From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/37] libext2fs: Add metadata checksum flag
Date: Wed, 31 Aug 2011 17:35:23 -0700
Message-ID: <20110901003523.1176.17239.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294Ab1IAAf1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:35:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7VNFNK4029320
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 19:15:23 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ZQPb200642
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:35:26 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810ZPDp022154
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:35:26 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a feature flag to enable metadata checksumming in e2fsprogs.  Also add a
runtime flag to disable checksum verification; this flag will be used by
debugfs to salvage filesystems and tune2fs when resetting checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/blkid/probe.h    |    1 +
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    1 +
 lib/ext2fs/ext2fs.h  |    4 +++-
 4 files changed, 7 insertions(+), 1 deletions(-)


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
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 16fba53..07b700d 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -59,6 +59,8 @@ static struct feature feature_list[] = {
 			"quota" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
 			"bigalloc"},
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM,
+			"metadata_csum"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index e342bf0..ae7662e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -635,6 +635,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b290a1f..e638169 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -195,6 +195,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_64BITS		0x20000
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
+#define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x100000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -564,7 +565,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed

