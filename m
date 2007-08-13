From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] This is the equivalent of ext3-mballoc3-sles10.patch
Date: Mon, 13 Aug 2007 15:52:24 +0530
Message-ID: <11870005773291-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870005502857-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1187000553923-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:41501 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937901AbXHMKXG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:23:06 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DAPYvS4468750
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:25:34 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7DAQYIt111222
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:26:35 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DAN0O1028845
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:23:01 +1000
In-Reply-To: <1187000553923-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

---
 fs/ext4/Makefile          |    2 +-
 fs/ext4/balloc.c          |   58 ++++++++++++++++++++++++++++++++++-----------
 fs/ext4/extents.c         |   44 +++++++++++++++++++++++++++-------
 fs/ext4/inode.c           |   14 +++++-----
 fs/ext4/super.c           |   18 ++++++++++++++
 fs/ext4/xattr.c           |    4 +-
 include/linux/ext4_fs.h   |    1 +
 include/linux/ext4_fs_i.h |    4 +++
 8 files changed, 112 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index ae6e7e5..c7801ab 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o
+		   ext4_jbd2.o mballoc.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e53b4af..55f4be8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -110,7 +110,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
  *
  * Return buffer_head on success or NULL in case of failure.
  */
-static struct buffer_head *
+struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	struct ext4_group_desc * desc;
@@ -412,6 +412,8 @@ void ext4_discard_reservation(struct inode *inode)
 	struct ext4_reserve_window_node *rsv;
 	spinlock_t *rsv_lock = &EXT4_SB(inode->i_sb)->s_rsv_window_lock;
 
+	ext4_mb_discard_inode_preallocations(inode);
+
 	if (!block_i)
 		return;
 
@@ -617,21 +619,29 @@ error_return:
  * @inode:		inode
  * @block:		start physical block to free
  * @count:		number of blocks to count
+ * @metadata: 		Are these metadata blocks
  */
 void ext4_free_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t block, unsigned long count)
+			ext4_fsblk_t block, unsigned long count,
+			int metadata)
 {
 	struct super_block * sb;
-	unsigned long dquot_freed_blocks;
+	int freed;
+
+	/* this isn't the right place to decide whether block is metadata
+	 * inode.c/extents.c knows better, but for safety ... */
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode) ||
+			ext4_should_journal_data(inode))
+		metadata = 1;
 
 	sb = inode->i_sb;
-	if (!sb) {
-		printk ("ext4_free_blocks: nonexistent device");
-		return;
-	}
-	ext4_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
-	if (dquot_freed_blocks)
-		DQUOT_FREE_BLOCK(inode, dquot_freed_blocks);
+
+	if (!test_opt(sb, MBALLOC) || !EXT4_SB(sb)->s_group_info)
+		ext4_free_blocks_sb(handle, sb, block, count, &freed);
+	else
+		ext4_mb_free_blocks(handle, inode, block, count, metadata, &freed);
+	if (freed)
+		DQUOT_FREE_BLOCK(inode, freed);
 	return;
 }
 
@@ -1420,7 +1430,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  * any specific goal block.
  *
  */
-ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -1681,11 +1691,31 @@ out:
 }
 
 ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, int *errp)
+		ext4_fsblk_t goal, int *errp)
 {
-	unsigned long count = 1;
+	struct ext4_allocation_request ar;
+	ext4_fsblk_t ret;
+
+	if (!test_opt(inode->i_sb, MBALLOC)) {
+		unsigned long count = 1;
+		ret = ext4_new_blocks_old(handle, inode, goal, &count, errp);
+		return ret;
+	}
+
+	ar.inode = inode;
+	ar.goal = goal;
+	ar.len = 1;
+	ar.logical = 0;
+	ar.lleft = 0;
+	ar.pleft = 0;
+	ar.lright = 0;
+	ar.pright = 0;
+	ar.flags = 0;
+	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	return ret;
+}
+
 
-	return ext4_new_blocks(handle, inode, goal, &count, errp);
 }
 
 /**
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3084e09..8d163d7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -851,7 +851,7 @@ cleanup:
 		for (i = 0; i < depth; i++) {
 			if (!ablocks[i])
 				continue;
-			ext4_free_blocks(handle, inode, ablocks[i], 1);
+			ext4_free_blocks(handle, inode, ablocks[i], 1, 1);
 		}
 	}
 	kfree(ablocks);
@@ -1800,7 +1800,7 @@ int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 	ext_debug("index is empty, remove it, free block %llu\n", leaf);
 	bh = sb_find_get_block(inode->i_sb, leaf);
 	ext4_forget(handle, 1, inode, bh, leaf);
-	ext4_free_blocks(handle, inode, leaf, 1);
+	ext4_free_blocks(handle, inode, leaf, 1, 1);
 	return err;
 }
 
@@ -1861,8 +1861,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 {
 	struct buffer_head *bh;
 	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
-	int i;
+	int i, metadata = 0;
 
+	if (S_ISDIR(tree->inode->i_mode) || S_ISLNK(tree->inode->i_mode))
+		metadata = 1;
 #ifdef EXTENTS_STATS
 	{
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -1890,7 +1892,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			bh = sb_find_get_block(inode->i_sb, start + i);
 			ext4_forget(handle, 0, inode, bh, start + i);
 		}
-		ext4_free_blocks(handle, inode, start, num);
+		ext4_free_blocks(handle, inode, start, num, metadata);
 	} else if (from == le32_to_cpu(ex->ee_block)
 		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
 		printk("strange request: removal %lu-%lu from %u:%u\n",
@@ -2380,6 +2382,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t goal, newblock;
 	int err = 0, depth, ret;
 	unsigned long allocated = 0;
+	struct ext4_allocation_request ar;
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %d/%lu requested for inode %u\n", (int) iblock,
@@ -2491,8 +2494,16 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	if (S_ISREG(inode->i_mode) && (!EXT4_I(inode)->i_block_alloc_info))
 		ext4_init_block_alloc_info(inode);
 
-	/* allocate new block */
-	goal = ext4_ext_find_goal(inode, path, iblock);
+	/* find neighbour allocated blocks */
+	ar.lleft = iblock;
+	err = ext4_ext_search_left(&tree, path, &ar.lleft, &ar.pleft);
+	if (err)
+		goto out2;
+	ar.lright = iblock;
+	err = ext4_ext_search_right(&tree, path, &ar.lright, &ar.pright);
+	if (err)
+		goto out2;
+	/* FIXME!! allocated is updated with resepec to ar.pright */
 
 	/*
 	 * See if request is beyond maximum number of blocks we can have in
@@ -2507,6 +2518,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		 create == EXT4_CREATE_UNINITIALIZED_EXT)
 		max_blocks = EXT_UNINIT_MAX_LEN;
 
+
 	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
 	newex.ee_block = cpu_to_le32(iblock);
 	newex.ee_len = cpu_to_le16(max_blocks);
@@ -2515,7 +2527,14 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		allocated = le16_to_cpu(newex.ee_len);
 	else
 		allocated = max_blocks;
-	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
+
+	/* allocate new block */
+	ar.inode = inode;
+	ar.goal = ext4_ext_find_goal(inode, path, iblock);
+	ar.logical = iblock;
+	ar.len = allocated;
+	ar.flags = EXT4_MB_HINT_DATA;
+	newblock = ext4_mb_new_blocks(handle, &ar, &err);
 	if (!newblock)
 		goto out2;
 	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
@@ -2523,14 +2542,17 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* try to insert new extent into found leaf and return */
 	ext4_ext_store_pblock(&newex, newblock);
-	newex.ee_len = cpu_to_le16(allocated);
+	newex.ee_len = cpu_to_le16(ar.len);
 	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
 	if (err) {
 		/* free data blocks we just allocated */
+		/* not a good idea to call discard here directly,
+		 * but otherwise we'd need to call it every free() */
+		ext4_mb_discard_inode_preallocations(inode);
 		ext4_free_blocks(handle, inode, ext_pblock(&newex),
-					le16_to_cpu(newex.ee_len));
+					le16_to_cpu(newex.ee_len), 0);
 		goto out2;
 	}
 
@@ -2539,6 +2561,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
+	allocated = newex.ee_len;
 outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
@@ -2592,6 +2615,9 @@ void ext4_ext_truncate(struct inode * inode, struct page *page)
 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 	ext4_ext_invalidate_cache(inode);
 
+	/* it's important to discard preallocations under truncate_mutex */
+	ext4_mb_discard_inode_preallocations(inode);
+
 	/*
 	 * TODO: optimization is possible here.
 	 * Probably we need not scan at all,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4848e0..38b8d19 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -559,7 +559,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	return ret;
 failed_out:
 	for (i = 0; i <index; i++)
-		ext4_free_blocks(handle, inode, new_blocks[i], 1);
+		ext4_free_blocks(handle, inode, new_blocks[i], 1, 0);
 	return ret;
 }
 
@@ -658,9 +658,9 @@ failed:
 		ext4_journal_forget(handle, branch[i].bh);
 	}
 	for (i = 0; i <indirect_blks; i++)
-		ext4_free_blocks(handle, inode, new_blocks[i], 1);
+		ext4_free_blocks(handle, inode, new_blocks[i], 1, 0);
 
-	ext4_free_blocks(handle, inode, new_blocks[i], num);
+	ext4_free_blocks(handle, inode, new_blocks[i], num, 0);
 
 	return err;
 }
@@ -757,9 +757,9 @@ err_out:
 	for (i = 1; i <= num; i++) {
 		BUFFER_TRACE(where[i].bh, "call jbd2_journal_forget");
 		ext4_journal_forget(handle, where[i].bh);
-		ext4_free_blocks(handle,inode,le32_to_cpu(where[i-1].key),1);
+		ext4_free_blocks(handle,inode,le32_to_cpu(where[i-1].key),1, 0);
 	}
-	ext4_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks);
+	ext4_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks, 0);
 
 	return err;
 }
@@ -1990,7 +1990,7 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	ext4_free_blocks(handle, inode, block_to_free, count);
+	ext4_free_blocks(handle, inode, block_to_free, count, 0);
 }
 
 /**
@@ -2163,7 +2163,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 				ext4_journal_test_restart(handle, inode);
 			}
 
-			ext4_free_blocks(handle, inode, nr, 1);
+			ext4_free_blocks(handle, inode, nr, 1, 1);
 
 			if (parent_bh) {
 				/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index edc2ef7..b95a1b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -739,6 +739,7 @@ enum {
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents,
+	Opt_mballoc, Opt_nomballoc, Opt_stripe,
 };
 
 static match_table_t tokens = {
@@ -790,6 +791,9 @@ static match_table_t tokens = {
 	{Opt_barrier, "barrier=%u"},
 	{Opt_extents, "extents"},
 	{Opt_noextents, "noextents"},
+	{Opt_mballoc, "mballoc"},
+	{Opt_nomballoc, "nomballoc"},
+	{Opt_stripe, "stripe=%u"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1128,6 +1132,19 @@ clear_qf_name:
 		case Opt_noextents:
 			clear_opt (sbi->s_mount_opt, EXTENTS);
 			break;
+		case Opt_mballoc:
+			set_opt(sbi->s_mount_opt, MBALLOC);
+			break;
+		case Opt_nomballoc:
+			clear_opt(sbi->s_mount_opt, MBALLOC);
+			break;
+		case Opt_stripe:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			sbi->s_stripe = option;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
@@ -1926,6 +1943,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		"writeback");
 
 	ext4_ext_init(sb);
+	ext4_mb_init(sb, needs_recovery);
 
 	lock_kernel();
 	return 0;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b10d68f..4149b8a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -480,7 +480,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		ea_bdebug(bh, "refcount now=0; freeing");
 		if (ce)
 			mb_cache_entry_free(ce);
-		ext4_free_blocks(handle, inode, bh->b_blocknr, 1);
+		ext4_free_blocks(handle, inode, bh->b_blocknr, 1, 1);
 		get_bh(bh);
 		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
@@ -822,7 +822,7 @@ inserted:
 			new_bh = sb_getblk(sb, block);
 			if (!new_bh) {
 getblk_failed:
-				ext4_free_blocks(handle, inode, block, 1);
+				ext4_free_blocks(handle, inode, block, 1, 1);
 				error = -EIO;
 				goto cleanup;
 			}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index fbbb920..c2e819f 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -507,6 +507,7 @@ do {									       \
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
 #define EXT4_MOUNT_EXTENTS		0x400000 /* Extents support */
+#define EXT4_MOUNT_MBALLOC		0x800000 /* Buddy allocation support */
 
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 1a511e9..22ba80e 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -158,6 +158,10 @@ struct ext4_inode_info {
 	 * struct timespec i_{a,c,m}time in the generic inode.
 	 */
 	struct timespec i_crtime;
+
+	/* mballoc */
+	struct list_head i_prealloc_list;
+	spinlock_t i_prealloc_lock;
 };
 
 #endif	/* _LINUX_EXT4_FS_I */
-- 
1.5.3.rc4.67.gf9286-dirty
