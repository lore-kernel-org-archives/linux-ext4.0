From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
Subject: [PATCH] Support for "gnu" extended attributes namespace for ext3
Date: Thu, 12 Jun 2008 13:27:12 -0300
Message-ID: <20080612162711.GB13745@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:38690 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYFLQps (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 12:45:48 -0400
Received: from vespa.holoscopio.com (unknown [201.80.63.222])
	by liberdade.minaslivre.org (Postfix) with ESMTP id 637F8208D70
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 13:32:50 -0300 (BRT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This support is needed for some extended attributes used by the Hurd,
like translators.
---
 fs/ext3/Makefile    |    3 +-
 fs/ext3/xattr.c     |    2 +
 fs/ext3/xattr.h     |    2 +
 fs/ext3/xattr_gnu.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 1 deletions(-)
 create mode 100644 fs/ext3/xattr_gnu.c

diff --git a/fs/ext3/Makefile b/fs/ext3/Makefile
index e77766a..2198804 100644
--- a/fs/ext3/Makefile
+++ b/fs/ext3/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_EXT3_FS) += ext3.o
 ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
 
-ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
+ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o \
+				    xattr_gnu.o
 ext3-$(CONFIG_EXT3_FS_POSIX_ACL) += acl.o
 ext3-$(CONFIG_EXT3_FS_SECURITY)	 += xattr_security.o
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 175414a..1a8023a 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -114,6 +114,7 @@ static struct xattr_handler *ext3_xattr_handler_map[] = {
 #ifdef CONFIG_EXT3_FS_SECURITY
 	[EXT3_XATTR_INDEX_SECURITY]	     = &ext3_xattr_security_handler,
 #endif
+	[EXT3_XATTR_INDEX_GNU]		     = &ext3_xattr_gnu_handler,
 };
 
 struct xattr_handler *ext3_xattr_handlers[] = {
@@ -126,6 +127,7 @@ struct xattr_handler *ext3_xattr_handlers[] = {
 #ifdef CONFIG_EXT3_FS_SECURITY
 	&ext3_xattr_security_handler,
 #endif
+	&ext3_xattr_gnu_handler,
 	NULL
 };
 
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
index 148a4df..58824d0 100644
--- a/fs/ext3/xattr.h
+++ b/fs/ext3/xattr.h
@@ -21,6 +21,7 @@
 #define EXT3_XATTR_INDEX_TRUSTED		4
 #define	EXT3_XATTR_INDEX_LUSTRE			5
 #define EXT3_XATTR_INDEX_SECURITY	        6
+#define EXT3_XATTR_INDEX_GNU			7
 
 struct ext3_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -63,6 +64,7 @@ extern struct xattr_handler ext3_xattr_trusted_handler;
 extern struct xattr_handler ext3_xattr_acl_access_handler;
 extern struct xattr_handler ext3_xattr_acl_default_handler;
 extern struct xattr_handler ext3_xattr_security_handler;
+extern struct xattr_handler ext3_xattr_gnu_handler;
 
 extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
 
diff --git a/fs/ext3/xattr_gnu.c b/fs/ext3/xattr_gnu.c
new file mode 100644
index 0000000..c369f1e
--- /dev/null
+++ b/fs/ext3/xattr_gnu.c
@@ -0,0 +1,62 @@
+/*
+ * linux/fs/ext3/xattr_gnu.c
+ * Handler for GNU extended attributes.
+ *
+ * Copyright (C) 2003 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
+ * Copyright 2008 Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/capability.h>
+#include <linux/fs.h>
+#include <linux/ext3_jbd.h>
+#include <linux/ext3_fs.h>
+#include "xattr.h"
+
+#define XATTR_GNU_PREFIX "gnu."
+
+static size_t
+ext3_xattr_gnu_list(struct inode *inode, char *list, size_t list_size,
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
+ext3_xattr_gnu_get(struct inode *inode, const char *name,
+		       void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ext3_xattr_get(inode, EXT3_XATTR_INDEX_GNU, name,
+			      buffer, size);
+}
+
+static int
+ext3_xattr_gnu_set(struct inode *inode, const char *name,
+		       const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ext3_xattr_set(inode, EXT3_XATTR_INDEX_GNU, name,
+			      value, size, flags);
+}
+
+struct xattr_handler ext3_xattr_gnu_handler = {
+	.prefix	= XATTR_GNU_PREFIX,
+	.list	= ext3_xattr_gnu_list,
+	.get	= ext3_xattr_gnu_get,
+	.set	= ext3_xattr_gnu_set,
+};
-- 
1.5.5.4
