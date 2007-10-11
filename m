From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] Make ext3 use bit operations to manipulate i_flags
Date: Thu, 11 Oct 2007 20:01:11 +0200
Message-ID: <20071011180111.GG7125@duck.suse.cz>
References: <20071011175618.GF7125@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49271 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754403AbXJKRiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 13:38:24 -0400
Content-Disposition: inline
In-Reply-To: <20071011175618.GF7125@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  attached patch implements recursive mtime feature for ext3. Things like
rsync or updatedb can be much faster with it... More detailed description
is in the patch.
  BTW: Hardlinks are currently unsolved - change is propagated to just the
first parent. Currently it's upto userspace to handle this - if you have
some idea how to make hardlinked files easier for userspace, please speak
up :).
  Any comments welcome.

								Honza

--------
Implement recursive mtime (rtime) feature for ext3. The feature works as
follows: In each inode we keep a flag EXT3_RTIME_FL (modifiable by user)
whether rtime should be updated. In case the inode is modified and when
the flag is set, inode's rtime is updated, the flag is cleared, and we
move to the parent. If the flag is set there, we clear it, update rtime
and continue upwards upto the root of the filesystem. Because the flag
is always cleared after updating rtime, we have constant amortized
complexity of rtime updates.

Intended use case is that application which wants to watch any modification
in a subtree scans the subtree and sets flags for all inodes there. Next time,
it just needs to recurse in directories having rtime newer than the start
of the previous scan. There it can handle modifications and set the flag
again.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ialloc.c linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/ialloc.c
--- linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ialloc.c	2007-10-11 18:05:48.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/ialloc.c	2007-10-11 18:14:03.000000000 +0200
@@ -580,6 +580,7 @@ got:
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
+	ei->i_rtime = inode->i_mtime.tv_sec;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/fs/ext3/inode.c linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/inode.c
--- linux-2.6.23-1-ext3_iflags_locking/fs/ext3/inode.c	2007-10-11 18:13:04.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/inode.c	2007-10-11 18:57:50.000000000 +0200
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
@@ -2785,6 +2797,8 @@ static int ext3_do_update_inode(handle_t
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb, EXT3_FEATURE_COMPAT_RTIME))
+		raw_inode->i_rtime = cpu_to_le32(ei->i_rtime);
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
@@ -3137,6 +3151,7 @@ void ext3_dirty_inode(struct inode *inod
 	handle_t *current_handle = ext3_journal_current_handle();
 	handle_t *handle;
 
+	/* Reserve 2 blocks for inode and superblock */
 	handle = ext3_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ioctl.c linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/ioctl.c
--- linux-2.6.23-1-ext3_iflags_locking/fs/ext3/ioctl.c	2007-10-11 16:54:03.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/ioctl.c	2007-10-11 18:14:03.000000000 +0200
@@ -23,10 +23,18 @@ int ext3_ioctl (struct inode * inode, st
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	unsigned int rtime;
 
 	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case EXT3_IOC_GETRTIME:
+		if (!test_opt(inode->i_sb, RTIME))
+			return -ENOTSUPP;
+		spin_lock(&inode->i_lock);
+		rtime = ei->i_rtime;
+		spin_unlock(&inode->i_lock);
+		return put_user(rtime, (unsigned int __user *) arg);
 	case EXT3_IOC_GETFLAGS:
 		ext3_get_inode_flags(ei);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/fs/ext3/namei.c linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/namei.c
--- linux-2.6.23-1-ext3_iflags_locking/fs/ext3/namei.c	2007-10-11 18:09:11.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/namei.c	2007-10-11 18:57:09.000000000 +0200
@@ -65,6 +65,55 @@ static struct buffer_head *ext3_append(h
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
+	while (test_bit(EXT3_RTIME_FL, &EXT3_I(inode)->i_flags)) {
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
+		spin_unlock(&inode->i_lock);
+		clear_bit(EXT3_RTIME_FL, &EXT3_I(inode)->i_flags);
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
@@ -775,7 +824,7 @@ static void ext3_update_dx_flag(struct i
 {
 	if (!EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
 				     EXT3_FEATURE_COMPAT_DIR_INDEX))
-		clear_bit(&EXT3_I(inode)->i_flags, EXT3_INDEX_FL);
+		EXT3_I(inode)->i_flags &= ~EXT3_INDEX_FL;
 }
 
 /*
@@ -1405,7 +1454,7 @@ static int make_indexed_dir(handle_t *ha
 		brelse(bh);
 		return retval;
 	}
-	set_bit(&EXT3_I(dir)->i_flags, EXT3_INDEX_FL);
+	EXT3_I(dir)->i_flags |= EXT3_INDEX_FL;
 	data1 = bh2->b_data;
 
 	/* The 0th block becomes the root, move the dirents out */
@@ -1738,6 +1787,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1773,6 +1824,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -1847,6 +1900,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2123,6 +2178,8 @@ static int ext3_rmdir (struct inode * di
 
 end_rmdir:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2177,6 +2234,8 @@ static int ext3_unlink(struct inode * di
 
 end_unlink:
 	ext3_journal_stop(handle);
+	if (!retval)
+		ext3_update_rtimes(dir);
 	brelse (bh);
 	return retval;
 }
@@ -2234,6 +2293,8 @@ out_stop:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2270,6 +2331,8 @@ retry:
 	ext3_journal_stop(handle);
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	if (!err)
+		ext3_update_rtimes(dir);
 	return err;
 }
 
@@ -2429,6 +2492,10 @@ end_rename:
 	brelse (old_bh);
 	brelse (new_bh);
 	ext3_journal_stop(handle);
+	if (!retval) {
+		ext3_update_rtimes(old_dir);
+		ext3_update_rtimes(new_dir);
+	}
 	return retval;
 }
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/fs/ext3/super.c linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/super.c
--- linux-2.6.23-1-ext3_iflags_locking/fs/ext3/super.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/fs/ext3/super.c	2007-10-11 18:14:03.000000000 +0200
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
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs.h linux-2.6.23-2-ext3_recursive_mtime/include/linux/ext3_fs.h
--- linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs.h	2007-10-11 17:01:28.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/include/linux/ext3_fs.h	2007-10-11 18:57:06.000000000 +0200
@@ -177,10 +177,11 @@ struct ext3_group_desc
 #define EXT3_NOTAIL_FL			15 /* file tail should not be merged */
 #define EXT3_DIRSYNC_FL			16 /* dirsync behaviour (directories only) */
 #define EXT3_TOPDIR_FL			17 /* Top of directory hierarchies*/
+#define EXT3_RTIME_FL			18 /* Update recursive mtime */
 #define EXT3_RESERVED_FL		31 /* reserved for ext3 lib */
 
-#define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-#define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
+#define EXT3_FL_USER_VISIBLE		0x0007DFFF /* User visible flags */
+#define EXT3_FL_USER_MODIFIABLE		0x000780FF /* User modifiable flags */
 
 /*
  * Inode dynamic state flags
@@ -229,6 +230,7 @@ struct ext3_new_group_data {
 #endif
 #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT3_IOC_GETRTIME		_IOR('f', 9, unsigned int)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -318,6 +320,7 @@ struct ext3_inode {
 	} osd2;				/* OS dependent 2 */
 	__le16	i_extra_isize;
 	__le16	i_pad1;
+	__le32	i_rtime;	/* Recursive Modification Time */
 };
 
 #define i_size_high	i_dir_acl
@@ -384,6 +387,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_RTIME		0x400000 /* Update rtime */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -572,6 +576,7 @@ static inline int ext3_valid_inum(struct
 #define EXT3_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT3_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT3_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT3_FEATURE_COMPAT_RTIME		0x0040
 
 #define EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT3_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -837,6 +842,14 @@ extern int ext3_orphan_add(handle_t *, s
 extern int ext3_orphan_del(handle_t *, struct inode *);
 extern int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
+extern int __ext3_update_rtimes(struct inode *inode);
+static inline int ext3_update_rtimes(struct inode *inode)
+{
+	if (test_opt(inode->i_sb, RTIME) &&
+	    test_bit(EXT3_RTIME_FL, &EXT3_I(inode)->i_flags))
+		return __ext3_update_rtimes(inode);
+	return 0;
+}
 
 /* resize.c */
 extern int ext3_group_add(struct super_block *sb,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs_i.h linux-2.6.23-2-ext3_recursive_mtime/include/linux/ext3_fs_i.h
--- linux-2.6.23-1-ext3_iflags_locking/include/linux/ext3_fs_i.h	2007-07-16 17:47:28.000000000 +0200
+++ linux-2.6.23-2-ext3_recursive_mtime/include/linux/ext3_fs_i.h	2007-10-11 18:14:03.000000000 +0200
@@ -78,6 +78,7 @@ struct ext3_inode_info {
 	ext3_fsblk_t	i_file_acl;
 	__u32	i_dir_acl;
 	__u32	i_dtime;
+	__u32	i_rtime;
 
 	/*
 	 * i_block_group is the number of the block group which contains
