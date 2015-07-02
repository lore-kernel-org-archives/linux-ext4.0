From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix fencepost error in lazytime optimization
Date: Wed,  1 Jul 2015 23:38:08 -0400
Message-ID: <1435808288-20665-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 8f4d8558391: "ext4: fix lazytime optimization" was not a
complete fix.  In the case where the inode number is a multiple of 16,
and we could still end up updating an inode with dirty timestamps
written to the wrong inode on disk.  Oops.

This can be easily reproduced by using generic/005 with a file system
with metadata_csum and lazytime enabled.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e057c6f..0b4dd57 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4348,7 +4348,7 @@ static void ext4_update_other_inodes_time(struct super_block *sb,
 	int inode_size = EXT4_INODE_SIZE(sb);
 
 	oi.orig_ino = orig_ino;
-	ino = (orig_ino & ~(inodes_per_block - 1)) + 1;
+	ino = ((orig_ino - 1) & ~(inodes_per_block - 1)) + 1;
 	for (i = 0; i < inodes_per_block; i++, ino++, buf += inode_size) {
 		if (ino == orig_ino)
 			continue;
-- 
2.3.0
