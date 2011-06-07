From: amir73il@users.sourceforge.net
Subject: [PATCH v1 27/36] ext4: snapshot list support
Date: Tue,  7 Jun 2011 18:07:54 +0300
Message-ID: <1307459283-22130-28-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1FGPKM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:11 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of multiple incremental snapshots.
Snapshot inodes are chained on a list starting at the super block,
both on-disk and in-memory, similar to the orphan inodes.
Unlink and truncate of snapshot inodes on the list is not allowed,
so an inode can never be chained on both orphan and snapshot lists.
We make use of this fact to overload the in-memory inode field
ext4_inode_info.i_orphan for the chaining of snapshots.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |    1 +
 fs/ext4/snapshot_ctl.c |  329 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/super.c        |    1 +
 3 files changed, 307 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8d82125..ea1f38a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1194,6 +1194,7 @@ struct ext4_sb_info {
 	struct block_device *journal_bdev;
 	struct mutex s_snapshot_mutex;		/* protects 2 fields below: */
 	struct inode *s_active_snapshot;	/* [ s_snapshot_mutex ] */
+	struct list_head s_snapshot_list;	/* [ s_snapshot_mutex ] */
 #ifdef CONFIG_JBD2_DEBUG
 	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
 	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index a610025..298405a 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -132,6 +132,168 @@ static void ext4_snapshot_reset_bitmap_cache(struct super_block *sb)
 }
 
 /*
+ * A modified version of ext4_orphan_add(), used to add a snapshot inode
+ * to the head of the on-disk and in-memory lists.
+ * in-memory i_orphan list field is overloaded, because inodes on snapshots
+ * list cannot be unlinked nor truncated.
+ */
+static int ext4_inode_list_add(handle_t *handle, struct inode *inode,
+		__u32 *i_next, __le32 *s_last,
+		struct list_head *s_list, const char *name)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_iloc iloc;
+	int err = 0, rc;
+
+	if (!ext4_handle_valid(handle))
+		return 0;
+
+	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
+	if (!list_empty(&EXT4_I(inode)->i_orphan))
+		goto out_unlock;
+
+	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
+	if (err)
+		goto out_unlock;
+
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto out_unlock;
+
+	snapshot_debug(4, "add inode %lu to %s list\n",
+			inode->i_ino, name);
+
+	/* Insert this inode at the head of the on-disk inode list... */
+	*i_next = le32_to_cpu(*s_last);
+	*s_last = cpu_to_le32(inode->i_ino);
+	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
+	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	if (!err)
+		err = rc;
+
+	/* Only add to the head of the in-memory list if all the
+	 * previous operations succeeded. */
+	if (!err)
+		list_add(&EXT4_I(inode)->i_orphan, s_list);
+
+	snapshot_debug(4, "last_%s will point to inode %lu\n",
+			name, inode->i_ino);
+	snapshot_debug(4, "%s inode %lu will point to inode %d\n",
+			name, inode->i_ino, *i_next);
+out_unlock:
+	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
+	ext4_std_error(inode->i_sb, err);
+	return err;
+}
+
+static int ext4_snapshot_list_add(handle_t *handle, struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	return ext4_inode_list_add(handle, inode, &NEXT_SNAPSHOT(inode),
+			&sbi->s_es->s_snapshot_list,
+			&sbi->s_snapshot_list, "snapshot");
+}
+
+#define NEXT_INODE_OFFSET (((char *)inode)-((char *)i_next))
+#define NEXT_INODE(i_prev) (*(__u32 *)(((char *)i_prev)-NEXT_INODE_OFFSET))
+
+/*
+ * A modified version of ext4_orphan_del(), used to remove a snapshot inode
+ * from the on-disk and in-memory lists.
+ * in-memory i_orphan list field is overloaded, because inodes on snapshots
+ * list cannot be unlinked nor truncated.
+ */
+static int ext4_inode_list_del(handle_t *handle, struct inode *inode,
+		__u32 *i_next, __le32 *s_last,
+		struct list_head *s_list, const char *name)
+{
+	struct list_head *prev;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi;
+	__u32 ino_next;
+	struct ext4_iloc iloc;
+	int err = 0;
+
+	/* ext4_handle_valid() assumes a valid handle_t pointer */
+	if (handle && !ext4_handle_valid(handle))
+		return 0;
+
+	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	if (list_empty(&ei->i_orphan))
+		goto out;
+
+	ino_next = *i_next;
+	prev = ei->i_orphan.prev;
+	sbi = EXT4_SB(inode->i_sb);
+
+	snapshot_debug(4, "remove inode %lu from %s list\n", inode->i_ino,
+		       name);
+
+	list_del_init(&ei->i_orphan);
+
+	/* If we're on an error path, we may not have a valid
+	 * transaction handle with which to update the orphan list on
+	 * disk, but we still need to remove the inode from the linked
+	 * list in memory. */
+	if (sbi->s_journal && !handle)
+		goto out;
+
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto out_err;
+
+	if (prev == s_list) {
+		snapshot_debug(4, "last_%s will point to inode %lu\n", name,
+					   (long unsigned int)ino_next);
+		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+		if (err)
+			goto out_brelse;
+		*s_last = cpu_to_le32(ino_next);
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
+	} else {
+		struct ext4_iloc iloc2;
+		struct inode *i_prev;
+		i_prev = &list_entry(prev, struct ext4_inode_info,
+				     i_orphan)->vfs_inode;
+
+		snapshot_debug(4, "%s inode %lu will point to inode %lu\n",
+			  name, i_prev->i_ino, (long unsigned int)ino_next);
+		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
+		if (err)
+			goto out_brelse;
+		NEXT_INODE(i_prev) = ino_next;
+		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
+	}
+	if (err)
+		goto out_brelse;
+	*i_next = 0;
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+
+out_err:
+	ext4_std_error(inode->i_sb, err);
+out:
+	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
+	return err;
+
+out_brelse:
+	brelse(iloc.bh);
+	goto out_err;
+}
+
+static int ext4_snapshot_list_del(handle_t *handle, struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	return ext4_inode_list_del(handle, inode, &NEXT_SNAPSHOT(inode),
+			&sbi->s_es->s_snapshot_list,
+			&sbi->s_snapshot_list, "snapshot");
+}
+
+
+/*
  * Snapshot control functions
  *
  * Snapshot files are controlled by changing snapshot flags with chattr and
@@ -395,11 +557,18 @@ static int ext4_snapshot_create(struct inode *inode)
 	ext4_fsblk_t bmap_blk = 0, imap_blk = 0, inode_blk = 0;
 	ext4_fsblk_t prev_inode_blk = 0;
 	ext4_fsblk_t snapshot_blocks = ext4_blocks_count(sbi->s_es);
-	if (active_snapshot) {
-		snapshot_debug(1, "failed to add snapshot because active "
-			       "snapshot (%u) has to be deleted first\n",
-			       active_snapshot->i_generation);
-		return -EINVAL;
+	struct list_head *l, *list = &sbi->s_snapshot_list;
+
+	if (!list_empty(list)) {
+		struct inode *last_snapshot =
+			&list_first_entry(list, struct ext4_inode_info,
+					  i_snaplist)->vfs_inode;
+		if (active_snapshot != last_snapshot) {
+			snapshot_debug(1, "failed to add snapshot because last"
+				       " snapshot (%u) is not active\n",
+				       last_snapshot->i_generation);
+			return -EINVAL;
+		}
 	}
 
 	/* prevent take of unlinked snapshot file */
@@ -455,14 +624,27 @@ static int ext4_snapshot_create(struct inode *inode)
 	/* record the file system size in the snapshot inode disksize field */
 	SNAPSHOT_SET_BLOCKS(inode, snapshot_blocks);
 
-	lock_super(sb);
-	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
-	sbi->s_es->s_snapshot_list = cpu_to_le32(inode->i_ino);
-	if (!err)
-		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	unlock_super(sb);
-	if (err)
+	/* add snapshot list reference */
+	if (!igrab(inode)) {
+		err = -EIO;
+		goto out_handle;
+	}
+	/*
+	 * First, the snapshot is added to the in-memory and on-disk list.
+	 * At the end of snapshot_take(), it will become the active snapshot
+	 * in-memory and on-disk.
+	 * Finally, if snapshot_create() or snapshot_take() has failed,
+	 * snapshot_update() will remove it from the in-memory and on-disk list.
+	 */
+	err = ext4_snapshot_list_add(handle, inode);
+	/* add snapshot list reference */
+	if (err) {
+		snapshot_debug(1, "failed to add snapshot (%u) to list\n",
+			       inode->i_generation);
+		iput(inode);
 		goto out_handle;
+	}
+	l = list->next;
 
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err)
@@ -609,8 +791,10 @@ next_snapshot:
 			err = -EIO;
 		goto out_handle;
 	}
-	if (ino == EXT4_ROOT_INO) {
-		ino = inode->i_ino;
+	if (l != list) {
+		ino = list_entry(l, struct ext4_inode_info,
+				i_snaplist)->vfs_inode.i_ino;
+		l = l->next;
 		goto alloc_inode_blocks;
 	}
 	snapshot_debug(1, "snapshot (%u) created\n", inode->i_generation);
@@ -695,6 +879,8 @@ static char *copy_inode_block_name[COPY_INODE_BLOCKS_NUM] = {
  */
 int ext4_snapshot_take(struct inode *inode)
 {
+	struct list_head *list = &EXT4_SB(inode->i_sb)->s_snapshot_list;
+	struct list_head *l = list->next;
 	struct super_block *sb = inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = NULL;
@@ -885,8 +1071,15 @@ fix_inode_copy:
 	sync_dirty_buffer(sbh);
 
 next_inode:
-	if (curr_inode->i_ino == EXT4_ROOT_INO) {
-		curr_inode = inode;
+	if (l == list && !fixing) {
+		/* done with copy pass - start fixing pass */
+		l = l->next;
+		fixing = 1;
+	}
+	if (l != list) {
+		curr_inode = &list_entry(l, struct ext4_inode_info,
+				       i_snaplist)->vfs_inode;
+		l = l->next;
 		goto copy_inode_blocks;
 	}
 
@@ -1082,14 +1275,11 @@ static int ext4_snapshot_remove(struct inode *inode)
 	if (err)
 		goto out_handle;
 
-	lock_super(inode->i_sb);
-	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
-	sbi->s_es->s_snapshot_list = 0;
-	if (!err)
-		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	unlock_super(inode->i_sb);
+	err = ext4_snapshot_list_del(handle, inode);
 	if (err)
 		goto out_handle;
+	/* remove snapshot list reference - taken on snapshot_create() */
+	iput(inode);
 	/*
 	 * At this point, this snapshot is empty and not on the snapshots list.
 	 * As long as it was on the list it had to have the LIST flag to prevent
@@ -1145,6 +1335,10 @@ int ext4_snapshot_load(struct super_block *sb, struct ext4_super_block *es,
 	int err = 0, num = 0, snapshot_id = 0;
 	int has_active = 0;
 
+	if (!list_empty(&EXT4_SB(sb)->s_snapshot_list)) {
+		snapshot_debug(1, "warning: snapshots already loaded!\n");
+		return -EINVAL;
+	}
 
 	if (!load_ino && active_ino) {
 		/* snapshots list is empty and active snapshot exists */
@@ -1197,8 +1391,10 @@ int ext4_snapshot_load(struct super_block *sb, struct ext4_super_block *es,
 			has_active = 1;
 		}
 
-		iput(inode);
-		break;
+		list_add_tail(&EXT4_I(inode)->i_snaplist,
+			      &EXT4_SB(sb)->s_snapshot_list);
+		load_ino = NEXT_SNAPSHOT(inode);
+		/* keep snapshot list reference */
 	}
 
 	if (err) {
@@ -1225,6 +1421,16 @@ int ext4_snapshot_load(struct super_block *sb, struct ext4_super_block *es,
  */
 void ext4_snapshot_destroy(struct super_block *sb)
 {
+	struct list_head *l, *n;
+	/* iterate safe because we are deleting from list and freeing the
+	 * inodes */
+	list_for_each_safe(l, n, &EXT4_SB(sb)->s_snapshot_list) {
+		struct inode *inode = &list_entry(l, struct ext4_inode_info,
+						  i_snaplist)->vfs_inode;
+		list_del_init(&EXT4_I(inode)->i_snaplist);
+		/* remove snapshot list reference */
+		iput(inode);
+	}
 	/* deactivate in-memory active snapshot - cannot fail */
 	(void) ext4_snapshot_set_active(sb, NULL);
 }
@@ -1244,6 +1450,11 @@ int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
 	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
 	struct inode *used_by = NULL; /* last non-deleted snapshot found */
 	int deleted;
+	struct inode *inode;
+	struct ext4_inode_info *ei;
+	int found_active = 0;
+	int found_enabled = 0;
+	struct list_head *prev;
 	int err = 0;
 
 	BUG_ON(read_only && cleanup);
@@ -1255,6 +1466,76 @@ int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
 					EXT4_SNAPSTATE_ACTIVE);
 	}
 
+	/* iterate safe from oldest snapshot backwards */
+	prev = EXT4_SB(sb)->s_snapshot_list.prev;
+	if (list_empty(prev))
+		return 0;
+
+update_snapshot:
+	ei = list_entry(prev, struct ext4_inode_info, i_snaplist);
+	inode = &ei->vfs_inode;
+	prev = ei->i_snaplist.prev;
+
+	/* all snapshots on the list have the LIST flag */
+	ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_LIST);
+	/* set the 'No_Dump' flag on all snapshots */
+	ext4_set_inode_flag(inode, EXT4_NODUMP_FL);
+
+	/*
+	 * snapshots later than active (failed take) should be removed.
+	 * no active snapshot means failed first snapshot take.
+	 */
+	if (found_active || !active_snapshot) {
+		if (!read_only)
+			err = ext4_snapshot_remove(inode);
+		goto prev_snapshot;
+	}
+
+	deleted = ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED);
+	if (!deleted && read_only)
+		/* auto enable snapshots on readonly mount */
+		ext4_snapshot_enable(inode);
+
+	/*
+	 * after completion of a snapshot management operation,
+	 * only the active snapshot can have the ACTIVE flag
+	 */
+	if (inode == active_snapshot) {
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE);
+		found_active = 1;
+		deleted = 0;
+	} else
+		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE);
+
+	if (found_enabled)
+		/* snapshot is in use by an older enabled snapshot */
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE);
+	else
+		/* snapshot is not in use by older enabled snapshots */
+		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE);
+
+	if (cleanup && deleted && !used_by)
+		/* remove permanently unused deleted snapshot */
+		err = ext4_snapshot_remove(inode);
+
+	if (!deleted) {
+		if (!found_active)
+			/* newer snapshots are potentially used by
+			 * this snapshot (when it is enabled) */
+			used_by = inode;
+		if (ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED))
+			found_enabled = 1;
+		else
+			SNAPSHOT_SET_DISABLED(inode);
+	} else
+		SNAPSHOT_SET_DISABLED(inode);
+
+prev_snapshot:
+	if (err)
+		return err;
+	/* update prev snapshot */
+	if (prev != &EXT4_SB(sb)->s_snapshot_list)
+		goto update_snapshot;
 
 	if (!active_snapshot || !cleanup || used_by)
 		return 0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fc8bfda..a1c4728 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3543,6 +3543,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	mutex_init(&sbi->s_snapshot_mutex);
 	sbi->s_active_snapshot = NULL;
+	INIT_LIST_HEAD(&sbi->s_snapshot_list); /* snapshot files */
 
 	needs_recovery = (es->s_last_orphan != 0 ||
 			  EXT4_HAS_INCOMPAT_FEATURE(sb,
-- 
1.7.4.1

