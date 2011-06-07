From: amir73il@users.sourceforge.net
Subject: [PATCH v1 33/36] ext4: snapshot cleanup
Date: Tue,  7 Jun 2011 18:08:00 +0300
Message-ID: <1307459283-22130-34-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51987 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1FGPK1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:27 -0400
Received: by wwk4 with SMTP id 4so2575454wwk.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:26 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Cleanup snapshots list and reclaim unused blocks of deleted snapshots.
Oldest snapshot can be removed from list and its blocks can be freed.
Non-oldest snapshots have to be shrunk and merged before they can be
removed from the list.  All snapshot blocks must be excluded in order
to properly shrink/merge deleted old snapshots.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |   16 ++++++++
 fs/ext4/inode.c        |   19 ++++++----
 fs/ext4/snapshot_ctl.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 118 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 34aaade..6f0f310 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1737,6 +1737,12 @@ struct ext4_features {
 	struct completion f_kobj_unregister;
 };
 
+typedef struct {
+	__le32	*p;
+	__le32	key;
+	struct buffer_head *bh;
+} Indirect;
+
 /*
  * Function prototypes
  */
@@ -1878,6 +1884,16 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 /* snapshot_inode.c */
 extern int ext4_snapshot_readpage(struct file *file, struct page *page);
 
+extern int ext4_block_to_path(struct inode *inode,
+			      ext4_lblk_t i_block,
+			      ext4_lblk_t offsets[4], int *boundary);
+extern Indirect *ext4_get_branch(struct inode *inode, int depth,
+				 ext4_lblk_t  *offsets,
+				 Indirect chain[4], int *err);
+extern void ext4_free_branches(handle_t *handle, struct inode *inode,
+				struct buffer_head *parent_bh,
+				__le32 *first, __le32 *last,
+				int depth);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 89a97da..5199035 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -176,6 +176,14 @@ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
 	 */
 	BUG_ON(EXT4_JOURNAL(inode) == NULL);
 	jbd_debug(2, "restarting handle %p\n", handle);
+	/*
+	 * Snapshot shrink/merge/clean do not take i_data_sem, so we cannot
+	 * release it here. Luckily, snapshot files are not writable,
+	 * so deadlock with ext4_map_blocks on writepage is impossible.
+	 * Snapshot files also don't have preallocations.
+	 */
+	if (ext4_snapshot_file(inode))
+		return ext4_journal_restart(handle, nblocks);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_journal_restart(handle, nblocks);
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -281,11 +289,6 @@ no_delete:
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
-typedef struct {
-	__le32	*p;
-	__le32	key;
-	struct buffer_head *bh;
-} Indirect;
 
 static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 {
@@ -324,7 +327,7 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
  * get there at all.
  */
 
-static int ext4_block_to_path(struct inode *inode,
+int ext4_block_to_path(struct inode *inode,
 			      ext4_lblk_t i_block,
 			      ext4_lblk_t offsets[4], int *boundary)
 {
@@ -440,7 +443,7 @@ static int __ext4_check_blockref(const char *function, unsigned int line,
  *      Need to be called with
  *      down_read(&EXT4_I(inode)->i_data_sem)
  */
-static Indirect *ext4_get_branch(struct inode *inode, int depth,
+Indirect *ext4_get_branch(struct inode *inode, int depth,
 				 ext4_lblk_t  *offsets,
 				 Indirect chain[4], int *err)
 {
@@ -4679,7 +4682,7 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
  *	stored as little-endian 32-bit) and updating @inode->i_blocks
  *	appropriately.
  */
-static void ext4_free_branches(handle_t *handle, struct inode *inode,
+void ext4_free_branches(handle_t *handle, struct inode *inode,
 			       struct buffer_head *parent_bh,
 			       __le32 *first, __le32 *last, int depth)
 {
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 9e39c04..13048f5 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -1149,6 +1149,53 @@ out_err:
 }
 
 /*
+ * ext4_snapshot_clean() frees snapshot file blocks
+ * before removing snapshot file from snapshots list.
+ * Called from ext4_snapshot_remove() under snapshot_mutex.
+ *
+ * Returns 0 on success and < 0 on error.
+ */
+static int ext4_snapshot_clean(handle_t *handle, struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int i;
+
+	if (!ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "ext4_snapshot_clean() called with "
+			       "snapshot file (ino=%lu) not on list\n",
+			       inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE)) {
+		snapshot_debug(1, "clean of active snapshot (%u) "
+			       "is not allowed.\n",
+			       inode->i_generation);
+		return -EPERM;
+	}
+
+	/*
+	 * A very simplified version of ext4_truncate() for snapshot files.
+	 * A non-active snapshot file never allocates new blocks and only frees
+	 * blocks under snapshot_mutex, so no need to take truncate_mutex here.
+	 * No need to add inode to orphan list for post crash truncate, because
+	 * snapshot is still on the snapshot list and marked for deletion.
+	 * Free DIND branch last, to keep snapshot's super block around longer.
+	 */
+	for (i = EXT4_SNAPSHOT_N_BLOCKS - 1; i >= EXT4_DIND_BLOCK; i--) {
+		int depth = (i == EXT4_DIND_BLOCK ? 2 : 3);
+		int j = i%EXT4_N_BLOCKS;
+
+		if (!ei->i_data[j])
+			continue;
+		ext4_free_branches(handle, inode, NULL,
+				ei->i_data+j, ei->i_data+j+1, depth);
+		ei->i_data[j] = 0;
+	}
+	return 0;
+}
+
+/*
  * ext4_snapshot_enable() enables snapshot mount
  * sets the in-use flag and the active snapshot
  * Called under i_mutex and snapshot_mutex
@@ -1277,6 +1324,17 @@ static int ext4_snapshot_remove(struct inode *inode)
 	}
 	sbi = EXT4_SB(inode->i_sb);
 
+	/* free snapshot inode blocks */
+	err = ext4_snapshot_clean(handle, inode);
+	if (err)
+		goto out_handle;
+
+	/* reset i_size and i_disksize and invalidate page cache */
+	SNAPSHOT_SET_REMOVED(inode);
+
+	err = ext4_mark_inode_dirty(handle, inode);
+	if (err)
+		goto out_handle;
 
 	err = extend_or_restart_transaction_inode(handle, inode, 2);
 	if (err)
@@ -1321,6 +1379,34 @@ out_err:
 }
 
 /*
+ * ext4_snapshot_cleanup - shrink/merge/remove snapshot marked for deletion
+ * @inode - inode in question
+ * @used_by - latest non-deleted snapshot
+ * @deleted - true if snapshot is marked for deletion and not active
+ * @need_shrink - counter of deleted snapshots to shrink
+ * @need_merge - counter of deleted snapshots to merge
+ *
+ * Deleted snapshot with no older non-deleted snapshot - remove from list
+ * Deleted snapshot with no older enabled snapshot - add to merge count
+ * Deleted snapshot with older enabled snapshot - add to shrink count
+ * Non-deleted snapshot - shrink and merge deleted snapshots group
+ *
+ * Called from ext4_snapshot_update() under snapshot_mutex.
+ * Returns 0 on success and <0 on error.
+ */
+static int ext4_snapshot_cleanup(struct inode *inode, struct inode *used_by,
+		int deleted, int *need_shrink, int *need_merge)
+{
+	int err = 0;
+
+	if (deleted && !used_by)
+		/* remove permanently unused deleted snapshot */
+		return ext4_snapshot_remove(inode);
+
+	return 0;
+}
+
+/*
  * Snapshot constructor/destructor
  */
 /*
@@ -1462,6 +1548,8 @@ int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
 	int found_active = 0;
 	int found_enabled = 0;
 	struct list_head *prev;
+	int need_shrink = 0;
+	int need_merge = 0;
 	int err = 0;
 
 	BUG_ON(read_only && cleanup);
@@ -1521,9 +1609,9 @@ update_snapshot:
 		/* snapshot is not in use by older enabled snapshots */
 		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE);
 
-	if (cleanup && deleted && !used_by)
-		/* remove permanently unused deleted snapshot */
-		err = ext4_snapshot_remove(inode);
+	if (cleanup)
+		err = ext4_snapshot_cleanup(inode, used_by, deleted,
+				&need_shrink, &need_merge);
 
 	if (!deleted) {
 		if (!found_active)
-- 
1.7.4.1

