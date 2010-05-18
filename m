From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/4] jbd2: yield the device queue when waiting for journal commits
Date: Tue, 18 May 2010 14:20:20 -0400
Message-ID: <1274206820-17071-5-git-send-email-jmoyer@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, jens.axboe@oracle.com,
	vgoyal@redhat.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch gets CFQ back in line with deadline for iozone runs, especially
those testing small files + fsync timings.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/jbd2/journal.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c03d4dc..28848a6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -41,6 +41,7 @@
 #include <linux/hash.h>
 #include <linux/log2.h>
 #include <linux/vmalloc.h>
+#include <linux/blkdev.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -580,6 +581,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
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
