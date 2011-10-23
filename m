From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 7/8] e2fsprogs: add exclude bitmap support in e2image
Date: Sun, 23 Oct 2011 15:21:27 +0800
Message-ID: <1319354488-6050-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1JWJLI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:11:08 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:11:08 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is a feature needed by ext4 snapshot.  This patch
Adds exclude bitmap support in e2image.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 lib/ext2fs/e2image.h    |    1 +
 lib/ext2fs/ext2fs.h     |    1 +
 lib/ext2fs/imager.c     |   22 ++++++++++++++++++++++
 lib/ext2fs/rw_bitmaps.c |   16 ++++++++++++++++
 misc/e2image.c          |   22 ++++++++++++++++++++++
 5 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
index c918529..61d7ff9 100644
--- a/lib/ext2fs/e2image.h
+++ b/lib/ext2fs/e2image.h
@@ -41,6 +41,7 @@ struct ext2_image_hdr {
 	__u32	offset_super;	/* Byte offset of the sb and descriptors */
 	__u32	offset_inode;	/* Byte offset of the inode table  */
 	__u32	offset_inodemap; /* Byte offset of the inode bitmaps */
+	__u32	offset_excludemap; /* Byte offset of the exclude bitmaps */
 	__u32	offset_blockmap; /* Byte offset of the inode bitmaps */
 	__u32	offset_reserved[8];
 };
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d1f0d98..dab5ad7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -526,6 +526,7 @@ typedef struct ext2_icount *ext2_icount_t;
  */
 #define IMAGER_FLAG_INODEMAP	1
 #define IMAGER_FLAG_SPARSEWRITE	2
+#define IMAGER_FLAG_EXCLUDEMAP	3
 
 /*
  * For checking structure magic numbers...
diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
index a0fb81e..c6b5af2 100644
--- a/lib/ext2fs/imager.c
+++ b/lib/ext2fs/imager.c
@@ -296,6 +296,17 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		itr = 1;
 		cnt = EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count;
 		size = (EXT2_INODES_PER_GROUP(fs->super) / 8);
+	} else if (flags & IMAGER_FLAG_EXCLUDEMAP) {
+		if (!fs->exclude_map) {
+			retval = ext2fs_read_exclude_bitmap(fs);
+			if (retval)
+				return retval;
+		}
+		bmap = fs->exclude_map;
+		err = EXT2_ET_MAGIC_EXCLUDE_BITMAP;
+		itr = fs->super->s_first_data_block;
+		cnt = EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count;
+		size = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
 	} else {
 		if (!fs->block_map) {
 			retval = ext2fs_read_block_bitmap(fs);
@@ -373,6 +384,17 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 		itr = 1;
 		cnt = EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count;
 		size = (EXT2_INODES_PER_GROUP(fs->super) / 8);
+	} else if (flags & IMAGER_FLAG_EXCLUDEMAP) {
+		if (!fs->exclude_map) {
+			retval = ext2fs_read_exclude_bitmap(fs);
+			if (retval)
+				return retval;
+		}
+		bmap = fs->exclude_map;
+		err = EXT2_ET_MAGIC_EXCLUDE_BITMAP;
+		itr = fs->super->s_first_data_block;
+		cnt = EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count;
+		size = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
 	} else {
 		if (!fs->block_map) {
 			retval = ext2fs_read_block_bitmap(fs);
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 3126733..6c8179b 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -274,6 +274,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block,
 	ext2fs_free_mem(&buf);
 
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE) {
+		blk64_t	exclude_blk;
 		blk = (fs->image_header->offset_inodemap / fs->blocksize);
 		ino_cnt = fs->super->s_inodes_count;
 		while (inode_nbytes > 0) {
@@ -294,10 +295,25 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block,
 		}
 		blk = (fs->image_header->offset_blockmap /
 		       fs->blocksize);
+		exclude_blk = (fs->image_header->offset_excludemap /
+			       fs->blocksize);
 		blk_cnt = (blk64_t)EXT2_CLUSTERS_PER_GROUP(fs->super) *
 			fs->group_desc_count;
 		while (block_nbytes > 0) {
 			if (do_exclude) {
+				retval = io_channel_read_blk64(fs->image_io,
+					    exclude_blk++, 1, exclude_bitmap);
+				if (retval)
+					goto cleanup;
+				cnt = fs->blocksize << 3;
+				if (cnt > blk_cnt)
+					cnt = blk_cnt;
+				retval = ext2fs_set_exclude_bitmap_range2(
+					       fs->exclude_map,
+					       blk_itr, cnt, exclude_bitmap);
+				if (retval)
+					goto cleanup;
+
 				retval = EXT2_ET_EXCLUDE_BITMAP_READ;
 				goto cleanup;
 			}
diff --git a/misc/e2image.c b/misc/e2image.c
index 4cd834a..44a602c 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -187,6 +187,18 @@ static void write_image_file(ext2_filsys fs, int fd)
 		exit(1);
 	}
 
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+					EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+		hdr.offset_excludemap = lseek(fd, 0, SEEK_CUR);
+		retval = ext2fs_image_bitmap_write(fs, fd,
+						   IMAGER_FLAG_EXCLUDEMAP);
+		if (retval) {
+			com_err(program_name, retval, _("while writing "
+							"exclude bitmap"));
+			exit(1);
+		}
+	}
+
 	hdr.offset_inodemap = ext2fs_llseek(fd, 0, SEEK_CUR);
 	retval = ext2fs_image_bitmap_write(fs, fd, IMAGER_FLAG_INODEMAP);
 	if (retval) {
@@ -359,6 +371,16 @@ static void mark_table_blocks(ext2_filsys fs)
 		}
 
 		/*
+		 * Mark block used for the exclude bitmap
+		 */
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+					EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    ext2fs_exclude_bitmap_loc(fs, i)) {
+			ext2fs_mark_block_bitmap2(meta_block_map,
+				     ext2fs_exclude_bitmap_loc(fs, i));
+		}
+
+		/*
 		 * Mark block used for the inode bitmap
 		 */
 		if (ext2fs_inode_bitmap_loc(fs, i)) {
-- 
1.7.5.1

