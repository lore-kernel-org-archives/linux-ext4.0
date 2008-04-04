From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 5/8] defragmentation for the relevant files (-r mode)
Date: Fri, 04 Apr 2008 20:20:00 +0900
Message-ID: <47F60EE0.1040202@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51717 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYDDLZ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 07:25:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag-- Defragmentation for the relevant files (-r mode)

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Relevant file fragmentation could be solved by moving
the files under the specified directory close together with
the block containing the directory data.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 fs/ext4/defrag.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/ext4.h   |    4 +++-
 fs/ext4/inode.c  |    2 +-
 fs/ext4/ioctl.c  |    1 +
 4 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index baa04d9..847f708 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -93,10 +93,23 @@ int ext4_defrag_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			unsigned long arg)
 {
 	int err = 0;
-	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL ||
+		cmd == EXT4_IOC_FIBMAP))
 			return -EINVAL;

-	if (cmd == EXT4_IOC_DEFRAG) {
+	if (cmd == EXT4_IOC_FIBMAP) {
+		ext4_fsblk_t __user *p = (ext4_fsblk_t __user *)arg;
+		ext4_fsblk_t block = 0;
+		struct address_space *mapping = filp->f_mapping;
+
+		if (copy_from_user(&block, (ext4_fsblk_t __user *)arg,
+					sizeof(block)))
+			return -EFAULT;
+
+		block = ext4_bmap(mapping, block);
+
+		return put_user(block, p);
+	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;

 		if (copy_from_user(&defrag,
@@ -104,7 +117,7 @@ int ext4_defrag_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			sizeof(defrag)))
 			return -EFAULT;
 		err = ext4_defrag(filp, defrag.start_offset,
-				defrag.defrag_size);
+				defrag.defrag_size, defrag.goal);
 	}

 	return err;
@@ -729,13 +742,14 @@ out:
  * @org_inode		original inode
  * @iblock		file related offset
  * @total_blocks	contiguous blocks count
+ * @goal		block offset for allocation
  *
  * If succeed, fuction returns count of extent we got,
  * otherwise returns err.
  */
 static int ext4_defrag_alloc_blocks(struct inode *dest_inode,
 		struct inode *org_inode, ext4_lblk_t iblock,
-		ext4_fsblk_t total_blocks)
+		ext4_fsblk_t total_blocks, ext4_fsblk_t goal)
 {
 	handle_t *handle = NULL;
 	struct ext4_ext_path *dest_path = NULL;
@@ -772,7 +786,10 @@ static int ext4_defrag_alloc_blocks(struct inode *dest_inode,
 	ar.flags = EXT4_MB_HINT_DATA | EXT4_MB_HINT_RESERVED
 		| EXT4_MB_HINT_NOPREALLOC;

-	ar.goal = ext4_ext_find_goal(dest_inode, dest_path, iblock);
+	if (goal)
+		ar.goal = goal;
+	else
+		ar.goal = ext4_ext_find_goal(dest_inode, dest_path, iblock);

 	ar.logical = iblock;
 	ar.lleft = 0;
@@ -994,6 +1011,7 @@ out:
  * @tar_start:		starting offset to allocate in blocks
  * @tar_blocks:		the number of blocks to allocate
  * @iblock:		file related offset
+ * @goal:		block offset for allocaton
  *
  * This function returns the value as below:
  *	0(succeeded)
@@ -1003,7 +1021,8 @@ out:
 static int
 ext4_defrag_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
 			struct ext4_ext_path *path, ext4_lblk_t tar_start,
-			ext4_lblk_t tar_blocks, ext4_lblk_t iblock)
+			ext4_lblk_t tar_blocks, ext4_lblk_t iblock,
+			ext4_fsblk_t goal)
 {
 	struct ext4_extent *ext = NULL;
 	struct ext4_extent_header *eh = NULL;
@@ -1017,7 +1036,7 @@ ext4_defrag_new_extent_tree(struct inode *inode, struct inode *tmp_inode,

 	/* Allocate contiguous blocks */
 	sum_tmp = ext4_defrag_alloc_blocks(tmp_inode, inode, iblock,
-					tar_blocks);
+					tar_blocks, goal);
 	if (sum_tmp < 0) {
 		ret = sum_tmp;
 		goto out;
@@ -1034,7 +1053,7 @@ ext4_defrag_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
 			       le16_to_cpu(ext->ee_len) - 1 ||
 			       last_extent) {

-			if (sum_org == sum_tmp) {
+			if ((sum_org == sum_tmp) && !goal) {
 				/* Not improved */
 				ret = ext4_ext_remove_space(tmp_inode, 0);
 				if (!ret)
@@ -1065,15 +1084,17 @@ out:
  * @filp:		pointer to file
  * @block_start:	starting offset to defrag in blocks
  * @defrag_size:	size of defrag in blocks
+ * @goal:		block offset for allocation
  *
  * This function returns the number of blocks if succeeded, otherwise
  * returns error value.
  */
 int
 ext4_defrag(struct file *filp, ext4_lblk_t block_start,
-		ext4_lblk_t defrag_size)
+		ext4_lblk_t defrag_size, ext4_fsblk_t goal)
 {
 	struct inode *inode = filp->f_dentry->d_inode, *tmp_inode = NULL;
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 	struct ext4_ext_path *path = NULL, *holecheck_path = NULL;
 	struct ext4_extent *ext_prev = NULL, *ext_cur = NULL, *ext_dummy = NULL;
 	handle_t *handle;
@@ -1098,6 +1119,14 @@ ext4_defrag(struct file *filp, ext4_lblk_t block_start,
 		return -EINVAL;
 	}

+	/* Check goal offset if goal offset was given from userspace */
+	if (((0 < goal) && (ext4_blocks_count(es) < goal)) && (goal != -1)) {
+		printk(KERN_ERR "ext4 defrag: Invalid goal offset %llu, "
+				"you can set goal offset up to %llu\n", goal,
+						ext4_blocks_count(es) - 1);
+		return -EINVAL;
+	}
+
 	if (file_end < block_end)
 		defrag_size -= block_end - file_end;

@@ -1215,13 +1244,13 @@ ext4_defrag(struct file *filp, ext4_lblk_t block_start,
 		}

 		/* Found an isolated block */
-		if (seq_extents == 1) {
+		if ((seq_extents == 1) && !goal) {
 			seq_start = le32_to_cpu(ext_cur->ee_block);
 			goto CLEANUP;
 		}

 		ret = ext4_defrag_new_extent_tree(inode, tmp_inode, path,
-			seq_start, seq_blocks, block_start);
+			seq_start, seq_blocks, block_start, goal);

 		if (ret < 0) {
 			break;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 18c1fcf..24c7144 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -298,6 +298,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_MIGRATE		_IO('f', 7)
+#define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
 #define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)

 /*
@@ -1013,6 +1014,7 @@ extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 				    __u32 minor_hash,
 				    struct ext4_dir_entry_2 *dirent);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
+extern sector_t ext4_bmap(struct address_space *mapping, sector_t block);

 /* fsync.c */
 extern int ext4_sync_file (struct file *, struct dentry *, int);
@@ -1128,7 +1130,7 @@ extern void ext4_inode_table_set(struct super_block *sb,
 extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
 /* defrag.c */
 extern int ext4_defrag(struct file *filp, ext4_lblk_t block_start,
-			ext4_lblk_t defrag_size);
+			ext4_lblk_t defrag_size, ext4_fsblk_t goal);
 extern int ext4_defrag_ioctl(struct inode *, struct file *, unsigned int,
 				unsigned long);

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 53943b6..e9db7a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1605,7 +1605,7 @@ out:
  * So, if we see any bmap calls here on a modified, data-journaled file,
  * take extra steps to flush any blocks which might be in the cache.
  */
-static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
+sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
 	journal_t *journal;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 98b6f4a..da13cee 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -231,6 +231,7 @@ flags_err:

 		return err;
 	}
+	case EXT4_IOC_FIBMAP:
 	case EXT4_IOC_DEFRAG: {
 		return ext4_defrag_ioctl(inode, filp, cmd, arg);
 	}
