From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v5 1/2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Mon,  5 Aug 2013 13:43:39 +0800
Message-ID: <1375681420-15384-2-git-send-email-wenqing.lz@taobao.com>
References: <1375681420-15384-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42791 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HEFnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 01:43:37 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so2849038pad.8
        for <linux-ext4@vger.kernel.org>; Sun, 04 Aug 2013 22:43:36 -0700 (PDT)
In-Reply-To: <1375681420-15384-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ext2fs_file_llseek is extented to introduce SEEK_DATA/HOLE.  In *_data()
function it will find the next data, and in *_hole() function it will find the
next hole.  A new error code called EXT2_ET_SEEK_BEYOND_EOF is define to
indicate that the offset is beyond the end of file.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2_err.et.in |    3 +
 lib/ext2fs/ext2fs.h       |    2 +
 lib/ext2fs/fileio.c       |  197 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 201 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index d20c6b7..6e79b97 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
 ec	EXT2_ET_FILE_EXISTS,
 	"Ext2 file already exists"
 
+ec	EXT2_ET_SEEK_BEYOND_EOF,
+	"lseek beyond the EOF"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 311ceda..2a9ddbb 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -160,6 +160,8 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_SEEK_SET	0
 #define EXT2_SEEK_CUR	1
 #define EXT2_SEEK_END	2
+#define EXT2_SEEK_DATA	3
+#define EXT2_SEEK_HOLE	4
 
 /*
  * Flags for the ext2_filsys structure and for ext2fs_open()
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..6cb2e43 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -312,10 +312,201 @@ fail:
 	return retval;
 }
 
+static errcode_t ext2fs_file_llseek_data_ext(ext2_file_t file, __u64 offset)
+{
+	ext2_extent_handle_t	handle = 0;
+	struct ext2fs_extent	extent;
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval = 0;
+	unsigned int	dataoff;
+
+	retval = ext2fs_extent_open2(fs, file->ino, &file->inode, &handle);
+	if (retval)
+		return retval;
+
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_extent_goto(handle, file->blockno);
+		if (retval && retval != EXT2_ET_EXTENT_NOT_FOUND)
+			goto done;
+		if (retval == EXT2_ET_EXTENT_NOT_FOUND) {
+			file->blockno++;
+		} else {
+			retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+						   &extent);
+			if (retval)
+				goto done;
+			/*
+			 * Here we skip uninit block because uninit block is
+			 * as a hole.
+			 */
+			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT) {
+				file->blockno++;
+				continue;
+			}
+			dataoff = file->blockno - extent.e_lblk;
+			if (file->blockno >= extent.e_lblk &&
+			    dataoff <= extent.e_len) {
+				if (file->blockno == offset / fs->blocksize)
+					file->pos = offset;
+				else
+					file->pos = file->blockno *
+						    fs->blocksize;
+				break;
+			}
+		}
+	}
+
+done:
+	ext2fs_extent_free(handle);
+	return retval;
+}
+
+static errcode_t ext2fs_file_llseek_data_ind(ext2_file_t file, __u64 offset)
+{
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval = 0;
+
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode, BMAP_BUFFER,
+				      0, file->blockno, 0, &file->physblock);
+		if (retval)
+			return retval;
+		/*
+		 * Here we don't care about uninit block because indirect-based
+		 * file doesn't support it.
+		 */
+		if (file->physblock == 0) {
+			file->blockno++;
+		} else {
+			if (file->blockno == offset / fs->blocksize)
+				file->pos = offset;
+			else
+				file->pos = file->blockno * fs->blocksize;
+			break;
+		}
+	}
+
+	return retval;
+}
+
+static errcode_t ext2fs_file_llseek_data(ext2_file_t file, __u64 offset)
+{
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval;
+
+	file->blockno = offset / fs->blocksize;
+
+	if (file->inode.i_flags & EXT4_EXTENTS_FL)
+		retval = ext2fs_file_llseek_data_ext(file, offset);
+	else
+		retval = ext2fs_file_llseek_data_ind(file, offset);
+
+	/* notify the caller that there is no any data */
+	if (file->blockno * fs->blocksize >= EXT2_I_SIZE(&file->inode))
+		return EXT2_ET_SEEK_BEYOND_EOF;
+
+	return retval;
+}
+
+static errcode_t ext2fs_file_llseek_hole_ext(ext2_file_t file, __u64 offset)
+{
+	ext2_extent_handle_t	handle = 0;
+	struct ext2fs_extent	extent;
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval = 0;
+	unsigned int	dataoff;
+
+	retval = ext2fs_extent_open2(fs, file->ino, &file->inode, &handle);
+	if (retval)
+		return retval;
+
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_extent_goto(handle, file->blockno);
+		if (retval && retval != EXT2_ET_EXTENT_NOT_FOUND)
+			goto done;
+		if (retval == EXT2_ET_EXTENT_NOT_FOUND) {
+			if (file->blockno == offset / fs->blocksize)
+				file->pos = offset;
+			else
+				file->pos = file->blockno * fs->blocksize;
+			break;
+		} else {
+			retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+						   &extent);
+			if (retval)
+				goto done;
+			/* Here uninit block is as a hole */
+			if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT) {
+				if (file->blockno == offset / fs->blocksize)
+					file->pos = offset;
+				else
+					file->pos = file->blockno *
+						    fs->blocksize;
+				break;
+			}
+			dataoff = file->blockno - extent.e_lblk;
+			if (file->blockno >= extent.e_lblk &&
+			    dataoff <= extent.e_len)
+				file->blockno = extent.e_lblk + extent.e_len;
+		}
+	}
+
+done:
+	ext2fs_extent_free(handle);
+	return retval;
+}
+
+static errcode_t ext2fs_file_llseek_hole_ind(ext2_file_t file, __u64 offset)
+{
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval = 0;
+
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode, BMAP_BUFFER,
+				      0, file->blockno, 0, &file->physblock);
+		if (retval)
+			return retval;
+		/*
+		 * Here we don't care about uninit block because indirect-based
+		 * file doesn't support it.
+		 */
+		if (file->physblock == 0) {
+			if (file->blockno == offset / fs->blocksize)
+				file->pos = offset;
+			else
+				file->pos = file->blockno * fs->blocksize;
+			break;
+		} else {
+			file->blockno++;
+		}
+	}
+
+	return retval;
+}
+
+static errcode_t ext2fs_file_llseek_hole(ext2_file_t file, __u64 offset)
+{
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval;
+
+	if (offset >= EXT2_I_SIZE(&file->inode))
+		return EXT2_ET_SEEK_BEYOND_EOF;
+
+	file->blockno = offset / fs->blocksize;
+
+	if (file->inode.i_flags & EXT4_EXTENTS_FL)
+		retval = ext2fs_file_llseek_hole_ext(file, offset);
+	else
+		retval = ext2fs_file_llseek_hole_ind(file, offset);
+
+	return retval;
+}
+
 errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
 			    int whence, __u64 *ret_pos)
 {
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
+	errcode_t retval = 0;
 
 	if (whence == EXT2_SEEK_SET)
 		file->pos = offset;
@@ -323,13 +514,17 @@ errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
 		file->pos += offset;
 	else if (whence == EXT2_SEEK_END)
 		file->pos = EXT2_I_SIZE(&file->inode) + offset;
+	else if (whence == EXT2_SEEK_DATA)
+		retval = ext2fs_file_llseek_data(file, offset);
+	else if (whence == EXT2_SEEK_HOLE)
+		retval = ext2fs_file_llseek_hole(file, offset);
 	else
 		return EXT2_ET_INVALID_ARGUMENT;
 
 	if (ret_pos)
 		*ret_pos = file->pos;
 
-	return 0;
+	return retval;
 }
 
 errcode_t ext2fs_file_lseek(ext2_file_t file, ext2_off_t offset,
-- 
1.7.9.7

