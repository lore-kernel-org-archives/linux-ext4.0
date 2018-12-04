Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbeLDXzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 18:55:14 -0500
Date: Tue, 4 Dec 2018 15:55:10 -0800
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
Subject: Re: [PATCH V2 5/7] ext4: use IS_VERITY() to check inode's fsverity
 status
Message-ID: <20181204235509.GF70682@gmail.com>
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
 <20181204095650.12562-6-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204095650.12562-6-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2018 at 03:26:48PM +0530, Chandan Rajendra wrote:
> This commit now uses IS_VERITY() macro to check if fsverity is
> enabled on an inode.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/ext4.h     |  9 ---------
>  fs/ext4/file.c     |  2 +-
>  fs/ext4/inode.c    | 10 ++++++----
>  fs/ext4/readpage.c |  2 +-
>  fs/ext4/super.c    |  1 +
>  5 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index db21df885186..64bf9fb7ef18 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2296,15 +2296,6 @@ extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
>  					      struct ext4_group_desc *gdp);
>  ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
>  
> -static inline bool ext4_verity_inode(struct inode *inode)
> -{
> -#ifdef CONFIG_EXT4_FS_VERITY
> -	return ext4_test_inode_flag(inode, EXT4_INODE_VERITY);
> -#else
> -	return false;
> -#endif
> -}
> -
>  #ifdef CONFIG_FS_ENCRYPTION
>  static inline int ext4_fname_setup_filename(struct inode *dir,
>  			const struct qstr *iname,
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cb4b69ef01a2..30fbd663354f 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -444,7 +444,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
>  	if (ret)
>  		return ret;
>  
> -	if (ext4_verity_inode(inode)) {
> +	if (IS_VERITY(inode)) {
>  		ret = fsverity_file_open(inode, filp);
>  		if (ret)
>  			return ret;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 09d8857b0e3c..79d14d8bbbf4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3884,7 +3884,7 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  		return 0;
>  #endif
>  
> -	if (ext4_verity_inode(inode))
> +	if (IS_VERITY(inode))
>  		return 0;
>  
>  	/*
> @@ -4726,7 +4726,7 @@ static bool ext4_should_use_dax(struct inode *inode)
>  		return false;
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT))
>  		return false;
> -	if (ext4_verity_inode(inode))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_VERITY))
>  		return false;
>  	return true;
>  }
> @@ -4750,9 +4750,11 @@ void ext4_set_inode_flags(struct inode *inode)
>  		new_fl |= S_DAX;
>  	if (flags & EXT4_ENCRYPT_FL)
>  		new_fl |= S_ENCRYPTED;
> +	if (flags & EXT4_VERITY_FL)
> +		new_fl |= S_VERITY;
>  	inode_set_flags(inode, new_fl,
>  			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX|
> -			S_ENCRYPTED);
> +			S_ENCRYPTED|S_VERITY);
>  }
>  
>  static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
> @@ -5510,7 +5512,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	if (error)
>  		return error;
>  
> -	if (ext4_verity_inode(inode)) {
> +	if (IS_VERITY(inode)) {
>  		error = fsverity_prepare_setattr(dentry, attr);
>  		if (error)
>  			return error;
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 7252f0a60cdb..2c037df629dd 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -206,7 +206,7 @@ static void mpage_end_io(struct bio *bio)
>  static inline loff_t ext4_readpage_limit(struct inode *inode)
>  {
>  #ifdef CONFIG_EXT4_FS_VERITY
> -	if (ext4_verity_inode(inode)) {
> +	if (IS_VERITY(inode)) {
>  		if (inode->i_verity_info)
>  			/* limit to end of metadata region */
>  			return fsverity_full_i_size(inode);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 16fb483a6f4a..35ed3c48f8d2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1344,6 +1344,7 @@ static int ext4_set_verity(struct inode *inode, loff_t data_i_size)
>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
>  	if (err == 0) {
>  		ext4_set_inode_flag(inode, EXT4_INODE_VERITY);
> +		ext4_set_inode_flags(inode);
>  		EXT4_I(inode)->i_disksize = data_i_size;
>  		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
>  	}
> -- 
> 2.19.1
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

Note: we should also move the IS_VERITY() check into fsverity_file_open() and
fsverity_prepare_setattr(), to be like fscrypt_file_open() and
fscrypt_prepare_setattr().  But starting with just this is fine.

- Eric
