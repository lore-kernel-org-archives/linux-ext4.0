From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH -mm] Split fs/Kconfig: ext[234]
Date: Sat, 6 Oct 2007 12:15:08 +0400
Message-ID: <20071006081508.GA7924@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: akpm@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:26345 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXJFIPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Oct 2007 04:15:42 -0400
Received: by fk-out-0910.google.com with SMTP id z23so743689fkz
        for <linux-ext4@vger.kernel.org>; Sat, 06 Oct 2007 01:15:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/Kconfig      |  191 ----------------------------------------------
 fs/ext2/Kconfig |   55 +++++++++++++
 fs/ext3/Kconfig |   67 ++++++++++++++++
 fs/ext4/Kconfig |   65 +++++++++++++++
 4 files changed, 190 insertions(+), 188 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -6,61 +6,7 @@ menu "File systems"
 
 if BLOCK
 
-config EXT2_FS
-	tristate "Second extended fs support"
-	help
-	  Ext2 is a standard Linux file system for hard disks.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called ext2.
-
-	  If unsure, say Y.
-
-config EXT2_FS_XATTR
-	bool "Ext2 extended attributes"
-	depends on EXT2_FS
-	help
-	  Extended attributes are name:value pairs associated with inodes by
-	  the kernel or by users (see the attr(5) manual page, or visit
-	  <http://acl.bestbits.at/> for details).
-
-	  If unsure, say N.
-
-config EXT2_FS_POSIX_ACL
-	bool "Ext2 POSIX Access Control Lists"
-	depends on EXT2_FS_XATTR
-	select FS_POSIX_ACL
-	help
-	  Posix Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
-
-	  To learn more about Access Control Lists, visit the Posix ACLs for
-	  Linux website <http://acl.bestbits.at/>.
-
-	  If you don't know what Access Control Lists are, say N
-
-config EXT2_FS_SECURITY
-	bool "Ext2 Security Labels"
-	depends on EXT2_FS_XATTR
-	help
-	  Security labels support alternative access control models
-	  implemented by security modules like SELinux.  This option
-	  enables an extended attribute handler for file security
-	  labels in the ext2 filesystem.
-
-	  If you are not using a security module that requires using
-	  extended attributes for file security labels, say N.
-
-config EXT2_FS_XIP
-	bool "Ext2 execute in place support"
-	depends on EXT2_FS && MMU
-	help
-	  Execute in place can be used on memory-backed block devices. If you
-	  enable this option, you can select to mount block devices which are
-	  capable of this feature without using the page cache.
-
-	  If you do not use a block device that is capable of using this,
-	  or if unsure, say N.
+source "fs/ext2/Kconfig"
 
 config FS_XIP
 # execute in place
@@ -68,139 +14,8 @@ config FS_XIP
 	depends on EXT2_FS_XIP
 	default y
 
-config EXT3_FS
-	tristate "Ext3 journalling file system support"
-	select JBD
-	help
-	  This is the journalling version of the Second extended file system
-	  (often called ext3), the de facto standard Linux file system
-	  (method to organize files on a storage device) for hard disks.
-
-	  The journalling code included in this driver means you do not have
-	  to run e2fsck (file system checker) on your file systems after a
-	  crash.  The journal keeps track of any changes that were being made
-	  at the time the system crashed, and can ensure that your file system
-	  is consistent without the need for a lengthy check.
-
-	  Other than adding the journal to the file system, the on-disk format
-	  of ext3 is identical to ext2.  It is possible to freely switch
-	  between using the ext3 driver and the ext2 driver, as long as the
-	  file system has been cleanly unmounted, or e2fsck is run on the file
-	  system.
-
-	  To add a journal on an existing ext2 file system or change the
-	  behavior of ext3 file systems, you can use the tune2fs utility ("man
-	  tune2fs").  To modify attributes of files and directories on ext3
-	  file systems, use chattr ("man chattr").  You need to be using
-	  e2fsprogs version 1.20 or later in order to create ext3 journals
-	  (available at <http://sourceforge.net/projects/e2fsprogs/>).
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called ext3.
-
-config EXT3_FS_XATTR
-	bool "Ext3 extended attributes"
-	depends on EXT3_FS
-	default y
-	help
-	  Extended attributes are name:value pairs associated with inodes by
-	  the kernel or by users (see the attr(5) manual page, or visit
-	  <http://acl.bestbits.at/> for details).
-
-	  If unsure, say N.
-
-	  You need this for POSIX ACL support on ext3.
-
-config EXT3_FS_POSIX_ACL
-	bool "Ext3 POSIX Access Control Lists"
-	depends on EXT3_FS_XATTR
-	select FS_POSIX_ACL
-	help
-	  Posix Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
-
-	  To learn more about Access Control Lists, visit the Posix ACLs for
-	  Linux website <http://acl.bestbits.at/>.
-
-	  If you don't know what Access Control Lists are, say N
-
-config EXT3_FS_SECURITY
-	bool "Ext3 Security Labels"
-	depends on EXT3_FS_XATTR
-	help
-	  Security labels support alternative access control models
-	  implemented by security modules like SELinux.  This option
-	  enables an extended attribute handler for file security
-	  labels in the ext3 filesystem.
-
-	  If you are not using a security module that requires using
-	  extended attributes for file security labels, say N.
-
-config EXT4DEV_FS
-	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	select JBD2
-	select CRC16
-	help
-	  Ext4dev is a predecessor filesystem of the next generation
-	  extended fs ext4, based on ext3 filesystem code. It will be
-	  renamed ext4 fs later, once ext4dev is mature and stabilized.
-
-	  Unlike the change from ext2 filesystem to ext3 filesystem,
-	  the on-disk format of ext4dev is not the same as ext3 any more:
-	  it is based on extent maps and it supports 48-bit physical block
-	  numbers. These combined on-disk format changes will allow
-	  ext4dev/ext4 to handle more than 16 TB filesystem volumes --
-	  a hard limit that ext3 cannot overcome without changing the
-	  on-disk format.
-
-	  Other than extent maps and 48-bit block numbers, ext4dev also is
-	  likely to have other new features such as persistent preallocation,
-	  high resolution time stamps, and larger file support etc.  These
-	  features will be added to ext4dev gradually.
-
-	  To compile this file system support as a module, choose M here. The
-	  module will be called ext4dev.
-
-	  If unsure, say N.
-
-config EXT4DEV_FS_XATTR
-	bool "Ext4dev extended attributes"
-	depends on EXT4DEV_FS
-	default y
-	help
-	  Extended attributes are name:value pairs associated with inodes by
-	  the kernel or by users (see the attr(5) manual page, or visit
-	  <http://acl.bestbits.at/> for details).
-
-	  If unsure, say N.
-
-	  You need this for POSIX ACL support on ext4dev/ext4.
-
-config EXT4DEV_FS_POSIX_ACL
-	bool "Ext4dev POSIX Access Control Lists"
-	depends on EXT4DEV_FS_XATTR
-	select FS_POSIX_ACL
-	help
-	  POSIX Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
-
-	  To learn more about Access Control Lists, visit the POSIX ACLs for
-	  Linux website <http://acl.bestbits.at/>.
-
-	  If you don't know what Access Control Lists are, say N
-
-config EXT4DEV_FS_SECURITY
-	bool "Ext4dev Security Labels"
-	depends on EXT4DEV_FS_XATTR
-	help
-	  Security labels support alternative access control models
-	  implemented by security modules like SELinux.  This option
-	  enables an extended attribute handler for file security
-	  labels in the ext4dev/ext4 filesystem.
-
-	  If you are not using a security module that requires using
-	  extended attributes for file security labels, say N.
+source "fs/ext3/Kconfig"
+source "fs/ext4/Kconfig"
 
 config JBD
 	tristate
new file mode 100644
--- /dev/null
+++ b/fs/ext2/Kconfig
@@ -0,0 +1,55 @@
+config EXT2_FS
+	tristate "Second extended fs support"
+	help
+	  Ext2 is a standard Linux file system for hard disks.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called ext2.
+
+	  If unsure, say Y.
+
+config EXT2_FS_XATTR
+	bool "Ext2 extended attributes"
+	depends on EXT2_FS
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config EXT2_FS_POSIX_ACL
+	bool "Ext2 POSIX Access Control Lists"
+	depends on EXT2_FS_XATTR
+	select FS_POSIX_ACL
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the Posix ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
+
+config EXT2_FS_SECURITY
+	bool "Ext2 Security Labels"
+	depends on EXT2_FS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the ext2 filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
+
+config EXT2_FS_XIP
+	bool "Ext2 execute in place support"
+	depends on EXT2_FS && MMU
+	help
+	  Execute in place can be used on memory-backed block devices. If you
+	  enable this option, you can select to mount block devices which are
+	  capable of this feature without using the page cache.
+
+	  If you do not use a block device that is capable of using this,
+	  or if unsure, say N.
new file mode 100644
--- /dev/null
+++ b/fs/ext3/Kconfig
@@ -0,0 +1,67 @@
+config EXT3_FS
+	tristate "Ext3 journalling file system support"
+	select JBD
+	help
+	  This is the journalling version of the Second extended file system
+	  (often called ext3), the de facto standard Linux file system
+	  (method to organize files on a storage device) for hard disks.
+
+	  The journalling code included in this driver means you do not have
+	  to run e2fsck (file system checker) on your file systems after a
+	  crash.  The journal keeps track of any changes that were being made
+	  at the time the system crashed, and can ensure that your file system
+	  is consistent without the need for a lengthy check.
+
+	  Other than adding the journal to the file system, the on-disk format
+	  of ext3 is identical to ext2.  It is possible to freely switch
+	  between using the ext3 driver and the ext2 driver, as long as the
+	  file system has been cleanly unmounted, or e2fsck is run on the file
+	  system.
+
+	  To add a journal on an existing ext2 file system or change the
+	  behavior of ext3 file systems, you can use the tune2fs utility ("man
+	  tune2fs").  To modify attributes of files and directories on ext3
+	  file systems, use chattr ("man chattr").  You need to be using
+	  e2fsprogs version 1.20 or later in order to create ext3 journals
+	  (available at <http://sourceforge.net/projects/e2fsprogs/>).
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called ext3.
+
+config EXT3_FS_XATTR
+	bool "Ext3 extended attributes"
+	depends on EXT3_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+	  You need this for POSIX ACL support on ext3.
+
+config EXT3_FS_POSIX_ACL
+	bool "Ext3 POSIX Access Control Lists"
+	depends on EXT3_FS_XATTR
+	select FS_POSIX_ACL
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the Posix ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
+
+config EXT3_FS_SECURITY
+	bool "Ext3 Security Labels"
+	depends on EXT3_FS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the ext3 filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
new file mode 100644
--- /dev/null
+++ b/fs/ext4/Kconfig
@@ -0,0 +1,65 @@
+config EXT4DEV_FS
+	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	select JBD2
+	select CRC16
+	help
+	  Ext4dev is a predecessor filesystem of the next generation
+	  extended fs ext4, based on ext3 filesystem code. It will be
+	  renamed ext4 fs later, once ext4dev is mature and stabilized.
+
+	  Unlike the change from ext2 filesystem to ext3 filesystem,
+	  the on-disk format of ext4dev is not the same as ext3 any more:
+	  it is based on extent maps and it supports 48-bit physical block
+	  numbers. These combined on-disk format changes will allow
+	  ext4dev/ext4 to handle more than 16 TB filesystem volumes --
+	  a hard limit that ext3 cannot overcome without changing the
+	  on-disk format.
+
+	  Other than extent maps and 48-bit block numbers, ext4dev also is
+	  likely to have other new features such as persistent preallocation,
+	  high resolution time stamps, and larger file support etc.  These
+	  features will be added to ext4dev gradually.
+
+	  To compile this file system support as a module, choose M here. The
+	  module will be called ext4dev.
+
+	  If unsure, say N.
+
+config EXT4DEV_FS_XATTR
+	bool "Ext4dev extended attributes"
+	depends on EXT4DEV_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+	  You need this for POSIX ACL support on ext4dev/ext4.
+
+config EXT4DEV_FS_POSIX_ACL
+	bool "Ext4dev POSIX Access Control Lists"
+	depends on EXT4DEV_FS_XATTR
+	select FS_POSIX_ACL
+	help
+	  POSIX Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
+
+config EXT4DEV_FS_SECURITY
+	bool "Ext4dev Security Labels"
+	depends on EXT4DEV_FS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the ext4dev/ext4 filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
