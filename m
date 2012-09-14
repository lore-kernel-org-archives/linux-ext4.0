From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 06/23] ext4: Add journalled write support for inline data.
Date: Fri, 14 Sep 2012 19:24:54 +0800
Message-ID: <1347621911-4104-6-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:41566 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757954Ab2INLZ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:25:26 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1U-0001sO-AE
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:24 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   24 ++++++++++++++++++++++
 fs/ext4/inode.c  |   59 +++++++++++++++++++++++++++++++++++++----------------
 fs/ext4/xattr.h  |   12 +++++++++++
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 50c3e95..fc42ed0 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -741,6 +741,30 @@ out:
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
+	kaddr = kmap_atomic(page);
+	ext4_write_inline_data(inode, &iloc, kaddr, 0, len);
+	kunmap_atomic(kaddr);
+	up_write(&EXT4_I(inode)->xattr_sem);
+
+	return iloc.bh;
+}
+
 
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index de11f32..7a6d11a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1150,16 +1150,21 @@ static int ext4_journalled_write_end(struct file *file,
 
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
@@ -1933,15 +1938,23 @@ static int __ext4_journalled_writepage(struct page *page,
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
@@ -1954,11 +1967,19 @@ static int __ext4_journalled_writepage(struct page *page,
 
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
@@ -1966,9 +1987,11 @@ static int __ext4_journalled_writepage(struct page *page,
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
index 7d9bf51..91df676 100644
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
@@ -287,6 +291,14 @@ static inline int ext4_write_inline_data_end(struct inode *inode,
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
1.7.1

