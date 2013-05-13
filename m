From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 5/9] ext4: Adding itree implementation I - Core
Date: Mon, 13 May 2013 17:42:06 +0200
Message-ID: <1368459730-3405-6-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3EMQmw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:52 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit contains the basic code related to the new inode tree
including the common/helper functions, tree initialisation, and
a few functions for debugging.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 729 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 729 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c9b6c91..1f9ea5b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -311,6 +311,49 @@ struct itree_frame {
 	struct itree_entry *at;
 };
 
+/*
+ * The depth of the tree is limited for convenience, so we can allocate
+ * itree_frames statically on the stack.
+ *
+ * With three levels, the tree can take around 12 millions of entries
+ * in the worst case scenario of 255 characters per file name and each
+ * node of the tree only half-full. In a much more likely case of 20B
+ * per name and 75% average fullness, the tree capacity is roughly 0.5
+ * billion of entries.
+ *
+ * In case those limits are exceeded, the capacity of the tree can be
+ * increased by incrementing this constant.
+ */
+#define ITREE_MAX_DEPTH 3
+
+static int itree_init(handle_t *handle, struct inode *dir,
+		      struct dx_hash_info *hinfo,
+		      struct ext4_dir_entry_2 *dirents,
+		      struct dentry *entry, struct inode *inode,
+		      ext4_fsblk_t *root_block);
+
+static int itree_next_frame(struct inode *dir, u32 ino,
+			    struct itree_frame *frames,
+			    struct itree_frame *frame_in,
+			    int allways);
+
+#define itree_leaf_for_each(le, de, head, blocksize) \
+	for (le = ((void *)head + sizeof(struct itree_leaf_head)), \
+	     de = &(le->dirent); \
+	     le < (struct itree_leaf_entry *)((void *)head + blocksize); \
+	     le = itree_next_leaf_entry(le, blocksize), de = &(le->dirent))
+
+#define ITREE_DEBUG__
+#ifdef ITREE_DEBUG
+#define itree_debug(command) command
+static void itree_show_node(struct buffer_head *bh);
+static void itree_show_leaf(struct inode *dir, struct buffer_head *bh,
+			    ext4_fsblk_t *block);
+static void itree_show(struct inode *dir, ext4_fsblk_t block);
+#else
+#define itree_debug(command)
+#endif
+
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry);
 static void dx_set_block(struct dx_entry *entry, ext4_lblk_t value);
 static inline unsigned dx_get_hash(struct dx_entry *entry);
@@ -3391,3 +3434,689 @@ const struct inode_operations ext4_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 };
+
+/*
+ * TODO Add BUFFER_TRACEs where they should be
+ */
+
+static unsigned get_itree_node_limit(int blocksize)
+{
+	unsigned space = blocksize - sizeof(struct itree_node);
+	return space / sizeof(struct itree_entry);
+}
+
+static void ext4_free_itree_block(handle_t *handle, struct inode *inode,
+				  ext4_fsblk_t block)
+{
+	int flags = EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET;
+	ext4_free_blocks(handle, inode, NULL, block, 1, flags);
+}
+
+static struct itree_leaf_head *itree_leaf_get_head(struct buffer_head *leaf)
+{
+	return (struct itree_leaf_head *)leaf->b_data;
+}
+
+static struct itree_leaf_entry *itree_leaf_get_entries(struct buffer_head *leaf)
+{
+	void *entries = (void *)leaf->b_data + sizeof(struct itree_leaf_head);
+	return (struct itree_leaf_entry *)entries;
+}
+
+static void itree_entry_get_key(struct itree_entry *entry,
+				struct itree_key *key)
+{
+	key->inode = le32_to_cpu(entry->inode);
+	key->hash = le32_to_cpu(entry->hash);
+}
+
+static void itree_leaf_entry_get_key(struct itree_leaf_entry *entry,
+				     struct itree_key *key)
+{
+	key->inode = le32_to_cpu(entry->dirent.inode);
+	key->hash = le32_to_cpu(entry->hash);
+}
+
+static int itree_key_compare(struct itree_key *one, struct itree_key *two)
+{
+	if (one->inode < two->inode)
+		return -1;
+	if (one->inode > two->inode)
+		return 1;
+
+	if (one->hash < two->hash)
+		return -1;
+	if (one->hash > two->hash)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Returned buffer is locked. The caller is expected to mark it
+ * uptodate and unlock it after it is initialized.
+ */
+static struct buffer_head *ext4_new_itree_block(handle_t *handle,
+						struct inode *inode,
+						ext4_fsblk_t *block, int *err)
+{
+	struct buffer_head *bh;
+	ext4_fsblk_t new_blk;
+
+	new_blk = ext4_new_meta_blocks(handle, inode,
+				       ext4_inode_to_goal_block(inode),
+				       EXT4_MB_HINT_METADATA, NULL, err);
+	if (!new_blk)
+		return NULL;
+
+	bh = sb_getblk(inode->i_sb, new_blk);
+	if (!bh) {
+		*err = -ENOMEM;
+		goto fail;
+	}
+
+	lock_buffer(bh);
+
+	*err = ext4_journal_get_create_access(handle, bh);
+	if (*err) {
+		unlock_buffer(bh);
+		brelse(bh);
+		goto fail;
+	}
+
+	*block = new_blk;
+	return bh;
+
+fail:
+	ext4_free_itree_block(handle, inode, *block);
+	return NULL;
+}
+
+static u8 itree_get_fullness(int value, int value_max)
+{
+	int fullness = ((value * 255) / value_max) + 1;
+	return fullness > 255 ? 255 : fullness;
+}
+
+static u8 itree_get_leaf_fullness(struct itree_leaf_head *head, int blocksize)
+{
+	int value = le16_to_cpu(head->used_length);
+	int max = blocksize - sizeof(struct itree_leaf_head);
+
+	return itree_get_fullness(value, max);
+}
+
+static u8 itree_get_node_fullness(struct itree_node *node)
+{
+	int value = le16_to_cpu(node->count);
+	int max = le16_to_cpu(node->limit);
+
+	return itree_get_fullness(value, max);
+}
+
+static int itree_update_fullness(handle_t *handle, struct inode *dir,
+				 struct itree_frame *frame, u8 fullness)
+{
+	struct buffer_head *bh = frame->bh;
+	struct itree_entry *entry = frame->at;
+	int err;
+
+	err = ext4_journal_get_write_access(handle, bh);
+	if (err)
+		return err;
+
+	entry->fullness = fullness;
+
+	err = ext4_handle_dirty_metadata(handle, dir, bh);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct itree_frame *itree_probe(struct itree_key *key, struct inode *dir,
+				       ext4_fsblk_t itree_root_blk,
+				       struct itree_frame *frame_in, int *err)
+{
+	struct itree_frame *frame = frame_in;
+	struct buffer_head *bh;
+	struct itree_node *node;
+	struct itree_entry *entries, *at, *p, *q, *m;
+	struct itree_key entry_key;
+	unsigned count, indirect;
+
+	bh = sb_bread(dir->i_sb, itree_root_blk);
+	if (!bh) {
+		*err = -EIO;
+		return NULL;
+	}
+
+	/* TODO Verify checksum */
+
+	node = (struct itree_node *)bh->b_data;
+	if (node->indirect_levels >= ITREE_MAX_DEPTH) {
+		ext4_warning(dir->i_sb, "Too many levels in itree.");
+		return NULL;
+	}
+
+	while (1) {
+		frame->bh = NULL;
+		node = (struct itree_node *)bh->b_data;
+		entries = node->entries;
+		count = le16_to_cpu(node->count);
+		indirect = node->indirect_levels;
+
+		if (key->inode < le32_to_cpu(entries[0].inode)) {
+			at = entries;
+		} else {
+			p = entries;
+			q = entries + count - 1;
+			while (p <= q) {
+				m = p + (q - p)/2;
+				itree_entry_get_key(m, &entry_key);
+				if (itree_key_compare(&entry_key, key) > 0)
+					q = m - 1;
+				else
+					p = m + 1;
+			}
+			at = p - 1;
+		}
+
+		while ((at->flags & ITREE_NODE_FL_CONT) && at > entries &&
+		       le32_to_cpu(at->inode) == key->inode)
+			at--;
+
+		frame->bh = bh;
+		frame->entries = entries;
+		frame->at = at;
+
+		if (!indirect--)
+			return frame;
+
+		bh = sb_bread(dir->i_sb, le64_to_cpu(at->block));
+		if (!bh)
+			goto fail;
+
+		frame++;
+	}
+
+	return frame;
+
+fail:
+	while (frame >= frame_in) {
+		brelse(frame->bh);
+		frame--;
+	}
+	return NULL;
+}
+
+/*
+ * frames must be an array of at least two
+ */
+static void itree_release_frames(struct itree_frame *frames)
+{
+	int n;
+
+	for (n = 0; n < ITREE_MAX_DEPTH; n++)
+		if (frames[n].bh)
+			brelse(frames[n].bh);
+}
+
+static unsigned itree_leaf_entry_len(unsigned rec_len)
+{
+	return rec_len + ITREE_LE_HEAD_LEN;
+}
+
+static unsigned itree_leaf_entry_min_len(struct itree_leaf_entry *le)
+{
+	return itree_leaf_entry_len(EXT4_DIR_REC_LEN(le->dirent.name_len));
+}
+
+static int itree_leaf_entry_get_len(struct itree_leaf_entry *le,
+				    long int blocksize)
+{
+	return sizeof(((struct itree_leaf_entry *)0)->hash) +
+	       ext4_rec_len_from_disk(le->dirent.rec_len, blocksize);
+}
+
+static struct itree_leaf_entry
+*itree_next_leaf_entry(struct itree_leaf_entry *le, long int blocksize)
+{
+	BUG_ON(!itree_leaf_entry_get_len(le, blocksize));
+
+	return (struct itree_leaf_entry *)((void *)le +
+		itree_leaf_entry_get_len(le, blocksize));
+}
+
+struct itree_leaf_map {
+	struct itree_leaf_head	*head;
+
+	struct itree_leaf_entry	*first;
+	struct itree_leaf_entry	*last;
+	struct itree_leaf_entry	*at;
+	struct itree_leaf_entry	*free;
+
+	struct itree_leaf_entry	*before_split;
+	struct itree_leaf_entry	*split_at;
+
+	int used_length1;
+	int used_length2;
+};
+
+static void scan_sorted_buf(struct itree_key *key, struct dentry *dentry,
+			    struct buffer_head *bh, int blocksize,
+			    struct itree_leaf_map *leaf_map)
+{
+	struct itree_leaf_head *lh;
+	struct itree_leaf_entry *le, *prev = 0;
+	struct ext4_dir_entry_2 *de;
+	struct itree_key le_key;
+	int rlen, req_rlen, min_rlen, size = 0;
+	int bufsize, len;
+
+	memset(leaf_map, 0, sizeof(struct itree_leaf_map));
+
+	lh = leaf_map->head = itree_leaf_get_head(bh);
+
+	req_rlen = itree_leaf_entry_len(EXT4_DIR_REC_LEN(dentry->d_name.len));
+	bufsize = blocksize - sizeof(struct itree_leaf_head);
+
+	le = itree_leaf_get_entries(bh);
+	leaf_map->first = leaf_map->at = le;
+
+	itree_leaf_for_each(le, de, lh, blocksize) {
+		itree_leaf_entry_get_key(le, &le_key);
+
+		if (le_key.inode && itree_key_compare(&le_key, key) <= 0)
+			leaf_map->at = le;
+
+		/* Identify a split point in case we'll need to split */
+		if (!leaf_map->split_at) {
+			rlen = itree_leaf_entry_get_len(le, blocksize);
+			if (size + rlen/2 >= bufsize/2) {
+				leaf_map->before_split = leaf_map->last;
+				leaf_map->split_at = le;
+			}
+			size += rlen;
+		}
+
+		if (le_key.inode) {
+			len = itree_leaf_entry_min_len(le);
+			if (!leaf_map->split_at)
+				leaf_map->used_length1 += len;
+			else
+				leaf_map->used_length2 += len;
+		}
+
+		/* XXX Maybe search for the smallest available free space? */
+		if (!leaf_map->free) {
+			min_rlen = 0;
+			if (le_key.inode) /* inode != 0 */
+				min_rlen = EXT4_DIR_REC_LEN(de->name_len);
+
+			rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
+			if ((rlen - min_rlen) >= req_rlen)
+				leaf_map->free = le;
+		}
+
+		prev = leaf_map->last;
+		leaf_map->last = le;
+	}
+
+	/*
+	 * When adding at end of the block, we're probably adding a
+	 * continuous sequence of inodes. Make the split at the end
+	 * of the block.
+	 */
+	if (leaf_map->at == leaf_map->last) {
+		leaf_map->before_split = prev;
+		leaf_map->split_at = leaf_map->last;
+
+		len = itree_leaf_entry_min_len(leaf_map->last);
+		if (leaf_map->used_length2)
+			leaf_map->used_length1 += leaf_map->used_length2 - len;
+		leaf_map->used_length2 = len;
+	}
+}
+
+static int itree_next_frame(struct inode *dir, u32 ino,
+			    struct itree_frame *frames,
+			    struct itree_frame *frame_in,
+			    int always)
+{
+	int count, levels_crossed = 0;
+	struct itree_frame *frame = frame_in;
+	struct buffer_head *bh;
+	struct itree_node *node;
+	struct itree_entry *node_end, *at = NULL;
+
+	while (frame >= frames) {
+		bh = frame->bh;
+		node = (struct itree_node *)bh->b_data;
+		count = le16_to_cpu(node->count);
+		node_end = &(frame->entries[count]);
+
+		at = frame->at + 1;
+		if (at < node_end)
+			break;
+
+		if (frame == frames)
+			return 1;
+
+		levels_crossed++;
+		frame--;
+	}
+
+	if (!always && (at->inode > ino ||
+			 !(at->flags & ITREE_NODE_FL_CONT)))
+		return 1;
+
+	frame->at = at;
+
+	while (levels_crossed--) {
+		bh = sb_bread(dir->i_sb, le64_to_cpu(frame->at->block));
+		if (!bh)
+			return -EIO;
+
+		/* TODO: Checksum */
+
+		frame++;
+		brelse(frame->bh);
+		frame->bh = bh;
+		node = (struct itree_node *)bh->b_data;
+		frame->entries = node->entries;
+		frame->at = node->entries;
+	}
+	return 0;
+}
+
+/*
+ * Arrange the dirents to the two new itree blocks in the order
+ * specified by the map. Returns 1 in case the split occured within
+ * a collision, otherwise 0.
+ */
+static int itree_arrange_dirents(struct ext4_dir_entry_2 *dirents,
+				 struct dx_hash_info *hinfo,
+				 void *leaf1, void *leaf2, int blocksize)
+{
+	struct dx_map_entry *map, *split_point;
+	struct ext4_dir_entry_2 *de;
+	struct itree_leaf_head *head1, *head2;
+	struct itree_leaf_entry *entry = NULL;
+	unsigned split, rec_len = 0;
+	void *from, *to, *buf_end;
+	void *data1, *data2;
+	int size1 = 0, size2 = 0, *size = &size1;
+	int count, retval;
+
+	head1 = (struct itree_leaf_head *)leaf1;
+	head2 = (struct itree_leaf_head *)leaf2;
+
+	data1 = leaf1 + sizeof(struct itree_leaf_head);
+	data2 = leaf2 + sizeof(struct itree_leaf_head);
+
+	map = (struct dx_map_entry *)(leaf2 + blocksize);
+	count = dx_make_map(dirents, blocksize, hinfo, map);
+	map -= count;
+	dx_sort_map(inode_order, map, count);
+
+	split = dx_map_split_point(map, count, blocksize);
+	split_point = map + split;
+
+	/* Did we split a collision? */
+	retval = (map[split - 1].inode == map[split].inode) &&
+		(map[split - 1].hash  == map[split].hash);
+
+	from = (void *)dirents;
+	to = data1;
+	while (count--) {
+		entry = (struct itree_leaf_entry *)to;
+		entry->hash = cpu_to_le32(map->hash);
+
+		de = (struct ext4_dir_entry_2 *)(from + (map->offs<<2));
+		rec_len = EXT4_DIR_REC_LEN(de->name_len);
+		memcpy(&(entry->dirent), de, rec_len);
+		entry->dirent.rec_len = ext4_rec_len_to_disk(rec_len,
+				blocksize);
+
+		/*FIXME sizeof(leaf_entry_head!!)*/
+		*size += (rec_len + sizeof(__u32));
+
+		if (++map == split_point) {
+			buf_end = leaf1 + blocksize;
+			rec_len = buf_end - (void *)(&entry->dirent);
+			entry->dirent.rec_len = ext4_rec_len_to_disk(rec_len,
+								     blocksize);
+			to = data2;
+			size = &size2;
+		} else {
+			to = itree_next_leaf_entry(entry, blocksize);
+		}
+	}
+
+	head1->used_length = cpu_to_le16(size1);
+	head2->used_length = cpu_to_le16(size2);
+
+	buf_end = leaf2 + blocksize;
+	rec_len = buf_end - (void *)(&(entry->dirent));
+	entry->dirent.rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
+
+	return retval;
+}
+
+static int itree_init(handle_t *handle, struct inode *dir,
+		      struct dx_hash_info *hinfo,
+		      struct ext4_dir_entry_2 *dirents,
+		      struct dentry *dentry, struct inode *inode,
+		      ext4_fsblk_t *root_block)
+{
+	struct buffer_head *bh, *bh1, *bh2, *target_bh;
+	struct itree_leaf_head *head1, *head2;
+	ext4_fsblk_t leaf_blk1, leaf_blk2;
+	struct itree_node *root;
+	struct itree_key key2, key;
+	char *leaf1, *leaf2;
+	int err, blocksize, continued = 0;
+	struct itree_leaf_entry *le;
+	struct itree_leaf_map leaf_map;
+
+	blocksize = dir->i_sb->s_blocksize;
+
+	bh = ext4_new_itree_block(handle, dir, root_block, &err);
+	if (!bh)
+		goto out;
+
+	root = (struct itree_node *)(bh->b_data);
+	root->checksum = 0;
+	root->indirect_levels = 0;
+	root->count = 0;
+	root->limit = cpu_to_le16(get_itree_node_limit(blocksize));
+
+	/* Initialize the two dirent leaf blocks. */
+	bh1 = ext4_new_itree_block(handle, dir, &leaf_blk1, &err);
+	if (!bh1)
+		goto free_bh;
+	head1 = (struct itree_leaf_head *)bh1->b_data;
+	leaf1 = bh1->b_data;
+
+	bh2 = ext4_new_itree_block(handle, dir, &leaf_blk2, &err);
+	if (!bh2)
+		goto free_bh1;
+	head2 = (struct itree_leaf_head *)bh2->b_data;
+	leaf2 = bh2->b_data;
+
+	continued = itree_arrange_dirents(dirents, hinfo, leaf1, leaf2,
+					  blocksize);
+
+	le = itree_leaf_get_entries(bh2);
+	itree_leaf_entry_get_key(le, &key2);
+
+	root->count = cpu_to_le16(2);
+	root->entries[0].inode = 0;
+	root->entries[0].hash = 0;
+	root->entries[0].block = cpu_to_le64(leaf_blk1);
+	root->entries[0].fullness = itree_get_leaf_fullness(head1, blocksize);
+	root->entries[0].flags = 0;
+
+	root->entries[1].inode = cpu_to_le32(key2.inode);
+	root->entries[1].hash = cpu_to_le32(key2.hash);
+	root->entries[1].block = cpu_to_le64(leaf_blk2);
+	root->entries[1].fullness = itree_get_leaf_fullness(head2, blocksize);
+	root->entries[1].flags = 0;
+
+	if (continued)
+		root->entries[1].flags |= ITREE_NODE_FL_CONT;
+
+	ext4fs_dirhash(dentry->d_name.name, dentry->d_name.len, hinfo);
+	key.inode = inode->i_ino;
+	key.hash = hinfo->hash;
+
+	/* Insert the new entry to itree */
+	target_bh = itree_key_compare(&key, &key2) <= 0 ? bh1 : bh2;
+
+	scan_sorted_buf(&key, dentry, target_bh, blocksize, &leaf_map);
+	put_entry_to_sorted_buf(&key, dentry, inode, target_bh, blocksize,
+				&leaf_map);
+
+	/* TODO: Set checksums */
+
+	set_buffer_uptodate(bh2);
+	unlock_buffer(bh2);
+	err = ext4_handle_dirty_metadata(handle, dir, bh2);
+	if (err)
+		goto free_bh1;
+	brelse(bh2);
+
+	set_buffer_uptodate(bh1);
+	unlock_buffer(bh1);
+	err = ext4_handle_dirty_metadata(handle, dir, bh1);
+	if (err)
+		goto free_bh;
+	brelse(bh1);
+
+	set_buffer_uptodate(bh);
+	unlock_buffer(bh);
+	err = ext4_handle_dirty_metadata(handle, dir, bh);
+	if (err)
+		goto out;
+	brelse(bh);
+
+	return 0;
+
+/*free_bh2:
+	unlock_buffer(bh2);
+	brelse(bh2);
+	ext4_free_itree_block(handle, dir, leaf_blk2);*/
+free_bh1:
+	unlock_buffer(bh1);
+	brelse(bh1);
+	ext4_free_itree_block(handle, dir, leaf_blk1);
+free_bh:
+	unlock_buffer(bh);
+	brelse(bh);
+	ext4_free_itree_block(handle, dir, *root_block);
+out:
+	return err;
+}
+
+#ifdef ITREE_DEBUG
+static void itree_show_node(struct buffer_head *bh)
+{
+	struct itree_node *node = (struct itree_node *)bh->b_data;
+	struct itree_entry *e;
+	int n = 0, i;
+
+	static const char * const indent[] = {"            ", "        ",
+					      "    "};
+	i = node->indirect_levels;
+	BUG_ON(i < 0 || i > 2);
+
+	printk(KERN_DEBUG
+	       "%s[itree node] count=%u, limit=%u, indirect=%u, checksum=%u\n",
+	       indent[i], le16_to_cpu(node->count), le16_to_cpu(node->limit),
+	       node->indirect_levels, le32_to_cpu(node->checksum));
+
+	for (e = node->entries; e < (node->entries + node->count); e++)
+		printk(KERN_DEBUG "%s        [%d] inode=%u, hash=%u, "
+		       "block=%llu, flags=%x, fullness=%u\n", indent[i], n++,
+		       le32_to_cpu(e->inode), le32_to_cpu(e->hash),
+		       le64_to_cpu(e->block), e->flags, e->fullness);
+}
+
+static void itree_show_leaf(struct inode *dir, struct buffer_head *bh,
+			    ext4_fsblk_t *block)
+{
+	int blocksize = dir->i_sb->s_blocksize;
+	struct ext4_dir_entry_2 *de;
+	struct itree_leaf_entry *le;
+	struct itree_leaf_head *lh;
+	int num_entries = 0;
+	int size = 0, req_size = 0;
+	u32 first_inode, last_inode = 0;
+
+	lh = (struct itree_leaf_head *)bh->b_data;
+	le = (struct itree_leaf_entry *)(lh + 1);
+	first_inode = le32_to_cpu(le->dirent.inode);
+
+	itree_leaf_for_each(le, de, lh, blocksize) {
+		size += itree_leaf_entry_get_len(le, blocksize);
+		req_size += itree_leaf_entry_min_len(le);
+
+		num_entries++;
+		last_inode = le32_to_cpu(de->inode);
+	}
+
+	if (block)
+		printk(KERN_DEBUG "                [itree leaf@%llu] ", *block);
+	else
+		printk(KERN_DEBUG "                [itree leaf] ");
+	printk(KERN_DEBUG "checksum(%u), first_ino(%u), last_ino(%u), "
+	       "entries(%u), fullness(%d%%), used_length(%u)\n",
+	       le32_to_cpu(lh->checksum), first_inode, last_inode, num_entries,
+	       (req_size*100)/size, le16_to_cpu(lh->used_length));
+
+	if (0) { /* Print entries */
+		printk(KERN_DEBUG "                      entries: ");
+		itree_leaf_for_each(le, de, lh, blocksize) {
+			le = container_of(de, struct itree_leaf_entry, dirent);
+			printk(KERN_DEBUG "%u:%u(%u), ",
+			       le32_to_cpu(de->inode), le32_to_cpu(le->hash),
+			       ext4_rec_len_from_disk(de->rec_len, blocksize));
+		}
+		printk(KERN_DEBUG "\n");
+	}
+}
+
+static void itree_show(struct inode *dir, ext4_fsblk_t block)
+{
+	struct buffer_head *bh, *leaf;
+	struct itree_node *node;
+	struct itree_entry *e;
+	int level;
+	ext4_fsblk_t next;
+
+	bh = sb_bread(dir->i_sb, block);
+	if (!bh)
+		return;
+
+	itree_show_node(bh);
+
+	node = (struct itree_node *)bh->b_data;
+	level = le16_to_cpu(node->indirect_levels);
+
+	for (e = node->entries; e < (node->entries + node->count); e++) {
+		next = le64_to_cpu(e->block);
+		if (level) {
+			itree_show(dir, next);
+		} else {
+			leaf = sb_bread(dir->i_sb, next);
+			if (!leaf)
+				return;
+			itree_show_leaf(dir, leaf, &next);
+			brelse(leaf);
+		}
+
+	}
+	brelse(bh);
+}
+#endif
-- 
1.7.11.7

