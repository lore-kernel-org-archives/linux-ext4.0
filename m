From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
Subject: [PATCH] Support for namespace "gnu" for extended attributes in ext2
Date: Thu, 12 Jun 2008 13:26:52 -0300
Message-ID: <20080612162644.GA13745@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:42840 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYFLQps (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 12:45:48 -0400
Received: from vespa.holoscopio.com (unknown [201.80.63.222])
	by liberdade.minaslivre.org (Postfix) with ESMTP id C07D9208D6F
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 13:32:30 -0300 (BRT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds support for the "gnu" extended attributes namespace in
ext2. This namespace is needed for Hurd, for things like translators.
---
 fs/ext2/Makefile    |    3 +-
 fs/ext2/xattr.c     |    2 +
 fs/ext2/xattr.h     |    2 +
 fs/ext2/xattr_gnu.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100644 fs/ext2/xattr_gnu.c

diff --git a/fs/ext2/Makefile b/fs/ext2/Makefile
index e0b2b43..42184c1 100644
--- a/fs/ext2/Makefile
+++ b/fs/ext2/Makefile
@@ -7,7 +7,8 @@ obj-$(CONFIG_EXT2_FS) += ext2.o
 ext2-y := balloc.o dir.o file.o fsync.o ialloc.o inode.o \
 	  ioctl.o namei.o super.o symlink.o
 
-ext2-$(CONFIG_EXT2_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
+ext2-$(CONFIG_EXT2_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o \
+				    xattr_gnu.o
 ext2-$(CONFIG_EXT2_FS_POSIX_ACL) += acl.o
 ext2-$(CONFIG_EXT2_FS_SECURITY)	 += xattr_security.o
 ext2-$(CONFIG_EXT2_FS_XIP)	 += xip.o
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 987a526..93717ff 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -110,6 +110,7 @@ static struct xattr_handler *ext2_xattr_handler_map[] = {
 #ifdef CONFIG_EXT2_FS_SECURITY
 	[EXT2_XATTR_INDEX_SECURITY]	     = &ext2_xattr_security_handler,
 #endif
+	[EXT2_XATTR_INDEX_GNU]		     = &ext2_xattr_gnu_handler,
 };
 
 struct xattr_handler *ext2_xattr_handlers[] = {
@@ -122,6 +123,7 @@ struct xattr_handler *ext2_xattr_handlers[] = {
 #ifdef CONFIG_EXT2_FS_SECURITY
 	&ext2_xattr_security_handler,
 #endif
+	&ext2_xattr_gnu_handler,
 	NULL
 };
 
diff --git a/fs/ext2/xattr.h b/fs/ext2/xattr.h
index bf8175b..da3b5c7 100644
--- a/fs/ext2/xattr.h
+++ b/fs/ext2/xattr.h
@@ -22,6 +22,7 @@
 #define EXT2_XATTR_INDEX_TRUSTED		4
 #define	EXT2_XATTR_INDEX_LUSTRE			5
 #define EXT2_XATTR_INDEX_SECURITY	        6
+#define EXT2_XATTR_INDEX_GNU			7
 
 struct ext2_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -60,6 +61,7 @@ extern struct xattr_handler ext2_xattr_trusted_handler;
 extern struct xattr_handler ext2_xattr_acl_access_handler;
 extern struct xattr_handler ext2_xattr_acl_default_handler;
 extern struct xattr_handler ext2_xattr_security_handler;
+extern struct xattr_handler ext2_xattr_gnu_handler;
 
 extern ssize_t ext2_listxattr(struct dentry *, char *, size_t);
 
diff --git a/fs/ext2/xattr_gnu.c b/fs/ext2/xattr_gnu.c
new file mode 100644
index 0000000..9515438
--- /dev/null
+++ b/fs/ext2/xattr_gnu.c
@@ -0,0 +1,56 @@
+/*
+ * linux/fs/ext2/xattr_user.c
+ * Handler for extended user attributes.
+ *
+ * Copyright (C) 2001 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include "ext2.h"
+#include "xattr.h"
+
+#define XATTR_GNU_PREFIX "gnu."
+
+static size_t
+ext2_xattr_gnu_list(struct inode *inode, char *list, size_t list_size,
+		     const char *name, size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_GNU_PREFIX)-1;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_GNU_PREFIX, prefix_len);
+		memcpy(list+prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int
+ext2_xattr_gnu_get(struct inode *inode, const char *name,
+		    void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ext2_xattr_get(inode, EXT2_XATTR_INDEX_GNU, name, buffer, size);
+}
+
+static int
+ext2_xattr_user_set(struct inode *inode, const char *name,
+		    const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ext2_xattr_set(inode, EXT2_XATTR_INDEX_GNU, name,
+			      value, size, flags);
+}
+
+struct xattr_handler ext2_xattr_gnu_handler = {
+	.prefix	= XATTR_GNU_PREFIX,
+	.list	= ext2_xattr_gnu_list,
+	.get	= ext2_xattr_gnu_get,
+	.set	= ext2_xattr_gnu_set,
+};
-- 
1.5.5.4
