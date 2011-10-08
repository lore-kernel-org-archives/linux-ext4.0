From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/47] libext2fs: Add metadata checksum flag
Date: Sat, 08 Oct 2011 00:33:29 -0700
Message-ID: <20111008073329.17888.70945.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e33.co.us.ibm.com ([32.97.110.151]:53485 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1JHHgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:36:24 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 01:36:24 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987XWeq197092
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:32 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987XUpO022986
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:31 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a feature flag to enable metadata checksumming in e2fsprogs.  Also add a
runtime flag to disable checksum verification; this flag will be used by
debugfs to salvage filesystems and tune2fs when resetting checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/blkid/probe.h   |    1 +
 lib/ext2fs/ext2fs.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)


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
index b04b0d1..4a3e7af 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -199,6 +199,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
 #define EXT2_FLAG_SKIP_MMP		0x100000
+#define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -584,7 +585,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed

