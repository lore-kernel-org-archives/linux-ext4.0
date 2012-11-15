From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Thu, 15 Nov 2012 17:39:06 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com> <1352794923-28555-1-git-send-email-lczerner@redhat.com> <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com> <alpine.LFD.2.00.1211131304030.3577@localhost> <20121113141911.GA7472@X61>
 <20121113185104.GC1282@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571107329-156055853-1352997549=:27888"
Cc: Peng Tao <bergwolf@gmail.com>,
	=?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, dmonakhov@openvz.org
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768379Ab2KOQjO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 11:39:14 -0500
In-Reply-To: <20121113185104.GC1282@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-156055853-1352997549=:27888
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 13 Nov 2012, Zach Brown wrote:

> Date: Tue, 13 Nov 2012 10:51:04 -0800
> From: Zach Brown <zab@redhat.com>
> To: Peng Tao <bergwolf@gmail.com>
> Cc: Luká¨ Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
>     tytso@mit.edu, dmonakhov@openvz.org
> Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
> 
> > The deadlock mentioned by Zach Brown can be fixed by simply switching
> > to GFP_NOFS.
> 
> That's a start, but it doesn't address the copy_to_user().  You could
> pin that memory, I suppose, but that starts to feel like more trouble
> than its worth.
> 
> - z

You're both right. The code have to be reorganized. The
ext4_ext_fiemap_cb() is ugly as hell, but luckily that will be
resolved with extent status tree patches from Zheng Liu, however the
indirection in ext4_ext_walk_space() and the callback business
is also pointless.

I have prepared a path to fix this and I am going to test this
right not. Basically it will:

1. remove the callback

2. rename functions
	ext4_ext_walk_space -> ext4_fill_fiemap_extents
	ext4_ext_fiemap_cb -> ext4_find_delayed_extent

3. put fiemap_fill_next_extent() into ext4_fill_fiemap_extents)_

4. Call ext4_find_delayed_extent() only for non existing extents

5. Use GFP_NOFS in ext4_find_delayed_extent()

5. hold the i_data_sem for:
	ext4_ext_find_extent()
	ext4_ext_next_allocated_block()
	ext4_find_delayed_extent()

6. call fiemap_fill_next_extent after releasing the i_data_sem

does it sounds ok?

There are some collisions with extent status tree patches, but it
could be easily resolved depending on which goes in first.

I am going to test the patch now, so this is entirely untested and
possibly still contains bugs, but if you're interested to see how it
looks like, here it is:



---
I should probably split that into two parts to make the changes
clearer, because removing the if (newex->ec_start == 0) in the old
ext4_ext_fiemap_cb() obfuscated it a lot.


diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index cb1b2c9..1718ff1 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -144,20 +144,6 @@ struct ext4_ext_path {
  */
 
 /*
- * to be called by ext4_ext_walk_space()
- * negative retcode - error
- * positive retcode - signal for ext4_ext_walk_space(), see below
- * callback must return valid extent (passed or newly created)
- */
-typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
-					struct ext4_ext_cache *,
-					struct ext4_extent *, void *);
-
-#define EXT_CONTINUE   0
-#define EXT_BREAK      1
-#define EXT_REPEAT     2
-
-/*
  * Maximum number of logical blocks in a file; ext4_extent's ee_block is
  * __le32.
  */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..5c56194 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -109,6 +109,9 @@ static int ext4_split_extent_at(handle_t *handle,
 			     int split_flag,
 			     int flags);
 
+static int ext4_find_delayed_extent(struct inode *inode,
+				    struct ext4_ext_cache *newex);
+
 static int ext4_ext_truncate_extend_restart(handle_t *handle,
 					    struct inode *inode,
 					    int needed)
@@ -1959,27 +1962,35 @@ cleanup:
 	return err;
 }
 
-static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
-			       ext4_lblk_t num, ext_prepare_callback func,
-			       void *cbdata)
+static int ext4_fill_fiemap_extents(struct inode *inode,
+				    ext4_lblk_t block, ext4_lblk_t num,
+				    struct fiemap_extent_info *fieinfo)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_ext_cache cbex;
+	struct ext4_ext_cache newex;
 	struct ext4_extent *ex;
 	ext4_lblk_t next, start = 0, end = 0;
 	ext4_lblk_t last = block + num;
-	int depth, exists, err = 0;
+	int exists, depth = 0, err = 0;
+	unsigned int flags = 0;
+	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 
-	BUG_ON(func == NULL);
 	BUG_ON(inode == NULL);
 
 	while (block < last && block != EXT_MAX_BLOCKS) {
 		num = last - block;
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
+
+		if (path && ext_depth(inode) != depth) {
+			/* depth was changed. we have to realloc path */
+			kfree(path);
+			path = NULL;
+		}
+
 		path = ext4_ext_find_extent(inode, block, path);
-		up_read(&EXT4_I(inode)->i_data_sem);
 		if (IS_ERR(path)) {
+			up_read(&EXT4_I(inode)->i_data_sem);
 			err = PTR_ERR(path);
 			path = NULL;
 			break;
@@ -1987,12 +1998,14 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 
 		depth = ext_depth(inode);
 		if (unlikely(path[depth].p_hdr == NULL)) {
+			up_read(&EXT4_I(inode)->i_data_sem);
 			EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
 			err = -EIO;
 			break;
 		}
 		ex = path[depth].p_ext;
 		next = ext4_ext_next_allocated_block(path);
+		ext4_ext_drop_refs(path);
 
 		exists = 0;
 		if (!ex) {
@@ -2030,40 +2043,49 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		BUG_ON(end <= start);
 
 		if (!exists) {
-			cbex.ec_block = start;
-			cbex.ec_len = end - start;
-			cbex.ec_start = 0;
+			newex.ec_block = start;
+			newex.ec_len = end - start;
+			newex.ec_start = 0;
+			err = ext4_find_delayed_extent(inode, &newex);
 		} else {
-			cbex.ec_block = le32_to_cpu(ex->ee_block);
-			cbex.ec_len = ext4_ext_get_actual_len(ex);
-			cbex.ec_start = ext4_ext_pblock(ex);
+			newex.ec_block = le32_to_cpu(ex->ee_block);
+			newex.ec_len = ext4_ext_get_actual_len(ex);
+			newex.ec_start = ext4_ext_pblock(ex);
+			if (ext4_ext_is_uninitialized(ex))
+				flags |= FIEMAP_EXTENT_UNWRITTEN;
 		}
+		up_read(&EXT4_I(inode)->i_data_sem);
 
-		if (unlikely(cbex.ec_len == 0)) {
-			EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
+		if (unlikely(newex.ec_len == 0)) {
+			EXT4_ERROR_INODE(inode, "newex.ec_len == 0");
 			err = -EIO;
 			break;
 		}
-		err = func(inode, next, &cbex, ex, cbdata);
-		ext4_ext_drop_refs(path);
-
 		if (err < 0)
 			break;
-
-		if (err == EXT_REPEAT)
-			continue;
-		else if (err == EXT_BREAK) {
-			err = 0;
-			break;
+		if (err == 1) {
+			exists = 1;
+			flags |= FIEMAP_EXTENT_DELALLOC;
 		}
 
-		if (ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
+		if (next == EXT_MAX_BLOCKS)
+			flags |= FIEMAP_EXTENT_LAST;
+
+		if (exists) {
+			err = fiemap_fill_next_extent(fieinfo,
+				(__u64)newex.ec_block << blksize_bits,
+				(__u64)newex.ec_start << blksize_bits,
+				(__u64)newex.ec_len << blksize_bits,
+				flags);
+			if (err < 0)
+				break;
+			if (err == 1) {
+				err = 0;
+				break;
+			}
 		}
 
-		block = cbex.ec_block + cbex.ec_len;
+		block = newex.ec_block + newex.ec_len;
 	}
 
 	if (path) {
@@ -4574,204 +4596,179 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
-		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
-		       void *data)
+static int ext4_find_delayed_extent(struct inode *inode,
+				    struct ext4_ext_cache *newex)
 {
-	__u64	logical;
-	__u64	physical;
-	__u64	length;
-	__u32	flags = 0;
 	int		ret = 0;
-	struct fiemap_extent_info *fieinfo = data;
-	unsigned char blksize_bits;
+	unsigned int flags = 0;
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
+	/*
+	 * No extent in extent-tree contains block @newex->ec_start,
+	 * then the block may stay in 1)a hole or 2)delayed-extent.
+	 *
+	 * Holes or delayed-extents are processed as follows.
+	 * 1. lookup dirty pages with specified range in pagecache.
+	 *    If no page is got, then there is no delayed-extent and
+	 *    return with EXT_CONTINUE.
+	 * 2. find the 1st mapped buffer,
+	 * 3. check if the mapped buffer is both in the request range
+	 *    and a delayed buffer. If not, there is no delayed-extent,
+	 *    then return.
+	 * 4. a delayed-extent is found, the extent will be collected.
+	 */
 
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
+	pages = kmalloc(PAGE_SIZE, GFP_NOFS);
+	if (pages == NULL)
+		return -ENOMEM;
 
-		offset = logical >> PAGE_SHIFT;
+	offset = ((__u64)newex->ec_block << PAGE_SHIFT) >>
+			blksize_bits;
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
+				PAGECACHE_TAG_DIRTY, nr_pages, pages);
+
+	if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
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
+			return 0;
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
-				goto out;
+		/* Try to find the 1st mapped buffer. */
+		end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
+			  blksize_bits;
+		if (!page_has_buffers(pages[index]))
+			goto out;
+		head = page_buffers(pages[index]);
+		if (!head)
+			goto out;
 
-			index++;
-			bh = head;
-			do {
-				if (end >= newex->ec_block +
-					newex->ec_len)
-					/* The buffer is out of
-					 * the request range.
-					 */
-					goto out;
+		index++;
+		bh = head;
+		do {
+			if (end >= newex->ec_block +
+				newex->ec_len)
+				/* The buffer is out of
+				 * the request range.
+				 */
+				goto out;
 
-				if (buffer_mapped(bh) &&
-				    end >= newex->ec_block) {
-					start_index = index - 1;
-					/* get the 1st mapped buffer. */
-					goto found_mapped_buffer;
-				}
+			if (buffer_mapped(bh) &&
+			    end >= newex->ec_block) {
+				start_index = index - 1;
+				/* get the 1st mapped buffer. */
+				goto found_mapped_buffer;
+			}
 
-				bh = bh->b_this_page;
-				end++;
-			} while (bh != head);
+			bh = bh->b_this_page;
+			end++;
+		} while (bh != head);
 
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
+		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+			/*
+			 * 1st delayed buffer found, record
+			 * the start of extent.
+			 */
+			flags |= FIEMAP_EXTENT_DELALLOC;
+			newex->ec_block = end;
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
+			}
+
+			if (pages[index]->index !=
+			    pages[start_index]->index + index
+			    - start_index) {
+				/* Blocks are not contiguous. */
+				bh = NULL;
+				break;
 			}
-			/* Find contiguous delayed buffers. */
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
+	} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
+		/* a hole found. */
+		goto out;
 
+found_delayed_extent:
+	newex->ec_len = min(end - newex->ec_block,
+					(ext4_lblk_t)EXT_INIT_MAX_LEN);
+	if (ret == nr_pages && bh != NULL &&
+		newex->ec_len < EXT_INIT_MAX_LEN &&
+		buffer_delay(bh)) {
+		/* Have not collected an extent and continue. */
 		for (index = 0; index < ret; index++)
 			page_cache_release(pages[index]);
-		kfree(pages);
+		goto repeat;
 	}
 
-	physical = (__u64)newex->ec_start << blksize_bits;
-	length =   (__u64)newex->ec_len << blksize_bits;
-
-	if (ex && ext4_ext_is_uninitialized(ex))
-		flags |= FIEMAP_EXTENT_UNWRITTEN;
-
-	if (next == EXT_MAX_BLOCKS)
-		flags |= FIEMAP_EXTENT_LAST;
+	for (index = 0; index < ret; index++)
+		page_cache_release(pages[index]);
+	kfree(pages);
 
-	ret = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, flags);
-	if (ret < 0)
-		return ret;
-	if (ret == 1)
-		return EXT_BREAK;
-	return EXT_CONTINUE;
+	return 1;
 }
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
@@ -4991,6 +4988,7 @@ out_mutex:
 	mutex_unlock(&inode->i_mutex);
 	return err;
 }
+
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
@@ -5021,8 +5019,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 * Walk the extent tree gathering extent information.
 		 * ext4_ext_fiemap_cb will push extents back to user.
 		 */
-		error = ext4_ext_walk_space(inode, start_blk, len_blks,
-					  ext4_ext_fiemap_cb, fieinfo);
+		error = ext4_fill_fiemap_extents(inode, start_blk,
+						 len_blks, fieinfo);
 	}
 
 	return error;


--571107329-156055853-1352997549=:27888--
