From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 03/28] libext2fs: extend xattr api to query number of attrs
Date: Tue,  3 Dec 2013 20:11:30 +0800
Message-ID: <1386072715-9869-4-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62417 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3LCMJP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:15 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so2873282pab.34
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:15 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Add another API to query the number of extended attributes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h   |    1 +
 lib/ext2fs/ext_attr.c |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 57db793..e251435 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1168,6 +1168,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
 errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 			       struct ext2_inode_large *inode);
+size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index bfe95f4..2fae516 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -197,7 +197,7 @@ struct ext2_xattr {
 struct ext2_xattr_handle {
 	ext2_filsys fs;
 	struct ext2_xattr *attrs;
-	size_t length;
+	size_t length, count;
 	ext2_ino_t ino;
 	int dirty;
 };
@@ -575,7 +575,8 @@ out:
 static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 					 struct ext2_ext_attr_entry *entries,
 					 unsigned int storage_size,
-					 void *value_start)
+					 void *value_start,
+					 size_t *nr_read)
 {
 	struct ext2_xattr *x;
 	struct ext2_ext_attr_entry *entry;
@@ -648,6 +649,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 		memcpy(x->value, value_start + entry->e_value_offs,
 		       entry->e_value_size);
 		x++;
+		(*nr_read)++;
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 
@@ -697,7 +699,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 			inode->i_extra_isize + sizeof(__u32);
 
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      start);
+					      start, &handle->count);
 		if (err)
 			goto out;
 	}
@@ -737,7 +739,7 @@ read_ea_block:
 			sizeof(struct ext2_ext_attr_header);
 		start = block_buf + sizeof(struct ext2_ext_attr_header);
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      block_buf);
+					      block_buf, &handle->count);
 		if (err)
 			goto out3;
 
@@ -848,6 +850,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 		memcpy(last_empty->value, value, value_len);
 		last_empty->value_len = value_len;
 		handle->dirty = 1;
+		handle->count++;
 		return 0;
 	}
 
@@ -868,6 +871,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	memcpy(x->value, value, value_len);
 	x->value_len = value_len;
 	handle->dirty = 1;
+	handle->count++;
 	return 0;
 }
 
@@ -886,6 +890,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			ext2fs_free_mem(&x->value);
 			x->value_len = 0;
 			handle->dirty = 1;
+			handle->count--;
 			return 0;
 		}
 	}
@@ -910,6 +915,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_free_mem(&h);
 		return err;
 	}
+	h->count = 0;
 	h->ino = ino;
 	h->fs = fs;
 	*handle = h;
@@ -940,3 +946,8 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 	ext2fs_free_mem(handle);
 	return 0;
 }
+
+size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle)
+{
+	return handle->count;
+}
-- 
1.7.9.7

