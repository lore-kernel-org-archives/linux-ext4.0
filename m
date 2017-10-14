From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] Fix typos in code comments and developer docs.
Date: Sat, 14 Oct 2017 16:29:59 -0600
Message-ID: <0C256E20-53C8-4B20-A1EC-43B53BD38BBF@dilger.ca>
References: <20171014184456.17602-1-sebras@gmail.com>
 <20171014184456.17602-3-sebras@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_ACEB08B7-56D5-438C-A387-2D4466B2752E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Sebastian Rasmussen <sebras@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:48454 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdJNWaE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Oct 2017 18:30:04 -0400
Received: by mail-it0-f45.google.com with SMTP id c3so15159577itc.3
        for <linux-ext4@vger.kernel.org>; Sat, 14 Oct 2017 15:30:04 -0700 (PDT)
In-Reply-To: <20171014184456.17602-3-sebras@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_ACEB08B7-56D5-438C-A387-2D4466B2752E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 14, 2017, at 12:44 PM, Sebastian Rasmussen <sebras@gmail.com> =
wrote:
>=20
> Signed-off-by: Sebastian Rasmussen <sebras@gmail.com>

Did you use a tool to extract comments and then run this through a spell
checker, or actually read all of the comments manually?  Some of the
errors are very hard to notice, even when already knowing the line has
a correction.

Some minor comments below.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> diff --git a/lib/ext2fs/nt_io.c b/lib/ext2fs/nt_io.c
> index f0d16ae0..234f6b17 100644
> --- a/lib/ext2fs/nt_io.c
> +++ b/lib/ext2fs/nt_io.c
> @@ -673,7 +673,7 @@ _NormalizeDeviceName(
> 	else if('f' =3D=3D *Device)
> 	{
> 		//
> -		// 3-d letted should be a digit.
> +		// 3-d letter should be a digit.

This should probably be "3rd letter"?

> diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
> index eaa9cf87..45a475d9 100644
> --- a/lib/ext2fs/res_gdt.c
> +++ b/lib/ext2fs/res_gdt.c
> @@ -104,7 +104,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys =
fs)
> 	if (fs->blocksize =3D=3D 1024 && sb_blk =3D=3D 0)
> 		sb_blk =3D 1;
>=20
> -	/* Maximum possible file size (we donly use the dindirect =
blocks) */
> +	/* Maximum possible file size (we only use the indirect blocks) =
*/

The "donly" typo should be fixed, but "dindirect" is not a typo.  This =
means
"double indirect blocks".  Maybe "(we only use double indirect blocks)" =
so
that it still fits on a single line?

> #ifdef RES_GDT_DEBUG
> diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
> index b36c4858..9c1dd31d 100644
> --- a/lib/ext2fs/tdb.c
> +++ b/lib/ext2fs/tdb.c

Since the "tdb" code was copied from another project, you might
consider to also submit these corrections to the original project.

> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 20a0c463..b53141a2 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -932,7 +932,7 @@ retry:
> 	/*
> 	 * If we changed the number of block_group descriptor blocks,
> 	 * we need to make sure they are all marked as reserved in the
> -	 * file systems's block allocation map.
> +	 * file systems' block allocation map.

This should probably be "filesystem's" since there is only one =
filesystem
in question, and its block allocation map.

> diff --git a/util/gen-tarball.in b/util/gen-tarball.in
> index a3a02cef..6f087d1a 100644
> --- a/util/gen-tarball.in
> +++ b/util/gen-tarball.in
> @@ -12,7 +12,7 @@ GZIP=3Dgzip
>=20
> #
> # This hack is needed because texi2dvi blows up horribly if there are
> -# any '~' chracters in the directory pathname.  So we kludge around =
it by
> +# any '~' characters in the directory path name.  So we kludge around =
it by

IMHO, "pathname" is OK.

Cheers, Andreas






--Apple-Mail=_ACEB08B7-56D5-438C-A387-2D4466B2752E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ4o/npIg59Q01vtYRAr2PAKCGpa2AHtNMfsLynTnarpbArUZdmgCgypKS
ke82JxBU0kZZzKx8Qp3yKuw=
=Zwuc
-----END PGP SIGNATURE-----

--Apple-Mail=_ACEB08B7-56D5-438C-A387-2D4466B2752E--
