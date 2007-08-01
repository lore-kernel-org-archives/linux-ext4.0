From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: [EXT4 set 8][PATCH 1/1]Add journal checksums
Date: Wed, 01 Aug 2007 12:34:17 +0530
Message-ID: <1185951857.3875.6.camel@dhcp4.linsyssoft.com>
References: <1183275505.4010.136.camel@localhost.localdomain>
	 <20070710231601.798304e0.akpm@linux-foundation.org>
	 <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kakK77po6F6ah0VxkqG2"
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:44611 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXHAHDM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 03:03:12 -0400
In-Reply-To: <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-kakK77po6F6ah0VxkqG2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-07-11 at 17:16 +0530, Girish Shilamkar wrote:

> I will make the changes and send an incremental patch.
> 
Hi,
	I have made the changes and attached the incremental patch as per the
review.

This is the actual changelog which was missing in the original patch.

------
The journal checksum feature adds two new flags i.e 
JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT and JBD2_FEATURE_COMPAT_CHECKSUM.

JBD2_FEATURE_CHECKSUM flag indicates that the commit block contains the
checksum for the blocks described by the descriptor blocks.
Due to checksums, writing of the commit record no longer needs to be
synchronous. Now commit record can be sent to disk without waiting for
descriptor blocks to be written to disk. This behavior is controlled
using JBD2_FEATURE_ASYNC_COMMIT flag. Older kernels/e2fsck should not be
able to recover the journal with _ASYNC_COMMIT hence it is made
incompat.
The commit header has been extended to hold the checksum along with the
type of the checksum.

For recovery in pass scan checksums are verified to ensure the sanity
and completeness(in case of _ASYNC_COMMIT) of every transaction.
-----

Thanks & Regards,
Girish. 


--=-kakK77po6F6ah0VxkqG2
Content-Disposition: attachment; filename=jrnl-chksum-fix-review.patch
Content-Type: text/x-patch; name=jrnl-chksum-fix-review.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>

Index: linux-2.6.22/Documentation/filesystems/ext4.txt
===================================================================
--- linux-2.6.22.orig/Documentation/filesystems/ext4.txt
+++ linux-2.6.22/Documentation/filesystems/ext4.txt
@@ -89,6 +89,16 @@ When mounting an ext4 filesystem, the fo
 extents			ext4 will use extents to address file data.  The
 			file system will no longer be mountable by ext3.
 
+journal_checksum	Enable checksumming of the journal transactions.
+			This will allow the recovery code in e2fsck and the
+			kernel to detect corruption in the kernel.  It is a 
+			compatible change and will be ignored by older kernels.
+
+journal_async_commit	Commit block can be written to disk without waiting 
+			for descriptor blocks. If enabled older kernels cannot
+			mount the device. This will enable 'journal_checksum'
+			internally.
+
 journal=update		Update the ext4 file system's journal to the current
 			format.
 
Index: linux-2.6.22/fs/Kconfig
===================================================================
--- linux-2.6.22.orig/fs/Kconfig
+++ linux-2.6.22/fs/Kconfig
@@ -235,6 +235,7 @@ config JBD_DEBUG
 
 config JBD2
 	tristate
+	select CRC32
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
Index: linux-2.6.22/fs/jbd2/commit.c
===================================================================
--- linux-2.6.22.orig/fs/jbd2/commit.c
+++ linux-2.6.22/fs/jbd2/commit.c
@@ -108,8 +108,9 @@ static int journal_submit_commit_record(
 					__u32 crc32_sum)
 {
 	struct journal_head *descriptor;
+	struct commit_header *tmp;
 	struct buffer_head *bh;
-	int i, ret;
+	int ret;
 	int barrier_done = 0;
 
 	if (is_journal_aborted(journal))
@@ -121,19 +122,16 @@ static int journal_submit_commit_record(
 
 	bh = jh2bh(descriptor);
 
-	for (i = 0; i < bh->b_size; i += 512) {
-		struct commit_header *tmp =
-			(struct commit_header *)(bh->b_data + i);
-		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
-		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
-		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
-
-		if (JBD2_HAS_COMPAT_FEATURE(journal,
-					    JBD2_FEATURE_COMPAT_CHECKSUM)) {
-			tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
-			tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
-			tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
-		}
+	tmp = (struct commit_header *)bh->b_data;
+	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
+	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
+	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
+
+	if (JBD2_HAS_COMPAT_FEATURE(journal,
+				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
+		tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
+		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
+		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
 	}
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
@@ -185,8 +183,8 @@ static int journal_wait_on_commit_record
 {
 	int ret = 0;
 
-	if (buffer_locked(bh))
-		wait_on_buffer(bh);
+	clear_buffer_dirty(bh);
+	wait_on_buffer(bh);
 
 	if (unlikely(!buffer_uptodate(bh)))
 		ret = -EIO;
Index: linux-2.6.22/fs/jbd2/recovery.c
===================================================================
--- linux-2.6.22.orig/fs/jbd2/recovery.c
+++ linux-2.6.22/fs/jbd2/recovery.c
@@ -318,14 +318,14 @@ static inline unsigned long long read_ta
 }
 
 /*
- * cal_chksums calculates the checksums for the blocks described in the
+ * calc_chksums calculates the checksums for the blocks described in the
  * descriptor block.
  */
-static int cal_chksums(journal_t *journal, struct buffer_head *bh,
-		       unsigned long *next_log_block, __u32 *crc32_sum)
+static int calc_chksums(journal_t *journal, struct buffer_head *bh,
+			unsigned long *next_log_block, __u32 *crc32_sum)
 {
 	int i, num_blks, err;
-	unsigned long io_block;
+	unsigned io_block;
 	struct buffer_head *obh;
 
 	num_blks = count_tags(journal, bh);
@@ -338,7 +338,7 @@ static int cal_chksums(journal_t *journa
 		err = jread(&obh, journal, io_block);
 		if (err) {
 			printk(KERN_ERR "JBD: IO error %d recovering block "
-				"%ld in log\n", err, io_block);
+				"%u in log\n", err, io_block);
 			return 1;
 		} else {
 			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
@@ -460,7 +460,7 @@ static int do_one_pass(journal_t *journa
 				    JBD2_HAS_COMPAT_FEATURE(journal,
 					    JBD2_FEATURE_COMPAT_CHECKSUM) &&
 				    !info->end_transaction) {
-					if (cal_chksums(journal, bh,
+					if (calc_chksums(journal, bh,
 							&next_log_block,
 							&crc32_sum)) {
 						brelse(bh);
@@ -601,11 +601,14 @@ static int do_one_pass(journal_t *journa
 			if (pass == PASS_SCAN &&
 			    JBD2_HAS_COMPAT_FEATURE(journal,
 				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
+				int chksum_err, chksum_seen;
 				struct commit_header *cbh =
 					(struct commit_header *)bh->b_data;
 				unsigned found_chksum =
 					be32_to_cpu(cbh->h_chksum[0]);
 
+				chksum_err = chksum_seen = 0;
+
 				if (info->end_transaction) {
 					printk(KERN_ERR "JBD: Transaction %u "
 						"found to be corrupt.\n",
@@ -614,7 +617,29 @@ static int do_one_pass(journal_t *journa
 					break;
 				}
 
-				if (crc32_sum != found_chksum) {
+				if (crc32_sum == found_chksum &&
+				    cbh->h_chksum_type == JBD2_CRC32_CHKSUM &&
+				    cbh->h_chksum_size ==
+						JBD2_CRC32_CHKSUM_SIZE) {
+				       chksum_seen = 1;
+				} else if (!(cbh->h_chksum_type == 0 &&
+					     cbh->h_chksum_size == 0 &&
+					     found_chksum == 0 &&
+					     !chksum_seen)) {
+				/*
+				 * If fs is mounted using an old kernel and then
+				 * kernel with journal_chksum is used then we
+				 * get a situation where the journal flag has
+				 * checksum flag set but checksums are not
+				 * present i.e chksum = 0, in the individual
+				 * commit blocks.
+				 * Hence to avoid checksum failures, in this
+				 * situation, this extra check is added.
+				 */
+						chksum_err = 1;
+				}
+
+				if (chksum_err) {
 					info->end_transaction = next_commit_ID;
 
 					if (!JBD2_HAS_COMPAT_FEATURE(journal,
Index: linux-2.6.22/fs/jbd2/journal.c
===================================================================
--- linux-2.6.22.orig/fs/jbd2/journal.c
+++ linux-2.6.22/fs/jbd2/journal.c
@@ -1582,8 +1582,9 @@ int jbd2_journal_set_features (journal_t
 	return 1;
 }
 
-/**
- * int jbd2_journal_clear_features () - Clear a given journal feature in the superblock
+/*
+ * jbd2_journal_clear_features () - Clear a given journal feature in the
+ * 				    superblock
  * @journal: Journal to act on.
  * @compat: bitmask of compatible features
  * @ro: bitmask of features that force read-only mount
@@ -1591,10 +1592,9 @@ int jbd2_journal_set_features (journal_t
  *
  * Clear a given journal feature as present on the
  * superblock.  Returns true if the requested features could be reset.
- *
  */
-int jbd2_journal_clear_features (journal_t *journal, unsigned long compat,
-			  unsigned long ro, unsigned long incompat)
+int jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
+				unsigned long ro, unsigned long incompat)
 {
 	journal_superblock_t *sb;
 

--=-kakK77po6F6ah0VxkqG2--
