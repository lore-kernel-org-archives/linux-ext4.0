From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 09/11] ext4: subtree add kconfig options
Date: Mon, 08 Feb 2010 16:28:11 +0300
Message-ID: <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0BHO2d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:33 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:02 +0300 (MSK)
In-reply-to: <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/Kconfig  |    9 +++++++++
 fs/ext4/Makefile |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..6c05d1a 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -75,6 +75,15 @@ config EXT4_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
+config EXT4_SUBTREE
+	bool "Ext4 subtree support"
+	depends on EXT4_FS_XATTR
+	default y
+	help
+	  Enables subtree support for ext4 filesystem
+
+	  If you don't know what subtree are, say N
+
 config EXT4_DEBUG
 	bool "EXT4 debugging support"
 	depends on EXT4_FS
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 8867b2a..2c314ce 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -11,3 +11,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_SUBTREE)		+= subtree.o
-- 
1.6.3.3

