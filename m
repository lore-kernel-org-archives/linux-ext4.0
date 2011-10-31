From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] ext4: Use correct locking for ext4_end_io_nolock()
Date: Mon, 31 Oct 2011 11:02:45 -0400
Message-ID: <1320073367-28916-1-git-send-email-tytso@mit.edu>
References: <20111031150206.GC16825@thunk.org>
Cc: Tao Ma <boyu.mt@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37936 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066Ab1JaPCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 11:02:49 -0400
In-Reply-To: <20111031150206.GC16825@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

We must hold i_completed_io_lock when manipulating anything on the
i_completed_io_list linked list.  This includes io->lock, which we
were checking in ext4_end_io_nolock().

So move this check to ext4_end_io_work().  This also has the bonus of
avoiding extra work if it is already done without needing to take the
mutex.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c   |    3 ---
 fs/ext4/page-io.c |   14 +++++++++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c942924..851ac5b 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -83,9 +83,6 @@ int ext4_flush_completed_IO(struct inode *inode)
 	int ret = 0;
 	int ret2 = 0;
 
-	if (list_empty(&ei->i_completed_io_list))
-		return ret;
-
 	dump_completed_IO(inode);
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	while (!list_empty(&ei->i_completed_io_list)){
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 92f38ee..aed4096 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -87,6 +87,9 @@ void ext4_free_io_end(ext4_io_end_t *io)
 
 /*
  * check a range of space and convert unwritten extents to written.
+ *
+ * Called with inode->i_mutex; we depend on this when we manipulate
+ * io->flag, since we could otherwise race with ext4_flush_completed_IO()
  */
 int ext4_end_io_nolock(ext4_io_end_t *io)
 {
@@ -100,9 +103,6 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	if (list_empty(&io->list))
-		return ret;
-
 	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
 		return ret;
 
@@ -142,6 +142,13 @@ static void ext4_end_io_work(struct work_struct *work)
 	unsigned long		flags;
 	int			ret;
 
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&io->list)) {
+		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+		goto free;
+	}
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+
 	if (!mutex_trylock(&inode->i_mutex)) {
 		/*
 		 * Requeue the work instead of waiting so that the work
@@ -170,6 +177,7 @@ static void ext4_end_io_work(struct work_struct *work)
 		list_del_init(&io->list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 	mutex_unlock(&inode->i_mutex);
+free:
 	ext4_free_io_end(io);
 }
 
-- 
1.7.4.1.22.gec8e1.dirty

