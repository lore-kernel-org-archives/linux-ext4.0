From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Use unmap_underlying_metadata_ext() instead of iteration
Date: Fri, 21 Oct 2016 13:55:40 +0200
Message-ID: <1477050941-29682-4-git-send-email-jack@suse.cz>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754124AbcJULzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Oct 2016 07:55:50 -0400
In-Reply-To: <1477050941-29682-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use unmap_underlying_metadata_ext() instead of iterating through blocks
one by one.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 10 +---------
 fs/ext4/inode.c   | 13 ++++---------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c930a0110fb4..0cd47355d919 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3777,14 +3777,6 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	return err;
 }
 
-static void unmap_underlying_metadata_blocks(struct block_device *bdev,
-			sector_t block, int count)
-{
-	int i;
-	for (i = 0; i < count; i++)
-                unmap_underlying_metadata(bdev, block + i);
-}
-
 /*
  * Handle EOFBLOCKS_FL flag, clearing it if necessary
  */
@@ -4121,7 +4113,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	 * new.
 	 */
 	if (allocated > map->m_len) {
-		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+		unmap_underlying_metadata_ext(inode->i_sb->s_bdev,
 					newblock + map->m_len,
 					allocated - map->m_len);
 		allocated = map->m_len;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c064727ed62..e2046742a564 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -654,12 +654,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		if (flags & EXT4_GET_BLOCKS_ZERO &&
 		    map->m_flags & EXT4_MAP_MAPPED &&
 		    map->m_flags & EXT4_MAP_NEW) {
-			ext4_lblk_t i;
-
-			for (i = 0; i < map->m_len; i++) {
-				unmap_underlying_metadata(inode->i_sb->s_bdev,
-							  map->m_pblk + i);
-			}
+			unmap_underlying_metadata_ext(inode->i_sb->s_bdev,
+						      map->m_pblk,
+						      map->m_len);
 			ret = ext4_issue_zeroout(inode, map->m_lblk,
 						 map->m_pblk, map->m_len);
 			if (ret) {
@@ -2361,10 +2358,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 	BUG_ON(map->m_len == 0);
 	if (map->m_flags & EXT4_MAP_NEW) {
 		struct block_device *bdev = inode->i_sb->s_bdev;
-		int i;
 
-		for (i = 0; i < map->m_len; i++)
-			unmap_underlying_metadata(bdev, map->m_pblk + i);
+		unmap_underlying_metadata_ext(bdev, map->m_pblk, map->m_len);
 	}
 	return 0;
 }
-- 
2.6.6

