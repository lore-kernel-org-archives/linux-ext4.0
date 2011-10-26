From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 03/17] ext4: Add read support for inline data.
Date: Wed, 26 Oct 2011 15:34:14 +0800
Message-ID: <1319614468-11227-3-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Let readpage and readpages handle the case when we
want to read an inlined file.

Signed-off-by: Tao Ma <boyu.mt@taobao.comc.
---
 fs/ext4/inode.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 017e119..2fa8cf4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -540,6 +540,9 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 	int ret = 0, started = 0;
 	int dio_credits;
 
+	if (ext4_has_inline_data(inode))
+		return -ERANGE;
+
 	map.m_lblk = iblock;
 	map.m_len = bh->b_size >> inode->i_blkbits;
 
@@ -2483,6 +2486,12 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
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
@@ -2526,9 +2535,58 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, ext4_get_block);
 }
 
+static int ext4_read_inline_page(struct inode *inode, struct page *page)
+{
+	void *kaddr;
+	loff_t size;
+	int ret;
+	struct ext4_iloc iloc;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!ext4_has_inline_data(inode));
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	size = i_size_read(inode);
+
+	if (size > PAGE_CACHE_SIZE ||
+	    size > ext4_get_max_inline_size(inode)) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+			"bad size %ld for a inline file", (long)size);
+		return -EROFS;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	ext4_read_inline_data(inode, &iloc, kaddr, size);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+	SetPageUptodate(page);
+
+	brelse(iloc.bh);
+	return 0;
+}
+
+static int ext4_readpage_inline(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	ret = ext4_read_inline_page(inode, page);
+
+	unlock_page(page);
+	return ret;
+}
+
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
 
@@ -2536,6 +2594,12 @@ static int
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
 
@@ -2854,6 +2918,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
+	/* Let buffer I/O handle the inline data case. */
+	if (ext4_has_inline_data(inode))
+		return 0;
+
 	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
-- 
1.7.0.4
