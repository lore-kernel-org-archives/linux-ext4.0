From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] jbd2: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Fri, 12 Apr 2013 20:24:23 +0800
Message-ID: <1365769463-22071-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52235 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3DLMHZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Apr 2013 08:07:25 -0400
Received: by mail-pd0-f170.google.com with SMTP id 10so1387184pdi.1
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2013 05:07:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now jbd2_alloc_handle is only called by new_handle.  So this commit
uses kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/jbd2/transaction.c | 1 -
 include/linux/jbd2.h  | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 63834eb..3abdad1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -332,7 +332,6 @@ static handle_t *new_handle(int nblocks)
 	handle_t *handle = jbd2_alloc_handle(GFP_NOFS);
 	if (!handle)
 		return NULL;
-	memset(handle, 0, sizeof(*handle));
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 04c04dc..c9fc7df 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1146,7 +1146,7 @@ extern struct kmem_cache *jbd2_handle_cache;
 
 static inline handle_t *jbd2_alloc_handle(gfp_t gfp_flags)
 {
-	return kmem_cache_alloc(jbd2_handle_cache, gfp_flags);
+	return kmem_cache_zalloc(jbd2_handle_cache, gfp_flags);
 }
 
 static inline void jbd2_free_handle(handle_t *handle)
-- 
1.7.12.rc2.18.g61b472e

