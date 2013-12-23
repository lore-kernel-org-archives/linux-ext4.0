From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 03/10] misc/create_inode.c: create special file
Date: Mon, 23 Dec 2013 07:09:53 -0500
Message-ID: <1387800600-13718-4-git-send-email-liezhi.yang@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:52647 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3LWMKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:10 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_mknod_internal() is used for creating special file which is
block, character and fifo, most of the code are from debugfs/debugfs.c,
the debugfs/debugfs.c will be modified to use this function.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/create_inode.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 275d3f0..62a40de 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -3,6 +3,79 @@
 /* Make a special file which is block, character and fifo */
 errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
+	ext2_ino_t		ino;
+	errcode_t 		retval;
+	struct ext2_inode	inode;
+	char			*func_name = "do_mknod_internal";
+	unsigned long		major, minor, mode;
+	int			filetype;
+
+	switch(st->st_mode & S_IFMT) {
+		case S_IFCHR:
+			mode = LINUX_S_IFCHR;
+			filetype = EXT2_FT_CHRDEV;
+			break;
+		case S_IFBLK:
+			mode = LINUX_S_IFBLK;
+			filetype =  EXT2_FT_BLKDEV;
+			break;
+		case S_IFIFO:
+			mode = LINUX_S_IFIFO;
+			filetype = EXT2_FT_FIFO;
+			break;
+	}
+
+	if (!(current_fs->flags & EXT2_FLAG_RW)) {
+		com_err(func_name, 0, "Filesystem opened read/only");
+		return -1;
+	}
+	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &ino);
+	if (retval) {
+		com_err(func_name, retval, 0);
+		return retval;
+	}
+
+#ifdef DEBUGFS
+	printf("Allocated inode: %u\n", ino);
+#endif
+	retval = ext2fs_link(current_fs, cwd, name, ino, filetype);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, cwd);
+		if (retval) {
+			com_err(func_name, retval, "while expanding directory");
+			return retval;
+		}
+		retval = ext2fs_link(current_fs, cwd, name, ino, filetype);
+	}
+	if (retval) {
+		com_err(name, retval, 0);
+		return -1;
+	}
+        if (ext2fs_test_inode_bitmap2(current_fs->inode_map, ino))
+		com_err(func_name, 0, "Warning: inode already set");
+	ext2fs_inode_alloc_stats2(current_fs, ino, +1, 0);
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = mode;
+	inode.i_atime = inode.i_ctime = inode.i_mtime =
+		current_fs->now ? current_fs->now : time(0);
+
+	major = major(st->st_rdev);
+	minor = minor(st->st_rdev);
+
+	if ((major < 256) && (minor < 256)) {
+		inode.i_block[0] = major * 256 + minor;
+		inode.i_block[1] = 0;
+	} else {
+		inode.i_block[0] = 0;
+		inode.i_block[1] = (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
+	}
+	inode.i_links_count = 1;
+
+	retval = ext2fs_write_new_inode(current_fs, ino, &inode);
+	if (retval)
+		com_err(func_name, retval, "while creating inode %u", ino);
+
+	return retval;
 }
 
 /* Make a symlink name -> target */
-- 
1.7.10.4

