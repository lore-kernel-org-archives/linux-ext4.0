From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Thu, 16 Apr 2015 17:42:56 +0200
Message-ID: <1429198977-5637-3-git-send-email-jack@suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbDPPnJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 11:43:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D5B53AC84
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2015 15:43:07 +0000 (UTC)
In-Reply-To: <1429198977-5637-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 orphan inode handling is a bottleneck for workloads which heavily
truncate / unlink small files since it contends on the global
s_orphan_mutex lock (and generally it's difficult to improve scalability
of the ondisk linked list of orphaned inodes).

This patch implements new way of handling orphan inodes. Instead of
linking orphaned inode into a linked list, we store it's inode number in
a new special file which we call "orphan file". Currently we still
protect the orphan file with a spinlock for simplicity but even in this
setting we can substantially reduce the length of the critical section
and thus speedup some workloads.

Note that the change is backwards compatible when the filesystem is
clean - the existence of the orphan file is a compat feature, we set
another ro-compat feature indicating orphan file needs scanning for
orphaned inodes when mounting filesystem read-write. This ro-compat
feature gets cleared on unmount / remount read-only.

Some performance data from 48 CPU Xeon Server with 32 GB of RAM,
filesystem located on ramdisk, average of 5 runs:

stress-orphan (microbenchmark truncating files byte-by-byte from N
processes in parallel)

Threads Time            Time
        Vanilla         Patched
  1       1.602800        1.260000
  2       4.292200        2.455000
  4       6.202800        3.848400
  8      10.415000        6.833000
 16      18.933600       12.883200
 32      38.517200       25.342200
 64      79.805000       50.918400
128     159.629200      102.666000

reaim new_fserver workload (tweaked to avoid calling sync(1) after every
operation)

Threads Jobs/s          Jobs/s
        Vanilla         Patched
  1      24375.00        22941.18
 25     162162.16       278571.43
 49     222209.30       331626.90
 73     280147.60       419447.52
 97     315250.00       481910.83
121     331157.90       503360.00
145     343769.00       489081.08
169     355549.56       519487.68
193     356518.65       501800.00

So in both cases we see significant wins all over the board.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  52 +++++++++++--
 fs/ext4/namei.c |  95 +++++++++++++++++++++--
 fs/ext4/super.c | 237 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 341 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index abed83485915..768a8b9ee2f9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -208,6 +208,7 @@ struct ext4_io_submit {
 #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT4_JOURNAL_INO	 8	/* Journal inode */
+#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */
 
 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO	11
@@ -831,7 +832,14 @@ struct ext4_inode_info {
 	 */
 	struct rw_semaphore xattr_sem;
 
-	struct list_head i_orphan;	/* unlinked but open inodes */
+	/*
+	 * Inodes with EXT4_STATE_ORPHAN_FILE use i_orphan_block. Otherwise
+	 * i_orphan is used.
+	 */
+	union {
+		struct list_head i_orphan;	/* unlinked but open inodes */
+		unsigned int i_orphan_idx;	/* Index in orphan file */
+	};
 
 	/*
 	 * i_disksize keeps track of what the inode size is ON DISK, not
@@ -1188,6 +1196,7 @@ struct ext4_super_block {
 
 /* Types of ext4 journal triggers */
 enum ext4_journal_trigger_type {
+	TR_ORPHAN_FILE,
 	TR_NONE
 };
 
@@ -1204,6 +1213,29 @@ static inline struct ext4_journal_trigger *EXT4_TRIGGER(
 	return container_of(trigger, struct ext4_journal_trigger, tr_triggers);
 }
 
+static inline int ext4_inodes_per_orphan_block(struct super_block *sb)
+{
+	/* We reserve 1 entry for block checksum */
+	return sb->s_blocksize / sizeof(u32) - 1;
+}
+
+struct ext4_orphan_block {
+	int ob_free_entries;	/* Number of free orphan entries in block */
+	struct buffer_head *ob_bh;	/* Buffer for orphan block */
+};
+
+/*
+ * Info about orphan file. Some info in this structure is duplicated - once
+ * for running and once for committing transaction
+ */
+struct ext4_orphan_info {
+	spinlock_t of_lock;
+	int of_blocks;			/* Number of orphan blocks in a file */
+	__u32 of_csum_seed;		/* Checksum seed for orphan file */
+	struct ext4_orphan_block *of_binfo;	/* Array with info about orphan
+						 * file blocks */
+};
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1258,8 +1290,10 @@ struct ext4_sb_info {
 
 	/* Journaling */
 	struct journal_s *s_journal;
-	struct list_head s_orphan;
-	struct mutex s_orphan_lock;
+	struct mutex s_orphan_lock;	/* Protects on disk list changes */
+	struct list_head s_orphan;	/* List of orphaned inodes in on disk
+					   list */
+	struct ext4_orphan_info s_orphan_info;
 	unsigned long s_resize_flags;		/* Flags indicating if there
 						   is a resizer */
 	unsigned long s_commit_interval;
@@ -1397,6 +1431,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		ino == EXT4_BOOT_LOADER_INO ||
 		ino == EXT4_JOURNAL_INO ||
 		ino == EXT4_RESIZE_INO ||
+		ino == EXT4_ORPHAN_INO ||
 		(ino >= EXT4_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
@@ -1437,6 +1472,7 @@ enum {
 	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
 	EXT4_STATE_ORDERED_MODE,	/* data=ordered mode */
 	EXT4_STATE_EXT_PRECACHED,	/* extents have been precached */
+	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
@@ -1539,6 +1575,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
+#define EXT4_FEATURE_COMPAT_ORPHAN_FILE		0x0400	/* Orphan file exists */
 
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -1556,7 +1593,10 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+/* 0x0800 Reserved for EXT4_FEATURE_RO_COMPAT_REPLICA */
 #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
+#define EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT	0x2000 /* Orphan file may be
+							  non-empty */
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1589,7 +1629,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
 
-#define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
+#define EXT4_FEATURE_COMPAT_SUPP	(EXT4_FEATURE_COMPAT_EXT_ATTR| \
+					 EXT4_FEATURE_COMPAT_ORPHAN_FILE)
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
@@ -1607,7 +1648,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT)
 
 /*
  * Default values for user and/or group using reserved blocks
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 460c716e38b0..3436b7fa0ef9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2529,6 +2529,46 @@ static int empty_dir(struct inode *inode)
 	return 1;
 }
 
+static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
+{
+	int i, j;
+	struct ext4_orphan_info *oi = &EXT4_SB(inode->i_sb)->s_orphan_info;
+	int ret = 0;
+	__le32 *bdata;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(inode->i_sb);
+
+	spin_lock(&oi->of_lock);
+	for (i = 0; i < oi->of_blocks && !oi->of_binfo[i].ob_free_entries; i++);
+	if (i == oi->of_blocks) {
+		spin_unlock(&oi->of_lock);
+		return -ENOSPC;
+	}
+	oi->of_binfo[i].ob_free_entries--;
+	spin_unlock(&oi->of_lock);
+
+	/*
+	 * Get access to orphan block. We have dropped of_lock but since we
+	 * have decremented number of free entries we are guaranteed free entry
+	 * in our block.
+	 */
+	ret = ext4_journal_get_write_access(handle, inode->i_sb,
+				oi->of_binfo[i].ob_bh, TR_ORPHAN_FILE);
+	if (ret)
+		return ret;
+
+	bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
+	spin_lock(&oi->of_lock);
+	/* Find empty slot in a block */
+	for (j = 0; j < inodes_per_ob && bdata[j]; j++);
+	BUG_ON(j == inodes_per_ob);
+	bdata[j] = cpu_to_le32(inode->i_ino);
+	EXT4_I(inode)->i_orphan_idx = i * inodes_per_ob + j;
+	ext4_set_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
+	spin_unlock(&oi->of_lock);
+
+	return ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[i].ob_bh);
+}
+
 /*
  * ext4_orphan_add() links an unlinked or truncated inode into a list of
  * such inodes, starting at the superblock, in case we crash before the
@@ -2555,10 +2595,10 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
 		     !mutex_is_locked(&inode->i_mutex));
 	/*
-	 * Exit early if inode already is on orphan list. This is a big speedup
-	 * since we don't have to contend on the global s_orphan_lock.
+	 * Inode orphaned in orphan file or in orphan list?
 	 */
-	if (!list_empty(&EXT4_I(inode)->i_orphan))
+	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) ||
+	    !list_empty(&EXT4_I(inode)->i_orphan))
 		return 0;
 
 	/*
@@ -2570,6 +2610,16 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
 
+	if (sbi->s_orphan_info.of_blocks) {
+		err = ext4_orphan_file_add(handle, inode);
+		/*
+		 * Fallback to normal orphan list of orphan file is
+		 * out of space
+		 */
+		if (err != -ENOSPC)
+			return err;
+	}
+
 	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh, TR_NONE);
 	if (err)
@@ -2618,6 +2668,37 @@ out:
 	return err;
 }
 
+static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
+{
+	struct ext4_orphan_info *oi = &EXT4_SB(inode->i_sb)->s_orphan_info;
+	__le32 *bdata;
+	int blk, off;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(inode->i_sb);
+	int ret = 0;
+
+	if (!handle)
+		goto out;
+	blk = EXT4_I(inode)->i_orphan_idx / inodes_per_ob;
+	off = EXT4_I(inode)->i_orphan_idx % inodes_per_ob;
+
+	ret = ext4_journal_get_write_access(handle, inode->i_sb,
+				oi->of_binfo[blk].ob_bh, TR_ORPHAN_FILE);
+	if (ret)
+		goto out;
+
+	bdata = (__le32 *)(oi->of_binfo[blk].ob_bh->b_data);
+	spin_lock(&oi->of_lock);
+	bdata[off] = 0;
+	oi->of_binfo[blk].ob_free_entries++;
+	spin_unlock(&oi->of_lock);
+	ret = ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[blk].ob_bh);
+out:
+	ext4_clear_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
+	INIT_LIST_HEAD(&EXT4_I(inode)->i_orphan);
+
+	return ret;
+}
+
 /*
  * ext4_orphan_del() removes an unlinked or truncated inode from the list
  * of such inodes stored on disk, because it is finally being cleaned up.
@@ -2636,10 +2717,14 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 
 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
 		     !mutex_is_locked(&inode->i_mutex));
-	/* Do this quick check before taking global s_orphan_lock. */
-	if (list_empty(&ei->i_orphan))
+	/* Do this quick check before taking global lock. */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) &&
+	    list_empty(&ei->i_orphan))
 		return 0;
 
+	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
+		return ext4_orphan_file_del(handle, inode);
+
 	if (handle) {
 		/* Grab inode buffer early before taking global s_orphan_lock */
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0babe8c435b6..14c30a9ef509 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -761,6 +761,18 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 	}
 }
 
+static void ext4_release_orphan_info(struct super_block *sb)
+{
+	int i;
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+
+	if (!oi->of_blocks)
+		return;
+	for (i = 0; i < oi->of_blocks; i++)
+		brelse(oi->of_binfo[i].ob_bh);
+	kfree(oi->of_binfo);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -772,6 +784,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	flush_workqueue(sbi->rsv_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
+	ext4_release_orphan_info(sb);
 
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
@@ -789,6 +802,8 @@ static void ext4_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		EXT4_CLEAR_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1905,8 +1920,14 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	le16_add_cpu(&es->s_mnt_count, 1);
 	es->s_mtime = cpu_to_le32(get_seconds());
 	ext4_update_dynamic_rev(sb);
-	if (sbi->s_journal)
+	if (sbi->s_journal) {
 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		if (EXT4_HAS_COMPAT_FEATURE(sb,
+					    EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+			EXT4_SET_RO_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
+		}
+	}
 
 	ext4_commit_super(sb, 1);
 done:
@@ -2128,6 +2149,36 @@ static int ext4_check_descriptors(struct super_block *sb,
 	return 1;
 }
 
+static void ext4_process_orphan(struct inode *inode,
+				int *nr_truncates, int *nr_orphans)
+{
+	struct super_block *sb = inode->i_sb;
+
+	dquot_initialize(inode);
+	if (inode->i_nlink) {
+		if (test_opt(sb, DEBUG))
+			ext4_msg(sb, KERN_DEBUG,
+				"%s: truncating inode %lu to %lld bytes",
+				__func__, inode->i_ino, inode->i_size);
+		jbd_debug(2, "truncating inode %lu to %lld bytes\n",
+			  inode->i_ino, inode->i_size);
+		mutex_lock(&inode->i_mutex);
+		truncate_inode_pages(inode->i_mapping, inode->i_size);
+		ext4_truncate(inode);
+		mutex_unlock(&inode->i_mutex);
+		(*nr_truncates)++;
+	} else {
+		if (test_opt(sb, DEBUG))
+			ext4_msg(sb, KERN_DEBUG,
+				"%s: deleting unreferenced inode %lu",
+				__func__, inode->i_ino);
+		jbd_debug(2, "deleting unreferenced inode %lu\n",
+			  inode->i_ino);
+		(*nr_orphans)++;
+	}
+	iput(inode);  /* The delete magic happens here! */
+}
+
 /* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
  * the superblock) which were deleted from all directories, but held open by
  * a process at the time of a crash.  We walk the list and try to delete these
@@ -2150,10 +2201,13 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 {
 	unsigned int s_flags = sb->s_flags;
 	int nr_orphans = 0, nr_truncates = 0;
-#ifdef CONFIG_QUOTA
-	int i;
-#endif
-	if (!es->s_last_orphan) {
+	int i, j;
+	__le32 *bdata;
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+	struct inode *inode;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+
+	if (!es->s_last_orphan && !oi->of_blocks) {
 		jbd_debug(4, "no orphan inodes to clean up\n");
 		return;
 	}
@@ -2202,8 +2256,6 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 #endif
 
 	while (es->s_last_orphan) {
-		struct inode *inode;
-
 		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
 		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
@@ -2211,29 +2263,21 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		}
 
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
-		dquot_initialize(inode);
-		if (inode->i_nlink) {
-			if (test_opt(sb, DEBUG))
-				ext4_msg(sb, KERN_DEBUG,
-					"%s: truncating inode %lu to %lld bytes",
-					__func__, inode->i_ino, inode->i_size);
-			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
-				  inode->i_ino, inode->i_size);
-			mutex_lock(&inode->i_mutex);
-			truncate_inode_pages(inode->i_mapping, inode->i_size);
-			ext4_truncate(inode);
-			mutex_unlock(&inode->i_mutex);
-			nr_truncates++;
-		} else {
-			if (test_opt(sb, DEBUG))
-				ext4_msg(sb, KERN_DEBUG,
-					"%s: deleting unreferenced inode %lu",
-					__func__, inode->i_ino);
-			jbd_debug(2, "deleting unreferenced inode %lu\n",
-				  inode->i_ino);
-			nr_orphans++;
+		ext4_process_orphan(inode, &nr_truncates, &nr_orphans);
+	}
+
+	for (i = 0; i < oi->of_blocks; i++) {
+		bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
+		for (j = 0; j < inodes_per_ob; j++) {
+			if (!bdata[j])
+				continue;
+			inode = ext4_orphan_get(sb, le32_to_cpu(bdata[j]));
+			if (IS_ERR(inode))
+				continue;
+			ext4_set_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
+			EXT4_I(inode)->i_orphan_idx = i * inodes_per_ob + j;
+			ext4_process_orphan(inode, &nr_truncates, &nr_orphans);
 		}
-		iput(inode);  /* The delete magic happens here! */
 	}
 
 #define PLURAL(x) (x), ((x) == 1) ? "" : "s"
@@ -3420,6 +3464,97 @@ static void ext4_setup_csum_trigger(struct super_block *sb,
 	sbi->s_journal_triggers[type].tr_triggers.t_frozen = trigger;
 }
 
+static int ext4_orphan_file_block_csum_verify(struct super_block *sb,
+					      struct buffer_head *bh)
+{
+	__u32 provided, calculated;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+
+	if (!ext4_has_metadata_csum(sb))
+		return 1;
+
+	provided = le32_to_cpu(((__le32 *)bh->b_data)[inodes_per_ob]);
+	calculated = ext4_chksum(EXT4_SB(sb), oi->of_csum_seed,
+				 (__u8 *)bh->b_data,
+				 inodes_per_ob * sizeof(__u32));
+	return provided == calculated;
+}
+
+/* This gets called only when checksumming is enabled */
+static void ext4_orphan_file_block_trigger(
+			struct jbd2_buffer_trigger_type *triggers,
+			struct buffer_head *bh,
+			void *data, size_t size)
+{
+	struct super_block *sb = EXT4_TRIGGER(triggers)->sb;
+	__u32 csum;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+
+	csum = ext4_chksum(EXT4_SB(sb), oi->of_csum_seed, (__u8 *)data,
+			   inodes_per_ob * sizeof(__u32));
+	((__le32 *)data)[inodes_per_ob] = cpu_to_le32(csum);
+}
+
+static int ext4_init_orphan_info(struct super_block *sb)
+{
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+	struct inode *inode;
+	int i, j;
+	int ret;
+	int free;
+	__le32 *bdata;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+
+	spin_lock_init(&oi->of_lock);
+
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE))
+		return 0;
+
+	inode = ext4_iget(sb, 12 /* FIXME: EXT4_ORPHAN_INO */);
+	if (IS_ERR(inode)) {
+		ext4_msg(sb, KERN_ERR, "get orphan inode failed");
+		return PTR_ERR(inode);
+	}
+	oi->of_blocks = inode->i_size >> sb->s_blocksize_bits;
+	oi->of_csum_seed = EXT4_I(inode)->i_csum_seed;
+	oi->of_binfo = kmalloc(oi->of_blocks*sizeof(struct ext4_orphan_block),
+			       GFP_KERNEL);
+	if (!oi->of_binfo) {
+		ret = -ENOMEM;
+		goto out_put;
+	}
+	for (i = 0; i < oi->of_blocks; i++) {
+		oi->of_binfo[i].ob_bh = ext4_bread(NULL, inode, i, 0);
+		if (IS_ERR(oi->of_binfo[i].ob_bh)) {
+			ret = PTR_ERR(oi->of_binfo[i].ob_bh);
+			goto out_free;
+		}
+		if (!ext4_orphan_file_block_csum_verify(sb,
+						oi->of_binfo[i].ob_bh)) {
+			ext4_error(sb, "orphan file block %d: bad checksum", i);
+			ret = -EIO;
+			goto out_free;
+		}
+		bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
+		free = 0;
+		for (j = 0; j < inodes_per_ob; j++)
+			if (bdata[j] == 0)
+				free++;
+		oi->of_binfo[i].ob_free_entries = free;
+	}
+	iput(inode);
+	return 0;
+out_free:
+	for (i--; i >= 0; i--)
+		brelse(oi->of_binfo[i].ob_bh);
+	kfree(oi->of_binfo);
+out_put:
+	iput(inode);
+	return ret;
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
@@ -3515,6 +3650,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		silent = 1;
 		goto cantfind_ext4;
 	}
+	ext4_setup_csum_trigger(sb, TR_ORPHAN_FILE,
+				ext4_orphan_file_block_trigger);
 
 	/* Load the checksum driver */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
@@ -3988,8 +4125,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = NULL;
 
 	needs_recovery = (es->s_last_orphan != 0 ||
+			  EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT) ||
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
-				    EXT4_FEATURE_INCOMPAT_RECOVER));
+				EXT4_FEATURE_INCOMPAT_RECOVER));
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_MMP) &&
 	    !(sb->s_flags & MS_RDONLY))
@@ -4207,13 +4346,16 @@ no_journal:
 	if (err)
 		goto failed_mount7;
 
+	err = ext4_init_orphan_info(sb);
+	if (err)
+		goto failed_mount8;
 #ifdef CONFIG_QUOTA
 	/* Enable quota usage during mount. */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		err = ext4_enable_quotas(sb);
 		if (err)
-			goto failed_mount8;
+			goto failed_mount9;
 	}
 #endif  /* CONFIG_QUOTA */
 
@@ -4263,9 +4405,11 @@ cantfind_ext4:
 	goto failed_mount;
 
 #ifdef CONFIG_QUOTA
+failed_mount9:
+	ext4_release_orphan_info(sb);
+#endif
 failed_mount8:
 	kobject_del(&sbi->s_kobj);
-#endif
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
@@ -4771,6 +4915,20 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	return ret;
 }
 
+static int ext4_orphan_file_empty(struct super_block *sb)
+{
+	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
+	int i;
+	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
+
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE))
+		return 1;
+	for (i = 0; i < oi->of_blocks; i++)
+		if (oi->of_binfo[i].ob_free_entries != inodes_per_ob)
+			return 0;
+	return 1;
+}
+
 /*
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
@@ -4804,6 +4962,10 @@ static int ext4_freeze(struct super_block *sb)
 
 	/* Journal blocked and flushed, clear needs_recovery flag. */
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+	if (ext4_orphan_file_empty(sb)) {
+		EXT4_CLEAR_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
+	}
 	error = ext4_commit_super(sb, 1);
 out:
 	if (journal)
@@ -4823,6 +4985,10 @@ static int ext4_unfreeze(struct super_block *sb)
 
 	/* Reset the needs_recovery flag before the fs is unlocked. */
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+		EXT4_SET_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
+	}
 	ext4_commit_super(sb, 1);
 	return 0;
 }
@@ -4966,8 +5132,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			    (sbi->s_mount_state & EXT4_VALID_FS))
 				es->s_state = cpu_to_le16(sbi->s_mount_state);
 
-			if (sbi->s_journal)
+			if (sbi->s_journal) {
 				ext4_mark_recovery_complete(sb, es);
+				if (ext4_orphan_file_empty(sb)) {
+					EXT4_CLEAR_RO_COMPAT_FEATURE(sb,
+						EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT);
+				}
+			}
 		} else {
 			/* Make sure we can mount this feature set readwrite */
 			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-- 
2.1.4

