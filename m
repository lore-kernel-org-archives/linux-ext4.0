From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, E2FSPROGS] On-disk format for inode extra size control
   inode size
Date: Wed, 18 Oct 2006 02:25:05 -0400
Message-ID: <E1Ga4rR-000534-CE@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:3523 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751439AbWJRGZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 02:25:09 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Comments?

						- Ted


On-disk format for controlling the inode size

- EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE (0x0040?) - add s_min_extra_isize and
  s_want_extra_isize fields to superblock, which allow specifying
  the minimum and desired i_extra_isize fields in large inodes
  (for nsec+epoch timestamps, potential other uses).  Needs RO_COMPAT
  flag handling, needs e2fsck support, patch complete, little testing.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 01:49:51.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 02:07:35.000000000 -0400
@@ -298,7 +298,7 @@
 	__u16	i_uid;		/* Low 16 bits of Owner Uid */
 	__u32	i_size;		/* Size in bytes */
 	__u32	i_atime;	/* Access time */
-	__u32	i_ctime;	/* Creation time */
+	__u32	i_ctime;	/* Inode Change time */
 	__u32	i_mtime;	/* Modification time */
 	__u32	i_dtime;	/* Deletion Time */
 	__u16	i_gid;		/* Low 16 bits of Group Id */
@@ -356,7 +356,7 @@
 	__u16	i_uid;		/* Low 16 bits of Owner Uid */
 	__u32	i_size;		/* Size in bytes */
 	__u32	i_atime;	/* Access time */
-	__u32	i_ctime;	/* Creation time */
+	__u32	i_ctime;	/* Inode Change time */
 	__u32	i_mtime;	/* Modification time */
 	__u32	i_dtime;	/* Deletion Time */
 	__u16	i_gid;		/* Low 16 bits of Group Id */
@@ -405,6 +405,11 @@
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
 	__u16	i_pad1;
+	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
+	__u32	i_mtime_extra;	/* extra Mod. time (nsec << 2 | epoch) */
+	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
+	__u32	i_crtime;	/* File creation time */
+	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 | epoch)*/
 };
 
 #define i_size_high	i_dir_acl
@@ -554,7 +559,9 @@
 	__u32	s_blocks_count_hi;	/* Blocks count high 32bits */
 	__u32	s_r_blocks_count_hi;	/* Reserved blocks count high 32 bits*/
 	__u32	s_free_blocks_hi; 	/* Free blocks count */
-	__u32	s_reserved[169];	/* Padding to the end of the block */
+	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
+	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
+	__u32	s_reserved[168];	/* Padding to the end of the block */
 };
 
 /*
@@ -607,6 +614,7 @@
 #define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
+#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
