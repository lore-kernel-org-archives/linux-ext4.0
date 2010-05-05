From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [Bug 15906] serious performance regression in "umount" on ext4 over LVM
Date: Wed, 05 May 2010 13:06:45 +0400
Message-ID: <87d3xahg4a.fsf@openvz.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
	<201005050728.o457SHRn012045@demeter.kernel.org>
	<87ljbyhhxe.fsf@openvz.org> <20100505084056.GZ27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, chris.mason@oracle.com
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:36239 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab0EEJGu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 05:06:50 -0400
Received: by bwz25 with SMTP id 25so2779378bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 05 May 2010 02:06:47 -0700 (PDT)
In-Reply-To: <20100505084056.GZ27497@kernel.dk> (Jens Axboe's message of "Wed,
	5 May 2010 10:40:56 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, May 05 2010, Dmitry Monakhov wrote:
>> bugzilla-daemon@bugzilla.kernel.org writes:
>> 
>> Hi Jens,
>> 
>> Just FYI, we have found a regression which was caused by your famous
>> writeback patch 03ba3782e8dcc5b0e1efe440d33084f066e38cae
>> I'm not allowed to add you to CC in BZ, that's why i wrote this mail.
>
> You need to use axboe@kernel.dk as that is what I use there.
>
>> Before the patch __sync_filesystem() called writeback_single_inode()
>> directly, but now it is called indirectly (from flush-X:X task)
>> which require a super_block in question to be pinned.
>> But this is impossible to pin this SB on umount because we already
>> hold s_umount sem for write, so effectively we already pinned that SB.
>> So my proposal is to treat umount similar to WB_SYNC_ALL, and skip
>> pining stage.
>
> Hmm I see, yes that is a bug. How about adding a WB_SYNC_NONE_PINNED or
> something to that effect, which acts like WB_SYNC_NONE but the caller is
> required to hold the s_umount already (like WB_SYNC_ALL).
Yes, the core idea definitely looks better. Caller must know in what
conditions it submit work to flush task and umount is just one of such
'special' situations. BTW do we have writeback-subsystem maintainer who
is responsible to take care of that patch?
>
> Something like the below. It compiles, but not tested.
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 4b37f7c..4327465 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -245,19 +245,20 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
>   * @bdi: the backing device to write from
>   * @sb: write inodes from this super_block
>   * @nr_pages: the number of pages to write
> + * @sb_locked: caller already holds sb umount sem.
>   *
>   * Description:
>   *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
>   *   started when this function returns, we make no guarentees on
> - *   completion. Caller need not hold sb s_umount semaphore.
> + *   completion. Caller specifies whether sb umount sem is held already or not.
>   *
>   */
>  void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> -			 long nr_pages)
> +			 long nr_pages, int sb_locked)
>  {
>  	struct wb_writeback_args args = {
>  		.sb		= sb,
> -		.sync_mode	= WB_SYNC_NONE,
> +		.sync_mode	= sb_locked ? WB_SYNC_NONE_PIN : WB_SYNC_NONE,
>  		.nr_pages	= nr_pages,
>  		.range_cyclic	= 1,
>  	};
> @@ -577,7 +578,8 @@ static enum sb_pin_state pin_sb_for_writeback(struct writeback_control *wbc,
>  	/*
>  	 * Caller must already hold the ref for this
>  	 */
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> +	if (wbc->sync_mode == WB_SYNC_ALL ||
> +	    wbc->sync_mode == WB_SYNC_NONE_PIN) {
>  		WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  		return SB_NOT_PINNED;
>  	}
> @@ -1183,6 +1185,18 @@ static void wait_sb_inodes(struct super_block *sb)
>  	iput(old_inode);
>  }
>  
> +static void __writeback_inodes_sb(struct super_block *sb, int sb_locked)
> +{
> +	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
> +	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> +	long nr_to_write;
> +
> +	nr_to_write = nr_dirty + nr_unstable +
> +			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +
> +	bdi_start_writeback(sb->s_bdi, sb, nr_to_write, sb_locked);
> +}
> +
>  /**
>   * writeback_inodes_sb	-	writeback dirty inodes from given super_block
>   * @sb: the superblock
> @@ -1194,18 +1208,23 @@ static void wait_sb_inodes(struct super_block *sb)
>   */
>  void writeback_inodes_sb(struct super_block *sb)
>  {
> -	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
> -	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> -	long nr_to_write;
> -
> -	nr_to_write = nr_dirty + nr_unstable +
> -			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> -
> -	bdi_start_writeback(sb->s_bdi, sb, nr_to_write);
> +	__writeback_inodes_sb(sb, 0);
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb);
>  
>  /**
> + * writeback_inodes_sb_locked	- writeback dirty inodes from given super_block
> + * @sb: the superblock
> + *
> + * Like writeback_inodes_sb(), except the caller already holds the
> + * sb umount sem.
> + */
> +void writeback_inodes_sb_locked(struct super_block *sb)
> +{
> +	__writeback_inodes_sb(sb, 1);
> +}
> +
> +/**
>   * writeback_inodes_sb_if_idle	-	start writeback if none underway
>   * @sb: the superblock
>   *
> diff --git a/fs/sync.c b/fs/sync.c
> index 92b2281..de6a441 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -42,7 +42,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
>  	if (wait)
>  		sync_inodes_sb(sb);
>  	else
> -		writeback_inodes_sb(sb);
> +		writeback_inodes_sb_locked(sb);
>  
>  	if (sb->s_op->sync_fs)
>  		sb->s_op->sync_fs(sb, wait);
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index bd0e3c6..90e677a 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -103,7 +103,7 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
>  void bdi_unregister(struct backing_dev_info *bdi);
>  int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
>  void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
> -				long nr_pages);
> +				long nr_pages, int sb_locked);
>  int bdi_writeback_task(struct bdi_writeback *wb);
>  int bdi_has_dirty_io(struct backing_dev_info *bdi);
>  
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 36520de..3cd39b0 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -19,6 +19,7 @@ extern struct list_head inode_unused;
>  enum writeback_sync_modes {
>  	WB_SYNC_NONE,	/* Don't wait on anything */
>  	WB_SYNC_ALL,	/* Wait on every mapping */
> +	WB_SYNC_NONE_PIN,	/* Like WB_SYNC_NONE, but s_umount held */
>  };
>  
>  /*
> @@ -73,6 +74,7 @@ struct writeback_control {
>  struct bdi_writeback;
>  int inode_wait(void *);
>  void writeback_inodes_sb(struct super_block *);
> +void writeback_inodes_sb_locked(struct super_block *);
>  int writeback_inodes_sb_if_idle(struct super_block *);
>  void sync_inodes_sb(struct super_block *);
>  void writeback_inodes_wbc(struct writeback_control *wbc);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0b19943..49d3508 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -597,7 +597,7 @@ static void balance_dirty_pages(struct address_space *mapping,
>  	    (!laptop_mode && ((global_page_state(NR_FILE_DIRTY)
>  			       + global_page_state(NR_UNSTABLE_NFS))
>  					  > background_thresh)))
> -		bdi_start_writeback(bdi, NULL, 0);
> +		bdi_start_writeback(bdi, NULL, 0, 0);
>  }
>  
>  void set_page_dirty_balance(struct page *page, int page_mkwrite)
