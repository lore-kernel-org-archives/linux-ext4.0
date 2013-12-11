From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 57/74] libext2fs: extend xattr api to query number of attrs
Date: Tue, 10 Dec 2013 17:24:39 -0800
Message-ID: <20131211012439.30655.46580.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27325 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3LKBYp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:24:45 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add another API to query the number of extended attributes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h   |    1 +
 lib/ext2fs/ext_attr.c |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9f631e6..d94fdd4 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1178,6 +1178,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
 errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 			       struct ext2_inode_large *inode);
+size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 8101c7f..772bb07 100644
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
 
@@ -696,7 +698,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 			inode->i_extra_isize + sizeof(__u32);
 
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      start);
+					      start, &handle->count);
 		if (err)
 			goto out;
 	}
@@ -736,7 +738,7 @@ read_ea_block:
 			sizeof(struct ext2_ext_attr_header);
 		start = block_buf + sizeof(struct ext2_ext_attr_header);
 		err = read_xattrs_from_buffer(handle, start, storage_size,
-					      block_buf);
+					      block_buf, &handle->count);
 		if (err)
 			goto out3;
 
@@ -845,6 +847,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 		memcpy(last_empty->value, value, value_len);
 		last_empty->value_len = value_len;
 		handle->dirty = 1;
+		handle->count++;
 		return 0;
 	}
 
@@ -865,6 +868,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 	memcpy(x->value, value, value_len);
 	x->value_len = value_len;
 	handle->dirty = 1;
+	handle->count++;
 	return 0;
 }
 
@@ -883,6 +887,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			ext2fs_free_mem(&x->value);
 			x->value_len = 0;
 			handle->dirty = 1;
+			handle->count--;
 			return 0;
 		}
 	}
@@ -913,6 +918,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_free_mem(&h);
 		return err;
 	}
+	h->count = 0;
 	h->ino = ino;
 	h->fs = fs;
 	*handle = h;
@@ -943,3 +949,8 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 	ext2fs_free_mem(handle);
 	return 0;
 }
+
+size_t ext2fs_xattrs_count(struct ext2_xattr_handle *handle)
+{
+	return handle->count;
+}

