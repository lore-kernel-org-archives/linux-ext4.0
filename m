From: Tao Ma <tm@tao.ma>
Subject: [PATCH V4 04/22] ext4: Add read support for inline data.
Date: Mon, 20 Feb 2012 15:01:38 +0800
Message-ID: <1329721316-4955-4-git-send-email-tm@tao.ma>
References: <4F41EF95.2000909@tao.ma>
 <1329721316-4955-1-git-send-email-tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:53841 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751506Ab2BTHCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 02:02:34 -0500
In-Reply-To: <1329721316-4955-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Let readpage and readpages handle the case when we
want to read an inlined file.

Signed-off-by: Tao Ma <boyu.mt@taobao.comc.
---
 fs/ext4/inline.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c  |   31 ++++++++++++++++++++++++++-
 fs/ext4/xattr.h  |    7 ++++++
 3 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 77cedd2..97ca5de 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -444,6 +444,67 @@ out:
 	return error;
 }
 
+static int ext4_read_inline_page(struct inode *inode, struct page *page)
+{
+	void *kaddr;
+	int ret = 0;
+	size_t len;
+	struct ext4_iloc iloc;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!ext4_has_inline_data(inode));
+	BUG_ON(page->index);
+
+	if (!EXT4_I(inode)->i_inline_off) {
+		ext4_warning(inode->i_sb, "inode %lu doesn't have inline data.",
+			     inode->i_ino);
+		goto out;
+	}
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		goto out;
+
+	len = min_t(size_t, ext4_get_inline_size(inode), i_size_read(inode));
+	kaddr = kmap_atomic(page, KM_USER0);
+	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_segment(page, len, PAGE_CACHE_SIZE);
+	SetPageUptodate(page);
+	brelse(iloc.bh);
+
+out:
+	return ret;
+}
+
+int ext4_readpage_inline(struct inode *inode, struct page *page)
+{
+	int ret = 0;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	if (!ext4_has_inline_data(inode)) {
+		up_read(&EXT4_I(inode)->xattr_sem);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Current inline data can only exist in the 1st page,
+	 * So for all the other pages, just set them uptodate.
+	 */
+	if (!page->index)
+		ret = ext4_read_inline_page(inode, page);
+	else if (!PageUptodate(page)) {
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
+	}
+
+	up_read(&EXT4_I(inode)->xattr_sem);
+
+	unlock_page(page);
+	return ret >= 0 ? 0 : ret;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b94a388..f631070 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -594,6 +594,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 	int ret = 0, started = 0;
 	int dio_credits;
 
+	if (ext4_has_inline_data(inode))
+		return -ERANGE;
+
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
 
@@ -2620,6 +2623,12 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	journal_t *journal;
 	int err;
 
+	/*
+	 * XXX: Can we arrive here for a inline file? Maybe not.
+	 */
+	if (ext4_has_inline_data(inode))
+		return 0;
+
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 			test_opt(inode->i_sb, DELALLOC)) {
 		/*
@@ -2665,14 +2674,30 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 
 static int ext4_readpage(struct file *file, struct page *page)
 {
+	int ret = -EAGAIN;
+	struct inode *inode = page->mapping->host;
+
 	trace_ext4_readpage(page);
-	return mpage_readpage(page, ext4_get_block);
+
+	if (ext4_has_inline_data(inode))
+		ret = ext4_readpage_inline(inode, page);
+
+	if (ret == -EAGAIN)
+		return mpage_readpage(page, ext4_get_block);
+
+	return ret;
 }
 
 static int
 ext4_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	struct inode *inode = mapping->host;
+
+	/* If the file has inline data, no need to do readpages. */
+	if (ext4_has_inline_data(inode))
+		return 0;
+
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
@@ -2994,6 +3019,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_should_journal_data(inode))
 		return 0;
 
+	/* Let buffer I/O handle the inline data case. */
+	if (ext4_has_inline_data(inode))
+		return 0;
+
 	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 2fe373f..8971d06 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -137,6 +137,8 @@ extern int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
 extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
 				 unsigned int len);
 extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
+
+extern int ext4_readpage_inline(struct inode *inode, struct page *page);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -252,6 +254,11 @@ static inline int ext4_destroy_inline_data(handle_t *handle,
 {
 	return 0;
 }
+
+static inline int ext4_readpage_inline(struct inode *inode, struct page *page)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

