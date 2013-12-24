From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2 02/11] misc/create_inode.c: copy files recursively
Date: Tue, 24 Dec 2013 03:47:18 -0500
Message-ID: <1387874847-4922-3-git-send-email-liezhi.yang@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40435 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3LXIrf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 03:47:35 -0500
In-Reply-To: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use opendir() and readdir() to read the native directory, then use
lstat() to identify the file type and call the corresponding function to
add the file to the filesystem, call the populate_fs() recursively if it
is a directory.

NOTE: the libext2fs can't create the socket file.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/create_inode.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 46aaa60..6f5e300 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -23,4 +23,93 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 /* Copy files from source_dir to fs */
 errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 {
+	const char	*name;
+	DIR		*dh;
+	struct dirent	*dent;
+	struct stat	st;
+	char		ln_target[PATH_MAX];
+	ext2_ino_t	ino;
+	errcode_t	retval;
+	int		read_cnt;
+
+	root = EXT2_ROOT_INO;
+
+	if (chdir(source_dir) < 0) {
+		com_err(__FUNCTION__, errno,
+			_("while changing working directory to \"%s\""), source_dir);
+		return errno;
+	}
+
+	if (!(dh = opendir("."))) {
+		com_err(__FUNCTION__, errno,
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
+					com_err(__FUNCTION__, retval,
+						_("while creating special file \"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFSOCK:
+				/* FIXME: there is no make socket function atm. */
+				com_err(__FUNCTION__, 0,
+					_("ignoring socket file\"%s\""), name);
+				break;
+			case S_IFLNK:
+				if((read_cnt = readlink(name, ln_target, sizeof(ln_target))) == -1) {
+					com_err(__FUNCTION__, errno,
+						_("while trying to readlink \"%s\""), name);
+					return errno;
+				}
+				ln_target[read_cnt] = '\0';
+				if ((retval = do_symlink_internal(parent_ino, name, ln_target))) {
+					com_err(__FUNCTION__, retval,
+						_("while writing symlink\"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFREG:
+				if ((retval = do_write_internal(parent_ino, name, name))) {
+					com_err(__FUNCTION__, retval,
+						_("while writing file \"%s\""), name);
+					return retval;
+				}
+				break;
+			case S_IFDIR:
+				if ((retval = do_mkdir_internal(parent_ino, name, &st))) {
+					com_err(__FUNCTION__, retval,
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
+					com_err(__FUNCTION__, retval, _("while adding dir \"%s\""), name);
+					return retval;
+				}
+				chdir("..");
+				break;
+			default:
+				com_err(__FUNCTION__, 0,
+					_("ignoring entry \"%s\""), name);
+		}
+	}
+	closedir(dh);
+	return retval;
 }
-- 
1.7.10.4

