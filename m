From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] jbd2: tidy up revoke cache initialisation and destruction
Date: Sat,  8 Mar 2008 18:37:37 +0000
Message-ID: <1205001459-5291-5-git-send-email-duaneg@dghda.com>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
 <1205001459-5291-2-git-send-email-duaneg@dghda.com>
 <1205001459-5291-3-git-send-email-duaneg@dghda.com>
 <1205001459-5291-4-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2249 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbYCHShz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2008 13:37:55 -0500
In-Reply-To: <1205001459-5291-4-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make revocation cache destruction safe to call if initialisation fails
partially or entirely. This allows it to be used to cleanup in the case of
initialisation failure, simplifying that code slightly.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd2/revoke.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 07e4703..5a020f1 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -167,33 +167,38 @@ static struct jbd2_revoke_record_s *find_revoke_record(journal_t *journal,
 	return NULL;
 }
 
+void jbd2_journal_destroy_revoke_caches(void)
+{
+	if (jbd2_revoke_record_cache) {
+		kmem_cache_destroy(jbd2_revoke_record_cache);
+		jbd2_revoke_record_cache = NULL;
+	}
+	if (jbd2_revoke_table_cache) {
+		kmem_cache_destroy(jbd2_revoke_table_cache);
+		jbd2_revoke_table_cache = NULL;
+	}
+}
+
 int __init jbd2_journal_init_revoke_caches(void)
 {
+	J_ASSERT(!jbd2_revoke_record_cache);
+	J_ASSERT(!jbd2_revoke_table_cache);
+
 	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
 					   sizeof(struct jbd2_revoke_record_s),
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (jbd2_revoke_record_cache == 0)
-		return -ENOMEM;
-
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (jbd2_revoke_table_cache == 0) {
-		kmem_cache_destroy(jbd2_revoke_record_cache);
-		jbd2_revoke_record_cache = NULL;
+
+	if (jbd2_revoke_table_cache && jbd2_revoke_table_cache) {
+		return 0;
+	} else {
+		jbd2_journal_destroy_revoke_caches();
 		return -ENOMEM;
 	}
-	return 0;
-}
