From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/5] debugfs: make debugfs to support inline data
Date: Sun, 18 Dec 2011 22:44:42 +0800
Message-ID: <1324219484-22443-4-git-send-email-wenqing.lz@taobao.com>
References: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1LROoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:44:23 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so7092185iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 06:44:23 -0800 (PST)
In-Reply-To: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Let debugfs to support inline data in read-only mode.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c          |    4 +
 debugfs/dump.c             |   26 +++++
 debugfs/htree.c            |    6 +-
 lib/ext2fs/Makefile.in     |    5 +
 lib/ext2fs/Makefile.pq     |    1 +
 lib/ext2fs/block.c         |   15 +++
 lib/ext2fs/ext2_ext_attr.h |    4 +
 lib/ext2fs/ext2_fs.h       |    8 ++
 lib/ext2fs/ext2fs.h        |   11 ++
 lib/ext2fs/inline_data.c   |  224 ++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 302 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/inline_data.c

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index b7ff00d..c7837ed 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -800,6 +800,10 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (inode->i_dtime)
 	  fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
 		  time_to_string(inode->i_dtime));
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		fprintf(out, "Inode has inline data\n");
+		return;
+	}
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
diff --git a/debugfs/dump.c b/debugfs/dump.c
index a15a0b7..d56f869 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -113,6 +113,32 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 	if (debugfs_read_inode(ino, &inode, cmdname))
 		return;
 
+	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
+		struct ext2_inode *large_inode;
+		struct inline_data idata;
+		void *inline_start;
+		int inline_size;
+
+		large_inode = (struct ext2_inode *)
+				malloc(EXT2_INODE_SIZE(current_fs->super));
+		ext2fs_read_inode_full(current_fs, ino, large_inode,
+					EXT2_INODE_SIZE(current_fs->super));
+		write(fd, large_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+
+		ext2fs_iget_extra_inode(current_fs, large_inode, &idata);
+		if (idata.inline_off == 0 ||
+		    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+			goto out;
+
+		inline_start = ext2fs_get_inline_xattr_pos(large_inode, &idata);
+		inline_size = idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+		write(fd, inline_start, inline_size);
+
+out:
+		free(large_inode);
+		return;
+	}
+
 	retval = ext2fs_file_open(current_fs, ino, 0, &e2_file);
 	if (retval) {
 		com_err(cmdname, retval, "while opening ext2 file");
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 05745eb..9a850f6 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -354,8 +354,10 @@ void do_dirsearch(int argc, char *argv[])
 	pb.search_name = argv[2];
 	pb.len = strlen(pb.search_name);
 
-	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
-			      search_dir_block, &pb);
+	if (ext2fs_search_dir_inline_data(current_fs,
+			inode, argv[2], strlen(argv[2])) != 0)
+		ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
+				      search_dir_block, &pb);
 
 	free(pb.buf);
 }
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index a9795a3..6fd35d9 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -57,6 +57,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	ind_block.o \
 	initialize.o \
 	inline.o \
+	inline_data.o \
 	inode.o \
 	io_manager.o \
 	ismounted.o \
@@ -127,6 +128,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/ind_block.c \
 	$(srcdir)/initialize.c \
 	$(srcdir)/inline.c \
+	$(srcdir)/inline_data.c \
 	$(srcdir)/inode.c \
 	$(srcdir)/inode_io.c \
 	$(srcdir)/imager.c \
@@ -687,6 +689,9 @@ inline.o: $(srcdir)/inline.c $(top_builddir)/lib/config.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
+inline_data.o: $(srcdir)/inline_data.c $(top_builddir)/lib/config.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(srcdir)/ext2_ext_attr.h \
+ $(srcdir)/ext2fsP.h
 inode.o: $(srcdir)/inode.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
diff --git a/lib/ext2fs/Makefile.pq b/lib/ext2fs/Makefile.pq
index 2f7b654..89082a7 100644
--- a/lib/ext2fs/Makefile.pq
+++ b/lib/ext2fs/Makefile.pq
@@ -27,6 +27,7 @@ OBJS= 	alloc.obj \
 	icount.obj \
 	initialize.obj \
 	inline.obj \
+	inline_data.obj \
 	inode.obj \
 	ismounted.obj \
 	link.obj \
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 6a5c10d..92083f9 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -387,6 +387,21 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 		}
 	}
 
+	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
+		struct ext2_inode *large_inode;
+
+		large_inode = (struct ext2_inode *)
+				malloc(EXT2_INODE_SIZE(fs->super));
+		ext2fs_read_inode_full(fs, ino, large_inode,
+					EXT2_INODE_SIZE(fs->super));
+		ret = ext2fs_find_inline_entry(fs, large_inode, priv_data);
+		free(large_inode);
+		if (ret & BLOCK_ABORT)
+			goto abort_exit;
+		else
+			goto errout;
+	}
+
 	if (inode.i_flags & EXT4_EXTENTS_FL) {
 		ext2_extent_handle_t	handle;
 		struct ext2fs_extent	extent;
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index ed548d1..78ef7fc 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -23,6 +23,10 @@ struct ext2_ext_attr_header {
 	__u32	h_reserved[4];	/* zero right now */
 };
 
+struct ext2_ext_attr_ibody_header {
+	__u32	h_magic;
+};
+
 struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0a37b57..c7a8380 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -300,6 +300,7 @@ struct ext2_dx_countlimit {
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+#define EXT4_INLINE_DATA_FL		0x00800000 /* Inode has inline data */
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
@@ -852,4 +853,11 @@ struct mmp_struct {
  */
 #define EXT4_MMP_MIN_CHECK_INTERVAL     5
 
+struct inline_data {
+	__u16	inline_off;
+	__u16	inline_size;
+};
+
+#define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__u32) * EXT2_N_BLOCKS))
+
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8b94ad0..c17922e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1223,6 +1223,17 @@ extern errcode_t ext2fs_initialize(const char *name, int flags,
 				   struct ext2_super_block *param,
 				   io_manager manager, ext2_filsys *ret_fs);
 
+/* inline_data.c */
+extern errcode_t ext2fs_find_inline_entry(ext2_filsys fs,
+					  struct ext2_inode *inode,
+					  void *priv_data);
+extern errcode_t ext2fs_search_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					       char *search_name, int len);
+extern void *ext2fs_get_inline_xattr_pos(struct ext2_inode *inode,
+					 struct inline_data *idata);
+extern void ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode *inode,
+				    struct inline_data *idata);
+
 /* icount.c */
 extern void ext2fs_free_icount(ext2_icount_t icount);
 extern errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
new file mode 100644
index 0000000..dcf33f9
--- /dev/null
+++ b/lib/ext2fs/inline_data.c
@@ -0,0 +1,224 @@
+/*
+ * inline_data.c --- inode allocates inline data
+ *
+ * Copyright (C) 2011 Zheng Liu <wenqing.lz@taobao.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Libaray
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+
+#include "ext2_fs.h"
+#include "ext2_ext_attr.h"
+
+#include "ext2fs.h"
+#include "ext2fsP.h"
+
+#define EXT4_XATTR_INDEX_SYSTEM_DATA	7
+#define EXT4_XATTR_SYSTEM_DATA_NAME	"data"
+
+static int search_dir(ext2_filsys fs, char *start, int size, void *priv_data)
+{
+	struct dir_context *ctx = (struct dir_context *) priv_data;
+	struct ext2_dir_entry *dirent;
+	unsigned int rec_len;
+	int ret;
+	int do_abort = 0;
+	char *dlimit;
+
+	dirent = (struct ext2_dir_entry *) start;
+	dlimit = start + size;
+
+	while ((char *) dirent < dlimit) {
+		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
+			return BLOCK_ABORT;
+		ret = (ctx->func)(ctx->dir, 0, dirent,
+				  0, fs->blocksize, ctx->buf,
+				  ctx->priv_data);
+		if (ret & DIRENT_ABORT) {
+			do_abort++;
+			break;
+		}
+		dirent = (struct ext2_dir_entry *) ((char *) dirent + rec_len);
+	}
+
+	if (do_abort)
+		return BLOCK_ABORT;
+
+	return 0;
+}
+
+static int search_dir2(ext2_filsys fs, char *start, int size,
+		       char *search_name, int len)
+{
+	struct ext2_dir_entry *dirent;
+	unsigned int rec_len;
+	int ret;
+	int do_abort = 0;
+	char *dlimit;
+
+	dirent = (struct ext2_dir_entry *) start;
+	dlimit = start + size;
+
+	while ((char *) dirent < dlimit) {
+		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
+			return BLOCK_ABORT;
+		if (dirent->inode &&
+		    len == (dirent->name_len & 0xFF) &&
+		    strncmp(search_name, dirent->name,
+			    len) == 0) {
+			printf("Entry found at inline data\n");
+			break;
+		}
+		dirent = (struct ext2_dir_entry *) ((char *) dirent + rec_len);
+	}
+
+	return 0;
+}
+
+void ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode *inode,
+			     struct inline_data *idata)
+{
+	struct ext2_inode_large *large_inode;
+	struct ext2_ext_attr_entry *entry;
+	__u32 *magic;
+	char *start, *end;
+	int cmp;
+	unsigned int storage_size;
+
+	large_inode = (struct ext2_inode_large *) inode;
+	idata->inline_off = 0;
+	if (large_inode->i_extra_isize > EXT2_INODE_SIZE(fs->super) -
+			EXT2_GOOD_OLD_INODE_SIZE) {
+		fprintf(stderr, "invalid inode->i_extra_isize (%u)\n",
+				large_inode->i_extra_isize);
+		return;
+	}
+	storage_size = EXT2_INODE_SIZE(fs->super) -
+			EXT2_GOOD_OLD_INODE_SIZE -
+			large_inode->i_extra_isize;
+	magic = (__u32 *)((char *)large_inode + EXT2_GOOD_OLD_INODE_SIZE +
+			large_inode->i_extra_isize);
+	if (*magic == EXT2_EXT_ATTR_MAGIC) {
+		end = (char *) large_inode + EXT2_INODE_SIZE(fs->super);
+		start = (char *) magic + sizeof(__u32);
+		entry = (struct ext2_ext_attr_entry *) start;
+		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+			struct ext2_ext_attr_entry *next =
+				EXT2_EXT_ATTR_NEXT(entry);
+			if (entry->e_value_size > storage_size ||
+					(char *) next >= end) {
+				fprintf(stderr, "invalid inline data\n");
+				return;
+			}
+			cmp = EXT4_XATTR_INDEX_SYSTEM_DATA - entry->e_name_index;
+			if (!cmp)
+				cmp = strlen(EXT4_XATTR_SYSTEM_DATA_NAME) -
+					entry->e_name_len;
+			if (!cmp)
+				cmp = memcmp(EXT4_XATTR_SYSTEM_DATA_NAME,
+					     EXT2_EXT_ATTR_NAME(entry),
+					     strlen(EXT4_XATTR_SYSTEM_DATA_NAME));
+			if (cmp == 0)
+				break;
+
+			entry = next;
+		}
+
+		if (cmp == 0) {
+			idata->inline_off = (__u16)((void *) entry -
+					(void *) large_inode);
+			idata->inline_size = EXT4_MIN_INLINE_DATA_SIZE +
+					entry->e_value_size;
+		}
+	}
+}
+
+void *ext2fs_get_inline_xattr_pos(struct ext2_inode *inode,
+				  struct inline_data *idata)
+{
+	struct ext2_inode_large *large_inode;
+	struct ext2_ext_attr_entry *entry;
+	struct ext2_ext_attr_ibody_header *header;
+
+	large_inode = (struct ext2_inode_large *) inode;
+	header = (struct ext2_ext_attr_ibody_header *)
+			((void *)large_inode +
+			EXT2_GOOD_OLD_INODE_SIZE +
+			large_inode->i_extra_isize);
+	entry = (struct ext2_ext_attr_entry *)((void *)large_inode +
+			idata->inline_off);
+
+	return (void *)((struct ext2_ext_attr_header *)((header)+1)) +
+			entry->e_value_offs;
+}
+
+errcode_t ext2fs_find_inline_entry(ext2_filsys fs, struct ext2_inode *inode,
+				   void *priv_data)
+{
+	struct inline_data idata;
+	void *inline_start;
+	int inline_size;
+	int ret = 0;
+
+	inline_start = inode->i_block;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+	ret = search_dir(fs, inline_start, inline_size, priv_data);
+	if (ret)
+		return ret;
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_off == 0 ||
+	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		return -1;
+
+	inline_start = ext2fs_get_inline_xattr_pos(inode, &idata);
+	inline_size = idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+	ret = search_dir(fs, inline_start, inline_size, priv_data);
+
+	return 0;
+}
+
+errcode_t ext2fs_search_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					char *search_name, int len)
+{
+	struct ext2_inode *inode;
+	struct ext2_dir_entry *dirent;
+	struct inline_data idata;
+	unsigned int rec_len;
+	char *dlimit;
+	void *start;
+	int size;
+	int ret = 0;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode,
+				EXT2_INODE_SIZE(fs->super));
+
+	if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+		goto out;
+
+	start = inode->i_block;
+	size = EXT4_MIN_INLINE_DATA_SIZE;
+	ret = search_dir2(fs, start, size, search_name, len);
+	if (!ret)
+		goto out;
+
+	ret = 0;
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_off == 0 ||
+	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		goto out;
+
+	start = ext2fs_get_inline_xattr_pos(inode, &idata);
+	size = idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+	ret = search_dir2(fs, start, size, search_name, len);
+
+out:
+	free(inode);
+	return ret;
+}
-- 
1.7.4.1

