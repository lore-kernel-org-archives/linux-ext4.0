From: akpm@linux-foundation.org
Subject: [patch 065/283] jbd: tidy up revoke cache initialisation and destruction
Date: Fri, 25 Jul 2008 00:01:58 -0700
Message-ID: <200807250701.m6P71xnW028434@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYGYHCE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 03:02:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Duane Griffin" <duaneg@dghda.com>

Make revocation cache destruction safe to call if initialisation fails
partially or entirely.  This allows it to be used to cleanup in the case
of initialisation failure, simplifying that code slightly.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/revoke.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff -puN fs/jbd/revoke.c~jbd-tidy-up-revoke-cache-initialisation-and-destruction fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-tidy-up-revoke-cache-initialisation-and-destruction
+++ a/fs/jbd/revoke.c
@@ -166,33 +166,43 @@ static struct jbd_revoke_record_s *find_
 	return NULL;
 }
 
+void journal_destroy_revoke_caches(void)
+{
+	if (revoke_record_cache) {
+		kmem_cache_destroy(revoke_record_cache);
+		revoke_record_cache = NULL;
+	}
+	if (revoke_table_cache) {
+		kmem_cache_destroy(revoke_table_cache);
+		revoke_table_cache = NULL;
+	}
+}
+
 int __init journal_init_revoke_caches(void)
 {
+	J_ASSERT(!revoke_record_cache);
+	J_ASSERT(!revoke_table_cache);
+
 	revoke_record_cache = kmem_cache_create("revoke_record",
 					   sizeof(struct jbd_revoke_record_s),
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
 	if (!revoke_record_cache)
-		return -ENOMEM;
+		goto record_cache_failure;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (!revoke_table_cache) {
-		kmem_cache_destroy(revoke_record_cache);
-		revoke_record_cache = NULL;
-		return -ENOMEM;
-	}
+	if (!revoke_table_cache)
+		goto table_cache_failure;
+
 	return 0;
-}
 
-void journal_destroy_revoke_caches(void)
-{
-	kmem_cache_destroy(revoke_record_cache);
-	revoke_record_cache = NULL;
-	kmem_cache_destroy(revoke_table_cache);
-	revoke_table_cache = NULL;
+table_cache_failure:
+	journal_destroy_revoke_caches();
+record_cache_failure:
+	return -ENOMEM;
 }
 
 static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
_
