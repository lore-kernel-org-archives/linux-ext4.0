From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 2/3] ext4 crypto: add ioctls to allow backup of encryption metadata
Date: Thu, 10 Dec 2015 16:48:56 -0700
Message-ID: <649A5882-2F1C-4A55-ADB1-AFECA3FD560C@dilger.ca>
References: <1449759879-2166-1-git-send-email-tytso@mit.edu> <1449759879-2166-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_937F688D-D7E9-4356-BE43-A5AFB5558353"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35708 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbLJXtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2015 18:49:04 -0500
Received: by ioc74 with SMTP id 74so109838636ioc.2
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2015 15:49:02 -0800 (PST)
In-Reply-To: <1449759879-2166-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_937F688D-D7E9-4356-BE43-A5AFB5558353
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 10, 2015, at 8:04 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> Add new ioctls which allow for the metadata of encrypted files (the
> filename and the crypto policy) to be backed up.  We can restore the
> crypto policy, but for now we can't restore the encrypted filename
> because messing with encrypted directories directly while bypassing
> the VFS would get fairly tricky/nasty.

Instead of exposing these via ioctls, why not use virtual xattrs
(e.g. "trusted.crypt_meta" or similar) so that this can be backed
up and restored using a normal backup tool instead of basically
nothing that exists today.

For reading the ciphertext, do existing tools such as tar and rsync
allow reading with O_DIRECT with CIPHERTEXT_ACCESS?  If not, one might
consider to allow normal reads w/o the file key to return the
ciphertext so that "tar --xattr" by some process with CAP_SYS_ADMIN
but out any keys could be used to backup and restore the ciphertext
in a sensible manner.  That is no more risk than the same process
reading the blocks from the disk device directly, but would be a lot
more useful (i.e. it is practical to use normal backup tools for
encrypted files).

Cheers, Andreas

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/crypto_key.c  | 57 =
++++++++++++++++++++++++++++++++++++++++++++-
> fs/ext4/ext4.h        |  9 ++++++++
> fs/ext4/ext4_crypto.h |  8 +++++++
> fs/ext4/ioctl.c       | 64 =
+++++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/namei.c       | 24 +++++++++++++++++++
> 5 files changed, 161 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
> index c5882b3..039b22d 100644
> --- a/fs/ext4/crypto_key.c
> +++ b/fs/ext4/crypto_key.c
> @@ -14,7 +14,7 @@
> #include <linux/scatterlist.h>
> #include <uapi/linux/keyctl.h>
>=20
> -#include "ext4.h"
> +#include "ext4_jbd2.h"
> #include "xattr.h"
>=20
> static void derive_crypt_complete(struct crypto_async_request *req, =
int rc)
> @@ -270,3 +270,58 @@ int ext4_has_encryption_key(struct inode *inode)
>=20
> 	return (ei->i_crypt_info !=3D NULL);
> }
> +
> +int ext4_get_encryption_metadata(struct inode *inode,
> +				 struct ext4_encrypted_metadata *mdata)
> +{
> +	int res;
> +
> +	if (mdata->len < sizeof(struct ext4_encryption_context))
> +		return -EINVAL;
> +
> +	res =3D ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> +			     &mdata->metadata, mdata->len);
> +	if (res < 0)
> +		return res;
> +	mdata->len =3D res;
> +	return 0;
> +}
> +
> +int ext4_set_encryption_metadata(struct inode *inode,
> +				 struct ext4_encrypted_metadata *mdata)
> +{
> +	struct ext4_encryption_context *ctx;
> +	handle_t *handle;
> +	int res;
> +
> +	if (mdata->len !=3D sizeof(struct ext4_encryption_context))
> +		return -EINVAL;
> +	ctx =3D (struct ext4_encryption_context *) &mdata->metadata;
> +	if (ctx->format !=3D EXT4_ENCRYPTION_CONTEXT_FORMAT_V1)
> +		return -EINVAL;
> +
> +	res =3D ext4_convert_inline_data(inode);
> +	if (res)
> +		return res;
> +
> +	handle =3D ext4_journal_start(inode, EXT4_HT_MISC,
> +				    ext4_jbd2_credits_xattr(inode));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +	res =3D ext4_xattr_set(inode, EXT4_XATTR_INDEX_ENCRYPTION,
> +			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, ctx,
> +			     sizeof(struct ext4_encryption_context), 0);
> +	if (res < 0)
> +		goto errout;
> +	ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> +	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +	res =3D ext4_mark_inode_dirty(handle, inode);
> +	if (res)
> +		EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
> +	else
> +		res =3D ext4_get_encryption_info(inode);
> +errout:
> +	ext4_journal_stop(handle);
> +	return res;
> +}
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cf7a885..c569430 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -617,6 +617,9 @@ enum {
> #define EXT4_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct =
ext4_encryption_policy)
> #define EXT4_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
> #define EXT4_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct =
ext4_encryption_policy)
> +#define EXT4_IOC_GET_ENCRYPTION_METADATA _IOWR('f', 22, struct =
ext4_encrypted_metadata)
> +#define EXT4_IOC_SET_ENCRYPTION_METADATA _IOR('f', 23, struct =
ext4_encrypted_metadata)
> +#define EXT4_IOC_GET_ENCRYPTED_FILENAME	_IOWR('f', 24, struct =
ext4_encrypted_metadata)
>=20
> #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> /*
> @@ -2311,6 +2314,10 @@ static inline void =
ext4_fname_free_filename(struct ext4_filename *fname) { }
> void ext4_free_crypt_info(struct ext4_crypt_info *ci);
> void ext4_free_encryption_info(struct inode *inode, struct =
ext4_crypt_info *ci);
> int _ext4_get_encryption_info(struct inode *inode);
> +int ext4_set_encryption_metadata(struct inode *inode,
> +				 struct ext4_encrypted_metadata *mdata);
> +int ext4_get_encryption_metadata(struct inode *inode,
> +				 struct ext4_encrypted_metadata *mdata);
>=20
> #ifdef CONFIG_EXT4_FS_ENCRYPTION
> int ext4_has_encryption_key(struct inode *inode);
> @@ -2546,6 +2553,8 @@ extern int ext4_generic_delete_entry(handle_t =
*handle,
> 				     int buf_size,
> 				     int csum_size);
> extern int ext4_empty_dir(struct inode *inode);
> +extern int ext4_get_encrypted_filename(struct file *filp,
> +				       struct ext4_encrypted_metadata =
*mdata);
>=20
> /* resize.c */
> extern int ext4_group_add(struct super_block *sb,
> diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
> index ac7d4e8..f267cd3 100644
> --- a/fs/ext4/ext4_crypto.h
> +++ b/fs/ext4/ext4_crypto.h
> @@ -156,4 +156,12 @@ static inline u32 encrypted_symlink_data_len(u32 =
l)
> 	return (l + sizeof(struct ext4_encrypted_symlink_data) - 1);
> }
>=20
> +/**
> + * Structure used for communicating encrypted metadata with userspace
> + */
> +struct ext4_encrypted_metadata {
> +	u32 len;
> +	char metadata[288];
> +};
> +
> #endif	/* _EXT4_CRYPTO_H */
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 5e872fd..afb51f5 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -689,6 +689,67 @@ encryption_policy_out:
> 		return -EOPNOTSUPP;
> #endif
> 	}
> +	case EXT4_IOC_GET_ENCRYPTION_METADATA: {
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +		struct ext4_encrypted_metadata mdata;
> +		int err =3D 0;
> +
> +		if (get_user(mdata.len, (u32 __user *) arg))
> +			return -EFAULT;
> +		if (mdata.len > sizeof(mdata.metadata))
> +			return -EINVAL;
> +
> +		if (!ext4_encrypted_inode(inode))
> +			return -ENOENT;
> +		err =3D ext4_get_encryption_metadata(inode, &mdata);
> +		if (err)
> +			return err;
> +		if (copy_to_user((void __user *)arg, &mdata, =
sizeof(mdata)))
> +			return -EFAULT;
> +		return 0;
> +#else
> +		return -EOPNOTSUPP;
> +#endif
> +	}
> +	case EXT4_IOC_SET_ENCRYPTION_METADATA: {
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +		struct ext4_encrypted_metadata mdata;
> +		int err =3D 0;
> +
> +		if (ext4_encrypted_inode(inode))
> +			return -EINVAL;
> +		if (copy_from_user(&mdata,
> +				   (struct ext4_encrypted_metadata =
__user *)arg,
> +				   sizeof(mdata)))
> +			return -EFAULT;
> +		err =3D ext4_set_encryption_metadata(inode, &mdata);
> +		return err;
> +#else
> +		return -EOPNOTSUPP;
> +#endif
> +	}
> +	case EXT4_IOC_GET_ENCRYPTED_FILENAME: {
> +#ifdef CONFIG_EXT4_FS_ENCRYPTION
> +		struct ext4_encrypted_metadata mdata;
> +		int err =3D 0;
> +
> +		if (get_user(mdata.len, (u32 __user *) arg))
> +			return -EFAULT;
> +		if (mdata.len > sizeof(mdata.metadata))
> +			return -EINVAL;
> +
> +		if (!ext4_encrypted_inode(inode))
> +			return -ENOENT;
> +		err =3D ext4_get_encrypted_filename(filp, &mdata);
> +		if (err)
> +			return err;
> +		if (copy_to_user((void __user *)arg, &mdata, =
sizeof(mdata)))
> +			return -EFAULT;
> +		return 0;
> +#else
> +		return -EOPNOTSUPP;
> +#endif
> +	}
> 	default:
> 		return -ENOTTY;
> 	}
> @@ -755,6 +816,9 @@ long ext4_compat_ioctl(struct file *file, unsigned =
int cmd, unsigned long arg)
> 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
> 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
> 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
> +	case EXT4_IOC_GET_ENCRYPTION_METADATA:
> +	case EXT4_IOC_SET_ENCRYPTION_METADATA:
> +	case EXT4_IOC_GET_ENCRYPTED_FILENAME:
> 		break;
> 	default:
> 		return -ENOIOCTLCMD;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a969ab3..1cc4eef 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3861,3 +3861,27 @@ const struct inode_operations =
ext4_special_inode_operations =3D {
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> };
> +
> +int ext4_get_encrypted_filename(struct file *filp,
> +				struct ext4_encrypted_metadata *mdata)
> +{
> +	struct dentry *dentry =3D filp->f_path.dentry;
> +	struct inode *dir =3D dentry->d_parent->d_inode;
> +	struct buffer_head *bh;
> +	struct ext4_dir_entry_2 *de;
> +
> +	if (!dir || !ext4_encrypted_inode(dir))
> +		return -EINVAL;
> +
> +	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL);
> +	if (IS_ERR(bh))
> +		return PTR_ERR(bh);
> +	if (de =3D=3D NULL)
> +		return -ENOENT;
> +
> +	if (mdata->len < de->name_len)
> +		return -ENOSPC;
> +	mdata->len =3D de->name_len;
> +	memcpy(mdata->metadata, de->name, de->name_len);
> +	return 0;
> +}
> --
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_937F688D-D7E9-4356-BE43-A5AFB5558353
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmoPaXKl2rkXzB/gAQiywRAAgUFw1pdvUKEpdwCfuMBZN0jhJS70uij7
9uTeyat8hMB58vJq9TIugSN2XnQEqH6okZYFrKFa5nDAYHX0BJ+ZwjzPShvAp+fM
gBs2SkKU0gf95dl03QLcz3TdRJDBL0JW7osKzAfnNrx2K3uaQ5CHrfqKD3NpHgt1
83fl8eYIb239sLPmNZD3z1xpFUo0a6WQK9DEII3xb/Q3gF5tARFvYG5+tpAJuu8Q
YWQikAjoiaJnW4E3TDM7cE9kTcXhaAanBTivbSeQyomSZ5c0ZaMykpRqs+Xe/aHb
7LLW/bRJkHlErsgOESu1+18I0uVmCGkro4aZBqbHHijs+K/N2WaXXgaoYFSPIMKn
Ky8IigoeWhoITnuRExL4jSxRpFgnqM2AYEKpXkm2KjT48XWCqPaT5ps/fA5gb2Xj
T5cezx69cQkWFVAwK64Ugm4AxrZkcnvm3d704BDm+5Sw3dyCcPq0KjOYg7IJq9SC
KzsB26cFAup13l3fCif9Q8A77xeLc+O2zEnGREKfmipvFnBhbrj8JiDYrE+le4rP
tgkpvdNu60GnXyJohqltp2RZDV7EzZ8hGuVeiu26Wd7jdxdEhZ+WaCOaB06Pql9Y
v857O4qEPnVFdH5jBAo7qsDNg/KlDliPciTOO9yTFai8qg7SOUV9MPq6bSWXwc81
gkiypMNLO2U=
=8gT9
-----END PGP SIGNATURE-----

--Apple-Mail=_937F688D-D7E9-4356-BE43-A5AFB5558353--
