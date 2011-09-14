From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/3] VFS: Fix s_umount thaw/write deadlock
Date: Wed, 14 Sep 2011 16:00:47 +0200
Message-ID: <20110914140047.GB7903@quack.suse.cz>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
 <CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1INOAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 10:00:48 -0400
Content-Disposition: inline
In-Reply-To: <CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-09-11 19:57:11, Valerie Aurora wrote:
> Val, if you are sending patches as attachments, make them at least
> text/plain please!
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 04cf3b9..d1dca03 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -537,6 +537,9 @@ static long writeback_sb_inodes(struct super_block *sb,
>  	long write_chunk;
>  	long wrote = 0;  /* count both pages and inodes */
>  
> +	if (vfs_is_frozen(sb))
> +		return 0;
> +
  Umm, maybe we could make this more robust by skipping the superblock in
__writeback_inodes_wb() and just explicitely stopping the writeback when
work->sb is set (i.e. writeback is required only for frozen sb) in
wb_writeback()?

>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
>  
> @@ -1238,39 +1241,43 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   * writeback_inodes_sb_if_idle	-	start writeback if none underway
>   * @sb: the superblock
>   *
> - * Invoke writeback_inodes_sb if no writeback is currently underway.
> - * Returns 1 if writeback was started, 0 if not.
> + * Invoke writeback_inodes_sb if no writeback is currently underway
> + * and no one else holds the s_umount lock.  Returns 1 if writeback
> + * was started, 0 if not.
>   */
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +		if (down_read_trylock(&sb->s_umount)) {
  What's exactly the deadlock trylock protects from here? Or is it just an
optimization?

> +			writeback_inodes_sb(sb);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>  
>  /**
> - * writeback_inodes_sb_if_idle	-	start writeback if none underway
> + * writeback_inodes_sb_nr_if_idle	-	start writeback if none underway
>   * @sb: the superblock
>   * @nr: the number of pages to write
>   *
> - * Invoke writeback_inodes_sb if no writeback is currently underway.
> - * Returns 1 if writeback was started, 0 if not.
> + * Invoke writeback_inodes_sb if no writeback is currently underway
> + * and no one else holds the s_umount lock.  Returns 1 if writeback
> + * was started, 0 if not.
>   */
>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>  				   unsigned long nr)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +		if (down_read_trylock(&sb->s_umount)) {
  The same question here...

> +			writeback_inodes_sb_nr(sb, nr);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}
> +	return 0;
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>  
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index b34bdb2..993ce22 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -366,6 +366,18 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
>  	if (IS_ERR(sb))
>  		return PTR_ERR(sb);
>  
> +	/*
> +	 * It's not clear which quota functions may write to the file
> +	 * system (all?).  Check for a frozen fs and bail out now.
> +	 */
> +	if (vfs_is_frozen(sb)) {
> +		drop_super(sb);
> +		/* XXX Should quotactl_block() error path do this too? */
  Yes, it does. Thanks for spotting this.

> +		if (pathp && !IS_ERR(pathp))
> +			path_put(pathp);
> +		return -EBUSY;
> +	}
> +
>  	ret = do_quotactl(sb, type, cmds, id, addr, pathp);
>  
>  	drop_super(sb);
...
> diff --git a/fs/sync.c b/fs/sync.c
> index c98a747..db15b11 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -68,7 +68,7 @@ int sync_filesystem(struct super_block *sb)
>  	/*
>  	 * No point in syncing out anything if the filesystem is read-only.
>  	 */
> -	if (sb->s_flags & MS_RDONLY)
> +	if ((sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
                                      ^^^^
The check should be: (sb->s_flags & MS_RDONLY || vfs_is_frozen(sb))

>  		return 0;
>  
>  	ret = __sync_filesystem(sb, 0);

									Honza
--...
Jan Kara <jack@suse.cz>
SUSE Labs, CR
