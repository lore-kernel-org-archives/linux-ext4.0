From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V3] resize2fs: clear uninit BG if allocating from new group
Date: Thu, 14 Jan 2016 12:39:25 -0700
Message-ID: <32E46FD0-E27F-4FD3-AFF6-F594DE1BD5BC@dilger.ca>
References: <55FB41CA.8010003@redhat.com> <5697ECEB.3020408@redhat.com> <5697F69E.4090404@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CFEDF39A-1521-4502-8696-15B3B006E894"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33182 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbcANTjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2016 14:39:31 -0500
Received: by mail-pa0-f65.google.com with SMTP id pv5so29657257pac.0
        for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 11:39:31 -0800 (PST)
In-Reply-To: <5697F69E.4090404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CFEDF39A-1521-4502-8696-15B3B006E894
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 14, 2016, at 12:27 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>=20
> If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
> group, nothing clears the UNINIT flag, so it is skipped when we
> go to write out modified bitmaps.  This leads to post-resize2fs
> e2fsck errors; used blocks in UNINIT groups, not marked in the
> block bitmap.  This was seen on r_ext4_small_bg.
>=20
> This patch uses clear_block_uninit() to clear the flag,
> and my problem goes away.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> V2: don't cut and paste, sorry!
> V3: ext2fs_* namespace for the exported function, thanks Darrick
>=20
> Thanks,
> -Eric
>=20
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 86e7f99..ce59e85 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -39,7 +39,7 @@
> /*
>  * Clear the uninit block bitmap flag if necessary
>  */
> -static void clear_block_uninit(ext2_filsys fs, dgrp_t group)
> +void ext2fs_clear_block_uninit(ext2_filsys fs, dgrp_t group)
> {
> 	if (!ext2fs_has_group_desc_csum(fs) ||
> 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
> @@ -183,7 +183,7 @@ allocated:
> 	if (retval)
> 		return retval;
>=20
> -	clear_block_uninit(fs, ext2fs_group_of_blk2(fs, b));
> +	ext2fs_clear_block_uninit(fs, ext2fs_group_of_blk2(fs, b));
> 	*ret =3D b;
> 	return 0;
> }
> @@ -455,7 +455,7 @@ errcode_t ext2fs_new_range(ext2_filsys fs, int =
flags, blk64_t goal,
> allocated:
> 			for (b =3D start; b < end;
> 			     b +=3D fs->super->s_blocks_per_group)
> -				clear_block_uninit(fs,
> +				ext2fs_clear_block_uninit(fs,
> 						ext2fs_group_of_blk2(fs, =
b));
> 			return 0;
> 		}
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 86d860f..d5e9684 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -647,6 +647,7 @@ static inline int =
ext2fs_needs_large_file_feature(unsigned long long file_size)
> }
>=20
> /* alloc.c */
> +extern void ext2fs_clear_block_uninit(ext2_filsys fs, dgrp_t group);
> extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int =
mode,
> 				  ext2fs_inode_bitmap map, ext2_ino_t =
*ret);
> extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 07c6a0c..42435b2 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -1620,6 +1620,7 @@ static errcode_t =
resize2fs_get_alloc_block(ext2_filsys fs,
> {
> 	ext2_resize_t rfs =3D (ext2_resize_t) fs->priv_data;
> 	blk64_t blk;
> +	int group;
>=20
> 	blk =3D get_new_block(rfs);
> 	if (!blk)
> @@ -1632,6 +1633,12 @@ static errcode_t =
resize2fs_get_alloc_block(ext2_filsys fs,
>=20
> 	ext2fs_mark_block_bitmap2(rfs->old_fs->block_map, blk);
> 	ext2fs_mark_block_bitmap2(rfs->new_fs->block_map, blk);
> +
> +	group =3D ext2fs_group_of_blk2(rfs->old_fs, blk);
> +	ext2fs_clear_block_uninit(rfs->old_fs, group);
> +	group =3D ext2fs_group_of_blk2(rfs->new_fs, blk);
> +	ext2fs_clear_block_uninit(rfs->new_fs, group);
> +
> 	*ret =3D (blk64_t) blk;
> 	return 0;
> }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_CFEDF39A-1521-4502-8696-15B3B006E894
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVpf5bnKl2rkXzB/gAQhGbhAAgYKwbOmE2dUjBBeNY7p0y4U/wTXSi1eq
Z/dHcZ+QwY2WbmKxrEUsZmoAwSWFEMaLmfvOJfPI1P96Y+Eps7AI+u/bFN1nI62u
O4U2gZKD6vkVUschCSnIbBjpRcmKROm/Xa9lMsROJnW7DkhQ/AwVE8zRu7mipffm
rW5/+ZsF0VcDa7ogYLug8yvFDnhSq4+kdjiZioRI8p9DLbbZRf5AAUzNvCxpTquO
HwYrOYWYHKi/0wuACt2YFUjN7mgmowBh0r4aRtSadLFzpRla9Njc3dFnVRlBo4Mr
LfC8KiQm7FBcF/aQIxcYP2Ced/Ly/BPzRzze8kRgL3HEsUMvJZGQUFFhX3Um5IYS
SrMNh2fbnPhU5haWsxaPJg7+a8y7lf26OFcRFC2kLvKBvcXrnrwX5zL5//QSspDi
f5R2oCte+e0pObdrtfjl65D2fyt4+CWU7Ycqs01+PNMxOradML/rSVpGtKgMqs74
EH3J3nCX8PnAj/OYkBhLxg/ltbBoghmwbAZfQd5FkkoNvBsUfaVy+VFw5VUqsKm7
Q43vEkTP2JduFaPTDyypiuCSRoA4dV80wGHm49aHZitLbZIaHzVdTaaDIVtiGY7Z
qeeO/wBXTJN9wsjlIXgBAD0Ag4L2VR4gC8LibSaxrkhilk9V98D3JgohQzyP0alp
MN2myo7TZcA=
=0bwC
-----END PGP SIGNATURE-----

--Apple-Mail=_CFEDF39A-1521-4502-8696-15B3B006E894--
