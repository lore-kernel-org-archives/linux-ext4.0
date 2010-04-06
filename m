From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] jbd: tag journal writes as metadata I/O
Date: Tue, 06 Apr 2010 12:52:37 -0400
Message-ID: <x49eiisr0a2.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	Jan Kara <jack@ucw.cz>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab0DFQwt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Apr 2010 12:52:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In running iozone for writes to small files, we noticed a pretty big
discrepency between the performance of the deadline and cfq I/O
schedulers.  Investigation showed that I/O was being issued from 2
different contexts: the iozone process itself, and the jbd/sdh-8 thread
(as expected).  Because of the way cfq performs slice idling, the delays
introduced between the metadata and data I/Os were significant.  For
example, cfq would see about 7MB/s versus deadline's 35 for the same
workload.  I also tested fs_mark with writing and fsyncing 1000 64k
files, and a similar 5x performance difference was observed.  Eric
Sandeen suggested that I flag the journal writes as metadata, and once I
did that, the performance difference went away completely (cfq has
special logic to prioritize metadata I/O).

This is similar to the jbd2 patch I posted earlier that Ted has accepted
into his patch queue.  Comments, as always, are appreciated.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 4bd8825..e9f1369 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -318,7 +318,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
-	int write_op = WRITE;
+	int write_op = WRITE_META;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -357,7 +357,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC_PLUG | (1<<BIO_RW_META);
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
