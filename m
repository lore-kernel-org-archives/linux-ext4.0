From: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] Possible data loss on ext[34], reiserfs with external
	journal
Date: Fri, 11 Dec 2009 11:16:08 +0300
Message-ID: <20091211081608.GA597088@fiona.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext3@vger.kernel.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello!

   It seems when external journal device is used for ext3, ext4 and reiserfs
   (possibly others, but I can only readily confirm these three) and
   main filesystem device had writeback cache enabled, a very real
   data loss is possible because we never flush main device cache on commit.
   As a result if we just wrote some files in ordered mode and then
   transaction was committed, the journal data makes it to the disk
   (provided that barriers are in use), but the actual file data only made
   it to the device cache. As such sudden loss of power at this stage
   would lead to files in place, but their content replaced with
   whatever happened to be in those blocks before.

   This simple patch at the end should remedy the problem.

   Also I wonder if there would be a strong opposition to add async version
   of blkdev_issue_flush()? Essentially it would be current blkdev_issue_flush
   that returns straight after submit_bio() call and returns the bio itself
   as a void *cookie for later waiting by the caller. (natirally the completion
   would need to be allocated on stack)

   This would allow us to have extra optimization to avoid dead waiting and
   submit the barrier to data device right after we scheduled all data
   blocks and then call completion waiting right before we submit commit
   record. We'll have actual transaction preparation and writing in between.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
 
 jbd/commit.c       |    7 +++++++
 jbd2/commit.c      |    8 ++++++++
 reiserfs/journal.c |    5 +++++
 3 files changed, 20 insertions(+)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 4bd8825..60c190c 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/blkdev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -787,6 +788,12 @@ wait_for_iobuf:
 
 	jbd_debug(3, "JBD: commit phase 6\n");
 
+	/* Flush the external data device first */
+	if ((journal->j_fs_dev != journal->j_dev) &&
+	    journal->j_flags & JFS_BARRIER)
+		blkdev_issue_flush(journal->j_fs_dev, NULL);
+
+
 	if (journal_write_commit_record(journal, commit_transaction))
 		err = -EIO;
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8896c1d..e653d72 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -712,6 +712,10 @@ start_journal_io:
 
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+		/* Flush the external data device first */
+		if ((journal->j_fs_dev != journal->j_dev) &&
+		    journal->j_flags & JBD2_BARRIER)
+			blkdev_issue_flush(journal->j_fs_dev, NULL);
 		err = journal_submit_commit_record(journal, commit_transaction,
 						 &cbh, crc32_sum);
 		if (err)
@@ -841,6 +845,10 @@ wait_for_iobuf:
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
 				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+		/* Flush the external data device first */
+		if ((journal->j_fs_dev != journal->j_dev) &&
+		    journal->j_flags & JBD2_BARRIER)
+			blkdev_issue_flush(journal->j_fs_dev, NULL);
 		err = journal_submit_commit_record(journal, commit_transaction,
 						&cbh, crc32_sum);
 		if (err)
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 2f8a7e7..c49f5a3 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1104,6 +1104,11 @@ static int flush_commit_list(struct super_block *s,
 	barrier = reiserfs_barrier_flush(s);
 	if (barrier) {
 		int ret;
+
+		/* Wait for data device flush to finish first */
+		if ((s->s_dev != journal->j_dev_bd))
+			blkdev_issue_flush(s->s_dev, NULL);
+	
 		lock_buffer(jl->j_commit_bh);
 		ret = submit_barrier_buffer(jl->j_commit_bh);
 		if (ret == -EOPNOTSUPP) {
