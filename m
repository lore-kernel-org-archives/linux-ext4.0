From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 18:19:45 +0100
Message-ID: <20071106171945.GG23689@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42602 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756962AbXKFRTr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 12:19:47 -0500
Content-Disposition: inline
In-Reply-To: <20071106171537.GD23689@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Implement recursive mtime (rtime) feature for ext3. The feature works as
follows: In each directory we keep a flag EXT3_RTIME_FL (modifiable by a user)
whether rtime should be updated. In case a directory or a file in it is
modified and when the flag is set, directory's rtime is updated, the flag is
cleared, and we move to the parent. If the flag is set there, we clear it,
update rtime and continue upwards upto the root of the filesystem. In case a
regular file or symlink is modified, we pick arbitrary of its parents (actually
the one that happens to be at the head of i_dentry list) and start the rtime
update algorith there.

As the flag is always cleared after updating rtime and we don't climb up the
tree if the flag is cleared, we have constant amortized complexity of rtime
updates. That's for theoretical time consumption ;) Practically, there's no
measurable performance impact for a test case like: touch every file in a
kernel tree where every directory has RTIME flag set.

Intended use case is that application which wants to watch any modification in
a subtree scans the subtree and sets flags for all inodes there. Next time, it
just needs to recurse in directories having rtime newer than the start of the
previous scan. There it can handle modifications and set the flag again. It is
up to application to watch out for hardlinked files. It can e.g.  build their
list and check their mtime separately (when a hardlink to a file is created its
inode is modified and rtimes properly updated and thus any application has an
effective way of finding new hardlinked files).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ialloc.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ialloc.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ialloc.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ialloc.c	2007-11-05 16:58:53.000000000 +0100
@@ -569,7 +569,7 @@ got:
 	/* Guard reading of directory's i_flags, created inode is safe as
 	 * noone has a reference to it yet */
 	spin_lock(&dir->i_lock);
-	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+ 	ei->i_flags = EXT3_I(dir)->i_flags & ~(EXT3_INDEX_FL | EXT3_RTIME_FL);
 	spin_unlock(&dir->i_lock);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
@@ -579,6 +579,7 @@ got:
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
+	ei->i_rtime = inode->i_mtime.tv_sec;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/inode.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/inode.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/inode.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/inode.c	2007-11-06 16:13:50.000000000 +0100
@@ -1232,6 +1232,8 @@ static int ext3_ordered_commit_write(str
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -1255,6 +1257,8 @@ static int ext3_writeback_commit_write(s
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -1288,6 +1292,8 @@ static int ext3_journalled_commit_write(
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
+	if (!ret)
+		ext3_update_rtimes(inode);
 	return ret;
 }
 
@@ -2386,6 +2392,10 @@ out_stop:
 		ext3_orphan_del(handle, inode);
 
 	ext3_journal_stop(handle);
+	/* We update time only for linked inodes. Unlinked ones already
+	 * notified parent during unlink... */
+	if (inode->i_nlink)
+		ext3_update_rtimes(inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
@@ -2628,6 +2638,8 @@ void ext3_read_inode(struct inode * inod
 	inode->i_ctime.tv_sec = (signed)le32_to_cpu(raw_inode->i_ctime);
 	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode->i_mtime);
 	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
+	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, EXT3_FEATURE_COMPAT_RTIME))
+		ei->i_rtime = le32_to_cpu(raw_inode->i_rtime);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2780,6 +2792,8 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, EXT3_FEATURE_COMPAT_RTIME))
+		raw_inode->i_rtime = cpu_to_le32(ei->i_rtime);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	spin_lock(&inode->i_lock);
@@ -2978,6 +2992,8 @@ int ext3_setattr(struct dentry *dentry, 
 
 	if (!rc && (ia_valid & ATTR_MODE))
 		rc = ext3_acl_chmod(inode);
+	if (!rc)
+		ext3_update_rtimes(inode);
 
 err_out:
 	ext3_std_error(inode->i_sb, error);
@@ -3129,6 +3145,7 @@ void ext3_dirty_inode(struct inode *inod
 	handle_t *current_handle = ext3_journal_current_handle();
 	handle_t *handle;
 
+	/* Reserve 2 blocks for inode and superblock */
 	handle = ext3_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ioctl.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ioctl.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/ioctl.c	2007-11-05 15:42:03.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/ioctl.c	2007-11-05 16:58:53.000000000 +0100
@@ -23,10 +23,20 @@ int ext3_ioctl (struct inode * inode, st
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	unsigned int rtime;
 
 	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case EXT3_IOC_GETRTIME:
+		if (!test_opt(inode->i_sb, RTIME))
+			return -ENOTSUPP;
+		if (!S_ISDIR(inode->i_mode))
+			return -ENOTDIR;
+		spin_lock(&inode->i_lock);
+		rtime = ei->i_rtime;
+		spin_unlock(&inode->i_lock);
+		return put_user(rtime, (unsigned int __user *) arg);
 	case EXT3_IOC_GETFLAGS:
 		ext3_get_inode_flags(ei);
 		spin_lock(&inode->i_lock);
@@ -49,8 +59,10 @@ int ext3_ioctl (struct inode * inode, st
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		if (!S_ISDIR(inode->i_mode))
+		if (!S_ISDIR(inode->i_mode)) {
 			flags &= ~EXT3_DIRSYNC_FL;
+			flags &= ~EXT3_RTIME_FL;
+		}
 
 		mutex_lock(&inode->i_mutex);
 		handle = ext3_journal_start(inode, 1);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/namei.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/namei.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/namei.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/namei.c	2007-11-05 16:58:53.000000000 +0100
@@ -65,6 +65,59 @@ static struct buffer_head *ext3_append(h
 	return bh;
 }
 
+/* We don't want to get new handle for every inode updated. Thus we batch
+ * updates of this many inodes into one transaction */
+#define RTIME_UPDATES_PER_TRANS 16
+
+/* Walk up the directory tree and modify rtimes.
+ * We journal i_rtime updates into a separate transaction - we don't guarantee
+ * consistency between other inode times and rtime. Only consistency between
+ * i_flags and i_rtime. */
+int __ext3_update_rtimes(struct inode *inode)
+{
+	struct dentry *dentry = list_entry(inode->i_dentry.next, struct dentry,
+					d_alias);
+	handle_t *handle;
+	int updates = 0;
+	int err = 0;
+
+	/* We should not have any transaction started - noone knows how many
+	 * inode updates will be needed */
+	WARN_ON(ext3_journal_current_handle() != NULL);
+	if (!S_ISDIR(inode->i_mode)) {
+		dentry = dentry->d_parent;
+		inode = dentry->d_inode;
+	}
+	while (ext3_test_inode_flags(inode, EXT3_RTIME_FL)) {
+		if (!updates) {
+			/* For inode updates + superblock */
+			handle = ext3_journal_start(inode, RTIME_UPDATES_PER_TRANS + 1);
+			if (IS_ERR(handle))
+				return PTR_ERR(handle);
+			updates = RTIME_UPDATES_PER_TRANS;
+		}
+
+		spin_lock(&inode->i_lock);
+		EXT3_I(inode)->i_rtime = get_seconds();
+		EXT3_I(inode)->i_flags &= ~EXT3_RTIME_FL;
+		spin_unlock(&inode->i_lock);
+		ext3_mark_inode_dirty(handle, inode);
+		if (!--updates) {
+			err = ext3_journal_stop(handle);
+			if (err)
+				return err;
+		}
+		
+		if (dentry == inode->i_sb->s_root)
+			break;
+		dentry = dentry->d_parent;
+		inode = dentry->d_inode;
+	}
+	if (updates)
+		err = ext3_journal_stop(handle);
+	return err;
+}
+
 #ifndef assert
 #define assert(test) J_ASSERT(test)
 #endif
@@ -1738,6 +1791,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1773,6 +1828,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1847,6 +1904,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2123,6 +2182,8 @@ static int ext3_rmdir (struct inode * di
 
 end_rmdir:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2177,6 +2238,8 @@ static int ext3_unlink(struct inode * di
 
 end_unlink:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2234,6 +2297,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2270,6 +2335,10 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err) {
+		ext3_update_rtimes(dir);
+		ext3_update_rtimes(inode);
+	}
 	return err;
 }
 
@@ -2429,6 +2498,10 @@ end_rename:
 	brelse (old_bh);
 	brelse (new_bh);
 	ext3_journal_stop(handle);
+	if (!retval) {
+		ext3_update_rtimes(old_dir);
+		ext3_update_rtimes(new_dir);
+	}
 	return retval;
 }
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/super.c linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/super.c
--- linux-2.6.23-2-ext3_make_frags_unused/fs/ext3/super.c	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/fs/ext3/super.c	2007-11-05 16:58:53.000000000 +0100
@@ -684,7 +684,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_rtime
 };
 
 static match_table_t tokens = {
@@ -734,6 +734,7 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
+	{Opt_rtime, "rtime"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1066,6 +1067,14 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_rtime:
+			if (!EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_RTIME)) {
+				printk("EXT3-fs: rtime option available only "
+					"if superblock has RTIME feature.\n");
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, RTIME);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs.h linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs.h
--- linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs.h	2007-11-05 16:58:10.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs.h	2007-11-06 16:34:43.000000000 +0100
@@ -177,10 +177,11 @@ struct ext3_group_desc
 #define EXT3_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define EXT3_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define EXT3_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define EXT3_RTIME_FL			0x00100000 /* Update recursive mtime (directories only) */
 #define EXT3_RESERVED_FL		0x80000000 /* reserved for ext3 lib */
 
-#define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-#define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
+#define EXT3_FL_USER_VISIBLE		0x0013DFFF /* User visible flags */
+#define EXT3_FL_USER_MODIFIABLE		0x001380FF /* User modifiable flags */
 
 /*
  * Inode dynamic state flags
@@ -229,6 +230,7 @@ struct ext3_new_group_data {
 #endif
 #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT3_IOC_GETRTIME		_IOR('f', 9, unsigned int)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -291,7 +293,7 @@ struct ext3_inode {
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
-	__le32	i_obsolete_faddr;	/* Unused */
+	__le32	i_rtime;	/* Recursive Modification Time - directories only */
 	union {
 		struct {
 			__u16	l_i_obsolete_frag;	/* Unused */
@@ -381,6 +383,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_RTIME		0x400000 /* Update rtime */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -580,6 +583,7 @@ static inline unsigned int ext3_test_ino
 #define EXT3_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT3_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT3_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT3_FEATURE_COMPAT_RTIME		0x0080
 
 #define EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT3_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -854,6 +858,13 @@ extern int ext3_orphan_add(handle_t *, s
 extern int ext3_orphan_del(handle_t *, struct inode *);
 extern int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
+extern int __ext3_update_rtimes(struct inode *inode);
+static inline int ext3_update_rtimes(struct inode *inode)
+{
+	if (test_opt(inode->i_sb, RTIME))
+		return __ext3_update_rtimes(inode);
+	return 0;
+}
 
 /* resize.c */
 extern int ext3_group_add(struct super_block *sb,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs_i.h linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs_i.h
--- linux-2.6.23-2-ext3_make_frags_unused/include/linux/ext3_fs_i.h	2007-11-05 15:42:03.000000000 +0100
+++ linux-2.6.23-3-ext3_recursive_mtime/include/linux/ext3_fs_i.h	2007-11-05 16:58:53.000000000 +0100
@@ -78,6 +78,7 @@ struct ext3_inode_info {
 	ext3_fsblk_t	i_file_acl;
 	__u32	i_dir_acl;
 	__u32	i_dtime;
+	__u32	i_rtime;
 
 	/*
 	 * i_block_group is the number of the block group which contains
