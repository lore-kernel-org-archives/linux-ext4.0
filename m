From: amir73il@users.sourceforge.net
Subject: [PATCH v1 18/36] ext4: snapshot control
Date: Tue,  7 Jun 2011 18:07:45 +0300
Message-ID: <1307459283-22130-19-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:45 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:45 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Snapshot control with chsnap/lssnap.
Take/delete snapshot with chsnap +/-S.
Enable/disable snapshot with chsnap +/-n.
Show snapshot status with lssnap.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |    2 +
 fs/ext4/ioctl.c        |  117 ++++++++++
 fs/ext4/snapshot.h     |    8 +
 fs/ext4/snapshot_ctl.c |  593 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 720 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7d66f92..e76faae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -584,6 +584,8 @@ struct ext4_new_group_data {
  /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
+#define EXT4_IOC_GETSNAPFLAGS		_IOR('f', 13, long)
+#define EXT4_IOC_SETSNAPFLAGS		_IOW('f', 14, long)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a8b1254..1ed6f50 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -83,6 +83,21 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			if (!capable(CAP_SYS_RESOURCE))
 				goto flags_out;
 		}
+
+		/*
+		 * The SNAPFILE flag can only be changed on directories by
+		 * the relevant capability.
+		 * It can only be inherited by regular files.
+		 */
+		if ((flags ^ oldflags) & EXT4_SNAPFILE_FL) {
+			if (!S_ISDIR(inode->i_mode)) {
+				err = -ENOTDIR;
+				goto flags_out;
+			}
+			if (!capable(CAP_SYS_RESOURCE))
+				goto flags_out;
+		}
+
 		if (oldflags & EXT4_EXTENTS_FL) {
 			/* We don't support clearning extent flags */
 			if (!(flags & EXT4_EXTENTS_FL)) {
@@ -139,6 +154,102 @@ flags_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
+	case EXT4_IOC_GETSNAPFLAGS:
+		if (!EXT4_SNAPSHOTS(inode->i_sb))
+			return -EOPNOTSUPP;
+
+		ext4_snapshot_get_flags(inode, filp);
+		flags = ext4_get_snapstate_flags(inode);
+		return put_user(flags, (int __user *) arg);
+
+	case EXT4_IOC_SETSNAPFLAGS: {
+		handle_t *handle = NULL;
+		struct ext4_iloc iloc;
+		unsigned int oldflags;
+		int err;
+
+		if (!EXT4_SNAPSHOTS(inode->i_sb))
+			return -EOPNOTSUPP;
+
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+
+		/*
+		 * Snapshot file state flags can only be changed by
+		 * the relevant capability and under snapshot_mutex lock.
+		 */
+		if (!ext4_snapshot_file(inode) ||
+				!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
+		/* update snapshot 'open' flag under i_mutex */
+		mutex_lock(&inode->i_mutex);
+		ext4_snapshot_get_flags(inode, filp);
+		oldflags = ext4_get_snapstate_flags(inode);
+
+		/*
+		 * snapshot_mutex should be held throughout the trio
+		 * snapshot_{set_flags,take,update}().  It must be taken
+		 * before starting the transaction, otherwise
+		 * journal_lock_updates() inside snapshot_take()
+		 * can deadlock:
+		 * A: journal_start()
+		 * A: snapshot_mutex_lock()
+		 * B: journal_start()
+		 * B: snapshot_mutex_lock() (waiting for A)
+		 * A: journal_stop()
+		 * A: snapshot_take() ->
+		 * A: journal_lock_updates() (waiting for B)
+		 */
+		mutex_lock(&EXT4_SB(inode->i_sb)->s_snapshot_mutex);
+
+		handle = ext4_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto snapflags_out;
+		}
+		err = ext4_reserve_inode_write(handle, inode, &iloc);
+		if (err)
+			goto snapflags_err;
+
+		err = ext4_snapshot_set_flags(handle, inode, flags);
+		if (err)
+			goto snapflags_err;
+
+		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+snapflags_err:
+		ext4_journal_stop(handle);
+		if (err)
+			goto snapflags_out;
+
+		if (!(oldflags & 1UL<<EXT4_SNAPSTATE_LIST)  &&
+				(flags & 1UL<<EXT4_SNAPSTATE_LIST))
+			/* setting list flag - take snapshot */
+			err = ext4_snapshot_take(inode);
+snapflags_out:
+		if ((oldflags|flags) & 1UL<<EXT4_SNAPSTATE_LIST) {
+			/* if clearing list flag, cleanup snapshot list */
+			int ret;
+
+			/* update/cleanup snapshots list even if take failed */
+			ret = ext4_snapshot_update(inode->i_sb,
+					!(flags & 1UL<<EXT4_SNAPSTATE_LIST), 0);
+			if (!err)
+				err = ret;
+		}
+
+		mutex_unlock(&EXT4_SB(inode->i_sb)->s_snapshot_mutex);
+		mutex_unlock(&inode->i_mutex);
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
 		return put_user(inode->i_generation, (int __user *) arg);
@@ -210,6 +321,8 @@ setversion_out:
 
 		if (get_user(n_blocks_count, (__u32 __user *)arg))
 			return -EFAULT;
+		/* avoid snapshot_take() in the middle of group_extend() */
+		mutex_lock(&EXT4_SB(sb)->s_snapshot_mutex);
 
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
@@ -223,6 +336,7 @@ setversion_out:
 		}
 		if (err == 0)
 			err = err2;
+		mutex_unlock(&EXT4_SB(sb)->s_snapshot_mutex);
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
@@ -285,6 +399,8 @@ mext_out:
 		if (err)
 			return err;
 
+		/* avoid snapshot_take() in the middle of group_add() */
+		mutex_lock(&EXT4_SB(sb)->s_snapshot_mutex);
 		err = ext4_group_add(sb, &input);
 		if (EXT4_SB(sb)->s_journal) {
 			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
@@ -293,6 +409,7 @@ mext_out:
 		}
 		if (err == 0)
 			err = err2;
+		mutex_unlock(&EXT4_SB(sb)->s_snapshot_mutex);
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index fc5dbec..007fec0 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -346,6 +346,14 @@ static inline int ext4_snapshot_get_delete_access(handle_t *handle,
 /* snapshot_ctl.c */
 
 /*
+ * Snapshot control functions
+ */
+extern void ext4_snapshot_get_flags(struct inode *inode, struct file *filp);
+extern int ext4_snapshot_set_flags(handle_t *handle, struct inode *inode,
+				    unsigned int flags);
+extern int ext4_snapshot_take(struct inode *inode);
+
+/*
  * Snapshot constructor/destructor
  */
 extern int ext4_snapshot_load(struct super_block *sb,
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 810cb21..f2dbef4 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -132,6 +132,576 @@ static void ext4_snapshot_reset_bitmap_cache(struct super_block *sb)
 }
 
 /*
+ * Snapshot control functions
+ *
+ * Snapshot files are controlled by changing snapshot flags with chattr and
+ * moving the snapshot file through the stages of its life cycle:
+ *
+ * 1. Creating a snapshot file
+ * The snapfile flag is changed for directories only (chattr +x), so
+ * snapshot files must be created inside a snapshots directory.
+ * They inherit the flag at birth and they die with it.
+ * This helps to avoid various race conditions when changing
+ * regular files to snapshots and back.
+ * Snapshot files are assigned with read-only address space operations, so
+ * they are not writable for users.
+ *
+ * 2. Taking a snapshot
+ * An empty snapshot file becomes the active snapshot after it is added to the
+ * head on the snapshots list by setting its snapshot list flag (chattr -X +S).
+ * snapshot_create() verifies that the file is empty and pre-allocates some
+ * blocks during the ioctl transaction.  snapshot_take() locks journal updates
+ * and copies some file system block to the pre-allocated blocks and then adds
+ * the snapshot file to the on-disk list and sets it as the active snapshot.
+ *
+ * 3. Mounting a snapshot
+ * A snapshot on the list can be enabled for user read access by setting the
+ * enabled flag (chattr -X +n) and disabled by clearing the enabled flag.
+ * An enabled snapshot can be mounted via a loop device and mounted as a
+ * read-only ext2 filesystem.
+ *
+ * 4. Deleting a snapshot
+ * A non-mounted and disabled snapshot may be marked for removal from the
+ * snapshots list by requesting to clear its snapshot list flag (chattr -X -S).
+ * The process of removing a snapshot from the list varies according to the
+ * dependencies between the snapshot and older snapshots on the list:
+ * - if all older snapshots are deleted, the snapshot is removed from the list.
+ * - if some older snapshots are enabled, snapshot_shrink() is called to free
+ *   unused blocks, but the snapshot remains on the list.
+ * - if all older snapshots are disabled, snapshot_merge() is called to move
+ *   used blocks to an older snapshot and the snapshot is removed from the list.
+ *
+ * 5. Unlinking a snapshot file
+ * When a snapshot file is no longer (or never was) on the snapshots list, it
+ * may be unlinked.  Snapshots on the list are protected from user unlink and
+ * truncate operations.
+ *
+ * 6. Discarding all snapshots
+ * An irregular way to abruptly end the lives of all snapshots on the list is by
+ * detaching the snapshot list head using the command: tune2fs -O ^has_snapshot.
+ * This action is applicable on an un-mounted ext4 filesystem.  After mounting
+ * the filesystem, the discarded snapshot files will not be loaded, they will
+ * not have the snapshot list flag and therefore, may be unlinked.
+ */
+static int ext4_snapshot_enable(struct inode *inode);
+static int ext4_snapshot_disable(struct inode *inode);
+static int ext4_snapshot_create(struct inode *inode);
+static int ext4_snapshot_delete(struct inode *inode);
+
+/*
+ * ext4_snapshot_get_flags() check snapshot state
+ * Called from ext4_ioctl() under i_mutex
+ */
+void ext4_snapshot_get_flags(struct inode *inode, struct file *filp)
+{
+	unsigned int open_count = filp->f_path.dentry->d_count;
+
+	/*
+	 * 1 count for ioctl (lsattr)
+	 * greater count means the snapshot is open by user (mounted?)
+	 * We rely on d_count because snapshot shouldn't have hard links.
+	 */
+	if (ext4_snapshot_list(inode) && open_count > 1)
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_OPEN);
+	else
+		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_OPEN);
+	/* copy persistent flags to dynamic state flags */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED))
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_DELETED);
+	else
+		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_DELETED);
+	if (ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK))
+		ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_SHRUNK);
+	else
+		ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_SHRUNK);
+}
+
+/*
+ * ext4_snapshot_set_flags() monitors snapshot state changes
+ * Called from ext4_ioctl() under i_mutex and snapshot_mutex
+ */
+int ext4_snapshot_set_flags(handle_t *handle, struct inode *inode,
+			     unsigned int flags)
+{
+	unsigned int oldflags = ext4_get_snapstate_flags(inode);
+	int err = 0;
+
+	if ((flags ^ oldflags) & 1UL<<EXT4_SNAPSTATE_ENABLED) {
+		/* enabled/disabled the snapshot during transaction */
+		if (flags & 1UL<<EXT4_SNAPSTATE_ENABLED)
+			err = ext4_snapshot_enable(inode);
+		else
+			err = ext4_snapshot_disable(inode);
+	}
+	if (err)
+		goto out;
+
+	if ((flags ^ oldflags) & 1UL<<EXT4_SNAPSTATE_LIST) {
+		/* add/delete to snapshots list during transaction */
+		if (flags & 1UL<<EXT4_SNAPSTATE_LIST)
+			err = ext4_snapshot_create(inode);
+		else
+			err = ext4_snapshot_delete(inode);
+	}
+	if (err)
+		goto out;
+
+out:
+	/*
+	 * retake reserve inode write from ext4_ioctl() and mark inode
+	 * dirty
+	 */
+	if (!err)
+		err = ext4_mark_inode_dirty(handle, inode);
+	return err;
+}
+
+/*
+ * If we have fewer than nblocks credits,
+ * extend transaction by at most EXT4_MAX_TRANS_DATA.
+ * If that fails, restart the transaction &
+ * regain write access for the inode block.
+ */
+int __extend_or_restart_transaction(const char *where,
+		handle_t *handle, struct inode *inode, int nblocks)
+{
+	int err;
+
+	if (ext4_handle_has_enough_credits(handle, nblocks))
+		return 0;
+
+	if (nblocks < EXT4_MAX_TRANS_DATA)
+		nblocks = EXT4_MAX_TRANS_DATA;
+
+	err = __ext4_journal_extend(where, handle, nblocks);
+	if (err < 0)
+		return err;
+	if (err) {
+		if (inode) {
+			/* lazy way to do mark_iloc_dirty() */
+			err = ext4_mark_inode_dirty(handle, inode);
+			if (err)
+				return err;
+		}
+		err = __ext4_journal_restart(where, handle, nblocks);
+		if (err)
+			return err;
+		if (inode)
+			/* lazy way to do reserve_inode_write() */
+			err = ext4_mark_inode_dirty(handle, inode);
+	}
+
+	return err;
+}
+
+#define extend_or_restart_transaction(handle, nblocks)			\
+	__extend_or_restart_transaction(__func__, (handle), NULL, (nblocks))
+#define extend_or_restart_transaction_inode(handle, inode, nblocks)	\
+	__extend_or_restart_transaction(__func__, (handle), (inode), (nblocks))
+
+
+static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
+					 unsigned long ino,
+					 struct ext4_iloc *iloc)
+{
+	ext4_fsblk_t block;
+	struct ext4_group_desc *desc;
+	int inodes_per_block, inode_offset;
+
+	iloc->bh = NULL;
+	iloc->offset = 0;
+	iloc->block_group = 0;
+
+	if (!ext4_valid_inum(sb, ino))
+		return 0;
+
+	iloc->block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
+	desc = ext4_get_group_desc(sb, iloc->block_group, NULL);
+	if (!desc)
+		return 0;
+
+	/*
+	 * Figure out the offset within the block group inode table
+	 */
+	inodes_per_block = (EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb));
+	inode_offset = ((ino - 1) %
+			EXT4_INODES_PER_GROUP(sb));
+	block = ext4_inode_table(sb, desc) + (inode_offset / inodes_per_block);
+	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
+	return block;
+}
+
+/*
+ * ext4_snapshot_create() initializes a snapshot file
+ * and adds it to the list of snapshots
+ * Called under i_mutex and snapshot_mutex
+ */
+static int ext4_snapshot_create(struct inode *inode)
+{
+	handle_t *handle;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int i, err, ret;
+	ext4_fsblk_t snapshot_blocks = ext4_blocks_count(sbi->s_es);
+	if (active_snapshot) {
+		snapshot_debug(1, "failed to add snapshot because active "
+			       "snapshot (%u) has to be deleted first\n",
+			       active_snapshot->i_generation);
+		return -EINVAL;
+	}
+
+	/* prevent take of unlinked snapshot file */
+	if (!inode->i_nlink) {
+		snapshot_debug(1, "failed to create snapshot file (ino=%lu) "
+				"because it has 0 nlink count\n",
+				inode->i_ino);
+		return -EINVAL;
+	}
+
+	/* prevent recycling of old snapshot files */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED)) {
+		snapshot_debug(1, "deleted snapshot file (ino=%lu) cannot "
+				"be reused - it may be unlinked\n",
+				inode->i_ino);
+		return -EINVAL;
+	}
+
+	/* verify that no inode blocks are allocated */
+	for (i = 0; i < EXT4_N_BLOCKS; i++) {
+		if (ei->i_data[i])
+			break;
+	}
+	/* Don't need i_size_read because we hold i_mutex */
+	if (i != EXT4_N_BLOCKS ||
+		inode->i_size > 0 || ei->i_disksize > 0) {
+		snapshot_debug(1, "failed to create snapshot file (ino=%lu) "
+				"because it is not empty (i_data[%d]=%u, "
+				"i_size=%lld, i_disksize=%lld)\n",
+				inode->i_ino, i, ei->i_data[i],
+				inode->i_size, ei->i_disksize);
+		return -EINVAL;
+	}
+
+	/*
+	 * Take a reference to the small transaction that started in
+	 * ext4_ioctl() We will extend or restart this transaction as we go
+	 * along.  journal_start(n > 1) would not have increase the buffer
+	 * credits.
+	 */
+	handle = ext4_journal_start(inode, 1);
+
+	err = extend_or_restart_transaction_inode(handle, inode, 2);
+	if (err)
+		goto out_handle;
+
+	/* record the new snapshot ID in the snapshot inode generation field */
+	inode->i_generation = le32_to_cpu(sbi->s_es->s_snapshot_id) + 1;
+	if (inode->i_generation == 0)
+		/* 0 is not a valid snapshot id */
+		inode->i_generation = 1;
+
+	/* record the file system size in the snapshot inode disksize field */
+	SNAPSHOT_SET_BLOCKS(inode, snapshot_blocks);
+
+	lock_super(sb);
+	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+	sbi->s_es->s_snapshot_list = cpu_to_le32(inode->i_ino);
+	if (!err)
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
+	unlock_super(sb);
+	if (err)
+		goto out_handle;
+
+	err = ext4_mark_inode_dirty(handle, inode);
+	if (err)
+		goto out_handle;
+
+	snapshot_debug(1, "snapshot (%u) created\n", inode->i_generation);
+	err = 0;
+out_handle:
+	ret = ext4_journal_stop(handle);
+	if (!err)
+		err = ret;
+	return err;
+}
+
+
+/*
+ * ext4_snapshot_take() makes a new snapshot file
+ * into the active snapshot
+ *
+ * this function calls journal_lock_updates()
+ * and should not be called during a journal transaction
+ * Called from ext4_ioctl() under i_mutex and snapshot_mutex
+ */
+int ext4_snapshot_take(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = NULL;
+	struct buffer_head *es_bh = NULL;
+	struct buffer_head *sbh = NULL;
+	int err = -EIO;
+
+	if (!sbi->s_sbh)
+		goto out_err;
+	else if (sbi->s_sbh->b_blocknr != 0) {
+		snapshot_debug(1, "warning: unexpected super block at block "
+			"(%lld:%d)!\n", (long long)sbi->s_sbh->b_blocknr,
+			(int)((char *)sbi->s_es - (char *)sbi->s_sbh->b_data));
+	} else if (sbi->s_es->s_magic != cpu_to_le16(EXT4_SUPER_MAGIC)) {
+		snapshot_debug(1, "warning: super block of snapshot (%u) is "
+			       "broken!\n", inode->i_generation);
+	} else
+		es_bh = ext4_getblk(NULL, inode, SNAPSHOT_IBLOCK(0),
+				   SNAPMAP_READ, &err);
+
+	if (!es_bh || es_bh->b_blocknr == 0) {
+		snapshot_debug(1, "warning: super block of snapshot (%u) not "
+			       "allocated\n", inode->i_generation);
+		goto out_err;
+	} else {
+		snapshot_debug(4, "super block of snapshot (%u) mapped to "
+			       "block (%lld)\n", inode->i_generation,
+			       (long long)es_bh->b_blocknr);
+		es = (struct ext4_super_block *)(es_bh->b_data +
+						  ((char *)sbi->s_es -
+						   sbi->s_sbh->b_data));
+	}
+
+	err = -EIO;
+
+	/*
+	 * flush journal to disk and clear the RECOVER flag
+	 * before taking the snapshot
+	 */
+	freeze_super(sb);
+	lock_super(sb);
+
+#ifdef CONFIG_EXT4_DEBUG
+	if (snapshot_enable_test[SNAPTEST_TAKE]) {
+		snapshot_debug(1, "taking snapshot (%u) ...\n",
+				inode->i_generation);
+		/* sleep 1 tunable delay unit */
+		snapshot_test_delay(SNAPTEST_TAKE);
+	}
+#endif
+
+
+	/* reset i_size and invalidate page cache */
+	SNAPSHOT_SET_DISABLED(inode);
+	/* reset COW bitmap cache */
+	ext4_snapshot_reset_bitmap_cache(sb);
+	/* set as in-memory active snapshot */
+	err = ext4_snapshot_set_active(sb, inode);
+	if (err)
+		goto out_unlockfs;
+
+	/* set as on-disk active snapshot */
+
+	sbi->s_es->s_snapshot_id =
+		cpu_to_le32(le32_to_cpu(sbi->s_es->s_snapshot_id) + 1);
+	if (sbi->s_es->s_snapshot_id == 0)
+		/* 0 is not a valid snapshot id */
+		sbi->s_es->s_snapshot_id = cpu_to_le32(1);
+	sbi->s_es->s_snapshot_inum = cpu_to_le32(inode->i_ino);
+	ext4_snapshot_set_tid(sb);
+
+	err = 0;
+out_unlockfs:
+	unlock_super(sb);
+	thaw_super(sb);
+
+	if (err)
+		goto out_err;
+
+	snapshot_debug(1, "snapshot (%u) has been taken\n",
+			inode->i_generation);
+
+out_err:
+	brelse(es_bh);
+	brelse(sbh);
+	return err;
+}
+
+/*
+ * ext4_snapshot_enable() enables snapshot mount
+ * sets the in-use flag and the active snapshot
+ * Called under i_mutex and snapshot_mutex
+ */
+static int ext4_snapshot_enable(struct inode *inode)
+{
+	if (!ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "ext4_snapshot_enable() called with "
+			       "snapshot file (ino=%lu) not on list\n",
+			       inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED)) {
+		snapshot_debug(1, "enable of deleted snapshot (%u) "
+				"is not permitted\n",
+				inode->i_generation);
+		return -EPERM;
+	}
+
+	/*
+	 * set i_size to block device size to enable loop device mount
+	 */
+	SNAPSHOT_SET_ENABLED(inode);
+	ext4_set_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED);
+
+	/* Don't need i_size_read because we hold i_mutex */
+	snapshot_debug(4, "setting snapshot (%u) i_size to (%lld)\n",
+			inode->i_generation, inode->i_size);
+	snapshot_debug(1, "snapshot (%u) enabled\n", inode->i_generation);
+	return 0;
+}
+
+/*
+ * ext4_snapshot_disable() disables snapshot mount
+ * Called under i_mutex and snapshot_mutex
+ */
+static int ext4_snapshot_disable(struct inode *inode)
+{
+	if (!ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "ext4_snapshot_disable() called with "
+			       "snapshot file (ino=%lu) not on list\n",
+			       inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_OPEN)) {
+		snapshot_debug(1, "disable of mounted snapshot (%u) "
+			       "is not permitted\n",
+			       inode->i_generation);
+		return -EPERM;
+	}
+
+	/* reset i_size and invalidate page cache */
+	SNAPSHOT_SET_DISABLED(inode);
+	ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED);
+
+	/* Don't need i_size_read because we hold i_mutex */
+	snapshot_debug(4, "setting snapshot (%u) i_size to (%lld)\n",
+		       inode->i_generation, inode->i_size);
+	snapshot_debug(1, "snapshot (%u) disabled\n", inode->i_generation);
+	return 0;
+}
+
+/*
+ * ext4_snapshot_delete() marks snapshot for deletion
+ * Called under i_mutex and snapshot_mutex
+ */
+static int ext4_snapshot_delete(struct inode *inode)
+{
+	if (!ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "ext4_snapshot_delete() called with "
+			       "snapshot file (ino=%lu) not on list\n",
+			       inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED)) {
+		snapshot_debug(1, "delete of enabled snapshot (%u) "
+			       "is not permitted\n",
+			       inode->i_generation);
+		return -EPERM;
+	}
+
+	/* mark deleted for later cleanup to finish the job */
+	ext4_set_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED);
+	snapshot_debug(1, "snapshot (%u) marked for deletion\n",
+		       inode->i_generation);
+	return 0;
+}
+
+/*
+ * ext4_snapshot_remove - removes a snapshot from the list
+ * @inode: snapshot inode
+ *
+ * Removed the snapshot inode from in-memory and on-disk snapshots list of
+ * and truncates the snapshot inode.
+ * Called from ext4_snapshot_update/cleanup/merge() under snapshot_mutex.
+ * Returns 0 on success and <0 on error.
+ */
+static int ext4_snapshot_remove(struct inode *inode)
+{
+	handle_t *handle;
+	struct ext4_sb_info *sbi;
+	int err = 0, ret;
+
+	/* elevate ref count until final cleanup */
+	if (!igrab(inode))
+		return -EIO;
+
+	if (ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE) ||
+		ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED) ||
+		ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE)) {
+		snapshot_debug(1, "ext4_snapshot_remove() called with active/"
+			       "enabled/in-use snapshot file (ino=%lu)\n",
+			       inode->i_ino);
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	/* start large truncate transaction that will be extended/restarted */
+	handle = ext4_journal_start(inode, EXT4_MAX_TRANS_DATA);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out_err;
+	}
+	sbi = EXT4_SB(inode->i_sb);
+
+
+	err = extend_or_restart_transaction_inode(handle, inode, 2);
+	if (err)
+		goto out_handle;
+
+	lock_super(inode->i_sb);
+	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+	sbi->s_es->s_snapshot_list = 0;
+	if (!err)
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
+	unlock_super(inode->i_sb);
+	if (err)
+		goto out_handle;
+	/*
+	 * At this point, this snapshot is empty and not on the snapshots list.
+	 * As long as it was on the list it had to have the LIST flag to prevent
+	 * truncate/unlink.  Now that it is removed from the list, the LIST flag
+	 * and other snapshot status flags should be cleared.  It will still
+	 * have the SNAPFILE and SNAPFILE_DELETED persistent flags to indicate
+	 * this is a deleted snapshot that should not be recycled.
+	 */
+	ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_LIST);
+	ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_ENABLED);
+	ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE);
+	ext4_clear_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE);
+
+out_handle:
+	ret = ext4_journal_stop(handle);
+	if (!err)
+		err = ret;
+	if (err)
+		goto out_err;
+
+	snapshot_debug(1, "snapshot (%u) deleted\n", inode->i_generation);
+
+	err = 0;
+out_err:
+	/* drop final ref count - taken on entry to this function */
+	iput(inode);
+	if (err) {
+		snapshot_debug(1, "failed to delete snapshot (%u)\n",
+				inode->i_generation);
+	}
+	return err;
+}
+
+/*
  * Snapshot constructor/destructor
  */
 /*
@@ -250,6 +820,8 @@ void ext4_snapshot_destroy(struct super_block *sb)
 int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
 {
 	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
+	struct inode *used_by = NULL; /* last non-deleted snapshot found */
+	int deleted;
 	int err = 0;
 
 	BUG_ON(read_only && cleanup);
@@ -262,5 +834,26 @@ int ext4_snapshot_update(struct super_block *sb, int cleanup, int read_only)
 	}
 
 
+	if (!active_snapshot || !cleanup || used_by)
+		return 0;
+
+	/* if all snapshots are deleted - deactivate active snapshot */
+	deleted = ext4_test_inode_flag(active_snapshot,
+				       EXT4_INODE_SNAPFILE_DELETED);
+	if (deleted && igrab(active_snapshot)) {
+		/* lock journal updates before deactivating snapshot */
+		freeze_super(sb);
+		lock_super(sb);
+		/* deactivate in-memory active snapshot - cannot fail */
+		(void) ext4_snapshot_set_active(sb, NULL);
+		/* clear on-disk active snapshot */
+		EXT4_SB(sb)->s_es->s_snapshot_inum = 0;
+		unlock_super(sb);
+		thaw_super(sb);
+		/* remove unused deleted active snapshot */
+		err = ext4_snapshot_remove(active_snapshot);
+		/* drop the refcount to 0 */
+		iput(active_snapshot);
+	}
 	return err;
 }
-- 
1.7.4.1

