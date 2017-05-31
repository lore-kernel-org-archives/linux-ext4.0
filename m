From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 23/28] mbcache: make mbcache more generic
Date: Wed, 31 May 2017 01:15:12 -0700
Message-ID: <20170531081517.11438-23-tahsin@google.com>
References: <20170531081517.11438-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Large xattr feature would like to use the mbcache for xattr value
deduplication. Current implementation is geared towards xattr block
deduplication. Make it more generic so that it can be used by both.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext2/xattr.c         | 18 +++++++++---------
 fs/ext4/xattr.c         | 10 +++++-----
 fs/mbcache.c            | 43 +++++++++++++++++++++----------------------
 include/linux/mbcache.h | 14 ++++++++------
 4 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index fbdb8f171893..1e5f76070580 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -493,8 +493,8 @@ bad_block:		ext2_error(sb, "ext2_xattr_set",
 			 * This must happen under buffer lock for
 			 * ext2_xattr_set2() to reliably detect modified block
 			 */
-			mb_cache_entry_delete_block(EXT2_SB(sb)->s_mb_cache,
-						    hash, bh->b_blocknr);
+			mb_cache_entry_delete(EXT2_SB(sb)->s_mb_cache, hash,
+					      bh->b_blocknr);
 
 			/* keep the buffer locked while modifying it. */
 		} else {
@@ -721,8 +721,8 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			 * This must happen under buffer lock for
 			 * ext2_xattr_set2() to reliably detect freed block
 			 */
-			mb_cache_entry_delete_block(ext2_mb_cache,
-						    hash, old_bh->b_blocknr);
+			mb_cache_entry_delete(ext2_mb_cache, hash,
+					      old_bh->b_blocknr);
 			/* Free the old block. */
 			ea_bdebug(old_bh, "freeing");
 			ext2_free_blocks(inode, old_bh->b_blocknr, 1);
@@ -795,8 +795,8 @@ ext2_xattr_delete_inode(struct inode *inode)
 		 * This must happen under buffer lock for ext2_xattr_set2() to
 		 * reliably detect freed block
 		 */
-		mb_cache_entry_delete_block(EXT2_SB(inode->i_sb)->s_mb_cache,
-					    hash, bh->b_blocknr);
+		mb_cache_entry_delete(EXT2_SB(inode->i_sb)->s_mb_cache, hash,
+				      bh->b_blocknr);
 		ext2_free_blocks(inode, EXT2_I(inode)->i_file_acl, 1);
 		get_bh(bh);
 		bforget(bh);
@@ -907,11 +907,11 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
 	while (ce) {
 		struct buffer_head *bh;
 
-		bh = sb_bread(inode->i_sb, ce->e_block);
+		bh = sb_bread(inode->i_sb, ce->e_value);
 		if (!bh) {
 			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
 				"inode %ld: block %ld read error",
-				inode->i_ino, (unsigned long) ce->e_block);
+				inode->i_ino, (unsigned long) ce->e_value);
 		} else {
 			lock_buffer(bh);
 			/*
@@ -931,7 +931,7 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
 			} else if (le32_to_cpu(HDR(bh)->h_refcount) >
 				   EXT2_XATTR_REFCOUNT_MAX) {
 				ea_idebug(inode, "block %ld refcount %d>%d",
-					  (unsigned long) ce->e_block,
+					  (unsigned long) ce->e_value,
 					  le32_to_cpu(HDR(bh)->h_refcount),
 					  EXT2_XATTR_REFCOUNT_MAX);
 			} else if (!ext2_xattr_cmp(header, HDR(bh))) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 886d06e409b6..772948f168c3 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -678,7 +678,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		 * This must happen under buffer lock for
 		 * ext4_xattr_block_set() to reliably detect freed block
 		 */
-		mb_cache_entry_delete_block(ext4_mb_cache, hash, bh->b_blocknr);
+		mb_cache_entry_delete(ext4_mb_cache, hash, bh->b_blocknr);
 		get_bh(bh);
 		unlock_buffer(bh);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
@@ -1115,8 +1115,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			 * ext4_xattr_block_set() to reliably detect modified
 			 * block
 			 */
-			mb_cache_entry_delete_block(ext4_mb_cache, hash,
-						    bs->bh->b_blocknr);
+			mb_cache_entry_delete(ext4_mb_cache, hash,
+					      bs->bh->b_blocknr);
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode);
 			if (!error) {
@@ -2238,10 +2238,10 @@ ext4_xattr_cache_find(struct inode *inode, struct ext4_xattr_header *header,
 	while (ce) {
 		struct buffer_head *bh;
 
-		bh = sb_bread(inode->i_sb, ce->e_block);
+		bh = sb_bread(inode->i_sb, ce->e_value);
 		if (!bh) {
 			EXT4_ERROR_INODE(inode, "block %lu read error",
-					 (unsigned long) ce->e_block);
+					 (unsigned long) ce->e_value);
 		} else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {
 			*pce = ce;
 			return bh;
diff --git a/fs/mbcache.c b/fs/mbcache.c
index b19be429d655..77a5b99d8f92 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -10,7 +10,7 @@
 /*
  * Mbcache is a simple key-value store. Keys need not be unique, however
  * key-value pairs are expected to be unique (we use this fact in
- * mb_cache_entry_delete_block()).
+ * mb_cache_entry_delete()).
  *
  * Ext2 and ext4 use this cache for deduplication of extended attribute blocks.
  * They use hash of a block contents as a key and block number as a value.
@@ -62,15 +62,15 @@ static inline struct hlist_bl_head *mb_cache_entry_head(struct mb_cache *cache,
  * @cache - cache where the entry should be created
  * @mask - gfp mask with which the entry should be allocated
  * @key - key of the entry
- * @block - block that contains data
- * @reusable - is the block reusable by other inodes?
+ * @value - value of the entry
+ * @reusable - is the entry reusable by others?
  *
- * Creates entry in @cache with key @key and records that data is stored in
- * block @block. The function returns -EBUSY if entry with the same key
- * and for the same block already exists in cache. Otherwise 0 is returned.
+ * Creates entry in @cache with key @key and value @value. The function returns
+ * -EBUSY if entry with the same key and value already exists in cache.
+ * Otherwise 0 is returned.
  */
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
-			  sector_t block, bool reusable)
+			  cache_value_t value, bool reusable)
 {
 	struct mb_cache_entry *entry, *dup;
 	struct hlist_bl_node *dup_node;
@@ -91,12 +91,12 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	/* One ref for hash, one ref returned */
 	atomic_set(&entry->e_refcnt, 1);
 	entry->e_key = key;
-	entry->e_block = block;
+	entry->e_value = value;
 	entry->e_reusable = reusable;
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
-		if (dup->e_key == key && dup->e_block == block) {
+		if (dup->e_key == key && dup->e_value == value) {
 			hlist_bl_unlock(head);
 			kmem_cache_free(mb_entry_cache, entry);
 			return -EBUSY;
@@ -187,13 +187,13 @@ struct mb_cache_entry *mb_cache_entry_find_next(struct mb_cache *cache,
 EXPORT_SYMBOL(mb_cache_entry_find_next);
 
 /*
- * mb_cache_entry_get - get a cache entry by block number (and key)
+ * mb_cache_entry_get - get a cache entry by value (and key)
  * @cache - cache we work with
- * @key - key of block number @block
- * @block - block number
+ * @key - key
+ * @value - value
  */
 struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
-					  sector_t block)
+					  cache_value_t value)
 {
 	struct hlist_bl_node *node;
 	struct hlist_bl_head *head;
@@ -202,7 +202,7 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_block == block) {
+		if (entry->e_key == key && entry->e_value == value) {
 			atomic_inc(&entry->e_refcnt);
 			goto out;
 		}
@@ -214,15 +214,14 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 }
 EXPORT_SYMBOL(mb_cache_entry_get);
 
-/* mb_cache_entry_delete_block - remove information about block from cache
+/* mb_cache_entry_delete - remove a cache entry
  * @cache - cache we work with
- * @key - key of block @block
- * @block - block number
+ * @key - key
+ * @value - value
  *
- * Remove entry from cache @cache with key @key with data stored in @block.
+ * Remove entry from cache @cache with key @key and value @value.
  */
-void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
-				 sector_t block)
+void mb_cache_entry_delete(struct mb_cache *cache, u32 key, cache_value_t value)
 {
 	struct hlist_bl_node *node;
 	struct hlist_bl_head *head;
@@ -231,7 +230,7 @@ void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_block == block) {
+		if (entry->e_key == key && entry->e_value == value) {
 			/* We keep hash list reference to keep entry alive */
 			hlist_bl_del_init(&entry->e_hash_list);
 			hlist_bl_unlock(head);
@@ -248,7 +247,7 @@ void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
 	}
 	hlist_bl_unlock(head);
 }
-EXPORT_SYMBOL(mb_cache_entry_delete_block);
+EXPORT_SYMBOL(mb_cache_entry_delete);
 
 /* mb_cache_entry_touch - cache entry got used
  * @cache - cache the entry belongs to
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 86c9a8b480c5..e2d9f2f926a4 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -9,6 +9,8 @@
 
 struct mb_cache;
 
+typedef sector_t cache_value_t;
+
 struct mb_cache_entry {
 	/* List of entries in cache - protected by cache->c_list_lock */
 	struct list_head	e_list;
@@ -19,15 +21,15 @@ struct mb_cache_entry {
 	u32			e_key;
 	u32			e_referenced:1;
 	u32			e_reusable:1;
-	/* Block number of hashed block - stable during lifetime of the entry */
-	sector_t		e_block;
+	/* User provided value - stable during lifetime of the entry */
+	cache_value_t		e_value;
 };
 
 struct mb_cache *mb_cache_create(int bucket_bits);
 void mb_cache_destroy(struct mb_cache *cache);
 
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
-			  sector_t block, bool reusable);
+			  cache_value_t value, bool reusable);
 void __mb_cache_entry_free(struct mb_cache_entry *entry);
 static inline int mb_cache_entry_put(struct mb_cache *cache,
 				     struct mb_cache_entry *entry)
@@ -38,10 +40,10 @@ static inline int mb_cache_entry_put(struct mb_cache *cache,
 	return 1;
 }
 
-void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
-				  sector_t block);
+void mb_cache_entry_delete(struct mb_cache *cache, u32 key,
+			   cache_value_t value);
 struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
-					  sector_t block);
+					  cache_value_t value);
 struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache *cache,
 						 u32 key);
 struct mb_cache_entry *mb_cache_entry_find_next(struct mb_cache *cache,
-- 
2.13.0.219.gdb65acc882-goog
