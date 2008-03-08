From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] jbd2: handle cache initialisation failure gracefully when statically compiled in
Date: Sat,  8 Mar 2008 18:37:39 +0000
Message-ID: <1205001459-5291-7-git-send-email-duaneg@dghda.com>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
 <1205001459-5291-2-git-send-email-duaneg@dghda.com>
 <1205001459-5291-3-git-send-email-duaneg@dghda.com>
 <1205001459-5291-4-git-send-email-duaneg@dghda.com>
 <1205001459-5291-5-git-send-email-duaneg@dghda.com>
 <1205001459-5291-6-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2265 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350AbYCHSiB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2008 13:38:01 -0500
In-Reply-To: <1205001459-5291-6-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When jbd2 is statically compiled into the kernel we need to check whether the
caches are properly initialised before using them. If they are not then have
another go before failing gracefully.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd2/journal.c |  154 ++++++++++++++++++++++++++---------------------------
 fs/jbd2/revoke.c  |    2 +-
 2 files changed, 76 insertions(+), 80 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 96ba846..d4cc95a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -641,6 +641,67 @@ struct journal_head *jbd2_journal_get_descriptor_buffer(journal_t *journal)
 	return jbd2_journal_add_journal_head(bh);
 }
 
+/*
+ * Journal_head storage management
+ */
+static struct kmem_cache *jbd2_journal_head_cache;
+#ifdef CONFIG_JBD2_DEBUG
+static atomic_t nr_journal_heads = ATOMIC_INIT(0);
+#endif
+
+struct kmem_cache *jbd2_handle_cache;
+
+static void jbd2_journal_destroy_caches(void)
+{
+	jbd2_journal_destroy_revoke_caches();
+
+	if (jbd2_journal_head_cache) {
+		kmem_cache_destroy(jbd2_journal_head_cache);
+		jbd2_journal_head_cache = NULL;
+	}
+
+	if (jbd2_handle_cache) {
+		kmem_cache_destroy(jbd2_handle_cache);
+		jbd2_handle_cache = NULL;
+	}
+}
+
+static int jbd2_journal_init_caches(void)
+{
+	int ret;
+
+	J_ASSERT(!jbd2_journal_head_cache);
+	J_ASSERT(!jbd2_handle_cache);
+
+	ret = jbd2_journal_init_revoke_caches();
+	if (ret)
+		goto fail;
+
+	ret = -ENOMEM;
+	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
+				sizeof(struct journal_head),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!jbd2_journal_head_cache)
+		goto fail;
+
+	jbd2_handle_cache = kmem_cache_create("jbd2_journal_handle",
+				sizeof(handle_t),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!jbd2_handle_cache)
+		goto fail;
+
+	return 0;
+
+fail:
+	jbd2_journal_destroy_caches();
+	printk(KERN_EMERG "JBD2: no memory to initialise cache\n");
+	return ret;
+}
+
 struct jbd2_stats_proc_session {
 	journal_t *journal;
 	struct transaction_stats_s *stats;
@@ -959,7 +1020,14 @@ static void journal_init_stats(journal_t *journal)
 static journal_t * journal_init_common (void)
 {
 	journal_t *journal;
-	int err;
+	int err = 0;
+
+	if (!jbd2_journal_head_cache)
+		err = jbd2_journal_init_caches();
+	if (err) {
+		jbd2_journal_destroy_caches();
+		return NULL;
+	}
 
 	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
@@ -1958,39 +2026,6 @@ size_t journal_tag_bytes(journal_t *journal)
 }
 
 /*
- * Journal_head storage management
- */
-static struct kmem_cache *jbd2_journal_head_cache;
-#ifdef CONFIG_JBD2_DEBUG
-static atomic_t nr_journal_heads = ATOMIC_INIT(0);
-#endif
-
-static int journal_init_jbd2_journal_head_cache(void)
-{
-	int retval;
-
-	J_ASSERT(jbd2_journal_head_cache == 0);
-	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
-				sizeof(struct journal_head),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
-	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
-		retval = -ENOMEM;
-		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
-	}
-	return retval;
-}
-
-static void jbd2_journal_destroy_jbd2_journal_head_cache(void)
-{
-	J_ASSERT(jbd2_journal_head_cache != NULL);
-	kmem_cache_destroy(jbd2_journal_head_cache);
-	jbd2_journal_head_cache = NULL;
-}
-
-/*
  * journal_head splicing and dicing
  */
 static struct journal_head *journal_alloc_journal_head(void)
@@ -2262,62 +2297,23 @@ static void __exit jbd2_remove_jbd_stats_proc_entry(void)
 
 #endif
 
-struct kmem_cache *jbd2_handle_cache;
-
-static int __init journal_init_handle_cache(void)
-{
-	jbd2_handle_cache = kmem_cache_create("jbd2_journal_handle",
-				sizeof(handle_t),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
-	if (jbd2_handle_cache == NULL) {
-		printk(KERN_EMERG "JBD: failed to create handle cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void jbd2_journal_destroy_handle_cache(void)
-{
-	if (jbd2_handle_cache)
-		kmem_cache_destroy(jbd2_handle_cache);
-}
-
 /*
  * Module startup and shutdown
  */
 
-static int __init journal_init_caches(void)
-{
-	int ret;
-
-	ret = jbd2_journal_init_revoke_caches();
-	if (ret == 0)
-		ret = journal_init_jbd2_journal_head_cache();
-	if (ret == 0)
-		ret = journal_init_handle_cache();
-	return ret;
-}
-
-static void jbd2_journal_destroy_caches(void)
-{
-	jbd2_journal_destroy_revoke_caches();
-	jbd2_journal_destroy_jbd2_journal_head_cache();
-	jbd2_journal_destroy_handle_cache();
-}
-
 static int __init journal_init(void)
 {
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
-	ret = journal_init_caches();
-	if (ret != 0)
+	ret = jbd2_journal_init_caches();
+	if (ret == 0) {
+		jbd2_create_debugfs_entry();
+		jbd2_create_jbd_stats_proc_entry();
+	} else {
 		jbd2_journal_destroy_caches();
-	jbd2_create_debugfs_entry();
-	jbd2_create_jbd_stats_proc_entry();
+	}
 	return ret;
 }
 
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 5a020f1..da4551e 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -179,7 +179,7 @@ void jbd2_journal_destroy_revoke_caches(void)
 	}
 }
 
-int __init jbd2_journal_init_revoke_caches(void)
+int jbd2_journal_init_revoke_caches(void)
 {
 	J_ASSERT(!jbd2_revoke_record_cache);
 	J_ASSERT(!jbd2_revoke_table_cache);
-- 
1.5.3.7

