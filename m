From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 4/4] libext2fs: add ea_inode support to set xattr
Date: Fri,  7 Jul 2017 05:12:46 -0700
Message-ID: <20170707121246.6159-4-tahsin@google.com>
References: <20170707121246.6159-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33339 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdGGMM5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 08:12:57 -0400
Received: by mail-pg0-f48.google.com with SMTP id k14so16530221pgr.0
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jul 2017 05:12:57 -0700 (PDT)
In-Reply-To: <20170707121246.6159-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is a major update to how we decide where to put extended
attributes. The main motivation is to enable creating values in extended
attribute inodes. While doing this, we want to implement a behavior
that is as close to kernel as possible.

Existing set ea code deviates from kernel behavior which makes it harder
to implement ea_inode feature:

 - kernel only sorts ea entries in xattr block, e2fsprogs implementation
   sorts all entries on every update.

 - e2fsprogs implementation shuffled things on every update so the order
   of updates does not matter. Kernel does not reshuffle things.

 - e2fsprogs could evacuate entries from inode body to xattr block and
   vice versa. This behavior does not exist in kernel.

Such differences could lead to inconsistent behavior between fuse2fs and
a kernel mount.

With ea_inode feature, we also need to decide whether to put a value in
an inode or keep it 'inline'. In kernel implementation this depends on
current placement of entries.

To close the behavioral gap, ext2fs_xattr_set() now takes over the
decision about where to place ea values. This also allows it to raise
errors early instead of delaying them to a separate
ext2fs_xattrs_write() call later.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 contrib/android/perms.c  |   6 -
 debugfs/xattrs.c         |  11 -
 e2fsck/pass4.c           |  20 +-
 lib/ext2fs/ext2fs.h      |   2 +
 lib/ext2fs/ext_attr.c    | 659 +++++++++++++++++++++++++++++++++++------------
 lib/ext2fs/inline_data.c |  10 -
 misc/fuse2fs.c           |  17 --
 7 files changed, 499 insertions(+), 226 deletions(-)

diff --git a/contrib/android/perms.c b/contrib/android/perms.c
index 9a7a93f5564b..08fb861486bf 100644
--- a/contrib/android/perms.c
+++ b/contrib/android/perms.c
@@ -48,12 +48,6 @@ static errcode_t ino_add_xattr(ext2_filsys fs, ext2_ino_t ino, const char *name,
 			_("while setting xattrs of inode %u"), ino);
 		goto xattrs_close;
 	}
-	retval = ext2fs_xattrs_write(xhandle);
-	if (retval) {
-		com_err(__func__, retval,
-			_("while writting xattrs of inode %u"), ino);
-		goto xattrs_close;
-	}
 xattrs_close:
 	close_retval = ext2fs_xattrs_close(&xhandle);
 	if (close_retval) {
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index 9b87d14551dc..fdb76e41a230 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -306,13 +306,6 @@ void do_set_xattr(int argc, char **argv)
 	}
 
 	err = ext2fs_xattr_set(h, argv[optind + 1], buf, buflen);
-	if (err)
-		goto out;
-
-	err = ext2fs_xattrs_write(h);
-	if (err)
-		goto out;
-
 out:
 	ext2fs_xattrs_close(&h);
 	if (err)
@@ -360,10 +353,6 @@ void do_rm_xattr(int argc, char **argv)
 		if (err)
 			goto out;
 	}
-
-	err = ext2fs_xattrs_write(h);
-	if (err)
-		goto out;
 out:
 	ext2fs_xattrs_close(&h);
 	if (err)
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 663f87ab59c0..4125c53b1b97 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -87,22 +87,6 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 	return 0;
 }
 
-/*
- * Get/set ref functions below could later be moved to somewhere in lib/ext2fs/.
- * Currently the only user is e2fsck so we rather not expose it in common
- * library until there are more users.
- */
-static __u64 ea_inode_get_ref(struct ext2_inode_large *inode)
-{
-	return ((__u64)inode->i_ctime << 32) | inode->osd1.linux1.l_i_version;
-}
-
-static void ea_inode_set_ref(struct ext2_inode_large *inode, __u64 ref_count)
-{
-	inode->i_ctime = (__u32)(ref_count >> 32);
-	inode->osd1.linux1.l_i_version = (__u32)ref_count;
-}
-
 static void check_ea_inode(e2fsck_t ctx, ext2_ino_t i,
 			   struct ext2_inode_large *inode, __u16 *link_counted)
 {
@@ -140,7 +124,7 @@ static void check_ea_inode(e2fsck_t ctx, ext2_ino_t i,
 	 */
 	*link_counted = 1;
 
-	ref_count = ea_inode_get_ref(inode);
+	ref_count = ext2fs_get_ea_inode_ref(EXT2_INODE(inode));
 
 	/* Old Lustre-style xattr inodes do not have a stored refcount.
 	 * However, their i_ctime and i_atime should be the same.
@@ -153,7 +137,7 @@ static void check_ea_inode(e2fsck_t ctx, ext2_ino_t i,
 		pctx.num = ref_count;
 		pctx.num2 = actual_refs;
 		if (fix_problem(ctx, PR_4_EA_INODE_REF_COUNT, &pctx)) {
-			ea_inode_set_ref(inode, actual_refs);
+			ext2fs_set_ea_inode_ref(EXT2_INODE(inode), actual_refs);
 			e2fsck_write_inode(ctx, i, EXT2_INODE(inode), "pass4");
 		}
 	}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b734f1aa2d5b..a2c8edaa4ac2 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1251,6 +1251,8 @@ extern void ext2fs_ext_attr_block_rehash(struct ext2_ext_attr_header *header,
 					 struct ext2_ext_attr_entry *end);
 extern __u32 ext2fs_get_ea_inode_hash(struct ext2_inode *inode);
 extern void ext2fs_set_ea_inode_hash(struct ext2_inode *inode, __u32 hash);
+extern __u64 ext2fs_get_ea_inode_ref(struct ext2_inode *inode);
+extern void ext2fs_set_ea_inode_ref(struct ext2_inode *inode, __u64 ref_count);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 00ff79ae3890..7cecb16885aa 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -139,6 +139,17 @@ void ext2fs_set_ea_inode_hash(struct ext2_inode *inode, __u32 hash)
 	inode->i_atime = hash;
 }
 
+__u64 ext2fs_get_ea_inode_ref(struct ext2_inode *inode)
+{
+	return ((__u64)inode->i_ctime << 32) | inode->osd1.linux1.l_i_version;
+}
+
+void ext2fs_set_ea_inode_ref(struct ext2_inode *inode, __u64 ref_count)
+{
+	inode->i_ctime = (__u32)(ref_count >> 32);
+	inode->osd1.linux1.l_i_version = (__u32)ref_count;
+}
+
 static errcode_t check_ext_attr_header(struct ext2_ext_attr_header *header)
 {
 	if ((header->h_magic != EXT2_EXT_ATTR_MAGIC_v1 &&
@@ -284,17 +295,19 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 struct ext2_xattr {
 	char *name;
 	void *value;
-	size_t value_len;
+	unsigned int value_len;
+	ext2_ino_t ea_ino;
 };
 
 struct ext2_xattr_handle {
 	errcode_t magic;
 	ext2_filsys fs;
 	struct ext2_xattr *attrs;
-	size_t capacity, count;
+	int capacity;
+	int count;
+	int ibody_count;
 	ext2_ino_t ino;
 	unsigned int flags;
-	int dirty;
 };
 
 static errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
@@ -333,40 +346,6 @@ static struct ea_name_index ea_names[] = {
 	{0, NULL},
 };
 
-static int find_ea_index(char *fullname, char **name, int *index);
-
-/* Pull inlinedata to the front. */
-static int attr_compare(const void *a, const void *b)
-{
-	const struct ext2_xattr *xa = a, *xb = b;
-	char *xa_suffix, *xb_suffix;
-	int xa_idx, xb_idx;
-	int cmp;
-
-	if (!strcmp(xa->name, "system.data"))
-		return -1;
-	else if (!strcmp(xb->name, "system.data"))
-		return +1;
-
-	/*
-	 * Duplicate the kernel's sorting algorithm because xattr blocks
-	 * require sorted keys.
-	 */
-	xa_suffix = xa->name;
-	xb_suffix = xb->name;
-	xa_idx = xb_idx = 0;
-	find_ea_index(xa->name, &xa_suffix, &xa_idx);
-	find_ea_index(xb->name, &xb_suffix, &xb_idx);
-	cmp = xa_idx - xb_idx;
-	if (cmp)
-		return cmp;
-	cmp = strlen(xa_suffix) - strlen(xb_suffix);
-	if (cmp)
-		return cmp;
-	cmp = strcmp(xa_suffix, xb_suffix);
-	return cmp;
-}
-
 static const char *find_ea_prefix(int index)
 {
 	struct ea_name_index *e;
@@ -378,7 +357,7 @@ static const char *find_ea_prefix(int index)
 	return NULL;
 }
 
-static int find_ea_index(char *fullname, char **name, int *index)
+static int find_ea_index(const char *fullname, char **name, int *index)
 {
 	struct ea_name_index *e;
 
@@ -654,24 +633,21 @@ static errcode_t convert_disk_buffer_to_posix_acl(const void *value, size_t size
 	return 0;
 }
 
-
-static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
-					struct ext2_xattr **pos,
-					void *entries_start,
-					unsigned int storage_size,
-					unsigned int value_offset_correction,
-					int write_hash)
+static errcode_t
+write_xattrs_to_buffer(ext2_filsys fs, struct ext2_xattr *attrs, int count,
+		       void *entries_start, unsigned int storage_size,
+		       unsigned int value_offset_correction, int write_hash)
 {
-	struct ext2_xattr *x = *pos;
+	struct ext2_xattr *x;
 	struct ext2_ext_attr_entry *e = entries_start;
-	char *end = (char *) entries_start + storage_size;
+	void *end = entries_start + storage_size;
 	char *shortname;
 	unsigned int entry_size, value_size;
 	int idx, ret;
+	errcode_t err;
 
 	memset(entries_start, 0, storage_size);
-	/* For all remaining x...  */
-	for (; x < handle->attrs + handle->count; x++) {
+	for (x = attrs; x < attrs + count; x++) {
 		/* Calculate index and shortname position */
 		shortname = x->name;
 		ret = find_ea_index(x->name, &shortname, &idx);
@@ -683,43 +659,43 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 		value_size = ((x->value_len + EXT2_EXT_ATTR_PAD - 1) /
 			      EXT2_EXT_ATTR_PAD) * EXT2_EXT_ATTR_PAD;
 
-		/*
-		 * Would entry collide with value?
-		 * Note that we must leave sufficient room for a (u32)0 to
-		 * mark the end of the entries.
-		 */
-		if ((char *)e + entry_size + sizeof(__u32) > end - value_size)
-			break;
-
 		/* Fill out e appropriately */
 		e->e_name_len = strlen(shortname);
 		e->e_name_index = (ret ? idx : 0);
-		e->e_value_offs = end - value_size - (char *)entries_start +
-				value_offset_correction;
-		e->e_value_inum = 0;
+
 		e->e_value_size = x->value_len;
+		e->e_value_inum = x->ea_ino;
 
-		/* Store name and value */
-		end -= value_size;
+		/* Store name */
 		memcpy((char *)e + sizeof(*e), shortname, e->e_name_len);
-		memcpy(end, x->value, e->e_value_size);
+		if (x->ea_ino) {
+			e->e_value_offs = 0;
+		} else {
+			end -= value_size;
+			e->e_value_offs = end - entries_start +
+							value_offset_correction;
+			memcpy(end, x->value, e->e_value_size);
+		}
 
-		if (write_hash)
-			e->e_hash = ext2fs_ext_attr_hash_entry(e, end);
-		else
+		if (write_hash || x->ea_ino) {
+			err = ext2fs_ext_attr_hash_entry2(fs, e,
+							  x->ea_ino ? 0 : end,
+							  &e->e_hash);
+			if (err)
+				return err;
+		} else
 			e->e_hash = 0;
 
 		e = EXT2_EXT_ATTR_NEXT(e);
 		*(__u32 *)e = 0;
 	}
-	*pos = x;
-
 	return 0;
 }
 
 errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 {
-	struct ext2_xattr *x;
+	ext2_filsys fs = handle->fs;
+	const int inode_size = EXT2_INODE_SIZE(fs->super);
 	struct ext2_inode_large *inode;
 	char *start, *block_buf = NULL;
 	struct ext2_ext_attr_header *header;
@@ -730,24 +706,23 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	errcode_t err;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
-	i = EXT2_INODE_SIZE(handle->fs->super);
+	i = inode_size;
 	if (i < sizeof(*inode))
 		i = sizeof(*inode);
 	err = ext2fs_get_memzero(i, &inode);
 	if (err)
 		return err;
 
-	err = ext2fs_read_inode_full(handle->fs, handle->ino,
-				     (struct ext2_inode *)inode,
-				     EXT2_INODE_SIZE(handle->fs->super));
+	err = ext2fs_read_inode_full(fs, handle->ino, EXT2_INODE(inode),
+				     inode_size);
 	if (err)
 		goto out;
 
 	/* If extra_isize isn't set, we need to set it now */
 	if (inode->i_extra_isize == 0 &&
-	    EXT2_INODE_SIZE(handle->fs->super) > EXT2_GOOD_OLD_INODE_SIZE) {
+	    inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
 		char *p = (char *)inode;
-		size_t extra = handle->fs->super->s_want_extra_isize;
+		size_t extra = fs->super->s_want_extra_isize;
 
 		if (extra == 0)
 			extra = sizeof(__u32);
@@ -759,55 +734,45 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		goto out;
 	}
 
-	/* Force the inlinedata attr to the front. */
-	x = handle->attrs;
-	qsort(x, handle->count, sizeof(struct ext2_xattr), attr_compare);
-
 	/* Does the inode have space for EA? */
 	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
-	    EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
-						  inode->i_extra_isize +
-						  sizeof(__u32))
+	    inode_size <= EXT2_GOOD_OLD_INODE_SIZE + inode->i_extra_isize +
+								sizeof(__u32))
 		goto write_ea_block;
 
 	/* Write the inode EA */
 	ea_inode_magic = EXT2_EXT_ATTR_MAGIC;
 	memcpy(((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 	       inode->i_extra_isize, &ea_inode_magic, sizeof(__u32));
-	storage_size = EXT2_INODE_SIZE(handle->fs->super) -
-		EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize -
-		sizeof(__u32);
+	storage_size = inode_size - EXT2_GOOD_OLD_INODE_SIZE -
+				inode->i_extra_isize - sizeof(__u32);
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
-		inode->i_extra_isize + sizeof(__u32);
+				inode->i_extra_isize + sizeof(__u32);
 
-	err = write_xattrs_to_buffer(handle, &x, start, storage_size, 0, 0);
+	err = write_xattrs_to_buffer(fs, handle->attrs, handle->ibody_count,
+				     start, storage_size, 0, 0);
 	if (err)
 		goto out;
-
 write_ea_block:
 	/* Are we done? */
-	if (x >= handle->attrs + handle->count)
+	if (handle->ibody_count == handle->count &&
+	    !ext2fs_file_acl_block(fs, EXT2_INODE(inode)))
 		goto skip_ea_block;
 
 	/* Write the EA block */
-	err = ext2fs_get_memzero(handle->fs->blocksize, &block_buf);
+	err = ext2fs_get_memzero(fs->blocksize, &block_buf);
 	if (err)
 		goto out;
 
-	storage_size = handle->fs->blocksize -
-		sizeof(struct ext2_ext_attr_header);
+	storage_size = fs->blocksize - sizeof(struct ext2_ext_attr_header);
 	start = block_buf + sizeof(struct ext2_ext_attr_header);
 
-	err = write_xattrs_to_buffer(handle, &x, start, storage_size,
-				     start - block_buf, 1);
+	err = write_xattrs_to_buffer(fs, handle->attrs + handle->ibody_count,
+				     handle->count - handle->ibody_count, start,
+				     storage_size, start - block_buf, 1);
 	if (err)
 		goto out2;
 
-	if (x < handle->attrs + handle->count) {
-		err = EXT2_ET_EA_NO_SPACE;
-		goto out2;
-	}
-
 	/* Write a header on the EA block */
 	header = (struct ext2_ext_attr_header *) block_buf;
 	header->h_magic = EXT2_EXT_ATTR_MAGIC;
@@ -815,31 +780,28 @@ write_ea_block:
 	header->h_blocks = 1;
 
 	/* Get a new block for writing */
-	err = prep_ea_block_for_write(handle->fs, handle->ino, inode);
+	err = prep_ea_block_for_write(fs, handle->ino, inode);
 	if (err)
 		goto out2;
 
 	/* Finally, write the new EA block */
-	blk = ext2fs_file_acl_block(handle->fs,
-				    (struct ext2_inode *)inode);
-	err = ext2fs_write_ext_attr3(handle->fs, blk, block_buf,
-				     handle->ino);
+	blk = ext2fs_file_acl_block(fs, EXT2_INODE(inode));
+	err = ext2fs_write_ext_attr3(fs, blk, block_buf, handle->ino);
 	if (err)
 		goto out2;
 
 skip_ea_block:
-	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
+	blk = ext2fs_file_acl_block(fs, (struct ext2_inode *)inode);
 	if (!block_buf && blk) {
 		/* xattrs shrunk, free the block */
-		err = ext2fs_free_ext_attr(handle->fs, handle->ino, inode);
+		err = ext2fs_free_ext_attr(fs, handle->ino, inode);
 		if (err)
 			goto out;
 	}
 
 	/* Write the inode */
-	err = ext2fs_write_inode_full(handle->fs, handle->ino,
-				      (struct ext2_inode *)inode,
-				      EXT2_INODE_SIZE(handle->fs->super));
+	err = ext2fs_write_inode_full(fs, handle->ino, EXT2_INODE(inode),
+				      inode_size);
 	if (err)
 		goto out2;
 
@@ -847,7 +809,6 @@ out2:
 	ext2fs_free_mem(&block_buf);
 out:
 	ext2fs_free_mem(&inode);
-	handle->dirty = 0;
 	return err;
 }
 
@@ -970,6 +931,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 				return err;
 		}
 
+		x->ea_ino = entry->e_value_inum;
 		x->value_len = entry->e_value_size;
 
 		/* e_hash may be 0 in older inode's ea */
@@ -1018,6 +980,7 @@ static void xattrs_free_keys(struct ext2_xattr_handle *h)
 			ext2fs_free_mem(&a[i].value);
 	}
 	h->count = 0;
+	h->ibody_count = 0;
 }
 
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
@@ -1073,6 +1036,8 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 					storage_size, start);
 		if (err)
 			goto out;
+
+		handle->ibody_count = handle->count;
 	}
 
 read_ea_block:
@@ -1131,17 +1096,20 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				void *data)
 {
 	struct ext2_xattr *x;
+	int dirty = 0;
 	int ret;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 	for (x = h->attrs; x < h->attrs + h->count; x++) {
 		ret = func(x->name, x->value, x->value_len, data);
 		if (ret & XATTR_CHANGED)
-			h->dirty = 1;
+			dirty = 1;
 		if (ret & XATTR_ABORT)
-			return 0;
+			break;
 	}
 
+	if (dirty)
+		return ext2fs_xattrs_write(h);
 	return 0;
 }
 
@@ -1237,66 +1205,433 @@ out:
 	return err;
 }
 
-errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
-			   const char *key,
+static errcode_t xattr_create_ea_inode(ext2_filsys fs, const void *value,
+				       size_t value_len, ext2_ino_t *ea_ino)
+{
+	struct ext2_inode inode;
+	ext2_ino_t ino;
+	ext2_file_t file;
+	__u32 hash;
+	errcode_t ret;
+
+	ret = ext2fs_new_inode(fs, 0, 0, 0, &ino);
+	if (ret)
+		return ret;
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_flags |= EXT4_EA_INODE_FL;
+	if (ext2fs_has_feature_extents(fs->super))
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	inode.i_size = 0;
+	inode.i_mode = LINUX_S_IFREG | 0600;
+	inode.i_links_count = 1;
+	ret = ext2fs_write_new_inode(fs, ino, &inode);
+	if (ret)
+		return ret;
+	/*
+	 * ref_count and hash utilize inode's i_*time fields.
+	 * ext2fs_write_new_inode() call above initializes these fields with
+	 * current time. That's why ref count and hash updates are done
+	 * separately below.
+	 */
+	ext2fs_set_ea_inode_ref(&inode, 1);
+	hash = ext2fs_crc32c_le(fs->csum_seed, value, value_len);
+	ext2fs_set_ea_inode_hash(&inode, hash);
+
+	ret = ext2fs_write_inode(fs, ino, &inode);
+	if (ret)
+		return ret;
+
+	ret = ext2fs_file_open(fs, ino, EXT2_FILE_WRITE, &file);
+	if (ret)
+		return ret;
+	ret = ext2fs_file_write(file, value, value_len, NULL);
+	ext2fs_file_close(file);
+	if (ret)
+		return ret;
+
+	ext2fs_inode_alloc_stats2(fs, ino, 1 /* inuse */, 0 /* isdir */);
+
+	*ea_ino = ino;
+	return 0;
+}
+
+static errcode_t xattr_inode_dec_ref(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode_large inode;
+	__u64 ref_count;
+	errcode_t ret;
+
+	ret = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (ret)
+		goto out;
+
+	ref_count = ext2fs_get_ea_inode_ref(EXT2_INODE(&inode));
+	ref_count--;
+	ext2fs_set_ea_inode_ref(EXT2_INODE(&inode), ref_count);
+
+	if (ref_count)
+		goto write_out;
+
+	inode.i_links_count = 0;
+	inode.i_dtime = fs->now ? fs->now : time(0);
+
+	ret = ext2fs_free_ext_attr(fs, ino, &inode);
+	if (ret)
+		goto write_out;
+
+	if (ext2fs_inode_has_valid_blocks2(fs, (struct ext2_inode *)&inode)) {
+		ret = ext2fs_punch(fs, ino, (struct ext2_inode *)&inode, NULL,
+				   0, ~0ULL);
+		if (ret)
+			goto out;
+	}
+
+	ext2fs_inode_alloc_stats2(fs, ino, -1 /* inuse */, 0 /* is_dir */);
+
+write_out:
+	ret = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+out:
+	return ret;
+}
+
+static errcode_t xattr_update_entry(ext2_filsys fs, struct ext2_xattr *x,
+				    const char *name, const void *value,
+				    size_t value_len, int in_inode)
+{
+	ext2_ino_t ea_ino = 0;
+	void *new_value = NULL;
+	char *new_name = NULL;
+	int name_len;
+	errcode_t ret;
+
+	if (!x->name) {
+		name_len = strlen(name);
+		ret = ext2fs_get_mem(name_len + 1, &new_name);
+		if (ret)
+			goto fail;
+		memcpy(new_name, name, name_len + 1);
+	}
+
+	ret = ext2fs_get_mem(value_len, &new_value);
+	if (ret)
+		goto fail;
+	memcpy(new_value, value, value_len);
+
+	if (in_inode) {
+		ret = xattr_create_ea_inode(fs, value, value_len, &ea_ino);
+		if (ret)
+			goto fail;
+	}
+
+	if (x->ea_ino) {
+		ret = xattr_inode_dec_ref(fs, x->ea_ino);
+		if (ret)
+			goto fail;
+	}
+
+	if (!x->name)
+		x->name = new_name;
+	
+	if (x->value)
+		ext2fs_free_mem(&x->value);
+	x->value = new_value;
+	x->value_len = value_len;
+	x->ea_ino = ea_ino;
+	return 0;
+fail:
+	if (new_name)
+		ext2fs_free_mem(&new_name);
+	if (new_value)
+		ext2fs_free_mem(&new_value);
+	if (ea_ino)
+		xattr_inode_dec_ref(fs, ea_ino);
+	return ret;
+}
+
+static int xattr_find_position(struct ext2_xattr *attrs, int count, const char *name)
+{
+	struct ext2_xattr *x;
+	int i;
+	char *shortname, *x_shortname;
+	int name_idx, x_name_idx;
+	int shortname_len, x_shortname_len;
+
+	find_ea_index(name, &shortname, &name_idx);
+	shortname_len = strlen(shortname);
+
+	for (i = 0, x = attrs; i < count; i++, x++) {
+		find_ea_index(x->name, &x_shortname, &x_name_idx);
+		if (name_idx < x_name_idx)
+			break;
+		if (name_idx > x_name_idx)
+			continue;
+
+		x_shortname_len = strlen(x_shortname);
+		if (shortname_len < x_shortname_len)
+			break;
+		if (shortname_len > x_shortname_len)
+			continue;
+
+		if (memcmp(shortname, x_shortname, shortname_len) <= 0)
+			break;
+	}
+	return i;
+}
+
+errcode_t xattr_array_update(struct ext2_xattr_handle *h, const char *name,
+			const void *value, size_t value_len, int ibody_free,
+			int block_free, int old_idx, int in_inode)
+{
+	struct ext2_xattr tmp;
+	int add_to_ibody;
+	int needed;
+	int name_len, name_idx;
+	char *shortname;
+	int new_idx;
+	int ret;
+
+	find_ea_index(name, &shortname, &name_idx);
+	name_len = strlen(shortname);
+
+	needed = EXT2_EXT_ATTR_LEN(name_len);
+	if (!in_inode)
+		needed += EXT2_EXT_ATTR_SIZE(value_len);
+
+	if (0 <= old_idx && old_idx < h->ibody_count) {
+		ibody_free += EXT2_EXT_ATTR_LEN(name_len);
+		if (!h->attrs[old_idx].ea_ino)
+			ibody_free += EXT2_EXT_ATTR_SIZE(
+						h->attrs[old_idx].value_len);
+	}
+
+	if (needed <= ibody_free) {
+		if (0 <= old_idx) {
+			/* Update the existing entry. */
+			ret = xattr_update_entry(h->fs, &h->attrs[old_idx],
+						 name, value, value_len,
+						 in_inode);
+			if (ret)
+				return ret;
+			if (h->ibody_count <= old_idx) {
+				/* Move entry from block to the end of ibody. */
+				tmp = h->attrs[old_idx];
+				memmove(h->attrs + h->ibody_count + 1,
+					h->attrs + h->ibody_count,
+					(old_idx - h->ibody_count)
+							* sizeof(*h->attrs));
+				h->attrs[h->ibody_count] = tmp;
+				h->ibody_count++;
+			}
+			return 0;
+		} else {
+			new_idx = h->ibody_count;
+			add_to_ibody = 1;
+			goto add_new;
+		}
+	}
+
+	if (h->ibody_count <= old_idx) {
+		block_free += EXT2_EXT_ATTR_LEN(name_len);
+		if (!h->attrs[old_idx].ea_ino)
+			block_free += EXT2_EXT_ATTR_SIZE(
+						h->attrs[old_idx].value_len);
+	}
+
+	if (needed <= block_free) {
+		if (0 <= old_idx) {
+			/* Update the existing entry. */
+			ret = xattr_update_entry(h->fs, &h->attrs[old_idx],
+						 name, value, value_len,
+						 in_inode);
+			if (ret)
+				return ret;
+			if (old_idx < h->ibody_count) {
+				/*
+				 * Move entry from ibody to the block. Note that
+				 * entries in the block are sorted.
+				 */
+				new_idx = xattr_find_position(
+						h->attrs + h->ibody_count,
+						h->count - h->ibody_count,
+						name);
+				new_idx += h->ibody_count - 1;
+				tmp = h->attrs[old_idx];
+				memmove(h->attrs + old_idx,
+					h->attrs + old_idx + 1,
+					(new_idx - old_idx)*sizeof(*h->attrs));
+				h->attrs[new_idx] = tmp;
+				h->ibody_count--;
+			}
+			return 0;
+		} else {
+			new_idx = xattr_find_position(h->attrs + h->ibody_count,
+						      h->count - h->ibody_count,
+						      name);
+			new_idx += h->ibody_count;
+			add_to_ibody = 0;
+			goto add_new;
+		}
+	}
+
+	return EXT2_ET_EA_NO_SPACE;
+
+add_new:
+	if (h->count == h->capacity) {
+		ret = ext2fs_xattrs_expand(h, 4);
+		if (ret)
+			return ret;
+	}
+
+	ret = xattr_update_entry(h->fs, &h->attrs[h->count], name, value,
+				 value_len, in_inode);
+	if (ret)
+		return ret;
+
+	tmp = h->attrs[h->count];
+	memmove(h->attrs + new_idx + 1, h->attrs + new_idx,
+		(h->count - new_idx)*sizeof(*h->attrs));
+	h->attrs[new_idx] = tmp;
+	if (add_to_ibody)
+		h->ibody_count++;
+	h->count++;
+	return 0;
+}
+
+int space_used(struct ext2_xattr *attrs, int count)
+{
+	int total = 0;
+	struct ext2_xattr *x;
+	char *shortname;
+	int i, len, name_idx;
+
+	for (i = 0, x = attrs; i < count; i++, x++) {
+		find_ea_index(x->name, &shortname, &name_idx);
+		len = strlen(shortname);
+		total += EXT2_EXT_ATTR_LEN(len);
+		if (!x->ea_ino)
+			total += EXT2_EXT_ATTR_SIZE(x->value_len);
+	}
+	return total;
+}
+
+/*
+ * The minimum size of EA value when you start storing it in an external inode
+ * size of block - size of header - size of 1 entry - 4 null bytes
+*/
+#define EXT4_XATTR_MIN_LARGE_EA_SIZE(b)	\
+	((b) - EXT2_EXT_ATTR_LEN(3) - sizeof(struct ext2_ext_attr_header) - 4)
+
+errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
+			   const char *name,
 			   const void *value,
 			   size_t value_len)
 {
+	ext2_filsys fs = h->fs;
+	const int inode_size = EXT2_INODE_SIZE(fs->super);
+	struct ext2_inode_large *inode = NULL;
 	struct ext2_xattr *x;
 	char *new_value;
-	errcode_t err;
+	int ibody_free, block_free;
+	int in_inode = 0;
+	int old_idx = -1;
+	int extra_isize;
+	errcode_t ret;
 
-	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
+	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 
-	err = ext2fs_get_mem(value_len, &new_value);
-	if (err)
-		return err;
-	if (!(handle->flags & XATTR_HANDLE_FLAG_RAW) &&
-	    ((strcmp(key, "system.posix_acl_default") == 0) ||
-	     (strcmp(key, "system.posix_acl_access") == 0))) {
-		err = convert_posix_acl_to_disk_buffer(value, value_len,
+	ret = ext2fs_get_mem(value_len, &new_value);
+	if (ret)
+		return ret;
+	if (!(h->flags & XATTR_HANDLE_FLAG_RAW) &&
+	    ((strcmp(name, "system.posix_acl_default") == 0) ||
+	     (strcmp(name, "system.posix_acl_access") == 0))) {
+		ret = convert_posix_acl_to_disk_buffer(value, value_len,
 						       new_value, &value_len);
-		if (err)
-			goto errout;
+		if (ret)
+			goto out;
 	} else
 		memcpy(new_value, value, value_len);
 
-	for (x = handle->attrs; x < handle->attrs + handle->count; x++) {
-		/* Replace xattr */
-		if (strcmp(x->name, key) == 0) {
-			ext2fs_free_mem(&x->value);
-			x->value = new_value;
-			x->value_len = value_len;
-			handle->dirty = 1;
-			return 0;
+	/* Imitate kernel behavior by skipping update if value is the same. */
+	for (x = h->attrs; x < h->attrs + h->count; x++) {
+		if (!strcmp(x->name, name)) {
+			if (!x->ea_ino && x->value_len == value_len &&
+			    !memcmp(x->value, new_value, value_len)) {
+				ret = 0;
+				goto out;
+			}
+			old_idx = x - h->attrs;
+			break;
 		}
 	}
 
-	if (handle->count == handle->capacity) {
-		/* Expand array, append slot */
-		err = ext2fs_xattrs_expand(handle, 4);
-		if (err)
-			goto errout;
+	ret = ext2fs_get_memzero(inode_size, &inode);
+	if (ret)
+		goto out;
+	ret = ext2fs_read_inode_full(fs, h->ino,
+				     (struct ext2_inode *)inode,
+				     inode_size);
+	if (ret)
+		goto out;
+	if (inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
+		extra_isize = inode->i_extra_isize;
+		if (extra_isize == 0) {
+		    	extra_isize = fs->super->s_want_extra_isize;
+		    	if (extra_isize == 0)
+				extra_isize = sizeof(__u32);
+		}
+		ibody_free = inode_size - EXT2_GOOD_OLD_INODE_SIZE;
+		ibody_free -= extra_isize;
+		/* Extended attribute magic and final null entry. */
+		ibody_free -= sizeof(__u32) * 2;
+		ibody_free -= space_used(h->attrs, h->ibody_count);
+	} else
+		ibody_free = 0;
 
-		x = handle->attrs + handle->capacity - 4;
+	/* Inline data can only go to ibody. */
+	if (strcmp(name, "system.data") == 0) {
+		if (h->ibody_count <= old_idx) {
+			ret = EXT2_ET_FILESYSTEM_CORRUPTED;
+			goto out;
+		}
+		ret = xattr_array_update(h, name, value, value_len, ibody_free,
+					 0 /* block_free */, old_idx,
+					 0 /* in_inode */);
+		if (ret)
+			goto out;
+		goto write_out;
 	}
 
-	err = ext2fs_get_mem(strlen(key) + 1, &x->name);
-	if (err)
-		goto errout;
-	strcpy(x->name, key);
+	block_free = fs->blocksize;
+	block_free -= sizeof(struct ext2_ext_attr_header);
+	/* Final null entry. */
+	block_free -= sizeof(__u32);
+	block_free -= space_used(h->attrs + h->ibody_count,
+				 h->count - h->ibody_count);
+
+	if (ext2fs_has_feature_ea_inode(fs->super) &&
+	    value_len > EXT4_XATTR_MIN_LARGE_EA_SIZE(fs->blocksize))
+		in_inode = 1;
+
+	ret = xattr_array_update(h, name, value, value_len, ibody_free,
+				 block_free, old_idx, in_inode);
+	if (ret == EXT2_ET_EA_NO_SPACE && !in_inode &&
+	    ext2fs_has_feature_ea_inode(fs->super))
+		ret = xattr_array_update(h, name, value, value_len, ibody_free,
+				 block_free, old_idx, 1 /* in_inode */);
+	if (ret)
+		goto out;
 
-	err = ext2fs_get_mem(value_len, &x->value);
-	if (err)
-		goto errout;
-	memcpy(x->value, value, value_len);
-	x->value_len = value_len;
-	handle->dirty = 1;
-	handle->count++;
-	return 0;
-errout:
+write_out:
+	ret = ext2fs_xattrs_write(h);
+out:
+	if (inode)
+		ext2fs_free_mem(&inode);
 	ext2fs_free_mem(&new_value);
-	return err;
+	return ret;
 }
 
 errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
@@ -1310,11 +1645,14 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 		if (strcmp(x->name, key) == 0) {
 			ext2fs_free_mem(&x->name);
 			ext2fs_free_mem(&x->value);
-			memmove(x, x + 1, (char *)end - (char *)(x + 1));
-			memset(end, 0, sizeof(*end));
-			handle->dirty = 1;
+			if (x->ea_ino)
+				xattr_inode_dec_ref(handle->fs, x->ea_ino);
+			memmove(x, x + 1, (end - x - 1)*sizeof(*x));
+			memset(end - 1, 0, sizeof(*end));
+			if (x < handle->attrs + handle->ibody_count)
+				handle->ibody_count--;
 			handle->count--;
-			return 0;
+			return ext2fs_xattrs_write(handle);
 		}
 	}
 
@@ -1354,15 +1692,8 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 {
 	struct ext2_xattr_handle *h = *handle;
-	errcode_t err;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
-	if (h->dirty) {
-		err = ext2fs_xattrs_write(h);
-		if (err)
-			return err;
-	}
-
 	xattrs_free_keys(h);
 	ext2fs_free_mem(&h->attrs);
 	ext2fs_free_mem(handle);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index c0fc4ed1d6c7..0c1eef6c73d2 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -42,11 +42,6 @@ static errcode_t ext2fs_inline_data_ea_set(struct ext2_inline_data *data)
 
 	retval = ext2fs_xattr_set(handle, "system.data",
 				  data->ea_data, data->ea_size);
-	if (retval)
-		goto err;
-
-	retval = ext2fs_xattrs_write(handle);
-
 err:
 	(void) ext2fs_xattrs_close(&handle);
 	return retval;
@@ -270,11 +265,6 @@ errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino)
 		goto err;
 
 	retval = ext2fs_xattr_remove(handle, "system.data");
-	if (retval)
-		goto err;
-
-	retval = ext2fs_xattrs_write(handle);
-
 err:
 	(void) ext2fs_xattrs_close(&handle);
 	return retval;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 27c94a62a18d..9435e428c823 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -2653,12 +2653,6 @@ static int op_setxattr(const char *path EXT2FS_ATTR((unused)),
 		goto out3;
 	}
 
-	err = ext2fs_xattrs_write(h);
-	if (err) {
-		ret = translate_error(fs, ino, err);
-		goto out3;
-	}
-
 	ret = update_ctime(fs, ino, NULL);
 out3:
 	if (cvalue != value)
@@ -2725,12 +2719,6 @@ static int op_removexattr(const char *path, const char *key)
 		goto out2;
 	}
 
-	err = ext2fs_xattrs_write(h);
-	if (err) {
-		ret = translate_error(fs, ino, err);
-		goto out2;
-	}
