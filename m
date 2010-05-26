From: npiggin@suse.de
Subject: [patch 5/6] [PATCH] ext2: convert to use the new truncate convention.
Date: Thu, 27 May 2010 01:05:37 +1000
Message-ID: <20100526151542.051900106@suse.de>
References: <20100526150532.718322484@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab0EZPw5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 11:52:57 -0400
Content-Disposition: inline; filename=vfs-2.6.git-a6ea9a7206eceddd62ec468e595f7b086a32fd7c.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I also have commented a possible bug in existing ext2 code, marked with XXX.

Cc: linux-ext4@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/ext2/ext2.h  |    1 
 fs/ext2/file.c  |    1 
 fs/ext2/inode.c |  153 +++++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 119 insertions(+), 36 deletions(-)

Index: linux-2.6/fs/ext2/ext2.h
===================================================================
--- linux-2.6.orig/fs/ext2/ext2.h
+++ linux-2.6/fs/ext2/ext2.h
@@ -122,7 +122,6 @@ extern int ext2_write_inode (struct inod
 extern void ext2_delete_inode (struct inode *);
 extern int ext2_sync_inode (struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
-extern void ext2_truncate (struct inode *);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern void ext2_get_inode_flags(struct ext2_inode_info *);
Index: linux-2.6/fs/ext2/file.c
===================================================================
--- linux-2.6.orig/fs/ext2/file.c
+++ linux-2.6/fs/ext2/file.c
@@ -95,7 +95,6 @@ const struct file_operations ext2_xip_fi
 #endif
 
 const struct inode_operations ext2_file_inode_operations = {
-	.truncate	= ext2_truncate,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -54,6 +54,18 @@ static inline int ext2_inode_is_fast_sym
 		inode->i_blocks - ea_blocks == 0);
 }
 
+static void ext2_truncate_blocks(struct inode *inode, loff_t offset);
+
+static void ext2_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		ext2_truncate_blocks(inode, inode->i_size);
+	}
+}
+
 /*
  * Called at the last iput() if i_nlink is zero.
  */
@@ -71,7 +83,7 @@ void ext2_delete_inode (struct inode * i
 
 	inode->i_size = 0;
 	if (inode->i_blocks)
-		ext2_truncate (inode);
+		ext2_truncate_blocks(inode, 0);
 	ext2_free_inode (inode);
 
 	return;
@@ -757,8 +769,8 @@ int __ext2_write_begin(struct file *file
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
 {
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext2_get_block);
+	return block_write_begin_newtrunc(file, mapping, pos, len, flags,
+					pagep, fsdata, ext2_get_block);
 }
 
 static int
@@ -766,8 +778,25 @@ ext2_write_begin(struct file *file, stru
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
 {
+	int ret;
+
 	*pagep = NULL;
-	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
+	ret = __ext2_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+	if (ret < 0)
+		ext2_write_failed(mapping, pos + len);
+	return ret;
+}
+
+static int ext2_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	int ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret < len)
+		ext2_write_failed(mapping, pos + len);
+	return ret;
 }
 
 static int
@@ -775,13 +804,18 @@ ext2_nobh_write_begin(struct file *file,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
 {
+	int ret;
+
 	/*
 	 * Dir-in-pagecache still uses ext2_write_begin. Would have to rework
 	 * directory handling code to pass around offsets rather than struct
 	 * pages in order to make this work easily.
 	 */
-	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext2_get_block);
+	ret = nobh_write_begin_newtrunc(file, mapping, pos, len, flags, pagep,
+						fsdata, ext2_get_block);
+	if (ret < 0)
+		ext2_write_failed(mapping, pos + len);
+	return ret;
 }
 
 static int ext2_nobh_writepage(struct page *page,
@@ -800,10 +834,15 @@ ext2_direct_IO(int rw, struct kiocb *ioc
 			loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, ext2_get_block, NULL);
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	ssize_t ret;
+
+	ret = blockdev_direct_IO_newtrunc(rw, iocb, inode, inode->i_sb->s_bdev,
+				iov, offset, nr_segs, ext2_get_block, NULL);
+	if (ret < 0 && (rw & WRITE))
+		ext2_write_failed(mapping, offset + iov_length(iov, nr_segs));
+	return ret;
 }
 
 static int
@@ -818,7 +857,7 @@ const struct address_space_operations ex
 	.writepage		= ext2_writepage,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext2_write_begin,
-	.write_end		= generic_write_end,
+	.write_end		= ext2_write_end,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
@@ -1027,7 +1066,7 @@ static void ext2_free_branches(struct in
 		ext2_free_data(inode, p, q);
 }
 
-void ext2_truncate(struct inode *inode)
+static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	__le32 *i_data = EXT2_I(inode)->i_data;
 	struct ext2_inode_info *ei = EXT2_I(inode);
@@ -1039,27 +1078,8 @@ void ext2_truncate(struct inode *inode)
 	int n;
 	long iblock;
 	unsigned blocksize;
-
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	    S_ISLNK(inode->i_mode)))
-		return;
-	if (ext2_inode_is_fast_symlink(inode))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-		return;
-
 	blocksize = inode->i_sb->s_blocksize;
-	iblock = (inode->i_size + blocksize-1)
-					>> EXT2_BLOCK_SIZE_BITS(inode->i_sb);
-
-	if (mapping_is_xip(inode->i_mapping))
-		xip_truncate_page(inode->i_mapping, inode->i_size);
-	else if (test_opt(inode->i_sb, NOBH))
-		nobh_truncate_page(inode->i_mapping,
-				inode->i_size, ext2_get_block);
-	else
-		block_truncate_page(inode->i_mapping,
-				inode->i_size, ext2_get_block);
+	iblock = (offset + blocksize-1) >> EXT2_BLOCK_SIZE_BITS(inode->i_sb);
 
 	n = ext2_block_to_path(inode, iblock, offsets, NULL);
 	if (n == 0)
@@ -1127,6 +1147,62 @@ do_indirects:
 	ext2_discard_reservation(inode);
 
 	mutex_unlock(&ei->truncate_mutex);
+}
+
+static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
+{
+	/*
+	 * XXX: it seems like a bug here that we don't allow
+	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
+	 * review and fix this.
+	 *
+	 * Also would be nice to be able to handle IO errors and such,
+	 * but that's probably too much to ask.
+	 */
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+	    S_ISLNK(inode->i_mode)))
+		return;
+	if (ext2_inode_is_fast_symlink(inode))
+		return;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return;
+	__ext2_truncate_blocks(inode, offset);
+}
+
+int ext2_setsize(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	int error;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		return error;
+
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+	    S_ISLNK(inode->i_mode)))
+		return -EINVAL;
+	if (ext2_inode_is_fast_symlink(inode))
+		return -EINVAL;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+
+	if (mapping_is_xip(inode->i_mapping))
+		error = xip_truncate_page(inode->i_mapping, newsize);
+	else if (test_opt(inode->i_sb, NOBH))
+		error = nobh_truncate_page(inode->i_mapping,
+				newsize, ext2_get_block);
+	else
+		error = block_truncate_page(inode->i_mapping,
+				newsize, ext2_get_block);
+	if (error)
+		return error;
+
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+
+	__ext2_truncate_blocks(inode, newsize);
+
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
@@ -1134,6 +1210,8 @@ do_indirects:
 	} else {
 		mark_inode_dirty(inode);
 	}
+
+	return 0;
 }
 
 static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
@@ -1474,8 +1552,15 @@ int ext2_setattr(struct dentry *dentry,
 		if (error)
 			return error;
 	}
-	error = inode_setattr(inode, iattr);
-	if (!error && (iattr->ia_valid & ATTR_MODE))
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = ext2_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+	generic_setattr(inode, iattr);
+	if (iattr->ia_valid & ATTR_MODE)
 		error = ext2_acl_chmod(inode);
+	mark_inode_dirty(inode);
+
 	return error;
 }


