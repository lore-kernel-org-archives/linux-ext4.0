From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 09/10] ext4: namei: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:04 +0530
Message-ID: <1350414785-7848-9-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed checkpatch.pl reported issues

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/namei.c |  135 ++++++++++++++++++-----------------------
 1 files changed, 58 insertions(+), 77 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/namei.c b/linux-3.7-rc1/fs/ext4/namei.c
index 6d600a6..44b7d09 100644
--- a/linux-3.7-rc1/fs/ext4/namei.c
+++ b/linux-3.7-rc1/fs/ext4/namei.c
@@ -47,7 +47,7 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
+#define NAMEI_RA_INDEX(c , b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
@@ -93,22 +93,19 @@ static struct buffer_head *ext4_append(handle_t *handle,
 #define dxtrace(command)
 #endif
 
-struct fake_dirent
-{
+struct fake_dirent {
 	__le32 inode;
 	__le16 rec_len;
 	u8 name_len;
 	u8 file_type;
 };
 
-struct dx_countlimit
-{
+struct dx_countlimit {
 	__le16 limit;
 	__le16 count;
 };
 
-struct dx_entry
-{
+struct dx_entry {
 	__le32 hash;
 	__le32 block;
 };
@@ -119,14 +116,12 @@ struct dx_entry
  * hash version mod 4 should never be 0.  Sincerely, the paranoia department.
  */
 
-struct dx_root
-{
+struct dx_root {
 	struct fake_dirent dot;
 	char dot_name[4];
 	struct fake_dirent dotdot;
 	char dotdot_name[4];
-	struct dx_root_info
-	{
+	struct dx_root_info {
 		__le32 reserved_zero;
 		u8 hash_version;
 		u8 info_length; /* 8 */
@@ -137,22 +132,19 @@ struct dx_root
 	struct dx_entry	entries[0];
 };
 
-struct dx_node
-{
+struct dx_node {
 	struct fake_dirent fake;
 	struct dx_entry	entries[0];
 };
 
 
-struct dx_frame
-{
+struct dx_frame {
 	struct buffer_head *bh;
 	struct dx_entry *entries;
 	struct dx_entry *at;
 };
 
-struct dx_map_entry
-{
+struct dx_map_entry {
 	u32 hash;
 	u16 offs;
 	u16 size;
@@ -187,14 +179,14 @@ static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext4_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count, unsigned blocksize);
-static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize);
+static struct ext4_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize);
 static void dx_insert_block(struct dx_frame *frame,
 					u32 hash, ext4_lblk_t block);
 static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
 				 __u32 *start_hash);
-static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
+static struct buffer_head *ext4_dx_find_entry(struct inode *dir,
 		const struct qstr *d_name,
 		struct ext4_dir_entry_2 **res_dir,
 		int *err);
@@ -505,9 +497,9 @@ static inline unsigned dx_node_limit(struct inode *dir)
  * Debug
  */
 #ifdef DX_DEBUG
-static void dx_show_index(char * label, struct dx_entry *entries)
+static void dx_show_index(char *label, struct dx_entry *entries)
 {
-	int i, n = dx_get_count (entries);
+	int i, n = dx_get_count(entries);
 	printk(KERN_DEBUG "%s index ", label);
 	for (i = 0; i < n; i++) {
 		printk("%x->%lu ", i ? dx_get_hash(entries + i) :
@@ -516,8 +508,7 @@ static void dx_show_index(char * label, struct dx_entry *entries)
 	printk("\n");
 }
 
-struct stats
-{
+struct stats {
 	unsigned names;
 	unsigned space;
 	unsigned bcount;
@@ -531,12 +522,9 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 	struct dx_hash_info h = *hinfo;
 
 	printk("names: ");
-	while ((char *) de < base + size)
-	{
-		if (de->inode)
-		{
-			if (show_names)
-			{
+	while ((char *) de < base + size) {
+		if (de->inode) {
+			if (show_names) {
 				int len = de->name_len;
 				char *name = de->name;
 				while (len--) printk("%c", *name++);
@@ -562,14 +550,13 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 	struct buffer_head *bh;
 	int err;
 	printk("%i indexed blocks...\n", count);
-	for (i = 0; i < count; i++, entries++)
-	{
+	for (i = 0; i < count; i++, entries++) {
 		ext4_lblk_t block = dx_get_block(entries);
 		ext4_lblk_t hash  = i ? dx_get_hash(entries): 0;
 		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
 		struct stats stats;
 		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
-		if (!(bh = ext4_bread (NULL,dir, block, 0,&err))) continue;
+		if (!(bh = ext4_bread(NULL, dir, block, 0, &err))) continue;
 		stats = levels?
 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
 		   dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) bh->b_data, blocksize, 0);
@@ -667,8 +654,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	}
 
 	dxtrace(printk("Look up %x", hash));
-	while (1)
-	{
+	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
 			ext4_warning(dir->i_sb,
@@ -680,8 +666,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 
 		p = entries + 1;
 		q = entries + count - 1;
-		while (p <= q)
-		{
+		while (p <= q) {
 			m = p + (q - p)/2;
 			dxtrace(printk("."));
 			if (dx_get_hash(m) > hash)
@@ -690,20 +675,17 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 				p = m + 1;
 		}
 
-		if (0) // linear search cross check
-		{
+		if (0) { /* linear search cross check */
 			unsigned n = count - 1;
 			at = entries;
-			while (n--)
-			{
+			while (n--) {
 				dxtrace(printk(","));
-				if (dx_get_hash(++at) > hash)
-				{
+				if (dx_get_hash(++at) > hash) {
 					at--;
 					break;
 				}
 			}
-			assert (at == p - 1);
+			assert(at == p - 1);
 		}
 
 		at = p - 1;
@@ -729,7 +711,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		}
 		set_buffer_verified(bh);
 
-		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+		if (dx_get_limit(entries) != dx_node_limit(dir)) {
 			ext4_warning(dir->i_sb,
 				     "dx entry: limit != node limit");
 			brelse(bh);
@@ -752,7 +734,7 @@ fail:
 	return NULL;
 }
 
-static void dx_release (struct dx_frame *frames)
+static void dx_release(struct dx_frame *frames)
 {
 	if (frames[0].bh == NULL)
 		return;
@@ -964,7 +946,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 			goto errout;
 		count++;
 	}
-	if (start_hash < 2 || (start_hash ==2 && start_minor_hash==0)) {
+	if (start_hash < 2 || (start_hash == 2 && start_minor_hash == 0)) {
 		de = (struct ext4_dir_entry_2 *) frames[0].bh->b_data;
 		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 		if ((err = ext4_htree_store_dirent(dir_file, 2, 0, de)) != 0)
@@ -1004,7 +986,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	return count;
 errout:
 	dx_release(frames);
-	return (err);
+	return err;
 }
 
 
@@ -1041,7 +1023,7 @@ static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 }
 
 /* Sort map by hash value */
-static void dx_sort_map (struct dx_map_entry *map, unsigned count)
+static void dx_sort_map(struct dx_map_entry *map, unsigned count)
 {
 	struct dx_map_entry *p, *q, *top = map + count - 1;
 	int more;
@@ -1064,7 +1046,7 @@ static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 			swap(*(q+1), *q);
 			more = 1;
 		}
-	} while(more);
+	} while (more);
 }
 
 static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
@@ -1094,8 +1076,8 @@ static void ext4_update_dx_flag(struct inode *inode)
  * `len <= EXT4_NAME_LEN' is guaranteed by caller.
  * `de != NULL' is guaranteed by caller.
  */
-static inline int ext4_match (int len, const char * const name,
-			      struct ext4_dir_entry_2 * de)
+static inline int ext4_match(int len, const char * const name,
+			      struct ext4_dir_entry_2 *de)
 {
 	if (len != de->name_len)
 		return 0;
@@ -1111,10 +1093,10 @@ static inline int search_dirblock(struct buffer_head *bh,
 				  struct inode *dir,
 				  const struct qstr *d_name,
 				  unsigned int offset,
-				  struct ext4_dir_entry_2 ** res_dir)
+				  struct ext4_dir_entry_2 **res_dir)
 {
-	struct ext4_dir_entry_2 * de;
-	char * dlimit;
+	struct ext4_dir_entry_2 *de;
+	char *dlimit;
 	int de_len;
 	const char *name = d_name->name;
 	int namelen = d_name->len;
@@ -1126,7 +1108,7 @@ static inline int search_dirblock(struct buffer_head *bh,
 		/* do minimal checking `by hand' */
 
 		if ((char *) de + namelen <= dlimit &&
-		    ext4_match (namelen, name, de)) {
+		    ext4_match(namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, offset))
 				return -1;
@@ -1156,9 +1138,9 @@ static inline int search_dirblock(struct buffer_head *bh,
  * The returned buffer_head has ->b_count elevated.  The caller is expected
  * to brelse() it when appropriate.
  */
-static struct buffer_head * ext4_find_entry (struct inode *dir,
+static struct buffer_head *ext4_find_entry(struct inode *dir,
 					const struct qstr *d_name,
-					struct ext4_dir_entry_2 ** res_dir)
+					struct ext4_dir_entry_2 **res_dir)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
@@ -1286,10 +1268,10 @@ cleanup_and_exit:
 	return ret;
 }
 
-static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct qstr *d_name,
+static struct buffer_head *ext4_dx_find_entry(struct inode *dir, const struct qstr *d_name,
 		       struct ext4_dir_entry_2 **res_dir, int *err)
 {
-	struct super_block * sb = dir->i_sb;
+	struct super_block *sb = dir->i_sb;
 	struct dx_hash_info	hinfo;
 	struct dx_frame frames[2], *frame;
 	struct buffer_head *bh;
@@ -1348,7 +1330,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 	*err = -ENOENT;
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
-	dx_release (frames);
+	dx_release(frames);
 	return NULL;
 }
 
@@ -1392,7 +1374,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 {
 	__u32 ino;
 	static const struct qstr dotdot = QSTR_INIT("..", 2);
-	struct ext4_dir_entry_2 * de;
+	struct ext4_dir_entry_2 *de;
 	struct buffer_head *bh;
 
 	bh = ext4_find_entry(child->d_inode, &dotdot, &de);
@@ -1442,7 +1424,7 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count,
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
 		rec_len = EXT4_DIR_REC_LEN(de->name_len);
-		memcpy (to, de, rec_len);
+		memcpy(to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
 				ext4_rec_len_to_disk(rec_len, blocksize);
 		de->inode = 0;
@@ -1456,13 +1438,13 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count,
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize)
+static struct ext4_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize)
 {
 	struct ext4_dir_entry_2 *next, *to, *prev, *de = (struct ext4_dir_entry_2 *) base;
 	unsigned rec_len = 0;
 
 	prev = to = de;
-	while ((char*)de < base + blocksize) {
+	while ((char *)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
 			rec_len = EXT4_DIR_REC_LEN(de->name_len);
@@ -1483,7 +1465,7 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize)
  * Returns pointer to de in block into which the new entry will be inserted.
  */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
-			struct buffer_head **bh,struct dx_frame *frame,
+			struct buffer_head **bh, struct dx_frame *frame,
 			struct dx_hash_info *hinfo, int *error)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
@@ -1503,7 +1485,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
-	bh2 = ext4_append (handle, dir, &newblock, &err);
+	bh2 = ext4_append(handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1563,12 +1545,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		initialize_dirent_tail(t, blocksize);
 	}
 
-	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data1, blocksize, 1));
-	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
+	dxtrace(dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) data1, blocksize, 1));
+	dxtrace(dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
 
 	/* Which block gets the new entry? */
-	if (hinfo->hash >= hash2)
-	{
+	if (hinfo->hash >= hash2) {
 		swap(*bh, bh2);
 		de = de2;
 	}
@@ -1630,7 +1611,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 				return -EEXIST;
 			nlen = EXT4_DIR_REC_LEN(de->name_len);
 			rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
-			if ((de->inode? rlen - nlen: rlen) >= reclen)
+			if ((de->inode ? rlen - nlen : rlen) >= reclen)
 				break;
 			de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
 			offset += rlen;
@@ -1740,7 +1721,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
 	data1 = bh2->b_data;
 
-	memcpy (data1, de, len);
+	memcpy(data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;
 	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
@@ -1758,7 +1739,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
 	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2),
 					   blocksize);
-	memset (&root->info, 0, sizeof(root->info));
+	memset(&root->info, 0, sizeof(root->info));
 	root->info.info_length = sizeof(root->info);
 	root->info.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
 	entries = root->entries;
@@ -1781,7 +1762,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	ext4_handle_dirty_dirent_node(handle, dir, bh);
 
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
+	de = do_split(handle, dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
 		/*
 		 * Even if the block split failed, we have to properly write
@@ -1818,7 +1799,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext4_dir_entry_tail *t;
 	struct super_block *sb;
 	int	retval;
-	int	dx_fallback=0;
+	int	dx_fallback = 0;
 	unsigned blocksize;
 	ext4_lblk_t block, blocks;
 	int	csum_size = 0;
@@ -1948,7 +1929,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			err = -ENOSPC;
 			goto cleanup;
 		}
-		bh2 = ext4_append (handle, dir, &newblock, &err);
+		bh2 = ext4_append(handle, dir, &newblock, &err);
 		if (!(bh2))
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
@@ -1991,7 +1972,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			err = ext4_handle_dirty_dx_node(handle, dir, bh2);
 			if (err)
 				goto journal_error;
-			brelse (bh2);
+			brelse(bh2);
 		} else {
 			dxtrace(printk(KERN_DEBUG
 				       "Creating second level index...\n"));
-- 
1.7.7.3
