From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 09/30] ext4: snapshot file
Date: Mon,  9 May 2011 19:41:27 +0300
Message-ID: <1304959308-11122-10-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1EIQnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:35 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:35 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Ext4 snapshot implementation as a file inside the file system.
Snapshot files are marked with the snapfile flag and have special
read-only address space ops.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h      |   83 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/ext4_jbd2.h |    2 +
 fs/ext4/ialloc.c    |    8 ++++-
 fs/ext4/inode.c     |   29 ++++++++++++++++++
 fs/ext4/super.c     |    9 +++++
 5 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 013eec2..4072036 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -361,17 +361,23 @@ struct flex_groups {
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+/* snapshot persistent flags */
+#define EXT4_SNAPFILE_FL		0x01000000 /* snapshot file */
+#define EXT4_SNAPFILE_DELETED_FL	0x04000000 /* snapshot is deleted */
+#define EXT4_SNAPFILE_SHRUNK_FL		0x08000000 /* snapshot was shrunk */
+/* end of snapshot flags */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
+
+#define EXT4_FL_USER_VISIBLE		0x014BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x014B80FF /* User modifiable flags */
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
 			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
-			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
+			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL | EXT4_SNAPFILE_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
@@ -418,6 +424,9 @@ enum {
 	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
+	EXT4_INODE_SNAPFILE	= 24,	/* Snapshot file/dir */
+	EXT4_INODE_SNAPFILE_DELETED = 26,	/* Snapshot is deleted */
+	EXT4_INODE_SNAPFILE_SHRUNK = 27,	/* Snapshot was shrunk */
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
@@ -464,6 +473,9 @@ static inline void ext4_check_flag_values(void)
 	CHECK_FLAG_VALUE(EXTENTS);
 	CHECK_FLAG_VALUE(EA_INODE);
 	CHECK_FLAG_VALUE(EOFBLOCKS);
+	CHECK_FLAG_VALUE(SNAPFILE);
+	CHECK_FLAG_VALUE(SNAPFILE_DELETED);
+	CHECK_FLAG_VALUE(SNAPFILE_SHRUNK);
 	CHECK_FLAG_VALUE(RESERVED);
 }
 
@@ -803,6 +815,14 @@ struct ext4_inode_info {
 	struct list_head i_orphan;	/* unlinked but open inodes */
 
 	/*
+	 * In-memory snapshot list overrides i_orphan to link snapshot inodes,
+	 * but unlike the real orphan list, the next snapshot inode number
+	 * is stored in i_next_snapshot_ino and not in i_dtime
+	 */
+#define i_snaplist i_orphan
+	__u32	i_next_snapshot_ino;
+
+	/*
 	 * i_disksize keeps track of what the inode size is ON DISK, not
 	 * in memory.  During truncate, i_size is set to the new size by
 	 * the VFS prior to calling ext4_truncate(), but the filesystem won't
@@ -1158,6 +1178,8 @@ struct ext4_sb_info {
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
 	struct block_device *journal_bdev;
+	struct mutex s_snapshot_mutex;		/* protects 2 fields below: */
+	struct inode *s_active_snapshot;	/* [ s_snapshot_mutex ] */
 #ifdef CONFIG_JBD2_DEBUG
 	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
 	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
@@ -1274,8 +1296,31 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_LAST
 };
 
+/*
+ * Snapshot dynamic state flags (starting at offset EXT4_STATE_LAST)
+ * These flags are read by GETSNAPFLAGS ioctl and interpreted by the lssnap
+ * utility.  Do not change these values.
+ */
+enum {
+	EXT4_SNAPSTATE_LIST = 0,	/* snapshot is on list (S) */
+	EXT4_SNAPSTATE_ENABLED = 1,	/* snapshot is enabled (n) */
+	EXT4_SNAPSTATE_ACTIVE = 2,	/* snapshot is active  (a) */
+	EXT4_SNAPSTATE_INUSE = 3,	/* snapshot is in-use  (p) */
+	EXT4_SNAPSTATE_DELETED = 4,	/* snapshot is deleted (s) */
+	EXT4_SNAPSTATE_SHRUNK = 5,	/* snapshot was shrunk (h) */
+	EXT4_SNAPSTATE_OPEN = 6,	/* snapshot is mounted (o) */
+	EXT4_SNAPSTATE_TAGGED = 7,	/* snapshot is tagged  (t) */
+	EXT4_SNAPSTATE_LAST
+};
+
+#define EXT4_SNAPSTATE_MASK		\
+	((1UL << EXT4_SNAPSTATE_LAST) - 1)
+
+
+/* atomic single bit funcs */
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
 static inline int ext4_test_inode_##name(struct inode *inode, int bit)	\
 {									\
@@ -1290,9 +1335,28 @@ static inline void ext4_clear_inode_##name(struct inode *inode, int bit) \
 	clear_bit(bit + (offset), &EXT4_I(inode)->i_##field);		\
 }
 
+/* non-atomic multi bit funcs */
+#define EXT4_INODE_FLAGS_FNS(name, field, offset)			\
+static inline int ext4_get_##name##_flags(struct inode *inode)		\
+{									\
+	return EXT4_I(inode)->i_##field >> (offset);			\
+}									\
+static inline void ext4_set_##name##_flags(struct inode *inode,		\
+						unsigned long flags)	\
+{									\
+	EXT4_I(inode)->i_##field |= (flags << (offset));		\
+}									\
+static inline void ext4_clear_##name##_flags(struct inode *inode,	\
+						unsigned long flags)	\
+{									\
+	EXT4_I(inode)->i_##field &= ~(flags << (offset));		\
+}
+
 EXT4_INODE_BIT_FNS(flag, flags, 0)
 #if (BITS_PER_LONG < 64)
 EXT4_INODE_BIT_FNS(state, state_flags, 0)
+EXT4_INODE_BIT_FNS(snapstate, state_flags, EXT4_STATE_LAST)
+EXT4_INODE_FLAGS_FNS(snapstate, state_flags, EXT4_STATE_LAST)
 
 static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
@@ -1300,6 +1364,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 }
 #else
 EXT4_INODE_BIT_FNS(state, flags, 32)
+EXT4_INODE_BIT_FNS(snapstate, flags, 32 + EXT4_STATE_LAST)
+EXT4_INODE_FLAGS_FNS(snapstate, flags, 32 + EXT4_STATE_LAST)
 
 static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
@@ -1314,6 +1380,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #endif
 
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
+#define NEXT_SNAPSHOT(inode) (EXT4_I(inode)->i_next_snapshot_ino)
 
 /*
  * Codes for operating systems
@@ -1781,6 +1848,10 @@ extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+
+/* snapshot_inode.c */
+extern int ext4_snapshot_readpage(struct file *file, struct page *page);
+
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
@@ -2004,6 +2075,12 @@ struct ext4_group_info {
 	void            *bb_bitmap;
 #endif
 	struct rw_semaphore alloc_sem;
+	/*
+	 * bg_cow_bitmap is reset to zero on mount time and on every snapshot
+	 * take and initialized lazily on first block group write access.
+	 * bg_cow_bitmap is protected by sb_bgl_lock().
+	 */
+	unsigned long bg_cow_bitmap;	/* COW bitmap cache */
 	ext4_grpblk_t	bb_counters[];	/* Nr of free power-of-two-block
 					 * regions, index is order.
 					 * bb_counters[3] = 5 means
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index ea3a0a0..e0fef0d 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -369,6 +369,8 @@ static inline int ext4_snapshot_should_move_data(struct inode *inode)
 		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 0;
+	if (ext4_snapshot_excluded(inode))
+		return 0;
 	/* when a data block is journaled, it is already COWed as metadata */
 	if (ext4_should_journal_data(inode))
 		return 0;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 831d49a..ba928a7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1048,8 +1048,12 @@ got:
 		goto fail_free_drop;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
-		/* set extent flag only for directory, file and normal symlink*/
-		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
+		/*
+		 * Set extent flag only for non-snapshot file, directory
+		 * and normal symlink
+		 */
+		if ((S_ISREG(mode) && !ext4_snapshot_file(inode)) ||
+				S_ISDIR(mode) || S_ISLNK(mode)) {
 			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 			ext4_ext_tree_init(handle, inode);
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 866ac36..4ec5f02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4162,9 +4162,38 @@ static const struct address_space_operations ext4_da_aops = {
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
+static int ext4_no_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	unlock_page(page);
+	return -EIO;
+}
+
+/*
+ * Snapshot file page operations:
+ * always readpage (by page) with buffer tracked read.
+ * user cannot writepage or direct_IO to a snapshot file.
+ *
+ * snapshot file pages are written to disk after a COW operation in "ordered"
+ * mode and are never changed after that again, so there is no data corruption
+ * risk when using "ordered" mode on snapshot files.
+ * some snapshot data pages are written to disk by sync_dirty_buffer(), namely
+ * the snapshot COW bitmaps and a few initial blocks copied on snapshot_take().
+ */
+static const struct address_space_operations ext4_snapfile_aops = {
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_no_writepage,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+};
 
 void ext4_set_aops(struct inode *inode)
 {
+	if (ext4_snapshot_file(inode))
+		inode->i_mapping->a_ops = &ext4_snapfile_aops;
+	else
 	if (ext4_should_order_data(inode) &&
 		test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops = &ext4_da_aops;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c345d1..e3ebd7d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -745,6 +745,8 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
+	if (EXT4_SNAPSHOTS(sb))
+		ext4_snapshot_destroy(sb);
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
@@ -3474,6 +3476,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_root = NULL;
 
+	mutex_init(&sbi->s_snapshot_mutex);
+	sbi->s_active_snapshot = NULL;
+
 	needs_recovery = (es->s_last_orphan != 0 ||
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
 				    EXT4_FEATURE_INCOMPAT_RECOVER));
@@ -3676,6 +3681,10 @@ no_journal:
 		goto failed_mount4;
 	};
 
+	if (EXT4_SNAPSHOTS(sb) &&
+			ext4_snapshot_load(sb, es, sb->s_flags & MS_RDONLY))
+		/* XXX: how can we fail and force read-only at this point? */
+		ext4_error(sb, "load snapshot failed\n");
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
-- 
1.7.0.4

