From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Fix debug messages in ext3_group_extend()
Date: Sun, 17 Oct 2010 01:11:23 +0900
Message-ID: <1287245483-3557-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix a typo, break long lines and use E3FSBLK on ext3_fsblk_t.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/resize.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 0ccd7b1..e746d30 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -977,7 +977,8 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 	o_blocks_count = le32_to_cpu(es->s_blocks_count);
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT3-fs: extending last group from "E3FSBLK" uto "E3FSBLK" blocks\n",
+		printk(KERN_DEBUG "EXT3-fs: extending last group from "E3FSBLK
+		       " upto "E3FSBLK" blocks\n",
 		       o_blocks_count, n_blocks_count);
 
 	if (n_blocks_count == 0 || n_blocks_count == o_blocks_count)
@@ -985,7 +986,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 
 	if (n_blocks_count > (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
 		printk(KERN_ERR "EXT3-fs: filesystem on %s:"
-			" too large to resize to %lu blocks safely\n",
+			" too large to resize to "E3FSBLK" blocks safely\n",
 			sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
 			ext3_warning(sb, __func__,
@@ -1065,11 +1066,11 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 	es->s_blocks_count = cpu_to_le32(o_blocks_count + add);
 	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
 	mutex_unlock(&EXT3_SB(sb)->s_resize_lock);
-	ext3_debug("freeing blocks %lu through "E3FSBLK"\n", o_blocks_count,
-		   o_blocks_count + add);
+	ext3_debug("freeing blocks "E3FSBLK" through "E3FSBLK"\n",
+		   o_blocks_count, o_blocks_count + add);
 	ext3_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
-	ext3_debug("freed blocks "E3FSBLK" through "E3FSBLK"\n", o_blocks_count,
-		   o_blocks_count + add);
+	ext3_debug("freed blocks "E3FSBLK" through "E3FSBLK"\n",
+		   o_blocks_count, o_blocks_count + add);
 	if ((err = ext3_journal_stop(handle)))
 		goto exit_put;
 	if (test_opt(sb, DEBUG))
-- 
1.7.0.4
