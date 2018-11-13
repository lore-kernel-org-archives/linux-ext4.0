Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:40135 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:00:57 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 04/10] ext2: fix coding style for ext2.h
Date: Tue, 13 Nov 2018 08:04:42 +0800
Message-Id: <20181113000448.16023-5-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/ext2.h | 100 ++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 43 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd100a6a..6b1a7633771e 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -80,10 +80,11 @@ struct ext2_sb_info {
 	unsigned long s_groups_count;	/* Number of groups in the fs */
 	unsigned long s_overhead_last;  /* Last calculated overhead */
 	unsigned long s_blocks_last;    /* Last seen block count */
-	struct buffer_head * s_sbh;	/* Buffer containing the super block */
-	struct ext2_super_block * s_es;	/* Pointer to the super block in the buffer */
-	struct buffer_head ** s_group_desc;
-	unsigned long  s_mount_opt;
+	struct buffer_head *s_sbh;	/* Buffer containing the super block */
+	/* Pointer to the super block in the buffer */
+	struct ext2_super_block *s_es;
+	struct buffer_head **s_group_desc;
+	unsigned long s_mount_opt;
 	unsigned long s_sb_block;
 	kuid_t s_resuid;
 	kgid_t s_resgid;
@@ -198,8 +199,8 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
  */
 struct ext2_group_desc
 {
-	__le32	bg_block_bitmap;		/* Blocks bitmap block */
-	__le32	bg_inode_bitmap;		/* Inodes bitmap block */
+	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
@@ -735,62 +736,75 @@ static inline struct ext2_inode_info *EXT2_I(struct inode *inode)
 /* balloc.c */
 extern int ext2_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext2_bg_num_gdb(struct super_block *sb, int group);
-extern ext2_fsblk_t ext2_new_block(struct inode *, unsigned long, int *);
-extern ext2_fsblk_t ext2_new_blocks(struct inode *, unsigned long,
-				unsigned long *, int *);
-extern int ext2_data_block_valid(struct ext2_sb_info *sbi, ext2_fsblk_t start_blk,
-				 unsigned int count);
-extern void ext2_free_blocks (struct inode *, unsigned long,
-			      unsigned long);
-extern unsigned long ext2_count_free_blocks (struct super_block *);
-extern unsigned long ext2_count_dirs (struct super_block *);
-extern struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
-						    unsigned int block_group,
-						    struct buffer_head ** bh);
-extern void ext2_discard_reservation (struct inode *);
+extern ext2_fsblk_t ext2_new_block(struct inode *inode, unsigned long goal,
+				   int *errp);
+extern ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
+				    unsigned long *count, int *errp);
+extern int ext2_data_block_valid(struct ext2_sb_info *sbi,
+				 ext2_fsblk_t start_blk, unsigned int count);
+extern void ext2_free_blocks(struct inode *inode, unsigned long block,
+			     unsigned long count);
+extern unsigned long ext2_count_free_blocks(struct super_block *sb);
+extern unsigned long ext2_count_dirs(struct super_block *sb);
+extern struct ext2_group_desc *ext2_get_group_desc(struct super_block *sb,
+						   unsigned int block_group,
+						   struct buffer_head **bh);
+extern void ext2_discard_reservation(struct inode *inode);
 extern int ext2_should_retry_alloc(struct super_block *sb, int *retries);
-extern void ext2_init_block_alloc_info(struct inode *);
-extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_window_node *rsv);
+extern void ext2_init_block_alloc_info(struct inode *inode);
+extern void ext2_rsv_window_add(struct super_block *sb,
+				struct ext2_reserve_window_node *rsv);
+extern unsigned long ext2_count_free(struct buffer_head *map,
+				     unsigned int numchars);
 
 /* dir.c */
-extern int ext2_add_link (struct dentry *, struct inode *);
-extern ino_t ext2_inode_by_name(struct inode *, const struct qstr *);
-extern int ext2_make_empty(struct inode *, struct inode *);
-extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,const struct qstr *, struct page **);
-extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
-extern int ext2_empty_dir (struct inode *);
-extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
-extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
+extern int ext2_add_link(struct dentry *dentry, struct inode *inode);
+extern ino_t ext2_inode_by_name(struct inode *dir, const struct qstr *child);
+extern int ext2_make_empty(struct inode *inode, struct inode *parent);
+extern struct ext2_dir_entry_2 *ext2_find_entry(struct inode *dir,
+						const struct qstr *child,
+						struct page **res_page);
+extern int ext2_delete_entry(struct ext2_dir_entry_2 *dir, struct page *page);
+extern int ext2_empty_dir(struct inode *inode);
+extern struct ext2_dir_entry_2 *ext2_dotdot(struct inode *dir, struct page **p);
+extern void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
+			  struct page *page, struct inode *inode,
+			  int update_times);
 
 /* ialloc.c */
-extern struct inode * ext2_new_inode (struct inode *, umode_t, const struct qstr *);
-extern void ext2_free_inode (struct inode *);
-extern unsigned long ext2_count_free_inodes (struct super_block *);
-extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
+extern struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
+				    const struct qstr *qstr);
+extern void ext2_free_inode(struct inode *inode);
+extern unsigned long ext2_count_free_inodes(struct super_block *sb);
 
 /* inode.c */
-extern struct inode *ext2_iget (struct super_block *, unsigned long);
-extern int ext2_write_inode (struct inode *, struct writeback_control *);
-extern void ext2_evict_inode(struct inode *);
-extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
-extern int ext2_setattr (struct dentry *, struct iattr *);
+extern struct inode *ext2_iget(struct super_block *sb, unsigned long ino);
+extern int ext2_write_inode(struct inode *inode,
+			    struct writeback_control *do_sync);
+extern void ext2_evict_inode(struct inode *inode);
+extern int ext2_get_block(struct inode *inode, sector_t iblock,
+			  struct buffer_head *bh_result, int creaate);
+extern int ext2_setattr(struct dentry *dentry, struct iattr *iattr);
 extern void ext2_set_inode_flags(struct inode *inode);
 extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
 
 /* ioctl.c */
-extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
-extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
+extern long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+extern long ext2_compat_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg);
 
 /* namei.c */
 struct dentry *ext2_get_parent(struct dentry *child);
 
 /* super.c */
 extern __printf(3, 4)
-void ext2_error(struct super_block *, const char *, const char *, ...);
+void ext2_error(struct super_block *sb, const char *function,
+		const char *fmt, ...);
 extern __printf(3, 4)
-void ext2_msg(struct super_block *, const char *, const char *, ...);
-extern void ext2_update_dynamic_rev (struct super_block *sb);
+void ext2_msg(struct super_block *sb, const char *prefix,
+	      const char *fmt, ...);
+extern void ext2_update_dynamic_rev(struct super_block *sb);
 extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait);
 
-- 
2.17.2
