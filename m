From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Fri, 02 Feb 2007 20:09:40 +0530
Message-ID: <1170427180.6086.17.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu,
	sct@redhat.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52048 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945900AbXBBOjg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Feb 2007 09:39:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patch is a spinoff of the old nanosecond patches. It includes some
cleanups and addition of a creation timestamp. The
EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
s_{min, want}_extra_isize fields in struct ext3_super_block. 

Any comments are welcome.

Index: linux-2.6.19/fs/ext3/ialloc.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/ialloc.c
+++ linux-2.6.19/fs/ext3/ialloc.c
@@ -560,7 +560,8 @@ got:
 	inode->i_ino = ino;
 	/* This is the optimal IO size (for stat), not the fs block size */
 	inode->i_blocks = 0;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
+						       ext3_current_time(inode);
 
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
@@ -592,9 +593,8 @@ got:
 	spin_unlock(&sbi->s_next_gen_lock);
 
 	ei->i_state = EXT3_STATE_NEW;
-	ei->i_extra_isize =
-		(EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) ?
-		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
+
+	ei->i_extra_isize = EXT3_SB(sb)->s_want_extra_isize;
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
Index: linux-2.6.19/fs/ext3/inode.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/inode.c
+++ linux-2.6.19/fs/ext3/inode.c
@@ -729,7 +729,7 @@ static int ext3_splice_branch(handle_t *
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = ext3_current_time(inode);
 	ext3_mark_inode_dirty(handle, inode);
 
 	/* had we spliced it onto indirect block? */
@@ -2374,7 +2374,7 @@ do_indirects:
 	ext3_discard_reservation(inode);
 
 	mutex_unlock(&ei->truncate_mutex);
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = ext3_current_time(inode);
 	ext3_mark_inode_dirty(handle, inode);
 
 	/*
@@ -2608,10 +2608,11 @@ void ext3_read_inode(struct inode * inod
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
-	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
-	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec =
inode->i_mtime.tv_nsec = 0;
+
+	EXT3_INODE_GET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
+	EXT3_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2763,9 +2764,11 @@ static int ext3_do_update_inode(handle_t
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
-	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
-	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
-	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	EXT3_INODE_SET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
+	EXT3_INODE_SET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
+
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
Index: linux-2.6.19/fs/ext3/ioctl.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/ioctl.c
+++ linux-2.6.19/fs/ext3/ioctl.c
@@ -96,7 +96,7 @@ int ext3_ioctl (struct inode * inode, st
 		ei->i_flags = flags;
 
 		ext3_set_inode_flags(inode);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = ext3_current_time(inode);
 
 		err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
@@ -133,7 +133,7 @@ flags_err:
 			return PTR_ERR(handle);
 		err = ext3_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
-			inode->i_ctime = CURRENT_TIME_SEC;
+			inode->i_ctime = ext3_current_time(inode);
 			inode->i_generation = generation;
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
Index: linux-2.6.19/fs/ext3/namei.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/namei.c
+++ linux-2.6.19/fs/ext3/namei.c
@@ -1275,7 +1275,7 @@ static int add_dirent_to_buf(handle_t *h
 	 * happen is that the times are slightly out of date
 	 * and/or different from the directory change time.
 	 */
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = ext3_current_time(dir);
 	ext3_update_dx_flag(dir);
 	dir->i_version++;
 	ext3_mark_inode_dirty(handle, dir);
@@ -2051,7 +2051,7 @@ static int ext3_rmdir (struct inode * di
 	 * recovery. */
 	inode->i_size = 0;
 	ext3_orphan_add(handle, inode);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime =
ext3_current_time(inode);
 	ext3_mark_inode_dirty(handle, inode);
 	drop_nlink(dir);
 	ext3_update_dx_flag(dir);
@@ -2101,7 +2101,7 @@ static int ext3_unlink(struct inode * di
 	retval = ext3_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_ctime = dir->i_mtime = ext3_current_time(dir);
 	ext3_update_dx_flag(dir);
 	ext3_mark_inode_dirty(handle, dir);
 	drop_nlink(inode);
@@ -2192,7 +2192,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = ext3_current_time(inode);
 	ext3_inc_count(handle, inode);
 	atomic_inc(&inode->i_count);
 
@@ -2294,7 +2294,7 @@ static int ext3_rename (struct inode * o
 	 * Like most other Unix systems, set the ctime for inodes on a
 	 * rename.
 	 */
-	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_ctime = ext3_current_time(old_inode);
 	ext3_mark_inode_dirty(handle, old_inode);
 
 	/*
@@ -2327,9 +2327,9 @@ static int ext3_rename (struct inode * o
 
 	if (new_inode) {
 		drop_nlink(new_inode);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = ext3_current_time(new_inode);
 	}
-	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+	old_dir->i_ctime = old_dir->i_mtime = ext3_current_time(old_dir);
 	ext3_update_dx_flag(old_dir);
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
Index: linux-2.6.19/fs/ext3/super.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/super.c
+++ linux-2.6.19/fs/ext3/super.c
@@ -1568,6 +1568,8 @@ static int ext3_fill_super (struct super
 				sbi->s_inode_size);
 			goto failed_mount;
 		}
+		if (sbi->s_inode_size > EXT3_GOOD_OLD_INODE_SIZE)
+			sb->s_time_gran = 1 << (EXT3_EPOCH_BITS - 2);
 	}
 	sbi->s_frag_size = EXT3_MIN_FRAG_SIZE <<
 				   le32_to_cpu(es->s_log_frag_size);
@@ -1770,6 +1772,32 @@ static int ext3_fill_super (struct super
 	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+
+	/* determine the minimum size of new large inodes, if present */
+	if (sbi->s_inode_size > EXT3_GOOD_OLD_INODE_SIZE) {
+	    EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) -
+						     EXT3_GOOD_OLD_INODE_SIZE;
+		if (EXT3_HAS_RO_COMPAT_FEATURE(sb,
+		    EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
+			if (EXT3_SB(sb)->s_want_extra_isize <
+			    le32_to_cpu(es->s_want_extra_isize))
+				EXT3_SB(sb)->s_want_extra_isize =
+					le32_to_cpu(es->s_want_extra_isize);
+			if (EXT3_SB(sb)->s_want_extra_isize <
+			    le32_to_cpu(es->s_min_extra_isize))
+				EXT3_SB(sb)->s_want_extra_isize =
+					le32_to_cpu(es->s_min_extra_isize);
+		}
+	}
+	/* Check if enough inode space is available */
+	if (EXT3_GOOD_OLD_INODE_SIZE + EXT3_SB(sb)->s_want_extra_isize >
+							sbi->s_inode_size) {
+		EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) -
+						       EXT3_GOOD_OLD_INODE_SIZE;
+		printk(KERN_INFO "EXT3-fs: required extra inode space not"
+			"available.\n");
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
Index: linux-2.6.19/fs/ext3/xattr.c
===================================================================
--- linux-2.6.19.orig/fs/ext3/xattr.c
+++ linux-2.6.19/fs/ext3/xattr.c
@@ -1007,7 +1007,7 @@ ext3_xattr_set_handle(handle_t *handle, 
 	}
 	if (!error) {
 		ext3_xattr_update_super_block(handle, inode->i_sb);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = ext3_current_time(inode);
 		error = ext3_mark_iloc_dirty(handle, inode, &is.iloc);
 		/*
 		 * The bh is consumed by ext3_mark_iloc_dirty, even with
Index: linux-2.6.19/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext3_fs.h
+++ linux-2.6.19/include/linux/ext3_fs.h
@@ -269,7 +269,7 @@ struct ext3_inode {
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
 	__le32	i_size;		/* Size in bytes */
 	__le32	i_atime;	/* Access time */
-	__le32	i_ctime;	/* Creation time */
+	__le32  i_ctime;        /* Inode Change time */
 	__le32	i_mtime;	/* Modification time */
 	__le32	i_dtime;	/* Deletion Time */
 	__le16	i_gid;		/* Low 16 bits of Group Id */
@@ -318,10 +318,53 @@ struct ext3_inode {
 	} osd2;				/* OS dependent 2 */
 	__le16	i_extra_isize;
 	__le16	i_pad1;
+	__le32  i_ctime_extra;  /* extra Change time      (nsec << 2 | epoch)
*/
+	__le32  i_mtime_extra;  /* extra Modification time(nsec << 2 | epoch)
*/
+	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch)
*/
+	__le32  i_crtime;       /* File Creation time */
+	__le32  i_crtime_extra; /* extra File Creation time (nsec << 2 |
epoch) */
 };
 
 #define i_size_high	i_dir_acl
 
+#define EXT3_EPOCH_BITS 2
+#define EXT3_EPOCH_MASK ((1 << EXT3_EPOCH_BITS) - 1)
+#define EXT3_NSEC_MASK  (~0UL << EXT3_EPOCH_BITS)
+
+#define EXT3_INODE_SET_XTIME(xtime, extra_xtime, inode, raw_inode)
\
+do {
\
+	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);
\
+									      \
+	if (offsetof(typeof(*raw_inode), extra_xtime) -
\
+	    offsetof(typeof(*raw_inode), i_extra_isize) +
\
+	    sizeof((raw_inode)->extra_xtime) <=
\
+		le16_to_cpu((raw_inode)->i_extra_isize))                      \
+		(raw_inode)->extra_xtime =                                    \
+			cpu_to_le32((sizeof((inode)->xtime.tv_sec) > 4 ?      \
+				((__u64)(inode)->xtime.tv_sec >> 32) : 0)|    \
+				(((inode)->xtime.tv_nsec << 2) &              \
+				EXT3_NSEC_MASK));                             \
+} while (0)
+
+#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode)
\
+do {
\
+	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);
\
+									      \
+	if (offsetof(typeof(*raw_inode), extra_xtime) -
\
+	    offsetof(typeof(*raw_inode), i_extra_isize) +
\
+   	    sizeof((raw_inode)->extra_xtime) <=
\
+	    le16_to_cpu((raw_inode)->i_extra_isize)) {
\
+		if (sizeof((inode)->xtime.tv_sec) > 4)                        \
+			(inode)->xtime.tv_sec |=                              \
+			(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &       \
+				EXT3_EPOCH_MASK) << 32;                       \
+			(inode)->xtime.tv_nsec =                              \
+				(le32_to_cpu((raw_inode)->extra_xtime) &      \
+				EXT3_NSEC_MASK) >> 2;                         \
+	}
\
+} while (0)
+
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
@@ -491,7 +534,9 @@ struct ext3_super_block {
 	__u16	s_reserved_word_pad;
 	__le32	s_default_mount_opts;
 	__le32	s_first_meta_bg;	/* First metablock block group */
-	__u32	s_reserved[190];	/* Padding to the end of the block */
+	__u16   s_min_extra_isize;      /* All inodes have at least # bytes */
+	__u16   s_want_extra_isize;     /* New inodes should reserve # bytes
*/
+	__u32   s_reserved[189];        /* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -514,6 +559,13 @@ static inline int ext3_valid_inum(struct
 		(ino >= EXT3_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT3_SB(sb)->s_es->s_inodes_count));
 }
+
+static inline struct timespec ext3_current_time(struct inode *inode)
+{
+	return (inode->i_sb->s_time_gran < 1000000000) ?
+		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
+}
+
 #else
 /* Assume that user mode programs are passing in an ext3fs superblock,
not
  * a kernel struct super_block.  This will allow us to call the
feature-test
@@ -576,6 +628,7 @@ static inline int ext3_valid_inum(struct
 #define EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT3_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT3_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 
 #define EXT3_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT3_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -589,6 +642,7 @@ static inline int ext3_valid_inum(struct
 					 EXT3_FEATURE_INCOMPAT_META_BG)
 #define EXT3_FEATURE_RO_COMPAT_SUPP
(EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT3_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
 					 EXT3_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
Index: linux-2.6.19/include/linux/ext3_fs_i.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext3_fs_i.h
+++ linux-2.6.19/include/linux/ext3_fs_i.h
@@ -142,6 +142,7 @@ struct ext3_inode_info {
 	 */
 	struct mutex truncate_mutex;
 	struct inode vfs_inode;
+	struct timespec i_crtime;
 };
 
 #endif	/* _LINUX_EXT3_FS_I */
Index: linux-2.6.19/include/linux/ext3_fs_sb.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext3_fs_sb.h
+++ linux-2.6.19/include/linux/ext3_fs_sb.h
@@ -78,6 +78,7 @@ struct ext3_sb_info {
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled
quota */
 	int s_jquota_fmt;			/* Format of quota to use */
 #endif
+	u16   s_want_extra_isize;               /* New inodes should reserve #
bytes */
 };
 
 #endif	/* _LINUX_EXT3_FS_SB */


Thanks,
Kalpak <kalpak@clusterfs.com>
