From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 49/51] libext2fs: Enable support for the metadata checksumming
	feature
Date: Sat, 07 Jan 2012 00:38:09 -0800
Message-ID: <20120107083809.25788.76815.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50325 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2AGIi3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:38:29 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:38:28 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078cC0B272358
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:38:12 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078cAHU016036
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:38:11 -0500
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add metadata checksumming to the list of supported features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/ext2fs.h     |   12 ++++++++----
 lib/ext2fs/kernel-jbd.h |    3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 10113f7..5c51e7d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -570,7 +570,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -579,7 +580,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
 #endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
@@ -589,7 +591,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 #else
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -597,7 +600,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 #endif
 
 /*
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index e9d725d..a86150c 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -259,7 +259,8 @@ typedef struct journal_superblock_s
 #define JFS_KNOWN_ROCOMPAT_FEATURES	0
 #define JFS_KNOWN_INCOMPAT_FEATURES	(JFS_FEATURE_INCOMPAT_REVOKE|\
 					 JFS_FEATURE_INCOMPAT_ASYNC_COMMIT|\
-					 JFS_FEATURE_INCOMPAT_64BIT)
+					 JFS_FEATURE_INCOMPAT_64BIT|\
+					 JFS_FEATURE_INCOMPAT_CSUM_V2)
 
 #if (defined(E2FSCK_INCLUDE_INLINE_FUNCS) || !defined(NO_INLINE_FUNCS))
 #ifdef E2FSCK_INCLUDE_INLINE_FUNCS

