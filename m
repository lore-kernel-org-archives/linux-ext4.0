From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/2] ext4: each filesystem creates and uses its own
 mb_cache
Date: Wed, 30 Oct 2013 10:30:24 -0400
Message-ID: <20131030143024.GB3305@thunk.org>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
 <1378312756-68597-3-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com,
	torvalds@linux-foundation.org, aswin_proj@groups.hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1378312756-68597-3-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 04, 2013 at 10:39:16AM -0600, T Makphaibulchoke wrote:
> This patch adds new interfaces to create and destory cache,
> ext4_xattr_create_cache() and ext4_xattr_destroy_cache(), and remove the
> cache creation and destory calls from ex4_init_xattr() and ext4_exitxattr()
> in fs/ext4/xattr.c.
> fs/ext4/super.c has been changed so that when a filesystem is mounted a
> cache is allocated and attched to its ext4_sb_info structure.

One problem with this patch is that it creates separate slabs for each
ext4 file system where previously we had a single slab cache for
mbcache entries.  I've tried adding the following patch on top of
yours so that we can retain the previous behavior of creating a single
kmem_cache for all ext4 file systems.

Please comment/review...

							- Ted

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3b525b6..d529807 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -31,6 +31,7 @@
 #include <linux/vfs.h>
 #include <linux/random.h>
 #include <linux/mount.h>
+#include <linux/mbcache.h>
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
@@ -5492,9 +5493,16 @@ static int __init ext4_init_fs(void)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
+	ext4_xattr_kmem_cache = kmem_cache_create("ext4_xattr",
+		sizeof(struct mb_cache_entry), 0,
+		SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
+	if (ext4_xattr_kmem_cache == NULL)
+		return -ENOMEM;
+
+
 	err = ext4_init_es();
 	if (err)
-		return err;
+		goto out8;
 
 	err = ext4_init_pageio();
 	if (err)
@@ -5548,12 +5556,15 @@ out6:
 	ext4_exit_pageio();
 out7:
 	ext4_exit_es();
+out8:
+	kmem_cache_destroy(ext4_xattr_kmem_cache);
 
 	return err;
 }
 
 static void __exit ext4_exit_fs(void)
 {
+	kmem_cache_destroy(ext4_xattr_kmem_cache);
 	ext4_destroy_lazyinit_thread();
 	unregister_as_ext2();
 	unregister_as_ext3();
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 07ca399..3d2bd5a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -81,6 +81,8 @@
 # define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
+struct kmem_cache *ext4_xattr_kmem_cache;
+
 static void ext4_xattr_cache_insert(struct mb_cache *, struct buffer_head *);
 static struct buffer_head *ext4_xattr_cache_find(struct inode *,
 						 struct ext4_xattr_header *,
@@ -1687,7 +1689,8 @@ static void ext4_xattr_rehash(struct ext4_xattr_header *header,
 struct mb_cache *
 ext4_xattr_create_cache(char *name)
 {
-	return mb_cache_create(name, HASH_BUCKET_BITS);
+	return mb_cache_create_instance(name, HASH_BUCKET_BITS,
+					ext4_xattr_kmem_cache);
 }
 
 void ext4_xattr_destroy_cache(struct mb_cache *cache)
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index b930320..15616eb 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -94,6 +94,8 @@ struct ext4_xattr_ibody_find {
 	struct ext4_iloc iloc;
 };
 
+extern struct kmem_cache *ext4_xattr_kmem_cache;
+
 extern const struct xattr_handler ext4_xattr_user_handler;
 extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_acl_access_handler;
diff --git a/fs/mbcache.c b/fs/mbcache.c
index 44e7153..8e373c6 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -96,6 +96,7 @@ MODULE_DESCRIPTION("Meta block cache (for extended attributes)");
 MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(mb_cache_create);
+EXPORT_SYMBOL(mb_cache_create_instance);
 EXPORT_SYMBOL(mb_cache_shrink);
 EXPORT_SYMBOL(mb_cache_destroy);
 EXPORT_SYMBOL(mb_cache_entry_alloc);
@@ -260,18 +261,20 @@ static struct shrinker mb_cache_shrinker = {
 };
 
 /*
- * mb_cache_create()  create a new cache
+ * mb_cache_create_instance()  create a new cache for a device
  *
  * All entries in one cache are equal size. Cache entries may be from
- * multiple devices. If this is the first mbcache created, registers
- * the cache with kernel memory management. Returns NULL if no more
+ * multiple devices.  The caller must create a kmem_cache appropriate
+ * for allocating struct mb_cache_entry.  Returns NULL if no more
  * memory was available.
  *
  * @name: name of the cache (informal)
  * @bucket_bits: log2(number of hash buckets)
+ * @mb_kmem_cache: slab cache for mb_cache_entry structures
  */
 struct mb_cache *
-mb_cache_create(const char *name, int bucket_bits)
+mb_cache_create_instance(const char *name, int bucket_bits,
+			 struct kmem_cache *mb_kmem_cache)
 {
 	int n, bucket_count = 1 << bucket_bits;
 	struct mb_cache *cache = NULL;
@@ -294,11 +297,8 @@ mb_cache_create(const char *name, int bucket_bits)
 		goto fail;
 	for (n=0; n<bucket_count; n++)
 		INIT_HLIST_BL_HEAD(&cache->c_index_hash[n]);
-	cache->c_entry_cache = kmem_cache_create(name,
-		sizeof(struct mb_cache_entry), 0,
-		SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
-	if (!cache->c_entry_cache)
-		goto fail2;
+	BUG_ON(mb_kmem_cache == NULL);
+	cache->c_entry_cache = mb_kmem_cache;
 
 	/*
 	 * Set an upper limit on the number of cache entries so that the hash
@@ -311,15 +311,38 @@ mb_cache_create(const char *name, int bucket_bits)
 	spin_unlock(&mb_cache_spinlock);
 	return cache;
 
-fail2:
-	kfree(cache->c_index_hash);
-
 fail:
 	kfree(cache->c_block_hash);
 	kfree(cache);
 	return NULL;
 }
 
+/*
+ * mb_cache_create()  create a new cache
+ *
+ * All entries in one cache are equal size. Cache entries may be from
+ * multiple devices.  Returns NULL if no more memory was available.
+ *
+ * @name: name of the cache (informal)
+ * @bucket_bits: log2(number of hash buckets)
+ */
+struct mb_cache *
+mb_cache_create(const char *name, int bucket_bits)
+{
+	struct kmem_cache *mb_kmem_cache;
+	struct mb_cache *cache;
+
+	mb_kmem_cache = kmem_cache_create(name,
+		sizeof(struct mb_cache_entry), 0,
+		SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
+	if (mb_kmem_cache == NULL)
+		return NULL;
+	cache = mb_cache_create_instance(name, bucket_bits, mb_kmem_cache); 
+	if (cache == NULL)
+		kmem_cache_destroy(mb_kmem_cache);
+	cache->c_entry_cache_autofree = 1;
+	return cache;
+}
 
 /*
  * mb_cache_shrink()
@@ -406,7 +429,8 @@ mb_cache_destroy(struct mb_cache *cache)
 			  atomic_read(&cache->c_entry_count));
 	}
 
-	kmem_cache_destroy(cache->c_entry_cache);
+	if (cache->c_entry_cache_autofree)
+		kmem_cache_destroy(cache->c_entry_cache);
 
 	kfree(cache->c_index_hash);
 	kfree(cache->c_block_hash);
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 89826c0..b326ce7 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -29,11 +29,14 @@ struct mb_cache {
 	struct kmem_cache		*c_entry_cache;
 	struct hlist_bl_head		*c_block_hash;
 	struct hlist_bl_head		*c_index_hash;
+	unsigned int			c_entry_cache_autofree:1;
 };
 
 /* Functions on caches */
 
 struct mb_cache *mb_cache_create(const char *, int);
+struct mb_cache *mb_cache_create_instance(const char *,
+					  int, struct kmem_cache *);
 void mb_cache_shrink(struct block_device *);
 void mb_cache_destroy(struct mb_cache *);
 
