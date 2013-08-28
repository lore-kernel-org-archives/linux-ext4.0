From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 05/10] misc/util.c: copy regular file
Date: Wed, 28 Aug 2013 13:25:55 +0800
Message-ID: <1377667560-20089-6-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:63290 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3H1Fam (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:42 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_write_internal() is used for copying file from native fs to
target, most of the code are from debugfs/debugfs.c, the
debugfs/debugfs.c will be modified to use this function.

NOTE: It needs further more work which is merging the sparse copy patch.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/util.c | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index f6ae7ca..e35fd88 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -428,6 +428,46 @@ try_again:
 
 }
 
+static errcode_t copy_file(int fd, ext2_ino_t ino)
+{
+	ext2_file_t	e2_file;
+	errcode_t	retval;
+	int		got;
+	unsigned int	written;
+	char		buf[8192];
+	char		*ptr;
+
+	retval = ext2fs_file_open(current_fs, ino, EXT2_FILE_WRITE, &e2_file);
+	if (retval)
+		return retval;
+
+	while (1) {
+		got = read(fd, buf, sizeof(buf));
+		if (got == 0)
+			break;
+		if (got < 0) {
+			retval = errno;
+			goto fail;
+		}
+		ptr = buf;
+		while (got > 0) {
+			retval = ext2fs_file_write(e2_file, ptr,
+						   got, &written);
+			if (retval)
+				goto fail;
+
+			got -= written;
+			ptr += written;
+		}
+	}
+	retval = ext2fs_file_close(e2_file);
+	return retval;
+
+fail:
+	(void) ext2fs_file_close(e2_file);
+	return retval;
+}
+
 /* Make a directory in the fs */
 errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
@@ -436,6 +476,91 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 /* Copy the native file to the fs */
 errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 {
+	int		fd;
+	struct stat	statbuf;
+	ext2_ino_t	ino;
+	errcode_t	retval;
+	struct		ext2_inode inode;
+	char		*func_name = "do_write_internal";
+	int		hdlink;
+
+	fd = open(src, O_RDONLY);
+	if (fd < 0) {
+		com_err(src, errno, 0);
+		return errno;
+	}
+	if (fstat(fd, &statbuf) < 0) {
+		com_err(src, errno, 0);
+		close(fd);
+		return errno;
+	}
+
+	retval = ext2fs_namei(current_fs, root, cwd, dest, &ino);
+	if (retval == 0) {
+		com_err(func_name, 0, "The file '%s' already exists\n", dest);
+		close(fd);
+		return errno;
+	}
+
+	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &ino);
+	if (retval) {
+		com_err(func_name, retval, 0);
+		close(fd);
+		return errno;
+	}
+	printf("Allocated inode: %u\n", ino);
+	retval = ext2fs_link(current_fs, cwd, dest, ino, EXT2_FT_REG_FILE);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, cwd);
+		if (retval) {
+			com_err(func_name, retval, "while expanding directory");
+			close(fd);
+			return errno;
+		}
+		retval = ext2fs_link(current_fs, cwd, dest, ino, EXT2_FT_REG_FILE);
+	}
+	if (retval) {
+		com_err(dest, retval, 0);
+		close(fd);
+		return errno;
+	}
+        if (ext2fs_test_inode_bitmap2(current_fs->inode_map, ino))
+		com_err(func_name, 0, "Warning: inode already set");
+	ext2fs_inode_alloc_stats2(current_fs, ino, +1, 0);
+	memset(&inode, 0, sizeof(inode));
+	inode.i_mode = (statbuf.st_mode & ~LINUX_S_IFMT) | LINUX_S_IFREG;
+	inode.i_atime = inode.i_ctime = inode.i_mtime =
+		current_fs->now ? current_fs->now : time(0);
+	inode.i_links_count = 1;
+	inode.i_size = statbuf.st_size;
+	if (current_fs->super->s_feature_incompat &
+	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		int i;
+		struct ext3_extent_header *eh;
+
+		eh = (struct ext3_extent_header *) &inode.i_block[0];
+		eh->eh_depth = 0;
+		eh->eh_entries = 0;
+		eh->eh_magic = EXT3_EXT_MAGIC;
+		i = (sizeof(inode.i_block) - sizeof(*eh)) /
+			sizeof(struct ext3_extent);
+		eh->eh_max = ext2fs_cpu_to_le16(i);
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	}
+
+	if ((retval = ext2fs_write_new_inode(current_fs, ino, &inode))) {
+		com_err(func_name, retval, "while creating inode %u", ino);
+		close(fd);
+		return errno;
+	}
+	if (LINUX_S_ISREG(inode.i_mode)) {
+		retval = copy_file(fd, ino);
+		if (retval)
+			com_err("copy_file", retval, 0);
+	}
+	close(fd);
+
+	return 0;
 }
 
 /* Copy files from source_dir to fs */
-- 
1.8.1.2

