From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 2/6] jbd: replace potentially false assertion with
	if block
Date: Sat, 8 Mar 2008 09:52:36 -0500
Message-ID: <20080308145236.GA18522@infradead.org>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <7fbb2f28dcb417e3173ffacc103932c36683f2f0.1204685366.git.duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbYCHOwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 09:52:38 -0500
Content-Disposition: inline
In-Reply-To: <7fbb2f28dcb417e3173ffacc103932c36683f2f0.1204685366.git.duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2008 at 01:59:10AM +0000, Duane Griffin wrote:
> If an error occurs during jbd cache initialisation it is possible for the
> journal_head_cache to be NULL when journal_destroy_journal_head_cache is
> called. Replace the J_ASSERT with an if block to handle the situation
> correctly.
> 
> Note that even with this fix things will break badly if ext3 is statically
> compiled in and cache initialisation fails.

Actually the whole code surrounding this is far too confusing.  The
patch below converts it much simpler code with proper goto unwinding
for initialization failures:

Index: linux-2.6/fs/jbd/journal.c
===================================================================
--- linux-2.6.orig/fs/jbd/journal.c	2008-03-08 15:43:41.000000000 +0100
+++ linux-2.6/fs/jbd/journal.c	2008-03-08 15:50:44.000000000 +0100
@@ -1615,31 +1615,6 @@ static struct kmem_cache *journal_head_c
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
 
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
 /*
  * journal_head splicing and dicing
  */
@@ -1891,59 +1866,45 @@ static inline void jbd_remove_debugfs_en
 
 struct kmem_cache *jbd_handle_cache;
 
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
+static int __init journal_init(void)
 {
 	int ret;
 
-	ret = journal_init_revoke_caches();
-	if (ret == 0)
-		ret = journal_init_journal_head_cache();
-	if (ret == 0)
-		ret = journal_init_handle_cache();
-	return ret;
-}
+	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
-static void journal_destroy_caches(void)
-{
-	journal_destroy_revoke_caches();
-	journal_destroy_journal_head_cache();
-	journal_destroy_handle_cache();
-}
+	ret = journal_init_revoke_caches();
+	if (ret)
+		goto out;
 
-static int __init journal_init(void)
-{
-	int ret;
+	ret = -ENOMEM;
+	journal_head_cache = kmem_cache_create("journal_head",
+				sizeof(struct journal_head),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!journal_head_cache)
+		goto out_destroy_revoke_caches;
 
-	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
+	jbd_handle_cache = kmem_cache_create("journal_handle",
+				sizeof(handle_t),
+				0,		/* offset */
+				SLAB_TEMPORARY,	/* flags */
+				NULL);		/* ctor */
+	if (!jbd_handle_cache)
+		goto out_destroy_head_cache;
 
-	ret = journal_init_caches();
-	if (ret != 0)
-		journal_destroy_caches();
 	jbd_create_debugfs_entry();
+	return 0;
+
+ out_destroy_head_cache:
+	kmem_cache_destroy(journal_head_cache);
+ out_destroy_revoke_caches:
+	journal_destroy_revoke_caches();
+ out:
 	return ret;
 }
 
@@ -1955,7 +1916,10 @@ static void __exit journal_exit(void)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
 #endif
 	jbd_remove_debugfs_entry();
-	journal_destroy_caches();
+
+	kmem_cache_destroy(jbd_handle_cache);
+	kmem_cache_destroy(journal_head_cache);
+	journal_destroy_revoke_caches();
 }
 
 MODULE_LICENSE("GPL");
