From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Fri, 18 Oct 2013 12:25:16 -0700
Message-ID: <20131018192516.GG19188@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3JRTZY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 15:25:24 -0400
Content-Disposition: inline
In-Reply-To: <20131018045134.7339.30673.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There were a lot of cosmetic changes in this patch since September.  I
rearranged the header file to put the constants up with the other constants,
and the functions under the correct file name.  I added a function to free a EA
block, and added in other checks to make sure that there actually is extra
space after the inode before trying to write EAs there.

This functionality is still missing posix acl <-> ext4 acl translation, but
there are many things missing for EA support, such as printing the names
properly in debugfs, any sort of e2fsck checking, inlinedata integration... all
of which will come next.  For now I prefer to work on reducing the patchbomb
size before I go adding more.

Roughly speaking, this is the diff from the 9/30 patch to yesterday's:

---
 lib/ext2fs/ext2fs.h   |   51 ++++++++++++++------------
 lib/ext2fs/ext_attr.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 121 insertions(+), 28 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 45555d6..308dc9b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -638,6 +638,13 @@ typedef struct stat ext2fs_struct_stat;
 #define EXT2_FLAG_FLUSH_NO_SYNC          1
 
 /*
+ * Modify and iterate extended attributes
+ */
+struct ext2_xattr_handle;
+#define XATTR_ABORT	1
+#define XATTR_CHANGED	2
+
+/*
  * function prototypes
  */
 static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
@@ -1161,6 +1168,27 @@ extern errcode_t ext2fs_ext_attr_find_entry(struct ext2_ext_attr_entry **pentry,
 					    size_t size, int sorted);
 extern errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
 					   struct ext2_ext_attr_search *s);
+errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
+			       unsigned int expandby);
+errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
+				int (*func)(char *name, char *value,
+					    void *data),
+				void *data);
+errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
+			   void **value, unsigned int *value_len);
+errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
+			   const char *key,
+			   const void *value,
+			   unsigned int value_len);
+errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
+			      const char *key);
+errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
+			     struct ext2_xattr_handle **handle);
+errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
+errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode_large *inode);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
@@ -1189,29 +1217,6 @@ extern errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
 				     int leaf_level, blk64_t blk);
 extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
 
-struct ext2_xattr_handle;
-errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
-			       unsigned int expandby);
-errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle);
-errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle);
-#define XATTR_ABORT	1
-#define XATTR_CHANGED	2
-errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
-				int (*func)(char *name, char *value,
-					    void *data),
-				void *data);
-errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
-			   void **value, unsigned int *value_len);
-errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
-			   const char *key,
-			   const void *value,
-			   unsigned int value_len);
-errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
-			      const char *key);
-errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_xattr_handle **handle);
-errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
-
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 				   struct ext2_inode *inode,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 876dac7..c5fd070 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -373,7 +373,6 @@ errcode_t ext2fs_ext_attr_set_entry(struct ext2_ext_attr_info *i,
 	return 0;
 }
 
-
 /* Manipulate the contents of extended attribute regions */
 struct ext2_xattr {
 	char *name;
@@ -447,6 +446,74 @@ static int find_ea_index(const char *fullname, char **name, int *index)
 	return 0;
 }
 
+errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode_large *inode)
+{
+	struct ext2_ext_attr_header *header;
+	void *block_buf = NULL;
+	dgrp_t grp;
+	blk64_t blk, goal;
+	errcode_t err;
+	struct ext2_inode_large i;
+
+	/* Read inode? */
+	if (inode == NULL) {
+		err = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&i,
+					     sizeof(struct ext2_inode_large));
+		if (err)
+			return err;
+		inode = &i;
+	}
+
+	/* Do we already have an EA block? */
+	blk = ext2fs_file_acl_block(fs, (struct ext2_inode *)inode);
+	if (blk == 0)
+		return 0;
+
+	/* Find block, zero it, write back */
+	if ((blk < fs->super->s_first_data_block) ||
+	    (blk >= ext2fs_blocks_count(fs->super))) {
+		err = EXT2_ET_BAD_EA_BLOCK_NUM;
+		goto out;
+	}
+
+	err = ext2fs_get_mem(fs->blocksize, &block_buf);
+	if (err)
+		goto out;
+
+	err = ext2fs_read_ext_attr3(fs, blk, block_buf, ino);
+	if (err)
+		goto out2;
+
+	header = (struct ext2_ext_attr_header *) block_buf;
+	if (header->h_magic != EXT2_EXT_ATTR_MAGIC) {
+		err = EXT2_ET_BAD_EA_HEADER;
+		goto out2;
+	}
+
+	header->h_refcount--;
+	err = ext2fs_write_ext_attr3(fs, blk, block_buf, ino);
+	if (err)
+		goto out2;
+
+	/* Erase link to block */
+	ext2fs_file_acl_block_set(fs, (struct ext2_inode *)inode, 0);
+	if (header->h_refcount == 0)
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+
+	/* Write inode? */
+	if (inode == &i) {
+		err = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&i,
+					      sizeof(struct ext2_inode_large));
+		if (err)
+			goto out2;
+	}
+out2:
+	ext2fs_free_mem(&block_buf);
+out:
+	return err;
+}
+
 static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 					 struct ext2_inode_large *inode)
 {
@@ -586,7 +653,10 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 				     EXT2_FEATURE_COMPAT_EXT_ATTR))
 		return 0;
 
-	err = ext2fs_get_memzero(EXT2_INODE_SIZE(handle->fs->super), &inode);
+	i = EXT2_INODE_SIZE(handle->fs->super);
+	if (i < sizeof(*inode))
+		i = sizeof(*inode);
+	err = ext2fs_get_memzero(i, &inode);
 	if (err)
 		return err;
 
@@ -596,6 +666,13 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	x = handle->attrs;
+	/* Does the inode have size for EA? */
+	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+						  inode->i_extra_isize +
+						  sizeof(__u32))
+		goto write_ea_block;
+
 	/* Write the inode EA */
 	ea_inode_magic = EXT2_EXT_ATTR_MAGIC;
 	memcpy(((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
@@ -605,7 +682,6 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		sizeof(__u32);
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 		inode->i_extra_isize + sizeof(__u32);
-	x = handle->attrs;
 
 	err = write_xattrs_to_buffer(handle, &x, start, storage_size, 0);
 	if (err)
@@ -615,6 +691,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	if (x == handle->attrs + handle->length)
 		goto skip_ea_block;
 
+write_ea_block:
 	/* Write the EA block */
 	err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
 	if (err)
@@ -634,7 +711,6 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		goto out2;
 	}
 
-skip_ea_block:
 	if (block_buf) {
 		/* Write a header on the EA block */
 		header = block_buf;
@@ -656,6 +732,7 @@ skip_ea_block:
 			goto out2;
 	}
 
+skip_ea_block:
 	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
 	if (!block_buf && blk) {
 		/* xattrs shrunk, free the block */
@@ -775,13 +852,17 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	unsigned int storage_size;
 	void *start, *block_buf = NULL;
 	blk64_t blk;
+	int i;
 	errcode_t err;
 
 	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
 				     EXT2_FEATURE_COMPAT_EXT_ATTR))
 		return 0;
 
-	err = ext2fs_get_memzero(EXT2_INODE_SIZE(handle->fs->super), &inode);
+	i = EXT2_INODE_SIZE(handle->fs->super);
+	if (i < sizeof(*inode))
+		i = sizeof(*inode);
+	err = ext2fs_get_memzero(i, &inode);
 	if (err)
 		return err;
 
@@ -791,6 +872,12 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	/* Does the inode have size for EA? */
+	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+						  inode->i_extra_isize +
+						  sizeof(__u32))
+		goto read_ea_block;
+
 	/* Look for EA in the inode */
 	memcpy(&ea_inode_magic, ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 	       inode->i_extra_isize, sizeof(__u32));
@@ -807,6 +894,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 			goto out;
 	}
 
+read_ea_block:
 	/* Look for EA in a separate EA block */
 	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
 	if (blk != 0) {
