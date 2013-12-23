From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 02/10] misc/create_inode.c: copy files recursively
Date: Mon, 23 Dec 2013 07:09:52 -0500
Message-ID: <1387800600-13718-3-git-send-email-liezhi.yang@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:52646 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3LWMKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:08 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use opendir() and readdir() to read the native directory, then use
lstat() to identify the file type and call the corresponding function to
add the file to the filesystem, call the populate_fs() recursively if it
is a directory.

NOTE: the libext2fs can't create the socket file.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/create_inode.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 46aaa60..275d3f0 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -23,4 +23,94 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 /* Copy files from source_dir to fs */
 errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 {
+	const char	*name;
+	DIR		*dh;
+	struct dirent	*dent;
+	struct stat	st;
+	char		ln_target[PATH_MAX];
+	char		*func_name = "populate_fs";
+	ext2_ino_t	ino;
+	errcode_t	retval;
+	int		read_cnt;
+
+	root = EXT2_ROOT_INO;
+
+	if (chdir(source_dir) < 0) {
+		com_err(func_name, errno,
+			_("while changing working directory to \"%s\""), source_dir);
+		return errno;
+	}
+
+	if (!(dh = opendir("."))) {
+		com_err(func_name, errno,
+			_("while openning directory \"%s\""), source_dir);
+		return errno;
+	}
+
+	while((dent = readdir(dh))) {
+		if((!strcmp(dent->d_name, ".")) || (!strcmp(dent->d_name, "..")))
+			continue;
+		lstat(dent->d_name, &st);
+		name = dent->d_name;
+
+		switch(st.st_mode & S_IFMT) {
+			case S_IFCHR:
+			case S_IFBLK:
+			case S_IFIFO:
+				if ((retval = do_mknod_internal(parent_ino, name, &st))) {
+					com_err(func_name, retval,
+						_("while creating special file \"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFSOCK:
+				/* FIXME: there is no make sockect function atm. */
+				com_err(func_name, 0,
+					_("ignoring sockect file\"%s\""), name);
+				break;
+			case S_IFLNK:
+				if((read_cnt = readlink(name, ln_target, sizeof(ln_target))) == -1) {
+					com_err(func_name, errno,
+						_("while trying to readlink \"%s\""), name);
+					return errno;
+				}
+				ln_target[read_cnt] = '\0';
+				if ((retval = do_symlink_internal(parent_ino, name, ln_target))) {
+					com_err(func_name, retval,
+						_("while writing symlink\"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFREG:
+				if ((retval = do_write_internal(parent_ino, name, name))) {
+					com_err(func_name, retval,
+						_("while writing file \"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFDIR:
+				if ((retval = do_mkdir_internal(parent_ino, name, &st))) {
+					com_err(func_name, retval,
+						_("while making dir \"%s\""), name);
+					return retval;
+				}
+				if ((retval = ext2fs_namei(current_fs, root, parent_ino, name, &ino))) {
+					com_err(name, retval, 0);
+						return retval;
+				}
+				/* Populate the dir recursively*/
+				retval = populate_fs(ino, name);
+				if (retval) {
+					com_err(func_name, retval, _("while adding dir \"%s\""), name);
+					return retval;
+				}
+				chdir("..");
+				break;
+			default:
+				com_err(func_name, 0,
+					_("ignoring entry \"%s\""), name);
+		}
+	}
+	closedir(dh);
+	return retval;
 }
-- 
1.7.10.4

