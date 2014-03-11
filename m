From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/49] create_inode: move debugfs internal state back to
 debugfs
Date: Mon, 10 Mar 2014 23:54:23 -0700
Message-ID: <20140311065423.30585.98566.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32129 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaCKGy2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:28 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since create_inode.c is shared between debugfs and mke2fs, don't
spread debugfs internal state into mke2fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c   |   15 ++++--
 misc/create_inode.c |  134 +++++++++++++++++++++++++++------------------------
 misc/create_inode.h |   21 +++++---
 misc/mke2fs.c       |    5 +-
 4 files changed, 95 insertions(+), 80 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 5554017..9b38c08 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -43,7 +43,8 @@ ss_request_table *extra_cmds;
 const char *debug_prog_name;
 int sci_idx;
 
-ext2_ino_t	cwd;
+ext2_filsys    current_fs;
+ext2_ino_t     root, cwd;
 
 static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			    blk64_t blocksize, int catastrophic,
@@ -1606,7 +1607,8 @@ void do_write(int argc, char *argv[])
 				"<native file> <new file>", CHECK_FS_RW))
 		return;
 
-	if ((retval = do_write_internal(cwd, argv[1], argv[2])))
+	retval = do_write_internal(current_fs, cwd, argv[1], argv[2], root);
+	if (retval)
 		com_err(argv[0], retval, 0);
 }
 
@@ -1654,7 +1656,8 @@ void do_mknod(int argc, char *argv[])
 		goto usage;
 
 	st.st_rdev = makedev(major, minor);
-	if ((retval = do_mknod_internal(cwd, argv[1], &st)))
+	retval = do_mknod_internal(current_fs, cwd, argv[1], &st);
+	if (retval)
 		com_err(argv[0], retval, 0);
 }
 
@@ -1666,7 +1669,8 @@ void do_mkdir(int argc, char *argv[])
 				"<filename>", CHECK_FS_RW))
 		return;
 
-	if ((retval = do_mkdir_internal(cwd, argv[1], NULL)))
+	retval = do_mkdir_internal(current_fs, cwd, argv[1], NULL, root);
+	if (retval)
 		com_err(argv[0], retval, 0);
 
 }
@@ -2067,7 +2071,8 @@ void do_symlink(int argc, char *argv[])
 				"<filename> <target>", CHECK_FS_RW))
 		return;
 
-	if ((retval = do_symlink_internal(cwd, argv[1], argv[2])))
+	retval = do_symlink_internal(current_fs, cwd, argv[1], argv[2], root);
+	if (retval)
 		com_err(argv[0], retval, 0);
 
 }
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 766a8a4..588f3f6 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -25,27 +25,26 @@
 int hdlink_cnt = HDLINK_CNT;
 
 /* Link an inode number to a directory */
-static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino,
-			  const char *name)
+static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
+			  ext2_ino_t ino, const char *name)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
 
-	retval = ext2fs_read_inode(current_fs, ino, &inode);
+	retval = ext2fs_read_inode(fs, ino, &inode);
         if (retval) {
 		com_err(__func__, retval, "while reading inode %u", ino);
 		return retval;
 	}
 
-	retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
+	retval = ext2fs_link(fs, parent_ino, name, ino, inode.i_flags);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
-		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
 			com_err(__func__, retval, "while expanding directory");
 			return retval;
 		}
-		retval = ext2fs_link(current_fs, parent_ino, name, ino,
-				     inode.i_flags);
+		retval = ext2fs_link(fs, parent_ino, name, ino, inode.i_flags);
 	}
 	if (retval) {
 		com_err(__func__, retval, "while linking %s", name);
@@ -54,7 +53,7 @@ static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino,
 
 	inode.i_links_count++;
 
-	retval = ext2fs_write_inode(current_fs, ino, &inode);
+	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval)
 		com_err(__func__, retval, "while writing inode %u", ino);
 
@@ -75,12 +74,13 @@ static void fill_inode(struct ext2_inode *inode, struct stat *st)
 }
 
 /* Set the uid, gid, mode and time for the inode */
-errcode_t set_inode_extra(ext2_ino_t cwd, ext2_ino_t ino, struct stat *st)
+static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
+				 ext2_ino_t ino, struct stat *st)
 {
 	errcode_t		retval;
 	struct ext2_inode	inode;
 
-	retval = ext2fs_read_inode(current_fs, ino, &inode);
+	retval = ext2fs_read_inode(fs, ino, &inode);
         if (retval) {
 		com_err(__func__, retval, "while reading inode %u", ino);
 		return retval;
@@ -88,7 +88,7 @@ errcode_t set_inode_extra(ext2_ino_t cwd, ext2_ino_t ino, struct stat *st)
 
 	fill_inode(&inode, st);
 
-	retval = ext2fs_write_inode(current_fs, ino, &inode);
+	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval) {
 		com_err(__func__, retval, "while writing inode %u", ino);
 		return retval;
@@ -96,7 +96,8 @@ errcode_t set_inode_extra(ext2_ino_t cwd, ext2_ino_t ino, struct stat *st)
 }
 
 /* Make a special file which is block, character and fifo */
-errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
+			    struct stat *st)
 {
 	ext2_ino_t		ino;
 	errcode_t 		retval;
@@ -119,11 +120,11 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 		break;
 	}
 
-	if (!(current_fs->flags & EXT2_FLAG_RW)) {
+	if (!(fs->flags & EXT2_FLAG_RW)) {
 		com_err(__func__, 0, "Filesystem opened read/only");
 		return -1;
 	}
-	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &ino);
+	retval = ext2fs_new_inode(fs, cwd, 010755, 0, &ino);
 	if (retval) {
 		com_err(__func__, retval, 0);
 		return retval;
@@ -132,26 +133,26 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 #ifdef DEBUGFS
 	printf("Allocated inode: %u\n", ino);
 #endif
-	retval = ext2fs_link(current_fs, cwd, name, ino, filetype);
+	retval = ext2fs_link(fs, cwd, name, ino, filetype);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
-		retval = ext2fs_expand_dir(current_fs, cwd);
+		retval = ext2fs_expand_dir(fs, cwd);
 		if (retval) {
 			com_err(__func__, retval, "while expanding directory");
 			return retval;
 		}
-		retval = ext2fs_link(current_fs, cwd, name, ino, filetype);
+		retval = ext2fs_link(fs, cwd, name, ino, filetype);
 	}
 	if (retval) {
 		com_err(name, retval, 0);
 		return -1;
 	}
-	if (ext2fs_test_inode_bitmap2(current_fs->inode_map, ino))
+	if (ext2fs_test_inode_bitmap2(fs->inode_map, ino))
 		com_err(__func__, 0, "Warning: inode already set");
-	ext2fs_inode_alloc_stats2(current_fs, ino, +1, 0);
+	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 	memset(&inode, 0, sizeof(inode));
 	inode.i_mode = mode;
 	inode.i_atime = inode.i_ctime = inode.i_mtime =
-		current_fs->now ? current_fs->now : time(0);
+		fs->now ? fs->now : time(0);
 
 	major = major(st->st_rdev);
 	minor = minor(st->st_rdev);
@@ -166,7 +167,7 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 	}
 	inode.i_links_count = 1;
 
-	retval = ext2fs_write_new_inode(current_fs, ino, &inode);
+	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		com_err(__func__, retval, "while creating inode %u", ino);
 
@@ -174,7 +175,8 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 }
 
 /* Make a symlink name -> target */
-errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
+errcode_t do_symlink_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
+			      char *target, ext2_ino_t root)
 {
 	char			*cp;
 	ext2_ino_t		parent_ino;
@@ -185,8 +187,7 @@ errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		retval = ext2fs_namei(current_fs, root, cwd, name,
-				      &parent_ino);
+		retval = ext2fs_namei(fs, root, cwd, name, &parent_ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
@@ -196,9 +197,9 @@ errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
 		parent_ino = cwd;
 
 try_again:
-	retval = ext2fs_symlink(current_fs, parent_ino, 0, name, target);
+	retval = ext2fs_symlink(fs, parent_ino, 0, name, target);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
-		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
 			com_err("do_symlink_internal", retval,
 				"while expanding directory");
@@ -214,7 +215,8 @@ try_again:
 }
 
 /* Make a directory in the fs */
-errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+errcode_t do_mkdir_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
+			    struct stat *st, ext2_ino_t root)
 {
 	char			*cp;
 	ext2_ino_t		parent_ino, ino;
@@ -225,8 +227,7 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		retval = ext2fs_namei(current_fs, root, cwd, name,
-				      &parent_ino);
+		retval = ext2fs_namei(fs, root, cwd, name, &parent_ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
@@ -236,9 +237,9 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 		parent_ino = cwd;
 
 try_again:
-	retval = ext2fs_mkdir(current_fs, parent_ino, 0, name);
+	retval = ext2fs_mkdir(fs, parent_ino, 0, name);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
-		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
 			com_err(__func__, retval, "while expanding directory");
 			return retval;
@@ -251,8 +252,8 @@ try_again:
 	}
 }
 
-static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
-			   int make_holes)
+static errcode_t copy_file(ext2_filsys fs, int fd, ext2_ino_t newfile,
+			   int bufsize, int make_holes)
 {
 	ext2_file_t	e2_file;
 	errcode_t	retval;
@@ -263,7 +264,7 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize,
 	char		*zero_buf;
 	int		cmp;
 
-	retval = ext2fs_file_open(current_fs, newfile,
+	retval = ext2fs_file_open(fs, newfile,
 				  EXT2_FILE_WRITE, &e2_file);
 	if (retval)
 		return retval;
@@ -330,7 +331,7 @@ fail:
 	return retval;
 }
 
-int is_hardlink(ext2_ino_t ino)
+static int is_hardlink(ext2_ino_t ino)
 {
 	int i;
 
@@ -342,7 +343,8 @@ int is_hardlink(ext2_ino_t ino)
 }
 
 /* Copy the native file to the fs */
-errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
+errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
+			    const char *dest, ext2_ino_t root)
 {
 	int		fd;
 	struct stat	statbuf;
@@ -363,14 +365,14 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 		return errno;
 	}
 
-	retval = ext2fs_namei(current_fs, root, cwd, dest, &newfile);
+	retval = ext2fs_namei(fs, root, cwd, dest, &newfile);
 	if (retval == 0) {
 		com_err(__func__, 0, "The file '%s' already exists\n", dest);
 		close(fd);
 		return retval;
 	}
 
-	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
+	retval = ext2fs_new_inode(fs, cwd, 010755, 0, &newfile);
 	if (retval) {
 		com_err(__func__, retval, 0);
 		close(fd);
@@ -379,16 +381,16 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 #ifdef DEBUGFS
 	printf("Allocated inode: %u\n", newfile);
 #endif
-	retval = ext2fs_link(current_fs, cwd, dest, newfile,
+	retval = ext2fs_link(fs, cwd, dest, newfile,
 				EXT2_FT_REG_FILE);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
-		retval = ext2fs_expand_dir(current_fs, cwd);
+		retval = ext2fs_expand_dir(fs, cwd);
 		if (retval) {
 			com_err(__func__, retval, "while expanding directory");
 			close(fd);
 			return retval;
 		}
-		retval = ext2fs_link(current_fs, cwd, dest, newfile,
+		retval = ext2fs_link(fs, cwd, dest, newfile,
 					EXT2_FT_REG_FILE);
 	}
 	if (retval) {
@@ -396,19 +398,19 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 		close(fd);
 		return errno;
 	}
-	if (ext2fs_test_inode_bitmap2(current_fs->inode_map, newfile))
+	if (ext2fs_test_inode_bitmap2(fs->inode_map, newfile))
 		com_err(__func__, 0, "Warning: inode already set");
-	ext2fs_inode_alloc_stats2(current_fs, newfile, +1, 0);
+	ext2fs_inode_alloc_stats2(fs, newfile, +1, 0);
 	memset(&inode, 0, sizeof(inode));
 	inode.i_mode = (statbuf.st_mode & ~LINUX_S_IFMT) | LINUX_S_IFREG;
 	inode.i_atime = inode.i_ctime = inode.i_mtime =
-		current_fs->now ? current_fs->now : time(0);
+		fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
 	inode.i_size = statbuf.st_size;
-	if (EXT2_HAS_INCOMPAT_FEATURE(current_fs->super,
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
-	} else if (current_fs->super->s_feature_incompat &
+	} else if (fs->super->s_feature_incompat &
 		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
 		int i;
 		struct ext3_extent_header *eh;
@@ -423,14 +425,14 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 		inode.i_flags |= EXT4_EXTENTS_FL;
 	}
 
-	retval = ext2fs_write_new_inode(current_fs, newfile, &inode);
+	retval = ext2fs_write_new_inode(fs, newfile, &inode);
 	if (retval) {
 		com_err(__func__, retval, "while creating inode %u", newfile);
 		close(fd);
 		return retval;
 	}
 	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
-		retval = ext2fs_inline_data_init(current_fs, newfile);
+		retval = ext2fs_inline_data_init(fs, newfile);
 		if (retval) {
 			com_err("copy_file", retval, 0);
 			close(fd);
@@ -446,7 +448,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 			 */
 			bufsize = statbuf.st_blksize;
 		}
-		retval = copy_file(fd, newfile, bufsize, make_holes);
+		retval = copy_file(fs, fd, newfile, bufsize, make_holes);
 		if (retval)
 			com_err("copy_file", retval, 0);
 	}
@@ -456,7 +458,8 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 }
 
 /* Copy files from source_dir to fs */
-errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
+errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
+		      const char *source_dir, ext2_ino_t root)
 {
 	const char	*name;
 	DIR		*dh;
@@ -469,8 +472,6 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 	int		read_cnt;
 	int		hdlink;
 
-	root = EXT2_ROOT_INO;
-
 	if (chdir(source_dir) < 0) {
 		com_err(__func__, errno,
 			_("while changing working directory to \"%s\""),
@@ -497,7 +498,7 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 		    st.st_nlink > 1) {
 			hdlink = is_hardlink(st.st_ino);
 			if (hdlink >= 0) {
-				retval = add_link(parent_ino,
+				retval = add_link(fs, parent_ino,
 						  hdlinks.hdl[hdlink].dst_ino,
 						  name);
 				if (retval) {
@@ -514,7 +515,7 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 		case S_IFCHR:
 		case S_IFBLK:
 		case S_IFIFO:
-			retval = do_mknod_internal(parent_ino, name, &st);
+			retval = do_mknod_internal(fs, parent_ino, name, &st);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while creating special file "
@@ -537,8 +538,8 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 				return errno;
 			}
 			ln_target[read_cnt] = '\0';
-			retval = do_symlink_internal(parent_ino, name,
-						     ln_target);
+			retval = do_symlink_internal(fs, parent_ino, name,
+						     ln_target, root);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while writing symlink\"%s\""),
@@ -547,7 +548,8 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 			}
 			break;
 		case S_IFREG:
-			retval = do_write_internal(parent_ino, name, name);
+			retval = do_write_internal(fs, parent_ino, name, name,
+						   root);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while writing file \"%s\""), name);
@@ -555,40 +557,44 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 			}
 			break;
 		case S_IFDIR:
-			retval = do_mkdir_internal(parent_ino, name, &st);
+			retval = do_mkdir_internal(fs, parent_ino, name, &st,
+						   root);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while making dir \"%s\""), name);
 				return retval;
 			}
-			retval = ext2fs_namei(current_fs, root, parent_ino,
+			retval = ext2fs_namei(fs, root, parent_ino,
 					      name, &ino);
 			if (retval) {
 				com_err(name, retval, 0);
 					return retval;
 			}
 			/* Populate the dir recursively*/
-			retval = populate_fs(ino, name);
+			retval = populate_fs(fs, ino, name, root);
 			if (retval) {
 				com_err(__func__, retval,
 					_("while adding dir \"%s\""), name);
 				return retval;
 			}
-			chdir("..");
+			if (chdir("..")) {
+				com_err(__func__, errno,
+					_("during cd .."));
+				return errno;
+			}
 			break;
 		default:
 			com_err(__func__, 0,
 				_("ignoring entry \"%s\""), name);
 		}
 
-		retval =  ext2fs_namei(current_fs, root, parent_ino,
-				       name, &ino);
+		retval =  ext2fs_namei(fs, root, parent_ino, name, &ino);
 		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
 		}
 
-		retval = set_inode_extra(parent_ino, ino, &st);
+		retval = set_inode_extra(fs, parent_ino, ino, &st);
 		if (retval) {
 			com_err(__func__, retval,
 				_("while setting inode for \"%s\""), name);
diff --git a/misc/create_inode.h b/misc/create_inode.h
index 79742e8..fd96910 100644
--- a/misc/create_inode.h
+++ b/misc/create_inode.h
@@ -23,18 +23,23 @@ struct hdlinks_s
 
 struct hdlinks_s hdlinks;
 
-ext2_filsys    current_fs;
-ext2_ino_t     root;
-
 /* For saving the hard links */
 #define HDLINK_CNT     4
 extern int hdlink_cnt;
 
 /* For populating the filesystem */
-extern errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir);
-extern errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st);
-extern errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target);
-extern errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st);
-extern errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest);
+extern errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
+			     const char *source_dir, ext2_ino_t root);
+extern errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd,
+				   const char *name, struct stat *st);
+extern errcode_t do_symlink_internal(ext2_filsys fs, ext2_ino_t cwd,
+				     const char *name, char *target,
+				     ext2_ino_t root);
+extern errcode_t do_mkdir_internal(ext2_filsys fs, ext2_ino_t cwd,
+				   const char *name, struct stat *st,
+				   ext2_ino_t root);
+extern errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd,
+				   const char *src, const char *dest,
+				   ext2_ino_t root);
 
 #endif /* _CREATE_INODE_H */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 61aced2..1422336 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -3000,9 +3000,8 @@ no_journal:
 		}
 
 		hdlinks.count = 0;
-		current_fs = fs;
-		root = EXT2_ROOT_INO;
-		retval = populate_fs(root, root_dir);
+		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
+				     EXT2_ROOT_INO);
 		if (retval)
 			fprintf(stderr, "%s",
 				_("\nError while populating file system"));

