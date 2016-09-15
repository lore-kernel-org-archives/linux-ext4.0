From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] fscrypto: make filename crypto functions return 0 on success
Date: Thu, 15 Sep 2016 14:21:47 -0600
Message-ID: <4CEDAC87-D605-44CF-AAA1-240233AA31A6@dilger.ca>
References: <1473960529-29158-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_65AA74EE-7B7B-4300-8ABB-20506729FE9C"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473960529-29158-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_65AA74EE-7B7B-4300-8ABB-20506729FE9C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Sep 15, 2016, at 11:28 AM, Eric Biggers <ebiggers@google.com> =
wrote:
>=20
> Several filename crypto functions: fname_decrypt(),
> fscrypt_fname_disk_to_usr(), and fscrypt_fname_usr_to_disk(), returned
> the output length on success or -errno on failure.  However, the =
output
> length was redundant with the value written to 'oname->len'.  It is =
also
> potentially error-prone to make callers have to check for '< 0' =
instead
> of '!=3D 0'.
>=20
> Therefore, make these functions return 0 instead of a length, and make
> the callers who cared about the return value being a length use
> 'oname->len' instead.  For consistency also make other callers check =
for
> a nonzero result rather than a negative result.
>=20
> This change also fixes the inconsistency of fname_encrypt() actually
> already returning 0 on success, not a length like the other filename
> crypto functions and as documented in its function comment.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/crypto/fname.c | 56 =
+++++++++++++++++++++++++++++++------------------------
> fs/ext4/dir.c     |  5 +++--
> fs/ext4/namei.c   |  8 ++++----
> fs/ext4/symlink.c |  5 ++---
> fs/f2fs/dir.c     |  6 +++---
> fs/f2fs/namei.c   |  6 +++---
> 6 files changed, 47 insertions(+), 39 deletions(-)
>=20
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 6bbc3b1..90697c7 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -35,11 +35,11 @@ static void fname_crypt_complete(struct =
crypto_async_request *req, int res)
> }
>=20
> /**
> - * fname_encrypt() -
> + * fname_encrypt() - encrypt a filename
>  *
> - * This function encrypts the input filename, and returns the length =
of the
> - * ciphertext. Errors are returned as negative numbers.  We trust the =
caller to
> - * allocate sufficient memory to oname string.
> + * The caller must have allocated sufficient memory for the @oname =
string.
> + *
> + * Return: 0 on success, -errno on failure
>  */
> static int fname_encrypt(struct inode *inode,
> 			const struct qstr *iname, struct fscrypt_str =
*oname)
> @@ -105,20 +105,22 @@ static int fname_encrypt(struct inode *inode,
> 	}
> 	kfree(alloc_buf);
> 	skcipher_request_free(req);
> -	if (res < 0)
> +	if (res < 0) {
> 		printk_ratelimited(KERN_ERR
> 				"%s: Error (error code %d)\n", __func__, =
res);
> +		return res;
> +	}
>=20
> 	oname->len =3D ciphertext_len;
> -	return res;
> +	return 0;
> }
>=20
> -/*
> - * fname_decrypt()
> - *	This function decrypts the input filename, and returns
> - *	the length of the plaintext.
> - *	Errors are returned as negative numbers.
> - *	We trust the caller to allocate sufficient memory to oname =
string.
> +/**
> + * fname_decrypt() - decrypt a filename
> + *
> + * The caller must have allocated sufficient memory for the @oname =
string.
> + *
> + * Return: 0 on success, -errno on failure
>  */
> static int fname_decrypt(struct inode *inode,
> 				const struct fscrypt_str *iname,
> @@ -168,7 +170,7 @@ static int fname_decrypt(struct inode *inode,
> 	}
>=20
> 	oname->len =3D strnlen(oname->name, iname->len);
> -	return oname->len;
> +	return 0;
> }
>=20
> static const char *lookup_table =3D
> @@ -279,6 +281,10 @@ EXPORT_SYMBOL(fscrypt_fname_free_buffer);
> /**
>  * fscrypt_fname_disk_to_usr() - converts a filename from disk space =
to user
>  * space
> + *
> + * The caller must have allocated sufficient memory for the @oname =
string.
> + *
> + * Return: 0 on success, -errno on failure
>  */
> int fscrypt_fname_disk_to_usr(struct inode *inode,
> 			u32 hash, u32 minor_hash,
> @@ -287,13 +293,12 @@ int fscrypt_fname_disk_to_usr(struct inode =
*inode,
> {
> 	const struct qstr qname =3D FSTR_TO_QSTR(iname);
> 	char buf[24];
> -	int ret;
>=20
> 	if (fscrypt_is_dot_dotdot(&qname)) {
> 		oname->name[0] =3D '.';
> 		oname->name[iname->len - 1] =3D '.';
> 		oname->len =3D iname->len;
> -		return oname->len;
> +		return 0;
> 	}
>=20
> 	if (iname->len < FS_CRYPTO_BLOCK_SIZE)
> @@ -303,9 +308,9 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
> 		return fname_decrypt(inode, iname, oname);
>=20
> 	if (iname->len <=3D FS_FNAME_CRYPTO_DIGEST_SIZE) {
> -		ret =3D digest_encode(iname->name, iname->len, =
oname->name);
> -		oname->len =3D ret;
> -		return ret;
> +		oname->len =3D digest_encode(iname->name, iname->len,
> +					   oname->name);
> +		return 0;
> 	}
> 	if (hash) {
> 		memcpy(buf, &hash, 4);
> @@ -315,15 +320,18 @@ int fscrypt_fname_disk_to_usr(struct inode =
*inode,
> 	}
> 	memcpy(buf + 8, iname->name + iname->len - 16, 16);
> 	oname->name[0] =3D '_';
> -	ret =3D digest_encode(buf, 24, oname->name + 1);
> -	oname->len =3D ret + 1;
> -	return ret + 1;
> +	oname->len =3D 1 + digest_encode(buf, 24, oname->name + 1);
> +	return 0;
> }
> EXPORT_SYMBOL(fscrypt_fname_disk_to_usr);
>=20
> /**
>  * fscrypt_fname_usr_to_disk() - converts a filename from user space =
to disk
>  * space
> + *
> + * The caller must have allocated sufficient memory for the @oname =
string.
> + *
> + * Return: 0 on success, -errno on failure
>  */
> int fscrypt_fname_usr_to_disk(struct inode *inode,
> 			const struct qstr *iname,
> @@ -333,7 +341,7 @@ int fscrypt_fname_usr_to_disk(struct inode *inode,
> 		oname->name[0] =3D '.';
> 		oname->name[iname->len - 1] =3D '.';
> 		oname->len =3D iname->len;
> -		return oname->len;
> +		return 0;
> 	}
> 	if (inode->i_crypt_info)
> 		return fname_encrypt(inode, iname, oname);
> @@ -367,10 +375,10 @@ int fscrypt_setup_filename(struct inode *dir, =
const struct qstr *iname,
> 	if (dir->i_crypt_info) {
> 		ret =3D fscrypt_fname_alloc_buffer(dir, iname->len,
> 							=
&fname->crypto_buf);
> -		if (ret < 0)
> +		if (ret)
> 			return ret;
> 		ret =3D fname_encrypt(dir, iname, &fname->crypto_buf);
> -		if (ret < 0)
> +		if (ret)
> 			goto errout;
> 		fname->disk_name.name =3D fname->crypto_buf.name;
> 		fname->disk_name.len =3D fname->crypto_buf.len;
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 67415e0..4d4b910 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -260,11 +260,12 @@ static int ext4_readdir(struct file *file, =
struct dir_context *ctx)
> 					/* Directory is encrypted */
> 					err =3D =
fscrypt_fname_disk_to_usr(inode,
> 						0, 0, &de_name, &fstr);
> +					de_name =3D fstr;
> 					fstr.len =3D save_len;
> -					if (err < 0)
> +					if (err)
> 						goto errout;
> 					if (!dir_emit(ctx,
> -					    fstr.name, err,
> +					    de_name.name, de_name.len,
> 					    le32_to_cpu(de->inode),
> 					    get_dtype(sb, =
de->file_type)))
> 						goto done;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 34c0142..2243ae2 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -639,7 +639,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
> 					res =3D =
fscrypt_fname_alloc_buffer(
> 						dir, len,
> 						&fname_crypto_str);
> -					if (res < 0)
> +					if (res)
> 						printk(KERN_WARNING =
"Error "
> 							"allocating =
crypto "
> 							=
"buffer--skipping "
> @@ -647,7 +647,7 @@ static struct stats dx_show_leaf(struct inode =
*dir,
> 					res =3D =
fscrypt_fname_disk_to_usr(dir,
> 						0, 0, &de_name,
> 						&fname_crypto_str);
> -					if (res < 0) {
> +					if (res) {
> 						printk(KERN_WARNING =
"Error "
> 							"converting =
filename "
> 							"from disk to =
usr"
> @@ -1011,7 +1011,7 @@ static int htree_dirblock_to_tree(struct file =
*dir_file,
> 			err =3D fscrypt_fname_disk_to_usr(dir, =
hinfo->hash,
> 					hinfo->minor_hash, &de_name,
> 					&fname_crypto_str);
> -			if (err < 0) {
> +			if (err) {
> 				count =3D err;
> 				goto errout;
> 			}
> @@ -3144,7 +3144,7 @@ static int ext4_symlink(struct inode *dir,
> 		istr.name =3D (const unsigned char *) symname;
> 		istr.len =3D len;
> 		err =3D fscrypt_fname_usr_to_disk(inode, &istr, &ostr);
> -		if (err < 0)
> +		if (err)
> 			goto err_drop_inode;
> 		sd->len =3D cpu_to_le16(ostr.len);
> 		disk_link.name =3D (char *) sd;
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index 4d83d9e..55aaf30 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -67,14 +67,13 @@ static const char *ext4_encrypted_get_link(struct =
dentry *dentry,
> 		goto errout;
>=20
> 	res =3D fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
> -	if (res < 0)
> +	if (res)
> 		goto errout;
>=20
> 	paddr =3D pstr.name;
>=20
> 	/* Null-terminate the name */
> -	if (res <=3D pstr.len)
> -		paddr[res] =3D '\0';
> +	paddr[pstr.len] =3D '\0';
> 	if (cpage)
> 		put_page(cpage);
> 	set_delayed_call(done, kfree_link, paddr);
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 9054aea..8716943 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -786,7 +786,7 @@ bool f2fs_fill_dentries(struct dir_context *ctx, =
struct f2fs_dentry_ptr *d,
>=20
> 		if (f2fs_encrypted_inode(d->inode)) {
> 			int save_len =3D fstr->len;
> -			int ret;
> +			int err;
>=20
> 			de_name.name =3D f2fs_kmalloc(de_name.len, =
GFP_NOFS);
> 			if (!de_name.name)
> @@ -794,11 +794,11 @@ bool f2fs_fill_dentries(struct dir_context *ctx, =
struct f2fs_dentry_ptr *d,
>=20
> 			memcpy(de_name.name, d->filename[bit_pos], =
de_name.len);
>=20
> -			ret =3D fscrypt_fname_disk_to_usr(d->inode,
> +			err =3D fscrypt_fname_disk_to_usr(d->inode,
> 						(u32)de->hash_code, 0,
> 						&de_name, fstr);
> 			kfree(de_name.name);
> -			if (ret < 0)
> +			if (err)
> 				return true;
>=20
> 			de_name =3D *fstr;
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 73fa356..afd5633 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -449,7 +449,7 @@ static int f2fs_symlink(struct inode *dir, struct =
dentry *dentry,
> 		ostr.name =3D sd->encrypted_path;
> 		ostr.len =3D disk_link.len;
> 		err =3D fscrypt_fname_usr_to_disk(inode, &istr, &ostr);
> -		if (err < 0)
> +		if (err)
> 			goto err_out;
>=20
> 		sd->len =3D cpu_to_le16(ostr.len);
> @@ -1048,7 +1048,7 @@ static const char =
*f2fs_encrypted_get_link(struct dentry *dentry,
> 		goto errout;
>=20
> 	res =3D fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
> -	if (res < 0)
> +	if (res)
> 		goto errout;
>=20
> 	/* this is broken symlink case */
> @@ -1060,7 +1060,7 @@ static const char =
*f2fs_encrypted_get_link(struct dentry *dentry,
> 	paddr =3D pstr.name;
>=20
> 	/* Null-terminate the name */
> -	paddr[res] =3D '\0';
> +	paddr[pstr.len] =3D '\0';
>=20
> 	put_page(cpage);
> 	set_delayed_call(done, kfree_link, paddr);
> --
> 2.8.0.rc3.226.g39d4020
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_65AA74EE-7B7B-4300-8ABB-20506729FE9C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV9sC3XKl2rkXzB/gAQjXsQ//XzlLmTT6UhGEEhr3GDOzzvkFwZEBFW39
ucb+zN2zXC3u/o203+Uc1XI86YBJGtKcPzhaEl9Df4cexGqS04Go2IV1se+fdbDG
BwtUZ7Y7YoG0kYcdWdzJJLprRiUSrxQbX84F6hfxrZiWSyUfJauuOHkakP7mQp0i
8BdMvDOe6MMNqLsHEgSa7t+fKX05KrCNw+Qym48UPSFqRtNPInr9E09hWZ3fzOKK
4LJ/hdT4YaCoJo7bDm3/USD8E+DOjELBa7vgp/4p9uaQbxy1ouIRLfglZKPiZcuh
RTBlhJvc9fwWMRx+nk7Ktn//Np5JU/MajEknpnYC4dpb9rlxoMQ48g4s/7fn7QvP
qURvedGdAZfZOimK5T6y7x17Nm9W96YYcLiK3fHgQ/2ejQtkXhIwY5XHSwVrarU+
K0O7urvCEUM4jpirzM6IaQhUw0uGixk+dyHF5GQqlsU2day9DEvFrnMr/IQNtqvr
CnNsWIZh7i4MVBZtM5t9qozeypUXlBokx7Cm8UUz8pFesTkPHxShk+rmYlvj4mmB
TsF4K2+5Uk0Bs/ziTSvKu8MDhGMugTuJ5Wkod9HMGEJHFJsoS8SRSaDDiCXM1/Mq
o0G/ohBzqTd7h4L/D9ToPfAqLD4ffQEKFV73MGwZVwORLKS0aHEs6URUCPEsO2qi
d/bXshpF6r0=
=iGtz
-----END PGP SIGNATURE-----

--Apple-Mail=_65AA74EE-7B7B-4300-8ABB-20506729FE9C--
