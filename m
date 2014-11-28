From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v5 2/5] vfs: don't let the dirty time inodes get more
 than a day stale
Date: Fri, 28 Nov 2014 17:43:58 +0100
Message-ID: <20141128164358.GB738@quack.suse.cz>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
 <1417154411-5367-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417154411-5367-3-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 28-11-14 01:00:07, Ted Tso wrote:
> Guarantee that the on-disk timestamps will be no more than 24 hours
> stale.
  Why is this still necessary after what you do in patch 1/5?

								Honza
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/fs-writeback.c  |  1 +
>  fs/inode.c         | 20 ++++++++++++++++++++
>  include/linux/fs.h |  1 +
>  3 files changed, 22 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 518f3bb..15dec84 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1147,6 +1147,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
>  		trace_writeback_dirty_inode_start(inode, flags);
>  
> +		inode->i_ts_dirty_day = 0;
>  		if (sb->s_op->dirty_inode)
>  			sb->s_op->dirty_inode(inode, flags);
>  
> diff --git a/fs/inode.c b/fs/inode.c
> index 1ec0629..84a5a3d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1507,6 +1507,9 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>   */
>  static int update_time(struct inode *inode, struct timespec *time, int flags)
>  {
> +	struct timespec uptime;
> +	unsigned short days_since_boot;
> +
>  	if (inode->i_op->update_time)
>  		return inode->i_op->update_time(inode, time, flags);
>  
> @@ -1524,6 +1527,22 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
>  	    !(inode->i_state & I_DIRTY_WB)) {
>  		if (inode->i_state & I_DIRTY_TIME)
>  			return 0;
> +		get_monotonic_boottime(&uptime);
> +		days_since_boot = div_u64(uptime.tv_sec, 86400);
> +		/*
> +		 * If i_ts_dirty_day is zero, then either we have not
> +		 * deferred timestamp updates, or the system has been
> +		 * up for less than a day (so days_since_boot is
> +		 * zero), so we can defer timestamp updates in that
> +		 * case.  If a day or more has passed, then
> +		 * i_ts_dirty_day will be different from
> +		 * days_since_boot, and then we should update the
> +		 * on-disk inode and then we can clear i_ts_dirty_day.
> +		 */
> +		if (inode->i_ts_dirty_day &&
> +		    (inode->i_ts_dirty_day != days_since_boot))
> +			goto force_dirty;
> +
>  		spin_lock(&inode->i_lock);
>  		if (inode->i_state & I_DIRTY_WB) {
>  			spin_unlock(&inode->i_lock);
> @@ -1534,6 +1553,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
>  			return 0;
>  		}
>  		inode->i_state |= I_DIRTY_TIME;
> +		inode->i_ts_dirty_day = days_since_boot;
>  		spin_unlock(&inode->i_lock);
>  		inode_requeue_dirtytime(inode);
>  		return 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7932482..2b86b5d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -575,6 +575,7 @@ struct inode {
>  	struct timespec		i_ctime;
>  	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
>  	unsigned short          i_bytes;
> +	unsigned short		i_ts_dirty_day;
>  	unsigned int		i_blkbits;
>  	blkcnt_t		i_blocks;
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
