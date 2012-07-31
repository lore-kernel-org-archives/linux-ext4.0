From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 01/36 v4] libext2fs: add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
Date: Tue, 31 Jul 2012 19:47:54 +0800
Message-ID: <1343735309-30579-2-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLjs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:39:48 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:39:48 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag to support inline
data feature.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/e2p/feature.c    |    2 +-
 lib/ext2fs/ext2_fs.h |    2 +-
 lib/ext2fs/ext2fs.h  |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 8ac4f3f..70815ef 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -93,7 +93,7 @@ static struct feature feature_list[] = {
 			"dirdata"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_LARGEDIR,
 			"large_dir"},
-	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INLINEDATA,
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 			"inline_data"},
 	{	0, 0, 0 },
 };
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 4093d5b..c6de26a 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -750,7 +750,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 /* 0x2000 was EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM but this was never used */
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
-#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x8000 /* data in inode */
+#define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 02e1b4e..65d30de 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -566,7 +566,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -575,7 +576,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
 #endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-- 
1.7.4.1

