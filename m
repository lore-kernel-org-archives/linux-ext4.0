From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: Use bitops to read/modify EXT4_I(inode)->i_flags
Date: Mon, 19 Apr 2010 18:32:16 +0400
Message-ID: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54185 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0DSOcY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 10:32:24 -0400
Received: by bwz25 with SMTP id 25so5659952bwz.28
        for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 07:32:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At several places we modify EXT4_I(inode)->i_flags without holding
i_mutex (ext4_do_update_inode, ...). These modifications are racy and we can
lose updates to i_flags. So convert handling of i_flags to use bitops
which are atomic.
https://bugzilla.kernel.org/show_bug.cgi?id=15792

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/dir.c         |    4 +-
 fs/ext4/ext4.h        |  103 +++++++++++++++++++++++++++++++-----------------
 fs/ext4/ext4_jbd2.h   |    8 ++--
 fs/ext4/extents.c     |   10 ++--
 fs/ext4/file.c        |    2 +-
 fs/ext4/ialloc.c      |    4 +-
 fs/ext4/inode.c       |   71 ++++++++++++++++++++--------------
 fs/ext4/mballoc.c     |    4 +-
 fs/ext4/migrate.c     |    4 +-
 fs/ext4/move_extent.c |    4 +-
 fs/ext4/namei.c       |   10 ++--
 fs/ext4/xattr.c       |    4 +-
 12 files changed, 135 insertions(+), 93 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 86cb6d8..a696746 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -111,7 +111,7 @@ static int ext4_readdir(struct file *filp,
 
 	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
 				    EXT4_FEATURE_COMPAT_DIR_INDEX) &&
-	    ((EXT4_I(inode)->i_flags & EXT4_INDEX_FL) ||
+	    (ext4_test_inode_flag(inode, EXT4_INODE_INDEX) ||
 	     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
 		err = ext4_dx_readdir(filp, dirent, filldir);
 		if (err != ERR_BAD_DX_DIR) {
@@ -122,7 +122,7 @@ static int ext4_readdir(struct file *filp,
 		 * We don't set the inode dirty flag since it's not
 		 * critical that it get flushed back to the disk.
 		 */
-		EXT4_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT4_INDEX_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 	}
 	stored = 0;
 	offset = filp->f_pos & (sb->s_blocksize - 1);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..6641c58 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -268,31 +268,57 @@ struct flex_groups {
 /*
  * Inode flags
  */
-#define	EXT4_SECRM_FL			0x00000001 /* Secure deletion */
-#define	EXT4_UNRM_FL			0x00000002 /* Undelete */
-#define	EXT4_COMPR_FL			0x00000004 /* Compress file */
-#define EXT4_SYNC_FL			0x00000008 /* Synchronous updates */
-#define EXT4_IMMUTABLE_FL		0x00000010 /* Immutable file */
-#define EXT4_APPEND_FL			0x00000020 /* writes to file may only append */
-#define EXT4_NODUMP_FL			0x00000040 /* do not dump file */
-#define EXT4_NOATIME_FL			0x00000080 /* do not update atime */
+enum {
+	EXT4_INODE_SECRM	= 0, 	/* Secure deletion */
+	EXT4_INODE_UNORM	= 1, 	/* Undelete */
+	EXT4_INODE_COMPR 	= 2,	/* Compress file */
+	EXT4_INODE_SYNC		= 3,	/* Synchronous updates */
+	EXT4_INODE_IMMUTABLE	= 4,	/* Immutable file */
+	EXT4_INODE_APPEND	= 5,	/* writes to file may only append */
+	EXT4_INODE_NODUMP	= 6,	/* do not dump file */
+	EXT4_INODE_NOATIME	= 7,	/* do not update atime */
 /* Reserved for compression usage... */
-#define EXT4_DIRTY_FL			0x00000100
-#define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
-#define EXT4_ECOMPR_FL			0x00000800 /* Compression error */
+	EXT4_INODE_DIRTY	= 8,
+	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
+	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
+	EXT4_INODE_ECOMPR	= 11,	/* Compression error */
 /* End compression flags --- maybe not all used */
-#define EXT4_INDEX_FL			0x00001000 /* hash-indexed directory */
-#define EXT4_IMAGIC_FL			0x00002000 /* AFS directory */
-#define EXT4_JOURNAL_DATA_FL		0x00004000 /* file data should be journaled */
-#define EXT4_NOTAIL_FL			0x00008000 /* file tail should not be merged */
-#define EXT4_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
-#define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
-#define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
-#define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
-#define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
-#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
-#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
+	EXT4_INODE_INDEX	= 12,	/* hash-indexed directory */
+	EXT4_INODE_IMAGIC	= 13,	/* AFS directory */
+	EXT4_INODE_JOURNAL_DATA	= 14,	/* file data should be journaled */
+	EXT4_INODE_NOTAIL	= 15,	/* file tail should not be merged */
+	EXT4_INODE_DIRSYNC	= 16,	/* dirsync behaviour (directories only) */
+	EXT4_INODE_TOPDIR	= 17,	/* Top of directory hierarchies*/
+	EXT4_INODE_HUGE_FILE	= 18,	/* Set to each huge file */
+	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
+	EXT4_INODE_EA_INODE	= 20,	/* Inode used for large EA */
+	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
+	EXT4_INODE_RESERVED	= 23,	/* reserved for ext4 lib */
+};
+
+#define	EXT4_SECRM_FL		(1 << EXT4_INODE_SECRM)
+#define	EXT4_UNRM_FL		(1 << EXT4_INODE_UNORM)
+#define	EXT4_COMPR_FL		(1 << EXT4_INODE_COMPR)
+#define EXT4_SYNC_FL		(1 << EXT4_INODE_SYNC)
+#define EXT4_IMMUTABLE_FL	(1 << EXT4_INODE_IMMUTABLE)
+#define EXT4_APPEND_FL		(1 << EXT4_INODE_APPEND)
+#define EXT4_NODUMP_FL		(1 << EXT4_INODE_NODUMP)
+#define EXT4_NOATIME_FL		(1 << EXT4_INODE_NOATIME)
+#define EXT4_DIRTY_FL		(1 << EXT4_INODE_DIRTY)
+#define EXT4_COMPRBLK_FL	(1 << EXT4_INODE_COMPRBLK)
+#define EXT4_NOCOMPR_FL		(1 << EXT4_INODE_NOCOMPR)
+#define EXT4_ECOMPR_FL		(1 << EXT4_INODE_ECOMPR)
+#define EXT4_INDEX_FL		(1 << EXT4_INODE_INDEX)
+#define EXT4_IMAGIC_FL		(1 << EXT4_INODE_IMAGIC)
+#define EXT4_JOURNAL_DATA_FL	(1 << EXT4_INODE_JOURNAL_DATA)
+#define EXT4_NOTAIL_FL		(1 << EXT4_INODE_NOTAIL)
+#define EXT4_DIRSYNC_FL		(1 << EXT4_INODE_DIRSYNC)
+#define EXT4_TOPDIR_FL		(1 << EXT4_INODE_TOPDIR)
+#define EXT4_HUGE_FILE_FL	(1 << EXT4_INODE_HUGE_FILE)
+#define EXT4_EXTENTS_FL		(1 << EXT4_INODE_EXTENTS)
+#define EXT4_EA_INODE_FL	(1 << EXT4_INODE_EA_INODE)
+#define EXT4_EOFBLOCKS_FL	(1 << EXT4_INODE_EOFBLOCKS)
+#define EXT4_RESERVED_FL	(1 << EXT4_INODE_RESERVED)
 
 #define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
@@ -616,7 +642,6 @@ struct ext4_ext_cache {
  */
 struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
-	__u32	i_flags;
 	ext4_fsblk_t	i_file_acl;
 	__u32	i_dtime;
 
@@ -628,8 +653,10 @@ struct ext4_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	ext4_group_t	i_block_group;
+	unsigned long	i_flags;
 	unsigned long	i_state_flags;		/* Dynamic state flags */
 
+
 	ext4_lblk_t		i_dir_start_lookup;
 #ifdef CONFIG_EXT4_FS_XATTR
 	/*
@@ -1064,20 +1091,22 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 };
 
-static inline int ext4_test_inode_state(struct inode *inode, int bit)
-{
-	return test_bit(bit, &EXT4_I(inode)->i_state_flags);
-}
-
-static inline void ext4_set_inode_state(struct inode *inode, int bit)
-{
-	set_bit(bit, &EXT4_I(inode)->i_state_flags);
+#define EXT4_INODE_BIT_FNS(name, field)					\
+static inline int ext4_test_inode_##name(struct inode *inode, int bit)	\
+{									\
+	return test_bit(bit, &EXT4_I(inode)->i_##field);		\
+}									\
+static inline void ext4_set_inode_##name(struct inode *inode, int bit) 	\
+{									\
+	set_bit(bit, &EXT4_I(inode)->i_##field);			\
+}									\
+static inline void ext4_clear_inode_##name(struct inode *inode, int bit) \
+{									\
+	clear_bit(bit, &EXT4_I(inode)->i_##field);			\
 }
 
-static inline void ext4_clear_inode_state(struct inode *inode, int bit)
-{
-	clear_bit(bit, &EXT4_I(inode)->i_state_flags);
-}
+EXT4_INODE_BIT_FNS(flag, flags)
+EXT4_INODE_BIT_FNS(state, state_flags)
 #else
 /* Assume that user mode programs are passing in an ext4fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
@@ -1264,7 +1293,7 @@ struct ext4_dir_entry_2 {
 
 #define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
 				      EXT4_FEATURE_COMPAT_DIR_INDEX) && \
-		      (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
+			ext4_test_inode_flag((dir), EXT4_INODE_INDEX))
 #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
 #define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index b79ad51..f35d77c 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -273,7 +273,7 @@ static inline int ext4_should_journal_data(struct inode *inode)
 		return 1;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		return 1;
-	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 1;
 	return 0;
 }
@@ -284,7 +284,7 @@ static inline int ext4_should_order_data(struct inode *inode)
 		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
-	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
 		return 1;
@@ -297,7 +297,7 @@ static inline int ext4_should_writeback_data(struct inode *inode)
 		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 1;
-	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
 		return 1;
@@ -321,7 +321,7 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return 0;
 	if (ext4_should_journal_data(inode))
 		return 0;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1938418..7c7b1d5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3509,7 +3509,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			set_buffer_uninit(bh_result);
 	}
 
-	if (unlikely(EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL)) {
+	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
 		if (unlikely(!eh->eh_entries)) {
 			EXT4_ERROR_INODE(inode,
 					 "eh->eh_entries == 0 ee_block %d",
@@ -3520,7 +3520,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		last_ex = EXT_LAST_EXTENT(eh);
 		if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
 		    + ext4_ext_get_actual_len(last_ex))
-			EXT4_I(inode)->i_flags &= ~EXT4_EOFBLOCKS_FL;
+			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
@@ -3661,7 +3661,7 @@ static void ext4_falloc_update_inode(struct inode *inode,
 		 * can proceed even if the new size is the same as i_size.
 		 */
 		if (new_size > i_size_read(inode))
-			EXT4_I(inode)->i_flags |= EXT4_EOFBLOCKS_FL;
+			ext4_set_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 	}
 
 }
@@ -3689,7 +3689,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
 	 */
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return -EOPNOTSUPP;
 
 	/* preallocation to directories is currently not supported */
@@ -3933,7 +3933,7 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	int error = 0;
 
 	/* fallback to generic here if not in extents fmt */
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return generic_block_fiemap(inode, fieinfo, start, len,
 			ext4_get_block);
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d0776e4..a708d15 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -66,7 +66,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	 * is smaller than s_maxbytes, which is for extent-mapped files.
 	 */
 
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 		size_t length = iov_length(iov, nr_segs);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25fe42f..8d3a4d6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -499,7 +499,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 
 	if (S_ISDIR(mode) &&
 	    ((parent == sb->s_root->d_inode) ||
-	     (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL))) {
+		    ext4_test_inode_flag(parent, EXT4_INODE_TOPDIR))) {
 		int best_ndir = inodes_per_group;
 		int ret = -1;
 
@@ -1045,7 +1045,7 @@ got:
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
 		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
-			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
+			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 			ext4_ext_tree_init(handle, inode);
 		}
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 11119e0..8fe4e68 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -932,7 +932,7 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
 
-	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
+	J_ASSERT(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	J_ASSERT(handle != NULL || (flags & EXT4_GET_BLOCKS_CREATE) == 0);
 	depth = ext4_block_to_path(inode, iblock, offsets,
 				   &blocks_to_boundary);
@@ -1060,7 +1060,7 @@ static int ext4_indirect_calc_metadata_amount(struct inode *inode,
  */
 static int ext4_calc_metadata_amount(struct inode *inode, sector_t lblock)
 {
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ext_calc_metadata_amount(inode, lblock);
 
 	return ext4_indirect_calc_metadata_amount(inode, lblock);
@@ -1249,7 +1249,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	 * file system block.
 	 */
 	down_read((&EXT4_I(inode)->i_data_sem));
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, 0);
 	} else {
@@ -1311,7 +1311,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 	 * We need to check for EXT4 here because migrate
 	 * could have changed the inode type in between
 	 */
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 					      bh, flags);
 	} else {
@@ -2349,7 +2349,7 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	int nrblocks = mpd->b_size >> mpd->inode->i_blkbits;
 
 	/* check if thereserved journal credits might overflow */
-	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
+	if (!ext4_test_inode_flag(mpd->inode, EXT4_INODE_EXTENTS)) {
 		if (nrblocks >= EXT4_MAX_TRANS_DATA) {
 			/*
 			 * With non-extent format we are limited by the journal
@@ -2820,7 +2820,7 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 	 * number of contiguous block. So we will limit
 	 * number of contiguous block to a sane value
 	 */
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
 	    (max_blocks > EXT4_MAX_TRANS_DATA))
 		max_blocks = EXT4_MAX_TRANS_DATA;
 
@@ -3972,7 +3972,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
 
 	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
@@ -4611,12 +4611,12 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
-	EXT4_I(inode)->i_flags &= ~EXT4_EOFBLOCKS_FL;
+	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 
 	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		ext4_ext_truncate(inode);
 		return;
 	}
@@ -4922,19 +4922,32 @@ void ext4_set_inode_flags(struct inode *inode)
 void ext4_get_inode_flags(struct ext4_inode_info *ei)
 {
 	unsigned int flags = ei->vfs_inode.i_flags;
+	struct inode *inode =  &(ei->vfs_inode);
 
-	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
 	if (flags & S_SYNC)
-		ei->i_flags |= EXT4_SYNC_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_SYNC);
+	else
+		ext4_clear_inode_flag(inode, EXT4_INODE_SYNC);
+
 	if (flags & S_APPEND)
-		ei->i_flags |= EXT4_APPEND_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_APPEND);
+	else
+		ext4_clear_inode_flag(inode, EXT4_INODE_APPEND);
+
 	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT4_IMMUTABLE_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_IMMUTABLE);
+	else
+		ext4_clear_inode_flag(inode, EXT4_INODE_IMMUTABLE);
+
 	if (flags & S_NOATIME)
-		ei->i_flags |= EXT4_NOATIME_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_NOATIME);
+	else
+		ext4_clear_inode_flag(inode, EXT4_INODE_NOATIME);
+
 	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT4_DIRSYNC_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_DIRSYNC);
+	else
+		ext4_clear_inode_flag(inode, EXT4_INODE_DIRSYNC);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
@@ -4949,7 +4962,7 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
 					le32_to_cpu(raw_inode->i_blocks_lo);
-		if (ei->i_flags & EXT4_HUGE_FILE_FL) {
+		if (ext4_test_inode_flag(inode, EXT4_INODE_HUGE_FILE)) {
 			/* i_blocks represent file system block size */
 			return i_blocks  << (inode->i_blkbits - 9);
 		} else {
@@ -5099,7 +5112,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			   ei->i_file_acl, inode->i_ino);
 		ret = -EIO;
 		goto bad_inode;
-	} else if (ei->i_flags & EXT4_EXTENTS_FL) {
+	} else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 		    (S_ISLNK(inode->i_mode) &&
 		     !ext4_inode_is_fast_symlink(inode)))
@@ -5171,7 +5184,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = 0;
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
@@ -5184,9 +5197,9 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
-		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 	} else {
-		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		/* i_block is stored in file system block size */
 		i_blocks = i_blocks >> (inode->i_blkbits - 9);
 		raw_inode->i_blocks_lo   = cpu_to_le32(i_blocks);
@@ -5453,7 +5466,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
@@ -5464,9 +5477,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE &&
-	    (attr->ia_size < inode->i_size ||
-	     (EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL))) {
+		attr->ia_valid & ATTR_SIZE &&
+		(attr->ia_size < inode->i_size ||
+			ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, 3);
@@ -5498,7 +5511,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			}
 		}
 		/* ext4_truncate will clear the flag */
-		if ((EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL))
+		if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
 			ext4_truncate(inode);
 	}
 
@@ -5574,7 +5587,7 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
 	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
@@ -5909,9 +5922,9 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 */
 
 	if (val)
-		EXT4_I(inode)->i_flags |= EXT4_JOURNAL_DATA_FL;
+		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	else
-		EXT4_I(inode)->i_flags &= ~EXT4_JOURNAL_DATA_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 506713a..c24a1a3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1963,7 +1963,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	sbi = EXT4_SB(sb);
 	ngroups = ext4_get_groups_count(sb);
 	/* non-extent files are limited to low blocks/groups */
-	if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
 		ngroups = sbi->s_blockfile_groups;
 
 	BUG_ON(ac->ac_status == AC_STATUS_FOUND);
@@ -3121,7 +3121,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 			continue;
 
 		/* non-extent files can't have physical blocks past 2^32 */
-		if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL) &&
+		if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS) &&
 			pa->pa_pstart + pa->pa_len > EXT4_MAX_BLOCK_FILE_PHYS)
 			continue;
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 8b87bd0..7b8b52d 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -375,7 +375,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
 	 */
-	ei->i_flags |= EXT4_EXTENTS_FL;
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));
 
 	/*
@@ -474,7 +474,7 @@ int ext4_ext_migrate(struct inode *inode)
 	 */
 	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
 				       EXT4_FEATURE_INCOMPAT_EXTENTS) ||
-	    (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+		ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return -EINVAL;
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b399358..b1c5b76 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -976,11 +976,11 @@ mext_check_arguments(struct inode *orig_inode,
 	}
 
 	/* Ext4 move extent supports only extent based file */
-	if (!(EXT4_I(orig_inode)->i_flags & EXT4_EXTENTS_FL)) {
+	if (!ext4_test_inode_flag(orig_inode, EXT4_INODE_EXTENTS)) {
 		ext4_debug("ext4 move extent: orig file is not extents "
 			"based file [ino:orig %lu]\n", orig_inode->i_ino);
 		return -EOPNOTSUPP;
-	} else if (!(EXT4_I(donor_inode)->i_flags & EXT4_EXTENTS_FL)) {
+	} else if (!ext4_test_inode_flag(donor_inode, EXT4_INODE_EXTENTS)) {
 		ext4_debug("ext4 move extent: donor file is not extents "
 			"based file [ino:donor %lu]\n", donor_inode->i_ino);
 		return -EOPNOTSUPP;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0c070fa..e3066d3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -656,7 +656,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	dxtrace(printk(KERN_DEBUG "In htree_fill_tree, start hash: %x:%x\n", 
 		       start_hash, start_minor_hash));
 	dir = dir_file->f_path.dentry->d_inode;
-	if (!(EXT4_I(dir)->i_flags & EXT4_INDEX_FL)) {
+	if (!ext4_test_inode_flag(dir, EXT4_INODE_INDEX)) {
 		hinfo.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
 		if (hinfo.hash_version <= DX_HASH_TEA)
 			hinfo.hash_version +=
@@ -801,7 +801,7 @@ static void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
 				     EXT4_FEATURE_COMPAT_DIR_INDEX))
-		EXT4_I(inode)->i_flags &= ~EXT4_INDEX_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 }
 
 /*
@@ -1418,7 +1418,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		brelse(bh);
 		return retval;
 	}
-	EXT4_I(dir)->i_flags |= EXT4_INDEX_FL;
+	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
 	data1 = bh2->b_data;
 
 	memcpy (data1, de, len);
@@ -1491,7 +1491,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		retval = ext4_dx_add_entry(handle, dentry, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			return retval;
-		EXT4_I(dir)->i_flags &= ~EXT4_INDEX_FL;
+		ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
 		dx_fallback++;
 		ext4_mark_inode_dirty(handle, dir);
 	}
@@ -2297,7 +2297,7 @@ retry:
 		}
 	} else {
 		/* clear the extent format for fast symlink */
-		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
+		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char *)&EXT4_I(inode)->i_data, symname, l);
 		inode->i_size = l-1;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b4c5aa8..277e9e6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -820,7 +820,7 @@ inserted:
 						EXT4_I(inode)->i_block_group);
 
 			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
 
 			block = ext4_new_meta_blocks(handle, inode,
@@ -828,7 +828,7 @@ inserted:
 			if (error)
 				goto cleanup;
 
-			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
 
 			ea_idebug(inode, "creating block %d", block);
-- 
1.6.6.1

