From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Use preallocation when reading from the inode table
Date: Mon, 22 Sep 2008 20:35:23 -0400
Message-ID: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53048 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427AbYIWAf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 20:35:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


With modern hard drives, reading 64k takes roughly the same time as
reading a 4k block.  So request adjacent inode table blocks to reduce
the time it takes when iterating over directories (especially when doing
this in htree sort order) in a cold cache case.  With this patch, the
time it takes to run "git status" on a kernel tree after flushing the
caches via "echo 3 > /proc/sys/vm/drop_caches", is reduced by 21%.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
----

Note: this patch could work for ext3 as well.  Anyone see any downsides?
A 20% improvement seems too easy...  I guess it does increase what we
hold in the buffer cache by a small amount, but once the inodes are
cached, we'll stop needing to do any I/O, and we only try to do the
readahead when we know that we need to do some I/O anyway.

This patch also eliminates ext4_get_inode_block(), since it's a static
function which is only called once, and we needed access to the block
group descriptor, so it simplified the code to move the code into
__ext4_get_inode_loc().  The interesting bits are in the very last hunk
of the patch.


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index eed1265..9f6c10e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3833,41 +3833,6 @@ out_stop:
 	ext4_journal_stop(handle);
 }
 
-static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
-		unsigned long ino, struct ext4_iloc *iloc)
-{
-	ext4_group_t block_group;
-	unsigned long offset;
-	ext4_fsblk_t block;
-	struct ext4_group_desc *gdp;
-
-	if (!ext4_valid_inum(sb, ino)) {
-		/*
-		 * This error is already checked for in namei.c unless we are
-		 * looking at an NFS filehandle, in which case no error
-		 * report is needed
-		 */
-		return 0;
-	}
-
-	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
-	gdp = ext4_get_group_desc(sb, block_group, NULL);
-	if (!gdp)
-		return 0;
-
-	/*
-	 * Figure out the offset within the block group inode table
-	 */
-	offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
-		EXT4_INODE_SIZE(sb);
-	block = ext4_inode_table(sb, gdp) +
-		(offset >> EXT4_BLOCK_SIZE_BITS(sb));
-
-	iloc->block_group = block_group;
-	iloc->offset = offset & (EXT4_BLOCK_SIZE(sb) - 1);
-	return block;
-}
-
 /*
  * ext4_get_inode_loc returns with an extra refcount against the inode's
  * underlying buffer_head on success. If 'in_mem' is true, we have all
@@ -3877,13 +3842,30 @@ static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
 static int __ext4_get_inode_loc(struct inode *inode,
 				struct ext4_iloc *iloc, int in_mem)
 {
+	struct ext4_group_desc *gdp;
 	ext4_fsblk_t block;
 	struct buffer_head *bh;
 
-	block = ext4_get_inode_block(inode->i_sb, inode->i_ino, iloc);
-	if (!block)
+	iloc->bh = 0;
+	if (!ext4_valid_inum(inode->i_sb, inode->i_ino))
 		return -EIO;
 
+	iloc->block_group = (inode->i_ino - 1) / 
+		EXT4_INODES_PER_GROUP(inode->i_sb);
+	gdp = ext4_get_group_desc(inode->i_sb, iloc->block_group, NULL);
+	if (!gdp)
+		return -EIO;
+
+	/*
+	 * Figure out the offset within the block group inode table
+	 */
+	iloc->offset = ((inode->i_ino - 1) % 
+			EXT4_INODES_PER_GROUP(inode->i_sb)) *
+		EXT4_INODE_SIZE(inode->i_sb);
+	block = ext4_inode_table(inode->i_sb, gdp) +
+		(iloc->offset >> EXT4_BLOCK_SIZE_BITS(inode->i_sb));
+	iloc->offset = iloc->offset & (EXT4_BLOCK_SIZE(inode->i_sb) - 1);
+
 	bh = sb_getblk(inode->i_sb, block);
 	if (!bh) {
 		ext4_error (inode->i_sb, "ext4_get_inode_loc",
@@ -3969,6 +3951,31 @@ static int __ext4_get_inode_loc(struct inode *inode,
 
 make_io:
 		/*
+		 * If we need to do any I/O, try to readahead up to 16
+		 * blocks from the inode table.
+		 */
+		{
+			ext4_fsblk_t b, end, table;
+			unsigned num;
+
+			table = ext4_inode_table(inode->i_sb, gdp);
+			b = block & ~15;
+			if (table > b)
+				b = table;
+			end = b+16;
+			num = EXT4_INODES_PER_GROUP(inode->i_sb);
+			if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, 
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+				num -= le16_to_cpu(gdp->bg_itable_unused);
+			table += num / (EXT4_BLOCK_SIZE(inode->i_sb) /
+					EXT4_INODE_SIZE(inode->i_sb));
+			if (end > table)
+				end = table;
+			while (b <= end)
+				sb_breadahead(inode->i_sb, b++);
+		}
+
+		/*
 		 * There are other valid inodes in the buffer, this inode
 		 * has in-inode xattrs, or we don't have this inode in memory.
 		 * Read the block from disk.
