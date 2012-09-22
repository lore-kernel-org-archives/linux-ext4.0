From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 04/21 v5] libext2fs: handle inline data in dir iterator function
Date: Sat, 22 Sep 2012 12:00:52 +0800
Message-ID: <1348286469-31690-5-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2IVDvG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:06 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873803pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:05 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Inline_data is handled in dir iterator because a lot of commands use this
function to traverse directory entries debugfs.  We need to handle inline_data
individually because inline_data is saved in two places.  One is in i_block, and
another is in ibody extend attribute.

After adding these functions, some commands in debugfs can support inline_data
feature as below:
	- ncheck
	- chroot
	- cd
	- ls
	- pwd
	- link*
	- unlink

* If inline_data doesn't expand to ibody extend attribute, link command will
  allocate a new block for this inode instead of using extend attribute when we
  exhaust all space of i_block.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/dir_iterate.c  |  101 +++++++++++++++++++++++++++++++++-
 lib/ext2fs/ext2_err.et.in |    6 ++
 lib/ext2fs/ext2_fs.h      |    7 +++
 lib/ext2fs/ext2fs.h       |   11 ++++
 lib/ext2fs/ext2fsP.h      |    7 +++
 lib/ext2fs/inline_data.c  |  132 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 262 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index c24015c..7b82fb1 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -123,8 +123,14 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
 	ctx.func = func;
 	ctx.priv_data = priv_data;
 	ctx.errcode = 0;
-	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY, 0,
-				       ext2fs_process_dir_block, &ctx);
+	if (ext2fs_inode_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_iterate(fs, dir,
+						BLOCK_FLAG_READ_ONLY, 0,
+						ext2fs_process_dir_inline_data,
+						&ctx);
+	else
+		retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY, 0,
+					       ext2fs_process_dir_block, &ctx);
 	if (!block_buf)
 		ext2fs_free_mem(&ctx.buf);
 	if (retval)
@@ -275,3 +281,94 @@ next:
 	return 0;
 }
 
+int ext2fs_process_dir_inline_data(ext2_filsys	fs,
+				   void		*buf,
+				   int		buf_len,
+				   e2_blkcnt_t	blockcnt,
+				   struct ext2_inode_large *inode,
+				   void		*priv_data)
+{
+	struct dir_context *ctx = (struct dir_context *) priv_data;
+	unsigned int	offset = 0;
+	unsigned int	next_real_entry = 0;
+	int		ret = 0;
+	int		changed = 0;
+	int		do_abort = 0;
+	unsigned int	rec_len, size;
+	int		entry;
+	struct ext2_dir_entry *dirent;
+
+	if (blockcnt < 0)
+		return 0;
+
+	entry = blockcnt ? DIRENT_OTHER_FILE : DIRENT_DOT_FILE;
+
+	while (offset < buf_len) {
+		dirent = (struct ext2_dir_entry *) (buf + offset);
+		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
+			return BLOCK_ABORT;
+		if (((offset + rec_len) > buf_len) ||
+		    (rec_len < 8) ||
+		    ((rec_len % 4) != 0) ||
+		    ((((unsigned) dirent->name_len & 0xFF)+8) > rec_len)) {
+			ctx->errcode = EXT2_ET_DIR_CORRUPTED;
+			return BLOCK_ABORT;
+		}
+		if (!dirent->inode &&
+		    !(ctx->flags & DIRENT_FLAG_INCLUDE_EMPTY))
+			goto next;
+
+		ret = (ctx->func)(ctx->dir,
+				  (next_real_entry > offset) ?
+				  DIRENT_DELETED_FILE : entry,
+				  dirent, offset,
+				  buf_len, buf,
+				  ctx->priv_data);
+		if (entry < DIRENT_OTHER_FILE)
+			entry++;
+
+		if (ret & DIRENT_CHANGED) {
+			dirent->rec_len = rec_len;
+			changed++;
+		}
+		if (ret & DIRENT_ABORT) {
+			do_abort++;
+			break;
+		}
+next:
+		if (next_real_entry == offset)
+			next_real_entry += rec_len;
+
+		if (ctx->flags & DIRENT_FLAG_INCLUDE_REMOVED) {
+			size = ((dirent->name_len & 0xFF) + 11) & ~3;
+
+			if (rec_len != size)  {
+				unsigned int final_offset;
+
+				final_offset = offset + rec_len;
+				offset += size;
+				while (offset < final_offset &&
+				       !ext2fs_validate_entry(fs, buf,
+							      offset,
+							      final_offset))
+					offset += 4;
+				continue;
+			}
+		}
+		offset += rec_len;
+	}
+
+	if (changed) {
+		/* change parent ino */
+		if (buf_len == EXT2_DIR_REC_LEN(2))
+			((struct ext2_dir_entry *)inode->i_block)->inode =
+								 dirent->inode;
+		ctx->errcode = ext2fs_write_inode_full(fs, ctx->dir, (void *)inode,
+						       EXT2_INODE_SIZE(fs->super));
+		if (ctx->errcode)
+			return BLOCK_ABORT;
+	}
+	if (do_abort)
+		return BLOCK_ABORT;
+	return 0;
+}
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index c99a167..537d840 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -68,6 +68,9 @@ ec	EXT2_ET_MAGIC_EXTENT_HANDLE,
 ec	EXT2_ET_BAD_MAGIC,
 	"Bad magic number in super-block"
 
+ec	EXT2_ET_BAD_EXT_ATTR_MAGIC,
+	"Bad magic number in extend attribute"
+
 ec	EXT2_ET_REV_TOO_HIGH,
 	"Filesystem revision too high"
 
@@ -473,4 +476,7 @@ ec	EXT2_ET_UNKNOWN_CSUM,
 ec	EXT2_ET_MMP_CSUM_INVALID,
 	"MMP block checksum does not match MMP block"
 
+ec	EXT2_ET_BAD_EXTRA_SIZE,
+	"Bad inode extra isizevalue"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 5b6e315..4201c71 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -905,4 +905,11 @@ struct mmp_struct {
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
index b076c3c..b0efda6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1335,6 +1335,17 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 
 /* inline_data.c */
 extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
+extern int ext2fs_inline_data_iterate(ext2_filsys fs,
+				      ext2_ino_t ino,
+				      int flags,
+				      char *block_buf,
+				      int (*func)(ext2_filsys fs,
+						  void *buf,
+						  int buf_len,
+						  e2_blkcnt_t blockcnt,
+						  struct ext2_inode_large *inode,
+						  void *priv_data),
+				      void *priv_data);
 
 /* inode.c */
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 3de9278..742ddf6 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -87,6 +87,13 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 				    int			ref_offset,
 				    void		*priv_data);
 
+extern int ext2fs_process_dir_inline_data(ext2_filsys	fs,
+					  void		*buf,
+					  int		buf_len,
+					  e2_blkcnt_t	blockcnt,
+					  struct ext2_inode_large *inode,
+					  void		*priv_data);
+
 /* Generic numeric progress meter */
 
 struct ext2fs_numeric_progress_struct {
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 0341ee3..2be1a61 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -13,10 +13,60 @@
 #include <stdio.h>
 
 #include "ext2_fs.h"
+#include "ext2_ext_attr.h"
 
 #include "ext2fs.h"
 #include "ext2fsP.h"
 
+#define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
+
+static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inode,
+				    struct inline_data *data);
+static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
+					 struct inline_data *data);
+
+static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inode,
+				    struct inline_data *data)
+{
+	struct ext2_ext_attr_ibody_header *header;
+	struct ext2_ext_attr_search s = {
+		.not_found = -1,
+	};
+	struct ext2_ext_attr_info i = {
+		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
+		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
+	};
+
+	data->inline_off = 0;
+	if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
+				   EXT2_GOOD_OLD_INODE_SIZE))
+		return EXT2_ET_BAD_EXTRA_SIZE;
+
+	(void)ext2fs_ibody_find_ext_attr(fs, inode, &i, &s);
+
+	if (!s.not_found) {
+		data->inline_off = (__u16)((void *)s.here - (void *)inode);
+		data->inline_size = EXT4_MIN_INLINE_DATA_SIZE +
+				    s.here->e_value_size;
+		return 0;
+	}
+
+	return EXT2_ET_BAD_EXT_ATTR_MAGIC;
+}
+
+static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
+					 struct inline_data *data)
+{
+	struct ext2_ext_attr_entry *entry;
+	struct ext2_ext_attr_ibody_header *header;
+
+	header = IHDR(inode);
+	entry = (struct ext2_ext_attr_entry *)
+			((void *)inode + data->inline_off);
+
+	return (void *)IFIRST(header) + entry->e_value_offs;
+}
+
 int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
@@ -28,3 +78,85 @@ int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 
 	return (inode.i_flags & EXT4_INLINE_DATA_FL);
 }
+
+int ext2fs_inline_data_iterate(ext2_filsys fs,
+			       ext2_ino_t ino,
+			       int flags,
+			       char *block_buf,
+			       int (*func)(ext2_filsys fs,
+					   void *buf,
+					   int buf_len,
+					   e2_blkcnt_t blockcnt,
+					   struct ext2_inode_large *inode,
+					   void *priv_data),
+			       void *priv_data)
+{
+	struct dir_context *ctx;
+	struct ext2_inode_large *inode;
+	struct ext2_dir_entry dirent;
+	struct inline_data data;
+	errcode_t retval = 0;
+	e2_blkcnt_t blockcnt = 0;
+	void *inline_start;
+	int inline_size;
+
+	ctx = (struct dir_context *)priv_data;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	if (inode->i_size == 0)
+		goto out;
+
+	/* we first check '.' and '..' dir */
+	dirent.inode = ino;
+	dirent.name_len = 1;
+	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
+	dirent.name[0] = '.';
+	dirent.name[1] = '\0';
+	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
+			 inode, priv_data);
+	if (retval & BLOCK_ABORT)
+		goto out;
+
+	dirent.inode = (__u32)*inode->i_block;
+	dirent.name_len = 2;
+	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
+	dirent.name[0] = '.';
+	dirent.name[1] = '.';
+	dirent.name[2] = '\0';
+	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
+			 inode, priv_data);
+	if (retval & BLOCK_ABORT)
+		goto out;
+
+	inline_start = (void *)inode->i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
+	retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
+			 inode, priv_data);
+	if (retval & BLOCK_ABORT)
+		goto out;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
+	if (retval)
+		goto out;
+	if (data.inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
+		inline_start = ext2fs_get_inline_xattr_pos(inode, &data);
+		inline_size = data.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+		retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
+			 inode, priv_data);
+		if (retval & BLOCK_ABORT)
+			goto out;
+	}
+
+out:
+	retval |= BLOCK_ERROR;
+	ext2fs_free_mem(&inode);
+	return retval & BLOCK_ERROR ? ctx->errcode : 0;
+}
-- 
1.7.4.1

