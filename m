From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/2] ext4: clean up feature flag checking and usage
Date: Sat,  3 Oct 2015 03:37:08 -0600
Message-ID: <1443865028-5943-2-git-send-email-adilger@dilger.ca>
References: <1443865028-5943-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:46905 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbJCJpV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2015 05:45:21 -0400
In-Reply-To: <1443865028-5943-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clean up the EXT4_{HAS,SET,CLEAR}_{,RO_,IN}COMPAT_FEATURE() flag
checking to be easier to read, as well as safer from accidental
coding mistakes.  Instead of passing the EXT4_FEATURE_*COMPAT_foo
flag name to the macro, generate the EXT4_FEATURE_*COMPAT prefix
within the macro, to ensure the flag name matches the check being
done, since the numerical value might be for the wrong compat type.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/balloc.c    |   17 ++---
 fs/ext4/dir.c       |    7 +-
 fs/ext4/ext4.h      |   70 ++++++++++---------
 fs/ext4/ext4_jbd2.h |   26 +++----
 fs/ext4/extents.c   |    4 +-
 fs/ext4/ialloc.c    |    4 +-
 fs/ext4/indirect.c  |    3 +-
 fs/ext4/inline.c    |    3 +-
 fs/ext4/inode.c     |   18 ++---
 fs/ext4/ioctl.c     |   15 ++---
 fs/ext4/migrate.c   |   13 ++--
 fs/ext4/mmp.c       |    7 +-
 fs/ext4/namei.c     |    8 +--
 fs/ext4/resize.c    |   29 +++-----
 fs/ext4/super.c     |  191 ++++++++++++++++++++++++---------------------------
 fs/ext4/xattr.c     |    4 +-
 16 files changed, 194 insertions(+), 225 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index cd6ea29..bc44979 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -213,7 +213,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 
 	start = ext4_group_first_block_no(sb, block_group);
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG))
 		flex_bg = 1;
 
 	/* Set bits for block and inode bitmaps, and inode table */
@@ -322,7 +322,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
 	ext4_fsblk_t blk;
 	ext4_fsblk_t group_first_block;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG)) {
 		/* with FLEX_BG, the inode/block bitmaps and itable
 		 * blocks may not be in the group at all
 		 * so the bitmap validation will be skipped for those groups
@@ -740,14 +740,13 @@ int ext4_bg_has_super(struct super_block *sb, ext4_group_t group)
 
 	if (group == 0)
 		return 1;
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_SPARSE_SUPER2)) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, SPARSE_SUPER2)) {
 		if (group == le32_to_cpu(es->s_backup_bgs[0]) ||
 		    group == le32_to_cpu(es->s_backup_bgs[1]))
 			return 1;
 		return 0;
 	}
-	if ((group <= 1) || !EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER))
+	if ((group <= 1) || !EXT4_HAS_RO_COMPAT_FEATURE(sb, SPARSE_SUPER))
 		return 1;
 	if (!(group & 1))
 		return 0;
@@ -776,7 +775,7 @@ static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 	if (!ext4_bg_has_super(sb, group))
 		return 0;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG))
 		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	else
 		return EXT4_SB(sb)->s_gdb_count;
@@ -797,8 +796,8 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
-			metagroup < first_meta_bg)
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG) ||
+	    metagroup < first_meta_bg)
 		return ext4_bg_num_gdb_nometa(sb, group);
 
 	return ext4_bg_num_gdb_meta(sb,group);
@@ -818,7 +817,7 @@ static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
 	/* Check for superblock and gdt backups in this group */
 	num = ext4_bg_has_super(sb, block_group);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG) ||
 	    block_group < le32_to_cpu(sbi->s_es->s_first_meta_bg) *
 			  sbi->s_desc_per_block) {
 		if (num) {
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f9e1491..bf38cea 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -40,10 +40,9 @@ static int is_dx_dir(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
-		     EXT4_FEATURE_COMPAT_DIR_INDEX) &&
-	    ((ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) ||
-	     ((inode->i_size >> sb->s_blocksize_bits) == 1) ||
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, DIR_INDEX) &&
+	    (ext4_test_inode_flag(inode, EXT4_INODE_INDEX) ||
+	     (inode->i_size >> sb->s_blocksize_bits) == 1 ||
 	     ext4_has_inline_data(inode)))
 		return 1;
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fd1f28b..721c7c2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1522,24 +1522,33 @@ static inline int ext4_encrypted_inode(struct inode *inode)
  * Feature set definitions
  */
 
-#define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
-	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
-	((EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
-	((EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask)) != 0)
-#define EXT4_SET_COMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_compat |= cpu_to_le32(mask)
-#define EXT4_SET_RO_COMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_ro_compat |= cpu_to_le32(mask)
-#define EXT4_SET_INCOMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_incompat |= cpu_to_le32(mask)
-#define EXT4_CLEAR_COMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_ro_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_INCOMPAT_FEATURE(sb,mask)			\
-	EXT4_SB(sb)->s_es->s_feature_incompat &= ~cpu_to_le32(mask)
+#define EXT4_HAS_COMPAT_FEATURE(sb, name)			\
+	((EXT4_SB(sb)->s_es->s_feature_compat &			\
+	  cpu_to_le32(EXT4_FEATURE_COMPAT_ ## name)) != 0)
+#define EXT4_HAS_RO_COMPAT_FEATURE(sb, name)			\
+	((EXT4_SB(sb)->s_es->s_feature_ro_compat &		\
+	  cpu_to_le32(EXT4_FEATURE_RO_COMPAT_ ## name)) != 0)
+#define EXT4_HAS_INCOMPAT_FEATURE(sb, name)			\
+	((EXT4_SB(sb)->s_es->s_feature_incompat &		\
+	  cpu_to_le32(EXT4_FEATURE_INCOMPAT_ ## name)) != 0)
+#define EXT4_SET_COMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_compat |=			\
+		cpu_to_le32(EXT4_FEATURE_COMPAT_ ## name)
+#define EXT4_SET_RO_COMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_ro_compat |=		\
+		cpu_to_le32(EXT4_FEATURE_RO_COMPAT_ ## name)
+#define EXT4_SET_INCOMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_incompat |=		\
+		cpu_to_le32(EXT4_FEATURE_INCOMPAT_ ## name)
+#define EXT4_CLEAR_COMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_compat &=			\
+		~cpu_to_le32(EXT4_FEATURE_COMPAT_ ## name)
+#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_ro_compat &=		\
+		~cpu_to_le32(EXT4_FEATURE_RO_COMPAT_ ## name)
+#define EXT4_CLEAR_INCOMPAT_FEATURE(sb, name)			\
+	EXT4_SB(sb)->s_es->s_feature_incompat &=		\
+		~cpu_to_le32(EXT4_FEATURE_INCOMPAT_ ## name)
 
 #define EXT4_FEATURE_COMPAT_DIR_PREALLOC	0x0001
 #define EXT4_FEATURE_COMPAT_IMAGIC_INODES	0x0002
@@ -1583,14 +1592,14 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
 
-#define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
+#define EXT2_FEATURE_COMPAT_SUPP	(EXT4_FEATURE_COMPAT_EXT_ATTR)
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
 
-#define EXT3_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
+#define EXT3_FEATURE_COMPAT_SUPP	(EXT4_FEATURE_COMPAT_EXT_ATTR)
 #define EXT3_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG)
@@ -1598,7 +1607,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
 
-#define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
+#define EXT4_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_EXT_ATTR)
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
@@ -1769,8 +1778,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
  * (c) Daniel Phillips, 2001
  */
 
-#define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
-				      EXT4_FEATURE_COMPAT_DIR_INDEX) && \
+#define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, DIR_INDEX) && \
 		    ext4_test_inode_flag((dir), EXT4_INODE_INDEX))
 #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
 #define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
@@ -2072,7 +2080,7 @@ int ext4_init_crypto(void);
 void ext4_exit_crypto(void);
 static inline int ext4_sb_has_crypto(struct super_block *sb)
 {
-	return EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
+	return EXT4_HAS_INCOMPAT_FEATURE(sb, ENCRYPT);
 }
 #else
 static inline int ext4_init_crypto(void) { return 0; }
@@ -2193,8 +2201,7 @@ int ext4_insert_dentry(struct inode *dir,
 		       struct ext4_filename *fname);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
-	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
-				     EXT4_FEATURE_COMPAT_DIR_INDEX))
+	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb, DIR_INDEX))
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 }
 static unsigned char ext4_filetype_table[] = {
@@ -2203,8 +2210,7 @@ static unsigned char ext4_filetype_table[] = {
 
 static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
-	    (filetype >= EXT4_FT_MAX))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, FILETYPE) || filetype >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
 	return ext4_filetype_table[filetype];
@@ -2534,15 +2540,13 @@ extern int ext4_register_li_request(struct super_block *sb,
 
 static inline int ext4_has_group_desc_csum(struct super_block *sb)
 {
-	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb, GDT_CSUM) ||
 	       (EXT4_SB(sb)->s_chksum_driver != NULL);
 }
 
 static inline int ext4_has_metadata_csum(struct super_block *sb)
 {
-	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb, METADATA_CSUM) &&
 		     !EXT4_SB(sb)->s_chksum_driver);
 
 	return (EXT4_SB(sb)->s_chksum_driver != NULL);
@@ -2889,7 +2893,7 @@ static unsigned char ext4_type_by_mode[S_IFMT >> S_SHIFT] = {
 static inline void ext4_set_de_type(struct super_block *sb,
 				struct ext4_dir_entry_2 *de,
 				umode_t mode) {
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FILETYPE))
 		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
 }
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 9c5b49f..e00a04f 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -34,8 +34,7 @@
  */
 
 #define EXT4_SINGLEDATA_TRANS_BLOCKS(sb)				\
-	(EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)   \
-	 ? 20U : 8U)
+	(EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS) ? 20U : 8U)
 
 /* Extended attribute operations touch at most two data buffers,
  * two bitmap buffers, and two group summaries, in addition to the inode
@@ -83,20 +82,19 @@
 #ifdef CONFIG_QUOTA
 /* Amount of blocks needed for quota update - we know that the structure was
  * allocated so we need to update only data block */
-#define EXT4_QUOTA_TRANS_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
-		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
-		1 : 0)
+#define EXT4_QUOTA_TRANS_BLOCKS(sb)					     \
+	((test_opt(sb, QUOTA) || EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) ? 1 : 0)
 /* Amount of blocks needed for quota insert/delete - we do some block writes
  * but inode, sb and group updates are done only once */
-#define EXT4_QUOTA_INIT_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
-		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
-		(DQUOT_INIT_ALLOC*(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
-		 +3+DQUOT_INIT_REWRITE) : 0)
-
-#define EXT4_QUOTA_DEL_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
-		EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
-		(DQUOT_DEL_ALLOC*(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
-		 +3+DQUOT_DEL_REWRITE) : 0)
+#define EXT4_QUOTA_INIT_BLOCKS(sb)					     \
+	((test_opt(sb, QUOTA) || EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) ?    \
+		(DQUOT_INIT_ALLOC * (EXT4_SINGLEDATA_TRANS_BLOCKS(sb) - 3) + \
+		 3 + DQUOT_INIT_REWRITE) : 0)
+
+#define EXT4_QUOTA_DEL_BLOCKS(sb)					     \
+	((test_opt(sb, QUOTA) || EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) ?    \
+		(DQUOT_DEL_ALLOC * (EXT4_SINGLEDATA_TRANS_BLOCKS(sb) - 3) +  \
+		 3 + DQUOT_DEL_REWRITE) : 0)
 #else
 #define EXT4_QUOTA_TRANS_BLOCKS(sb) 0
 #define EXT4_QUOTA_INIT_BLOCKS(sb) 0
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2553aa8..6995df3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3054,7 +3054,7 @@ void ext4_ext_init(struct super_block *sb)
 	 * possible initialization would be here
 	 */
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS)) {
 #if defined(AGGRESSIVE_TEST) || defined(CHECK_BINSEARCH) || defined(EXTENTS_STATS)
 		printk(KERN_INFO "EXT4-fs: file extents enabled"
 #ifdef AGGRESSIVE_TEST
@@ -3081,7 +3081,7 @@ void ext4_ext_init(struct super_block *sb)
  */
 void ext4_ext_release(struct super_block *sb)
 {
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS))
 		return;
 
 #ifdef EXTENTS_STATS
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 619bfc1..d3835e5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1045,7 +1045,7 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 	ei->i_inline_off = 0;
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, INLINE_DATA))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = inode;
 	err = dquot_alloc_inode(inode);
@@ -1060,7 +1060,7 @@ got:
 	if (err)
 		goto fail_free_drop;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
 		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
 			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 2468261..05c9c02 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -562,8 +562,7 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Okay, we need to do block allocation.
 	*/
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, BIGALLOC)) {
 		EXT4_ERROR_INODE(inode, "Can't allocate blocks for "
 				 "non-extent mapped inodes with bigalloc");
 		return -EUCLEAN;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index cd944a7..9fe1530 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -434,8 +434,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 	memset((void *)ext4_raw_inode(&is.iloc)->i_block,
 		0, EXT4_MIN_INLINE_DATA_SIZE);
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
-				      EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb, EXTENTS)) {
 		if (S_ISDIR(inode->i_mode) ||
 		    S_ISREG(inode->i_mode) || S_ISLNK(inode->i_mode)) {
 			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 612fbcf..f1f912b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2599,8 +2599,7 @@ static int ext4_nonda_switch(struct super_block *sb)
 /* We always reserve for an inode update; the superblock could be there too */
 static int ext4_da_write_credits(struct inode *inode, loff_t pos, unsigned len)
 {
-	if (likely(EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				EXT4_FEATURE_RO_COMPAT_LARGE_FILE)))
+	if (likely(EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, LARGE_FILE)))
 		return 1;
 
 	if (pos + len <= 0x7fffffffULL)
@@ -4006,8 +4005,7 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 	struct inode *inode = &(ei->vfs_inode);
 	struct super_block *sb = inode->i_sb;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, HUGE_FILE)) {
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
 					le32_to_cpu(raw_inode->i_blocks_lo);
@@ -4130,7 +4128,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
 	inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, 64BIT))
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
@@ -4294,7 +4292,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		ext4_clear_inode_flag(inode, EXT4_INODE_HUGE_FILE);
 		return 0;
 	}
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE))
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, HUGE_FILE))
 		return -EFBIG;
 
 	if (i_blocks <= 0xffffffffffffULL) {
@@ -4455,9 +4453,8 @@ static int ext4_do_update_inode(handle_t *handle,
 		need_datasync = 1;
 	}
 	if (ei->i_disksize > 0x7fffffffULL) {
-		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ||
-				EXT4_SB(sb)->s_es->s_rev_level ==
+		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, LARGE_FILE) ||
+		    EXT4_SB(sb)->s_es->s_rev_level ==
 		    cpu_to_le32(EXT4_GOOD_OLD_REV))
 			set_large_file = 1;
 	}
@@ -4505,8 +4502,7 @@ static int ext4_do_update_inode(handle_t *handle,
 		if (err)
 			goto out_brelse;
 		ext4_update_dynamic_rev(sb);
-		EXT4_SET_RO_COMPAT_FEATURE(sb,
-					   EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
+		EXT4_SET_RO_COMPAT_FEATURE(sb, LARGE_FILE);
 		ext4_handle_sync(handle);
 		err = ext4_handle_dirty_super(handle, sb);
 	}
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1346cfa..751c802 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -145,8 +145,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		inode_bl->i_version = 1;
 		i_size_write(inode_bl, 0);
 		inode_bl->i_mode = S_IFREG;
-		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
-					      EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
 			ext4_ext_tree_init(handle, inode_bl);
 		} else
@@ -383,8 +382,7 @@ setversion_out:
 			goto group_extend_out;
 		}
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online resizing not supported with bigalloc");
 			err = -EOPNOTSUPP;
@@ -432,8 +430,7 @@ group_extend_out:
 			goto mext_out;
 		}
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online defrag not supported with bigalloc");
 			err = -EOPNOTSUPP;
@@ -470,8 +467,7 @@ mext_out:
 			goto group_add_out;
 		}
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online resizing not supported with bigalloc");
 			err = -EOPNOTSUPP;
@@ -553,8 +549,7 @@ group_add_out:
 		int err = 0, err2 = 0;
 		ext4_group_t o_group = EXT4_SB(sb)->s_groups_count;
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online resizing not (yet) supported with bigalloc");
 			return -EOPNOTSUPP;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 6163ad2..fc225bb 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -448,9 +448,8 @@ int ext4_ext_migrate(struct inode *inode)
 	 * If the filesystem does not support extents, or the inode
 	 * already is extent-based, error out.
 	 */
-	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_INCOMPAT_EXTENTS) ||
-	    (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb, EXTENTS) ||
+	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return -EINVAL;
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
@@ -625,13 +624,11 @@ int ext4_ind_migrate(struct inode *inode)
 	handle_t			*handle;
 	int				ret;
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_INCOMPAT_EXTENTS) ||
-	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb, EXTENTS) ||
+	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return -EINVAL;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, BIGALLOC))
 		return -EOPNOTSUPP;
 
 	/*
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6eb1a61..8578836 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -169,21 +169,20 @@ static int kmmpd(void *data)
 		 * Don't spew too many error messages. Print one every
 		 * (s_mmp_update_interval * 60) seconds.
 		 */
-		if (retval) {
+		if (unlikely(retval)) {
 			if ((failed_writes % 60) == 0)
 				ext4_error(sb, "Error writing to MMP block");
 			failed_writes++;
 		}
 
-		if (!(le32_to_cpu(es->s_feature_incompat) &
-		    EXT4_FEATURE_INCOMPAT_MMP)) {
+		if (unlikely(!EXT4_HAS_INCOMPAT_FEATURE(sb, MMP))) {
 			ext4_warning(sb, "kmmpd being stopped since MMP feature"
 				     " has been disabled.");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
 
-		if (sb->s_flags & MS_RDONLY) {
+		if (unlikely(sb->s_flags & MS_RDONLY)) {
 			ext4_warning(sb, "kmmpd being stopped since filesystem "
 				     "has been remounted as readonly.");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9f61e76..df36af6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2118,7 +2118,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 			goto out;
 
 		if (blocks == 1 && !dx_fallback &&
-		    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+		    EXT4_HAS_COMPAT_FEATURE(sb, DIR_INDEX)) {
 			retval = make_indexed_dir(handle, &fname, dentry,
 						  inode, bh);
 			bh = NULL; /* make_indexed_dir releases bh */
@@ -2388,8 +2388,7 @@ static void ext4_inc_count(handle_t *handle, struct inode *inode)
 		/* limit is 16-bit i_links_count */
 		if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
 			set_nlink(inode, 1);
-			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb,
-					      EXT4_FEATURE_RO_COMPAT_DIR_NLINK);
+			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb, DIR_NLINK);
 		}
 	}
 }
@@ -3352,8 +3351,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	if (retval)
 		return retval;
 	ent->de->inode = cpu_to_le32(ino);
-	if (EXT4_HAS_INCOMPAT_FEATURE(ent->dir->i_sb,
-				      EXT4_FEATURE_INCOMPAT_FILETYPE))
+	if (EXT4_HAS_INCOMPAT_FEATURE(ent->dir->i_sb, FILETYPE))
 		ent->de->file_type = file_type;
 	ent->dir->i_version++;
 	ent->dir->i_ctime = ent->dir->i_mtime =
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cf0c472..5b47753 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -490,7 +490,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	       group_data[0].group != sbi->s_groups_count);
 
 	reserved_gdb = le16_to_cpu(es->s_reserved_gdt_blocks);
-	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
+	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG);
 
 	/* This transaction may be extended/restarted along the way */
 	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, EXT4_MAX_TRANS_DATA);
@@ -680,8 +680,7 @@ static unsigned ext4_list_backups(struct super_block *sb, unsigned *three,
 	int mult = 3;
 	unsigned ret;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, SPARSE_SUPER)) {
 		ret = *min;
 		*min += 1;
 		return ret;
@@ -1158,7 +1157,7 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 	int i, gdb_off, gdb_num, err = 0;
 	int meta_bg;
 
-	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
+	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG);
 	for (i = 0; i < count; i++, group++) {
 		int reserved_gdb = ext4_bg_has_super(sb, group) ?
 			le16_to_cpu(es->s_reserved_gdt_blocks) : 0;
@@ -1381,8 +1380,7 @@ static void ext4_update_super(struct super_block *sb,
 
 	ext4_debug("free blocks count %llu",
 		   percpu_counter_read(&sbi->s_freeclusters_counter));
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb,
-				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG) &&
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
@@ -1476,8 +1474,7 @@ exit_journal:
 		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 		int gdb_num_end = ((group + flex_gd->count - 1) /
 				   EXT4_DESC_PER_BLOCK(sb));
-		int meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb,
-				EXT4_FEATURE_INCOMPAT_META_BG);
+		int meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG);
 		sector_t old_gdb = 0;
 
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
@@ -1585,8 +1582,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 
 	gdb_off = input->group % EXT4_DESC_PER_BLOCK(sb);
 
-	if (gdb_off == 0 && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
+	if (gdb_off == 0 && !EXT4_HAS_RO_COMPAT_FEATURE(sb, SPARSE_SUPER)) {
 		ext4_warning(sb, "Can't resize non-sparse filesystem further");
 		return -EPERM;
 	}
@@ -1604,9 +1600,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	}
 
 	if (reserved_gdb || gdb_off == 0) {
-		if (!EXT4_HAS_COMPAT_FEATURE(sb,
-					     EXT4_FEATURE_COMPAT_RESIZE_INODE)
-		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
+		if (!EXT4_HAS_COMPAT_FEATURE(sb, RESIZE_INODE) ||
+		    !le16_to_cpu(es->s_reserved_gdt_blocks)) {
 			ext4_warning(sb,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
@@ -1825,8 +1820,8 @@ static int ext4_convert_meta_bg(struct super_block *sb, struct inode *inode)
 	if (err)
 		goto errout;
 
-	EXT4_CLEAR_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE);
-	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
+	EXT4_CLEAR_COMPAT_FEATURE(sb, RESIZE_INODE);
+	EXT4_SET_INCOMPAT_FEATURE(sb, META_BG);
 	sbi->s_es->s_first_meta_bg =
 		cpu_to_le32(num_desc_blocks(sb, sbi->s_groups_count));
 
@@ -1918,9 +1913,9 @@ retry:
 	n_desc_blocks = num_desc_blocks(sb, n_group + 1);
 	o_desc_blocks = num_desc_blocks(sb, sbi->s_groups_count);
 
-	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
+	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG);
 
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE)) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, RESIZE_INODE)) {
 		if (meta_bg) {
 			ext4_error(sb, "resize_inode and meta_bg enabled "
 				   "simultaneously");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a63c7b0..7d0c320 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -115,8 +115,7 @@ MODULE_ALIAS("ext3");
 static int ext4_verify_csum_type(struct super_block *sb,
 				 struct ext4_super_block *es)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, METADATA_CSUM))
 		return 1;
 
 	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
@@ -808,7 +807,7 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_xattr_put_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		EXT4_CLEAR_INCOMPAT_FEATURE(sb, RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1288,7 +1287,7 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 			"quota options when quota turned on");
 		return -1;
 	}
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) {
 		ext4_msg(sb, KERN_ERR, "Cannot set journaled quota options "
 			 "when QUOTA feature is enabled");
 		return -1;
@@ -1647,8 +1646,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 				 "quota options when quota turned on");
 			return -1;
 		}
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					       EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Cannot set journaled quota options "
 				 "when QUOTA feature is enabled");
@@ -1707,7 +1705,7 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 	}
 #ifdef CONFIG_QUOTA
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA) &&
 	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
 		ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
 			 "feature is enabled");
@@ -1944,7 +1942,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	es->s_mtime = cpu_to_le32(get_seconds());
 	ext4_update_dynamic_rev(sb);
 	if (sbi->s_journal)
-		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		EXT4_SET_INCOMPAT_FEATURE(sb, RECOVER);
 
 	ext4_commit_super(sb, 1);
 done:
@@ -2106,7 +2104,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 	int flexbg_flag = 0;
 	ext4_group_t i, grp = sbi->s_groups_count;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG))
 		flexbg_flag = 1;
 
 	ext4_debug("Checking group descriptors");
@@ -2413,7 +2411,7 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 
 	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, META_BG) ||
 	    nr < first_meta_bg)
 		return logical_sb_block + nr + 1;
 	bg = sbi->s_desc_per_block * nr;
@@ -2799,6 +2797,8 @@ static struct kobj_type ext4_feat_ktype = {
 	.release	= ext4_feat_release,
 };
 
+#define EXT4_FEATURE_INCOMPAT_EXT4_UNKNOWN	~EXT4_FEATURE_INCOMPAT_SUPP
+#define EXT4_FEATURE_RO_COMPAT_EXT4_UNKNOWN	~EXT4_FEATURE_RO_COMPAT_SUPP
 /*
  * Check whether this filesystem can be mounted based on
  * the features present and the RDONLY/RDWR mount requested.
@@ -2807,37 +2807,37 @@ static struct kobj_type ext4_feat_ktype = {
  */
 static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 {
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_UNKNOWN)) {
 		ext4_msg(sb, KERN_ERR,
 			"Couldn't mount because of "
 			"unsupported optional features (%x)",
 			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
-			~EXT4_FEATURE_INCOMPAT_SUPP));
+			EXT4_FEATURE_INCOMPAT_EXT4_UNKNOWN));
 		return 0;
 	}
 
 	if (readonly)
 		return 1;
 
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_READONLY)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, READONLY)) {
 		ext4_msg(sb, KERN_INFO, "filesystem is read-only");
 		sb->s_flags |= MS_RDONLY;
 		return 1;
 	}
 
 	/* Check that feature set is OK for a read-write mount */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_UNKNOWN)) {
 		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
 			 "unsupported optional features (%x)",
 			 (le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
-				~EXT4_FEATURE_RO_COMPAT_SUPP));
+			  EXT4_FEATURE_RO_COMPAT_EXT4_UNKNOWN));
 		return 0;
 	}
 	/*
 	 * Large file size enabled file system can only be mounted
 	 * read-write on 32-bit systems if kernel is built with CONFIG_LBDAF
 	 */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, HUGE_FILE)) {
 		if (sizeof(blkcnt_t) < sizeof(u64)) {
 			ext4_msg(sb, KERN_ERR, "Filesystem with huge files "
 				 "cannot be mounted RDWR without "
@@ -2845,8 +2845,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			return 0;
 		}
 	}
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
-	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC) &&
+	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS)) {
 		ext4_msg(sb, KERN_ERR,
 			 "Can't support bigalloc feature without "
 			 "extents feature\n");
@@ -2854,7 +2854,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	}
 
 #ifndef CONFIG_QUOTA
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA) &&
 	    !readonly) {
 		ext4_msg(sb, KERN_ERR,
 			 "Filesystem with quota feature cannot be mounted RDWR "
@@ -3266,23 +3266,21 @@ static int set_journal_csum_feature_set(struct super_block *sb)
 	}
 
 	jbd2_journal_clear_features(sbi->s_journal,
-			JBD2_FEATURE_COMPAT_CHECKSUM, 0,
-			JBD2_FEATURE_INCOMPAT_CSUM_V3 |
-			JBD2_FEATURE_INCOMPAT_CSUM_V2);
+				    JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				    JBD2_FEATURE_INCOMPAT_CSUM_V3 |
+				    JBD2_FEATURE_INCOMPAT_CSUM_V2);
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-		ret = jbd2_journal_set_features(sbi->s_journal,
-				compat, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT |
-				incompat);
+		ret = jbd2_journal_set_features(sbi->s_journal, compat, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT | incompat);
 	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
 		ret = jbd2_journal_set_features(sbi->s_journal,
-				compat, 0,
-				incompat);
+						compat, 0,
+						incompat);
 		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+					    JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
 	} else {
 		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+					    JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
 	}
 
 	return ret;
@@ -3312,7 +3310,7 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
 
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC))
 		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
 			sbi->s_itb_per_group + 2);
 
@@ -3414,7 +3412,7 @@ static ext4_fsblk_t ext4_calculate_resv_clusters(struct super_block *sb)
 	 * hole punching doesn't need new metadata... This is needed especially
 	 * to keep ext2/3 backward compatibility.
 	 */
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXTENTS))
 		return 0;
 	/*
 	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
@@ -3446,6 +3444,9 @@ static int ext4_reserve_clusters(struct ext4_sb_info *sbi, ext4_fsblk_t count)
 	return 0;
 }
 
+#define EXT4_FEATURE_COMPAT_ANY		(~0)
+#define EXT4_FEATURE_RO_COMPAT_ANY	(~0)
+#define EXT4_FEATURE_INCOMPAT_ANY	(~0)
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
@@ -3526,9 +3527,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
 
 	/* Warn if metadata_csum and gdt_csum are both set. */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, METADATA_CSUM) &&
+	    EXT4_HAS_RO_COMPAT_FEATURE(sb, GDT_CSUM))
 		ext4_warning(sb, "metadata_csum and uninit_bg are "
 			     "redundant flags; please run fsck.");
 
@@ -3541,8 +3541,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* Load the checksum driver */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, METADATA_CSUM)) {
 		sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
 		if (IS_ERR(sbi->s_chksum_driver)) {
 			ext4_msg(sb, KERN_ERR, "Cannot load crc32c driver.");
@@ -3664,17 +3663,16 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
-	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
-	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
-	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
+	    (EXT4_HAS_COMPAT_FEATURE(sb, ANY) ||
+	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ANY) ||
+	     EXT4_HAS_INCOMPAT_FEATURE(sb, ANY)))
 		ext4_msg(sb, KERN_WARNING,
 		       "feature flags set on rev 0 fs, "
 		       "running e2fsck is recommended");
 
 	if (es->s_creator_os == cpu_to_le32(EXT4_OS_HURD)) {
 		set_opt2(sb, HURD_COMPAT);
-		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
-					      EXT4_FEATURE_INCOMPAT_64BIT)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb, 64BIT)) {
 			ext4_msg(sb, KERN_ERR,
 				 "The Hurd can't support 64-bit file systems");
 			goto failed_mount;
@@ -3732,8 +3730,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT) &&
-	    es->s_encryption_level) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ENCRYPT) && es->s_encryption_level) {
 		ext4_msg(sb, KERN_ERR, "Unsupported encryption level %d",
 			 es->s_encryption_level);
 		goto failed_mount;
@@ -3765,8 +3762,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
-	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
+	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb, HUGE_FILE);
 	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits,
 						      has_huge_files);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
@@ -3790,7 +3786,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, 64BIT)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
 		    !is_power_of_2(sbi->s_desc_size)) {
@@ -3821,7 +3817,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, DIR_INDEX)) {
 		i = le32_to_cpu(es->s_flags);
 		if (i & EXT2_FLAGS_UNSIGNED_HASH)
 			sbi->s_hash_unsigned = 3;
@@ -3841,8 +3837,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Handle clustersize */
 	clustersize = BLOCK_SIZE << le32_to_cpu(es->s_log_cluster_size);
-	has_bigalloc = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_BIGALLOC);
+	has_bigalloc = EXT4_HAS_RO_COMPAT_FEATURE(sb, BIGALLOC);
 	if (has_bigalloc) {
 		if (clustersize < blocksize) {
 			ext4_msg(sb, KERN_ERR,
@@ -4007,7 +4002,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = ext4_xattr_handlers;
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &ext4_quota_operations;
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA))
 		sb->s_qcop = &dquot_quotactl_sysfile_ops;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
@@ -4021,11 +4016,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = NULL;
 
 	needs_recovery = (es->s_last_orphan != 0 ||
-			  EXT4_HAS_INCOMPAT_FEATURE(sb,
-				    EXT4_FEATURE_INCOMPAT_RECOVER));
+			  EXT4_HAS_INCOMPAT_FEATURE(sb, RECOVER));
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_MMP) &&
-	    !(sb->s_flags & MS_RDONLY))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, MMP) && !(sb->s_flags & MS_RDONLY))
 		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
 			goto failed_mount3a;
 
@@ -4034,11 +4027,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * root first: it may be modified in the journal!
 	 */
 	if (!test_opt(sb, NOLOAD) &&
-	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+	    EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL)) {
 		if (ext4_load_journal(sb, es, journal_devnum))
 			goto failed_mount3a;
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
-	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
+		   EXT4_HAS_INCOMPAT_FEATURE(sb, RECOVER)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "
 		       "suppressed and not mounted read-only");
 		goto failed_mount_wq;
@@ -4049,7 +4042,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto no_journal;
 	}
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT) &&
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, 64BIT) &&
 	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
 				       JBD2_FEATURE_INCOMPAT_64BIT)) {
 		ext4_msg(sb, KERN_ERR, "Failed to set 64-bit journal feature");
@@ -4102,7 +4095,7 @@ no_journal:
 	}
 
 	if ((DUMMY_ENCRYPTION_ENABLED(sbi) ||
-	     EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT)) &&
+	     EXT4_HAS_INCOMPAT_FEATURE(sb, ENCRYPT)) &&
 	    (blocksize != PAGE_CACHE_SIZE)) {
 		ext4_msg(sb, KERN_ERR,
 			 "Unsupported blocksize for fs encryption");
@@ -4111,8 +4104,8 @@ no_journal:
 
 	if (DUMMY_ENCRYPTION_ENABLED(sbi) &&
 	    !(sb->s_flags & MS_RDONLY) &&
-	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
-		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
+	    !EXT4_HAS_INCOMPAT_FEATURE(sb, ENCRYPT)) {
+		EXT4_SET_INCOMPAT_FEATURE(sb, ENCRYPT);
 		ext4_commit_super(sb, 1);
 	}
 
@@ -4171,8 +4164,7 @@ no_journal:
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
 		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
 						     EXT4_GOOD_OLD_INODE_SIZE;
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXTRA_ISIZE)) {
 			if (sbi->s_want_extra_isize <
 			    le16_to_cpu(es->s_want_extra_isize))
 				sbi->s_want_extra_isize =
@@ -4236,7 +4228,7 @@ no_journal:
 		goto failed_mount6;
 	}
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
 			       "unable to initialize "
@@ -4257,7 +4249,7 @@ no_journal:
 
 #ifdef CONFIG_QUOTA
 	/* Enable quota usage during mount. */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA) &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		err = ext4_enable_quotas(sb);
 		if (err)
@@ -4403,7 +4395,7 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 	struct inode *journal_inode;
 	journal_t *journal;
 
-	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL));
 
 	/* First, test for the existence of a valid inode on disk.  Bad
 	 * things happen if we iget() an unused inode, as the subsequent
@@ -4453,7 +4445,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	struct ext4_super_block *es;
 	struct block_device *bdev;
 
-	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL));
 
 	bdev = ext4_blkdev_get(j_dev, sb);
 	if (bdev == NULL)
@@ -4480,8 +4472,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if ((le16_to_cpu(es->s_magic) != EXT4_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT4_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		ext4_msg(sb, KERN_ERR, "external journal has "
-					"bad superblock");
+		ext4_msg(sb, KERN_ERR, "external journal has bad superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -4545,7 +4536,7 @@ static int ext4_load_journal(struct super_block *sb,
 	int err = 0;
 	int really_read_only;
 
-	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL));
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
@@ -4562,7 +4553,7 @@ static int ext4_load_journal(struct super_block *sb,
 	 * crash?  For recovery, we need to check in advance whether we
 	 * can get read-write access to the device.
 	 */
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
 			ext4_msg(sb, KERN_INFO, "INFO: recovery "
 					"required on readonly filesystem");
@@ -4593,7 +4584,7 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!(journal->j_flags & JBD2_BARRIER))
 		ext4_msg(sb, KERN_INFO, "barriers disabled");
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER))
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, RECOVER))
 		err = jbd2_journal_wipe(journal, !really_read_only);
 	if (!err) {
 		char *save = kmalloc(EXT4_S_ERR_LEN, GFP_KERNEL);
@@ -4707,7 +4698,7 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 {
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
-	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL)) {
 		BUG_ON(journal != NULL);
 		return;
 	}
@@ -4715,9 +4706,9 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 	if (jbd2_journal_flush(journal) < 0)
 		goto out;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
-	    sb->s_flags & MS_RDONLY) {
-		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, RECOVER) &&
+	    (sb->s_flags & MS_RDONLY)) {
+		EXT4_CLEAR_INCOMPAT_FEATURE(sb, RECOVER);
 		ext4_commit_super(sb, 1);
 	}
 
@@ -4737,7 +4728,7 @@ static void ext4_clear_journal_err(struct super_block *sb,
 	int j_errno;
 	const char *errstr;
 
-	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL));
 
 	journal = EXT4_SB(sb)->s_journal;
 
@@ -4852,7 +4843,7 @@ static int ext4_freeze(struct super_block *sb)
 			goto out;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
-		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		EXT4_CLEAR_INCOMPAT_FEATURE(sb, RECOVER);
 	}
 
 	error = ext4_commit_super(sb, 1);
@@ -4872,10 +4863,9 @@ static int ext4_unfreeze(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	if (EXT4_SB(sb)->s_journal) {
-		/* Reset the needs_recovery flag before the fs is unlocked. */
-		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-	}
+	/* Reset the needs_recovery flag before the fs is unlocked. */
+	if (EXT4_SB(sb)->s_journal)
+		EXT4_SET_INCOMPAT_FEATURE(sb, RECOVER);
 
 	ext4_commit_super(sb, 1);
 	return 0;
@@ -5027,8 +5017,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				ext4_mark_recovery_complete(sb, es);
 		} else {
 			/* Make sure we can mount this feature set readwrite */
-			if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_READONLY) ||
+			if (EXT4_HAS_RO_COMPAT_FEATURE(sb, READONLY) ||
 			    !ext4_feature_set_ok(sb, 0)) {
 				err = -EROFS;
 				goto restore_opts;
@@ -5076,13 +5065,12 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			sbi->s_mount_state = le16_to_cpu(es->s_state);
 			if (!ext4_setup_super(sb, es, 0))
 				sb->s_flags &= ~MS_RDONLY;
-			if (EXT4_HAS_INCOMPAT_FEATURE(sb,
-						     EXT4_FEATURE_INCOMPAT_MMP))
-				if (ext4_multi_mount_protect(sb,
+			if (EXT4_HAS_INCOMPAT_FEATURE(sb, MMP) &&
+			    ext4_multi_mount_protect(sb,
 						le64_to_cpu(es->s_mmp_block))) {
-					err = -EROFS;
-					goto restore_opts;
-				}
+				err = -EROFS;
+				goto restore_opts;
+			}
 			enable_quota = 1;
 		}
 	}
@@ -5108,10 +5096,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(old_opts.s_qf_names[i]);
 	if (enable_quota) {
-		if (sb_any_quota_suspended(sb))
+		if (sb_any_quota_suspended(sb)) {
 			dquot_resume(sb, -1);
-		else if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+		} else if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA)) {
 			err = ext4_enable_quotas(sb);
 			if (err)
 				goto restore_opts;
@@ -5255,7 +5242,7 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	/* Are we journaling quotas? */
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA) ||
 	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
 		return ext4_write_dquot(dquot);
@@ -5343,7 +5330,7 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
 	};
 
-	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
+	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, QUOTA));
 
 	if (!qf_inums[type])
 		return -EPERM;
@@ -5535,13 +5522,15 @@ static inline void unregister_as_ext2(void)
 	unregister_filesystem(&ext2_fs_type);
 }
 
+#define EXT4_FEATURE_INCOMPAT_EXT2_UNKNOWN	~EXT2_FEATURE_INCOMPAT_SUPP
+#define EXT4_FEATURE_RO_COMPAT_EXT2_UNKNOWN	~EXT2_FEATURE_RO_COMPAT_SUPP
 static inline int ext2_feature_set_ok(struct super_block *sb)
 {
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT2_UNKNOWN))
 		return 0;
 	if (sb->s_flags & MS_RDONLY)
 		return 1;
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT2_UNKNOWN))
 		return 0;
 	return 1;
 }
@@ -5564,15 +5553,17 @@ static inline void unregister_as_ext3(void)
 	unregister_filesystem(&ext3_fs_type);
 }
 
+#define EXT4_FEATURE_INCOMPAT_EXT3_UNKNOWN	~EXT3_FEATURE_INCOMPAT_SUPP
+#define EXT4_FEATURE_RO_COMPAT_EXT3_UNKNOWN	~EXT3_FEATURE_RO_COMPAT_SUPP
 static inline int ext3_feature_set_ok(struct super_block *sb)
 {
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT3_FEATURE_INCOMPAT_SUPP))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT3_UNKNOWN))
 		return 0;
-	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, HAS_JOURNAL))
 		return 0;
 	if (sb->s_flags & MS_RDONLY)
 		return 1;
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP))
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT3_UNKNOWN))
 		return 0;
 	return 1;
 }
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 16e28c0..995a832 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -525,12 +525,12 @@ errout:
 static void ext4_xattr_update_super_block(handle_t *handle,
 					  struct super_block *sb)
 {
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR))
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT_ATTR))
 		return;
 
 	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
-		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
+		EXT4_SET_COMPAT_FEATURE(sb, EXT_ATTR);
 		ext4_handle_dirty_super(handle, sb);
 	}
 }
-- 
1.7.3.4

