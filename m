From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 04/21] ext4: Add read support for inline data.
Date: Sun, 18 Dec 2011 22:24:21 +0800
Message-ID: <1324218278-2460-4-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Let readpage and readpages handle the case when we
want to read an inlined file.

Signed-off-by: Tao Ma <boyu.mt@taobao.comc.
---
 fs/ext4/inline.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c  |   25 +++++++++++++++++++++++++
 fs/ext4/xattr.h  |    7 +++++++
 3 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index dd2b362..d6451a4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -437,6 +437,58 @@ out:
 	return error;
 }
 
+static int ext4_read_inline_page(struct inode *inode, struct page *page)
+{
+	void *kaddr;
+	loff_t size;
+	int ret = 0;
+	struct ext4_iloc iloc;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!ext4_has_inline_data(inode));
+
+	size = i_size_read(inode);
+
+	if (size > PAGE_CACHE_SIZE ||
+	    size > ext4_get_inline_size(inode)) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+			"bad size %ld for a inline file", (long)size);
+		return -EROFS;
+	}
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
+	kaddr = kmap_atomic(page, KM_USER0);
+	ret = ext4_read_inline_data(inode, kaddr, size, &iloc);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+	SetPageUptodate(page);
+	brelse(iloc.bh);
+
+out:
+	return ret;
+}
+
+int ext4_readpage_inline(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	ret = ext4_read_inline_page(inode, page);
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
index 3342724..837e259 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -592,6 +592,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 	int ret = 0, started = 0;
 	int dio_credits;
 
+	if (ext4_has_inline_data(inode))
+		return -ERANGE;
+
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
 
@@ -2634,6 +2637,12 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
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
@@ -2679,7 +2688,13 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 
 static int ext4_readpage(struct file *file, struct page *page)
 {
+	struct inode *inode = file->f_mapping->host;
+
 	trace_ext4_readpage(page);
+
+	if (ext4_has_inline_data(inode))
+		return ext4_readpage_inline(inode, page);
+
 	return mpage_readpage(page, ext4_get_block);
 }
 
@@ -2687,6 +2702,12 @@ static int
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
 
@@ -3008,6 +3029,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
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
index 9f1b217..bb226f4 100644
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
