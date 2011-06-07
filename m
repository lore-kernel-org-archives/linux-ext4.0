From: amir73il@users.sourceforge.net
Subject: [PATCH v1 09/36] ext4: snapshot file
Date: Tue,  7 Jun 2011 18:07:36 +0300
Message-ID: <1307459283-22130-10-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab1FGPJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:19 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:19 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Ext4 snapshot implementation as a file inside the file system.
Snapshot files are marked with the snapfile flag and have special
read-only address space ops.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |   70 ++++++++++++++-
 fs/ext4/ext4_jbd2.h    |    2 +
 fs/ext4/ialloc.c       |    8 ++-
 fs/ext4/inode.c        |   29 ++++++
 fs/ext4/snapshot.h     |  106 ++++++++++++++++++++++
 fs/ext4/snapshot_ctl.c |  227 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c        |    9 ++
 7 files changed, 446 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a5bc3ab..7f96ba5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -348,17 +348,23 @@ struct flex_groups {
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
@@ -405,6 +411,9 @@ enum {
 	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
+	EXT4_INODE_SNAPFILE	= 24,	/* Snapshot file/dir */
+	EXT4_INODE_SNAPFILE_DELETED = 26,	/* Snapshot is deleted */
+	EXT4_INODE_SNAPFILE_SHRUNK = 27,	/* Snapshot was shrunk */
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
@@ -451,6 +460,9 @@ static inline void ext4_check_flag_values(void)
 	CHECK_FLAG_VALUE(EXTENTS);
 	CHECK_FLAG_VALUE(EA_INODE);
 	CHECK_FLAG_VALUE(EOFBLOCKS);
+	CHECK_FLAG_VALUE(SNAPFILE);
+	CHECK_FLAG_VALUE(SNAPFILE_DELETED);
+	CHECK_FLAG_VALUE(SNAPFILE_SHRUNK);
 	CHECK_FLAG_VALUE(RESERVED);
 }
 
@@ -790,6 +802,14 @@ struct ext4_inode_info {
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
@@ -1145,6 +1165,8 @@ struct ext4_sb_info {
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
 	struct block_device *journal_bdev;
+	struct mutex s_snapshot_mutex;		/* protects 2 fields below: */
+	struct inode *s_active_snapshot;	/* [ s_snapshot_mutex ] */
 #ifdef CONFIG_JBD2_DEBUG
 	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
 	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
@@ -1261,6 +1283,24 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_LAST
+};
+
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
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
@@ -1277,9 +1317,19 @@ static inline void ext4_clear_inode_##name(struct inode *inode, int bit) \
 	clear_bit(bit + (offset), &EXT4_I(inode)->i_##field);		\
 }
 
+#define EXT4_INODE_FLAGS_FNS(name, field, offset, count)		\
+static inline int ext4_get_##name##_flags(struct inode *inode)		\
+{									\
+	return (EXT4_I(inode)->i_##field >> (offset)) &			\
+				((1UL << (count)) - 1);			\
+}									\
+
 EXT4_INODE_BIT_FNS(flag, flags, 0)
 #if (BITS_PER_LONG < 64)
 EXT4_INODE_BIT_FNS(state, state_flags, 0)
+EXT4_INODE_BIT_FNS(snapstate, state_flags, EXT4_STATE_LAST)
+EXT4_INODE_FLAGS_FNS(snapstate, state_flags, EXT4_STATE_LAST, \
+					EXT4_SNAPSTATE_LAST)
 
 static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
@@ -1287,6 +1337,9 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 }
 #else
 EXT4_INODE_BIT_FNS(state, flags, 32)
+EXT4_INODE_BIT_FNS(snapstate, flags, 32 + EXT4_STATE_LAST)
+EXT4_INODE_FLAGS_FNS(snapstate, flags, 32 + EXT4_STATE_LAST, \
+					EXT4_SNAPSTATE_LAST)
 
 static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
@@ -1301,6 +1354,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #endif
 
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
+#define NEXT_SNAPSHOT(inode) (EXT4_I(inode)->i_next_snapshot_ino)
 
 /*
  * Codes for operating systems
@@ -1783,6 +1837,10 @@ extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
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
@@ -2006,6 +2064,12 @@ struct ext4_group_info {
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
index 1dfd439..4d57fcb 100644
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
index 40ca5bc..b0e5749 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1049,8 +1049,12 @@ got:
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
index 1f1ba2b..0468ef2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4139,9 +4139,38 @@ static const struct address_space_operations ext4_da_aops = {
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
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 71edd71..19e3416 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -288,6 +288,14 @@ static inline int ext4_snapshot_get_delete_access(handle_t *handle,
 
 /* snapshot_ctl.c */
 
+/*
+ * Snapshot constructor/destructor
+ */
+extern int ext4_snapshot_load(struct super_block *sb,
+		struct ext4_super_block *es, int read_only);
+extern int ext4_snapshot_update(struct super_block *sb, int cleanup,
+		int read_only);
+extern void ext4_snapshot_destroy(struct super_block *sb);
 
 static inline int init_ext4_snapshot(void)
 {
@@ -299,7 +307,105 @@ static inline void exit_ext4_snapshot(void)
 }
 
 
+/* tests if @inode is a snapshot file */
+static inline int ext4_snapshot_file(struct inode *inode)
+{
+	if (!S_ISREG(inode->i_mode))
+		/* a snapshots directory */
+		return 0;
+	return ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE);
+}
+
+/* tests if @inode is on the on-disk snapshot list */
+static inline int ext4_snapshot_list(struct inode *inode)
+{
+	return ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_LIST);
+}
+
+/*
+ * ext4_snapshot_excluded():
+ * Checks if the file should be excluded from snapshot.
+ *
+ * Returns 0 for normal file.
+ * Returns > 0 for 'excluded' file.
+ * Returns < 0 for 'ignored' file (stonger than 'excluded').
+ *
+ * Excluded and ignored file blocks are not moved to snapshot.
+ * Ignored file metadata blocks are not COWed to snapshot.
+ * Excluded file metadata blocks are zeroed in the snapshot file.
+ * XXX: Excluded files code is experimental,
+ *      but ignored files code isn't.
+ */
+static inline int ext4_snapshot_excluded(struct inode *inode)
+{
+	/* directory blocks and global filesystem blocks cannot be 'excluded' */
+	if (!inode || !S_ISREG(inode->i_mode))
+		return 0;
+	/* snapshot files are 'ignored' */
+	if (ext4_snapshot_file(inode))
+		return -1;
+	return 0;
+}
+
+/* tests if the file system has an active snapshot */
+static inline int ext4_snapshot_active(struct ext4_sb_info *sbi)
+{
+	if (unlikely((sbi)->s_active_snapshot))
+		return 1;
+	return 0;
+}
 
+/*
+ * tests if the file system has an active snapshot and returns its inode.
+ * active snapshot is only changed under journal_lock_updates(),
+ * so it is safe to use the returned inode during a transaction.
+ */
+static inline struct inode *ext4_snapshot_has_active(struct super_block *sb)
+{
+	return EXT4_SB(sb)->s_active_snapshot;
+}
+
+/*
+ * tests if @inode is the current active snapshot.
+ * active snapshot is only changed under journal_lock_updates(),
+ * so the test result never changes during a transaction.
+ */
+static inline int ext4_snapshot_is_active(struct inode *inode)
+{
+	return (inode == EXT4_SB(inode->i_sb)->s_active_snapshot);
+}
+
+
+#define SNAPSHOT_TRANSACTION_ID(sb)				\
+	((EXT4_I(EXT4_SB(sb)->s_active_snapshot))->i_datasync_tid)
+
+/**
+ * set transaction ID for active snapshot
+ *
+ * this function is called after freeze_super() returns but before
+ * calling unfreeze_super() to record the tid at time when a snapshot is
+ * taken.
+ */
+static inline void ext4_snapshot_set_tid(struct super_block *sb)
+{
+	BUG_ON(!ext4_snapshot_active(EXT4_SB(sb)));
+	SNAPSHOT_TRANSACTION_ID(sb) =
+			EXT4_SB(sb)->s_journal->j_transaction_sequence;
+}
+
+/* get trancation ID of active snapshot */
+static inline tid_t ext4_snapshot_get_tid(struct super_block *sb)
+{
+	BUG_ON(!ext4_snapshot_active(EXT4_SB(sb)));
+	return SNAPSHOT_TRANSACTION_ID(sb);
+}
+
+/* test if thereis a mow that is in or before current transcation */
+static inline int ext4_snapshot_mow_in_tid(struct inode *inode)
+{
+	return tid_geq(EXT4_I(inode)->i_datasync_tid,
+		      ext4_snapshot_get_tid(inode->i_sb));
+}
 
 
 #else /* CONFIG_EXT4_FS_SNAPSHOT */
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 201ef20..1abda77 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -15,8 +15,235 @@
 #include <linux/statfs.h>
 #include "ext4_jbd2.h"
 #include "snapshot.h"
+
+/*
+ * General snapshot locking semantics:
+ *
+ * The snapshot_mutex:
+ * -------------------
+ * The majority of the code in the snapshot_{ctl,debug}.c files is called from
+ * very few entry points in the code:
+ * 1. {init,exit}_ext4_fs() - calls {init,exit}_ext4_snapshot() under BGL.
+ * 2. ext4_{fill,put}_super() - calls ext4_snapshot_{load,destroy}() under
+ *    VFS sb_lock, while f/s is not accessible to users.
+ * 3. ext4_ioctl() - only place that takes snapshot_mutex (after i_mutex)
+ *    and only entry point to snapshot control functions below.
+ *
+ * From the rules above it follows that all fields accessed inside
+ * snapshot_{ctl,debug}.c are protected by one of the following:
+ * - snapshot_mutex during snapshot control operations.
+ * - VFS sb_lock during f/s mount/umount time.
+ * - Big kernel lock during module init time.
+ * Needless to say, either of the above is sufficient.
+ * So if a field is accessed only inside snapshot_*.c it should be safe.
+ *
+ * The transaction handle:
+ * -----------------------
+ * Snapshot COW code (in snapshot.c) is called from block access hooks during a
+ * transaction (with a transaction handle). This guaranties safe read access to
+ * s_active_snapshot, without taking snapshot_mutex, because the latter is only
+ * changed under journal_lock_updates() (while no transaction handles exist).
+ *
+ * The transaction handle is a per task struct, so there is no need to protect
+ * fields on that struct (i.e. h_cowing, h_cow_*).
+ */
+
+/*
+ * ext4_snapshot_set_active - set the current active snapshot
+ * First, if current active snapshot exists, it is deactivated.
+ * Then, if @inode is not NULL, the active snapshot is set to @inode.
+ *
+ * Called from ext4_snapshot_take() and ext4_snapshot_update() under
+ * journal_lock_updates() and snapshot_mutex.
+ * Called from ext4_snapshot_{load,destroy}() under sb_lock.
+ *
+ * Returns 0 on success and <0 on error.
+ */
+static int ext4_snapshot_set_active(struct super_block *sb,
+		struct inode *inode)
+{
+	struct inode *old = EXT4_SB(sb)->s_active_snapshot;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	if (old == inode)
+		return 0;
+
+	/* add new active snapshot reference */
+	if (inode && !igrab(inode))
+		return -EIO;
+
+	/* point of no return - replace old with new snapshot */
+	if (old) {
+		ext4_clear_inode_snapstate(old, EXT4_SNAPSTATE_ACTIVE);
+		snapshot_debug(1, "snapshot (%u) deactivated\n",
+			       old->i_generation);
+		/* remove old active snapshot reference */
+		iput(old);
+	}
+	if (inode) {
+		/*
+		 * Set up the jbd2_inode - we are about to file_inode soon...
+		 */
+		if (!ei->jinode) {
+			struct jbd2_inode *jinode;
+			jinode = jbd2_alloc_inode(GFP_KERNEL);
+
+			spin_lock(&inode->i_lock);
+			if (!ei->jinode) {
+				if (!jinode) {
+					spin_unlock(&inode->i_lock);
+					return -ENOMEM;
+				}
+				ei->jinode = jinode;
+				jbd2_journal_init_jbd_inode(ei->jinode, inode);
+				jinode = NULL;
+			}
+			spin_unlock(&inode->i_lock);
+			if (unlikely(jinode != NULL))
+				jbd2_free_inode(jinode);
+		}
+		/* ACTIVE implies LIST */
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_LIST);
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE);
+		snapshot_debug(1, "snapshot (%u) activated\n",
+			       inode->i_generation);
+	}
+	EXT4_SB(sb)->s_active_snapshot = inode;
+
+	return 0;
+}
 #define ext4_snapshot_reset_bitmap_cache(sb, init) 0
 
 /*
  * Snapshot constructor/destructor
  */
+/*
+ * ext4_snapshot_load - load the on-disk snapshot list to memory.
+ * Start with last (or active) snapshot and continue to older snapshots.
+ * If snapshot load fails before active snapshot, force read-only mount.
+ * If snapshot load fails after active snapshot, allow read-write mount.
+ * Called from ext4_fill_super() under sb_lock during mount time.
+ *
+ * Return values:
+ * = 0 - on-disk snapshot list is empty or active snapshot loaded
+ * < 0 - error loading active snapshot
+ */
+int ext4_snapshot_load(struct super_block *sb, struct ext4_super_block *es,
+		int read_only)
+{
+	__u32 active_ino = le32_to_cpu(es->s_snapshot_inum);
+	__u32 load_ino = le32_to_cpu(es->s_snapshot_list);
+	int err = 0, num = 0, snapshot_id = 0;
+	int has_active = 0;
+
+
+	if (!load_ino && active_ino) {
+		/* snapshots list is empty and active snapshot exists */
+		if (!read_only)
+			/* reset list head to active snapshot */
+			es->s_snapshot_list = es->s_snapshot_inum;
+		/* try to load active snapshot */
+		load_ino = le32_to_cpu(es->s_snapshot_inum);
+	}
+
+	while (load_ino) {
+		struct inode *inode;
+
+		inode = ext4_orphan_get(sb, load_ino);
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
+		} else if (!ext4_snapshot_file(inode)) {
+			iput(inode);
+			err = -EIO;
+		}
+
+		if (err && num == 0 && load_ino != active_ino) {
+			/* failed to load last non-active snapshot */
+			if (!read_only)
+				/* reset list head to active snapshot */
+				es->s_snapshot_list = es->s_snapshot_inum;
+			snapshot_debug(1, "warning: failed to load "
+					"last snapshot (%u) - trying to load "
+					"active snapshot (%u).\n",
+					load_ino, active_ino);
+			/* try to load active snapshot */
+			load_ino = active_ino;
+			err = 0;
+			continue;
+		}
+
+		if (err)
+			break;
+
+		snapshot_id = inode->i_generation;
+		snapshot_debug(1, "snapshot (%d) loaded\n",
+			       snapshot_id);
+		num++;
+
+		if (!has_active && load_ino == active_ino) {
+			/* active snapshot was loaded */
+			err = ext4_snapshot_set_active(sb, inode);
+			if (err)
+				break;
+			has_active = 1;
+		}
+
+		iput(inode);
+		break;
+	}
+
+	if (err) {
+		/* failed to load active snapshot */
+		snapshot_debug(1, "warning: failed to load "
+				"snapshot (ino=%u) - "
+				"forcing read-only mount!\n",
+				load_ino);
+		/* force read-only mount */
+		return read_only ? 0 : err;
+	}
+
+	if (num > 0) {
+		err = ext4_snapshot_update(sb, 0, read_only);
+		snapshot_debug(1, "%d snapshots loaded\n", num);
+	}
+	return err;
+}
+
+/*
+ * ext4_snapshot_destroy() releases the in-memory snapshot list
+ * Called from ext4_put_super() under sb_lock during umount time.
+ * This function cannot fail.
+ */
+void ext4_snapshot_destroy(struct super_block *sb)
+{
+	/* deactivate in-memory active snapshot - cannot fail */
+	(void) ext4_snapshot_set_active(sb, NULL);
+}
+
+/*
+ * ext4_snapshot_update - iterate snapshot list and update snapshots status.
+ * @sb: handle to file system super block.
+ * @cleanup: if true, shrink/merge/cleanup all snapshots marked for deletion.
+ * @read_only: if true, don't remove snapshot after failed take.
+ *
+ * Called from ext4_ioctl() under snapshot_mutex.
+ * Called from snapshot_load() under sb_lock with @cleanup=0.
+ * Returns 0 on success and <0 on error.
+ */
+int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
+{
+	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
+	int err = 0;
+
+	BUG_ON(read_only && cleanup);
+	if (active_snapshot) {
+		/* ACTIVE implies LIST */
+		ext4_set_inode_snapstate(active_snapshot,
+					EXT4_SNAPSTATE_LIST);
+		ext4_set_inode_snapstate(active_snapshot,
+					EXT4_SNAPSTATE_ACTIVE);
+	}
+
+
+	return err;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61e9173..7655010 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -761,6 +761,8 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
+	if (EXT4_SNAPSHOTS(sb))
+		ext4_snapshot_destroy(sb);
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
@@ -3521,6 +3523,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_root = NULL;
 
+	mutex_init(&sbi->s_snapshot_mutex);
+	sbi->s_active_snapshot = NULL;
+
 	needs_recovery = (es->s_last_orphan != 0 ||
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
 				    EXT4_FEATURE_INCOMPAT_RECOVER));
@@ -3727,6 +3732,10 @@ no_journal:
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
1.7.4.1

