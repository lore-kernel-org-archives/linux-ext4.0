From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 02/17] ext4: Add the basic function for inline data support.
Date: Wed, 26 Oct 2011 15:34:13 +0800
Message-ID: <1319614468-11227-2-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Implement inline data with xattr. This idea is inspired by Andreas.
So now we use "system.data" to store xattr.
For inode_size = 256, currently we uses all the space between i_extra_isize
and inode_size. For inode_size > 256, we use half of that space.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    5 ++
 fs/ext4/inode.c |    9 ++-
 fs/ext4/xattr.c |  216 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h |   68 +++++++++++++++++
 4 files changed, 295 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b7d7bd0..9a60193 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -846,6 +846,10 @@ struct ext4_inode_info {
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
+	/* Indicate the inline data space. */
+	u16 i_inline_off;
+	u16 i_inline_size;
+
 #ifdef CONFIG_QUOTA
 	/* quota space reservation, managed internally by quota code */
 	qsize_t i_reserved_quota;
@@ -1261,6 +1265,7 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6638f0e..017e119 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3386,12 +3386,15 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 
 static inline void ext4_iget_extra_inode(struct inode *inode,
 					 struct ext4_inode *raw_inode,
-					 struct ext4_inode_info *ei)
+					 struct ext4_inode_info *ei,
+					 struct ext4_iloc *iloc)
 {
 	__le32 *magic = (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
-	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
+	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
+		ext4_find_inline_data(inode, iloc);
+	}
 }
 
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
@@ -3505,7 +3508,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
 					    EXT4_GOOD_OLD_INODE_SIZE;
 		} else
-			ext4_iget_extra_inode(inode, raw_inode, ei);
+			ext4_iget_extra_inode(inode, raw_inode, ei, &iloc);
 	} else
 		ei->i_extra_isize = 0;
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..37418a9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -944,6 +944,222 @@ ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
+#define EXT4_XATTR_SYSTEM_DATA_NAME		"data"
+
+/*
+ * the max inline size we can have for an inline inode.
+ *
+ * Currently we uses the maximum free space if inode size is 256
+ * and half of the space left if inode size > 256.
+ * This can be tuned later and the codes should work with
+ * the old size since if an inode has been initialized already,
+ * it will uses the value it detected.
+ */
+int ext4_get_max_inline_size(struct inode *inode)
+{
+	if (EXT4_SB(inode->i_sb)->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE)
+		return 0;
+
+	if (EXT4_I(inode)->i_inline_off)
+		return EXT4_I(inode)->i_inline_size;
+
+	if (EXT4_SB(inode->i_sb)->s_inode_size == 256)
+		return EXT4_XATTR_SIZE(EXT4_SB(inode->i_sb)->s_inode_size -
+			EXT4_GOOD_OLD_INODE_SIZE -
+			EXT4_I(inode)->i_extra_isize -
+			sizeof(struct ext4_xattr_ibody_header) -
+			EXT4_XATTR_LEN(sizeof(EXT4_XATTR_SYSTEM_DATA_NAME)) -
+			EXT4_XATTR_ROUND);
+
+	return EXT4_XATTR_SIZE((EXT4_SB(inode->i_sb)->s_inode_size -
+		EXT4_GOOD_OLD_INODE_SIZE - EXT4_I(inode)->i_extra_isize) / 2);
+}
+
+int ext4_has_inline_data(struct inode *inode)
+{
+	return EXT4_I(inode)->i_inline_off;
+}
+
+int ext4_find_inline_data(struct inode *inode, struct ext4_iloc *iloc)
+{
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+		.iloc = *iloc,
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
+		.name = EXT4_XATTR_SYSTEM_DATA_NAME,
+	};
+	int error;
+
+	if (EXT4_I(inode)->i_extra_isize == 0)
+		return 0;
+
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		return error;
+	if (!is.s.not_found) {
+		EXT4_I(inode)->i_inline_off = (u16)((void *)is.s.here -
+						(void *)ext4_raw_inode(iloc));
+		EXT4_I(inode)->i_inline_size =
+				le32_to_cpu(is.s.here->e_value_size);
+		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	}
+	return 0;
+}
+
+void* ext4_get_inline_data_pos(struct inode *inode, struct ext4_iloc *iloc)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+
+	BUG_ON(!EXT4_I(inode)->i_inline_off);
+
+	header = IHDR(inode, ext4_raw_inode(iloc));
+	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
+					    EXT4_I(inode)->i_inline_off);
+
+	return (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs);
+
+}
+
+void ext4_read_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+			   void *buffer, size_t len)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+
+	BUG_ON(!EXT4_I(inode)->i_inline_off);
+
+	header = IHDR(inode, ext4_raw_inode(iloc));
+	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
+					    EXT4_I(inode)->i_inline_off);
+	BUG_ON(len > EXT4_I(inode)->i_inline_size);
+
+	memcpy(buffer,
+	      (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
+}
+
+void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+			    void *buffer, loff_t pos, unsigned len)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+
+	BUG_ON(!EXT4_I(inode)->i_inline_off);
+	BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
+
+	header = IHDR(inode, ext4_raw_inode(iloc));
+	entry = (struct ext4_xattr_entry *)((void *)ext4_raw_inode(iloc) +
+					    EXT4_I(inode)->i_inline_off);
+	memcpy((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) + pos,
+	       buffer + pos, len);
+}
+
+int ext4_init_inline_data(handle_t *handle, struct inode *inode,
+			  struct ext4_iloc *iloc)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int size, error;
+	char *value;
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+		.iloc = *iloc,
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
+		.name = EXT4_XATTR_SYSTEM_DATA_NAME,
+	};
+
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return -ENOSPC;
+
+	BUG_ON(ei->i_inline_off != 0);
+
+	size = ext4_get_max_inline_size(inode);
+	/*
+	 * XXX: We'd better try to check whether we can insert it into inode
+	 * before allocating the value.
+	 */
+	value = kzalloc(size, GFP_NOFS);
+	if (!value)
+		return -ENOMEM;
+
+	i.value = value;
+	i.value_len = size;
+
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		goto out;
+
+	BUG_ON(!is.s.not_found);
+
+	error = ext4_journal_get_write_access(handle, iloc->bh);
+	if (error)
+		goto out;
+
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	if (error) {
+		if (error == -ENOSPC)
+			ext4_clear_inode_state(inode,
+					       EXT4_STATE_MAY_INLINE_DATA);
+		goto out;
+	}
+
+	get_bh(iloc->bh);
+	error = ext4_mark_iloc_dirty(handle, inode, iloc);
+
+	EXT4_I(inode)->i_inline_off = (u16)((void *)is.s.here -
+				      (void *)ext4_raw_inode(iloc));
+	EXT4_I(inode)->i_inline_size = size;
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+out:
+	kfree(value);
+	return error;
+}
+
+int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = 0, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
+		.name = EXT4_XATTR_SYSTEM_DATA_NAME,
+		.value = NULL,
+		.value_len = 0,
+	};
+	int error;
+
+	if (!ei->i_inline_off)
+		return 0;
+
+	error = ext4_get_inode_loc(inode, &is.iloc);
+	if (error)
+		return error;
+
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		goto out;
+
+	error = ext4_journal_get_write_access(handle, is.iloc.bh);
+	if (error)
+		goto out;
+
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	if (error)
+		goto out;
+
+	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+
+	EXT4_I(inode)->i_inline_off = 0;
+	EXT4_I(inode)->i_inline_size = 0;
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+out:
+	return error;
+}
+
 /*
  * ext4_xattr_set_handle()
  *
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 25b7387..ca3b05b 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_SYSTEM_DATA		7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -88,6 +89,18 @@ extern void ext4_exit_xattr(void);
 
 extern const struct xattr_handler *ext4_xattr_handlers[];
 
+extern int ext4_has_inline_data(struct inode *inode);
+extern int ext4_get_max_inline_size(struct inode *inode);
+extern int ext4_find_inline_data(struct inode *inode, struct ext4_iloc *iloc);
+extern void* ext4_get_inline_data_pos(struct inode *inode,
+				      struct ext4_iloc *iloc);
+extern void ext4_read_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+				  void *buffer, size_t len);
+extern void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+				   void *buffer, loff_t pos, unsigned len);
+extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
+				 struct ext4_iloc *iloc);
+extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -141,6 +154,61 @@ ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 #define ext4_xattr_handlers	NULL
 
+static inline int ext4_find_inline_data(struct inode *inode,
+					struct ext4_iloc *iloc)
+{
+	return 0;
+}
+
+static inline void* ext4_get_inline_data_pos(struct inode *inode,
+					     struct ext4_iloc *iloc)
+{
+	return NULL;
+}
+
+static inline int ext4_has_inline_data(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_get_max_inline_size(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_find_inline_data(struct inode *inode,
+					struct ext4_iloc *iloc)
+{
+	return 0;
+}
+
+static inline void ext4_read_inline_data(struct inode *inode,
+					 struct ext4_iloc *iloc,
+					 void *buffer, size_t len)
+{
+	return;
+}
+
+static inline void ext4_write_inline_data(struct inode *inode,
+					  struct ext4_iloc *iloc,
+					  void *buffer, loff_t pos,
+					  unsigned len)
+{
+	return;
+}
+
+static inline int ext4_init_inline_data(handle_t *handle,
+					struct inode *inode,
+					struct ext4_iloc *iloc)
+{
+	return 0;
+}
+
+static inline int ext4_destroy_inline_data(handle_t *handle,
+					   struct inode *inode)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4
