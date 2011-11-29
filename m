From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 48/50] e2fsck: Verify data block checksums when recovering
	journal
Date: Mon, 28 Nov 2011 16:33:25 -0800
Message-ID: <20111129003325.17953.78225.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56173 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1K2Adh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:33:37 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:33:36 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0XSdb2756750
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:33:28 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0XQWx006914
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 22:33:27 -0200
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check the data block checksums when recovering the journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/jfs_user.h       |   11 -----------
 e2fsck/recovery.c       |   32 ++++++++++++++++++++++++++++++++
 lib/ext2fs/kernel-jbd.h |   31 +++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 11 deletions(-)


diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 9e33306..4baba54 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -104,17 +104,6 @@ _INLINE_ void do_cache_destroy(lkmem_cache_t *cache)
 	free(cache);
 }
 
-/*
- * helper functions to deal with 32 or 64bit block numbers.
- */
-_INLINE_ size_t journal_tag_bytes(journal_t *journal)
-{
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
-		return JBD_TAG_SIZE64;
-	else
-		return JBD_TAG_SIZE32;
-}
-
 #undef _INLINE_
 #endif
 
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index beafacc..5cda381 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -395,6 +395,25 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 	return provided == calculated;
 }
 
+static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
+				      void *buf, __u32 sequence)
+{
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	sequence = ext2fs_cpu_to_be32(sequence);
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, (__u8 *)&sequence,
+				      sizeof(sequence));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	provided = ext2fs_be32_to_cpu(tag->t_checksum);
+
+	return provided == ext2fs_cpu_to_be32(calculated);
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -575,6 +594,19 @@ static int do_one_pass(journal_t *journal,
 						goto skip_write;
 					}
 
+					/* Look for block corruption */
+					if (!jbd2_block_tag_csum_verify(
+						journal, tag, obh->b_data,
+						be32_to_cpu(tmp->h_sequence))) {
+						brelse(obh);
+						success = -EIO;
+						printk(KERN_ERR "JBD: Invalid "
+						       "checksum recovering "
+						       "block %ld in log\n",
+						       blocknr);
+						continue;
+					}
+
 					/* Find a buffer for the new
 					 * data being restored */
 					nbh = __getblk(journal->j_fs_dev,
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index c650582..a86150c 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -153,6 +153,7 @@ typedef struct journal_block_tag_s
 	__u32		t_blocknr;	/* The on-disk block number */
 	__u32		t_flags;	/* See below */
 	__u32		t_blocknr_high; /* most-significant high 32bits. */
+	__u32		t_checksum;	/* crc32c(uuid+seq+block) */
 } journal_block_tag_t;
 
 #define JBD_TAG_SIZE64 (sizeof(journal_block_tag_t))
@@ -261,6 +262,36 @@ typedef struct journal_superblock_s
 					 JFS_FEATURE_INCOMPAT_64BIT|\
 					 JFS_FEATURE_INCOMPAT_CSUM_V2)
 
+#if (defined(E2FSCK_INCLUDE_INLINE_FUNCS) || !defined(NO_INLINE_FUNCS))
+#ifdef E2FSCK_INCLUDE_INLINE_FUNCS
+#define _INLINE_ extern
+#else
+#ifdef __GNUC__
+#define _INLINE_ extern __inline__
+#else				/* For Watcom C */
+#define _INLINE_ extern inline
+#endif
+#endif
+
+/*
+ * helper functions to deal with 32 or 64bit block numbers.
+ */
+_INLINE_ size_t journal_tag_bytes(journal_t *journal)
+{
+	journal_block_tag_t tag;
+	size_t x = 0;
+
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		x += sizeof(tag.t_checksum);
+
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
+		return x + JBD_TAG_SIZE64;
+	else
+		return x + JBD_TAG_SIZE32;
+}
+#undef _INLINE_
+#endif
+
 #ifdef __KERNEL__
 
 #include <linux/fs.h>

