From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 3/10] Get block group information
Date: Thu, 21 Jun 2007 10:53:06 +0900
Message-ID: <20070621105306t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Get s_blocks_per_group and s_inodes_per_group of target filesystem.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test1/fs/ext4/balloc.c Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/balloc.c
--- linux-2.6.19-rc6-test1/fs/ext4/balloc.c	2007-06-20 15:15:46.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/balloc.c	2007-06-20 14:57:04.000000000 +0900
@@ -216,7 +216,7 @@ restart:
  * If the goal block is within the reservation window, return 1;
  * otherwise, return 0;
  */
-static int
+int
 goal_in_my_reservation(struct ext4_reserve_window *rsv, ext4_grpblk_t grp_goal,
 			unsigned int group, struct super_block * sb)
 {
@@ -336,7 +336,7 @@ static void rsv_window_remove(struct sup
  *
  * returns 1 if the end block is EXT4_RESERVE_WINDOW_NOT_ALLOCATED.
  */
-static inline int rsv_is_empty(struct ext4_reserve_window *rsv)
+inline int rsv_is_empty(struct ext4_reserve_window *rsv)
 {
 	/* a valid reservation end block could not be 0 */
 	return rsv->_rsv_end == EXT4_RESERVE_WINDOW_NOT_ALLOCATED;
@@ -660,7 +660,7 @@ static int ext4_test_allocatable(ext4_gr
  * bitmap on disk and the last-committed copy in journal, until we find a
  * bit free in both bitmaps.
  */
-static ext4_grpblk_t
+ext4_grpblk_t
 bitmap_search_next_usable_block(ext4_grpblk_t start, struct buffer_head *bh,
 					ext4_grpblk_t maxblocks)
 {
@@ -1029,7 +1029,7 @@ static int find_next_reservable_window(
  *	@bitmap_bh: the block group block bitmap
  *
  */
-static int alloc_new_reservation(struct ext4_reserve_window_node *my_rsv,
+int alloc_new_reservation(struct ext4_reserve_window_node *my_rsv,
 		ext4_grpblk_t grp_goal, struct super_block *sb,
 		unsigned int group, struct buffer_head *bitmap_bh)
 {
@@ -1173,7 +1173,7 @@ retry:
  * expand the reservation window size if necessary on a best-effort
  * basis before ext4_new_blocks() tries to allocate blocks,
  */
-static void try_to_extend_reservation(struct ext4_reserve_window_node *my_rsv,
+void try_to_extend_reservation(struct ext4_reserve_window_node *my_rsv,
 			struct super_block *sb, int size)
 {
 	struct ext4_reserve_window_node *next_rsv;
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test1/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/extents.c
--- linux-2.6.19-rc6-test1/fs/ext4/extents.c	2007-06-20 15:42:15.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/extents.c	2007-06-20 15:50:14.000000000 +0900
@@ -43,7 +43,6 @@
 #include <linux/ext4_fs_extents.h>
 #include <asm/uaccess.h>
 
-
 /*
  * ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
@@ -206,11 +205,17 @@ static ext4_fsblk_t ext4_ext_find_goal(s
 static ext4_fsblk_t
 ext4_ext_new_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
-			struct ext4_extent *ex, int *err)
+			struct ext4_extent *ex, int *err,
+			ext4_fsblk_t defrag_goal)
 {
 	ext4_fsblk_t goal, newblock;
 
-	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
+	if (defrag_goal) {
+		goal = defrag_goal;
+	} else {
+		goal= ext4_ext_find_goal(inode, path, 
+				le32_to_cpu(ex->ee_block));
+	}
 	newblock = ext4_new_block(handle, inode, goal, err);
 	return newblock;
 }
@@ -598,7 +603,8 @@ static int ext4_ext_insert_index(handle_
  */
 static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int at)
+				struct ext4_extent *newext, int at,
+				ext4_fsblk_t defrag_goal)
 {
 	struct buffer_head *bh = NULL;
 	int depth = ext_depth(inode);
@@ -649,7 +655,8 @@ static int ext4_ext_split(handle_t *hand
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
-		newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+		newblock = ext4_ext_new_block(handle, inode, path, newext, &err,
+						defrag_goal);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -836,7 +843,8 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					ext4_fsblk_t defrag_goal)
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
@@ -845,7 +853,8 @@ static int ext4_ext_grow_indepth(handle_
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_block(handle, inode, path, newext, &err,
+				defrag_goal);
 	if (newblock == 0)
 		return err;
 
@@ -913,7 +922,8 @@ out:
  */
 static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					ext4_fsblk_t defrag_goal)
 {
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
@@ -933,7 +943,8 @@ repeat:
 	if (EXT_HAS_FREE_INDEX(curp)) {
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
-		err = ext4_ext_split(handle, inode, path, newext, i);
+		err = ext4_ext_split(handle, inode, path, newext, i,
+				defrag_goal);
 
 		/* refill path */
 		ext4_ext_drop_refs(path);
@@ -944,7 +955,8 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, path, newext);
+		err = ext4_ext_grow_indepth(handle, inode,
+			 path, newext, defrag_goal);
 		if (err)
 			goto out;
 
@@ -2517,6 +2529,22 @@ int ext4_ext_ioctl(struct inode *inode, 
 		unlock_kernel();
 
 		return put_user(block, p);
+	} else if (cmd == EXT4_IOC_GROUP_INFO) {
+		struct ext4_group_data_info grp_data;
+
+		if (copy_from_user(&grp_data,
+			(struct ext4_group_data_info __user *)arg,
+			sizeof(grp_data)))
+			return -EFAULT;
+
+		grp_data.s_blocks_per_group =
+			EXT4_BLOCKS_PER_GROUP(inode->i_sb);
+		grp_data.s_inodes_per_group =
+			EXT4_INODES_PER_GROUP(inode->i_sb);
+
+		if (copy_to_user((struct ext4_group_data_info *)arg,
+			&grp_data, sizeof(grp_data)))
+			return -EFAULT;
 	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;
 
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test1/fs/ext4/mballoc.c Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/mballoc.c
--- linux-2.6.19-rc6-test1/fs/ext4/mballoc.c	2007-06-20 15:42:08.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/mballoc.c	2007-06-20 15:14:36.000000000 +0900
@@ -3721,6 +3721,13 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 
 	ext4_mb_poll_new_transaction(sb, handle);
 
+	if ((err = ext4_mb_initialize_context(&ac, ar))) {
+		if (reserved)
+			ext4_release_blocks(sb, reserved);
+		*errp = err;
+		return err;
+	}
+
 	if (!(ac.ac_flags & EXT4_MB_HINT_RESERVED) &&
 		!(EXT4_I(ar->inode)->i_state & EXT4_STATE_BLOCKS_RESERVED)) {
 		reserved = ar->len;
@@ -3729,12 +3736,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 			return err;
 	}
 
-	if ((err = ext4_mb_initialize_context(&ac, ar))) {
-		if (reserved)
-			ext4_release_blocks(sb, reserved);
-		return err;
-	}
-
 	if (!ext4_mb_use_preallocated(&ac)) {
 		ext4_mb_normalize_request(&ac, ar);
 
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr linux-2.6.19-rc6-test1/include/linux/ext4_fs.h Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/include/linux/ext4_fs.h
--- linux-2.6.19-rc6-test1/include/linux/ext4_fs.h	2007-06-20 15:42:08.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/include/linux/ext4_fs.h	2007-06-20 15:16:11.000000000 +0900
@@ -285,6 +285,12 @@ struct ext4_get_buddy_request {
 #define EXT4_IOC_GET_TREE_STATS		_IOR('f', 9, long)
 #define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
 #define EXT4_IOC_DEFRAG			_IOW('f', 10, struct ext4_ext_defrag_data)
+#define EXT4_IOC_GROUP_INFO		_IOW('f', 11, struct ext4_group_data_info)
+#define EXT4_IOC_FREE_BLOCKS_INFO	_IOW('f', 12, struct ext4_extents_info)
+#define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
+#define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
+#define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
+#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 16)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -303,6 +309,10 @@ struct ext4_get_buddy_request {
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 
 /* Used for defrag */
+#define DEFRAG_MAX_ENT 32 
+#define DEFRAG_RESERVE_BLOCKS_FIRST 1
+#define DEFRAG_RESERVE_BLOCKS_SECOND 2
+#define DEFRAG_FIXED_BLOCKS_MODE 3
 
 struct ext4_extent_data {
 	unsigned long long block;	/* start logical block number */
@@ -318,6 +328,20 @@ struct ext4_ext_defrag_data {
 	struct ext4_extent_data ext;
 };
 
+struct ext4_group_data_info {
+	int s_blocks_per_group;		 /* blocks per group */
+	int s_inodes_per_group;		 /* inodes per group */
+};
+
+struct ext4_extents_info {
+	unsigned long long ino;		/* inode number */
+	int max_entries;		/* maximum extents count */
+	int entries;			/* extent number/count */
+	unsigned long offset;		/* search offset */
+	ext4_fsblk_t goal;		/* block offset for allocation */
+	struct ext4_extent_data ext[DEFRAG_MAX_ENT];
+};
+
 #define EXT4_TRANS_META_BLOCKS	4 /* bitmap + group desc + sb + inode */
 
 /*
@@ -912,6 +936,14 @@ extern struct ext4_group_desc * ext4_get
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext4_init_block_alloc_info(struct inode *);
 extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
+extern struct buffer_head * read_block_bitmap(struct super_block *, unsigned int);
+extern void try_to_extend_reservation(struct ext4_reserve_window_node *,
+			struct super_block *, int);
+extern int alloc_new_reservation(struct ext4_reserve_window_node *,
+		ext4_grpblk_t, struct super_block *,
+		unsigned int, struct buffer_head *);
+extern ext4_grpblk_t bitmap_search_next_usable_block(ext4_grpblk_t,
+		struct buffer_head *, ext4_grpblk_t);
 
 /* reservation.c */
 int ext4_reserve_init(struct super_block *sb);
