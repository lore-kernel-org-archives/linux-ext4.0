From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: rfc: [patch] move "_hi" block numbers
Date: Fri, 15 Sep 2006 17:22:52 +0200
Message-ID: <20060915152252.GA1628@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:62866 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751643AbWIOPXD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 11:23:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B070919D93F
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 17:22:58 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 06138-07 for <linux-ext4@vger.kernel.org>;
 Fri, 15 Sep 2006 17:22:54 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 2F2F419D935
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 17:22:54 +0200 (CEST)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hi,

recently i've posted patches that remove relative block numbers in group
descriptors and that allow larger descriptors. The current group descriptor
size is 32 bytes and with the patch any power of 2 is allowed. This will
make possible to add ``_hi'' bits to other fields of the group decriptor.
We'll need this in order to enlarge block groups, thus breaking the current
2^37 file-system size limit.

the attached patch moves ``_hi'' bits of bg_inode_bitmap, bg_block_bitmap
and bg_inode_table in the larger part of the group descriptor structure, as
we discussed the last week. 

With this patch, we let a gap in the first 32 byte part of the group
descriptor. It can be used to port future ext3 features to ext4 or to
backport features from ext4 to ext3, without interfering with the 64bit
support.

the patch is very simple:

 - it defines ``EXT4_MIN_DESC_SIZE_64BIT'', the smallest group descriptor
   size allowed for 64BIT support.

 - in ext4_fill_super(), check that if the 64BT incompat feature is 
   set then the group descriptor is large enough

 - modify getters and setters for bg_block_bitmap, bg_inode_bitmap and
   bg_inode_table to use ``_hi'' bits only if the descriptor is large enough
   to contain them.

Comments?

here is the complete patch set for 2.6.18-rc6; there's also a patch set for
e2fsprogs-1.39 in sync with the kernel patches:

http://www.bullopensource.org/ext4/20060915/

I've tested all this stuff on x86_64 with a 20TB device.

cheers,

-- Alexandre


Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>

Index: linux-2.6.18-rc6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.18-rc6.orig/fs/ext4/ialloc.c	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/fs/ext4/ialloc.c	2006-09-15 14:26:43.000000000 +0200
@@ -60,12 +60,12 @@ read_inode_bitmap(struct super_block * s
 	if (!desc)
 		goto error_out;
 
-	bh = sb_bread(sb, ext4_inode_bitmap(desc));
+	bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
 	if (!bh)
 		ext4_error(sb, "read_inode_bitmap",
 			    "Cannot read inode bitmap - "
 			    "block_group = %lu, inode_bitmap = %llu",
-			    block_group, ext4_inode_bitmap(desc));
+			    block_group, ext4_inode_bitmap(sb, desc));
 error_out:
 	return bh;
 }
Index: linux-2.6.18-rc6/fs/ext4/resize.c
===================================================================
--- linux-2.6.18-rc6.orig/fs/ext4/resize.c	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/fs/ext4/resize.c	2006-09-15 14:26:43.000000000 +0200
@@ -829,9 +829,9 @@ int ext4_group_add(struct super_block *s
 	/* Update group descriptor block for new group */
 	gdp = (struct ext4_group_desc *)primary->b_data + gdb_off;
 
-	ext4_block_bitmap_set(gdp, input->block_bitmap); /* LV FIXME */
-	ext4_inode_bitmap_set(gdp, input->inode_bitmap); /* LV FIXME */
-	ext4_inode_table_set(gdp, input->inode_table); /* LV FIXME */
+	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
+	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
+	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
 
Index: linux-2.6.18-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.18-rc6.orig/fs/ext4/balloc.c	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/fs/ext4/balloc.c	2006-09-15 14:26:44.000000000 +0200
@@ -89,13 +89,13 @@ read_block_bitmap(struct super_block *sb
 	desc = ext4_get_group_desc (sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(desc));
+	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
 	if (!bh)
 		ext4_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group,
-			    ext4_block_bitmap(desc));
+			    ext4_block_bitmap(sb, desc));
 error_out:
 	return bh;
 }
@@ -358,10 +358,11 @@ do_more:
 	if (!desc)
 		goto error_return;
 
-	if (in_range(ext4_block_bitmap(desc), block, count) ||
-	    in_range(ext4_inode_bitmap(desc), block, count) ||
-	    in_range(block, ext4_inode_table(desc), sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(desc), sbi->s_itb_per_group))
+	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
+	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
+	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
+	    in_range(block + count - 1, 
+		     ext4_inode_table(sb, desc), sbi->s_itb_per_group))
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
@@ -1361,11 +1362,11 @@ allocated:
 
 	ret_block = grp_alloc_blk + ext4_group_first_block_no(sb, group_no);
 
-	if (in_range(ext4_block_bitmap(gdp), ret_block, num) ||
-	    in_range(ext4_block_bitmap(gdp), ret_block, num) ||
-	    in_range(ret_block, ext4_inode_table(gdp),
+	if (in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
+	    in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
+	    in_range(ret_block, ext4_inode_table(sb, gdp),
 			EXT4_SB(sb)->s_itb_per_group) ||
-	    in_range(ret_block + num - 1, ext4_inode_table(gdp),
+	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
 			EXT4_SB(sb)->s_itb_per_group))
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
Index: linux-2.6.18-rc6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.18-rc6.orig/include/linux/ext4_fs.h	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/include/linux/ext4_fs.h	2006-09-15 16:18:18.000000000 +0200
@@ -133,10 +133,10 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;		/* reserved for fsck */
-	__le16	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
-	__le16	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
-	__le16	bg_inode_table_hi;	/* Inodes table block MSB */
-	__u16	bg_reserved[3];
+	__u32	bg_reserved[3];
+	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
+	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
+	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
 };
 
 #ifdef __KERNEL__
@@ -147,6 +147,7 @@ struct ext4_group_desc
  * Macro-instructions used to manage group descriptors
  */
 #define EXT4_MIN_DESC_SIZE		32
+#define EXT4_MIN_DESC_SIZE_64BIT	64
 #define	EXT4_MAX_DESC_SIZE		EXT4_MIN_BLOCK_SIZE
 #define EXT4_DESC_SIZE(s)		(EXT4_SB(s)->s_desc_size)
 #ifdef __KERNEL__
@@ -896,12 +897,18 @@ extern void ext4_warning (struct super_b
 extern void ext4_update_dynamic_rev (struct super_block *sb);
 extern ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es);
 extern ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es);
-extern ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg);
-extern ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg);
-extern ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg);
-extern void ext4_block_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t blk);
-extern void ext4_inode_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t blk);
-extern void ext4_inode_table_set(struct ext4_group_desc *bg, ext4_fsblk_t blk);
+extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *bg);
+extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *bg);
+extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
+				     struct ext4_group_desc *bg);
+extern void ext4_block_bitmap_set(struct super_block *sb, 
+				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
+extern void ext4_inode_bitmap_set(struct super_block *sb,
+				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
+extern void ext4_inode_table_set(struct super_block *sb,
+				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
 
 #define ext4_std_error(sb, errno)				\
 do {								\
Index: linux-2.6.18-rc6/fs/ext4/inode.c
===================================================================
--- linux-2.6.18-rc6.orig/fs/ext4/inode.c	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/fs/ext4/inode.c	2006-09-15 14:26:44.000000000 +0200
@@ -2435,9 +2435,8 @@ static ext4_fsblk_t ext4_get_inode_block
 	 */
 	offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
 		EXT4_INODE_SIZE(sb);
-	block = ext4_inode_table(gdp) + (offset >> EXT4_BLOCK_SIZE_BITS(sb));
-
-
+	block = ext4_inode_table(sb, gdp) + 
+		(offset >> EXT4_BLOCK_SIZE_BITS(sb));
 
 	iloc->block_group = block_group;
 	iloc->offset = offset & (EXT4_BLOCK_SIZE(sb) - 1);
@@ -2504,7 +2503,7 @@ static int __ext4_get_inode_loc(struct i
 				goto make_io;
 
 			bitmap_bh = sb_getblk(inode->i_sb, 
-				ext4_inode_bitmap(desc));
+				ext4_inode_bitmap(inode->i_sb, desc));
 			if (!bitmap_bh)
 				goto make_io;
 
Index: linux-2.6.18-rc6/fs/ext4/super.c
===================================================================
--- linux-2.6.18-rc6.orig/fs/ext4/super.c	2006-09-14 18:32:37.000000000 +0200
+++ linux-2.6.18-rc6/fs/ext4/super.c	2006-09-15 18:15:47.000000000 +0200
@@ -74,40 +74,52 @@ ext4_fsblk_t ext4_r_blocks_count(struct 
 				(__u64)le32_to_cpu(es->s_r_blocks_count));
 }
 
-ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg)
+ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
+			       struct ext4_group_desc *bg)
 {	
-	return le32_to_cpu(bg->bg_block_bitmap) | 
-		((ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32);
+	return le32_to_cpu(bg->bg_block_bitmap) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
 }	
 
-ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg)
+ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
+			       struct ext4_group_desc *bg)
 {	
 	return le32_to_cpu(bg->bg_inode_bitmap) | 
-		((ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32);
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
 }	
 
-ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg)
+ext4_fsblk_t ext4_inode_table(struct super_block *sb,
+			      struct ext4_group_desc *bg)
 {	
 	return le32_to_cpu(bg->bg_inode_table) | 
-		((ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32);
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
 }	
 
-void ext4_block_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t blk)
+void ext4_block_bitmap_set(struct super_block *sb,
+			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {	
-	bg->bg_block_bitmap    = cpu_to_le32((u32)blk);
-	bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
-}	
+	bg->bg_block_bitmap = cpu_to_le32((u32)blk);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
+} 
 
-void ext4_inode_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t blk)
+void ext4_inode_bitmap_set(struct super_block *sb,
+			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {	
-	bg->bg_inode_bitmap    = cpu_to_le32((u32)blk);
-	bg->bg_inode_bitmap_hi = cpu_to_le32(blk >> 32);
+	bg->bg_inode_bitmap = cpu_to_le32((u32)blk);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_inode_bitmap_hi = cpu_to_le32(blk >> 32);
 }	
 
-void ext4_inode_table_set(struct ext4_group_desc *bg, ext4_fsblk_t blk)
+void ext4_inode_table_set(struct super_block *sb,
+			  struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {	
-	bg->bg_inode_table    = cpu_to_le32((u32)blk);
-	bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
+	bg->bg_inode_table = cpu_to_le32((u32)blk);
+	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
+		bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
 }	
 
 static void ext4_free_blocks_count_set(struct ext4_super_block *es, __u32 v)
@@ -1204,32 +1216,32 @@ static int ext4_check_descriptors (struc
 		if ((i % EXT4_DESC_PER_BLOCK(sb)) == 0)
 			gdp = (struct ext4_group_desc *)
 					sbi->s_group_desc[desc_block++]->b_data;
-		if (ext4_block_bitmap(gdp) < block ||
-		    ext4_block_bitmap(gdp) >= block + EXT4_BLOCKS_PER_GROUP(sb))
+		if (ext4_block_bitmap(sb, gdp) < block ||
+		    ext4_block_bitmap(sb, gdp) >= block + EXT4_BLOCKS_PER_GROUP(sb))
 		{
 			ext4_error (sb, "ext4_check_descriptors",
 				    "Block bitmap for group %d"
 				    " not in group (block %llu)!",
-				    i, ext4_block_bitmap(gdp));
+				    i, ext4_block_bitmap(sb, gdp));
 			return 0;
 		}
-		if (ext4_inode_bitmap(gdp) < block ||
-		    ext4_inode_bitmap(gdp) >= block + EXT4_BLOCKS_PER_GROUP(sb))
+		if (ext4_inode_bitmap(sb, gdp) < block ||
+		    ext4_inode_bitmap(sb, gdp) >= block + EXT4_BLOCKS_PER_GROUP(sb))
 		{
 			ext4_error (sb, "ext4_check_descriptors",
 				    "Inode bitmap for group %d"
 				    " not in group (block %llu)!",
-				    i, ext4_inode_bitmap(gdp));
+				    i, ext4_inode_bitmap(sb, gdp));
 			return 0;
 		}
-		if (ext4_inode_table(gdp) < block ||
-		    ext4_inode_table(gdp) + sbi->s_itb_per_group >=
+		if (ext4_inode_table(sb, gdp) < block ||
+		    ext4_inode_table(sb, gdp) + sbi->s_itb_per_group >=
 			block + EXT4_BLOCKS_PER_GROUP(sb))
 		{
 			ext4_error (sb, "ext4_check_descriptors",
 				    "Inode table for group %d"
 				    " not in group (block %llu)!",
-				    i, ext4_inode_table(gdp));
+				    i, ext4_inode_table(sb, gdp));
 			return 0;
 		}
 		block += EXT4_BLOCKS_PER_GROUP(sb);
@@ -1588,11 +1600,11 @@ static int ext4_fill_super (struct super
 	}
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
-		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE ||
+		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
 		    sbi->s_desc_size & (sbi->s_desc_size - 1)) {
 			printk(KERN_ERR
-			       "EXT4-fs: unsupported descriptor size %d\n",
+			       "EXT4-fs: unsupported descriptor size %lu\n",
 			       sbi->s_desc_size);
 			goto failed_mount;
 		}

