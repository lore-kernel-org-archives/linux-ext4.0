From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Ext4: Make file creation time,
	i_version and i_generation available by xattrs
Date: Mon, 28 Jun 2010 17:26:27 +0100
Message-ID: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make the file creation time, inode data version number and inode generation
number available on Ext4 by as xattrs named:

	file.crtime
	file.i_generation
	file.i_version (directories only for ext4)

This could then be used by Samba as the SMB protocol passes the file creation
time to the client.

With this patch, you can see the xattrs providing binary data:

[root@andromeda ~]# getfattr -d /var/cache/fscache -e hex -m\.*
getfattr: Removing leading '/' from absolute path names
# file: var/cache/fscache
file.crtime=0x53ba244c000000000000000000000000
file.i_generation=0x0000000000000000
file.i_version=0x0400000000000000
security.selinux=0x73797374656d5f753a6f626a6563745f723a636163686566696c65735f7661725f743a733000
[root@andromeda ~]# getfattr -d /var/cache/fscache/cull_atimes -e hex -m\.*
getfattr: Removing leading '/' from absolute path names
# file: var/cache/fscache/cull_atimes
file.crtime=0x83ba244c0000000019a3632a00000000
file.i_generation=0x73ab85f500000000
security.selinux=0x73797374656d5f753a6f626a6563745f723a636163686566696c65735f7661725f743a733000
user.CacheFiles.atime_base=0x30303030303030303463323464363239


Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/Makefile      |    4 +-
 fs/ext4/xattr.c       |   39 ++++++++++++------
 fs/ext4/xattr.h       |    2 +
 fs/ext4/xattr_file.c  |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/xattr.h |    3 +
 5 files changed, 142 insertions(+), 14 deletions(-)
 create mode 100644 fs/ext4/xattr_file.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 8867b2a..034dd27 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -8,6 +8,8 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
 		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o
 
-ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
+ext4-$(CONFIG_EXT4_FS_XATTR) += \
+	xattr.o xattr_user.o xattr_trusted.o xattr_file.o
+
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0433800..1360f7c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -111,6 +111,7 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
 	&ext4_xattr_user_handler,
+	&ext4_xattr_file_handler,
 	&ext4_xattr_trusted_handler,
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	&ext4_xattr_acl_access_handler,
@@ -427,23 +428,35 @@ cleanup:
 static int
 ext4_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
-	int i_error, b_error;
+	int ret, result = 0;
 
 	down_read(&EXT4_I(dentry->d_inode)->xattr_sem);
-	i_error = ext4_xattr_ibody_list(dentry, buffer, buffer_size);
-	if (i_error < 0) {
-		b_error = 0;
-	} else {
-		if (buffer) {
-			buffer += i_error;
-			buffer_size -= i_error;
-		}
-		b_error = ext4_xattr_block_list(dentry, buffer, buffer_size);
-		if (b_error < 0)
-			i_error = 0;
+	ret = ext4_xattr_ibody_list(dentry, buffer, buffer_size);
+	if (ret < 0)
+		goto error;
+	result += ret;
+	if (buffer) {
+		buffer += ret;
+		buffer_size -= ret;
+	}
+
+	ret = ext4_xattr_block_list(dentry, buffer, buffer_size);
+	if (ret < 0)
+		goto error;
+	result += ret;
+	if (buffer) {
+		buffer += ret;
+		buffer_size -= ret;
 	}
+
+	ret = ext4_xattr_file_list(dentry, buffer, buffer_size);
+	if (ret < 0)
+		goto error;
+	result += ret;
+
+error:
 	up_read(&EXT4_I(dentry->d_inode)->xattr_sem);
-	return i_error + b_error;
+	return ret < 0 ? ret : result;
 }
 
 /*
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 518e96e..f0e3aaf 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -66,12 +66,14 @@ struct ext4_xattr_entry {
 # ifdef CONFIG_EXT4_FS_XATTR
 
 extern const struct xattr_handler ext4_xattr_user_handler;
+extern const struct xattr_handler ext4_xattr_file_handler;
 extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_acl_access_handler;
 extern const struct xattr_handler ext4_xattr_acl_default_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
+extern int ext4_xattr_file_list(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
diff --git a/fs/ext4/xattr_file.c b/fs/ext4/xattr_file.c
new file mode 100644
index 0000000..81044c5
--- /dev/null
+++ b/fs/ext4/xattr_file.c
@@ -0,0 +1,108 @@
+/* File-specific xattrs
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/capability.h>
+#include <linux/fs.h>
+#include "ext4_jbd2.h"
+#include "ext4.h"
+#include "xattr.h"
+
+static const char *ext4_file_xattrs[] = {
+	"crtime",
+	"i_generation"
+};
+
+static const char *ext4_dir_xattrs[] = {
+	"i_version",
+};
+
+int
+ext4_xattr_file_list(struct dentry *dentry, char *list, size_t list_size)
+{
+	struct ext4_inode_info *ei = EXT4_I(dentry->d_inode);
+	const size_t prefix_len = XATTR_FILE_PREFIX_LEN;
+	int total_len = 0;
+	int loop;
+
+	for (loop = 0; loop < ARRAY_SIZE(ext4_file_xattrs); loop++) {
+		const char *fxname = ext4_file_xattrs[loop];
+		int fxnlen = strlen(fxname);
+
+		total_len += prefix_len + fxnlen + 1;
+		if (list && total_len <= list_size) {
+			memcpy(list, XATTR_FILE_PREFIX, prefix_len);
+			list += prefix_len;
+			memcpy(list, fxname, fxnlen + 1);
+			list += fxnlen + 1;
+		}
+	}
+
+	if (!S_ISDIR(ei->vfs_inode.i_mode))
+		goto out;
+
+	/* Ext4 only supports i_version on directories */
+	for (loop = 0; loop < ARRAY_SIZE(ext4_dir_xattrs); loop++) {
+		const char *fxname = ext4_dir_xattrs[loop];
+		int fxnlen = strlen(fxname);
+
+		total_len += prefix_len + fxnlen + 1;
+		if (list && total_len <= list_size) {
+			memcpy(list, XATTR_FILE_PREFIX, prefix_len);
+			list += prefix_len;
+			memcpy(list, fxname, fxnlen + 1);
+			list += fxnlen + 1;
+		}
+	}
+
+out:
+	return total_len;
+}
+
+static int
+ext4_xattr_file_get(struct dentry *dentry, const char *name, void *buffer,
+		    size_t size, int type)
+{
+	struct ext4_inode_info *ei = EXT4_I(dentry->d_inode);
+	size_t result_size;
+	union {
+		struct timespec ts;
+		u64 val;
+	} result;
+
+	if (strcmp(name, "crtime") == 0) {
+		result_size = sizeof(struct timespec);
+		result.ts = ei->i_crtime;
+	} else if (strcmp(name, "i_version") == 0) {
+		if (!S_ISDIR(ei->vfs_inode.i_mode))
+			return -ENOTDIR;
+		result_size = sizeof(u64);
+		result.val = ei->vfs_inode.i_version;
+	} else if (strcmp(name, "i_generation") == 0) {
+		result_size = sizeof(u64);
+		result.val = ei->vfs_inode.i_generation;
+	} else {
+		return -EINVAL;
+	}
+
+	if (size == 0)
+		return result_size;
+	if (size < result_size)
+		return -E2BIG;
+	memcpy(buffer, &result, result_size);
+	return result_size;
+}
+
+const struct xattr_handler ext4_xattr_file_handler = {
+	.prefix	= XATTR_FILE_PREFIX,
+	.get	= ext4_xattr_file_get,
+};
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 0cfa1e9..e52a8ce 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -33,6 +33,9 @@
 #define XATTR_USER_PREFIX "user."
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
+#define XATTR_FILE_PREFIX "file."
+#define XATTR_FILE_PREFIX_LEN (sizeof (XATTR_FILE_PREFIX) - 1)
+
 struct inode;
 struct dentry;
 

