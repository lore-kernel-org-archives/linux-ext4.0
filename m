From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 146/148] fs/Kconfig: move ext2, ext3, ext4, JBD, JBD2
	out
Date: Mon, 20 Oct 2008 22:28:45 +0400
Message-ID: <20081020182845.GA7079@x200.localdomain>
References: <200810190328.m9J3Snvw000579@imap1.linux-foundation.org> <alpine.LFD.2.00.0810200847310.8651@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:13764 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYJTSZj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 14:25:39 -0400
Received: by ug-out-1314.google.com with SMTP id k3so779834ugf.37
        for <linux-ext4@vger.kernel.org>; Mon, 20 Oct 2008 11:25:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810200847310.8651@nehalem.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 20, 2008 at 08:49:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 18 Oct 2008, akpm@linux-foundation.org wrote:
> > 
> > Use fs/*/Kconfig more, which is good because everything related to one
> > filesystem is in one place and fs/Kconfig is quite fat.
> 
> Umm.
> 
> This removes the EXT2 things from fs/Kconfig, but leaves everything else. 
> So now EXT3/EXT4 and JDB/JDB2 symbols are done twice! Well, JDB/JDB2 
> aren't actually wired up, because there's no "source fs/jdb[2]/Kconfig 
> added.
> 
> Whaa?
> 
> Not applied. Please fix, or explain why the obvious bug was intentional.

Umm, indeed.

JBD/JBD2 removal chunk dissapeared somewhere, presumably because Andrew
becoming the most professional reject fixer in the world.

Patch in my "sent" mailbox definitely contains JBD/JBD2 chunk, but
ext4 people renamed ext4 so it won't apply anyway, so here is new patch
against HEAD:



[PATCH] fs/Kconfig: move ext2, ext3, ext4, JBD, JBD2 out

Use fs/*/Kconfig more, which is good because everything related to one
filesystem is in one place and fs/Kconfig is quite fat.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/Kconfig      |  272 +-------------------------------------------------------
 fs/ext2/Kconfig |   55 +++++++++++
 fs/ext3/Kconfig |   67 +++++++++++++
 fs/ext4/Kconfig |   79 ++++++++++++++++
 fs/jbd/Kconfig  |   30 ++++++
 fs/jbd2/Kconfig |   33 ++++++
 6 files changed, 269 insertions(+), 267 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -6,61 +6,9 @@ menu "File systems"
 
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
+source "fs/ext3/Kconfig"
+source "fs/ext4/Kconfig"
 
 config FS_XIP
 # execute in place
@@ -68,218 +16,8 @@ config FS_XIP
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
-config EXT4_FS
-	tristate "The Extended 4 (ext4) filesystem"
-	select JBD2
-	select CRC16
-	help
-	  This is the next generation of the ext3 filesystem.
-
-	  Unlike the change from ext2 filesystem to ext3 filesystem,
-	  the on-disk format of ext4 is not forwards compatible with
-	  ext3; it is based on extent maps and it supports 48-bit
-	  physical block numbers.  The ext4 filesystem also supports delayed
-	  allocation, persistent preallocation, high resolution time stamps,
-	  and a number of other features to improve performance and speed
-	  up fsck time.  For more information, please see the web pages at
-	  http://ext4.wiki.kernel.org.
-
-	  The ext4 filesystem will support mounting an ext3
-	  filesystem; while there will be some performance gains from
-	  the delayed allocation and inode table readahead, the best
-	  performance gains will require enabling ext4 features in the
-	  filesystem, or formating a new filesystem as an ext4
-	  filesystem initially.
-
-	  To compile this file system support as a module, choose M here. The
-	  module will be called ext4.
-
-	  If unsure, say N.
-
-config EXT4DEV_COMPAT
-	bool "Enable ext4dev compatibility"
-	depends on EXT4_FS
-	help
-	  Starting with 2.6.28, the name of the ext4 filesystem was
-	  renamed from ext4dev to ext4.  Unfortunately there are some
-	  legacy userspace programs (such as klibc's fstype) have
-	  "ext4dev" hardcoded.
-
-	  To enable backwards compatibility so that systems that are
-	  still expecting to mount ext4 filesystems using ext4dev,
-	  chose Y here.   This feature will go away by 2.6.31, so
-	  please arrange to get your userspace programs fixed!
-
-config EXT4_FS_XATTR
-	bool "Ext4 extended attributes"
-	depends on EXT4_FS
-	default y
-	help
-	  Extended attributes are name:value pairs associated with inodes by
-	  the kernel or by users (see the attr(5) manual page, or visit
-	  <http://acl.bestbits.at/> for details).
-
-	  If unsure, say N.
-
-	  You need this for POSIX ACL support on ext4.
-
-config EXT4_FS_POSIX_ACL
-	bool "Ext4 POSIX Access Control Lists"
-	depends on EXT4_FS_XATTR
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
-config EXT4_FS_SECURITY
-	bool "Ext4 Security Labels"
-	depends on EXT4_FS_XATTR
-	help
-	  Security labels support alternative access control models
-	  implemented by security modules like SELinux.  This option
-	  enables an extended attribute handler for file security
-	  labels in the ext4 filesystem.
-
-	  If you are not using a security module that requires using
-	  extended attributes for file security labels, say N.
-
-config JBD
-	tristate
-	help
-	  This is a generic journalling layer for block devices.  It is
-	  currently used by the ext3 file system, but it could also be
-	  used to add journal support to other file systems or block
-	  devices such as RAID or LVM.
-
-	  If you are using the ext3 file system, you need to say Y here.
-	  If you are not using ext3 then you will probably want to say N.
-
-	  To compile this device as a module, choose M here: the module will be
-	  called jbd.  If you are compiling ext3 into the kernel, you
-	  cannot compile this code as a module.
-
-config JBD_DEBUG
-	bool "JBD (ext3) debugging support"
-	depends on JBD && DEBUG_FS
-	help
-	  If you are using the ext3 journaled file system (or potentially any
-	  other file system/device using JBD), this option allows you to
-	  enable debugging output while the system is running, in order to
-	  help track down any problems you are having.  By default the
-	  debugging output will be turned off.
-
-	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /sys/kernel/debug/jbd/jbd-debug", where N is a
-	  number between 1 and 5, the higher the number, the more debugging
-	  output is generated.  To turn debugging off again, do
-	  "echo 0 > /sys/kernel/debug/jbd/jbd-debug".
-
-config JBD2
-	tristate
-	select CRC32
-	help
-	  This is a generic journaling layer for block devices that support
-	  both 32-bit and 64-bit block numbers.  It is currently used by
-	  the ext4 and OCFS2 filesystems, but it could also be used to add
-	  journal support to other file systems or block devices such
-	  as RAID or LVM.
-
-	  If you are using ext4 or OCFS2, you need to say Y here.
-	  If you are not using ext4 or OCFS2 then you will
-	  probably want to say N.
-
-	  To compile this device as a module, choose M here. The module will be
-	  called jbd2.  If you are compiling ext4 or OCFS2 into the kernel,
-	  you cannot compile this code as a module.
-
-config JBD2_DEBUG
-	bool "JBD2 (ext4) debugging support"
-	depends on JBD2 && DEBUG_FS
-	help
-	  If you are using the ext4 journaled file system (or
-	  potentially any other filesystem/device using JBD2), this option
-	  allows you to enable debugging output while the system is running,
-	  in order to help track down any problems you are having.
-	  By default, the debugging output will be turned off.
-
-	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /sys/kernel/debug/jbd2/jbd2-debug", where N is a
-	  number between 1 and 5. The higher the number, the more debugging
-	  output is generated.  To turn debugging off again, do
-	  "echo 0 > /sys/kernel/debug/jbd2/jbd2-debug".
+source "fs/jbd/Kconfig"
+source "fs/jbd2/Kconfig"
 
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
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
@@ -0,0 +1,79 @@
+config EXT4_FS
+	tristate "The Extended 4 (ext4) filesystem"
+	select JBD2
+	select CRC16
+	help
+	  This is the next generation of the ext3 filesystem.
+
+	  Unlike the change from ext2 filesystem to ext3 filesystem,
+	  the on-disk format of ext4 is not forwards compatible with
+	  ext3; it is based on extent maps and it supports 48-bit
+	  physical block numbers.  The ext4 filesystem also supports delayed
+	  allocation, persistent preallocation, high resolution time stamps,
+	  and a number of other features to improve performance and speed
+	  up fsck time.  For more information, please see the web pages at
+	  http://ext4.wiki.kernel.org.
+
+	  The ext4 filesystem will support mounting an ext3
+	  filesystem; while there will be some performance gains from
+	  the delayed allocation and inode table readahead, the best
+	  performance gains will require enabling ext4 features in the
+	  filesystem, or formating a new filesystem as an ext4
+	  filesystem initially.
+
+	  To compile this file system support as a module, choose M here. The
+	  module will be called ext4.
+
+	  If unsure, say N.
+
+config EXT4DEV_COMPAT
+	bool "Enable ext4dev compatibility"
+	depends on EXT4_FS
+	help
+	  Starting with 2.6.28, the name of the ext4 filesystem was
+	  renamed from ext4dev to ext4.  Unfortunately there are some
+	  legacy userspace programs (such as klibc's fstype) have
+	  "ext4dev" hardcoded.
+
+	  To enable backwards compatibility so that systems that are
+	  still expecting to mount ext4 filesystems using ext4dev,
+	  chose Y here.   This feature will go away by 2.6.31, so
+	  please arrange to get your userspace programs fixed!
+
+config EXT4_FS_XATTR
+	bool "Ext4 extended attributes"
+	depends on EXT4_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+	  You need this for POSIX ACL support on ext4.
+
+config EXT4_FS_POSIX_ACL
+	bool "Ext4 POSIX Access Control Lists"
+	depends on EXT4_FS_XATTR
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
+config EXT4_FS_SECURITY
+	bool "Ext4 Security Labels"
+	depends on EXT4_FS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the ext4 filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
new file mode 100644
--- /dev/null
+++ b/fs/jbd/Kconfig
@@ -0,0 +1,30 @@
+config JBD
+	tristate
+	help
+	  This is a generic journalling layer for block devices.  It is
+	  currently used by the ext3 file system, but it could also be
+	  used to add journal support to other file systems or block
+	  devices such as RAID or LVM.
+
+	  If you are using the ext3 file system, you need to say Y here.
+	  If you are not using ext3 then you will probably want to say N.
+
+	  To compile this device as a module, choose M here: the module will be
+	  called jbd.  If you are compiling ext3 into the kernel, you
+	  cannot compile this code as a module.
+
+config JBD_DEBUG
+	bool "JBD (ext3) debugging support"
+	depends on JBD && DEBUG_FS
+	help
+	  If you are using the ext3 journaled file system (or potentially any
+	  other file system/device using JBD), this option allows you to
+	  enable debugging output while the system is running, in order to
+	  help track down any problems you are having.  By default the
+	  debugging output will be turned off.
+
+	  If you select Y here, then you will be able to turn on debugging
+	  with "echo N > /sys/kernel/debug/jbd/jbd-debug", where N is a
+	  number between 1 and 5, the higher the number, the more debugging
+	  output is generated.  To turn debugging off again, do
+	  "echo 0 > /sys/kernel/debug/jbd/jbd-debug".
new file mode 100644
--- /dev/null
+++ b/fs/jbd2/Kconfig
@@ -0,0 +1,33 @@
+config JBD2
+	tristate
+	select CRC32
+	help
+	  This is a generic journaling layer for block devices that support
+	  both 32-bit and 64-bit block numbers.  It is currently used by
+	  the ext4 and OCFS2 filesystems, but it could also be used to add
+	  journal support to other file systems or block devices such
+	  as RAID or LVM.
+
+	  If you are using ext4 or OCFS2, you need to say Y here.
+	  If you are not using ext4 or OCFS2 then you will
+	  probably want to say N.
+
+	  To compile this device as a module, choose M here. The module will be
+	  called jbd2.  If you are compiling ext4 or OCFS2 into the kernel,
+	  you cannot compile this code as a module.
+
+config JBD2_DEBUG
+	bool "JBD2 (ext4) debugging support"
+	depends on JBD2 && DEBUG_FS
+	help
+	  If you are using the ext4 journaled file system (or
+	  potentially any other filesystem/device using JBD2), this option
+	  allows you to enable debugging output while the system is running,
+	  in order to help track down any problems you are having.
+	  By default, the debugging output will be turned off.
+
+	  If you select Y here, then you will be able to turn on debugging
+	  with "echo N > /sys/kernel/debug/jbd2/jbd2-debug", where N is a
+	  number between 1 and 5. The higher the number, the more debugging
+	  output is generated.  To turn debugging off again, do
+	  "echo 0 > /sys/kernel/debug/jbd2/jbd2-debug".
