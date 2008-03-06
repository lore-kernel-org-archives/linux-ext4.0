From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery loop into separate functions
Date: Thu,  6 Mar 2008 01:59:12 +0000
Message-ID: <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg__12759.1923847378$1204769406$gmane$org@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
 <1204768754-29655-2-git-send-email-duaneg@dghda.com>
 <1204768754-29655-3-git-send-email-duaneg@dghda.com>
 <1204768754-29655-4-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764341AbYCFCIr@vger.kernel.org>
In-Reply-To: <1204768754-29655-4-git-send-email-duaneg@dghda.com>
Message-Id: <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
In-Reply-To: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The do_one_pass function iterates through the jbd log operating on blocks
depending on the pass. During the replay pass descriptor blocks are processed
by an inner loop which replays them. The nesting makes the code difficult to
follow or to modify. Splitting the inner loop and replay code into separate
functions simplifies matters.

The refactored code no longer unnecessarily reads revoked data blocks, so
potential read errors from such blocks will cause differing behaviour. Aside
from that there should be no functional effect.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Note the TODO before the block read in the outer loop below. We could possibly
attempt to continue after a failed read as we do when replaying descriptor
blocks. However if it was a descriptor block we'd likely bomb out on the next
iteration anyway, so I'm not sure it would be worth it. Thoughts?

 fs/jbd/recovery.c |  243 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 127 insertions(+), 116 deletions(-)

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 2b8edf4..e2ac78f 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -307,6 +307,101 @@ int journal_skip_recovery(journal_t *journal)
 	return err;
 }
 
+static int replay_data_block(
+	journal_t *journal, struct buffer_head *obh, char *data,
+	int flags, unsigned long blocknr)
+{
+	struct buffer_head *nbh;
+
+	/* Find a buffer for the new data being restored */
+	nbh = __getblk(journal->j_fs_dev, blocknr, journal->j_blocksize);
+	if (nbh == NULL)
+		return -ENOMEM;
+
+	lock_buffer(nbh);
+	memcpy(nbh->b_data, obh->b_data, journal->j_blocksize);
+	if (flags & JFS_FLAG_ESCAPE)
+		*((__be32 *)data) = cpu_to_be32(JFS_MAGIC_NUMBER);
+
+	BUFFER_TRACE(nbh, "marking dirty");
+	set_buffer_uptodate(nbh);
+	mark_buffer_dirty(nbh);
+	BUFFER_TRACE(nbh, "marking uptodate");
+	/* ll_rw_block(WRITE, 1, &nbh); */
+	unlock_buffer(nbh);
+	brelse(nbh);
+
+	return 0;
+}
+
+/* Replay a descriptor block: write all of the data blocks. */
+static int replay_descriptor_block(
+	journal_t *journal, char *data,
+	unsigned int next_commit_ID,
+	unsigned long *next_log_block,
+	struct recovery_info *info)
+{
+	int err;
+	int success = 0;
+	char *tagp;
+	unsigned long io_block;
+	struct buffer_head *obh;
+	unsigned long next = *next_log_block;
+
+	tagp = &data[sizeof(journal_header_t)];
+	while ((tagp - data + sizeof(journal_block_tag_t)) <=
+	       journal->j_blocksize) {
+		unsigned long blocknr;
+		journal_block_tag_t *tag = (journal_block_tag_t *) tagp;
+		int flags = be32_to_cpu(tag->t_flags);
+
+		io_block = next++;
+		wrap(journal, next);
+		blocknr = be32_to_cpu(tag->t_blocknr);
+
+		/* If the block has been revoked, then we're all done here. */
+		if (journal_test_revoke(journal, blocknr, next_commit_ID)) {
+			++info->nr_revoke_hits;
+			goto skip_write;
+		}
+
+		err = jread(&obh, journal, io_block);
+		if (err) {
+
+			/* Recover what we can, but
+			 * report failure at the end. */
+			success = err;
+			printk(KERN_ERR "JBD: IO error %d recovering "
+			       "block %ld in log\n", err, io_block);
+			continue;
+		}
+		J_ASSERT(obh != NULL);
+
+		err = replay_data_block(journal, obh, data, flags, blocknr);
+		if (err) {
+			brelse(obh);
+			printk(KERN_ERR "JBD: Out of memory during recovery\n");
+			success = err;
+			goto failed;
+		}
+
+		++info->nr_replays;
+		brelse(obh);
+
+skip_write:
+		tagp += sizeof(journal_block_tag_t);
+		if (!(flags & JFS_FLAG_SAME_UUID))
+			tagp += 16;
+
+		if (flags & JFS_FLAG_LAST_TAG)
+			break;
+	}
+
+	*next_log_block = next;
+failed:
+	return success;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -316,8 +411,6 @@ static int do_one_pass(journal_t *journal,
 	journal_superblock_t *	sb;
 	journal_header_t *	tmp;
 	struct buffer_head *	bh;
-	unsigned int		sequence;
-	int			blocktype;
 
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
@@ -348,11 +441,8 @@ static int do_one_pass(journal_t *journal,
 	 */
 
 	while (1) {
-		int			flags;
-		char *			tagp;
-		journal_block_tag_t *	tag;
-		struct buffer_head *	obh;
-		struct buffer_head *	nbh;
+		int blocktype;
+		unsigned int sequence;
 
 		cond_resched();
 
@@ -371,10 +461,13 @@ static int do_one_pass(journal_t *journal,
 		 * either the next descriptor block or the final commit
 		 * record. */
 
+		/* TODO: Should we continue on error? */
 		jbd_debug(3, "JBD: checking block %ld\n", next_log_block);
 		err = jread(&bh, journal, next_log_block);
-		if (err)
+		if (err) {
+			success = err;
 			goto failed;
+		}
 
 		next_log_block++;
 		wrap(journal, next_log_block);
@@ -406,137 +499,57 @@ static int do_one_pass(journal_t *journal,
 		 * all of the sequence number checks.  What are we going
 		 * to do with it?  That depends on the pass... */
 
-		switch(blocktype) {
+		switch (blocktype) {
 		case JFS_DESCRIPTOR_BLOCK:
 			/* If it is a valid descriptor block, replay it
 			 * in pass REPLAY; otherwise, just skip over the
 			 * blocks it describes. */
-			if (pass != PASS_REPLAY) {
+			if (pass == PASS_REPLAY) {
+				err = replay_descriptor_block(
+					journal,
+					bh->b_data,
+					next_commit_ID,
+					&next_log_block,
+					info);
+			} else {
 				next_log_block +=
 					count_tags(bh, journal->j_blocksize);
 				wrap(journal, next_log_block);
-				brelse(bh);
-				continue;
 			}
-
-			/* A descriptor block: we can now write all of
-			 * the data blocks.  Yay, useful work is finally
-			 * getting done here! */
-
-			tagp = &bh->b_data[sizeof(journal_header_t)];
-			while ((tagp - bh->b_data +sizeof(journal_block_tag_t))
-			       <= journal->j_blocksize) {
-				unsigned long io_block;
-
-				tag = (journal_block_tag_t *) tagp;
-				flags = be32_to_cpu(tag->t_flags);
-
-				io_block = next_log_block++;
-				wrap(journal, next_log_block);
-				err = jread(&obh, journal, io_block);
-				if (err) {
-					/* Recover what we can, but
-					 * report failure at the end. */
-					success = err;
-					printk (KERN_ERR
-						"JBD: IO error %d recovering "
-						"block %ld in log\n",
-						err, io_block);
-				} else {
-					unsigned long blocknr;
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
-						*((__be32 *)bh->b_data) =
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
-				}
-
-			skip_write:
-				tagp += sizeof(journal_block_tag_t);
-				if (!(flags & JFS_FLAG_SAME_UUID))
-					tagp += 16;
-
-				if (flags & JFS_FLAG_LAST_TAG)
-					break;
-			}
-
-			brelse(bh);
-			continue;
+			break;
 
 		case JFS_COMMIT_BLOCK:
 			/* Found an expected commit block: not much to
 			 * do other than move on to the next sequence
 			 * number. */
-			brelse(bh);
 			next_commit_ID++;
-			continue;
+			break;
 
 		case JFS_REVOKE_BLOCK:
 			/* If we aren't in the REVOKE pass, then we can
 			 * just skip over this block. */
-			if (pass != PASS_REVOKE) {
-				brelse(bh);
-				continue;
+			if (pass == PASS_REVOKE) {
+				err = scan_revoke_records(
+					journal, bh, next_commit_ID, info);
 			}
-
-			err = scan_revoke_records(journal, bh,
-						  next_commit_ID, info);
-			brelse(bh);
-			if (err)
-				goto failed;
-			continue;
+			break;
 
 		default:
 			jbd_debug(3, "Unrecognised magic %d, end of scan.\n",
 				  blocktype);
-			brelse(bh);
-			goto done;
+			break;
 		}
+
+		brelse(bh);
+
+		/* Immediately fail on OOM; on other errors try to recover
+		 * as much as we can, but report the failure at the end. */
+		if (err)
+			success = err;
+		if (err == -ENOMEM)
+			goto failed;
 	}
 
- done:
 	/*
 	 * We broke out of the log scan loop: either we came to the
 	 * known end of the log or we found an unexpected block in the
@@ -558,10 +571,8 @@ static int do_one_pass(journal_t *journal,
 		}
 	}
 
-	return success;
-
  failed:
-	return err;
+	return success;
 }
 
 
-- 
1.5.3.7
