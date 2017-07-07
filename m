From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 3/4] libext2fs: eliminate empty element holes in ext2_xattr_handle->attrs
Date: Fri,  7 Jul 2017 05:12:45 -0700
Message-ID: <20170707121246.6159-3-tahsin@google.com>
References: <20170707121246.6159-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36512 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdGGMMz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 08:12:55 -0400
Received: by mail-pf0-f180.google.com with SMTP id q86so16374583pfl.3
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jul 2017 05:12:55 -0700 (PDT)
In-Reply-To: <20170707121246.6159-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When an extended attribute is removed, its array element is emptied.
This creates holes in the array so various places that want to walk
filled elements have to do an empty element check.

Have remove operation shift remaining filled elements to the left.
This allows a simple iteration up to ext2_xattr_handle->count to walk
all filled entries, and so empty element checks become unnecessary.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/ext2fs/ext_attr.c | 93 ++++++++++++++++-----------------------------------
 1 file changed, 29 insertions(+), 64 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 2e9fc96d114d..00ff79ae3890 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -335,7 +335,7 @@ static struct ea_name_index ea_names[] = {
 
 static int find_ea_index(char *fullname, char **name, int *index);
 
-/* Push empty attributes to the end and inlinedata to the front. */
+/* Pull inlinedata to the front. */
 static int attr_compare(const void *a, const void *b)
 {
 	const struct ext2_xattr *xa = a, *xb = b;
@@ -343,11 +343,7 @@ static int attr_compare(const void *a, const void *b)
 	int xa_idx, xb_idx;
 	int cmp;
 
-	if (xa->name == NULL)
-		return +1;
-	else if (xb->name == NULL)
-		return -1;
-	else if (!strcmp(xa->name, "system.data"))
+	if (!strcmp(xa->name, "system.data"))
 		return -1;
 	else if (!strcmp(xb->name, "system.data"))
 		return +1;
@@ -675,10 +671,7 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 
 	memset(entries_start, 0, storage_size);
 	/* For all remaining x...  */
-	for (; x < handle->attrs + handle->capacity; x++) {
-		if (!x->name)
-			continue;
-
+	for (; x < handle->attrs + handle->count; x++) {
 		/* Calculate index and shortname position */
 		shortname = x->name;
 		ret = find_ea_index(x->name, &shortname, &idx);
@@ -766,12 +759,9 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		goto out;
 	}
 
-	/*
-	 * Force the inlinedata attr to the front and the empty entries
-	 * to the end.
-	 */
+	/* Force the inlinedata attr to the front. */
 	x = handle->attrs;
-	qsort(x, handle->capacity, sizeof(struct ext2_xattr), attr_compare);
+	qsort(x, handle->count, sizeof(struct ext2_xattr), attr_compare);
 
 	/* Does the inode have space for EA? */
 	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
@@ -813,7 +803,7 @@ write_ea_block:
 	if (err)
 		goto out2;
 
-	if (x < handle->attrs + handle->capacity) {
+	if (x < handle->attrs + handle->count) {
 		err = EXT2_ET_EA_NO_SPACE;
 		goto out2;
 	}
@@ -865,8 +855,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 					 struct ext2_inode_large *inode,
 					 struct ext2_ext_attr_entry *entries,
 					 unsigned int storage_size,
-					 char *value_start,
-					 size_t *nr_read)
+					 char *value_start)
 {
 	struct ext2_xattr *x;
 	struct ext2_ext_attr_entry *entry, *end;
@@ -876,10 +865,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	unsigned int values_size = storage_size +
 			((char *)entries - value_start);
 
-	x = handle->attrs;
-	while (x->name)
-		x++;
-
 	/* find the end */
 	end = entries;
 	remain = storage_size;
@@ -904,13 +889,14 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 
 		/* Allocate space for more attrs? */
-		if (x == handle->attrs + handle->capacity) {
+		if (handle->count == handle->capacity) {
 			err = ext2fs_xattrs_expand(handle, 4);
 			if (err)
 				return err;
-			x = handle->attrs + handle->capacity - 4;
 		}
 
+		x = handle->attrs + handle->count;
+
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
 
@@ -1013,8 +999,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			}
 		}
 
-		x++;
-		(*nr_read)++;
+		handle->count++;
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 
@@ -1084,8 +1069,8 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 			inode->i_extra_isize + sizeof(__u32);
 
 		err = read_xattrs_from_buffer(handle, inode,
-			(struct ext2_ext_attr_entry *) start, storage_size,
-					      start, &handle->count);
+					(struct ext2_ext_attr_entry *) start,
+					storage_size, start);
 		if (err)
 			goto out;
 	}
@@ -1121,8 +1106,8 @@ read_ea_block:
 			sizeof(struct ext2_ext_attr_header);
 		start = block_buf + sizeof(struct ext2_ext_attr_header);
 		err = read_xattrs_from_buffer(handle, inode,
-			(struct ext2_ext_attr_entry *) start, storage_size,
-					      block_buf, &handle->count);
+					(struct ext2_ext_attr_entry *) start,
+					storage_size, block_buf);
 		if (err)
 			goto out3;
 
@@ -1149,10 +1134,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 	int ret;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = h->attrs; x < h->attrs + h->capacity; x++) {
-		if (!x->name)
-			continue;
-
+	for (x = h->attrs; x < h->attrs + h->count; x++) {
 		ret = func(x->name, x->value, x->value_len, data);
 		if (ret & XATTR_CHANGED)
 			h->dirty = 1;
@@ -1171,8 +1153,8 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 	errcode_t err;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = h->attrs; x < h->attrs + h->capacity; x++) {
-		if (!x->name || strcmp(x->name, key))
+	for (x = h->attrs; x < h->attrs + h->count; x++) {
+		if (strcmp(x->name, key))
 			continue;
 
 		if (!(h->flags & XATTR_HANDLE_FLAG_RAW) &&
@@ -1260,12 +1242,11 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 			   const void *value,
 			   size_t value_len)
 {
-	struct ext2_xattr *x, *last_empty;
+	struct ext2_xattr *x;
 	char *new_value;
 	errcode_t err;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
-	last_empty = NULL;
 
 	err = ext2fs_get_mem(value_len, &new_value);
 	if (err)
@@ -1280,12 +1261,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	} else
 		memcpy(new_value, value, value_len);
 
-	for (x = handle->attrs; x < handle->attrs + handle->capacity; x++) {
-		if (!x->name) {
-			last_empty = x;
-			continue;
-		}
-
+	for (x = handle->attrs; x < handle->attrs + handle->count; x++) {
 		/* Replace xattr */
 		if (strcmp(x->name, key) == 0) {
 			ext2fs_free_mem(&x->value);
@@ -1296,25 +1272,15 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 		}
 	}
 
-	/* Add attr to empty slot */
-	if (last_empty) {
-		err = ext2fs_get_mem(strlen(key) + 1, &last_empty->name);
+	if (handle->count == handle->capacity) {
+		/* Expand array, append slot */
+		err = ext2fs_xattrs_expand(handle, 4);
 		if (err)
 			goto errout;
-		strcpy(last_empty->name, key);
-		last_empty->value = new_value;
-		last_empty->value_len = value_len;
-		handle->dirty = 1;
-		handle->count++;
-		return 0;
-	}
 
-	/* Expand array, append slot */
-	err = ext2fs_xattrs_expand(handle, 4);
-	if (err)
-		goto errout;
+		x = handle->attrs + handle->capacity - 4;
+	}
 
-	x = handle->attrs + handle->capacity - 4;
 	err = ext2fs_get_mem(strlen(key) + 1, &x->name);
 	if (err)
 		goto errout;
@@ -1337,16 +1303,15 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			      const char *key)
 {
 	struct ext2_xattr *x;
+	struct ext2_xattr *end = handle->attrs + handle->count;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = handle->attrs; x < handle->attrs + handle->capacity; x++) {
-		if (!x->name)
-			continue;
