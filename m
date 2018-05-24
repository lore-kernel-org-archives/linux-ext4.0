From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Forbid overflowing inode count when resizing
Date: Thu, 24 May 2018 13:36:46 +0200
Message-ID: <20180524113646.3859-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jaco Kroon <jaco@uls.co.za>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_resize_fs() has an off-by-one bug when checking whether growing of
a filesystem will not overflow inode count. As a result it allows a
filesystem with 8192 inodes per group to grow to 64TB which overflows
inode count to 0 and makes filesystem unusable. Fix it.

CC: stable@vger.kernel.org
Fixes: 3f8a6411fbada1fa482276591e037f3b1adcf55b
Reported-by: Jaco Kroon <jaco@uls.co.za>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b6bec270a8e4..d792b7689d92 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1933,7 +1933,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		return 0;
 
 	n_group = ext4_get_group_number(sb, n_blocks_count - 1);
-	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+	if (n_group >= (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
 		ext4_warning(sb, "resize would cause inodes_count overflow");
 		return -EINVAL;
 	}
-- 
2.13.6
