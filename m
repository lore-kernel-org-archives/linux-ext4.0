From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 37/37] e2fsck: Support CRC32c checksum in journal commit blocks
Date: Wed, 31 Aug 2011 17:39:08 -0700
Message-ID: <20110901003908.1176.88497.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53395 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab1IAAkb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:40:31 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 31 Aug 2011 20:40:31 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810dBma217122
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:39:11 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIcgoU012255
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:38:44 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The CRC32c polynomial provides better error detection and can be hardware
accelerated on newer machines.  To that end, support replaying transactions
with this checksum type.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/jfs_user.h       |    1 +
 e2fsck/recovery.c       |   19 ++++++++++++++++---
 lib/ext2fs/kernel-jbd.h |    1 +
 3 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 802f6e8..2f15c19 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -13,6 +13,7 @@
  * Pull in the definition of the e2fsck context structure
  */
 #include "e2fsck.h"
+#include "ext2fs/ext2fs.h"
 
 struct buffer_head {
 	e2fsck_t	b_ctx;
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index cac9294..2d4dd06 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -323,7 +323,8 @@ static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag
  * descriptor block.
  */
 static int calc_chksums(journal_t *journal, struct buffer_head *bh,
-			unsigned long *next_log_block, __u32 *crc32_sum)
+			unsigned long *next_log_block, __u32 *crc32_sum,
+			__u32 *crc32c_sum)
 {
 	int i, num_blks, err;
 	unsigned long io_block;
@@ -332,6 +333,7 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	num_blks = count_tags(journal, bh);
 	/* Calculate checksum of the descriptor block. */
 	*crc32_sum = crc32_be(*crc32_sum, (void *)bh->b_data, bh->b_size);
+	*crc32c_sum = crc32c_le(*crc32c_sum, (void *)bh->b_data, bh->b_size);
 
 	for (i = 0; i < num_blks; i++) {
 		io_block = (*next_log_block)++;
@@ -344,6 +346,9 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 		} else {
 			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
 				     obh->b_size);
+			*crc32c_sum = crc32c_le(*crc32c_sum,
+				     (void *)obh->b_data,
+				     obh->b_size);
 		}
 		brelse(obh);
 	}
@@ -363,6 +368,7 @@ static int do_one_pass(journal_t *journal,
 	int			blocktype;
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	__u32			crc32c_sum = ~0; /* Transactional Checksums */
 
 	/* Precompute the maximum metadata descriptors in a descriptor block */
 	int			MAX_BLOCKS_PER_DESC;
@@ -464,7 +470,8 @@ static int do_one_pass(journal_t *journal,
 				    !info->end_transaction) {
 					if (calc_chksums(journal, bh,
 							&next_log_block,
-							&crc32_sum)) {
+							&crc32_sum,
+							&crc32c_sum)) {
 						brelse(bh);
 						break;
 					}
@@ -627,7 +634,12 @@ static int do_one_pass(journal_t *journal,
 				    cbh->h_chksum_type == JBD2_CRC32_CHKSUM &&
 				    cbh->h_chksum_size ==
 						JBD2_CRC32_CHKSUM_SIZE)
-				       chksum_seen = 1;
+					chksum_seen = 1;
+				else if (crc32c_sum == found_chksum &&
+				    cbh->h_chksum_type == JBD2_CRC32C_CHKSUM &&
+				    cbh->h_chksum_size ==
+						JBD2_CRC32_CHKSUM_SIZE)
+					chksum_seen = 1;
 				else if (!(cbh->h_chksum_type == 0 &&
 					     cbh->h_chksum_size == 0 &&
 					     found_chksum == 0 &&
@@ -657,6 +669,7 @@ static int do_one_pass(journal_t *journal,
 					}
 				}
 				crc32_sum = ~0;
+				crc32c_sum = ~0;
 			}
 			brelse(bh);
 			next_commit_ID++;
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 066c031..7d92b56 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -114,6 +114,7 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 

