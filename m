From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/28] ext4: Add block validity check when truncating indirect block mapped inodes
Date: Tue,  2 Mar 2010 13:18:20 -0500
Message-ID: <1267553925-6308-4-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43041 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0CBSSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:54 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add checks to ext4_free_branches() to make sure a block number found
in an indirect block are valid before trying to free it.  If a bad
block number is found, stop freeing the indirect block immediately,
since the file system is corrupt and we will need to run fsck anyway.
This also avoids spamming the logs, and specifically avoids
driver-level "attempt to access beyond end of device" errors obscure
what is really going on.

If you get *really*, *really*, *really* unlucky, without this patch, a
supposed indirect block containing garbage might contain a reference
to a primary block group descriptor, in which case
ext4_free_branches() could end up zero'ing out a block group
descriptor block, and if then one of the block bitmaps for a block
group described by that bg descriptor block is not in memory, and is
read in by ext4_read_block_bitmap().  This function calls
ext4_valid_block_bitmap(), which assumes that bg_inode_table() was
validated at mount time and hasn't been modified since.  Since this
assumption is no longer valid, it's possible for the value
(ext4_inode_table(sb, desc) - group_first_block) to go negative, which
will cause ext4_find_next_zero_bit() to trigger a kernel GPF.

Addresses-Google-Bug: #2220436

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |   39 ++++++++++++++++++++++++++++++---------
 fs/ext4/mballoc.c |    7 ++++---
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 602d5ad..307ecd1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -377,6 +377,7 @@ struct ext4_new_group_data {
  */
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
+#define EXT4_FREE_BLOCKS_VALIDATED	0x0004
 
 /*
  * ioctl commands
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2059c34..3e8afd9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4130,18 +4130,27 @@ no_top:
  * We release `count' blocks on disk, but (last - first) may be greater
  * than `count' because there can be holes in there.
  */
-static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
-			      struct buffer_head *bh,
-			      ext4_fsblk_t block_to_free,
-			      unsigned long count, __le32 *first,
-			      __le32 *last)
+static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
+			     struct buffer_head *bh,
+			     ext4_fsblk_t block_to_free,
+			     unsigned long count, __le32 *first,
+			     __le32 *last)
 {
 	__le32 *p;
-	int	flags = EXT4_FREE_BLOCKS_FORGET;
+	int	flags = EXT4_FREE_BLOCKS_FORGET | EXT4_FREE_BLOCKS_VALIDATED;
 
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		flags |= EXT4_FREE_BLOCKS_METADATA;
 
+	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), block_to_free,
+				   count)) {
+		ext4_error(inode->i_sb, __func__, "inode #%lu: "
+			   "attempt to clear blocks %llu len %lu, invalid",
+			   inode->i_ino, (unsigned long long) block_to_free,
+			   count);
+		return 1;
+	}
+
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
@@ -4160,6 +4169,7 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		*p = 0;
 
 	ext4_free_blocks(handle, inode, 0, block_to_free, count, flags);
+	return 0;
 }
 
 /**
@@ -4215,9 +4225,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 			} else if (nr == block_to_free + count) {
 				count++;
 			} else {
-				ext4_clear_blocks(handle, inode, this_bh,
-						  block_to_free,
-						  count, block_to_free_p, p);
+				if (ext4_clear_blocks(handle, inode, this_bh,
+						      block_to_free, count,
+						      block_to_free_p, p))
+					break;
 				block_to_free = nr;
 				block_to_free_p = p;
 				count = 1;
@@ -4281,6 +4292,16 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			if (!nr)
 				continue;		/* A hole */
 
+			if (!ext4_data_block_valid(EXT4_SB(inode->i_sb),
+						   nr, 1)) {
+				ext4_error(inode->i_sb, __func__,
+					   "indirect mapped block in inode "
+					   "#%lu invalid (level %d, blk #%lu)",
+					   inode->i_ino, depth,
+					   (unsigned long) nr);
+				break;
+			}
+
 			/* Go read the buffer for the next level down */
 			bh = sb_bread(inode->i_sb, nr);
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..d129c10 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4476,10 +4476,11 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 	es = EXT4_SB(sb)->s_es;
-	if (!ext4_data_block_valid(sbi, block, count)) {
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_data_block_valid(sbi, block, count)) {
 		ext4_error(sb, __func__,
-			    "Freeing blocks not in datazone - "
-			    "block = %llu, count = %lu", block, count);
+			   "Freeing blocks not in datazone - "
+			   "block = %llu, count = %lu", block, count);
 		goto error_return;
 	}
 
-- 
1.6.6.1.1.g974db.dirty

