From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] Ext4: Update ext4 documentation
Date: Tue, 18 Jan 2011 16:50:43 +0100
Message-ID: <1295365843-29414-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1ARPut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jan 2011 10:50:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since Documentation/filesystem/ext4.txt has not been updated for a
while, there were some missing information. This commit add not yet
documented mount options and ioctls. Also it adds sysfs documentation
from Documentation/ABI/testing/sysfs-fs-ext4 which was really well
hidden, as you can see.

Some typo fixes in sysfs-fs-ext4 as well.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 Documentation/ABI/testing/sysfs-fs-ext4 |   13 ++-
 Documentation/filesystems/ext4.txt      |  209 ++++++++++++++++++++++++++++++-
 2 files changed, 218 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 5fb7099..f22ac08 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -48,7 +48,7 @@ Description:
 		 will have its blocks allocated out of its own unique
 		 preallocation pool.
 
-What:		/sys/fs/ext4/<disk>/inode_readahead
+What:		/sys/fs/ext4/<disk>/inode_readahead_blks
 Date:		March 2008
 Contact:	"Theodore Ts'o" <tytso@mit.edu>
 Description:
@@ -85,7 +85,14 @@ Date:		June 2008
 Contact:	"Theodore Ts'o" <tytso@mit.edu>
 Description:
 		Tuning parameter which (if non-zero) controls the goal
-		inode used by the inode allocator in p0reference to
-		all other allocation hueristics.  This is intended for
+		inode used by the inode allocator in preference to
+		all other allocation heuristics.  This is intended for
 		debugging use only, and should be 0 on production
 		systems.
+
+What:		/sys/fs/ext4/<disk>/max_writeback_mb_bump
+Date:		September 2009
+Contact:	"Theodore Ts'o" <tytso@mit.edu>
+Description:
+		The maximum number of megabytes the writeback code will
+		try to write out before move on to another inode.
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 6ab9442..cd980f7 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -367,12 +367,47 @@ init_itable=n		The lazy itable init code will wait n times the
 			minimizes the impact on the systme performance
 			while file system's inode table is being initialized.
 
-discard		Controls whether ext4 should issue discard/TRIM
+discard			Controls whether ext4 should issue discard/TRIM
 nodiscard(*)		commands to the underlying block device when
 			blocks are freed.  This is useful for SSD devices
 			and sparse/thinly-provisioned LUNs, but it is off
 			by default until sufficient testing has been done.
 
+nouid32			Disables 32-bit UIDs and GIDs.  This is for
+			interoperability  with  older kernels which only
+			store and expect 16-bit values.
+
+resize			Allows to resize filesystem to the end of the last
+			existing block group, further resize has to be done
+			with resize2fs either online, or offline. It can be
+			used only with conjunction with remount.
+
+block_validity		This options allows to enables/disables the in-kernel
+noblock_validity	facility for tracking filesystem metadata blocks
+			within internal data structures. This allows multi-
+			block allocator and other routines to quickly locate
+			extents which might overlap with filesystem metadata
+			blocks. This option is intended for debugging
+			purposes and since it negatively affects the
+			performance, it is off by default.
+
+dioread_lock		Controls whether or not ext4 should use the DIO read
+dioread_nolock		locking. If the dioread_nolock option is specified
+			ext4 will allocate uninitialized extent before buffer
+			write and convert the extent to initialized after IO
+			completes. This approach allows ext4 code to avoid
+			using inode mutex, which improves scalability on high
+			speed storages. However this does not work with nobh
+			option and the mount will fail. Nor does it work with
+			data journaling and dioread_nolock option will be
+			ignored with kernel warning. Note that dioread_nolock
+			code path is only used for extent-based files.
+			Because of the restrictions this options comprises
+			it is off by default (e.g. dioread_lock).
+
+i_version		Enable 64-bit inode version support. This option is
+			off by default.
+
 Data Mode
 =========
 There are 3 different data modes:
@@ -400,6 +435,178 @@ needs to be read from and written to disk at the same time where it
 outperforms all others modes.  Currently ext4 does not have delayed
 allocation support if this data journalling mode is selected.
 
+/proc entries
+=============
+
+Information about mounted ext4 file systems can be found in
+/proc/fs/ext4.  Each mounted filesystem will have a directory in
+/proc/fs/ext4 based on its device name (i.e., /proc/fs/ext4/hdc or
+/proc/fs/ext4/dm-0).   The files in each per-device directory are shown
+in table below.
+
+Files in /proc/fs/ext4/<devname>
+..............................................................................
+ File            Content
+ mb_groups       details of multiblock allocator buddy cache of free blocks
+..............................................................................
+
+/sys entries
+============
+
+Information about mounted ext4 file systems can be found in
+/sys/fs/ext4.  Each mounted filesystem will have a directory in
+/sys/fs/ext4 based on its device name (i.e., /sys/fs/ext4/hdc or
+/sys/fs/ext4/dm-0).   The files in each per-device directory are shown
+in table below.
+
+Files in /sys/fs/ext4/<devname>
+(see also Documentation/ABI/testing/sysfs-fs-ext4)
+..............................................................................
+ File                         Content
+
+ delayed_allocation_blocks    This file is read-only and shows the number of
+                              blocks that are dirty in the page cache, but
+                              which do not have their location in the
+                              filesystem allocated yet.
+
+ inode_goal                   Tuning parameter which (if non-zero) controls
+                              the goal inode used by the inode allocator in
+                              preference to all other allocation heuristics.
+                              This is intended for debugging use only, and
+                              should be 0 on production systems.
+
+ inode_readahead_blks         Tuning parameter which controls the maximum
+                              number of inode table blocks that ext4's inode
+                              table readahead algorithm will pre-read into
+                              the buffer cache
+
+ lifetime_write_kbytes        This file is read-only and shows the number of
+                              kilobytes of data that have been written to this
+                              filesystem since it was created.
+
+ max_writeback_mb_bump        The maximum number of megabytes the writeback
+                              code will try to write out before move on to
+                              another inode.
+
+ mb_group_prealloc            The multiblock allocator will round up allocation
+                              requests to a multiple of this tuning parameter if
+                              the stripe size is not set in the ext4 superblock
+
+ mb_max_to_scan               The maximum number of extents the multiblock
+                              allocator will search to find the best extent
+
+ mb_min_to_scan               The minimum number of extents the multiblock
+                              allocator will search to find the best extent
+
+ mb_order2_req                Tuning parameter which controls the minimum size
+                              for requests (as a power of 2) where the buddy
+                              cache is used
+
+ mb_stats                     Controls whether the multiblock allocator should
+                              collect statistics, which are shown during the
+                              unmount. 1 means to collect statistics, 0 means
+                              not to collect statistics
+
+ mb_stream_req                Files which have fewer blocks than this tunable
+                              parameter will have their blocks allocated out
+                              of a block group specific preallocation pool, so
+                              that small files are packed closely together.
+                              Each large file will have its blocks allocated
+                              out of its own unique preallocation pool.
+
+ session_write_kbytes         This file is read-only and shows the number of
+                              kilobytes of data that have been written to this
+                              filesystem since it was mounted.
+..............................................................................
+
+Ioctls
+======
+
+There is some Ext4 specific functionality which can be accessed by applications
+through the system call interfaces. The list of all Ext4 specific ioctls are
+shown in the table below.
+
+Table of Ext4 specific ioctls
+..............................................................................
+ Ioctl			      Description
+ EXT4_IOC_GETFLAGS	      Get additional attributes associated with files
+			      in Ext4. The argument point to the integer.
+			      Meaning of the particular bits are defined in
+			      fs/ext4/ext4.
+
+ EXT4_IOC_SETFLAGS	      Set additional attributes associated with files
+			      in Ext4. The argument point to the integer.
+			      Meaning of the particular bits are defined in
+			      fs/ext4/ext4. If the file is a subject to quota,
+			      setting inode flags is prohibited.
+
+ EXT4_IOC_GETVERSION
+ EXT4_IOC_GETVERSION_OLD
+			      Get the inode i_generation number stored for
+			      each inode. This is particularly useful for
+			      NFS in cases when one inode is unlinked and
+			      then a new inode is created with the same inode
+			      number. NFS daemon should know that it is not
+			      the same inode, thus i_generation is needed.
+			      All that said, it is normally changed only when
+			      new inode is created.
+
+ EXT4_IOC_SETVERSION
+ EXT4_IOC_SETVERSION_OLD
+			      Set the inode i_generation number stored for
+			      each inode.
+
+ EXT4_IOC_GROUP_EXTEND	      This ioctl has the same purpose as the resize
+			      mount option. It allows to resize filesystem
+			      to the end of the last existing block group,
+			      further resize has to be done with resize2fs,
+			      either online, or offline. The argument points
+			      to the unsigned logn number representing the
+			      filesystem new block count.
+
+ EXT4_IOC_MOVE_EXT	      Move the block extents from orig_fd (the one
+			      this ioctl is pointing to) to the donor_fd (the
+			      one specified in move_extent structure passed
+			      as an argument to this ioctl). Then, exchange
+			      inode metadata between orig_fd and donor_fd.
+			      This is especially useful for online
+			      defragmentation, because the allocator has the
+			      opportunity to allocate moved blocks better,
+			      ideally into one contiguous extent.
+
+ EXT4_IOC_GROUP_ADD	      Add a new group descriptor to an existing or
+			      new group descriptor block. The new group
+			      descriptor is described by ext4_new_group_input
+			      structure, which is passed as an argument to
+			      this ioctl. This is especially useful in
+			      conjunction with EXT4_IOC_GROUP_EXTEND,
+			      which allows online resize of the filesystem
+			      to the end of the last existing block group.
+			      Those two ioctls combined is used in userspace
+			      online resize tool (e.g. resize2fs).
+
+ EXT4_IOC_MIGRATE	      This ioctl operates on the filesystem itself.
+			      It converts (migrates) ext3 indirect block mapped
+			      inode to ext4 extent mapped inode by walking
+			      through indirect block mapping of the original
+			      inode and converting contiguous block ranges
+			      into ext4 extents of the temporary inode. Then,
+			      inodes are swapped. This ioctl might help, when
+			      migrating from ext3 to ext4 filesystem, however
+			      suggestion is to create fresh ext4 filesystem
+			      and copy data from the backup. Note, that
+			      filesystem has to support extents for this ioctl
+			      to work.
+
+ EXT4_IOC_ALLOC_DA_BLKS	      Force all of the delay allocated blocks to be
+			      allocated to preserve application-expected ext3
+			      behaviour. Note that this will also start
+			      triggering a write of the data blocks, but this
+			      behaviour may change in the future as it is
+			      not necessary and has been done this way only
+			      for sake of simplicity.
+..............................................................................
+
 References
 ==========
 
-- 
1.7.2.3

