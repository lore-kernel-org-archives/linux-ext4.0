From: Liu Song <liu.song11@zte.com.cn>
Subject: [PATCH] Improve code readability
Date: Tue, 31 Jul 2018 14:15:15 +0800
Message-ID: <1533017715-122171-1-git-send-email-liu.song11@zte.com.cn>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liu.song11@zte.com.cn, jiang.biao2@zte.com.cn,
        zhong.weidong@zte.com.cn
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Merge the duplicated complex conditions to improve code readability.

Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
---
 fs/ext4/inode.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7d6c100..c2bc1fd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4946,17 +4946,15 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	} else if (!ext4_has_inline_data(inode)) {
-		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-			if ((S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-			    (S_ISLNK(inode->i_mode) &&
-			     !ext4_inode_is_fast_symlink(inode))))
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		   (S_ISLNK(inode->i_mode) &&
+		    !ext4_inode_is_fast_symlink(inode))) {
+			if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 				/* Validate extent which is part of inode */
 				ret = ext4_ext_check_inode(inode);
-		} else if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-			   (S_ISLNK(inode->i_mode) &&
-			    !ext4_inode_is_fast_symlink(inode))) {
+			else
 			/* Validate block references which are part of inode */
-			ret = ext4_ind_check_inode(inode);
+				ret = ext4_ind_check_inode(inode);
 		}
 	}
 	if (ret)
-- 
1.8.3.1
