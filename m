From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] properly calculate overhead in ext2fs_initialize()
Date: Fri, 20 Jul 2007 16:47:14 -0500
Message-ID: <46A12D62.2010704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569AbXGTVw6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 17:52:58 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6KLqvYB025333
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:52:57 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6KLqvs3011420
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:52:57 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l6KLqvXj016639
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:52:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For some odd geometries*, mkfs will try to allocate inode tables off
the end of the block group and fail, rather than warning that too
many inodes have been requested.

This is because when ext2fs_initialize calculates metadata overhead,
it is only adding in group descriptor blocks and the superblock
if the *last* bg contains them - but the first bg also has all of 
the various metadata bits taking up space.

Unconditionally adding those counts into the overhead seems to fix
it properly.

*for example "mke2fs  -b 1024 -m 0 -g 256 -N 3745 fsfile 1024"

(Note, the test here is a little funky; the expected output is
actually a mkfs failure - but a proper failure instead of the
allocator catching the problem at the last minute)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-1.40.2/lib/ext2fs/initialize.c
@@ -299,15 +299,13 @@ ipg_retry:
 
 	/*
 	 * Overhead is the number of bookkeeping blocks per group.  It
-	 * includes the superblock backup, the group descriptor
-	 * backups, the inode bitmap, the block bitmap, and the inode
-	 * table.
+	 * includes the superblock (or backup), the block bitmap, the
+	 * inode bitmap, the inode table, the group descriptor (or
+	 * backups), and the reserved gdt blocks.
 	 */
 
-	overhead = (int) (2 + fs->inode_blocks_per_group);
-
-	if (ext2fs_bg_has_super(fs, fs->group_desc_count - 1))
-		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
+	overhead = (int) (3 + fs->inode_blocks_per_group +
+			  fs->desc_blocks + super->s_reserved_gdt_blocks);
 
 	/* This can only happen if the user requested too many inodes */
 	if (overhead > super->s_blocks_per_group)Index: e2fsprogs-1.40.2/tests/m_mkfs_overhead/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/tests/m_mkfs_overhead/expect.1
@@ -0,0 +1,10 @@
+./test.img: Cannot create filesystem with requested number of inodes while setting up superblock
+./test.img: Attempt to read block from filesystem resulted in short read while opening filesystem
+features: Filesystem not open
+ 
+../e2fsck/e2fsck: Attempt to read block from filesystem resulted in short read while trying to open ./test.img
+Could this be a zero-length partition?
+Exit status is 8
+
+../misc/dumpe2fs: Attempt to read block from filesystem resulted in short read while trying to open ./test.img
+Couldn't find valid filesystem superblock.
Index: e2fsprogs-1.40.2/tests/m_mkfs_overhead/script
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.2/tests/m_mkfs_overhead/script
@@ -0,0 +1,5 @@
+DESCRIPTION="test bg overhead calculation"
+FS_SIZE=1024
+MKE2FS_OPTS="-b 1024 -m 0 -g 256 -N 3745"
+. $cmd_dir/run_mke2fs
+
