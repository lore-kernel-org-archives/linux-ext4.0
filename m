From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Factor out replay_tag()
Date: Wed, 13 Oct 2010 14:53:31 +0900
Message-ID: <1286949211-4175-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Split replay_tag() out of do_one_pass() to make code more readable.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/recovery.c |  131 +++++++++++++++++++++++++++--------------------------
 1 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 5b43e96..8ebdfc7 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -307,6 +307,66 @@ int journal_skip_recovery(journal_t *journal)
 	return err;
 }
 
+/* Write given block in the log to disk */
+static int replay_tag(journal_t *journal, journal_block_tag_t *tag,
+		      unsigned int log_block, unsigned int commit_id,
+		      struct recovery_info *info, int *success)
+{
+	int err;
+	int flags;
+	unsigned int blocknr;
+	struct buffer_head *obh;
+	struct buffer_head *nbh;
+
+	err = jread(&obh, journal, log_block);
+	if (err) {
+		/* Recover what we can, but report failure at the end. */
+		*success = err;
+		printk(KERN_ERR "JBD: IO error %d recovering block %u "
+		       "in log\n", err, log_block);
+		err = 0;
+		goto out;
+	}
+
+	J_ASSERT(obh != NULL);
+	blocknr = be32_to_cpu(tag->t_blocknr);
+
+	/* If the block has been revoked, then we're all done here. */
+	if (journal_test_revoke(journal, blocknr, commit_id)) {
+		brelse(obh);
+		++info->nr_revoke_hits;
+		goto out;
+	}
+
+	/* Find a buffer for the new data being restored */
+	nbh = __getblk(journal->j_fs_dev, blocknr, journal->j_blocksize);
+	if (nbh == NULL) {
+		printk(KERN_ERR "JBD: Out of memory during recovery.\n");
+		err = -ENOMEM;
+		brelse(obh);
+		goto out;
+	}
+
+	flags = be32_to_cpu(tag->t_flags);
+
+	lock_buffer(nbh);
+	memcpy(nbh->b_data, obh->b_data, journal->j_blocksize);
+	if (flags & JFS_FLAG_ESCAPE)
+		*((__be32 *)nbh->b_data) = cpu_to_be32(JFS_MAGIC_NUMBER);
+
+	BUFFER_TRACE(nbh, "marking dirty");
+	set_buffer_uptodate(nbh);
+	mark_buffer_dirty(nbh);
+	BUFFER_TRACE(nbh, "marking uptodate");
+	++info->nr_replays;
+	/* ll_rw_block(WRITE, 1, &nbh); */
+	unlock_buffer(nbh);
+	brelse(obh);
+	brelse(nbh);
+out:
+	return err;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -346,8 +406,6 @@ static int do_one_pass(journal_t *journal,
 		int			flags;
 		char *			tagp;
 		journal_block_tag_t *	tag;
-		struct buffer_head *	obh;
-		struct buffer_head *	nbh;
 
 		cond_resched();
 
@@ -421,74 +479,19 @@ static int do_one_pass(journal_t *journal,
 			tagp = &bh->b_data[sizeof(journal_header_t)];
 			while ((tagp - bh->b_data +sizeof(journal_block_tag_t))
 			       <= journal->j_blocksize) {
-				unsigned int io_block;
-
 				tag = (journal_block_tag_t *) tagp;
 				flags = be32_to_cpu(tag->t_flags);
 
-				io_block = next_log_block++;
-				wrap(journal, next_log_block);
-				err = jread(&obh, journal, io_block);
+				err = replay_tag(journal, tag, next_log_block,
+					      next_commit_ID, info, &success);
 				if (err) {
-					/* Recover what we can, but
-					 * report failure at the end. */
-					success = err;
-					printk (KERN_ERR
-						"JBD: IO error %d recovering "
-						"block %u in log\n",
-						err, io_block);
-				} else {
-					unsigned int blocknr;
-
-					J_ASSERT(obh != NULL);
-					blocknr = be32_to_cpu(tag->t_blocknr);
-
-					/* If the block has been
-					 * revoked, then we're all done
-					 * here. */
-					if (journal_test_revoke
-					    (journal, blocknr,
-					     next_commit_ID)) {
-						brelse(obh);
-						++info->nr_revoke_hits;
-						goto skip_write;
-					}
-
-					/* Find a buffer for the new
-					 * data being restored */
-					nbh = __getblk(journal->j_fs_dev,
-							blocknr,
-							journal->j_blocksize);
-					if (nbh == NULL) {
-						printk(KERN_ERR
-						       "JBD: Out of memory "
-						       "during recovery.\n");
-						err = -ENOMEM;
-						brelse(bh);
-						brelse(obh);
-						goto failed;
-					}
-
-					lock_buffer(nbh);
-					memcpy(nbh->b_data, obh->b_data,
-							journal->j_blocksize);
-					if (flags & JFS_FLAG_ESCAPE) {
-						*((__be32 *)nbh->b_data) =
-						cpu_to_be32(JFS_MAGIC_NUMBER);
-					}
-
-					BUFFER_TRACE(nbh, "marking dirty");
-					set_buffer_uptodate(nbh);
-					mark_buffer_dirty(nbh);
-					BUFFER_TRACE(nbh, "marking uptodate");
-					++info->nr_replays;
-					/* ll_rw_block(WRITE, 1, &nbh); */
-					unlock_buffer(nbh);
-					brelse(obh);
-					brelse(nbh);
+					brelse(bh);
+					goto failed;
 				}
 
-			skip_write:
+				next_log_block++;
+				wrap(journal, next_log_block);
+
 				tagp += sizeof(journal_block_tag_t);
 				if (!(flags & JFS_FLAG_SAME_UUID))
 					tagp += 16;
-- 
1.7.0.4
