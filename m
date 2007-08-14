From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 2/4][e2fsprogs] Allow FLEX_BG to be use as a feature option at mke2fs time.
Date: Mon, 13 Aug 2007 23:32:57 -0500
Message-ID: <20070814043257.32206.56210.stgit@gara>
References: <20070814043245.32206.34785.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45394 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762403AbXHNEdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Aug 2007 00:33:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7E4X6W3024298
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:06 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7E4X653266196
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:33:06 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7E4X5iR022647
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:33:06 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7E4X55D022642
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 22:33:05 -0600
Received: from [127.0.1.1] (sig-9-65-58-9.mts.ibm.com [9.65.58.9])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7E4X5pK040302
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 23:33:05 -0500
In-Reply-To: <20070814043245.32206.34785.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Allow FLEX_BG to be use as a feature option at mke2fs time.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/e2p/feature.c   |    2 ++
 lib/ext2fs/ext2fs.h |    6 ++++--
 misc/mke2fs.c       |    7 ++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

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
index 83a9091..5c461c9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -432,12 +432,14 @@ typedef struct ext2_icount *ext2_icount_t;
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
index 4a6cace..6dd8d30 100644
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
 
@@ -1363,6 +1364,10 @@ static void PRS(int argc, char *argv[])
 		fs_param.s_feature_ro_compat = 0;
  	}
 	
+	if (fs_param.s_feature_incompat &
+	    EXT4_FEATURE_INCOMPAT_FLEX_BG)
+		fs_param.s_feature_incompat |= EXT2_FEATURE_INCOMPAT_META_BG;
+
 	/* Set first meta blockgroup via an environment variable */
 	/* (this is mostly for debugging purposes) */
 	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
