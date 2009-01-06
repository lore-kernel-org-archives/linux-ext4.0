From: Frank Mayhar <fmayhar@google.com>
Subject: [PATCH] Clean up no-journal handling.
Date: Tue, 06 Jan 2009 13:55:01 -0800
Message-ID: <1231278901.8844.14.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:59265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZAFVzE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 16:55:04 -0500
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n06Lt35A023029
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 13:55:03 -0800
Received: from bobble.smo.corp.google.com (bobble.smo.corp.google.com [172.29.60.126])
	(authenticated bits=0)
	by zps36.corp.google.com with ESMTP id n06Lt1Jn019586
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 13:55:02 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch cleans up the no-journal signaling in ext4, removing the new
s_nojournal_flag that was previously introduced in ext4_sb_info for this
purpose.  It also cleans up the write_dirty_metadata handling and fixes
a bug in ext4_sync_fs().

Signed-off-by: Frank Mayhar <fmayhar@google.com>
---
 ext4_jbd2.c  |   17 +++++++++++++++--
 ext4_jbd2.h  |   28 ++++++++--------------------
 ext4_sb.h    |    1 -
 ialloc.c.rej |only
 inode.c      |   19 -------------------
 super.c      |   28 +++++++++++++++++++---------
 6 files changed, 42 insertions(+), 51 deletions(-)

diff -rup oext4/fs/ext4/ext4_jbd2.c ext4/fs/ext4/ext4_jbd2.c
--- oext4/fs/ext4/ext4_jbd2.c	2009-01-06 12:30:27.000000000 -0800
+++ ext4/fs/ext4/ext4_jbd2.c	2009-01-06 12:12:55.000000000 -0800
@@ -69,8 +69,8 @@ int __ext4_journal_get_create_access(con
 	return err;
 }
 
-int __ext4_journal_dirty_metadata(const char *where,
-				handle_t *handle, struct buffer_head *bh)
+int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
+				struct inode *inode, struct buffer_head *bh)
 {
 	int err = 0;
 
@@ -78,6 +78,19 @@ int __ext4_journal_dirty_metadata(const 
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
 			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	} else {
+		mark_buffer_dirty(bh);
+		if (inode && inode_needs_sync(inode)) {
+			sync_dirty_buffer(bh);
+			if (buffer_req(bh) && !buffer_uptodate(bh)) {
+				ext4_error(inode->i_sb, __func__,
+					   "IO error syncing inode, "
+					   "inode=%lu, block=%llu",
+					   inode->i_ino,
+					   (unsigned long long)bh->b_blocknr);
+				err = -EIO;
+			}
+		}
 	}
 	return err;
 }
diff -rup oext4/fs/ext4/ext4_jbd2.h ext4/fs/ext4/ext4_jbd2.h
--- oext4/fs/ext4/ext4_jbd2.h	2009-01-06 12:30:27.000000000 -0800
+++ ext4/fs/ext4/ext4_jbd2.h	2009-01-06 12:15:14.000000000 -0800
@@ -19,8 +19,6 @@
 #include <linux/jbd2.h>
 #include "ext4.h"
 
-#define EXT4_NOJOURNAL_MAGIC	(void *)0x457874344e6a6e6c /* "Ext4Njnl" */
-
 #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
 
 /* Define the number of blocks we need to account to a transaction to
@@ -142,10 +140,9 @@ int __ext4_journal_revoke(const char *wh
 int __ext4_journal_get_create_access(const char *where,
 				handle_t *handle, struct buffer_head *bh);
 
-int __ext4_journal_dirty_metadata(const char *where,
-				handle_t *handle, struct buffer_head *bh);
-
-int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh);
+int __ext4_handle_dirty_metadata(const char *where,
+				handle_t *handle, struct inode *inode,
+				struct buffer_head *bh);
 
 #define ext4_journal_get_undo_access(handle, bh) \
 	__ext4_journal_get_undo_access(__func__, (handle), (bh))
@@ -157,32 +154,23 @@ int __ext4_write_dirty_metadata(struct i
 	__ext4_journal_get_create_access(__func__, (handle), (bh))
 #define ext4_journal_forget(handle, bh) \
 	__ext4_journal_forget(__func__, (handle), (bh))
+#define ext4_handle_dirty_metadata(handle, inode, bh) \
+	__ext4_handle_dirty_metadata(__func__, (handle), (inode), (bh))
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);
 
 static inline int ext4_handle_valid(handle_t *handle)
 {
+	extern void *ext4_no_journal_in_use;
+
 	if (handle == NULL)
 		return 1;
-	if (handle->h_transaction == EXT4_NOJOURNAL_MAGIC)
+	if (handle == ext4_no_journal_in_use)
 		return 0;
 	return 1;
 }
 
-static inline int ext4_handle_dirty_metadata(handle_t *handle,
-				struct inode *inode, struct buffer_head *bh)
-{
-	int err;
-
-	if (ext4_handle_valid(handle)) {
-		err = __ext4_journal_dirty_metadata(__func__, handle, bh);
-	} else {
-		err = __ext4_write_dirty_metadata(inode, bh);
-	}
-	return err;
-}
-
 static inline void ext4_handle_sync(handle_t *handle)
 {
 	if (ext4_handle_valid(handle))
diff -rup oext4/fs/ext4/ext4_sb.h ext4/fs/ext4/ext4_sb.h
--- oext4/fs/ext4/ext4_sb.h	2009-01-06 12:30:27.000000000 -0800
+++ ext4/fs/ext4/ext4_sb.h	2009-01-06 12:15:48.000000000 -0800
@@ -28,7 +28,6 @@
  * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
-	int *s_nojournal_flag;		/* Null to indicate "not a handle" */
 	unsigned long s_desc_size;	/* Size of a group descriptor in bytes */
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
Only in ext4/fs/ext4: ialloc.c.rej
diff -rup oext4/fs/ext4/inode.c ext4/fs/ext4/inode.c
--- oext4/fs/ext4/inode.c	2009-01-06 12:30:27.000000000 -0800
+++ ext4/fs/ext4/inode.c	2009-01-06 12:18:11.000000000 -0800
@@ -4423,25 +4423,6 @@ int ext4_write_inode(struct inode *inode
 	return ext4_force_commit(inode->i_sb);
 }
 
-int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh)
-{
-	int err = 0;
-
-	mark_buffer_dirty(bh);
-	if (inode && inode_needs_sync(inode)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			ext4_error(inode->i_sb, __func__,
-				   "IO error syncing inode, "
-				   "inode=%lu, block=%llu",
-				   inode->i_ino,
-				   (unsigned long long)bh->b_blocknr);
-			err = -EIO;
-		}
-	}
-	return err;
-}
-
 /*
  * ext4_setattr()
  *
diff -rup oext4/fs/ext4/super.c ext4/fs/ext4/super.c
--- oext4/fs/ext4/super.c	2009-01-06 12:30:27.000000000 -0800
+++ ext4/fs/ext4/super.c	2009-01-06 12:25:24.000000000 -0800
@@ -47,6 +47,15 @@
 #include "namei.h"
 #include "group.h"
 
+/*
+ * This is used to stand in for a real handle when we're running without
+ * a journal.  In that case, the handle pointer is really a pointer to
+ * 'dummy_handle' via ext4_no_journal_in_use.  The ext4_handle_valid()
+ * routine compares the passed handle pointer to this.
+ */
+static int dummy_handle = 0x0bad;
+void *ext4_no_journal_in_use = &dummy_handle;
+
 struct proc_dir_entry *ext4_proc_root;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -145,10 +154,9 @@ handle_t *ext4_journal_start_sb(struct s
 		return jbd2_journal_start(journal, nblocks);
 	}
 	/*
-	 * We're not journaling.  Return a pointer to our flag that
-	 * indicates that fact.
+	 * We're not journaling, return the appropriate indication.
 	 */
-	current->journal_info = (handle_t *)&EXT4_SB(sb)->s_nojournal_flag;
+	current->journal_info = ext4_no_journal_in_use;
 	return current->journal_info;
 }
 
@@ -1913,7 +1921,6 @@ static int ext4_fill_super(struct super_
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
-	sbi->s_nojournal_flag = EXT4_NOJOURNAL_MAGIC;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
 	sbi->s_resgid = EXT4_DEF_RESGID;
@@ -2966,11 +2973,14 @@ static int ext4_sync_fs(struct super_blo
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
-	if (wait)
-		ret = ext4_force_commit(sb);
-	else
-		if (EXT4_SB(sb)->s_journal)
-			jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	if (EXT4_SB(sb)->s_journal) {
+		if (wait)
+			ret = ext4_force_commit(sb);
+		else
+ 			jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	} else {
+		ext4_commit_super(sb, EXT4_SB(sb)->s_es, wait);
+	}
 	return ret;
 }
 
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

