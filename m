From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] jbd: handle cache initialisation failure gracefully when statically compiled in
Date: Sat,  8 Mar 2008 18:37:38 +0000
Message-ID: <1205001459-5291-6-git-send-email-duaneg@dghda.com>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
 <1205001459-5291-2-git-send-email-duaneg@dghda.com>
 <1205001459-5291-3-git-send-email-duaneg@dghda.com>
 <1205001459-5291-4-git-send-email-duaneg@dghda.com>
 <1205001459-5291-5-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2257 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbYCHSh6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2008 13:37:58 -0500
In-Reply-To: <1205001459-5291-5-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When jbd is statically compiled into the kernel we need to check whether the
caches are properly initialised before using them. If they are not then have
another go before failing gracefully.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd/journal.c |  149 ++++++++++++++++++++++++++----------------------------
 fs/jbd/revoke.c  |    2 +-
 2 files changed, 73 insertions(+), 78 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..884e4ee 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -642,6 +642,67 @@ struct journal_head *journal_get_descriptor_buffer(journal_t *journal)
 }
 
 /*
+ * Journal_head storage management
+ */
+static struct kmem_cache *journal_head_cache;
+#ifdef CONFIG_JBD_DEBUG
+static atomic_t nr_journal_heads = ATOMIC_INIT(0);
+#endif
+
+struct kmem_cache *jbd_handle_cache;
+
+static void journal_destroy_caches(void)
+{
+	journal_destroy_revoke_caches();
+
+	if (journal_head_cache) {
+		kmem_cache_destroy(journal_head_cache);
+		journal_head_cache = NULL;
+	}
+
+	if (jbd_handle_cache) {
+		kmem_cache_destroy(jbd_handle_cache);
+		jbd_handle_cache = NULL;
+	}
+}
+
+static int journal_init_caches(void)
+{
+	int ret;
+
+	J_ASSERT(!journal_head_cache);
+	J_ASSERT(!jbd_handle_cache);
+
+	ret = journal_init_revoke_caches();
+	if (ret)
+		goto fail;
+
+	ret = -ENOMEM;
+	journal_head_cache = kmem_cache_create("journal_head",
+				sizeof(struct journal_head),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!journal_head_cache)
+		goto fail;
+
+	jbd_handle_cache = kmem_cache_create("journal_handle",
+				sizeof(handle_t),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!jbd_handle_cache)
+		goto fail;
+
+	return 0;
+
+fail:
+	journal_destroy_caches();
+	printk(KERN_EMERG "JBD: no memory to initialise cache\n");
+	return ret;
+}
+
+/*
  * Management for journal control blocks: functions to create and
  * destroy journal_t structures, and to initialise and read existing
  * journal blocks from disk.  */
@@ -653,7 +714,14 @@ struct journal_head *journal_get_descriptor_buffer(journal_t *journal)
 static journal_t * journal_init_common (void)
 {
 	journal_t *journal;
-	int err;
+	int err = 0;
+
+	if (!journal_head_cache)
+		err = journal_init_caches();
+	if (err) {
+		journal_destroy_caches();
+		return NULL;
+	}
 
 	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
@@ -1608,39 +1676,6 @@ int journal_blocks_per_page(struct inode *inode)
 }
 
 /*
- * Journal_head storage management
- */
-static struct kmem_cache *journal_head_cache;
-#ifdef CONFIG_JBD_DEBUG
-static atomic_t nr_journal_heads = ATOMIC_INIT(0);
-#endif
-
-static int journal_init_journal_head_cache(void)
-{
-	int retval;
-
-	J_ASSERT(journal_head_cache == 0);
-	journal_head_cache = kmem_cache_create("journal_head",
-				sizeof(struct journal_head),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
-	retval = 0;
-	if (journal_head_cache == 0) {
-		retval = -ENOMEM;
-		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
-	}
-	return retval;
-}
-
-static void journal_destroy_journal_head_cache(void)
-{
-	J_ASSERT(journal_head_cache != NULL);
-	kmem_cache_destroy(journal_head_cache);
-	journal_head_cache = NULL;
-}
-
-/*
  * journal_head splicing and dicing
  */
 static struct journal_head *journal_alloc_journal_head(void)
@@ -1889,51 +1924,10 @@ static inline void jbd_remove_debugfs_entry(void)
 
 #endif
 
-struct kmem_cache *jbd_handle_cache;
-
-static int __init journal_init_handle_cache(void)
-{
-	jbd_handle_cache = kmem_cache_create("journal_handle",
-				sizeof(handle_t),
-				0,		/* offset */
-				SLAB_TEMPORARY,	/* flags */
-				NULL);		/* ctor */
-	if (jbd_handle_cache == NULL) {
-		printk(KERN_EMERG "JBD: failed to create handle cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void journal_destroy_handle_cache(void)
-{
-	if (jbd_handle_cache)
-		kmem_cache_destroy(jbd_handle_cache);
-}
-
 /*
  * Module startup and shutdown
  */
 
-static int __init journal_init_caches(void)
-{
-	int ret;
-
-	ret = journal_init_revoke_caches();
-	if (ret == 0)
-		ret = journal_init_journal_head_cache();
-	if (ret == 0)
-		ret = journal_init_handle_cache();
-	return ret;
-}
-
-static void journal_destroy_caches(void)
-{
-	journal_destroy_revoke_caches();
-	journal_destroy_journal_head_cache();
-	journal_destroy_handle_cache();
-}
-
 static int __init journal_init(void)
 {
 	int ret;
@@ -1941,9 +1935,10 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0)
+		jbd_create_debugfs_entry();
+	else
 		journal_destroy_caches();
-	jbd_create_debugfs_entry();
 	return ret;
 }
 
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index c1fcd62..b586801 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -178,7 +178,7 @@ void journal_destroy_revoke_caches(void)
 	}
 }
 
-int __init journal_init_revoke_caches(void)
+int journal_init_revoke_caches(void)
 {
 	J_ASSERT(!revoke_record_cache);
 	J_ASSERT(!revoke_table_cache);
-- 
1.5.3.7

