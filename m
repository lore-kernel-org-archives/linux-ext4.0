From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Unmap metadata when zeroing blocks
Date: Tue, 27 Sep 2016 18:15:18 +0200
Message-ID: <1474992918-20488-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753547AbcI0QPd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Sep 2016 12:15:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When zeroing blocks for DAX allocations, we also have to unmap aliases
in the block device mappings. Otherwise writeback can overwrite zeros
with stale data from block device page cache.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Ted, can you merge this patch please? It's a data corruption issue for DAX.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6ea25a190f8..87150122d361 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -647,11 +647,19 @@ found:
 		/*
 		 * We have to zeroout blocks before inserting them into extent
 		 * status tree. Otherwise someone could look them up there and
-		 * use them before they are really zeroed.
+		 * use them before they are really zeroed. We also have to
+		 * unmap metadata before zeroing as otherwise writeback can
+		 * overwrite zeros with stale data from block device.
 		 */
 		if (flags & EXT4_GET_BLOCKS_ZERO &&
 		    map->m_flags & EXT4_MAP_MAPPED &&
 		    map->m_flags & EXT4_MAP_NEW) {
+			ext4_lblk_t i;
+
+			for (i = 0; i < map->m_len; i++) {
+				unmap_underlying_metadata(inode->i_sb->s_bdev,
+							  map->m_pblk + i);
+			}
 			ret = ext4_issue_zeroout(inode, map->m_lblk,
 						 map->m_pblk, map->m_len);
 			if (ret) {
-- 
2.6.6

