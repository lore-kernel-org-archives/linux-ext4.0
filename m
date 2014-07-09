From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] tune2fs: update journal super block when changing UUID for fs.
Date: Wed, 9 Jul 2014 14:38:19 -0600
Message-ID: <F7FBA430-6337-40C9-BCD0-22503131FD3E@dilger.ca>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com> <1404852082-1550-4-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3A5EDB07-E304-43C3-826B-92FCCFD6DB57"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62071 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGIUiZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 16:38:25 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so9682327pdi.9
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 13:38:24 -0700 (PDT)
In-Reply-To: <1404852082-1550-4-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3A5EDB07-E304-43C3-826B-92FCCFD6DB57
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 8, 2014, at 2:41 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:

> Using -U option you can change the UUID for fs, however it will not =
work
> for journal device, since it have a copy of this UUID inside jsb (i.e.
> journal super block). So copy UUID on change into that block.
>=20
> Here is the initial thread:
> http://comments.gmane.org/gmane.comp.file-systems.ext4/44532
>=20
> You can reproduce this by executing following commands:
> $ fallocate -l100M /tmp/dev
> $ fallocate -l100M /tmp/journal
> $ sudo /sbin/losetup /dev/loop1 /tmp/dev
> $ sudo /sbin/losetup /dev/loop0 /tmp/journal
> $ mke2fs -O journal_dev /tmp/journal
> $ tune2fs -U da1f2ed0-60f6-aaaa-92fd-738701418523 /tmp/journal
> $ sudo mke2fs -t ext4 -J device=3D/dev/loop0 /dev/loop1
> $ dumpe2fs -h /tmp/dev | fgrep UUID
> dumpe2fs 1.43-WIP (18-May-2014)
> Filesystem UUID:          8a776be9-12eb-411f-8e88-b873575ecfb6
> Journal UUID:             e3d02151-e776-4865-af25-aecb7291e8e5
> $ sudo e2fsck /dev/vdc
> e2fsck 1.43-WIP (18-May-2014)
> External journal does not support this filesystem
>=20
> /dev/loop1: ********** WARNING: Filesystem still has errors **********
>=20
> Reported-by: Chin Tzung Cheng <chintzung@gmail.com>
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

It may be that the reverse problem also exists - if the UUID is changed
on the filesystem, it probably is not updated in the journal "users" =
list?
I'm not sure either way, but it is worthwhile to check.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> misc/tune2fs.c | 74 =
++++++++++++++++++++++++++++++++++++++++++++--------------
> 1 file changed, 56 insertions(+), 18 deletions(-)
>=20
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 811cb4d..898a1b3 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -180,6 +180,38 @@ static __u32 clear_ok_features[3] =3D {
> 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
> };
>=20
> +/**
> + * Try to get journal super block if any
> + */
> +static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
> +{
> +	int retval;
> +	int start;
> +	journal_superblock_t *jsb;
> +
> +	if (!(jfs->super->s_feature_incompat &
> +	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
> +		return EXT2_ET_UNSUPP_FEATURE;
> +	}
> +
> +	/* Get the journal superblock */
> +	if ((retval =3D io_channel_read_blk64(jfs->io,
> +	    ext2fs_journal_sb_start(jfs->blocksize), -SUPERBLOCK_SIZE, =
buf))) {
> +		com_err(program_name, retval, "%s",
> +		_("while reading journal superblock"));
> +		return retval;
> +	}
> +
> +	jsb =3D (journal_superblock_t *) buf;
> +	if ((jsb->s_header.h_magic !=3D =
(unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
> +	    (jsb->s_header.h_blocktype !=3D =
(unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
> +		fputs(_("Journal superblock not found!\n"), stderr);
> +		return EXT2_ET_BAD_MAGIC;
> +	}
> +
> +	return 0;
> +}
> +
> /*
>  * Remove an external journal from the filesystem
>  */
> @@ -223,29 +255,15 @@ static int remove_journal_device(ext2_filsys fs)
> 			_("while trying to open external journal"));
> 		goto no_valid_journal;
> 	}
> -	if (!(jfs->super->s_feature_incompat &
> -	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
> -		fprintf(stderr, _("%s is not a journal device.\n"),
> -			journal_path);
> -		goto no_valid_journal;
> -	}
>=20
> -	start =3D ext2fs_journal_sb_start(fs->blocksize);
> -	/* Get the journal superblock */
> -	if ((retval =3D io_channel_read_blk64(jfs->io, start,
> -	    -SUPERBLOCK_SIZE, buf))) {
> -		com_err(program_name, retval, "%s",
> -			_("while reading journal superblock"));
> +	if ((retval =3D get_journal_sb(jfs, buf))) {
> +		if (retval =3D=3D EXT2_ET_UNSUPP_FEATURE)
> +			fprintf(stderr, _("%s is not a journal =
device.\n"),
> +				journal_path);
> 		goto no_valid_journal;
> 	}
>=20
> 	jsb =3D (journal_superblock_t *) buf;
> -	if ((jsb->s_header.h_magic !=3D =
(unsigned)ntohl(JFS_MAGIC_NUMBER)) ||
> -	    (jsb->s_header.h_blocktype !=3D =
(unsigned)ntohl(JFS_SUPERBLOCK_V2))) {
> -		fputs(_("Journal superblock not found!\n"), stderr);
> -		goto no_valid_journal;
> -	}
> -
> 	/* Find the filesystem UUID */
> 	nr_users =3D ntohl(jsb->s_nr_users);
> 	for (i =3D 0; i < nr_users; i++) {
> @@ -2695,6 +2713,7 @@ retry_open:
> 	if (U_flag) {
> 		int set_csum =3D 0;
> 		dgrp_t i;
> +		char buf[SUPERBLOCK_SIZE];
>=20
> 		if (ext2fs_has_group_desc_csum(fs)) {
> 			/*
> @@ -2740,6 +2759,25 @@ retry_open:
> 				ext2fs_group_desc_csum_set(fs, i);
> 			fs->flags &=3D ~EXT2_FLAG_SUPER_ONLY;
> 		}
> +
> +		/* If this is a journal dev, we need to copy UUID into =
jsb */
> +		if (!(rc =3D get_journal_sb(fs, buf))) {
> +			journal_superblock_t *jsb;
> +
> +			jsb =3D (journal_superblock_t *) buf;
> +			fputs(_("Need to update journal superblock.\n"), =
stdout);
> +			memcpy(jsb->s_uuid, sb->s_uuid, =
sizeof(sb->s_uuid));
> +
> +			/* Writeback the journal superblock */
> +			if ((rc =3D io_channel_write_blk64(fs->io,
> +				ext2fs_journal_sb_start(fs->blocksize),
> +					-SUPERBLOCK_SIZE, buf)))
> +				goto closefs;
> +		} else if (rc !=3D EXT2_ET_UNSUPP_FEATURE)
> +			goto closefs;
> +		else
> +			rc =3D 0; /** Reset rc to avoid =
ext2fs_mmp_stop() */
> +
> 		ext2fs_mark_super_dirty(fs);
> 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> --=20
> 2.0.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_3A5EDB07-E304-43C3-826B-92FCCFD6DB57
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU72oO3Kl2rkXzB/gAQLgWxAAkUvSiIR9kOwx5vy9xTm3CtjsJlI3YLl8
TvE9xsB6MezE1gfgepfCIfwtPvSgWm0CvLQWXrFhdpO4qOhAKFzmt97jcGcCiqkI
pQb9RHrtlpZ3neuIORgm49XiMSvTqcb8+TDVGWlhCMe8eVZUJ9wfZ3bOsNcgdJMs
9jjJKIMHx8msrxqdNGvssdFDZHm4LKZzevZPR8I0ZHw8VRJC4xcWtBiaQaPY2BUI
6SeSHHMGzvAXyuLfauX5Q/u6Njl59STLgwbZHVN4C51cq+AWtht2EDbiU0NdDKgT
oChBKqVh+cswY8cgUqB19VL0XPlTiv8LJkRgs+fAKWofzmfwbU7hBYbb5NZtVZeO
mJCwAuW0BqdV1WmDI7dtoaXV6xEbbbUqTHzwBhatNqJmUbVekJdhEQCb7qAhsn+/
FpkTbElkZV5GRiOvn93Lu7XuaQpOJw1/D5Y1MkJxX4og+EfzHBmzY1OxHIKNsnOa
qVZ4F72HZZ3KsjHMgGBPvZIIkDtb0kNAzv2Ulff22y3GjiWjGzf7fpq7u13GFqBx
kO5PFMmcLfCe3v++OfBKsM9pK9y88+dkTBifCxcmxr6G9ElWtwkx/qHyUEQr9NUG
7D8zU8t7Pc/zGPmrn3t/uOUnKRwJXHqQjDWdflfpNt4hxwaCifpF2lF+ERJYQhNS
j4U6WnW7aQM=
=UdOK
-----END PGP SIGNATURE-----

--Apple-Mail=_3A5EDB07-E304-43C3-826B-92FCCFD6DB57--
