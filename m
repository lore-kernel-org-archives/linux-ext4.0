From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Move orphan inode handling into a separate file
Date: Fri, 22 May 2015 13:21:55 +0200
Message-ID: <1432293717-24010-3-git-send-email-jack@suse.cz>
References: <1432293717-24010-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbbEVLWJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:22:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DD25FACF7
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:22:07 +0000 (UTC)
In-Reply-To: <1432293717-24010-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move functions for handling orphan inodes into a new file
fs/ext4/orphan.c to have them in one place and somewhat reduce size of
other files. No code changes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/Makefile |   2 +-
 fs/ext4/ext4.h   |   9 +-
 fs/ext4/namei.c  | 174 ------------------------------
 fs/ext4/orphan.c | 315 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c  | 140 +------------------------
 5 files changed, 324 insertions(+), 316 deletions(-)
 create mode 100644 fs/ext4/orphan.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 75285ea9aa05..477de2db9d4a 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -8,7 +8,7 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
 		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
 		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
-		xattr_trusted.o inline.o readpage.o
+		xattr_trusted.o inline.o readpage.o orphan.o
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 01916e21b8fa..2a69a5e9017a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2335,8 +2335,6 @@ extern int ext4_ind_migrate(struct inode *inode);
 /* namei.c */
 extern int ext4_dirent_csum_verify(struct inode *inode,
 				   struct ext4_dir_entry *dirent);
-extern int ext4_orphan_add(handle_t *, struct inode *);
-extern int ext4_orphan_del(handle_t *, struct inode *);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int search_dir(struct buffer_head *bh,
@@ -2469,6 +2467,7 @@ extern int ext4_update_rocompat_feature(handle_t *handle,
 					struct super_block *sb,	__u32 rocompat);
 extern int ext4_update_incompat_feature(handle_t *handle,
 					struct super_block *sb,	__u32 incompat);
+extern int ext4_feature_set_ok(struct super_block *sb, int readonly);
 extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
@@ -2968,6 +2967,12 @@ extern int ext4_bio_write_page(struct ext4_io_submit *io,
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
 
+/* orphan.c */
+extern int ext4_orphan_add(handle_t *, struct inode *);
+extern int ext4_orphan_del(handle_t *, struct inode *);
+extern void ext4_orphan_cleanup(struct super_block *sb,
+				struct ext4_super_block *es);
+
 /*
  * Add new method to test whether block and inode bitmaps are properly
  * initialized. With uninit_bg reading the block from disk is not enough
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 225890c8289e..b38b2d068ef0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2829,180 +2829,6 @@ int ext4_empty_dir(struct inode *inode)
 	return 1;
 }
 
-/*
- * ext4_orphan_add() links an unlinked or truncated inode into a list of
- * such inodes, starting at the superblock, in case we crash before the
- * file is closed/deleted, or in case the inode truncate spans multiple
- * transactions and the last transaction is not recovered after a crash.
- *
- * At filesystem recovery time, we walk this list deleting unlinked
- * inodes and truncating linked inodes in ext4_orphan_cleanup().
- *
- * Orphan list manipulation functions must be called under i_mutex unless
- * we are just creating the inode or deleting it.
- */
-int ext4_orphan_add(handle_t *handle, struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_iloc iloc;
-	int err = 0, rc;
-	bool dirty = false;
-
-	if (!sbi->s_journal || is_bad_inode(inode))
-		return 0;
-
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
-		     !mutex_is_locked(&inode->i_mutex));
-	/*
-	 * Exit early if inode already is on orphan list. This is a big speedup
-	 * since we don't have to contend on the global s_orphan_lock.
-	 */
-	if (!list_empty(&EXT4_I(inode)->i_orphan))
-		return 0;
-
-	/*
-	 * Orphan handling is only valid for files with data blocks
-	 * being truncated, or files being unlinked. Note that we either
-	 * hold i_mutex, or the inode can not be referenced from outside,
-	 * so i_nlink should not be bumped due to race
-	 */
-	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
-
-	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh,
-					    EXT4_JTR_NONE);
-	if (err)
-		goto out;
-
-	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (err)
-		goto out;
-
-	mutex_lock(&sbi->s_orphan_lock);
-	/*
-	 * Due to previous errors inode may be already a part of on-disk
-	 * orphan list. If so skip on-disk list modification.
-	 */
-	if (!NEXT_ORPHAN(inode) || NEXT_ORPHAN(inode) >
-	    (le32_to_cpu(sbi->s_es->s_inodes_count))) {
-		/* Insert this inode at the head of the on-disk orphan list */
-		NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
-		sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-		dirty = true;
-	}
-	list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
-	mutex_unlock(&sbi->s_orphan_lock);
-
-	if (dirty) {
-		err = ext4_handle_dirty_super(handle, sb);
-		rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
-		if (!err)
-			err = rc;
-		if (err) {
-			/*
-			 * We have to remove inode from in-memory list if
-			 * addition to on disk orphan list failed. Stray orphan
-			 * list entries can cause panics at unmount time.
-			 */
-			mutex_lock(&sbi->s_orphan_lock);
-			list_del(&EXT4_I(inode)->i_orphan);
-			mutex_unlock(&sbi->s_orphan_lock);
-		}
-	}
-	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
-	jbd_debug(4, "orphan inode %lu will point to %d\n",
-			inode->i_ino, NEXT_ORPHAN(inode));
-out:
-	ext4_std_error(sb, err);
-	return err;
-}
-
-/*
- * ext4_orphan_del() removes an unlinked or truncated inode from the list
- * of such inodes stored on disk, because it is finally being cleaned up.
- */
-int ext4_orphan_del(handle_t *handle, struct inode *inode)
-{
-	struct list_head *prev;
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	__u32 ino_next;
-	struct ext4_iloc iloc;
-	int err = 0;
-
-	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
-		return 0;
-
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
-		     !mutex_is_locked(&inode->i_mutex));
-	/* Do this quick check before taking global s_orphan_lock. */
-	if (list_empty(&ei->i_orphan))
-		return 0;
-
-	if (handle) {
-		/* Grab inode buffer early before taking global s_orphan_lock */
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-	}
-
-	mutex_lock(&sbi->s_orphan_lock);
-	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
-
-	prev = ei->i_orphan.prev;
-	list_del_init(&ei->i_orphan);
-
-	/* If we're on an error path, we may not have a valid
-	 * transaction handle with which to update the orphan list on
-	 * disk, but we still need to remove the inode from the linked
-	 * list in memory. */
-	if (!handle || err) {
-		mutex_unlock(&sbi->s_orphan_lock);
-		goto out_err;
-	}
-
-	ino_next = NEXT_ORPHAN(inode);
-	if (prev == &sbi->s_orphan) {
-		jbd_debug(4, "superblock will point to %u\n", ino_next);
-		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
-		err = ext4_journal_get_write_access(handle, inode->i_sb,
-						    sbi->s_sbh, EXT4_JTR_NONE);
-		if (err) {
-			mutex_unlock(&sbi->s_orphan_lock);
-			goto out_brelse;
-		}
-		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		mutex_unlock(&sbi->s_orphan_lock);
-		err = ext4_handle_dirty_super(handle, inode->i_sb);
-	} else {
-		struct ext4_iloc iloc2;
-		struct inode *i_prev =
-			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
-
-		jbd_debug(4, "orphan inode %lu will point to %u\n",
-			  i_prev->i_ino, ino_next);
-		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
-		if (err) {
-			mutex_unlock(&sbi->s_orphan_lock);
-			goto out_brelse;
-		}
-		NEXT_ORPHAN(i_prev) = ino_next;
-		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
-		mutex_unlock(&sbi->s_orphan_lock);
-	}
-	if (err)
-		goto out_brelse;
-	NEXT_ORPHAN(inode) = 0;
-	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-out_err:
-	ext4_std_error(inode->i_sb, err);
-	return err;
-
-out_brelse:
-	brelse(iloc.bh);
-	goto out_err;
-}
-
 static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
new file mode 100644
index 000000000000..a192cc2086f9
--- /dev/null
+++ b/fs/ext4/orphan.c
@@ -0,0 +1,315 @@
+/*
+ * Ext4 orphan inode handling
+ */
+#include <linux/fs.h>
+#include <linux/quotaops.h>
+#include <linux/buffer_head.h>
+
+#include "ext4.h"
+#include "ext4_jbd2.h"
+
+/*
+ * ext4_orphan_add() links an unlinked or truncated inode into a list of
+ * such inodes, starting at the superblock, in case we crash before the
+ * file is closed/deleted, or in case the inode truncate spans multiple
+ * transactions and the last transaction is not recovered after a crash.
+ *
+ * At filesystem recovery time, we walk this list deleting unlinked
+ * inodes and truncating linked inodes in ext4_orphan_cleanup().
+ *
+ * Orphan list manipulation functions must be called under i_mutex unless
+ * we are just creating the inode or deleting it.
+ */
+int ext4_orphan_add(handle_t *handle, struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_iloc iloc;
+	int err = 0, rc;
+	bool dirty = false;
+
+	if (!sbi->s_journal || is_bad_inode(inode))
+		return 0;
+
+	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+		     !mutex_is_locked(&inode->i_mutex));
+	/*
+	 * Exit early if inode already is on orphan list. This is a big speedup
+	 * since we don't have to contend on the global s_orphan_lock.
+	 */
+	if (!list_empty(&EXT4_I(inode)->i_orphan))
+		return 0;
+
+	/*
+	 * Orphan handling is only valid for files with data blocks
+	 * being truncated, or files being unlinked. Note that we either
+	 * hold i_mutex, or the inode can not be referenced from outside,
+	 * so i_nlink should not be bumped due to race
+	 */
+	J_ASSERT((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
+
+	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh,
+					    EXT4_JTR_NONE);
+	if (err)
+		goto out;
+
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto out;
+
+	mutex_lock(&sbi->s_orphan_lock);
+	/*
+	 * Due to previous errors inode may be already a part of on-disk
+	 * orphan list. If so skip on-disk list modification.
+	 */
+	if (!NEXT_ORPHAN(inode) || NEXT_ORPHAN(inode) >
+	    (le32_to_cpu(sbi->s_es->s_inodes_count))) {
+		/* Insert this inode at the head of the on-disk orphan list */
+		NEXT_ORPHAN(inode) = le32_to_cpu(sbi->s_es->s_last_orphan);
+		sbi->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
+		dirty = true;
+	}
+	list_add(&EXT4_I(inode)->i_orphan, &sbi->s_orphan);
+	mutex_unlock(&sbi->s_orphan_lock);
+
+	if (dirty) {
+		err = ext4_handle_dirty_super(handle, sb);
+		rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
+		if (!err)
+			err = rc;
+		if (err) {
+			/*
+			 * We have to remove inode from in-memory list if
+			 * addition to on disk orphan list failed. Stray orphan
+			 * list entries can cause panics at unmount time.
+			 */
+			mutex_lock(&sbi->s_orphan_lock);
+			list_del(&EXT4_I(inode)->i_orphan);
+			mutex_unlock(&sbi->s_orphan_lock);
+		}
+	}
+	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
+	jbd_debug(4, "orphan inode %lu will point to %d\n",
+			inode->i_ino, NEXT_ORPHAN(inode));
+out:
+	ext4_std_error(sb, err);
+	return err;
+}
+
+/*
+ * ext4_orphan_del() removes an unlinked or truncated inode from the list
+ * of such inodes stored on disk, because it is finally being cleaned up.
+ */
+int ext4_orphan_del(handle_t *handle, struct inode *inode)
+{
+	struct list_head *prev;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	__u32 ino_next;
+	struct ext4_iloc iloc;
+	int err = 0;
+
+	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
+		return 0;
+
+	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+		     !mutex_is_locked(&inode->i_mutex));
+	/* Do this quick check before taking global s_orphan_lock. */
+	if (list_empty(&ei->i_orphan))
+		return 0;
+
+	if (handle) {
+		/* Grab inode buffer early before taking global s_orphan_lock */
+		err = ext4_reserve_inode_write(handle, inode, &iloc);
+	}
+
+	mutex_lock(&sbi->s_orphan_lock);
+	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+
+	prev = ei->i_orphan.prev;
+	list_del_init(&ei->i_orphan);
+
+	/* If we're on an error path, we may not have a valid
+	 * transaction handle with which to update the orphan list on
+	 * disk, but we still need to remove the inode from the linked
+	 * list in memory. */
+	if (!handle || err) {
+		mutex_unlock(&sbi->s_orphan_lock);
+		goto out_err;
+	}
+
+	ino_next = NEXT_ORPHAN(inode);
+	if (prev == &sbi->s_orphan) {
+		jbd_debug(4, "superblock will point to %u\n", ino_next);
+		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, inode->i_sb,
+						    sbi->s_sbh, EXT4_JTR_NONE);
+		if (err) {
+			mutex_unlock(&sbi->s_orphan_lock);
+			goto out_brelse;
+		}
+		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+		mutex_unlock(&sbi->s_orphan_lock);
+		err = ext4_handle_dirty_super(handle, inode->i_sb);
+	} else {
+		struct ext4_iloc iloc2;
+		struct inode *i_prev =
+			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
+
+		jbd_debug(4, "orphan inode %lu will point to %u\n",
+			  i_prev->i_ino, ino_next);
+		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
+		if (err) {
+			mutex_unlock(&sbi->s_orphan_lock);
+			goto out_brelse;
+		}
+		NEXT_ORPHAN(i_prev) = ino_next;
+		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
+		mutex_unlock(&sbi->s_orphan_lock);
+	}
+	if (err)
+		goto out_brelse;
+	NEXT_ORPHAN(inode) = 0;
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+out_err:
+	ext4_std_error(inode->i_sb, err);
+	return err;
+
+out_brelse:
+	brelse(iloc.bh);
+	goto out_err;
+}
+
+static int ext4_quota_on_mount(struct super_block *sb, int type)
+{
+	return dquot_quota_on_mount(sb, EXT4_SB(sb)->s_qf_names[type],
+					EXT4_SB(sb)->s_jquota_fmt, type);
+}
+
+/* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
+ * the superblock) which were deleted from all directories, but held open by
+ * a process at the time of a crash.  We walk the list and try to delete these
+ * inodes at recovery time (only with a read-write filesystem).
+ *
+ * In order to keep the orphan inode chain consistent during traversal (in
+ * case of crash during recovery), we link each inode into the superblock
+ * orphan list_head and handle it the same way as an inode deletion during
+ * normal operation (which journals the operations for us).
+ *
+ * We only do an iget() and an iput() on each inode, which is very safe if we
+ * accidentally point at an in-use or already deleted inode.  The worst that
+ * can happen in this case is that we get a "bit already cleared" message from
+ * ext4_free_inode().  The only reason we would point at a wrong inode is if
+ * e2fsck was run on this filesystem, and it must have already done the orphan
+ * inode cleanup for us, so we can safely abort without any further action.
+ */
+void ext4_orphan_cleanup(struct super_block *sb,
+			 struct ext4_super_block *es)
+{
+	unsigned int s_flags = sb->s_flags;
+	int nr_orphans = 0, nr_truncates = 0;
+#ifdef CONFIG_QUOTA
+	int i;
+#endif
+	if (!es->s_last_orphan) {
+		jbd_debug(4, "no orphan inodes to clean up\n");
+		return;
+	}
+
+	if (bdev_read_only(sb->s_bdev)) {
+		ext4_msg(sb, KERN_ERR, "write access "
+			"unavailable, skipping orphan cleanup");
+		return;
+	}
+
+	/* Check if feature set would not allow a r/w mount */
+	if (!ext4_feature_set_ok(sb, 0)) {
+		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
+	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
+		/* don't clear list on RO mount w/ errors */
+		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
+			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
+				  "clearing orphan list.\n");
+			es->s_last_orphan = 0;
+		}
+		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+		return;
+	}
+
+	if (s_flags & MS_RDONLY) {
+		ext4_msg(sb, KERN_INFO, "orphan cleanup on readonly fs");
+		sb->s_flags &= ~MS_RDONLY;
+	}
+#ifdef CONFIG_QUOTA
+	/* Needed for iput() to work correctly and not trash data */
+	sb->s_flags |= MS_ACTIVE;
+	/* Turn on quotas so that they are updated correctly */
+	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
+		if (EXT4_SB(sb)->s_qf_names[i]) {
+			int ret = ext4_quota_on_mount(sb, i);
+			if (ret < 0)
+				ext4_msg(sb, KERN_ERR,
+					"Cannot turn on journaled "
+					"quota: error %d", ret);
+		}
+	}
+#endif
+
+	while (es->s_last_orphan) {
+		struct inode *inode;
+
+		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		if (IS_ERR(inode)) {
+			es->s_last_orphan = 0;
+			break;
+		}
+
+		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
+		dquot_initialize(inode);
+		if (inode->i_nlink) {
+			if (test_opt(sb, DEBUG))
+				ext4_msg(sb, KERN_DEBUG,
+					"%s: truncating inode %lu to %lld bytes",
+					__func__, inode->i_ino, inode->i_size);
+			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
+				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
+			truncate_inode_pages(inode->i_mapping, inode->i_size);
+			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
+			nr_truncates++;
+		} else {
+			if (test_opt(sb, DEBUG))
+				ext4_msg(sb, KERN_DEBUG,
+					"%s: deleting unreferenced inode %lu",
+					__func__, inode->i_ino);
+			jbd_debug(2, "deleting unreferenced inode %lu\n",
+				  inode->i_ino);
+			nr_orphans++;
+		}
+		iput(inode);  /* The delete magic happens here! */
+	}
+
+#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
+
+	if (nr_orphans)
+		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
+		       PLURAL(nr_orphans));
+	if (nr_truncates)
+		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
+		       PLURAL(nr_truncates));
+#ifdef CONFIG_QUOTA
+	/* Turn quotas off */
+	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
+		if (sb_dqopt(sb)->files[i])
+			dquot_quota_off(sb, i);
+	}
+#endif
+	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0f577e45de5d..a8ea6e00b23f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -77,7 +77,6 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data);
 static inline int ext2_feature_set_ok(struct super_block *sb);
 static inline int ext3_feature_set_ok(struct super_block *sb);
-static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
@@ -1035,7 +1034,6 @@ static int ext4_write_info(struct super_block *sb, int type);
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 			 struct path *path);
 static int ext4_quota_off(struct super_block *sb, int type);
-static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext4_quota_write(struct super_block *sb, int type,
@@ -2127,132 +2125,6 @@ static int ext4_check_descriptors(struct super_block *sb,
 	return 1;
 }
 
-/* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
- * the superblock) which were deleted from all directories, but held open by
- * a process at the time of a crash.  We walk the list and try to delete these
- * inodes at recovery time (only with a read-write filesystem).
- *
- * In order to keep the orphan inode chain consistent during traversal (in
- * case of crash during recovery), we link each inode into the superblock
- * orphan list_head and handle it the same way as an inode deletion during
- * normal operation (which journals the operations for us).
- *
- * We only do an iget() and an iput() on each inode, which is very safe if we
- * accidentally point at an in-use or already deleted inode.  The worst that
- * can happen in this case is that we get a "bit already cleared" message from
- * ext4_free_inode().  The only reason we would point at a wrong inode is if
- * e2fsck was run on this filesystem, and it must have already done the orphan
- * inode cleanup for us, so we can safely abort without any further action.
- */
-static void ext4_orphan_cleanup(struct super_block *sb,
-				struct ext4_super_block *es)
-{
-	unsigned int s_flags = sb->s_flags;
-	int nr_orphans = 0, nr_truncates = 0;
-#ifdef CONFIG_QUOTA
-	int i;
-#endif
-	if (!es->s_last_orphan) {
-		jbd_debug(4, "no orphan inodes to clean up\n");
-		return;
-	}
-
-	if (bdev_read_only(sb->s_bdev)) {
-		ext4_msg(sb, KERN_ERR, "write access "
-			"unavailable, skipping orphan cleanup");
-		return;
-	}
-
-	/* Check if feature set would not allow a r/w mount */
-	if (!ext4_feature_set_ok(sb, 0)) {
-		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
-			 "unknown ROCOMPAT features");
-		return;
-	}
-
-	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-		/* don't clear list on RO mount w/ errors */
-		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
-			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
-				  "clearing orphan list.\n");
-			es->s_last_orphan = 0;
-		}
-		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
-		return;
-	}
-
-	if (s_flags & MS_RDONLY) {
-		ext4_msg(sb, KERN_INFO, "orphan cleanup on readonly fs");
-		sb->s_flags &= ~MS_RDONLY;
-	}
-#ifdef CONFIG_QUOTA
-	/* Needed for iput() to work correctly and not trash data */
-	sb->s_flags |= MS_ACTIVE;
-	/* Turn on quotas so that they are updated correctly */
-	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
-		if (EXT4_SB(sb)->s_qf_names[i]) {
-			int ret = ext4_quota_on_mount(sb, i);
-			if (ret < 0)
-				ext4_msg(sb, KERN_ERR,
-					"Cannot turn on journaled "
-					"quota: error %d", ret);
-		}
-	}
-#endif
-
-	while (es->s_last_orphan) {
-		struct inode *inode;
-
-		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
-		if (IS_ERR(inode)) {
-			es->s_last_orphan = 0;
-			break;
-		}
-
-		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
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
-		}
-		iput(inode);  /* The delete magic happens here! */
-	}
-
-#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
-
-	if (nr_orphans)
-		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
-		       PLURAL(nr_orphans));
-	if (nr_truncates)
-		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
-		       PLURAL(nr_truncates));
-#ifdef CONFIG_QUOTA
-	/* Turn quotas off */
-	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
-		if (sb_dqopt(sb)->files[i])
-			dquot_quota_off(sb, i);
-	}
-#endif
-	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
-}
-
 /*
  * Maximal extent format file size.
  * Resulting logical blkno at s_maxbytes must fit in our on-disk
@@ -2766,7 +2638,7 @@ static struct kobj_type ext4_feat_ktype = {
  * Returns 1 if this filesystem can be mounted as requested,
  * 0 if it cannot be.
  */
-static int ext4_feature_set_ok(struct super_block *sb, int readonly)
+int ext4_feature_set_ok(struct super_block *sb, int readonly)
 {
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP)) {
 		ext4_msg(sb, KERN_ERR,
@@ -5244,16 +5116,6 @@ static int ext4_write_info(struct super_block *sb, int type)
 }
 
 /*
- * Turn on quotas during mount time - we need to find
- * the quota file and such...
- */
-static int ext4_quota_on_mount(struct super_block *sb, int type)
-{
-	return dquot_quota_on_mount(sb, EXT4_SB(sb)->s_qf_names[type],
-					EXT4_SB(sb)->s_jquota_fmt, type);
-}
