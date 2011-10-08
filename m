From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 46/47] e2fsck: Check commit block checksum during recovery
Date: Sat, 08 Oct 2011 00:38:09 -0700
Message-ID: <20111008073809.17888.72414.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49858 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1JHHkf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:40:35 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:40:34 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987cCdg233362
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:38:12 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987cBfE010707
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:38:12 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When recovering a journal with checksum v2, verify the commit block checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c       |   33 +++++++++++++++++++++++++++++++++
 lib/ext2fs/kernel-jbd.h |   11 +++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index a192378..beafacc 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -375,6 +375,26 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	return 0;
 }
 
+static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
+{
+	struct commit_header *h;
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	h = buf;
+	provided = h->h_chksum[0];
+	h->h_chksum[0] = 0;
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	h->h_chksum[0] = provided;
+
+	provided = ext2fs_be32_to_cpu(provided);
+	return provided == calculated;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -696,6 +716,19 @@ static int do_one_pass(journal_t *journal,
 				}
 				crc32_sum = ~0;
 			}
+			if (pass == PASS_SCAN &&
+			    !jbd2_commit_block_csum_verify(journal,
+							   bh->b_data)) {
+				info->end_transaction = next_commit_ID;
+
+				if (!JFS_HAS_INCOMPAT_FEATURE(journal,
+				     JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+					journal->j_failed_commit =
+						next_commit_ID;
+					brelse(bh);
+					break;
+				}
+			}
 			brelse(bh);
 			next_commit_ID++;
 			continue;
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index b79eed5..c650582 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -121,6 +121,17 @@ typedef struct journal_header_s
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

