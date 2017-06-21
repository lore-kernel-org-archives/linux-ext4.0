From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 32/32] ext4: add nombcache mount option
Date: Wed, 21 Jun 2017 14:21:42 -0700
Message-ID: <20170621212142.16581-32-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The main purpose of mb cache is to achieve deduplication in
extended attributes. In use cases where opportunity for deduplication
is unlikely, it only adds overhead.

Add a mount option to explicitly turn off mb cache.

Suggested-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 34 +++++++++++++++++++++++-----------
 fs/ext4/xattr.c | 52 +++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cb5ace63796a..65443cbc982a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1149,6 +1149,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
+#define EXT4_MOUNT_NO_MBCACHE		0x2000000 /* No mbcache usage */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f347b01ca5ca..c828959b0551 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1336,7 +1336,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb, Opt_nojournal_checksum,
+	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 };
 
 static const match_table_t tokens = {
@@ -1419,6 +1419,8 @@ static const match_table_t tokens = {
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
+	{Opt_nombcache, "nombcache"},
+	{Opt_nombcache, "no_mbcache"},	/* for backward compatibility */
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1626,6 +1628,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
+	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
 	{Opt_err, 0, 0}
 };
 
@@ -4080,19 +4083,22 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 
 no_journal:
-	sbi->s_mb_block_cache = ext4_xattr_create_cache();
-	if (!sbi->s_mb_block_cache) {
-		ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
-		goto failed_mount_wq;
-	}
-
-	if (ext4_has_feature_ea_inode(sb)) {
-		sbi->s_ea_inode_cache = ext4_xattr_create_cache();
-		if (!sbi->s_ea_inode_cache) {
+	if (!test_opt(sb, NO_MBCACHE)) {
+		sbi->s_mb_block_cache = ext4_xattr_create_cache();
+		if (!sbi->s_mb_block_cache) {
 			ext4_msg(sb, KERN_ERR,
-				 "Failed to create an s_ea_inode_cache");
+				 "Failed to create xattr block mb_cache");
 			goto failed_mount_wq;
 		}
+
+		if (ext4_has_feature_ea_inode(sb)) {
+			sbi->s_ea_inode_cache = ext4_xattr_create_cache();
+			if (!sbi->s_ea_inode_cache) {
+				ext4_msg(sb, KERN_ERR,
+					 "Failed to create ea_inode mb_cache");
+				goto failed_mount_wq;
+			}
+		}
 	}
 
 	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
@@ -4989,6 +4995,12 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 
+	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_NO_MBCACHE) {
+		ext4_msg(sb, KERN_ERR, "can't enable nombcache during remount");
+		err = -EINVAL;
+		goto restore_opts;
+	}
+
 	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX) {
 		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
 			"dax flag with busy inodes while remounting");
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index edef88a2cc7c..0a160d93b52d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -976,10 +976,13 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 			set_nlink(ea_inode, 1);
 			ext4_orphan_del(handle, ea_inode);
 
-			hash = ext4_xattr_inode_get_hash(ea_inode);
-			mb_cache_entry_create(ea_inode_cache, GFP_NOFS, hash,
-					      ea_inode->i_ino,
-					      true /* reusable */);
+			if (ea_inode_cache) {
+				hash = ext4_xattr_inode_get_hash(ea_inode);
+				mb_cache_entry_create(ea_inode_cache,
+						      GFP_NOFS, hash,
+						      ea_inode->i_ino,
+						      true /* reusable */);
+			}
 		}
 	} else {
 		WARN_ONCE(ref_count < 0, "EA inode %lu ref_count=%lld",
@@ -993,9 +996,11 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 			clear_nlink(ea_inode);
 			ext4_orphan_add(handle, ea_inode);
 
-			hash = ext4_xattr_inode_get_hash(ea_inode);
-			mb_cache_entry_delete(ea_inode_cache, hash,
-					      ea_inode->i_ino);
+			if (ea_inode_cache) {
+				hash = ext4_xattr_inode_get_hash(ea_inode);
+				mb_cache_entry_delete(ea_inode_cache, hash,
+						      ea_inode->i_ino);
+			}
 		}
 	}
 
@@ -1179,7 +1184,9 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		 * This must happen under buffer lock for
 		 * ext4_xattr_block_set() to reliably detect freed block
 		 */
-		mb_cache_entry_delete(mb_block_cache, hash, bh->b_blocknr);
+		if (mb_block_cache)
+			mb_cache_entry_delete(mb_block_cache, hash,
+					      bh->b_blocknr);
 		get_bh(bh);
 		unlock_buffer(bh);
 
@@ -1199,11 +1206,13 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ref == EXT4_XATTR_REFCOUNT_MAX - 1) {
 			struct mb_cache_entry *ce;
 
-			ce = mb_cache_entry_get(mb_block_cache, hash,
-						bh->b_blocknr);
-			if (ce) {
-				ce->e_reusable = 1;
-				mb_cache_entry_put(mb_block_cache, ce);
+			if (mb_block_cache) {
+				ce = mb_cache_entry_get(mb_block_cache, hash,
+							bh->b_blocknr);
+				if (ce) {
+					ce->e_reusable = 1;
+					mb_cache_entry_put(mb_block_cache, ce);
+				}
 			}
 		}
 
@@ -1382,6 +1391,9 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(inode);
 	void *ea_data;
 
+	if (!ea_inode_cache)
+		return NULL;
+
 	ce = mb_cache_entry_find_first(ea_inode_cache, hash);
 	if (!ce)
 		return NULL;
@@ -1452,8 +1464,9 @@ static int ext4_xattr_inode_lookup_create(handle_t *handle, struct inode *inode,
 		return err;
 	}
 
-	mb_cache_entry_create(EA_INODE_CACHE(inode), GFP_NOFS, hash,
-			      ea_inode->i_ino, true /* reusable */);
+	if (EA_INODE_CACHE(inode))
+		mb_cache_entry_create(EA_INODE_CACHE(inode), GFP_NOFS, hash,
+				      ea_inode->i_ino, true /* reusable */);
 
 	*ret_inode = ea_inode;
 	return 0;
@@ -1780,8 +1793,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			 * ext4_xattr_block_set() to reliably detect modified
 			 * block
 			 */
-			mb_cache_entry_delete(mb_block_cache, hash,
-					      bs->bh->b_blocknr);
+			if (mb_block_cache)
+				mb_cache_entry_delete(mb_block_cache, hash,
+						      bs->bh->b_blocknr);
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode,
 						     true /* is_block */);
@@ -2870,6 +2884,8 @@ ext4_xattr_block_cache_insert(struct mb_cache *mb_block_cache,
 		       EXT4_XATTR_REFCOUNT_MAX;
 	int error;
 
+	if (!mb_block_cache)
+		return;
 	error = mb_cache_entry_create(mb_block_cache, GFP_NOFS, hash,
 				      bh->b_blocknr, reusable);
 	if (error) {
@@ -2936,6 +2952,8 @@ ext4_xattr_block_cache_find(struct inode *inode,
 	struct mb_cache_entry *ce;
 	struct mb_cache *mb_block_cache = MB_BLOCK_CACHE(inode);
 
+	if (!mb_block_cache)
+		return NULL;
 	if (!header->h_hash)
 		return NULL;  /* never share */
 	ea_idebug(inode, "looking for cached blocks [%x]", (int)hash);
-- 
2.13.1.611.g7e3b11ae1-goog
