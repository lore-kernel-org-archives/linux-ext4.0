From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 2/4] libext2fs: rename ext2_xattr_handle->length to capacity
Date: Fri,  7 Jul 2017 05:12:44 -0700
Message-ID: <20170707121246.6159-2-tahsin@google.com>
References: <20170707121246.6159-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35804 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdGGMMx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jul 2017 08:12:53 -0400
Received: by mail-pf0-f171.google.com with SMTP id c73so16416766pfk.2
        for <linux-ext4@vger.kernel.org>; Fri, 07 Jul 2017 05:12:52 -0700 (PDT)
In-Reply-To: <20170707121246.6159-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_xattr_handle has two fields 'count' and 'length' which
represent number of filled elements vs total element count.
They have close meanings so are easy to confuse, thus make code less
readable. Rename length to capacity.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/ext2fs/ext_attr.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 4357bdd0caae..2e9fc96d114d 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -291,7 +291,7 @@ struct ext2_xattr_handle {
 	errcode_t magic;
 	ext2_filsys fs;
 	struct ext2_xattr *attrs;
-	size_t length, count;
+	size_t capacity, count;
 	ext2_ino_t ino;
 	unsigned int flags;
 	int dirty;
@@ -303,14 +303,14 @@ static errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
 	struct ext2_xattr *new_attrs;
 	errcode_t err;
 
-	err = ext2fs_get_arrayzero(h->length + expandby,
+	err = ext2fs_get_arrayzero(h->capacity + expandby,
 				   sizeof(struct ext2_xattr), &new_attrs);
 	if (err)
 		return err;
 
-	memcpy(new_attrs, h->attrs, h->length * sizeof(struct ext2_xattr));
+	memcpy(new_attrs, h->attrs, h->capacity * sizeof(struct ext2_xattr));
 	ext2fs_free_mem(&h->attrs);
-	h->length += expandby;
+	h->capacity += expandby;
 	h->attrs = new_attrs;
 
 	return 0;
@@ -675,7 +675,7 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 
 	memset(entries_start, 0, storage_size);
 	/* For all remaining x...  */
-	for (; x < handle->attrs + handle->length; x++) {
+	for (; x < handle->attrs + handle->capacity; x++) {
 		if (!x->name)
 			continue;
 
@@ -771,7 +771,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	 * to the end.
 	 */
 	x = handle->attrs;
-	qsort(x, handle->length, sizeof(struct ext2_xattr), attr_compare);
+	qsort(x, handle->capacity, sizeof(struct ext2_xattr), attr_compare);
 
 	/* Does the inode have space for EA? */
 	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
@@ -813,7 +813,7 @@ write_ea_block:
 	if (err)
 		goto out2;
 
-	if (x < handle->attrs + handle->length) {
+	if (x < handle->attrs + handle->capacity) {
 		err = EXT2_ET_EA_NO_SPACE;
 		goto out2;
 	}
@@ -904,11 +904,11 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
 
 		/* Allocate space for more attrs? */
-		if (x == handle->attrs + handle->length) {
+		if (x == handle->attrs + handle->capacity) {
 			err = ext2fs_xattrs_expand(handle, 4);
 			if (err)
 				return err;
-			x = handle->attrs + handle->length - 4;
+			x = handle->attrs + handle->capacity - 4;
 		}
 
 		/* header eats this space */
@@ -1026,7 +1026,7 @@ static void xattrs_free_keys(struct ext2_xattr_handle *h)
 	struct ext2_xattr *a = h->attrs;
 	size_t i;
 
-	for (i = 0; i < h->length; i++) {
+	for (i = 0; i < h->capacity; i++) {
 		if (a[i].name)
 			ext2fs_free_mem(&a[i].name);
 		if (a[i].value)
@@ -1149,7 +1149,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 	int ret;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = h->attrs; x < h->attrs + h->length; x++) {
+	for (x = h->attrs; x < h->attrs + h->capacity; x++) {
 		if (!x->name)
 			continue;
 
@@ -1171,7 +1171,7 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 	errcode_t err;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = h->attrs; x < h->attrs + h->length; x++) {
+	for (x = h->attrs; x < h->attrs + h->capacity; x++) {
 		if (!x->name || strcmp(x->name, key))
 			continue;
 
@@ -1280,7 +1280,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	} else
 		memcpy(new_value, value, value_len);
 
-	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
+	for (x = handle->attrs; x < handle->attrs + handle->capacity; x++) {
 		if (!x->name) {
 			last_empty = x;
 			continue;
@@ -1314,7 +1314,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	if (err)
 		goto errout;
 
-	x = handle->attrs + handle->length - 4;
+	x = handle->attrs + handle->capacity - 4;
 	err = ext2fs_get_mem(strlen(key) + 1, &x->name);
 	if (err)
 		goto errout;
@@ -1339,7 +1339,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 	struct ext2_xattr *x;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
-	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
+	for (x = handle->attrs; x < handle->attrs + handle->capacity; x++) {
 		if (!x->name)
 			continue;
 
@@ -1372,8 +1372,8 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 		return err;
 
 	h->magic = EXT2_ET_MAGIC_EA_HANDLE;
-	h->length = 4;
-	err = ext2fs_get_arrayzero(h->length, sizeof(struct ext2_xattr),
+	h->capacity = 4;
+	err = ext2fs_get_arrayzero(h->capacity, sizeof(struct ext2_xattr),
 				   &h->attrs);
 	if (err) {
 		ext2fs_free_mem(&h);
-- 
2.13.2.725.g09c95d1e9-goog
