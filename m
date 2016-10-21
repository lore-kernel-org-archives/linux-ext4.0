From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext2: Use unmap_underlying_metadata_ext() instead of iteration
Date: Fri, 21 Oct 2016 13:55:41 +0200
Message-ID: <1477050941-29682-5-git-send-email-jack@suse.cz>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477050941-29682-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use unmap_underlying_metadata_ext() instead of iterating through blocks
one by one.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d831e24dc885..335cd1e1f902 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -732,16 +732,13 @@ static int ext2_get_blocks(struct inode *inode,
 	}
 
 	if (IS_DAX(inode)) {
-		int i;
-
 		/*
 		 * We must unmap blocks before zeroing so that writeback cannot
 		 * overwrite zeros with stale data from block device page cache.
 		 */
-		for (i = 0; i < count; i++) {
-			unmap_underlying_metadata(inode->i_sb->s_bdev,
-					le32_to_cpu(chain[depth-1].key) + i);
-		}
+		unmap_underlying_metadata_ext(inode->i_sb->s_bdev,
+					      le32_to_cpu(chain[depth-1].key),
+					      count);
 		/*
 		 * block must be initialised before we put it in the tree
 		 * so that it's not found by another thread before it's
-- 
2.6.6

