From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 02/49] create_inode: minor cleanups
Date: Tue, 11 Mar 2014 14:31:27 -0600
Message-ID: <18BBBB53-C4B5-4724-BB26-199FE065278C@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065410.30585.93415.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_1F4C366B-96E0-49C0-8378-869694A43905"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42290 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaCKUby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 16:31:54 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl14so60446pab.18
        for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 13:31:53 -0700 (PDT)
In-Reply-To: <20140311065410.30585.93415.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1F4C366B-96E0-49C0-8378-869694A43905
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 11, 2014, at 12:54 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:

> Fix a couple of small style issues in the create_inode files.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>


> ---
> misc/create_inode.c |   42 ++++++++++++++++++++++++++++--------------
> misc/create_inode.h |    5 +++++
> 2 files changed, 33 insertions(+), 14 deletions(-)
>=20
>=20
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 647480c..b204e71 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -1,3 +1,6 @@
> +#include <time.h>
> +#include <unistd.h>
> +
> #include "create_inode.h"
>=20
> #if __STDC_VERSION__ < 199901L
> @@ -179,7 +182,8 @@ errcode_t do_symlink_internal(ext2_ino_t cwd, =
const char *name, char *target)
> 	cp =3D strrchr(name, '/');
> 	if (cp) {
> 		*cp =3D 0;
> -		if ((retval =3D  ext2fs_namei(current_fs, root, cwd, =
name, &parent_ino))){
> +		retval =3D ext2fs_namei(current_fs, root, cwd, name, =
&parent_ino);
> +		if (retval) {
> 			com_err(name, retval, 0);
> 			return retval;
> 		}
> @@ -216,7 +220,8 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const =
char *name, struct stat *st)
> 	cp =3D strrchr(name, '/');
> 	if (cp) {
> 		*cp =3D 0;
> -		if ((retval =3D  ext2fs_namei(current_fs, root, cwd, =
name, &parent_ino))){
> +		retval =3D ext2fs_namei(current_fs, root, cwd, name, =
&parent_ino);
> +		if (retval) {
> 			com_err(name, retval, 0);
> 			return retval;
> 		}
> @@ -409,7 +414,8 @@ errcode_t do_write_internal(ext2_ino_t cwd, const =
char *src, const char *dest)
> 		inode.i_flags |=3D EXT4_EXTENTS_FL;
> 	}
>=20
> -	if ((retval =3D ext2fs_write_new_inode(current_fs, newfile, =
&inode))) {
> +	retval =3D ext2fs_write_new_inode(current_fs, newfile, &inode);
> +	if (retval) {
> 		com_err(__func__, retval, "while creating inode %u", =
newfile);
> 		close(fd);
> 		return retval;
> @@ -464,12 +470,12 @@ errcode_t populate_fs(ext2_ino_t parent_ino, =
const char *source_dir)
>=20
> 	if (!(dh =3D opendir("."))) {
> 		com_err(__func__, errno,
> -			_("while openning directory \"%s\""), =
source_dir);
> +			_("while opening directory \"%s\""), =
source_dir);
> 		return errno;
> 	}
>=20
> -	while((dent =3D readdir(dh))) {
> -		if((!strcmp(dent->d_name, ".")) || =
(!strcmp(dent->d_name, "..")))
> +	while ((dent =3D readdir(dh))) {
> +		if ((!strcmp(dent->d_name, ".")) || =
(!strcmp(dent->d_name, "..")))
> 			continue;
> 		lstat(dent->d_name, &st);
> 		name =3D dent->d_name;
> @@ -494,7 +500,8 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const =
char *source_dir)
> 			case S_IFCHR:
> 			case S_IFBLK:
> 			case S_IFIFO:
> -				if ((retval =3D =
do_mknod_internal(parent_ino, name, &st))) {
> +				retval =3D do_mknod_internal(parent_ino, =
name, &st);
> +				if (retval) {
> 					com_err(__func__, retval,
> 						_("while creating =
special file \"%s\""), name);
> 					return retval;
> @@ -506,32 +513,37 @@ errcode_t populate_fs(ext2_ino_t parent_ino, =
const char *source_dir)
> 					_("ignoring socket file =
\"%s\""), name);
> 				continue;
> 			case S_IFLNK:
> -				if((read_cnt =3D readlink(name, =
ln_target, sizeof(ln_target))) =3D=3D -1) {
> +				read_cnt =3D readlink(name, ln_target, =
sizeof(ln_target));
> +				if (read_cnt =3D=3D -1) {
> 					com_err(__func__, errno,
> 						_("while trying to =
readlink \"%s\""), name);
> 					return errno;
> 				}
> 				ln_target[read_cnt] =3D '\0';
> -				if ((retval =3D =
do_symlink_internal(parent_ino, name, ln_target))) {
> +				retval =3D =
do_symlink_internal(parent_ino, name, ln_target);
> +				if (retval) {
> 					com_err(__func__, retval,
> 						_("while writing =
symlink\"%s\""), name);
> 					return retval;
> 				}
> 				break;
> 			case S_IFREG:
> -				if ((retval =3D =
do_write_internal(parent_ino, name, name))) {
> +				retval =3D do_write_internal(parent_ino, =
name, name);
> +				if (retval) {
> 					com_err(__func__, retval,
> 						_("while writing file =
\"%s\""), name);
> 					return retval;
> 				}
> 				break;
> 			case S_IFDIR:
> -				if ((retval =3D =
do_mkdir_internal(parent_ino, name, &st))) {
> +				retval =3D do_mkdir_internal(parent_ino, =
name, &st);
> +				if (retval) {
> 					com_err(__func__, retval,
> 						_("while making dir =
\"%s\""), name);
> 					return retval;
> 				}
> -				if ((retval =3D ext2fs_namei(current_fs, =
root, parent_ino, name, &ino))) {
> +				retval =3D ext2fs_namei(current_fs, =
root, parent_ino, name, &ino);
> +				if (retval) {
> 					com_err(name, retval, 0);
> 						return retval;
> 				}
> @@ -548,12 +560,14 @@ errcode_t populate_fs(ext2_ino_t parent_ino, =
const char *source_dir)
> 					_("ignoring entry \"%s\""), =
name);
> 		}
>=20
> -		if ((retval =3D  ext2fs_namei(current_fs, root, =
parent_ino, name, &ino))){
> +		retval =3D  ext2fs_namei(current_fs, root, parent_ino, =
name, &ino);
> +		if (retval) {
> 			com_err(name, retval, 0);
> 			return retval;
> 		}
>=20
> -		if ((retval =3D set_inode_extra(parent_ino, ino, &st))) =
{
> +		retval =3D set_inode_extra(parent_ino, ino, &st);
> +		if (retval) {
> 			com_err(__func__, retval,
> 				_("while setting inode for \"%s\""), =
name);
> 			return retval;
> diff --git a/misc/create_inode.h b/misc/create_inode.h
> index 2b6d429..79742e8 100644
> --- a/misc/create_inode.h
> +++ b/misc/create_inode.h
> @@ -1,3 +1,6 @@
> +#ifndef _CREATE_INODE_H
> +#define _CREATE_INODE_H
> +
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> @@ -33,3 +36,5 @@ extern errcode_t do_mknod_internal(ext2_ino_t cwd, =
const char *name, struct stat
> extern errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, =
char *target);
> extern errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, =
struct stat *st);
> extern errcode_t do_write_internal(ext2_ino_t cwd, const char *src, =
const char *dest);
> +
> +#endif /* _CREATE_INODE_H */
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_1F4C366B-96E0-49C0-8378-869694A43905
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUx9yoHKl2rkXzB/gAQImSQ/+O4aNPWI2NM9wuibd1loJt7v1zMW9T/sp
9JpN/jLVCESB78f1SPy/2PWmPojTZfHzbCNNTMUx8Dgsrki1UgM6sfNRdDqOAnXc
yIs+XMZKcnGYjUCjEAnmlT73gTnEdCYu808ITfX88nhMP4HDvMd4wK3wMPHI7aIq
xS7bUxAtbOqyfCy6T8aC2xILU4173eVqGldfPyCyR3OG+M1NKk/2buIVjgpejKmm
KWj7NdtlRycwUuX8RKSelqu/F8qTa8QeUO0BQt8E3+GvJwTdWNDhYeJ3sLNDDU/C
VQAFiyrhQAzziI7BKtNCcdHkROAJ2wXKF3qlxQxOyveuKw7jgw7tcOowxbjrOuSI
TUKLVGA/bwrzcal0TOt/GblM7qidZdLTxDqf/XdS3vFYu8TWhK3bThDRBY33EDII
cCShE1/9/pXyJJDlC4eyM5KuKt3N+hBVky7gCuYKlIRdQ91HY1gU19K7dujZ0gDA
ZQqDDGmPuO5gS9nofo0GouFa5YaU1ZQrFe1hjf4ayzmUjijL5XDn08+AJpp6i4qr
exhF+npdlHKyZXfq68QLlM7WDejMTQJZGcS8fbrp+MySMsqKMZSrecv+EexCK3g7
xHYGhlJwczAzPH/+7/Rf25s6bxL95BV/g1+dB1xub0caJFWXEZCXJvJH9ppvyC4d
nf7/OyEZvKw=
=XneW
-----END PGP SIGNATURE-----

--Apple-Mail=_1F4C366B-96E0-49C0-8378-869694A43905--
