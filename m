From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 06/19] ext4: Add journalled write support for inline data.
Date: Tue, 22 Nov 2011 00:39:44 +0800
Message-ID: <1321893597-11024-6-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   24 ++++++++++++++++++++++
 fs/ext4/inode.c  |   59 +++++++++++++++++++++++++++++++++++++----------------
 fs/ext4/xattr.h  |   12 +++++++++++
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1d1572b..e14d8e8 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -708,6 +708,30 @@ out:
 	return copied;
 }
 
+struct buffer_head *
+ext4_journalled_write_inline_data(struct inode *inode,
+				  unsigned len,
+				  struct page *page)
+{
+	int ret;
+	void *kaddr;
+	struct ext4_iloc iloc;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret) {
+		ext4_std_error(inode->i_sb, ret);
+		return NULL;
+	}
+
+	down_write(&EXT4_I(inode)->xattr_sem);
+	kaddr = kmap_atomic(page, KM_USER0);
+	ext4_write_inline_data(inode, &iloc, kaddr, 0, len);
+	kunmap_atomic(kaddr, KM_USER0);
+	up_write(&EXT4_I(inode)->xattr_sem);
+
+	return iloc.bh;
+}
+
 
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26ca9a7..32077cf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1062,16 +1062,21 @@ static int ext4_journalled_write_end(struct file *file,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (copied < len) {
-		if (!PageUptodate(page))
-			copied = 0;
-		page_zero_new_buffers(page, from+copied, to);
-	}
+	if (ext4_has_inline_data(inode))
+		copied = ext4_write_inline_data_end(inode, pos, len,
+						    copied, page);
+	else {
+		if (copied < len) {
+			if (!PageUptodate(page))
+				copied = 0;
+			page_zero_new_buffers(page, from+copied, to);
+		}
 
-	ret = walk_page_buffers(handle, page_buffers(page), from,
-				to, &partial, write_end_fn);
-	if (!partial)
-		SetPageUptodate(page);
+		ret = walk_page_buffers(handle, page_buffers(page), from,
+					to, &partial, write_end_fn);
+		if (!partial)
+			SetPageUptodate(page);
+	}
 	new_i_size = pos + copied;
 	if (new_i_size > inode->i_size)
 		i_size_write(inode, pos+copied);
@@ -1830,15 +1835,23 @@ static int __ext4_journalled_writepage(struct page *page,
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	struct buffer_head *page_bufs;
+	struct buffer_head *page_bufs = NULL;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	struct buffer_head *inode_bh = NULL;
 
 	ClearPageChecked(page);
-	page_bufs = page_buffers(page);
-	BUG_ON(!page_bufs);
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+
+	if (ext4_has_inline_data(inode)) {
+		BUG_ON(page->index != 0);
+		BUG_ON(len > ext4_get_max_inline_size(inode));
+		inode_bh = ext4_journalled_write_inline_data(inode, len, page);
+	} else {
+		page_bufs = page_buffers(page);
+		BUG_ON(!page_bufs);
+		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+	}
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
 	unlock_page(page);
@@ -1851,11 +1864,19 @@ static int __ext4_journalled_writepage(struct page *page,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				do_journal_get_write_access);
+	if (ext4_has_inline_data(inode) && inode_bh) {
+		ret = ext4_journal_get_write_access(handle, inode_bh);
+
+		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
+
+	} else {
+		ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					do_journal_get_write_access);
+
+		err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					write_end_fn);
+	}
 
-	err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				write_end_fn);
 	if (ret == 0)
 		ret = err;
 	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
@@ -1863,9 +1884,11 @@ static int __ext4_journalled_writepage(struct page *page,
 	if (!ret)
 		ret = err;
 
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
+	if (!ext4_has_inline_data(inode))
+		walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
+	brelse(inode_bh);
 	return ret;
 }
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index f2d9c53..85dbcc0 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -150,6 +150,10 @@ extern int ext4_write_inline_data_end(struct inode *inode,
 				      loff_t pos, unsigned len,
 				      unsigned copied,
 				      struct page *page);
+extern struct buffer_head *
+ext4_journalled_write_inline_data(struct inode *inode,
+				  unsigned len,
+				  struct page *page);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -293,6 +297,14 @@ static inline int ext4_write_inline_data_end(struct inode *inode,
 {
 	return 0;
 }
+
+static inline struct buffer_head *
+ext4_journalled_write_inline_data(struct inode *inode,
+				  unsigned len,
+				  struct page *page)
+{
+	return NULL;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4
