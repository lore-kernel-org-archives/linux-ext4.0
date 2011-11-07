From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/3] ext4: remove unnecessary assignments in xattr.c
Date: Mon,  7 Nov 2011 21:32:03 +0800
Message-ID: <1320672724-4432-3-git-send-email-wenqing.lz@taobao.com>
References: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60792 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1KGNam (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 08:30:42 -0500
Received: by mail-qw0-f46.google.com with SMTP id 25so580066qao.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 05:30:42 -0800 (PST)
In-Reply-To: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In some functions, 'error' variable is assigned but not used when the result
of if statement is false.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/xattr.c |   64 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1bff752..e985864 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -214,13 +214,16 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
 
-	error = -ENODATA;
-	if (!EXT4_I(inode)->i_file_acl)
+	if (!EXT4_I(inode)->i_file_acl) {
+		error = -ENODATA;
 		goto cleanup;
+	}
 	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
-	if (!bh)
+	if (!bh) {
+		error = -ENODATA;
 		goto cleanup;
+	}
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext4_xattr_check_block(bh)) {
@@ -239,9 +242,10 @@ bad_block:
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
 	if (buffer) {
-		error = -ERANGE;
-		if (size > buffer_size)
+		if (size > buffer_size) {
+			error = -ERANGE;
 			goto cleanup;
+		}
 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
 		       size);
 	}
@@ -282,9 +286,10 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 		goto cleanup;
 	size = le32_to_cpu(entry->e_value_size);
 	if (buffer) {
-		error = -ERANGE;
-		if (size > buffer_size)
+		if (size > buffer_size) {
+			error = -ERANGE;
 			goto cleanup;
+		}
 		memcpy(buffer, (void *)IFIRST(header) +
 		       le16_to_cpu(entry->e_value_offs), size);
 	}
@@ -357,14 +362,16 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	ea_idebug(inode, "buffer=%p, buffer_size=%ld",
 		  buffer, (long)buffer_size);
 
-	error = 0;
-	if (!EXT4_I(inode)->i_file_acl)
+	if (!EXT4_I(inode)->i_file_acl) {
+		error = 0;
 		goto cleanup;
+	}
 	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
-	error = -EIO;
-	if (!bh)
+	if (!bh) {
+		error = -EIO;
 		goto cleanup;
+	}
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext4_xattr_check_block(bh)) {
@@ -653,9 +660,10 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 	if (EXT4_I(inode)->i_file_acl) {
 		/* The inode already has an extended attribute block. */
 		bs->bh = sb_bread(sb, EXT4_I(inode)->i_file_acl);
-		error = -EIO;
-		if (!bs->bh)
+		if (!bs->bh) {
+			error = -EIO;
 			goto cleanup;
+		}
 		ea_bdebug(bs->bh, "b_count=%d, refcount=%d",
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));
@@ -739,9 +747,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			}
 			ea_bdebug(bs->bh, "cloning");
 			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
-			error = -ENOMEM;
-			if (s->base == NULL)
+			if (s->base == NULL) {
+				error = -ENOMEM;
 				goto cleanup;
+			}
 			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
 			s->first = ENTRY(header(s->base)+1);
 			header(s->base)->h_refcount = cpu_to_le32(1);
@@ -752,9 +761,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		/* Allocate a buffer where we construct the new block. */
 		s->base = kzalloc(sb->s_blocksize, GFP_NOFS);
 		/* assert(header == s->base) */
-		error = -ENOMEM;
-		if (s->base == NULL)
+		if (s->base == NULL) {
+			error = -ENOMEM;
 			goto cleanup;
+		}
 		header(s->base)->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);
@@ -1006,16 +1016,19 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	if (error)
 		goto cleanup;
 	if (is.s.not_found && bs.s.not_found) {
-		error = -ENODATA;
-		if (flags & XATTR_REPLACE)
+		if (flags & XATTR_REPLACE) {
+			error = -ENODATA;
 			goto cleanup;
-		error = 0;
-		if (!value)
+		}
+		if (!value) {
+			error = 0;
 			goto cleanup;
+		}
 	} else {
-		error = -EEXIST;
-		if (flags & XATTR_CREATE)
+		if (flags & XATTR_CREATE) {
+			error = -EEXIST;
 			goto cleanup;
+		}
 	}
 	if (!value) {
 		if (!is.s.not_found)
@@ -1186,9 +1199,10 @@ retry:
 	 */
 	if (EXT4_I(inode)->i_file_acl) {
 		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
-		error = -EIO;
-		if (!bh)
+		if (!bh) {
+			error = -EIO;
 			goto cleanup;
+		}
 		if (ext4_xattr_check_block(bh)) {
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
-- 
1.7.4.1

