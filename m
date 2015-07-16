From: Jan Kara <jack@suse.com>
Subject: [PATCH 2/4] fs: Remove ext3 filesystem driver
Date: Thu, 16 Jul 2015 11:53:04 +0200
Message-ID: <1437040386-31148-3-git-send-email-jack@suse.com>
References: <1437040386-31148-1-git-send-email-jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437040386-31148-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

The functionality of ext3 is fully supported by ext4 driver. Major
distributions (SUSE, RedHat) already use ext4 driver to handle ext3
filesystems for quite some time. There is some ugliness in mm resulting
from jbd cleaning buffers in a dirty page without cleaning page dirty
bit and also support for buffer bouncing in the block layer when stable
pages are required is there only because of jbd. So let's remove the
ext3 driver. This saves us some 28k lines of duplicated code.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/ext2.txt |    4 +-
 Documentation/filesystems/ext3.txt |  209 +--
 Documentation/filesystems/vfs.txt  |    2 +-
 MAINTAINERS                        |   18 +-
 fs/Kconfig                         |    5 +-
 fs/Makefile                        |    2 -
 fs/ext3/Kconfig                    |   89 -
 fs/ext3/Makefile                   |   12 -
 fs/ext3/acl.c                      |  281 ---
 fs/ext3/acl.h                      |   72 -
 fs/ext3/balloc.c                   | 2158 ----------------------
 fs/ext3/bitmap.c                   |   20 -
 fs/ext3/dir.c                      |  537 ------
 fs/ext3/ext3.h                     | 1332 --------------
 fs/ext3/ext3_jbd.c                 |   59 -
 fs/ext3/file.c                     |   79 -
 fs/ext3/fsync.c                    |  109 --
 fs/ext3/hash.c                     |  206 ---
 fs/ext3/ialloc.c                   |  706 -------
 fs/ext3/inode.c                    | 3574 ------------------------------------
 fs/ext3/ioctl.c                    |  327 ----
 fs/ext3/namei.c                    | 2586 --------------------------
 fs/ext3/namei.h                    |   27 -
 fs/ext3/resize.c                   | 1117 -----------
 fs/ext3/super.c                    | 3165 -------------------------------
 fs/ext3/symlink.c                  |   46 -
 fs/ext3/xattr.c                    | 1330 --------------
 fs/ext3/xattr.h                    |  136 --
 fs/ext3/xattr_security.c           |   78 -
 fs/ext3/xattr_trusted.c            |   54 -
 fs/ext3/xattr_user.c               |   58 -
 fs/ext4/Kconfig                    |   41 +-
 fs/ext4/super.c                    |   14 +-
 fs/jbd/Kconfig                     |   30 -
 fs/jbd/Makefile                    |    7 -
 fs/jbd/checkpoint.c                |  782 --------
 fs/jbd/commit.c                    | 1021 ----------
 fs/jbd/journal.c                   | 2145 ----------------------
 fs/jbd/recovery.c                  |  594 ------
 fs/jbd/revoke.c                    |  733 --------
 fs/jbd/transaction.c               | 2237 ----------------------
 include/linux/jbd.h                | 1047 -----------
 include/linux/jbd2.h               |   41 +-
 include/linux/jbd_common.h         |   46 -
 include/trace/events/ext3.h        |  866 ---------
 include/trace/events/jbd.h         |  194 --
 46 files changed, 87 insertions(+), 28109 deletions(-)
 delete mode 100644 fs/ext3/Kconfig
 delete mode 100644 fs/ext3/Makefile
 delete mode 100644 fs/ext3/acl.c
 delete mode 100644 fs/ext3/acl.h
 delete mode 100644 fs/ext3/balloc.c
 delete mode 100644 fs/ext3/bitmap.c
 delete mode 100644 fs/ext3/dir.c
 delete mode 100644 fs/ext3/ext3.h
 delete mode 100644 fs/ext3/ext3_jbd.c
 delete mode 100644 fs/ext3/file.c
 delete mode 100644 fs/ext3/fsync.c
 delete mode 100644 fs/ext3/hash.c
 delete mode 100644 fs/ext3/ialloc.c
 delete mode 100644 fs/ext3/inode.c
 delete mode 100644 fs/ext3/ioctl.c
 delete mode 100644 fs/ext3/namei.c
 delete mode 100644 fs/ext3/namei.h
 delete mode 100644 fs/ext3/resize.c
 delete mode 100644 fs/ext3/super.c
 delete mode 100644 fs/ext3/symlink.c
 delete mode 100644 fs/ext3/xattr.c
 delete mode 100644 fs/ext3/xattr.h
 delete mode 100644 fs/ext3/xattr_security.c
 delete mode 100644 fs/ext3/xattr_trusted.c
 delete mode 100644 fs/ext3/xattr_user.c
 delete mode 100644 fs/jbd/Kconfig
 delete mode 100644 fs/jbd/Makefile
 delete mode 100644 fs/jbd/checkpoint.c
 delete mode 100644 fs/jbd/commit.c
 delete mode 100644 fs/jbd/journal.c
 delete mode 100644 fs/jbd/recovery.c
 delete mode 100644 fs/jbd/revoke.c
 delete mode 100644 fs/jbd/transaction.c
 delete mode 100644 include/linux/jbd.h
 delete mode 100644 include/linux/jbd_common.h
 delete mode 100644 include/trace/events/ext3.h
 delete mode 100644 include/trace/events/jbd.h

diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index b9714569e472..55755395d3dc 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -360,8 +360,8 @@ and are copied into the filesystem.  If a transaction is incomplete at
 the time of the crash, then there is no guarantee of consistency for
 the blocks in that transaction so they are discarded (which means any
 filesystem changes they represent are also lost).
-Check Documentation/filesystems/ext3.txt if you want to read more about
-ext3 and journaling.
+Check Documentation/filesystems/ext4.txt if you want to read more about
+ext4 and journaling.
 
 References
 ==========
diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 7ed0d17d6721..58758fbef9e0 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -6,210 +6,7 @@ Ext3 was originally released in September 1999. Written by Stephen Tweedie
 for the 2.2 branch, and ported to 2.4 kernels by Peter Braam, Andreas Dilger,
 Andrew Morton, Alexander Viro, Ted Ts'o and Stephen Tweedie.
 
-Ext3 is the ext2 filesystem enhanced with journalling capabilities.
+Ext3 is the ext2 filesystem enhanced with journalling capabilities. The
+filesystem is a subset of ext4 filesystem so use ext4 driver for accessing
+ext3 filesystems.
 
-Options
-=======
-
-When mounting an ext3 filesystem, the following option are accepted:
-(*) == default
-
-ro			Mount filesystem read only. Note that ext3 will replay
-			the journal (and thus write to the partition) even when
-			mounted "read only". Mount options "ro,noload" can be
-			used to prevent writes to the filesystem.
-
-journal=update		Update the ext3 file system's journal to the current
-			format.
-
-journal=inum		When a journal already exists, this option is ignored.
-			Otherwise, it specifies the number of the inode which
-			will represent the ext3 file system's journal file.
-
-journal_path=path
-journal_dev=devnum	When the external journal device's major/minor numbers
-			have changed, these options allow the user to specify
-			the new journal location.  The journal device is
-			identified through either its new major/minor numbers
-			encoded in devnum, or via a path to the device.
-
-norecovery		Don't load the journal on mounting. Note that this forces
-noload			mount of inconsistent filesystem, which can lead to
-			various problems.
-
-data=journal		All data are committed into the journal prior to being
-			written into the main file system.
-
-data=ordered	(*)	All data are forced directly out to the main file
-			system prior to its metadata being committed to the
-			journal.
-
-data=writeback		Data ordering is not preserved, data may be written
-			into the main file system after its metadata has been
-			committed to the journal.
-
-commit=nrsec	(*)	Ext3 can be told to sync all its data and metadata
-			every 'nrsec' seconds. The default value is 5 seconds.
-			This means that if you lose your power, you will lose
-			as much as the latest 5 seconds of work (your
-			filesystem will not be damaged though, thanks to the
-			journaling).  This default value (or any low value)
-			will hurt performance, but it's good for data-safety.
-			Setting it to 0 will have the same effect as leaving
-			it at the default (5 seconds).
-			Setting it to very large values will improve
-			performance.
-
-barrier=<0|1(*)>	This enables/disables the use of write barriers in
-barrier	(*)		the jbd code.  barrier=0 disables, barrier=1 enables.
-nobarrier		This also requires an IO stack which can support
-			barriers, and if jbd gets an error on a barrier
-			write, it will disable again with a warning.
-			Write barriers enforce proper on-disk ordering
-			of journal commits, making volatile disk write caches
-			safe to use, at some performance penalty.  If
-			your disks are battery-backed in one way or another,
-			disabling barriers may safely improve performance.
-			The mount options "barrier" and "nobarrier" can
-			also be used to enable or disable barriers, for
-			consistency with other ext3 mount options.
-
-user_xattr		Enables Extended User Attributes.  Additionally, you
-			need to have extended attribute support enabled in the
-			kernel configuration (CONFIG_EXT3_FS_XATTR).  See the
-			attr(5) manual page and http://acl.bestbits.at/ to
-			learn more about extended attributes.
-
-nouser_xattr		Disables Extended User Attributes.
-
-acl			Enables POSIX Access Control Lists support.
-			Additionally, you need to have ACL support enabled in
-			the kernel configuration (CONFIG_EXT3_FS_POSIX_ACL).
-			See the acl(5) manual page and http://acl.bestbits.at/
-			for more information.
-
-noacl			This option disables POSIX Access Control List
-			support.
-
-reservation
-
-noreservation
-
-bsddf 		(*)	Make 'df' act like BSD.
-minixdf			Make 'df' act like Minix.
-
-check=none		Don't do extra checking of bitmaps on mount.
-nocheck
-
-debug			Extra debugging information is sent to syslog.
-
-errors=remount-ro	Remount the filesystem read-only on an error.
-errors=continue		Keep going on a filesystem error.
-errors=panic		Panic and halt the machine if an error occurs.
-			(These mount options override the errors behavior
-			specified in the superblock, which can be
-			configured using tune2fs.)
-
-data_err=ignore(*)	Just print an error message if an error occurs
-			in a file data buffer in ordered mode.
-data_err=abort		Abort the journal if an error occurs in a file
-			data buffer in ordered mode.
-
-grpid			Give objects the same group ID as their creator.
-bsdgroups
-
-nogrpid		(*)	New objects have the group ID of their creator.
-sysvgroups
-
-resgid=n		The group ID which may use the reserved blocks.
-
-resuid=n		The user ID which may use the reserved blocks.
-
-sb=n			Use alternate superblock at this location.
-
-quota			These options are ignored by the filesystem. They
-noquota			are used only by quota tools to recognize volumes
-grpquota		where quota should be turned on. See documentation
-usrquota		in the quota-tools package for more details
-			(http://sourceforge.net/projects/linuxquota).
-
-jqfmt=<quota type>	These options tell filesystem details about quota
-usrjquota=<file>	so that quota information can be properly updated
-grpjquota=<file>	during journal replay. They replace the above
-			quota options. See documentation in the quota-tools
-			package for more details
-			(http://sourceforge.net/projects/linuxquota).
-
-Specification
-=============
-Ext3 shares all disk implementation with the ext2 filesystem, and adds
-transactions capabilities to ext2.  Journaling is done by the Journaling Block
-Device layer.
-
-Journaling Block Device layer
------------------------------
-The Journaling Block Device layer (JBD) isn't ext3 specific.  It was designed
-to add journaling capabilities to a block device.  The ext3 filesystem code
-will inform the JBD of modifications it is performing (called a transaction).
-The journal supports the transactions start and stop, and in case of a crash,
-the journal can replay the transactions to quickly put the partition back into
-a consistent state.
-
-Handles represent a single atomic update to a filesystem.  JBD can handle an
-external journal on a block device.
-
-Data Mode
----------
-There are 3 different data modes:
-
-* writeback mode
-In data=writeback mode, ext3 does not journal data at all.  This mode provides
-a similar level of journaling as that of XFS, JFS, and ReiserFS in its default
-mode - metadata journaling.  A crash+recovery can cause incorrect data to
-appear in files which were written shortly before the crash.  This mode will
-typically provide the best ext3 performance.
-
-* ordered mode
-In data=ordered mode, ext3 only officially journals metadata, but it logically
-groups metadata and data blocks into a single unit called a transaction.  When
-it's time to write the new metadata out to disk, the associated data blocks
-are written first.  In general, this mode performs slightly slower than
-writeback but significantly faster than journal mode.
-
-* journal mode
-data=journal mode provides full data and metadata journaling.  All new data is
-written to the journal first, and then to its final location.
-In the event of a crash, the journal can be replayed, bringing both data and
-metadata into a consistent state.  This mode is the slowest except when data
-needs to be read from and written to disk at the same time where it
-outperforms all other modes.
-
-Compatibility
--------------
-
-Ext2 partitions can be easily convert to ext3, with `tune2fs -j <dev>`.
-Ext3 is fully compatible with Ext2.  Ext3 partitions can easily be mounted as
-Ext2.
-
-
-External Tools
-==============
-See manual pages to learn more.
-
-tune2fs: 	create a ext3 journal on a ext2 partition with the -j flag.
-mke2fs: 	create a ext3 partition with the -j flag.
-debugfs: 	ext2 and ext3 file system debugger.
-ext2online:	online (mounted) ext2 and ext3 filesystem resizer
-
-
-References
-==========
-
-kernel source:	<file:fs/ext3/>
-		<file:fs/jbd/>
-
-programs: 	http://e2fsprogs.sourceforge.net/
-		http://ext2resize.sourceforge.net
-
-useful links:	http://www.ibm.com/developerworks/library/l-fs7/index.html
-        http://www.ibm.com/developerworks/library/l-fs8/index.html
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 5eb8456fc41e..8c6f07ad373a 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -769,7 +769,7 @@ struct address_space_operations {
 	to stall to allow flushers a chance to complete some IO. Ordinarily
 	it can use PageDirty and PageWriteback but some filesystems have
 	more complex state (unstable pages in NFS prevent reclaim) or
-	do not set those flags due to locking problems (jbd). This callback
+	do not set those flags due to locking problems. This callback
 	allows a filesystem to indicate to the VM if a page should be
 	treated as dirty or writeback for the purposes of stalling.
 
diff --git a/MAINTAINERS b/MAINTAINERS
index fd6078443083..d78655e61702 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4058,15 +4058,6 @@ F:	Documentation/filesystems/ext2.txt
 F:	fs/ext2/
 F:	include/linux/ext2*
 
-EXT3 FILE SYSTEM
-M:	Jan Kara <jack@suse.cz>
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Andreas Dilger <adilger.kernel@dilger.ca>
-L:	linux-ext4@vger.kernel.org
-S:	Maintained
-F:	Documentation/filesystems/ext3.txt
-F:	fs/ext3/
-
 EXT4 FILE SYSTEM
 M:	"Theodore Ts'o" <tytso@mit.edu>
 M:	Andreas Dilger <adilger.kernel@dilger.ca>
@@ -5750,16 +5741,9 @@ S:	Maintained
 F:	fs/jffs2/
 F:	include/uapi/linux/jffs2.h
 
-JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Jan Kara <jack@suse.cz>
-L:	linux-ext4@vger.kernel.org
-S:	Maintained
-F:	fs/jbd/
-F:	include/linux/jbd.h
-
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
 M:	"Theodore Ts'o" <tytso@mit.edu>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd2/
diff --git a/fs/Kconfig b/fs/Kconfig
index 011f43365d7b..da3f32f1a4e4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -11,18 +11,15 @@ config DCACHE_WORD_ACCESS
 if BLOCK
 
 source "fs/ext2/Kconfig"
-source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
-source "fs/jbd/Kconfig"
 source "fs/jbd2/Kconfig"
 
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
 	tristate
 	default y if EXT2_FS=y && EXT2_FS_XATTR
-	default y if EXT3_FS=y && EXT3_FS_XATTR
 	default y if EXT4_FS=y
-	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS
+	default m if EXT2_FS_XATTR || EXT4_FS
 
 source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index cb20e4bf2303..09e051fefc5b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -62,12 +62,10 @@ obj-$(CONFIG_DLM)		+= dlm/
 # Do not add any filesystems before this line
 obj-$(CONFIG_FSCACHE)		+= fscache/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
-obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT2_FS)		+= ext2/
 # We place ext4 after ext2 so plain ext2 root fs's are mounted using ext2
 # unless explicitly requested by rootfstype
 obj-$(CONFIG_EXT4_FS)		+= ext4/
-obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
 obj-$(CONFIG_SQUASHFS)		+= squashfs/
diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
deleted file mode 100644
index e8c6ba0e4a3e..000000000000
diff --git a/fs/ext3/Makefile b/fs/ext3/Makefile
deleted file mode 100644
index e77766a8b3f0..000000000000
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
deleted file mode 100644
index 8bbaf5bcf982..000000000000
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
deleted file mode 100644
index ea1c69edab9e..000000000000
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
deleted file mode 100644
index 158b5d4ce067..000000000000
diff --git a/fs/ext3/bitmap.c b/fs/ext3/bitmap.c
deleted file mode 100644
index ef9c643e8e9d..000000000000
diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
deleted file mode 100644
index 17742eed2c16..000000000000
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
deleted file mode 100644
index f483a80b3fe7..000000000000
diff --git a/fs/ext3/ext3_jbd.c b/fs/ext3/ext3_jbd.c
deleted file mode 100644
index 785a3261a26c..000000000000
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
deleted file mode 100644
index 3b8f650de22c..000000000000
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
deleted file mode 100644
index 1cb9c7e10c6f..000000000000
diff --git a/fs/ext3/hash.c b/fs/ext3/hash.c
deleted file mode 100644
index ede315cdf126..000000000000
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
deleted file mode 100644
index 3ad242e5840e..000000000000
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
deleted file mode 100644
index 6c7e5468a2f8..000000000000
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
deleted file mode 100644
index 4d96e9a64532..000000000000
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
deleted file mode 100644
index c9e767cd4b67..000000000000
diff --git a/fs/ext3/namei.h b/fs/ext3/namei.h
deleted file mode 100644
index 46304d8c9f0a..000000000000
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
deleted file mode 100644
index 27105655502c..000000000000
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
deleted file mode 100644
index 5ed0044fbb37..000000000000
diff --git a/fs/ext3/symlink.c b/fs/ext3/symlink.c
deleted file mode 100644
index c08c59094ae6..000000000000
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
deleted file mode 100644
index 7cf36501ccf4..000000000000
diff --git a/fs/ext3/xattr.h b/fs/ext3/xattr.h
deleted file mode 100644
index 32e93ebf8031..000000000000
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
deleted file mode 100644
index c9506d5e3b13..000000000000
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
deleted file mode 100644
index 206cc66dc285..000000000000
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
deleted file mode 100644
index 021508ad1616..000000000000
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index bf8bc8aba471..219a190ccae9 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -1,5 +1,38 @@
+# Ext3 configs are here for backward compatibility with old configs which may
+# have EXT3_FS set but not EXT4_FS set and thus would result in non-bootable
+# kernels after the removal of ext3 driver.
+config EXT3_FS
+	tristate "The Extended 3 (ext3) filesystem"
+	# These must match EXT4_FS selects...
+	select EXT4_FS
+	select JBD2
+	select CRC16
+	select CRYPTO
+	select CRYPTO_CRC32C
+	help
+	  This config option is here only for backward compatibility. ext3
+	  filesystem is now handled by the ext4 driver.
+
+config EXT3_FS_POSIX_ACL
+	bool "Ext3 POSIX Access Control Lists"
+	depends on EXT3_FS
+	select EXT4_FS_POSIX_ACL
+	select FS_POSIX_ACL
+	help
+	  This config option is here only for backward compatibility. ext3
+	  filesystem is now handled by the ext4 driver.
+
+config EXT3_FS_SECURITY
+	bool "Ext3 Security Labels"
+	depends on EXT3_FS
+	select EXT4_FS_SECURITY
+	help
+	  This config option is here only for backward compatibility. ext3
+	  filesystem is now handled by the ext4 driver.
+
 config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
+	# Please update EXT3_FS selects when changing these
 	select JBD2
 	select CRC16
 	select CRYPTO
@@ -28,14 +61,14 @@ config EXT4_FS
 
 	  If unsure, say N.
 
-config EXT4_USE_FOR_EXT23
+config EXT4_USE_FOR_EXT2
 	bool "Use ext4 for ext2/ext3 file systems"
 	depends on EXT4_FS
-	depends on EXT3_FS=n || EXT2_FS=n
+	depends on EXT2_FS=n
 	default y
 	help
-	  Allow the ext4 file system driver code to be used for ext2 or
-	  ext3 file system mounts.  This allows users to reduce their
+	  Allow the ext4 file system driver code to be used for ext2
+	  file system mounts.  This allows users to reduce their
 	  compiled kernel size by using one file system driver for
 	  ext2, ext3, and ext4 file systems.
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 58987b5c514b..06b4b14e8aa0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -84,7 +84,7 @@ static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
 static int ext4_reserve_clusters(struct ext4_sb_info *, ext4_fsblk_t);
 
-#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
 static struct file_system_type ext2_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext2",
@@ -100,7 +100,6 @@ MODULE_ALIAS("ext2");
 #endif
 
 
-#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext3",
@@ -111,9 +110,6 @@ static struct file_system_type ext3_fs_type = {
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
 #define IS_EXT3_SB(sb) ((sb)->s_bdev->bd_holder == &ext3_fs_type)
-#else
-#define IS_EXT3_SB(sb) (0)
-#endif
 
 static int ext4_verify_csum_type(struct super_block *sb,
 				 struct ext4_super_block *es)
@@ -5500,7 +5496,7 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 	return mount_bdev(fs_type, flags, dev_name, data, ext4_fill_super);
 }
 
-#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT2)
 static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
@@ -5530,7 +5526,6 @@ static inline void unregister_as_ext2(void) { }
 static inline int ext2_feature_set_ok(struct super_block *sb) { return 0; }
 #endif
 
-#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static inline void register_as_ext3(void)
 {
 	int err = register_filesystem(&ext3_fs_type);
@@ -5556,11 +5551,6 @@ static inline int ext3_feature_set_ok(struct super_block *sb)
 		return 0;
 	return 1;
 }
-#else
-static inline void register_as_ext3(void) { }
-static inline void unregister_as_ext3(void) { }
-static inline int ext3_feature_set_ok(struct super_block *sb) { return 0; }
-#endif
 
 static struct file_system_type ext4_fs_type = {
 	.owner		= THIS_MODULE,
diff --git a/fs/jbd/Kconfig b/fs/jbd/Kconfig
deleted file mode 100644
index 4e28beeed157..000000000000
diff --git a/fs/jbd/Makefile b/fs/jbd/Makefile
deleted file mode 100644
index 54aca4868a36..000000000000
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
deleted file mode 100644
index 08c03044abdd..000000000000
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
deleted file mode 100644
index bb217dcb41af..000000000000
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
deleted file mode 100644
index c46a79adb6ad..000000000000
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
deleted file mode 100644
index a748fe21465a..000000000000
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
deleted file mode 100644
index dcead636c33b..000000000000
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
deleted file mode 100644
index 1695ba8334a2..000000000000
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
deleted file mode 100644
index d32615280be9..000000000000
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index edb640ae9a94..ad4b28647298 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/bit_spinlock.h>
 #include <crypto/hash.h>
 #endif
 
@@ -336,7 +337,45 @@ BUFFER_FNS(Freed, freed)
 BUFFER_FNS(Shadow, shadow)
 BUFFER_FNS(Verified, verified)
 
-#include <linux/jbd_common.h>
+static inline struct buffer_head *jh2bh(struct journal_head *jh)
+{
+	return jh->b_bh;
+}
+
+static inline struct journal_head *bh2jh(struct buffer_head *bh)
+{
+	return bh->b_private;
+}
+
+static inline void jbd_lock_bh_state(struct buffer_head *bh)
+{
+	bit_spin_lock(BH_State, &bh->b_state);
+}
+
+static inline int jbd_trylock_bh_state(struct buffer_head *bh)
+{
+	return bit_spin_trylock(BH_State, &bh->b_state);
+}
+
+static inline int jbd_is_locked_bh_state(struct buffer_head *bh)
+{
+	return bit_spin_is_locked(BH_State, &bh->b_state);
+}
+
+static inline void jbd_unlock_bh_state(struct buffer_head *bh)
+{
+	bit_spin_unlock(BH_State, &bh->b_state);
+}
+
+static inline void jbd_lock_bh_journal_head(struct buffer_head *bh)
+{
+	bit_spin_lock(BH_JournalHead, &bh->b_state);
+}
+
+static inline void jbd_unlock_bh_journal_head(struct buffer_head *bh)
+{
+	bit_spin_unlock(BH_JournalHead, &bh->b_state);
+}
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
diff --git a/include/linux/jbd_common.h b/include/linux/jbd_common.h
deleted file mode 100644
index 3dc53432355f..000000000000
diff --git a/include/trace/events/ext3.h b/include/trace/events/ext3.h
deleted file mode 100644
index fc733d28117a..000000000000
diff --git a/include/trace/events/jbd.h b/include/trace/events/jbd.h
deleted file mode 100644
index da6f2591c25e..000000000000
-- 
2.1.4
