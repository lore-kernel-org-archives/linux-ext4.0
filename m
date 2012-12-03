From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix inline data build warning found by kernel build testing.
Date: Mon,  3 Dec 2012 16:28:22 +0800
Message-ID: <1354523302-6790-1-git-send-email-tm@tao.ma>
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42325 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752640Ab2LCI2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2012 03:28:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

This patch just tries to silence all the build warning found
by Fengguang's kernel build testing. It has following fixes:
1. change all walk_page_buffers to ext4_walk_page_buffers to avoid
   a conflict with ocfs2.
2. make ext4_get_inline_xattr_pos static.
3. make ext4_xattr_ibody_set static.
4. change two or more data types in declaration specifiers for
   ext4_convert_inline_data.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Theodore Tso <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h   |   14 +++++++-------
 fs/ext4/inline.c |    8 +++++---
 fs/ext4/inode.c  |   48 ++++++++++++++++++++++++++----------------------
 fs/ext4/xattr.c  |    6 +++---
 fs/ext4/xattr.h  |    2 +-
 5 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6967c26..2dd5824 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2041,13 +2041,13 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			   struct buffer_head *bh, int create);
-int walk_page_buffers(handle_t *handle,
-			     struct buffer_head *head,
-			     unsigned from,
-			     unsigned to,
-			     int *partial,
-			     int (*fn)(handle_t *handle,
-				       struct buffer_head *bh));
+int ext4_walk_page_buffers(handle_t *handle,
+			   struct buffer_head *head,
+			   unsigned from,
+			   unsigned to,
+			   int *partial,
+			   int (*fn)(handle_t *handle,
+				     struct buffer_head *bh));
 int do_journal_get_write_access(handle_t *handle,
 				struct buffer_head *bh);
 #define FALL_BACK_TO_NONDELALLOC 1
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d98eb46..6c15e63 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -583,8 +583,9 @@ retry:
 		ret = __block_write_begin(page, from, to, ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
-		ret = walk_page_buffers(handle, page_buffers(page),
-				from, to, NULL, do_journal_get_write_access);
+		ret = ext4_walk_page_buffers(handle, page_buffers(page),
+					     from, to, NULL,
+					     do_journal_get_write_access);
 	}
 
 	if (ret) {
@@ -1023,7 +1024,8 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	return 1;
 }
 
-void *ext4_get_inline_xattr_pos(struct inode *inode, struct ext4_iloc *iloc)
+static void *ext4_get_inline_xattr_pos(struct inode *inode,
+				       struct ext4_iloc *iloc)
 {
 	struct ext4_xattr_entry *entry;
 	struct ext4_xattr_ibody_header *header;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b314a0c..dbc5784 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -801,13 +801,13 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 	return NULL;
 }
 
-int walk_page_buffers(handle_t *handle,
-			     struct buffer_head *head,
-			     unsigned from,
-			     unsigned to,
-			     int *partial,
-			     int (*fn)(handle_t *handle,
-				       struct buffer_head *bh))
+int ext4_walk_page_buffers(handle_t *handle,
+			   struct buffer_head *head,
+			   unsigned from,
+			   unsigned to,
+			   int *partial,
+			   int (*fn)(handle_t *handle,
+				     struct buffer_head *bh))
 {
 	struct buffer_head *bh;
 	unsigned block_start, block_end;
@@ -940,8 +940,9 @@ retry:
 		ret = __block_write_begin(page, pos, len, ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
-		ret = walk_page_buffers(handle, page_buffers(page),
-				from, to, NULL, do_journal_get_write_access);
+		ret = ext4_walk_page_buffers(handle, page_buffers(page),
+					     from, to, NULL,
+					     do_journal_get_write_access);
 	}
 
 	if (ret) {
@@ -1162,8 +1163,8 @@ static int ext4_journalled_write_end(struct file *file,
 			page_zero_new_buffers(page, from+copied, to);
 		}
 
-		ret = walk_page_buffers(handle, page_buffers(page), from,
-					to, &partial, write_end_fn);
+		ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
+					     to, &partial, write_end_fn);
 		if (!partial)
 			SetPageUptodate(page);
 	}
@@ -1967,7 +1968,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	} else {
 		page_bufs = page_buffers(page);
 		BUG_ON(!page_bufs);
-		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+		ext4_walk_page_buffers(handle, page_bufs,
+				       0, len, NULL, bget_one);
 	}
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
@@ -1987,11 +1989,11 @@ static int __ext4_journalled_writepage(struct page *page,
 		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
 
 	} else {
-		ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-					do_journal_get_write_access);
+		ret = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					     do_journal_get_write_access);
 
-		err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-					write_end_fn);
+		err = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					     write_end_fn);
 	}
 
 	if (ret == 0)
@@ -2002,7 +2004,8 @@ static int __ext4_journalled_writepage(struct page *page,
 		ret = err;
 
 	if (!ext4_has_inline_data(inode))
-		walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
+		ext4_walk_page_buffers(handle, page_bufs,
+				       0, len, NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
 	brelse(inode_bh);
@@ -2082,8 +2085,8 @@ static int ext4_writepage(struct page *page,
 		commit_write = 1;
 	}
 	page_bufs = page_buffers(page);
-	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-			      ext4_bh_delay_or_unwritten)) {
+	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+				   ext4_bh_delay_or_unwritten)) {
 		/*
 		 * We don't want to do block allocation, so redirty
 		 * the page and return.  We may reach here when we do
@@ -4944,8 +4947,9 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * journal_start/journal_stop which can block and take a long time
 	 */
 	if (page_has_buffers(page)) {
-		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped)) {
+		if (!ext4_walk_page_buffers(NULL, page_buffers(page),
+					    0, len, NULL,
+					    ext4_bh_unmapped)) {
 			/* Wait so that we don't change page under IO */
 			wait_on_page_writeback(page);
 			ret = VM_FAULT_LOCKED;
@@ -4966,7 +4970,7 @@ retry_alloc:
 	}
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	if (!ret && ext4_should_journal_data(inode)) {
-		if (walk_page_buffers(handle, page_buffers(page), 0,
+		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
 			ret = VM_FAULT_SIGBUS;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e83beb2..5255794 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -997,9 +997,9 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
-			 struct ext4_xattr_info *i,
-			 struct ext4_xattr_ibody_find *is)
+static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+				struct ext4_xattr_info *i,
+				struct ext4_xattr_ibody_find *is)
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_search *s = &is->s;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 9a7986c..39ef0d6 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -419,7 +419,7 @@ static inline void ext4_inline_data_truncate(struct inode *inode,
 	return;
 }
 
-static int int ext4_convert_inline_data(struct inode *inode)
+static int ext4_convert_inline_data(struct inode *inode)
 {
 	return 0;
 }
-- 
1.7.1

