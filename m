From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/2] jbd2: clean up feature flag checking and usage
Date: Sat,  3 Oct 2015 03:37:07 -0600
Message-ID: <1443865028-5943-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:46902 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbJCJpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2015 05:45:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clean up the JBD2_HAS_{,RO,IN}COMPAT_FEATURE() flag checking to be
easier to read, as well as safer from accidental coding mistakes.
Instead of passing the whole JBD2_FEATURE_*COMPAT_foo flag name to
the macro, generate the JBD2_FEATURE_*COMPAT prefix internal to the
macro, to ensure the flag name matches the check being done,
since the numerical value might be for the wrong compat type.

Also clean up the functions jbd2_journal_check_used_features() and
jbd2_journal_check_available_features(), jbd2_journal_set_features(),
and jbd2_journal_clear_features() to actually return bool rather
than just pretending to.  Clean up functions to match modern style.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/jbd2/commit.c     |   34 +++++------
 fs/jbd2/journal.c    |  159 ++++++++++++++++++++++++++------------------------
 fs/jbd2/recovery.c   |   15 ++---
 fs/jbd2/revoke.c     |    9 ++-
 include/linux/jbd2.h |   72 +++++++++++++---------
 5 files changed, 150 insertions(+), 139 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 362e5f6..24eeb91 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -142,11 +142,10 @@ static int journal_submit_commit_record(journal_t *journal,
 	tmp->h_commit_sec = cpu_to_be64(now.tv_sec);
 	tmp->h_commit_nsec = cpu_to_be32(now.tv_nsec);
 
-	if (JBD2_HAS_COMPAT_FEATURE(journal,
-				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
-		tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
-		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
-		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
+	if (JBD2_HAS_COMPAT_FEATURE(journal, CHECKSUM)) {
+		tmp->h_chksum_type	= JBD2_CRC32_CHKSUM;
+		tmp->h_chksum_size	= JBD2_CRC32_CHKSUM_SIZE;
+		tmp->h_chksum[0]	= cpu_to_be32(crc32_sum);
 	}
 	jbd2_commit_block_csum_set(journal, bh);
 
@@ -157,8 +156,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	bh->b_end_io = journal_end_buffer_io_sync;
 
 	if (journal->j_flags & JBD2_BARRIER &&
-	    !JBD2_HAS_INCOMPAT_FEATURE(journal,
-				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
+	    !JBD2_HAS_INCOMPAT_FEATURE(journal, ASYNC_COMMIT))
 		ret = submit_bh(WRITE_SYNC | WRITE_FLUSH_FUA, bh);
 	else
 		ret = submit_bh(WRITE_SYNC, bh);
@@ -317,7 +315,7 @@ static void write_tag_block(journal_t *j, journal_block_tag_t *tag,
 				   unsigned long long block)
 {
 	tag->t_blocknr = cpu_to_be32(block & (u32)~0);
-	if (JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(j, 64BIT))
 		tag->t_blocknr_high = cpu_to_be32((block >> 31) >> 1);
 }
 
@@ -356,7 +354,7 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
 			     bh->b_size);
 	kunmap_atomic(addr);
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V3))
+	if (JBD2_HAS_INCOMPAT_FEATURE(j, CSUM_V3))
 		tag3->t_checksum = cpu_to_be32(csum32);
 	else
 		tag->t_checksum = cpu_to_be16(csum32);
@@ -731,7 +729,7 @@ start_journal_io:
 				 * Compute checksum.
 				 */
 				if (JBD2_HAS_COMPAT_FEATURE(journal,
-					JBD2_FEATURE_COMPAT_CHECKSUM)) {
+							    CHECKSUM)) {
 					crc32_sum =
 					    jbd2_checksum_data(crc32_sum, bh);
 				}
@@ -797,10 +795,9 @@ start_journal_io:
 		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
 
 	/* Done it all: now write the commit record asynchronously. */
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
-				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, ASYNC_COMMIT)) {
 		err = journal_submit_commit_record(journal, commit_transaction,
-						 &cbh, crc32_sum);
+						   &cbh, crc32_sum);
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 	}
@@ -889,20 +886,17 @@ start_journal_io:
 	commit_transaction->t_state = T_COMMIT_JFLUSH;
 	write_unlock(&journal->j_state_lock);
 
-	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
-				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+	if (!JBD2_HAS_INCOMPAT_FEATURE(journal, ASYNC_COMMIT)) {
 		err = journal_submit_commit_record(journal, commit_transaction,
-						&cbh, crc32_sum);
+						   &cbh, crc32_sum);
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
-				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
-	    journal->j_flags & JBD2_BARRIER) {
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, ASYNC_COMMIT) &&
+	    journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
-	}
 
 	if (err)
 		jbd2_journal_abort(journal, err);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8270fe9..0a25b88 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1523,8 +1523,8 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2) &&
-	    JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V3)) {
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V2) &&
+	    JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V3)) {
 		/* Can't have checksum v2 and v3 at the same time! */
 		printk(KERN_ERR "JBD2: Can't enable checksumming v2 and v3 "
 		       "at the same time!\n");
@@ -1532,7 +1532,7 @@ static int journal_get_superblock(journal_t *journal)
 	}
 
 	if (jbd2_journal_has_csum_v2or3(journal) &&
-	    JBD2_HAS_COMPAT_FEATURE(journal, JBD2_FEATURE_COMPAT_CHECKSUM)) {
+	    JBD2_HAS_COMPAT_FEATURE(journal, CHECKSUM)) {
 		/* Can't have checksum v1 and v2 on at the same time! */
 		printk(KERN_ERR "JBD2: Can't enable checksumming v1 and v2/3 "
 		       "at the same time!\n");
@@ -1611,26 +1611,24 @@ static int load_superblock(journal_t *journal)
  */
 int jbd2_journal_load(journal_t *journal)
 {
-	int err;
 	journal_superblock_t *sb;
+	int err;
 
 	err = load_superblock(journal);
 	if (err)
 		return err;
 
 	sb = journal->j_superblock;
+
 	/* If this is a V2 superblock, then we have to check the
 	 * features flags on it. */
-
-	if (journal->j_format_version >= 2) {
-		if ((sb->s_feature_ro_compat &
-		     ~cpu_to_be32(JBD2_KNOWN_ROCOMPAT_FEATURES)) ||
-		    (sb->s_feature_incompat &
-		     ~cpu_to_be32(JBD2_KNOWN_INCOMPAT_FEATURES))) {
-			printk(KERN_WARNING
-				"JBD2: Unrecognised features on journal\n");
-			return -EINVAL;
-		}
+	if (JBD2_HAS_ROCOMPAT_FEATURE(journal, UNKNOWN) ||
+	    JBD2_HAS_INCOMPAT_FEATURE(journal, UNKNOWN)) {
+		printk(KERN_WARNING
+		       "JBD2: Unrecognised features %#x/%#x on journal\n",
+		       be32_to_cpu(sb->s_feature_rocompat),
+		       be32_to_cpu(sb->s_feature_incompat));
+		return -EINVAL;
 	}
 
 	/*
@@ -1737,98 +1735,105 @@ int jbd2_journal_destroy(journal_t *journal)
 
 
 /**
- *int jbd2_journal_check_used_features () - Check if features specified are used.
+ * jbd2_journal_check_used_features - Check if features specified are used.
  * @journal: Journal to check.
  * @compat: bitmask of compatible features
- * @ro: bitmask of features that force read-only mount
+ * @rocompat: bitmask of features that force read-only mount
  * @incompat: bitmask of incompatible features
  *
- * Check whether the journal uses all of a given set of
- * features.  Return true (non-zero) if it does.
+ * Check whether the journal uses all of a given set of features.
+ * Return true if it does.
  **/
-
-int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
-				 unsigned long ro, unsigned long incompat)
+bool jbd2_journal_check_used_features(journal_t *journal, unsigned long compat,
+				      unsigned long rocompat,
+				      unsigned long incompat)
 {
 	journal_superblock_t *sb;
 
-	if (!compat && !ro && !incompat)
-		return 1;
+	if (!compat && !rocompat && !incompat)
+		return true;
+
 	/* Load journal superblock if it is not loaded yet. */
 	if (journal->j_format_version == 0 &&
 	    journal_get_superblock(journal) != 0)
-		return 0;
-	if (journal->j_format_version == 1)
-		return 0;
+		return false;
+	if (journal->j_format_version < 2)
+		return false;
 
 	sb = journal->j_superblock;
 
 	if (((be32_to_cpu(sb->s_feature_compat) & compat) == compat) &&
-	    ((be32_to_cpu(sb->s_feature_ro_compat) & ro) == ro) &&
+	    ((be32_to_cpu(sb->s_feature_rocompat) & rocompat) == rocompat) &&
 	    ((be32_to_cpu(sb->s_feature_incompat) & incompat) == incompat))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 /**
- * int jbd2_journal_check_available_features() - Check feature set in journalling layer
+ * jbd2_journal_check_available_features - Check feature set in journal layer
  * @journal: Journal to check.
  * @compat: bitmask of compatible features
- * @ro: bitmask of features that force read-only mount
+ * @rocompat: bitmask of features that force read-only mount
  * @incompat: bitmask of incompatible features
  *
  * Check whether the journaling code supports the use of
  * all of a given set of features on this journal.  Return true
- * (non-zero) if it can. */
-
-int jbd2_journal_check_available_features (journal_t *journal, unsigned long compat,
-				      unsigned long ro, unsigned long incompat)
+ * if all features are supported.
+ */
+bool jbd2_journal_check_available_features(journal_t *journal,
+					   unsigned long compat,
+					   unsigned long rocompat,
+					   unsigned long incompat)
 {
-	if (!compat && !ro && !incompat)
-		return 1;
+	if (!compat && !rocompat && !incompat)
+		return true;
 
 	/* We can support any known requested features iff the
 	 * superblock is in version 2.  Otherwise we fail to support any
 	 * extended sb features. */
-
 	if (journal->j_format_version != 2)
-		return 0;
+		return false;
 
-	if ((compat   & JBD2_KNOWN_COMPAT_FEATURES) == compat &&
-	    (ro       & JBD2_KNOWN_ROCOMPAT_FEATURES) == ro &&
-	    (incompat & JBD2_KNOWN_INCOMPAT_FEATURES) == incompat)
-		return 1;
+	if ((compat   & JBD2_FEATURE_COMPAT_KNOWN) == compat &&
+	    (rocompat & JBD2_FEATURE_ROCOMPAT_KNOWN) == rocompat &&
+	    (incompat & JBD2_FEATURE_INCOMPAT_KNOWN) == incompat)
+		return true;
 
-	return 0;
+	return false;
 }
 
 /**
- * int jbd2_journal_set_features () - Mark a given journal feature in the superblock
+ * jbd2_journal_set_features() - Mark journal feature(s) in the superblock
  * @journal: Journal to act on.
  * @compat: bitmask of compatible features
- * @ro: bitmask of features that force read-only mount
+ * @rocompat: bitmask of features that force read-only mount
  * @incompat: bitmask of incompatible features
  *
  * Mark a given journal feature as present on the
  * superblock.  Returns true if the requested features could be set.
- *
  */
-
-int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
-			  unsigned long ro, unsigned long incompat)
-{
-#define INCOMPAT_FEATURE_ON(f) \
-		((incompat & (f)) && !(sb->s_feature_incompat & cpu_to_be32(f)))
-#define COMPAT_FEATURE_ON(f) \
-		((compat & (f)) && !(sb->s_feature_compat & cpu_to_be32(f)))
+bool jbd2_journal_set_features(journal_t *journal, unsigned long compat,
+			       unsigned long rocompat, unsigned long incompat)
+{
+#define COMPAT_FEATURE_ON(f)						\
+	((compat & (JBD2_FEATURE_COMPAT_ ## f)) &&			\
+	 !(sb->s_feature_compat & cpu_to_be32(JBD2_FEATURE_COMPAT_ ## f)))
+#define ROCOMPAT_FEATURE_ON(f)						\
+	((rocompat & (JBD2_FEATURE_ROCOMPAT_ ## f)) &&			\
+	 !(sb->s_feature_rocompat & cpu_to_be32(JBD2_FEATURE_ROCOMPAT_ ## f)))
+#define INCOMPAT_FEATURE_ON(f)						\
+	((incompat & (JBD2_FEATURE_INCOMPAT_ ## f)) &&			\
+	 !(sb->s_feature_incompat & cpu_to_be32(JBD2_FEATURE_INCOMPAT_ ## f)))
 	journal_superblock_t *sb;
 
-	if (jbd2_journal_check_used_features(journal, compat, ro, incompat))
-		return 1;
+	if (jbd2_journal_check_used_features(journal, compat,
+					     rocompat, incompat))
+		return true;
 
-	if (!jbd2_journal_check_available_features(journal, compat, ro, incompat))
-		return 0;
+	if (!jbd2_journal_check_available_features(journal, compat,
+						   rocompat, incompat))
+		return false;
 
 	/* If enabling v2 checksums, turn on v3 instead */
 	if (incompat & JBD2_FEATURE_INCOMPAT_CSUM_V2) {
@@ -1842,12 +1847,12 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 		compat &= ~JBD2_FEATURE_COMPAT_CHECKSUM;
 
 	jbd_debug(1, "Setting new features 0x%lx/0x%lx/0x%lx\n",
-		  compat, ro, incompat);
+		  compat, rocompat, incompat);
 
 	sb = journal->j_superblock;
 
 	/* If enabling v3 checksums, update superblock */
-	if (INCOMPAT_FEATURE_ON(JBD2_FEATURE_INCOMPAT_CSUM_V3)) {
+	if (INCOMPAT_FEATURE_ON(CSUM_V3)) {
 		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
 		sb->s_feature_compat &=
 			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
@@ -1860,7 +1865,7 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 				printk(KERN_ERR "JBD2: Cannot load crc32c "
 				       "driver.\n");
 				journal->j_chksum_driver = NULL;
-				return 0;
+				return false;
 			}
 
 			/* Precompute checksum seed for all metadata */
@@ -1871,44 +1876,44 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 	}
 
 	/* If enabling v1 checksums, downgrade superblock */
-	if (COMPAT_FEATURE_ON(JBD2_FEATURE_COMPAT_CHECKSUM))
+	if (COMPAT_FEATURE_ON(CHECKSUM))
 		sb->s_feature_incompat &=
 			~cpu_to_be32(JBD2_FEATURE_INCOMPAT_CSUM_V2 |
 				     JBD2_FEATURE_INCOMPAT_CSUM_V3);
 
-	sb->s_feature_compat    |= cpu_to_be32(compat);
-	sb->s_feature_ro_compat |= cpu_to_be32(ro);
-	sb->s_feature_incompat  |= cpu_to_be32(incompat);
+	sb->s_feature_compat   |= cpu_to_be32(compat);
+	sb->s_feature_rocompat |= cpu_to_be32(rocompat);
+	sb->s_feature_incompat |= cpu_to_be32(incompat);
 
-	return 1;
+	return true;
 #undef COMPAT_FEATURE_ON
+#undef ROCOMPAT_FEATURE_ON
 #undef INCOMPAT_FEATURE_ON
 }
 
 /*
- * jbd2_journal_clear_features () - Clear a given journal feature in the
- * 				    superblock
+ * jbd2_journal_clear_features() - Clear journal feature(s) from the superblock
  * @journal: Journal to act on.
  * @compat: bitmask of compatible features
- * @ro: bitmask of features that force read-only mount
+ * @rocompat: bitmask of features that force read-only mount
  * @incompat: bitmask of incompatible features
  *
  * Clear a given journal feature as present on the
  * superblock.
  */
 void jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
-				unsigned long ro, unsigned long incompat)
+				unsigned long rocompat, unsigned long incompat)
 {
 	journal_superblock_t *sb;
 
 	jbd_debug(1, "Clear features 0x%lx/0x%lx/0x%lx\n",
-		  compat, ro, incompat);
+		  compat, rocompat, incompat);
 
 	sb = journal->j_superblock;
 
-	sb->s_feature_compat    &= ~cpu_to_be32(compat);
-	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
-	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
+	sb->s_feature_compat   &= ~cpu_to_be32(compat);
+	sb->s_feature_rocompat &= ~cpu_to_be32(rocompat);
+	sb->s_feature_incompat &= ~cpu_to_be32(incompat);
 }
 EXPORT_SYMBOL(jbd2_journal_clear_features);
 
@@ -2197,15 +2202,15 @@ size_t journal_tag_bytes(journal_t *journal)
 {
 	size_t sz;
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V3))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V3))
 		return sizeof(journal_block_tag3_t);
 
 	sz = sizeof(journal_block_tag_t);
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V2))
 		sz += sizeof(__u16);
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, 64BIT))
 		return sz;
 	else
 		return sz - sizeof(__u32);
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index a9079d0..b3cfe15 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -342,7 +342,7 @@ static inline unsigned long long read_tag_block(journal_t *journal,
 						journal_block_tag_t *tag)
 {
 	unsigned long long block = be32_to_cpu(tag->t_blocknr);
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, 64BIT))
 		block |= (u64)be32_to_cpu(tag->t_blocknr_high) << 32;
 	return block;
 }
@@ -411,7 +411,7 @@ static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
 	csum32 = jbd2_chksum(j, csum32, buf, j->j_blocksize);
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V3))
+	if (JBD2_HAS_INCOMPAT_FEATURE(j, CSUM_V3))
 		return tag3->t_checksum == cpu_to_be32(csum32);
 	else
 		return tag->t_checksum == cpu_to_be16(csum32);
@@ -539,7 +539,7 @@ static int do_one_pass(journal_t *journal,
 			if (pass != PASS_REPLAY) {
 				if (pass == PASS_SCAN &&
 				    JBD2_HAS_COMPAT_FEATURE(journal,
-					    JBD2_FEATURE_COMPAT_CHECKSUM) &&
+							    CHECKSUM) &&
 				    !info->end_transaction) {
 					if (calc_chksums(journal, bh,
 							&next_log_block,
@@ -694,8 +694,7 @@ static int do_one_pass(journal_t *journal,
 			 * much to do other than move on to the next sequence
 			 * number. */
 			if (pass == PASS_SCAN &&
-			    JBD2_HAS_COMPAT_FEATURE(journal,
-				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
+			    JBD2_HAS_COMPAT_FEATURE(journal, CHECKSUM)) {
 				int chksum_err, chksum_seen;
 				struct commit_header *cbh =
 					(struct commit_header *)bh->b_data;
@@ -736,7 +735,7 @@ static int do_one_pass(journal_t *journal,
 					info->end_transaction = next_commit_ID;
 
 					if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
-					   JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)){
+								ASYNC_COMMIT)) {
 						journal->j_failed_commit =
 							next_commit_ID;
 						brelse(bh);
@@ -751,7 +750,7 @@ static int do_one_pass(journal_t *journal,
 				info->end_transaction = next_commit_ID;
 
 				if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
-				     JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+							       ASYNC_COMMIT)) {
 					journal->j_failed_commit =
 						next_commit_ID;
 					brelse(bh);
@@ -859,7 +858,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 		return -EINVAL;
 	max = rcount;
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, 64BIT))
 		record_len = 8;
 
 	while (offset + record_len <= max) {
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 0abf2e7..aa5b26a 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -334,8 +334,9 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 		BUFFER_TRACE(bh_in, "enter");
 
 	journal = handle->h_transaction->t_journal;
-	if (!jbd2_journal_set_features(journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE)){
-		J_ASSERT (!"Cannot set revoke feature!");
+	if (!jbd2_journal_set_features(journal, 0, 0,
+				       JBD2_FEATURE_INCOMPAT_REVOKE)) {
+		J_ASSERT(!"Cannot set revoke feature!");
 		return -EINVAL;
 	}
 
@@ -589,7 +590,7 @@ static void write_one_revoke_record(journal_t *journal,
 	if (jbd2_journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct jbd2_journal_revoke_tail);
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, 64BIT))
 		sz = 8;
 	else
 		sz = 4;
@@ -619,7 +620,7 @@ static void write_one_revoke_record(journal_t *journal,
 		*descriptorp = descriptor;
 	}
 
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, 64BIT))
 		* ((__be64 *)(&descriptor->b_data[offset])) =
 			cpu_to_be64(record->blocknr);
 	else
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index df07e78..0d1912c 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -254,7 +254,7 @@ typedef struct journal_superblock_s
 	/* Remaining fields are only valid in a version-2 superblock */
 	__be32	s_feature_compat;	/* compatible feature set */
 	__be32	s_feature_incompat;	/* incompatible feature set */
-	__be32	s_feature_ro_compat;	/* readonly-compatible feature set */
+	__be32	s_feature_rocompat;	/* readonly-compatible feature set */
 /* 0x0030 */
 	__u8	s_uuid[16];		/* 128-bit uuid for journal */
 
@@ -278,17 +278,20 @@ typedef struct journal_superblock_s
 /* 0x0400 */
 } journal_superblock_t;
 
-#define JBD2_HAS_COMPAT_FEATURE(j,mask)					\
+#define JBD2_HAS_COMPAT_FEATURE(j, name)				\
 	((j)->j_format_version >= 2 &&					\
-	 ((j)->j_superblock->s_feature_compat & cpu_to_be32((mask))))
-#define JBD2_HAS_RO_COMPAT_FEATURE(j,mask)				\
+	 ((j)->j_superblock->s_feature_compat &				\
+	  cpu_to_be32(JBD2_FEATURE_COMPAT_ ## name)))
+#define JBD2_HAS_ROCOMPAT_FEATURE(j, name)				\
 	((j)->j_format_version >= 2 &&					\
-	 ((j)->j_superblock->s_feature_ro_compat & cpu_to_be32((mask))))
-#define JBD2_HAS_INCOMPAT_FEATURE(j,mask)				\
+	 ((j)->j_superblock->s_feature_rocompat &			\
+	  cpu_to_be32(JBD2_FEATURE_ROCOMPAT_ ## name)))
+#define JBD2_HAS_INCOMPAT_FEATURE(j, name)				\
 	((j)->j_format_version >= 2 &&					\
-	 ((j)->j_superblock->s_feature_incompat & cpu_to_be32((mask))))
+	 ((j)->j_superblock->s_feature_incompat &			\
+	  cpu_to_be32(JBD2_FEATURE_INCOMPAT_ ## name)))
 
-#define JBD2_FEATURE_COMPAT_CHECKSUM	0x00000001
+#define JBD2_FEATURE_COMPAT_CHECKSUM		0x00000001
 
 #define JBD2_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JBD2_FEATURE_INCOMPAT_64BIT		0x00000002
@@ -297,13 +300,16 @@ typedef struct journal_superblock_s
 #define JBD2_FEATURE_INCOMPAT_CSUM_V3		0x00000010
 
 /* Features known to this kernel version: */
-#define JBD2_KNOWN_COMPAT_FEATURES	JBD2_FEATURE_COMPAT_CHECKSUM
-#define JBD2_KNOWN_ROCOMPAT_FEATURES	0
-#define JBD2_KNOWN_INCOMPAT_FEATURES	(JBD2_FEATURE_INCOMPAT_REVOKE | \
-					JBD2_FEATURE_INCOMPAT_64BIT | \
-					JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT | \
-					JBD2_FEATURE_INCOMPAT_CSUM_V2 | \
-					JBD2_FEATURE_INCOMPAT_CSUM_V3)
+#define JBD2_FEATURE_COMPAT_KNOWN	(JBD2_FEATURE_COMPAT_CHECKSUM)
+#define JBD2_FEATURE_ROCOMPAT_KNOWN	0
+#define JBD2_FEATURE_INCOMPAT_KNOWN	(JBD2_FEATURE_INCOMPAT_REVOKE | \
+					 JBD2_FEATURE_INCOMPAT_64BIT | \
+					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT | \
+					 JBD2_FEATURE_INCOMPAT_CSUM_V2 | \
+					 JBD2_FEATURE_INCOMPAT_CSUM_V3)
+#define JBD2_FEATURE_COMPAT_UNKNOWN	~JBD2_FEATURE_COMPAT_KNOWN
+#define JBD2_FEATURE_ROCOMPAT_UNKNOWN	~JBD2_FEATURE_ROCOMPAT_KNOWN
+#define JBD2_FEATURE_INCOMPAT_UNKNOWN	~JBD2_FEATURE_INCOMPAT_KNOWN
 
 #ifdef __KERNEL__
 
@@ -1178,19 +1184,25 @@ extern int	 jbd2_journal_flush (journal_t *);
 extern void	 jbd2_journal_lock_updates (journal_t *);
 extern void	 jbd2_journal_unlock_updates (journal_t *);
 
-extern journal_t * jbd2_journal_init_dev(struct block_device *bdev,
-				struct block_device *fs_dev,
-				unsigned long long start, int len, int bsize);
-extern journal_t * jbd2_journal_init_inode (struct inode *);
-extern int	   jbd2_journal_update_format (journal_t *);
-extern int	   jbd2_journal_check_used_features
-		   (journal_t *, unsigned long, unsigned long, unsigned long);
-extern int	   jbd2_journal_check_available_features
-		   (journal_t *, unsigned long, unsigned long, unsigned long);
-extern int	   jbd2_journal_set_features
-		   (journal_t *, unsigned long, unsigned long, unsigned long);
-extern void	   jbd2_journal_clear_features
-		   (journal_t *, unsigned long, unsigned long, unsigned long);
+extern journal_t *jbd2_journal_init_dev(struct block_device *bdev,
+					struct block_device *fs_dev,
+					unsigned long long start,
+					int len, int bsize);
+extern journal_t *jbd2_journal_init_inode(struct inode *);
+extern int jbd2_journal_update_format(journal_t *);
+extern bool jbd2_journal_check_used_features(journal_t *, unsigned long compat,
+					     unsigned long rocompat,
+					     unsigned long incompat);
+extern bool jbd2_journal_check_available_features(journal_t *,
+						  unsigned long compat,
+						  unsigned long rocompat,
+						  unsigned long incompat);
+extern bool jbd2_journal_set_features(journal_t *, unsigned long compat,
+				      unsigned long rocompat,
+				      unsigned long incompat);
+extern void jbd2_journal_clear_features(journal_t *, unsigned long compat,
+					unsigned long rocompat,
+					unsigned long incompat);
 extern int	   jbd2_journal_load       (journal_t *journal);
 extern int	   jbd2_journal_destroy    (journal_t *);
 extern int	   jbd2_journal_recover    (journal_t *journal);
@@ -1340,8 +1352,8 @@ extern size_t journal_tag_bytes(journal_t *journal);
 
 static inline int jbd2_journal_has_csum_v2or3(journal_t *journal)
 {
-	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2) ||
-	    JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V3))
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V2) ||
+	    JBD2_HAS_INCOMPAT_FEATURE(journal, CSUM_V3))
 		return 1;
 
 	return 0;
-- 
1.7.3.4

