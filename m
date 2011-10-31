From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 6/6] ext4: reimplement ext4_find_delay_alloc_range on delayed extent tree
Date: Mon, 31 Oct 2011 08:55:47 +0800
Message-ID: <1320022547-2284-7-git-send-email-xiaoqiangnk@gmail.com>
References: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1JaDAL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 23:00:11 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6677937iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 20:00:11 -0700 (PDT)
In-Reply-To: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_find_delay_alloc_range is reimplemented on delayed extent tree.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |    4 --
 fs/ext4/ext4_extents.h |    3 +-
 fs/ext4/extents.c      |  109 +++++------------------------------------------
 fs/ext4/inode.c        |   53 +-----------------------
 4 files changed, 14 insertions(+), 155 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 72c6b1e..9eacf5a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2296,14 +2296,10 @@ enum ext4_state_bits {
 				 * never, ever appear in a buffer_head's state
 				 * flag. See EXT4_MAP_FROM_CLUSTER to see where
 				 * this is used. */
-	BH_Da_Mapped,	/* Delayed allocated block that now has a mapping. This
-			 * flag is set when ext4_map_blocks is called on a
-			 * delayed allocated block to get its real mapping. */
 };
 
 BUFFER_FNS(Uninit, uninit)
 TAS_BUFFER_FNS(Uninit, uninit)
-BUFFER_FNS(Da_Mapped, da_mapped)
 
 /*
  * Add new method to test wether block and inode bitmaps are properly
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a52db3a..14ef9f5 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -290,7 +290,6 @@ extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
-extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk,
-				      int search_hint_reverse);
+extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad6f5af..a18ff48 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3260,112 +3260,27 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 /**
  * ext4_find_delalloc_range: find delayed allocated block in the given range.
  *
- * Goes through the buffer heads in the range [lblk_start, lblk_end] and returns
- * whether there are any buffers marked for delayed allocation. It returns '1'
- * on the first delalloc'ed buffer head found. If no buffer head in the given
- * range is marked for delalloc, it returns 0.
- * lblk_start should always be <= lblk_end.
- * search_hint_reverse is to indicate that searching in reverse from lblk_end to
- * lblk_start might be more efficient (i.e., we will likely hit the delalloc'ed
- * block sooner). This is useful when blocks are truncated sequentially from
- * lblk_start towards lblk_end.
+ * Return 1 if there is a delalloc block in the range, otherwise 0.
  */
 static int ext4_find_delalloc_range(struct inode *inode,
 				    ext4_lblk_t lblk_start,
-				    ext4_lblk_t lblk_end,
-				    int search_hint_reverse)
+				    ext4_lblk_t lblk_end)
 {
-	struct address_space *mapping = inode->i_mapping;
-	struct buffer_head *head, *bh = NULL;
-	struct page *page;
-	ext4_lblk_t i, pg_lblk;
-	pgoff_t index;
-
-	/* reverse search wont work if fs block size is less than page size */
-	if (inode->i_blkbits < PAGE_CACHE_SHIFT)
-		search_hint_reverse = 0;
-
-	if (search_hint_reverse)
-		i = lblk_end;
-	else
-		i = lblk_start;
-
-	index = i >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
-
-	while ((i >= lblk_start) && (i <= lblk_end)) {
-		page = find_get_page(mapping, index);
-		if (!page)
-			goto nextpage;
-
-		if (!page_has_buffers(page))
-			goto nextpage;
-
-		head = page_buffers(page);
-		if (!head)
-			goto nextpage;
-
-		bh = head;
-		pg_lblk = index << (PAGE_CACHE_SHIFT -
-						inode->i_blkbits);
-		do {
-			if (unlikely(pg_lblk < lblk_start)) {
-				/*
-				 * This is possible when fs block size is less
-				 * than page size and our cluster starts/ends in
-				 * middle of the page. So we need to skip the
-				 * initial few blocks till we reach the 'lblk'
-				 */
-				pg_lblk++;
-				continue;
-			}
-
-			/* Check if the buffer is delayed allocated and that it
-			 * is not yet mapped. (when da-buffers are mapped during
-			 * their writeout, their da_mapped bit is set.)
-			 */
-			if (buffer_delay(bh) && !buffer_da_mapped(bh)) {
-				page_cache_release(page);
-				trace_ext4_find_delalloc_range(inode,
-						lblk_start, lblk_end,
-						search_hint_reverse,
-						1, i);
-				return 1;
-			}
-			if (search_hint_reverse)
-				i--;
-			else
-				i++;
-		} while ((i >= lblk_start) && (i <= lblk_end) &&
-				((bh = bh->b_this_page) != head));
-nextpage:
-		if (page)
-			page_cache_release(page);
-		/*
-		 * Move to next page. 'i' will be the first lblk in the next
-		 * page.
-		 */
-		if (search_hint_reverse)
-			index--;
-		else
-			index++;
-		i = index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	}
+	struct delayed_extent de;
 
-	trace_ext4_find_delalloc_range(inode, lblk_start, lblk_end,
-					search_hint_reverse, 0, 0);
-	return 0;
+	de.start = lblk_start;
+	ext4_de_find_extent(inode, &de);
+	return (de.start + de.len) >= lblk_end && de.start <= lblk_start;
 }
 
-int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk,
-			       int search_hint_reverse)
+int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t lblk_start, lblk_end;
 	lblk_start = lblk & (~(sbi->s_cluster_ratio - 1));
 	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
 
-	return ext4_find_delalloc_range(inode, lblk_start, lblk_end,
-					search_hint_reverse);
+	return ext4_find_delalloc_range(inode, lblk_start, lblk_end);
 }
 
 /**
@@ -3426,7 +3341,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = lblk_start & (~(sbi->s_cluster_ratio - 1));
 		lblk_to = lblk_from + c_offset - 1;
 
-		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3436,7 +3351,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
 
-		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3727,7 +3642,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
 		if (!newex.ee_start_lo && !newex.ee_start_hi) {
 			if ((sbi->s_cluster_ratio > 1) &&
-			    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
+			    ext4_find_delalloc_cluster(inode, map->m_lblk))
 				map->m_flags |= EXT4_MAP_FROM_CLUSTER;
 
 			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
@@ -3903,7 +3818,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	if ((sbi->s_cluster_ratio > 1) &&
-	    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
+	    ext4_find_delalloc_cluster(inode, map->m_lblk))
 		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
 
 	/*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f573020..5ae0c0d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -398,49 +398,6 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 }
 
 /*
- * Sets the BH_Da_Mapped bit on the buffer heads corresponding to the given map.
- */
-static void set_buffers_da_mapped(struct inode *inode,
-				   struct ext4_map_blocks *map)
-{
-	struct address_space *mapping = inode->i_mapping;
-	struct pagevec pvec;
-	int i, nr_pages;
-	pgoff_t index, end;
-
-	index = map->m_lblk >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	end = (map->m_lblk + map->m_len - 1) >>
-		(PAGE_CACHE_SHIFT - inode->i_blkbits);
-
-	pagevec_init(&pvec, 0);
-	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, index,
-					  min(end - index + 1,
-					      (pgoff_t)PAGEVEC_SIZE));
-		if (nr_pages == 0)
-			break;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-			struct buffer_head *bh, *head;
-
-			if (unlikely(page->mapping != mapping) ||
-			    !PageDirty(page))
-				break;
-
-			if (page_has_buffers(page)) {
-				bh = head = page_buffers(page);
-				do {
-					set_buffer_da_mapped(bh);
-					bh = bh->b_this_page;
-				} while (bh != head);
-			}
-			index++;
-		}
-		pagevec_release(&pvec);
-	}
-}
-
-/*
  * The ext4_map_blocks() function tries to look up the requested blocks,
  * and returns if the blocks are already mapped.
  *
@@ -573,13 +530,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
 		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
 
-		/* If we have successfully mapped the delayed allocated blocks,
-		 * set the BH_Da_Mapped bit on them. Its important to do this
-		 * under the protection of i_data_sem.
-		 */
 		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 			int ret;
-			set_buffers_da_mapped(inode, map);
 delayed_mapped:
 			/* delayed allocation blocks has been allocated */
 			ret = ext4_de_remove_space(inode, map->m_lblk,
@@ -1227,7 +1179,6 @@ static void ext4_da_page_release_reservation(struct page *page,
 		if ((offset <= curr_off) && (buffer_delay(bh))) {
 			to_release++;
 			clear_buffer_delay(bh);
-			clear_buffer_da_mapped(bh);
 		}
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
@@ -1240,7 +1191,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 		lblk = (page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits)) +
 			((num_clusters - 1) << sbi->s_cluster_bits);
 		if (sbi->s_cluster_ratio == 1 ||
-		    !ext4_find_delalloc_cluster(inode, lblk, 1))
+		    !ext4_find_delalloc_cluster(inode, lblk))
 			ext4_da_release_space(inode, 1);
 
 		num_clusters--;
@@ -1346,8 +1297,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 						clear_buffer_delay(bh);
 						bh->b_blocknr = pblock;
 					}
-					if (buffer_da_mapped(bh))
-						clear_buffer_da_mapped(bh);
 					if (buffer_unwritten(bh) ||
 					    buffer_mapped(bh))
 						BUG_ON(bh->b_blocknr != pblock);
-- 
1.7.5.1

