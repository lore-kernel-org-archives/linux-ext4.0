From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 47/50] e2fsck: Check commit block checksum during recovery
Date: Mon, 28 Nov 2011 16:33:18 -0800
Message-ID: <20111129003318.17953.83170.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:55786 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1K2AdZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:33:25 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:33:25 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0XN4N132430
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:33:23 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0XKhZ014952
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:33:23 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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

