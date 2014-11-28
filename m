From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] vfs: use writeback lists to provide lazytime one day
 timeout
Date: Fri, 28 Nov 2014 18:20:46 +0100
Message-ID: <20141128172046.GC738@quack.suse.cz>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
 <1417154411-5367-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaK1RUv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 12:20:51 -0500
Content-Disposition: inline
In-Reply-To: <1417154411-5367-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-11-14 01:00:08, Ted Tso wrote:
> Queue inodes with dirty timestamps for writeback 24 hours after they
> were initially dirtied.
  Oh I see, this patch should probably replace the other 2/5 patch.

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/fs-writeback.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3d562e2..bd76590 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -253,7 +253,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
>   */
>  static int move_expired_inodes(struct list_head *delaying_queue,
>  			       struct list_head *dispatch_queue,
> -			       struct wb_writeback_work *work)
> +			       unsigned long *older_than_this)
>  {
>  	LIST_HEAD(tmp);
>  	struct list_head *pos, *node;
> @@ -264,8 +264,8 @@ static int move_expired_inodes(struct list_head *delaying_queue,
>  
>  	while (!list_empty(delaying_queue)) {
>  		inode = wb_inode(delaying_queue->prev);
> -		if (work->older_than_this &&
> -		    inode_dirtied_after(inode, *work->older_than_this))
> +		if (older_than_this &&
> +		    inode_dirtied_after(inode, *older_than_this))
>  			break;
>  		list_move(&inode->i_wb_list, &tmp);
>  		moved++;
> @@ -309,9 +309,14 @@ out:
>  static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	int moved;
> +	unsigned long one_day_later = jiffies + (HZ * 86400);
> +
>  	assert_spin_locked(&wb->list_lock);
>  	list_splice_init(&wb->b_more_io, &wb->b_io);
> -	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, work);
> +	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io,
> +				    work->older_than_this);
> +	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
> +				     &one_day_later);
  I'd change this to:
	if (work->sync_mode == WB_SYNC_ALL) {
		moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
					     work->older_than_this);
	} else {
		moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
					     &one_day_later);
	}
  That way you can get rid of special sync handling. Also just fold this
patch into 1/5...


>  	trace_writeback_queue_io(wb, work, moved);
>  }
>  
> @@ -679,6 +684,17 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		inode->i_state |= I_SYNC;
>  		spin_unlock(&inode->i_lock);
>  
> +		/*
> +		 * If the inode is marked dirty time but is not dirty,
> +		 * then at last for ext3 and ext4 we need to call
> +		 * mark_inode_dirty_sync in order to get the inode
> +		 * timestamp transferred to the on disk inode, since
> +		 * write_inode is a no-op for those file systems.
> +		 */
> +		if ((inode->i_state & I_DIRTY_TIME) &&
> +		    ((inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) == 0))
> +			mark_inode_dirty_sync(inode);
> +
  This isn't necessary - you already handle this in
__writeback_single_inode(). Or am I missing something?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
