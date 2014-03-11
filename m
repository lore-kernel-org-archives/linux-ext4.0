From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/49] create_inode: whitespace fixes
Date: Mon, 10 Mar 2014 23:54:17 -0700
Message-ID: <20140311065417.30585.15673.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32081 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaCKGyV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:21 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a ton of whitespace issues.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |  198 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 110 insertions(+), 88 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index b204e71..766a8a4 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -25,7 +25,8 @@
 int hdlink_cnt = HDLINK_CNT;
 
 /* Link an inode number to a directory */
-static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino, const char *name)
+static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino,
+			  const char *name)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -43,7 +44,8 @@ static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino, const char *nam
 			com_err(__func__, retval, "while expanding directory");
 			return retval;
 		}
-		retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
+		retval = ext2fs_link(current_fs, parent_ino, name, ino,
+				     inode.i_flags);
 	}
 	if (retval) {
 		com_err(__func__, retval, "while linking %s", name);
@@ -103,18 +105,18 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 	int			filetype;
 
 	switch(st->st_mode & S_IFMT) {
-		case S_IFCHR:
-			mode = LINUX_S_IFCHR;
-			filetype = EXT2_FT_CHRDEV;
-			break;
-		case S_IFBLK:
-			mode = LINUX_S_IFBLK;
-			filetype =  EXT2_FT_BLKDEV;
-			break;
-		case S_IFIFO:
-			mode = LINUX_S_IFIFO;
-			filetype = EXT2_FT_FIFO;
-			break;
+	case S_IFCHR:
+		mode = LINUX_S_IFCHR;
+		filetype = EXT2_FT_CHRDEV;
+		break;
+	case S_IFBLK:
+		mode = LINUX_S_IFBLK;
+		filetype =  EXT2_FT_BLKDEV;
+		break;
+	case S_IFIFO:
+		mode = LINUX_S_IFIFO;
+		filetype = EXT2_FT_FIFO;
+		break;
 	}
 
 	if (!(current_fs->flags & EXT2_FLAG_RW)) {
@@ -143,7 +145,7 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 		com_err(name, retval, 0);
 		return -1;
 	}
-        if (ext2fs_test_inode_bitmap2(current_fs->inode_map, ino))
+	if (ext2fs_test_inode_bitmap2(current_fs->inode_map, ino))
 		com_err(__func__, 0, "Warning: inode already set");
 	ext2fs_inode_alloc_stats2(current_fs, ino, +1, 0);
 	memset(&inode, 0, sizeof(inode));
@@ -159,7 +161,8 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 		inode.i_block[1] = 0;
 	} else {
 		inode.i_block[0] = 0;
-		inode.i_block[1] = (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
+		inode.i_block[1] = (minor & 0xff) | (major << 8) |
+				   ((minor & ~0xff) << 12);
 	}
 	inode.i_links_count = 1;
 
@@ -182,7 +185,8 @@ errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		retval = ext2fs_namei(current_fs, root, cwd, name, &parent_ino);
+		retval = ext2fs_namei(current_fs, root, cwd, name,
+				      &parent_ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
@@ -196,7 +200,8 @@ try_again:
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(current_fs, parent_ino);
 		if (retval) {
-			com_err("do_symlink_internal", retval, "while expanding directory");
+			com_err("do_symlink_internal", retval,
+				"while expanding directory");
 			return retval;
 		}
 		goto try_again;
@@ -220,7 +225,8 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		retval = ext2fs_namei(current_fs, root, cwd, name, &parent_ino);
+		retval = ext2fs_namei(current_fs, root, cwd, name,
+				      &parent_ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
@@ -245,7 +251,8 @@ try_again:
 	}
 }
 
-static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_holes)
+static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
+			   int make_holes)
 {
 	ext2_file_t	e2_file;
 	errcode_t	retval;
@@ -291,7 +298,9 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 			cmp = memcmp(ptr, zero_buf, got);
 			if (cmp == 0) {
 				 /* The whole block is zero, make a hole */
-				retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
+				retval = ext2fs_file_lseek(e2_file, got,
+							   EXT2_SEEK_CUR,
+							   NULL);
 				if (retval)
 					goto fail;
 				got = 0;
@@ -387,7 +396,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 		close(fd);
 		return errno;
 	}
-        if (ext2fs_test_inode_bitmap2(current_fs->inode_map, newfile))
+	if (ext2fs_test_inode_bitmap2(current_fs->inode_map, newfile))
 		com_err(__func__, 0, "Warning: inode already set");
 	ext2fs_inode_alloc_stats2(current_fs, newfile, +1, 0);
 	memset(&inode, 0, sizeof(inode));
@@ -464,7 +473,8 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 
 	if (chdir(source_dir) < 0) {
 		com_err(__func__, errno,
-			_("while changing working directory to \"%s\""), source_dir);
+			_("while changing working directory to \"%s\""),
+			source_dir);
 		return errno;
 	}
 
@@ -475,20 +485,24 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 	}
 
 	while ((dent = readdir(dh))) {
-		if ((!strcmp(dent->d_name, ".")) || (!strcmp(dent->d_name, "..")))
+		if ((!strcmp(dent->d_name, ".")) ||
+		    (!strcmp(dent->d_name, "..")))
 			continue;
 		lstat(dent->d_name, &st);
 		name = dent->d_name;
 
 		/* Check for hardlinks */
 		save_inode = 0;
-		if (!S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode) && st.st_nlink > 1) {
+		if (!S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode) &&
+		    st.st_nlink > 1) {
 			hdlink = is_hardlink(st.st_ino);
 			if (hdlink >= 0) {
 				retval = add_link(parent_ino,
-						hdlinks.hdl[hdlink].dst_ino, name);
+						  hdlinks.hdl[hdlink].dst_ino,
+						  name);
 				if (retval) {
-					com_err(__func__, retval, "while linking %s", name);
+					com_err(__func__, retval,
+						"while linking %s", name);
 					return retval;
 				}
 				continue;
@@ -497,70 +511,78 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 		}
 
 		switch(st.st_mode & S_IFMT) {
-			case S_IFCHR:
-			case S_IFBLK:
-			case S_IFIFO:
-				retval = do_mknod_internal(parent_ino, name, &st);
-				if (retval) {
-					com_err(__func__, retval,
-						_("while creating special file \"%s\""), name);
-					return retval;
-				}
-				break;
-			case S_IFSOCK:
-				/* FIXME: there is no make socket function atm. */
-				com_err(__func__, 0,
-					_("ignoring socket file \"%s\""), name);
-				continue;
-			case S_IFLNK:
-				read_cnt = readlink(name, ln_target, sizeof(ln_target));
-				if (read_cnt == -1) {
-					com_err(__func__, errno,
-						_("while trying to readlink \"%s\""), name);
-					return errno;
-				}
-				ln_target[read_cnt] = '\0';
-				retval = do_symlink_internal(parent_ino, name, ln_target);
-				if (retval) {
-					com_err(__func__, retval,
-						_("while writing symlink\"%s\""), name);
-					return retval;
-				}
-				break;
-			case S_IFREG:
-				retval = do_write_internal(parent_ino, name, name);
-				if (retval) {
-					com_err(__func__, retval,
-						_("while writing file \"%s\""), name);
-					return retval;
-				}
-				break;
-			case S_IFDIR:
-				retval = do_mkdir_internal(parent_ino, name, &st);
-				if (retval) {
-					com_err(__func__, retval,
-						_("while making dir \"%s\""), name);
-					return retval;
-				}
-				retval = ext2fs_namei(current_fs, root, parent_ino, name, &ino);
-				if (retval) {
-					com_err(name, retval, 0);
-						return retval;
-				}
-				/* Populate the dir recursively*/
-				retval = populate_fs(ino, name);
-				if (retval) {
-					com_err(__func__, retval, _("while adding dir \"%s\""), name);
+		case S_IFCHR:
+		case S_IFBLK:
+		case S_IFIFO:
+			retval = do_mknod_internal(parent_ino, name, &st);
+			if (retval) {
+				com_err(__func__, retval,
+					_("while creating special file "
+					  "\"%s\""), name);
+				return retval;
+			}
+			break;
+		case S_IFSOCK:
+			/* FIXME: there is no make socket function atm. */
+			com_err(__func__, 0,
+				_("ignoring socket file \"%s\""), name);
+			continue;
+		case S_IFLNK:
+			read_cnt = readlink(name, ln_target,
+					    sizeof(ln_target));
+			if (read_cnt == -1) {
+				com_err(__func__, errno,
+					_("while trying to readlink \"%s\""),
+					name);
+				return errno;
+			}
+			ln_target[read_cnt] = '\0';
+			retval = do_symlink_internal(parent_ino, name,
+						     ln_target);
+			if (retval) {
+				com_err(__func__, retval,
+					_("while writing symlink\"%s\""),
+					name);
+				return retval;
+			}
+			break;
+		case S_IFREG:
+			retval = do_write_internal(parent_ino, name, name);
+			if (retval) {
+				com_err(__func__, retval,
+					_("while writing file \"%s\""), name);
+				return retval;
+			}
+			break;
+		case S_IFDIR:
+			retval = do_mkdir_internal(parent_ino, name, &st);
+			if (retval) {
+				com_err(__func__, retval,
+					_("while making dir \"%s\""), name);
+				return retval;
+			}
+			retval = ext2fs_namei(current_fs, root, parent_ino,
+					      name, &ino);
+			if (retval) {
+				com_err(name, retval, 0);
 					return retval;
-				}
-				chdir("..");
-				break;
-			default:
-				com_err(__func__, 0,
-					_("ignoring entry \"%s\""), name);
+			}
+			/* Populate the dir recursively*/
+			retval = populate_fs(ino, name);
+			if (retval) {
+				com_err(__func__, retval,
+					_("while adding dir \"%s\""), name);
+				return retval;
+			}
+			chdir("..");
+			break;
+		default:
+			com_err(__func__, 0,
+				_("ignoring entry \"%s\""), name);
 		}
 
-		retval =  ext2fs_namei(current_fs, root, parent_ino, name, &ino);
+		retval =  ext2fs_namei(current_fs, root, parent_ino,
+				       name, &ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;

