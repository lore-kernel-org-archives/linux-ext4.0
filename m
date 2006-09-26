From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 12/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:50:57 +0200
Message-ID: <20060926145057.GL25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35723 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932109AbWIZOvI
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:51:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id E974419D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:51:03 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12580-04 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:50:59 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B81EC19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:50:58 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

move "*_hi" bits of bg_block_bitmap, bg_inode_bitmap, bg_inode_table
fields in the larger part of the block group descriptor

Index: e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_fs.h	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2_fs.h	2006-09-25 13:22:27.000000000 +0200
@@ -144,10 +144,10 @@ struct ext2_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u16	bg_block_bitmap_hi;	/* Blocks bitmap block */
-	__u16	bg_inode_bitmap_hi;	/* Inodes bitmap block */
-	__u16	bg_inode_table_hi;	/* Inodes table block */
-	__u16	bg_reserved[3];
+	__u32	bg_reserved[3];
+	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block */
+	__u32	bg_inode_bitmap_hi;	/* Inodes bitmap block */
+	__u32	bg_inode_table_hi;	/* Inodes table block */
 };
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
@@ -156,35 +156,47 @@ struct ext2_group_desc
 #define EXT2_GROUP_BASE(s,g)	((__u64)(s)->s_first_data_block + \
 				 (__u64)(s)->s_blocks_per_group * (g))
 
-#define EXT2_BLOCK_BITMAP(bg)			\
-	((bg)->bg_block_bitmap + ((__u64)(bg)->bg_block_bitmap_hi << 32))
-#define EXT2_INODE_BITMAP(bg)			\
-	((bg)->bg_inode_bitmap + ((__u64)(bg)->bg_inode_bitmap_hi << 32))
-#define EXT2_INODE_TABLE(bg)			\
-	((bg)->bg_inode_table  + ((__u64)(bg)->bg_inode_table_hi  << 32))
-
-#define EXT2_BLOCK_BITMAP_SET(bg, value)			\
-	do {							\
-		(bg)->bg_block_bitmap = (__u32)(value);		\
-		(bg)->bg_block_bitmap_hi = (value) >> 32;	\
+#define EXT2_BLOCK_BITMAP(sb, bg)					\
+	((bg)->bg_block_bitmap +					\
+	 (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT ?		\
+	  (blk_t)(bg)->bg_block_bitmap_hi << 32 : 0))
+#define EXT2_INODE_BITMAP(sb, bg)					\
+	((bg)->bg_inode_bitmap +					\
+	 (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT ?		\
+	  (blk_t)(bg)->bg_inode_bitmap_hi << 32 : 0))
+#define EXT2_INODE_TABLE(sb, bg)					\
+	((bg)->bg_inode_table +						\
+	 (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT ?		\
+	  (blk_t)(bg)->bg_inode_table_hi << 32 : 0))
+
+#define EXT2_BLOCK_BITMAP_SET(sb, bg, value)				\
+	do {								\
+		(bg)->bg_block_bitmap = (__u32)(value);			\
+		if (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT)	\
+			(bg)->bg_block_bitmap_hi = (value) >> 32;	\
 	} while(0)
-#define EXT2_INODE_BITMAP_SET(bg, value)			\
-	do {							\
-		(bg)->bg_inode_bitmap = (__u32)(value);		\
-		(bg)->bg_inode_bitmap_hi = (value) >> 32;	\
+#define EXT2_INODE_BITMAP_SET(sb, bg, value)				\
+	do {								\
+		(bg)->bg_inode_bitmap = (__u32)(value);			\
+		if (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT)	\
+			(bg)->bg_inode_bitmap_hi = (value) >> 32;	\
 	} while(0)
-#define EXT2_INODE_TABLE_SET(bg, value)				\
-	do {							\
-		(bg)->bg_inode_table = (__u32)(value);		\
-		(bg)->bg_inode_table_hi = (value) >> 32;	\
+#define EXT2_INODE_TABLE_SET(sb, bg, value)				\
+	do {								\
+		(bg)->bg_inode_table = (__u32)(value);			\
+		if (EXT2_DESC_SIZE(sb) >= EXT2_MIN_DESC_SIZE_64BIT)	\
+			(bg)->bg_inode_table_hi = (value) >> 32;	\
 	} while(0)
 
-#define EXT2_IS_USED_BLOCK_BITMAP(bg)	\
-	((bg)->bg_block_bitmap != 0 || (bg)->bg_block_bitmap_hi != 0)
-#define EXT2_IS_USED_INODE_BITMAP(bg)	\
-	((bg)->bg_inode_bitmap != 0 || (bg)->bg_inode_bitmap_hi != 0)
-#define EXT2_IS_USED_INODE_TABLE(bg)	\
-	((bg)->bg_inode_table  != 0 || (bg)->bg_inode_table_hi  != 0)
+#define EXT2_IS_USED_BLOCK_BITMAP(sb, bg) \
+	(EXT2_BLOCK_BITMAP((sb), (bg)) != 0)
+
+#define EXT2_IS_USED_INODE_BITMAP(sb, bg) \
+	(EXT2_INODE_BITMAP((sb), (bg)) != 0)
+
+#define EXT2_IS_USED_INODE_TABLE(sb, bg)	\
+	(EXT2_INODE_TABLE((sb), (bg)) != 0)
+
 /*
  * Data structures used by the directory indexing feature
  *
Index: e2fsprogs-1.39/lib/ext2fs/check_desc.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/check_desc.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/check_desc.c	2006-09-25 13:22:27.000000000 +0200
@@ -45,22 +45,22 @@ errcode_t ext2fs_check_desc(ext2_filsys 
 		 * Check to make sure block bitmap for group is
 		 * located within the group.
 		 */
-		if (EXT2_BLOCK_BITMAP(&fs->group_desc[i]) < first_block ||
-		    EXT2_BLOCK_BITMAP(&fs->group_desc[i]) > last_block)
+		if (EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]) < first_block ||
+		    EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]) > last_block)
 			return EXT2_ET_GDESC_BAD_BLOCK_MAP;
 		/*
 		 * Check to make sure inode bitmap for group is
 		 * located within the group
 		 */
-		if (EXT2_INODE_BITMAP(&fs->group_desc[i]) < first_block ||
-		    EXT2_INODE_BITMAP(&fs->group_desc[i]) > last_block)
+		if (EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]) < first_block ||
+		    EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]) > last_block)
 			return EXT2_ET_GDESC_BAD_INODE_MAP;
 		/*
 		 * Check to make sure inode table for group is located
 		 * within the group
 		 */
-		if (EXT2_INODE_TABLE(&fs->group_desc[i]) < first_block ||
-		    ((EXT2_INODE_TABLE(&fs->group_desc[i]) +
+		if (EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) < first_block ||
+		    ((EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) +
 		      fs->inode_blocks_per_group) > last_block))
 			return EXT2_ET_GDESC_BAD_INODE_TABLE;
 	}
Index: e2fsprogs-1.39/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/alloc_tables.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/alloc_tables.c	2006-09-25 13:22:27.000000000 +0200
@@ -56,7 +56,7 @@ errcode_t ext2fs_allocate_group_table(ex
 	} else
 		start_blk = group_blk;
 
-	if (!EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[group])) {
+	if (!EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -65,10 +65,11 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		EXT2_BLOCK_BITMAP_SET(&fs->group_desc[group], new_blk);
+		EXT2_BLOCK_BITMAP_SET(fs->super, 
+				      &fs->group_desc[group], new_blk);
 	}
 
-	if (!EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[group])) {
+	if (!EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
@@ -77,13 +78,14 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (retval)
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		EXT2_INODE_BITMAP_SET(&fs->group_desc[group], new_blk);
+		EXT2_INODE_BITMAP_SET(fs->super, 
+				      &fs->group_desc[group], new_blk);
 	}
 
 	/*
 	 * Allocate the inode table
 	 */
-	if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[group])) {
+	if (!EXT2_IS_USED_INODE_TABLE(fs->super, &fs->group_desc[group])) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
 						bmap, &new_blk);
@@ -93,9 +95,9 @@ errcode_t ext2fs_allocate_group_table(ex
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++)
 			ext2fs_mark_block_bitmap(bmap, blk);
-		EXT2_INODE_TABLE_SET(&fs->group_desc[group], new_blk);
+		EXT2_INODE_TABLE_SET(fs->super, 
+				     &fs->group_desc[group], new_blk);
 	}
-
 	
 	return 0;
 }
Index: e2fsprogs-1.39/lib/ext2fs/imager.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/imager.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/imager.c	2006-09-25 13:22:27.000000000 +0200
@@ -71,9 +71,11 @@ errcode_t ext2fs_image_inode_write(ext2_
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned)group]))
+		if (!EXT2_IS_USED_INODE_TABLE(fs->super, 
+					      &fs->group_desc[(unsigned)group]))
 			return EXT2_ET_MISSING_INODE_TABLE;
-		blk = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]);
+		blk = EXT2_INODE_TABLE(fs->super,
+				       &fs->group_desc[(unsigned)group]);
 		left = fs->inode_blocks_per_group;
 		while (left) {
 			c = BUF_BLOCKS;
@@ -143,11 +145,13 @@ errcode_t ext2fs_image_inode_read(ext2_f
 		return ENOMEM;
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
-		if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned)group])) {
+		if (!EXT2_IS_USED_INODE_TABLE(fs->super,
+					      &fs->group_desc[(unsigned)group])) {
 			retval = EXT2_ET_MISSING_INODE_TABLE;
 			goto errout;
 		}
-		blk = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]);
+		blk = EXT2_INODE_TABLE(fs->super,
+				       &fs->group_desc[(unsigned)group]);
 		left = fs->inode_blocks_per_group;
 		while (left) {
 			c = BUF_BLOCKS;
Index: e2fsprogs-1.39/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass5.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass5.c	2006-09-25 13:22:27.000000000 +0200
@@ -180,12 +180,16 @@ redo_counts:
 			    (i <= super + fs->desc_blocks) &&
 			    ext2fs_bg_has_super(fs, group))
 				bitmap = 1;
-			else if (i == EXT2_BLOCK_BITMAP(&fs->group_desc[group]))
+			else if (i == EXT2_BLOCK_BITMAP(fs->super, 
+							&fs->group_desc[group]))
 				bitmap = 1;
-			else if (i == EXT2_INODE_BITMAP(&fs->group_desc[group]))
+			else if (i == EXT2_INODE_BITMAP(fs->super, 
+							&fs->group_desc[group]))
 				bitmap = 1;
-			else if (i >= EXT2_INODE_TABLE(&fs->group_desc[group]) &&
-				 (i < EXT2_INODE_TABLE(&fs->group_desc[group])
+			else if (i >= EXT2_INODE_TABLE(fs->super, 
+						       &fs->group_desc[group]) &&
+				 (i < EXT2_INODE_TABLE(fs->super, 
+						       &fs->group_desc[group])
 				  + fs->inode_blocks_per_group))
 				bitmap = 1;
 			else
Index: e2fsprogs-1.39/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/swapfs.c	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/swapfs.c	2006-09-25 13:22:27.000000000 +0200
@@ -74,11 +74,17 @@ void ext2fs_swap_super(struct ext2_super
 
 }
 
-void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
+void ext2fs_swap_group_desc(struct ext2_super_block *sb,
+			    struct ext2_group_desc *gdp)
 {
 	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
 	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);
 	gdp->bg_inode_table = ext2fs_swab32(gdp->bg_inode_table);
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
+		gdp->bg_block_bitmap_hi = ext2fs_swab32(gdp->bg_block_bitmap_hi);
+		gdp->bg_inode_bitmap_hi = ext2fs_swab32(gdp->bg_inode_bitmap_hi);
+		gdp->bg_inode_table_hi = ext2fs_swab32(gdp->bg_inode_table_hi);
+	}
 	gdp->bg_free_blocks_count = ext2fs_swab16(gdp->bg_free_blocks_count);
 	gdp->bg_free_inodes_count = ext2fs_swab16(gdp->bg_free_inodes_count);
 	gdp->bg_used_dirs_count = ext2fs_swab16(gdp->bg_used_dirs_count);
Index: e2fsprogs-1.39/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/rw_bitmaps.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/rw_bitmaps.c	2006-09-25 13:22:27.000000000 +0200
@@ -108,8 +108,8 @@ static errcode_t write_bitmaps(ext2_fils
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
-		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
-			 blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
+		if (EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[i])) {
+			 blk = EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]);
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
 			      (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)))
@@ -133,8 +133,8 @@ static errcode_t write_bitmaps(ext2_fils
 			goto skip_this_inode_bitmap;
  
 		memcpy(inode_buf, inode_bitmap, inode_nbytes);
-		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
-			blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
+		if (EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[i])) {
+			blk = EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]);
 #ifdef EXT2_BIG_ENDIAN_BITMAPS
 			if (!((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
 			      (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)))
@@ -227,8 +227,10 @@ static errcode_t read_bitmaps(ext2_filsy
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (block_bitmap) {
-			if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
-				blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
+			if (EXT2_IS_USED_BLOCK_BITMAP(fs->super,
+						      &fs->group_desc[i])) {
+				blk = EXT2_BLOCK_BITMAP(fs->super,
+							&fs->group_desc[i]);
 			if (lazy_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_BLOCK_UNINIT)
 				blk = 0;
@@ -248,8 +250,10 @@ static errcode_t read_bitmaps(ext2_filsy
 			block_bitmap += block_nbytes;
 		}
 		if (inode_bitmap) {
-			if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
-				blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
+			if (EXT2_IS_USED_INODE_BITMAP(fs->super,
+						      &fs->group_desc[i])) {
+				blk = EXT2_INODE_BITMAP(fs->super,
+							&fs->group_desc[i]);
 			if (lazy_flag && fs->group_desc[i].bg_flags &
 			    EXT2_BG_INODE_UNINIT)
 				blk = 0;
Index: e2fsprogs-1.39/resize/online.c
===================================================================
--- e2fsprogs-1.39.orig/resize/online.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/resize/online.c	2006-09-25 13:22:27.000000000 +0200
@@ -98,9 +98,12 @@ errcode_t online_resize_fs(ext2_filsys f
 				new_fs->super->s_reserved_gdt_blocks;
 
 		input.group = i;
-		input.block_bitmap = EXT2_BLOCK_BITMAP(&new_fs->group_desc[i]);
-		input.inode_bitmap = EXT2_INODE_BITMAP(&new_fs->group_desc[i]);
-		input.inode_table = EXT2_INODE_TABLE(&new_fs->group_desc[i]);
+		input.block_bitmap = EXT2_BLOCK_BITMAP(new_fs->super, 
+						       &new_fs->group_desc[i]);
+		input.inode_bitmap = EXT2_INODE_BITMAP(new_fs->super, 
+						       &new_fs->group_desc[i]);
+		input.inode_table = EXT2_INODE_TABLE(new_fs->super,
+						     &new_fs->group_desc[i]);
 		input.blocks_count = sb->s_blocks_per_group;
 		if (i == new_fs->group_desc_count-1) {
 			input.blocks_count = EXT2_BLOCKS_COUNT(new_fs->super) -
Index: e2fsprogs-1.39/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/logdump.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/debugfs/logdump.c	2006-09-25 13:22:27.000000000 +0200
@@ -158,7 +158,8 @@ void do_logdump(int argc, char **argv)
 				    / sizeof(struct ext2_inode));
 		
 		inode_block_to_dump = 
-			EXT2_INODE_TABLE(&current_fs->group_desc[inode_group]) +
+			EXT2_INODE_TABLE(current_fs->super, 
+					 &current_fs->group_desc[inode_group]) +
 			(group_offset / inodes_per_block);
 		inode_offset_to_dump = ((group_offset % inodes_per_block)
 					* sizeof(struct ext2_inode));
@@ -183,7 +184,9 @@ void do_logdump(int argc, char **argv)
 		group_to_dump = ((block_to_dump - 
 				  es->s_first_data_block)
 				 / es->s_blocks_per_group);
-		bitmap_to_dump = EXT2_BLOCK_BITMAP(&current_fs->group_desc[group_to_dump]);
+		bitmap_to_dump = EXT2_BLOCK_BITMAP(
+			current_fs->super, 
+			&current_fs->group_desc[group_to_dump]);
 	}
 
 	if (!journal_fn && check_fs_open(argv[0]))
Index: e2fsprogs-1.39/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/debugfs.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/debugfs/debugfs.c	2006-09-25 13:22:27.000000000 +0200
@@ -322,9 +322,9 @@ void do_show_super_stats(int argc, char 
 		        "           %d free %s, "
 		        "%d free %s, "
 		        "%d used %s\n",
-		        i, EXT2_BLOCK_BITMAP(gdp),
-			EXT2_INODE_BITMAP(gdp),
-			EXT2_INODE_TABLE(gdp),
+		        i, EXT2_BLOCK_BITMAP(current_fs->super, gdp),
+			EXT2_INODE_BITMAP(current_fs->super, gdp),
+			EXT2_INODE_TABLE(current_fs->super, gdp),
 		        gdp->bg_free_blocks_count,
 		        gdp->bg_free_blocks_count != 1 ? "blocks" : "block",
 		        gdp->bg_free_inodes_count,
@@ -1714,13 +1714,15 @@ void do_imap(int argc, char *argv[])
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(current_fs->super)) *
 		EXT2_INODE_SIZE(current_fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(current_fs->super);
-	if (!EXT2_IS_USED_INODE_TABLE(&current_fs->group_desc[(unsigned)group])) {
+	if (!EXT2_IS_USED_INODE_TABLE(current_fs->super, 
+				      &current_fs->group_desc[(unsigned)group])) {
 		com_err(argv[0], 0, "Inode table for group %lu is missing\n",
 			group);
 		return;
 	}
 
-	block_nr = EXT2_INODE_TABLE(&current_fs->group_desc[(unsigned)group]) +
+	block_nr = EXT2_INODE_TABLE(current_fs->super, 
+				    &current_fs->group_desc[(unsigned)group]) +
 		block;
 	offset &= (EXT2_BLOCK_SIZE(current_fs->super) - 1);
 
Index: e2fsprogs-1.39/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39.orig/resize/resize2fs.c	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/resize/resize2fs.c	2006-09-25 13:22:27.000000000 +0200
@@ -53,9 +53,9 @@ static errcode_t ext2fs_calculate_summar
 /*
  * Some helper CPP macros
  */
-#define FS_BLOCK_BM(fs, i) ((fs)->group_desc[(i)].bg_block_bitmap)
-#define FS_INODE_BM(fs, i) ((fs)->group_desc[(i)].bg_inode_bitmap)
-#define FS_INODE_TB(fs, i) ((fs)->group_desc[(i)].bg_inode_table)
+#define FS_BLOCK_BM(fs, i) (EXT2_BLOCK_BITMAP((fs)->super, &(fs)->group_desc[(i)]))
+#define FS_INODE_BM(fs, i) (EXT2_INODE_BITMAP((fs)->super, &(fs)->group_desc[(i)]))
+#define FS_INODE_TB(fs, i) (EXT2_INODE_TABLE((fs)->super, &(fs)->group_desc[(i)]))
 
 #define IS_BLOCK_BM(fs, i, blk) ((blk) == FS_BLOCK_BM((fs),(i)))
 #define IS_INODE_BM(fs, i, blk) ((blk) == FS_INODE_BM((fs),(i)))
@@ -506,7 +506,8 @@ static errcode_t adjust_superblock(ext2_
 		 * Write out the new inode table
 		 */
 		retval = io_channel_write_blk(fs->io,
-					      EXT2_INODE_TABLE(&fs->group_desc[i]),
+					      EXT2_INODE_TABLE(fs->super,
+							       &fs->group_desc[i]),
 					      fs->inode_blocks_per_group,
 					      rfs->itable_buf);
 		if (retval) goto errout;
@@ -564,7 +565,7 @@ static errcode_t mark_table_blocks(ext2_
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
+		for (j = 0, b = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]);
 		     j < (unsigned int) fs->inode_blocks_per_group;
 		     j++, b++)
 			ext2fs_mark_block_bitmap(bmap, b);
@@ -573,13 +574,15 @@ static errcode_t mark_table_blocks(ext2_
 		 * Mark block used for the block bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
+					 EXT2_BLOCK_BITMAP(fs->super, 
+							   &fs->group_desc[i]));
 
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
 		ext2fs_mark_block_bitmap(bmap,
-					 EXT2_INODE_BITMAP(&fs->group_desc[i]));
+					 EXT2_INODE_BITMAP(fs->super,
+							   &fs->group_desc[i]));
 	}
 	return 0;
 }
@@ -604,13 +607,13 @@ static void mark_fs_metablock(ext2_resiz
 	 * mark it as a block to be moved.
 	 */
 	if (IS_BLOCK_BM(fs, group, blk)) {
-		FS_BLOCK_BM(fs, group) = 0;
+		EXT2_BLOCK_BITMAP_SET(fs->super, &fs->group_desc[group], 0ULL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_BM(fs, group, blk)) {
-		FS_INODE_BM(fs, group) = 0;
+		EXT2_INODE_BITMAP_SET(fs->super, &fs->group_desc[group], 0ULL);
 		rfs->needed_blocks++;
 	} else if (IS_INODE_TB(fs, group, blk)) {
-		FS_INODE_TB(fs, group) = 0;
+		EXT2_INODE_TABLE_SET(fs->super, &fs->group_desc[group], 0ULL);
 		rfs->needed_blocks++;
 	} else if (ext2fs_test_block_bitmap(rfs->old_fs->block_map, blk) &&
 		   !ext2fs_test_block_bitmap(meta_bmap, blk)) {
@@ -745,23 +748,23 @@ static errcode_t blocks_to_move(ext2_res
 						  group_blk + has_super);
 		}
 
-		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i]) &&
-		    EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i]) &&
-		    EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i]))
+		if (EXT2_IS_USED_INODE_TABLE(fs->super, &fs->group_desc[i]) &&
+		    EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[i]) &&
+		    EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[i]))
 			goto next_group;
 
 		/*
 		 * Reserve the existing meta blocks that we know
 		 * aren't to be moved.
 		 */
-		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i]))
+		if (EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[i]))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
-		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i]))
+				 EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]));
+		if (EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[i]))
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks,
-				 EXT2_INODE_BITMAP(&fs->group_desc[i]));
-		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i]))
-			for (blk = EXT2_INODE_TABLE(&fs->group_desc[i]), j=0;
+				 EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]));
+		if (EXT2_IS_USED_INODE_TABLE(fs->super, &fs->group_desc[i]))
+			for (blk = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]), j=0;
 			     j < fs->inode_blocks_per_group ; j++, blk++)
 				ext2fs_mark_block_bitmap(rfs->reserve_blocks,
 							 blk);
@@ -812,7 +815,7 @@ static errcode_t blocks_to_move(ext2_res
 		 * allocation bitmap, and move any blocks that might 
 		 * be necessary.
 		 */
-		for (blk = EXT2_INODE_TABLE(&fs->group_desc[i]), j=0;
+		for (blk = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++) {
 			ext2fs_mark_block_bitmap(fs->block_map, blk);
 			if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
@@ -825,7 +828,8 @@ static errcode_t blocks_to_move(ext2_res
 		 * Make sure the old inode table is reserved in the
 		 * block reservation bitmap.
 		 */
-		for (blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]), j=0;
+		for (blk = EXT2_INODE_TABLE(rfs->old_fs->super,
+					    &rfs->old_fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_mark_block_bitmap(rfs->reserve_blocks, blk);
 		
@@ -1403,8 +1407,8 @@ static errcode_t move_itables(ext2_resiz
 	 */
 	to_move = moved = 0;
 	for (i=0; i < max_groups; i++) {
-		if (EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]) !=
-		    EXT2_INODE_TABLE(&fs->group_desc[i]))
+		if (EXT2_INODE_TABLE(rfs->old_fs->super, &rfs->old_fs->group_desc[i]) !=
+		    EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]))
 			to_move++;
 	}
 
@@ -1421,8 +1425,10 @@ static errcode_t move_itables(ext2_resiz
 	rfs->old_fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
 
 	for (i=0; i < max_groups; i++) {
-		old_blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]);
-		new_blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
+		old_blk = EXT2_INODE_TABLE(rfs->old_fs->super, 
+					   &rfs->old_fs->group_desc[i]);
+		new_blk = EXT2_INODE_TABLE(fs->super,
+					   &fs->group_desc[i]);
 		diff = new_blk - old_blk;
 		
 #ifdef RESIZE2FS_DEBUG
@@ -1475,11 +1481,13 @@ static errcode_t move_itables(ext2_resiz
 				goto errout;
 		}
 
-		for (blk = EXT2_INODE_TABLE(&rfs->old_fs->group_desc[i]), j=0;
+		for (blk = EXT2_INODE_TABLE(rfs->old_fs->super,
+					    &rfs->old_fs->group_desc[i]), j=0;
 		     j < fs->inode_blocks_per_group ; j++, blk++)
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
-		EXT2_INODE_TABLE_SET(&rfs->old_fs->group_desc[i], new_blk);
+		EXT2_INODE_TABLE_SET(rfs->old_fs->super,
+				     &rfs->old_fs->group_desc[i], new_blk);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
Index: e2fsprogs-1.39/misc/dumpe2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/dumpe2fs.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/misc/dumpe2fs.c	2006-09-25 13:22:27.000000000 +0200
@@ -188,20 +188,20 @@ static void list_desc (ext2_filsys fs)
 		if (has_super)
 			fputc('\n', stdout);
 		fputs(_("  Block bitmap at "), stdout);
-		print_number(EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
-		diff = EXT2_BLOCK_BITMAP(&fs->group_desc[i]) - first_block;
+		print_number(EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]));
+		diff = EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_(", Inode bitmap at "), stdout);
-		print_number(EXT2_INODE_BITMAP(&fs->group_desc[i]));
-		diff = EXT2_INODE_BITMAP(&fs->group_desc[i]) - first_block;
+		print_number(EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]));
+		diff = EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
 		fputs(_("\n  Inode table at "), stdout);
-		print_range(EXT2_INODE_TABLE(&fs->group_desc[i]),
-			    EXT2_INODE_TABLE(&fs->group_desc[i]) +
+		print_range(EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]),
+			    EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) +
 			    inode_blocks_per_group - 1);
-		diff = EXT2_INODE_TABLE(&fs->group_desc[i]) - first_block;
+		diff = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
 		printf (_("\n  %d free blocks, %d free inodes, "
Index: e2fsprogs-1.39/e2fsck/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/swapfs.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/swapfs.c	2006-09-25 13:22:27.000000000 +0200
@@ -131,7 +131,7 @@ static void swap_inodes(e2fsck_t ctx)
 						    "block interate buffer");
 	for (group = 0; group < fs->group_desc_count; group++) {
 		retval = io_channel_read_blk(fs->io,
-		      EXT2_INODE_TABLE(&fs->group_desc[group]),
+		      EXT2_INODE_TABLE(fs->super, &fs->group_desc[group]),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
@@ -169,7 +169,7 @@ static void swap_inodes(e2fsck_t ctx)
 				ext2fs_swap_inode(fs, inode, inode, 1);
 		}
 		retval = io_channel_write_blk(fs->io,
-		      EXT2_INODE_TABLE(&fs->group_desc[group]),
+		      EXT2_INODE_TABLE(fs->super, &fs->group_desc[group]),
 		      fs->inode_blocks_per_group, buf);
 		if (retval) {
 			com_err("swap_inodes", retval,
Index: e2fsprogs-1.39/resize/main.c
===================================================================
--- e2fsprogs-1.39.orig/resize/main.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/resize/main.c	2006-09-25 13:22:27.000000000 +0200
@@ -106,11 +106,11 @@ static void determine_fs_stride(ext2_fil
 		has_sb = ext2fs_bg_has_super(fs, group);
 		if (group == 0 || has_sb != prev_has_sb)
 			goto next;
-		b_stride = EXT2_BLOCK_BITMAP(&fs->group_desc[group]) - 
-			EXT2_BLOCK_BITMAP(&fs->group_desc[group-1]) - 
+		b_stride = EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[group]) - 
+			EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[group-1]) - 
 			fs->super->s_blocks_per_group;
-		i_stride = EXT2_INODE_BITMAP(&fs->group_desc[group]) - 
-			EXT2_INODE_BITMAP(&fs->group_desc[group-1]) - 
+		i_stride = EXT2_INODE_BITMAP(fs->super, &fs->group_desc[group]) - 
+			EXT2_INODE_BITMAP(fs->super, &fs->group_desc[group-1]) - 
 			fs->super->s_blocks_per_group;
 		if (b_stride != i_stride ||
 		    b_stride < 0)
Index: e2fsprogs-1.39/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/mke2fs.c	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/misc/mke2fs.c	2006-09-25 13:22:27.000000000 +0200
@@ -419,7 +419,7 @@ static void write_inode_tables(ext2_fils
 	for (i = 0; i < fs->group_desc_count; i++) {
 		progress_update(&progress, i);
 		
-		blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
+		blk = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]);
 		num = fs->inode_blocks_per_group;
 
 		if (!(lazy_flag &&
Index: e2fsprogs-1.39/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/inode.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/inode.c	2006-09-25 13:22:27.000000000 +0200
@@ -142,7 +142,8 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 	scan->current_group = 0;
 	scan->groups_left = fs->group_desc_count - 1;
 	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks : 8;
-	scan->current_block = EXT2_INODE_TABLE(&scan->fs->group_desc[scan->current_group]);
+	scan->current_block = EXT2_INODE_TABLE(scan->fs->super,
+			      &scan->fs->group_desc[scan->current_group]);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	retval = ext2fs_get_mem((size_t) (scan->inode_buffer_blocks * 
@@ -220,7 +221,8 @@ static errcode_t get_next_blockgroup(ext
 	scan->current_group++;
 	scan->groups_left--;
 			
-	scan->current_block = EXT2_INODE_TABLE(&scan->fs->group_desc[scan->current_group]);
+	scan->current_block = EXT2_INODE_TABLE(scan->fs->super,
+			      &scan->fs->group_desc[scan->current_group]);
 
 	scan->current_inode = scan->current_group *
 		EXT2_INODES_PER_GROUP(scan->fs->super);
@@ -545,9 +547,11 @@ errcode_t ext2fs_read_inode_full(ext2_fi
 		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 			EXT2_INODE_SIZE(fs->super);
 		block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned)group]))
+		if (!EXT2_IS_USED_INODE_TABLE(fs->super, 
+					      &fs->group_desc[(unsigned)group]))
 			return EXT2_ET_MISSING_INODE_TABLE;
-		block_nr = EXT2_INODE_TABLE(&fs->group_desc[(unsigned)group]) +
+		block_nr = EXT2_INODE_TABLE(fs->super,
+					    &fs->group_desc[(unsigned)group]) +
 			block;
 		io = fs->io;
 	}
@@ -669,9 +673,11 @@ errcode_t ext2fs_write_inode_full(ext2_f
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-	if (!EXT2_IS_USED_INODE_TABLE(&fs->group_desc[(unsigned) group]))
+	if (!EXT2_IS_USED_INODE_TABLE(fs->super, 
+				      &fs->group_desc[(unsigned) group]))
 		return EXT2_ET_MISSING_INODE_TABLE;
-	block_nr = EXT2_INODE_TABLE(&fs->group_desc[(unsigned) group]) + block;
+	block_nr = EXT2_INODE_TABLE(fs->super,
+				    &fs->group_desc[(unsigned) group]) + block;
 
 	offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
 
Index: e2fsprogs-1.39/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1b.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1b.c	2006-09-25 13:22:27.000000000 +0200
@@ -802,15 +802,15 @@ static int check_if_fs_block(e2fsck_t ct
 		}
 		
 		/* Check the inode table */
-		if ((EXT2_INODE_TABLE(&fs->group_desc[i]) &&
-		    (test_block >= EXT2_INODE_TABLE(&fs->group_desc[i])) &&
-		    (test_block < (EXT2_INODE_TABLE(&fs->group_desc[i]) +
+		if ((EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) &&
+		    (test_block >= EXT2_INODE_TABLE(fs->super, &fs->group_desc[i])) &&
+		    (test_block < (EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) +
 				   fs->inode_blocks_per_group))))
 			return 1;
 
 		/* Check the bitmap blocks */
-		if ((test_block == EXT2_BLOCK_BITMAP(&fs->group_desc[i])) ||
-		    (test_block == EXT2_INODE_BITMAP(&fs->group_desc[i])))
+		if ((test_block == EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i])) ||
+		    (test_block == EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i])))
 			return 1;
 		
 		first_block += fs->super->s_blocks_per_group;
Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c	2006-09-25 13:22:19.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1.c	2006-09-25 13:22:27.000000000 +0200
@@ -2106,22 +2106,22 @@ static int process_bad_block(ext2_filsys
 			return 0;
 		}
 	skip_super:
-		if (blk == EXT2_BLOCK_BITMAP(&fs->group_desc[i])) {
+		if (blk == EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i])) {
 			if (fix_problem(ctx, PR_1_BB_BAD_BLOCK, pctx)) {
 				ctx->invalid_block_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if (blk == EXT2_INODE_BITMAP(&fs->group_desc[i])) {
+		if (blk == EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i])) {
 			if (fix_problem(ctx, PR_1_IB_BAD_BLOCK, pctx)) {
 				ctx->invalid_inode_bitmap_flag[i]++;
 				ctx->invalid_bitmaps++;
 			}
 			return 0;
 		}
-		if ((blk >= EXT2_INODE_TABLE(&fs->group_desc[i])) &&
-		    (blk < (EXT2_INODE_TABLE(&fs->group_desc[i]) +
+		if ((blk >= EXT2_INODE_TABLE(fs->super, &fs->group_desc[i])) &&
+		    (blk < (EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]) +
 			    fs->inode_blocks_per_group))) {
 			/*
 			 * If there are bad blocks in the inode table,
@@ -2233,22 +2233,22 @@ static void handle_fs_bad_blocks(e2fsck_
 		first_block = ext2fs_group_first_block(fs, i);
 
 		if (ctx->invalid_block_bitmap_flag[i]) {
-			blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
+			blk = EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("block bitmap"),
 					1, &blk);
-			EXT2_BLOCK_BITMAP_SET(&fs->group_desc[i], blk);
+			EXT2_BLOCK_BITMAP_SET(fs->super, &fs->group_desc[i], blk);
 		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
-			blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
+			blk = EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
 					1, &blk);
-			EXT2_INODE_BITMAP_SET(&fs->group_desc[i], blk);
+			EXT2_INODE_BITMAP_SET(fs->super, &fs->group_desc[i], blk);
 		}
 		if (ctx->invalid_inode_table_flag[i]) {
-			blk = EXT2_INODE_TABLE(&fs->group_desc[i]);
+			blk = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]);
 			new_table_block(ctx, first_block, i, _("inode table"),
 					fs->inode_blocks_per_group, &blk);
-			EXT2_INODE_TABLE_SET(&fs->group_desc[i], blk);
+			EXT2_INODE_TABLE_SET(fs->super, &fs->group_desc[i], blk);
 			ctx->flags |= E2F_FLAG_RESTART;
 		}
 	}
@@ -2277,8 +2277,8 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i])) {
-			for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
+		if (EXT2_IS_USED_INODE_TABLE(fs->super, &fs->group_desc[i])) {
+			for (j = 0, b = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]);
 			     j < fs->inode_blocks_per_group;
 			     j++, b++) {
 				if (ext2fs_test_block_bitmap(ctx->block_found_map,
@@ -2299,34 +2299,40 @@ static void mark_table_blocks(e2fsck_t c
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
+		if (EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[i])) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     EXT2_BLOCK_BITMAP(&fs->group_desc[i]))) {
-				pctx.blk = EXT2_BLOCK_BITMAP(&fs->group_desc[i]);
+				     EXT2_BLOCK_BITMAP(fs->super, 
+						       &fs->group_desc[i]))) {
+				pctx.blk = EXT2_BLOCK_BITMAP(fs->super, 
+							     &fs->group_desc[i]);
 				if (fix_problem(ctx, PR_1_BB_CONFLICT, &pctx)) {
 					ctx->invalid_block_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				}
 			} else {
-			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				      EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
+				ext2fs_mark_block_bitmap(ctx->block_found_map,
+				    EXT2_BLOCK_BITMAP(fs->super,
+				        &fs->group_desc[i]));
 		    }
 			
 		}
+		
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
+		if (EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[i])) {
 			if (ext2fs_test_block_bitmap(ctx->block_found_map,
-				     EXT2_INODE_BITMAP(&fs->group_desc[i]))) {
-				pctx.blk = EXT2_INODE_BITMAP(&fs->group_desc[i]);
+				     EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]))) {
+				pctx.blk = EXT2_INODE_BITMAP(fs->super, 
+							     &fs->group_desc[i]);
 				if (fix_problem(ctx, PR_1_IB_CONFLICT, &pctx)) {
 					ctx->invalid_inode_bitmap_flag[i]++;
 					ctx->invalid_bitmaps++;
 				} 
 			} else {
-			    ext2fs_mark_block_bitmap(ctx->block_found_map,
-				     EXT2_INODE_BITMAP(&fs->group_desc[i]));
+				ext2fs_mark_block_bitmap(ctx->block_found_map,
+				    EXT2_INODE_BITMAP(fs->super, 
+				        &fs->group_desc[i]));
 			}
 		}
 	}
Index: e2fsprogs-1.39/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/super.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/super.c	2006-09-25 13:22:27.000000000 +0200
@@ -574,34 +574,34 @@ void check_super_block(e2fsck_t ctx)
 		first_block = ext2fs_group_first_block(fs, i);
 		last_block = ext2fs_group_last_block(fs, i);
 
-		if ((EXT2_BLOCK_BITMAP(gd) < first_block) ||
-		    (EXT2_BLOCK_BITMAP(gd) > last_block)) {
-			pctx.blk = EXT2_BLOCK_BITMAP(gd);
+		if ((EXT2_BLOCK_BITMAP(fs->super, gd) < first_block) ||
+		    (EXT2_BLOCK_BITMAP(fs->super, gd) > last_block)) {
+			pctx.blk = EXT2_BLOCK_BITMAP(fs->super, gd);
 			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
-				EXT2_BLOCK_BITMAP_SET(gd, 0ULL);
+				EXT2_BLOCK_BITMAP_SET(fs->super, gd, 0ULL);
 		}
-		if (!EXT2_IS_USED_BLOCK_BITMAP(gd)) {
+		if (!EXT2_IS_USED_BLOCK_BITMAP(fs->super, gd)) {
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((EXT2_INODE_BITMAP(gd) < first_block) ||
-		    (EXT2_INODE_BITMAP(gd) > last_block)) {
-			pctx.blk = EXT2_INODE_BITMAP(gd);
+		if ((EXT2_INODE_BITMAP(fs->super, gd) < first_block) ||
+		    (EXT2_INODE_BITMAP(fs->super, gd) > last_block)) {
+			pctx.blk = EXT2_INODE_BITMAP(fs->super, gd);
 			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
-				EXT2_INODE_BITMAP_SET(gd, 0ULL);
+				EXT2_INODE_BITMAP_SET(fs->super, gd, 0ULL);
 		}
-		if (!EXT2_IS_USED_INODE_BITMAP(gd)) {
+		if (!EXT2_IS_USED_INODE_BITMAP(fs->super, gd)) {
 			ctx->invalid_inode_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		if ((EXT2_INODE_TABLE(gd) < first_block) ||
-		    ((EXT2_INODE_TABLE(gd) +
+		if ((EXT2_INODE_TABLE(fs->super, gd) < first_block) ||
+		    ((EXT2_INODE_TABLE(fs->super, gd) +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
-			pctx.blk = EXT2_INODE_TABLE(gd);
+			pctx.blk = EXT2_INODE_TABLE(fs->super, gd);
 			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
-				EXT2_INODE_TABLE_SET(gd, 0ULL);
+				EXT2_INODE_TABLE_SET(fs->super, gd, 0ULL);
 		}
-		if (!EXT2_IS_USED_INODE_TABLE(gd)) {
+		if (!EXT2_IS_USED_INODE_TABLE(fs->super, gd)) {
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
Index: e2fsprogs-1.39/misc/e2image.c
===================================================================
--- e2fsprogs-1.39.orig/misc/e2image.c	2006-09-25 13:00:26.000000000 +0200
+++ e2fsprogs-1.39/misc/e2image.c	2006-09-25 13:22:27.000000000 +0200
@@ -265,8 +265,8 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark the blocks used for the inode table
 		 */
-		if (EXT2_IS_USED_INODE_TABLE(&fs->group_desc[i])) {
-			for (j = 0, b = EXT2_INODE_TABLE(&fs->group_desc[i]);
+		if (EXT2_IS_USED_INODE_TABLE(fs->super, &fs->group_desc[i])) {
+			for (j = 0, b = EXT2_INODE_TABLE(fs->super, &fs->group_desc[i]);
 			     j < (unsigned) fs->inode_blocks_per_group;
 			     j++, b++)
 				ext2fs_mark_block_bitmap(meta_block_map, b);
@@ -275,17 +275,17 @@ static void mark_table_blocks(ext2_filsy
 		/*
 		 * Mark block used for the block bitmap 
 		 */
-		if (EXT2_IS_USED_BLOCK_BITMAP(&fs->group_desc[i])) {
+		if (EXT2_IS_USED_BLOCK_BITMAP(fs->super, &fs->group_desc[i])) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				     EXT2_BLOCK_BITMAP(&fs->group_desc[i]));
+				     EXT2_BLOCK_BITMAP(fs->super, &fs->group_desc[i]));
 		}
 		
 		/*
 		 * Mark block used for the inode bitmap 
 		 */
-		if (EXT2_IS_USED_INODE_BITMAP(&fs->group_desc[i])) {
+		if (EXT2_IS_USED_INODE_BITMAP(fs->super, &fs->group_desc[i])) {
 			ext2fs_mark_block_bitmap(meta_block_map,
-				 EXT2_INODE_BITMAP(&fs->group_desc[i]));
+				 EXT2_INODE_BITMAP(fs->super, &fs->group_desc[i]));
 		}
 	}
 }
Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h	2006-09-25 13:22:27.000000000 +0200
@@ -956,7 +956,8 @@ extern errcode_t ext2fs_copy_bitmap(ext2
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, 
 				 int has_header);
 extern void ext2fs_swap_super(struct ext2_super_block * super);
-extern void ext2fs_swap_group_desc(struct ext2_group_desc *gdp);
+extern void ext2fs_swap_group_desc(struct ext2_super_block *sb,
+				   struct ext2_group_desc *gdp);
 extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 				   struct ext2_inode_large *f, int hostorder,
 				   int bufsize);
Index: e2fsprogs-1.39/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/openfs.c	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/openfs.c	2006-09-25 13:22:27.000000000 +0200
@@ -293,7 +293,7 @@ errcode_t ext2fs_open2(const char *name,
 			memcpy(gdp, shadow_block + j * fs->desc_size, fs->desc_size);
 #ifdef EXT2FS_ENABLE_SWAPFS
 			if (fs->flags & EXT2_FLAG_SWAP_BYTES)
-					ext2fs_swap_group_desc(gdp);
+					ext2fs_swap_group_desc(fs->super, gdp);
 #endif
 			gdp++;
 		}
Index: e2fsprogs-1.39/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/closefs.c	2006-09-25 13:22:21.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/closefs.c	2006-09-25 13:22:27.000000000 +0200
@@ -235,7 +235,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 		memcpy(gd, &fs->group_desc[i], fs->desc_size);
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if (fs->flags & EXT2_FLAG_SWAP_BYTES)
-			ext2fs_swap_group_desc(gd);
+			ext2fs_swap_group_desc(fs->super, gd);
 #endif
 	}
 
