From: akpm@linux-foundation.org
Subject: - ext3-return-after-ext3_error-in-case-of-failures.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:40 -0800
Message-ID: <200802070030.m170ULUi007380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: return after ext3_error in case of failures
has been removed from the -mm tree.  Its filename was
     ext3-return-after-ext3_error-in-case-of-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 fs/ext3/balloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-return-after-ext3_error-in-case-of-failures
+++ a/fs/ext3/balloc.c
@@ -530,11 +530,13 @@ do_more:
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
@@ -1637,11 +1639,13 @@ allocated:
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

origin.patch
