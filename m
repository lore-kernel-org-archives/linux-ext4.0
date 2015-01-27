From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 44/54] copyin: fix error handling
Date: Mon, 26 Jan 2015 23:40:22 -0800
Message-ID: <20150127074022.13308.52497.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35348 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbA0Hk1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:40:27 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Save errno (in retval) before doing anything else, because the
"anything else" (usually com_err()) can call library functions, which
will reset errno.

Fix the error messages to use the message catalog, and don't _ever_
print an error without providing context.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c            |  212 ++++++++++++++++++++--------------------
 misc/mke2fs.c                  |    2 
 tests/f_create_symlinks/expect |    4 -
 3 files changed, 107 insertions(+), 111 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 8ab546e..7d3c9e6 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -75,7 +75,7 @@ static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 
 	retval = ext2fs_read_inode(fs, ino, &inode);
         if (retval) {
-		com_err(__func__, retval, "while reading inode %u", ino);
+		com_err(__func__, retval, _("while reading inode %u"), ino);
 		return retval;
 	}
 
@@ -84,14 +84,15 @@ static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
-			com_err(__func__, retval, "while expanding directory");
+			com_err(__func__, retval,
+				_("while expanding directory"));
 			return retval;
 		}
 		retval = ext2fs_link(fs, parent_ino, name, ino,
 				     ext2_file_type(inode.i_mode));
 	}
 	if (retval) {
-		com_err(__func__, retval, "while linking %s", name);
+		com_err(__func__, retval, _("while linking \"%s\""), name);
 		return retval;
 	}
 
@@ -99,24 +100,11 @@ static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
 
 	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval)
-		com_err(__func__, retval, "while writing inode %u", ino);
+		com_err(__func__, retval, _("while writing inode %u"), ino);
 
 	return retval;
 }
 
-/* Fill the uid, gid, mode and time for the inode */
-static void fill_inode(struct ext2_inode *inode, struct stat *st)
-{
-	if (st != NULL) {
-		inode->i_uid = st->st_uid;
-		inode->i_gid = st->st_gid;
-		inode->i_mode |= st->st_mode;
-		inode->i_atime = st->st_atime;
-		inode->i_mtime = st->st_mtime;
-		inode->i_ctime = st->st_ctime;
-	}
-}
-
 /* Set the uid, gid, mode and time for the inode */
 static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
 				 ext2_ino_t ino, struct stat *st)
@@ -126,19 +114,25 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
 
 	retval = ext2fs_read_inode(fs, ino, &inode);
         if (retval) {
-		com_err(__func__, retval, "while reading inode %u", ino);
+		com_err(__func__, retval, _("while reading inode %u"), ino);
 		return retval;
 	}
 
-	fill_inode(&inode, st);
+	inode.i_uid = st->st_uid;
+	inode.i_gid = st->st_gid;
+	inode.i_mode |= st->st_mode;
+	inode.i_atime = st->st_atime;
+	inode.i_mtime = st->st_mtime;
+	inode.i_ctime = st->st_ctime;
 
 	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval)
-		com_err(__func__, retval, "while writing inode %u", ino);
+		com_err(__func__, retval, _("while writing inode %u"), ino);
 	return retval;
 }
 
-static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *filename)
+static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino,
+				 const char *filename)
 {
 #ifdef HAVE_LLISTXATTR
 	errcode_t			retval, close_retval;
@@ -149,8 +143,10 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 
 	size = llistxattr(filename, NULL, 0);
 	if (size == -1) {
-		com_err(__func__, errno, "llistxattr failed on %s", filename);
-		return errno;
+		retval = errno;
+		com_err(__func__, retval, _("while listing attributes of \"%s\""),
+			filename);
+		return retval;
 	} else if (size == 0) {
 		return 0;
 	}
@@ -159,20 +155,21 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 	if (retval) {
 		if (retval == EXT2_ET_MISSING_EA_FEATURE)
 			return 0;
-		com_err(__func__, retval, "while opening inode %u", ino);
+		com_err(__func__, retval, _("while opening inode %u"), ino);
 		return retval;
 	}
 
 	retval = ext2fs_get_mem(size, &list);
 	if (retval) {
-		com_err(__func__, retval, "whilst allocating memory");
+		com_err(__func__, retval, _("while allocating memory"));
 		goto out;
 	}
 
 	size = llistxattr(filename, list, size);
 	if (size == -1) {
-		com_err(__func__, errno, "llistxattr failed on %s", filename);
 		retval = errno;
+		com_err(__func__, retval, _("while listing attributes of \"%s\""),
+			filename);
 		goto out;
         }
 
@@ -182,24 +179,26 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 
 		value_size = getxattr(filename, name, NULL, 0);
 		if (value_size == -1) {
-			com_err(__func__, errno, "getxattr failed on %s",
-				filename);
 			retval = errno;
+			com_err(__func__, retval,
+				_("while reading attribute \"%s\" of \"%s\""),
+				name, filename);
 			break;
 		}
 
 		retval = ext2fs_get_mem(value_size, &value);
 		if (retval) {
-			com_err(__func__, retval, "whilst allocating memory");
+			com_err(__func__, retval, _("while allocating memory"));
 			break;
 		}
 
 		value_size = getxattr(filename, name, value, value_size);
 		if (value_size == -1) {
 			ext2fs_free_mem(&value);
-			com_err(__func__, errno, "getxattr failed on %s",
-				filename);
 			retval = errno;
+			com_err(__func__, retval,
+				_("while reading attribute \"%s\" of \"%s\""),
+				name, filename);
 			break;
 		}
 
@@ -207,7 +206,8 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 		ext2fs_free_mem(&value);
 		if (retval) {
 			com_err(__func__, retval,
-				"while writing xattr %u", ino);
+				_("while writing attribute \"%s\" to inode %u"),
+				name, ino);
 			break;
 		}
 
@@ -216,7 +216,7 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *fil
 	ext2fs_free_mem(&list);
 	close_retval = ext2fs_xattrs_close(&handle);
 	if (close_retval) {
-		com_err(__func__, retval, "while closing inode %u", ino);
+		com_err(__func__, retval, _("while closing inode %u"), ino);
 		retval = retval ? retval : close_retval;
 	}
 	return retval;
@@ -256,13 +256,10 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 		return EXT2_ET_INVALID_ARGUMENT;
 	}
 
-	if (!(fs->flags & EXT2_FLAG_RW)) {
-		com_err(__func__, 0, "Filesystem opened read/only");
-		return EROFS;
-	}
 	retval = ext2fs_new_inode(fs, cwd, 010755, 0, &ino);
 	if (retval) {
-		com_err(__func__, retval, 0);
+		com_err(__func__, retval, _("while allocating inode \"%s\""),
+			name);
 		return retval;
 	}
 
@@ -273,13 +270,14 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, cwd);
 		if (retval) {
-			com_err(__func__, retval, "while expanding directory");
+			com_err(__func__, retval,
+				_("while expanding directory"));
 			return retval;
 		}
 		retval = ext2fs_link(fs, cwd, name, ino, filetype);
 	}
 	if (retval) {
-		com_err(name, retval, 0);
+		com_err(name, retval, _("while creating inode \"%s\""), name);
 		return retval;
 	}
 	if (ext2fs_test_inode_bitmap2(fs->inode_map, ino))
@@ -307,7 +305,7 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 
 	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
-		com_err(__func__, retval, "while creating inode %u", ino);
+		com_err(__func__, retval, _("while writing inode %u"), ino);
 
 	return retval;
 }
@@ -332,19 +330,19 @@ errcode_t do_symlink_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 	} else
 		parent_ino = cwd;
 
-try_again:
 	retval = ext2fs_symlink(fs, parent_ino, 0, name, target);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
 			com_err("do_symlink_internal", retval,
-				"while expanding directory");
+				_("while expanding directory"));
 			return retval;
 		}
-		goto try_again;
+		retval = ext2fs_symlink(fs, parent_ino, 0, name, target);
 	}
 	if (retval)
-		com_err("ext2fs_symlink", retval, 0);
+		com_err("ext2fs_symlink", retval,
+			_("while creating symlink \"%s\""), name);
 	return retval;
 }
 
@@ -362,25 +360,27 @@ errcode_t do_mkdir_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 		*cp = 0;
 		retval = ext2fs_namei(fs, root, cwd, name, &parent_ino);
 		if (retval) {
-			com_err(name, retval, 0);
+			com_err(name, retval, _("while looking up \"%s\""),
+				name);
 			return retval;
 		}
 		name = cp+1;
 	} else
 		parent_ino = cwd;
 
-try_again:
 	retval = ext2fs_mkdir(fs, parent_ino, 0, name);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, parent_ino);
 		if (retval) {
-			com_err(__func__, retval, "while expanding directory");
+			com_err(__func__, retval,
+				_("while expanding directory"));
 			return retval;
 		}
-		goto try_again;
+		retval = ext2fs_mkdir(fs, parent_ino, 0, name);
 	}
 	if (retval)
-		com_err("ext2fs_mkdir", retval, 0);
+		com_err("ext2fs_mkdir", retval,
+			_("while creating directory \"%s\""), name);
 	return retval;
 }
 
@@ -606,27 +606,25 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 
 	fd = ext2fs_open_file(src, O_RDONLY, 0);
 	if (fd < 0) {
-		com_err(src, errno, 0);
-		return errno;
+		retval = errno;
+		com_err(__func__, retval, _("while opening \"%s\" to copy"),
+			src);
+		return retval;
 	}
 	if (fstat(fd, &statbuf) < 0) {
-		com_err(src, errno, 0);
-		close(fd);
-		return errno;
+		retval = errno;
+		goto out;
 	}
 
 	retval = ext2fs_namei(fs, root, cwd, dest, &newfile);
 	if (retval == 0) {
-		close(fd);
-		return EXT2_ET_FILE_EXISTS;
+		retval = EXT2_ET_FILE_EXISTS;
+		goto out;
 	}
 
 	retval = ext2fs_new_inode(fs, cwd, 010755, 0, &newfile);
-	if (retval) {
-		com_err(__func__, retval, 0);
-		close(fd);
-		return retval;
-	}
+	if (retval)
+		goto out;
 #ifdef DEBUGFS
 	printf("Allocated inode: %u\n", newfile);
 #endif
@@ -634,19 +632,13 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 				EXT2_FT_REG_FILE);
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(fs, cwd);
-		if (retval) {
-			com_err(__func__, retval, "while expanding directory");
-			close(fd);
-			return retval;
-		}
+		if (retval)
+			goto out;
 		retval = ext2fs_link(fs, cwd, dest, newfile,
 					EXT2_FT_REG_FILE);
 	}
-	if (retval) {
-		com_err(dest, retval, 0);
-		close(fd);
-		return errno;
-	}
+	if (retval)
+		goto out;
 	if (ext2fs_test_inode_bitmap2(fs->inode_map, newfile))
 		com_err(__func__, 0, "Warning: inode already set");
 	ext2fs_inode_alloc_stats2(fs, newfile, +1, 0);
@@ -656,11 +648,8 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 		fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
 	retval = ext2fs_inode_size_set(fs, &inode, statbuf.st_size);
-	if (retval) {
-		com_err(dest, retval, 0);
-		close(fd);
-		return retval;
-	}
+	if (retval)
+		goto out;
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
@@ -671,31 +660,25 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 		inode.i_flags &= ~EXT4_EXTENTS_FL;
 		retval = ext2fs_extent_open2(fs, newfile, &inode, &handle);
 		if (retval)
-			return retval;
+			goto out;
 		ext2fs_extent_free(handle);
 	}
 
 	retval = ext2fs_write_new_inode(fs, newfile, &inode);
-	if (retval) {
-		com_err(__func__, retval, "while creating inode %u", newfile);
-		close(fd);
-		return retval;
-	}
+	if (retval)
+		goto out;
 	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
 		retval = ext2fs_inline_data_init(fs, newfile);
-		if (retval) {
-			com_err("copy_file", retval, 0);
-			close(fd);
-			return retval;
-		}
+		if (retval)
+			goto out;
 	}
 	if (LINUX_S_ISREG(inode.i_mode)) {
 		retval = copy_file(fs, fd, &statbuf, newfile);
 		if (retval)
-			com_err("copy_file", retval, _("while copying %s"), src);
+			goto out;
 	}
+out:
 	close(fd);
-
 	return retval;
 }
 
@@ -716,16 +699,18 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 	int		hdlink;
 
 	if (chdir(source_dir) < 0) {
-		com_err(__func__, errno,
+		retval = errno;
+		com_err(__func__, retval,
 			_("while changing working directory to \"%s\""),
 			source_dir);
-		return errno;
+		return retval;
 	}
 
 	if (!(dh = opendir("."))) {
-		com_err(__func__, errno,
+		retval = errno;
+		com_err(__func__, retval,
 			_("while opening directory \"%s\""), source_dir);
-		return errno;
+		return retval;
 	}
 
 	while ((dent = readdir(dh))) {
@@ -733,7 +718,8 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 		    (!strcmp(dent->d_name, "..")))
 			continue;
 		if (lstat(dent->d_name, &st)) {
-			com_err(__func__, errno, _("while lstat \"%s\""),
+			retval = errno;
+			com_err(__func__, retval, _("while lstat \"%s\""),
 				dent->d_name);
 			goto out;
 		}
@@ -775,10 +761,10 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 			read_cnt = readlink(name, ln_target,
 					    sizeof(ln_target) - 1);
 			if (read_cnt == -1) {
-				com_err(__func__, errno,
-					_("while trying to readlink \"%s\""),
-					name);
 				retval = errno;
+				com_err(__func__, retval,
+					_("while trying to read link \"%s\""),
+					name);
 				goto out;
 			}
 			ln_target[read_cnt] = '\0';
@@ -801,6 +787,10 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 			}
 			break;
 		case S_IFDIR:
+			/* Don't choke on /lost+found */
+			if (parent_ino == EXT2_ROOT_INO &&
+			    strcmp(name, "lost+found") == 0)
+				goto find_lnf;
 			retval = do_mkdir_internal(fs, parent_ino, name, &st,
 						   root);
 			if (retval) {
@@ -808,6 +798,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 					_("while making dir \"%s\""), name);
 				goto out;
 			}
+find_lnf:
 			retval = ext2fs_namei(fs, root, parent_ino,
 					      name, &ino);
 			if (retval) {
@@ -816,14 +807,12 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 			}
 			/* Populate the dir recursively*/
 			retval = __populate_fs(fs, ino, name, root, hdlinks);
-			if (retval) {
-				com_err(__func__, retval,
-					_("while adding dir \"%s\""), name);
+			if (retval)
 				goto out;
-			}
 			if (chdir("..")) {
-				com_err(__func__, errno, _("during cd .."));
 				retval = errno;
+				com_err(__func__, retval,
+					_("while changing directory"));
 				goto out;
 			}
 			break;
@@ -834,7 +823,8 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 
 		retval =  ext2fs_namei(fs, root, parent_ino, name, &ino);
 		if (retval) {
-			com_err(name, retval, 0);
+			com_err(name, retval, _("while looking up \"%s\""),
+				name);
 			goto out;
 		}
 
@@ -864,9 +854,9 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 						(hdlinks->size + HDLINK_CNT) *
 						sizeof(struct hdlink_s));
 				if (p == NULL) {
-					com_err(name, errno,
-						_("Not enough memory"));
 					retval = EXT2_ET_NO_MEMORY;
+					com_err(name, retval,
+						_("while saving inode data"));
 					goto out;
 				}
 				hdlinks->hdl = p;
@@ -890,12 +880,18 @@ errcode_t populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 	struct hdlinks_s hdlinks;
 	errcode_t retval;
 
+	if (!(fs->flags & EXT2_FLAG_RW)) {
+		com_err(__func__, 0, "Filesystem opened readonly");
+		return EROFS;
+	}
+
 	hdlinks.count = 0;
 	hdlinks.size = HDLINK_CNT;
 	hdlinks.hdl = realloc(NULL, hdlinks.size * sizeof(struct hdlink_s));
 	if (hdlinks.hdl == NULL) {
-		com_err(__func__, errno, "Not enough memory");
-		return errno;
+		retval = errno;
+		com_err(__func__, retval, _("while allocating memory"));
+		return retval;
 	}
 
 	retval = __populate_fs(fs, parent_ino, source_dir, root, &hdlinks);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 47b0b29..5572ec0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -3131,7 +3131,7 @@ no_journal:
 				     EXT2_ROOT_INO);
 		if (retval) {
 			com_err(program_name, retval, "%s",
-				_("\nError while populating file system\n"));
+				_("while populating file system"));
 			exit(1);
 		} else if (!quiet)
 			printf("%s", _("done\n"));
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index 096495c..47fa468 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -11,10 +11,10 @@ debugfs -R "symlink /l_70 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 debugfs -R "symlink /l_500 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
 debugfs -R "symlink /l_1023 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
 debugfs -R "symlink /l_1024 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
-ext2fs_symlink: Invalid argument passed to ext2 library 
+ext2fs_symlink: Invalid argument passed to ext2 library while creating symlink "l_1024"
 symlink: Invalid argument passed to ext2 library 
 debugfs -R "symlink /l_1500 /xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" test.img
-ext2fs_symlink: Invalid argument passed to ext2 library 
+ext2fs_symlink: Invalid argument passed to ext2 library while creating symlink "l_1500"
 symlink: Invalid argument passed to ext2 library 
 debugfs -R "stat /l_30" test.img
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0

