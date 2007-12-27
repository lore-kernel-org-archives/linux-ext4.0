From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 1/5] ext4 online defrag header file changes
Date: Thu, 27 Dec 2007 20:11:35 +0900
Message-ID: <200712271111.AA00286@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61851 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXL0LNj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2007 06:13:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Header file changes used by online defrag.

*This patch is applied on the top of
 ext4 git tree(linux-2.6.24-rc5).
http://repo.or.cz/r/ext4-patch-queue.git

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

---
diff -X linux-2.6.24-rc5-defrag/Documentation/dontdiff -upNr linux-2.6.24-rc5-header/fs/ext4/Makefile linux-2.6.24-rc5-alloc-block/fs/ext4/Makefile
--- linux-2.6.24-rc5-header/fs/ext4/Makefile	2007-12-25 21:06:01.000000000 +0900
+++ linux-2.6.24-rc5-alloc-block/fs/ext4/Makefile	2007-12-25 20:54:48.000000000 +0900
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o migrate.o mballoc.o
+		   ext4_jbd2.o migrate.o mballoc.o defrag.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff -X linux-2.6.24-rc5-defrag/Documentation/dontdiff -upNr linux-2.6.24-rc5-header/include/linux/ext4_fs.h linux-2.6.24-rc5-alloc-
block/include/linux/ext4_fs.h
--- linux-2.6.24-rc5-header/include/linux/ext4_fs.h	2007-12-25 21:08:46.000000000 +0900
+++ linux-2.6.24-rc5-alloc-block/include/linux/ext4_fs.h	2007-12-25 20:55:04.000000000 +0900
@@ -76,6 +76,7 @@ struct ext4_allocation_request {
 	ext4_fsblk_t pright;	/* phys. block for ^^^ */
 	unsigned long len;	/* how many blocks we want to allocate */
 	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
+	long long excepted_group;
 };
 
 /*
@@ -271,6 +272,17 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_MIGRATE		_IO('f', 7)
+#define EXT4_IOC_GET_EXTENTS		_IOR('f', 7, long)
+#define EXT4_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
+#define EXT4_IOC_GET_TREE_STATS		_IOR('f', 9, long)
+#define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
+#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)
+#define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
+#define EXT4_IOC_FREE_BLOCKS_INFO	_IOW('f', 12, struct ext4_extents_info)
+#define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
+#define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
+#define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
+#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 16)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -288,6 +300,41 @@ struct ext4_new_group_data {
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 
+/* Used for defrag */
+#define DEFRAG_MAX_ENT         32
+#define DEFRAG_FORCE_TRY       1
+#define DEFRAG_FORCE_VICTIM    2
+#define DEFRAG_FORCE_GATHER    3
+
+struct ext4_extent_data {
+	unsigned long long block;       /* start logical block number */
+	ext4_fsblk_t start;             /* start physical block number */
+	int len;                        /* blocks count */
+};
+
+struct ext4_ext_defrag_data {
+	ext4_fsblk_t start_offset;      /* start offset to defrag in blocks */
+	ext4_fsblk_t defrag_size;       /* size of defrag in blocks */
+	ext4_fsblk_t goal;              /* block offset for allocation */
+	int flag;                       /* free space mode flag */
+	struct ext4_extent_data ext;
+};
+
+struct ext4_group_data_info {
+	int s_blocks_per_group;          /* blocks per group */
+	int s_inodes_per_group;          /* inodes per group */
+};
+
+struct ext4_extents_info {
+	unsigned long long ino;         /* inode number */
+	int max_entries;                /* maximum extents count */
+	int entries;                    /* extent number/count */
+	unsigned long offset;           /* search offset */
+	ext4_fsblk_t goal;              /* block offset for allocation */
+	struct ext4_extent_data ext[DEFRAG_MAX_ENT];
+};
+
+#define EXT4_TRANS_META_BLOCKS 4 /* bitmap + group desc + sb + inode */
 
 /*
  *  Mount options
@@ -953,6 +1000,17 @@ extern struct ext4_group_desc * ext4_get
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext4_init_block_alloc_info(struct inode *);
 extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
+extern void try_to_extend_reservation(struct ext4_reserve_window_node *,
+					struct super_block *, int);
+extern int alloc_new_reservation(struct ext4_reserve_window_node *,
+				ext4_grpblk_t, struct super_block *,
+				ext4_group_t, struct buffer_head *);
+extern ext4_grpblk_t bitmap_search_next_usable_block(ext4_grpblk_t,
+				struct buffer_head *, ext4_grpblk_t);
+extern int rsv_is_empty(struct ext4_reserve_window *rsv);
+extern int goal_in_my_reservation(struct ext4_reserve_window *rsv,
+				ext4_grpblk_t grp_goal, ext4_group_t group,
+				struct super_block * sb);
 
 /* dir.c */
 extern int ext4_check_dir_entry(const char *, struct inode *,
@@ -962,6 +1020,7 @@ extern int ext4_htree_store_dirent(struc
 				    __u32 minor_hash,
 				    struct ext4_dir_entry_2 *dirent);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
+extern sector_t ext4_bmap(struct address_space *mapping, sector_t block);
 
 /* fsync.c */
 extern int ext4_sync_file (struct file *, struct dentry *, int);
@@ -1020,6 +1079,8 @@ extern void ext4_set_aops(struct inode *
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from);
+extern int ext4_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create);
 
 /* ioctl.c */
 extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
@@ -1069,6 +1130,14 @@ extern void ext4_inode_bitmap_set(struct
 				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
 extern void ext4_inode_table_set(struct super_block *sb,
 				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
+/* extents.c */
+extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
+/* defrag.c */
+extern int ext4_ext_defrag(struct file *filp, ext4_fsblk_t block_start,
+				ext4_fsblk_t defrag_size, ext4_fsblk_t goal,
+				int flag, struct ext4_extent_data *ext);
+extern int ext4_ext_ioctl(struct inode *, struct file *, unsigned int,
+				unsigned long);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
@@ -1158,6 +1227,8 @@ extern void ext4_ext_init(struct super_b
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
+extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start);
+
 static inline int
 ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
diff -X linux-2.6.24-rc5-defrag/Documentation/dontdiff -upNr linux-2.6.24-rc5-header/include/linux/ext4_fs_extents.h linux-2.6.24-rc5-alloc-
block/include/linux/ext4_fs_extents.h
--- linux-2.6.24-rc5-header/include/linux/ext4_fs_extents.h	2007-12-25 21:09:41.000000000 +0900
+++ linux-2.6.24-rc5-alloc-block/include/linux/ext4_fs_extents.h	2007-12-25 20:55:04.000000000 +0900
@@ -124,6 +124,19 @@ struct ext4_ext_path {
 #define EXT4_EXT_CACHE_GAP	1
 #define EXT4_EXT_CACHE_EXTENT	2
 
+/*
+ * to be called by ext4_ext_walk_space()
+ * negative retcode - error
+ * positive retcode - signal for ext4_ext_walk_space(), see below
+ * callback must return valid extent (passed or newly created)
+ */
+typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
+					struct ext4_ext_cache *,
+					void *);
+
+#define EXT_CONTINUE	0
+#define EXT_BREAK	1
+#define EXT_REPEAT	2
 
 #define EXT_MAX_BLOCK	0xffffffff
 
@@ -225,5 +238,14 @@ extern int ext4_ext_search_left(struct i
 						ext4_lblk_t *, ext4_fsblk_t *);
 extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
 						ext4_lblk_t *, ext4_fsblk_t *);
+extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
+extern void ext4_ext_drop_refs(struct ext4_ext_path *path);
+extern ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
+					struct ext4_ext_path *path,
+					ext4_lblk_t block);
+extern int ext4_ext_insert_extent_defrag(handle_t *handle, struct inode *inode,
+					struct ext4_ext_path *path,
+					struct ext4_extent *newext, int defrag);
+extern ext4_lblk_t ext4_ext_next_allocated_block(struct ext4_ext_path *path);
 #endif /* _LINUX_EXT4_EXTENTS */
