From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 29/74] libext2fs: fix memory leaks
Date: Tue, 10 Dec 2013 17:21:34 -0800
Message-ID: <20131211012134.30655.87393.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42861 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3LKBVk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:40 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/gen_bitmap64.c |    2 ++
 lib/ext2fs/mkjournal.c    |   13 ++++++++-----
 lib/ext2fs/newdir.c       |    8 ++++++--
 lib/ext2fs/qcow2.c        |   14 ++++++++++----
 4 files changed, 26 insertions(+), 11 deletions(-)


diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 2880afa..36e0240 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -128,6 +128,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	if (gettimeofday(&bitmap->stats.created,
 			 (struct timezone *) NULL) == -1) {
 		perror("gettimeofday");
+		ext2fs_free_mem(&bitmap);
 		return 1;
 	}
 	bitmap->stats.type = type;
@@ -300,6 +301,7 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 	if (gettimeofday(&new_bmap->stats.created,
 			 (struct timezone *) NULL) == -1) {
 		perror("gettimeofday");
+		ext2fs_free_mem(&new_bmap);
 		return 1;
 	}
 	new_bmap->stats.type = src->stats.type;
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 1d5b1a7..09ca412 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -312,13 +312,15 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 		return retval;
 
 	if ((retval = ext2fs_read_bitmaps(fs)))
-		return retval;
+		goto out2;
 
 	if ((retval = ext2fs_read_inode(fs, journal_ino, &inode)))
-		return retval;
+		goto out2;
 
-	if (inode.i_blocks > 0)
-		return EEXIST;
+	if (inode.i_blocks > 0) {
+		retval = EEXIST;
+		goto out2;
+	}
 
 	es.num_blocks = num_blocks;
 	es.newblocks = 0;
@@ -330,7 +332,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
 		inode.i_flags |= EXT4_EXTENTS_FL;
 		if ((retval = ext2fs_write_inode(fs, journal_ino, &inode)))
-			return retval;
+			goto out2;
 	}
 
 	/*
@@ -398,6 +400,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 
 errout:
 	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
+out2:
 	ext2fs_free_mem(&buf);
 	return retval;
 }
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index d134bdf..44e4ca9 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -50,8 +50,10 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	retval = ext2fs_set_rec_len(fs, fs->blocksize - csum_size, dir);
-	if (retval)
+	if (retval) {
+		ext2fs_free_mem(&buf);
 		return retval;
+	}
 
 	if (dir_ino) {
 		if (fs->super->s_feature_incompat &
@@ -72,8 +74,10 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		 */
 		dir = (struct ext2_dir_entry *) (buf + dir->rec_len);
 		retval = ext2fs_set_rec_len(fs, rec_len, dir);
-		if (retval)
+		if (retval) {
+			ext2fs_free_mem(&buf);
 			return retval;
+		}
 		dir->inode = parent_ino;
 		ext2fs_dirent_set_name_len(dir, 2);
 		ext2fs_dirent_set_file_type(dir, filetype);
diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
index 8394270..547edc0 100644
--- a/lib/ext2fs/qcow2.c
+++ b/lib/ext2fs/qcow2.c
@@ -60,8 +60,10 @@ struct ext2_qcow2_hdr *qcow2_read_header(int fd)
 		return NULL;
 	memset(buffer, 0, sizeof(struct ext2_qcow2_hdr));
 
-	if (ext2fs_llseek(fd, 0, SEEK_SET < 0))
+	if (ext2fs_llseek(fd, 0, SEEK_SET < 0)) {
+		ext2fs_free_mem(&buffer);
 		return NULL;
+	}
 
 	size = read(fd, buffer, sizeof(struct ext2_qcow2_hdr));
 	if (size != sizeof(struct ext2_qcow2_hdr)) {
@@ -91,8 +93,10 @@ static int qcow2_read_l1_table(struct ext2_qcow2_image *img)
 	if (ret)
 		return ret;
 
-	if (ext2fs_llseek(fd, img->l1_offset, SEEK_SET) < 0)
+	if (ext2fs_llseek(fd, img->l1_offset, SEEK_SET) < 0) {
+		ext2fs_free_mem(&table);
 		return errno;
+	}
 
 	size = read(fd, table, l1_size);
 	if (size != l1_size) {
@@ -236,8 +240,10 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
 
 	((char *)copy_buf)[0] = 0;
 	size = write(raw_fd, copy_buf, 1);
-	if (size != 1)
-		return errno;
+	if (size != 1) {
+		ret = errno;
+		goto out;
+	}
 
 out:
 	if (copy_buf)

