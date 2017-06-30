From: Miao Xie <miaoxie@huawei.com>
Subject: Re: [PATCH 1/2] ext4, project: expand inode extra size if possible
Date: Fri, 30 Jun 2017 16:48:38 +0800
Message-ID: <535692b6-b000-e040-2fdc-2ef5dcbff1ab@huawei.com>
References: <20170630035148.63305-1-wshilong@ddn.com>
Reply-To: <miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <lixi@ddn.com>, <yi.zhang@huawei.com>,
        <adilger@dilger.ca>, <wshilong@ddn.com>, <sihara@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>,
        <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9256 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdF3ItG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jun 2017 04:49:06 -0400
In-Reply-To: <20170630035148.63305-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

on 2017/6/30 at 11:51, Wang Shilong wrote:
> when upgrading from old format, try to set project id
> to old file first time, it will return EOVERFLOW, but if
> that file is dirtied(touch etc), changing project id will
> be allowed, this might be confusing for users, we could
> try to expand @i_extra_iszie here too.
> 
> Reported-by: zhangyi(F) <yi.zhang@huawei.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/ext4/ext4.h  |  3 +++
>  fs/ext4/inode.c |  7 +++----
>  fs/ext4/ioctl.c | 17 +++++++++++++++--
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3219154..640f006 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2453,6 +2453,9 @@ int ext4_walk_page_buffers(handle_t *handle,
>  			   int *partial,
>  			   int (*fn)(handle_t *handle,
>  				     struct buffer_head *bh));
> +int ext4_expand_extra_isize(struct inode *inode,
> +			    unsigned int new_extra_isize,
> +			    struct ext4_iloc iloc, handle_t *handle);
>  int do_journal_get_write_access(handle_t *handle,
>  				struct buffer_head *bh);
>  #define FALL_BACK_TO_NONDELALLOC 1
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cf82d0..d53fae6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5632,10 +5632,9 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
>   * Expand an inode by new_extra_isize bytes.
>   * Returns 0 on success or negative error number on failure.
>   */
> -static int ext4_expand_extra_isize(struct inode *inode,
> -				   unsigned int new_extra_isize,
> -				   struct ext4_iloc iloc,
> -				   handle_t *handle)
> +int ext4_expand_extra_isize(struct inode *inode,
> +			    unsigned int new_extra_isize,
> +			    struct ext4_iloc iloc, handle_t *handle)
>  {
>  	struct ext4_inode *raw_inode;
>  	struct ext4_xattr_ibody_header *header;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0c21e22..819f59d 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -319,6 +319,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  	struct ext4_iloc iloc;
>  	struct ext4_inode *raw_inode;
>  	struct dquot *transfer_to[MAXQUOTAS] = { };
> +	bool need_expand = false;
>  
>  	if (!ext4_has_feature_project(sb)) {
>  		if (projid != EXT4_DEF_PROJID)
> @@ -350,7 +351,10 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  		goto out_unlock;
>  
>  	raw_inode = ext4_raw_inode(&iloc);
> -	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
> +	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid) &&
> +	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
> +		need_expand = true;
> +	} else if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
>  		err = -EOVERFLOW;
>  		brelse(iloc.bh);
>  		goto out_unlock;
> @@ -361,12 +365,21 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  
>  	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
>  		EXT4_QUOTA_INIT_BLOCKS(sb) +
> -		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +		EXT4_QUOTA_DEL_BLOCKS(sb) + 3 +
> +		need_expand ? EXT4_DATA_TRANS_BLOCKS(sb) : 0);
>  	if (IS_ERR(handle)) {
>  		err = PTR_ERR(handle);
>  		goto out_unlock;
>  	}
>  
> +	if (need_expand) {
> +		err = ext4_expand_extra_isize(inode,
> +				      EXT4_SB(sb)->s_want_extra_isize,
> +				      iloc, handle);
> +		if (err)
> +			goto out_stop;
> +	}
> +

ext4_expand_extra_isize should be invoked after ext4_reserve_inode_write.

And I think it is better to restructure ext4_expand_extra_isize by moving NO_EXPAND check,
nojournal check and journal credits extend into it, and then we just if i_projid is in
the inode or not, if not, invoke ext4_expand_extra_isize. (don't forget to do cleanup for
ext4_mark_inode_dirty), And then we can remove many check in the above code.

Thanks
Miao

>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
>  	if (err)
>  		goto out_stop;
> 
