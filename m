From: Theodore Tso <tytso@mit.edu>
Subject: [PATCH] e2fsck: Fix potential data corruptor bug in journal
	recovery
Date: Tue, 20 May 2008 15:38:41 -0400
Message-ID: <20080520193841.GA19525@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>,
	Eric Sandeen <sandeen@redhat.com>,
	Martin Pitt <martin.pitt@ubuntu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36634 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757036AbYETTjG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 15:39:06 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While adding support for journal checksums into e2fsck, I found the
following rather embarassing bug.  It can potentially cause
data/fileysystem corruption, although tripping it would be quite rare.
Still, Enterprise distro's might consider this worthy of a bugfix
update --- that would have to be their call.  I've checked this into
e2fsprogs's maint branch and will probably release e2fsprogs 1.40.10
as a result of finding this bug, and cc'ed people that I know are
involved with Red Hat, SuSE and Ubuntu as a heads up.

If you want the minimalistic (one character!) patch to fix this bug,
here it is:

diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 22e79a5..f7fd7b6 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -473,7 +473,7 @@ static int do_one_pass(journal_t *journal,
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						*((unsigned int *)bh->b_data) =
+						*((unsigned int *)nbh->b_data) =
 							htonl(JFS_MAGIC_NUMBER);
 					}
 
		  	       	      	 	 - Ted

>From e5ea6b14eb93671525e01ec4a6100febe541bf67 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 20 May 2008 14:51:14 -0400
Subject: [PATCH] e2fsck: Fix potential data corruptor bug in journal recovery

While synchronizing e2fsck's recovery.c with the latest 2.6 kernel
sources, I discovered a serious bug that apparently had been fixed in
the kernel sometime between Deceber 2003 and April 2005, but which had
not been carried over to e2fsprogs.  Specifically, when blocks whose
first 4 bytes are JFS_MAGIC_NUMBER (0xc03b3998) are written into the
journal, the first 4 bytes zero'ed out.  A one character typo meant
that when the blocks were replayed by e2fsck, the JFS_MAGIC_NUMBER
would not be restored.

Oops.

Fortunately, it is *highly* unlikely that ext4 metadata blocks will
contain that magic number in the first four bytes, and data=journalled
is a relatively rarely used.

This commit fixes this bug, as well as updating e2fsck's recovery.c to
be in sync with 2.6.25.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/jfs_user.h |    4 +
 e2fsck/recovery.c |  171 +++++++++++++++++++++++++++--------------------------
 2 files changed, 92 insertions(+), 83 deletions(-)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index c38def3..9da5a16 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -59,6 +59,10 @@ typedef struct {
 #define kmalloc(len,flags) malloc(len)
 #define kfree(p) free(p)
 
+#define cond_resched()	do { } while (0)
+
+typedef unsigned int __be32;
+
 /*
  * We use the standard libext2fs portability tricks for inline
  * functions.  
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 22e79a5..43bc5e5 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -1,6 +1,6 @@
 /*
- * linux/fs/recovery.c
- * 
+ * linux/fs/jbd/recovery.c
+ *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
  * Copyright 1999-2000 Red Hat Software --- All Rights Reserved
@@ -10,7 +10,7 @@
  * option, any later version, incorporated herein by reference.
  *
  * Journal recovery routines for the generic filesystem journaling code;
- * part of the ext2fs journaling system.  
+ * part of the ext2fs journaling system.
  */
 
 #ifndef __KERNEL__
@@ -25,13 +25,13 @@
 
 /*
  * Maintain information about the progress of the recovery job, so that
- * the different passes can carry information between them. 
+ * the different passes can carry information between them.
  */
-struct recovery_info 
+struct recovery_info
 {
-	tid_t		start_transaction;	
+	tid_t		start_transaction;
 	tid_t		end_transaction;
-	
+
 	int		nr_replays;
 	int		nr_revokes;
 	int		nr_revoke_hits;
@@ -46,7 +46,7 @@ static int scan_revoke_records(journal_t *, struct buffer_head *,
 #ifdef __KERNEL__
 
 /* Release readahead buffers after use */
-void journal_brelse_array(struct buffer_head *b[], int n)
+static void journal_brelse_array(struct buffer_head *b[], int n)
 {
 	while (--n >= 0)
 		brelse (b[n]);
@@ -72,9 +72,9 @@ static int do_readahead(journal_t *journal, unsigned int start)
 	unsigned int max, nbufs, next;
 	unsigned long blocknr;
 	struct buffer_head *bh;
-	
+
 	struct buffer_head * bufs[MAXBUF];
-	
+
 	/* Do up to 128K of readahead */
 	max = start + (128 * 1024 / journal->j_blocksize);
 	if (max > journal->j_maxlen)
@@ -82,9 +82,9 @@ static int do_readahead(journal_t *journal, unsigned int start)
 
 	/* Do the readahead itself.  We'll submit MAXBUF buffer_heads at
 	 * a time to the block device IO layer. */
-	
+
 	nbufs = 0;
-	
+
 	for (next = start; next < max; next++) {
 		err = journal_bmap(journal, next, &blocknr);
 
@@ -115,8 +115,8 @@ static int do_readahead(journal_t *journal, unsigned int start)
 		ll_rw_block(READ, nbufs, bufs);
 	err = 0;
 
-failed:	
-	if (nbufs) 
+failed:
+	if (nbufs)
 		journal_brelse_array(bufs, nbufs);
 	return err;
 }
@@ -128,7 +128,7 @@ failed:
  * Read a block from the journal
  */
 
-static int jread(struct buffer_head **bhp, journal_t *journal, 
+static int jread(struct buffer_head **bhp, journal_t *journal,
 		 unsigned int offset)
 {
 	int err;
@@ -137,8 +137,11 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 
 	*bhp = NULL;
 
-	J_ASSERT (offset < journal->j_maxlen);
-	
+	if (offset >= journal->j_maxlen) {
+		printk(KERN_ERR "JBD: corrupted journal superblock\n");
+		return -EIO;
+	}
+
 	err = journal_bmap(journal, offset, &blocknr);
 
 	if (err) {
@@ -188,10 +191,10 @@ static int count_tags(struct buffer_head *bh, int size)
 
 		nr++;
 		tagp += sizeof(journal_block_tag_t);
-		if (!(tag->t_flags & htonl(JFS_FLAG_SAME_UUID)))
+		if (!(tag->t_flags & cpu_to_be32(JFS_FLAG_SAME_UUID)))
 			tagp += 16;
 
-		if (tag->t_flags & htonl(JFS_FLAG_LAST_TAG))
+		if (tag->t_flags & cpu_to_be32(JFS_FLAG_LAST_TAG))
 			break;
 	}
 
@@ -207,16 +210,16 @@ do {									\
 } while (0)
 
 /**
- * int journal_recover(journal_t *journal) - recovers a on-disk journal
+ * journal_recover - recovers a on-disk journal
  * @journal: the journal to recover
  *
  * The primary function for recovering the log contents when mounting a
- * journaled device.  
- * 
+ * journaled device.
+ *
  * Recovery is done in three passes.  In the first pass, we look for the
  * end of the log.  In the second, we assemble the list of revoke
  * blocks.  In the third and final pass, we replay any un-revoked blocks
- * in the log.  
+ * in the log.
  */
 int journal_recover(journal_t *journal)
 {
@@ -224,56 +227,56 @@ int journal_recover(journal_t *journal)
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
-	
+
 	memset(&info, 0, sizeof(info));
 	sb = journal->j_superblock;
-	
-	/* 
+
+	/*
 	 * The journal superblock's s_start field (the current log head)
 	 * is always zero if, and only if, the journal was cleanly
-	 * unmounted.  
+	 * unmounted.
 	 */
 
 	if (!sb->s_start) {
 		jbd_debug(1, "No recovery required, last transaction %d\n",
-			  (int)ntohl(sb->s_sequence));
-		journal->j_transaction_sequence = ntohl(sb->s_sequence) + 1;
+			  be32_to_cpu(sb->s_sequence));
+		journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
 		return 0;
 	}
-	
+
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REPLAY);
 
-	jbd_debug(0, "JBD: recovery, exit status %d, "
+	jbd_debug(1, "JBD: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
 		  err, info.start_transaction, info.end_transaction);
-	jbd_debug(0, "JBD: Replayed %d and revoked %d/%d blocks\n", 
+	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
 	/* Restart the log at the next transaction ID, thus invalidating
 	 * any existing commit records in the log. */
 	journal->j_transaction_sequence = ++info.end_transaction;
-		
+
 	journal_clear_revoke(journal);
 	sync_blockdev(journal->j_fs_dev);
 	return err;
 }
 
 /**
- * int journal_skip_recovery() - Start journal and wipe exiting records
+ * journal_skip_recovery - Start journal and wipe exiting records
  * @journal: journal to startup
  *
  * Locate any valid recovery information from the journal and set up the
  * journal structures in memory to ignore it (presumably because the
- * caller has evidence that it is out of date).  
+ * caller has evidence that it is out of date).
  * This function does'nt appear to be exorted..
  *
  * We perform one pass over the journal to allow us to tell the user how
  * much recovery information is being erased, and to let us initialise
- * the journal transaction sequence numbers to the next unused ID. 
+ * the journal transaction sequence numbers to the next unused ID.
  */
 int journal_skip_recovery(journal_t *journal)
 {
@@ -281,10 +284,10 @@ int journal_skip_recovery(journal_t *journal)
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
-	
+
 	memset (&info, 0, sizeof(info));
 	sb = journal->j_superblock;
-	
+
 	err = do_one_pass(journal, &info, PASS_SCAN);
 
 	if (err) {
@@ -292,9 +295,9 @@ int journal_skip_recovery(journal_t *journal)
 		++journal->j_transaction_sequence;
 	} else {
 #ifdef CONFIG_JBD_DEBUG
-		int dropped = info.end_transaction - ntohl(sb->s_sequence);
+		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
 #endif
-		jbd_debug(0, 
+		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
 		journal->j_transaction_sequence = ++info.end_transaction;
@@ -311,25 +314,25 @@ static int do_one_pass(journal_t *journal,
 	unsigned long		next_log_block;
 	int			err, success = 0;
 	journal_superblock_t *	sb;
-	journal_header_t * 	tmp;
+	journal_header_t *	tmp;
 	struct buffer_head *	bh;
 	unsigned int		sequence;
 	int			blocktype;
-	
+
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
 	MAX_BLOCKS_PER_DESC = ((journal->j_blocksize-sizeof(journal_header_t))
 			       / sizeof(journal_block_tag_t));
 
-	/* 
+	/*
 	 * First thing is to establish what we expect to find in the log
 	 * (in terms of transaction IDs), and where (in terms of log
-	 * block offsets): query the superblock.  
+	 * block offsets): query the superblock.
 	 */
 
 	sb = journal->j_superblock;
-	next_commit_ID = ntohl(sb->s_sequence);
-	next_log_block = ntohl(sb->s_start);
+	next_commit_ID = be32_to_cpu(sb->s_sequence);
+	next_log_block = be32_to_cpu(sb->s_start);
 
 	first_commit_ID = next_commit_ID;
 	if (pass == PASS_SCAN)
@@ -341,7 +344,7 @@ static int do_one_pass(journal_t *journal,
 	 * Now we walk through the log, transaction by transaction,
 	 * making sure that each transaction has a commit block in the
 	 * expected place.  Each complete transaction gets replayed back
-	 * into the main filesystem. 
+	 * into the main filesystem.
 	 */
 
 	while (1) {
@@ -350,11 +353,13 @@ static int do_one_pass(journal_t *journal,
 		journal_block_tag_t *	tag;
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
-		
+
+		cond_resched();
+
 		/* If we already know where to stop the log traversal,
 		 * check right now that we haven't gone past the end of
 		 * the log. */
-		
+
 		if (pass != PASS_SCAN)
 			if (tid_geq(next_commit_ID, info->end_transaction))
 				break;
@@ -365,7 +370,7 @@ static int do_one_pass(journal_t *journal,
 		/* Skip over each chunk of the transaction looking
 		 * either the next descriptor block or the final commit
 		 * record. */
-		
+
 		jbd_debug(3, "JBD: checking block %ld\n", next_log_block);
 		err = jread(&bh, journal, next_log_block);
 		if (err)
@@ -373,30 +378,30 @@ static int do_one_pass(journal_t *journal,
 
 		next_log_block++;
 		wrap(journal, next_log_block);
-		
-		/* What kind of buffer is it? 
-		 * 
+
+		/* What kind of buffer is it?
+		 *
 		 * If it is a descriptor block, check that it has the
 		 * expected sequence number.  Otherwise, we're all done
 		 * here. */
 
 		tmp = (journal_header_t *)bh->b_data;
-		
-		if (tmp->h_magic != htonl(JFS_MAGIC_NUMBER)) {
+
+		if (tmp->h_magic != cpu_to_be32(JFS_MAGIC_NUMBER)) {
 			brelse(bh);
 			break;
 		}
 
-		blocktype = ntohl(tmp->h_blocktype);
-		sequence = ntohl(tmp->h_sequence);
-		jbd_debug(3, "Found magic %d, sequence %d\n", 
+		blocktype = be32_to_cpu(tmp->h_blocktype);
+		sequence = be32_to_cpu(tmp->h_sequence);
+		jbd_debug(3, "Found magic %d, sequence %d\n",
 			  blocktype, sequence);
-		
+
 		if (sequence != next_commit_ID) {
 			brelse(bh);
 			break;
 		}
-		
+
 		/* OK, we have a valid descriptor block which matches
 		 * all of the sequence number checks.  What are we going
 		 * to do with it?  That depends on the pass... */
@@ -424,8 +429,8 @@ static int do_one_pass(journal_t *journal,
 				unsigned long io_block;
 
 				tag = (journal_block_tag_t *) tagp;
-				flags = ntohl(tag->t_flags);
-				
+				flags = be32_to_cpu(tag->t_flags);
+
 				io_block = next_log_block++;
 				wrap(journal, next_log_block);
 				err = jread(&obh, journal, io_block);
@@ -433,34 +438,34 @@ static int do_one_pass(journal_t *journal,
 					/* Recover what we can, but
 					 * report failure at the end. */
 					success = err;
-					printk (KERN_ERR 
+					printk (KERN_ERR
 						"JBD: IO error %d recovering "
-						"block %lu in log\n",
+						"block %ld in log\n",
 						err, io_block);
 				} else {
 					unsigned long blocknr;
-					
+
 					J_ASSERT(obh != NULL);
-					blocknr = ntohl(tag->t_blocknr);
+					blocknr = be32_to_cpu(tag->t_blocknr);
 
 					/* If the block has been
 					 * revoked, then we're all done
 					 * here. */
 					if (journal_test_revoke
-					    (journal, blocknr, 
+					    (journal, blocknr,
 					     next_commit_ID)) {
 						brelse(obh);
 						++info->nr_revoke_hits;
 						goto skip_write;
 					}
-								
+
 					/* Find a buffer for the new
 					 * data being restored */
-					nbh = __getblk(journal->j_fs_dev, 
-						       blocknr,
-						     journal->j_blocksize);
+					nbh = __getblk(journal->j_fs_dev,
+							blocknr,
+							journal->j_blocksize);
 					if (nbh == NULL) {
-						printk(KERN_ERR 
+						printk(KERN_ERR
 						       "JBD: Out of memory "
 						       "during recovery.\n");
 						err = -ENOMEM;
@@ -473,8 +478,8 @@ static int do_one_pass(journal_t *journal,
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						*((unsigned int *)bh->b_data) =
-							htonl(JFS_MAGIC_NUMBER);
+						*((__be32 *)nbh->b_data) =
+						cpu_to_be32(JFS_MAGIC_NUMBER);
 					}
 
 					BUFFER_TRACE(nbh, "marking dirty");
@@ -487,7 +492,7 @@ static int do_one_pass(journal_t *journal,
 					brelse(obh);
 					brelse(nbh);
 				}
-				
+
 			skip_write:
 				tagp += sizeof(journal_block_tag_t);
 				if (!(flags & JFS_FLAG_SAME_UUID))
@@ -496,7 +501,7 @@ static int do_one_pass(journal_t *journal,
 				if (flags & JFS_FLAG_LAST_TAG)
 					break;
 			}
-			
+
 			brelse(bh);
 			continue;
 
@@ -532,13 +537,13 @@ static int do_one_pass(journal_t *journal,
 	}
 
  done:
-	/* 
+	/*
 	 * We broke out of the log scan loop: either we came to the
 	 * known end of the log or we found an unexpected block in the
 	 * log.  If the latter happened, then we know that the "current"
 	 * transaction marks the end of the valid log.
 	 */
-	
+
 	if (pass == PASS_SCAN)
 		info->end_transaction = next_commit_ID;
 	else {
@@ -562,7 +567,7 @@ static int do_one_pass(journal_t *journal,
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
-static int scan_revoke_records(journal_t *journal, struct buffer_head *bh, 
+static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 			       tid_t sequence, struct recovery_info *info)
 {
 	journal_revoke_header_t *header;
@@ -570,13 +575,13 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 
 	header = (journal_revoke_header_t *) bh->b_data;
 	offset = sizeof(journal_revoke_header_t);
-	max = ntohl(header->r_count);
-	
+	max = be32_to_cpu(header->r_count);
+
 	while (offset < max) {
 		unsigned long blocknr;
 		int err;
-		
-		blocknr = ntohl(* ((unsigned int *) (bh->b_data+offset)));
+
+		blocknr = be32_to_cpu(* ((__be32 *) (bh->b_data+offset)));
 		offset += 4;
 		err = journal_set_revoke(journal, blocknr, sequence);
 		if (err)
-- 
1.5.4.1.144.gdfee-dirty


