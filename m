From: Jody McIntyre <scjody@sun.com>
Subject: [e2fsprogs] Implement resync of declared blocks for software RAID
Date: Tue, 08 Dec 2009 13:30:48 -0500
Message-ID: <20091208183046.GH4508@clouds>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51396 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZLHSar (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 13:30:47 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB8IUsAO008709
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 10:30:54 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUC00M00J8EF600@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 08 Dec 2009 10:30:54 -0800 (PST)
Received: from shinkansen.modernduck.com ([unknown] [96.21.225.78])
 by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 with ESMTPSA id <0KUC00FZWJFCP9A0@fe-sfbay-09.sun.com> for
 linux-ext4@vger.kernel.org; Tue, 08 Dec 2009 10:30:50 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch resyncs declared blocks on journal recovery.  This must be done
as part of journal replay for filesystems with
JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS; we have previously guaranteed to MD
that we will resync any blocks that may have been undergoing writes at
the time of a system crash.

The SET_RESYNC_ALL and CLEAR_RESYNC_ALL ioctls are used to instruct MD
to resync all blocks being read and written.

This patch is UNTESTED and is being sent only because I am no longer
working on declared mode.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: e2fsprogs-1.41.6/e2fsck/recovery.c
===================================================================
--- e2fsprogs-1.41.6.orig/e2fsck/recovery.c
+++ e2fsprogs-1.41.6/e2fsck/recovery.c
@@ -15,12 +15,16 @@
 
 #ifndef __KERNEL__
 #include "jfs_user.h"
+#include <sys/ioctl.h>
+#define MD_MAJOR 9
+#include "md_u.h"
 #else
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/raid/md.h>
 #endif
 
 /*
@@ -35,6 +39,7 @@ struct recovery_info
 	int		nr_replays;
 	int		nr_revokes;
 	int		nr_revoke_hits;
+	int		nr_declared;
 };
 
 enum passtype {PASS_SCAN, PASS_REVOKE, PASS_REPLAY};
@@ -42,6 +47,7 @@ static int do_one_pass(journal_t *journa
 				struct recovery_info *info, enum passtype pass);
 static int scan_revoke_records(journal_t *, struct buffer_head *,
 				tid_t, struct recovery_info *);
+static void journal_syncraid(journal_t *, unsigned long);
 
 #ifdef __KERNEL__
 
@@ -66,7 +72,7 @@ static void journal_brelse_array(struct 
  */
 
 #define MAXBUF 8
-static int do_readahead(journal_t *journal, unsigned int start)
+static int do_readahead(journal_t *journal, unsigned int start, int raid_sync)
 {
 	int err;
 	unsigned int max, nbufs, next;
@@ -102,6 +108,15 @@ static int do_readahead(journal_t *journ
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
+
+			/* For declared mode: perform a raid synchronization
+			 * read for the journal block; this will resync all of
+			 * the journal blocks read, which is more than strictly
+			 * necessary.
+			 */
+			if (raid_sync)
+				set_buffer_syncraid(bh);
+
 			if (nbufs == MAXBUF) {
 				ll_rw_block(READ, nbufs, bufs);
 				journal_brelse_array(bufs, nbufs);
@@ -129,7 +144,7 @@ failed:
  */
 
 static int jread(struct buffer_head **bhp, journal_t *journal,
-		 unsigned int offset)
+		 unsigned int offset, int sync_raid)
 {
 	int err;
 	unsigned long blocknr;
@@ -158,7 +173,7 @@ static int jread(struct buffer_head **bh
 		/* If this is a brand new buffer, start readahead.
                    Otherwise, we assume we are already reading it.  */
 		if (!buffer_req(bh))
-			do_readahead(journal, offset);
+			do_readahead(journal, offset, sync_raid);
 		wait_on_buffer(bh);
 	}
 
@@ -245,6 +260,26 @@ int journal_recover(journal_t *journal)
 		return 0;
 	}
 
+	if (JFS_HAS_INCOMPAT_FEATURE(journal,
+				     JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+		int fd;
+
+		fd = open(journal->j_fs_dev->k_ctx->filesystem_name,
+			  O_RDONLY, 0);
+		if (!fd) {
+			perror("could not open device for SET_RESYNC_ALL");
+			exit(1);
+		}
+
+		jbd_debug(1, "Sending SET_RESYNC_ALL ioctl\n");
+		/* We ignore the return code - someone may have set the flag
+		 * on a filesystem backed by a block device that does not
+		 * support this, in which case journal guided resync is not
+		 * required anyway. */
+		ioctl(fd, SET_RESYNC_ALL);
+		close(fd);
+	}
+
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
@@ -257,6 +292,28 @@ int journal_recover(journal_t *journal)
 	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
+	if (JFS_HAS_INCOMPAT_FEATURE(journal,
+				     JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+		/* Successful declared mode resync: instruct the block
+		 * device to skip its resync and clear the flag. */
+		int fd;
+
+		jbd_debug(0, "JBD: Resynced %d declared blocks\n",
+			  info.nr_declared);
+
+		fd = open(journal->j_fs_dev->k_ctx->filesystem_name,
+			  O_RDONLY, 0);
+
+		if (fd) {
+			jbd_debug(1, "Sending CLEAR_RESYNC_ALL ioctl\n");
+			ioctl(fd, CLEAR_RESYNC_ALL);
+			close(fd);
+		}
+
+		journal_clear_features(journal, 0, 0,
+				       JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS);
+	}
+
 	/* Restart the log at the next transaction ID, thus invalidating
 	 * any existing commit records in the log. */
 	journal->j_transaction_sequence = ++info.end_transaction;
@@ -336,7 +393,7 @@ static int calc_chksums(journal_t *journ
 	for (i = 0; i < num_blks; i++) {
 		io_block = (*next_log_block)++;
 		wrap(journal, *next_log_block);
-		err = jread(&obh, journal, io_block);
+		err = jread(&obh, journal, io_block, 0);
 		if (err) {
 			printk(KERN_ERR "JBD: IO error %d recovering block "
 				"%lu in log\n", err, io_block);
@@ -363,6 +420,8 @@ static int do_one_pass(journal_t *journa
 	int			blocktype;
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	int			raid_sync_journal = 0;
+	int			raid_sync_data = 0;
 
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
@@ -405,9 +464,30 @@ static int do_one_pass(journal_t *journa
 		 * check right now that we haven't gone past the end of
 		 * the log. */
 
-		if (pass != PASS_SCAN)
-			if (tid_geq(next_commit_ID, info->end_transaction))
-				break;
+		if (pass != PASS_SCAN) {
+			if (tid_geq(next_commit_ID, info->end_transaction)) {
+				/* For declared mode resync, move ahead past
+				 * the last commmitted transaction to deal with
+				 * raid sync for declare blocks and the head
+				 * of the journal.
+				 */
+				if (pass == PASS_REPLAY &&
+				    JFS_HAS_INCOMPAT_FEATURE(journal,
+					 JFS_FEATURE_INCOMPAT_DECLARE_BLOCKS)) {
+					if (journal->j_fs_dev == journal->j_dev)
+						raid_sync_journal = 1;
+					if (!raid_sync_data)
+						jbd_debug(1, "Declared mode was used; "
+							  "performing raid sync%s\n",
+							  raid_sync_journal ?
+							  "of journal and data" :
+							  "of data");
+					raid_sync_data = 1;
+				} else {
+					break;
+				}
+			}
+		}
 
 		jbd_debug(2, "Scanning for sequence ID %u at %lu/%lu\n",
 			  next_commit_ID, next_log_block, journal->j_last);
@@ -417,7 +497,7 @@ static int do_one_pass(journal_t *journa
 		 * record. */
 
 		jbd_debug(3, "JBD: checking block %ld\n", next_log_block);
-		err = jread(&bh, journal, next_log_block);
+		err = jread(&bh, journal, next_log_block, raid_sync_journal);
 		if (err)
 			goto failed;
 
@@ -434,6 +514,10 @@ static int do_one_pass(journal_t *journa
 
 		if (tmp->h_magic != cpu_to_be32(JFS_MAGIC_NUMBER)) {
 			brelse(bh);
+
+			/* raid sync the head of the journal */
+			if (raid_sync_journal)
+				journal_syncraid(journal, next_log_block);
 			break;
 		}
 
@@ -444,6 +528,10 @@ static int do_one_pass(journal_t *journa
 
 		if (sequence != next_commit_ID) {
 			brelse(bh);
+
+			/* raid sync the head of the journal */
+			if (raid_sync_journal)
+				journal_syncraid(journal, next_log_block);
 			break;
 		}
 
@@ -491,7 +579,8 @@ static int do_one_pass(journal_t *journa
 
 				io_block = next_log_block++;
 				wrap(journal, next_log_block);
-				err = jread(&obh, journal, io_block);
+				err = jread(&obh, journal, io_block,
+					    raid_sync_journal);
 				if (err) {
 					/* Recover what we can, but
 					 * report failure at the end. */
@@ -675,6 +764,55 @@ static int do_one_pass(journal_t *journa
 				goto failed;
 			continue;
 
+		case JFS_DECLARE_BLOCK:
+			if (!raid_sync_data) {
+				brelse(bh);
+				continue;
+			}
+
+			/* this is a declare block for an uncommitted
+			 * transaction, so raid sync all of the blocks it
+			 * describes
+			 */
+
+			tagp = &bh->b_data[sizeof(journal_header_t)];
+			while ((tagp - bh->b_data +sizeof(journal_block_tag_t))
+			       <= journal->j_blocksize) {
+
+				unsigned long blocknr;
+
+				tag = (journal_block_tag_t *) tagp;
+				flags = be32_to_cpu(tag->t_flags);
+				blocknr = be32_to_cpu(tag->t_blocknr);
+
+				nbh = __getblk(journal->j_fs_dev, blocknr,
+						journal->j_blocksize);
+
+				if (nbh == NULL) {
+					printk(KERN_ERR "JBD: Out of memory "
+					       "during recovery.\n");
+					err = -ENOMEM;
+					brelse(bh);
+					goto failed;
+				}
+
+				ll_rw_block(READ, 1, &nbh);
+				wait_on_buffer(nbh);
+
+				brelse(nbh);
+				++info->nr_declared;
+
+				tagp += sizeof(journal_block_tag_t);
+				if (!(flags & JFS_FLAG_SAME_UUID))
+					tagp += 16;
+
+				if (flags & JFS_FLAG_LAST_TAG)
+					break;
+			}
+
+			brelse(bh);
+			continue;
+
 		default:
 			jbd_debug(3, "Unrecognised magic %d, end of scan.\n",
 				  blocktype);
@@ -712,6 +850,27 @@ static int do_one_pass(journal_t *journa
 	return err;
 }
 
+/* RAID sync the next one quarter of the journal.  This is called once at the
+ * end of recovery if declare blocks are present since that part of the journal
+ * was likely undergoing writes before the crash.
+ */
+static void
+journal_syncraid(journal_t *journal, unsigned long next_log_block)
+{
+	struct buffer_head  *bh;
+	int                  i, err;
+
+	jbd_debug(2, "RAID resync of 1/4 of the journal starting at %lu\n",
+		  next_log_block);
+
+	for (i = 0; i < journal->j_maxlen / 4; i++) {
+		err = jread(&bh, journal, next_log_block, 1);
+		brelse(bh);
+
+		next_log_block++;
+		wrap(journal, next_log_block);
+	}
+}
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
Index: e2fsprogs-1.41.6/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.41.6.orig/e2fsck/journal.c
+++ e2fsprogs-1.41.6/e2fsck/journal.c
@@ -584,6 +584,34 @@ static errcode_t e2fsck_journal_load(jou
 	return 0;
 }
 
+/**
+ * int journal_clear_features () - Clear a given journal feature in the superblock
+ * @journal: Journal to act on.
+ * @compat: bitmask of compatible features
+ * @ro: bitmask of features that force read-only mount
+ * @incompat: bitmask of incompatible features
+ *
+ * Clear a given journal feature as present on the
+ * superblock.  Returns true if the requested features could be reset.
+ *
+ */
+int journal_clear_features (journal_t *journal, unsigned long compat,
+			  unsigned long ro, unsigned long incompat)
+{
+	journal_superblock_t *sb;
+
+	jbd_debug(1, "Clear features 0x%lx/0x%lx/0x%lx\n",
+		  compat, ro, incompat);
+
+	sb = journal->j_superblock;
+
+	sb->s_feature_compat    &= ~cpu_to_be32(compat);
+	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
+	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
+
+	return 1;
+}
+
 static void e2fsck_journal_reset_super(e2fsck_t ctx, journal_superblock_t *jsb,
 				       journal_t *journal)
 {
