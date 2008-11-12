From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 17/17] Convert to 64-bit IO
Date: Tue, 11 Nov 2008 19:43:10 -0800
Message-ID: <1226461390-5502-18-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
 <1226461390-5502-15-git-send-email-vaurora@redhat.com>
 <1226461390-5502-16-git-send-email-vaurora@redhat.com>
 <1226461390-5502-17-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42478 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbYKLDoJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:09 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i9qc007483
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:09 -0500
In-Reply-To: <1226461390-5502-17-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/ehandler.c       |    6 +++---
 e2fsck/journal.c        |    4 ++--
 e2fsck/pass1.c          |    8 ++++----
 e2fsck/pass1b.c         |    4 ++--
 e2fsck/pass3.c          |    2 +-
 e2fsck/super.c          |    6 +++---
 e2fsck/util.c           |    4 ++--
 lib/ext2fs/bmove.c      |    2 +-
 lib/ext2fs/closefs.c    |    8 ++++----
 lib/ext2fs/dirblock.c   |    2 +-
 lib/ext2fs/extent.c     |    7 ++++---
 lib/ext2fs/inode.c      |    8 ++++----
 lib/ext2fs/mkjournal.c  |    7 ++++---
 lib/ext2fs/openfs.c     |    2 +-
 lib/ext2fs/rw_bitmaps.c |   10 +++++-----
 15 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/e2fsck/ehandler.c b/e2fsck/ehandler.c
index 7bae4ab..8add25f 100644
--- a/e2fsck/ehandler.c
+++ b/e2fsck/ehandler.c
@@ -42,7 +42,7 @@ static errcode_t e2fsck_handle_read_error(io_channel channel,
 	if (count > 1) {
 		p = (char *) data;
 		for (i=0; i < count; i++, p += channel->block_size, block++) {
-			error = io_channel_read_blk(channel, block,
+			error = io_channel_read_blk64(channel, block,
 						    1, p);
 			if (error)
 				return error;
@@ -58,7 +58,7 @@ static errcode_t e2fsck_handle_read_error(io_channel channel,
 	preenhalt(ctx);
 	if (ask(ctx, _("Ignore error"), 1)) {
 		if (ask(ctx, _("Force rewrite"), 1))
-			io_channel_write_blk(channel, block, 1, data);
+			io_channel_write_blk64(channel, block, 1, data);
 		return 0;
 	}
 
@@ -88,7 +88,7 @@ static errcode_t e2fsck_handle_write_error(io_channel channel,
 	if (count > 1) {
 		p = (const char *) data;
 		for (i=0; i < count; i++, p += channel->block_size, block++) {
-			error = io_channel_write_blk(channel, block,
+			error = io_channel_write_blk64(channel, block,
 						     1, p);
 			if (error)
 				return error;
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 660b6ca..9897ee2 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -113,7 +113,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
 		if (rw == READ && !bh->b_uptodate) {
 			jfs_debug(3, "reading block %lu/%p\n",
 				  (unsigned long) bh->b_blocknr, (void *) bh);
-			retval = io_channel_read_blk(bh->b_io,
+			retval = io_channel_read_blk64(bh->b_io,
 						     bh->b_blocknr,
 						     1, bh->b_data);
 			if (retval) {
@@ -127,7 +127,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
 		} else if (rw == WRITE && bh->b_dirty) {
 			jfs_debug(3, "writing block %lu/%p\n",
 				  (unsigned long) bh->b_blocknr, (void *) bh);
-			retval = io_channel_write_blk(bh->b_io,
+			retval = io_channel_write_blk64(bh->b_io,
 						      bh->b_blocknr,
 						      1, bh->b_data);
 			if (retval) {
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2d29988..4f69d46 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -211,7 +211,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 			if (inode->i_block[i])
 				return 0;
 
-		if (io_channel_read_blk(fs->io, inode->i_block[0], 1, buf))
+		if (io_channel_read_blk64(fs->io, inode->i_block[0], 1, buf))
 			return 0;
 
 		len = strnlen(buf, fs->blocksize);
@@ -1564,7 +1564,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 			return 0;
 	}
 
-	retval = io_channel_read_blk(fs->io, blk, 1, block_buf);
+	retval = io_channel_read_blk64(fs->io, blk, 1, block_buf);
 	if (retval && fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
 		return 1;
 
@@ -2386,7 +2386,7 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
 		pctx.blk = i;
 		ext2fs_mark_block_bitmap2(ctx->block_found_map, (*new_block)+i);
 		if (old_block) {
-			pctx.errcode = io_channel_read_blk(fs->io,
+			pctx.errcode = io_channel_read_blk64(fs->io,
 				   old_block + i, 1, buf);
 			if (pctx.errcode)
 				fix_problem(ctx, PR_1_RELOC_READ_ERR, &pctx);
@@ -2394,7 +2394,7 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
 			memset(buf, 0, fs->blocksize);
 
 		pctx.blk = (*new_block) + i;
-		pctx.errcode = io_channel_write_blk(fs->io, pctx.blk,
+		pctx.errcode = io_channel_write_blk64(fs->io, pctx.blk,
 					      1, buf);
 		if (pctx.errcode)
 			fix_problem(ctx, PR_1_RELOC_WRITE_ERR, &pctx);
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 8fbdfcd..0d5ce5d 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -684,13 +684,13 @@ static int clone_file_block(ext2_filsys fs,
 			printf("Cloning block %u to %u\n", *block_nr,
 			       new_block);
 #endif
-			retval = io_channel_read_blk(fs->io, *block_nr, 1,
+			retval = io_channel_read_blk64(fs->io, *block_nr, 1,
 						     cs->buf);
 			if (retval) {
 				cs->errcode = retval;
 				return BLOCK_ABORT;
 			}
-			retval = io_channel_write_blk(fs->io, new_block, 1,
+			retval = io_channel_write_blk64(fs->io, new_block, 1,
 						      cs->buf);
 			if (retval) {
 				cs->errcode = retval;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index e81575f..5929430 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -743,7 +743,7 @@ static int expand_dir_proc(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		memset(block, 0, fs->blocksize);
-		retval = io_channel_write_blk(fs->io, new_blk, 1, block);
+		retval = io_channel_write_blk64(fs->io, new_blk, 1, block);
 	}
 	if (retval) {
 		es->err = retval;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index b7415e4..ff102eb 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -103,7 +103,7 @@ static int release_inode_block(ext2_filsys fs,
 			int	i, limit;
 			blk_t	*bp;
 
-			pb->errcode = io_channel_read_blk(fs->io, blk, 1,
+			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
 							pb->buf);
 			if (pb->errcode)
 				goto return_abort;
@@ -125,13 +125,13 @@ static int release_inode_block(ext2_filsys fs,
 		 * it here.
 		 */
 		if ((blockcnt == pb->truncate_block) && pb->truncate_offset) {
-			pb->errcode = io_channel_read_blk(fs->io, blk, 1,
+			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
 							pb->buf);
 			if (pb->errcode)
 				goto return_abort;
 			memset(pb->buf + pb->truncate_offset, 0,
 			       fs->blocksize - pb->truncate_offset);
-			pb->errcode = io_channel_write_blk(fs->io, blk, 1,
+			pb->errcode = io_channel_write_blk64(fs->io, blk, 1,
 							 pb->buf);
 			if (pb->errcode)
 				goto return_abort;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 256100c..be46fd3 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -482,7 +482,7 @@ blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
 		if (blocksize == 1024)
 			superblock++;
 		io_channel_set_blksize(io, blocksize);
-		if (io_channel_read_blk(io, superblock,
+		if (io_channel_read_blk64(io, superblock,
 					-SUPERBLOCK_SIZE, buf))
 			continue;
 #ifdef WORDS_BIGENDIAN
@@ -582,7 +582,7 @@ errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 		count = num - j;
 		if (count > STRIDE_LENGTH)
 			count = STRIDE_LENGTH;
-		retval = io_channel_write_blk(fs->io, blk, count, buf);
+		retval = io_channel_write_blk64(fs->io, blk, count, buf);
 		if (retval) {
 			if (ret_count)
 				*ret_count = count;
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index 32fbbcb..61629ea 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -59,7 +59,7 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 		} while (ext2fs_test_block_bitmap2(pb->reserve, block) ||
 			 ext2fs_test_block_bitmap2(pb->alloc_map, block));
 
-		retval = io_channel_read_blk(fs->io, orig, 1, pb->buf);
+		retval = io_channel_read_blk64(fs->io, orig, 1, pb->buf);
 		if (retval) {
 			pb->error = retval;
 			return BLOCK_ABORT;
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index b5b32b2..2cf38ee 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -194,7 +194,7 @@ static errcode_t write_primary_superblock(ext2_filsys fs,
 
 	if (!fs->io->manager->write_byte || !fs->orig_super) {
 		io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);
-		retval = io_channel_write_blk(fs->io, 1, -SUPERBLOCK_SIZE,
+		retval = io_channel_write_blk64(fs->io, 1, -SUPERBLOCK_SIZE,
 					      super);
 		io_channel_set_blksize(fs->io, fs->blocksize);
 		return retval;
@@ -257,7 +257,7 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 	fs->super->s_block_group_nr = sgrp;
 #endif
 
-	return io_channel_write_blk(fs->io, group_block, -SUPERBLOCK_SIZE,
+	return io_channel_write_blk64(fs->io, group_block, -SUPERBLOCK_SIZE,
 				    super_shadow);
 }
 
@@ -353,7 +353,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 			continue;
 		if ((old_desc_blk) &&
 		    (!(fs->flags & EXT2_FLAG_MASTER_SB_ONLY) || (i == 0))) {
-			retval = io_channel_write_blk(fs->io,
+			retval = io_channel_write_blk64(fs->io,
 			      old_desc_blk, old_desc_blocks, group_ptr);
 			if (retval)
 				goto errout;
@@ -361,7 +361,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 		if (new_desc_blk) {
 			int meta_bg = i / EXT2_DESC_PER_BLOCK(fs->super);
 
-			retval = io_channel_write_blk(fs->io, new_desc_blk,
+			retval = io_channel_write_blk64(fs->io, new_desc_blk,
 				1, group_ptr + (meta_bg*fs->blocksize));
 			if (retval)
 				goto errout;
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index c81d7fd..888cf45 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -108,7 +108,7 @@ errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 	ext2fs_free_mem(&buf);
 	return retval;
 #else
- 	return io_channel_write_blk(fs->io, block, 1, (char *) inbuf);
+	return io_channel_write_blk64(fs->io, block, 1, (char *) inbuf);
 #endif
 }
 
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 929e5cd..63b752f 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -431,7 +431,7 @@ retry:
 		    (handle->fs->io != handle->fs->image_io))
 			memset(newpath->buf, 0, handle->fs->blocksize);
 		else {
-			retval = io_channel_read_blk(handle->fs->io,
+			retval = io_channel_read_blk64(handle->fs->io,
 						     blk, 1, newpath->buf);
 			if (retval)
 				return retval;
@@ -539,7 +539,7 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
 			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
 
-		retval = io_channel_write_blk(handle->fs->io,
+		retval = io_channel_write_blk64(handle->fs->io,
 				      blk, 1, handle->path[handle->level].buf);
 	}
 	return retval;
@@ -929,7 +929,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 	new_node_start = ext2fs_le32_to_cpu(EXT_FIRST_INDEX(neweh)->ei_block);
 
 	/* ...and write the new node block out to disk. */
-	retval = io_channel_write_blk(handle->fs->io, new_node_pblk, 1, block_buf);
+	retval = io_channel_write_blk64(handle->fs->io, new_node_pblk, 1,
+					block_buf);
 
 	if (retval)
 		goto done;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index cdfa19b..f963159 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -365,7 +365,7 @@ static errcode_t get_next_blocks(ext2_inode_scan scan)
 		memset(scan->inode_buffer, 0,
 		       (size_t) num_blocks * scan->fs->blocksize);
 	} else {
-		retval = io_channel_read_blk(scan->fs->io,
+		retval = io_channel_read_blk64(scan->fs->io,
 					     scan->current_block,
 					     (int) num_blocks,
 					     scan->inode_buffer);
@@ -586,7 +586,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			clen = fs->blocksize - offset;
 
 		if (block_nr != fs->icache->buffer_blk) {
-			retval = io_channel_read_blk(io, block_nr, 1,
+			retval = io_channel_read_blk64(io, block_nr, 1,
 						     fs->icache->buffer);
 			if (retval)
 				return retval;
@@ -706,7 +706,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			clen = fs->blocksize - offset;
 
 		if (fs->icache->buffer_blk != block_nr) {
-			retval = io_channel_read_blk(fs->io, block_nr, 1,
+			retval = io_channel_read_blk64(fs->io, block_nr, 1,
 						     fs->icache->buffer);
 			if (retval)
 				goto errout;
@@ -717,7 +717,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		memcpy((char *) fs->icache->buffer + (unsigned) offset,
 		       ptr, clen);
 
-		retval = io_channel_write_blk(fs->io, block_nr, 1,
+		retval = io_channel_write_blk64(fs->io, block_nr, 1,
 					      fs->icache->buffer);
 		if (retval)
 			goto errout;
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 5222fd1..19b099a 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -243,7 +243,7 @@ static int mkjournal_proc(ext2_filsys	fs,
 	es->newblocks++;
 	retval = 0;
 	if (blockcnt <= 0)
-		retval = io_channel_write_blk(fs->io, new_blk, 1, es->buf);
+		retval = io_channel_write_blk64(fs->io, new_blk, 1, es->buf);
 	else {
 		if (es->zero_count) {
 			if ((es->blk_to_zero + es->zero_count == new_blk) &&
@@ -423,7 +423,8 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	start = 1;
 	if (journal_dev->blocksize == 1024)
 		start++;
-	if ((retval = io_channel_read_blk(journal_dev->io, start, -1024, buf)))
+	if ((retval = io_channel_read_blk64(journal_dev->io, start, -1024,
+					    buf)))
 		return retval;
 
 	jsb = (journal_superblock_t *) buf;
@@ -448,7 +449,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	}
 
 	/* Writeback the journal superblock */
-	if ((retval = io_channel_write_blk(journal_dev->io, start, -1024, buf)))
+	if ((retval = io_channel_write_blk64(journal_dev->io, start, -1024, buf)))
 		return retval;
 
 	fs->super->s_journal_inum = 0;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index c1617f3..b00380a 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -300,7 +300,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
 	for (i=0 ; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc(fs, group_block, i);
-		retval = io_channel_read_blk(fs->io, blk, 1, dest);
+		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
 		if (retval)
 			goto cleanup;
 #ifdef WORDS_BIGENDIAN
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index ff56dcd..a7c4c25 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -113,7 +113,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
-			retval = io_channel_write_blk(fs->io, blk, 1,
+			retval = io_channel_write_blk64(fs->io, blk, 1,
 						      inode_buf);
 			if (retval)
 				return EXT2_ET_INODE_BITMAP_WRITE;
@@ -195,7 +195,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		blk = (fs->image_header->offset_inodemap / fs->blocksize);
 		ino_cnt = fs->super->s_inodes_count;
 		while (inode_nbytes > 0) {
-			retval = io_channel_read_blk(fs->image_io, blk++,
+			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, inode_bitmap);
 			if (retval)
 				goto cleanup;
@@ -215,7 +215,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		blk_cnt = EXT2_BLOCKS_PER_GROUP(fs->super) *
 			fs->group_desc_count;
 		while (block_nbytes > 0) {
-			retval = io_channel_read_blk(fs->image_io, blk++,
+			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, block_bitmap);
 			if (retval)
 				goto cleanup;
@@ -241,7 +241,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			    ext2fs_group_desc_csum_verify(fs, i))
 				blk = 0;
 			if (blk) {
-				retval = io_channel_read_blk(fs->io, blk,
+				retval = io_channel_read_blk64(fs->io, blk,
 					     -block_nbytes, block_bitmap);
 				if (retval) {
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
@@ -263,7 +263,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			    ext2fs_group_desc_csum_verify(fs, i))
 				blk = 0;
 			if (blk) {
-				retval = io_channel_read_blk(fs->io, blk,
+				retval = io_channel_read_blk64(fs->io, blk,
 					     -inode_nbytes, inode_bitmap);
 				if (retval) {
 					retval = EXT2_ET_INODE_BITMAP_READ;
-- 
1.5.6.5

