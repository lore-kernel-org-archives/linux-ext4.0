From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 42/54] copy-in: create hardlinks with the correct directory
 filetype
Date: Mon, 26 Jan 2015 23:40:09 -0800
Message-ID: <20150127074009.13308.17097.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbbA0HkO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:40:14 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're creating hard links via ext2fs_link, the (misnamed?) flags
argument specifies the filetype for the directory entry.  This is
*derived* from i_mode, so provide a translator.  Otherwise, fsck will
complain about unset file types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index a024d1c..3bc0515 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -37,6 +37,32 @@
 #define S_BLKSIZE 512
 #endif
 
+static int ext2_file_type(unsigned int mode)
+{
+	if (LINUX_S_ISREG(mode))
+		return EXT2_FT_REG_FILE;
+
+	if (LINUX_S_ISDIR(mode))
+		return EXT2_FT_DIR;
+
+	if (LINUX_S_ISCHR(mode))
+		return EXT2_FT_CHRDEV;
+
+	if (LINUX_S_ISBLK(mode))
+		return EXT2_FT_BLKDEV;
+
+	if (LINUX_S_ISLNK(mode))
+		return EXT2_FT_SYMLINK;
+
+	if (LINUX_S_ISFIFO(mode))
+		return EXT2_FT_FIFO;
+
+	if (LINUX_S_ISSOCK(mode))
+		return EXT2_FT_SOCK;
+
+	return 0;
+}
+
 /* Link an inode number to a directory */
 static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 			  ext2_ino_t ino, const char *name)
@@ -50,14 +76,16 @@ static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 		return retval;
 	}
 
-	retval = ext2fs_link(fs, parent_ino, name, ino, inode.i_flags);
+	retval = ext2fs_link(fs, parent_ino, name, ino,
+			     ext2_file_type(inode.i_mode));
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
 			com_err(__func__, retval, "while expanding directory");
 			return retval;
 		}
-		retval = ext2fs_link(fs, parent_ino, name, ino, inode.i_flags);
+		retval = ext2fs_link(fs, parent_ino, name, ino,
+				     ext2_file_type(inode.i_mode));
 	}
 	if (retval) {
 		com_err(__func__, retval, "while linking %s", name);

