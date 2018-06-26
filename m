From: GaoMing <gaoming20@huawei.com>
Subject: [PATCH] ext4: e2fsprogs: fix inode bitmap num not integer,incompatible for ancient android devices
Date: Tue, 26 Jun 2018 19:54:06 +0800
Message-ID: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <sorp.liqingchao@huawei.com>,
        <harry.shen@huawei.com>, <miaoxie@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

for example, 1708 inodes every group,3 block groups, bitmap bytes are 1708/8=213.5 when the inode bitmap has some errors, e2fsprogs cannot fix it

Signed-off-by: GaoMing <gaoming20@huawei.com>
---
 e2fsck/pass5.c          |  9 ++++-----
 lib/ext2fs/imager.c     | 35 +++++++++++++++++++++++++++--------
 lib/ext2fs/rw_bitmaps.c | 39 ++++++++++++++++++++++++++++-----------
 misc/dumpe2fs.c         |  4 ++--
 4 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 7803e8b..4970dae 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -95,7 +95,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	if (ext2fs_test_ib_dirty(ctx->fs))
 		return;
 
-	nbytes = (size_t)(EXT2_INODES_PER_GROUP(ctx->fs->super) / 8);
+	nbytes = (size_t)((EXT2_INODES_PER_GROUP(ctx->fs->super)+7) / 8);
 	retval = ext2fs_get_mem(ctx->fs->blocksize, &buf);
 	if (retval) {
 		com_err(ctx->program_name, 0, "%s",
@@ -108,14 +108,13 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 		if (ext2fs_bg_flags_test(ctx->fs, i, EXT2_BG_INODE_UNINIT))
 			continue;
 
-		ino_itr = 1 + (i * (nbytes << 3));
+		ino_itr = 1 + (i * EXT2_INODES_PER_GROUP(ctx->fs->super));
 		retval = ext2fs_get_inode_bitmap_range2(ctx->fs->inode_map,
-							ino_itr, nbytes << 3,
+							ino_itr, EXT2_INODES_PER_GROUP(ctx->fs->super),
 							buf);
 		if (retval)
 			break;
-
-		if (ext2fs_inode_bitmap_csum_verify(ctx->fs, i, buf, nbytes))
+		if (ext2fs_inode_bitmap_csum_verify(ctx->fs, i, buf, EXT2_INODES_PER_GROUP(ctx->fs->super) / 8))
 			continue;
 		pctx.group = i;
 		if (!fix_problem(ctx, PR_5_INODE_BITMAP_CSUM_INVALID, &pctx))
diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
index 7fd06f7..346ec70 100644
--- a/lib/ext2fs/imager.c
+++ b/lib/ext2fs/imager.c
@@ -341,7 +341,8 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		bmap = fs->inode_map;
 		itr = 1;
 		cnt = EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count;
-		size = (EXT2_INODES_PER_GROUP(fs->super) / 8);
+		size = ((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
+		total_size = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count+7)/8;
 	} else {
 		if (!fs->block_map) {
 			retval = ext2fs_read_block_bitmap(fs);
@@ -352,13 +353,14 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		itr = fs->super->s_first_data_block;
 		cnt = EXT2_GROUPS_TO_CLUSTERS(fs->super, fs->group_desc_count);
 		size = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
+		total_size = size * fs->group_desc_count;
 	}
-	total_size = size * fs->group_desc_count;
+
 
 	while (cnt > 0) {
 		size = sizeof(buf);
-		if (size > (cnt >> 3))
-			size = (cnt >> 3);
+		if (size > ((cnt+7) >> 3))
+			size = ((cnt+7) >> 3);
 
 		retval = ext2fs_get_generic_bmap_range(bmap, itr,
 						       size << 3, buf);
@@ -372,7 +374,10 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 			return EXT2_ET_SHORT_READ;
 
 		itr += size << 3;
-		cnt -= size << 3;
+		if (cnt < (size << 3))
+			cnt = 0;
+		else
+			cnt -= size << 3;
 	}
 
 	size = total_size % fs->blocksize;
@@ -406,6 +411,7 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 	char			buf[1024];
 	unsigned int		size;
 	ssize_t			actual;
+	__u64			count, pos;
 
 	if (flags & IMAGER_FLAG_INODEMAP) {
 		if (!fs->inode_map) {
@@ -431,8 +437,8 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 
 	while (cnt > 0) {
 		size = sizeof(buf);
-		if (size > (cnt >> 3))
-			size = (cnt >> 3);
+		if (size > ((cnt+7) >> 3))
+			size = ((cnt+7) >> 3);
 
 		actual = read(fd, buf, size);
 		if (actual == -1)
@@ -440,13 +446,26 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 		if (actual != (int) size)
 			return EXT2_ET_SHORT_READ;
 
+		if (cnt%8 != 0 && cnt < sizeof(buf)) {
+			pos = cnt;
+			count = (((cnt + 7)>>3)<<3)-cnt;
+			while (count > 0) {
+				ext2fs_fast_clear_bit(pos, buf);
+				pos++;
+				count--;
+			}
+		}
+
 		retval = ext2fs_set_generic_bmap_range(bmap, itr,
 						       size << 3, buf);
 		if (retval)
 			return retval;
 
 		itr += size << 3;
-		cnt -= size << 3;
+		if (cnt < (size << 3))
+			cnt = 0;
+		else
+			cnt -= size << 3;
 	}
 	return 0;
 }
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index e86bacd..e2499ff 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -40,6 +40,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	blk64_t		blk;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	ext2_ino_t	ino_itr = 1;
+	__u64 count, pos;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -115,19 +116,25 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (csum_flag && ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT)
 		    )
 			goto skip_this_inode_bitmap;
-
 		retval = ext2fs_get_inode_bitmap_range2(fs->inode_map,
-				ino_itr, inode_nbytes << 3, inode_buf);
+				ino_itr, EXT2_INODES_PER_GROUP(fs->super), inode_buf);
 		if (retval)
 			goto errout;
-
 		retval = ext2fs_inode_bitmap_csum_set(fs, i, inode_buf,
-						      inode_nbytes);
+						      EXT2_INODES_PER_GROUP(fs->super) / 8);
 		if (retval)
 			goto errout;
+		if (EXT2_INODES_PER_GROUP(fs->super)%8 != 0) {
+			pos = EXT2_INODES_PER_GROUP(fs->super);
+			count = (((pos + 7) >> 3)<<3)-pos;
+			while (count > 0) {
+				ext2fs_fast_set_bit(pos, inode_buf);
+				pos++;
+				count--;
+			}
+		}
 		ext2fs_group_desc_csum_set(fs, i);
 		fs->flags |= EXT2_FLAG_DIRTY;
-
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
@@ -138,7 +145,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			}
 		}
 	skip_this_inode_bitmap:
-		ino_itr += inode_nbytes << 3;
+		ino_itr += EXT2_INODES_PER_GROUP(fs->super);
 
 	}
 	if (do_block) {
@@ -202,7 +209,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	char *buf;
 	errcode_t retval;
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
+	int inode_nbytes = (EXT2_INODES_PER_GROUP(fs->super) + 7) / 8;
 	int csum_flag;
 	unsigned int	cnt;
 	blk64_t	blk;
@@ -210,6 +217,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	blk64_t   blk_cnt;
 	ext2_ino_t ino_itr = 1;
 	ext2_ino_t ino_cnt;
+	__u64 count, pos;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -337,24 +345,33 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_INODE_BITMAP_READ;
 					goto cleanup;
 				}
-
+				if (EXT2_INODES_PER_GROUP(fs->super)%8 != 0) {
+					pos = EXT2_INODES_PER_GROUP(fs->super);
+					count = (((pos + 7) >> 3)<<3)-pos;
+					while (count > 0) {
+						ext2fs_fast_clear_bit(pos, inode_bitmap);
+						pos++;
+						count--;
+					}
+				}
 				/* verify inode bitmap checksum */
 				if (!(fs->flags &
 				      EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
 				    !ext2fs_inode_bitmap_csum_verify(fs, i,
-						inode_bitmap, inode_nbytes)) {
+						inode_bitmap,
+						EXT2_INODES_PER_GROUP(fs->super) / 8)) {
 					retval =
 					EXT2_ET_INODE_BITMAP_CSUM_INVALID;
 					goto cleanup;
 				}
 			} else
 				memset(inode_bitmap, 0, inode_nbytes);
-			cnt = inode_nbytes << 3;
+			cnt = EXT2_INODES_PER_GROUP(fs->super);
 			retval = ext2fs_set_inode_bitmap_range2(fs->inode_map,
 					       ino_itr, cnt, inode_bitmap);
 			if (retval)
 				goto cleanup;
-			ino_itr += inode_nbytes << 3;
+			ino_itr += EXT2_INODES_PER_GROUP(fs->super);
 		}
 	}
 
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 395ea9e..5cf431a 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -168,7 +168,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 		units = _("clusters");
 
 	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
-	inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
+	inode_nbytes = (EXT2_INODES_PER_GROUP(fs->super)+7) / 8;
 
 	if (fs->block_map)
 		block_bitmap = malloc(block_nbytes);
@@ -303,7 +303,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 		if (inode_bitmap) {
 			fputs(_("  Free inodes: "), stdout);
 			retval = ext2fs_get_inode_bitmap_range2(fs->inode_map,
-				 ino_itr, inode_nbytes << 3, inode_bitmap);
+				 ino_itr, EXT2_INODES_PER_GROUP(fs->super), inode_bitmap);
 			if (retval)
 				com_err("list_desc", retval,
 					"while reading inode bitmap");
-- 
2.8.1
