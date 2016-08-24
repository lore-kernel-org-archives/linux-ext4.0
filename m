From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/6 linux-next] ext4: avoid EXT4_INODE_EXTENTS double checking
Date: Wed, 24 Aug 2016 22:03:15 +0200
Message-ID: <1472069000-18897-2-git-send-email-fabf@skynet.be>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_collapse_range() and ext4_insert_range()
already checked inode flag at the beginning of function.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/extents.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d7ccb7f..5d9f99a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5506,12 +5506,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
-	}
-
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
 	inode_dio_wait(inode);
@@ -5643,11 +5637,6 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	inode_lock(inode);
-	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
-	}
 
 	/* Check for wrap through zero */
 	if (inode->i_size + len > inode->i_sb->s_maxbytes) {
-- 
2.8.1
