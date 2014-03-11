From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/49] create_inode: minor cleanups
Date: Mon, 10 Mar 2014 23:54:11 -0700
Message-ID: <20140311065410.30585.93415.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21006 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaCKGyO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:14 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a couple of small style issues in the create_inode files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |   42 ++++++++++++++++++++++++++++--------------
 misc/create_inode.h |    5 +++++
 2 files changed, 33 insertions(+), 14 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 647480c..b204e71 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -1,3 +1,6 @@
+#include <time.h>
+#include <unistd.h>
+
 #include "create_inode.h"
 
 #if __STDC_VERSION__ < 199901L
@@ -179,7 +182,8 @@ errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		if ((retval =  ext2fs_namei(current_fs, root, cwd, name, &parent_ino))){
+		retval = ext2fs_namei(current_fs, root, cwd, name, &parent_ino);
+		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
 		}
@@ -216,7 +220,8 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 	cp = strrchr(name, '/');
 	if (cp) {
 		*cp = 0;
-		if ((retval =  ext2fs_namei(current_fs, root, cwd, name, &parent_ino))){
+		retval = ext2fs_namei(current_fs, root, cwd, name, &parent_ino);
+		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
 		}
@@ -409,7 +414,8 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 		inode.i_flags |= EXT4_EXTENTS_FL;
 	}
 
-	if ((retval = ext2fs_write_new_inode(current_fs, newfile, &inode))) {
+	retval = ext2fs_write_new_inode(current_fs, newfile, &inode);
+	if (retval) {
 		com_err(__func__, retval, "while creating inode %u", newfile);
 		close(fd);
 		return retval;
@@ -464,12 +470,12 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 
 	if (!(dh = opendir("."))) {
 		com_err(__func__, errno,
-			_("while openning directory \"%s\""), source_dir);
+			_("while opening directory \"%s\""), source_dir);
 		return errno;
 	}
 
-	while((dent = readdir(dh))) {
-		if((!strcmp(dent->d_name, ".")) || (!strcmp(dent->d_name, "..")))
+	while ((dent = readdir(dh))) {
+		if ((!strcmp(dent->d_name, ".")) || (!strcmp(dent->d_name, "..")))
 			continue;
 		lstat(dent->d_name, &st);
 		name = dent->d_name;
@@ -494,7 +500,8 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 			case S_IFCHR:
 			case S_IFBLK:
 			case S_IFIFO:
-				if ((retval = do_mknod_internal(parent_ino, name, &st))) {
+				retval = do_mknod_internal(parent_ino, name, &st);
+				if (retval) {
 					com_err(__func__, retval,
 						_("while creating special file \"%s\""), name);
 					return retval;
@@ -506,32 +513,37 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 					_("ignoring socket file \"%s\""), name);
 				continue;
 			case S_IFLNK:
-				if((read_cnt = readlink(name, ln_target, sizeof(ln_target))) == -1) {
+				read_cnt = readlink(name, ln_target, sizeof(ln_target));
+				if (read_cnt == -1) {
 					com_err(__func__, errno,
 						_("while trying to readlink \"%s\""), name);
 					return errno;
 				}
 				ln_target[read_cnt] = '\0';
-				if ((retval = do_symlink_internal(parent_ino, name, ln_target))) {
+				retval = do_symlink_internal(parent_ino, name, ln_target);
+				if (retval) {
 					com_err(__func__, retval,
 						_("while writing symlink\"%s\""), name);
 					return retval;
 				}
 				break;
 			case S_IFREG:
-				if ((retval = do_write_internal(parent_ino, name, name))) {
+				retval = do_write_internal(parent_ino, name, name);
+				if (retval) {
 					com_err(__func__, retval,
 						_("while writing file \"%s\""), name);
 					return retval;
 				}
 				break;
 			case S_IFDIR:
-				if ((retval = do_mkdir_internal(parent_ino, name, &st))) {
+				retval = do_mkdir_internal(parent_ino, name, &st);
+				if (retval) {
 					com_err(__func__, retval,
 						_("while making dir \"%s\""), name);
 					return retval;
 				}
-				if ((retval = ext2fs_namei(current_fs, root, parent_ino, name, &ino))) {
+				retval = ext2fs_namei(current_fs, root, parent_ino, name, &ino);
+				if (retval) {
 					com_err(name, retval, 0);
 						return retval;
 				}
@@ -548,12 +560,14 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 					_("ignoring entry \"%s\""), name);
 		}
 
-		if ((retval =  ext2fs_namei(current_fs, root, parent_ino, name, &ino))){
+		retval =  ext2fs_namei(current_fs, root, parent_ino, name, &ino);
+		if (retval) {
 			com_err(name, retval, 0);
 			return retval;
 		}
 
-		if ((retval = set_inode_extra(parent_ino, ino, &st))) {
+		retval = set_inode_extra(parent_ino, ino, &st);
+		if (retval) {
 			com_err(__func__, retval,
 				_("while setting inode for \"%s\""), name);
 			return retval;
diff --git a/misc/create_inode.h b/misc/create_inode.h
index 2b6d429..79742e8 100644
--- a/misc/create_inode.h
+++ b/misc/create_inode.h
@@ -1,3 +1,6 @@
+#ifndef _CREATE_INODE_H
+#define _CREATE_INODE_H
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -33,3 +36,5 @@ extern errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat
 extern errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target);
 extern errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st);
 extern errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest);
+
+#endif /* _CREATE_INODE_H */

