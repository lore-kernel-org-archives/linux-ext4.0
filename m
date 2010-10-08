From: Dmitry Monakhov <dmonakhov@gmail.com>
Subject: [PATCH 2/2] writeback: skip useless data integrity tricks for sync_filesystem
Date: Fri,  8 Oct 2010 19:00:27 +0400
Message-ID: <1286550027-9684-2-git-send-email-dmonakhov@gmail.com>
References: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@gmail.com>
To: jaxboe@fusionio.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37780 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab0JHPAh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 11:00:37 -0400
In-Reply-To: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we about to write many inodes at the time, even in for
data integrity sync, it is reasonable to skip data integrity
logic for each inode, but perform all necessary steps at the end.

The frozen sync() issue:
If we try to call sync() then other process dirties inodes in
parallels we end up with writing inodes in sync mode, which
usually result in io_barriers spam. Which result in almost 100 times
performance degradation.

___sync_task____			____writer_task____
sync_filesystem() {
  __sync_filesystem(sb, 0)
                                while(num--) {mark_inode_dirty(inode++);}
  __sync_filesystem(sb, 1)
     ->sb->s_opt->sync_fs()
 }
But in case of sync_fs we do know that final ->sync_fs() is responsible
for data integrity guaranties.

Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
---
 fs/ext3/inode.c           |    3 ++-
 fs/ext4/inode.c           |    4 +++-
 fs/fs-writeback.c         |    3 +++
 fs/reiserfs/inode.c       |    3 ++-
 include/linux/writeback.h |    1 +
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..8d90ada 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3153,7 +3153,8 @@ int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (wbc->sync_mode != WB_SYNC_ALL)
 		return 0;
-
+	if (wbc->for_sync_fs)
+		return 0;
 	return ext3_force_commit(inode->i_sb);
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..8d627e8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5416,7 +5416,9 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 		if (wbc->sync_mode != WB_SYNC_ALL)
 			return 0;
-
+		/* Caller is responsible to call ->sync_fs() after writeback */
+		if (wbc->for_sync_fs)
+			return 0;
 		err = ext4_force_commit(inode->i_sb);
 	} else {
 		struct ext4_iloc iloc;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 81e086d..4f50067 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -39,6 +39,7 @@ struct wb_writeback_work {
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
+	unsigned int for_sync_fs:1;
 
 	struct list_head list;		/* pending work list */
 	struct completion *done;	/* set if the caller waits */
@@ -600,6 +601,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		.older_than_this	= NULL,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
+		.for_sync_fs		= work->for_sync_fs,
 		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
@@ -1124,6 +1126,7 @@ void sync_inodes_sb(struct super_block *sb)
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
+		.for_sync_fs	= 1,
 		.done		= &done,
 	};
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index caa7583..244bf0e 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1638,7 +1638,8 @@ int reiserfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	 ** inode needs to reach disk for safety, and they can safely be
 	 ** ignored because the altered inode has already been logged.
 	 */
-	if (wbc->sync_mode == WB_SYNC_ALL && !(current->flags & PF_MEMALLOC)) {
+	if (wbc->sync_mode == WB_SYNC_ALL && !(current->flags & PF_MEMALLOC) &&
+		!wbc->for_sync_fs) {
 		reiserfs_write_lock(inode->i_sb);
 		if (!journal_begin(&th, inode->i_sb, jbegin_count)) {
 			reiserfs_update_sd(&th, inode);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 72a5d64..a2f7c57 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -50,6 +50,7 @@ struct writeback_control {
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
+	unsigned for_sync_fs:1;		/* Invoked from sync_filesystem*/
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
 };
-- 
1.6.6.1

