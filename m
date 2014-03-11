From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/49] libext2fs: support modifying arbitrary extended
 attributes (v5)
Date: Mon, 10 Mar 2014 23:54:36 -0700
Message-ID: <20140311065436.30585.53528.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaCKGyl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:41 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v5: Add magic number checking to the extended attribute editing
handle; move inline data to the head of the attribute list when
writing so that inline data ends up in the inode area; and always zero
the attribute space before writing to ensure that we can delete the
last xattr.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c         |    4 +++-
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2fs.h       |    2 +-
 lib/ext2fs/ext_attr.c     |   39 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 43 insertions(+), 5 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 9b38c08..d50bb42 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -549,6 +549,7 @@ static int dump_attr(char *name, char *value, size_t value_len, void *data)
 static void dump_inode_attributes(FILE *out, ext2_ino_t ino)
 {
 	struct ext2_xattr_handle *h;
+	size_t sz;
 	errcode_t err;
 
 	err = ext2fs_xattrs_open(current_fs, ino, &h);
@@ -559,7 +560,8 @@ static void dump_inode_attributes(FILE *out, ext2_ino_t ino)
 	if (err)
 		goto out;
 
-	if (ext2fs_xattrs_count(h) == 0)
+	err = ext2fs_xattrs_count(h, &sz);
+	if (err || sz == 0)
 		goto out;
 
 	fprintf(out, "Extended attributes:\n");
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 007103d..51c88d0 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -512,4 +512,7 @@ ec	EXT2_ET_INLINE_DATA_NO_BLOCK,
 ec	EXT2_ET_INLINE_DATA_NO_SPACE,
 	"No free space in inline data"
 
+ec	EXT2_ET_MAGIC_EA_HANDLE,
+	"Wrong magic number for extended attribute structure"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a7b6116..3756e8b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1183,7 +1183,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
 errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 			       struct ext2_inode_large *inode);
-size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle, size_t *count);
 errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 				      size_t *size);
 
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index e8dee53..308d21d 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -195,6 +195,7 @@ struct ext2_xattr {
 };
 
 struct ext2_xattr_handle {
+	errcode_t magic;
 	ext2_filsys fs;
 	struct ext2_xattr *attrs;
 	size_t length, count;
@@ -238,6 +239,24 @@ static struct ea_name_index ea_names[] = {
 	{0, NULL},
 };
 
+static void move_inline_data_to_front(struct ext2_xattr_handle *h)
+{
+	struct ext2_xattr *x;
+	struct ext2_xattr tmp;
+
+	for (x = h->attrs + 1; x < h->attrs + h->length; x++) {
+		if (!x->name)
+			continue;
+
+		if (strcmp(x->name, "system.data") == 0) {
+			memcpy(&tmp, x, sizeof(tmp));
+			memcpy(x, h->attrs, sizeof(tmp));
+			memcpy(h->attrs, &tmp, sizeof(tmp));
+			return;
+		}
+	}
+}
+
 static const char *find_ea_prefix(int index)
 {
 	struct ea_name_index *e;
@@ -412,6 +431,7 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 	unsigned int entry_size, value_size;
 	int idx, ret;
 
+	memset(entries_start, 0, storage_size);
 	/* For all remaining x...  */
 	for (; x < handle->attrs + handle->length; x++) {
 		if (!x->name)
@@ -471,6 +491,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	unsigned int i;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
 	i = EXT2_INODE_SIZE(handle->fs->super);
 	if (i < sizeof(*inode))
 		i = sizeof(*inode);
@@ -484,6 +505,8 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	move_inline_data_to_front(handle);
+
 	x = handle->attrs;
 	/* Does the inode have size for EA? */
 	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
@@ -511,7 +534,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 
 write_ea_block:
 	/* Write the EA block */
-	err = ext2fs_get_memzero(handle->fs->blocksize, &block_buf);
+	err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
 	if (err)
 		goto out;
 
@@ -590,6 +613,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 		x++;
 
 	entry = entries;
+	remain = storage_size;
 	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
@@ -682,6 +706,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	int i;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
 	i = EXT2_INODE_SIZE(handle->fs->super);
 	if (i < sizeof(*inode))
 		i = sizeof(*inode);
@@ -781,6 +806,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 	errcode_t err;
 	int ret;
 
+	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 	for (x = h->attrs; x < h->attrs + h->length; x++) {
 		if (!x->name)
 			continue;
@@ -802,6 +828,7 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 	void *val;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 	for (x = h->attrs; x < h->attrs + h->length; x++) {
 		if (!x->name)
 			continue;
@@ -893,6 +920,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	char *new_value;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
 	last_empty = NULL;
 	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
 		if (!x->name) {
@@ -958,6 +986,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 	struct ext2_xattr *x;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
 	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
 		if (!x->name)
 			continue;
@@ -991,6 +1020,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 	if (err)
 		return err;
 
+	h->magic = EXT2_ET_MAGIC_EA_HANDLE;
 	h->length = 4;
 	err = ext2fs_get_arrayzero(h->length, sizeof(struct ext2_xattr),
 				   &h->attrs);
@@ -1010,6 +1040,7 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 	struct ext2_xattr_handle *h = *handle;
 	errcode_t err;
 
+	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 	if (h->dirty) {
 		err = ext2fs_xattrs_write(h);
 		if (err)
@@ -1022,7 +1053,9 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 	return 0;
 }
 
-size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle)
+errcode_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle, size_t *count)
 {
-	return handle->count;
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
+	*count = handle->count;
+	return 0;
 }

