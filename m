From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 09/12] tune2fs: update ea_inode hashes when fs uuid changes
Date: Mon, 26 Jun 2017 06:43:45 -0700
Message-ID: <20170626134348.1240-9-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33206 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbdFZNoT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:19 -0400
Received: by mail-pf0-f178.google.com with SMTP id e7so779156pfk.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:14 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extended attribute inodes maintain a crc32c hash that is used for
deduplication. The crc seed derives from uuid so ea_inode hashes
must be updated when uuid changes.

The ea_inode hash is also incorporated into the xattr entry e_hash
so the entries that reference the inode also must be updated.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/ext2fs/csum.c     |   3 +-
 lib/ext2fs/ext2fs.h   |   4 +
 lib/ext2fs/ext_attr.c |  44 +++++++-
 misc/tune2fs.c        | 299 ++++++++++++++++++++++++++++++++++----------------
 4 files changed, 249 insertions(+), 101 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index e67850fa47af..214a099762ee 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -34,7 +34,8 @@ void ext2fs_init_csum_seed(ext2_filsys fs)
 {
 	if (ext2fs_has_feature_csum_seed(fs->super))
 		fs->csum_seed = fs->super->s_checksum_seed;
-	else if (ext2fs_has_feature_metadata_csum(fs->super))
+	else if (ext2fs_has_feature_metadata_csum(fs->super) ||
+		 ext2fs_has_feature_ea_inode(fs->super))
 		fs->csum_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
 						 sizeof(fs->super->s_uuid));
 }
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f72cbe17a8cd..90df2182bd7b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1247,6 +1247,10 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 #define XATTR_HANDLE_FLAG_RAW	0x0001
 errcode_t ext2fs_xattrs_flags(struct ext2_xattr_handle *handle,
 			      unsigned int *new_flags, unsigned int *old_flags);
+extern void ext2fs_ext_attr_block_rehash(struct ext2_ext_attr_header *header,
+					 struct ext2_ext_attr_entry *end);
+extern __u32 ext2fs_get_ea_inode_hash(struct ext2_inode *inode);
+extern void ext2fs_set_ea_inode_hash(struct ext2_inode *inode, __u32 hash);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index d48ab5c55270..41789c7dcbf2 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -33,7 +33,7 @@ static errcode_t read_ea_inode_hash(ext2_filsys fs, ext2_ino_t ino, __u32 *hash)
 	retval = ext2fs_read_inode(fs, ino, &inode);
 	if (retval)
 		return retval;
-	*hash = inode.i_atime;
+	*hash = ext2fs_get_ea_inode_hash(&inode);
 	return 0;
 }
 
@@ -100,6 +100,45 @@ errcode_t ext2fs_ext_attr_hash_entry2(ext2_filsys fs,
 	return 0;
 }
 
+#undef NAME_HASH_SHIFT
+#undef VALUE_HASH_SHIFT
+
+#define BLOCK_HASH_SHIFT 16
+
+/* Mirrors ext4_xattr_rehash() implementation in kernel. */
+void ext2fs_ext_attr_block_rehash(struct ext2_ext_attr_header *header,
+				  struct ext2_ext_attr_entry *end)
+{
+	struct ext2_ext_attr_entry *here;
+	__u32 hash = 0;
+
+	here = (struct ext2_ext_attr_entry *)(header+1);
+	while (here < end && !EXT2_EXT_IS_LAST_ENTRY(here)) {
+		if (!here->e_hash) {
+			/* Block is not shared if an entry's hash value == 0 */
+			hash = 0;
+			break;
+		}
+		hash = (hash << BLOCK_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - BLOCK_HASH_SHIFT)) ^
+		       here->e_hash;
+		here = EXT2_EXT_ATTR_NEXT(here);
+	}
+	header->h_hash = hash;
+}
+
+#undef BLOCK_HASH_SHIFT
+
+__u32 ext2fs_get_ea_inode_hash(struct ext2_inode *inode)
+{
+	return inode->i_atime;
+}
+
+void ext2fs_set_ea_inode_hash(struct ext2_inode *inode, __u32 hash)
+{
+	inode->i_atime = hash;
+}
+
 static errcode_t check_ext_attr_header(struct ext2_ext_attr_header *header)
 {
 	if ((header->h_magic != EXT2_EXT_ATTR_MAGIC_v1 &&
@@ -110,9 +149,6 @@ static errcode_t check_ext_attr_header(struct ext2_ext_attr_header *header)
 	return 0;
 }
 
-#undef NAME_HASH_SHIFT
-#undef VALUE_HASH_SHIFT
-
 errcode_t ext2fs_read_ext_attr3(ext2_filsys fs, blk64_t block, void *buf,
 				ext2_ino_t inum)
 {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2a437b9fc7b7..9b53dc28e9cb 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -718,115 +718,224 @@ static errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
 	return ctx.errcode;
 }
 
+/*
+ * Context information that does not change across rewrite_one_inode()
+ * invocations.
+ */
+struct rewrite_context {
+	ext2_filsys fs;
+	struct ext2_inode *zero_inode;
+	char *ea_buf;
+	int inode_size;
+};
+
+#define fatal_err(code, args...)		\
+	do {					\
+		com_err(__func__, code, args);	\
+		exit(1);			\
+	} while (0);
+
+static void update_ea_inode_hash(struct rewrite_context *ctx, ext2_ino_t ino,
+				 struct ext2_inode *inode)
+{
+	errcode_t retval;
+	ext2_file_t file;
+	__u32 hash;
+
+	retval = ext2fs_file_open(ctx->fs, ino, 0, &file);
+	if (retval)
+		fatal_err(retval, "open ea_inode");
+	retval = ext2fs_file_read(file, ctx->ea_buf, inode->i_size,
+				  NULL);
+	if (retval)
+		fatal_err(retval, "read ea_inode");
+	retval = ext2fs_file_close(file);
+	if (retval)
+		fatal_err(retval, "close ea_inode");
+
+	hash = ext2fs_crc32c_le(ctx->fs->csum_seed, ctx->ea_buf, inode->i_size);
+	ext2fs_set_ea_inode_hash(inode, hash);
+}
+
+static int update_xattr_entry_hashes(ext2_filsys fs,
+				     struct ext2_ext_attr_entry *entry,
+				     struct ext2_ext_attr_entry *end)
+{
+	int modified = 0;
+	errcode_t retval;
+
+	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_inum) {
+			retval = ext2fs_ext_attr_hash_entry2(fs, entry, NULL,
+							     &entry->e_hash);
+			if (retval)
+				fatal_err(retval, "hash ea_inode entry");
+			modified = 1;
+		}
+		entry = EXT2_EXT_ATTR_NEXT(entry);
+	}
+	return modified;
+}
+
+static void update_inline_xattr_hashes(struct rewrite_context *ctx,
+				       struct ext2_inode_large *inode)
+{
+	struct ext2_ext_attr_entry *start, *end;
+	__u32 *ea_magic;
+
+	if (inode->i_extra_isize == 0)
+		return;
+
+	if (inode->i_extra_isize & 3 ||
+	    inode->i_extra_isize > ctx->inode_size - EXT2_GOOD_OLD_INODE_SIZE)
+		fatal_err(EXT2_ET_INODE_CORRUPTED, "bad i_extra_isize")
+
+	ea_magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
+				inode->i_extra_isize);
+	if (*ea_magic != EXT2_EXT_ATTR_MAGIC)
+		return;
+
+	start = (struct ext2_ext_attr_entry *)(ea_magic + 1);
+	end = (struct ext2_ext_attr_entry *)((char *)inode + ctx->inode_size);
+
+	update_xattr_entry_hashes(ctx->fs, start, end);
+}
+
+static void update_block_xattr_hashes(struct rewrite_context *ctx,
+				      void *block_buf)
+{
+	struct ext2_ext_attr_header *header;
+	struct ext2_ext_attr_entry *start, *end;
+
+	header = (struct ext2_ext_attr_header *)block_buf;
+	if (header->h_magic != EXT2_EXT_ATTR_MAGIC)
+		return;
+
+	start = (struct ext2_ext_attr_entry *)(header+1);
+	end = (struct ext2_ext_attr_entry *)(block_buf + ctx->fs->blocksize);
+
+	if (update_xattr_entry_hashes(ctx->fs, start, end))
+		ext2fs_ext_attr_block_rehash(header, end);
+}
+
+static void rewrite_one_inode(struct rewrite_context *ctx, ext2_ino_t ino,
+			      struct ext2_inode *inode)
+{
+	blk64_t file_acl_block;
+	errcode_t retval;
+
+	if (!ext2fs_test_inode_bitmap2(ctx->fs->inode_map, ino)) {
+		if (!memcmp(inode, ctx->zero_inode, ctx->inode_size))
+			return;
+		memset(inode, 0, ctx->inode_size);
+	}
+
+	if (inode->i_flags & EXT4_EA_INODE_FL)
+		update_ea_inode_hash(ctx, ino, inode);
+
+	if (ctx->inode_size != EXT2_GOOD_OLD_INODE_SIZE)
+		update_inline_xattr_hashes(ctx,
+					   (struct ext2_inode_large *)inode);
+
+	retval = ext2fs_write_inode_full(ctx->fs, ino, inode, ctx->inode_size);
+	if (retval)
+		fatal_err(retval, "while writing inode");
+
+	retval = rewrite_extents(ctx->fs, ino, inode);
+	if (retval)
+		fatal_err(retval, "while rewriting extents");
+
+	if (LINUX_S_ISDIR(inode->i_mode) &&
+	    ext2fs_inode_has_valid_blocks2(ctx->fs, inode)) {
+		retval = rewrite_directory(ctx->fs, ino, inode);
+		if (retval)
+			fatal_err(retval, "while rewriting directories");
+	}
+
+	file_acl_block = ext2fs_file_acl_block(ctx->fs, inode);
+	if (!file_acl_block)
+		return;
+
+	retval = ext2fs_read_ext_attr3(ctx->fs, file_acl_block, ctx->ea_buf,
+				       ino);
+	if (retval)
+		fatal_err(retval, "while rewriting extended attribute");
+
+	update_block_xattr_hashes(ctx, ctx->ea_buf);
+	retval = ext2fs_write_ext_attr3(ctx->fs, file_acl_block, ctx->ea_buf,
+					ino);
+	if (retval)
+		fatal_err(retval, "while rewriting extended attribute");
+}
+
 /*
  * Forcibly set checksums in all inodes.
  */
 static void rewrite_inodes(ext2_filsys fs)
 {
-	int length = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode *inode, *zero;
-	char		*ea_buf;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
-	blk64_t		file_acl_block;
-	int		inode_dirty;
+	struct ext2_inode *inode;
+	int pass;
+	struct rewrite_context ctx = {
+		.fs = fs,
+		.inode_size = EXT2_INODE_SIZE(fs->super),
+	};
 
 	if (fs->super->s_creator_os == EXT2_OS_HURD)
 		return;
 
-	retval = ext2fs_open_inode_scan(fs, 0, &scan);
-	if (retval) {
-		com_err("set_csum", retval, "while opening inode scan");
-		exit(1);
-	}
-
-	retval = ext2fs_get_mem(length, &inode);
-	if (retval) {
-		com_err("set_csum", retval, "while allocating memory");
-		exit(1);
-	}
-
-	retval = ext2fs_get_memzero(length, &zero);
-	if (retval) {
-		com_err("set_csum", retval, "while allocating memory");
-		exit(1);
-	}
+	retval = ext2fs_get_mem(ctx.inode_size, &inode);
+	if (retval)
+		fatal_err(retval, "while allocating memory");
 
-	retval = ext2fs_get_mem(fs->blocksize, &ea_buf);
-	if (retval) {
-		com_err("set_csum", retval, "while allocating memory");
-		exit(1);
-	}
+	retval = ext2fs_get_memzero(ctx.inode_size, &ctx.zero_inode);
+	if (retval)
+		fatal_err(retval, "while allocating memory");
 
-	do {
-		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
-		if (retval) {
-			com_err("set_csum", retval, "while getting next inode");
-			exit(1);
-		}
-		if (!ino)
-			break;
-		if (ext2fs_test_inode_bitmap2(fs->inode_map, ino)) {
-			inode_dirty = 1;
-		} else {
-			if (memcmp(inode, zero, length) != 0) {
-				memset(inode, 0, length);
-				inode_dirty = 1;
-			} else {
-				inode_dirty = 0;
-			}
-		}
+	retval = ext2fs_get_mem(64 * 1024, &ctx.ea_buf);
+	if (retval)
+		fatal_err(retval, "while allocating memory");
 
-		if (inode_dirty) {
-			retval = ext2fs_write_inode_full(fs, ino, inode,
-							 length);
-			if (retval) {
-				com_err("set_csum", retval, "while writing "
-					"inode");
-				exit(1);
-			}
-		}
+	/*
+	 * Extended attribute inodes have a lookup hash that needs to be
+	 * recalculated with the new csum_seed. Other inodes referencing xattr
+	 * inodes need this value to be up to date. That's why we do two passes:
+	 *
+	 * pass 1: update xattr inodes to update their lookup hash as well as
+	 *         other checksums.
+	 *
+	 * pass 2: go over other inodes to update their checksums.
+	 */
+	if (ext2fs_has_feature_ea_inode(fs->super))
+		pass = 1;
+	else
+		pass = 2;
+	for (;pass <= 2; pass++) {
+		retval = ext2fs_open_inode_scan(fs, 0, &scan);
+		if (retval)
+			fatal_err(retval, "while opening inode scan");
 
-		retval = rewrite_extents(fs, ino, inode);
-		if (retval) {
-			com_err("rewrite_extents", retval,
-				"while rewriting extents");
-			exit(1);
-		}
+		do {
+			retval = ext2fs_get_next_inode_full(scan, &ino, inode,
+							    ctx.inode_size);
+			if (retval)
+				fatal_err(retval, "while getting next inode");
+			if (!ino)
+				break;
 
-		if (LINUX_S_ISDIR(inode->i_mode) &&
-		    ext2fs_inode_has_valid_blocks2(fs, inode)) {
-			retval = rewrite_directory(fs, ino, inode);
-			if (retval) {
-				com_err("rewrite_directory", retval,
-					"while rewriting directories");
-				exit(1);
-			}
-		}
+			if (pass == 1 && (inode->i_flags & EXT4_EA_INODE_FL) ||
+			    pass == 2 && !(inode->i_flags & EXT4_EA_INODE_FL))
+				rewrite_one_inode(&ctx, ino, inode);
+		} while (ino);
 
-		file_acl_block = ext2fs_file_acl_block(fs, inode);
-		if (!file_acl_block)
-			continue;
-		retval = ext2fs_read_ext_attr3(fs, file_acl_block, ea_buf, ino);
-		if (retval) {
-			com_err("rewrite_eablock", retval,
-				"while rewriting extended attribute");
-			exit(1);
-		}
-		retval = ext2fs_write_ext_attr3(fs, file_acl_block, ea_buf,
-						ino);
-		if (retval) {
-			com_err("rewrite_eablock", retval,
-				"while rewriting extended attribute");
-			exit(1);
-		}
-	} while (ino);
+		ext2fs_close_inode_scan(scan);
+	}
 
-	ext2fs_free_mem(&zero);
+	ext2fs_free_mem(&ctx.zero_inode);
+	ext2fs_free_mem(&ctx.ea_buf);
 	ext2fs_free_mem(&inode);
-	ext2fs_free_mem(&ea_buf);
-	ext2fs_close_inode_scan(scan);
 }
 
 static void rewrite_metadata_checksums(ext2_filsys fs)
@@ -839,11 +948,8 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	for (i = 0; i < fs->group_desc_count; i++)
 		ext2fs_group_desc_csum_set(fs, i);
 	retval = ext2fs_read_bitmaps(fs);
-	if (retval) {
-		com_err("rewrite_metadata_checksums", retval,
-			"while reading bitmaps");
-		exit(1);
-	}
+	if (retval)
+		fatal_err(retval, "while reading bitmaps");
 	rewrite_inodes(fs);
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
@@ -3135,8 +3241,9 @@ retry_open:
 		}
 
 		ext2fs_mark_super_dirty(fs);
-		if (ext2fs_has_feature_metadata_csum(fs->super) &&
-		    !ext2fs_has_feature_csum_seed(fs->super))
+		if (!ext2fs_has_feature_csum_seed(fs->super) &&
+		    (ext2fs_has_feature_metadata_csum(fs->super) ||
+		     ext2fs_has_feature_ea_inode(fs->super)))
 			rewrite_checksums = 1;
 	}
 
-- 
2.13.1.611.g7e3b11ae1-goog
