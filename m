From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 09/18] f2fs: use generic posix ACL infrastructure
Date: Fri, 06 Dec 2013 10:37:34 +0900
Message-ID: <1386293854.2101.8.camel@kjgkr>
References: <20131201115903.910559036@bombadil.infradead.org>
 <20131201120655.205206019@bombadil.infradead.org>
Reply-To: jaegeuk.kim@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-nfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20131201120655.205206019@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2013-12-01 (=EC=9D=BC), 03:59 -0800, Christoph Hellwig:

> f2fs has some weird mode bit handling, so still using the old
> chmod code for now.

f2fs caches a new mode bit for a while to make the consistency between
xattr's acl mode and the inode mode.
Anyway, it's a very good job.
Thanks,

You can add:
Reviewed-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/f2fs/acl.c   |  140 +++++++++------------------------------------=
----------
>  fs/f2fs/acl.h   |    1 +
>  fs/f2fs/file.c  |    1 +
>  fs/f2fs/namei.c |    2 +
>  fs/f2fs/xattr.c |    9 ++--
>  fs/f2fs/xattr.h |    2 -
>  6 files changed, 30 insertions(+), 125 deletions(-)
>=20
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index 45e8430..4f52fe0f 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -205,7 +205,7 @@ struct posix_acl *f2fs_get_acl(struct inode *inod=
e, int type)
>  	return acl;
>  }
> =20
> -static int f2fs_set_acl(struct inode *inode, int type,
> +static int __f2fs_set_acl(struct inode *inode, int type,
>  			struct posix_acl *acl, struct page *ipage)
>  {
>  	struct f2fs_sb_info *sbi =3D F2FS_SB(inode->i_sb);
> @@ -261,37 +261,32 @@ static int f2fs_set_acl(struct inode *inode, in=
t type,
>  	return error;
>  }
> =20
> +int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, int typ=
e)
> +{
> +	return __f2fs_set_acl(inode, type, acl, NULL);
> +}
> +
>  int f2fs_init_acl(struct inode *inode, struct inode *dir, struct pag=
e *ipage)
>  {
> -	struct f2fs_sb_info *sbi =3D F2FS_SB(dir->i_sb);
> -	struct posix_acl *acl =3D NULL;
> +	struct posix_acl *default_acl, *acl;
>  	int error =3D 0;
> =20
> -	if (!S_ISLNK(inode->i_mode)) {
> -		if (test_opt(sbi, POSIX_ACL)) {
> -			acl =3D f2fs_get_acl(dir, ACL_TYPE_DEFAULT);
> -			if (IS_ERR(acl))
> -				return PTR_ERR(acl);
> -		}
> -		if (!acl)
> -			inode->i_mode &=3D ~current_umask();
> -	}
> -
> -	if (!test_opt(sbi, POSIX_ACL) || !acl)
> -		goto cleanup;
> +	error =3D posix_acl_create(dir, &inode->i_mode, &default_acl, &acl)=
;
> +	if (error)
> +		return error;
> =20
> -	if (S_ISDIR(inode->i_mode)) {
> -		error =3D f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl, ipage);
> +	if (default_acl) {
> +		error =3D __f2fs_set_acl(inode, ACL_TYPE_DEFAULT, default_acl,
> +				       ipage);
> +		posix_acl_release(default_acl);
> +	}
> +	if (acl) {
>  		if (error)
> -			goto cleanup;
> +			error =3D __f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl,
> +					       ipage);
> +		posix_acl_release(acl);
>  	}
> -	error =3D __posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
> -	if (error < 0)
> -		return error;
> -	if (error > 0)
> -		error =3D f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, ipage);
> -cleanup:
> -	posix_acl_release(acl);
> +
>  	return error;
>  }
> =20
> @@ -315,100 +310,7 @@ int f2fs_acl_chmod(struct inode *inode)
>  	if (error)
>  		return error;
> =20
> -	error =3D f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, NULL);
> -	posix_acl_release(acl);
> -	return error;
> -}
> -
> -static size_t f2fs_xattr_list_acl(struct dentry *dentry, char *list,
> -		size_t list_size, const char *name, size_t name_len, int type)
> -{
> -	struct f2fs_sb_info *sbi =3D F2FS_SB(dentry->d_sb);
> -	const char *xname =3D POSIX_ACL_XATTR_DEFAULT;
> -	size_t size;
> -
> -	if (!test_opt(sbi, POSIX_ACL))
> -		return 0;
> -
> -	if (type =3D=3D ACL_TYPE_ACCESS)
> -		xname =3D POSIX_ACL_XATTR_ACCESS;
> -
> -	size =3D strlen(xname) + 1;
> -	if (list && size <=3D list_size)
> -		memcpy(list, xname, size);
> -	return size;
> -}
> -
> -static int f2fs_xattr_get_acl(struct dentry *dentry, const char *nam=
e,
> -		void *buffer, size_t size, int type)
> -{
> -	struct f2fs_sb_info *sbi =3D F2FS_SB(dentry->d_sb);
> -	struct posix_acl *acl;
> -	int error;
> -
> -	if (strcmp(name, "") !=3D 0)
> -		return -EINVAL;
> -	if (!test_opt(sbi, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -
> -	acl =3D f2fs_get_acl(dentry->d_inode, type);
> -	if (IS_ERR(acl))
> -		return PTR_ERR(acl);
> -	if (!acl)
> -		return -ENODATA;
> -	error =3D posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
> -	posix_acl_release(acl);
> -
> -	return error;
> -}
> -
> -static int f2fs_xattr_set_acl(struct dentry *dentry, const char *nam=
e,
> -		const void *value, size_t size, int flags, int type)
> -{
> -	struct f2fs_sb_info *sbi =3D F2FS_SB(dentry->d_sb);
> -	struct inode *inode =3D dentry->d_inode;
> -	struct posix_acl *acl =3D NULL;
> -	int error;
> -
> -	if (strcmp(name, "") !=3D 0)
> -		return -EINVAL;
> -	if (!test_opt(sbi, POSIX_ACL))
> -		return -EOPNOTSUPP;
> -	if (!inode_owner_or_capable(inode))
> -		return -EPERM;
> -
> -	if (value) {
> -		acl =3D posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		if (acl) {
> -			error =3D posix_acl_valid(acl);
> -			if (error)
> -				goto release_and_out;
> -		}
> -	} else {
> -		acl =3D NULL;
> -	}
> -
> -	error =3D f2fs_set_acl(inode, type, acl, NULL);
> -
> -release_and_out:
> +	error =3D __f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl, NULL);
>  	posix_acl_release(acl);
>  	return error;
>  }
> -
> -const struct xattr_handler f2fs_xattr_acl_default_handler =3D {
> -	.prefix =3D POSIX_ACL_XATTR_DEFAULT,
> -	.flags =3D ACL_TYPE_DEFAULT,
> -	.list =3D f2fs_xattr_list_acl,
> -	.get =3D f2fs_xattr_get_acl,
> -	.set =3D f2fs_xattr_set_acl,
> -};
> -
> -const struct xattr_handler f2fs_xattr_acl_access_handler =3D {
> -	.prefix =3D POSIX_ACL_XATTR_ACCESS,
> -	.flags =3D ACL_TYPE_ACCESS,
> -	.list =3D f2fs_xattr_list_acl,
> -	.get =3D f2fs_xattr_get_acl,
> -	.set =3D f2fs_xattr_set_acl,
> -};
> diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
> index 4963313..2af31fe 100644
> --- a/fs/f2fs/acl.h
> +++ b/fs/f2fs/acl.h
> @@ -37,6 +37,7 @@ struct f2fs_acl_header {
>  #ifdef CONFIG_F2FS_FS_POSIX_ACL
> =20
>  extern struct posix_acl *f2fs_get_acl(struct inode *, int);
> +extern int f2fs_set_acl(struct inode *inode, struct posix_acl *acl, =
int type);
>  extern int f2fs_acl_chmod(struct inode *);
>  extern int f2fs_init_acl(struct inode *, struct inode *, struct page=
 *);
>  #else
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 7d714f4..13eff60 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -405,6 +405,7 @@ const struct inode_operations f2fs_file_inode_ope=
rations =3D {
>  	.getattr	=3D f2fs_getattr,
>  	.setattr	=3D f2fs_setattr,
>  	.get_acl	=3D f2fs_get_acl,
> +	.set_acl	=3D f2fs_set_acl,
>  #ifdef CONFIG_F2FS_FS_XATTR
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 575adac..5846eeb 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -496,6 +496,7 @@ const struct inode_operations f2fs_dir_inode_oper=
ations =3D {
>  	.getattr	=3D f2fs_getattr,
>  	.setattr	=3D f2fs_setattr,
>  	.get_acl	=3D f2fs_get_acl,
> +	.set_acl	=3D f2fs_set_acl,
>  #ifdef CONFIG_F2FS_FS_XATTR
>  	.setxattr	=3D generic_setxattr,
>  	.getxattr	=3D generic_getxattr,
> @@ -522,6 +523,7 @@ const struct inode_operations f2fs_special_inode_=
operations =3D {
>  	.getattr	=3D f2fs_getattr,
>  	.setattr        =3D f2fs_setattr,
>  	.get_acl	=3D f2fs_get_acl,
> +	.set_acl	=3D f2fs_set_acl,
>  #ifdef CONFIG_F2FS_FS_XATTR
>  	.setxattr       =3D generic_setxattr,
>  	.getxattr       =3D generic_getxattr,
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index aa7a3f1..e2b9299 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -21,6 +21,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/f2fs_fs.h>
>  #include <linux/security.h>
> +#include <linux/posix_acl_xattr.h>
>  #include "f2fs.h"
>  #include "xattr.h"
> =20
> @@ -216,8 +217,8 @@ const struct xattr_handler f2fs_xattr_security_ha=
ndler =3D {
>  static const struct xattr_handler *f2fs_xattr_handler_map[] =3D {
>  	[F2FS_XATTR_INDEX_USER] =3D &f2fs_xattr_user_handler,
>  #ifdef CONFIG_F2FS_FS_POSIX_ACL
> -	[F2FS_XATTR_INDEX_POSIX_ACL_ACCESS] =3D &f2fs_xattr_acl_access_hand=
ler,
> -	[F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &f2fs_xattr_acl_default_ha=
ndler,
> +	[F2FS_XATTR_INDEX_POSIX_ACL_ACCESS] =3D &posix_acl_access_xattr_han=
dler,
> +	[F2FS_XATTR_INDEX_POSIX_ACL_DEFAULT] =3D &posix_acl_default_xattr_h=
andler,
>  #endif
>  	[F2FS_XATTR_INDEX_TRUSTED] =3D &f2fs_xattr_trusted_handler,
>  #ifdef CONFIG_F2FS_FS_SECURITY
> @@ -229,8 +230,8 @@ static const struct xattr_handler *f2fs_xattr_han=
dler_map[] =3D {
>  const struct xattr_handler *f2fs_xattr_handlers[] =3D {
>  	&f2fs_xattr_user_handler,
>  #ifdef CONFIG_F2FS_FS_POSIX_ACL
> -	&f2fs_xattr_acl_access_handler,
> -	&f2fs_xattr_acl_default_handler,
> +	&posix_acl_access_xattr_handler,
> +	&posix_acl_default_xattr_handler,
>  #endif
>  	&f2fs_xattr_trusted_handler,
>  #ifdef CONFIG_F2FS_FS_SECURITY
> diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
> index 02a08fb..b21d9eb 100644
> --- a/fs/f2fs/xattr.h
> +++ b/fs/f2fs/xattr.h
> @@ -108,8 +108,6 @@ struct f2fs_xattr_entry {
>  #ifdef CONFIG_F2FS_FS_XATTR
>  extern const struct xattr_handler f2fs_xattr_user_handler;
>  extern const struct xattr_handler f2fs_xattr_trusted_handler;
> -extern const struct xattr_handler f2fs_xattr_acl_access_handler;
> -extern const struct xattr_handler f2fs_xattr_acl_default_handler;
>  extern const struct xattr_handler f2fs_xattr_advise_handler;
>  extern const struct xattr_handler f2fs_xattr_security_handler;
> =20

--=20
Jaegeuk Kim
Samsung

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
