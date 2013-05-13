From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 6/9] ext4: Adding itree implementation II - Inserting
Date: Mon, 13 May 2013 17:42:07 +0200
Message-ID: <1368459730-3405-7-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3EMQmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:53 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit contains functions that are related to inserting entries
to the inode tree including the functions that handle the node splits.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 617 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 617 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1f9ea5b..af350af 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -332,6 +332,10 @@ static int itree_init(handle_t *handle, struct inode *dir,
 		      struct dentry *entry, struct inode *inode,
 		      ext4_fsblk_t *root_block);
 
+static int itree_add_entry(handle_t *handle, struct inode *dir,
+			   ext4_fsblk_t root_blk, struct dentry *entry,
+			   struct inode *inode, u32 hash);
+
 static int itree_next_frame(struct inode *dir, u32 ino,
 			    struct itree_frame *frames,
 			    struct itree_frame *frame_in,
@@ -3688,6 +3692,68 @@ static struct itree_leaf_entry
 		itree_leaf_entry_get_len(le, blocksize));
 }
 
+static struct itree_leaf_entry *make_space_before(struct itree_leaf_entry *le,
+						  int blocksize)
+{
+	int min_len = itree_leaf_entry_min_len(le);
+	int rec_len = EXT4_DIR_REC_LEN(le->dirent.name_len);
+	int len = itree_leaf_entry_get_len(le, blocksize);
+	int new_rlen;
+
+	le->dirent.rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
+	memmove((void *)le + len - min_len, le, min_len);
+
+	new_rlen = len - min_len - ITREE_LE_HEAD_LEN;
+	le->dirent.rec_len = ext4_rec_len_to_disk(new_rlen, blocksize);
+
+	return le;
+}
+
+static struct itree_leaf_entry *make_space_after(struct itree_leaf_entry *le,
+						 int blocksize)
+{
+	struct itree_leaf_entry *new;
+	int len = itree_leaf_entry_get_len(le, blocksize);
+	int min_len = itree_leaf_entry_min_len(le);
+	int rec_len = EXT4_DIR_REC_LEN(le->dirent.name_len);
+	int new_rlen;
+
+	new = (struct itree_leaf_entry *)((void *)le + min_len);
+	le->dirent.rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
+
+	new_rlen = len - min_len - ITREE_LE_HEAD_LEN;
+	new->dirent.rec_len = ext4_rec_len_to_disk(new_rlen, blocksize);
+	return new;
+}
+
+static int itree_insert_dentry(struct itree_key *key, struct dentry *dentry,
+			       struct inode *inode, struct itree_leaf_entry *le,
+			       int blocksize)
+{
+	struct itree_leaf_entry *new;
+	struct itree_key old_key;
+
+	itree_leaf_entry_get_key(le, &old_key);
+
+	new = le;
+	if (le->dirent.inode) {
+		if (itree_key_compare(key, &old_key) < 0)
+			new = make_space_before(le, blocksize);
+		else
+			new = make_space_after(le, blocksize);
+	}
+
+	new->dirent.file_type = EXT4_FT_UNKNOWN;
+	new->dirent.inode = cpu_to_le32(inode->i_ino);
+	ext4_set_de_type(inode->i_sb, &(new->dirent), inode->i_mode);
+	new->dirent.name_len = dentry->d_name.len;
+	memcpy(new->dirent.name, dentry->d_name.name, dentry->d_name.len);
+
+	new->hash = cpu_to_le32(key->hash);
+
+	return itree_leaf_entry_min_len(new);
+}
+
 struct itree_leaf_map {
 	struct itree_leaf_head	*head;
 
@@ -3703,6 +3769,73 @@ struct itree_leaf_map {
 	int used_length2;
 };
 
+static int put_entry_to_sorted_buf(struct itree_key *key,
+				   struct dentry *dentry, struct inode *inode,
+				   struct buffer_head *bh, int blocksize,
+				   struct itree_leaf_map *leaf_map)
+{
+	void *at_end, *from, *to;
+	int rlen, req_rlen, at_rec_len, free_rec_len, free_space;
+	int at_len, free_len;
+	struct itree_leaf_entry *at, *free;
+	struct itree_leaf_head *head = itree_leaf_get_head(bh);
+
+	at = leaf_map->at;
+	free = leaf_map->free;
+
+	at_rec_len = ext4_rec_len_from_disk(at->dirent.rec_len, blocksize);
+	free_rec_len = ext4_rec_len_from_disk(free->dirent.rec_len, blocksize);
+
+	at_len = itree_leaf_entry_get_len(at, blocksize);
+	free_len = itree_leaf_entry_get_len(free, blocksize);
+
+	at_end = (void *)at + at_len;
+
+	to = (void *)free + free_len;
+	from = (void *)free;
+	if (free->dirent.inode)
+		from += itree_leaf_entry_min_len(free);
+
+	req_rlen = itree_leaf_entry_len(EXT4_DIR_REC_LEN(dentry->d_name.len));
+	head->used_length = cpu_to_le16(le16_to_cpu(head->used_length) +
+					req_rlen);
+
+	/*
+	 * Don't copy anything if there is enough space at the
+	 * right spot
+	 */
+	free_space = at_len;
+	if (at->dirent.inode)
+		free_space -= itree_leaf_entry_min_len(at);
+	if (free_space >= req_rlen)
+		return itree_insert_dentry(key, dentry, inode, at, blocksize);
+
+	/* In case there is an unused entry directly following 'at' */
+	if (at_end == from)
+		return itree_insert_dentry(key, dentry, inode, at, blocksize);
+
+	/* Fix free rec_len */
+	rlen = free_rec_len;
+	if (le32_to_cpu(free->dirent.inode))
+		free->dirent.rec_len = ext4_rec_len_to_disk(rlen - (to - from),
+							    blocksize);
+
+	/* Which part of memory we'll need to move */
+	if (at_end > to) {
+		memmove(from, to, at_end - to);
+		at = (struct itree_leaf_entry *)((void *)at - (to - from));
+	} else {
+		memmove(at_end + (to - from), at_end, from - at_end);
+	}
+
+	/* Fix at rec_len */
+	rlen = at_rec_len;
+	at->dirent.rec_len = ext4_rec_len_to_disk(rlen + (to - from),
+						  blocksize);
+
+	return itree_insert_dentry(key, dentry, inode, at, blocksize);
+}
+
 static void scan_sorted_buf(struct itree_key *key, struct dentry *dentry,
 			    struct buffer_head *bh, int blocksize,
 			    struct itree_leaf_map *leaf_map)
@@ -3779,6 +3912,490 @@ static void scan_sorted_buf(struct itree_key *key, struct dentry *dentry,
 	}
 }
 
+/*
+ * Used during node splits to test whether a split occured
+ * in the middle of a key collision.
+ */
+static int itree_is_continuation(struct itree_entry *a, struct itree_entry *b)
+{
+	return (a->inode == b->inode && a->hash == b->hash) ||
+	       b->flags & ITREE_NODE_FL_CONT;
+}
+
+/*
+ * Returns non-zero if the node can be split, zero otherwise
+ */
+static int itree_can_split(struct itree_frame *frame,
+			   struct itree_frame *frames)
+{
+	int count, limit;
+	struct itree_node *node;
+
+	while (frame >= frames) {
+		node = (struct itree_node *)frame->bh->b_data;
+		count = le16_to_cpu(node->count);
+		limit = le16_to_cpu(node->limit);
+
+		if (count < limit)
+			return 1;
+		frame--;
+	}
+	node = (struct itree_node *)frames->bh->b_data;
+	return node->indirect_levels < (ITREE_MAX_DEPTH - 1);
+}
+
+static struct itree_entry *itree_node_make_space(struct itree_node *node,
+						 struct itree_entry *old)
+{
+	struct itree_entry *new = old + 1;
+	int len, count;
+
+	count = le16_to_cpu(node->count);
+	len = (void *)(node->entries + count) - (void *)new;
+	memmove(new + 1, new, len);
+	node->count = cpu_to_le16(++count);
+	return new;
+}
+
+static void itree_store_entry(struct itree_entry *new, struct itree_key *key,
+			      ext4_fsblk_t block, int continuation)
+{
+	new->inode = cpu_to_le32(key->inode);
+	new->hash = cpu_to_le32(key->hash);
+	new->block = cpu_to_le64(block);
+
+	new->flags = 0;
+	if (continuation)
+		new->flags |= ITREE_NODE_FL_CONT;
+}
+
+static struct buffer_head *itree_node_split(handle_t *handle, struct inode *dir,
+					    struct itree_frame *frame,
+					    struct itree_entry **old,
+					    struct itree_entry **new,
+					    int *err)
+{
+	struct buffer_head *new_bh, *bh = frame->bh;
+	struct itree_node *node = (struct itree_node *)bh->b_data, *new_node;
+	int blocksize = dir->i_sb->s_blocksize;
+	int split, count, at;
+	ext4_fsblk_t new_blk;
+
+	BUFFER_TRACE(bh, "get_write_access");
+	*err = ext4_journal_get_write_access(handle, bh);
+	if (*err)
+		return NULL;
+
+	new_bh = ext4_new_itree_block(handle, dir, &new_blk, err);
+	if (!new_bh)
+		return NULL;
+
+	new_node = (struct itree_node *)new_bh->b_data;
+	new_node->indirect_levels = node->indirect_levels;
+	new_node->limit = cpu_to_le16(get_itree_node_limit(blocksize));
+
+	count = le16_to_cpu(node->count);
+
+	/* Don't split, just append if adding to the end */
+	if (frame->at == (node->entries + count - 1)) {
+		new_node->count = cpu_to_le16(1);
+		*old = node->entries + count - 1;
+		*new = new_node->entries;
+		return new_bh;
+	}
+
+	/* Can't split a block with a single entry */
+	BUG_ON(count <= 1);
+
+	split = count / 2;
+	memcpy(new_node->entries, node->entries + split,
+	       (count - split) * sizeof(struct itree_entry));
+	node->count = le16_to_cpu(split);
+	new_node->count = le16_to_cpu(count - split);
+
+	at = frame->at - frame->entries;
+	if (at >= split) {
+		*old = new_node->entries + at - split;
+		*new = itree_node_make_space(new_node, *old);
+	} else {
+		*old = frame->at;
+		*new = itree_node_make_space(node, *old);
+	}
+
+	return new_bh;
+}
+
+static int itree_add_level(handle_t *handle, struct inode *dir,
+			   struct itree_frame *frame, struct itree_key *key,
+			   ext4_fsblk_t block, int continuation, int len1,
+			   int len2)
+{
+	struct buffer_head *bh1, *bh2;
+	struct itree_entry *old, *new;
+	ext4_fsblk_t new_blk1, new_blk2;
+	struct itree_node *root, *node1, *node2;
+	struct itree_key key1, key2;
+	int limit, count, size, err;
+
+	bh1 = ext4_new_itree_block(handle, dir, &new_blk1, &err);
+	if (!bh1)
+		return err;
+
+	bh2 = itree_node_split(handle, dir, frame, &old, &new, &err);
+	if (!bh2) {
+		unlock_buffer(bh1);
+		brelse(bh1);
+		ext4_free_itree_block(handle, dir, new_blk1);
+		return err;
+	}
+	new_blk2 = bh2->b_blocknr;
+
+	itree_store_entry(new, key, block, continuation);
+
+	root = (struct itree_node *)frame->bh->b_data;
+	count = le16_to_cpu(root->count);
+	limit = le16_to_cpu(root->limit);
+
+	old->fullness = itree_get_fullness(len1, limit);
+	new->fullness = itree_get_fullness(len2, limit);
+
+	size = sizeof(struct itree_node) + count * sizeof(struct itree_entry);
+	memcpy(bh1->b_data, root, size);
+
+	node1 = (struct itree_node *)bh1->b_data;
+	node2 = (struct itree_node *)bh2->b_data;
+
+	continuation = itree_is_continuation(node1->entries + count - 1,
+					     node2->entries);
+
+	itree_entry_get_key(node1->entries, &key1);
+	itree_entry_get_key(node2->entries, &key2);
+
+	len1 = le16_to_cpu(node1->count);
+	len2 = le16_to_cpu(node2->count);
+
+	root->indirect_levels++;
+	root->count = cpu_to_le16(2);
+
+	itree_store_entry(root->entries, &key1, new_blk1, 0);
+	root->entries->fullness = itree_get_fullness(len1, limit);
+
+	itree_store_entry(root->entries + 1, &key2, new_blk2, continuation);
+	root->entries[1].fullness = itree_get_fullness(len2, limit);
+
+	set_buffer_uptodate(bh1);
+	unlock_buffer(bh1);
+	err = ext4_handle_dirty_metadata(handle, dir, bh1);
+	if (err)
+		return err; /* FIXME Free everything? */
+	brelse(bh1);
+
+	set_buffer_uptodate(bh2);
+	unlock_buffer(bh2);
+	err = ext4_handle_dirty_metadata(handle, dir, bh2);
+	if (err)
+		return err; /* FIXME Free everything? */
+	brelse(bh2);
+
+	err = ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	if (err)
+		return err; /* FIXME Free everything? */
+
+	return 0;
+}
+
+static int itree_node_insert_entry(handle_t *handle, struct inode *dir,
+				   struct itree_key *key_in, ext4_fsblk_t block,
+				   int continuation, struct itree_frame *frames,
+				   struct itree_frame *frame,
+				   int len1, int len2)
+{
+	struct buffer_head *bh1, *bh2;
+	struct itree_node *node, *node1, *node2;
+	struct itree_entry *old, *new;
+	struct itree_key key = *key_in;
+	int count, limit, err, max, levels, fullness;
+	int blocksize = dir->i_sb->s_blocksize;
+
+	while (frame >= frames) {
+		old = frame->at;
+		new = old + 1;
+		node = (struct itree_node *)frame->bh->b_data;
+		count = le16_to_cpu(node->count);
+		limit = le16_to_cpu(node->limit);
+		levels = node->indirect_levels;
+
+		if (levels)
+			max = le16_to_cpu(node->limit);
+		else
+			max = blocksize - sizeof(struct itree_leaf_head);
+
+		/* No need for split */
+		if (count < limit) {
+			err = ext4_journal_get_write_access(handle, frame->bh);
+			if (err)
+				return err;
+
+			new = itree_node_make_space(node, old);
+			itree_store_entry(new, &key, block, continuation);
+			old->fullness = itree_get_fullness(len1, max);
+			new->fullness = itree_get_fullness(len2, max);
+
+			err = ext4_handle_dirty_metadata(handle, dir,
+							 frame->bh);
+			if (err)
+				return err;
+
+			if (frame - 1 >= frames) {
+				fullness = itree_get_node_fullness(node);
+				err = itree_update_fullness(handle, dir,
+							    frame-1, fullness);
+			}
+
+			return err;
+		}
+
+		if (frame > frames) {
+			bh1 = frame->bh;
+			bh2 = itree_node_split(handle, dir, frame, &old, &new,
+					       &err);
+			if (!bh2)
+				return err;
+
+			itree_store_entry(new, &key, block, continuation);
+			old->fullness = itree_get_fullness(len1, max);
+			new->fullness = itree_get_fullness(len2, max);
+
+			node1 = (struct itree_node *)bh1->b_data;
+			node2 = (struct itree_node *)bh2->b_data;
+
+			/* Values to add to the parent */
+			len1 = le16_to_cpu(node1->count);
+			len2 = le16_to_cpu(node2->count);
+
+			continuation = itree_is_continuation(node1->entries +
+							     len1 - 1,
+							     node2->entries);
+
+			itree_entry_get_key(node2->entries, &key);
+			block = bh2->b_blocknr;
+
+			set_buffer_uptodate(bh2);
+			unlock_buffer(bh2);
+
+			err = ext4_handle_dirty_metadata(handle, dir, bh1);
+			if (err) {
+				ext4_std_error(dir->i_sb, err);
+				return err;
+			}
+
+			err = ext4_handle_dirty_metadata(handle, dir, bh2);
+			if (err) {
+				ext4_std_error(dir->i_sb, err);
+				return err;
+			}
+			brelse(bh2);
+		} else if (frame == frames && levels < (ITREE_MAX_DEPTH - 1)) {
+			return itree_add_level(handle, dir, frame, &key, block,
+					       continuation, len1, len2);
+		} else {
+			return -ENOSPC;
+		}
+
+		frame--;
+	}
+	return 0;
+}
+
+static struct buffer_head *
+itree_find_leaf_entry(struct inode *dir, struct itree_key *key,
+		      struct dentry *dentry, struct itree_frame *frames,
+		      struct itree_frame *frame,
+		      struct itree_leaf_map *lm, int *err)
+{
+	int retval, blocksize = dir->i_sb->s_blocksize;
+	struct buffer_head *bh;
+
+	while (1) {
+		*err = -EIO;
+		bh = sb_bread(dir->i_sb, le64_to_cpu(frame->at->block));
+		if (!bh)
+			return NULL;
+
+		/* TODO: Verify leaf checksum */
+
+		scan_sorted_buf(key, dentry, bh, blocksize, lm);
+		if (lm->at != lm->last)
+			break;
+
+		retval = itree_next_frame(dir, key->inode, frames, frame, 0);
+		if (retval > 0)
+			break;
+
+		brelse(bh);
+		*err = retval;
+		if (retval < 0)
+			return NULL;
+	}
+	*err = 0;
+	return bh;
+}
+
+static int itree_add_entry(handle_t *handle, struct inode *dir,
+			   ext4_fsblk_t root_blk, struct dentry *entry,
+			   struct inode *inode, u32 hash)
+{
+	/* This will be called from ext4_dx_add_entry() */
+	struct itree_frame frames[ITREE_MAX_DEPTH];
+	struct itree_frame *frame;
+	struct buffer_head *bh, *bh2 = NULL, *target_bh;
+	ext4_fsblk_t new_block;
+	int err, continued = 0;
+	int new_len, len1, len2;
+
+	struct itree_leaf_entry *last, *first_new;
+	struct itree_leaf_head *head, *head2;
+	struct itree_key key, split_key;
+	void *split_point, *buf_end;
+	unsigned blocksize;
+	int new_rlen, last_off, fullness;
+	struct itree_leaf_map lm;
+	__le32 rlen_disk;
+
+	memset(frames, 0, ITREE_MAX_DEPTH*sizeof(struct itree_frame));
+
+	blocksize = dir->i_sb->s_blocksize;
+
+	key.inode = inode->i_ino;
+	key.hash = hash;
+
+	frame = itree_probe(&key, dir, root_blk, frames, &err);
+	if (!frame)
+		return err;
+
+	bh = itree_find_leaf_entry(dir, &key, entry, frames, frame, &lm, &err);
+	if (err)
+		goto out;
+
+	/* TODO Add count to the map and check for that instead */
+	if (lm.before_split && lm.split_at)
+		continued = (lm.before_split->dirent.inode ==
+			     lm.split_at->dirent.inode) &&
+			    (lm.before_split->hash == lm.split_at->hash);
+
+	buf_end = (void *)bh->b_data + blocksize;
+
+	err = ext4_journal_get_write_access(handle, bh);
+	if (err)
+		goto out;
+
+	if (lm.free) {
+		new_rlen = put_entry_to_sorted_buf(&key, entry, inode, bh,
+						   blocksize, &lm);
+
+		head = itree_leaf_get_head(bh);
+		fullness = itree_get_leaf_fullness(head, blocksize);
+		err = itree_update_fullness(handle, dir, frame, fullness);
+		if (err)
+			goto out;
+	} else {
+		err = -ENOSPC;
+		if (!itree_can_split(frame, frames))
+			goto out;
+
+		bh2 = ext4_new_itree_block(handle, dir, &new_block, &err);
+		if (!bh2)
+			goto out;
+
+		split_point = (void *)lm.split_at;
+		memcpy(bh2->b_data + sizeof(struct itree_leaf_head),
+		       split_point, buf_end - split_point);
+
+		/* Fix the rec_len of the last entries */
+		new_rlen = buf_end - (void *)(&(lm.before_split->dirent));
+		rlen_disk = ext4_rec_len_to_disk(new_rlen, blocksize);
+		lm.before_split->dirent.rec_len = rlen_disk;
+
+		first_new = (struct itree_leaf_entry *)(bh2->b_data +
+					sizeof(struct itree_leaf_head));
+
+		last_off = (void *)lm.last - split_point;
+		last = (struct itree_leaf_entry *)((void *)first_new +
+						   last_off);
+
+		buf_end = (void *)bh2->b_data + blocksize;
+		new_rlen = buf_end - (void *)(&(last->dirent));
+		last->dirent.rec_len = ext4_rec_len_to_disk(new_rlen,
+							    blocksize);
+
+		/* TODO: Set checksums */
+
+		len1 = lm.used_length1;
+		len2 = lm.used_length2;
+
+		itree_leaf_entry_get_key(lm.split_at, &split_key);
+
+		head = itree_leaf_get_head(bh);
+		head2 = itree_leaf_get_head(bh2);
+
+		head->used_length = cpu_to_le16(len1);
+		head2->used_length = cpu_to_le16(len2);
+
+		target_bh = bh;
+		if ((void *)lm.at >= split_point)
+			target_bh = bh2;
+
+		scan_sorted_buf(&key, entry, target_bh, blocksize, &lm);
+		new_len = put_entry_to_sorted_buf(&key, entry, inode, target_bh,
+						  blocksize, &lm);
+
+		if (target_bh == bh)
+			len1 += new_len;
+		else
+			len2 += new_len;
+
+		/* Add the keys to the itree_frame */
+		err = itree_node_insert_entry(handle, dir, &split_key,
+					      new_block, continued, frames,
+					      frame, len1, len2);
+		if (err) {
+			brelse(bh);
+			unlock_buffer(bh2);
+			brelse(bh2);
+			ext4_free_itree_block(handle, dir, new_block);
+			goto out;
+		}
+
+		set_buffer_uptodate(bh2);
+		unlock_buffer(bh2);
+	}
+
+	/* See add_dirent_to_buf() */
+	dir->i_mtime = dir->i_ctime = ext4_current_time(dir);
+	ext4_update_dx_flag(dir);
+	dir->i_version++;
+	ext4_mark_inode_dirty(handle, dir);
+
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, dir, bh);
+	if (err)
+		ext4_std_error(dir->i_sb, err);
+	brelse(bh);
+
+	if (bh2) {
+		err = ext4_handle_dirty_metadata(handle, dir, bh2);
+		if (err)
+			ext4_std_error(dir->i_sb, err);
+		brelse(bh2);
+	}
+
+	err = 0;
+out:
+	itree_release_frames(frames);
+
+	return err;
+}
+
 static int itree_next_frame(struct inode *dir, u32 ino,
 			    struct itree_frame *frames,
 			    struct itree_frame *frame_in,
-- 
1.7.11.7

