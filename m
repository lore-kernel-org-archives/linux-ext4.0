Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46106 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbeJ3AhD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:37:03 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 1/7] ext4 resise: extra brelse in
 setup_new_flex_group_blocks()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <yangyongqiang01@baidu.com>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>
Message-ID: <5d2aaeac-2a28-365d-808f-eae2e42218c9@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:04 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

currently bh is set to NULL only during first iteration of for cycle,
then this pointer is not cleared after end of using.
Therefore rollback after errors can lead to extra brelse(bh) call,
decrements bh counter and later trigger an unexpected warning in __brelse()

Patch moves brelse() calls in body of cycle to exclude requirement of
brelse() call in rollback.

Fixes 33afdcc5402d ("ext4: add a function which sets up group blocks ...")
#? cc: stable@vger.kernel.org # 3.3+

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ebbc663d0798..c3fa30878ca8 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -605,7 +605,6 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
-			bh = NULL;
 			goto out;
 		}
 		overhead = ext4_group_overhead_blocks(sb, group);
@@ -618,9 +617,9 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		ext4_mark_bitmap_end(EXT4_B2C(sbi, group_data[i].blocks_count),
 				     sb->s_blocksize * 8, bh->b_data);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
+		brelse(bh);
 		if (err)
 			goto out;
-		brelse(bh);
 
 handle_ib:
 		if (bg_flags[i] & EXT4_BG_INODE_UNINIT)
@@ -635,18 +634,16 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
-			bh = NULL;
 			goto out;
 		}
 
 		ext4_mark_bitmap_end(EXT4_INODES_PER_GROUP(sb),
 				     sb->s_blocksize * 8, bh->b_data);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
+		brelse(bh);
 		if (err)
 			goto out;
-		brelse(bh);
 	}
-	bh = NULL;
 
 	/* Mark group tables in block bitmap */
 	for (j = 0; j < GROUP_TABLE_COUNT; j++) {
@@ -685,7 +682,6 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	}
 
 out:
-	brelse(bh);
 	err2 = ext4_journal_stop(handle);
 	if (err2 && !err)
 		err = err2;
-- 
2.17.1
