From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 01/22] libext2fs: add INLINE_DATA into EXT2_LIB_SOFTSUPP_INCOMPAT
Date: Fri,  2 Aug 2013 17:49:28 +0800
Message-ID: <1375436989-18948-2-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47578 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3HBJuG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:06 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so500315pbb.41
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:05 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

EXT4_FEATURE_INCOMPAT_INLINE_DATA flag is added into
EXT2_LIB_SOFTSUPP_INCOMPAT due to we still need to take a long time to
test inline_data feature.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6923f34..100270c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -604,7 +604,7 @@ typedef struct ext2_icount *ext2_icount_t;
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
  */
-#define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
+#define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT4_FEATURE_INCOMPAT_INLINE_DATA)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA)
 
 
-- 
1.7.9.7

