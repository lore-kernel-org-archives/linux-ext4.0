From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] Add SEEK_DATA/SEEK_HOLE support
Date: Mon, 26 Sep 2011 21:50:59 +0800
Message-ID: <4E808343.8080205@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36299 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1IZNvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 09:51:19 -0400
Received: from ucsinet23.oracle.com (ucsinet23.oracle.com [156.151.31.71])
	by acsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id p8QDpG92012123
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2011 13:51:18 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet23.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id p8QDpG7j008967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2011 13:51:16 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id p8QDpApv002003
	for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2011 08:51:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear developer,

Has anyone started working on SEEK_DATA/SEEK_HOLE yet?
If not, I'd like to submit a patch for it, or please just ignore my noise. :-P.

The mainly idea of how to retrieve the delayed extent info are copied from ext4_ext_fiemap_cb().
And also, IMHO, for block based file, return -ENOTSUPP is ok?

I have done the following tests, all works for me.
1. file start with hole.
2. file end with hole.
3. file with about 10001 extents on my test env which was created through:
python -c "f=open('./sptest', 'w'); [(f.seek(x) or f.write(str(x))) for x in range(1, 1000000000, 99999)]; f.close()

Any constructive criticism/comments are welcome, thank you!

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ext4/ext4.h         |    4 +
 fs/ext4/ext4_extents.h |    8 ++
 fs/ext4/extents.c      |  234 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/file.c         |   14 ++--
 4 files changed, 253 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..05b9a3a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2222,6 +2222,10 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
 			     __u64 len, __u64 *moved_len);
 
+/* extent.c */
+extern int ext4_find_desired_extent(struct inode *inode, loff_t *offset,
+				    int origin);
+
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 095c36f..ca7a339 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -116,6 +116,14 @@ struct ext4_ext_path {
 };
 
 /*
+ * Structure for retrieving extent offset for SEEK_DATA/SEEK_HOLE.
+ */
+struct ext4_extent_seek_info {
+	unsigned int origin;	/* SEEK_DATA or SEEK_HOLE */
+	loff_t offset;		/* input/output offset */
+};
+
+/*
  * structure for external API
  */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..a339e00 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3901,6 +3901,240 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 }
 
 /*
+ * Callback function called for each extent to gather SEEK_DATA/SEEK_HOLE
+ * information.
+ */
+static int ext4_ext_seek_cb(struct inode *inode, ext4_lblk_t next,
+			    struct ext4_ext_cache *newex,
+			    struct ext4_extent *ex,
+			    void *data)
+{
+	__u64	logical;
+	__u32	flags = 0;
+	int	ret = 0;
+	unsigned char blksize_bits;
+	struct ext4_extent_seek_info *ext_seek_info = data;
+
+	blksize_bits = inode->i_sb->s_blocksize_bits;
+	logical = (__u64)newex->ec_block << blksize_bits;
+
+	/*
+	 * No extent in extent-tree contains block @newex->ec_start,
+	 * then the block may stay in 1)a hole or 2)delayed-extent.
+	 *
+	 * Holes or delayed-extents are processed as follows.
+	 * 1. lookup dirty pages with specified range in pagecache.
+	 *    If no page is got, then there is no delayed-extent and
+	 *    return with EXT_CONTINUE if SEEK_DATA; return EXT_BREAK
+	 *    with extent offset if SEEK_HOLE.
+	 * 2. find the 1st mapped buffer,
+	 * 3. check if the mapped buffer is both in the request range
+	 *    and a delayed buffer. If not, there is no delayed-extent,
+	 *    then return with EXT_CONTINUE if SEEK_DATA, or return
+	 *    EXT_BREAK if SEEK_HOLE and extent offset.
+	 * 4. a delayed-extent is found, return the extent offset if
+	 *    SEEK_DATA and EXT_BREAK.
+	 */
+	if (newex->ec_start == 0) {
+		ext4_lblk_t	end = 0;
+		pgoff_t		last_offset;
+		pgoff_t		offset;
+		pgoff_t		index;
+		pgoff_t		start_index = 0;
+		struct page	**pages = NULL;
+		struct buffer_head *bh = NULL;
+		struct buffer_head *head = NULL;
+		unsigned int nr_pages = PAGE_SIZE / sizeof(struct page *);
+
+		pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (pages == NULL)
+			return -ENOMEM;
+
+		offset = logical >> PAGE_SHIFT;
+repeat:
+		last_offset = offset;
+		head = NULL;
+
+		ret = find_get_pages_tag(inode->i_mapping, &offset,
+					 PAGECACHE_TAG_DIRTY, nr_pages, pages);
+
+		/* Not a delay allocated extent. */
+		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+			/* First time, try to find a mapped buffer. */
+			if (ret == 0) {
+out:
+				for (index = 0; index < ret; index++)
+					page_cache_release(pages[index]);
+				/* just a hole. */
+				kfree(pages);
+
+				/* If SEEK_HOLE, return the logical offset. */
+				if (ext_seek_info->origin == SEEK_HOLE) {
+					ext_seek_info->offset = logical;
+					return EXT_BREAK;
+				}
+
+				return EXT_CONTINUE;
+			}
+
+			index = 0;
+next_page:
+			/* Try to find the 1st mapped buffer. */
+			end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
+				  blksize_bits;
+			if (!page_has_buffers(pages[index]))
+				goto out;
+			head = page_buffers(pages[index]);
+			if (!head)
+				goto out;
+
+			index++;
+			bh = head;
+			do {
+				/* The buffer is out of the request range. */
+				if (end >= newex->ec_block + newex->ec_len)
+					goto out;
+
+				if (buffer_mapped(bh) &&
+				    end >= newex->ec_block) {
+					start_index = index - 1;
+					/* get the 1st mapped buffer. */
+					goto found_mapped_buffer;
+				}
+
+				bh = bh->b_this_page;
+				end++;
+			} while (bh != head);
+
+			/* No mapped buffer in the range found in this page,
+			 * We need to look up next page.
+			 */
+			if (index >= ret) {
+				/* There is no page left, but we need to limit
+				 * newex->ec_len.
+				 */
+				newex->ec_len = end - newex->ec_block;
+				goto out;
+			}
+			goto next_page;
+		} else {
+			/*Find contiguous delayed buffers. */
+			if (ret > 0 && pages[0]->index == last_offset)
+				head = page_buffers(pages[0]);
+			bh = head;
+			index = 1;
+			start_index = 0;
+		}
+
+found_mapped_buffer:
+		if (bh != NULL && buffer_delay(bh)) {
+			/* 1st or contiguous delayed buffer found. */
+			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+				/*
+				 * 1st delayed buffer found, record
+				 * the start of extent.
+				 */
+				flags |= FIEMAP_EXTENT_DELALLOC;
+				newex->ec_block = end;
+				logical = (__u64)end << blksize_bits;
+			}
+			/* Find contiguous delayed buffers. */
+			do {
+				if (!buffer_delay(bh))
+					goto found_delayed_extent;
+				bh = bh->b_this_page;
+				end++;
+			} while (bh != head);
+
+			for (; index < ret; index++) {
+				if (!page_has_buffers(pages[index])) {
+					bh = NULL;
+					break;
+				}
+				head = page_buffers(pages[index]);
+				if (!head) {
+					bh = NULL;
+					break;
+				}
+
+				if (pages[index]->index !=
+				    pages[start_index]->index + index
+				    - start_index) {
+					/* Blocks are not contiguous. */
+					bh = NULL;
+					break;
+				}
+				bh = head;
+				do {
+					if (!buffer_delay(bh))
+						/* Delayed-extent ends. */
+						goto found_delayed_extent;
+					bh = bh->b_this_page;
+					end++;
+				} while (bh != head);
+			}
+		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
+			/* a hole found. */
+			goto out;
+
+found_delayed_extent:
+		newex->ec_len = min(end - newex->ec_block,
+				    (ext4_lblk_t)EXT_INIT_MAX_LEN);
+		if (ret == nr_pages && bh != NULL &&
+			newex->ec_len < EXT_INIT_MAX_LEN &&
+			buffer_delay(bh)) {
+			/* Have not collected an extent and continue. */
+			for (index = 0; index < ret; index++)
+				page_cache_release(pages[index]);
+			goto repeat;
+		}
+
+		for (index = 0; index < ret; index++)
+			page_cache_release(pages[index]);
+		kfree(pages);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	if (ext_seek_info->origin == SEEK_DATA) {
+		ext_seek_info->offset = logical;
+		return EXT_BREAK;
+	}
+
+	return EXT_CONTINUE;
+}
+
+int ext4_find_desired_extent(struct inode *inode, loff_t *offset, int origin)
+{
+	ext4_lblk_t start_blk;
+	ext4_lblk_t end_blk;
+	ext4_lblk_t len_blks;
+	struct ext4_extent_seek_info ext_seek_info;
+	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
+	int error = 0;
+
+	/* Only support seeking extents based file. */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return -ENOTSUPP;
+
+	start_blk = *offset >> blkbits;
+	if (start_blk >= EXT_MAX_BLOCKS)
+		return -ENXIO;
+
+	end_blk = i_size_read(inode) >> blkbits;
+	len_blks = ((ext4_lblk_t)end_blk) - start_blk + 1;
+
+	ext_seek_info.origin = origin;
+	error = ext4_ext_walk_space(inode, start_blk, len_blks,
+				    ext4_ext_seek_cb, &ext_seek_info);
+	if (!error)
+		*offset = ext_seek_info.offset;
+
+	return error;
+}
+
+/*
  * Callback function called for each extent to gather FIEMAP information.
  */
 static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..48579d5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -219,6 +219,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 	loff_t maxbytes;
+	int ret;
 
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
@@ -241,21 +242,20 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= inode->i_size) {
-			mutex_unlock(&inode->i_mutex);
-			return -ENXIO;
-		}
-		break;
 	case SEEK_HOLE:
 		/*
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= inode->i_size) {
+		if (offset >= i_size_read(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -ENXIO;
 		}
-		offset = inode->i_size;
+		ret = ext4_find_desired_extent(inode, &offset, origin);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
 		break;
 	}
 
-- 
1.7.4.1
