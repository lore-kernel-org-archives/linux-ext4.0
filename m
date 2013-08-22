From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH v2 1/2] mbcache: decoupling the locking of local from global data
Date: Thu, 22 Aug 2013 09:54:35 -0600
Message-ID: <1377186876-57291-2-git-send-email-tmac@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1377186876-57291-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, torvalds@linux-foundation.org,
	T Makphaibulchoke <tmac@hp.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9512 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3HVPzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Aug 2013 11:55:08 -0400
In-Reply-To: <1377186876-57291-1-git-send-email-tmac@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The patch increases the parallelism of mb_cache_entry utilization by
introducing new spinlocks to the mb_cache structure to protect the mb_cache
local block and index hash chains, while the global mb_cache_lru_list and
mb_cache_list continue to be protected by the global mb_cache_spinlock.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
Changed in v2:
	- As per Linus Torvalds' suggestion, instead of allocating spinlock
	  arrays to protect the hash chains, use hlist_bl_head, which already
	  contains builtin lock.

 fs/mbcache.c            | 293 +++++++++++++++++++++++++++++++++++-------------
 include/linux/mbcache.h |  10 +-
 2 files changed, 221 insertions(+), 82 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 8c32ef3..cd4446e 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -26,6 +26,16 @@
  * back on the lru list.
  */
 
+/* Locking protocol:
+ *
+ * The nth hash chain of both the c_block_hash and c_index_hash are
+ * protected by the mth entry of the c_bdev_locks and c_key_locks respectively,
+ * where m is equal to n & c_lock_mask.
+ *
+ * While holding a c_bdev_locks, a thread can acquire either a c_key_locks
+ * or mb_cache_spinlock.
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -35,9 +45,9 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/list_bl.h>
 #include <linux/mbcache.h>
 
-
 #ifdef MB_CACHE_DEBUG
 # define mb_debug(f...) do { \
 		printk(KERN_DEBUG f); \
@@ -57,6 +67,40 @@
 
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
+#define	MB_LOCK_HASH_CHAIN(hash_head)	hlist_bl_lock(hash_head)
+#define	MB_UNLOCK_HASH_CHAIN(hash_head)	hlist_bl_unlock(hash_head)
+#ifdef MB_CACHE_DEBUG
+#define	MB_LOCK_BLOCK_HASH(ce) do {					\
+		struct hlist_bl_head *block_hash_p = ce->e_block_hash_p;\
+		MB_LOCK_HASH_CHAIN(block_hash_p);			\
+		mb_assert(ce->e_block_hash_p == block_hash_p);		\
+	} while (0)
+#else
+#define	MB_LOCK_BLOCK_HASH(ce)	MB_LOCK_HASH_CHAIN(ce->e_block_hash_p)
+#endif
+#define	MB_UNLOCK_BLOCK_HASH(ce)	MB_UNLOCK_HASH_CHAIN(ce->e_block_hash_p)
+#define	MB_LOCK_INDEX_HASH(ce)		MB_LOCK_HASH_CHAIN(ce->e_index_hash_p)
+#define	MB_UNLOCK_INDEX_HASH(ce)	MB_UNLOCK_HASH_CHAIN(ce->e_index_hash_p)
+
+#define	MAX_LOCK_RETRY	1024
+
+static inline int __mb_cache_lock_entry_block_hash(struct mb_cache_entry *ce)
+{
+	int nretry = 0;
+	struct hlist_bl_head *block_hash_p = ce->e_block_hash_p;
+
+	do {
+		MB_LOCK_HASH_CHAIN(block_hash_p);
+		if (ce->e_block_hash_p == block_hash_p)
+			return 0;
+		MB_UNLOCK_HASH_CHAIN(block_hash_p);
+		block_hash_p = ce->e_block_hash_p;
+	} while (++nretry < MAX_LOCK_RETRY);
+	return -1;
+}
+
+#define	MB_LOCK_ENTRY_BLOCK_HASH(ce)	__mb_cache_lock_entry_block_hash(ce)
+
 static DECLARE_WAIT_QUEUE_HEAD(mb_cache_queue);
 		
 MODULE_AUTHOR("Andreas Gruenbacher <a.gruenbacher@computer.org>");
@@ -101,7 +145,7 @@ static struct shrinker mb_cache_shrinker = {
 static inline int
 __mb_cache_entry_is_hashed(struct mb_cache_entry *ce)
 {
-	return !list_empty(&ce->e_block_list);
+	return !hlist_bl_unhashed(&ce->e_block_list);
 }
 
 
@@ -109,11 +153,26 @@ static void
 __mb_cache_entry_unhash(struct mb_cache_entry *ce)
 {
 	if (__mb_cache_entry_is_hashed(ce)) {
-		list_del_init(&ce->e_block_list);
-		list_del(&ce->e_index.o_list);
+		hlist_bl_del_init(&ce->e_block_list);
+		MB_LOCK_INDEX_HASH(ce);
+		hlist_bl_del(&ce->e_index.o_list);
+		MB_UNLOCK_INDEX_HASH(ce);
 	}
 }
 
+#ifdef	MAK_SRC
+static void
+__mb_cache_entry_unhash_nolock(struct mb_cache_entry *ce)
+{
+	mb_assert(!__mb_cache_entry_is_hashed(ce));
+	mb_assert(!ce->e_block_hash_p);
+	mb_assert(!ce->e_index_hash_p);
+
+	hlist_bl_del_init(&ce->e_block_list);
+	hlist_bl_del(&ce->e_index.o_list);
+}
+#endif	/* MAK_SRC */
+
 
 static void
 __mb_cache_entry_forget(struct mb_cache_entry *ce, gfp_t gfp_mask)
@@ -127,9 +186,10 @@ __mb_cache_entry_forget(struct mb_cache_entry *ce, gfp_t gfp_mask)
 
 
 static void
-__mb_cache_entry_release_unlock(struct mb_cache_entry *ce)
-	__releases(mb_cache_spinlock)
+__mb_cache_entry_release_unlock(struct mb_cache_entry *ce,
+	struct hlist_bl_head *hash_p)
 {
+	mb_assert(hash_p);
 	/* Wake up all processes queuing for this cache entry. */
 	if (ce->e_queued)
 		wake_up_all(&mb_cache_queue);
@@ -139,13 +199,17 @@ __mb_cache_entry_release_unlock(struct mb_cache_entry *ce)
 	if (!(ce->e_used || ce->e_queued)) {
 		if (!__mb_cache_entry_is_hashed(ce))
 			goto forget;
-		mb_assert(list_empty(&ce->e_lru_list));
-		list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
-	}
-	spin_unlock(&mb_cache_spinlock);
+		MB_UNLOCK_HASH_CHAIN(hash_p);
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&ce->e_lru_list))
+			list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+	} else
+		MB_UNLOCK_HASH_CHAIN(hash_p);
 	return;
 forget:
-	spin_unlock(&mb_cache_spinlock);
+	MB_UNLOCK_HASH_CHAIN(hash_p);
+	mb_assert(list_empty(&ce->e_lru_list));
 	__mb_cache_entry_forget(ce, GFP_KERNEL);
 }
 
@@ -164,31 +228,45 @@ forget:
 static int
 mb_cache_shrink_fn(struct shrinker *shrink, struct shrink_control *sc)
 {
-	LIST_HEAD(free_list);
 	struct mb_cache *cache;
-	struct mb_cache_entry *entry, *tmp;
 	int count = 0;
 	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
+	int max_loop = nr_to_scan << 1;
 
 	mb_debug("trying to free %d entries", nr_to_scan);
-	spin_lock(&mb_cache_spinlock);
-	while (nr_to_scan-- && !list_empty(&mb_cache_lru_list)) {
-		struct mb_cache_entry *ce =
-			list_entry(mb_cache_lru_list.next,
-				   struct mb_cache_entry, e_lru_list);
-		list_move_tail(&ce->e_lru_list, &free_list);
+	while ((nr_to_scan-- > 0) && (max_loop-- > 0)) {
+		struct mb_cache_entry *ce;
+
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&mb_cache_lru_list)) {
+			spin_unlock(&mb_cache_spinlock);
+			break;
+		}
+		ce = list_entry(mb_cache_lru_list.next,
+			struct mb_cache_entry, e_lru_list);
+		list_del_init(&ce->e_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+
+		if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
+			spin_lock(&mb_cache_spinlock);
+			list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+			spin_unlock(&mb_cache_spinlock);
+			continue;
+		}
+		mb_assert(!(ce->e_used || ce->e_queued));
 		__mb_cache_entry_unhash(ce);
+		MB_UNLOCK_BLOCK_HASH(ce);
+		__mb_cache_entry_forget(ce, gfp_mask);
+		nr_to_scan--;
 	}
+	spin_lock(&mb_cache_spinlock);
 	list_for_each_entry(cache, &mb_cache_list, c_cache_list) {
 		mb_debug("cache %s (%d)", cache->c_name,
 			  atomic_read(&cache->c_entry_count));
 		count += atomic_read(&cache->c_entry_count);
 	}
 	spin_unlock(&mb_cache_spinlock);
-	list_for_each_entry_safe(entry, tmp, &free_list, e_lru_list) {
-		__mb_cache_entry_forget(entry, gfp_mask);
-	}
 	return (count / 100) * sysctl_vfs_cache_pressure;
 }
 
@@ -216,18 +294,18 @@ mb_cache_create(const char *name, int bucket_bits)
 	cache->c_name = name;
 	atomic_set(&cache->c_entry_count, 0);
 	cache->c_bucket_bits = bucket_bits;
-	cache->c_block_hash = kmalloc(bucket_count * sizeof(struct list_head),
-	                              GFP_KERNEL);
+	cache->c_block_hash = kmalloc(bucket_count *
+		sizeof(struct hlist_bl_head), GFP_KERNEL);
 	if (!cache->c_block_hash)
 		goto fail;
 	for (n=0; n<bucket_count; n++)
-		INIT_LIST_HEAD(&cache->c_block_hash[n]);
-	cache->c_index_hash = kmalloc(bucket_count * sizeof(struct list_head),
-				      GFP_KERNEL);
+		INIT_HLIST_BL_HEAD(&cache->c_block_hash[n]);
+	cache->c_index_hash = kmalloc(bucket_count *
+		sizeof(struct hlist_bl_head), GFP_KERNEL);
 	if (!cache->c_index_hash)
 		goto fail;
 	for (n=0; n<bucket_count; n++)
-		INIT_LIST_HEAD(&cache->c_index_hash[n]);
+		INIT_HLIST_BL_HEAD(&cache->c_index_hash[n]);
 	cache->c_entry_cache = kmem_cache_create(name,
 		sizeof(struct mb_cache_entry), 0,
 		SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
@@ -276,13 +354,22 @@ mb_cache_shrink(struct block_device *bdev)
 			list_entry(l, struct mb_cache_entry, e_lru_list);
 		if (ce->e_bdev == bdev) {
 			list_move_tail(&ce->e_lru_list, &free_list);
-			__mb_cache_entry_unhash(ce);
 		}
 	}
 	spin_unlock(&mb_cache_spinlock);
 	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+		struct mb_cache_entry *ce =
+			list_entry(l, struct mb_cache_entry, e_lru_list);
+		if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
+			spin_lock(&mb_cache_spinlock);
+			list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+			spin_unlock(&mb_cache_spinlock);
+			continue;
+		}
+		mb_assert(!ce->e_used && !ce->e_queued);
+		__mb_cache_entry_unhash(ce);
+		MB_UNLOCK_BLOCK_HASH(ce);
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 }
 
@@ -306,15 +393,18 @@ mb_cache_destroy(struct mb_cache *cache)
 			list_entry(l, struct mb_cache_entry, e_lru_list);
 		if (ce->e_cache == cache) {
 			list_move_tail(&ce->e_lru_list, &free_list);
-			__mb_cache_entry_unhash(ce);
 		}
 	}
 	list_del(&cache->c_cache_list);
 	spin_unlock(&mb_cache_spinlock);
 
 	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+		struct mb_cache_entry *ce =
+			list_entry(l, struct mb_cache_entry, e_lru_list);
+		MB_LOCK_BLOCK_HASH(ce);
+		__mb_cache_entry_unhash(ce);
+		MB_UNLOCK_BLOCK_HASH(ce);
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 
 	if (atomic_read(&cache->c_entry_count) > 0) {
@@ -344,12 +434,26 @@ mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 	struct mb_cache_entry *ce = NULL;
 
 	if (atomic_read(&cache->c_entry_count) >= cache->c_max_entries) {
+		struct list_head *l;
+		struct list_head *ltmp;
+
 		spin_lock(&mb_cache_spinlock);
-		if (!list_empty(&mb_cache_lru_list)) {
-			ce = list_entry(mb_cache_lru_list.next,
-					struct mb_cache_entry, e_lru_list);
-			list_del_init(&ce->e_lru_list);
-			__mb_cache_entry_unhash(ce);
+		list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
+			ce = list_entry(l, struct mb_cache_entry, e_lru_list);
+			if (ce->e_cache == cache) {
+				list_del_init(&ce->e_lru_list);
+				spin_unlock(&mb_cache_spinlock);
+				if (MB_LOCK_ENTRY_BLOCK_HASH(ce)) {
+					spin_lock(&mb_cache_spinlock);
+					list_add_tail(&ce->e_lru_list,
+						&mb_cache_lru_list);
+					continue;
+				}
+				mb_assert(!ce->e_used && !ce->e_queued);
+				__mb_cache_entry_unhash(ce);
+				MB_UNLOCK_BLOCK_HASH(ce);
+				break;
+			}
 		}
 		spin_unlock(&mb_cache_spinlock);
 	}
@@ -359,9 +463,12 @@ mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 			return NULL;
 		atomic_inc(&cache->c_entry_count);
 		INIT_LIST_HEAD(&ce->e_lru_list);
-		INIT_LIST_HEAD(&ce->e_block_list);
+		INIT_HLIST_BL_NODE(&ce->e_block_list);
+		INIT_HLIST_BL_NODE(&ce->e_index.o_list);
 		ce->e_cache = cache;
 		ce->e_queued = 0;
+		ce->e_block_hash_p = &cache->c_block_hash[0];
+		ce->e_index_hash_p = &cache->c_index_hash[0];
 	}
 	ce->e_used = 1 + MB_CACHE_WRITER;
 	return ce;
@@ -388,28 +495,36 @@ mb_cache_entry_insert(struct mb_cache_entry *ce, struct block_device *bdev,
 {
 	struct mb_cache *cache = ce->e_cache;
 	unsigned int bucket;
-	struct list_head *l;
+	struct hlist_bl_node *l;
 	int error = -EBUSY;
+	struct hlist_bl_head *block_hash_p;
+	struct hlist_bl_head *index_hash_p;
+	struct mb_cache_entry *lce;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff), 
 			   cache->c_bucket_bits);
-	spin_lock(&mb_cache_spinlock);
-	list_for_each_prev(l, &cache->c_block_hash[bucket]) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_block_list);
-		if (ce->e_bdev == bdev && ce->e_block == block)
+	block_hash_p = &cache->c_block_hash[bucket];
+	MB_LOCK_HASH_CHAIN(block_hash_p);
+	hlist_bl_for_each_entry(lce, l, block_hash_p, e_block_list) {
+		if (lce->e_bdev == bdev && lce->e_block == block)
 			goto out;
 	}
+	mb_assert(!__mb_cache_entry_is_hashed(ce));
 	__mb_cache_entry_unhash(ce);
 	ce->e_bdev = bdev;
 	ce->e_block = block;
-	list_add(&ce->e_block_list, &cache->c_block_hash[bucket]);
+	hlist_bl_add_head(&ce->e_block_list, block_hash_p);
+	ce->e_block_hash_p = block_hash_p;
 	ce->e_index.o_key = key;
 	bucket = hash_long(key, cache->c_bucket_bits);
-	list_add(&ce->e_index.o_list, &cache->c_index_hash[bucket]);
+	index_hash_p = &cache->c_index_hash[bucket];
+	MB_LOCK_HASH_CHAIN(index_hash_p);
+	hlist_bl_add_head(&ce->e_index.o_list, index_hash_p);
+	ce->e_index_hash_p = index_hash_p;
+	MB_UNLOCK_HASH_CHAIN(index_hash_p);
 	error = 0;
 out:
-	spin_unlock(&mb_cache_spinlock);
+	MB_UNLOCK_HASH_CHAIN(block_hash_p);
 	return error;
 }
 
@@ -424,8 +539,8 @@ out:
 void
 mb_cache_entry_release(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
-	__mb_cache_entry_release_unlock(ce);
+	MB_LOCK_BLOCK_HASH(ce);
+	__mb_cache_entry_release_unlock(ce, ce->e_block_hash_p);
 }
 
 
@@ -438,10 +553,12 @@ mb_cache_entry_release(struct mb_cache_entry *ce)
 void
 mb_cache_entry_free(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
+	mb_assert(ce);
+	mb_assert(ce->e_block_hash_p);
+	MB_LOCK_BLOCK_HASH(ce);
 	mb_assert(list_empty(&ce->e_lru_list));
 	__mb_cache_entry_unhash(ce);
-	__mb_cache_entry_release_unlock(ce);
+	__mb_cache_entry_release_unlock(ce, ce->e_block_hash_p);
 }
 
 
@@ -458,34 +575,39 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 		   sector_t block)
 {
 	unsigned int bucket;
-	struct list_head *l;
+	struct hlist_bl_node *l;
 	struct mb_cache_entry *ce;
+	struct hlist_bl_head *block_hash_p;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff),
 			   cache->c_bucket_bits);
-	spin_lock(&mb_cache_spinlock);
-	list_for_each(l, &cache->c_block_hash[bucket]) {
-		ce = list_entry(l, struct mb_cache_entry, e_block_list);
+	block_hash_p = &cache->c_block_hash[bucket];
+	MB_LOCK_HASH_CHAIN(block_hash_p);
+	hlist_bl_for_each_entry(ce, l, block_hash_p, e_block_list) {
+		mb_assert(ce->e_block_hash_p == block_hash_p);
 		if (ce->e_bdev == bdev && ce->e_block == block) {
 			DEFINE_WAIT(wait);
 
+			spin_lock(&mb_cache_spinlock);
 			if (!list_empty(&ce->e_lru_list))
 				list_del_init(&ce->e_lru_list);
+			spin_unlock(&mb_cache_spinlock);
 
 			while (ce->e_used > 0) {
 				ce->e_queued++;
 				prepare_to_wait(&mb_cache_queue, &wait,
 						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
+				MB_UNLOCK_BLOCK_HASH(ce);
 				schedule();
-				spin_lock(&mb_cache_spinlock);
+				MB_LOCK_BLOCK_HASH(ce);
 				ce->e_queued--;
 			}
 			finish_wait(&mb_cache_queue, &wait);
 			ce->e_used += 1 + MB_CACHE_WRITER;
 
 			if (!__mb_cache_entry_is_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
+				__mb_cache_entry_release_unlock(ce,
+					block_hash_p);
 				return NULL;
 			}
 			goto cleanup;
@@ -494,25 +616,30 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 	ce = NULL;
 
 cleanup:
-	spin_unlock(&mb_cache_spinlock);
+	MB_UNLOCK_HASH_CHAIN(block_hash_p);
 	return ce;
 }
 
 #if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
 
 static struct mb_cache_entry *
-__mb_cache_entry_find(struct list_head *l, struct list_head *head,
+__mb_cache_entry_find(struct hlist_bl_node *l, struct hlist_bl_head *head,
 		      struct block_device *bdev, unsigned int key)
 {
-	while (l != head) {
+	while (l != NULL) {
 		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_index.o_list);
+			hlist_bl_entry(l, struct mb_cache_entry,
+				e_index.o_list);
 		if (ce->e_bdev == bdev && ce->e_index.o_key == key) {
 			DEFINE_WAIT(wait);
 
+			MB_UNLOCK_HASH_CHAIN(head);
+			spin_lock(&mb_cache_spinlock);
 			if (!list_empty(&ce->e_lru_list))
 				list_del_init(&ce->e_lru_list);
+			spin_unlock(&mb_cache_spinlock);
 
+			MB_LOCK_HASH_CHAIN(head);
 			/* Incrementing before holding the lock gives readers
 			   priority over writers. */
 			ce->e_used++;
@@ -520,18 +647,20 @@ __mb_cache_entry_find(struct list_head *l, struct list_head *head,
 				ce->e_queued++;
 				prepare_to_wait(&mb_cache_queue, &wait,
 						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
+				MB_UNLOCK_HASH_CHAIN(head);
 				schedule();
-				spin_lock(&mb_cache_spinlock);
+				MB_LOCK_HASH_CHAIN(head);
+				mb_assert(ce->e_index_hash_p == head);
 				ce->e_queued--;
 			}
 			finish_wait(&mb_cache_queue, &wait);
 
 			if (!__mb_cache_entry_is_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
-				spin_lock(&mb_cache_spinlock);
+				__mb_cache_entry_release_unlock(ce, head);
+				MB_LOCK_HASH_CHAIN(head);
 				return ERR_PTR(-EAGAIN);
 			}
+			mb_assert(ce->e_index_hash_p == head);
 			return ce;
 		}
 		l = l->next;
@@ -557,13 +686,17 @@ mb_cache_entry_find_first(struct mb_cache *cache, struct block_device *bdev,
 			  unsigned int key)
 {
 	unsigned int bucket = hash_long(key, cache->c_bucket_bits);
-	struct list_head *l;
-	struct mb_cache_entry *ce;
+	struct hlist_bl_node *l;
+	struct mb_cache_entry *ce = NULL;
+	struct hlist_bl_head *index_hash_p;
 
-	spin_lock(&mb_cache_spinlock);
-	l = cache->c_index_hash[bucket].next;
-	ce = __mb_cache_entry_find(l, &cache->c_index_hash[bucket], bdev, key);
-	spin_unlock(&mb_cache_spinlock);
+	index_hash_p = &cache->c_index_hash[bucket];
+	MB_LOCK_HASH_CHAIN(index_hash_p);
+	if (!hlist_bl_empty(index_hash_p)) {
+		l = hlist_bl_first(index_hash_p);
+		ce = __mb_cache_entry_find(l, index_hash_p, bdev, key);
+	}
+	MB_UNLOCK_HASH_CHAIN(index_hash_p);
 	return ce;
 }
 
@@ -592,13 +725,17 @@ mb_cache_entry_find_next(struct mb_cache_entry *prev,
 {
 	struct mb_cache *cache = prev->e_cache;
 	unsigned int bucket = hash_long(key, cache->c_bucket_bits);
-	struct list_head *l;
+	struct hlist_bl_node *l;
 	struct mb_cache_entry *ce;
+	struct hlist_bl_head *index_hash_p;
 
-	spin_lock(&mb_cache_spinlock);
+	index_hash_p = &cache->c_index_hash[bucket];
+	mb_assert(prev->e_index_hash_p == index_hash_p);
+	MB_LOCK_HASH_CHAIN(index_hash_p);
+	mb_assert(!hlist_bl_empty(index_hash_p));
 	l = prev->e_index.o_list.next;
-	ce = __mb_cache_entry_find(l, &cache->c_index_hash[bucket], bdev, key);
-	__mb_cache_entry_release_unlock(prev);
+	ce = __mb_cache_entry_find(l, index_hash_p, bdev, key);
+	MB_UNLOCK_HASH_CHAIN(index_hash_p);
 	return ce;
 }
 
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 5525d37..89826c0 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -11,11 +11,13 @@ struct mb_cache_entry {
 	unsigned short			e_queued;
 	struct block_device		*e_bdev;
 	sector_t			e_block;
-	struct list_head		e_block_list;
+	struct hlist_bl_node		e_block_list;
 	struct {
-		struct list_head	o_list;
+		struct hlist_bl_node	o_list;
 		unsigned int		o_key;
 	} e_index;
+	struct hlist_bl_head		*e_block_hash_p;
+	struct hlist_bl_head		*e_index_hash_p;
 };
 
 struct mb_cache {
@@ -25,8 +27,8 @@ struct mb_cache {
 	int				c_max_entries;
 	int				c_bucket_bits;
 	struct kmem_cache		*c_entry_cache;
-	struct list_head		*c_block_hash;
-	struct list_head		*c_index_hash;
+	struct hlist_bl_head		*c_block_hash;
+	struct hlist_bl_head		*c_index_hash;
 };
 
 /* Functions on caches */
-- 
1.7.11.3

