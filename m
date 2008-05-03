From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 2/3] jbd: tidy up revoke cache initialisation and destruction
Date: Sat,  3 May 2008 17:47:14 +0100
Message-ID: <1209833235-30521-3-git-send-email-duaneg@dghda.com>
References: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
 <1209833235-30521-2-git-send-email-duaneg@dghda.com>
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4039 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759761AbYECQyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 May 2008 12:54:04 -0400
In-Reply-To: <1209833235-30521-2-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make revocation cache destruction safe to call if initialisation fails
partially or entirely. This allows it to be used to cleanup in the case of
initialisation failure, simplifying that code slightly.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd/revoke.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 8ff5a7b..c99f4bf 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -166,33 +166,41 @@ static struct jbd_revoke_record_s *find_revoke_record(journal_t *journal,
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
-	return 0;
-}
+	if (!revoke_table_cache)
+		goto table_cache_failure;
 
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
-- 
1.5.3.7

