From: akpm@linux-foundation.org
Subject: [patch 2/4] ext4: fix error processing in mb_free_blocks
Date: Sat, 12 Jul 2008 23:26:20 -0700
Message-ID: <200807130626.m6D6QKtc007910@imap1.linux-foundation.org>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, shen@cn.fujitsu.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbYGMG1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 02:27:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

The error processing of the return value of mb_free_blocks is meanless
because it only returns 0.  This fix includes

- make mb_free_blocks return void

- remove the error processing part in callers

- unlock group before calling ext4_error in mb_free_blocks

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-fix-error-processing-in-mb_free_blocks fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fix-error-processing-in-mb_free_blocks
+++ a/fs/ext4/mballoc.c
@@ -1051,7 +1051,7 @@ static void mb_set_bits(spinlock_t *lock
 	}
 }
 
-static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
+static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
 	int block = 0;
@@ -1091,11 +1091,12 @@ static int mb_free_blocks(struct inode *
 			blocknr += block;
 			blocknr +=
 			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
-
+			ext4_unlock_group(sb, e4b->bd_group);
 			ext4_error(sb, __func__, "double-free of inode"
 				   " %lu's block %llu(bit %u in group %lu)\n",
 				   inode ? inode->i_ino : 0, blocknr, block,
 				   e4b->bd_group);
+			ext4_lock_group(sb, e4b->bd_group);
 		}
 		mb_clear_bit(block, EXT4_MB_BITMAP(e4b));
 		e4b->bd_info->bb_counters[order]++;
@@ -1133,8 +1134,6 @@ static int mb_free_blocks(struct inode *
 		} while (1);
 	}
 	mb_check_buddy(e4b);
-
-	return 0;
 }
 
 static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
@@ -2694,8 +2693,7 @@ ext4_mb_free_committed_blocks(struct sup
 		ext4_lock_group(sb, md->group);
 		for (i = 0; i < md->num; i++) {
 			mb_debug(" %u", md->blocks[i]);
-			err = mb_free_blocks(NULL, &e4b, md->blocks[i], 1);
-			BUG_ON(err != 0);
+			mb_free_blocks(NULL, &e4b, md->blocks[i], 1);
 		}
 		mb_debug("\n");
 		ext4_unlock_group(sb, md->group);
@@ -4488,10 +4486,9 @@ do_more:
 		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
 	} else {
 		ext4_lock_group(sb, block_group);
-		err = mb_free_blocks(inode, &e4b, bit, count);
+		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
 		ext4_unlock_group(sb, block_group);
-		BUG_ON(err != 0);
 	}
 
 	spin_lock(sb_bgl_lock(sbi, block_group));
_
