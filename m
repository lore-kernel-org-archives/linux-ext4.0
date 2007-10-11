From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] Make ext3 use bit operations to manipulate i_flags
Date: Thu, 11 Oct 2007 19:56:18 +0200
Message-ID: <20071011175618.GF7125@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34942 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754939AbXJKRdb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 13:33:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  attached patch makes ext3 use bit operations to manipulate its
EXT3_I->i_flags. So far i_flags modifications were usually guarded
by i_mutex but my next patch needs to modify i_flags without i_mutex.
  BTW: Is there any type + functions, which allow both bit operations
and things like atomic_read() and atomic_set()? It would be nice to
use them here - currently I just assign to the variable but I'm not sure if
this cannot result in some garbage on some strange architecture.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Use set_bit(), clear_bit() and test_bit() to manipulate EXT3_I->i_flags.
This allows concurrent updates to EXT3_I->i_flags. At several places
we need to copy EXT3_I->i_flags as a whole - we do it non-atomically
and hope we don't get any garbage.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/dir.c linux-2.6.23-1-ext3_iflags_locking/fs/ext3/dir.c
--- linux-2.6.23/fs/ext3/dir.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-ext3_iflags_locking/fs/ext3/dir.c	2007-10-11 18:03:19.000000000 +0200
@@ -110,7 +110,7 @@ static int ext3_readdir(struct file * fi
 #ifdef CONFIG_EXT3_INDEX
 	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
 				    EXT3_FEATURE_COMPAT_DIR_INDEX) &&
-	    ((EXT3_I(inode)->i_flags & EXT3_INDEX_FL) ||
+	    (test_bit(EXT3_INDEX_FL, &EXT3_I(inode)->i_flags) ||
 	     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
 		err = ext3_dx_readdir(filp, dirent, filldir);
 		if (err != ERR_BAD_DX_DIR) {
@@ -121,7 +121,7 @@ static int ext3_readdir(struct file * fi
 		 * We don't set the inode dirty flag since it's not
 		 * critical that it get flushed back to the disk.
 		 */
-		EXT3_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
+		clear_bit(EXT3_INDEX_FL, &EXT3_I(filp->f_path.dentry->d_inode)->i_flags);
 	}
 #endif
 	stored = 0;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/ialloc.c linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ialloc.c
--- linux-2.6.23/fs/ext3/ialloc.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ialloc.c	2007-10-11 18:05:48.000000000 +0200
@@ -278,7 +278,7 @@ static int find_group_orlov(struct super
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if ((parent == sb->s_root->d_inode) ||
-	    (EXT3_I(parent)->i_flags & EXT3_TOPDIR_FL)) {
+	    test_bit(EXT3_TOPDIR_FL, &EXT3_I(parent)->i_flags)) {
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/inode.c linux-2.6.23-1-ext3_iflags_locking/fs/ext3/inode.c
--- linux-2.6.23/fs/ext3/inode.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-ext3_iflags_locking/fs/ext3/inode.c	2007-10-11 18:13:04.000000000 +0200
@@ -2557,18 +2557,16 @@ int ext3_get_inode_loc(struct inode *ino
 
 void ext3_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT3_I(inode)->i_flags;
-
 	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (flags & EXT3_SYNC_FL)
+	if (test_bit(EXT3_SYNC_FL, &EXT3_I(inode)->i_flags))
 		inode->i_flags |= S_SYNC;
-	if (flags & EXT3_APPEND_FL)
+	if (test_bit(EXT3_APPEND_FL, &EXT3_I(inode)->i_flags))
 		inode->i_flags |= S_APPEND;
-	if (flags & EXT3_IMMUTABLE_FL)
+	if (test_bit(EXT3_IMMUTABLE_FL, &EXT3_I(inode)->i_flags))
 		inode->i_flags |= S_IMMUTABLE;
-	if (flags & EXT3_NOATIME_FL)
+	if (test_bit(EXT3_NOATIME_FL, &EXT3_I(inode)->i_flags))
 		inode->i_flags |= S_NOATIME;
-	if (flags & EXT3_DIRSYNC_FL)
+	if (test_bit(EXT3_DIRSYNC_FL, &EXT3_I(inode)->i_flags))
 		inode->i_flags |= S_DIRSYNC;
 }
 
@@ -2577,18 +2575,26 @@ void ext3_get_inode_flags(struct ext3_in
 {
 	unsigned int flags = ei->vfs_inode.i_flags;
 
-	ei->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
-			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
 	if (flags & S_SYNC)
-		ei->i_flags |= EXT3_SYNC_FL;
+		set_bit(EXT3_SYNC_FL, &ei->i_flags);
+	else
+		clear_bit(EXT3_SYNC_FL, &ei->i_flags);
 	if (flags & S_APPEND)
-		ei->i_flags |= EXT3_APPEND_FL;
+		set_bit(EXT3_APPEND_FL, &ei->i_flags);
+	else
+		clear_bit(EXT3_APPEND_FL, &ei->i_flags);
 	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT3_IMMUTABLE_FL;
+		set_bit(EXT3_IMMUTABLE_FL, &ei->i_flags);
+	else
+		clear_bit(EXT3_IMMUTABLE_FL, &ei->i_flags);
 	if (flags & S_NOATIME)
-		ei->i_flags |= EXT3_NOATIME_FL;
+		set_bit(EXT3_NOATIME_FL, &ei->i_flags);
+	else
+		clear_bit(EXT3_NOATIME_FL, &ei->i_flags);
 	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT3_DIRSYNC_FL;
+		set_bit(EXT3_DIRSYNC_FL, &ei->i_flags);
+	else
+		clear_bit(EXT3_DIRSYNC_FL, &ei->i_flags);
 }
 
 void ext3_read_inode(struct inode * inode)
@@ -3210,9 +3216,9 @@ int ext3_change_inode_journal_flag(struc
 	 */
 
 	if (val)
-		EXT3_I(inode)->i_flags |= EXT3_JOURNAL_DATA_FL;
+		set_bit(EXT3_JOURNAL_DATA_FL, &EXT3_I(inode)->i_flags);
 	else
-		EXT3_I(inode)->i_flags &= ~EXT3_JOURNAL_DATA_FL;
+		clear_bit(EXT3_JOURNAL_DATA_FL, &EXT3_I(inode)->i_flags);
 	ext3_set_aops(inode);
 
 	journal_unlock_updates(journal);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/namei.c linux-2.6.23-1-ext3_iflags_locking/fs/ext3/namei.c
--- linux-2.6.23/fs/ext3/namei.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-ext3_iflags_locking/fs/ext3/namei.c	2007-10-11 18:09:11.000000000 +0200
@@ -629,7 +629,7 @@ int ext3_htree_fill_tree(struct file *di
 	dxtrace(printk("In htree_fill_tree, start hash: %x:%x\n", start_hash,
 		       start_minor_hash));
 	dir = dir_file->f_path.dentry->d_inode;
-	if (!(EXT3_I(dir)->i_flags & EXT3_INDEX_FL)) {
+	if (!test_bit(EXT3_INDEX_FL, &EXT3_I(dir)->i_flags)) {
 		hinfo.hash_version = EXT3_SB(dir->i_sb)->s_def_hash_version;
 		hinfo.seed = EXT3_SB(dir->i_sb)->s_hash_seed;
 		count = htree_dirblock_to_tree(dir_file, dir, 0, &hinfo,
@@ -775,7 +775,7 @@ static void ext3_update_dx_flag(struct i
 {
 	if (!EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
 				     EXT3_FEATURE_COMPAT_DIR_INDEX))
-		EXT3_I(inode)->i_flags &= ~EXT3_INDEX_FL;
+		clear_bit(&EXT3_I(inode)->i_flags, EXT3_INDEX_FL);
 }
 
 /*
@@ -1405,7 +1405,7 @@ static int make_indexed_dir(handle_t *ha
 		brelse(bh);
 		return retval;
 	}
-	EXT3_I(dir)->i_flags |= EXT3_INDEX_FL;
+	set_bit(&EXT3_I(dir)->i_flags, EXT3_INDEX_FL);
 	data1 = bh2->b_data;
 
 	/* The 0th block becomes the root, move the dirents out */
@@ -1481,7 +1481,7 @@ static int ext3_add_entry (handle_t *han
 		retval = ext3_dx_add_entry(handle, dentry, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			return retval;
-		EXT3_I(dir)->i_flags &= ~EXT3_INDEX_FL;
+		clear_bit(EXT3_INDEX_FL, &EXT3_I(dir)->i_flags);
 		dx_fallback++;
 		ext3_mark_inode_dirty(handle, dir);
 	}
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/include/linux/ext3_fs.h linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs.h
--- linux-2.6.23/include/linux/ext3_fs.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs.h	2007-10-11 17:01:28.000000000 +0200
@@ -157,27 +157,27 @@ struct ext3_group_desc
 /*
  * Inode flags
  */
-#define	EXT3_SECRM_FL			0x00000001 /* Secure deletion */
-#define	EXT3_UNRM_FL			0x00000002 /* Undelete */
-#define	EXT3_COMPR_FL			0x00000004 /* Compress file */
-#define EXT3_SYNC_FL			0x00000008 /* Synchronous updates */
-#define EXT3_IMMUTABLE_FL		0x00000010 /* Immutable file */
-#define EXT3_APPEND_FL			0x00000020 /* writes to file may only append */
-#define EXT3_NODUMP_FL			0x00000040 /* do not dump file */
-#define EXT3_NOATIME_FL			0x00000080 /* do not update atime */
+#define	EXT3_SECRM_FL			 0 /* Secure deletion */
+#define	EXT3_UNRM_FL			 1 /* Undelete */
+#define	EXT3_COMPR_FL			 2 /* Compress file */
+#define EXT3_SYNC_FL			 3 /* Synchronous updates */
+#define EXT3_IMMUTABLE_FL		 4 /* Immutable file */
+#define EXT3_APPEND_FL			 5 /* writes to file may only append */
+#define EXT3_NODUMP_FL			 6 /* do not dump file */
+#define EXT3_NOATIME_FL			 7 /* do not update atime */
 /* Reserved for compression usage... */
-#define EXT3_DIRTY_FL			0x00000100
-#define EXT3_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT3_NOCOMPR_FL			0x00000400 /* Don't compress */
-#define EXT3_ECOMPR_FL			0x00000800 /* Compression error */
+#define EXT3_DIRTY_FL			 8
+#define EXT3_COMPRBLK_FL		 9 /* One or more compressed clusters */
+#define EXT3_NOCOMPR_FL			10 /* Don't compress */
+#define EXT3_ECOMPR_FL			11 /* Compression error */
 /* End compression flags --- maybe not all used */
-#define EXT3_INDEX_FL			0x00001000 /* hash-indexed directory */
-#define EXT3_IMAGIC_FL			0x00002000 /* AFS directory */
-#define EXT3_JOURNAL_DATA_FL		0x00004000 /* file data should be journaled */
-#define EXT3_NOTAIL_FL			0x00008000 /* file tail should not be merged */
-#define EXT3_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
-#define EXT3_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
-#define EXT3_RESERVED_FL		0x80000000 /* reserved for ext3 lib */
+#define EXT3_INDEX_FL			12 /* hash-indexed directory */
+#define EXT3_IMAGIC_FL			13 /* AFS directory */
+#define EXT3_JOURNAL_DATA_FL		14 /* file data should be journaled */
+#define EXT3_NOTAIL_FL			15 /* file tail should not be merged */
+#define EXT3_DIRSYNC_FL			16 /* dirsync behaviour (directories only) */
+#define EXT3_TOPDIR_FL			17 /* Top of directory hierarchies*/
+#define EXT3_RESERVED_FL		31 /* reserved for ext3 lib */
 
 #define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
 #define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
