From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/27] e2fsck: resync jbd2 recovery code from Linux 3.16
Date: Sat, 16 Aug 2014 16:46:42 -0700
Message-ID: <20140816234642.11171.76498.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43425 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaHPXqr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:47 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Synchronize e2fsck's copy of recovery.c with the kernel's copy in
fs/jbd2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/jfs_user.h       |    2 
 e2fsck/journal.c        |    8 +-
 e2fsck/recovery.c       |  209 +++++++++++++++++++++--------------------------
 lib/ext2fs/jfs_compat.h |   18 ++++
 4 files changed, 120 insertions(+), 117 deletions(-)


diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 3cccd3f..799c6da 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -123,7 +123,7 @@ _INLINE_ void do_cache_destroy(lkmem_cache_t *cache)
  */
 int journal_bmap(journal_t *journal, blk64_t block, unsigned long long *phys);
 struct buffer_head *getblk(kdev_t ctx, blk64_t blocknr, int blocksize);
-void sync_blockdev(kdev_t kdev);
+int sync_blockdev(kdev_t kdev);
 void ll_rw_block(int rw, int dummy, struct buffer_head *bh[]);
 void mark_buffer_dirty(struct buffer_head *bh);
 void mark_buffer_uptodate(struct buffer_head *bh, int val);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 206685a..533b1d6 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -144,7 +144,7 @@ struct buffer_head *getblk(kdev_t kdev, blk64_t blocknr, int blocksize)
 	return bh;
 }
 
-void sync_blockdev(kdev_t kdev)
+int sync_blockdev(kdev_t kdev)
 {
 	io_channel	io;
 
@@ -153,7 +153,7 @@ void sync_blockdev(kdev_t kdev)
 	else
 		io = kdev->k_ctx->journal_io;
 
-	io_channel_flush(io);
+	return io_channel_flush(io) ? EIO : 0;
 }
 
 void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
@@ -632,6 +632,10 @@ static errcode_t e2fsck_journal_load(journal_t *journal)
 	    !e2fsck_journal_sb_csum_verify(journal, jsb))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		journal->j_csum_seed = jbd2_chksum(journal, ~0, jsb->s_uuid,
+						   sizeof(jsb->s_uuid));
+
 	/* We have now checked whether we know enough about the journal
 	 * format to be able to proceed safely, so any other checks that
 	 * fail we should attempt to recover from. */
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 66d02b2..e4c7519 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/jbd/recovery.c
+ * linux/fs/jbd2/recovery.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
@@ -14,14 +14,14 @@
  */
 
 #ifndef __KERNEL__
-#include "config.h"
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
 #include <linux/fs.h>
-#include <linux/jbd.h>
+#include <linux/jbd2.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
+#include <linux/crc32.h>
+#include <linux/blkdev.h>
 #endif
 
 /*
@@ -90,7 +90,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 		err = journal_bmap(journal, next, &blocknr);
 
 		if (err) {
-			printk (KERN_ERR "JBD: bad block at offset %u\n",
+			printk(KERN_ERR "JBD2: bad block at offset %u\n",
 				next);
 			goto failed;
 		}
@@ -139,14 +139,14 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 	*bhp = NULL;
 
 	if (offset >= journal->j_maxlen) {
-		printk(KERN_ERR "JBD: corrupted journal superblock\n");
+		printk(KERN_ERR "JBD2: corrupted journal superblock\n");
 		return -EIO;
 	}
 
 	err = journal_bmap(journal, offset, &blocknr);
 
 	if (err) {
-		printk (KERN_ERR "JBD: bad block at offset %u\n",
+		printk(KERN_ERR "JBD2: bad block at offset %u\n",
 			offset);
 		return err;
 	}
@@ -164,7 +164,7 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 	}
 
 	if (!buffer_uptodate(bh)) {
-		printk (KERN_ERR "JBD: Failed to read block at offset %u\n",
+		printk(KERN_ERR "JBD2: Failed to read block at offset %u\n",
 			offset);
 		brelse(bh);
 		return -EIO;
@@ -178,22 +178,20 @@ static int jbd2_descr_block_csum_verify(journal_t *j,
 					void *buf)
 {
 	struct journal_block_tail *tail;
-	__u32 provided, calculated;
+	__u32 provided;
+	__u32 calculated;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
-	tail = (struct journal_block_tail *)((char *)buf + j->j_blocksize -
+	tail = (struct journal_block_tail *)(buf + j->j_blocksize -
 			sizeof(struct journal_block_tail));
 	provided = tail->t_checksum;
 	tail->t_checksum = 0;
-	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
-				      sizeof(j->j_superblock->s_uuid));
-	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
 	tail->t_checksum = provided;
 
-	provided = ext2fs_be32_to_cpu(provided);
-	return provided == calculated;
+	return provided == ext2fs_cpu_to_be32(calculated);
 }
 
 /*
@@ -217,10 +215,10 @@ static int count_tags(journal_t *journal, struct buffer_head *bh)
 
 		nr++;
 		tagp += tag_bytes;
-		if (!(tag->t_flags & cpu_to_be16(JFS_FLAG_SAME_UUID)))
+		if (!(tag->t_flags & ext2fs_cpu_to_be16(JFS_FLAG_SAME_UUID)))
 			tagp += 16;
 
-		if (tag->t_flags & cpu_to_be16(JFS_FLAG_LAST_TAG))
+		if (tag->t_flags & ext2fs_cpu_to_be16(JFS_FLAG_LAST_TAG))
 			break;
 	}
 
@@ -249,7 +247,7 @@ do {									\
  */
 int journal_recover(journal_t *journal)
 {
-	int			err;
+	int			err, err2;
 	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
@@ -265,8 +263,8 @@ int journal_recover(journal_t *journal)
 
 	if (!sb->s_start) {
 		jbd_debug(1, "No recovery required, last transaction %d\n",
-			  be32_to_cpu(sb->s_sequence));
-		journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
+			  ext2fs_be32_to_cpu(sb->s_sequence));
+		journal->j_transaction_sequence = ext2fs_be32_to_cpu(sb->s_sequence) + 1;
 		return 0;
 	}
 
@@ -276,10 +274,10 @@ int journal_recover(journal_t *journal)
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REPLAY);
 
-	jbd_debug(1, "JBD: recovery, exit status %d, "
+	jbd_debug(1, "JBD2: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
 		  err, info.start_transaction, info.end_transaction);
-	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
+	jbd_debug(1, "JBD2: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
 	/* Restart the log at the next transaction ID, thus invalidating
@@ -287,7 +285,15 @@ int journal_recover(journal_t *journal)
 	journal->j_transaction_sequence = ++info.end_transaction;
 
 	journal_clear_revoke(journal);
-	sync_blockdev(journal->j_fs_dev);
+	err2 = sync_blockdev(journal->j_fs_dev);
+	if (!err)
+		err = err2;
+	/* Make sure all replayed data is on permanent storage */
+	if (journal->j_flags & JFS_BARRIER) {
+		err2 = blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		if (!err)
+			err = err2;
+	}
 	return err;
 }
 
@@ -307,6 +313,7 @@ int journal_recover(journal_t *journal)
 int journal_skip_recovery(journal_t *journal)
 {
 	int			err;
+
 	struct recovery_info	info;
 
 	memset (&info, 0, sizeof(info));
@@ -314,17 +321,16 @@ int journal_skip_recovery(journal_t *journal)
 	err = do_one_pass(journal, &info, PASS_SCAN);
 
 	if (err) {
-		printk(KERN_ERR "JBD: error %d scanning journal\n", err);
+		printk(KERN_ERR "JBD2: error %d scanning journal\n", err);
 		++journal->j_transaction_sequence;
 	} else {
-#ifdef CONFIG_JBD_DEBUG
-		journal_superblock_t *sb = journal->j_superblock;
-
-		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
-#endif
+#ifdef CONFIG_JFS_DEBUG
+		int dropped = info.end_transaction - 
+			ext2fs_be32_to_cpu(journal->j_superblock->s_sequence);
 		jbd_debug(1,
-			  "JBD: ignoring %d transaction%s from the journal.\n",
+			  "JBD2: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
+#endif
 		journal->j_transaction_sequence = ++info.end_transaction;
 	}
 
@@ -334,9 +340,9 @@ int journal_skip_recovery(journal_t *journal)
 
 static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag_t *tag)
 {
-	unsigned long long block = be32_to_cpu(tag->t_blocknr);
-	if (tag_bytes > JBD_TAG_SIZE32)
-		block |= (__u64)be32_to_cpu(tag->t_blocknr_high) << 32;
+	unsigned long long block = ext2fs_be32_to_cpu(tag->t_blocknr);
+	if (tag_bytes > JFS_TAG_SIZE32)
+		block |= (u64)ext2fs_be32_to_cpu(tag->t_blocknr_high) << 32;
 	return block;
 }
 
@@ -345,31 +351,29 @@ static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag
  * descriptor block.
  */
 static int calc_chksums(journal_t *journal, struct buffer_head *bh,
-			unsigned long long *next_log_block, __u32 *crc32_sum)
+			unsigned long *next_log_block, __u32 *crc32_sum)
 {
 	int i, num_blks, err;
-	unsigned long long io_block;
+	unsigned long io_block;
 	struct buffer_head *obh;
 
 	num_blks = count_tags(journal, bh);
 	/* Calculate checksum of the descriptor block. */
-	*crc32_sum = ext2fs_crc32_be(*crc32_sum, (void *)bh->b_data,
-				     bh->b_size);
+	*crc32_sum = crc32_be(*crc32_sum, (void *)bh->b_data, bh->b_size);
 
 	for (i = 0; i < num_blks; i++) {
 		io_block = (*next_log_block)++;
 		wrap(journal, *next_log_block);
 		err = jread(&obh, journal, io_block);
 		if (err) {
-			printk(KERN_ERR "JBD: IO error %d recovering block "
-				"%llu in log\n", err, io_block);
+			printk(KERN_ERR "JBD2: IO error %d recovering block "
+				"%lu in log\n", err, io_block);
 			return 1;
 		} else {
-			*crc32_sum = ext2fs_crc32_be(*crc32_sum,
-						     (void *)obh->b_data,
-						     obh->b_size);
+			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
+				     obh->b_size);
 		}
-		brelse(obh);
+		put_bh(obh);
 	}
 	return 0;
 }
@@ -377,7 +381,8 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 {
 	struct commit_header *h;
-	__u32 provided, calculated;
+	__u32 provided;
+	__u32 calculated;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -385,41 +390,33 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 	h = buf;
 	provided = h->h_chksum[0];
 	h->h_chksum[0] = 0;
-	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
-				      sizeof(j->j_superblock->s_uuid));
-	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
 	h->h_chksum[0] = provided;
 
-	provided = ext2fs_be32_to_cpu(provided);
-	return provided == calculated;
+	return provided == ext2fs_cpu_to_be32(calculated);
 }
 
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 				      void *buf, __u32 sequence)
 {
-	__u32 calculated;
-	__u16 provided, crc;
+	__u32 csum32;
+	__u32 seq;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
-	sequence = ext2fs_cpu_to_be32(sequence);
-	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
-				      sizeof(j->j_superblock->s_uuid));
-	calculated = ext2fs_crc32c_le(calculated, (__u8 *)&sequence,
-				      sizeof(sequence));
-	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize) & 0xffff;
-	crc = calculated & 0xFFFF;
-	provided = ext2fs_be16_to_cpu(tag->t_checksum);
+	seq = ext2fs_cpu_to_be32(sequence);
+	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
+	csum32 = jbd2_chksum(j, csum32, buf, j->j_blocksize);
 
-	return provided == crc;
+	return tag->t_checksum == ext2fs_cpu_to_be16(csum32);
 }
 
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
 	unsigned int		first_commit_ID, next_commit_ID;
-	unsigned long long	next_log_block;
+	unsigned long		next_log_block;
 	int			err, success = 0;
 	journal_superblock_t *	sb;
 	journal_header_t *	tmp;
@@ -437,8 +434,8 @@ static int do_one_pass(journal_t *journal,
 	 */
 
 	sb = journal->j_superblock;
-	next_commit_ID = be32_to_cpu(sb->s_sequence);
-	next_log_block = be32_to_cpu(sb->s_start);
+	next_commit_ID = ext2fs_be32_to_cpu(sb->s_sequence);
+	next_log_block = ext2fs_be32_to_cpu(sb->s_start);
 
 	first_commit_ID = next_commit_ID;
 	if (pass == PASS_SCAN)
@@ -470,14 +467,14 @@ static int do_one_pass(journal_t *journal,
 			if (tid_geq(next_commit_ID, info->end_transaction))
 				break;
 
-		jbd_debug(2, "Scanning for sequence ID %u at %llu/%lu\n",
+		jbd_debug(2, "Scanning for sequence ID %u at %lu/%lu\n",
 			  next_commit_ID, next_log_block, journal->j_last);
 
 		/* Skip over each chunk of the transaction looking
 		 * either the next descriptor block or the final commit
 		 * record. */
 
-		jbd_debug(3, "JBD: checking block %llu\n", next_log_block);
+		jbd_debug(3, "JBD2: checking block %ld\n", next_log_block);
 		err = jread(&bh, journal, next_log_block);
 		if (err)
 			goto failed;
@@ -493,13 +490,13 @@ static int do_one_pass(journal_t *journal,
 
 		tmp = (journal_header_t *)bh->b_data;
 
-		if (tmp->h_magic != cpu_to_be32(JFS_MAGIC_NUMBER)) {
+		if (tmp->h_magic != ext2fs_cpu_to_be32(JFS_MAGIC_NUMBER)) {
 			brelse(bh);
 			break;
 		}
 
-		blocktype = be32_to_cpu(tmp->h_blocktype);
-		sequence = be32_to_cpu(tmp->h_sequence);
+		blocktype = ext2fs_be32_to_cpu(tmp->h_blocktype);
+		sequence = ext2fs_be32_to_cpu(tmp->h_sequence);
 		jbd_debug(3, "Found magic %d, sequence %d\n",
 			  blocktype, sequence);
 
@@ -523,7 +520,6 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
-				brelse(bh);
 				goto failed;
 			}
 
@@ -539,15 +535,15 @@ static int do_one_pass(journal_t *journal,
 					if (calc_chksums(journal, bh,
 							&next_log_block,
 							&crc32_sum)) {
-						brelse(bh);
+						put_bh(bh);
 						break;
 					}
-					brelse(bh);
+					put_bh(bh);
 					continue;
 				}
 				next_log_block += count_tags(journal, bh);
 				wrap(journal, next_log_block);
-				brelse(bh);
+				put_bh(bh);
 				continue;
 			}
 
@@ -558,10 +554,10 @@ static int do_one_pass(journal_t *journal,
 			tagp = &bh->b_data[sizeof(journal_header_t)];
 			while ((tagp - bh->b_data + tag_bytes)
 			       <= journal->j_blocksize - descr_csum_size) {
-				unsigned long long io_block;
+				unsigned long io_block;
 
 				tag = (journal_block_tag_t *) tagp;
-				flags = be16_to_cpu(tag->t_flags);
+				flags = ext2fs_be16_to_cpu(tag->t_flags);
 
 				io_block = next_log_block++;
 				wrap(journal, next_log_block);
@@ -570,9 +566,9 @@ static int do_one_pass(journal_t *journal,
 					/* Recover what we can, but
 					 * report failure at the end. */
 					success = err;
-					printk (KERN_ERR
-						"JBD: IO error %d recovering "
-						"block %llu in log\n",
+					printk(KERN_ERR
+						"JBD2: IO error %d recovering "
+						"block %ld in log\n",
 						err, io_block);
 				} else {
 					unsigned long long blocknr;
@@ -595,12 +591,12 @@ static int do_one_pass(journal_t *journal,
 					/* Look for block corruption */
 					if (!jbd2_block_tag_csum_verify(
 						journal, tag, obh->b_data,
-						be32_to_cpu(tmp->h_sequence))) {
+						ext2fs_be32_to_cpu(tmp->h_sequence))) {
 						brelse(obh);
 						success = -EIO;
-						printk(KERN_ERR "JBD: Invalid "
+						printk(KERN_ERR "JBD2: Invalid "
 						       "checksum recovering "
-						       "block %lld in log\n",
+						       "block %llu in log\n",
 						       blocknr);
 						continue;
 					}
@@ -612,7 +608,7 @@ static int do_one_pass(journal_t *journal,
 							journal->j_blocksize);
 					if (nbh == NULL) {
 						printk(KERN_ERR
-						       "JBD: Out of memory "
+						       "JBD2: Out of memory "
 						       "during recovery.\n");
 						err = -ENOMEM;
 						brelse(bh);
@@ -624,10 +620,8 @@ static int do_one_pass(journal_t *journal,
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						journal_header_t *header;
-
-						header = (journal_header_t *) &nbh->b_data[0];
-						header->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
+						*((__u32 *)nbh->b_data) =
+						ext2fs_cpu_to_be32(JFS_MAGIC_NUMBER);
 					}
 
 					BUFFER_TRACE(nbh, "marking dirty");
@@ -654,8 +648,6 @@ static int do_one_pass(journal_t *journal,
 			continue;
 
 		case JFS_COMMIT_BLOCK:
-			jbd_debug(3, "Commit block for #%u found\n",
-				  next_commit_ID);
 			/*     How to differentiate between interrupted commit
 			 *               and journal corruption ?
 			 *
@@ -698,12 +690,10 @@ static int do_one_pass(journal_t *journal,
 				struct commit_header *cbh =
 					(struct commit_header *)bh->b_data;
 				unsigned found_chksum =
-					be32_to_cpu(cbh->h_chksum[0]);
+					ext2fs_be32_to_cpu(cbh->h_chksum[0]);
 
 				chksum_err = chksum_seen = 0;
 
-				jbd_debug(3, "Checksums %x %x\n",
-					  crc32_sum, found_chksum);
 				if (info->end_transaction) {
 					journal->j_failed_commit =
 						info->end_transaction;
@@ -712,9 +702,9 @@ static int do_one_pass(journal_t *journal,
 				}
 
 				if (crc32_sum == found_chksum &&
-				    cbh->h_chksum_type == JBD2_CRC32_CHKSUM &&
+				    cbh->h_chksum_type == JFS_CRC32_CHKSUM &&
 				    cbh->h_chksum_size ==
-						JBD2_CRC32_CHKSUM_SIZE)
+						JFS_CRC32_CHKSUM_SIZE)
 				       chksum_seen = 1;
 				else if (!(cbh->h_chksum_type == 0 &&
 					     cbh->h_chksum_size == 0 &&
@@ -734,8 +724,7 @@ static int do_one_pass(journal_t *journal,
 
 				if (chksum_err) {
 					info->end_transaction = next_commit_ID;
-					jbd_debug(1, "Checksum_err %x %x\n",
-						  crc32_sum, found_chksum);
+
 					if (!JFS_HAS_INCOMPAT_FEATURE(journal,
 					   JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)){
 						journal->j_failed_commit =
@@ -801,7 +790,7 @@ static int do_one_pass(journal_t *journal,
 		/* It's really bad news if different passes end up at
 		 * different places (but possible due to IO errors). */
 		if (info->end_transaction != next_commit_ID) {
-			printk (KERN_ERR "JBD: recovery pass %d ended at "
+			printk(KERN_ERR "JBD2: recovery pass %d ended at "
 				"transaction %u, expected %u\n",
 				pass, next_commit_ID, info->end_transaction);
 			if (!success)
@@ -819,22 +808,20 @@ static int jbd2_revoke_block_csum_verify(journal_t *j,
 					 void *buf)
 {
 	struct journal_revoke_tail *tail;
-	__u32 provided, calculated;
+	__u32 provided;
+	__u32 calculated;
 
 	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
 
-	tail = (struct journal_revoke_tail *)((char *)buf + j->j_blocksize -
+	tail = (struct journal_revoke_tail *)(buf + j->j_blocksize -
 			sizeof(struct journal_revoke_tail));
 	provided = tail->r_checksum;
 	tail->r_checksum = 0;
-	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
-				      sizeof(j->j_superblock->s_uuid));
-	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
 	tail->r_checksum = provided;
 
-	provided = ext2fs_be32_to_cpu(provided);
-	return provided == calculated;
+	return provided == ext2fs_cpu_to_be32(calculated);
 }
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
@@ -848,7 +835,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 
 	header = (journal_revoke_header_t *) bh->b_data;
 	offset = sizeof(journal_revoke_header_t);
-	max = be32_to_cpu(header->r_count);
+	max = ext2fs_be32_to_cpu(header->r_count);
 
 	if (!jbd2_revoke_block_csum_verify(journal, header))
 		return -EINVAL;
@@ -856,20 +843,14 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 
-	while (offset < max) {
+	while (offset + record_len <= max) {
 		unsigned long long blocknr;
 		int err;
 
-		if (record_len == 4) {
-			__be32 b;
-			memcpy(&b, bh->b_data + offset, sizeof(__be32));
-			blocknr = ext2fs_be32_to_cpu(b);
-		} else {
-			__be64 b;
-			memcpy(&b, bh->b_data + offset, sizeof(__be64));
-			blocknr = ext2fs_be64_to_cpu(b);
-		}
-
+		if (record_len == 4)
+			blocknr = ext2fs_be32_to_cpu(* ((__u32 *) (bh->b_data+offset)));
+		else
+			blocknr = ext2fs_be64_to_cpu(* ((__u64 *) (bh->b_data+offset)));
 		offset += record_len;
 		err = journal_set_revoke(journal, blocknr, sequence);
 		if (err)
diff --git a/lib/ext2fs/jfs_compat.h b/lib/ext2fs/jfs_compat.h
index 7947ef5..2638c31 100644
--- a/lib/ext2fs/jfs_compat.h
+++ b/lib/ext2fs/jfs_compat.h
@@ -7,6 +7,7 @@
 #ifdef HAVE_NETINET_IN_H
 #include <netinet/in.h>
 #endif
+#include <arpa/inet.h>
 
 #define printk printf
 #define KERN_ERR ""
@@ -26,6 +27,22 @@ typedef struct journal_s journal_t;
 struct buffer_head;
 struct inode;
 
+#define GFP_KERNEL	0
+#define JFS_TAG_SIZE32	JBD_TAG_SIZE32
+#define JFS_BARRIER	0
+typedef __u64 u64;
+#define JFS_CRC32_CHKSUM	JBD2_CRC32_CHKSUM
+#define JFS_CRC32_CHKSUM_SIZE	JBD2_CRC32_CHKSUM_SIZE
+#define put_bh(x)	brelse(x)
+#define be64_to_cpu(x)	ext2fs_be64_to_cpu(x)
+
+static inline __u32 jbd2_chksum(journal_t *j, __u32 crc, const void *address,
+			unsigned int length)
+{
+	return ext2fs_crc32c_le(crc, address, length);
+}
+#define crc32_be(x, y, z)	ext2fs_crc32_be((x), (y), (z))
+
 struct journal_s
 {
 	unsigned long		j_flags;
@@ -48,6 +65,7 @@ struct journal_s
 	__u8			j_uuid[16];
 	struct jbd_revoke_table_s *j_revoke;
 	tid_t			j_failed_commit;
+	__u32			j_csum_seed;
 };
 
 #define J_ASSERT(assert)						\

