From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH v4 2/3] mbcache: decoupling the locking of local from global data
Date: Fri, 24 Jan 2014 11:31:27 -0700
Message-ID: <1390588288-66930-3-git-send-email-tmac@hp.com>
References: <1377186876-57291-1-git-send-email-tmac@hp.com>
 <1390588288-66930-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, T Makphaibulchoke <tmac@hp.com>
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390588288-66930-1-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch increases the parallelism of mb_cache_entry utilization by
replacing list_head with hlist_bl_node for the implementation of both the
block and index hash tables.  Each hlist_bl_node contains a built-in lock
used to protect mb_cache's local block and index hash chains. The global
data mb_cache_lru_list and mb_cache_list continue to be protected by the
global mb_cache_spinlock.

A new spinlock is also added to the mb_cache_entry to protect its local data,
e_used and e_queued.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/mbcache.c | 363 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 260 insertions(+), 103 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 55db0da..0c4cec2 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -26,6 +26,40 @@
  * back on the lru list.
  */
 
+/*
+ * Lock descriptions and usage:
+ *
+ * Each hash chain of both the block and index hash tables now contains
+ * a built-in lock used to serialize accesses to the hash chain.
+ *
+ * Accesses to global data structures mb_cache_list and mb_cache_lru_list
+ * are serialized via the global spinlock mb_cache_spinlock.
+ *
+ * Each mb_cache_entry contains a spinlock, e_entry_lock, to serialize
+ * accesses to its local data, such as e_used and e_queued.
+ *
+ * Lock ordering:
+ *
+ * mb_cache_spinlock has the lock highest order, followed by each block and
+ * index hash chain's lock, with e_entry_lock the lowest.  While holding
+ * mb_cache_spinlock, a thread can acquire either a block and/or index hash
+ * chain lock, and in turn can also acquire each entry spinlock, e_entry_lock.
+ *
+ * Synchronization:
+ *
+ * Since both mb_cache_entry_get and mb_cache_entry_find scan the block and
+ * index hash chian, it needs to lock the corresponding hash chain.  For each
+ * mb_cache_entry within the chain, it needs to lock the mb_cache_entry to
+ * prevent either any simultaneous release or free on the entry and also
+ * to serialize accesses to either the e_used or e_queued member of the entry.
+ *
+ * To avoid having a dangling reference to an already freed
+ * mb_cache_entry, an mb_cache_entry is only freed when it is not on a
+ * block hash chain and also no longer being referenced, both e_used,
+ * and e_queued are 0's.  When an mb_cache_entry is explicitly freed it is
+ * first removed from a block hash chain.
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -113,11 +147,21 @@ __mb_cache_entry_unhash_index(struct mb_cache_entry *ce)
 		hlist_bl_del_init(&ce->e_index.o_list);
 }
 
+/*
+ * __mb_cache_entry_unhash_unlock()
+ *
+ * This function is called to unhash both the block and index hash
+ * chain.
+ * It assumes both the block and index hash chain is locked upon entry.
+ * It also unlock both hash chains both exit
+ */
 static inline void
-__mb_cache_entry_unhash(struct mb_cache_entry *ce)
+__mb_cache_entry_unhash_unlock(struct mb_cache_entry *ce)
 {
 	__mb_cache_entry_unhash_index(ce);
+	hlist_bl_unlock(ce->e_index_hash_p);
 	__mb_cache_entry_unhash_block(ce);
+	hlist_bl_unlock(ce->e_block_hash_p);
 }
 
 static void
@@ -130,31 +174,42 @@ __mb_cache_entry_forget(struct mb_cache_entry *ce, gfp_t gfp_mask)
 	atomic_dec(&cache->c_entry_count);
 }
 
-
 static void
-__mb_cache_entry_release_unlock(struct mb_cache_entry *ce)
-	__releases(mb_cache_spinlock)
+__mb_cache_entry_release(struct mb_cache_entry *ce)
 {
+	/* First lock the entry to serialize access to its local data. */
+	spin_lock(&ce->e_entry_lock);
 	/* Wake up all processes queuing for this cache entry. */
 	if (ce->e_queued)
 		wake_up_all(&mb_cache_queue);
 	if (ce->e_used >= MB_CACHE_WRITER)
 		ce->e_used -= MB_CACHE_WRITER;
+	/*
+	 * Make sure that all cache entries on lru_list have
+	 * both e_used and e_qued of 0s.
+	 */
 	ce->e_used--;
 	if (!(ce->e_used || ce->e_queued)) {
-		if (!__mb_cache_entry_is_block_hashed(ce))
+		if (!__mb_cache_entry_is_block_hashed(ce)) {
+			spin_unlock(&ce->e_entry_lock);
 			goto forget;
-		mb_assert(list_empty(&ce->e_lru_list));
-		list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+		}
+		/*
+		 * Need access to lru list, first drop entry lock,
+		 * then reacquire the lock in the proper order.
+		 */
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&ce->e_lru_list))
+			list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+		spin_unlock(&mb_cache_spinlock);
 	}
-	spin_unlock(&mb_cache_spinlock);
+	spin_unlock(&ce->e_entry_lock);
 	return;
 forget:
-	spin_unlock(&mb_cache_spinlock);
+	mb_assert(list_empty(&ce->e_lru_list));
 	__mb_cache_entry_forget(ce, GFP_KERNEL);
 }
 
-
 /*
  * mb_cache_shrink_scan()  memory pressure callback
  *
@@ -177,17 +232,32 @@ mb_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 
 	mb_debug("trying to free %d entries", nr_to_scan);
 	spin_lock(&mb_cache_spinlock);
-	while (nr_to_scan-- && !list_empty(&mb_cache_lru_list)) {
+	while ((nr_to_scan-- > 0) && !list_empty(&mb_cache_lru_list)) {
 		struct mb_cache_entry *ce =
 			list_entry(mb_cache_lru_list.next,
-				   struct mb_cache_entry, e_lru_list);
-		list_move_tail(&ce->e_lru_list, &free_list);
-		__mb_cache_entry_unhash(ce);
-		freed++;
+				struct mb_cache_entry, e_lru_list);
+		list_del_init(&ce->e_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+		/* Prevent any find or get operation on the entry */
+		hlist_bl_lock(ce->e_block_hash_p);
+		hlist_bl_lock(ce->e_index_hash_p);
+		/* Ignore if it is touched by a find/get */
+		if (ce->e_used || ce->e_queued ||
+			!list_empty(&ce->e_lru_list)) {
+			hlist_bl_unlock(ce->e_index_hash_p);
+			hlist_bl_unlock(ce->e_block_hash_p);
+			spin_lock(&mb_cache_spinlock);
+			continue;
+		}
+		__mb_cache_entry_unhash_unlock(ce);
+		list_add_tail(&ce->e_lru_list, &free_list);
+		spin_lock(&mb_cache_spinlock);
 	}
 	spin_unlock(&mb_cache_spinlock);
+
 	list_for_each_entry_safe(entry, tmp, &free_list, e_lru_list) {
 		__mb_cache_entry_forget(entry, gfp_mask);
+		freed++;
 	}
 	return freed;
 }
@@ -290,21 +360,41 @@ void
 mb_cache_shrink(struct block_device *bdev)
 {
 	LIST_HEAD(free_list);
-	struct list_head *l, *ltmp;
+	struct list_head *l;
+	struct mb_cache_entry *ce, *tmp;
 
+	l = &mb_cache_lru_list;
 	spin_lock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_lru_list);
+	while (!list_is_last(l, &mb_cache_lru_list)) {
+		l = l->next;
+		ce = list_entry(l, struct mb_cache_entry, e_lru_list);
 		if (ce->e_bdev == bdev) {
-			list_move_tail(&ce->e_lru_list, &free_list);
-			__mb_cache_entry_unhash(ce);
+			list_del_init(&ce->e_lru_list);
+			spin_unlock(&mb_cache_spinlock);
+			/*
+			 * Prevent any find or get operation on the entry.
+			 */
+			hlist_bl_lock(ce->e_block_hash_p);
+			hlist_bl_lock(ce->e_index_hash_p);
+			/* Ignore if it is touched by a find/get */
+			if (ce->e_used || ce->e_queued ||
+				!list_empty(&ce->e_lru_list)) {
+				hlist_bl_unlock(ce->e_index_hash_p);
+				hlist_bl_unlock(ce->e_block_hash_p);
+				l = &mb_cache_lru_list;
+				spin_lock(&mb_cache_spinlock);
+				continue;
+			}
+			__mb_cache_entry_unhash_unlock(ce);
+			list_add_tail(&ce->e_lru_list, &free_list);
+			l = &mb_cache_lru_list;
+			spin_lock(&mb_cache_spinlock);
 		}
 	}
 	spin_unlock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+
+	list_for_each_entry_safe(ce, tmp, &free_list, e_lru_list) {
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 }
 
@@ -320,23 +410,26 @@ void
 mb_cache_destroy(struct mb_cache *cache)
 {
 	LIST_HEAD(free_list);
-	struct list_head *l, *ltmp;
+	struct mb_cache_entry *ce, *tmp;
 
 	spin_lock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_lru_list);
-		if (ce->e_cache == cache) {
+	list_for_each_entry_safe(ce, tmp, &mb_cache_lru_list, e_lru_list) {
+		if (ce->e_cache == cache)
 			list_move_tail(&ce->e_lru_list, &free_list);
-			__mb_cache_entry_unhash(ce);
-		}
 	}
 	list_del(&cache->c_cache_list);
 	spin_unlock(&mb_cache_spinlock);
 
-	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+	list_for_each_entry_safe(ce, tmp, &free_list, e_lru_list) {
+		list_del_init(&ce->e_lru_list);
+		/*
+		 * Prevent any find or get operation on the entry.
+		 */
+		hlist_bl_lock(ce->e_block_hash_p);
+		hlist_bl_lock(ce->e_index_hash_p);
+		mb_assert(!(ce->e_used || ce->e_queued));
+		__mb_cache_entry_unhash_unlock(ce);
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 
 	if (atomic_read(&cache->c_entry_count) > 0) {
@@ -363,31 +456,56 @@ mb_cache_destroy(struct mb_cache *cache)
 struct mb_cache_entry *
 mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 {
-	struct mb_cache_entry *ce = NULL;
+	struct mb_cache_entry *ce;
 
 	if (atomic_read(&cache->c_entry_count) >= cache->c_max_entries) {
+		struct list_head *l;
+
+		l = &mb_cache_lru_list;
 		spin_lock(&mb_cache_spinlock);
-		if (!list_empty(&mb_cache_lru_list)) {
-			ce = list_entry(mb_cache_lru_list.next,
-					struct mb_cache_entry, e_lru_list);
-			list_del_init(&ce->e_lru_list);
-			__mb_cache_entry_unhash(ce);
+		while (!list_is_last(l, &mb_cache_lru_list)) {
+			l = l->next;
+			ce = list_entry(l, struct mb_cache_entry, e_lru_list);
+			if (ce->e_cache == cache) {
+				list_del_init(&ce->e_lru_list);
+				spin_unlock(&mb_cache_spinlock);
+				/*
+				 * Prevent any find or get operation on the
+				 * entry.
+				 */
+				hlist_bl_lock(ce->e_block_hash_p);
+				hlist_bl_lock(ce->e_index_hash_p);
+				/* Ignore if it is touched by a find/get */
+				if (ce->e_used || ce->e_queued ||
+					!list_empty(&ce->e_lru_list)) {
+					hlist_bl_unlock(ce->e_index_hash_p);
+					hlist_bl_unlock(ce->e_block_hash_p);
+					l = &mb_cache_lru_list;
+					spin_lock(&mb_cache_spinlock);
+					continue;
+				}
+				mb_assert(list_empty(&ce->e_lru_list));
+				mb_assert(!(ce->e_used || ce->e_queued));
+				__mb_cache_entry_unhash_unlock(ce);
+				goto found;
+			}
 		}
 		spin_unlock(&mb_cache_spinlock);
 	}
-	if (!ce) {
-		ce = kmem_cache_alloc(cache->c_entry_cache, gfp_flags);
-		if (!ce)
-			return NULL;
-		atomic_inc(&cache->c_entry_count);
-		INIT_LIST_HEAD(&ce->e_lru_list);
-		INIT_HLIST_BL_NODE(&ce->e_block_list);
-		INIT_HLIST_BL_NODE(&ce->e_index.o_list);
-		ce->e_cache = cache;
-		ce->e_queued = 0;
-	}
+
+	ce = kmem_cache_alloc(cache->c_entry_cache, gfp_flags);
+	if (!ce)
+		return NULL;
+	atomic_inc(&cache->c_entry_count);
+	INIT_LIST_HEAD(&ce->e_lru_list);
+	INIT_HLIST_BL_NODE(&ce->e_block_list);
+	INIT_HLIST_BL_NODE(&ce->e_index.o_list);
+	ce->e_cache = cache;
+	ce->e_queued = 0;
+found:
 	ce->e_block_hash_p = &cache->c_block_hash[0];
 	ce->e_index_hash_p = &cache->c_index_hash[0];
+	spin_lock_init(&ce->e_entry_lock);
 	ce->e_used = 1 + MB_CACHE_WRITER;
 	return ce;
 }
@@ -423,25 +541,28 @@ mb_cache_entry_insert(struct mb_cache_entry *ce, struct block_device *bdev,
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff), 
 			   cache->c_bucket_bits);
 	block_hash_p = &cache->c_block_hash[bucket];
-	spin_lock(&mb_cache_spinlock);
+	hlist_bl_lock(block_hash_p);
 	hlist_bl_for_each_entry(lce, l, block_hash_p, e_block_list) {
 		if (lce->e_bdev == bdev && lce->e_block == block)
 			goto out;
 	}
 	mb_assert(!__mb_cache_entry_is_block_hashed(ce));
-	__mb_cache_entry_unhash(ce);
+	__mb_cache_entry_unhash_block(ce);
+	__mb_cache_entry_unhash_index(ce);
 	ce->e_bdev = bdev;
 	ce->e_block = block;
 	ce->e_block_hash_p = block_hash_p;
 	ce->e_index.o_key = key;
 	bucket = hash_long(key, cache->c_bucket_bits);
 	index_hash_p = &cache->c_index_hash[bucket];
+	hlist_bl_lock(index_hash_p);
 	ce->e_index_hash_p = index_hash_p;
 	hlist_bl_add_head(&ce->e_index.o_list, index_hash_p);
 	hlist_bl_add_head(&ce->e_block_list, block_hash_p);
+	hlist_bl_unlock(index_hash_p);
 	error = 0;
 out:
-	spin_unlock(&mb_cache_spinlock);
+	hlist_bl_unlock(block_hash_p);
 	return error;
 }
 
@@ -456,24 +577,26 @@ out:
 void
 mb_cache_entry_release(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
-	__mb_cache_entry_release_unlock(ce);
+	__mb_cache_entry_release(ce);
 }
 
 
 /*
  * mb_cache_entry_free()
  *
- * This is equivalent to the sequence mb_cache_entry_takeout() --
- * mb_cache_entry_release().
  */
 void
 mb_cache_entry_free(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
+	mb_assert(ce);
 	mb_assert(list_empty(&ce->e_lru_list));
-	__mb_cache_entry_unhash(ce);
-	__mb_cache_entry_release_unlock(ce);
+	hlist_bl_lock(ce->e_index_hash_p);
+	__mb_cache_entry_unhash_index(ce);
+	hlist_bl_unlock(ce->e_index_hash_p);
+	hlist_bl_lock(ce->e_block_hash_p);
+	__mb_cache_entry_unhash_block(ce);
+	hlist_bl_unlock(ce->e_block_hash_p);
+	__mb_cache_entry_release(ce);
 }
 
 
@@ -493,43 +616,58 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 	struct hlist_bl_node *l;
 	struct mb_cache_entry *ce;
 	struct hlist_bl_head *block_hash_p;
+	int held_lock = 1;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff),
 			   cache->c_bucket_bits);
 	block_hash_p = &cache->c_block_hash[bucket];
-	spin_lock(&mb_cache_spinlock);
+	/* First serialize access to the block corresponding hash chain. */
+	hlist_bl_lock(block_hash_p);
 	hlist_bl_for_each_entry(ce, l, block_hash_p, e_block_list) {
 		mb_assert(ce->e_block_hash_p == block_hash_p);
 		if (ce->e_bdev == bdev && ce->e_block == block) {
-			DEFINE_WAIT(wait);
-
-			if (!list_empty(&ce->e_lru_list))
+			/*
+			 * Prevent a release on the entry.
+			 */
+			spin_lock(&ce->e_entry_lock);
+			if (!list_empty(&ce->e_lru_list)) {
+				spin_lock(&mb_cache_spinlock);
 				list_del_init(&ce->e_lru_list);
-
-			while (ce->e_used > 0) {
-				ce->e_queued++;
-				prepare_to_wait(&mb_cache_queue, &wait,
-						TASK_UNINTERRUPTIBLE);
 				spin_unlock(&mb_cache_spinlock);
-				schedule();
-				spin_lock(&mb_cache_spinlock);
-				ce->e_queued--;
 			}
-			finish_wait(&mb_cache_queue, &wait);
+			if (ce->e_used > 0) {
+				DEFINE_WAIT(wait);
+				while (ce->e_used > 0) {
+					ce->e_queued++;
+					prepare_to_wait(&mb_cache_queue, &wait,
+							TASK_UNINTERRUPTIBLE);
+					spin_unlock(&ce->e_entry_lock);
+					if (held_lock) {
+						hlist_bl_unlock(block_hash_p);
+						held_lock = 0;
+					}
+					schedule();
+					spin_lock(&ce->e_entry_lock);
+					ce->e_queued--;
+				}
+				finish_wait(&mb_cache_queue, &wait);
+			}
 			ce->e_used += 1 + MB_CACHE_WRITER;
+			spin_unlock(&ce->e_entry_lock);
 
 			if (!__mb_cache_entry_is_block_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
+				if (held_lock)
+					hlist_bl_unlock(block_hash_p);
+				__mb_cache_entry_release(ce);
 				return NULL;
 			}
-			goto cleanup;
+			if (held_lock)
+				hlist_bl_unlock(block_hash_p);
+			return ce;
 		}
 	}
-	ce = NULL;
-
-cleanup:
-	spin_unlock(&mb_cache_spinlock);
-	return ce;
+	hlist_bl_unlock(block_hash_p);
+	return NULL;
 }
 
 #if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
@@ -538,40 +676,59 @@ static struct mb_cache_entry *
 __mb_cache_entry_find(struct hlist_bl_node *l, struct hlist_bl_head *head,
 		      struct block_device *bdev, unsigned int key)
 {
+	int held_lock = 1;
+
+	/* The index hash chain is alredy acquire by caller. */
 	while (l != NULL) {
 		struct mb_cache_entry *ce =
 			hlist_bl_entry(l, struct mb_cache_entry,
 				e_index.o_list);
 		mb_assert(ce->e_index_hash_p == head);
 		if (ce->e_bdev == bdev && ce->e_index.o_key == key) {
-			DEFINE_WAIT(wait);
-
-			if (!list_empty(&ce->e_lru_list))
+			/*
+			 * Prevent a release on the entry.
+			 */
+			spin_lock(&ce->e_entry_lock);
+			if (!list_empty(&ce->e_lru_list)) {
+				spin_lock(&mb_cache_spinlock);
 				list_del_init(&ce->e_lru_list);
-
+				spin_unlock(&mb_cache_spinlock);
+			}
+			ce->e_used++;
 			/* Incrementing before holding the lock gives readers
 			   priority over writers. */
-			ce->e_used++;
-			while (ce->e_used >= MB_CACHE_WRITER) {
-				ce->e_queued++;
-				prepare_to_wait(&mb_cache_queue, &wait,
-						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
-				schedule();
-				spin_lock(&mb_cache_spinlock);
-				ce->e_queued--;
+			if (ce->e_used >= MB_CACHE_WRITER) {
+				DEFINE_WAIT(wait);
+
+				while (ce->e_used >= MB_CACHE_WRITER) {
+					ce->e_queued++;
+					prepare_to_wait(&mb_cache_queue, &wait,
+							TASK_UNINTERRUPTIBLE);
+					spin_unlock(&ce->e_entry_lock);
+					if (held_lock) {
+						hlist_bl_unlock(head);
+						held_lock = 0;
+					}
+					schedule();
+					spin_lock(&ce->e_entry_lock);
+					ce->e_queued--;
+				}
+				finish_wait(&mb_cache_queue, &wait);
 			}
-			finish_wait(&mb_cache_queue, &wait);
-
+			spin_unlock(&ce->e_entry_lock);
 			if (!__mb_cache_entry_is_block_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
-				spin_lock(&mb_cache_spinlock);
+				if (held_lock)
+					hlist_bl_unlock(head);
+				__mb_cache_entry_release(ce);
 				return ERR_PTR(-EAGAIN);
 			}
+			if (held_lock)
+				hlist_bl_unlock(head);
 			return ce;
 		}
 		l = l->next;
 	}
+	hlist_bl_unlock(head);
 	return NULL;
 }
 
@@ -598,12 +755,12 @@ mb_cache_entry_find_first(struct mb_cache *cache, struct block_device *bdev,
 	struct hlist_bl_head *index_hash_p;
 
 	index_hash_p = &cache->c_index_hash[bucket];
-	spin_lock(&mb_cache_spinlock);
+	hlist_bl_lock(index_hash_p);
 	if (!hlist_bl_empty(index_hash_p)) {
 		l = hlist_bl_first(index_hash_p);
 		ce = __mb_cache_entry_find(l, index_hash_p, bdev, key);
-	}
-	spin_unlock(&mb_cache_spinlock);
+	} else
+		hlist_bl_unlock(index_hash_p);
 	return ce;
 }
 
@@ -638,11 +795,11 @@ mb_cache_entry_find_next(struct mb_cache_entry *prev,
 
 	index_hash_p = &cache->c_index_hash[bucket];
 	mb_assert(prev->e_index_hash_p == index_hash_p);
-	spin_lock(&mb_cache_spinlock);
+	hlist_bl_lock(index_hash_p);
 	mb_assert(!hlist_bl_empty(index_hash_p));
 	l = prev->e_index.o_list.next;
 	ce = __mb_cache_entry_find(l, index_hash_p, bdev, key);
-	__mb_cache_entry_release_unlock(prev);
+	__mb_cache_entry_release(prev);
 	return ce;
 }
 
-- 
1.7.11.3
