From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 01/21 v5] libext2fs: add INLINE_DATA into EXT2_LIB_SOFTSUPP_INCOMPAT
Date: Sat, 22 Sep 2012 12:00:49 +0800
Message-ID: <1348286469-31690-2-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2IVDvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:00 -0400
Received: by pbbrr4 with SMTP id rr4so3873803pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:50:59 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

EXT4_FEATURE_INCOMPAT_INLINE_DATA flag is added into EXT2_LIB_SOFTSUPP_INCOMPAT
due to we still need to take a long time to test inline_data feature.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9927875..1cd53f0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -602,7 +602,7 @@ typedef struct ext2_icount *ext2_icount_t;
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
  */
-#define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
+#define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT4_FEATURE_INCOMPAT_INLINE_DATA)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA)
 
 
-- 
1.7.4.1

