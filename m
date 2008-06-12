From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
Subject: [PATCH] Support for "gnu" extended attributes namespace for ext4
Date: Thu, 12 Jun 2008 13:27:37 -0300
Message-ID: <20080612162737.GC13745@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:41845 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYFLRC2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 13:02:28 -0400
Received: from vespa.holoscopio.com (unknown [201.80.63.222])
	by liberdade.minaslivre.org (Postfix) with ESMTP id 87B46208D71
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 13:33:15 -0300 (BRT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This support is needed for GNU Hurd, for things like active translators.
---
 fs/ext4/Makefile    |    3 +-
 fs/ext4/xattr.c     |    2 +
 fs/ext4/xattr.h     |    2 +
 fs/ext4/xattr_gnu.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 1 deletions(-)
 create mode 100644 fs/ext4/xattr_gnu.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index ac6fa8c..b148ba8 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -8,6 +8,7 @@ ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
 		   ext4_jbd2.o migrate.o mballoc.o
 
-ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
+ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o \
+					   xattr_trusted.o xattr_gnu.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
 ext4dev-$(CONFIG_EXT4DEV_FS_SECURITY)	+= xattr_security.o
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ff08633..6c47327 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,7 @@ static struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4DEV_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+	[EXT4_XATTR_INDEX_GNU]		     = &ext4_xattr_gnu_handler,
 };
 
 struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +120,7 @@ struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4DEV_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+	&ext4_xattr_gnu_handler,
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 5992fe9..bb481b4 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_GNU			7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -70,6 +71,7 @@ extern struct xattr_handler ext4_xattr_trusted_handler;
 extern struct xattr_handler ext4_xattr_acl_access_handler;
 extern struct xattr_handler ext4_xattr_acl_default_handler;
 extern struct xattr_handler ext4_xattr_security_handler;
+extern struct xattr_handler ext4_xattr_gnu_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
diff --git a/fs/ext4/xattr_gnu.c b/fs/ext4/xattr_gnu.c
new file mode 100644
index 0000000..039f839
--- /dev/null
+++ b/fs/ext4/xattr_gnu.c
@@ -0,0 +1,62 @@
+/*
+ * linux/fs/ext4/xattr_gnu.c
+ * Handler for gnu extended attributes.
+ *
+ * Copyright (C) 2003 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
+ * Copyright Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/capability.h>
+#include <linux/fs.h>
+#include <linux/ext4_jbd2.h>
+#include <linux/ext4_fs.h>
+#include "xattr.h"
+
+#define XATTR_GNU_PREFIX "gnu."
+
+static size_t
+ext4_xattr_gnu_list(struct inode *inode, char *list, size_t list_size,
+			const char *name, size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_GNU_PREFIX)-1;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
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
+ext4_xattr_gnu_get(struct inode *inode, const char *name,
+		       void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ext4_xattr_get(inode, EXT4_XATTR_INDEX_GNU, name,
+			      buffer, size);
+}
+
+static int
+ext4_xattr_gnu_set(struct inode *inode, const char *name,
+		       const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ext4_xattr_set(inode, EXT4_XATTR_INDEX_GNU, name,
+			      value, size, flags);
+}
+
+struct xattr_handler ext4_xattr_gnu_handler = {
+	.prefix	= XATTR_GNU_PREFIX,
+	.list	= ext4_xattr_gnu_list,
+	.get	= ext4_xattr_gnu_get,
+	.set	= ext4_xattr_gnu_set,
+};
-- 
1.5.5.4
