From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/6] jbd2: yield the device queue when waiting for journal commits
Date: Fri,  2 Jul 2010 15:58:16 -0400
Message-ID: <1278100699-24132-4-git-send-email-jmoyer@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665Ab0GBT6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 15:58:33 -0400
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch gets CFQ back in line with deadline for iozone runs, especially
those testing small files + fsync timings.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/jbd2/journal.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bc2ff59..6b5bf0f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -41,6 +41,7 @@
 #include <linux/hash.h>
 #include <linux/log2.h>
 #include <linux/vmalloc.h>
+#include <linux/blkdev.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -192,6 +193,7 @@ loop:
 			should_sleep = 0;
 		if (should_sleep) {
 			spin_unlock(&journal->j_state_lock);
+			blk_yield(journal->j_dev->bd_disk->queue, NULL);
 			schedule();
 			spin_lock(&journal->j_state_lock);
 		}
@@ -580,6 +582,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	while (tid_gt(tid, journal->j_commit_sequence)) {
 		jbd_debug(1, "JBD: want %d, j_commit_sequence=%d\n",
 				  tid, journal->j_commit_sequence);
+		/*
+		 * Give up our I/O scheduler time slice to allow the journal
+		 * thread to issue I/O.
+		 */
+		blk_yield(journal->j_dev->bd_disk->queue, journal->j_task);
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
 		wait_event(journal->j_wait_done_commit,
-- 
1.6.5.2

