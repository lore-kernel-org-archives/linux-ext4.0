From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: sort "-d" option alphabetically
Date: Tue, 24 Nov 2015 15:17:55 -0700
Message-ID: <B6F560EA-34EB-4270-A2C4-3390EB84C9B4@dilger.ca>
References: <1448403406-25049-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B74721A4-0D03-4D8B-98BC-C837BEE2F3C5"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34135 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbbKXWSB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2015 17:18:01 -0500
Received: by padhx2 with SMTP id hx2so35022308pad.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2015 14:18:00 -0800 (PST)
In-Reply-To: <1448403406-25049-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B74721A4-0D03-4D8B-98BC-C837BEE2F3C5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 24, 2015, at 3:16 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> Move the mke2fs "-d" option to be alphabetical like other options.
>=20
> Rename "root_dir" to "src_root_dir" to avoid confusion with the
> actual root inode in the new filesystem.

This patch is against master, since "-d" only lives there today, but I
noticed it while working on the extent/htree corruption test case.

Cheers, Andreas

> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> misc/mke2fs.c |   14 +++++++-------
> 1 files changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 179a4d1..9aaafbc 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -109,7 +109,7 @@ static char *mount_dir;
> char *journal_device;
> static int sync_kludge;	/* Set using the MKE2FS_SYNC env. option =
*/
> char **fs_types;
> -const char *root_dir;  /* Copy files from the specified directory */
> +const char *src_root_dir;  /* Copy files from the specified directory =
*/
> static char *undo_file;
>=20
> static profile_t	profile;
> @@ -1552,7 +1552,7 @@ profile_error:
> 	}
>=20
> 	while ((c =3D getopt (argc, argv,
> -		    =
"b:ce:g:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:Vz:")) !=3D EOF) =
{
> +		    =
"b:cd:e:g:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:Vz:")) !=3D EOF) =
{
> 		switch (c) {
> 		case 'b':
> 			blocksize =3D parse_num_blocks2(optarg, -1);
> @@ -1585,6 +1585,9 @@ profile_error:
> 				exit(1);
> 			}
> 			break;
> +		case 'd':
> +			src_root_dir =3D optarg;
> +			break;
> 		case 'D':
> 			direct_io =3D 1;
> 			break;
> @@ -1765,9 +1768,6 @@ profile_error:
> 		case 'U':
> 			fs_uuid =3D optarg;
> 			break;
> -		case 'd':
> -			root_dir =3D optarg;
> -			break;
> 		case 'v':
> 			verbose =3D 1;
> 			break;
> @@ -3143,11 +3143,11 @@ no_journal:
> 	if (retval)
> 		com_err(program_name, retval, "while creating huge =
files");
> 	/* Copy files from the specified directory */
> -	if (root_dir) {
> +	if (src_root_dir) {
> 		if (!quiet)
> 			printf("%s", _("Copying files into the device: =
"));
>=20
> -		retval =3D populate_fs(fs, EXT2_ROOT_INO, root_dir,
> +		retval =3D populate_fs(fs, EXT2_ROOT_INO, src_root_dir,
> 				     EXT2_ROOT_INO);
> 		if (retval) {
> 			com_err(program_name, retval, "%s",
> --
> 1.7.3.4
>=20


Cheers, Andreas






--Apple-Mail=_B74721A4-0D03-4D8B-98BC-C837BEE2F3C5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVlTiE3Kl2rkXzB/gAQiR9BAAlBwLP7b5XF0e3GDsSm47hJIQvr50s3nP
beTCOTzFTbiA7rpu4Gkanl5joDJF1oP9LlE6WhOqNz9eaMElkI7NX4phLusqh25h
yJq4Fa5x7x4q/uOUOV28ih+SY4PCl6Iy5wNwf9t10WeQa52DLgCqOLrjC6OF4xmp
65BDHt+yLOMdNweaC4d0OK+tfRo8AsIbvM888BY4pR9vXJvX++bXLjzxGy9cwEaW
M9hqbNGbcrVFdOHyId92B4caSLHQxEot9kzupjptYUrWcBkrOsz5NFiIBbRvOsVr
2Q/peJi4bm88x9ivriHwodU0ldfOpH716JxjZIWiIdPtcVeXZF3oCS/I/HQdOBkI
SAyVa714Olw+ymM1hru5faclsqCKSjQWTQsb9Qlm4tnvHpgjf5UbO/DKKwpYxSlA
p5j3+oS9jd3I77V6fpByikAnN+9Cn8GJo51UAfX7S0R2FZYzCjPq3q+eFKrgLttP
K1Ji/FTP87qx1x3rZgDxDy8ZwpVDLGtwEUdqpdS+A6j2uek2wq19Yv0n2zVzBa5q
5nNLcmkf3aP9n1HxBB8EEBPMjV9ZH1MW6/D0HsnavgjTJjN8qJ4qO9QYM+jN0AsH
k19plho6ct4OpCXnt1mpb9feJLbtY5pNCb9/NIaScwY6nsh7cDmzG7Z8Xt0L7LAF
FwAbuMS3WKA=
=Yp9+
-----END PGP SIGNATURE-----

--Apple-Mail=_B74721A4-0D03-4D8B-98BC-C837BEE2F3C5--
