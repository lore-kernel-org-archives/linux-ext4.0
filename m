From: akpm@linux-foundation.org
Subject: + ext3-return-after-ext3_error-in-case-of-failures.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:29:15 -0700
Message-ID: <200710252129.l9PLTIjB024917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: return after ext3_error in case of failures
has been added to the -mm tree.  Its filename is
     ext3-return-after-ext3_error-in-case-of-failures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: return after ext3_error in case of failures
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This fixes some instances where we were continuing after calling
ext3_error.  ext3_error calls panic only if errors=panic mount option is
set.  So we need to make sure we return correctly after ext3_error call

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures
+++ a/fs/ext3/balloc.c
@@ -111,11 +111,13 @@ read_block_bitmap(struct super_block *sb
 		return NULL;
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_bread(sb, bitmap_blk);
-	if (!bh)
+	if (!bh) {
 		ext3_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -507,11 +509,13 @@ do_more:
 	    in_range (block, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group) ||
 	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group))
+		      sbi->s_itb_per_group)) {
 		ext3_error (sb, "ext3_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = "E3FSBLK", count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1614,11 +1618,13 @@ allocated:
 	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
 		      EXT3_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group))
+		      EXT3_SB(sb)->s_itb_per_group)) {
 		ext3_error(sb, "ext3_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext4-return-after-ext4_error-in-case-of-failures.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext2-fix-the-max-file-size-for-ext2-file-system.patch
ext3-fix-the-max-file-size-for-ext3-file-system.patch
