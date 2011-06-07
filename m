From: Tao Ma <tm@tao.ma>
Subject: [PATCH] jbd: Use WRITE_SYNC in journal checkpoint.
Date: Tue,  7 Jun 2011 11:56:50 +0800
Message-ID: <1307419010-3390-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46077 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753993Ab1FGD5F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 23:57:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In journal checkpoint, we write the buffer and wait for its finish.
But in cfq, the async queue has a very low priority, and in our test,
if there are too many sync queues and every queue is filled up with
requests, and the process will hang waiting for the log space.

So this patch tries to use WRITE_SYNC in __flush_batch so that the request will
be moved into sync queue and handled by cfq timely. We also use the new plug,
sot that all the WRITE_SYNC requests can be given as a whole when we unplug it.

Cc: Jan Kara <jack@suse.cz>
Reported-by: Robin Dong <sanbai@taobao.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd/checkpoint.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index e4b87bc..a7ce053 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -22,6 +22,7 @@
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 
 /*
  * Unlink a buffer from a transaction checkpoint list.
@@ -253,9 +254,12 @@ static void
 __flush_batch(journal_t *journal, struct buffer_head **bhs, int *batch_count)
 {
 	int i;
+	struct blk_plug plug;
 
+	blk_start_plug(&plug);
 	for (i = 0; i < *batch_count; i++)
-		write_dirty_buffer(bhs[i], WRITE);
+		write_dirty_buffer(bhs[i], WRITE_SYNC);
+	blk_finish_plug(&plug);
 
 	for (i = 0; i < *batch_count; i++) {
 		struct buffer_head *bh = bhs[i];
-- 
1.7.4

