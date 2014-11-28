From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
Date: Fri, 28 Nov 2014 18:23:23 +0100
Message-ID: <20141128172323.GD738@quack.suse.cz>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
 <1417154411-5367-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaK1RbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 12:31:05 -0500
Content-Disposition: inline
In-Reply-To: <1417154411-5367-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-11-14 01:00:06, Ted Tso wrote:
> Add a new mount option which enables a new "lazytime" mode.  This mode
> causes atime, mtime, and ctime updates to only be made to the
> in-memory version of the inode.  The on-disk times will only get
> updated when (a) if the inode needs to be updated for some non-time
> related change, (b) if userspace calls fsync(), syncfs() or sync(), or
> (c) just before an undeleted inode is evicted from memory.
> 
> This is OK according to POSIX because there are no guarantees after a
> crash unless userspace explicitly requests via a fsync(2) call.
> 
> For workloads which feature a large number of random write to a
> preallocated file, the lazytime mount option significantly reduces
> writes to the inode table.  The repeated 4k writes to a single block
> will result in undesirable stress on flash devices and SMR disk
> drives.  Even on conventional HDD's, the repeated writes to the inode
> table block will trigger Adjacent Track Interference (ATI) remediation
> latencies, which very negatively impact 99.9 percentile latencies ---
> which is a very big deal for web serving tiers (for example).
> 
> Google-Bug-Id: 18297052
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/fs-writeback.c           | 64 ++++++++++++++++++++++++++++++++++++++++-----
>  fs/inode.c                  | 41 ++++++++++++++++++++++++-----
>  fs/libfs.c                  |  2 +-
>  fs/logfs/readwrite.c        |  2 +-
>  fs/nfsd/vfs.c               |  2 +-
>  fs/pipe.c                   |  2 +-
>  fs/proc_namespace.c         |  1 +
>  fs/sync.c                   |  8 ++++++
>  fs/ufs/truncate.c           |  2 +-
>  include/linux/backing-dev.h |  1 +
>  include/linux/fs.h          | 11 ++++++--
>  include/uapi/linux/fs.h     |  1 +
>  mm/backing-dev.c            | 10 +++++--
>  13 files changed, 126 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ef9bef1..518f3bb 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -397,7 +397,7 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
>  	 * shot. If still dirty, it will be redirty_tail()'ed below.  Update
>  	 * the dirty time to prevent enqueue and sync it again.
>  	 */
> -	if ((inode->i_state & I_DIRTY) &&
> +	if ((inode->i_state & I_DIRTY_WB) &&
>  	    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
>  		inode->dirtied_when = jiffies;
>  
> @@ -428,13 +428,15 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
>  			 */
>  			redirty_tail(inode, wb);
>  		}
> -	} else if (inode->i_state & I_DIRTY) {
> +	} else if (inode->i_state & I_DIRTY_WB) {
>  		/*
>  		 * Filesystems can dirty the inode during writeback operations,
>  		 * such as delayed allocation during submission or metadata
>  		 * updates after data IO completion.
>  		 */
>  		redirty_tail(inode, wb);
> +	} else if (inode->i_state & I_DIRTY_TIME) {
> +		list_move(&inode->i_wb_list, &wb->b_dirty_time);
>  	} else {
>  		/* The inode is clean. Remove from writeback lists. */
>  		list_del_init(&inode->i_wb_list);
> @@ -482,11 +484,15 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
>  	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		inode->i_state &= ~I_DIRTY_PAGES;
> -	dirty = inode->i_state & I_DIRTY;
> -	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> +	dirty = inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> +	if (dirty && (inode->i_state & I_DIRTY_TIME))
> +		dirty |= I_DIRTY_TIME;
> +	inode->i_state &= ~dirty;
>  	spin_unlock(&inode->i_lock);
> +	if (dirty & I_DIRTY_TIME)
> +		mark_inode_dirty_sync(inode);
Hum, when someone calls fsync() for an inode, you likely want to sync
timestamps to disk even if everything else is clean. I think that doing
what you did in last version:
	dirty = inode->i_state & I_DIRTY_INODE;
	inode->i_state &= ~I_DIRTY_INODE;
	spin_unlock(&inode->i_lock);
	if (dirty & I_DIRTY_TIME)
		mark_inode_dirty_sync(inode);
looks better to me. IMO when someone calls __writeback_single_inode() we
should write whatever we have...

>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
> -	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
> +	if (dirty) {
>  		int err = write_inode(inode, wbc);
>  		if (ret == 0)
>  			ret = err;
> @@ -1162,7 +1168,11 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  
>  	spin_lock(&inode->i_lock);
>  	if ((inode->i_state & flags) != flags) {
> -		const int was_dirty = inode->i_state & I_DIRTY;
> +		const int was_dirty = inode->i_state & I_DIRTY_WB;
> +
> +		if ((flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) &&
> +		    (inode->i_state & I_DIRTY_TIME))
> +			inode->i_state &= ~I_DIRTY_TIME;
>  
>  		inode->i_state |= flags;
>  
> @@ -1224,6 +1234,24 @@ out_unlock_inode:
>  }
>  EXPORT_SYMBOL(__mark_inode_dirty);
>  
> +void inode_requeue_dirtytime(struct inode *inode)
> +{
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> +
> +	spin_lock(&bdi->wb.list_lock);
> +	spin_lock(&inode->i_lock);
> +	if ((inode->i_state & I_DIRTY_WB) == 0) {
> +		if (inode->i_state & I_DIRTY_TIME)
> +			list_move(&inode->i_wb_list, &bdi->wb.b_dirty_time);
> +		else
> +			list_del_init(&inode->i_wb_list);
> +	}
> +	spin_unlock(&inode->i_lock);
> +	spin_unlock(&bdi->wb.list_lock);
> +
> +}
> +EXPORT_SYMBOL(inode_requeue_dirtytime);
> +
  This function has a single call site - update_time(). I'd prefer to
handle this as a special case of __mark_inode_dirty() to have all the dirty
queueing in one place...

>  static void wait_sb_inodes(struct super_block *sb)
>  {
>  	struct inode *inode, *old_inode = NULL;
> @@ -1277,6 +1305,29 @@ static void wait_sb_inodes(struct super_block *sb)
>  	iput(old_inode);
>  }
>  
> +/*
> + * Take all of the indoes on the dirty_time list, and mark them as
> + * dirty, so they will be written out.
> + */
> +static void flush_sb_dirty_time(struct super_block *sb)
> +{
> +	struct bdi_writeback *wb = &sb->s_bdi->wb;
> +	LIST_HEAD(tmp);
> +
> +	spin_lock(&wb->list_lock);
> +	list_cut_position(&tmp, &wb->b_dirty_time, wb->b_dirty_time.prev);
> +	while (!list_empty(&tmp)) {
> +		struct inode *inode = wb_inode(tmp.prev);
> +
> +		list_del_init(&inode->i_wb_list);
> +		spin_unlock(&wb->list_lock);
> +		if (inode->i_state & I_DIRTY_TIME)
> +			mark_inode_dirty_sync(inode);
> +		spin_lock(&wb->list_lock);
> +	}
> +	spin_unlock(&wb->list_lock);
> +}
> +
  This shouldn't be necessary when you somewhat tweak what you do in
queue_io().

>  /**
>   * writeback_inodes_sb_nr -	writeback dirty inodes from given super_block
>   * @sb: the superblock
> @@ -1388,6 +1439,7 @@ void sync_inodes_sb(struct super_block *sb)
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> +	flush_sb_dirty_time(sb);
>  	bdi_queue_work(sb->s_bdi, &work);
>  	wait_for_completion(&done);
>  
> diff --git a/fs/inode.c b/fs/inode.c
> index 26753ba..1ec0629 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -30,7 +30,7 @@
>   * inode_sb_list_lock protects:
>   *   sb->s_inodes, inode->i_sb_list
>   * bdi->wb.list_lock protects:
> - *   bdi->wb.b_{dirty,io,more_io}, inode->i_wb_list
> + *   bdi->wb.b_{dirty,io,more_io,dirty_time}, inode->i_wb_list
>   * inode_hash_lock protects:
>   *   inode_hashtable, inode->i_hash
>   *
> @@ -1430,11 +1430,19 @@ static void iput_final(struct inode *inode)
>   */
>  void iput(struct inode *inode)
>  {
> -	if (inode) {
> -		BUG_ON(inode->i_state & I_CLEAR);
> -
> -		if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
> -			iput_final(inode);
> +	if (!inode)
> +		return;
> +	BUG_ON(inode->i_state & I_CLEAR);
> +retry:
> +	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
> +		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> +			atomic_inc(&inode->i_count);
> +			inode->i_state &= ~I_DIRTY_TIME;
> +			spin_unlock(&inode->i_lock);
> +			mark_inode_dirty_sync(inode);
> +			goto retry;
> +		}
> +		iput_final(inode);
  How about my suggestion from previous version to avoid the retry loop by
checking I_DIRTY_TIME before atomic_dec_and_lock()?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
