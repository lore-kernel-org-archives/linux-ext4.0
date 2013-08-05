From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v5 2/2] debugfs: dump a sparse file
Date: Mon,  5 Aug 2013 13:43:40 +0800
Message-ID: <1375681420-15384-3-git-send-email-wenqing.lz@taobao.com>
References: <1375681420-15384-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38287 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3HEFnk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 01:43:40 -0400
Received: by mail-pd0-f171.google.com with SMTP id bv13so2807130pdb.2
        for <linux-ext4@vger.kernel.org>; Sun, 04 Aug 2013 22:43:39 -0700 (PDT)
In-Reply-To: <1375681420-15384-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When ext2fs_file_open() is called with EXT2_FILE_SPAESE flag, ext2fs_file_read()
will return EXT2_ET_READ_HOLE_FOUND if it meets a hole/uninitialized block.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/dump.c            |   48 +++++++++++++++++++++++++++++++++++++--------
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2fs.h       |    1 +
 lib/ext2fs/fileio.c       |   11 +++++++++--
 4 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index c75b9f1..5431a7b 100644
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
+			ret_pos = ext2fs_llseek(fd, ret_pos, SEEK_SET);
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
index 2a9ddbb..279087b 100644
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
1.7.9.7

