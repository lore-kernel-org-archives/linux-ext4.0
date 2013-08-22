From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH v2 2/2] ext4: each filesystem creates and uses its own mc_cache
Date: Thu, 22 Aug 2013 09:54:36 -0600
Message-ID: <1377186876-57291-3-git-send-email-tmac@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1377186876-57291-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com, torvalds@linux-foundation.org,
	T Makphaibulchoke <tmac@hp.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:12954 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3HVPzR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Aug 2013 11:55:17 -0400
In-Reply-To: <1377186876-57291-1-git-send-email-tmac@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds new interfaces to create and destory cache,
ext4_xattr_create_cache() and ext4_xattr_destroy_cache(), and remove the cache
creation and destory calls from ex4_init_xattr() and ext4_exitxattr() in
fs/ext4/xattr.c.
fs/ext4/super.c has been changed so that when a filesystem is mounted a
cache is allocated and attched to its ext4_sb_info structure.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 24 ++++++++++++++++--------
 fs/ext4/xattr.c | 51 ++++++++++++++++++++++++++++-----------------------
 fs/ext4/xattr.h |  6 +++---
 4 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b577e45..70f2709 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1306,6 +1306,7 @@ struct ext4_sb_info {
 	struct list_head s_es_lru;
 	unsigned long s_es_last_sorted;
 	struct percpu_counter s_extent_cache_cnt;
+	struct mb_cache *s_mb_cache;
 	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
 };
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 36b141e..3e7d338 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -59,6 +59,7 @@ static struct kset *ext4_kset;
 static struct ext4_lazy_init *ext4_li_info;
 static struct mutex ext4_li_mtx;
 static struct ext4_features *ext4_feat;
+static int ext4_mballoc_ready;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -828,6 +829,10 @@ static void ext4_put_super(struct super_block *sb)
 		invalidate_bdev(sbi->journal_bdev);
 		ext4_blkdev_remove(sbi);
 	}
+	if (sbi->s_mb_cache) {
+		ext4_xattr_destroy_cache(sbi->s_mb_cache);
+		sbi->s_mb_cache = NULL;
+	}
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 	sb->s_fs_info = NULL;
@@ -3916,6 +3921,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
+	if (ext4_mballoc_ready) {
+		sbi->s_mb_cache = ext4_xattr_create_cache(sb->s_id);
+		if (!sbi->s_mb_cache) {
+			ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
+			goto failed_mount_wq;
+		}
+	}
 
 	/*
 	 * The journal may have updated the bg summary counts, so we
@@ -5428,11 +5440,9 @@ static int __init ext4_init_fs(void)
 
 	err = ext4_init_mballoc();
 	if (err)
-		goto out3;
-
-	err = ext4_init_xattr();
-	if (err)
 		goto out2;
+	else
+		ext4_mballoc_ready = 1;
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -5448,10 +5458,9 @@ out:
 	unregister_as_ext3();
 	destroy_inodecache();
 out1:
-	ext4_exit_xattr();
-out2:
+	ext4_mballoc_ready = 0;
 	ext4_exit_mballoc();
-out3:
+out2:
 	ext4_exit_feat_adverts();
 out4:
 	if (ext4_proc_root)
@@ -5474,7 +5483,6 @@ static void __exit ext4_exit_fs(void)
 	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
 	destroy_inodecache();
-	ext4_exit_xattr();
 	ext4_exit_mballoc();
 	ext4_exit_feat_adverts();
 	remove_proc_entry("fs/ext4", NULL);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..3e0ff31 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -81,7 +81,7 @@
 # define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
-static void ext4_xattr_cache_insert(struct buffer_head *);
+static void ext4_xattr_cache_insert(struct mb_cache *, struct buffer_head *);
 static struct buffer_head *ext4_xattr_cache_find(struct inode *,
 						 struct ext4_xattr_header *,
 						 struct mb_cache_entry **);
@@ -90,8 +90,6 @@ static void ext4_xattr_rehash(struct ext4_xattr_header *,
 static int ext4_xattr_list(struct dentry *dentry, char *buffer,
 			   size_t buffer_size);
 
-static struct mb_cache *ext4_xattr_cache;
-
 static const struct xattr_handler *ext4_xattr_handler_map[] = {
 	[EXT4_XATTR_INDEX_USER]		     = &ext4_xattr_user_handler,
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
@@ -117,6 +115,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 	NULL
 };
 
+#define EXT4_GET_MB_CACHE(inode)	(((struct ext4_sb_info *) \
+				inode->i_sb->s_fs_info)->s_mb_cache)
+
 static __le32 ext4_xattr_block_csum(struct inode *inode,
 				    sector_t block_nr,
 				    struct ext4_xattr_header *hdr)
@@ -265,6 +266,7 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	struct ext4_xattr_entry *entry;
 	size_t size;
 	int error;
+	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
 
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
@@ -286,7 +288,7 @@ bad_block:
 		error = -EIO;
 		goto cleanup;
 	}
-	ext4_xattr_cache_insert(bh);
+	ext4_xattr_cache_insert(ext4_mb_cache, bh);
 	entry = BFIRST(bh);
 	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
 	if (error == -EIO)
@@ -409,6 +411,7 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	struct inode *inode = dentry->d_inode;
 	struct buffer_head *bh = NULL;
 	int error;
+	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
 
 	ea_idebug(inode, "buffer=%p, buffer_size=%ld",
 		  buffer, (long)buffer_size);
@@ -430,7 +433,7 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		error = -EIO;
 		goto cleanup;
 	}
-	ext4_xattr_cache_insert(bh);
+	ext4_xattr_cache_insert(ext4_mb_cache, bh);
 	error = ext4_xattr_list_entries(dentry, BFIRST(bh), buffer, buffer_size);
 
 cleanup:
@@ -526,8 +529,9 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 {
 	struct mb_cache_entry *ce = NULL;
 	int error = 0;
+	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
 
-	ce = mb_cache_entry_get(ext4_xattr_cache, bh->b_bdev, bh->b_blocknr);
+	ce = mb_cache_entry_get(ext4_mb_cache, bh->b_bdev, bh->b_blocknr);
 	error = ext4_journal_get_write_access(handle, bh);
 	if (error)
 		goto out;
@@ -745,13 +749,14 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	struct ext4_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
 	int error = 0;
+	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
 	if (i->value && i->value_len > sb->s_blocksize)
 		return -ENOSPC;
 	if (s->base) {
-		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
+		ce = mb_cache_entry_get(ext4_mb_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
 		error = ext4_journal_get_write_access(handle, bs->bh);
 		if (error)
@@ -769,7 +774,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
 							  s->here);
-				ext4_xattr_cache_insert(bs->bh);
+				ext4_xattr_cache_insert(ext4_mb_cache,
+					bs->bh);
 			}
 			unlock_buffer(bs->bh);
 			if (error == -EIO)
@@ -905,7 +911,7 @@ getblk_failed:
 			memcpy(new_bh->b_data, s->base, new_bh->b_size);
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
-			ext4_xattr_cache_insert(new_bh);
+			ext4_xattr_cache_insert(ext4_mb_cache, new_bh);
 			error = ext4_handle_dirty_xattr_block(handle,
 							      inode, new_bh);
 			if (error)
@@ -1492,13 +1498,13 @@ ext4_xattr_put_super(struct super_block *sb)
  * Returns 0, or a negative error number on failure.
  */
 static void
-ext4_xattr_cache_insert(struct buffer_head *bh)
+ext4_xattr_cache_insert(struct mb_cache *ext4_mb_cache, struct buffer_head *bh)
 {
 	__u32 hash = le32_to_cpu(BHDR(bh)->h_hash);
 	struct mb_cache_entry *ce;
 	int error;
 
-	ce = mb_cache_entry_alloc(ext4_xattr_cache, GFP_NOFS);
+	ce = mb_cache_entry_alloc(ext4_mb_cache, GFP_NOFS);
 	if (!ce) {
 		ea_bdebug(bh, "out of memory");
 		return;
@@ -1570,12 +1576,13 @@ ext4_xattr_cache_find(struct inode *inode, struct ext4_xattr_header *header,
 {
 	__u32 hash = le32_to_cpu(header->h_hash);
 	struct mb_cache_entry *ce;
+	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
 
 	if (!header->h_hash)
 		return NULL;  /* never share */
 	ea_idebug(inode, "looking for cached blocks [%x]", (int)hash);
 again:
-	ce = mb_cache_entry_find_first(ext4_xattr_cache, inode->i_sb->s_bdev,
+	ce = mb_cache_entry_find_first(ext4_mb_cache, inode->i_sb->s_bdev,
 				       hash);
 	while (ce) {
 		struct buffer_head *bh;
@@ -1673,19 +1680,17 @@ static void ext4_xattr_rehash(struct ext4_xattr_header *header,
 
 #undef BLOCK_HASH_SHIFT
 
-int __init
-ext4_init_xattr(void)
+#define	HASH_BUCKET_BITS	6
+
+struct mb_cache *
+ext4_xattr_create_cache(char *name)
 {
-	ext4_xattr_cache = mb_cache_create("ext4_xattr", 6);
-	if (!ext4_xattr_cache)
-		return -ENOMEM;
-	return 0;
+	return mb_cache_create(name, HASH_BUCKET_BITS);
 }
 
-void
-ext4_exit_xattr(void)
+void ext4_xattr_destroy_cache(struct mb_cache *cache)
 {
-	if (ext4_xattr_cache)
-		mb_cache_destroy(ext4_xattr_cache);
-	ext4_xattr_cache = NULL;
+	if (cache)
+		mb_cache_destroy(cache);
 }
+
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index c767dbd..b930320 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -112,9 +112,6 @@ extern void ext4_xattr_put_super(struct super_block *);
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
 
-extern int __init ext4_init_xattr(void);
-extern void ext4_exit_xattr(void);
