From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Mon, 20 Apr 2015 14:25:32 +0200
Message-ID: <20150420122532.GF3117@quack.suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
 <1429198977-5637-3-git-send-email-jack@suse.cz>
 <056F4994-DF7C-4780-A3BD-C2A818BEEE45@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbbDTMZh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 08:25:37 -0400
Content-Disposition: inline
In-Reply-To: <056F4994-DF7C-4780-A3BD-C2A818BEEE45@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 17-04-15 17:53:03, Andreas Dilger wrote:
> On Apr 16, 2015, at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > Ext4 orphan inode handling is a bottleneck for workloads which heavily
> > truncate / unlink small files since it contends on the global
> > s_orphan_mutex lock (and generally it's difficult to improve scalability
> > of the ondisk linked list of orphaned inodes).
> > 
> > This patch implements new way of handling orphan inodes. Instead of
> > linking orphaned inode into a linked list, we store it's inode number in
> > a new special file which we call "orphan file". Currently we still
> > protect the orphan file with a spinlock for simplicity but even in this
> > setting we can substantially reduce the length of the critical section
> > and thus speedup some workloads.
> > 
> > Note that the change is backwards compatible when the filesystem is
> > clean - the existence of the orphan file is a compat feature, we set
> > another ro-compat feature indicating orphan file needs scanning for
> > orphaned inodes when mounting filesystem read-write. This ro-compat
> > feature gets cleared on unmount / remount read-only.
> > 
> > Some performance data from 48 CPU Xeon Server with 32 GB of RAM,
> > filesystem located on ramdisk, average of 5 runs:
> > 
> > stress-orphan (microbenchmark truncating files byte-by-byte from N
> > processes in parallel)
> > 
> > Threads Time            Time
> >        Vanilla         Patched
> >  1       1.602800        1.260000
> >  2       4.292200        2.455000
> >  4       6.202800        3.848400
> >  8      10.415000        6.833000
> > 16      18.933600       12.883200
> > 32      38.517200       25.342200
> > 64      79.805000       50.918400
> > 128     159.629200      102.666000
> > 
> > reaim new_fserver workload (tweaked to avoid calling sync(1) after every
> > operation)
> > 
> > Threads Jobs/s          Jobs/s
> >        Vanilla         Patched
> >  1      24375.00        22941.18
> > 25     162162.16       278571.43
> > 49     222209.30       331626.90
> > 73     280147.60       419447.52
> > 97     315250.00       481910.83
> > 121     331157.90       503360.00
> > 145     343769.00       489081.08
> > 169     355549.56       519487.68
> > 193     356518.65       501800.00
> > 
> > So in both cases we see significant wins all over the board.
> 
> One thing I noticed looking at this patch is that there is quite a bit
> of orphan handling code now.  Is it worthwhile to move it into its own
> file and make super.c a bit smaller?
  Yeah, probably it's worth it. I can do it in the next version of the
patch set.

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/ext4/ext4.h  |  52 +++++++++++--
> > fs/ext4/namei.c |  95 +++++++++++++++++++++--
> > fs/ext4/super.c | 237 ++++++++++++++++++++++++++++++++++++++++++++++++--------
> > 3 files changed, 341 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index abed83485915..768a8b9ee2f9 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -208,6 +208,7 @@ struct ext4_io_submit {
> > #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
> > #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
> > #define EXT4_JOURNAL_INO	 8	/* Journal inode */
> > +#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */
> 
> Contrary to your patch description that said this was using ino #12,
> this conflicts with EXT2_EXCLUDE_INO for snapshots.  Why not use
> s_last_orphan in the superblock to reference the orphan inode?  Since
> this feature already requires a new EXT2_FEATURE_RO_COMPAT flag, the
> existing orphan inode number could be reused.  See below how this could
> still in the ENOSPC case.
  So I think you misunderstood one thing: Orphan file is statically
allocated (when feature gets enabled by mkfs). Kernel doesn't handle
resizing in any way - that way we can assume we modify exactly one block to
add inode to orphan file. If we run out of space in orphan file - but
note that e.g. if you have 128 KB orphan file, it can contain 32768 orphan
entries and you never have that many orphan inodes at once under normal
circumstances - we fall back to old style orphan list. So if you have more
orphan inodes than you expected when creating orphan file, the fs still
handles that gracefully, it just falls back to the old unscalable code.

IMHO adding code to grow orphan file isn't simply worth it (but we can do
it if we decide so in the future). Also we have to keep code to handle old
style orphan list anyway in kernel so the fallback doesn't really incurr
any significant additional complexity.

> > +static inline int ext4_inodes_per_orphan_block(struct super_block *sb)
> > +{
> > +	/* We reserve 1 entry for block checksum */
> 
> Would be good to improve this comment to say "first entry" or "last entry".
  Good idea.

> 
> > +	return sb->s_blocksize / sizeof(u32) - 1;
> > +}
> 
> What do you think about making the on-disk orphan inode numbers store
> 64-bit values?  That would be easy to do now, and would avoid a format
> change in the future if we wanted to use 64-bit inodes.
> 
> That said, if the orphan inode is deleted after orphan recovery (see more
> below) the only thing needed for compatibility is to store the inode number
> size into the orphan inode somewhere so it could be changed.  Maybe
> i_version and/or i_generation since they are not directly user accessible.
  So orphan entry is cleared once inode isn't orphan anymore. So a clean
filesystem currently has completely zeroed out orphan file. Switching to
64-bit inode numbers would be trivial then and you can just pick the format
of the orphan file based on the 64BIT_INODE incompat feature we'll have to
have in sb anyway. So I don't think we need to do anything in that regard
now.

> This would also allow you to detect if s_last_orphan was the orphan inode
> without burning an EXT4_*_FL inode flag for a one-file-only usage.
  Umm, which flag do you mean? I have EXT4_STATE_ORPHAN_FILE which
indicates that inode has entry in the orphan file - i.e. it is orphaned via
the orphan file. But you seem to be talking about something different here.

> > #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
> > #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
> > #define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
> > +#define EXT4_FEATURE_COMPAT_ORPHAN_FILE		0x0400	/* Orphan file exists */
> > 
> > #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
> > #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
> > @@ -1556,7 +1593,10 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
> >  * GDT_CSUM bits are mutually exclusive.
> >  */
> > #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
> > +/* 0x0800 Reserved for EXT4_FEATURE_RO_COMPAT_REPLICA */
> > #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
> > +#define EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT	0x2000 /* Orphan file may be
> > +							  non-empty */
> > 
> > #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
> > #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> > @@ -1589,7 +1629,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
> > 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
> > 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
> > 
> > -#define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
> > +#define EXT4_FEATURE_COMPAT_SUPP	(EXT4_FEATURE_COMPAT_EXT_ATTR| \
> > +					 EXT4_FEATURE_COMPAT_ORPHAN_FILE)
> > #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
> > 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
> > 					 EXT4_FEATURE_INCOMPAT_META_BG| \
> > @@ -1607,7 +1648,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
> > 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> > 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
> > 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> > -					 EXT4_FEATURE_RO_COMPAT_QUOTA)
> > +					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
> > +					 EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT)
> > 
> > /*
> >  * Default values for user and/or group using reserved blocks
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 460c716e38b0..3436b7fa0ef9 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -2529,6 +2529,46 @@ static int empty_dir(struct inode *inode)
> > 	return 1;
> > }
> > 
> > +static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
> > +{
> > +	int i, j;
> > +	struct ext4_orphan_info *oi = &EXT4_SB(inode->i_sb)->s_orphan_info;
> > +	int ret = 0;
> > +	__le32 *bdata;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(inode->i_sb);
> > +
> > +	spin_lock(&oi->of_lock);
> > +	for (i = 0; i < oi->of_blocks && !oi->of_binfo[i].ob_free_entries; i++);
> > +	if (i == oi->of_blocks) {
> > +		spin_unlock(&oi->of_lock);
> > +		return -ENOSPC;
> > +	}
> > +	oi->of_binfo[i].ob_free_entries--;
> > +	spin_unlock(&oi->of_lock);
> > +
> > +	/*
> > +	 * Get access to orphan block. We have dropped of_lock but since we
> > +	 * have decremented number of free entries we are guaranteed free entry
> > +	 * in our block.
> > +	 */
> > +	ret = ext4_journal_get_write_access(handle, inode->i_sb,
> > +				oi->of_binfo[i].ob_bh, TR_ORPHAN_FILE);
> > +	if (ret)
> > +		return ret;
> > +
> > +	bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
> > +	spin_lock(&oi->of_lock);
> > +	/* Find empty slot in a block */
> > +	for (j = 0; j < inodes_per_ob && bdata[j]; j++);
> > +	BUG_ON(j == inodes_per_ob);
> > +	bdata[j] = cpu_to_le32(inode->i_ino);
> > +	EXT4_I(inode)->i_orphan_idx = i * inodes_per_ob + j;
> > +	ext4_set_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
> > +	spin_unlock(&oi->of_lock);
> > +
> > +	return ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[i].ob_bh);
> > +}
> > +
> > /*
> >  * ext4_orphan_add() links an unlinked or truncated inode into a list of
> >  * such inodes, starting at the superblock, in case we crash before the
> > @@ -2555,10 +2595,10 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> > 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> > 		     !mutex_is_locked(&inode->i_mutex));
> > 	/*
> > -	 * Exit early if inode already is on orphan list. This is a big speedup
> > -	 * since we don't have to contend on the global s_orphan_lock.
> > +	 * Inode orphaned in orphan file or in orphan list?
> > 	 */
> > -	if (!list_empty(&EXT4_I(inode)->i_orphan))
> > +	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) ||
> > +	    !list_empty(&EXT4_I(inode)->i_orphan))
> > 		return 0;
> > 
> 
> > @@ -2570,6 +2610,16 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> > 	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > 		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
> > 
> > +	if (sbi->s_orphan_info.of_blocks) {
> > +		err = ext4_orphan_file_add(handle, inode);
> > +		/*
> > +		 * Fallback to normal orphan list of orphan file is
> > +		 * out of space
> > +		 */
> > +		if (err != -ENOSPC)
> > +			return err;
> > +	}
> 
> Hmm, that is sad, but I guess it is necessary to be able to unlink an
> inode if the filesystem is completely full.  Otherwise there won't be
> any space to free space...
> 
> That said, the ENOSPC orphan list could link onto the orphan inode
> itself if it is directly referenced from s_last_orphan.  Then, maybe
> conveniently, if the orphan inode itself is deleted at the end of
> orphan inode processing it would free all of the allocated blocks and
> avoid the problem of growing to a large size and never freeing blocks.
  See above.

> > 	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> > 	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh, TR_NONE);
> > 	if (err)
> > @@ -2618,6 +2668,37 @@ out:
> > 	return err;
> > }
> > 
> > +static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
> > +{
> > +	struct ext4_orphan_info *oi = &EXT4_SB(inode->i_sb)->s_orphan_info;
> > +	__le32 *bdata;
> > +	int blk, off;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(inode->i_sb);
> > +	int ret = 0;
> > +
> > +	if (!handle)
> > +		goto out;
> > +	blk = EXT4_I(inode)->i_orphan_idx / inodes_per_ob;
> > +	off = EXT4_I(inode)->i_orphan_idx % inodes_per_ob;
> > +
> > +	ret = ext4_journal_get_write_access(handle, inode->i_sb,
> > +				oi->of_binfo[blk].ob_bh, TR_ORPHAN_FILE);
> > +	if (ret)
> > +		goto out;
> > +
> > +	bdata = (__le32 *)(oi->of_binfo[blk].ob_bh->b_data);
> > +	spin_lock(&oi->of_lock);
> > +	bdata[off] = 0;
> > +	oi->of_binfo[blk].ob_free_entries++;
> > +	spin_unlock(&oi->of_lock);
> > +	ret = ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[blk].ob_bh);
> > +out:
> > +	ext4_clear_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
> > +	INIT_LIST_HEAD(&EXT4_I(inode)->i_orphan);
> > +
> > +	return ret;
> > +}
> > +
> > /*
> >  * ext4_orphan_del() removes an unlinked or truncated inode from the list
> >  * of such inodes stored on disk, because it is finally being cleaned up.
> > @@ -2636,10 +2717,14 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
> > 
> > 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> > 		     !mutex_is_locked(&inode->i_mutex));
> > -	/* Do this quick check before taking global s_orphan_lock. */
> > -	if (list_empty(&ei->i_orphan))
> > +	/* Do this quick check before taking global lock. */
> > +	if (!ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) &&
> > +	    list_empty(&ei->i_orphan))
> > 		return 0;
> > 
> > +	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
> > +		return ext4_orphan_file_del(handle, inode);
> 
> This could go before the above check, and then go back to only checking
> list_empty() instead of checking STATE_ORPHAN_FILE twice.
  Nice, done.

> > 	if (handle) {
> > 		/* Grab inode buffer early before taking global s_orphan_lock */
> > 		err = ext4_reserve_inode_write(handle, inode, &iloc);
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 0babe8c435b6..14c30a9ef509 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -761,6 +761,18 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
> > 	}
> > }
> > 
> > +static void ext4_release_orphan_info(struct super_block *sb)
> > +{
> > +	int i;
> > +	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
> > +
> > +	if (!oi->of_blocks)
> > +		return;
> > +	for (i = 0; i < oi->of_blocks; i++)
> > +		brelse(oi->of_binfo[i].ob_bh);
> > +	kfree(oi->of_binfo);
> > +}
> > +
> > static void ext4_put_super(struct super_block *sb)
> > {
> > 	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > @@ -772,6 +784,7 @@ static void ext4_put_super(struct super_block *sb)
> > 
> > 	flush_workqueue(sbi->rsv_conversion_wq);
> > 	destroy_workqueue(sbi->rsv_conversion_wq);
> > +	ext4_release_orphan_info(sb);
> > 
> > 	if (sbi->s_journal) {
> > 		err = jbd2_journal_destroy(sbi->s_journal);
> > @@ -789,6 +802,8 @@ static void ext4_put_super(struct super_block *sb)
> > 
> > 	if (!(sb->s_flags & MS_RDONLY)) {
> > 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> > +		EXT4_CLEAR_RO_COMPAT_FEATURE(sb,
> > +			EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
> > 		es->s_state = cpu_to_le16(sbi->s_mount_state);
> > 	}
> > 	if (!(sb->s_flags & MS_RDONLY))
> > @@ -1905,8 +1920,14 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
> > 	le16_add_cpu(&es->s_mnt_count, 1);
> > 	es->s_mtime = cpu_to_le32(get_seconds());
> > 	ext4_update_dynamic_rev(sb);
> > -	if (sbi->s_journal)
> > +	if (sbi->s_journal) {
> > 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> > +		if (EXT4_HAS_COMPAT_FEATURE(sb,
> > +					    EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
> > +			EXT4_SET_RO_COMPAT_FEATURE(sb,
> > +				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
> > +		}
> > +	}
> 
> Shouldn't this only be set the first time an orphan is created?
  Could be done that way. But I didn't want to deal with the locking and
checking down in the orphan inode handling functions. And once you mount fs
read-write, you are very likely to add orphan entry anyway. Also the
feature gets cleared once you unmount the fs so the feature remains set 
only if you crash while the fs is mounted - a corner case not worth
the complexity IMHO.

> > @@ -2128,6 +2149,36 @@ static int ext4_check_descriptors(struct super_block *sb,
> > 	return 1;
> > }
> > 
> > +static void ext4_process_orphan(struct inode *inode,
> > +				int *nr_truncates, int *nr_orphans)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +	dquot_initialize(inode);
> > +	if (inode->i_nlink) {
> > +		if (test_opt(sb, DEBUG))
> > +			ext4_msg(sb, KERN_DEBUG,
> > +				"%s: truncating inode %lu to %lld bytes",
> > +				__func__, inode->i_ino, inode->i_size);
> > +		jbd_debug(2, "truncating inode %lu to %lld bytes\n",
> > +			  inode->i_ino, inode->i_size);
> > +		mutex_lock(&inode->i_mutex);
> > +		truncate_inode_pages(inode->i_mapping, inode->i_size);
> > +		ext4_truncate(inode);
> > +		mutex_unlock(&inode->i_mutex);
> > +		(*nr_truncates)++;
> > +	} else {
> > +		if (test_opt(sb, DEBUG))
> > +			ext4_msg(sb, KERN_DEBUG,
> > +				"%s: deleting unreferenced inode %lu",
> > +				__func__, inode->i_ino);
> > +		jbd_debug(2, "deleting unreferenced inode %lu\n",
> > +			  inode->i_ino);
> > +		(*nr_orphans)++;
> > +	}
> > +	iput(inode);  /* The delete magic happens here! */
> > +}
> > +
> > /* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
> >  * the superblock) which were deleted from all directories, but held open by
> >  * a process at the time of a crash.  We walk the list and try to delete these
> > @@ -2150,10 +2201,13 @@ static void ext4_orphan_cleanup(struct super_block *sb,
> > {
> > 	unsigned int s_flags = sb->s_flags;
> > 	int nr_orphans = 0, nr_truncates = 0;
> > -#ifdef CONFIG_QUOTA
> > -	int i;
> > -#endif
> > -	if (!es->s_last_orphan) {
> > +	int i, j;
> > +	__le32 *bdata;
> > +	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
> > +	struct inode *inode;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
> > +
> > +	if (!es->s_last_orphan && !oi->of_blocks) {
> > 		jbd_debug(4, "no orphan inodes to clean up\n");
> > 		return;
> > 	}
> > @@ -2202,8 +2256,6 @@ static void ext4_orphan_cleanup(struct super_block *sb,
> > #endif
> > 
> > 	while (es->s_last_orphan) {
> > -		struct inode *inode;
> > -
> > 		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
> > 		if (IS_ERR(inode)) {
> > 			es->s_last_orphan = 0;
> > @@ -2211,29 +2263,21 @@ static void ext4_orphan_cleanup(struct super_block *sb,
> > 		}
> > 
> > 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
> > -		dquot_initialize(inode);
> > -		if (inode->i_nlink) {
> > -			if (test_opt(sb, DEBUG))
> > -				ext4_msg(sb, KERN_DEBUG,
> > -					"%s: truncating inode %lu to %lld bytes",
> > -					__func__, inode->i_ino, inode->i_size);
> > -			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
> > -				  inode->i_ino, inode->i_size);
> > -			mutex_lock(&inode->i_mutex);
> > -			truncate_inode_pages(inode->i_mapping, inode->i_size);
> > -			ext4_truncate(inode);
> > -			mutex_unlock(&inode->i_mutex);
> > -			nr_truncates++;
> > -		} else {
> > -			if (test_opt(sb, DEBUG))
> > -				ext4_msg(sb, KERN_DEBUG,
> > -					"%s: deleting unreferenced inode %lu",
> > -					__func__, inode->i_ino);
> > -			jbd_debug(2, "deleting unreferenced inode %lu\n",
> > -				  inode->i_ino);
> > -			nr_orphans++;
> > +		ext4_process_orphan(inode, &nr_truncates, &nr_orphans);
> > +	}
> > +
> > +	for (i = 0; i < oi->of_blocks; i++) {
> > +		bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
> > +		for (j = 0; j < inodes_per_ob; j++) {
> > +			if (!bdata[j])
> > +				continue;
> > +			inode = ext4_orphan_get(sb, le32_to_cpu(bdata[j]));
> > +			if (IS_ERR(inode))
> > +				continue;
> > +			ext4_set_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
> > +			EXT4_I(inode)->i_orphan_idx = i * inodes_per_ob + j;
> > +			ext4_process_orphan(inode, &nr_truncates, &nr_orphans);
> > 		}
> > -		iput(inode);  /* The delete magic happens here! */
> > 	}
> > 
> > #define PLURAL(x) (x), ((x) == 1) ? "" : "s"
> > @@ -3420,6 +3464,97 @@ static void ext4_setup_csum_trigger(struct super_block *sb,
> > 	sbi->s_journal_triggers[type].tr_triggers.t_frozen = trigger;
> > }
> > 
> > +static int ext4_orphan_file_block_csum_verify(struct super_block *sb,
> > +					      struct buffer_head *bh)
> > +{
> > +	__u32 provided, calculated;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
> > +	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
> > +
> > +	if (!ext4_has_metadata_csum(sb))
> > +		return 1;
> 
> Does it make sense to always checksum the orphan blocks, even if the
> whole filesystem is not being checksummed?  Corruption in the orphan 
> handling would result in orphan processing of random inode numbers.
> Not fatal, I guess, since the only thing orphan processing does today
> is truncate the file to the current i_size and unlink it only if
> i_nlink == 0, which should be safe on normal files (at worst losing
> fallocate'd blocks beyond i_size).  Still, better safe than sorry?
> That would also test the checksum callbacks on an ongoing basis,
> instead of only when both metadata_csum and orphan_inode are enabled.
  Umm, I like the fact that the code would be tested. But checksumming has
its overhead (although we compute the checksum only at transaction commit
but still it somewhat slows it down) so it seems wrong to slow everyone
down just for that. Dunno, what others think?
 
> > +	provided = le32_to_cpu(((__le32 *)bh->b_data)[inodes_per_ob]);
> > +	calculated = ext4_chksum(EXT4_SB(sb), oi->of_csum_seed,
> > +				 (__u8 *)bh->b_data,
> > +				 inodes_per_ob * sizeof(__u32));
> > +	return provided == calculated;
> > +}
> > +
> > +/* This gets called only when checksumming is enabled */
> > +static void ext4_orphan_file_block_trigger(
> > +			struct jbd2_buffer_trigger_type *triggers,
> > +			struct buffer_head *bh,
> > +			void *data, size_t size)
> > +{
> > +	struct super_block *sb = EXT4_TRIGGER(triggers)->sb;
> > +	__u32 csum;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
> > +	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
> > +
> > +	csum = ext4_chksum(EXT4_SB(sb), oi->of_csum_seed, (__u8 *)data,
> > +			   inodes_per_ob * sizeof(__u32));
> > +	((__le32 *)data)[inodes_per_ob] = cpu_to_le32(csum);
> > +}
> > +
> > +static int ext4_init_orphan_info(struct super_block *sb)
> > +{
> > +	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
> > +	struct inode *inode;
> > +	int i, j;
> > +	int ret;
> > +	int free;
> > +	__le32 *bdata;
> > +	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
> > +
> > +	spin_lock_init(&oi->of_lock);
> > +
> > +	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE))
> > +		return 0;
> > +
> > +	inode = ext4_iget(sb, 12 /* FIXME: EXT4_ORPHAN_INO */);
> 
> This would corrupt lost+found on most filesystems, better to use the
> existing EXT4_ORPHAN_INO = 9 for testing, since it will at least not
> exist on most filesystems.
  Yes, I know - actually lost+found is inode 11, this is the first free
inode on empty filesystem. That's why I wrote it's hacked up :) But because
I need preallocated file to give to kernel, this was as easy as it could
get.  Allocating blocks for ino 9 isn't as easy as you have to play with
debugfs. For now I don't expect anyone to use these patches on anything
else than scratch filesystems...
 
> Since the orphan inode blocks will be allocated one-at-a-time after
> long intervals, like an O_APPEND file, the orphan inode should not
> be extent-mapped, but rather block-mapped for efficiency.  Since
> there is already a fallback to handle ENOSPC, the chance of not
> being able to get a single free block in the first 2^32 blocks is
> not worth the 3x overhead of extent block addresses for this inode.
  Again here's the misunderstanding how the orphan file gets created. For
preallocated file I have in mind, extent format is better since I expect to
have just one extent in the file.

> > +	if (IS_ERR(inode)) {
> > +		ext4_msg(sb, KERN_ERR, "get orphan inode failed");
> > +		return PTR_ERR(inode);
> > +	}
> > +	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
> > +	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
> > +	oi->of_binfo = kmalloc(oi->of_blocks*sizeof(struct ext4_orphan_block),
> > +			       GFP_KERNEL);
> > +	if (!oi->of_binfo) {
> > +		ret = -ENOMEM;
> > +		goto out_put;
> > +	}
> > +	for (i = 0; i < oi->of_blocks; i++) {
> > +		oi->of_binfo[i].ob_bh = ext4_bread(NULL, inode, i, 0);
> > +		if (IS_ERR(oi->of_binfo[i].ob_bh)) {
> > +			ret = PTR_ERR(oi->of_binfo[i].ob_bh);
> > +			goto out_free;
> > +		}
> > +		if (!ext4_orphan_file_block_csum_verify(sb,
> > +						oi->of_binfo[i].ob_bh)) {
> > +			ext4_error(sb, "orphan file block %d: bad checksum", i);
> > +			ret = -EIO;
> > +			goto out_free;
> 
> Should this continue to the next block instead of aborting if a single
> block is bad?  If it is always checking the checksum it should be safe
> to try the later blocks as well.
  Well, if you have checksum errors, you better run fsck on the filesystem.
It may be a bitflip, it may be a block written elsewhere... hard to tell.
We could easily continue with later blocks but, then should we just wipe the
problematic block? That seems dangerous and possibly leaks some inodes /
space. And if we decide to not use that block (which effectively leaks
inodes & blocks as well) we'd have to check for that and skip such blocks -
doable but is it worth it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
