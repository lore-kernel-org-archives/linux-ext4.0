From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Documenatation: remove acl and user_xattr mount options
Date: Tue, 28 Jun 2011 17:21:17 +0200
Message-ID: <1309274477-451-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383Ab1F1PVW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 11:21:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Acl and user_xattr mount options are no longer needed since those
features are enabled by default if configured in (seee commit
ea6633369458992241599c9d9ebadffaeddec164). We can not easily
deprecate mount options itself (since it is probably too early),
but we can remove it from documentation first.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 Documentation/filesystems/ext4.txt |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 3ae9bc9..9544e2c 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -209,22 +209,19 @@ oldalloc		This disables the Orlov block allocator and enables
 			performance - we'd like to get some feedback if it's
 			the contrary for you.
 
-user_xattr		Enables Extended User Attributes.  Additionally, you
-			need to have extended attribute support enabled in the
-			kernel configuration (CONFIG_EXT4_FS_XATTR).  See the
-			attr(5) manual page and http://acl.bestbits.at/ to
-			learn more about extended attributes.
-
-nouser_xattr		Disables Extended User Attributes.
-
-acl			Enables POSIX Access Control Lists support.
-			Additionally, you need to have ACL support enabled in
-			the kernel configuration (CONFIG_EXT4_FS_POSIX_ACL).
-			See the acl(5) manual page and http://acl.bestbits.at/
-			for more information.
+nouser_xattr		Disables Extended User Attributes. If you have extended
+			attribute support enabled in the kernel configuration
+			(CONFIG_EXT4_FS_XATTR), extended attribute support
+			is enabled by default on mount. See the attr(5) manual
+			page and http://acl.bestbits.at/ for more information
+			about extended attributes.
 
 noacl			This option disables POSIX Access Control List
-			support.
+			support. If ACL support is enabled in the kernel
+			configuration (CONFIG_EXT4_FS_POSIX_ACL), ACL is
+			enabled by default on mount. See the acl(5) manual
+			page and http://acl.bestbits.at/ for more information
+			about acl.
 
 bsddf		(*)	Make 'df' act like BSD.
 minixdf			Make 'df' act like Minix.
-- 
1.7.4.4

