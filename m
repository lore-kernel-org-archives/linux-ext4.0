From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Move test whether extent to map can be extended to one place
Date: Mon,  5 Aug 2013 15:52:21 +0200
Message-ID: <1375710744-29329-2-git-send-email-jack@suse.cz>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab3HENw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 09:52:28 -0400
In-Reply-To: <1375710744-29329-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the logic whether the current buffer can be added to an extent
of buffers to map is split between mpage_add_bh_to_extent() and
add_page_bufs_to_extent(). Move the whole logic to
mpage_add_bh_to_extent() which makes things a bit more straightforward
and make following i_size fixes easier.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba33c67..afaf26b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1907,34 +1907,48 @@ static int ext4_writepage(struct page *page,
  *
  * @mpd - extent of blocks
  * @lblk - logical number of the block in the file
- * @b_state - b_state of the buffer head added
+ * @bh - buffer head we want to add to the extent
  *
- * the function is used to collect contig. blocks in same state
+ * The function is used to collect contig. blocks in the same state. If the
+ * buffer doesn't require mapping for writeback and we haven't started the
+ * extent of buffers to map yet, the function returns 'true' immediately - the
+ * caller can write the buffer right away. Otherwise the function returns true
+ * if the block has been added to the extent, false if the block couldn't be
+ * added.
  */
-static int mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
-				  unsigned long b_state)
+static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
+				   struct buffer_head *bh)
 {
 	struct ext4_map_blocks *map = &mpd->map;
 
-	/* Don't go larger than mballoc is willing to allocate */
-	if (map->m_len >= MAX_WRITEPAGES_EXTENT_LEN)
-		return 0;
+	/* Buffer that doesn't need mapping for writeback? */
+	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
+	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
+		/* So far no extent to map => we write the buffer right away */
+		if (map->m_len == 0)
+			return true;
+		return false;
+	}
 
 	/* First block in the extent? */
 	if (map->m_len == 0) {
 		map->m_lblk = lblk;
 		map->m_len = 1;
-		map->m_flags = b_state & BH_FLAGS;
-		return 1;
+		map->m_flags = bh->b_state & BH_FLAGS;
+		return true;
 	}
 
+	/* Don't go larger than mballoc is willing to allocate */
+	if (map->m_len >= MAX_WRITEPAGES_EXTENT_LEN)
+		return false;
+
 	/* Can we merge the block to our big extent? */
 	if (lblk == map->m_lblk + map->m_len &&
-	    (b_state & BH_FLAGS) == map->m_flags) {
+	    (bh->b_state & BH_FLAGS) == map->m_flags) {
 		map->m_len++;
-		return 1;
+		return true;
 	}
-	return 0;
+	return false;
 }
 
 static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
@@ -1949,18 +1963,13 @@ static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
 	do {
 		BUG_ON(buffer_locked(bh));
 
-		if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
-		    (!buffer_delay(bh) && !buffer_unwritten(bh)) ||
-		    lblk >= blocks) {
+		if (lblk >= blocks || !mpage_add_bh_to_extent(mpd, lblk, bh)) {
 			/* Found extent to map? */
 			if (mpd->map.m_len)
 				return false;
-			if (lblk >= blocks)
-				return true;
-			continue;
+			/* Everything mapped so far and we hit EOF */
+			return true;
 		}
-		if (!mpage_add_bh_to_extent(mpd, lblk, bh->b_state))
-			return false;
 	} while (lblk++, (bh = bh->b_this_page) != head);
 	return true;
 }
-- 
1.8.1.4

