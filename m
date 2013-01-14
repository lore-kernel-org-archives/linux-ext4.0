From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Mon, 14 Jan 2013 22:18:30 +0800
Message-ID: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34451 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3ANOEy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 09:04:54 -0500
Received: by mail-pb0-f53.google.com with SMTP id jt11so2171124pbb.40
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 06:04:53 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ext2fs_file_llseek is extented to introduce SEEK_DATA/HOLE.  In *_data()
function it will find the next data, and in *_hole() function it will find the
next hole.  A new error code called EXT2_ET_SEEK_BEYOND_EOF is define to
indicate that the offset is beyond the end of file.

Here they need to solve a problem that the caller can not dereference
ext2_file_t->pos because this structure is hidden by a typedef.  Thus,
EXT2_SEEK_OFFSET_INVALID is define to indicate whether or not it will
find the data/hole from ext2_file_t->pos.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
Hi Ted,

ext2fs_file_llseek_data/hole() seem to be weird because ext2_file_t structure is
hidden by a typedef.  The caller can not dereference it.  So I define a marco
called EXT2_SEEK_OFFSET_INVALID to let the caller indicate that it find the
data/hole from ext2_file_t->pos or from offset.  What do you think?

Thanks,
						- Zheng

 lib/ext2fs/ext2_err.et.in |  3 ++
 lib/ext2fs/ext2fs.h       |  4 +++
 lib/ext2fs/fileio.c       | 80 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index c99a167..f763938 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -473,4 +473,7 @@ ec	EXT2_ET_UNKNOWN_CSUM,
 ec	EXT2_ET_MMP_CSUM_INVALID,
 	"MMP block checksum does not match MMP block"
 
+ec	EXT2_ET_SEEK_BEYOND_EOF,
+	"lseek beyond the EOF"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7139b4d..474049f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -160,6 +160,10 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_SEEK_SET	0
 #define EXT2_SEEK_CUR	1
 #define EXT2_SEEK_END	2
+#define EXT2_SEEK_DATA	3
+#define EXT2_SEEK_HOLE	4
+
+#define EXT2_SEEK_OFFSET_INVALID	-1
 
 /*
  * Flags for the ext2_filsys structure and for ext2fs_open()
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..ab33290 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -312,10 +312,84 @@ fail:
 	return retval;
 }
 
+static errcode_t ext2fs_file_llseek_data(ext2_file_t file, __u64 offset)
+{
+	int		ret_flags, flag = 1;
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval;
+
+	/*
+	 * If offset == EXT2_SEEK_OFFSET_INVALID, that means that
+	 * the caller wants to find the data from file->pos.
+	 */
+	offset = offset != EXT2_SEEK_OFFSET_INVALID ? offset : file->pos;
+	file->blockno = offset / fs->blocksize;
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+				      BMAP_BUFFER, 0, file->blockno,
+				      &ret_flags, &file->physblock);
+		if (retval)
+			return retval;
+		if (file->physblock == 0 || (ret_flags & BMAP_RET_UNINIT)) {
+			file->blockno++;
+			flag = 0;
+		} else {
+			if (flag)
+				file->pos = offset;
+			else
+				file->pos = file->blockno * fs->blocksize;
+			break;
+		}
+	}
+
+	/* notify the caller that there is no any data */
+	if (file->blockno * fs->blocksize >= EXT2_I_SIZE(&file->inode))
+		return EXT2_ET_SEEK_BEYOND_EOF;
+
+	return 0;
+}
+
+static errcode_t ext2fs_file_llseek_hole(ext2_file_t file, __u64 offset)
+{
+	int		ret_flags, flag = 1;
+	ext2_filsys	fs = file->fs;
+	errcode_t	retval;
+
+	/*
+	 * If offset == EXT2_SEEK_OFFSET_INVALID, that means that
+	 * the caller wants to find the hole from file->pos.
+	 */
+	offset = offset != EXT2_SEEK_OFFSET_INVALID ? offset : file->pos;
+	if (offset >= EXT2_I_SIZE(&file->inode))
+		return EXT2_ET_SEEK_BEYOND_EOF;
+
+	file->blockno = offset / fs->blocksize;
+	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
+		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
+				      BMAP_BUFFER, 0, file->blockno,
+				      &ret_flags, &file->physblock);
+		if (retval)
+			return retval;
+		if (file->physblock == 0 || (ret_flags & BMAP_RET_UNINIT)) {
+			if (flag)
+				file->pos = offset;
+			else
+				file->pos = file->blockno * fs->blocksize;
+			break;
+		} else {
+			file->blockno++;
+			flag = 0;
+		}
+	}
+
+	return 0;
+}
+
 errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
 			    int whence, __u64 *ret_pos)
 {
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
+	errcode_t retval = 0;
 
 	if (whence == EXT2_SEEK_SET)
 		file->pos = offset;
@@ -323,13 +397,17 @@ errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
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
1.7.12.rc2.18.g61b472e

