From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 24/28] ext4: rename mb block cache functions
Date: Wed, 31 May 2017 01:15:13 -0700
Message-ID: <20170531081517.11438-24-tahsin@google.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:32879 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdEaIRe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 31 May 2017 04:17:34 -0400
Received: by mail-pf0-f180.google.com with SMTP id e193so7104412pfh.0
        for <linux-ext4@vger.kernel.org>; Wed, 31 May 2017 01:17:29 -0700 (PDT)
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There will be a second cache instance that tracks ea_inodes. Make
existing names more explicit so that it is clear that they refer to
xattr block cache.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 772948f168c3..3ee7e2f68476 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -72,10 +72,11 @@
 # define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
-static void ext4_xattr_cache_insert(struct mb_cache *, struct buffer_head *);
-static struct buffer_head *ext4_xattr_cache_find(struct inode *,
-						 struct ext4_xattr_header *,
-						 struct mb_cache_entry **);
+static void ext4_xattr_block_cache_insert(struct mb_cache *,
+					  struct buffer_head *);
+static struct buffer_head *
+ext4_xattr_block_cache_find(struct inode *, struct ext4_xattr_header *,
+			    struct mb_cache_entry **);
 static void ext4_xattr_rehash(struct ext4_xattr_header *,
 			      struct ext4_xattr_entry *);
 
@@ -395,7 +396,7 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 		error = -EFSCORRUPTED;
 		goto cleanup;
 	}
-	ext4_xattr_cache_insert(ext4_mb_cache, bh);
+	ext4_xattr_block_cache_insert(ext4_mb_cache, bh);
 	entry = BFIRST(bh);
 	error = ext4_xattr_find_entry(&entry, name_index, name, 1);
 	if (error)
@@ -563,7 +564,7 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		error = -EFSCORRUPTED;
 		goto cleanup;
 	}
-	ext4_xattr_cache_insert(ext4_mb_cache, bh);
+	ext4_xattr_block_cache_insert(ext4_mb_cache, bh);
 	error = ext4_xattr_list_entries(dentry, BFIRST(bh), buffer, buffer_size);
 
 cleanup:
@@ -1123,8 +1124,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
 							  s->here);
-				ext4_xattr_cache_insert(ext4_mb_cache,
-					bs->bh);
+				ext4_xattr_block_cache_insert(ext4_mb_cache,
+							      bs->bh);
 			}
 			ext4_xattr_block_csum_set(inode, bs->bh);
 			unlock_buffer(bs->bh);
@@ -1177,7 +1178,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 inserted:
 	if (!IS_LAST_ENTRY(s->first)) {
-		new_bh = ext4_xattr_cache_find(inode, header(s->base), &ce);
+		new_bh = ext4_xattr_block_cache_find(inode, header(s->base),
+						     &ce);
 		if (new_bh) {
 			/* We found an identical block in the cache. */
 			if (new_bh == bs->bh)
@@ -1292,7 +1294,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_block_csum_set(inode, new_bh);
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
-			ext4_xattr_cache_insert(ext4_mb_cache, new_bh);
+			ext4_xattr_block_cache_insert(ext4_mb_cache, new_bh);
 			error = ext4_handle_dirty_metadata(handle, inode,
 							   new_bh);
 			if (error)
@@ -2150,15 +2152,16 @@ void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *ea_inode_array)
 }
 
 /*
- * ext4_xattr_cache_insert()
+ * ext4_xattr_block_cache_insert()
  *
- * Create a new entry in the extended attribute cache, and insert
+ * Create a new entry in the extended attribute block cache, and insert
  * it unless such an entry is already in the cache.
  *
  * Returns 0, or a negative error number on failure.
  */
 static void
-ext4_xattr_cache_insert(struct mb_cache *ext4_mb_cache, struct buffer_head *bh)
+ext4_xattr_block_cache_insert(struct mb_cache *ext4_mb_cache,
+			      struct buffer_head *bh)
 {
 	struct ext4_xattr_header *header = BHDR(bh);
 	__u32 hash = le32_to_cpu(header->h_hash);
@@ -2216,7 +2219,7 @@ ext4_xattr_cmp(struct ext4_xattr_header *header1,
 }
 
 /*
- * ext4_xattr_cache_find()
+ * ext4_xattr_block_cache_find()
  *
  * Find an identical extended attribute block.
  *
@@ -2224,8 +2227,9 @@ ext4_xattr_cmp(struct ext4_xattr_header *header1,
  * not found or an error occurred.
  */
 static struct buffer_head *
-ext4_xattr_cache_find(struct inode *inode, struct ext4_xattr_header *header,
-		      struct mb_cache_entry **pce)
+ext4_xattr_block_cache_find(struct inode *inode,
+			    struct ext4_xattr_header *header,
+			    struct mb_cache_entry **pce)
 {
 	__u32 hash = le32_to_cpu(header->h_hash);
 	struct mb_cache_entry *ce;
-- 
2.13.0.219.gdb65acc882-goog
