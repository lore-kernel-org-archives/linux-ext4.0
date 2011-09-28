From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 1/2 V2] Consolidate delayed-extents fetch procedure to ext4_get_delayed_extent()
Date: Wed, 28 Sep 2011 14:38:15 +0800
Message-ID: <4E82C0D7.1060307@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42549 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1I1Gi2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 02:38:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move fetch delayed-extents procedure to a new function ext4_get_delayed_extent(), and modify the
fiemap callback function accordingly.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ext4/extents.c |  329 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 174 insertions(+), 155 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..06e88d4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3901,188 +3901,207 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 }
 
 /*
- * Callback function called for each extent to gather FIEMAP information.
+ * No extent in extent-tree contains block @newex->ec_start,
+ * then the block may stay in 1)a hole or 2)delayed-extent.
+ *
+ * Holes or delayed-extents are processed as follows.
+ * 1. lookup dirty pages with specified range in pagecache.
+ *    If no page is got, then there is no delayed-extent and
+ *    return with EXT_CONTINUE.
+ * 2. find the 1st mapped buffer,
+ * 3. check if the mapped buffer is both in the request range
+ *    and a delayed buffer. If not, there is no delayed-extent,
+ *    then return.
+ * 4. a delayed-extent is found, the extent will be collected.
+ * 5. fill the ext_seek_info.offset with logical and return
+ *    and EXT_BREAK if a delayed-extent is found.
+ * 6. same as above, but return EXT_BREAK if a hole is found.
  */
-static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
-		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
-		       void *data)
+static int ext4_get_delayed_extent(struct inode *inode, ext4_lblk_t next,
+				   struct ext4_ext_cache *newex,
+				   __u64 *logical, __u32 *flags)
 {
-	__u64	logical;
-	__u64	physical;
-	__u64	length;
-	__u32	flags = 0;
-	int		ret = 0;
-	struct fiemap_extent_info *fieinfo = data;
-	unsigned char blksize_bits;
+	int		ret;
+	ext4_lblk_t	end = 0;
+	pgoff_t		last_offset;
+	pgoff_t		offset;
+	pgoff_t		index;
+	pgoff_t		start_index = 0;
+	struct page	**pages = NULL;
+	struct buffer_head *bh = NULL;
+	struct buffer_head *head = NULL;
+	unsigned int nr_pages = PAGE_SIZE / sizeof(struct page *);
+	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 
-	blksize_bits = inode->i_sb->s_blocksize_bits;
-	logical = (__u64)newex->ec_block << blksize_bits;
+	pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (pages == NULL)
+		return -ENOMEM;
+
+	offset = *logical >> PAGE_SHIFT;
 
-	if (newex->ec_start == 0) {
-		/*
-		 * No extent in extent-tree contains block @newex->ec_start,
-		 * then the block may stay in 1)a hole or 2)delayed-extent.
-		 *
-		 * Holes or delayed-extents are processed as follows.
-		 * 1. lookup dirty pages with specified range in pagecache.
-		 *    If no page is got, then there is no delayed-extent and
-		 *    return with EXT_CONTINUE.
-		 * 2. find the 1st mapped buffer,
-		 * 3. check if the mapped buffer is both in the request range
-		 *    and a delayed buffer. If not, there is no delayed-extent,
-		 *    then return.
-		 * 4. a delayed-extent is found, the extent will be collected.
-		 */
-		ext4_lblk_t	end = 0;
-		pgoff_t		last_offset;
-		pgoff_t		offset;
-		pgoff_t		index;
-		pgoff_t		start_index = 0;
-		struct page	**pages = NULL;
-		struct buffer_head *bh = NULL;
-		struct buffer_head *head = NULL;
-		unsigned int nr_pages = PAGE_SIZE / sizeof(struct page *);
-
-		pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (pages == NULL)
-			return -ENOMEM;
-
-		offset = logical >> PAGE_SHIFT;
 repeat:
-		last_offset = offset;
-		head = NULL;
-		ret = find_get_pages_tag(inode->i_mapping, &offset,
-					PAGECACHE_TAG_DIRTY, nr_pages, pages);
-
-		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
-			/* First time, try to find a mapped buffer. */
-			if (ret == 0) {
+	last_offset = offset;
+	head = NULL;
+	ret = find_get_pages_tag(inode->i_mapping, &offset,
+				 PAGECACHE_TAG_DIRTY, nr_pages, pages);
+
+	if (!(*flags & FIEMAP_EXTENT_DELALLOC)) {
+		/* First time, try to find a mapped buffer. */
+		if (ret == 0) {
 out:
-				for (index = 0; index < ret; index++)
-					page_cache_release(pages[index]);
-				/* just a hole. */
-				kfree(pages);
-				return EXT_CONTINUE;
-			}
-			index = 0;
+			for (index = 0; index < ret; index++)
+				page_cache_release(pages[index]);
+			/* just a hole. */
+			kfree(pages);
+			return EXT_CONTINUE;
+		}
+		index = 0;
 
 next_page:
-			/* Try to find the 1st mapped buffer. */
-			end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
-				  blksize_bits;
-			if (!page_has_buffers(pages[index]))
-				goto out;
-			head = page_buffers(pages[index]);
-			if (!head)
+		/* Try to find the 1st mapped buffer. */
+		end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
+			blksize_bits;
+		if (!page_has_buffers(pages[index]))
+			goto out;
+		head = page_buffers(pages[index]);
+		if (!head)
+			goto out;
+
+		index++;
+		bh = head;
+		do {
+			if (end >= newex->ec_block +
+				newex->ec_len)
+				/* The buffer is out of
+				 * the request range.
+				 */
 				goto out;
 
-			index++;
-			bh = head;
-			do {
-				if (end >= newex->ec_block +
-					newex->ec_len)
-					/* The buffer is out of
-					 * the request range.
-					 */
-					goto out;
+			if (buffer_mapped(bh) &&
+			    end >= newex->ec_block) {
+				start_index = index - 1;
+				/* get the 1st mapped buffer. */
+				goto found_mapped_buffer;
+			}
 
-				if (buffer_mapped(bh) &&
-				    end >= newex->ec_block) {
-					start_index = index - 1;
-					/* get the 1st mapped buffer. */
-					goto found_mapped_buffer;
-				}
+			bh = bh->b_this_page;
+			end++;
+		} while (bh != head);
 
-				bh = bh->b_this_page;
-				end++;
-			} while (bh != head);
-
-			/* No mapped buffer in the range found in this page,
-			 * We need to look up next page.
+		/* No mapped buffer in the range found in this page,
+		 * We need to look up next page.
+		 */
+		if (index >= ret) {
+			/* There is no page left, but we need to limit
+			 * newex->ec_len.
 			 */
-			if (index >= ret) {
-				/* There is no page left, but we need to limit
-				 * newex->ec_len.
-				 */
-				newex->ec_len = end - newex->ec_block;
-				goto out;
-			}
-			goto next_page;
-		} else {
-			/*Find contiguous delayed buffers. */
-			if (ret > 0 && pages[0]->index == last_offset)
-				head = page_buffers(pages[0]);
-			bh = head;
-			index = 1;
-			start_index = 0;
+			newex->ec_len = end - newex->ec_block;
+			goto out;
 		}
+		goto next_page;
+	} else {
+		/*Find contiguous delayed buffers. */
+		if (ret > 0 && pages[0]->index == last_offset)
+			head = page_buffers(pages[0]);
+		bh = head;
+		index = 1;
+		start_index = 0;
+	}
 
 found_mapped_buffer:
-		if (bh != NULL && buffer_delay(bh)) {
-			/* 1st or contiguous delayed buffer found. */
-			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
-				/*
-				 * 1st delayed buffer found, record
-				 * the start of extent.
-				 */
-				flags |= FIEMAP_EXTENT_DELALLOC;
-				newex->ec_block = end;
-				logical = (__u64)end << blksize_bits;
+	if (bh != NULL && buffer_delay(bh)) {
+		/* 1st or contiguous delayed buffer found. */
+		if (!(*flags & FIEMAP_EXTENT_DELALLOC)) {
+			/*
+			 * 1st delayed buffer found, record
+			 * the start of extent.
+			 */
+			*flags |= FIEMAP_EXTENT_DELALLOC;
+			newex->ec_block = end;
+			*logical = (__u64)end << blksize_bits;
+		}
+		/* Find contiguous delayed buffers. */
+		do {
+			if (!buffer_delay(bh))
+				goto found_delayed_extent;
+			bh = bh->b_this_page;
+			end++;
+		} while (bh != head);
+
+		for (; index < ret; index++) {
+			if (!page_has_buffers(pages[index])) {
+				bh = NULL;
+				break;
+			}
+			head = page_buffers(pages[index]);
+			if (!head) {
+				bh = NULL;
+				break;
 			}
-			/* Find contiguous delayed buffers. */
+
+			if (pages[index]->index !=
+			    pages[start_index]->index + index
+			    - start_index) {
+				/* Blocks are not contiguous. */
+				bh = NULL;
+				break;
+			}
+			bh = head;
 			do {
 				if (!buffer_delay(bh))
+					/* Delayed-extent ends. */
 					goto found_delayed_extent;
 				bh = bh->b_this_page;
 				end++;
 			} while (bh != head);
-
-			for (; index < ret; index++) {
-				if (!page_has_buffers(pages[index])) {
-					bh = NULL;
-					break;
-				}
-				head = page_buffers(pages[index]);
-				if (!head) {
-					bh = NULL;
-					break;
-				}
-
-				if (pages[index]->index !=
-				    pages[start_index]->index + index
-				    - start_index) {
-					/* Blocks are not contiguous. */
-					bh = NULL;
-					break;
-				}
-				bh = head;
-				do {
-					if (!buffer_delay(bh))
-						/* Delayed-extent ends. */
-						goto found_delayed_extent;
-					bh = bh->b_this_page;
-					end++;
-				} while (bh != head);
-			}
-		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
-			/* a hole found. */
-			goto out;
-
-found_delayed_extent:
-		newex->ec_len = min(end - newex->ec_block,
-						(ext4_lblk_t)EXT_INIT_MAX_LEN);
-		if (ret == nr_pages && bh != NULL &&
-			newex->ec_len < EXT_INIT_MAX_LEN &&
-			buffer_delay(bh)) {
-			/* Have not collected an extent and continue. */
-			for (index = 0; index < ret; index++)
-				page_cache_release(pages[index]);
-			goto repeat;
 		}
+	} else if (!(*flags & FIEMAP_EXTENT_DELALLOC))
+		/* a hole found. */
+		goto out;
 
+found_delayed_extent:
+	newex->ec_len = min(end - newex->ec_block,
+			(ext4_lblk_t)EXT_INIT_MAX_LEN);
+	if (ret == nr_pages && bh != NULL &&
+		newex->ec_len < EXT_INIT_MAX_LEN &&
+		buffer_delay(bh)) {
+		/* Have not collected an extent and continue. */
 		for (index = 0; index < ret; index++)
 			page_cache_release(pages[index]);
-		kfree(pages);
+		goto repeat;
+	}
+
+	for (index = 0; index < ret; index++)
+		page_cache_release(pages[index]);
+	kfree(pages);
+
+	return EXT_BREAK;
+}
+
+/*
+ * Callback function called for each extent to gather FIEMAP information.
+ */
+static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
+		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
+		       void *data)
+{
+	__u64	logical;
+	__u64	physical;
+	__u64	length;
+	__u32	flags = 0;
+	int		ret = 0;
+	struct fiemap_extent_info *fieinfo = data;
+	unsigned char blksize_bits;
+
+	blksize_bits = inode->i_sb->s_blocksize_bits;
+	logical = (__u64)newex->ec_block << blksize_bits;
+
+	if (newex->ec_start == 0) {
+		ret = ext4_get_delayed_extent(inode, next, newex, &logical,
+					      &flags);
+		/* a hole found */
+		if (ret == EXT_CONTINUE)
+			return ret;
 	}
 
 	physical = (__u64)newex->ec_start << blksize_bits;
-- 
1.7.4.1
