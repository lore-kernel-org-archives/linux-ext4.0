From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/25] e2fsck/debugfs: fix descriptor block size handling
 errors with journal_csum
Date: Mon, 08 Sep 2014 16:11:43 -0700
Message-ID: <20140908231143.25904.98802.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXLt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:11:49 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It turns out that there are some serious problems with the on-disk
format of journal checksum v2.  The foremost is that the function to
calculate descriptor tag size returns sizes that are too big.  This
causes alignment issues on some architectures and is compounded by the
fact that some parts of jbd2 use the structure size (incorrectly) to
determine the presence of a 64bit journal instead of checking the
feature flags.  These errors regrettably lead to the journal
corruption reported by Mr. Reardon.

Therefore, introduce journal checksum v3, which enlarges the
descriptor block tag format to allow for full 32-bit checksums of
journal blocks, fix the journal tag function to return the correct
sizes, and fix the jbd2 recovery code to use feature flags to
determine 64bitness.

Add a few function helpers so we don't have to open-code quite so
many pieces.

Switching to a 16-byte block size was found to increase journal size
overhead by a maximum of 0.1%, to convert a 32-bit journal with no
checksumming to a 32-bit journal with checksum v3 enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 debugfs/jfs_user.h      |   21 +++++++++++++++++++++
 debugfs/logdump.c       |   12 +++++++-----
 e2fsck/journal.c        |   14 +++++++++-----
 e2fsck/recovery.c       |   24 ++++++++++++++----------
 e2fsck/revoke.c         |    4 ++--
 lib/e2p/feature.c       |    2 ++
 lib/ext2fs/kernel-jbd.h |   46 +++++++++++++++++++++++++++++++++++-----------
 misc/dumpe2fs.c         |   12 ++++++++----
 8 files changed, 98 insertions(+), 37 deletions(-)


diff --git a/debugfs/jfs_user.h b/debugfs/jfs_user.h
index 3070cd5..66756fc 100644
--- a/debugfs/jfs_user.h
+++ b/debugfs/jfs_user.h
@@ -5,4 +5,25 @@ typedef unsigned short kdev_t;
 
 #include <ext2fs/kernel-jbd.h>
 
+#define JSB_HAS_INCOMPAT_FEATURE(jsb, mask)				\
+	((jsb)->s_header.h_blocktype == ext2fs_cpu_to_be32(JFS_SUPERBLOCK_V2) &&	\
+	 ((jsb)->s_feature_incompat & ext2fs_cpu_to_be32((mask))))
+static inline size_t journal_super_tag_bytes(journal_superblock_t *jsb)
+{
+	size_t sz;
+
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_CSUM_V3))
+		return sizeof(journal_block_tag3_t);
+
+	sz = sizeof(journal_block_tag_t);
+
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		sz += sizeof(__u16);
+
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_64BIT))
+		return sz;
+
+	return sz - sizeof(__u32);
+}
+
 #endif /* _JFS_USER_H */
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 9f9594f..70a7c36 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -476,19 +476,21 @@ static void dump_descriptor_block(FILE *out_file,
 				  unsigned int *blockp, int blocksize,
 				  tid_t transaction)
 {
-	int			offset, tag_size = JBD_TAG_SIZE32;
+	int			offset, tag_size, csum_size = 0;
 	char			*tagp;
 	journal_block_tag_t	*tag;
 	unsigned int		blocknr;
 	__u32			tag_block;
 	__u32			tag_flags;
 
-	if (be32_to_cpu(jsb->s_feature_incompat) & JFS_FEATURE_INCOMPAT_64BIT)
-		tag_size = JBD_TAG_SIZE64;
-
+	tag_size = journal_super_tag_bytes(jsb);
 	offset = sizeof(journal_header_t);
 	blocknr = *blockp;
 
+	if (JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_CSUM_V3) ||
+	    JSB_HAS_INCOMPAT_FEATURE(jsb, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		csum_size = sizeof(struct journal_block_tail);
+
 	if (dump_all)
 		fprintf(out_file, "Dumping descriptor block, sequence %u, at "
 			"block %u:\n", transaction, blocknr);
@@ -505,7 +507,7 @@ static void dump_descriptor_block(FILE *out_file,
 
 		/* ... and if we have gone too far, then we've reached the
 		   end of this block. */
-		if (offset > blocksize)
+		if (offset > blocksize - csum_size)
 			break;
 
 		tag_block = be32_to_cpu(tag->t_blocknr);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 533b1d6..a19d40b 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -44,7 +44,7 @@ static int bh_count = 0;
 static int e2fsck_journal_verify_csum_type(journal_t *j,
 					   journal_superblock_t *jsb)
 {
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	return jsb->s_checksum_type == JBD2_CRC32C_CHKSUM;
@@ -68,7 +68,7 @@ static int e2fsck_journal_sb_csum_verify(journal_t *j,
 {
 	__u32 provided, calculated;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	provided = ext2fs_be32_to_cpu(jsb->s_checksum);
@@ -82,7 +82,7 @@ static errcode_t e2fsck_journal_sb_csum_set(journal_t *j,
 {
 	__u32 crc;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 0;
 
 	crc = e2fsck_journal_sb_csum(jsb);
@@ -623,8 +623,12 @@ static errcode_t e2fsck_journal_load(journal_t *journal)
 	if (JFS_HAS_RO_COMPAT_FEATURE(journal, ~JFS_KNOWN_ROCOMPAT_FEATURES))
 		return EXT2_ET_RO_UNSUPP_FEATURE;
 
-	/* Checksum v1 and v2 are mutually exclusive features. */
+	/* Checksum v1-3 are mutually exclusive features. */
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) &&
+	    JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+		return EXT2_ET_CORRUPT_SUPERBLOCK;
+
+	if (journal_has_csum_v2or3(journal) &&
 	    JFS_HAS_COMPAT_FEATURE(journal, JFS_FEATURE_COMPAT_CHECKSUM))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
@@ -632,7 +636,7 @@ static errcode_t e2fsck_journal_load(journal_t *journal)
 	    !e2fsck_journal_sb_csum_verify(journal, jsb))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (journal_has_csum_v2or3(journal))
 		journal->j_csum_seed = jbd2_chksum(journal, ~0, jsb->s_uuid,
 						   sizeof(jsb->s_uuid));
 
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index dae7239..3dc7c06 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -181,7 +181,7 @@ static int jbd2_descr_block_csum_verify(journal_t *j,
 	__u32 provided;
 	__u32 calculated;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	tail = (struct journal_block_tail *)(buf + j->j_blocksize -
@@ -205,7 +205,7 @@ static int count_tags(journal_t *journal, struct buffer_head *bh)
 	int			nr = 0, size = journal->j_blocksize;
 	int			tag_bytes = journal_tag_bytes(journal);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (journal_has_csum_v2or3(journal))
 		size -= sizeof(struct journal_block_tail);
 
 	tagp = &bh->b_data[sizeof(journal_header_t)];
@@ -338,10 +338,11 @@ int journal_skip_recovery(journal_t *journal)
 	return err;
 }
 
-static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag_t *tag)
+static inline unsigned long long read_tag_block(journal_t *journal,
+						journal_block_tag_t *tag)
 {
 	unsigned long long block = ext2fs_be32_to_cpu(tag->t_blocknr);
-	if (tag_bytes > JFS_TAG_SIZE32)
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		block |= (u64)ext2fs_be32_to_cpu(tag->t_blocknr_high) << 32;
 	return block;
 }
@@ -384,7 +385,7 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 	__u32 provided;
 	__u32 calculated;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	h = buf;
@@ -399,16 +400,20 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 				      void *buf, __u32 sequence)
 {
+	journal_block_tag3_t *tag3 = (journal_block_tag3_t *)tag;
 	__u32 csum32;
 	__u32 seq;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	seq = ext2fs_cpu_to_be32(sequence);
 	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
 	csum32 = jbd2_chksum(j, csum32, buf, j->j_blocksize);
 
+	if (JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V3))
+		return tag3->t_checksum == ext2fs_cpu_to_be32(csum32);
+
 	return tag->t_checksum == ext2fs_cpu_to_be16(csum32);
 }
 
@@ -513,8 +518,7 @@ static int do_one_pass(journal_t *journal,
 		switch(blocktype) {
 		case JFS_DESCRIPTOR_BLOCK:
 			/* Verify checksum first */
-			if (JFS_HAS_INCOMPAT_FEATURE(journal,
-					JFS_FEATURE_INCOMPAT_CSUM_V2))
+			if (journal_has_csum_v2or3(journal))
 				descr_csum_size =
 					sizeof(struct journal_block_tail);
 			if (descr_csum_size > 0 &&
@@ -575,7 +579,7 @@ static int do_one_pass(journal_t *journal,
 					unsigned long long blocknr;
 
 					J_ASSERT(obh != NULL);
-					blocknr = read_tag_block(tag_bytes,
+					blocknr = read_tag_block(journal,
 								 tag);
 
 					/* If the block has been
@@ -814,7 +818,7 @@ static int jbd2_revoke_block_csum_verify(journal_t *j,
 	__u32 provided;
 	__u32 calculated;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return 1;
 
 	tail = (struct journal_revoke_tail *)(buf + j->j_blocksize -
diff --git a/e2fsck/revoke.c b/e2fsck/revoke.c
index 383164e..b4c3f5f 100644
--- a/e2fsck/revoke.c
+++ b/e2fsck/revoke.c
@@ -597,7 +597,7 @@ static void write_one_revoke_record(journal_t *journal,
 	offset = *offsetp;
 
 	/* Do we need to leave space at the end for a checksum? */
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct journal_revoke_tail);
 
 	/* Make sure we have a descriptor with space left for the record */
@@ -644,7 +644,7 @@ static void jbd2_revoke_csum_set(journal_t *j, struct buffer_head *bh)
 	struct journal_revoke_tail *tail;
 	__u32 csum;
 
-	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (!journal_has_csum_v2or3(j))
 		return;
 
 	tail = (struct journal_revoke_tail *)(bh->b_data + j->j_blocksize -
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index d0e29b8..6e53cfe 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -112,6 +112,8 @@ static struct feature jrnl_feature_list[] = {
                        "journal_async_commit" },
        {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_CSUM_V2,
                        "journal_checksum_v2" },
+       {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_CSUM_V3,
+                       "journal_checksum_v3" },
        {       0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 407f4a5..4020429 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -131,7 +131,11 @@ typedef struct journal_header_s
  * journal_block_tag (in the descriptor).  The other h_chksum* fields are
  * not used.
  *
- * Checksum v1 and v2 are mutually exclusive features.
+ * If FEATURE_INCOMPAT_CSUM_V3 is set, the descriptor block uses
+ * journal_block_tag3_t to store a full 32-bit checksum.  Everything else
+ * is the same as v2.
+ *
+ * Checksum v1, v2, and v3 are mutually exclusive features.
  */
 struct commit_header {
 	__u32		h_magic;
@@ -148,6 +152,14 @@ struct commit_header {
 /*
  * The block tag: used to describe a single buffer in the journal
  */
+typedef struct journal_block_tag3_s
+{
+	__u32		t_blocknr;	/* The on-disk block number */
+	__u32		t_flags;	/* See below */
+	__u32		t_blocknr_high; /* most-significant high 32bits. */
+	__u32		t_checksum;	/* crc32c(uuid+seq+block) */
+} journal_block_tag3_t;
+
 typedef struct journal_block_tag_s
 {
 	__u32		t_blocknr;	/* The on-disk block number */
@@ -156,9 +168,6 @@ typedef struct journal_block_tag_s
 	__u32		t_blocknr_high; /* most-significant high 32bits. */
 } journal_block_tag_t;
 
-#define JBD_TAG_SIZE64 (sizeof(journal_block_tag_t))
-#define JBD_TAG_SIZE32 (8)
-
 /* Tail of descriptor block, for checksumming */
 struct journal_block_tail {
 	__u32		t_checksum;
@@ -257,6 +266,7 @@ typedef struct journal_superblock_s
 #define JFS_FEATURE_INCOMPAT_64BIT		0x00000002
 #define JFS_FEATURE_INCOMPAT_ASYNC_COMMIT	0x00000004
 #define JFS_FEATURE_INCOMPAT_CSUM_V2		0x00000008
+#define JFS_FEATURE_INCOMPAT_CSUM_V3		0x00000010
 
 /* Features known to this kernel version: */
 #define JFS_KNOWN_COMPAT_FEATURES	0
@@ -264,7 +274,8 @@ typedef struct journal_superblock_s
 #define JFS_KNOWN_INCOMPAT_FEATURES	(JFS_FEATURE_INCOMPAT_REVOKE|\
 					 JFS_FEATURE_INCOMPAT_ASYNC_COMMIT|\
 					 JFS_FEATURE_INCOMPAT_64BIT|\
-					 JFS_FEATURE_INCOMPAT_CSUM_V2)
+					 JFS_FEATURE_INCOMPAT_CSUM_V2|\
+					 JFS_FEATURE_INCOMPAT_CSUM_V3)
 
 #if (defined(E2FSCK_INCLUDE_INLINE_FUNCS) || !defined(NO_INLINE_FUNCS))
 #ifdef E2FSCK_INCLUDE_INLINE_FUNCS
@@ -290,16 +301,29 @@ typedef struct journal_superblock_s
  */
 _INLINE_ size_t journal_tag_bytes(journal_t *journal)
 {
-	journal_block_tag_t tag;
-	size_t x = 0;
+	size_t sz;
+
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+		return sizeof(journal_block_tag3_t);
+
+	sz = sizeof(journal_block_tag_t);
 
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
-		x += sizeof(tag.t_checksum);
+		sz += sizeof(__u16);
 
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
-		return x + JBD_TAG_SIZE64;
-	else
-		return x + JBD_TAG_SIZE32;
+		return sz;
+
+	return sz - sizeof(__u32);
+}
+
+_INLINE_ int journal_has_csum_v2or3(journal_t *journal)
+{
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) ||
+	    JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+		return 1;
+
+	return 0;
 }
 #undef _INLINE_
 #endif
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index a1c5ba2..25dce9c 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -415,8 +415,10 @@ static void print_inline_journal_information(ext2_filsys fs)
 	if (jsb->s_feature_compat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
 		printf("%s", _("Journal checksum type:    crc32\n"));
-	if (jsb->s_feature_incompat &
-	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if ((jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V3)) ||
+	    (jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)))
 		printf(_("Journal checksum type:    %s\n"
 			 "Journal checksum:         0x%08x\n"),
 		       journal_checksum_type_str(jsb->s_checksum_type),
@@ -454,8 +456,10 @@ static void print_journal_information(ext2_filsys fs)
 	if (jsb->s_feature_compat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
 		printf("%s", _("Journal checksum type:    crc32\n"));
-	if (jsb->s_feature_incompat &
-	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if ((jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V3)) ||
+	    (jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)))
 		printf(_("Journal checksum type:    %s\n"
 			 "Journal checksum:         0x%08x\n"),
 		       journal_checksum_type_str(jsb->s_checksum_type),

