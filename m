From: akpm@linux-foundation.org
Subject: + iget-stop-ext3-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:45:37 -0700
Message-ID: <200710270745.l9R7jb8t003339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     iget: stop EXT3 from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-ext3-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop EXT3 from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the EXT3 filesystem from using iget() and read_inode().  Replace
ext3_read_inode() with ext3_iget(), and call that instead of iget(). 
ext3_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

ext3_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |   58 ++++++++++++++++++++++----------------
 fs/ext3/inode.c         |   25 ++++++++++++----
 fs/ext3/namei.c         |   29 +++++--------------
 fs/ext3/resize.c        |    7 +---
 fs/ext3/super.c         |   40 ++++++++++++++------------
 include/linux/ext3_fs.h |    2 -
 6 files changed, 89 insertions(+), 72 deletions(-)

diff -puN fs/ext3/ialloc.c~iget-stop-ext3-from-using-iget-and-read_inode-try fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/fs/ext3/ialloc.c
@@ -642,14 +642,15 @@ struct inode *ext3_orphan_get(struct sup
 	unsigned long max_ino = le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count);
 	unsigned long block_group;
 	int bit;
-	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *bitmap_bh;
 	struct inode *inode = NULL;
+	long err = -EIO;
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
 		ext3_warning(sb, __FUNCTION__,
 			     "bad orphan ino %lu!  e2fsck was run?", ino);
-		goto out;
+		goto error;
 	}
 
 	block_group = (ino - 1) / EXT3_INODES_PER_GROUP(sb);
@@ -658,38 +659,49 @@ struct inode *ext3_orphan_get(struct sup
 	if (!bitmap_bh) {
 		ext3_warning(sb, __FUNCTION__,
 			     "inode bitmap error for orphan %lu", ino);
-		goto out;
+		goto error;
 	}
 
 	/* Having the inode bit set should be a 100% indicator that this
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
 	 * inodes that were being truncated, so we can't check i_nlink==0.
 	 */
-	if (!ext3_test_bit(bit, bitmap_bh->b_data) ||
-			!(inode = iget(sb, ino)) || is_bad_inode(inode) ||
-			NEXT_ORPHAN(inode) > max_ino) {
-		ext3_warning(sb, __FUNCTION__,
-			     "bad orphan inode %lu!  e2fsck was run?", ino);
-		printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
-		       bit, (unsigned long long)bitmap_bh->b_blocknr,
-		       ext3_test_bit(bit, bitmap_bh->b_data));
-		printk(KERN_NOTICE "inode=%p\n", inode);
-		if (inode) {
-			printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
-			       is_bad_inode(inode));
-			printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
-			       NEXT_ORPHAN(inode));
-			printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
-		}
+	if (!ext3_test_bit(bit, bitmap_bh->b_data))
+		goto bad_orphan;
+
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		goto iget_failed;
+
+	if (NEXT_ORPHAN(inode) > max_ino)
+		goto bad_orphan;
+	brelse(bitmap_bh);
+	return inode;
+
+iget_failed:
+	err = PTR_ERR(inode);
+	inode = NULL;
+bad_orphan:
+	ext3_warning(sb, __FUNCTION__,
+		     "bad orphan inode %lu!  e2fsck was run?", ino);
+	printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
+	       bit, (unsigned long long)bitmap_bh->b_blocknr,
+	       ext3_test_bit(bit, bitmap_bh->b_data));
+	printk(KERN_NOTICE "inode=%p\n", inode);
+	if (inode) {
+		printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
+		       is_bad_inode(inode));
+		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
+		       NEXT_ORPHAN(inode));
+		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
 		/* Avoid freeing blocks if we got a bad deleted inode */
-		if (inode && inode->i_nlink == 0)
+		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
 		iput(inode);
-		inode = NULL;
 	}
-out:
 	brelse(bitmap_bh);
-	return inode;
+error:
+	return ERR_PTR(err);
 }
 
 unsigned long ext3_count_free_inodes (struct super_block * sb)
diff -puN fs/ext3/inode.c~iget-stop-ext3-from-using-iget-and-read_inode-try fs/ext3/inode.c
--- a/fs/ext3/inode.c~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/fs/ext3/inode.c
@@ -2658,21 +2658,31 @@ void ext3_get_inode_flags(struct ext3_in
 		ei->i_flags |= EXT3_DIRSYNC_FL;
 }
 
-void ext3_read_inode(struct inode * inode)
+struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext3_iloc iloc;
 	struct ext3_inode *raw_inode;
-	struct ext3_inode_info *ei = EXT3_I(inode);
+	struct ext3_inode_info *ei;
 	struct buffer_head *bh;
+	struct inode *inode;
+	long ret;
 	int block;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ei = EXT3_I(inode);
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ei->i_acl = EXT3_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
 
-	if (__ext3_get_inode_loc(inode, &iloc, 0))
+	ret = __ext3_get_inode_loc(inode, &iloc, 0);
+	if (ret < 0)
 		goto bad_inode;
 	bh = iloc.bh;
 	raw_inode = ext3_raw_inode(&iloc);
@@ -2703,6 +2713,7 @@ void ext3_read_inode(struct inode * inod
 		    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) {
 			/* this inode is deleted */
 			brelse (bh);
+			ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
@@ -2746,6 +2757,7 @@ void ext3_read_inode(struct inode * inod
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT3_INODE_SIZE(inode->i_sb)) {
 			brelse (bh);
+			ret = -EIO;
 			goto bad_inode;
 		}
 		if (ei->i_extra_isize == 0) {
@@ -2787,11 +2799,12 @@ void ext3_read_inode(struct inode * inod
 	}
 	brelse (iloc.bh);
 	ext3_set_inode_flags(inode);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 /*
diff -puN fs/ext3/namei.c~iget-stop-ext3-from-using-iget-and-read_inode-try fs/ext3/namei.c
--- a/fs/ext3/namei.c~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/fs/ext3/namei.c
@@ -1039,17 +1039,11 @@ static struct dentry *ext3_lookup(struct
 		if (!ext3_valid_inum(dir->i_sb, ino)) {
 			ext3_error(dir->i_sb, "ext3_lookup",
 				   "bad inode number: %lu", ino);
-			inode = NULL;
-		} else
-			inode = iget(dir->i_sb, ino);
-
-		if (!inode)
-			return ERR_PTR(-EACCES);
-
-		if (is_bad_inode(inode)) {
-			iput(inode);
-			return ERR_PTR(-ENOENT);
+			return ERR_PTR(-EIO);
 		}
+		inode = ext3_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -1078,18 +1072,13 @@ struct dentry *ext3_get_parent(struct de
 	if (!ext3_valid_inum(child->d_inode->i_sb, ino)) {
 		ext3_error(child->d_inode->i_sb, "ext3_get_parent",
 			   "bad inode number: %lu", ino);
-		inode = NULL;
-	} else
-		inode = iget(child->d_inode->i_sb, ino);
-
-	if (!inode)
-		return ERR_PTR(-EACCES);
-
-	if (is_bad_inode(inode)) {
-		iput(inode);
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EIO);
 	}
 
+	inode = ext3_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
 	parent = d_alloc_anon(inode);
 	if (!parent) {
 		iput(inode);
diff -puN fs/ext3/resize.c~iget-stop-ext3-from-using-iget-and-read_inode-try fs/ext3/resize.c
--- a/fs/ext3/resize.c~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/fs/ext3/resize.c
@@ -795,12 +795,11 @@ int ext3_group_add(struct super_block *s
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
-		inode = iget(sb, EXT3_RESIZE_INO);
-		if (!inode || is_bad_inode(inode)) {
+		inode = ext3_iget(sb, EXT3_RESIZE_INO);
+		if (IS_ERR(inode)) {
 			ext3_warning(sb, __FUNCTION__,
 				     "Error opening resize inode");
-			iput(inode);
-			return -ENOENT;
+			return PTR_ERR(inode);
 		}
 	}
 
diff -puN fs/ext3/super.c~iget-stop-ext3-from-using-iget-and-read_inode-try fs/ext3/super.c
--- a/fs/ext3/super.c~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/fs/ext3/super.c
@@ -649,11 +649,10 @@ static struct inode *ext3_nfs_get_inode(
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	inode = ext3_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -722,7 +721,6 @@ static struct quotactl_ops ext3_qctl_ope
 static const struct super_operations ext3_sops = {
 	.alloc_inode	= ext3_alloc_inode,
 	.destroy_inode	= ext3_destroy_inode,
-	.read_inode	= ext3_read_inode,
 	.write_inode	= ext3_write_inode,
 	.dirty_inode	= ext3_dirty_inode,
 	.delete_inode	= ext3_delete_inode,
@@ -1383,8 +1381,8 @@ static void ext3_orphan_cleanup (struct 
 	while (es->s_last_orphan) {
 		struct inode *inode;
 
-		if (!(inode =
-		      ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan)))) {
+		inode = ext3_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
+		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
 			break;
 		}
@@ -1513,6 +1511,7 @@ static int ext3_fill_super (struct super
 	int db_count;
 	int i;
 	int needs_recovery;
+	int ret = -EINVAL;
 	__le32 features;
 	int err;
 
@@ -1882,19 +1881,24 @@ static int ext3_fill_super (struct super
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = iget(sb, EXT3_ROOT_INO);
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
+	root = ext3_iget(sb, EXT3_ROOT_INO);
+	if (IS_ERR(root)) {
 		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
-		iput(root);
+		ret = PTR_ERR(root);
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
+		iput(root);
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+	sb->s_root = d_alloc_root(root);
+	if (!sb->s_root) {
+		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
+		iput(root);
+		ret = -ENOMEM;
+		goto failed_mount4;
+	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	/*
@@ -1946,7 +1950,7 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	lock_kernel();
-	return -EINVAL;
+	return ret;
 }
 
 /*
@@ -1982,8 +1986,8 @@ static journal_t *ext3_get_journal(struc
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
 
-	journal_inode = iget(sb, journal_inum);
-	if (!journal_inode) {
+	journal_inode = ext3_iget(sb, journal_inum);
+	if (IS_ERR(journal_inode)) {
 		printk(KERN_ERR "EXT3-fs: no journal found.\n");
 		return NULL;
 	}
@@ -1996,7 +2000,7 @@ static journal_t *ext3_get_journal(struc
 
 	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (is_bad_inode(journal_inode) || !S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode)) {
 		printk(KERN_ERR "EXT3-fs: invalid journal inode.\n");
 		iput(journal_inode);
 		return NULL;
diff -puN include/linux/ext3_fs.h~iget-stop-ext3-from-using-iget-and-read_inode-try include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~iget-stop-ext3-from-using-iget-and-read_inode-try
+++ a/include/linux/ext3_fs.h
@@ -803,7 +803,7 @@ int ext3_get_blocks_handle(handle_t *han
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
 
-extern void ext3_read_inode (struct inode *);
+extern struct inode *ext3_iget (struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
 extern int  ext3_setattr (struct dentry *, struct iattr *);
 extern void ext3_delete_inode (struct inode *);
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
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
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
