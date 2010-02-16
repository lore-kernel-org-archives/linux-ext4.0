From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: quota_write cross block boundary behaviour
Date: Tue, 16 Feb 2010 19:46:55 +0100
Message-ID: <20100216184654.GD3153@quack.suse.cz>
References: <1266338022-24298-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab0BPSqq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 13:46:46 -0500
Content-Disposition: inline
In-Reply-To: <1266338022-24298-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-02-10 19:33:41, Dmitry Monakhov wrote:
> We always assume what dquot update result in changes in one data block
> But ext4_quota_write() function may handle cross block boundary writes
> In fact if this ever happen it will result in incorrect journal credits
> reservation. And later bug_on triggering. As soon this never happen the
> boundary cross loop is NOOP. In order to make things straight
> let's remove this loop and assert cross boundary condition.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Yeah, originally I thought it might be useful to support a possibility of
multiblock writes but in the end we never needed it and currently e.g. OCFS2
would already BUG on that so yes, this is a good simplification.
  Acked-by: Jan Kara <jack@suse.cz>

  I've merged the ext3 version of the patch into my tree. Ted, will you
merge this ext4 cleanup please?

								Honza

> ---
>  fs/ext4/super.c |   69 +++++++++++++++++++++++++++----------------------------
>  1 files changed, 34 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9e45e62..d5596ca 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3940,9 +3940,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
>  	int err = 0;
>  	int offset = off & (sb->s_blocksize - 1);
> -	int tocopy;
>  	int journal_quota = EXT4_SB(sb)->s_qf_names[type] != NULL;
> -	size_t towrite = len;
>  	struct buffer_head *bh;
>  	handle_t *handle = journal_current_handle();
>  
> @@ -3952,52 +3950,53 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  			(unsigned long long)off, (unsigned long long)len);
>  		return -EIO;
>  	}
> +	/*
> +	 * Since we account only one data block in transaction credits,
> +	 * then it is impossible to cross a block boundary.
> +	 */
> +	if (sb->s_blocksize - offset < len) {
> +		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
> +			" cancelled because not block aligned",
> +			(unsigned long long)off, (unsigned long long)len);
> +		return -EIO;
> +	}
> +
>  	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
> -	while (towrite > 0) {
> -		tocopy = sb->s_blocksize - offset < towrite ?
> -				sb->s_blocksize - offset : towrite;
> -		bh = ext4_bread(handle, inode, blk, 1, &err);
> -		if (!bh)
> +	bh = ext4_bread(handle, inode, blk, 1, &err);
> +	if (!bh)
> +		goto out;
> +	if (journal_quota) {
> +		err = ext4_journal_get_write_access(handle, bh);
> +		if (err) {
> +			brelse(bh);
>  			goto out;
> -		if (journal_quota) {
> -			err = ext4_journal_get_write_access(handle, bh);
> -			if (err) {
> -				brelse(bh);
> -				goto out;
> -			}
>  		}
> -		lock_buffer(bh);
> -		memcpy(bh->b_data+offset, data, tocopy);
> -		flush_dcache_page(bh->b_page);
> -		unlock_buffer(bh);
> -		if (journal_quota)
> -			err = ext4_handle_dirty_metadata(handle, NULL, bh);
> -		else {
> -			/* Always do at least ordered writes for quotas */
> -			err = ext4_jbd2_file_inode(handle, inode);
> -			mark_buffer_dirty(bh);
> -		}
> -		brelse(bh);
> -		if (err)
> -			goto out;
> -		offset = 0;
> -		towrite -= tocopy;
> -		data += tocopy;
> -		blk++;
>  	}
> +	lock_buffer(bh);
> +	memcpy(bh->b_data+offset, data, len);
> +	flush_dcache_page(bh->b_page);
> +	unlock_buffer(bh);
> +	if (journal_quota)
> +		err = ext4_handle_dirty_metadata(handle, NULL, bh);
> +	else {
> +		/* Always do at least ordered writes for quotas */
> +		err = ext4_jbd2_file_inode(handle, inode);
> +		mark_buffer_dirty(bh);
> +	}
> +	brelse(bh);
>  out:
> -	if (len == towrite) {
> +	if (err) {
>  		mutex_unlock(&inode->i_mutex);
>  		return err;
>  	}
> -	if (inode->i_size < off+len-towrite) {
> -		i_size_write(inode, off+len-towrite);
> +	if (inode->i_size < off + len) {
> +		i_size_write(inode, off + len);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
>  	}
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
> -	return len - towrite;
> +	return len;
>  }
>  
>  #endif
> -- 
> 1.6.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
