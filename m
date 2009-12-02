From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: Use slab allocator for sub-page sized allocations
Date: Tue,  1 Dec 2009 20:14:11 -0500
Message-ID: <1259716451-26901-2-git-send-email-tytso@mit.edu>
References: <1259716451-26901-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43725 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZLBBOH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2009 20:14:07 -0500
In-Reply-To: <1259716451-26901-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that the SLUB seems to be fixed so that it respects the requested
alignment, use kmem_cache_alloc() to allocator if the block size of
the buffer heads to be allocated is less than the page size.
Previously, we were using 16k page on a Power system for each buffer,
even when the file system was using 1k or 4k block size.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c    |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |   11 +----
 2 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 3f473fa..8e0c0a9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -39,6 +39,8 @@
 #include <linux/seq_file.h>
 #include <linux/math64.h>
 #include <linux/hash.h>
+#include <linux/log2.h>
+#include <linux/vmalloc.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/jbd2.h>
@@ -92,6 +94,7 @@ EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
+static int jbd2_journal_create_slab(size_t slab_size);
 
 /*
  * Helper function used to manage commit timeouts
@@ -1247,6 +1250,13 @@ int jbd2_journal_load(journal_t *journal)
 		}
 	}
 
+	/*
+	 * Create a slab for this blocksize
+	 */
+	err = jbd2_journal_create_slab(be32_to_cpu(sb->s_blocksize));
+	if (err)
+		return err;
+
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
 	if (jbd2_journal_recover(journal))
@@ -1806,6 +1816,111 @@ size_t journal_tag_bytes(journal_t *journal)
 }
 
 /*
+ * JBD memory management
+ */
+
+#define JBD2_MAX_SLABS 8
+static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
+
+static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
+	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
+	"jbd2_16k", "jbd2_32k", "jbd2_64k", "jbd2_128k"
+};
+
+
+static void jbd2_journal_destroy_slabs(void)
+{
+	int i;
+
+	for (i = 0; i < JBD2_MAX_SLABS; i++) {
+		if (jbd2_slab[i])
+			kmem_cache_destroy(jbd2_slab[i]);
+		jbd2_slab[i] = NULL;
+	}
+}
+
+static int jbd2_journal_create_slab(size_t size)
+{
+	int i = order_base_2(size) - 10;
+	size_t slab_size;
+
+	if (size == PAGE_SIZE)
+		return 0;
+
+	if (i >= JBD2_MAX_SLABS)
+		return -EINVAL;
+
+	if (unlikely(i < 0))
+		i = 0;
+	if (jbd2_slab[i])
+		return 0;	/* Already created */
+
+	slab_size = 1 << (i+10);
+	jbd2_slab[i] = kmem_cache_create(jbd2_slab_names[i], slab_size,
+					 slab_size, 0, NULL);
+	if (!jbd2_slab[i]) {
+		printk(KERN_EMERG "JBD2: no memory for jbd2_slab cache\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static struct kmem_cache *get_slab(size_t size)
+{
+	int i = order_base_2(size) - 10;
+
+	BUG_ON(i >= JBD2_MAX_SLABS);
+	if (unlikely(i < 0))
+		i = 0;
+	BUG_ON(jbd2_slab[i] == 0);
+	return jbd2_slab[i];
+}
+
+void *jbd2_alloc(size_t size, gfp_t flags)
+{
+	void *ptr;
+
+	BUG_ON(size & (size-1)); /* Must be a power of 2 */
+
+	flags |= __GFP_REPEAT;
+	if (size == PAGE_SIZE)
+		ptr = (void *)__get_free_pages(flags, 0);
+	else if (size > PAGE_SIZE) {
+		int order = get_order(size);
+
+		if (order < 3)
+			ptr = (void *)__get_free_pages(flags, order);
+		else
+			ptr = vmalloc(size);
+	} else
+		ptr = kmem_cache_alloc(get_slab(size), flags);
+
+	/* Check alignment; SLUB has gotten this wrong in the past,
+	 * and this can lead to user data corruption! */
+	BUG_ON(((unsigned long) ptr) & (size-1));
+
+	return ptr;
+}
+
+void jbd2_free(void *ptr, size_t size)
+{
+	if (size == PAGE_SIZE) {
+		free_pages((unsigned long)ptr, 0);
+		return;
+	}
+	if (size > PAGE_SIZE) {
+		int order = get_order(size);
+
+		if (order < 3)
+			free_pages((unsigned long)ptr, order);
+		else
+			vfree(ptr);
+		return;
+	}
+	kmem_cache_free(get_slab(size), ptr);
+};
+
+/*
  * Journal_head storage management
  */
 static struct kmem_cache *jbd2_journal_head_cache;
@@ -2202,6 +2317,7 @@ static void jbd2_journal_destroy_caches(void)
 	jbd2_journal_destroy_revoke_caches();
 	jbd2_journal_destroy_jbd2_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
+	jbd2_journal_destroy_slabs();
 }
 
 static int __init journal_init(void)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f1011f7..a7a8c7a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -69,15 +69,8 @@ extern u8 jbd2_journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-static inline void *jbd2_alloc(size_t size, gfp_t flags)
-{
-	return (void *)__get_free_pages(flags, get_order(size));
-}
