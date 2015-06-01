From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4 crypto: handle ENOKEY correctly
Date: Mon, 01 Jun 2015 12:59:10 +0300
Message-ID: <87bngz92c1.fsf@openvz.org>
References: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org> <20150529204429.GH18540@thunk.org> <20150531150342.GB11642@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, G@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35816 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbFAKBq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jun 2015 06:01:46 -0400
Received: by labko7 with SMTP id ko7so93684530lab.2
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 03:01:44 -0700 (PDT)
In-Reply-To: <20150531150342.GB11642@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, May 29, 2015 at 04:44:29PM -0400, Theodore Ts'o wrote:
>> I don't think that's the right way to go.  We should add checks to
>> ext4_file_open, sure.  But the problem is that i_crypt_info can get
>> set to NULL after the file is succesfully opened.  So we need to
>> handle i_crypt_info being NULL everywhere.  So the BUG_ON() in
>> ext4_get_crypto_ctx() needs to be replaced with:
>>=20
>> 	if (ci =3D=3D NULL)
>> 		return ERR_PTR(-ENOKEY);
>
> This is what I had in mind....
ACK. with one note, you forget to convert all callers of
ext4_get_crypto_ctx() to new error convention. Please see patch below.

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index a9fd028..6f9d95e 100644
=2D-- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -467,8 +467,9 @@ int ext4_decrypt_one(struct inode *inode, struct page *=
page)
=20
 	struct ext4_crypto_ctx *ctx =3D ext4_get_crypto_ctx(inode);
=20
=2D	if (!ctx)
=2D		return -ENOMEM;
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
 	ret =3D ext4_decrypt(ctx, page);
 	ext4_release_crypto_ctx(ctx);
 	return ret;

>
> 				- Ted
>
> commit 3cde0c5d3125697c4b02c32054a378dc71ebfdb5
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun May 31 08:12:34 2015 -0400
>
>     ext4 crypto: handle unexpected lack of encryption keys
>=20=20=20=20=20
>     Fix up attempts by users to try to write to a file when they don't
>     have access to the encryption key.
>=20=20=20=20=20
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> index ac2419c..6634478 100644
> --- a/fs/ext4/crypto.c
> +++ b/fs/ext4/crypto.c
> @@ -104,7 +104,8 @@ struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct in=
ode *inode)
>  	unsigned long flags;
>  	struct ext4_crypt_info *ci =3D EXT4_I(inode)->i_crypt_info;
>=20=20
> -	BUG_ON(ci =3D=3D NULL);
> +	if (ci =3D=3D NULL)
> +		return ERR_PTR(-ENOKEY);
>=20=20
>  	/*
>  	 * We first try getting the ctx from a free list because in
> diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
> index a1d434d..02c4e5d 100644
> --- a/fs/ext4/crypto_policy.c
> +++ b/fs/ext4/crypto_policy.c
> @@ -183,7 +183,8 @@ int ext4_inherit_context(struct inode *parent, struct=
 inode *child)
>  	if (res < 0)
>  		return res;
>  	ci =3D EXT4_I(parent)->i_crypt_info;
> -	BUG_ON(ci =3D=3D NULL);
> +	if (ci =3D=3D NULL)
> +		return -ENOKEY;
>=20=20
>  	ctx.format =3D EXT4_ENCRYPTION_CONTEXT_FORMAT_V1;
>  	if (DUMMY_ENCRYPTION_ENABLED(EXT4_SB(parent->i_sb))) {
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 875ca6b..ac517f1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -226,6 +226,8 @@ static int ext4_file_mmap(struct file *file, struct v=
m_area_struct *vma)
>  		int err =3D ext4_get_encryption_info(inode);
>  		if (err)
>  			return 0;
> +		if (ext4_encryption_info(inode) =3D=3D NULL)
> +			return -ENOKEY;
>  	}
>  	file_accessed(file);
>  	if (IS_DAX(file_inode(file))) {
> @@ -278,6 +280,13 @@ static int ext4_file_open(struct inode * inode, stru=
ct file * filp)
>  			ext4_journal_stop(handle);
>  		}
>  	}
> +	if (ext4_encrypted_inode(inode)) {
> +		ret =3D ext4_get_encryption_info(inode);
> +		if (ret)
> +			return -EACCES;
> +		if (ext4_encryption_info(inode) =3D=3D NULL)
> +			return -ENOKEY;
> +	}
>  	/*
>  	 * Set up the jbd2_inode if we are opening the inode for
>  	 * writing and the journal is present
> @@ -287,13 +296,7 @@ static int ext4_file_open(struct inode * inode, stru=
ct file * filp)
>  		if (ret < 0)
>  			return ret;
>  	}
> -	ret =3D dquot_file_open(inode, filp);
> -	if (!ret && ext4_encrypted_inode(inode)) {
> -		ret =3D ext4_get_encryption_info(inode);
> -		if (ret)
> -			ret =3D -EACCES;
> -	}
> -	return ret;
> +	return dquot_file_open(inode, filp);
>  }
>=20=20
>  /*

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVbCzuAAoJELhyPTmIL6kB2uMIAKHnbOu3WhYTt8YQfskZRN6Z
n6yQAKnGdJpL3xMiyjb2+uWnHsIlmCVTkUev+6XKOXuMBFjWkdny4/Ad5Xx36zyR
SHAXqQNocaM/s4D6OJja+Tg8nT+uZQ6yfstV8WD610vMph06EhooBoueYHcYrI6l
zl0wMZBaHjU58ilq+BBkPGc+ryNmMOEIqTUeycpi2u5cD0H/87+k7pissHkDJPfB
CpMTzPUThYZJuA6PtdzMP2ukTZJKRQI1bhfMF9ECPpHdklQmMgAWhGae096sHbSw
N+Vi2a5s06tY/8zE5L3j8YovycMMFsJFVtnFOjr/ReBE4oQ5nzXObGHY27za7/s=
=BGHl
-----END PGP SIGNATURE-----
--=-=-=--
