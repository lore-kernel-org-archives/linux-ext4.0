From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix ext2 allocator overflows above 31 bit blocks
Date: Fri, 20 Apr 2007 12:10:05 -0500
Message-ID: <4628F3ED.9040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993287AbXDTROS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 13:14:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If ext3 can do 16T, ext2 probably should be able to as well.
There are still "int" block containers in the block allocation path
that need to be fixed up.

Perhaps ext2 should get the ext2_fsblk_t/ext2_grpblk_t treatment
as ext3 did, for clarity...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.21-rc5/fs/ext2/balloc.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/ext2/balloc.c
+++ linux-2.6.21-rc5/fs/ext2/balloc.c
@@ -323,7 +323,7 @@ got_it:
  * bitmap, and then for any free bit if that fails.
  * This function also updates quota and i_blocks field.
  */
-int ext2_new_block(struct inode *inode, unsigned long goal,
+unsigned long ext2_new_block(struct inode *inode, unsigned long goal,
 			u32 *prealloc_count, u32 *prealloc_block, int *err)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -332,8 +332,8 @@ int ext2_new_block(struct inode *inode, 
 	int group_no;			/* i */
 	int ret_block;			/* j */
 	int group_idx;			/* k */
-	int target_block;		/* tmp */
-	int block = 0;
+	unsigned long target_block;	/* tmp */
+	unsigned long block = 0;
 	struct super_block *sb = inode->i_sb;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
@@ -460,7 +460,7 @@ got_block:
 		      sbi->s_itb_per_group))
 		ext2_error (sb, "ext2_new_block",
 			    "Allocating block in system zone - "
-			    "block = %u", target_block);
+			    "block = %lu", target_block);
 
 	if (target_block >= le32_to_cpu(es->s_blocks_count)) {
 		ext2_error (sb, "ext2_new_block",
Index: linux-2.6.21-rc5/fs/ext2/ext2.h
===================================================================
--- linux-2.6.21-rc5.orig/fs/ext2/ext2.h
+++ linux-2.6.21-rc5/fs/ext2/ext2.h
@@ -91,7 +91,7 @@ static inline struct ext2_inode_info *EX
 /* balloc.c */
 extern int ext2_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext2_bg_num_gdb(struct super_block *sb, int group);
-extern int ext2_new_block (struct inode *, unsigned long,
+extern unsigned long ext2_new_block (struct inode *, unsigned long,
 			   __u32 *, __u32 *, int *);
 extern void ext2_free_blocks (struct inode *, unsigned long,
 			      unsigned long);
Index: linux-2.6.21-rc5/fs/ext2/inode.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/ext2/inode.c
+++ linux-2.6.21-rc5/fs/ext2/inode.c
@@ -107,7 +107,7 @@ void ext2_discard_prealloc (struct inode
 #endif
 }
 
-static int ext2_alloc_block (struct inode * inode, unsigned long goal, int *err)
+static unsigned long ext2_alloc_block (struct inode * inode, unsigned long goal, int *err)
 {
 #ifdef EXT2FS_DEBUG
 	static unsigned long alloc_hits, alloc_attempts;
@@ -425,13 +425,13 @@ static int ext2_alloc_branch(struct inod
 	int n = 0;
 	int err;
 	int i;
-	int parent = ext2_alloc_block(inode, goal, &err);
+	unsigned long parent = ext2_alloc_block(inode, goal, &err);
 
 	branch[0].key = cpu_to_le32(parent);
 	if (parent) for (n = 1; n < num; n++) {
 		struct buffer_head *bh;
 		/* Allocate the next block */
-		int nr = ext2_alloc_block(inode, parent, &err);
+		unsigned long nr = ext2_alloc_block(inode, parent, &err);
 		if (!nr)
 			break;
 		branch[n].key = cpu_to_le32(nr);
