From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4/5] mbcache: use consistent type for entry count
Date: Sat, 26 Nov 2016 22:18:00 -0800
Message-ID: <1480227481-98535-4-git-send-email-ebiggers@google.com>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:36663 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbcK0GSd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:18:33 -0500
Received: by mail-pg0-f51.google.com with SMTP id f188so44199594pgc.3
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:18:31 -0800 (PST)
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mbcache used several different types to represent the number of entries
in the cache.  For consistency within mbcache and with the shrinker API,
always use unsigned long.

This does not change behavior for current mbcache users (ext2 and ext4)
since they limit the entry count to a value which easily fits in an int.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 07c5d7d..bf65906 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -29,7 +29,7 @@ struct mb_cache {
 	/* log2 of hash table size */
 	int			c_bucket_bits;
 	/* Maximum entries in cache to avoid degrading hash too much */
-	int			c_max_entries;
+	unsigned long		c_max_entries;
 	/* Protects c_list, c_entry_count */
 	spinlock_t		c_list_lock;
 	struct list_head	c_list;
@@ -43,7 +43,7 @@ struct mb_cache {
 static struct kmem_cache *mb_entry_cache;
 
 static unsigned long mb_cache_shrink(struct mb_cache *cache,
-				     unsigned int nr_to_scan);
+				     unsigned long nr_to_scan);
 
 static inline struct hlist_bl_head *mb_cache_entry_head(struct mb_cache *cache,
 							u32 key)
@@ -274,11 +274,11 @@ static unsigned long mb_cache_count(struct shrinker *shrink,
 
 /* Shrink number of entries in cache */
 static unsigned long mb_cache_shrink(struct mb_cache *cache,
-				     unsigned int nr_to_scan)
+				     unsigned long nr_to_scan)
 {
 	struct mb_cache_entry *entry;
 	struct hlist_bl_head *head;
-	unsigned int shrunk = 0;
+	unsigned long shrunk = 0;
 
 	spin_lock(&cache->c_list_lock);
 	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
@@ -316,10 +316,9 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 static unsigned long mb_cache_scan(struct shrinker *shrink,
 				   struct shrink_control *sc)
 {
-	int nr_to_scan = sc->nr_to_scan;
 	struct mb_cache *cache = container_of(shrink, struct mb_cache,
 					      c_shrink);
-	return mb_cache_shrink(cache, nr_to_scan);
+	return mb_cache_shrink(cache, sc->nr_to_scan);
 }
 
 /* We shrink 1/X of the cache when we have too many entries in it */
@@ -341,8 +340,8 @@ static void mb_cache_shrink_worker(struct work_struct *work)
 struct mb_cache *mb_cache_create(int bucket_bits)
 {
 	struct mb_cache *cache;
-	int bucket_count = 1 << bucket_bits;
-	int i;
+	unsigned long bucket_count = 1UL << bucket_bits;
+	unsigned long i;
 
 	cache = kzalloc(sizeof(struct mb_cache), GFP_KERNEL);
 	if (!cache)
-- 
2.8.0.rc3.226.g39d4020

