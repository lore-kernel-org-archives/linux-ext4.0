From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 15/23] jbd2: Change disk layout for metadata checksumming
Date: Sat, 07 Jan 2012 00:29:32 -0800
Message-ID: <20120107082932.21970.56787.stgit@elm3c44.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Define flags and allocate space in on-disk journal structures to support
checksumming of journal metadata.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 include/linux/jbd2.h |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)


diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2092ea2..ecd9b45 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -147,12 +147,24 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 
 #define JBD2_CHECKSUM_BYTES (32 / sizeof(u32))
 /*
  * Commit block header for storing transactional checksums:
+ *
+ * NOTE: If FEATURE_COMPAT_CHECKSUM (checksum v1) is set, the h_chksum*
+ * fields are used to store a checksum of the descriptor and data blocks.
+ *
+ * If FEATURE_INCOMPAT_CSUM_V2 (checksum v2) is set, then the h_chksum
+ * field is used to store crc32c(uuid+commit_block).  Each journal metadata
+ * block gets its own checksum, and data block checksums are stored in
+ * journal_block_tag (in the descriptor).  The other h_chksum* fields are
+ * not used.
+ *
+ * Checksum v1 and v2 are mutually exclusive features.
  */
 struct commit_header {
 	__be32		h_magic;
@@ -177,11 +189,17 @@ typedef struct journal_block_tag_s
 	__be32		t_blocknr;	/* The on-disk block number */
 	__be32		t_flags;	/* See below */
 	__be32		t_blocknr_high; /* most-significant high 32bits. */
+	__be32		t_checksum;	/* crc32c(uuid+seq+block) */
 } journal_block_tag_t;
 
 #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
 #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))
 
+/* Tail of descriptor block, for checksumming */
+struct jbd2_journal_block_tail {
+	__be32		t_checksum;	/* crc32c(uuid+descr_block) */
+};
+
 /*
  * The revoke descriptor: used on disk to describe a series of blocks to
  * be revoked from the log
@@ -192,6 +210,10 @@ typedef struct jbd2_journal_revoke_header_s
 	__be32		 r_count;	/* Count of bytes used in the block */
 } jbd2_journal_revoke_header_t;
 
+/* Tail of revoke block, for checksumming */
+struct jbd2_journal_revoke_tail {
+	__be32		r_checksum;	/* crc32c(uuid+revoke_block) */
+};
 
 /* Definitions for the journal tag flags word: */
 #define JBD2_FLAG_ESCAPE		1	/* on-disk block is escaped */
@@ -241,7 +263,10 @@ typedef struct journal_superblock_s
 	__be32	s_max_trans_data;	/* Limit of data blocks per trans. */
 
 /* 0x0050 */
-	__u32	s_padding[44];
+	__u8	s_checksum_type;	/* checksum type */
+	__u8	s_padding2[3];
+	__u32	s_padding[42];
+	__be32	s_checksum;		/* crc32c(superblock) */
 
 /* 0x0100 */
 	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
@@ -263,6 +288,7 @@ typedef struct journal_superblock_s
 #define JBD2_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JBD2_FEATURE_INCOMPAT_64BIT		0x00000002
 #define JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT	0x00000004
+#define JBD2_FEATURE_INCOMPAT_CSUM_V2		0x00000008
 
 /* Features known to this kernel version: */
 #define JBD2_KNOWN_COMPAT_FEATURES	JBD2_FEATURE_COMPAT_CHECKSUM
