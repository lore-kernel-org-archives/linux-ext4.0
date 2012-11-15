From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 6/7] libext2fs: fix some warnings from make gcc-wall
Date: Thu, 15 Nov 2012 16:13:28 +0800
Message-ID: <1352967209-29616-7-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65348 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992758Ab2KOIBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:19 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so905780pad.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:19 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove some warnings from make gcc-wall.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c           |  2 +-
 lib/ext2fs/dir_iterate.c |  4 +--
 lib/ext2fs/ext2fs.h      |  8 +++---
 lib/ext2fs/ext2fsP.h     |  4 +--
 lib/ext2fs/ext_attr.c    | 14 +++++------
 lib/ext2fs/inline_data.c | 65 ++++++++++++++++++++++++------------------------
 lib/ext2fs/mkdir.c       |  2 +-
 lib/ext2fs/punch.c       | 12 +++------
 8 files changed, 53 insertions(+), 58 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 41352c7..1f41166 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -203,7 +203,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
-		int inline_size;
+		unsigned int inline_size;
 
 		inline_size = ext2fs_get_inline_data_size(fs, ino);
 		if (inline_size == inode->i_size)
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 198c5aa..7d5b1da 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -289,8 +289,8 @@ next:
 }
 
 int ext2fs_process_dir_inline_data(ext2_filsys	fs,
-				   void		*buf,
-				   int		buf_len,
+				   char		*buf,
+				   unsigned int	buf_len,
 				   e2_blkcnt_t	blockcnt,
 				   struct ext2_inode_large *inode,
 				   void		*priv_data)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 05f630e..7a28e0f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1343,21 +1343,21 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
 
 /* inline_data.c */
 extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
-extern int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino);
+extern unsigned int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino);
 extern int ext2fs_inline_data_iterate(ext2_filsys fs,
 				      ext2_ino_t ino,
 				      int flags,
 				      char *block_buf,
 				      int (*func)(ext2_filsys fs,
-						  void *buf,
-						  int buf_len,
+						  char *buf,
+						  unsigned int buf_len,
 						  e2_blkcnt_t blockcnt,
 						  struct ext2_inode_large *inode,
 						  void *priv_data),
 				      void *priv_data);
 extern int ext2fs_inline_data_header_check(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_mkdir(ext2_filsys fs, ext2_ino_t parent,
-					  ext2_ino_t ino, const char *name);
+					  ext2_ino_t ino);
 extern errcode_t ext2fs_convert_inline_data(ext2_filsys fs, ext2_ino_t ino,
 					    void *priv_data);
 extern errcode_t ext2fs_read_inline_data(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 503ebbf..1da44ce 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -99,8 +99,8 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 				    void		*priv_data);
 
 extern int ext2fs_process_dir_inline_data(ext2_filsys	fs,
-					  void		*buf,
-					  int		buf_len,
+					  char		*buf,
+					  unsigned int	buf_len,
 					  e2_blkcnt_t	blockcnt,
 					  struct ext2_inode_large *inode,
 					  void		*priv_data);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 9c9ab1c..ec363e5 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -193,7 +193,7 @@ errcode_t ext2fs_find_entry_ext_attr(struct ext2_ext_attr_entry **pentry,
 {
 	struct ext2_ext_attr_entry *entry;
 	size_t name_len;
-	int cmp;
+	int cmp = 1;
 
 	name_len = strlen(name);
 	for (entry = *pentry; !EXT2_EXT_IS_LAST_ENTRY(entry);
@@ -267,7 +267,7 @@ errcode_t ext2fs_set_entry_ext_attr(struct ext2_ext_attr_info *i,
 				    struct ext2_ext_attr_search *s)
 {
 	struct ext2_ext_attr_entry *last;
-	size_t free, min_offs = s->end - s->base;
+	size_t freesize, min_offs = s->end - s->base;
 	size_t name_len = strlen(i->name);
 
 	last = s->first;
@@ -278,17 +278,17 @@ errcode_t ext2fs_set_entry_ext_attr(struct ext2_ext_attr_info *i,
 				min_offs = offs;
 		}
 	}
-	free = min_offs - ((void *)last - s->base) - sizeof(__u32);
+	freesize = min_offs - ((void *)last - s->base) - sizeof(__u32);
 	if (!s->not_found) {
 		if (!s->here->e_value_block && s->here->e_value_size) {
 			size_t size = ext2fs_le32_to_cpu(s->here->e_value_size);
-			free += EXT2_EXT_ATTR_SIZE(size);
+			freesize += EXT2_EXT_ATTR_SIZE(size);
 		}
-		free += EXT2_EXT_ATTR_LEN(name_len);
+		freesize += EXT2_EXT_ATTR_LEN(name_len);
 	}
 	if (i->value) {
-		if (free < EXT2_EXT_ATTR_SIZE(i->value_len) ||
-		    free < EXT2_EXT_ATTR_LEN(name_len) +
+		if (freesize < EXT2_EXT_ATTR_SIZE(i->value_len) ||
+		    freesize < EXT2_EXT_ATTR_LEN(name_len) +
 			   EXT2_EXT_ATTR_SIZE(i->value_len))
 			return -1;
 	}
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index fd89360..e9892e6 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -11,6 +11,7 @@
 
 #include "config.h"
 #include <stdio.h>
+#include <time.h>
 
 #include "ext2_fs.h"
 #include "ext2_ext_attr.h"
@@ -24,7 +25,8 @@ static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inod
 				    struct inline_data *data);
 static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
 					 struct inline_data *data);
-static int ext2fs_get_max_inline_size(ext2_filsys fs, struct ext2_inode_large *inode);
+static unsigned int ext2fs_get_max_inline_size(ext2_filsys fs,
+						struct ext2_inode_large *inode);
 static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
 					      char *target, void *buf,
 					      int inline_size);
@@ -35,14 +37,13 @@ static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
 					   struct inline_data *data);
 static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
 					   struct ext2_inode_large *inode,
-					   int len);
-static int do_search_dir(ext2_filsys fs, void *start, int size,
+					   unsigned int len);
+static int do_search_dir(ext2_filsys fs, void *start, unsigned int size,
 			 const char *name, size_t len);
 
 static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inode,
 				    struct inline_data *data)
 {
-	struct ext2_ext_attr_ibody_header *header;
 	struct ext2_ext_attr_search s = {
 		.not_found = -1,
 	};
@@ -121,7 +122,7 @@ static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
-static int do_search_dir(ext2_filsys fs, void *start, int size,
+static int do_search_dir(ext2_filsys fs, void *start, unsigned int size,
 			 const char *name, size_t len)
 {
 	struct ext2_dir_entry *de;
@@ -154,8 +155,6 @@ errcode_t ext2fs_inline_data_dirsearch(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_inode_large *inode;
 	struct ext2_dir_entry dirent;
 	struct inline_data data;
-	unsigned int offset = 0;
-	unsigned int rec_len;
 	void *inline_start;
 	int inline_size;
 	errcode_t retval = 0;
@@ -220,12 +219,12 @@ int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 	return (inode.i_flags & EXT4_INLINE_DATA_FL);
 }
 
-int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino)
+unsigned int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct inline_data data;
 	struct ext2_inode_large *inode;
 	errcode_t retval = 0;
-	int inline_size = 0;
+	unsigned int inline_size = 0;
 
 	if (!ext2fs_inode_has_inline_data(fs, ino))
 		return 0;
@@ -255,7 +254,7 @@ static void ext2fs_update_final_de(ext2_filsys fs, void *de_buf,
 {
 	struct ext2_dir_entry *de, *prev_de;
 	void *limit;
-	int de_len;
+	unsigned int de_len;
 
 	de = (struct ext2_dir_entry *)de_buf;
 	if (old_size) {
@@ -332,8 +331,8 @@ int ext2fs_inline_data_iterate(ext2_filsys fs,
 			       int flags,
 			       char *block_buf,
 			       int (*func)(ext2_filsys fs,
-					   void *buf,
-					   int buf_len,
+					   char *buf,
+					   unsigned int buf_len,
 					   e2_blkcnt_t blockcnt,
 					   struct ext2_inode_large *inode,
 					   void *priv_data),
@@ -414,7 +413,7 @@ errcode_t ext2fs_read_inline_data(ext2_filsys fs, ext2_ino_t ino, char *buf)
 	struct ext2_inode_large *inode;
 	struct inline_data data;
 	errcode_t retval = 0;
-	int inline_size;
+	unsigned int inline_size;
 
 	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
 	if (retval)
@@ -447,7 +446,7 @@ errcode_t ext2fs_write_inline_data(ext2_filsys fs, ext2_ino_t ino, char *buf)
 	struct ext2_inode_large *inode;
 	struct inline_data data;
 	errcode_t retval = 0;
-	int inline_size;
+	unsigned int inline_size;
 
 	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
 	if (retval)
@@ -484,7 +483,12 @@ errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
 	struct inline_data data;
 	errcode_t retval = 0;
 	void *value;
-	int inline_size, value_len;
+	unsigned int inline_size;
+	int value_len;
+
+	/* punching hole for inline_data is not supported */
+	if (end != ~0U)
+		return EXT2_ET_OP_NOT_SUPPORTED;
 
 	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
 	if (retval)
@@ -504,7 +508,6 @@ errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
 		goto out;
 
 	if (start < inline_size) {
-		struct ext2_ext_attr_ibody_header *header;
 		struct ext2_ext_attr_search s = {
 			.not_found = -1,
 		};
@@ -594,11 +597,9 @@ errcode_t ext2fs_convert_inline_data(ext2_filsys fs,
 	ext2_extent_handle_t handle;
 	errcode_t retval;
 	blk64_t blk;
-	void *inline_start;
 	char *backup_buf;
 	char *blk_buf;
-	int inline_size;
-	int i, limit, r;
+	unsigned int inline_size;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -702,7 +703,7 @@ out:
 
 static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
 					   struct ext2_inode_large *inode,
-					   int len)
+					   unsigned int len)
 {
 	struct ext2_ext_attr_ibody_header *header;
 	struct ext2_ext_attr_search s = {
@@ -742,12 +743,11 @@ static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
 }
 
 errcode_t ext2fs_inline_data_mkdir(ext2_filsys fs, ext2_ino_t parent,
-				   ext2_ino_t ino, const char *name)
+				   ext2_ino_t ino)
 {
 	struct ext2_inode_large *inode;
 	struct ext2_dir_entry *de;
 	errcode_t retval = 0;
-	char *buf;
 	int inline_size = EXT4_MIN_INLINE_DATA_SIZE;
 	__u32 t = fs->now ? fs->now : time(NULL);
 
@@ -793,13 +793,14 @@ out:
 	return retval;
 }
 
-static int ext2fs_get_max_inline_size(ext2_filsys fs, struct ext2_inode_large *inode)
+static unsigned int ext2fs_get_max_inline_size(ext2_filsys fs,
+				struct ext2_inode_large *inode)
 {
 	struct ext2_ext_attr_entry *entry;
 	struct ext2_ext_attr_ibody_header *header;
 	struct inline_data data;
 	errcode_t retval = 0;
-	int free, min_offs;
+	unsigned int freesize, min_offs;
 
 	min_offs = EXT2_INODE_SIZE(fs->super) -
 		   EXT2_GOOD_OLD_INODE_SIZE -
@@ -817,7 +818,7 @@ static int ext2fs_get_max_inline_size(ext2_filsys fs, struct ext2_inode_large *i
 				min_offs = offs;
 		}
 	}
-	free = min_offs -
+	freesize = min_offs -
 		((void *)entry - (void *)IFIRST(header)) - sizeof(__u32);
 
 	/*
@@ -831,19 +832,19 @@ static int ext2fs_get_max_inline_size(ext2_filsys fs, struct ext2_inode_large *i
 	if (data.inline_off) {
 		entry = (struct ext2_ext_attr_entry *)
 			((void *)inode + data.inline_off);
-		free += ext2fs_le32_to_cpu(entry->e_value_size);
+		freesize += ext2fs_le32_to_cpu(entry->e_value_size);
 		goto out;
 	}
 
-	free -= EXT2_EXT_ATTR_LEN(strlen(EXT4_EXT_ATTR_SYSTEM_DATA));
+	freesize -= EXT2_EXT_ATTR_LEN(strlen(EXT4_EXT_ATTR_SYSTEM_DATA));
 
-	if (free > EXT2_EXT_ATTR_ROUND)
-		free = EXT2_EXT_ATTR_SIZE(free - EXT2_EXT_ATTR_ROUND);
+	if (freesize > EXT2_EXT_ATTR_ROUND)
+		freesize = EXT2_EXT_ATTR_SIZE(freesize - EXT2_EXT_ATTR_ROUND);
 	else
-		free = 0;
+		freesize = 0;
 
 out:
-	return free + EXT4_MIN_INLINE_DATA_SIZE;
+	return freesize + EXT4_MIN_INLINE_DATA_SIZE;
 }
 
 errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
@@ -853,7 +854,7 @@ errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_inode_large *inode;
 	struct inline_data data;
 	errcode_t retval = 0;
-	int inline_size = 0;
+	unsigned int inline_size = 0;
 
 	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
 	if (retval)
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index d48a075..93403c8 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -58,7 +58,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA &&
 	    ino >= EXT2_FIRST_INO(fs->super) &&
 	    strcmp("lost+found", name) != 0) {
-		retval = ext2fs_inline_data_mkdir(fs, parent, ino, name);
+		retval = ext2fs_inline_data_mkdir(fs, parent, ino);
 		if (retval)
 			goto cleanup;
 		inline_data = 1;
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 4b8d51c..8de9649 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -307,15 +307,9 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 		inode = &inode_buf;
 	}
-	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
-		/* punching hole for inline_data is not supported */
-		if (end != ~0)
-			retval = EXT2_ET_OP_NOT_SUPPORTED;
-		else
-			retval = ext2fs_punch_inline_data(fs, ino, start, end);
