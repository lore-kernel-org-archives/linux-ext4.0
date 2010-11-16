From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add error check in ext3_mkdir()
Date: Tue, 16 Nov 2010 14:28:19 +0100
Message-ID: <20101116132819.GB7587@quack.suse.cz>
References: <1289906292-8906-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab0KPN2V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 08:28:21 -0500
Content-Disposition: inline
In-Reply-To: <1289906292-8906-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-11-10 20:18:12, Namhyung Kim wrote:
> Check return value of ext3_journal_get_write_access, ext3_journal_dirty_metadata
> and ext3_mark_inode_dirty. Consolidate error path under new label 'out_clear_inode'
> and adjust bh releasing appropriately.
  Thanks. Merged.

								Honza

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/namei.c |   36 ++++++++++++++++++++++--------------
>  1 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index bce9dce..03fccc5 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1762,7 +1762,7 @@ static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
>  {
>  	handle_t *handle;
>  	struct inode * inode;
> -	struct buffer_head * dir_block;
> +	struct buffer_head * dir_block = NULL;
>  	struct ext3_dir_entry_2 * de;
>  	int err, retries = 0;
>  
> @@ -1790,15 +1790,14 @@ retry:
>  	inode->i_fop = &ext3_dir_operations;
>  	inode->i_size = EXT3_I(inode)->i_disksize = inode->i_sb->s_blocksize;
>  	dir_block = ext3_bread (handle, inode, 0, 1, &err);
> -	if (!dir_block) {
> -		drop_nlink(inode); /* is this nlink == 0? */
> -		unlock_new_inode(inode);
> -		ext3_mark_inode_dirty(handle, inode);
> -		iput (inode);
> -		goto out_stop;
> -	}
> +	if (!dir_block)
> +		goto out_clear_inode;
> +
>  	BUFFER_TRACE(dir_block, "get_write_access");
> -	ext3_journal_get_write_access(handle, dir_block);
> +	err = ext3_journal_get_write_access(handle, dir_block);
> +	if (err)
> +		goto out_clear_inode;
> +
>  	de = (struct ext3_dir_entry_2 *) dir_block->b_data;
>  	de->inode = cpu_to_le32(inode->i_ino);
>  	de->name_len = 1;
> @@ -1814,11 +1813,16 @@ retry:
>  	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
>  	inode->i_nlink = 2;
>  	BUFFER_TRACE(dir_block, "call ext3_journal_dirty_metadata");
> -	ext3_journal_dirty_metadata(handle, dir_block);
> -	brelse (dir_block);
> -	ext3_mark_inode_dirty(handle, inode);
> -	err = ext3_add_entry (handle, dentry, inode);
> +	err = ext3_journal_dirty_metadata(handle, dir_block);
> +	if (err)
> +		goto out_clear_inode;
> +
> +	err = ext3_mark_inode_dirty(handle, inode);
> +	if (!err)
> +		err = ext3_add_entry (handle, dentry, inode);
> +
>  	if (err) {
> +out_clear_inode:
>  		inode->i_nlink = 0;
>  		unlock_new_inode(inode);
>  		ext3_mark_inode_dirty(handle, inode);
> @@ -1827,10 +1831,14 @@ retry:
>  	}
>  	inc_nlink(dir);
>  	ext3_update_dx_flag(dir);
> -	ext3_mark_inode_dirty(handle, dir);
> +	err = ext3_mark_inode_dirty(handle, dir);
> +	if (err)
> +		goto out_clear_inode;
> +
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  out_stop:
> +	brelse(dir_block);
>  	ext3_journal_stop(handle);
>  	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
>  		goto retry;
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
