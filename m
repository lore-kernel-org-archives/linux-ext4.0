From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/2 v3] debugfs: dump a sparse file
Date: Tue, 22 Jan 2013 17:11:33 +0800
Message-ID: <1358845893-24640-3-git-send-email-wenqing.lz@taobao.com>
References: <1358845893-24640-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39688 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3AVI6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 03:58:01 -0500
Received: by mail-pb0-f45.google.com with SMTP id mc8so3833505pbc.4
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 00:58:01 -0800 (PST)
In-Reply-To: <1358845893-24640-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When ext2fs_file_open() is called with EXT2_FILE_SPAESE flag, ext2fs_file_read()
will return EXT2_ET_READ_HOLE_FOUND if it meets a hole/uninitialized block.  The
caller can handle sparse file according to this flags.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c            | 48 +++++++++++++++++++++++++++++++++++++++--------
 lib/ext2fs/ext2_err.et.in |  3 +++
 lib/ext2fs/ext2fs.h       |  1 +
 lib/ext2fs/fileio.c       | 11 +++++++++--
 4 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index 9409ab6..3341c56 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -107,13 +107,20 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 	struct ext2_inode	inode;
 	char		*buf = 0;
 	ext2_file_t	e2_file;
-	int		nbytes;
+	ext2_off64_t	ret_pos, offset;
+	int		nbytes, flags = 0;
 	unsigned int	got, blocksize = current_fs->blocksize;
 
 	if (debugfs_read_inode(ino, &inode, cmdname))
 		return;
 
-	retval = ext2fs_file_open(current_fs, ino, 0, &e2_file);
+	/*
+	 * We need to handle stdout because this function is called by
+	 * do_cat() and do_dump().
+	 */
+	if (fd != 1)
+		flags = EXT2_FILE_SPARSE;
+	retval = ext2fs_file_open(current_fs, ino, flags, &e2_file);
 	if (retval) {
 		com_err(cmdname, retval, "while opening ext2 file");
 		return;
@@ -125,13 +132,38 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 	}
 	while (1) {
 		retval = ext2fs_file_read(e2_file, buf, blocksize, &got);
-		if (retval)
+		if (retval && retval != EXT2_ET_READ_HOLE_FOUND)
 			com_err(cmdname, retval, "while reading ext2 file");
-		if (got == 0)
-			break;
-		nbytes = write(fd, buf, got);
-		if ((unsigned) nbytes != got)
-			com_err(cmdname, errno, "while writing file");
+		if (retval == EXT2_ET_READ_HOLE_FOUND) {
+			if (got) {
+				nbytes = write(fd, buf, got);
+				if ((unsigned) nbytes != got)
+					com_err(cmdname, errno,
+						"while writing file");
+			}
+			retval = ext2fs_file_llseek(e2_file, 0, EXT2_SEEK_CUR,
+						    &offset);
+			if (retval)
+				com_err(cmdname, retval,
+					"while lseeking ext2 file");
+			retval = ext2fs_file_llseek(e2_file, offset,
+						    EXT2_SEEK_DATA, &ret_pos);
+			if (retval == EXT2_ET_SEEK_BEYOND_EOF)
+				break;
+			if (retval)
+				com_err(cmdname, retval,
+					"while lseeking ext2 file");
+			ret_pos = lseek64(fd, ret_pos, SEEK_SET);
+			if (ret_pos < 0)
+				com_err(cmdname, retval,
+					"while lseeking target file");
+		} else {
+			if (got == 0)
+				break;
+			nbytes = write(fd, buf, got);
+			if ((unsigned) nbytes != got)
+				com_err(cmdname, errno, "while writing file");
+		}
 	}
 	if (buf)
 		ext2fs_free_mem(&buf);
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 6e79b97..f854df0 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -479,4 +479,7 @@ ec	EXT2_ET_FILE_EXISTS,
 ec	EXT2_ET_SEEK_BEYOND_EOF,
 	"lseek beyond the EOF"
 
+ec	EXT2_ET_READ_HOLE_FOUND,
+	"We read a hole/uninitialized block with EXT2_FILE_SPARSE flag"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ce7c38a..e757b40 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -149,6 +149,7 @@ typedef struct ext2_struct_dblist *ext2_dblist;
 
 #define EXT2_FILE_WRITE		0x0001
 #define EXT2_FILE_CREATE	0x0002
+#define EXT2_FILE_SPARSE	0x0004
 
 #define EXT2_FILE_MASK		0x00FF
 
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 6cb2e43..be658d8 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -185,11 +185,12 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 {
 	ext2_filsys	fs = file->fs;
 	errcode_t	retval;
+	int		ret_flags = 0;
 
 	if (!(file->flags & EXT2_FILE_BUF_VALID)) {
 		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
-				     BMAP_BUFFER, 0, file->blockno, 0,
-				     &file->physblock);
+				     BMAP_BUFFER, 0, file->blockno,
+				     &ret_flags, &file->physblock);
 		if (retval)
 			return retval;
 		if (!dontfill) {
@@ -203,6 +204,12 @@ static errcode_t load_buffer(ext2_file_t file, int dontfill)
 				memset(file->buf, 0, fs->blocksize);
 		}
 		file->flags |= EXT2_FILE_BUF_VALID;
+		if (file->flags & EXT2_FILE_SPARSE) {
+			if (file->physblock == 0 ||
+			    (ret_flags & BMAP_RET_UNINIT)) {
+				return EXT2_ET_READ_HOLE_FOUND;
+			}
+		}
 	}
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

