From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/6] jbd: yield the device queue when waiting for commits
Date: Fri,  2 Jul 2010 15:58:15 -0400
Message-ID: <1278100699-24132-3-git-send-email-jmoyer@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab0GBT6c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 15:58:32 -0400
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch gets CFQ back in line with deadline for iozone runs, especially
those testing small files + fsync timings.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/jbd/journal.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 93d1e47..7bf7528 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/blkdev.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -183,6 +184,7 @@ loop:
 			should_sleep = 0;
 		if (should_sleep) {
 			spin_unlock(&journal->j_state_lock);
+			blk_yield(journal->j_dev->bd_disk->queue, NULL);
 			schedule();
 			spin_lock(&journal->j_state_lock);
 		}
@@ -549,6 +551,11 @@ int log_wait_commit(journal_t *journal, tid_t tid)
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

