From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/6] ext4: Use clean_bdev_aliases() instead of iteration
Date: Fri,  4 Nov 2016 18:08:13 +0100
Message-ID: <1478279296-6575-4-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35635 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936486AbcKDRI1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 13:08:27 -0400
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use clean_bdev_aliases() instead of iterating through blocks one by one.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 13 ++-----------
 fs/ext4/inode.c   | 15 ++++-----------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c930a0110fb4..dd5b74dfa018 100644
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
@@ -4121,9 +4113,8 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	 * new.
 	 */
 	if (allocated > map->m_len) {
-		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
-					newblock + map->m_len,
-					allocated - map->m_len);
+		clean_bdev_aliases(inode->i_sb->s_bdev, newblock + map->m_len,
+				   allocated - map->m_len);
 		allocated = map->m_len;
 	}
 	map->m_len = allocated;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c064727ed62..7c7cc4ae4b8e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -654,12 +654,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		if (flags & EXT4_GET_BLOCKS_ZERO &&
 		    map->m_flags & EXT4_MAP_MAPPED &&
 		    map->m_flags & EXT4_MAP_NEW) {
-			ext4_lblk_t i;
-
-			for (i = 0; i < map->m_len; i++) {
-				unmap_underlying_metadata(inode->i_sb->s_bdev,
-							  map->m_pblk + i);
-			}
+			clean_bdev_aliases(inode->i_sb->s_bdev, map->m_pblk,
+					   map->m_len);
 			ret = ext4_issue_zeroout(inode, map->m_lblk,
 						 map->m_pblk, map->m_len);
 			if (ret) {
@@ -2360,11 +2356,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 
 	BUG_ON(map->m_len == 0);
 	if (map->m_flags & EXT4_MAP_NEW) {
-		struct block_device *bdev = inode->i_sb->s_bdev;
-		int i;
