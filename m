From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Check io list state and avoid an unnecessary mutex_lock in ext4_end_io_work.
Date: Wed, 14 Sep 2011 16:33:02 +0800
Message-ID: <1315989182-6170-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57258 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752811Ab1INIdN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 04:33:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

When we finish the end io work in ext4_flush_completed_IO, we take
the io work away from the list, but don't free it. Then in the workqueue,
we can check the list state and then avoid the extra work if it is also
done. It is good, but we check list state in ext4_end_io_nolock with i_mutex held
instead of the spin_lock in other places. This is wrong.

So check the state within spin_lock and another side effect is that the heavy extra
mutex_lock can be avoided.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/page-io.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 92f38ee..f6b40f1 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -100,9 +100,6 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	if (list_empty(&io->list))
-		return ret;
-
 	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
 		return ret;
 
@@ -142,6 +139,13 @@ static void ext4_end_io_work(struct work_struct *work)
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
@@ -170,6 +174,7 @@ static void ext4_end_io_work(struct work_struct *work)
 		list_del_init(&io->list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 	mutex_unlock(&inode->i_mutex);
+free:
 	ext4_free_io_end(io);
 }
 
-- 
1.7.0.4

