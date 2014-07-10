From: Ross Burton <ross.burton@intel.com>
Subject: [PATCH][V3] misc: copy extended attributes in populate_fs
Date: Thu, 10 Jul 2014 17:39:49 +0100
Message-ID: <1405010389-25988-1-git-send-email-ross.burton@intel.com>
Cc: darrick.wong@oracle.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44970 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGJQkN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 12:40:13 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so723436wib.14
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 09:40:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When creating a file system using a source directory, also copy any extended
attributes that have been set.

Signed-off-by: Ross Burton <ross.burton@intel.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index c9c99b5..1a5c378 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -103,6 +103,89 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
 	return retval;
 }
 
+static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *filename)
+{
+	errcode_t			retval, close_retval;
+	struct ext2_inode		inode;
+	struct ext2_xattr_handle	*handle;
+	ssize_t				size, value_size;
+	char				*list;
+	int				i;
+
+	size = llistxattr(filename, NULL, 0);
+	if (size == -1) {
+		com_err(__func__, errno, "llistxattr failed on %s", filename);
+		return errno;
+	} else if (size == 0) {
+		return 0;
+	}
+
+	retval = ext2fs_xattrs_open(fs, ino, &handle);
+	if (retval) {
+		if (retval == EXT2_ET_MISSING_EA_FEATURE)
+			return 0;
+		com_err(__func__, retval, "while opening inode %u", ino);
+		return retval;
+	}
+
+	retval = ext2fs_get_mem(size, &list);
+	if (retval) {
+		com_err(__func__, retval, "whilst allocating memory");
+		goto out;
+	}
+
+	size = llistxattr(filename, list, size);
+	if (size == -1) {
+		com_err(__func__, errno, "llistxattr failed on %s", filename);
+		retval = errno;
+		goto out;
+        }
+
+	for (i = 0; i < size; i += strlen(&list[i]) + 1) {
+		const char *name = &list[i];
+		char *value;
+
+		value_size = getxattr(filename, name, NULL, 0);
+		if (value_size == -1) {
+			com_err(__func__, errno, "getxattr failed on %s", filename);
+			retval = errno;
+			break;
+		}
+
+		retval = ext2fs_get_mem(value_size, &value);
+		if (retval) {
+			com_err(__func__, retval, "whilst allocating memory");
+			break;
+		}
+
+		value_size = getxattr(filename, name, value, value_size);
+		if (value_size == -1) {
+			ext2fs_free_mem(&value);
+			com_err(__func__, errno, "getxattr failed on %s", filename);
+			retval = errno;
+			break;
+		}
+
+		retval = ext2fs_xattr_set(handle, name, value, value_size);
+		ext2fs_free_mem(&value);
+		if (retval) {
+			com_err(__func__, retval, "while writing xattr %u", ino);
+			break;
+		}
+
+	}
+ out:
+	ext2fs_free_mem(&list);
+
+	close_retval = ext2fs_xattrs_close(&handle);
+	if (close_retval) {
+		com_err(__func__, retval, "while closing inode %u", ino);
+		retval = retval ? close_retval;
+	}
+
+	return retval;
+}
+
 /* Make a special files (block and character devices), fifo's, and sockets  */
 errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 			    struct stat *st)
@@ -615,6 +698,13 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 			goto out;
 		}
 
+		retval = set_inode_xattr(fs, ino, name);
+		if (retval) {
+			com_err(__func__, retval,
+				_("while setting xattrs for \"%s\""), name);
+			goto out;
+		}
+
 		/* Save the hardlink ino */
 		if (save_inode) {
 			/*
-- 
1.7.10.4

