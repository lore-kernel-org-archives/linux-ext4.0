From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH Take2 1/1] Nanosecond timestamps
Date: Tue, 13 Feb 2007 18:46:44 +0530
Message-ID: <1171372604.16444.21.camel@garfield>
References: <1170427790.6464.6.camel@garfield>
	 <20070206151242.GB3140@lombardij>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>, sct@redhat.com,
	Johann Lombardi <johann.lombardi@bull.net>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45792 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXBMNQW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Feb 2007 08:16:22 -0500
In-Reply-To: <20070206151242.GB3140@lombardij>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

Thanks for all your comments. I have made the changes as suggested and ensured that no fields after EXT4_GOOD_OLD_INODE_SIZE are accessed without proper checks to avoid corruptions. Also I have rebased the code to ext4 in linux-2.6.20 for inclusion upstream.

Index: linux-2.6.20/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/ialloc.c
+++ linux-2.6.20/fs/ext4/ialloc.c
@@ -563,7 +563,8 @@ got:
 	inode->i_ino = ino;
 	/* This is the optimal IO size (for stat), not the fs block size */
 	inode->i_blocks = 0;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
+						       ext4_current_time(inode);
 
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
@@ -595,9 +596,8 @@ got:
 	spin_unlock(&sbi->s_next_gen_lock);
 
 	ei->i_state = EXT4_STATE_NEW;
-	ei->i_extra_isize =
-		(EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) ?
-		sizeof(struct ext4_inode) - EXT4_GOOD_OLD_INODE_SIZE : 0;
+
+	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
Index: linux-2.6.20/fs/ext4/inode.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/inode.c
+++ linux-2.6.20/fs/ext4/inode.c
@@ -727,7 +727,7 @@ static int ext4_splice_branch(handle_t *
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
 	/* had we spliced it onto indirect block? */
@@ -2441,7 +2441,7 @@ do_indirects:
 	ext4_discard_reservation(inode);
 
 	mutex_unlock(&ei->truncate_mutex);
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
 	/*
@@ -2676,10 +2676,11 @@ void ext4_read_inode(struct inode * inod
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
-	inode->i_atime.tv_sec = le32_to_cpu(raw_inode->i_atime);
-	inode->i_ctime.tv_sec = le32_to_cpu(raw_inode->i_ctime);
-	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode->i_mtime);
-	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_mtime.tv_nsec = 0;
+
+	EXT4_INODE_GET_XTIME(i_ctime, i_ctime_extra, ei, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_mtime, i_mtime_extra, ei, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_atime, i_atime_extra, ei, inode, raw_inode);
+	EXT4_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, ei, raw_inode);
 
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
@@ -2835,9 +2836,12 @@ static int ext4_do_update_inode(handle_t
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
-	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
-	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
-	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+
+	EXT4_INODE_SET_XTIME(i_ctime, i_ctime_extra, ei, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_mtime, i_mtime_extra, ei, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_atime, i_atime_extra, ei, inode, raw_inode);
+	EXT4_INODE_SET_XTIME(i_crtime, i_crtime_extra, ei, ei, raw_inode);
+
 	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
Index: linux-2.6.20/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/ioctl.c
+++ linux-2.6.20/fs/ext4/ioctl.c
@@ -96,7 +96,7 @@ int ext4_ioctl (struct inode * inode, st
 		ei->i_flags = flags;
 
 		ext4_set_inode_flags(inode);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = ext4_current_time(inode);
 
 		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
@@ -133,7 +133,7 @@ flags_err:
 			return PTR_ERR(handle);
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
-			inode->i_ctime = CURRENT_TIME_SEC;
+			inode->i_ctime = ext4_current_time(inode);
 			inode->i_generation = generation;
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
Index: linux-2.6.20/fs/ext4/namei.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/namei.c
+++ linux-2.6.20/fs/ext4/namei.c
@@ -1282,7 +1282,7 @@ static int add_dirent_to_buf(handle_t *h
 	 * happen is that the times are slightly out of date
 	 * and/or different from the directory change time.
 	 */
-	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
 	dir->i_version++;
 	ext4_mark_inode_dirty(handle, dir);
@@ -2058,7 +2058,7 @@ static int ext4_rmdir (struct inode * di
 	 * recovery. */
 	inode->i_size = 0;
 	ext4_orphan_add(handle, inode);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	drop_nlink(dir);
 	ext4_update_dx_flag(dir);
@@ -2108,13 +2108,13 @@ static int ext4_unlink(struct inode * di
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
 	drop_nlink(inode);
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
-	inode->i_ctime = dir->i_ctime;
+	inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	retval = 0;
 
@@ -2199,7 +2199,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
 	atomic_inc(&inode->i_count);
 
@@ -2301,7 +2301,7 @@ static int ext4_rename (struct inode * o
 	 * Like most other Unix systems, set the ctime for inodes on a
 	 * rename.
 	 */
-	old_inode->i_ctime = CURRENT_TIME_SEC;
+	old_inode->i_ctime = ext4_current_time(old_inode);
 	ext4_mark_inode_dirty(handle, old_inode);
 
 	/*
@@ -2334,9 +2334,9 @@ static int ext4_rename (struct inode * o
 
 	if (new_inode) {
 		drop_nlink(new_inode);
-		new_inode->i_ctime = CURRENT_TIME_SEC;
+		new_inode->i_ctime = ext4_current_time(new_inode);
 	}
-	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
 	ext4_update_dx_flag(old_dir);
 	if (dir_bh) {
 		BUFFER_TRACE(dir_bh, "get_write_access");
Index: linux-2.6.20/fs/ext4/super.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/super.c
+++ linux-2.6.20/fs/ext4/super.c
@@ -1631,6 +1631,8 @@ static int ext4_fill_super (struct super
 				sbi->s_inode_size);
 			goto failed_mount;
 		}
+		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
+			sb->s_time_gran = 1 << (EXT4_EPOCH_BITS - 2);
 	}
 	sbi->s_frag_size = EXT4_MIN_FRAG_SIZE <<
 				   le32_to_cpu(es->s_log_frag_size);
@@ -1847,6 +1849,32 @@ static int ext4_fill_super (struct super
 	}
 
 	ext4_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+
+	/* determine the minimum size of new large inodes, if present */
+	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						     EXT4_GOOD_OLD_INODE_SIZE;
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_want_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_want_extra_isize);
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_min_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_min_extra_isize);
+		}
+	}
+	/* Check if enough inode space is available */
+	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
+							sbi->s_inode_size) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						       EXT4_GOOD_OLD_INODE_SIZE;
+		printk(KERN_INFO "EXT4-fs: required extra inode space not"
+			"available.\n");
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
Index: linux-2.6.20/fs/ext4/xattr.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/xattr.c
+++ linux-2.6.20/fs/ext4/xattr.c
@@ -1004,7 +1004,7 @@ ext4_xattr_set_handle(handle_t *handle, 
 	}
 	if (!error) {
 		ext4_xattr_update_super_block(handle, inode->i_sb);
-		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_ctime = ext4_current_time(inode);
 		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
 		/*
 		 * The bh is consumed by ext4_mark_iloc_dirty, even with
Index: linux-2.6.20/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.20.orig/include/linux/ext4_fs.h
+++ linux-2.6.20/include/linux/ext4_fs.h
@@ -282,7 +282,7 @@ struct ext4_inode {
 	__le16	i_uid;		/* Low 16 bits of Owner Uid */
 	__le32	i_size;		/* Size in bytes */
 	__le32	i_atime;	/* Access time */
-	__le32	i_ctime;	/* Creation time */
+	__le32	i_ctime;	/* Inode Change time */
 	__le32	i_mtime;	/* Modification time */
 	__le32	i_dtime;	/* Deletion Time */
 	__le16	i_gid;		/* Low 16 bits of Group Id */
@@ -331,10 +331,54 @@ struct ext4_inode {
 	} osd2;				/* OS dependent 2 */
 	__le16	i_extra_isize;
 	__le16	i_pad1;
+	__le32  i_ctime_extra;  /* extra Change time      (nsec << 2 | epoch) */
+	__le32  i_mtime_extra;  /* extra Modification time(nsec << 2 | epoch) */
+	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
+	__le32  i_crtime;       /* File Creation time */
+	__le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch) */
 };
 
 #define i_size_high	i_dir_acl
 
+#define EXT4_EPOCH_BITS 2
+#define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
+#define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
+
+#define EXT4_INODE_SET_XTIME(xtime, extra_xtime, ei, inode, raw_inode)	       \
+do {									       \
+	if (offsetof(typeof(*raw_inode), xtime) +			       \
+	    sizeof((raw_inode)->xtime) <= 				       \
+	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
+		(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);       \
+	if (offsetof(typeof(*raw_inode), extra_xtime) +			       \
+	    sizeof((raw_inode)->extra_xtime) <=				       \
+	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
+		(raw_inode)->extra_xtime =				       \
+			cpu_to_le32((sizeof((inode)->xtime.tv_sec) > 4 ?       \
+				((__u64)(inode)->xtime.tv_sec >> 32) : 0)|     \
+				(((inode)->xtime.tv_nsec << 2) &	       \
+				EXT4_NSEC_MASK));			       \
+} while (0)
+
+#define EXT4_INODE_GET_XTIME(xtime, extra_xtime, ei, inode, raw_inode)	       \
+do {									       \
+	if (offsetof(typeof(*raw_inode), xtime) +			       \
+	    sizeof((raw_inode)->xtime) <=				       \
+	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize) 		       \
+		(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);       \
+	if (offsetof(typeof(*raw_inode), extra_xtime) +			       \
+	    sizeof((raw_inode)->extra_xtime) <= 			       \
+	    EXT4_GOOD_OLD_INODE_SIZE + (ei)->i_extra_isize){		       \
+		if (sizeof((inode)->xtime.tv_sec) > 4)			       \
+			(inode)->xtime.tv_sec |=			       \
+				(__u64)(le32_to_cpu((raw_inode)->extra_xtime) &\
+					EXT4_EPOCH_MASK) << 32;		       \
+			(inode)->xtime.tv_nsec =			       \
+				(le32_to_cpu((raw_inode)->extra_xtime) &       \
+					EXT4_NSEC_MASK) >> 2;		       \
+	}								       \
+} while (0)
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag
@@ -513,7 +557,9 @@ struct ext4_super_block {
 /*150*/	__le32	s_blocks_count_hi;	/* Blocks count */
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
-	__u32	s_reserved[169];	/* Padding to the end of the block */
+	__le16  s_min_extra_isize;      /* All inodes have at least # bytes */
+	__le16  s_want_extra_isize;     /* New inodes should reserve # bytes */
+	__u32   s_reserved[168];	/* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -526,6 +572,13 @@ static inline struct ext4_inode_info *EX
 	return container_of(inode, struct ext4_inode_info, vfs_inode);
 }
 
+static inline struct timespec ext4_current_time(struct inode *inode)
+{
+	return (inode->i_sb->s_time_gran < 1000000000) ?
+		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
+}
+
+
 static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 {
 	return ino == EXT4_ROOT_INO ||
@@ -596,6 +649,7 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT4_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -613,6 +667,7 @@ static inline int ext4_valid_inum(struct
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
Index: linux-2.6.20/include/linux/ext4_fs_i.h
===================================================================
--- linux-2.6.20.orig/include/linux/ext4_fs_i.h
+++ linux-2.6.20/include/linux/ext4_fs_i.h
@@ -153,6 +153,7 @@ struct ext4_inode_info {
 
 	unsigned long i_ext_generation;
 	struct ext4_ext_cache i_cached_extent;
+	struct timespec i_crtime;
 };
 
 #endif	/* _LINUX_EXT4_FS_I */
Index: linux-2.6.20/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.20.orig/include/linux/ext4_fs_sb.h
+++ linux-2.6.20/include/linux/ext4_fs_sb.h
@@ -89,6 +89,7 @@ struct ext4_sb_info {
 	unsigned long s_ext_blocks;
 	unsigned long s_ext_extents;
 #endif
+	unsigned int  s_want_extra_isize;               /* New inodes should reserve # bytes */
 };
 
 #endif	/* _LINUX_EXT4_FS_SB */


Thanks,
Kalpak. <kalpak@clusterfs.com>


On Tue, 2007-02-06 at 16:12 +0100, Johann Lombardi wrote:
> On Fri, Feb 02, 2007 at 08:19:50PM +0530, Kalpak Shah wrote:
> > Index: linux-2.6.19/fs/ext3/super.c
> > ===================================================================
> > --- linux-2.6.19.orig/fs/ext3/super.c
> > +++ linux-2.6.19/fs/ext3/super.c
> > @@ -1770,6 +1772,32 @@ static int ext3_fill_super (struct super
> >         }
> >  
> >         ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
> > +
> > +       /* determine the minimum size of new large inodes, if present */
> > +       if (sbi->s_inode_size > EXT3_GOOD_OLD_INODE_SIZE) {
> > +           EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) -  EXT3_GOOD_OLD_INODE_SIZE;
> 
> Maybe EXT3_SB(sb)-> could be replaced by sbi-> here and in the lines below.
> 
> > +               if (EXT3_HAS_RO_COMPAT_FEATURE(sb,
> > +                   EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
> > +                       if (EXT3_SB(sb)->s_want_extra_isize <
> > +                           le32_to_cpu(es->s_want_extra_isize))
>                                 ^^
> > +                               EXT3_SB(sb)->s_want_extra_isize =
> > +                                       le32_to_cpu(es->s_want_extra_isize);
>                                             ^^
> > +                       if (EXT3_SB(sb)->s_want_extra_isize <
> > +                           le32_to_cpu(es->s_min_extra_isize))
>                                 ^^
> > +                               EXT3_SB(sb)->s_want_extra_isize =
> > +                                       le32_to_cpu(es->s_min_extra_isize);
>                                             ^^
> Since es->s_{min,want}_extra_isize are both __u16 (BTW, shouldn't it be __le16?),
> I think you should use le16_to_cpu() instead of le32_to_cpu().
> 
> > +               }
> > +       }
> > +       /* Check if enough inode space is available */
> > +       if (EXT3_GOOD_OLD_INODE_SIZE + EXT3_SB(sb)->s_want_extra_isize >
> > +                                                       sbi->s_inode_size) {
> > +               EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
> > +               printk(KERN_INFO "EXT3-fs: required extra inode space not"
> > +                       "available.\n");
> > +       }
> 
> If the inode size is EXT3_GOOD_OLD_INODE_SIZE, sbi->s_want_extra_isize won't be
> initialized. However, it should not be an issue because the ext3_sb_info
> is set to zero in ext3_fill_super().
> 
> Johann
