From: akpm@linux-foundation.org
Subject: [to-be-updated] ext2-convert-to-use-the-new-truncate-convention.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:32:19 -0700
Message-ID: <200909241932.n8OJWJ3F026541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de,
	hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk,
	jack@suse.cz, linux-ext4@vger.kernel.org, miklos@szeredi.hu,
	sfrench@us.i
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: convert to use the new truncate convention.
has been removed from the -mm tree.  Its filename was
     ext2-convert-to-use-the-new-truncate-convention.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: convert to use the new truncate convention.
From: Nick Piggin <npiggin@suse.de>

I also have commented a possible bug in existing ext2 code, marked with
XXX.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h  |    1 
 fs/ext2/file.c  |    2 
 fs/ext2/inode.c |  142 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 116 insertions(+), 29 deletions(-)

diff -puN fs/ext2/ext2.h~ext2-convert-to-use-the-new-truncate-convention fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-convert-to-use-the-new-truncate-convention
+++ a/fs/ext2/ext2.h
@@ -122,7 +122,6 @@ extern int ext2_write_inode (struct inod
 extern void ext2_delete_inode (struct inode *);
 extern int ext2_sync_inode (struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
-extern void ext2_truncate (struct inode *);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern void ext2_get_inode_flags(struct ext2_inode_info *);
diff -puN fs/ext2/file.c~ext2-convert-to-use-the-new-truncate-convention fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-convert-to-use-the-new-truncate-convention
+++ a/fs/ext2/file.c
@@ -77,13 +77,13 @@ const struct file_operations ext2_xip_fi
 #endif
 
 const struct inode_operations ext2_file_inode_operations = {
-	.truncate	= ext2_truncate,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
+	.new_truncate	= 1,
 	.setattr	= ext2_setattr,
 	.check_acl	= ext2_check_acl,
 	.fiemap		= ext2_fiemap,
diff -puN fs/ext2/inode.c~ext2-convert-to-use-the-new-truncate-convention fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-convert-to-use-the-new-truncate-convention
+++ a/fs/ext2/inode.c
@@ -53,6 +53,8 @@ static inline int ext2_inode_is_fast_sym
 		inode->i_blocks - ea_blocks == 0);
 }
 
+static void ext2_truncate_blocks(struct inode *inode, loff_t offset);
+
 /*
  * Called at the last iput() if i_nlink is zero.
  */
@@ -68,7 +70,7 @@ void ext2_delete_inode (struct inode * i
 
 	inode->i_size = 0;
 	if (inode->i_blocks)
-		ext2_truncate (inode);
+		ext2_truncate_blocks(inode, 0);
 	ext2_free_inode (inode);
 
 	return;
@@ -761,8 +763,33 @@ ext2_write_begin(struct file *file, stru
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
 {
+	int ret;
+
 	*pagep = NULL;
-	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
+	ret = __ext2_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+	if (ret < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			ext2_truncate_blocks(inode, isize);
+	}
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
+	if (ret < len) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			ext2_truncate_blocks(inode, isize);
+	}
+	return ret;
 }
 
 static int
@@ -770,13 +797,22 @@ ext2_nobh_write_begin(struct file *file,
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
+	ret = nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 							ext2_get_block);
+	if (ret < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			ext2_truncate_blocks(inode, isize);
+	}
+	return ret;
 }
 
 static int ext2_nobh_writepage(struct page *page,
@@ -796,9 +832,15 @@ ext2_direct_IO(int rw, struct kiocb *ioc
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				offset, nr_segs, ext2_get_block, NULL);
+	if (ret < 0 && (rw & WRITE)) {
+		loff_t isize = inode->i_size;
+		ext2_truncate_blocks(inode, isize);
+	}
+	return ret;
 }
 
 static int
@@ -813,7 +855,7 @@ const struct address_space_operations ex
 	.writepage		= ext2_writepage,
 	.sync_page		= block_sync_page,
 	.write_begin		= ext2_write_begin,
-	.write_end		= generic_write_end,
+	.write_end		= ext2_write_end,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
@@ -1022,7 +1064,7 @@ static void ext2_free_branches(struct in
 		ext2_free_data(inode, p, q);
 }
 
-void ext2_truncate(struct inode *inode)
+static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	__le32 *i_data = EXT2_I(inode)->i_data;
 	struct ext2_inode_info *ei = EXT2_I(inode);
@@ -1034,27 +1076,8 @@ void ext2_truncate(struct inode *inode)
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
@@ -1122,6 +1145,62 @@ do_indirects:
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
@@ -1129,6 +1208,8 @@ do_indirects:
 	} else {
 		mark_inode_dirty(inode);
 	}
+
+	return 0;
 }
 
 static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
@@ -1461,8 +1542,15 @@ int ext2_setattr(struct dentry *dentry, 
 		if (error)
 			return error;
 	}
-	error = inode_setattr(inode, iattr);
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = ext2_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+	generic_setattr(inode, iattr);
 	if (!error && (iattr->ia_valid & ATTR_MODE))
 		error = ext2_acl_chmod(inode);
+	mark_inode_dirty(inode);
+
 	return error;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

