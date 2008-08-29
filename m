From: akpm@linux-foundation.org
Subject: + fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch added to -mm tree
Date: Fri, 29 Aug 2008 13:11:23 -0700
Message-ID: <200808292011.m7TKBN14002192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: adobriyan@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     fs/Kconfig: move ext2, ext3, ext4, JBD, JBD2 out
has been added to the -mm tree.  Its filename is
     fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/Kconfig: move ext2, ext3, ext4, JBD, JBD2 out
From: Alexey Dobriyan <adobriyan@gmail.com>

Use fs/*/Kconfig more, which is good because everything related to one
filesystem is in one place and fs/Kconfig is quite fat.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig      |  258 ----------------------------------------------
 fs/ext2/Kconfig |   55 +++++++++
 fs/ext3/Kconfig |   67 +++++++++++
 fs/ext4/Kconfig |   65 +++++++++++
 fs/jbd/Kconfig  |   31 +++++
 fs/jbd2/Kconfig |   32 +++++
 6 files changed, 255 insertions(+), 253 deletions(-)

diff -puN fs/Kconfig~fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out fs/Kconfig
--- a/fs/Kconfig~fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out
+++ a/fs/Kconfig
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
@@ -68,204 +16,8 @@ config FS_XIP
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
-
-config JBD
-	tristate
-	help
-	  This is a generic journalling layer for block devices.  It is
-	  currently used by the ext3 and OCFS2 file systems, but it could
-	  also be used to add journal support to other file systems or block
-	  devices such as RAID or LVM.
-
-	  If you are using the ext3 or OCFS2 file systems, you need to
-	  say Y here. If you are not using ext3 OCFS2 then you will probably
-	  want to say N.
-
-	  To compile this device as a module, choose M here: the module will be
-	  called jbd.  If you are compiling ext3 or OCFS2 into the kernel,
-	  you cannot compile this code as a module.
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
-	  the ext4dev/ext4 filesystem, but it could also be used to add
-	  journal support to other file systems or block devices such
-	  as RAID or LVM.
-
-	  If you are using ext4dev/ext4, you need to say Y here. If you are not
-	  using ext4dev/ext4 then you will probably want to say N.
-
-	  To compile this device as a module, choose M here. The module will be
-	  called jbd2.  If you are compiling ext4dev/ext4 into the kernel,
-	  you cannot compile this code as a module.
-
-config JBD2_DEBUG
-	bool "JBD2 (ext4dev/ext4) debugging support"
-	depends on JBD2 && DEBUG_FS
-	help
-	  If you are using the ext4dev/ext4 journaled file system (or
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
diff -puN /dev/null fs/ext2/Kconfig
--- /dev/null
+++ a/fs/ext2/Kconfig
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
diff -puN /dev/null fs/ext3/Kconfig
--- /dev/null
+++ a/fs/ext3/Kconfig
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
diff -puN /dev/null fs/ext4/Kconfig
--- /dev/null
+++ a/fs/ext4/Kconfig
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
diff -puN /dev/null fs/jbd/Kconfig
--- /dev/null
+++ a/fs/jbd/Kconfig
@@ -0,0 +1,31 @@
+config JBD
+	tristate
+	help
+	  This is a generic journalling layer for block devices.  It is
+	  currently used by the ext3 and OCFS2 file systems, but it could
+	  also be used to add journal support to other file systems or block
+	  devices such as RAID or LVM.
+
+	  If you are using the ext3 or OCFS2 file systems, you need to
+	  say Y here. If you are not using ext3 OCFS2 then you will probably
+	  want to say N.
+
+	  To compile this device as a module, choose M here: the module will be
+	  called jbd.  If you are compiling ext3 or OCFS2 into the kernel,
+	  you cannot compile this code as a module.
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
diff -puN /dev/null fs/jbd2/Kconfig
--- /dev/null
+++ a/fs/jbd2/Kconfig
@@ -0,0 +1,32 @@
+config JBD2
+	tristate
+	select CRC32
+	help
+	  This is a generic journaling layer for block devices that support
+	  both 32-bit and 64-bit block numbers.  It is currently used by
+	  the ext4dev/ext4 filesystem, but it could also be used to add
+	  journal support to other file systems or block devices such
+	  as RAID or LVM.
+
+	  If you are using ext4dev/ext4, you need to say Y here. If you are not
+	  using ext4dev/ext4 then you will probably want to say N.
+
+	  To compile this device as a module, choose M here. The module will be
+	  called jbd2.  If you are compiling ext4dev/ext4 into the kernel,
+	  you cannot compile this code as a module.
+
+config JBD2_DEBUG
+	bool "JBD2 (ext4dev/ext4) debugging support"
+	depends on JBD2 && DEBUG_FS
+	help
+	  If you are using the ext4dev/ext4 journaled file system (or
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
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
anondev-init-idr-statically.patch
anondev-switch-to-ida.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-jffs2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

