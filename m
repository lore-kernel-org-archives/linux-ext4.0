From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 2/4][e2fsprogs] Allow FLEX_BG to be use as a feature option at mke2fs time.
Date: Thu, 02 Aug 2007 23:00:53 -0500
Message-ID: <20070803040053.29456.48179.stgit@gara>
References: <20070803040041.29456.31454.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57067 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbXHCEDS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 00:03:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7343HEZ029689
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:17 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7343Hdo185620
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:17 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7343GH4015829
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:17 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7343GpJ015805
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 22:03:16 -0600
Received: from [127.0.1.1] (sig-9-65-28-26.mts.ibm.com [9.65.28.26])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7343Gxp050782
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 23:03:16 -0500
In-Reply-To: <20070803040041.29456.31454.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Allow FLEX_BG to be use as a feature option at mke2fs time.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/e2p/feature.c   |    2 ++
 lib/ext2fs/ext2fs.h |    6 ++++--
 misc/mke2fs.c       |    3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index fe7e65a..4bf5630 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -67,6 +67,8 @@ static struct feature feature_list[] = {
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
+                        "flex_bg"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 20c63c0..d1cda2f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -441,12 +441,14 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0c6d4f3..0af92e2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -873,7 +873,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_LAZY_BG,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
-		EXT2_FEATURE_INCOMPAT_META_BG,
+		EXT2_FEATURE_INCOMPAT_META_BG|
+		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
 };
 
