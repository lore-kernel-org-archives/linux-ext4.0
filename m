From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Fri, 12 Apr 2013 20:24:06 +0800
Message-ID: <1365769446-22034-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35091 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3DLMHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Apr 2013 08:07:09 -0400
Received: by mail-pd0-f181.google.com with SMTP id y10so1373987pdj.26
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2013 05:07:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now jbd_alloc_handle is only called by new_handle.  So this commit
uses kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/jbd/transaction.c | 1 -
 include/linux/jbd.h  | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 071d690..e3e255c 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -245,7 +245,6 @@ static handle_t *new_handle(int nblocks)
 	handle_t *handle = jbd_alloc_handle(GFP_NOFS);
 	if (!handle)
 		return NULL;
-	memset(handle, 0, sizeof(*handle));
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index c8f3297..7e0b622 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -887,7 +887,7 @@ extern struct kmem_cache *jbd_handle_cache;
 
 static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
 {
-	return kmem_cache_alloc(jbd_handle_cache, gfp_flags);
+	return kmem_cache_zalloc(jbd_handle_cache, gfp_flags);
 }
 
 static inline void jbd_free_handle(handle_t *handle)
-- 
1.7.12.rc2.18.g61b472e

