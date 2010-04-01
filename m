From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Thu, 01 Apr 2010 15:04:54 -0400
Message-ID: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	esandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

In running iozone for writes to small files, we noticed a pretty big
discrepency between the performance of the deadline and cfq I/O
schedulers.  Investigation showed that I/O was being issued from 2
different contexts: the iozone process itself, and the jbd2/sdh-8 thread
(as expected).  Because of the way cfq performs slice idling, the delays
introduced between the metadata and data I/Os were significant.  For
example, cfq would see about 7MB/s versus deadline's 35 for the same
workload.  I also tested fs_mark with writing and fsyncing 1000 64k
files, and a similar 5x performance difference was observed.  Eric
Sandeen suggested that I flag the journal writes as metadata, and once I
did that, the performance difference went away completely (cfq has
special logic to prioritize metadata I/O).

So, I'm submitting this patch for comments and testing.  I have a
similar patch for jbd that I will submit if folks agree that this is a
good idea.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 671da7f..1998265 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -139,7 +139,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		set_buffer_ordered(bh);
 		barrier_done = 1;
 	}
-	ret = submit_bh(WRITE_SYNC_PLUG, bh);
+	ret = submit_bh(WRITE_SYNC_PLUG | (1<<BIO_RW_META), bh);
 	if (barrier_done)
 		clear_buffer_ordered(bh);
 
@@ -160,7 +160,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
 		clear_buffer_dirty(bh);
-		ret = submit_bh(WRITE_SYNC_PLUG, bh);
+		ret = submit_bh(WRITE_SYNC_PLUG | (1<<BIO_RW_META), bh);
 	}
 	*cbh = bh;
 	return ret;
@@ -369,7 +369,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
-	int write_op = WRITE;
+	int write_op = WRITE_META;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -409,7 +409,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * instead we rely on sync_buffer() doing the unplug for us.
 	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC_PLUG;
+		write_op = WRITE_SYNC_PLUG | (1<<BIO_RW_META);
 	trace_jbd2_commit_locking(journal, commit_transaction);
 	stats.run.rs_wait = commit_transaction->t_max_wait;
 	stats.run.rs_locked = jiffies;
