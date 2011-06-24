From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/9] fs: move inode_dio_wait calls into ->setattr
Date: Fri, 24 Jun 2011 14:29:45 -0400
Message-ID: <20110624183207.921778908@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56824
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab1FXScO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 14:32:14 -0400
Content-Disposition: inline; filename=fs-move-dio_wait
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let filesystems handle waiting for direct I/O requests themselves instead
of doing it beforehand.  This means filesystem-specific locks to prevent
new dio referenes from appearing can be held.  This is important to allow
generalizing i_dio_count to non-DIO_LOCKING filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2011-06-20 09:28:54.516815966 +0200
+++ linux-2.6/fs/ocfs2/file.c	2011-06-20 09:31:34.706807855 +0200
@@ -1142,6 +1142,8 @@ int ocfs2_setattr(struct dentry *dentry,
 		if (status)
 			goto bail_unlock;
 
+		inode_dio_wait(inode);
+
 		if (i_size_read(inode) > attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2011-06-20 09:28:54.490149300 +0200
+++ linux-2.6/fs/attr.c	2011-06-20 09:29:06.000000000 +0200
@@ -232,9 +232,6 @@ int notify_change(struct dentry * dentry
 	if (error)
 		return error;
 
-	if (ia_valid & ATTR_SIZE)
-		inode_dio_wait(inode);
-
 	if (inode->i_op->setattr)
 		error = inode->i_op->setattr(dentry, attr);
 	else
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2011-06-18 12:54:28.058273680 +0200
+++ linux-2.6/fs/ext2/inode.c	2011-06-20 09:29:06.500148692 +0200
@@ -1184,6 +1184,8 @@ static int ext2_setsize(struct inode *in
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return -EPERM;
 
+	inode_dio_wait(inode);
+
 	if (mapping_is_xip(inode->i_mapping))
 		error = xip_truncate_page(inode->i_mapping, newsize);
 	else if (test_opt(inode->i_sb, NOBH))
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c	2011-06-18 12:54:28.071607014 +0200
+++ linux-2.6/fs/ext3/inode.c	2011-06-20 09:29:06.500148692 +0200
@@ -3216,6 +3216,9 @@ int ext3_setattr(struct dentry *dentry,
 		ext3_journal_stop(handle);
 	}
 
+	if (attr->ia_valid & ATTR_SIZE)
+		inode_dio_wait(inode);
+
 	if (S_ISREG(inode->i_mode) &&
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c	2011-06-20 09:28:54.506815967 +0200
+++ linux-2.6/fs/ext4/inode.c	2011-06-20 09:29:06.000000000 +0200
@@ -5351,6 +5351,8 @@ int ext4_setattr(struct dentry *dentry,
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
+		inode_dio_wait(inode);
+
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
Index: linux-2.6/fs/fat/file.c
===================================================================
--- linux-2.6.orig/fs/fat/file.c	2011-06-18 12:54:28.118273678 +0200
+++ linux-2.6/fs/fat/file.c	2011-06-20 09:29:06.000000000 +0200
@@ -397,6 +397,8 @@ int fat_setattr(struct dentry *dentry, s
 	 * sequence.
 	 */
 	if (attr->ia_valid & ATTR_SIZE) {
+		inode_dio_wait(inode);
+
 		if (attr->ia_size > inode->i_size) {
 			error = fat_cont_expand(inode, attr->ia_size);
 			if (error || attr->ia_valid == ATTR_SIZE)
Index: linux-2.6/fs/gfs2/bmap.c
===================================================================
--- linux-2.6.orig/fs/gfs2/bmap.c	2011-06-18 12:54:28.141607009 +0200
+++ linux-2.6/fs/gfs2/bmap.c	2011-06-20 09:29:06.510148693 +0200
@@ -1224,6 +1224,8 @@ int gfs2_setattr_size(struct inode *inod
 	if (ret)
 		return ret;
 
+	inode_dio_wait(inode);
+
 	oldsize = inode->i_size;
 	if (newsize >= oldsize)
 		return do_grow(inode, newsize);
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2011-06-18 12:54:28.154940342 +0200
+++ linux-2.6/fs/hfs/inode.c	2011-06-20 09:29:06.000000000 +0200
@@ -615,6 +615,8 @@ int hfs_inode_setattr(struct dentry *den
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
+		inode_dio_wait(inode);
+
 		error = vmtruncate(inode, attr->ia_size);
 		if (error)
 			return error;
Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2011-06-18 12:54:28.168273676 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2011-06-20 09:29:06.000000000 +0200
@@ -296,6 +296,8 @@ static int hfsplus_setattr(struct dentry
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
+		inode_dio_wait(inode);
+
 		error = vmtruncate(inode, attr->ia_size);
 		if (error)
 			return error;
Index: linux-2.6/fs/jfs/file.c
===================================================================
--- linux-2.6.orig/fs/jfs/file.c	2011-06-18 12:54:28.191607007 +0200
+++ linux-2.6/fs/jfs/file.c	2011-06-20 09:29:06.000000000 +0200
@@ -110,6 +110,8 @@ int jfs_setattr(struct dentry *dentry, s
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(inode)) {
+		inode_dio_wait(inode);
+
 		rc = vmtruncate(inode, iattr->ia_size);
 		if (rc)
 			return rc;
Index: linux-2.6/fs/nilfs2/inode.c
===================================================================
--- linux-2.6.orig/fs/nilfs2/inode.c	2011-06-18 12:54:28.204940339 +0200
+++ linux-2.6/fs/nilfs2/inode.c	2011-06-20 09:29:06.000000000 +0200
@@ -778,6 +778,8 @@ int nilfs_setattr(struct dentry *dentry,
 
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(inode)) {
+		inode_dio_wait(inode);
+
 		err = vmtruncate(inode, iattr->ia_size);
 		if (unlikely(err))
 			goto out_err;
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c	2011-06-18 12:54:28.218273673 +0200
+++ linux-2.6/fs/reiserfs/inode.c	2011-06-20 09:29:06.000000000 +0200
@@ -3114,6 +3114,9 @@ int reiserfs_setattr(struct dentry *dent
 			error = -EFBIG;
 			goto out;
 		}
+
+		inode_dio_wait(inode);
+
 		/* fill in hole pointers in the expanding truncate case. */
 		if (attr->ia_size > inode->i_size) {
 			error = generic_cont_expand_simple(inode, attr->ia_size);

