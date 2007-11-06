From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH 1/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 18:18:20 +0100
Message-ID: <20071106171820.GE23689@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42600 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753831AbXKFRSW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 12:18:22 -0500
Content-Disposition: inline
In-Reply-To: <20071106171537.GD23689@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  the following patch makes more lightweight handling of
EXT3_I(inode)->i_flags possible.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Implement atomic updates of EXT3_I(inode)->i_flags. So far the i_flags access
was guarded mostly by i_mutex but this is quite heavy-weight. We now use
inode->i_lock to protect i_flags reading and updates in ext3. This patch
introduces a bogus warning that jflag and oldflags may be uninitialized -
anyone knows how to cleanly get rid of it?

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/dir.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/dir.c
--- linux-2.6.23/fs/ext3/dir.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/dir.c	2007-11-05 14:04:56.000000000 +0100
@@ -108,10 +108,10 @@ static int ext3_readdir(struct file * fi
 	sb = inode->i_sb;
 
 #ifdef CONFIG_EXT3_INDEX
-	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
-				    EXT3_FEATURE_COMPAT_DIR_INDEX) &&
-	    ((EXT3_I(inode)->i_flags & EXT3_INDEX_FL) ||
-	     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
+	if (is_dx(inode) ||
+	    (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, \
+					EXT3_FEATURE_COMPAT_DIR_INDEX) &&
+	     (inode->i_size >> sb->s_blocksize_bits) == 1)) {
 		err = ext3_dx_readdir(filp, dirent, filldir);
 		if (err != ERR_BAD_DX_DIR) {
 			ret = err;
@@ -121,7 +121,9 @@ static int ext3_readdir(struct file * fi
 		 * We don't set the inode dirty flag since it's not
 		 * critical that it get flushed back to the disk.
 		 */
+		spin_lock(&inode->i_lock);
 		EXT3_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
+		spin_unlock(&inode->i_lock);
 	}
 #endif
 	stored = 0;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/ialloc.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c
--- linux-2.6.23/fs/ext3/ialloc.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c	2007-11-05 14:14:50.000000000 +0100
@@ -278,7 +278,7 @@ static int find_group_orlov(struct super
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if ((parent == sb->s_root->d_inode) ||
-	    (EXT3_I(parent)->i_flags & EXT3_TOPDIR_FL)) {
+	    ext3_test_inode_flags(parent, EXT3_TOPDIR_FL)) {
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
@@ -566,7 +566,11 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
+	/* Guard reading of directory's i_flags, created inode is safe as
+	 * noone has a reference to it yet */
+	spin_lock(&dir->i_lock);
 	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+	spin_unlock(&dir->i_lock);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
 	/* dirsync only applies to directories */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/inode.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c
--- linux-2.6.23/fs/ext3/inode.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c	2007-11-05 14:24:39.000000000 +0100
@@ -2557,8 +2557,10 @@ int ext3_get_inode_loc(struct inode *ino
 
 void ext3_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT3_I(inode)->i_flags;
+	unsigned int flags;
 
+	spin_lock(&inode->i_lock);
+	flags = EXT3_I(inode)->i_flags;
 	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 	if (flags & EXT3_SYNC_FL)
 		inode->i_flags |= S_SYNC;
@@ -2570,13 +2572,16 @@ void ext3_set_inode_flags(struct inode *
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT3_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	spin_unlock(&inode->i_lock);
 }
 
 /* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
 void ext3_get_inode_flags(struct ext3_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
+	unsigned int flags;
 
+	spin_lock(&ei->vfs_inode.i_lock);
+	flags = ei->vfs_inode.i_flags;
 	ei->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
 			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
 	if (flags & S_SYNC)
@@ -2589,6 +2594,7 @@ void ext3_get_inode_flags(struct ext3_in
 		ei->i_flags |= EXT3_NOATIME_FL;
 	if (flags & S_DIRSYNC)
 		ei->i_flags |= EXT3_DIRSYNC_FL;
+	spin_unlock(&ei->vfs_inode.i_lock);
 }
 
 void ext3_read_inode(struct inode * inode)
@@ -2781,7 +2787,9 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
+	spin_lock(&inode->i_lock);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
+	spin_unlock(&inode->i_lock);
 #ifdef EXT3_FRAGMENTS
 	raw_inode->i_faddr = cpu_to_le32(ei->i_faddr);
 	raw_inode->i_frag = ei->i_frag_no;
@@ -3209,10 +3217,12 @@ int ext3_change_inode_journal_flag(struc
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
+	spin_lock(&inode->i_lock);
 	if (val)
 		EXT3_I(inode)->i_flags |= EXT3_JOURNAL_DATA_FL;
 	else
 		EXT3_I(inode)->i_flags &= ~EXT3_JOURNAL_DATA_FL;
+	spin_unlock(&inode->i_lock);
 	ext3_set_aops(inode);
 
 	journal_unlock_updates(journal);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/fs/ext3/ioctl.c linux-2.6.23-1-i_flags_atomicity/fs/ext3/ioctl.c
--- linux-2.6.23/fs/ext3/ioctl.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/fs/ext3/ioctl.c	2007-11-05 14:32:12.000000000 +0100
@@ -29,7 +29,9 @@ int ext3_ioctl (struct inode * inode, st
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
 		ext3_get_inode_flags(ei);
+		spin_lock(&inode->i_lock);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
+		spin_unlock(&inode->i_lock);
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
@@ -51,10 +53,19 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		oldflags = ei->i_flags;
+		handle = ext3_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			mutex_unlock(&inode->i_mutex);
+			return PTR_ERR(handle);
+		}
+		if (IS_SYNC(inode))
+			handle->h_sync = 1;
+		err = ext3_reserve_inode_write(handle, inode, &iloc);
+		if (err)
+			goto flags_err;
 
-		/* The JOURNAL_DATA flag is modifiable only by root */
-		jflag = flags & EXT3_JOURNAL_DATA_FL;
+		spin_lock(&inode->i_lock);
+		oldflags = ei->i_flags;
 
 		/*
 		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
@@ -64,8 +75,9 @@ int ext3_ioctl (struct inode * inode, st
 		 */
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
-				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				spin_unlock(&inode->i_lock);
+				err = -EPERM;
+				goto flags_err;
 			}
 		}
 
@@ -73,28 +85,19 @@ int ext3_ioctl (struct inode * inode, st
 		 * The JOURNAL_DATA flag can only be changed by
 		 * the relevant capability.
 		 */
+		jflag = flags & EXT3_JOURNAL_DATA_FL;
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
-				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				spin_unlock(&inode->i_lock);
+				err = -EPERM;
+				goto flags_err;
 			}
 		}
 
-
-		handle = ext3_journal_start(inode, 1);
-		if (IS_ERR(handle)) {
-			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
-		}
-		if (IS_SYNC(inode))
-			handle->h_sync = 1;
-		err = ext3_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto flags_err;
-
 		flags = flags & EXT3_FL_USER_MODIFIABLE;
 		flags |= oldflags & ~EXT3_FL_USER_MODIFIABLE;
 		ei->i_flags = flags;
+		spin_unlock(&inode->i_lock);
 
 		ext3_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/include/linux/ext3_fs.h linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h
--- linux-2.6.23/include/linux/ext3_fs.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h	2007-11-05 14:31:44.000000000 +0100
@@ -514,6 +514,17 @@ static inline int ext3_valid_inum(struct
 		(ino >= EXT3_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count));
 }
+
+static inline unsigned int ext3_test_inode_flags(struct inode *inode, u32 flags)
+{
+	unsigned int ret;
+
+	spin_lock(&inode->i_lock);
+	ret = EXT3_I(inode)->i_flags & flags;
+	spin_unlock(&inode->i_lock);
+	return ret;
+}
+
 #else
 /* Assume that user mode programs are passing in an ext3fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
@@ -666,9 +677,18 @@ struct ext3_dir_entry_2 {
  */
 
 #ifdef CONFIG_EXT3_INDEX
-  #define is_dx(dir) (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
-					      EXT3_FEATURE_COMPAT_DIR_INDEX) && \
-		      (EXT3_I(dir)->i_flags & EXT3_INDEX_FL))
+static inline int is_dx(struct inode *dir)
+{
+	int ret = 0;
+
+	if (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
+	      EXT3_FEATURE_COMPAT_DIR_INDEX)) {
+		spin_lock(&dir->i_lock);
+		ret = EXT3_I(dir)->i_flags & EXT3_INDEX_FL;
+		spin_unlock(&dir->i_lock);
+	}
+	return ret;
+}
 #define EXT3_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT3_LINK_MAX)
 #define EXT3_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
 #else
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23/include/linux/ext3_fs_i.h linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_i.h
--- linux-2.6.23/include/linux/ext3_fs_i.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_i.h	2007-11-05 14:26:43.000000000 +0100
@@ -69,7 +69,7 @@ struct ext3_block_alloc_info {
  */
 struct ext3_inode_info {
 	__le32	i_data[15];	/* unconverted */
-	__u32	i_flags;
+	__u32	i_flags;	/* Guarded by inode->i_lock */
 #ifdef EXT3_FRAGMENTS
 	__u32	i_faddr;
 	__u8	i_frag_no;
