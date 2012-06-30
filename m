From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 03/23] ext4: Add the basic function for inline data support.
Date: Sat, 30 Jun 2012 23:45:04 +0800
Message-ID: <1341071124-4976-3-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56646 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754489Ab2F3Prr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:47:47 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skzth-0006eg-NO
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:47:46 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Implement inline data with xattr.
Now we use "system.data" to store xattr, and the xattr will
be extended if the i_size is increased while we don't release
the space during truncate.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/Makefile |    2 +-
 fs/ext4/ext4.h   |    7 +
 fs/ext4/inline.c |  461 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c  |    5 +-
 fs/ext4/xattr.h  |   54 +++++++
 5 files changed, 527 insertions(+), 2 deletions(-)
 create mode 100644 fs/ext4/inline.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f8..e88b7a6 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -9,6 +9,6 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
 		mmp.o indirect.o
 
-ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
+ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o inline.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..c755826 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -393,6 +393,7 @@ struct flex_groups {
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+#define EXT4_INLINE_DATA_FL		0x00800000 /* Inode has inline data. */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
@@ -449,6 +450,7 @@ enum {
 	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
+	EXT4_INODE_INLINE_DATA	= 23,	/* Data in inode. */
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
@@ -901,6 +903,10 @@ struct ext4_inode_info {
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
+	/* Indicate the inline data space. */
+	u16 i_inline_off;
+	u16 i_inline_size;
+
 #ifdef CONFIG_QUOTA
 	/* quota space reservation, managed internally by quota code */
 	qsize_t i_reserved_quota;
@@ -1342,6 +1348,7 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
new file mode 100644
index 0000000..8f4178f
--- /dev/null
+++ b/fs/ext4/inline.c
@@ -0,0 +1,461 @@
+/*
+ * Copyright (c) 2011 Taobao.
+ * Written by Tao Ma <boyu.mt@taobao.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include "ext4_jbd2.h"
+#include "ext4.h"
+#include "xattr.h"
+
+#define EXT4_XATTR_SYSTEM_DATA	"data"
+#define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
+
+int ext4_get_inline_size(struct inode *inode)
+{
+	if (EXT4_I(inode)->i_inline_off)
+		return EXT4_I(inode)->i_inline_size;
+
+	return 0;
+}
+
+static int get_max_inline_xattr_value_size(struct inode *inode,
+					   struct ext4_iloc *iloc)
+{
+	struct ext4_xattr_ibody_header *header;
+	struct ext4_xattr_entry *entry;
+	struct ext4_inode *raw_inode;
+	int free, min_offs;
+
+	min_offs = EXT4_SB(inode->i_sb)->s_inode_size -
+			EXT4_GOOD_OLD_INODE_SIZE -
+			EXT4_I(inode)->i_extra_isize -
+			sizeof(struct ext4_xattr_ibody_header);
+
+	/*
+	 * We need to abstrace another sizeof(__u32) since an in-inode xattr
+	 * needs an empty 4 bytes to indicate the gap between the xattr entry
+	 * and the name/value pair.
+	 */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
+		return EXT4_XATTR_SIZE(min_offs -
+			EXT4_XATTR_LEN(strlen(EXT4_XATTR_SYSTEM_DATA)) -
+			EXT4_XATTR_ROUND - sizeof(__u32));
+
+	raw_inode = ext4_raw_inode(iloc);
+	header = IHDR(inode, raw_inode);
+	entry = IFIRST(header);
+
+	/* Compute min_offs. */
+	for (; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry)) {
+		if (!entry->e_value_block && entry->e_value_size) {
+			size_t offs = le16_to_cpu(entry->e_value_offs);
+			if (offs < min_offs)
+				min_offs = offs;
+		}
+	}
+	free = min_offs -
+		((void *)entry - (void *)IFIRST(header)) - sizeof(__u32);
+
+	if (EXT4_I(inode)->i_inline_off) {
+		entry = (struct ext4_xattr_entry *)
+			((void *)raw_inode + EXT4_I(inode)->i_inline_off);
+
+		free += le32_to_cpu(entry->e_value_size);
+		goto out;
+	}
+
+	free -= EXT4_XATTR_LEN(strlen(EXT4_XATTR_SYSTEM_DATA));
+
+	if (free > EXT4_XATTR_ROUND)
+		free = EXT4_XATTR_SIZE(free - EXT4_XATTR_ROUND);
+	else
+		free = 0;
+
+out:
+	return free;
+}
+
+/*
+ * Get the maximum size we now can store in an inode.
+ * If we can't find the space for a xattr entry, don't use the space
+ * of the extents since we have no space to indicate the inline data.
+ */
+int ext4_get_max_inline_size(struct inode *inode)
+{
+	int error, max_inline_size;
+	struct ext4_iloc iloc;
+
+	if (EXT4_I(inode)->i_extra_isize == 0)
+		return 0;
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+				 "can't get inode location %lu",
+				 inode->i_ino);
+		return 0;
+	}
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	max_inline_size = get_max_inline_xattr_value_size(inode, &iloc);
+	up_read(&EXT4_I(inode)->xattr_sem);
+
+	brelse(iloc.bh);
+
+	if (!max_inline_size)
+		return 0;
+
+	return max_inline_size + EXT4_MIN_INLINE_DATA_SIZE;
+}
+
+int ext4_has_inline_data(struct inode *inode)
+{
+	return ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA) &&
+	       EXT4_I(inode)->i_inline_off;
+}
+
+int ext4_find_inline_data(struct inode *inode)
+{
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
+	};
+	int error;
+
+	if (EXT4_I(inode)->i_extra_isize == 0)
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
+	if (!is.s.not_found) {
+		EXT4_I(inode)->i_inline_off = (u16)((void *)is.s.here -
+					(void *)ext4_raw_inode(&is.iloc));
+		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
+				le32_to_cpu(is.s.here->e_value_size);
+		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	}
+out:
+	brelse(is.iloc.bh);
+	return error;
+}
+
+static int ext4_read_inline_data(struct inode *inode, void *buffer,
+				 unsigned int len,
+				 struct ext4_iloc *iloc)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+	int cp_len = 0;
+	struct ext4_inode *raw_inode;
+
+	if (!len)
+		return 0;
+
+	BUG_ON(len > EXT4_I(inode)->i_inline_size);
+
+	cp_len = len < EXT4_MIN_INLINE_DATA_SIZE ?
+			len : EXT4_MIN_INLINE_DATA_SIZE;
+
+	raw_inode = ext4_raw_inode(iloc);
+	memcpy(buffer, (void *)(raw_inode->i_block), cp_len);
+
+	len -= cp_len;
+	buffer += cp_len;
+
+	if (!len)
+		goto out;
+
+	header = IHDR(inode, raw_inode);
+	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
+					    EXT4_I(inode)->i_inline_off);
+	len = min_t(unsigned int, len,
+		    (unsigned int)le32_to_cpu(entry->e_value_size));
+
+	memcpy(buffer,
+	       (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
+	cp_len += len;
+
+out:
+	return cp_len;
+}
+
+/*
+ * write the buffer to the inline inode.
+ * If 'create' is set, we don't need to do the extra copy in the xattr
+ * value since it is already handled by ext4_xattr_ibody_set. That saves
+ * us one memcpy.
+ */
+void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+			    void *buffer, loff_t pos, unsigned int len)
+{
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_ibody_header *header;
+	struct ext4_inode *raw_inode;
+	int cp_len = 0;
+
+	BUG_ON(!EXT4_I(inode)->i_inline_off);
+	BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
+
+	raw_inode = ext4_raw_inode(iloc);
+	buffer += pos;
+
+	if (pos < EXT4_MIN_INLINE_DATA_SIZE) {
+		cp_len = pos + len > EXT4_MIN_INLINE_DATA_SIZE ?
+			 EXT4_MIN_INLINE_DATA_SIZE - pos : len;
+		memcpy((void *)raw_inode->i_block + pos, buffer, cp_len);
+
+		len -= cp_len;
+		buffer += cp_len;
+		pos += cp_len;
+	}
+
+	if (!len)
+		return;
+
+	pos -= EXT4_MIN_INLINE_DATA_SIZE;
+	header = IHDR(inode, raw_inode);
+	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
+					    EXT4_I(inode)->i_inline_off);
+
+	memcpy((void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs) + pos,
+	       buffer, len);
+}
+
+static int ext4_create_inline_data(handle_t *handle,
+				   struct inode *inode, unsigned len)
+{
+	int error;
+	void *value = NULL;
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
+	};
+
+	error = ext4_get_inode_loc(inode, &is.iloc);
+	if (error)
+		return error;
+
+	error = ext4_journal_get_write_access(handle, is.iloc.bh);
+	if (error)
+		goto out;
+
+	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
+		value = (void *)empty_zero_page;
+		len -= EXT4_MIN_INLINE_DATA_SIZE;
+	} else {
+		value = "";
+		len = 0;
+	}
+
+	/* Insert the the xttr entry. */
+	i.value = value;
+	i.value_len = len;
+
+	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (error)
+		goto out;
+
+	BUG_ON(!is.s.not_found);
+
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	if (error) {
+		if (error == -ENOSPC)
+			ext4_clear_inode_state(inode,
+					       EXT4_STATE_MAY_INLINE_DATA);
+		goto out;
+	}
+
+	memset((void *)ext4_raw_inode(&is.iloc)->i_block,
+		0, EXT4_MIN_INLINE_DATA_SIZE);
+
+	EXT4_I(inode)->i_inline_off = (u16)((void *)is.s.here -
+				      (void *)ext4_raw_inode(&is.iloc));
+	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
+	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
+	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	get_bh(is.iloc.bh);
+	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+
+out:
+	brelse(is.iloc.bh);
+	return error;
+}
+
+static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
+				   unsigned int len)
+{
+	int error;
+	void *value = NULL;
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
+	};
+
+	/* If the old space is ok, write the data directly. */
+	if (len <= EXT4_I(inode)->i_inline_size)
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
+	BUG_ON(is.s.not_found);
+
+	len -= EXT4_MIN_INLINE_DATA_SIZE;
+	value = kzalloc(len, GFP_NOFS);
+	if (!value)
+		goto out;
+
+	error = ext4_xattr_ibody_get(inode, i.name_index, i.name,
+				     value, len);
+	if (error == -ENODATA)
+		goto out;
+
+	error = ext4_journal_get_write_access(handle, is.iloc.bh);
+	if (error)
+		goto out;
+
+	/* Update the xttr entry. */
+	i.value = value;
+	i.value_len = len;
+
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+	if (error)
+		goto out;
+
+	EXT4_I(inode)->i_inline_off = (u16)((void *)is.s.here -
+				      (void *)ext4_raw_inode(&is.iloc));
+	EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
+				le32_to_cpu(is.s.here->e_value_size);
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	get_bh(is.iloc.bh);
+	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+
+out:
+	kfree(value);
+	brelse(is.iloc.bh);
+	return error;
+}
+
+int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
+			     unsigned int len)
+{
+	int ret, size;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return -ENOSPC;
+
+	size = ext4_get_max_inline_size(inode);
+	if (size < len)
+		return -ENOSPC;
+
+	down_write(&EXT4_I(inode)->xattr_sem);
+
+	if (ei->i_inline_off)
+		ret = ext4_update_inline_data(handle, inode, len);
+	else
+		ret = ext4_create_inline_data(handle, inode, len);
+
+	up_write(&EXT4_I(inode)->xattr_sem);
+
+	return ret;
+}
+
+static int ext4_destroy_inline_data_nolock(handle_t *handle,
+					   struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = 0, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM,
+		.name = EXT4_XATTR_SYSTEM_DATA,
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
+	memset((void *)ext4_raw_inode(&is.iloc)->i_block,
+		0, EXT4_MIN_INLINE_DATA_SIZE);
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(inode->i_sb,
+				      EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+		if (S_ISDIR(inode->i_mode) ||
+		    S_ISREG(inode->i_mode) || S_ISLNK(inode->i_mode)) {
+			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
+			ext4_ext_tree_init(handle, inode);
+		}
+	}
+	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+
+	get_bh(is.iloc.bh);
+	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
+
+	EXT4_I(inode)->i_inline_off = 0;
+	EXT4_I(inode)->i_inline_size = 0;
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+out:
+	brelse(is.iloc.bh);
+	if (error == -ENODATA)
+		error = 0;
+	return error;
+}
+
+int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
+{
+	int ret;
+
+	down_write(&EXT4_I(inode)->xattr_sem);
+	ret = ext4_destroy_inline_data_nolock(handle, inode);
+	up_write(&EXT4_I(inode)->xattr_sem);
+
+	return ret;
+}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 21793ea..4238df1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3693,8 +3693,10 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 {
 	__le32 *magic = (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
-	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
+	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
+		ext4_find_inline_data(inode);
+	}
 }
 
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
@@ -3767,6 +3769,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
+	ei->i_inline_off = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
 	/* We now have enough fields to check if the inode was active or not.
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 8c61a41..8c51edf 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_SYSTEM			7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -125,6 +126,19 @@ extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
 				struct ext4_xattr_ibody_find *is);
 
+extern int ext4_has_inline_data(struct inode *inode);
+extern int ext4_get_inline_size(struct inode *inode);
+extern int ext4_get_max_inline_size(struct inode *inode);
+extern int ext4_find_inline_data(struct inode *inode);
+extern void ext4_write_inline_data(struct inode *inode,
+				   struct ext4_iloc *iloc,
+				   void *buffer, loff_t pos,
+				   unsigned int len);
+extern int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
+				    unsigned int len);
+extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
+				 unsigned int len);
+extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -200,6 +214,46 @@ extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
 	return -EOPNOTSUPP;
 }
 
+static inline int ext4_find_inline_data(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_has_inline_data(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_get_inline_size(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int ext4_get_max_inline_size(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void ext4_write_inline_data(struct inode *inode,
+					  struct ext4_iloc *iloc,
+					  void *buffer, loff_t pos,
+					  unsigned int len)
+{
+	return;
+}
+
+static inline int ext4_init_inline_data(handle_t *handle,
+					struct inode *inode,
+					unsigned int len)
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

