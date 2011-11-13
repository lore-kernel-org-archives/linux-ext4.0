From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] jbd: use KMEM_CACHE instead of kmem_cache_create
Date: Sun, 13 Nov 2011 19:29:32 +0800
Message-ID: <1321183772-6181-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321183772-6181-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36043 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1KMNw2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 08:52:28 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6145576iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 05:52:27 -0800 (PST)
In-Reply-To: <1321183772-6181-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let jbd use KMEM_CACHE instead of kmem_cache_create.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd/journal.c |   12 ++----------
 fs/jbd/revoke.c  |   11 +++--------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 45ca982..b0ee518 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1735,11 +1735,7 @@ static int journal_init_journal_head_cache(void)
 	int retval;
 
 	J_ASSERT(journal_head_cache == NULL);
-	journal_head_cache = kmem_cache_create("journal_head",
-				sizeof(struct journal_head),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
+	journal_head_cache = KMEM_CACHE(journal_head, SLAB_TEMPORARY);
 	retval = 0;
 	if (!journal_head_cache) {
 		retval = -ENOMEM;
@@ -1973,11 +1969,7 @@ struct kmem_cache *jbd_handle_cache;
 
 static int __init journal_init_handle_cache(void)
 {
-	jbd_handle_cache = kmem_cache_create("journal_handle",
-				sizeof(handle_t),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
+	jbd_handle_cache = KMEM_CACHE(handle_s, SLAB_TEMPORARY);
 	if (jbd_handle_cache == NULL) {
 		printk(KERN_EMERG "JBD: failed to create handle cache\n");
 		return -ENOMEM;
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 305a907..034eb82 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -203,17 +203,12 @@ int __init journal_init_revoke_caches(void)
 	J_ASSERT(!revoke_record_cache);
 	J_ASSERT(!revoke_table_cache);
 
-	revoke_record_cache = kmem_cache_create("revoke_record",
-					   sizeof(struct jbd_revoke_record_s),
-					   0,
-					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
-					   NULL);
+	revoke_record_cache = KMEM_CACHE(jbd_revoke_record_s,
+					 SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
 	if (!revoke_record_cache)
 		goto record_cache_failure;
 
-	revoke_table_cache = kmem_cache_create("revoke_table",
-					   sizeof(struct jbd_revoke_table_s),
-					   0, SLAB_TEMPORARY, NULL);
+	revoke_table_cache = KMEM_CACHE(jbd_revoke_table_s, SLAB_TEMPORARY);
 	if (!revoke_table_cache)
 		goto table_cache_failure;
 
-- 
1.7.5.1

