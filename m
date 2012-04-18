From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ext4: reimplement ext4_find_delay_alloc_range on status extent tree
Date: Wed, 18 Apr 2012 00:07:18 -0700
Message-ID: <1334732838-25102-7-git-send-email-achender@linux.vnet.ibm.com>
References: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:52984 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2DRHGv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 03:06:51 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Apr 2012 01:06:51 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0114619D8048
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:39 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3I768AS046714
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:09 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3I76d4I005538
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:39 -0600
In-Reply-To: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_find_delay_alloc_range is reimplemented on status extent tree.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 704021e... 896f2fb... M	fs/ext4/ext4.h
:100644 100644 a52db3a... 14ef9f5... M	fs/ext4/ext4_extents.h
:100644 100644 cee94ce... bfcbde3... M	fs/ext4/extents.c
:100644 100644 adeae2f... 8970254... M	fs/ext4/inode.c
 fs/ext4/ext4.h         |    4 --
 fs/ext4/ext4_extents.h |    3 +-
 fs/ext4/extents.c      |  109 +++++------------------------------------------
 fs/ext4/inode.c        |   53 +-----------------------
 4 files changed, 14 insertions(+), 155 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 704021e..896f2fb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2304,14 +2304,10 @@ enum ext4_state_bits {
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
index cee94ce..bfcbde3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3262,112 +3262,27 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
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
+	struct status_extent se;
 
-	trace_ext4_find_delalloc_range(inode, lblk_start, lblk_end,
-					search_hint_reverse, 0, 0);
-	return 0;
+	se.start = lblk_start;
+	ext4_se_find_extent(inode, &se);
+	return (se.start + se.len) >= lblk_end && se.start <= lblk_start;
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
@@ -3428,7 +3343,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = lblk_start & (~(sbi->s_cluster_ratio - 1));
 		lblk_to = lblk_from + c_offset - 1;
 
-		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3438,7 +3353,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
 
-		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3728,7 +3643,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
index adeae2f..8970254 100644
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
@@ -571,13 +528,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
 			ret = ext4_se_remove_space(inode, map->m_lblk,
@@ -1221,7 +1173,6 @@ static void ext4_da_page_release_reservation(struct page *page,
 		if ((offset <= curr_off) && (buffer_delay(bh))) {
 			to_release++;
 			clear_buffer_delay(bh);
-			clear_buffer_da_mapped(bh);
 		}
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
@@ -1234,7 +1185,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 		lblk = (page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits)) +
 			((num_clusters - 1) << sbi->s_cluster_bits);
 		if (sbi->s_cluster_ratio == 1 ||
-		    !ext4_find_delalloc_cluster(inode, lblk, 1))
+		    !ext4_find_delalloc_cluster(inode, lblk))
 			ext4_da_release_space(inode, 1);
 
 		num_clusters--;
@@ -1340,8 +1291,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 						clear_buffer_delay(bh);
 						bh->b_blocknr = pblock;
 					}
-					if (buffer_da_mapped(bh))
-						clear_buffer_da_mapped(bh);
 					if (buffer_unwritten(bh) ||
 					    buffer_mapped(bh))
 						BUG_ON(bh->b_blocknr != pblock);
-- 
1.7.1

