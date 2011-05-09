From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 29/30] ext4: snapshot cleanup - shrink deleted snapshots
Date: Mon,  9 May 2011 19:41:47 +0300
Message-ID: <1304959308-11122-30-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1EIQof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:35 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:34 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Free blocks of deleted snapshots, which are not in use by an older
non-deleted snapshot.  Shrinking helps reclaiming disk space
while older snapshots are currently in use (enabled).
We modify the indirect inode truncate helper functions so that they
can be used by the snapshot cleanup functions to free blocks
selectively according to a COW bitmap buffer.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |   10 ++++++++++
 fs/ext4/inode.c |   51 +++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7650515..07629ce 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1905,6 +1905,16 @@ extern void ext4_free_branches(handle_t *handle, struct inode *inode,
 				struct buffer_head *parent_bh,
 				__le32 *first, __le32 *last,
 				int depth);
+extern void ext4_free_data_cow(handle_t *handle, struct inode *inode,
+			   struct buffer_head *this_bh,
+			   __le32 *first, __le32 *last,
+			   const char *bitmap, int bit,
+			   int *pfreed_blocks);
+
+#define ext4_free_data(handle, inode, bh, first, last)		\
+	ext4_free_data_cow(handle, inode, bh, first, last,	\
+			    NULL, 0, NULL)
+
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d46da6a..e3bfee2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4546,11 +4546,15 @@ no_top:
  * Return 0 on success, 1 on invalid block range
  * and < 0 on fatal error.
  */
-static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
-			     struct buffer_head *bh,
-			     ext4_fsblk_t block_to_free,
-			     unsigned long count, __le32 *first,
-			     __le32 *last)
+/*
+ * ext4_clear_blocks_cow - Zero a number of block pointers (consult COW bitmap)
+ * @bitmap:	COW bitmap to consult when shrinking deleted snapshot
+ * @bit:	bit number representing the @first block
+ */
+static int ext4_clear_blocks_cow(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_fsblk_t block_to_free,
+		unsigned long count, __le32 *first, __le32 *last,
+		const char *bitmap, int bit)
 {
 	__le32 *p;
 	int	flags = EXT4_FREE_BLOCKS_FORGET | EXT4_FREE_BLOCKS_VALIDATED;
@@ -4590,8 +4594,12 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	for (p = first; p < last; p++)
+	for (p = first; p < last; p++) {
+		if (*p && bitmap && ext4_test_bit(bit + (p - first), bitmap))
+			/* don't free block used by older snapshot */
+			continue;
 		*p = 0;
+	}
 
 	ext4_free_blocks(handle, inode, NULL, block_to_free, count, flags);
 	return 0;
@@ -4619,9 +4627,17 @@ out_err:
  * @this_bh will be %NULL if @first and @last point into the inode's direct
  * block pointers.
  */
-static void ext4_free_data(handle_t *handle, struct inode *inode,
+/*
+ * ext4_free_data_cow - free a list of data blocks (consult COW bitmap)
+ * @bitmap:	   COW bitmap to consult when shrinking deleted snapshot
+ * @bit:	   bit number representing the @first block
+ * @pfreed_blocks: return number of freed blocks
+ */
+void ext4_free_data_cow(handle_t *handle, struct inode *inode,
 			   struct buffer_head *this_bh,
-			   __le32 *first, __le32 *last)
+			   __le32 *first, __le32 *last,
+			   const char *bitmap, int bit,
+			   int *pfreed_blocks)
 {
 	ext4_fsblk_t block_to_free = 0;    /* Starting block # of a run */
 	unsigned long count = 0;	    /* Number of blocks in the run */
@@ -4645,6 +4661,11 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 
 	for (p = first; p < last; p++) {
 		nr = le32_to_cpu(*p);
+		if (nr && bitmap && ext4_test_bit(bit + (p - first), bitmap))
+			/* don't free block used by older snapshot */
+			nr = 0;
+		if (nr && pfreed_blocks)
+			++(*pfreed_blocks);
 		if (nr) {
 			/* accumulate blocks to free if they're contiguous */
 			if (count == 0) {
@@ -4654,9 +4675,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 			} else if (nr == block_to_free + count) {
 				count++;
 			} else {
-				err = ext4_clear_blocks(handle, inode, this_bh,
-						        block_to_free, count,
-						        block_to_free_p, p);
+				err = ext4_clear_blocks_cow(handle, inode,
+					       this_bh, block_to_free, count,
+					       block_to_free_p, p, bitmap,
+					       bit + (block_to_free_p - first));
 				if (err)
 					break;
 				block_to_free = nr;
@@ -4666,9 +4688,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	if (!err && count > 0)
-		err = ext4_clear_blocks(handle, inode, this_bh, block_to_free,
-					count, block_to_free_p, p);
+	if (count > 0)
+		err = ext4_clear_blocks_cow(handle, inode, this_bh,
+				block_to_free, count, block_to_free_p, p,
+				bitmap, bit + (block_to_free_p - first));
 	if (err < 0)
 		/* fatal error */
 		return;
-- 
1.7.0.4

