From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2 2/2] Ext3: return ENOMEM rather than EIO if
 sb_getblk fails
Date: Tue, 15 Jan 2013 14:30:58 +0100
Message-ID: <20130115133058.GB4631@quack.suse.cz>
References: <50F63881.3020306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab3AONbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:00 -0500
Content-Disposition: inline
In-Reply-To: <50F63881.3020306@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-01-13 21:20:01, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> It will be better to use ENOMEM rather than EIO, because the only
> reason that sb_getblk fails is that allocation fails.
  Thanks. I've merged the patch to my tree.

							Honza
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext3/inode.c  |    4 ++--
>  fs/ext3/resize.c |    6 +++---
>  fs/ext3/xattr.c  |    2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 7338a76..eecedfd 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1084,7 +1084,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
>  		struct buffer_head *bh;
>  		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
>  		if (unlikely(!bh)) {
> -			*errp = -EIO;
> +			*errp = -ENOMEM;
>  			goto err;
>  		}
>  		if (buffer_new(&dummy)) {
> @@ -2739,7 +2739,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
>  				"unable to read inode block - "
>  				"inode=%lu, block="E3FSBLK,
>  				 inode->i_ino, block);
> -		return -EIO;
> +		return -ENOMEM;
>  	}
>  	if (!buffer_uptodate(bh)) {
>  		lock_buffer(bh);
> diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
> index 704e8ce..2710565 100644
> --- a/fs/ext3/resize.c
> +++ b/fs/ext3/resize.c
> @@ -117,7 +117,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
>  
>  	bh = sb_getblk(sb, blk);
>  	if (unlikely(!bh))
> -		return ERR_PTR(-EIO);
> +		return ERR_PTR(-ENOMEM);
>  	if ((err = ext3_journal_get_write_access(handle, bh))) {
>  		brelse(bh);
>  		bh = ERR_PTR(err);
> @@ -235,7 +235,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>  
>  		gdb = sb_getblk(sb, block);
>  		if (unlikely(!gdb)) {
> -			err = -EIO;
> +			err = -ENOMEM;
>  			goto exit_bh;
>  		}
>  		if ((err = ext3_journal_get_write_access(handle, gdb))) {
> @@ -723,7 +723,7 @@ static void update_backups(struct super_block *sb,
>  
>  		bh = sb_getblk(sb, group * bpg + blk_off);
>  		if (unlikely(!bh)) {
> -			err = -EIO;
> +			err = -ENOMEM;
>  			break;
>  		}
>  		ext3_debug("update metadata backup %#04lx\n",
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index 9f57470..b1fc963 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -816,7 +816,7 @@ inserted:
>  			if (unlikely(!new_bh)) {
>  getblk_failed:
>  				ext3_free_blocks(handle, inode, block, 1);
> -				error = -EIO;
> +				error = -ENOMEM;
>  				goto cleanup;
>  			}
>  			lock_buffer(new_bh);
> -- 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
