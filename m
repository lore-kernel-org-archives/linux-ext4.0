From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: add large_file to base mkfs features
Date: Tue, 30 Sep 2014 22:36:56 -0600
Message-ID: <4B5735B7-0BBA-4785-A7B9-EEE5596A1171@dilger.ca>
References: <542B744B.3070602@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_80D68D2E-930C-4C8D-9911-7079956A0813"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48872 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaJAEg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2014 00:36:59 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb1so61818pad.11
        for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 21:36:59 -0700 (PDT)
In-Reply-To: <542B744B.3070602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_80D68D2E-930C-4C8D-9911-7079956A0813
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Sep 30, 2014, at 9:26 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> large_file (> 2G) support has been around since at least kernel 2.4;
> mkfs of any sufficiently large filesystem sets it "accidentally"
> when the resize inode exceeds 2G.  This leaves very small
> filesystems lacking the feature, which potentially changes
> their behavior & codepaths the first time a > 2G file gets
> written.
>=20
> There's really no reason to be making fresh filesystems which
> strive to keep compatibility with 10 year old kernels; just
> enable large_file at mkfs time.  This is particularly obvious
> for ext4 fielsystems, which set huge_file by default, but not
> necessarily large_file.
>=20
> If old-kernel compatibility is desired, mke2fs.conf can be
> modified locally to remove the feature.
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Doing a bit of spelunking now that I have a chance, I see:

    commit 77175ca20cbfd8d8f3473a060bdbcb7f18505d1f
    Author: Theodore Ts'o <tytso@mit.edu>
    Date:   Wed Feb 27 00:00:30 2008 -0500

    e2fsck: Don't clear the LARGE_FILES feature flag
   =20
    Stop clearing the EXT2_FEATURE_RO_COMPAT_LARGE_FILE flag =
automatically
    if there are no large files in the filesystem.  It's been almost a
    decade since there have been kernels that don't support this flag, =
and
    e2fsck clears it quietly without telling the user why the filesystem
    has been changed.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

So that means kernels have been supporting large_file since about 1998,
about 16 years already...  The first e2fsprogs git mention is also 1998,
and I found the original kernel patch:

    http://lkml.org/lkml/1998/3/12/99
   =20
    Date	Thu, 12 Mar 1998 23:12:53 -0500
    Subject	Ext2 patches for Linux 2.1
    From	tytso@mit.edu

    Hi Linus,=20

    Could you please install this patch set into the 2.1 tree?  It
    includes previous patches submitted by Stephen and Jakub (with some
    fixes) and my own patches and improvements.  None of these are =
really
    major changes; most of them are changes to provide better a forward
    migration path past Linux 2.2 for future ext2fs features.
    :
    :
    * Added Jakub Jelinek's support for large files on 64-bit
	platforms.  On a 64-bit platform, the first time you
	expand a file past the 32-bit boundary, the=20
	EXT2_FEATURE_RO_COMPAT_LARGE_FILE is turned on.
	2.0 machines will be able to mount such filesystems
	read-only.  2.2 kernels on 32-bit platforms will be
	able such filesystems read-write, but they will only
	be able to see the first 2**32 bytes of the file, and
	any attempt to open a large file for read/write access
	will cause an EBIGF error.

This was also bundled with the INCOMPAT_FILETYPE feature, so I see
virtually no risk to enable this feature via e2fsck for any ext3 or
ext4 filesystems (INCOMPAT_FILETYPE was added before INCOMPAT_RECOVER
for ext3).

Cheers, Andreas

> ---
>=20
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 2bc435b..2a16c59 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1927,7 +1927,7 @@ profile_error:
> 	tmp =3D NULL;
> 	if (fs_param.s_rev_level !=3D EXT2_GOOD_OLD_REV) {
> 		tmp =3D get_string_from_profile(fs_types, =
"base_features",
> -		      "sparse_super,filetype,resize_inode,dir_index");
> +		      =
"sparse_super,large_file,filetype,resize_inode,dir_index");
> 		edit_feature(tmp, &fs_param.s_feature_compat);
> 		free(tmp);
>=20
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 4c5dba7..106ee80 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -1,5 +1,5 @@
> [defaults]
> -	base_features =3D =
sparse_super,filetype,resize_inode,dir_index,ext_attr
> +	base_features =3D =
sparse_super,large_file,filetype,resize_inode,dir_index,ext_attr
> 	default_mntopts =3D acl,user_xattr
> 	enable_periodic_fsck =3D 0
> 	blocksize =3D 4096
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_80D68D2E-930C-4C8D-9911-7079956A0813
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCuE6HKl2rkXzB/gAQKqhRAAoLJDJxCY8dU3tj3V2cc6rhN+nE0AlgPW
MLQrwKuCe1ttERhWH9vQqzzEc7EXfV5dV8S7fVKUNyKcbrZ2lZRET1ILKAJlq2zm
b6x/k8ifXGnGuJmI7V6tpFQz1yPeW5yfJgH2INVFcEaZf+v9gFcT955r+pRhqf7r
/CGazT4buy577cxfyRUrx+q7PrcHUA86PUxAQbdxuwGxkwbXdfCIgWqPi1FR7/Vq
5t1+gt4QlD8pV1MUwhkWuxIo0qqbYV3GJYU1TbjanCzgY9ztOyw3rFx+uk7JU7DQ
puKHX/QwbLQ3Yqcu9s0biUA//xvfEEgPjYPY5iImCTr5ADSqvxanxU/NU0J3+KiW
JSN4h1wyEK6eYtEjb6k4f0t6pcOLM+CtcMIf79VM2PeXEi1FN1fnnBDlL6UAmjwG
8UVuN8z0MldbzTlz/r74K1/RdfC2YXh/IwlrczkdlAwywJlbCUTaEbxskcJQf0a0
OU7rDo0inyAwPflVzhjMYS/AWJQ3ldPvSkFES9B5Brw+bXSQTeVVFbXZaN6Ehgpv
Qb1ooCzhz4vOLCy9HnUFZfCeNi+FsYfryLV7g9ru1X5Z85GS99Yh7sECNocRwofo
u+dWGsxFfPaKA+d7x4WMwQ2vv8ueHWZ0hKlLcLXvua0D316r6kNkui89WYyoMRif
urirxDMWodA=
=EMcN
-----END PGP SIGNATURE-----

--Apple-Mail=_80D68D2E-930C-4C8D-9911-7079956A0813--
