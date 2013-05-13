From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 7/9] ext4: Adding itree implementation III - Deleting
Date: Mon, 13 May 2013 17:42:08 +0200
Message-ID: <1368459730-3405-8-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3EMQmz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:55 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit contains functions that are related to the deletion of
entries from the inode tree. This also includes the code related to
coalesce-on-delete.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 555 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 555 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index af350af..d5e09eb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -336,6 +336,9 @@ static int itree_add_entry(handle_t *handle, struct inode *dir,
 			   ext4_fsblk_t root_blk, struct dentry *entry,
 			   struct inode *inode, u32 hash);
 
+static int itree_delete_entry(handle_t *handle, struct inode *dir,
+			      struct dentry *entry);
+
 static int itree_next_frame(struct inode *dir, u32 ino,
 			    struct itree_frame *frames,
 			    struct itree_frame *frame_in,
@@ -4447,6 +4450,558 @@ static int itree_next_frame(struct inode *dir, u32 ino,
 	return 0;
 }
 
+static int itree_search_leaf(struct buffer_head *bh, struct inode *dir,
+			     u32 ino, u32 hash, const struct qstr *d_name,
+			     struct itree_leaf_entry **res_entry,
+			     struct itree_leaf_entry **prev_entry)
+{
+	struct itree_leaf_head *lh;
+	struct itree_leaf_entry *le;
+	struct ext4_dir_entry_2 *de;
+	char *data;
+	const char *name = d_name->name;
+	int namelen = d_name->len;
+	int blocksize = dir->i_sb->s_blocksize;
+	__le32 le_ino = cpu_to_le32(ino), le_hash = cpu_to_le32(hash);
+
+	lh = itree_leaf_get_head(bh);
+	le = itree_leaf_get_entries(bh);
+	data = (char *)le;
+
+	*res_entry = NULL;
+	*prev_entry = NULL;
+
+	itree_leaf_for_each(le, de, lh, blocksize) {
+		if (le->hash == le_hash &&
+		    de->inode == le_ino &&
+		    ext4_match(namelen, name, de)) {
+			if (ext4_check_dir_entry(dir, NULL, de, bh, data,
+						 bh->b_size, 0/*offset*/))
+				return -1;
+			*res_entry = le;
+			return 1;
+		}
+		*prev_entry = le;
+	}
+	return 0;
+}
+
+static void itree_erease_leaf_entry(struct inode *dir, struct buffer_head *leaf,
+				    struct itree_leaf_entry *entry,
+				    struct itree_leaf_entry *prev)
+{
+	struct itree_leaf_head *head = itree_leaf_get_head(leaf);
+	int blocksize = dir->i_sb->s_blocksize;
+	int prev_rec_len, entry_len, old_used_length, used_length;
+
+	if (prev) {
+		prev_rec_len = ext4_rec_len_from_disk(prev->dirent.rec_len,
+						      blocksize);
+		entry_len = itree_leaf_entry_get_len(entry, blocksize);
+		prev->dirent.rec_len = ext4_rec_len_to_disk(prev_rec_len +
+							    entry_len,
+							    blocksize);
+	}
+
+	used_length = itree_leaf_entry_min_len(entry);
+	old_used_length = le16_to_cpu(head->used_length);
+	head->used_length = cpu_to_le16(old_used_length - used_length);
+
+	entry->dirent.inode = 0;
+	dir->i_version++;
+}
+
+/* Returns the packed length of all the entries in the block */
+static int itree_leaf_pack_entries(struct inode *dir, struct buffer_head *leaf,
+				   int *last_offset)
+{
+	struct itree_leaf_head *lh;
+	struct itree_leaf_entry *le, *next, *last = NULL, *entries;
+	struct ext4_dir_entry_2 *de;
+	void *new_pos, *buff_end;
+	int blocksize = dir->i_sb->s_blocksize;
+	int new_reclen, old_reclen, entry_len, len = 0;
+
+	*last_offset = 0;
+
+	lh = itree_leaf_get_head(leaf);
+	entries = itree_leaf_get_entries(leaf);
+
+	buff_end = (void *)lh + blocksize;
+	new_pos = (void *)entries;
+	le = entries;
+
+	while ((void *)le < buff_end) {
+		de = &(le->dirent);
+		next = itree_next_leaf_entry(le, blocksize);
+
+		if (!de->inode) {
+			le = next;
+			continue;
+		}
+
+		old_reclen = ext4_rec_len_from_disk(de->rec_len, blocksize);
+		new_reclen = EXT4_DIR_REC_LEN(de->name_len);
+		if (new_reclen < old_reclen)
+			de->rec_len = ext4_rec_len_to_disk(new_reclen,
+							   blocksize);
+
+		entry_len = itree_leaf_entry_len(new_reclen);
+		len += entry_len;
+		if ((void *)le != new_pos)
+			memmove(new_pos, le, entry_len);
+		last = (struct itree_leaf_entry *)new_pos;
+		new_pos += entry_len;
+		le = next;
+	}
+
+	lh->used_length = cpu_to_le16(len);
+
+	if (last) {
+		new_reclen = buff_end - (void *)(&(last->dirent));
+		last->dirent.rec_len = ext4_rec_len_to_disk(new_reclen,
+							    blocksize);
+		*last_offset = (void *)last - (void *)entries;
+	}
+
+	return len;
+}
+
+/* Decide if we can coalesce and which neighbour will be used. Returns 1 if
+ * coalescing is possible and 0 otherwise. The entry parameters will be
+ * filled with pointers to entries that should be merged, while entry1 is
+ * always a pointer to the first block with smaller keys. */
+static int itree_can_coalesce(struct itree_frame *frame,
+			      struct itree_entry **entry1,
+			      struct itree_entry **entry2)
+{
+	struct itree_node *node = (struct itree_node *)frame->bh->b_data;
+	struct itree_entry *neighbour;
+	int count = le16_to_cpu(node->count);
+
+	/* Coalesce with the next entry? */
+	neighbour = frame->at + 1;
+	if ((neighbour < (frame->entries + count)) &&
+	    ((neighbour->fullness + frame->at->fullness) <= 255)) { /* FIXME */
+		*entry1 = frame->at;
+		*entry2 = neighbour;
+		return 1;
+	}
+
+	/* Coalesce with the previous entry? */
+	neighbour = frame->at - 1;
+	if ((neighbour >= frame->entries) &&
+	    ((neighbour->fullness + frame->at->fullness) <= 255)) {
+		*entry1 = neighbour;
+		*entry2 = frame->at;
+		return 1;
+	}
+
+	/* No sir. */
+	return 0;
+}
+
+/*
+ * Move entries from both leaves to the first one. The first block must
+ * contain entries with smaller keys than the second one.
+ *
+ * The function returns the number of bytes used in block1 after the merge.
+ */
+static int itree_merge_leaf_nodes(handle_t *handle, struct inode *dir,
+				  struct buffer_head *block1,
+				  struct buffer_head *block2)
+{
+	struct itree_leaf_head *head;
+	struct itree_leaf_entry *last;
+	int blocksize = dir->i_sb->s_blocksize;
+	int last_offset1, last_offset2;
+	int len1, len2, rec_len, used_length;
+	void *data1, *data2;
+	int err;
+
+	BUFFER_TRACE(block1, "get_write_access");
+	err = ext4_journal_get_write_access(handle, block1);
+	if (err)
+		return err;
+
+	len1 = itree_leaf_pack_entries(dir, block1, &last_offset1);
+	len2 = itree_leaf_pack_entries(dir, block2, &last_offset2);
+
+	data1 = (void *)itree_leaf_get_entries(block1);
+	data2 = (void *)itree_leaf_get_entries(block2);
+	memcpy(data1 + len1, data2, len2);
+
+	last = (struct itree_leaf_entry *)(data1 + last_offset1);
+	rec_len = EXT4_DIR_REC_LEN(last->dirent.name_len);
+	last->dirent.rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
+
+	last = (struct itree_leaf_entry *)(data1 + len1 + last_offset2);
+	rec_len = ((void *)block1->b_data + blocksize) -
+		  (void *)(&(last->dirent));
+	last->dirent.rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
+
+	head = itree_leaf_get_head(block2);
+	used_length = le16_to_cpu(head->used_length);
+
+	head = itree_leaf_get_head(block1);
+	used_length += le16_to_cpu(head->used_length);
+	head->used_length = cpu_to_le16(used_length);
+
+	/* TODO CHECKSUM */
+
+	err = ext4_handle_dirty_metadata(handle, dir, block1);
+	if (err)
+		return err;
+
+	return used_length;
+}
+
+/*
+ * This function removes frame->at + 1 entry from the index and
+ * coalesces the index if necessarry.
+ */
+static int itree_remove_from_index(handle_t *handle, struct inode *dir,
+				   struct itree_frame *frame,
+				   struct itree_frame *frames)
+{
+	struct itree_node *node, *node1, *node2;
+	struct buffer_head *node_bh, *neighbour_bh, *block1, *block2, *bh;
+	struct itree_entry *end, *entry, *entry1, *entry2;
+	ext4_fsblk_t blk;
+	int blocksize = dir->i_sb->s_blocksize;
+	int count, err = 0, count1, count2, fullness;
+
+	while (frame >= frames) {
+		node_bh = frame->bh;
+		node = (struct itree_node *)(node_bh->b_data);
+		count = le16_to_cpu(node->count);
+		entry = frame->at + 1;
+
+		/* First we update the frame */
+		BUFFER_TRACE(node_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, node_bh);
+		if (err)
+			return err;
+
+		end = frame->entries + count;
+		memmove(entry, entry + 1, (void *)end - (void *)(entry + 1));
+		node->count = cpu_to_le16(--count);
+
+		/*
+		 * Remove tree level in case the root has only a single child
+		 */
+		if (frame == frames && node->indirect_levels && count == 1) {
+			bh = sb_bread(dir->i_sb, le64_to_cpu(frame->at->block));
+			if (!bh)
+				return -EIO;
+			memcpy(node_bh->b_data, bh->b_data, blocksize);
+			ext4_free_blocks(handle, dir, bh, 0, 1,
+			EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+		}
+
+		err = ext4_handle_dirty_metadata(handle, dir, node_bh);
+		if (err)
+			return err;
+
+		if (frame == frames)
+			return 0;
+
+		/* Don't coalesce, remove right away */
+		if (!count) {
+			ext4_free_blocks(handle, dir, frame->bh, 0, 1,
+			EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+
+			frame->bh = NULL;
+			frame->at = NULL;
+			frame->entries = NULL;
+
+			frame--;
+			frame->at--;
+			continue;
+		}
+
+		/* Can we coalesce? */
+		frame--;
+		if (!itree_can_coalesce(frame, &entry1, &entry2)) {
+			fullness = itree_get_node_fullness(node);
+			err = itree_update_fullness(handle, dir, frame,
+						    fullness);
+			return err;
+		}
+
+		/* Get the neighbour block */
+		if (frame->at == entry1) {
+			blk = le64_to_cpu(entry2->block);
+			neighbour_bh = sb_bread(dir->i_sb, blk);
+			if (!neighbour_bh)
+				return -EIO;
+
+			block1 = node_bh;
+			block2 = neighbour_bh;
+
+			entry = frame->at + 1;
+		} else {
+			blk = le64_to_cpu(entry1->block);
+			neighbour_bh = sb_bread(dir->i_sb, blk);
+			if (!neighbour_bh)
+				return -EIO;
+
+			block1 = neighbour_bh;
+			block2 = node_bh;
+
+			entry = frame->at--;
+		}
+
+		BUFFER_TRACE(block1, "get_write_access");
+		err = ext4_journal_get_write_access(handle, block1);
+		if (err) {
+			brelse(block2);
+			return err;
+		}
+
+		node1 = (struct itree_node *)block1->b_data;
+		node2 = (struct itree_node *)block2->b_data;
+		count1 = le16_to_cpu(node1->count);
+		count2 = le16_to_cpu(node2->count);
+
+		memcpy(node1->entries + count1, node2->entries,
+		       count2 * sizeof(struct itree_entry));
+		count = count1 + count2;
+		node1->count = cpu_to_le16(count);
+
+		if ((frame+1)->bh == block2) {
+			(frame+1)->bh = block1;
+			(frame+1)->entries = node1->entries;
+			(frame+1)->at = node1->entries + count1 +
+					((frame+1)->at - (frame+1)->entries);
+		}
+
+		err = ext4_handle_dirty_metadata(handle, dir, block1);
+		if (err) {
+			brelse(block2);
+			return err;
+		}
+
+		fullness = itree_get_node_fullness(node1);
+		err = itree_update_fullness(handle, dir, frame, fullness);
+
+		brelse(block2);
+		ext4_free_itree_block(handle, dir, le64_to_cpu(entry->block));
+	}
+
+	return err;
+}
+
+static int is_last_leaf(struct itree_frame *frame, struct itree_frame *frames)
+{
+	struct itree_node *node;
+	int count = 0;
+
+	while (frame >= frames) {
+		node = (struct itree_node *)(frame->bh->b_data);
+		count = le16_to_cpu(node->count);
+		if (count > 1)
+			return 0;
+
+		frame--;
+	}
+
+	return 1;
+}
+
+static int itree_do_delete_entry(handle_t *handle, struct inode *dir,
+				 struct itree_leaf_entry *entry,
+				 struct itree_leaf_entry *prev_entry,
+				 struct buffer_head *leaf,
+				 struct itree_frame *frame,
+				 struct itree_frame *frames)
+{
+	struct itree_entry *entry1 = NULL, *entry2 = NULL;
+	struct itree_leaf_head *head;
+	struct buffer_head *neighbour, *block1, *block2;
+	int used_length = 0, err = 0, fullness;
+	int blocksize = dir->i_sb->s_blocksize;
+
+	BUFFER_TRACE(leaf, "get_write_access");
+	err = ext4_journal_get_write_access(handle, leaf);
+	if (err) {
+		brelse(leaf);
+		return err;
+	}
+
+	itree_erease_leaf_entry(dir, leaf, entry, prev_entry);
+
+	err = ext4_handle_dirty_metadata(handle, dir, leaf);
+	if (err) {
+		brelse(leaf);
+		return err;
+	}
+
+	head = (struct itree_leaf_head *)leaf->b_data;
+	fullness = itree_get_leaf_fullness(head, blocksize);
+	err = itree_update_fullness(handle, dir, frame, fullness);
+
+	/* No coalescing, remove the block right away */
+	used_length = le16_to_cpu(head->used_length);
+	if (!used_length && !is_last_leaf(frame, frames)) {
+		brelse(leaf);
+		ext4_free_blocks(handle, dir, leaf, 0, 1,
+			EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+
+		frame->at--;
+		err = itree_remove_from_index(handle, dir, frame, frames);
+		return err;
+	}
+
+	if (!itree_can_coalesce(frame, &entry1, &entry2))
+		return 0;
+
+	/* Get the neighbour leaf block */
+	if (frame->at == entry1) {
+		neighbour = sb_bread(dir->i_sb, le64_to_cpu(entry2->block));
+		if (!neighbour) {
+			brelse(leaf);
+			return -EIO;
+		}
+
+		block1 = leaf;
+		block2 = neighbour;
+	} else {
+		neighbour = sb_bread(dir->i_sb, le64_to_cpu(entry1->block));
+		if (!neighbour) {
+			brelse(leaf);
+			return -EIO;
+		}
+
+		block1 = neighbour;
+		block2 = leaf;
+
+		frame->at--;
+	}
+
+	head = itree_leaf_get_head(block2);
+	if (head->used_length) {
+		err = itree_merge_leaf_nodes(handle, dir, block1, block2);
+		if (err < 0) {
+			brelse(block1);
+			brelse(block2);
+			return err;
+		}
+
+		head = (struct itree_leaf_head *)block1->b_data;
+		fullness = itree_get_leaf_fullness(head, blocksize);
+		err = itree_update_fullness(handle, dir, frame, fullness);
+	}
+
+	brelse(block1);
+	brelse(block2);
+	ext4_free_itree_block(handle, dir, le64_to_cpu(entry2->block));
+
+	err = itree_remove_from_index(handle, dir, frame, frames);
+
+	return err;
+}
+
+static int itree_delete_entry(handle_t *handle, struct inode *dir,
+			      struct dentry *dentry)
+{
+	/*
+	 * TODO When deleting the last entry, look at the previous
+	 * entry and if it is different, check the collission flag
+	 * of the next block and clear it.
+	 */
+
+	/* This will be called from ext4_delete_entry() */
+	struct itree_frame frames[ITREE_MAX_DEPTH];
+	struct itree_frame *frame;
+	struct buffer_head *bh, *leaf;
+	ext4_fsblk_t root_blk, leaf_blk;
+	int err, retval;
+	struct itree_leaf_entry *entry, *prev_entry;
+	struct dx_hash_info hinfo;
+	struct dx_root *root;
+	struct itree_key key;
+
+	/* TODO Split the finding code to itree_find_entry? */
+
+	memset(frames, 0, ITREE_MAX_DEPTH*sizeof(struct itree_frame));
+
+	/* Get itree root block */
+	bh = ext4_bread(NULL, dir, 0, 0, &err);
+	if (!bh)
+		return err;
+
+	root = (struct dx_root *) bh->b_data;
+
+	err = dx_get_itree_root(dir, (struct ext4_dir_entry *)bh->b_data,
+				&root_blk);
+	brelse(bh);
+	if (err)
+		return err;
+
+	/* TODO Checksum */
+
+	hinfo.hash_version = root->info.hash_version;
+	if (hinfo.hash_version <= DX_HASH_TEA)
+		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
+	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
+	ext4fs_dirhash(dentry->d_name.name, dentry->d_name.len, &hinfo);
+
+	key.inode = dentry->d_inode->i_ino;
+	key.hash = hinfo.hash;
+
+	frame = itree_probe(&key, dir, root_blk, frames, &err);
+	if (!frame)
+		return err;
+
+	while (1) {
+		/* Get leaf */
+		leaf_blk = le64_to_cpu(frame->at->block);
+		err = -EIO;
+		leaf = sb_getblk(dir->i_sb, leaf_blk);
+		if (!leaf)
+			goto out; /* FIXME change GOTO's to breaks? */
+
+		/* TODO Checksum */
+
+		retval = itree_search_leaf(leaf, dir, key.inode, key.hash,
+					   &(dentry->d_name), &entry,
+					   &prev_entry);
+		if (retval == 1) {
+			/*
+			 * The 'leaf' buffer head is released within this
+			 * function. It might also invalidate the frames
+			 * in case some blocks in the tree are merged.
+			 */
+			err = itree_do_delete_entry(handle, dir, entry,
+						    prev_entry, leaf,
+						    frame, frames);
+			goto out;
+		} else if (retval == -1) {
+			err = -EIO;
+			brelse(leaf);
+			/* TODO: print error bad itree */
+			goto out;
+		}
+
+		/* Not found in the block. Could be collision. */
+		brelse(leaf);
+		retval = itree_next_frame(dir, key.inode, frames, frame, 0);
+		if (retval < 0) {
+			err = retval;
+			goto out;
+		}
+
+		err = -ENOENT;
+		if (retval > 0)
+			goto out;
+	}
+
+out:
+	itree_release_frames(frames);
+	return err;
+}
+
 /*
  * Arrange the dirents to the two new itree blocks in the order
  * specified by the map. Returns 1 in case the split occured within
-- 
1.7.11.7

