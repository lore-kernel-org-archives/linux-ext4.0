From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Mon, 23 Aug 2010 16:59:47 -0600
Message-ID: <1BF88ED4-1B61-4D6C-BD84-D8D28931D2C6@dilger.ca>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com> <1282326704-14838-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16693 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0HWW7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2010 18:59:49 -0400
In-Reply-To: <1282326704-14838-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-20, at 11:51, Lukas Czerner wrote:
> When file system is mounted with "inititable" mount option, new thread
> (called itableinitd) is created. This thread walks through allocation
> groups searching for the group with not yet initialized inode table.
> When such a group is found it write zeroes through whole inode table and
> put itself into sleep for defined number of seconds to not disturb other
> ongoing I/O. This is repeated until it walks through every allocation group
> then the iitableinitd thread is stopped.

Eric and I were discussing this in IRC, and for SSDs and thinly-provisioned storage (including loopback files, VM images, etc) it makes sense to only write zeroes into itable blocks if they are not already zero.  Otherwise, the backing storage will allocate thousands/millions of blocks that might not otherwise be needed.  One of the original reasons for the mke2fs lazy_itable_init option was to allow testing of large filesystems with sparse loopback files smaller than the filesystem being tested.

Reading the itable blocks before writing zeroes into them wouldn't be much (if any) slower than writing them.  It might make sense to just have a binary toggle, so that if any non-zero blocks are read from the filesystem the rest of the blocks will be zeroed out (to avoid doubling the total IO needed).  This has the added advantage that reads from erased SSDs (which return zero on read, the only sane action IMHO) or loopback files never need to do any writes.

The drawback is that reading the blocks will potentially pollute the cache if done incorrectly, but this can be handled with O_DIRECT reads.  It would also increase the CPU usage during the single zeroing pass.

> When regular inode allocation are going too fast, there is a chance that
> it hits the group with uninitialized inode table sooner than the
> itableinitd thread. In that case it just initializes the itable for
> itself the same way that itableinitd thread would do eventually.

I think this is the correct approach.  It should only take a fraction of a second to zero the few MB in the itable being accessed, and is still much faster than waiting for mke2fs to zero all of them.

> To prevent race conditions, each group is protected by the mutex.

> +/* Get pointer to lazyinit thread mutex li_mtx for particular group */
> +static inline struct mutex *ext4_li_mutex_ptr(struct super_block *sb,
> +						      ext4_group_t group)
> +{
> +	return &EXT4_SB(sb)->s_li_info->li_mtx[group];
> +}

Note that even allocating a single pointer per group is too much on a very large filesystem.  At 1TB this is 8192 groups * 32 bytes/ptr = 256kB (struct mutex may be even larger if debug is enabled).  This will fail allocation.

There is already the per-group alloc_sem in ext4_group_info that could be used.  Yes, it would mean that itable zeroing can conflict with block allocation for that group, but I consider this a very low-probability event, since blocks are normally allocated from the group where the inode was allocated, and this lock is only held once in the lifetime of the filesystem.

> @@ -123,6 +123,11 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t +	if (!(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)) &&
> +	      ext4_itable_init_allowed(sb))
> +		ext4_init_inode_table(sb, block_group);

This should be marked "unlikely()" since it will only ever be true right after formatting.

> +/*
> + * Initializes an uninitialized inode table - just write zeroes through
> + * the whole inode table. Must be called without group spinlock. Since
> + * this is called from itableinitd thread as well as from ext4_new_inode
> + * there are mutexes in s_li_info to prevent race conditions.

This comment would need to be changed to reflect that the locks are not in s_li_info.

> Do not call
> + * this withou s_li_info uninitialized. It s_li_info is not initialized

Some typos here...  Should be:

"Do not call this with s_li_info uninitialized.  If s_li_info is not ..."

> + * user does not want to init inode tables, or they are already zeroed.

That said, it makes sense to allow this function to be called without the need
for s_li_info at all.  Consider the case of resizing a filesystem, this can be
used to zero out the inode table, instead of the much-less-efficient code in setup_new_group_blocks().  That code currently journals all of the itable blocks to handle crash recovery with a write cache, but with the improved barrier code that is no longer necessary.

> +extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group)
> +{
> +	BUG_ON(NULL == sbi->s_li_info);

It looks like s_li_info is only needed for the mutex, which is no longer needed, so this requirement can just be removed.

> +	if (sb->s_flags & MS_RDONLY) {
> +		ext4_warning(sb, "Filesystem mounter read only. "

s/mounter/mounted/

> +	handle = ext4_journal_start_sb(sb, 1);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		return ret;
> +	}
> +
> +	gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
> +	if (!gdp)
> +		return ret;
> +
> +	blk = ext4_inode_table(sb, gdp);
> +	num = sbi->s_itb_per_group - 1;
> +
> +	ext4_li_lock(sb, group);
> +	ext4_lock_group(sb, group);

It's generally a bad idea to start a journal handle and then grab blocking locks while holding the handle.  I always try to get all of the potential failure cases out of the way before starting the journal handle, so that the only way it can fail is because the journal was aborted or the IO fails.

There will also be additional lock ordering issues with ext4_group_info->alloc_sem and the journal.  It looks like alloc_sem is gotten after the journal handle in ext4_add_groupblocks(), but alloc_sem looks to be held BEFORE the journal handle in the mballoc code (AFAICS, it isn't totally clear from the code).

> +
> +	if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))) {
> +		BUFFER_TRACE(group_desc_bh, "get_write_access");
> +		ret = ext4_journal_get_write_access(handle,
> +						    group_desc_bh);
> +		if (ret)
> +			goto err_out;
> +
> +		ext4_unlock_group(sb, group);
> +		ret = sb_issue_zeroout(sb, blk, num);

Note that there is also ext4_ext_zeroout(), which is zeroing fallocate() chunks on disk in a slightly different manner (submit_bio() with a bio of a zeroed page).  It makes sense to have only a single mechanism for doing this, and of sb_issue_zeroout() is the right way to do that, ext4_ext_zeroout() should also be changed to use this.

> +static int ext4_lazyinit_thread(void *arg)
> +{
> +	spin_lock(&eli->li_state_lock);
> +	for (group = 0; group < ngroups; group++) {
> +
> +		if (eli->li_state & EXT4_LAZYINIT_QUIT)
> +			break;
> +
> +		gdp = ext4_get_group_desc(sb, group, NULL);
> +		if (!gdp)
> +			continue;
> +
> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
> +			continue;

For a very large filesystem, this may spin through a very large number of groups, so I wonder if it makes sense to yield the spinlock here.  That may not be needed if other "on demand" itable zeroing threads do not need to get li_state_lock, which then makes me wonder why this lock is needed if there are no other threads contending on it?

> +		ret = ext4_init_inode_table(sb, group);
> +		if (ret)
> +			goto exit_thread;

This can't call ext4_init_inode_table() with the spinlock held, since that is calling sleeping functions (journal start, disk IO, etc).

> +static int ext4_lazyinit_start_thread(struct ext4_li_info *eli)
> +{
> +	t = kthread_run(ext4_lazyinit_thread, eli, "itableinitd");

This name doesn't really tell an uninformed user what the thread is doing.  Something like "ext4init-08:01" or similar would tell the user that this thread is ext4-related, it is initializing something (granted, there isn't room to say it is zeroing the itable, but my hope is that this thread will also do other things like check the group descriptor checksums at startup also), and it is working on block device 08:01.

On that related note, it may make sense to handle the itable zeroing for all filesystems from a single thread, instead of possibly starting multiple threads all writing to the same block device and causing a lot of seeking.  That means that at thread startup time it should verify that only a single thread is started, and all registered filesystems should put their zeroing tasks onto a list (under spinlock) that the one thread checks before it exits.


> +static int ext4_has_uninit_itable(struct super_block *sb)
> +{
> +	ext4_group_t i, ngroups = EXT4_SB(sb)->s_groups_count;
> +	struct ext4_group_desc *gdp = NULL;
> +	int ret = 1;
> +
> +	for (i = 0; i < ngroups; i++) {
> +		gdp = ext4_get_group_desc(sb, i, NULL);
> +		if (!gdp)
> +			continue;
> +
> +		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
> +			goto has_uinit_itb;

By the time this scan is done, you may as well have started the thread to do the same scan.  That will avoid traversing up to 131072 groups for a 16TB filesystem twice, if the previous thread was interrupted near the end.

> +static void ext4_stop_lazyinit_thread(struct ext4_li_info *eli)
> +{
> +	eli->li_state |= EXT4_LAZYINIT_QUIT;
> +
> +	while (eli->li_task) {
> +		wake_up(&eli->li_wait_daemon);
> +		spin_unlock(&eli->li_state_lock);
> +		wait_event(eli->li_wait_task, eli->li_task == NULL);
> +		spin_lock(&eli->li_state_lock);
> +	}
> +}

This isn't very clear from a readability or usability standpoint.  A function shouldn't unlock a lock it didn't get.  It isn't really clear what the spinlock is needed for in this case?  It can't be needed to access "eli", otherwise the whole loop is unsafe.

> +	err = ext4_create_lazyinit_thread(sb);
> +	if (err)
> +		ext4_msg(sb, KERN_ERR, "failed to initalize itableinitd (%d)",
> +			 err);

This message shouldn't hard-code the name of the thread.  Maybe just write:

"failed to initialize inode table zeroing thread"

> @@ -3723,6 +3972,19 @@ static int ext4_remount(struct super_block *sb, int +	+	ext4_destroy_lazyinit_thread(sb);
> +	err = ext4_create_lazyinit_thread(sb);

Rather than killing the old thread and starting a new one (which will have to scan all of the groups again) it makes sense to just silently fail the startup of the new thread if one is already running.


Cheers, Andreas





