From: Ross Burton <ross.burton@intel.com>
Subject: [PATCH] misc: copy extended attributes in populate_fs
Date: Fri, 27 Jun 2014 22:02:17 +0100
Message-ID: <1403902937-2781-2-git-send-email-ross.burton@intel.com>
References: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
Cc: dvhart@linux.intel.com, tytso@mit.edu, darrick.wong@oracle.com,
	liezhi.yang@windriver.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43335 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaF0VCa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2014 17:02:30 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so5856899wgh.16
        for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2014 14:02:29 -0700 (PDT)
In-Reply-To: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When creating a file system using a source directory, also copy any extended
attributes that have been set.

Signed-off-by: Ross Burton <ross.burton@intel.com>
---
 misc/create_inode.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index c9c99b5..2795f9e 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -103,6 +103,55 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
 	return retval;
 }
 
+static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *filename)
+{
+	errcode_t			retval;
+	struct ext2_inode		inode;
+	struct ext2_xattr_handle	*handle;
+	ssize_t				size, value_size;
+	char				*list;
+	int				i;
+
+	size = llistxattr(filename, NULL, 0);
+	if (size == -1) {
+		com_err(__func__, errno, "listxattr failed on %s", filename);
+		return errno;
+	} else if (size == 0) {
+		return 0;
+	}
+
+	retval = ext2fs_xattrs_open(fs, ino, &handle);
+	if (retval) {
+		com_err(__func__, errno, "while opening inode %u", ino);
+		return errno;
+	}
+
+	list = malloc(size);
+	size = llistxattr(filename, list, size);
+
+	for (i = 0; i < size; i += strlen(&list[i]) + 1) {
+		const char *name = &list[i];
+		char *value;
+
+		value_size = getxattr(filename, name, NULL, 0);
+		value = malloc(value_size);
+		value_size = getxattr(filename, name, value, value_size);
+
+		retval = ext2fs_xattr_set(handle, name, value, value_size);
+		if (retval)
+			com_err(__func__, retval, "while writing xattr %u", ino);
+
+		free (value);
+	}
+	free(list);
+
+	retval = ext2fs_xattrs_close(&handle);
+	if (retval)
+		com_err(__func__, errno, "while closing inode %u", ino);
+
+	return retval;
+}
+
 /* Make a special files (block and character devices), fifo's, and sockets  */
 errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 			    struct stat *st)
@@ -615,6 +664,13 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
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

