From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] resize2fs: move a cluster at a time with bigalloc file systems
Date: Sun, 20 Jan 2013 00:35:25 -0500
Message-ID: <1358660125-19027-3-git-send-email-tytso@mit.edu>
References: <20130120052744.GC9874@thunk.org>
 <1358660125-19027-1-git-send-email-tytso@mit.edu>
Cc: jon@severinsson.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44384 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3ATFf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2013 00:35:27 -0500
In-Reply-To: <1358660125-19027-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 6885aeb..c9458ea 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1178,8 +1178,9 @@ static errcode_t block_mover(ext2_resize_t rfs)
 	 */
 	to_move = moved = 0;
 	init_block_alloc(rfs);
-	for (blk = old_fs->super->s_first_data_block;
-	     blk < ext2fs_blocks_count(old_fs->super); blk++) {
+	for (blk = B2C(old_fs->super->s_first_data_block);
+	     blk < ext2fs_blocks_count(old_fs->super);
+	     blk += EXT2FS_CLUSTER_RATIO(fs)) {
 		if (!ext2fs_test_block_bitmap2(old_fs->block_map, blk))
 			continue;
 		if (!ext2fs_test_block_bitmap2(rfs->move_blocks, blk))
@@ -1196,7 +1197,7 @@ static errcode_t block_mover(ext2_resize_t rfs)
 			goto errout;
 		}
 		ext2fs_block_alloc_stats2(fs, new_blk, +1);
-		ext2fs_add_extent_entry(rfs->bmap, blk, new_blk);
+		ext2fs_add_extent_entry(rfs->bmap, B2C(blk), B2C(new_blk));
 		to_move++;
 	}
 
@@ -1226,6 +1227,9 @@ static errcode_t block_mover(ext2_resize_t rfs)
 		if (retval) goto errout;
 		if (!size)
 			break;
+		old_blk = C2B(old_blk);
+		new_blk = C2B(new_blk);
+		size = C2B(size);
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_BMOVE)
 			printf("Moving %llu blocks %llu->%llu\n",
@@ -1276,6 +1280,20 @@ errout:
  */
 
 
+/*
+ * The extent translation table is stored in clusters so we need to
+ * take special care when mapping a source block number to its
+ * destination block number.
+ */
+__u64 extent_translate(ext2_filsys fs, ext2_extent extent, __u64 old_loc)
+{
+	__u64 new_block = C2B(ext2fs_extent_translate(extent, B2C(old_loc)));
+
+	if (new_block != 0)
+		new_block += old_loc & (EXT2FS_CLUSTER_RATIO(fs) - 1);
+	return new_block;
+}
+
 struct process_block_struct {
 	ext2_resize_t 		rfs;
 	ext2_ino_t		ino;
@@ -1298,7 +1316,7 @@ static int process_block(ext2_filsys fs, blk64_t	*block_nr,
 	pb = (struct process_block_struct *) priv_data;
 	block = *block_nr;
 	if (pb->rfs->bmap) {
-		new_block = ext2fs_extent_translate(pb->rfs->bmap, block);
+		new_block = extent_translate(fs, pb->rfs->bmap, block);
 		if (new_block) {
 			*block_nr = new_block;
 			ret |= BLOCK_CHANGED;
@@ -1424,7 +1442,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		pb.changed = 0;
 
 		if (ext2fs_file_acl_block(rfs->old_fs, inode) && rfs->bmap) {
-			new_block = ext2fs_extent_translate(rfs->bmap,
+			new_block = extent_translate(rfs->old_fs, rfs->bmap,
 				ext2fs_file_acl_block(rfs->old_fs, inode));
 			if (new_block) {
 				ext2fs_file_acl_block_set(rfs->old_fs, inode,
-- 
1.7.12.rc0.22.gcdd159b

