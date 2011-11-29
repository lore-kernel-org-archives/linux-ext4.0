From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/50] libext2fs: Add metadata checksum flag
Date: Mon, 28 Nov 2011 16:28:09 -0800
Message-ID: <20111129002809.17953.92292.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48438 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1K2A22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:28:28 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:28:27 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0SCaf323288
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:28:12 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0SBjP016804
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:28:12 -0500
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a feature flag to enable metadata checksumming in e2fsprogs.  Also add a
runtime flag to disable checksum verification; this flag will be used by
debugfs to salvage filesystems and tune2fs when resetting checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/blkid/probe.h   |    1 +
 lib/ext2fs/ext2fs.h |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37e80ef..d6809e1 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -110,6 +110,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 /* for s_feature_incompat */
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 08f1946..4ff7f4f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -199,6 +199,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
 #define EXT2_FLAG_SKIP_MMP		0x100000
+#define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -585,7 +586,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 #else
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -593,7 +595,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 #endif
 
 /*

