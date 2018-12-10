Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbeLJSGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 13:06:32 -0500
Date: Mon, 10 Dec 2018 10:06:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        corbet@lwn.net, ralf@linux-mips.org, paul.burton@mips.com,
        jhogan@kernel.org, green.hu@gmail.com, deanbo422@gmail.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, richard@nod.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH V3 2/9] f2fs: use IS_ENCRYPTED() to check encryption
 status
Message-ID: <20181210180629.GD92174@gmail.com>
References: <20181208065144.19486-1-chandan@linux.vnet.ibm.com>
 <20181208065144.19486-3-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181208065144.19486-3-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 08, 2018 at 12:21:37PM +0530, Chandan Rajendra wrote:
> This commit removes the f2fs specific f2fs_encrypted_inode() and makes
> use of the generic IS_ENCRYPTED() macro to check for the encryption
> status of an inode.
> 
> Acked-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>

> ---
>  fs/f2fs/data.c  |  4 ++--
>  fs/f2fs/dir.c   | 10 +++++-----
>  fs/f2fs/f2fs.h  |  7 +------
>  fs/f2fs/file.c  | 10 +++++-----
>  fs/f2fs/inode.c |  4 ++--
>  fs/f2fs/namei.c |  6 +++---
>  6 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 09d9fc1676a7..844ec573263e 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -1491,7 +1491,7 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  	}
>  
>  	if (size) {
> -		if (f2fs_encrypted_inode(inode))
> +		if (IS_ENCRYPTED(inode))
>  			flags |= FIEMAP_EXTENT_DATA_ENCRYPTED;
>  
>  		ret = fiemap_fill_next_extent(fieinfo, logical,
> @@ -1764,7 +1764,7 @@ static inline bool check_inplace_update_policy(struct inode *inode,
>  	if (policy & (0x1 << F2FS_IPU_ASYNC) &&
>  			fio && fio->op == REQ_OP_WRITE &&
>  			!(fio->op_flags & REQ_SYNC) &&
> -			!f2fs_encrypted_inode(inode))
> +			!IS_ENCRYPTED(inode))
>  		return true;
>  
>  	/* this is only set during fdatasync */
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index bacc667950b6..cf9e2564388d 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -385,7 +385,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
>  		if (err)
>  			goto put_error;
>  
> -		if ((f2fs_encrypted_inode(dir) || dummy_encrypt) &&
> +		if ((IS_ENCRYPTED(dir) || dummy_encrypt) &&
>  					f2fs_may_encrypt(inode)) {
>  			err = fscrypt_inherit_context(dir, inode, page, false);
>  			if (err)
> @@ -399,7 +399,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
>  
>  	if (new_name) {
>  		init_dent_inode(new_name, page);
> -		if (f2fs_encrypted_inode(dir))
> +		if (IS_ENCRYPTED(dir))
>  			file_set_enc_name(inode);
>  	}
>  
> @@ -808,7 +808,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
>  		de_name.name = d->filename[bit_pos];
>  		de_name.len = le16_to_cpu(de->name_len);
>  
> -		if (f2fs_encrypted_inode(d->inode)) {
> +		if (IS_ENCRYPTED(d->inode)) {
>  			int save_len = fstr->len;
>  
>  			err = fscrypt_fname_disk_to_usr(d->inode,
> @@ -852,7 +852,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
>  	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
>  	int err = 0;
>  
> -	if (f2fs_encrypted_inode(inode)) {
> +	if (IS_ENCRYPTED(inode)) {
>  		err = fscrypt_get_encryption_info(inode);
>  		if (err && err != -ENOKEY)
>  			goto out;
> @@ -914,7 +914,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
>  
>  static int f2fs_dir_open(struct inode *inode, struct file *filp)
>  {
> -	if (f2fs_encrypted_inode(inode))
> +	if (IS_ENCRYPTED(inode))
>  		return fscrypt_get_encryption_info(inode) ? -EACCES : 0;
>  	return 0;
>  }
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index dadb5f468f20..368c7e78fe6b 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3436,14 +3436,9 @@ void f2fs_unregister_sysfs(struct f2fs_sb_info *sbi);
>  /*
>   * crypto support
>   */
> -static inline bool f2fs_encrypted_inode(struct inode *inode)
> -{
> -	return file_is_encrypt(inode);
> -}
> -
>  static inline bool f2fs_encrypted_file(struct inode *inode)
>  {
> -	return f2fs_encrypted_inode(inode) && S_ISREG(inode->i_mode);
> +	return IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode);
>  }
>  
>  static inline void f2fs_set_encrypted_inode(struct inode *inode)
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 87794b2a45ff..6c7ad15000b9 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -585,7 +585,7 @@ static int truncate_partial_data_page(struct inode *inode, u64 from,
>  	zero_user(page, offset, PAGE_SIZE - offset);
>  
>  	/* An encrypted inode should have a key and truncate the last page. */
> -	f2fs_bug_on(F2FS_I_SB(inode), cache_only && f2fs_encrypted_inode(inode));
> +	f2fs_bug_on(F2FS_I_SB(inode), cache_only && IS_ENCRYPTED(inode));
>  	if (!cache_only)
>  		set_page_dirty(page);
>  	f2fs_put_page(page, 1);
> @@ -730,7 +730,7 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
>  		stat->attributes |= STATX_ATTR_APPEND;
>  	if (flags & F2FS_COMPR_FL)
>  		stat->attributes |= STATX_ATTR_COMPRESSED;
> -	if (f2fs_encrypted_inode(inode))
> +	if (IS_ENCRYPTED(inode))
>  		stat->attributes |= STATX_ATTR_ENCRYPTED;
>  	if (flags & F2FS_IMMUTABLE_FL)
>  		stat->attributes |= STATX_ATTR_IMMUTABLE;
> @@ -1587,7 +1587,7 @@ static long f2fs_fallocate(struct file *file, int mode,
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
>  
> -	if (f2fs_encrypted_inode(inode) &&
> +	if (IS_ENCRYPTED(inode) &&
>  		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
>  		return -EOPNOTSUPP;
>  
> @@ -1671,7 +1671,7 @@ static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	unsigned int flags = fi->i_flags;
>  
> -	if (f2fs_encrypted_inode(inode))
> +	if (IS_ENCRYPTED(inode))
>  		flags |= F2FS_ENCRYPT_FL;
>  	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
>  		flags |= F2FS_INLINE_DATA_FL;
> @@ -2430,7 +2430,7 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
>  	if (!S_ISREG(src->i_mode) || !S_ISREG(dst->i_mode))
>  		return -EINVAL;
>  
> -	if (f2fs_encrypted_inode(src) || f2fs_encrypted_inode(dst))
> +	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst))
>  		return -EOPNOTSUPP;
>  
>  	if (src == dst) {
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index ddef483ad689..d731d23aedee 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -43,7 +43,7 @@ void f2fs_set_inode_flags(struct inode *inode)
>  		new_fl |= S_NOATIME;
>  	if (flags & F2FS_DIRSYNC_FL)
>  		new_fl |= S_DIRSYNC;
> -	if (f2fs_encrypted_inode(inode))
> +	if (file_is_encrypt(inode))
>  		new_fl |= S_ENCRYPTED;
>  	inode_set_flags(inode, new_fl,
>  			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|
> @@ -453,7 +453,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_mapping->a_ops = &f2fs_dblock_aops;
>  		inode_nohighmem(inode);
>  	} else if (S_ISLNK(inode->i_mode)) {
> -		if (f2fs_encrypted_inode(inode))
> +		if (file_is_encrypt(inode))
>  			inode->i_op = &f2fs_encrypted_symlink_inode_operations;
>  		else
>  			inode->i_op = &f2fs_symlink_inode_operations;
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 99299ede7429..6ae37e0cf6e3 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -75,7 +75,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
>  	set_inode_flag(inode, FI_NEW_INODE);
>  
>  	/* If the directory encrypted, then we should encrypt the inode. */
> -	if ((f2fs_encrypted_inode(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) &&
> +	if ((IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) &&
>  				f2fs_may_encrypt(inode))
>  		f2fs_set_encrypted_inode(inode);
>  
> @@ -476,7 +476,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
>  		if (err)
>  			goto out_iput;
>  	}
> -	if (f2fs_encrypted_inode(dir) &&
> +	if (IS_ENCRYPTED(dir) &&
>  	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
>  	    !fscrypt_has_permitted_context(dir, inode)) {
>  		f2fs_msg(inode->i_sb, KERN_WARNING,
> @@ -803,7 +803,7 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	if (unlikely(f2fs_cp_error(sbi)))
>  		return -EIO;
>  
> -	if (f2fs_encrypted_inode(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) {
> +	if (IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) {
>  		int err = fscrypt_get_encryption_info(dir);
>  		if (err)
>  			return err;
> -- 
> 2.19.1
> 
