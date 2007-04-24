From: Nick Piggin <npiggin@suse.de>
Subject: [patch 17/44] ext2 convert to new aops
Date: Tue, 24 Apr 2007 11:24:03 +1000
Message-ID: <20070424013434.915052000@suse.de>
References: <20070424012346.696840000@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Mark Fasheh <mark.fasheh@oracle.com>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161590AbXDXFUx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 01:20:53 -0400
Content-Disposition: inline; filename=fs-ext2-aops.patch
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Cc: linux-ext4@vger.kernel.org
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>

 fs/ext2/dir.c   |   47 +++++++++++++++++++++++++++++------------------
 fs/ext2/ext2.h  |    3 +++
 fs/ext2/inode.c |   24 +++++++++++++-----------
 3 files changed, 45 insertions(+), 29 deletions(-)

Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -726,18 +726,21 @@ ext2_readpages(struct file *file, struct
 	return mpage_readpages(mapping, pages, nr_pages, ext2_get_block);
 }
 
-static int
-ext2_prepare_write(struct file *file, struct page *page,
-			unsigned from, unsigned to)
+int __ext2_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
 {
-	return block_prepare_write(page,from,to,ext2_get_block);
+	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext2_get_block);
 }
 
 static int
-ext2_nobh_prepare_write(struct file *file, struct page *page,
-			unsigned from, unsigned to)
+ext2_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
 {
-	return nobh_prepare_write(page,from,to,ext2_get_block);
+	*pagep = NULL;
+	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
 }
 
 static int ext2_nobh_writepage(struct page *page,
@@ -773,8 +776,8 @@ const struct address_space_operations ex
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_writepage,
 	.sync_page		= block_sync_page,
-	.prepare_write		= ext2_prepare_write,
-	.commit_write		= generic_commit_write,
+	.write_begin		= ext2_write_begin,
+	.write_end		= generic_write_end,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
@@ -791,8 +794,7 @@ const struct address_space_operations ex
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_nobh_writepage,
 	.sync_page		= block_sync_page,
-	.prepare_write		= ext2_nobh_prepare_write,
-	.commit_write		= nobh_commit_write,
+	/* XXX: todo */
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
Index: linux-2.6/fs/ext2/dir.c
===================================================================
--- linux-2.6.orig/fs/ext2/dir.c
+++ linux-2.6/fs/ext2/dir.c
@@ -22,6 +22,7 @@
  */
 
 #include "ext2.h"
+#include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
@@ -61,12 +62,14 @@ ext2_last_byte(struct inode *inode, unsi
 	return last_byte;
 }
 
-static int ext2_commit_chunk(struct page *page, unsigned from, unsigned to)
+static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct inode *dir = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	int err = 0;
+
 	dir->i_version++;
-	page->mapping->a_ops->commit_write(NULL, page, from, to);
+	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 	if (IS_DIRSYNC(dir))
 		err = write_one_page(page, 1);
 	else
@@ -412,16 +415,18 @@ ino_t ext2_inode_by_name(struct inode * 
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 			struct page *page, struct inode *inode)
 {
-	unsigned from = (char *) de - (char *) page_address(page);
-	unsigned to = from + le16_to_cpu(de->rec_len);
+	loff_t pos = (page->index << PAGE_CACHE_SHIFT) +
+			(char *) de - (char *) page_address(page);
+	unsigned len = le16_to_cpu(de->rec_len);
 	int err;
 
 	lock_page(page);
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __ext2_write_begin(NULL, page->mapping, pos, len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
 	de->inode = cpu_to_le32(inode->i_ino);
-	ext2_set_de_type (de, inode);
-	err = ext2_commit_chunk(page, from, to);
+	ext2_set_de_type(de, inode);
+	err = ext2_commit_chunk(page, pos, len);
 	ext2_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
@@ -444,7 +449,7 @@ int ext2_add_link (struct dentry *dentry
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	loff_t pos;
 	int err;
 
 	/*
@@ -497,9 +502,10 @@ int ext2_add_link (struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	from = (char*)de - (char*)page_address(page);
-	to = from + rec_len;
-	err = page->mapping->a_ops->prepare_write(NULL, page, from, to);
+	pos = (page->index << PAGE_CACHE_SHIFT) +
+		(char*)de - (char*)page_address(page);
+	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
+							&page, NULL);
 	if (err)
 		goto out_unlock;
 	if (de->inode) {
@@ -509,10 +515,10 @@ got_it:
 		de = de1;
 	}
 	de->name_len = namelen;
-	memcpy (de->name, name, namelen);
+	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
-	err = ext2_commit_chunk(page, from, to);
+	err = ext2_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
@@ -537,6 +543,7 @@ int ext2_delete_entry (struct ext2_dir_e
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(ext2_chunk_size(inode)-1);
 	unsigned to = ((char*)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	loff_t pos;
 	ext2_dirent * pde = NULL;
 	ext2_dirent * de = (ext2_dirent *) (kaddr + from);
 	int err;
@@ -553,13 +560,15 @@ int ext2_delete_entry (struct ext2_dir_e
 	}
 	if (pde)
 		from = (char*)pde - (char*)page_address(page);
+	pos = (page->index << PAGE_CACHE_SHIFT) + from;
 	lock_page(page);
-	err = mapping->a_ops->prepare_write(NULL, page, from, to);
+	err = __ext2_write_begin(NULL, page->mapping, pos, to - from, 0,
+							&page, NULL);
 	BUG_ON(err);
 	if (pde)
-		pde->rec_len = cpu_to_le16(to-from);
+		pde->rec_len = cpu_to_le16(to - from);
 	dir->inode = 0;
-	err = ext2_commit_chunk(page, from, to);
+	err = ext2_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	EXT2_I(inode)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(inode);
@@ -582,7 +591,9 @@ int ext2_make_empty(struct inode *inode,
 
 	if (!page)
 		return -ENOMEM;
-	err = mapping->a_ops->prepare_write(NULL, page, 0, chunk_size);
+
+	err = __ext2_write_begin(NULL, page->mapping, 0, chunk_size, 0,
+							&page, NULL);
 	if (err) {
 		unlock_page(page);
 		goto fail;
Index: linux-2.6/fs/ext2/ext2.h
===================================================================
--- linux-2.6.orig/fs/ext2/ext2.h
+++ linux-2.6/fs/ext2/ext2.h
@@ -133,6 +133,9 @@ extern int ext2_get_block(struct inode *
 extern void ext2_truncate (struct inode *);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
+int __ext2_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata);
 
 /* ioctl.c */
 extern int ext2_ioctl (struct inode *, struct file *, unsigned int,

-- 
