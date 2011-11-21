From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 04/19] ext4: Add read support for inline data.
Date: Tue, 22 Nov 2011 00:39:42 +0800
Message-ID: <1321893597-11024-4-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53951 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755781Ab1KUQmg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 11:42:36 -0500
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Let readpage and readpages handle the case when we
want to read an inlined file.

Signed-off-by: Tao Ma <boyu.mt@taobao.comc.
---
 fs/ext4/inline.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/inode.c  |   25 +++++++++++++++++++++++++
 fs/ext4/xattr.h  |    7 +++++++
 3 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d3aa377..fa8f554 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -163,12 +163,6 @@ int ext4_read_inline_data(struct inode *inode, void *buffer, unsigned int len)
 	if (error)
 		return error;
 
-	down_read(&EXT4_I(inode)->xattr_sem);
-	if(!EXT4_I(inode)->i_inline_off) {
-		ext4_warning(inode->i_sb, "inode %lu doesn't have inline data.",
-			     inode->i_ino);
-		goto out;
-	}
 	BUG_ON(len > EXT4_I(inode)->i_inline_size);
 
 
@@ -193,7 +187,6 @@ int ext4_read_inline_data(struct inode *inode, void *buffer, unsigned int len)
 	cp_len += len;
 
 out:
-	up_read(&EXT4_I(inode)->xattr_sem);
 	brelse(iloc.bh);
 	return cp_len;
 }
@@ -447,6 +440,52 @@ out:
 	return error;
 }
 
+static int ext4_read_inline_page(struct inode *inode, struct page *page)
+{
+	void *kaddr;
+	loff_t size;
+	int ret = 0;
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
+	down_read(&EXT4_I(inode)->xattr_sem);
+	if(!EXT4_I(inode)->i_inline_off) {
+		ext4_warning(inode->i_sb, "inode %lu doesn't have inline data.",
+			     inode->i_ino);
+		goto out;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	ret = ext4_read_inline_data(inode, kaddr, size);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+	SetPageUptodate(page);
+
+out:
+	up_read(&EXT4_I(inode)->xattr_sem);
+	return ret;
+}
+
+int ext4_readpage_inline(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	ret = ext4_read_inline_page(inode, page);
+
+	unlock_page(page);
+	return ret;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b1fbf5..4f764b7 100644
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
 
@@ -2633,6 +2636,12 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
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
@@ -2678,7 +2687,13 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 
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
 
@@ -2686,6 +2701,12 @@ static int
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
 
@@ -3007,6 +3028,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
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
index e436d33..129ead1 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -139,6 +139,8 @@ extern int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
 extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
 				 unsigned int len);
 extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
+
+extern int ext4_readpage_inline(struct inode *inode, struct page *page);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -260,6 +262,11 @@ static inline int ext4_destroy_inline_data(handle_t *handle,
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

