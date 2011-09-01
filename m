From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 16/16] jbd2: Support CRC32C transaction checksums
Date: Wed, 31 Aug 2011 17:32:24 -0700
Message-ID: <20110901003224.31048.33516.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
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
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The CRC32c polynomial provides better error detection and can be hardware
accelerated on certain machines.  To that end, add support for it to jbd2.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/Kconfig      |    1 +
 fs/jbd2/commit.c     |    6 +++---
 fs/jbd2/recovery.c   |   20 +++++++++++++++++---
 include/linux/jbd2.h |    1 +
 4 files changed, 22 insertions(+), 6 deletions(-)


diff --git a/fs/jbd2/Kconfig b/fs/jbd2/Kconfig
index f32f346..40a126b 100644
--- a/fs/jbd2/Kconfig
+++ b/fs/jbd2/Kconfig
@@ -1,6 +1,7 @@
 config JBD2
 	tristate
 	select CRC32
+	select LIBCRC32C
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index eef6979..00387be 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -21,7 +21,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
-#include <linux/crc32.h>
+#include <linux/crc32c.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
@@ -125,7 +125,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	if (JBD2_HAS_COMPAT_FEATURE(journal,
 				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
-		tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
+		tmp->h_chksum_type	= JBD2_CRC32C_CHKSUM;
 		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
 		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
 	}
@@ -287,7 +287,7 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 	__u32 checksum;
 
 	addr = kmap_atomic(page, KM_USER0);
-	checksum = crc32_be(crc32_sum,
+	checksum = crc32c_le(crc32_sum,
 		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
 	kunmap_atomic(addr, KM_USER0);
 
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 1cad869..4bab4dd 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -21,6 +21,7 @@
 #include <linux/jbd2.h>
 #include <linux/errno.h>
 #include <linux/crc32.h>
+#include <linux/crc32c.h>
 #endif
 
 /*
@@ -323,7 +324,8 @@ static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag
  * descriptor block.
  */
 static int calc_chksums(journal_t *journal, struct buffer_head *bh,
-			unsigned long *next_log_block, __u32 *crc32_sum)
+			unsigned long *next_log_block, __u32 *crc32_sum,
+			__u32 *crc32c_sum)
 {
 	int i, num_blks, err;
 	unsigned long io_block;
@@ -332,6 +334,7 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	num_blks = count_tags(journal, bh);
 	/* Calculate checksum of the descriptor block. */
 	*crc32_sum = crc32_be(*crc32_sum, (void *)bh->b_data, bh->b_size);
+	*crc32c_sum = crc32c_le(*crc32c_sum, (void *)bh->b_data, bh->b_size);
 
 	for (i = 0; i < num_blks; i++) {
 		io_block = (*next_log_block)++;
@@ -344,6 +347,9 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 		} else {
 			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
 				     obh->b_size);
+			*crc32c_sum = crc32c_le(*crc32c_sum,
+				     (void *)obh->b_data,
+				     obh->b_size);
 		}
 		put_bh(obh);
 	}
@@ -363,6 +369,7 @@ static int do_one_pass(journal_t *journal,
 	int			blocktype;
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
+	__u32			crc32c_sum = ~0; /* Transactional Checksums */
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -459,7 +466,8 @@ static int do_one_pass(journal_t *journal,
 				    !info->end_transaction) {
 					if (calc_chksums(journal, bh,
 							&next_log_block,
-							&crc32_sum)) {
+							&crc32_sum,
+							&crc32c_sum)) {
 						put_bh(bh);
 						break;
 					}
@@ -617,7 +625,12 @@ static int do_one_pass(journal_t *journal,
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
@@ -646,6 +659,7 @@ static int do_one_pass(journal_t *journal,
 					}
 				}
 				crc32_sum = ~0;
+				crc32c_sum = ~0;
 			}
 			brelse(bh);
 			next_commit_ID++;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 38f307b..de3ec23 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -147,6 +147,7 @@ typedef struct journal_header_s
 #define JBD2_CRC32_CHKSUM   1
 #define JBD2_MD5_CHKSUM     2
 #define JBD2_SHA1_CHKSUM    3
+#define JBD2_CRC32C_CHKSUM  4
 
 #define JBD2_CRC32_CHKSUM_SIZE 4
 
