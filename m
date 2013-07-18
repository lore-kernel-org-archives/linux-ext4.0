From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH 1/2] mbcache: decoupling the locking of mb_cache local data from global data
Date: Wed, 17 Jul 2013 19:08:32 -0600
Message-ID: <1374109712-52311-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, T Makphaibulchoke <tmac@hp.com>
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tmakph@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch increases the parallelism of mb_cache_entry utilization by
introducing new spinlocks to the mb_cache structure to protect the mb_cache
local block and index hash chains, while the global mb_cache_lru_list and
mb_cache_list continue to be protected by the global mb_cache_spinlock.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/mbcache.c            | 419 +++++++++++++++++++++++++++++++++++++-----------
 include/linux/mbcache.h |   5 +
 2 files changed, 334 insertions(+), 90 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 8c32ef3..01a0c09 100644
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
 
@@ -57,6 +67,8 @@
 
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
+#define	MAX_LOCK_RETRY	2048
+
 static DECLARE_WAIT_QUEUE_HEAD(mb_cache_queue);
 		
 MODULE_AUTHOR("Andreas Gruenbacher <a.gruenbacher@computer.org>");
@@ -109,11 +121,28 @@ static void
 __mb_cache_entry_unhash(struct mb_cache_entry *ce)
 {
 	if (__mb_cache_entry_is_hashed(ce)) {
+		struct mb_cache *cache = ce->e_cache;
+		spinlock_t *key_lock = &cache->c_key_locks[ce->e_key_lock];
+
 		list_del_init(&ce->e_block_list);
+		spin_lock(key_lock);
 		list_del(&ce->e_index.o_list);
+		spin_unlock(key_lock);
 	}
 }
 
+static void
+__mb_cache_entry_unhash_lock(struct mb_cache_entry *ce)
+{
+	struct mb_cache *cache = ce->e_cache;
+	int lock_index = ce->e_bdev_lock;
+
+	spin_lock(&cache->c_bdev_locks[lock_index]);
+	mb_assert(lock_index == ce->e_bdev_lock);
+	__mb_cache_entry_unhash(ce);
+	spin_unlock(&cache->c_bdev_locks[lock_index]);
+}
+
 
 static void
 __mb_cache_entry_forget(struct mb_cache_entry *ce, gfp_t gfp_mask)
@@ -127,8 +156,9 @@ __mb_cache_entry_forget(struct mb_cache_entry *ce, gfp_t gfp_mask)
 
 
 static void
-__mb_cache_entry_release_unlock(struct mb_cache_entry *ce)
-	__releases(mb_cache_spinlock)
+__mb_cache_entry_release_unlock(struct mb_cache_entry *ce,
+		spinlock_t *hash_lock)
+	__releases(hash_lock)
 {
 	/* Wake up all processes queuing for this cache entry. */
 	if (ce->e_queued)
@@ -139,13 +169,17 @@ __mb_cache_entry_release_unlock(struct mb_cache_entry *ce)
 	if (!(ce->e_used || ce->e_queued)) {
 		if (!__mb_cache_entry_is_hashed(ce))
 			goto forget;
-		mb_assert(list_empty(&ce->e_lru_list));
-		list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
-	}
-	spin_unlock(&mb_cache_spinlock);
+		spin_unlock(hash_lock);
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&ce->e_lru_list))
+			list_add_tail(&ce->e_lru_list, &mb_cache_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+	} else
+		spin_unlock(hash_lock);
 	return;
 forget:
-	spin_unlock(&mb_cache_spinlock);
+	spin_unlock(hash_lock);
+	mb_assert(list_empty(&ce->e_lru_list));
 	__mb_cache_entry_forget(ce, GFP_KERNEL);
 }
 
@@ -164,31 +198,59 @@ forget:
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
+	while ((nr_to_scan > 0) && (max_loop-- > 0)) {
+		struct mb_cache *cache;
+		struct mb_cache_entry *ce;
+		int nloops = 0;
+		int lock_index;
+
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&mb_cache_lru_list)) {
+			spin_unlock(&mb_cache_spinlock);
+			break;
+		}
+		ce = list_entry(mb_cache_lru_list.next,
 				   struct mb_cache_entry, e_lru_list);
-		list_move_tail(&ce->e_lru_list, &free_list);
+		list_del_init(&ce->e_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+
+		cache = ce->e_cache;
+		lock_index = ce->e_bdev_lock;
+		spin_lock(&cache->c_bdev_locks[lock_index]);
+		while ((lock_index != ce->e_bdev_lock) &&
+			(nloops++ < MAX_LOCK_RETRY)) {
+			spin_unlock(&cache->c_bdev_locks[lock_index]);
+			lock_index = ce->e_bdev_lock;
+			spin_lock(&cache->c_bdev_locks[lock_index]);
+		}
+		if (nloops >= MAX_LOCK_RETRY) {
+			mb_assert(FALSE);
+			continue;
+		}
+		if (ce->e_used || ce->e_queued) {
+			spin_unlock(&cache->c_bdev_locks[lock_index]);
+			continue;
+		}
+
 		__mb_cache_entry_unhash(ce);
+		spin_unlock(&cache->c_bdev_locks[lock_index]);
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
 
@@ -209,6 +271,7 @@ mb_cache_create(const char *name, int bucket_bits)
 {
 	int n, bucket_count = 1 << bucket_bits;
 	struct mb_cache *cache = NULL;
+	int num_locks;
 
 	cache = kmalloc(sizeof(struct mb_cache), GFP_KERNEL);
 	if (!cache)
@@ -234,6 +297,28 @@ mb_cache_create(const char *name, int bucket_bits)
 	if (!cache->c_entry_cache)
 		goto fail2;
 
+	num_locks = 1 <<  (bucket_bits - 4);
+	cache->c_bdev_locks = kmalloc(num_locks * sizeof(spinlock_t),
+					GFP_KERNEL);
+	if (!cache->c_bdev_locks) {
+		kfree(cache->c_entry_cache);
+		goto fail2;
+	}
+
+	cache->c_key_locks = kmalloc(num_locks * sizeof(spinlock_t),
+					GFP_KERNEL);
+	if (!cache->c_key_locks) {
+		kfree(cache->c_bdev_locks);
+		kfree(cache->c_entry_cache);
+		goto fail2;
+	}
+
+	cache->c_lock_mask = num_locks - 1;
+	for (n = 0; n < num_locks; n++)
+		spin_lock_init(&cache->c_bdev_locks[n]);
+	for (n = 0; n < num_locks; n++)
+		spin_lock_init(&cache->c_key_locks[n]);
+
 	/*
 	 * Set an upper limit on the number of cache entries so that the hash
 	 * chains won't grow too long.
@@ -276,13 +361,36 @@ mb_cache_shrink(struct block_device *bdev)
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
+		int lock_index;
+		int nloops = 0;
+		struct mb_cache_entry *ce =
+			list_entry(l, struct mb_cache_entry, e_lru_list);
+		struct mb_cache *cache = ce->e_cache;
+
+		lock_index = ce->e_bdev_lock;
+		spin_lock(&cache->c_bdev_locks[lock_index]);
+		while ((lock_index != ce->e_bdev_lock) &&
+			(nloops++ < MAX_LOCK_RETRY)) {
+			spin_unlock(&cache->c_bdev_locks[lock_index]);
+			lock_index = ce->e_bdev_lock;
+			spin_lock(&cache->c_bdev_locks[lock_index]);
+		}
+		if (nloops > MAX_LOCK_RETRY) {
+			mb_assert(FALSE);
+			continue;
+		}
+		if (ce->e_used || ce->e_queued) {
+			spin_unlock(&cache->c_bdev_locks[lock_index]);
+			continue;
+		}
+
+		__mb_cache_entry_unhash(ce);
+		spin_unlock(&cache->c_bdev_locks[lock_index]);
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 }
 
@@ -306,15 +414,16 @@ mb_cache_destroy(struct mb_cache *cache)
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
+		__mb_cache_entry_unhash_lock(ce);
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 
 	if (atomic_read(&cache->c_entry_count) > 0) {
@@ -325,6 +434,8 @@ mb_cache_destroy(struct mb_cache *cache)
 
 	kmem_cache_destroy(cache->c_entry_cache);
 
+	kfree(cache->c_key_locks);
+	kfree(cache->c_bdev_locks);
 	kfree(cache->c_index_hash);
 	kfree(cache->c_block_hash);
 	kfree(cache);
@@ -344,26 +455,60 @@ mb_cache_entry_alloc(struct mb_cache *cache, gfp_t gfp_flags)
 	struct mb_cache_entry *ce = NULL;
 
 	if (atomic_read(&cache->c_entry_count) >= cache->c_max_entries) {
+		struct list_head *l, *ltmp;
+
+retry:
 		spin_lock(&mb_cache_spinlock);
-		if (!list_empty(&mb_cache_lru_list)) {
-			ce = list_entry(mb_cache_lru_list.next,
-					struct mb_cache_entry, e_lru_list);
-			list_del_init(&ce->e_lru_list);
-			__mb_cache_entry_unhash(ce);
+		list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
+			ce = list_entry(l, struct mb_cache_entry, e_lru_list);
+			if (ce->e_cache == cache) {
+				int lock_index = ce->e_bdev_lock;
+				spinlock_t *bdev_lock = &cache->
+					c_bdev_locks[lock_index];
+				int nloops = 0;
+
+				list_del_init(&ce->e_lru_list);
+				spin_unlock(&mb_cache_spinlock);
+				spin_lock(bdev_lock);
+				while ((lock_index != ce->e_bdev_lock) &&
+					(nloops++ < MAX_LOCK_RETRY)) {
+					spin_unlock(bdev_lock);
+					lock_index = ce->e_bdev_lock;
+					bdev_lock = &cache->
+						c_bdev_locks[lock_index];
+					spin_lock(bdev_lock);
+				}
+				if (nloops > MAX_LOCK_RETRY) {
+					mb_assert(FALSE);
+					continue;
+				}
+				if (ce->e_used || ce->e_queued) {
+					pr_warn("%s: ce %p is still being referenced..\n",
+						__func__, ce);
+					spin_unlock(bdev_lock);
+					goto retry;
+				}
+				__mb_cache_entry_unhash(ce);
+				ce->e_used = 1 + MB_CACHE_WRITER;
+				spin_unlock(bdev_lock);
+				return ce;
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
-		INIT_LIST_HEAD(&ce->e_block_list);
-		ce->e_cache = cache;
-		ce->e_queued = 0;
-	}
+
+	ce = kmem_cache_alloc(cache->c_entry_cache, gfp_flags);
+	if (!ce)
+		return NULL;
+	atomic_inc(&cache->c_entry_count);
+	INIT_LIST_HEAD(&ce->e_lru_list);
+	INIT_LIST_HEAD(&ce->e_block_list);
+	INIT_LIST_HEAD(&ce->e_index.o_list);
+	ce->e_cache = cache;
+	ce->e_queued =  0;
 	ce->e_used = 1 + MB_CACHE_WRITER;
+	ce->e_bdev_lock = 0;
+	ce->e_key_lock = 0;
 	return ce;
 }
 
@@ -390,27 +535,42 @@ mb_cache_entry_insert(struct mb_cache_entry *ce, struct block_device *bdev,
 	unsigned int bucket;
 	struct list_head *l;
 	int error = -EBUSY;
+	int lock_index;
+	spinlock_t *key_lock;
+	int key_index;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff), 
 			   cache->c_bucket_bits);
-	spin_lock(&mb_cache_spinlock);
+	lock_index = bucket & cache->c_lock_mask;
+	if ((ce->e_used != 1 + MB_CACHE_WRITER) || ce->e_queued)
+		pr_warn("%s: attempt to insert an in-used ce %p.\n",
+			__func__, ce);
+	__mb_cache_entry_unhash_lock(ce);
+
+	spin_lock(&cache->c_bdev_locks[lock_index]);
 	list_for_each_prev(l, &cache->c_block_hash[bucket]) {
 		struct mb_cache_entry *ce =
 			list_entry(l, struct mb_cache_entry, e_block_list);
-		if (ce->e_bdev == bdev && ce->e_block == block)
-			goto out;
+		if (ce->e_bdev == bdev && ce->e_block == block) {
+			spin_unlock(&cache->c_bdev_locks[lock_index]);
+			return error;
+		}
 	}
-	__mb_cache_entry_unhash(ce);
+
+	ce->e_bdev_lock = lock_index;
 	ce->e_bdev = bdev;
 	ce->e_block = block;
 	list_add(&ce->e_block_list, &cache->c_block_hash[bucket]);
 	ce->e_index.o_key = key;
 	bucket = hash_long(key, cache->c_bucket_bits);
+	key_index = bucket & cache->c_lock_mask;
+	key_lock = &cache->c_key_locks[key_index];
+	spin_lock(key_lock);
+	ce->e_key_lock = key_index;
 	list_add(&ce->e_index.o_list, &cache->c_index_hash[bucket]);
-	error = 0;
-out:
-	spin_unlock(&mb_cache_spinlock);
-	return error;
+	spin_unlock(key_lock);
+	spin_unlock(&cache->c_bdev_locks[lock_index]);
+	return 0;
 }
 
 
@@ -424,8 +584,14 @@ out:
 void
 mb_cache_entry_release(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
-	__mb_cache_entry_release_unlock(ce);
+	struct mb_cache *cache = ce->e_cache;
+	spinlock_t *hash_lock;
+	int lock_index = ce->e_bdev_lock;
+
+	hash_lock = &cache->c_bdev_locks[lock_index];
+	spin_lock(hash_lock);
+	mb_assert(lock_index == ce->e_bdev_lock);
+	__mb_cache_entry_release_unlock(ce, hash_lock);
 }
 
 
@@ -438,10 +604,21 @@ mb_cache_entry_release(struct mb_cache_entry *ce)
 void
 mb_cache_entry_free(struct mb_cache_entry *ce)
 {
-	spin_lock(&mb_cache_spinlock);
+	struct mb_cache *cache = ce->e_cache;
+	spinlock_t *hash_lock;
+	int lock_index = ce->e_bdev_lock;
+
+	if (!list_empty(&ce->e_lru_list)) {
+		pr_warn("%s: attempt to free ce %p still in-used.\n",
+			__func__, ce);
+		return;
+	}
 	mb_assert(list_empty(&ce->e_lru_list));
+	hash_lock = &cache->c_bdev_locks[lock_index];
+	spin_lock(hash_lock);
+	mb_assert(lock_index == ce->e_bdev_lock);
 	__mb_cache_entry_unhash(ce);
-	__mb_cache_entry_release_unlock(ce);
+	__mb_cache_entry_release_unlock(ce, hash_lock);
 }
 
 
@@ -460,32 +637,43 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 	unsigned int bucket;
 	struct list_head *l;
 	struct mb_cache_entry *ce;
+	spinlock_t *hash_lock;
+	int hash_index;
+	int lock_index;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff),
 			   cache->c_bucket_bits);
-	spin_lock(&mb_cache_spinlock);
+	hash_index = bucket & cache->c_lock_mask;
+	hash_lock = &cache->c_bdev_locks[hash_index];
+	spin_lock(hash_lock);
 	list_for_each(l, &cache->c_block_hash[bucket]) {
 		ce = list_entry(l, struct mb_cache_entry, e_block_list);
+		mb_assert(hash_index == ce->e_bdev_lock);
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
+				lock_index = ce->e_bdev_lock;
+				spin_unlock(hash_lock);
 				schedule();
-				spin_lock(&mb_cache_spinlock);
-				ce->e_queued--;
+				spin_lock(hash_lock);
+				mb_assert(lock_index == ce->e_bdev_lock);
+				ce->e_queued++;
 			}
 			finish_wait(&mb_cache_queue, &wait);
 			ce->e_used += 1 + MB_CACHE_WRITER;
 
 			if (!__mb_cache_entry_is_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
+				mb_assert(hash_index == ce->e_bdev_lock);
+				__mb_cache_entry_release_unlock(ce, hash_lock);
 				return NULL;
 			}
 			goto cleanup;
@@ -494,47 +682,76 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 	ce = NULL;
 
 cleanup:
-	spin_unlock(&mb_cache_spinlock);
+	spin_unlock(hash_lock);
 	return ce;
 }
 
 #if !defined(MB_CACHE_INDEXES_COUNT) || (MB_CACHE_INDEXES_COUNT > 0)
 
 static struct mb_cache_entry *
-__mb_cache_entry_find(struct list_head *l, struct list_head *head,
-		      struct block_device *bdev, unsigned int key)
+__mb_cache_entry_find_unlock(struct list_head *l, struct list_head *head,
+	struct block_device *bdev, unsigned int key, int lock_index)
 {
+	struct mb_cache_entry *ce;
+	struct mb_cache *cache;
+	spinlock_t *key_lock;
+	int found = 0;
+
+	mb_assert(l != head);
+	if (l == head)
+		return NULL;
+
+	ce = list_entry(l, struct mb_cache_entry, e_index.o_list);
+	cache = ce->e_cache;
+	mb_assert((lock_index >= 0) && (lock_index <= cache->c_lock_mask));
+	key_lock = &cache->c_key_locks[lock_index];
+
 	while (l != head) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_index.o_list);
+		ce = list_entry(l, struct mb_cache_entry, e_index.o_list);
+		mb_assert(lock_index == ce->e_key_lock);
 		if (ce->e_bdev == bdev && ce->e_index.o_key == key) {
-			DEFINE_WAIT(wait);
+			found = 1;
+			break;
+		}
+		l = l->next;
+	}
+	spin_unlock(key_lock);
 
-			if (!list_empty(&ce->e_lru_list))
-				list_del_init(&ce->e_lru_list);
+	if (found) {
+		int hash_index;
+		spinlock_t *hash_lock;
+		DEFINE_WAIT(wait);
 
-			/* Incrementing before holding the lock gives readers
-			   priority over writers. */
-			ce->e_used++;
-			while (ce->e_used >= MB_CACHE_WRITER) {
-				ce->e_queued++;
-				prepare_to_wait(&mb_cache_queue, &wait,
-						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
-				schedule();
-				spin_lock(&mb_cache_spinlock);
-				ce->e_queued--;
-			}
-			finish_wait(&mb_cache_queue, &wait);
+		hash_index = ce->e_bdev_lock;
+		hash_lock = &cache->c_bdev_locks[hash_index];
 
-			if (!__mb_cache_entry_is_hashed(ce)) {
-				__mb_cache_entry_release_unlock(ce);
-				spin_lock(&mb_cache_spinlock);
-				return ERR_PTR(-EAGAIN);
-			}
-			return ce;
+		spin_lock(&mb_cache_spinlock);
+		if (!list_empty(&ce->e_lru_list))
+			list_del_init(&ce->e_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+
+		spin_lock(hash_lock);
+		/* Incrementing before holding the lock gives readers
+		   priority over writers. */
+		ce->e_used++;
+		while (ce->e_used >= MB_CACHE_WRITER) {
+			ce->e_queued++;
+			prepare_to_wait(&mb_cache_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock(hash_lock);
+			schedule();
+			spin_lock(hash_lock);
+			mb_assert(hash_index == ce->e_bdev_lock);
+			ce->e_queued++;
 		}
-		l = l->next;
+		finish_wait(&mb_cache_queue, &wait);
+
+		if (!__mb_cache_entry_is_hashed(ce)) {
+			__mb_cache_entry_release_unlock(ce, hash_lock);
+			return ERR_PTR(-EAGAIN);
+		}
+		spin_unlock(hash_lock);
+		return ce;
 	}
 	return NULL;
 }
@@ -559,11 +776,18 @@ mb_cache_entry_find_first(struct mb_cache *cache, struct block_device *bdev,
 	unsigned int bucket = hash_long(key, cache->c_bucket_bits);
 	struct list_head *l;
 	struct mb_cache_entry *ce;
+	int lock_index = bucket & cache->c_lock_mask;
+	spinlock_t *key_lock = &cache->c_key_locks[lock_index];
 
-	spin_lock(&mb_cache_spinlock);
+	spin_lock(key_lock);
 	l = cache->c_index_hash[bucket].next;
-	ce = __mb_cache_entry_find(l, &cache->c_index_hash[bucket], bdev, key);
-	spin_unlock(&mb_cache_spinlock);
+	if (l == &cache->c_index_hash[bucket]) {
+		spin_unlock(key_lock);
+		return NULL;
+	}
+	ce = __mb_cache_entry_find_unlock(l, &cache->c_index_hash[bucket],
+		bdev, key, lock_index);
+	mb_assert(!ce || (lock_index == ce->e_key_lock));
 	return ce;
 }
 
@@ -593,12 +817,27 @@ mb_cache_entry_find_next(struct mb_cache_entry *prev,
 	struct mb_cache *cache = prev->e_cache;
 	unsigned int bucket = hash_long(key, cache->c_bucket_bits);
 	struct list_head *l;
-	struct mb_cache_entry *ce;
+	struct mb_cache_entry *ce = NULL;
+	int lock_index = bucket & cache->c_lock_mask;
+	spinlock_t *lock;
 
-	spin_lock(&mb_cache_spinlock);
+	lock = &cache->c_key_locks[lock_index];
+	spin_lock(lock);
+	mb_assert(lock_index == prev->e_key_lock);
 	l = prev->e_index.o_list.next;
-	ce = __mb_cache_entry_find(l, &cache->c_index_hash[bucket], bdev, key);
-	__mb_cache_entry_release_unlock(prev);
+	if (l == &cache->c_index_hash[bucket])
+		spin_unlock(lock);
+	else {
+		ce = __mb_cache_entry_find_unlock(l, &cache->
+			c_index_hash[bucket], bdev, key, lock_index);
+		mb_assert(!ce || (lock_index == ce->e_key_lock));
+	}
+
+	lock_index = prev->e_bdev_lock;
+	lock = &cache->c_bdev_locks[lock_index];
+	spin_lock(lock);
+	mb_assert(lock_index == prev->e_bdev_lock);
+	__mb_cache_entry_release_unlock(prev, lock);
 	return ce;
 }
 
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 5525d37..68d8409 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -9,6 +9,8 @@ struct mb_cache_entry {
 	struct mb_cache			*e_cache;
 	unsigned short			e_used;
 	unsigned short			e_queued;
+	unsigned int			e_bdev_lock;
+	unsigned int			e_key_lock;
 	struct block_device		*e_bdev;
 	sector_t			e_block;
 	struct list_head		e_block_list;
@@ -27,6 +29,9 @@ struct mb_cache {
 	struct kmem_cache		*c_entry_cache;
 	struct list_head		*c_block_hash;
 	struct list_head		*c_index_hash;
+	spinlock_t			*c_bdev_locks;
+	spinlock_t			*c_key_locks;
+	unsigned int			c_lock_mask;
 };
 
 /* Functions on caches */
-- 
1.7.11.3
