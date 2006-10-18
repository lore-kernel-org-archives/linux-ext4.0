From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, E2FSPROGS] On-disk format definition for huge files
Date: Wed, 18 Oct 2006 02:21:51 -0400
Message-ID: <E1Ga4oJ-0004iM-Va@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:10893 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751446AbWJRGVz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 02:21:55 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Comments?

						- Ted


On-disk format definition for huge files

- EXT4_FEATURE_RO_COMPAT_HUGE_FILE (0x0008) - change i_blocks to be
  in units of s_blocksize units instead of 512-byte sectors, use
  l_i_frag and l_i_fsize as i_blocks_hi (could also be part of 64BIT).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 02:20:25.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 02:20:35.000000000 -0400
@@ -321,8 +321,7 @@
 	__u32	i_faddr;	/* Fragment address */
 	union {
 		struct {
-			__u8	l_i_frag;	/* Fragment number */
-			__u8	l_i_fsize;	/* Fragment size */
+			__u16	l_i_blocks_hi;
 			__u16	i_pad1;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
@@ -601,6 +600,7 @@
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 /* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004 not used */
+#define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
