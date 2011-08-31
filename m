From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH] ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining
Date: Tue, 30 Aug 2011 18:08:10 -0700 (PDT)
Message-ID: <20110831010810.DBC952012E@ruihe2.smo.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:21320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab1HaBIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 21:08:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The i_mutex lock and flush_completed_IO() added by commit 2581fdc810 in
ext4_evict_inode() causes lockdep complaining about potential deadlock in
several places. This change removes the flush_completed_IO() and i_mutex lock
in ext4_evict_inode(). Instead, we take a different approach to resolve the
software lockup that commit 2581fdc810 intends to fix. Rather than having
ext4-dio-unwritten thread wait for grabing the i_mutex lock of an inode, we
use mutex_trylock() instead, and simply requeue the work item if we fail to
grab the inode's i_mutex lock. This should speed up work queue processing in
general and also prevents the following deadlock scenario: During page fault,
shrink_icache_memory is called that in turn evicts another inode B. Inode B
has some pending io_end work so it calls ext4_ioend_wait() that waits for
inode B's i_ioend_count to become zero. However, inode B's ioend work was
queued behind some of inode A's ioend work on the same cpu's ext4-dio-unwritten
workqueue. As the ext4-dio-unwritten thread on that cpu is processing inode A's
ioend work, it tries to grab inode A's i_mutex lock. Since the i_mutex lock of
inode A is still hold before the page fault happened, we enter a deadlock.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |    3 ---
 fs/ext4/page-io.c |   18 +++++++++++++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..b7d7bd0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -175,6 +175,7 @@ struct mpage_da_data {
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
+#define EXT4_IO_END_QUEUED	0x0004
 
 struct ext4_io_page {
 	struct page	*p_page;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4da98a..18d2558 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -121,9 +121,6 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
-	mutex_lock(&inode->i_mutex);
-	ext4_flush_completed_IO(inode);
-	mutex_unlock(&inode->i_mutex);
 	ext4_ioend_wait(inode);
 
 	if (inode->i_nlink) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 78839af..92f38ee 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -142,7 +142,23 @@ static void ext4_end_io_work(struct work_struct *work)
 	unsigned long		flags;
 	int			ret;
 
-	mutex_lock(&inode->i_mutex);
+	if (!mutex_trylock(&inode->i_mutex)) {
+		/*
+		 * Requeue the work instead of waiting so that the work
+		 * items queued after this can be processed.
+		 */
+		queue_work(EXT4_SB(inode->i_sb)->dio_unwritten_wq, &io->work);
+		/*
+		 * To prevent the ext4-dio-unwritten thread from keeping
+		 * requeueing end_io requests and occupying cpu for too long,
+		 * yield the cpu if it sees an end_io request that has already
+		 * been requeued.
+		 */
+		if (io->flag & EXT4_IO_END_QUEUED)
+			yield();
+		io->flag |= EXT4_IO_END_QUEUED;
+		return;
+	}
 	ret = ext4_end_io_nolock(io);
 	if (ret < 0) {
 		mutex_unlock(&inode->i_mutex);
-- 
1.7.3.1

