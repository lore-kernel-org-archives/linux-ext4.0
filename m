From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, E2FSPROGS] On-disk format definition group desciptor checksums
Date: Wed, 18 Oct 2006 02:23:14 -0400
Message-ID: <E1Ga4pe-0004rB-Cj@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:64450 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751450AbWJRGXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 02:23:18 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Comments?

						- Ted


On-disk format definition for group descriptor checksums

- EXT4_FEATURE_RO_COMPAT_GDT_CSUM (0x0010?) - store a crc16 checksum in
  the group descriptor (s_uuid[16] | __u32 group | ext3_group_desc
  (excluding gd_checksum itself)).  This allows the kernel to more safely
  manage UNINIT groups.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 02:20:35.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 02:20:41.000000000 -0400
@@ -144,7 +144,9 @@
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u32	bg_reserved[3];
+	__u32	bg_reserved[2];
+	__u16	bg_itable_unused;	/* Unused inodes count */
+	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
 };
 
 struct ext4_group_desc
@@ -601,6 +603,7 @@
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 /* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004 not used */
 #define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
