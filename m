From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 03/30] libext2fs: extend xattr api to query number of attrs
Date: Fri,  6 Dec 2013 17:57:50 +0800
Message-ID: <1386323897-2354-4-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58741 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3LFJza (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:30 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so746307pdi.38
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:29 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
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
index fa082ad..f7d623a 100644
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
@@ -579,7 +579,8 @@ out:
 static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 					 struct ext2_ext_attr_entry *entries,
 					 unsigned int storage_size,
-					 void *value_start)
+					 void *value_start,
+					 size_t *nr_read)
 {
 	struct ext2_xattr *x;
 	struct ext2_ext_attr_entry *entry;
@@ -652,6 +653,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 		memcpy(x->value, value_start + entry->e_value_offs,
 		       entry->e_value_size);
 		x++;
+		(*nr_read)++;
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 
@@ -705,7 +707,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 			inode->i_extra_isize + sizeof(__u32);
 
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      start);
+					      start, &handle->count);
 		if (err)
 			goto out;
 	}
@@ -745,7 +747,7 @@ read_ea_block:
 			sizeof(struct ext2_ext_attr_header);
 		start = block_buf + sizeof(struct ext2_ext_attr_header);
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      block_buf);
+					      block_buf, &handle->count);
 		if (err)
 			goto out3;
 
@@ -856,6 +858,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 		memcpy(last_empty->value, value, value_len);
 		last_empty->value_len = value_len;
 		handle->dirty = 1;
+		handle->count++;
 		return 0;
 	}
 
@@ -876,6 +879,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	memcpy(x->value, value, value_len);
 	x->value_len = value_len;
 	handle->dirty = 1;
+	handle->count++;
 	return 0;
 }
 
@@ -894,6 +898,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			ext2fs_free_mem(&x->value);
 			x->value_len = 0;
 			handle->dirty = 1;
+			handle->count--;
 			return 0;
 		}
 	}
@@ -918,6 +923,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_free_mem(&h);
 		return err;
 	}
+	h->count = 0;
 	h->ino = ino;
 	h->fs = fs;
 	*handle = h;
@@ -948,3 +954,8 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
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

