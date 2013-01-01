From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Tue,  1 Jan 2013 20:30:15 +0800
Message-ID: <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
Cc: George Spelvin <linux@horizon.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55698 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3AAMRA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 07:17:00 -0500
Received: by mail-pa0-f54.google.com with SMTP id bi5so7592049pad.41
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jan 2013 04:17:00 -0800 (PST)
In-Reply-To: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

For dumping a sparse file, ext2fs_file_read2 is defined to expand the interface.
It returns the sizeof hole and we can call lseek64(2) to skip it.

CC: George Spelvin <linux@horizon.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c      | 14 +++++++++++++-
 lib/ext2fs/ext2fs.h |  3 +++
 lib/ext2fs/fileio.c | 50 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index 5b2289c..d4483dc 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -107,6 +107,7 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 	struct ext2_inode	inode;
 	char		*buf = 0;
 	ext2_file_t	e2_file;
+	ext2_off64_t	seek;
 	int		nbytes;
 	unsigned int	got, blocksize = current_fs->blocksize;
 
@@ -124,11 +125,22 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 		return;
 	}
 	while (1) {
-		retval = ext2fs_file_read(e2_file, buf, blocksize, &got);
+		/* If fd is stdout, we won't consider a sparse file. */
+		if (fd == 1)
+			retval = ext2fs_file_read(e2_file, buf, blocksize,
+						  &got);
+		else
+			retval = ext2fs_file_read2(e2_file, buf, blocksize,
+						   &got, &seek);
 		if (retval)
 			com_err(cmdname, retval, "while reading ext2 file");
 		if (got == 0)
 			break;
+		if (fd != 1) {
+			nbytes = lseek64(fd, blocksize * seek, SEEK_CUR);
+			if (nbytes < 0)
+				com_err(cmdname, errno, "while lseek file");
+		}
 		nbytes = write(fd, buf, got);
 		if ((unsigned) nbytes != got)
 			com_err(cmdname, errno, "while writing file");
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7ec189e..435b68c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1171,6 +1171,9 @@ extern errcode_t ext2fs_file_close(ext2_file_t file);
 extern errcode_t ext2fs_file_flush(ext2_file_t file);
 extern errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 				  unsigned int wanted, unsigned int *got);
+extern errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
+				   unsigned int wanted, unsigned int *got,
+				   ext2_off64_t *seek);
 extern errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
 				   unsigned int nbytes, unsigned int *written);
 extern errcode_t ext2fs_file_llseek(ext2_file_t file, __u64 offset,
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..508d15c 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -179,20 +179,27 @@ static errcode_t sync_buffer_position(ext2_file_t file)
  * If dontfill is true, then skip initializing the buffer since we're
  * going to be replacing its entire contents anyway.  If set, then the
  * function basically only sets file->physblock and EXT2_FILE_BUF_VALID
+ *
+ * If seek is true, it indicates that we need to skip unwritten extents.
+ * When we get an unwritten extent, EXT2_FILE_BUF_VALID won't be set to
+ * tell caller that here is an unwritten extent and its content needn't
+ * be copied.
  */
 #define DONTFILL 1
-static errcode_t load_buffer(ext2_file_t file, int dontfill)
+#define SEEK	 2
+static errcode_t load_buffer(ext2_file_t file, int flags)
 {
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
+	int		ret_flags;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno, 0,
-				     &file->physblock);
+				     BMAP_BUFFER, 0, file->blockno,
+				     &ret_flags, &file->physblock);
 		if (retval)
 			return retval;
-		if (!dontfill) {
+		if (flags != DONTFILL) {
 			if (file->physblock) {
 				retval = io_channel_read_blk(fs->io,
 							     file->physblock,
@@ -202,7 +209,9 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 			} else
 				memset(file->buf, 0, fs->blocksize);
 		}
-		file->flags |= EXT2_FILE_BUF_VALID;
+		if ((flags != SEEK) ||
+		    (!(ret_flags & BMAP_RET_UNINIT) && file->physblock))
+			file->flags |= EXT2_FILE_BUF_VALID;
 	}
 	return 0;
 }
@@ -227,20 +236,33 @@ errcode_t ext2fs_file_close(ext2_file_t file)
 errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 			   unsigned int wanted, unsigned int *got)
 {
+	return ext2fs_file_read2(file, buf, wanted, got, 0);
+}
+
+
+errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
+			    unsigned int wanted, unsigned int *got,
+			    ext2_off64_t *seek)
+{
 	ext2_filsys	fs;
 	errcode_t	retval = 0;
 	unsigned int	start, c, count = 0;
 	__u64		left;
 	char		*ptr = (char *) buf;
+	int		seek_cnt = 0;
+	int		flags = 0;
 
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 	fs = file->fs;
 
+	if (seek)
+		flags = SEEK;
+
 	while ((file->pos < EXT2_I_SIZE(&file->inode)) && (wanted > 0)) {
 		retval = sync_buffer_position(file);
 		if (retval)
 			goto fail;
-		retval = load_buffer(file, 0);
+		retval = load_buffer(file, flags);
 		if (retval)
 			goto fail;
 
@@ -248,20 +270,26 @@ errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 		c = fs->blocksize - start;
 		if (c > wanted)
 			c = wanted;
-		left = EXT2_I_SIZE(&file->inode) - file->pos ;
+		left = EXT2_I_SIZE(&file->inode) - file->pos;
 		if (c > left)
 			c = left;
 
-		memcpy(ptr, file->buf+start, c);
 		file->pos += c;
-		ptr += c;
-		count += c;
-		wanted -= c;
+		if (file->flags & EXT2_FILE_BUF_VALID) {
+			memcpy(ptr, file->buf+start, c);
+			ptr += c;
+			count += c;
+			wanted -= c;
+		} else {
+			seek_cnt++;
+		}
 	}
 
 fail:
 	if (got)
 		*got = count;
+	if (seek)
+		*seek = seek_cnt;
 	return retval;
 }
 
-- 
1.7.12.rc2.18.g61b472e

