From: Dmitri Monakhov <dmonakhov@sw.ru>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 25 Jan 2008 15:18:51 +0300
Message-ID: <20080125121851.GA3361@dmon-lap.sw.ru>
References: <20080125195938t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31083 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYAYMUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 07:20:21 -0500
Content-Disposition: inline
In-Reply-To: <20080125195938t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 19:59 Fri 25 Jan     , Takashi Sato wrote:
> Hi,
> 
> Currently, ext3 doesn't have the freeze feature which suspends write
> requests.  So, we cannot get a backup which keeps the filesystem's
> consistency with the storage device's features (snapshot, replication)
> while it is mounted.
> In many case, a commercial filesystems (e.g. VxFS) has the freeze
> feature and it would be used to get the consistent backup.
First of all Linux already have at least one open-source(dm-snap),
and several commercial snapshot solutions. In fact dm-snaps it
not perfect:
a) bit map loading is not supported (this is useful for freezing 
   only used blocks) which causing significant  slowdown even for new writes
b) non patched dm-snap code has significant performance slowdown for all 
   rewrite requests. 
c) IMHO memory footprint is too big.

BUT, it works well for most file-systems.
> 
> So I am planning on implementing the ioctl of the freeze feature for ext3.
> I think we can get the consistent backup with the following steps.
> 1. Freeze the filesystem with ioctl.
So you plan to do it from userspace.. well good luck with it :)

> 2. Separate the replication volume or get the snapshot
>    with the storage device's feature.
> 3. Unfreeze the filesystem with ioctl.

You have to realize what delay between 1-3 stages have to be minimal.
for example dm-snap perform it only for explicit journal flushing.
>From my experience if delay is more than 4-5 seconds whole system becomes
unstable.
BTW: you have to always remember that while locking ext3 via freeze_bdev
 sb->ext3_write_super_lockfs() will be called wich implemented as "simple"
journal lock. This means what some bio-s still may reach original device
even after file system was locked (i've observed this in real life 
situation).

> 4. Get the backup from the separated replication volume
>    or the snapshot.
> 
> The usage of the ioctl is as below.
>  int ioctl(int fd, int cmd, long *timeval)
>  fd: The file descriptor of the mountpoint.
>  cmd: EXT3_IOC_FREEZE for the freeze or EXT3_IOC_THAW for the unfreeze.
>  timeval: The timeout value expressed in seconds.
>           If it's 0, the timeout isn't set.
>  Return value: 0 if the operation succeeds. Otherwise, -1.
> 
> I have made sure that write requests were suspended with the experimental
> patch for this feature and attached it in this mail.
> 
> The points of the implementation are followings.
> - Add calls of the freeze function (freeze_bdev) and
>   the unfreeze function (thaw_bdev) in ext3_ioctl().
> 
> - ext3_freeze_timeout() which calls the unfreeze function (thaw_bdev)
>   is registered to the delayed work queue to unfreeze the filesystem
>   automatically after the lapse of the specified time.
> 
> Any comments are very welcome.
> 
> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> ---
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/fs/ext3/ioctl.c linux-2.6.24-rc8-freeze/fs/ext3/ioctl.c
> --- linux-2.6.24-rc8/fs/ext3/ioctl.c	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/fs/ext3/ioctl.c	2008-01-22 18:20:33.000000000 +0900
> @@ -254,6 +254,42 @@ flags_err:
>  		return err;
>  	}
>  
> +	case EXT3_IOC_FREEZE: {
> +		long timeout_sec;
> +		long timeout_msec;
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		if (inode->i_sb->s_frozen != SB_UNFROZEN)

> +			return -EINVAL
WOW timeout extending is not supported !?
So you wanna say what caller have to set timer to the maximal possible
timeout from the very beginning.
IMHO it is better to use heart-beat timer approach, for example:
each second caller extend it's timeout for two seconds. in this approach
even after caller was killed by any reason, it's timeout will be expired in
two seconds.
 
		if (inode->i_sb->s_frozen == SB_FROZEN)
			/* extending timeout */
			...... 


> +		/* arg(sec) to tick value */
> +		get_user(timeout_sec, (long __user *) arg);
> +		timeout_msec = timeout_sec * 1000;
> +		if (timeout_msec < 0)
> +			return -EINVAL;
> +
> +		/* Freeze */
> +		freeze_bdev(inode->i_sb->s_bdev);
> +
> +		/* set up unfreeze timer */
> +		if (timeout_msec > 0)
> +			ext3_add_freeze_timeout(EXT3_SB(inode->i_sb),
> +						timeout_msec);
> +		return 0;
> +	}
> +	case EXT3_IOC_THAW: {
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		if (inode->i_sb->s_frozen == SB_UNFROZEN)
> +			return -EINVAL;
> +
> +		/* delete unfreeze timer */
> +		ext3_del_freeze_timeout(EXT3_SB(inode->i_sb));
> +
> +		/* Unfreeze */
> +		thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
> +
> +		return 0;
> +	}
>  
>  	default:
>  		return -ENOTTY;
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/fs/ext3/super.c linux-2.6.24-rc8-freeze/fs/ext3/super.c
> --- linux-2.6.24-rc8/fs/ext3/super.c	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/fs/ext3/super.c	2008-01-22 18:20:33.000000000 +0900
> @@ -63,6 +63,7 @@ static int ext3_statfs (struct dentry * 
>  static void ext3_unlockfs(struct super_block *sb);
>  static void ext3_write_super (struct super_block * sb);
>  static void ext3_write_super_lockfs(struct super_block *sb);
> +static void ext3_freeze_timeout(struct work_struct *work);
>  
>  /*
>   * Wrappers for journal_start/end.
> @@ -323,6 +324,44 @@ void ext3_update_dynamic_rev(struct supe
>  }
>  
>  /*
> + * ext3_add_freeze_timeout - Add timeout for ext3 freeze.
> + *
> + * @sbi			: ext3 super block
> + * @timeout_msec	: timeout period
> + *
> + * Add the delayed work for ext3 freeze timeout
> + * to the delayed work queue.
> + */
> +void ext3_add_freeze_timeout(struct ext3_sb_info *sbi,
> +			long timeout_msec)
> +{
> +	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
> +
> +	/*
> +	 * setup freeze timeout function
> +	 */
> +	INIT_DELAYED_WORK(&sbi->s_freeze_timeout, ext3_freeze_timeout);
> +
> +	/* set delayed work queue */
> +	cancel_delayed_work(&sbi->s_freeze_timeout);
> +	schedule_delayed_work(&sbi->s_freeze_timeout, timeout_jiffies);
> +}
> +
> +/*
> + * ext3_del_freeze_timeout - Delete timeout for ext3 freeze.
> + *
> + * @sbi	: ext3 super block
> + *
> + * Delete the delayed work for ext3 freeze timeout
> + * from the delayed work queue.
> + */
> +void ext3_del_freeze_timeout(struct ext3_sb_info *sbi)
> +{
> +	if (delayed_work_pending(&sbi->s_freeze_timeout))
> +		cancel_delayed_work(&sbi->s_freeze_timeout);
> +}
> +
> +/*
>   * Open the external journal device
>   */
>  static struct block_device *ext3_blkdev_get(dev_t dev)
> @@ -2367,10 +2406,31 @@ static void ext3_unlockfs(struct super_b
>  		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
>  		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
>  		unlock_super(sb);
> -		journal_unlock_updates(EXT3_SB(sb)->s_journal);
> +		journal_unlock_updates_if_needed(EXT3_SB(sb)->s_journal);
>  	}
>  }
>  
> +/*
> + * ext3_freeze_timeout - Thaw the filesystem.
> + *
> + * @work	: work queue (delayed_work.work)
> + *
> + * Called by the delayed work when elapsing the timeout period.
> + * Thaw the filesystem.
> + */
> +static void ext3_freeze_timeout(struct work_struct *work)
> +{
> +	struct ext3_sb_info *sbi = container_of(work,
> +				struct ext3_sb_info,
> +				s_freeze_timeout.work);
> +	struct super_block *sb = get_super_block(sbi);
> +
> +	BUG_ON(sb == NULL);
> +
> +	if (sb->s_frozen != SB_UNFROZEN)
> +		thaw_bdev(sb->s_bdev, sb);
> +}
> +
>  static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  {
>  	struct ext3_super_block * es;
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/fs/jbd/journal.c linux-2.6.24-rc8-freeze/fs/jbd/journal.c
> --- linux-2.6.24-rc8/fs/jbd/journal.c	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/fs/jbd/journal.c	2008-01-22 18:20:33.000000000 +0900
> @@ -46,6 +46,7 @@ EXPORT_SYMBOL(journal_extend);
>  EXPORT_SYMBOL(journal_stop);
>  EXPORT_SYMBOL(journal_lock_updates);
>  EXPORT_SYMBOL(journal_unlock_updates);
> +EXPORT_SYMBOL(journal_unlock_updates_if_needed);
>  EXPORT_SYMBOL(journal_get_write_access);
>  EXPORT_SYMBOL(journal_get_create_access);
>  EXPORT_SYMBOL(journal_get_undo_access);
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/fs/jbd/transaction.c linux-2.6.24-rc8-freeze/fs/jbd/transaction.c
> --- linux-2.6.24-rc8/fs/jbd/transaction.c	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/fs/jbd/transaction.c	2008-01-22 18:20:33.000000000 +0900
> @@ -485,6 +485,29 @@ void journal_unlock_updates (journal_t *
>  	wake_up(&journal->j_wait_transaction_locked);
>  }
>  
> +/**
> + * journal_unlock_updates_if_needed	 - release barrier if needed.
> + *
> + * @journal:  Journal to release the barrier on.
> + *
> + * Release a transaction barrier obtained if barrier count is not 0.
> + * Should be called without the journal lock held.
> + */
> +void journal_unlock_updates_if_needed(journal_t *journal)
> +{
> +	spin_lock(&journal->j_state_lock);
> +
> +	if (!journal->j_barrier_count) {
> +		spin_unlock(&journal->j_state_lock);
> +		return;
> +	}
> +
> +	--journal->j_barrier_count;
> +	spin_unlock(&journal->j_state_lock);
> +	mutex_unlock(&journal->j_barrier);
> +	wake_up(&journal->j_wait_transaction_locked);
> +}
> +
>  /*
>   * Report any unexpected dirty buffers which turn up.  Normally those
>   * indicate an error, but they can occur if the user is running (say)
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/fs/super.c linux-2.6.24-rc8-freeze/fs/super.c
> --- linux-2.6.24-rc8/fs/super.c	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/fs/super.c	2008-01-22 18:20:33.000000000 +0900
> @@ -950,3 +950,30 @@ struct vfsmount *kern_mount_data(struct 
>  }
>  
>  EXPORT_SYMBOL_GPL(kern_mount_data);
> +
> +/**
> + * get_super_block - get super_block
> + * @s_fs_info	: filesystem dependent information
> + * 		  (super_block.s_fs_info)
> + *
> + * Get super_block which holds s_fs_info from super_blocks.
> + * get_super_block() returns a pointer of super block or
> + * %NULL if it have failed.
> + */
> +struct super_block *get_super_block(void *s_fs_info)
> +{
> +	struct super_block *sb;
> +
> +	spin_lock(&sb_lock);
> +	sb = sb_entry(super_blocks.prev);
> +	for (; sb != sb_entry(&super_blocks);
> +				sb = sb_entry(sb->s_list.prev)) {
> +		if (sb->s_fs_info == s_fs_info) {
> +			spin_unlock(&sb_lock);
> +			return sb;
> +		}
> +	}
> +	spin_unlock(&sb_lock);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(get_super_block);
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/include/linux/ext3_fs.h linux-2.6.24-rc8-freeze/include/linux/ext3_fs.h
> --- linux-2.6.24-rc8/include/linux/ext3_fs.h	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/include/linux/ext3_fs.h	2008-01-22 18:20:33.000000000 +0900
> @@ -225,6 +225,8 @@ struct ext3_new_group_data {
>  #endif
>  #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
>  #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
> +#define EXT3_IOC_FREEZE			_IOW('f', 9, long)
> +#define EXT3_IOC_THAW			_IOW('f', 10, long)
>  
>  /*
>   * ioctl commands in 32 bit emulation
> @@ -864,6 +866,9 @@ extern void ext3_abort (struct super_blo
>  extern void ext3_warning (struct super_block *, const char *, const char *, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  extern void ext3_update_dynamic_rev (struct super_block *sb);
> +extern void ext3_add_freeze_timeout(struct ext3_sb_info *sbi,
> +			long timeout_msec);
> +extern void ext3_del_freeze_timeout(struct ext3_sb_info *sbi);
>  
>  #define ext3_std_error(sb, errno)				\
>  do {								\
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/include/linux/ext3_fs_sb.h linux-2.6.24-rc8-freeze/include/linux/ext3_fs_sb.h
> --- linux-2.6.24-rc8/include/linux/ext3_fs_sb.h	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/include/linux/ext3_fs_sb.h	2008-01-22 18:20:33.000000000 +0900
> @@ -81,6 +81,8 @@ struct ext3_sb_info {
>  	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
>  	int s_jquota_fmt;			/* Format of quota to use */
>  #endif
> +	/* Delayed work for freeze */
> +	struct delayed_work s_freeze_timeout;
>  };
>  
>  #endif	/* _LINUX_EXT3_FS_SB */
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/include/linux/fs.h linux-2.6.24-rc8-freeze/include/linux/fs.h
> --- linux-2.6.24-rc8/include/linux/fs.h	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/include/linux/fs.h	2008-01-22 18:20:33.000000000 +0900
> @@ -2095,6 +2095,7 @@ struct ctl_table;
>  int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
>  		  void __user *buffer, size_t *lenp, loff_t *ppos);
>  
> +extern struct super_block *get_super_block(void *s_fs_info);
>  
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_FS_H */
> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/include/linux/jbd.h linux-2.6.24-rc8-freeze/include/linux/jbd.h
> --- linux-2.6.24-rc8/include/linux/jbd.h	2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/include/linux/jbd.h	2008-01-22 18:20:33.000000000 +0900
> @@ -905,6 +905,7 @@ extern int	 journal_stop(handle_t *);
>  extern int	 journal_flush (journal_t *);
>  extern void	 journal_lock_updates (journal_t *);
>  extern void	 journal_unlock_updates (journal_t *);
> +extern void	 journal_unlock_updates_if_needed(journal_t *);
>  
>  extern journal_t * journal_init_dev(struct block_device *bdev,
>  				struct block_device *fs_dev,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
