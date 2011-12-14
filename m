From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 42/51] libext2fs: Change on-disk journal layout to support
	metadata checksumming
Date: Tue, 13 Dec 2011 17:17:55 -0800
Message-ID: <20111214011755.20947.16932.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48768 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab1LNBSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:18:09 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:18:08 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1Hwme303240
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:17:58 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1HufJ020627
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 23:17:58 -0200
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Define flags and change journal structure definitions to support v2 journal
checksumming.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/kernel-jbd.h |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 066c031..570bfa6 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -114,12 +114,24 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 
 #define JBD2_CHECKSUM_BYTES (32 / sizeof(__u32))
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
 	__u32		h_magic;
@@ -141,11 +153,17 @@ typedef struct journal_block_tag_s
 	__u32		t_blocknr;	/* The on-disk block number */
 	__u32		t_flags;	/* See below */
 	__u32		t_blocknr_high; /* most-significant high 32bits. */
+	__u32		t_checksum;	/* crc32c(uuid+seq+block) */
 } journal_block_tag_t;
 
 #define JBD_TAG_SIZE64 (sizeof(journal_block_tag_t))
 #define JBD_TAG_SIZE32 (8)
 
+/* Tail of descriptor block, for checksumming */
+struct journal_block_tail {
+	__u32		t_checksum;
+};
+
 /*
  * The revoke descriptor: used on disk to describe a series of blocks to
  * be revoked from the log
@@ -156,6 +174,10 @@ typedef struct journal_revoke_header_s
 	int		 r_count;	/* Count of bytes used in the block */
 } journal_revoke_header_t;
 
+/* Tail of revoke block, for checksumming */
+struct journal_revoke_tail {
+	__u32		r_checksum;
+};
 
 /* Definitions for the journal tag flags word: */
 #define JFS_FLAG_ESCAPE		1	/* on-disk block is escaped */
@@ -205,7 +227,10 @@ typedef struct journal_superblock_s
 	__u32	s_max_trans_data;	/* Limit of data blocks per trans. */
 
 /* 0x0050 */
-	__u32	s_padding[44];
+	__u8	s_checksum_type;	/* checksum type */
+	__u8	s_padding2[3];
+	__u32	s_padding[42];
+	__u32	s_checksum;		/* crc32c(superblock) */
 
 /* 0x0100 */
 	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
@@ -224,11 +249,10 @@ typedef struct journal_superblock_s
 
 #define JFS_FEATURE_COMPAT_CHECKSUM	0x00000001
 
-#define JFS_FEATURE_INCOMPAT_REVOKE	0x00000001
