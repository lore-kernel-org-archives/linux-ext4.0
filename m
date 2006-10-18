From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, E2FSPROGS] On-disk format for large number of subdirectors
Date: Wed, 18 Oct 2006 02:24:01 -0400
Message-ID: <E1Ga4qP-0004wH-85@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:451 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751453AbWJRGYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 02:24:05 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Comments?

						- Ted


On-disk format for large number of subdirectories

- EXT4_FEATURE_RO_COMPAT_DIR_NLINK (0x0020?) - allow directories to have
  > 65000 subdirectories (i_nlinks) by setting i_nlinks = 1 for such
  directories.  RO_COMPAT protects old filesystems from unlinking such
  directories incorrectly and losing all files therein.  

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 01:42:48.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 01:49:51.000000000 -0400
@@ -71,7 +71,7 @@
 /*
  * Maximal count of links to a file
  */
-#define EXT2_LINK_MAX		32000
+#define EXT2_LINK_MAX		65000
 
 /*
  * Macro-instructions used to manage several block sizes
@@ -606,6 +606,7 @@
 /* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004 not used */
 #define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
+#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
