From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC 9/9] ext4: Make ext4_readdir() use itree if available
Date: Sat,  4 May 2013 23:28:42 +0200
Message-ID: <1367702922-3236-10-git-send-email-rpazdera@redhat.com>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759528Ab3EDVef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:34:35 -0400
In-Reply-To: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds an alternative implementation of ext4_readdir() that
will read the directory in inode order in case there is a inode tree
available in the directory index.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/dir.c   | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/ext4.h  |   9 +++
 fs/ext4/namei.c | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d8cd1f0..1cb1d55 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -29,8 +29,8 @@
 #include "ext4.h"
 #include "xattr.h"
 
-static int ext4_dx_readdir(struct file *filp,
-			   void *dirent, filldir_t filldir);
+static int ext4_dx_readdir(struct file *filp, void *dirent, filldir_t filldir);
+static int ext4_itree_readdir(struct file *filp, void *buf, filldir_t filldir);
 
 /**
  * Check if the given dir-inode refers to an htree-indexed directory
@@ -123,6 +123,12 @@ static int ext4_readdir(struct file *filp,
 			return ret;
 	}
 
+	if (dx_itree(inode)) {
+		ret = ext4_itree_readdir(filp, dirent, filldir);
+		if (!ret)
+			goto out;
+	}
+
 	if (is_dx_dir(inode)) {
 		err = ext4_dx_readdir(filp, dirent, filldir);
 		if (err != ERR_BAD_DX_DIR) {
@@ -348,14 +354,16 @@ static loff_t ext4_dir_llseek(struct file *file, loff_t offset, int whence)
 }
 
 /*
- * This structure holds the nodes of the red-black tree used to store
- * the directory entry in hash order.
+ * This structure holds the nodes of the red-black tree while reading
+ * the directory in hash order. It is also used to store collision
+ * chains while reading the directory in inode order.
  */
 struct fname {
 	__u32		hash;
 	__u32		minor_hash;
 	struct rb_node	rb_hash;
 	struct fname	*next;
+	struct list_head cache_list;
 	__u32		inode;
 	__u8		name_len;
 	__u8		file_type;
@@ -611,10 +619,167 @@ finished:
 	return 0;
 }
 
+/*
+ * While reading the directory from using the inode tree,
+ * the filp->f_pos offset is set to the current key, i.e.,
+ * the inode and the hash of the entry read. The LSB in the
+ * 32bit hash value is not used, so we use it to indicate
+ * the end of the directory file.
+ */
+#define ITREE_POS_HASH_OFF	0
+#define ITREE_POS_INODE_OFF	32
+#define ITREE_POS_EOF_BIT	1
+
+loff_t itree_get_pos(u32 ino, u32 hash)
+{
+	return ((loff_t)(ino) << ITREE_POS_INODE_OFF) |
+	       ((loff_t)(hash) << ITREE_POS_HASH_OFF);
+}
+
+static u32 itree_pos_to_inode(loff_t pos)
+{
+	return (u32)(pos >> ITREE_POS_INODE_OFF);
+}
+
+static u32 itree_pos_to_hash(loff_t pos)
+{
+	return (u32)(pos >> ITREE_POS_HASH_OFF) & (~1);
+}
+
+struct dir_private_info *ext4_itree_create_dir_info(struct file *filp,
+						    loff_t pos)
+{
+	struct dir_private_info *info;
+
+	info = kzalloc(sizeof(struct dir_private_info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	INIT_LIST_HEAD(&(info->entry_cache));
+	info->curr_inode = itree_pos_to_inode(pos);
+	info->curr_hash  = itree_pos_to_hash(pos);
+	return info;
+}
+
+void ext4_itree_free_entry_cache(struct dir_private_info *info)
+{
+	struct list_head *list = &(info->entry_cache);
+	struct fname *entry, *next;
+	list_for_each_entry_safe(entry, next, list, cache_list) {
+		list_del(&(entry->cache_list));
+		kfree(entry);
+	}
+}
+
+void ext4_itree_free_dir_info(struct dir_private_info *info)
+{
+	ext4_itree_free_entry_cache(info);
+	kfree(info);
+}
+
+/*
+ * Store an entry into the collision chain.
+ *
+ * This can occur in case the filldir buffer runs out during a
+ * collision between two entries in the tree. We must read them
+ * all at once and store them in memory, because the next round
+ * of filldir starting from this key would return some of the
+ * entries again.
+ */
+int itree_cache_entry(struct list_head *entry_cache, u32 hash,
+		      struct ext4_dir_entry_2 *de)
+{
+	struct fname *entry;
+	int len = sizeof(struct fname) + de->name_len + 1;
+
+	entry = kzalloc(len, GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->hash = hash;
+	entry->inode = le32_to_cpu(de->inode);
+	entry->file_type = de->file_type;
+	entry->name_len = de->name_len;
+	memcpy(entry->name, de->name, entry->name_len);
+
+	list_add_tail(&(entry->cache_list), entry_cache);
+	return 0;
+}
+
+int ext4_itree_readdir(struct file *filp, void *buf, filldir_t filldir)
+{
+	struct inode *dir = filp->f_path.dentry->d_inode;
+	struct dir_private_info *info = filp->private_data;
+	struct fname *entry, *next;
+	int retval = 0;
+	u32 ino, hash, new_ino, new_hash;
+	loff_t pos;
+
+	if (!info) {
+		info = ext4_itree_create_dir_info(filp, filp->f_pos);
+		if (!info)
+			return -ENOMEM;
+		filp->private_data = info;
+	}
+
+	/* Someone changed the position, drop the collision chain */
+	if (filp->f_pos != info->last_pos) {
+		ext4_itree_free_entry_cache(info);
+		info->curr_inode = itree_pos_to_inode(filp->f_pos);
+		info->curr_hash = itree_pos_to_hash(filp->f_pos);
+	}
+
+	/* Return the entries from the collision chain first */
+	if (!list_empty(&(info->entry_cache))) {
+		list_for_each_entry_safe(entry, next, &(info->entry_cache),
+					 cache_list) {
+			retval = filldir(buf, entry->name, entry->name_len,
+					 filp->f_pos, entry->inode,
+					 get_dtype(dir->i_sb,
+						   entry->file_type));
+			pos = itree_get_pos(entry->inode, entry->hash);
+			if (filp->f_pos & ITREE_POS_EOF_BIT)
+				pos |= ITREE_POS_EOF_BIT;
+			filp->f_pos = pos;
+			if (retval) {
+				if (retval == -EINVAL)
+					return 0; /* buffer full */
+				return retval;
+			}
+			list_del(&(entry->cache_list));
+			kfree(entry);
+		}
+	}
+
+	/* The end of the directory file */
+	if (filp->f_pos & ITREE_POS_EOF_BIT)
+		return 0;
+
+	ino = itree_pos_to_inode(filp->f_pos);
+	hash = itree_pos_to_hash(filp->f_pos);
+
+	/* Read entries from the itree */
+	retval = ext4_read_itree(dir, ino, hash, buf, filldir,
+				 &(info->entry_cache), &new_ino, &new_hash);
+
+	filp->f_pos = itree_get_pos(new_ino, new_hash);
+	if (retval > 0) {
+		filp->f_pos |= ITREE_POS_EOF_BIT;
+		retval = 0;
+	}
+	info->last_pos = filp->f_pos;
+
+	return retval;
+}
+
 static int ext4_release_dir(struct inode *inode, struct file *filp)
 {
-	if (filp->private_data)
-		ext4_htree_free_dir_info(filp->private_data);
+	if (filp->private_data) {
+		if (dx_itree(inode))
+			ext4_itree_free_dir_info(filp->private_data);
+		else
+			ext4_htree_free_dir_info(filp->private_data);
+	}
 
 	return 0;
 }
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 763f958..b87aaf1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1775,7 +1775,9 @@ struct dir_private_info {
 	struct rb_root	root;
 	struct rb_node	*curr_node;
 	struct fname	*extra_fname;
+	struct list_head entry_cache;
 	loff_t		last_pos;
+	__u32		curr_inode;	/* Used only for itree */
 	__u32		curr_hash;
 	__u32		curr_minor_hash;
 	__u32		next_hash;
@@ -1984,6 +1986,9 @@ void ext4_insert_dentry(struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
 			const char *name, int namelen);
+extern loff_t itree_get_pos(u32 ino, u32 hash);
+extern int itree_cache_entry(struct list_head *entry_cache, u32 hash,
+			     struct ext4_dir_entry_2 *de);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
@@ -2150,6 +2155,10 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 				     int buf_size,
 				     int csum_size);
 
+extern int ext4_read_itree(struct inode *dir, u32 ino, u32 hash, void *buf,
+			   filldir_t filldir, struct list_head *entry_cache,
+			   u32 *new_ino, u32 *new_hash);
+
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
 				struct ext4_new_group_data *input);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6e941af..da5e630 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -5240,6 +5240,171 @@ out:
 	return err;
 }
 
+/*
+ * Returns negative on error, zero when the end of the block was
+ * reached, and positive in case the filldir buffer is full.
+ */
+static int itree_leaf_to_buffer(struct inode *dir, u32 start_ino,
+				u32 start_hash,	ext4_fsblk_t leaf_blk,
+				void *buf, filldir_t filldir,
+				struct list_head *entry_cache,
+				int *continuation, u32 *last_ino,
+				u32 *last_hash)
+{
+	struct buffer_head *bh;
+	struct itree_leaf_head *lh;
+	struct itree_leaf_entry *le;
+	struct ext4_dir_entry_2 *de;
+	int blocksize, err = 0, retval;
+	loff_t pos;
+	u32 ino, hash;
+	int buffer_full = 0;
+
+	bh = sb_bread(dir->i_sb, leaf_blk);
+	if (!bh)
+		return -EIO;
+
+	blocksize = dir->i_sb->s_blocksize;
+	lh = itree_leaf_get_head(bh);
+
+	itree_leaf_for_each(le, de, lh, blocksize) {
+		ino = le32_to_cpu(de->inode);
+		hash = le32_to_cpu(le->hash);
+
+		if (buffer_full) {
+			err = 1; /* buffer full */
+			if (ino == *last_ino && hash == *last_hash) {
+				retval = itree_cache_entry(entry_cache,
+							le32_to_cpu(le->hash),
+							de);
+				if (retval) /* FIXME report error */
+					break;
+				*continuation = 1;
+			} else {
+				*continuation = 0;
+				break;
+			}
+		} else if (ino && (ino > start_ino || (ino == start_ino &&
+						       hash > start_hash))) {
+			pos = itree_get_pos(ino, hash);
+			retval = filldir(buf, de->name, de->name_len, pos, ino,
+					 get_dtype(dir->i_sb, de->file_type));
+			if (retval) {
+				err = 1;
+				if (retval != -EINVAL) { /* error */
+					err = retval;
+					break;
+				}
+				/* buffer full */
+				buffer_full = 1;
+				continue;
+			}
+			*last_ino = ino;
+			*last_hash = hash;
+		}
+	}
+
+	brelse(bh);
+	return err;
+}
+
+int ext4_read_itree(struct inode *dir, u32 ino, u32 hash, void *buf,
+		    filldir_t filldir, struct list_head *entry_cache,
+		    u32 *new_ino, u32 *new_hash)
+{
+	struct itree_frame frames[ITREE_MAX_DEPTH];
+	struct itree_frame *frame;
+	struct buffer_head *bh;
+	struct itree_key key;
+	struct dx_root *dxr;
+	ext4_fsblk_t root_blk, leaf_blk;
+	int err = 0, retval;
+	int cont = 0;
+
+	/* TODO Split the finding code to itree_find_entry? */
+	/* TODO Merge the finding code with itree_delete_entry()*/
+
+	memset(frames, 0, ITREE_MAX_DEPTH*sizeof(struct itree_frame));
+
+	key.inode = ino;
+	key.hash = hash;
+
+	/* Get itree root block */
+	bh = ext4_bread(NULL, dir, 0, 0, &err);
+	if (!bh)
+		return err;
+
+	/* FIXME: Check if it is still a itree dir */
+
+	dxr = (struct dx_root *)bh->b_data;
+
+	/* . */
+	if (!ino && (hash < 2)) {
+		retval = filldir(buf, dxr->dot_name, dxr->dot.name_len,
+				 itree_get_pos(0, hash),
+				 le32_to_cpu(dxr->dot.inode),
+				 get_dtype(dir->i_sb, dxr->dot.file_type));
+		*new_hash = hash + 2;
+		if (retval) {
+			if (retval == -EINVAL)
+				return 0;
+			return retval;
+		}
+	}
+
+	/* .. */
+	if (!ino && (hash < 4)) {
+		retval = filldir(buf, dxr->dotdot_name, dxr->dotdot.name_len,
+				 itree_get_pos(0, hash),
+				 le32_to_cpu(dxr->dotdot.inode),
+				 get_dtype(dir->i_sb, dxr->dotdot.file_type));
+		*new_hash = hash + 4;
+		if (retval) {
+			if (retval == -EINVAL)
+				return 0;
+			return retval;
+		}
+	}
+
+	err = dx_get_itree_root(dir, (struct ext4_dir_entry *)bh->b_data,
+				&root_blk);
+	brelse(bh);
+	if (err)
+		return err;
+
+	frame = itree_probe(&key, dir, root_blk, frames, &err);
+	if (!frame)
+		return err;
+
+	while (1) {
+		leaf_blk = le64_to_cpu(frame->at->block);
+		retval = itree_leaf_to_buffer(dir, ino, hash, leaf_blk, buf,
+					      filldir, entry_cache, &cont,
+					      new_ino, new_hash);
+
+		/* error */
+		if (retval < 0) {
+			err = retval;
+			break;
+		}
+
+		/* buffer full */
+		if (retval > 0 && !cont) {
+			err = 0;
+			break;
+		}
+
+		/* retval == 0; get next block */
+		err = itree_next_frame(dir, ino, frames, frame, 1);
+		if (err)
+			goto out;
+	}
+
+out:
+	itree_release_frames(frames);
+	return err;
+}
+
 #ifdef ITREE_DEBUG
 static void itree_show_node(struct buffer_head *bh)
 {
-- 
1.7.11.7

