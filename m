From: Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] ext4: Fixed corruption when online resizing a fs with 1K block size
Date: Mon,  6 May 2013 18:06:07 +0200
Message-ID: <1367856367-15924-1-git-send-email-maarten@treewalker.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Maarten ter Huurne <maarten@treewalker.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subtracting the number of the first data block places the superblock
backups one block too early, corrupting the file system. When the block
size is larger than 1K, the first data block is 0, so the subtraction
has no effect and no corruption occurs.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 fs/ext4/resize.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c169477..116c80d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1654,12 +1654,10 @@ errout:
 		err = err2;
 
 	if (!err) {
-		ext4_fsblk_t first_block;
-		first_block = ext4_group_first_block_no(sb, 0);
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr - first_block,
+		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;
-- 
1.7.10.4
