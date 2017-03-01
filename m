From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: readahead for meta_bg
Date: Tue, 28 Feb 2017 17:10:55 -0700
Message-ID: <42AA3FB8-88C4-4616-A20F-D09F0833D288@dilger.ca>
References: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E7C5A052-0FD8-46CE-AB87-2A58E78BA1AF";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33279 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdCABQy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 20:16:54 -0500
Received: by mail-it0-f67.google.com with SMTP id 68so3439478itg.0
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 17:16:16 -0800 (PST)
In-Reply-To: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E7C5A052-0FD8-46CE-AB87-2A58E78BA1AF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 20, 2017, at 3:03 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>=20
> There are ~37k of random IOs with meta_bg option on 300T target.
> Debugfs requires 20 minutes to be started. Enabling readahead for
> group blocks metadata save time dramatically. Only 12s to start.
>=20
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>

This patch looks good by itself.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
----

On a related note, I've been wondering if it would make sense to have
a second patch that *only* does the readahead of the group descriptor =
blocks
in ext2fs_open2(), and move io_channel_read_blk64() to =
ext2fs_group_desc()
when the group descriptor blocks are actually accessed the first time?  =
This
would allow tools like tune2fs, debugfs, dumpe2fs, etc. that may not =
access
group descriptors to load _much_ faster than if it loads all of the =
bitmaps
synchronously at filesystem open time.  Even if they _do_ access the GDT =
it
will at least allow the prefetch more time to run in the background, and =
the
GDT swabbing happen incrementally upon access rather than all at the =
start.

A quick look through lib/ext2fs looks like ext2fs_group_desc() is used =
for
the majority of group descriptor accesses, but there are a few places =
that
access fs->group_desc directly.  The ext2fs_group_desc() code could =
check
whether the group descriptor is all-zero (ext2fs_open2() should be =
changed
to use ext2fs_get_array_zero(..., &fs->group_desc)) and if so read the =
whole
descriptor block into the array and optionally swab it.

Cheers, Andreas

> ---
> lib/ext2fs/openfs.c |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index ba501e6..f158b0a 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -399,6 +399,12 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> #endif
> 		dest +=3D fs->blocksize*first_meta_bg;
> 	}
> +
> +	for (i =3D first_meta_bg ; i < fs->desc_blocks; i++) {
> +		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
> +		io_channel_cache_readahead(fs->io, blk, 1);
> +	}
> +
> 	for (i=3Dfirst_meta_bg ; i < fs->desc_blocks; i++) {
> 		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
> 		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_E7C5A052-0FD8-46CE-AB87-2A58E78BA1AF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYthGRpIg59Q01vtYRAm/gAJ4qum6uQtzh7gkXHXjRdk/V1+igagCfXguZ
AE34zVWzBkkCVKZOgJgK2I4=
=smYt
-----END PGP SIGNATURE-----

--Apple-Mail=_E7C5A052-0FD8-46CE-AB87-2A58E78BA1AF--
