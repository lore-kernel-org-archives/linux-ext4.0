From: akpm@linux-foundation.org
Subject: - ext4-return-after-ext4_error-in-case-of-failures.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:49 -0700
Message-ID: <200710261848.l9QImnGi009171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, bunk@kernel.org,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: return after ext4_error in case of failures
has been removed from the -mm tree.  Its filename was
     ext4-return-after-ext4_error-in-case-of-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: return after ext4_error in case of failures
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This fix some instances where we were continuing after calling ext4_error. 
ext4_error call panic only if errors=panic mount option is set.  So we need to
make sure we return correctly after ext4_error call

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-return-after-ext4_error-in-case-of-failures fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-return-after-ext4_error-in-case-of-failures
+++ a/fs/ext4/balloc.c
@@ -234,11 +234,13 @@ read_block_bitmap(struct super_block *sb
 	} else {
 		bh = sb_bread(sb, bitmap_blk);
 	}
-	if (!bh)
+	if (!bh) {
 		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -630,11 +632,13 @@ do_more:
 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group))
+		     sbi->s_itb_per_group)) {
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1745,11 +1749,13 @@ allocated:
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
-		     EXT4_SB(sb)->s_itb_per_group))
+		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
