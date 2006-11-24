From: Valerie Clement <Valerie.Clement@bull.net>
Subject: [RFC][PATCH 3/4] BIG_BG: larger inode bitmaps
Date: 24 Nov 2006 17:48:34 +0100
Message-ID: <1164386913.17961.77.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:31151 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S934973AbWKXQ6Q
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Nov 2006 11:58:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id E5DF819D934
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:11 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21071-07 for <linux-ext4@vger.kernel.org>;
 Fri, 24 Nov 2006 17:58:06 +0100 (CET)
Received: from ckrm.frec.bull.fr (unknown [172.16.109.44])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 51DB919D931
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:06 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch does the same thing for the inodes, so that the inode bitmaps can be also stored on several blocks.


Signed-off-by: Valerie Clement <valerie.clement@bull.net>

 ialloc.c |   62 ++++++++++++++++++++++++++++++++++++++++----------------------
 inode.c  |    7 +++++--
 2 files changed, 45 insertions(+), 24 deletions(-)

Index: linux-2.6.19-rc6/fs/ext4/inode.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/inode.c	2006-11-17 12:13:49.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/inode.c	2006-11-17 12:14:11.000000000 +0100
@@ -2498,7 +2498,6 @@ static int __ext4_get_inode_loc(struct i
 				EXT4_INODE_SIZE(inode->i_sb);
 			inode_offset = ((inode->i_ino - 1) %
 					EXT4_INODES_PER_GROUP(inode->i_sb));
-			start = inode_offset & ~(inodes_per_buffer - 1);
 
 			/* Is the inode bitmap in cache? */
 			desc = ext4_get_group_desc(inode->i_sb,
@@ -2507,7 +2506,9 @@ static int __ext4_get_inode_loc(struct i
 				goto make_io;
 
 			bitmap_bh = sb_getblk(inode->i_sb,
-				ext4_inode_bitmap(inode->i_sb, desc));
+				ext4_inode_bitmap(inode->i_sb, desc)
+				+ (inode_offset >>
+				   EXT4_BITS_PER_BLOCK_BITS(inode->i_sb)));
 			if (!bitmap_bh)
 				goto make_io;
 
@@ -2520,6 +2521,8 @@ static int __ext4_get_inode_loc(struct i
 				brelse(bitmap_bh);
 				goto make_io;
 			}
+			inode_offset &= (EXT4_BITS_PER_BLOCK(inode->i_sb) - 1);
+			start = inode_offset & ~(inodes_per_buffer - 1);
 			for (i = start; i < start + inodes_per_buffer; i++) {
 				if (i == inode_offset)
 					continue;
Index: linux-2.6.19-rc6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/ialloc.c	2006-11-17 12:13:49.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/ialloc.c	2006-11-17 12:14:11.000000000 +0100
@@ -51,7 +51,8 @@
  * Return buffer_head of bitmap on success or NULL.
  */
 static struct buffer_head *
-read_inode_bitmap(struct super_block * sb, unsigned long block_group)
+read_inode_bitmap(struct super_block * sb, unsigned long block_group,
+		  unsigned int bitmap_block)
 {
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
@@ -60,12 +61,13 @@ read_inode_bitmap(struct super_block * s
 	if (!desc)
 		goto error_out;
 
-	bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
+	bh = sb_bread(sb, ext4_inode_bitmap(sb, desc) + bitmap_block);
 	if (!bh)
 		ext4_error(sb, "read_inode_bitmap",
-			    "Cannot read inode bitmap - "
-			    "block_group = %lu, inode_bitmap = %llu",
-			    block_group, ext4_inode_bitmap(sb, desc));
+			   "Cannot read inode bitmap - "
+			   "block_group = %lu, inode_bitmap = %llu",
+			   block_group,
+			   ext4_inode_bitmap(sb, desc) + bitmap_block);
 error_out:
 	return bh;
 }
@@ -141,9 +143,11 @@ void ext4_free_inode (handle_t *handle, 
 	}
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = read_inode_bitmap(sb, block_group);
+	bitmap_bh = read_inode_bitmap(sb, block_group,
+					bit >> EXT4_BITS_PER_BLOCK_BITS(sb));
 	if (!bitmap_bh)
 		goto error_return;
+	bit &= (EXT4_BITS_PER_BLOCK(sb) - 1);
 
 	BUFFER_TRACE(bitmap_bh, "get_write_access");
 	fatal = ext4_journal_get_write_access(handle, bitmap_bh);
@@ -439,6 +443,7 @@ struct inode *ext4_new_inode(handle_t *h
 	int err = 0;
 	struct inode *ret;
 	int i;
+	unsigned long bitmap_block, bit;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -470,18 +475,22 @@ struct inode *ext4_new_inode(handle_t *h
 		gdp = ext4_get_group_desc(sb, group, &bh2);
 		if (!gdp)
 			goto fail;
+		ino = 0;
+
+repeat_in_this_group:
+		bitmap_block = ino >> EXT4_BITS_PER_BLOCK_BITS(sb);
+		bit = ino & (EXT4_BITS_PER_BLOCK(sb) - 1);
 
+		err = -EIO;
 		brelse(bitmap_bh);
-		bitmap_bh = read_inode_bitmap(sb, group);
+		bitmap_bh = read_inode_bitmap(sb, group, bitmap_block);
 		if (!bitmap_bh)
 			goto fail;
 
-		ino = 0;
-
-repeat_in_this_group:
-		ino = ext4_find_next_zero_bit((unsigned long *)
-				bitmap_bh->b_data, EXT4_INODES_PER_GROUP(sb), ino);
-		if (ino < EXT4_INODES_PER_GROUP(sb)) {
+repeat_in_this_bitmap:
+		bit = ext4_find_next_zero_bit((unsigned long *)
+				bitmap_bh->b_data, EXT4_BITS_PER_BLOCK(sb), bit);
+		if (bit < EXT4_BITS_PER_BLOCK(sb)) {
 
 			BUFFER_TRACE(bitmap_bh, "get_write_access");
 			err = ext4_journal_get_write_access(handle, bitmap_bh);
@@ -489,7 +498,7 @@ repeat_in_this_group:
 				goto fail;
 
 			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
-						ino, bitmap_bh->b_data)) {
+						bit, bitmap_bh->b_data)) {
 				/* we won it */
 				BUFFER_TRACE(bitmap_bh,
 					"call ext4_journal_dirty_metadata");
@@ -497,15 +506,19 @@ repeat_in_this_group:
 								bitmap_bh);
 				if (err)
 					goto fail;
+				ino = (bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb)) + bit;
 				goto got;
 			}
 			/* we lost it */
 			jbd2_journal_release_buffer(handle, bitmap_bh);
 
-			if (++ino < EXT4_INODES_PER_GROUP(sb))
-				goto repeat_in_this_group;
+			if (++bit < EXT4_BITS_PER_BLOCK(sb))
+				goto repeat_in_this_bitmap;
 		}
 
+		ino = (bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb)) + bit;
+		if (ino < EXT4_INODES_PER_GROUP(sb))
+			goto repeat_in_this_group;
 		/*
 		 * This case is possible in concurrent environment.  It is very
 		 * rare.  We cannot repeat the find_group_xxx() call because
@@ -671,12 +684,14 @@ struct inode *ext4_orphan_get(struct sup
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
-	bitmap_bh = read_inode_bitmap(sb, block_group);
+	bitmap_bh = read_inode_bitmap(sb, block_group,
+					bit >> EXT4_BITS_PER_BLOCK_BITS(sb));
 	if (!bitmap_bh) {
 		ext4_warning(sb, __FUNCTION__,
 			     "inode bitmap error for orphan %lu", ino);
 		goto out;
 	}
+	bit &= (EXT4_BITS_PER_BLOCK(sb) - 1);
 
 	/* Having the inode bit set should be a 100% indicator that this
 	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
@@ -715,6 +730,7 @@ unsigned long ext4_count_free_inodes (st
 	struct ext4_group_desc *gdp;
 	int i;
 #ifdef EXT4FS_DEBUG
+	int j;
 	struct ext4_super_block *es;
 	unsigned long bitmap_count, x;
 	struct buffer_head *bitmap_bh = NULL;
@@ -728,12 +744,14 @@ unsigned long ext4_count_free_inodes (st
 		if (!gdp)
 			continue;
 		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
-		brelse(bitmap_bh);
-		bitmap_bh = read_inode_bitmap(sb, i);
-		if (!bitmap_bh)
-			continue;
+		for (j = 0, x = 0; j < EXT4_INODE_BITMAP_PER_GROUP(sb); j++) {
+			brelse(bitmap_bh);
+			bitmap_bh = read_inode_bitmap(sb, i, j);
+			if (!bitmap_bh)
+				continue;
 
-		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
+			x += ext4_count_free(bitmap_bh, EXT4_INODE_BITMAP_NBYTES(sb));
+		}
 		printk("group %d: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_inodes_count), x);
 		bitmap_count += x;
