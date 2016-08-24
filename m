From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/6 linux-next] ext4: remove unneeded test in ext4_alloc_file_blocks()
Date: Wed, 24 Aug 2016 22:03:16 +0200
Message-ID: <1472069000-18897-3-git-send-email-fabf@skynet.be>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_alloc_file_blocks() is called from ext4_zero_range() and
ext4_fallocate() both already testing EXT4_INODE_EXTENTS
We can call ext_depth(inode) unconditionnally.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/extents.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5d9f99a..4f1cca8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4693,13 +4693,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	 * credits to insert 1 extent into extent tree
 	 */
 	credits = ext4_chunk_trans_blocks(inode, len);
-	/*
-	 * We can only call ext_depth() on extent based inodes
-	 */
-	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		depth = ext_depth(inode);
-	else
-		depth = -1;
+	depth = ext_depth(inode);
 
 retry:
 	while (ret >= 0 && len) {
-- 
2.8.1
