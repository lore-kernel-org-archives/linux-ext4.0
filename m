From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: fix error processing in mb_free_blocks
Date: Thu, 29 May 2008 11:21:18 +0800
Message-ID: <483E212E.1020309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57743 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYE2DXu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 23:23:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The error processing of the return value of mb_free_blocks
is meanless because it only return 0. This fix includes
*make mb_free_blocks return void
*remove the error processing part in callers
*unlock group before calling ext4_error in mb_free_blocks

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a30a35d..6180ebc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1044,7 +1044,7 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 	}
 }
 
-static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
+static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
 	int block = 0;
@@ -1084,11 +1084,12 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
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
@@ -1126,8 +1127,6 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 		} while (1);
 	}
 	mb_check_buddy(e4b);
-
-	return 0;
 }
 
 static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
@@ -2561,8 +2560,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
 		ext4_lock_group(sb, md->group);
 		for (i = 0; i < md->num; i++) {
 			mb_debug(" %u", md->blocks[i]);
-			err = mb_free_blocks(NULL, &e4b, md->blocks[i], 1);
-			BUG_ON(err != 0);
+			mb_free_blocks(NULL, &e4b, md->blocks[i], 1);
 		}
 		mb_debug("\n");
 		ext4_unlock_group(sb, md->group);
@@ -4326,10 +4324,9 @@ do_more:
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
-- 
1.5.4.5
