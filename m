From: akpm@linux-foundation.org
Subject: + iget-stop-ext2-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:45:12 -0700
Message-ID: <200710270745.l9R7jCw2003329@imap1.linux-foundation.org>
Cc: dhowells@redhat.com, linux-ext4@vger.kernel.org, tytso@mit.edu
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbXJ0Hpr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Oct 2007 03:45:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     iget: stop EXT2 from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-ext2-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop EXT2 from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the EXT2 filesystem from using iget() and read_inode().  Replace
ext2_read_inode() with ext2_iget(), and call that instead of iget(). 
ext2_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext2_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h  |    2 +-
 fs/ext2/inode.c |   29 +++++++++++++++++++++--------
 fs/ext2/namei.c |   12 ++++++------
 fs/ext2/super.c |   32 ++++++++++++++++++--------------
 4 files changed, 46 insertions(+), 29 deletions(-)

diff -puN fs/ext2/ext2.h~iget-stop-ext2-from-using-iget-and-read_inode-try fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~iget-stop-ext2-from-using-iget-and-read_inode-try
+++ a/fs/ext2/ext2.h
@@ -124,7 +124,7 @@ extern void ext2_check_inodes_bitmap (st
 extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 
 /* inode.c */
-extern void ext2_read_inode (struct inode *);
+extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, int);
 extern void ext2_put_inode (struct inode *);
 extern void ext2_delete_inode (struct inode *);
diff -puN fs/ext2/inode.c~iget-stop-ext2-from-using-iget-and-read_inode-try fs/ext2/inode.c
--- a/fs/ext2/inode.c~iget-stop-ext2-from-using-iget-and-read_inode-try
+++ a/fs/ext2/inode.c
@@ -1185,22 +1185,33 @@ void ext2_get_inode_flags(struct ext2_in
 		ei->i_flags |= EXT2_DIRSYNC_FL;
 }
 
-void ext2_read_inode (struct inode * inode)
+struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	ino_t ino = inode->i_ino;
+	struct ext2_inode_info *ei;
 	struct buffer_head * bh;
-	struct ext2_inode * raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
+	struct ext2_inode * raw_inode;
+	struct inode *inode;
+	long ret = -EIO;
 	int n;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT2_I(inode);
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (IS_ERR(raw_inode))
+	raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);
+	if (IS_ERR(raw_inode)) {
+		ret = PTR_ERR(raw_inode);
  		goto bad_inode;
+	}
 
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
@@ -1224,6 +1235,7 @@ void ext2_read_inode (struct inode * ino
 	if (inode->i_nlink == 0 && (inode->i_mode == 0 || ei->i_dtime)) {
 		/* this inode is deleted */
 		brelse (bh);
+		ret = -ESTALE;
 		goto bad_inode;
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
@@ -1290,11 +1302,12 @@ void ext2_read_inode (struct inode * ino
 	}
 	brelse (bh);
 	ext2_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 	
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 static int ext2_update_inode(struct inode * inode, int do_sync)
diff -puN fs/ext2/namei.c~iget-stop-ext2-from-using-iget-and-read_inode-try fs/ext2/namei.c
--- a/fs/ext2/namei.c~iget-stop-ext2-from-using-iget-and-read_inode-try
+++ a/fs/ext2/namei.c
@@ -63,9 +63,9 @@ static struct dentry *ext2_lookup(struct
 	ino = ext2_inode_by_name(dir, dentry);
 	inode = NULL;
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = ext2_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -83,10 +83,10 @@ struct dentry *ext2_get_parent(struct de
 	ino = ext2_inode_by_name(child->d_inode, &dotdot);
 	if (!ino)
 		return ERR_PTR(-ENOENT);
-	inode = iget(child->d_inode->i_sb, ino);
+	inode = ext2_iget(child->d_inode->i_sb, ino);
 
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff -puN fs/ext2/super.c~iget-stop-ext2-from-using-iget-and-read_inode-try fs/ext2/super.c
--- a/fs/ext2/super.c~iget-stop-ext2-from-using-iget-and-read_inode-try
+++ a/fs/ext2/super.c
@@ -296,7 +296,6 @@ static ssize_t ext2_quota_write(struct s
 static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.destroy_inode	= ext2_destroy_inode,
-	.read_inode	= ext2_read_inode,
 	.write_inode	= ext2_write_inode,
 	.delete_inode	= ext2_delete_inode,
 	.put_super	= ext2_put_super,
@@ -326,11 +325,10 @@ static struct inode *ext2_nfs_get_inode(
 	 * it might be "neater" to call ext2_get_inode first and check
 	 * if the inode is valid.....
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext2_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		/* we didn't find the right inode.. */
 		iput(inode);
 		return ERR_PTR(-ESTALE);
@@ -750,6 +748,7 @@ static int ext2_fill_super(struct super_
 	unsigned long logic_sb_block;
 	unsigned long offset = 0;
 	unsigned long def_mount_opts;
+	long ret = -EINVAL;
 	int blocksize = BLOCK_SIZE;
 	int db_count;
 	int i, j;
@@ -1046,19 +1045,24 @@ static int ext2_fill_super(struct super_
 	sb->s_op = &ext2_sops;
 	sb->s_export_op = &ext2_export_ops;
 	sb->s_xattr = ext2_xattr_handlers;
-	root = iget(sb, EXT2_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
-		iput(root);
-		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+	root = ext2_iget(sb, EXT2_ROOT_INO);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto failed_mount3;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT2-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount3;
 	}
+
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		iput(root);
+		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
+		ret = -ENOMEM;
+		goto failed_mount3;
+	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_warning(sb, __FUNCTION__,
 			"mounting ext3 filesystem as ext2");
@@ -1085,7 +1089,7 @@ failed_mount:
 failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static void ext2_commit_super (struct super_block * sb,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
