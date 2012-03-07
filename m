From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 51/54] libext2fs: Enable support for the metadata checksumming
 feature
Date: Tue, 06 Mar 2012 16:03:24 -0800
Message-ID: <20120307000324.11945.51939.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:34285 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031618Ab2CGADt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:03:49 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:03:48 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 76920C90067
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:03:33 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2703X0S252382
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:03:33 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2703SNn006613
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 21:03:29 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add metadata checksumming to the list of supported features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/ext2fs.h     |    6 ++++--
 lib/ext2fs/kernel-jbd.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 49d9271..cd6c0b2 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -598,7 +598,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 #else
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -606,7 +607,8 @@ typedef struct ext2_icount *ext2_icount_t;
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

