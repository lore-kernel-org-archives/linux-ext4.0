From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Coding style fix in namei.c
Date: Fri, 19 Nov 2010 19:13:09 +0900
Message-ID: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 * break long lines (using temp variables if needed)
 * merge short lines
 * put open brace on the same line
 * use C89-style comments
 * remove a space between function name and parenthesis
 * remove a space between '*' and pointer name
 * add a space after ','
 * other random whitespace fixes

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/namei.c |  576 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 292 insertions(+), 284 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8061281..c7cdf32 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -49,8 +49,7 @@
 #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 #define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
-static struct buffer_head *ext3_append(handle_t *handle,
-					struct inode *inode,
+static struct buffer_head *ext3_append(handle_t *handle, struct inode *inode,
 					u32 *block, int *err)
 {
 	struct buffer_head *bh;
@@ -80,22 +79,19 @@ static struct buffer_head *ext3_append(handle_t *handle,
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
@@ -106,73 +102,65 @@ struct dx_entry
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
 		u8 indirect_levels;
 		u8 unused_flags;
-	}
-	info;
+	} info;
 	struct dx_entry	entries[0];
 };
 
-struct dx_node
-{
+struct dx_node {
 	struct fake_dirent fake;
 	struct dx_entry	entries[0];
 };
 
-
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
 };
 
-static inline unsigned dx_get_block (struct dx_entry *entry);
-static void dx_set_block (struct dx_entry *entry, unsigned value);
-static inline unsigned dx_get_hash (struct dx_entry *entry);
-static void dx_set_hash (struct dx_entry *entry, unsigned value);
-static unsigned dx_get_count (struct dx_entry *entries);
-static unsigned dx_get_limit (struct dx_entry *entries);
-static void dx_set_count (struct dx_entry *entries, unsigned value);
-static void dx_set_limit (struct dx_entry *entries, unsigned value);
-static unsigned dx_root_limit (struct inode *dir, unsigned infosize);
-static unsigned dx_node_limit (struct inode *dir);
-static struct dx_frame *dx_probe(struct qstr *entry,
-				 struct inode *dir,
+static inline unsigned dx_get_block(struct dx_entry *entry);
+static void dx_set_block(struct dx_entry *entry, unsigned value);
+static inline unsigned dx_get_hash(struct dx_entry *entry);
+static void dx_set_hash(struct dx_entry *entry, unsigned value);
+static unsigned dx_get_count(struct dx_entry *entries);
+static unsigned dx_get_limit(struct dx_entry *entries);
+static void dx_set_count(struct dx_entry *entries, unsigned value);
+static void dx_set_limit(struct dx_entry *entries, unsigned value);
+static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
+static unsigned dx_node_limit(struct inode *dir);
+static struct dx_frame *dx_probe(struct qstr *entry, struct inode *dir,
 				 struct dx_hash_info *hinfo,
-				 struct dx_frame *frame,
-				 int *err);
-static void dx_release (struct dx_frame *frames);
+				 struct dx_frame *frame, int *err);
+static void dx_release(struct dx_frame *frames);
 static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
-			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
+		       struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
-static struct ext3_dir_entry_2 *dx_move_dirents (char *from, char *to,
+static struct ext3_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize);
-static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
+static struct ext3_dir_entry_2 *dx_pack_dirents(char *base,
+						unsigned blocksize);
+static void dx_insert_block(struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
 				 __u32 *start_hash);
-static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
+static struct buffer_head *ext3_dx_find_entry(struct inode *dir,
 			struct qstr *entry, struct ext3_dir_entry_2 **res_dir,
 			int *err);
 static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
@@ -193,54 +181,54 @@ ext3_next_entry(struct ext3_dir_entry_2 *p)
  * Mask them off for now.
  */
 
-static inline unsigned dx_get_block (struct dx_entry *entry)
+static inline unsigned dx_get_block(struct dx_entry *entry)
 {
 	return le32_to_cpu(entry->block) & 0x00ffffff;
 }
 
-static inline void dx_set_block (struct dx_entry *entry, unsigned value)
+static inline void dx_set_block(struct dx_entry *entry, unsigned value)
 {
 	entry->block = cpu_to_le32(value);
 }
 
-static inline unsigned dx_get_hash (struct dx_entry *entry)
+static inline unsigned dx_get_hash(struct dx_entry *entry)
 {
 	return le32_to_cpu(entry->hash);
 }
 
-static inline void dx_set_hash (struct dx_entry *entry, unsigned value)
+static inline void dx_set_hash(struct dx_entry *entry, unsigned value)
 {
 	entry->hash = cpu_to_le32(value);
 }
 
-static inline unsigned dx_get_count (struct dx_entry *entries)
+static inline unsigned dx_get_count(struct dx_entry *entries)
 {
 	return le16_to_cpu(((struct dx_countlimit *) entries)->count);
 }
 
-static inline unsigned dx_get_limit (struct dx_entry *entries)
+static inline unsigned dx_get_limit(struct dx_entry *entries)
 {
 	return le16_to_cpu(((struct dx_countlimit *) entries)->limit);
 }
 
-static inline void dx_set_count (struct dx_entry *entries, unsigned value)
+static inline void dx_set_count(struct dx_entry *entries, unsigned value)
 {
 	((struct dx_countlimit *) entries)->count = cpu_to_le16(value);
 }
 
-static inline void dx_set_limit (struct dx_entry *entries, unsigned value)
+static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 {
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
 		EXT3_DIR_REC_LEN(2) - infosize;
 	return entry_space / sizeof(struct dx_entry);
 }
 
-static inline unsigned dx_node_limit (struct inode *dir)
+static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(0);
 	return entry_space / sizeof(struct dx_entry);
@@ -250,25 +238,26 @@ static inline unsigned dx_node_limit (struct inode *dir)
  * Debug
  */
 #ifdef DX_DEBUG
-static void dx_show_index (char * label, struct dx_entry *entries)
+static void dx_show_index(char *label, struct dx_entry *entries)
 {
-        int i, n = dx_get_count (entries);
-        printk("%s index ", label);
-        for (i = 0; i < n; i++)
-        {
-                printk("%x->%u ", i? dx_get_hash(entries + i): 0, dx_get_block(entries + i));
-        }
-        printk("\n");
+	int i, n = dx_get_count(entries);
+
+	printk("%s index ", label);
+	for (i = 0; i < n; i++) {
+		printk("%x->%u ", i ? dx_get_hash(entries + i) : 0,
+		       dx_get_block(entries + i));
+	}
+	printk("\n");
 }
 
-struct stats
-{
+struct stats {
 	unsigned names;
 	unsigned space;
 	unsigned bcount;
 };
 
-static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_entry_2 *de,
+static struct stats dx_show_leaf(struct dx_hash_info *hinfo,
+				 struct ext3_dir_entry_2 *de,
 				 int size, int show_names)
 {
 	unsigned names = 0, space = 0;
@@ -276,12 +265,9 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext3_dir_ent
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
@@ -302,29 +288,43 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 			     struct dx_entry *entries, int levels)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count = dx_get_count (entries), names = 0, space = 0, i;
-	unsigned bcount = 0;
+	unsigned count = dx_get_count(entries), names = 0, space = 0;
+	unsigned i, bcount = 0;
 	struct buffer_head *bh;
 	int err;
+
 	printk("%i indexed blocks...\n", count);
-	for (i = 0; i < count; i++, entries++)
-	{
-		u32 block = dx_get_block(entries), hash = i? dx_get_hash(entries): 0;
-		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
+	for (i = 0; i < count; i++, entries++) {
+		u32 block = dx_get_block(entries);
+		u32 hash = i ? dx_get_hash(entries) : 0;
+		u32 range;
 		struct stats stats;
-		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
-		if (!(bh = ext3_bread (NULL,dir, block, 0,&err))) continue;
-		stats = levels?
-		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
-		   dx_show_leaf(hinfo, (struct ext3_dir_entry_2 *) bh->b_data, blocksize, 0);
+
+		if (i < count - 1)
+			range = dx_get_hash(entries + 1) - hash;
+		else
+			range = ~hash;
+		printk("%s%3u:%03u hash %8x/%8x ", levels ? "" : "   ",
+						   i, block, hash, range);
+		if (!(bh = ext3_bread(NULL, dir, block, 0, &err)))
+			continue;
+		if (levels) {
+			struct dx_node *node = (struct dx_node *) bh->b_data;
+			stats = dx_show_entries(hinfo, dir, node->entries,
+						levels - 1);
+		} else {
+			struct ext3_dir_entry_2 *de;
+			de = (struct ext3_dir_entry_2 *) bh->b_data;
+			stats = dx_show_leaf(hinfo, de, blocksize, 0);
+		}
 		names += stats.names;
 		space += stats.space;
 		bcount += stats.bcount;
-		brelse (bh);
+		brelse(bh);
 	}
 	if (bcount)
-		printk("%snames %u, fullness %u (%u%%)\n", levels?"":"   ",
-			names, space/bcount,(space/bcount)*100/blocksize);
+		printk("%snames %u, fullness %u (%u%%)\n", levels ? "" : "   ",
+			names, space/bcount, (space/bcount) * 100 / blocksize);
 	return (struct stats) { names, space, bcount};
 }
 #endif /* DX_DEBUG */
@@ -350,7 +350,7 @@ dx_probe(struct qstr *entry, struct inode *dir,
 	u32 hash;
 
 	frame->bh = NULL;
-	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
+	if (!(bh = ext3_bread(NULL, dir, 0, 0, err)))
 		goto fail;
 	root = (struct dx_root *) bh->b_data;
 	if (root->info.hash_version != DX_HASH_TEA &&
@@ -401,9 +401,8 @@ dx_probe(struct qstr *entry, struct inode *dir,
 		goto fail;
 	}
 
-	dxtrace (printk("Look up %x", hash));
-	while (1)
-	{
+	dxtrace(printk("Look up %x", hash));
+	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
 			ext3_warning(dir->i_sb, __func__,
@@ -415,8 +414,7 @@ dx_probe(struct qstr *entry, struct inode *dir,
 
 		p = entries + 1;
 		q = entries + count - 1;
-		while (p <= q)
-		{
+		while (p <= q) {
 			m = p + (q - p)/2;
 			dxtrace(printk("."));
 			if (dx_get_hash(m) > hash)
@@ -425,32 +423,32 @@ dx_probe(struct qstr *entry, struct inode *dir,
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
-		dxtrace(printk(" %x->%u\n", at == entries? 0: dx_get_hash(at), dx_get_block(at)));
+		dxtrace(printk(" %x->%u\n", at == entries ? 0 : dx_get_hash(at),
+			       dx_get_block(at)));
 		frame->bh = bh;
 		frame->entries = entries;
 		frame->at = at;
-		if (!indirect--) return frame;
-		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
+
+		if (!indirect--)
+			return frame;
+		if (!(bh = ext3_bread(NULL, dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+		if (dx_get_limit(entries) != dx_node_limit(dir)) {
 			ext3_warning(dir->i_sb, __func__,
 				     "dx entry: limit != node limit");
 			brelse(bh);
@@ -473,7 +471,7 @@ fail:
 	return NULL;
 }
 
-static void dx_release (struct dx_frame *frames)
+static void dx_release(struct dx_frame *frames)
 {
 	if (frames[0].bh == NULL)
 		return;
@@ -550,7 +548,7 @@ static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				      0, &err)))
 			return err; /* Failure */
 		p++;
-		brelse (p->bh);
+		brelse(p->bh);
 		p->bh = bh;
 		p->at = p->entries = ((struct dx_node *) bh->b_data)->entries;
 	}
@@ -573,7 +571,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	int err, count = 0;
 
 	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
-	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
+	if (!(bh = ext3_bread(NULL, dir, block, 0, &err)))
 		return err;
 
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
@@ -581,13 +579,13 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 					   dir->i_sb->s_blocksize -
 					   EXT3_DIR_REC_LEN(0));
 	for (; de < top; de = ext3_next_entry(de)) {
-		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
-					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
-						+((char *)de - bh->b_data))) {
+		if (!ext3_check_dir_entry(__func__, dir, de, bh,
+				(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
+					+ ((char *)de - bh->b_data))) {
 			/* On error, skip the f_pos to the next block. */
 			dir_file->f_pos = (dir_file->f_pos |
 					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
+			brelse(bh);
 			return count;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
@@ -645,7 +643,8 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	}
 	hinfo.hash = start_hash;
 	hinfo.minor_hash = 0;
-	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo, frames, &err);
+	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo,
+			 frames, &err);
 	if (!frame)
 		return err;
 
@@ -686,8 +685,7 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		 * (b) we have inserted at least one entry and the
 		 * next hash value is not a continuation
 		 */
-		if ((ret == 0) ||
-		    (count && ((hashval & 1) == 0)))
+		if ((ret == 0) || (count && ((hashval & 1) == 0)))
 			break;
 	}
 	dx_release(frames);
@@ -715,8 +713,7 @@ static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + blocksize)
-	{
+	while ((char *) de < base + blocksize) {
 		if (de->name_len && de->inode) {
 			ext3fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
@@ -733,30 +730,28 @@ static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
 }
 
 /* Sort map by hash value */
-static void dx_sort_map (struct dx_map_entry *map, unsigned count)
+static void dx_sort_map(struct dx_map_entry *map, unsigned count)
 {
-        struct dx_map_entry *p, *q, *top = map + count - 1;
-        int more;
-        /* Combsort until bubble sort doesn't suck */
-        while (count > 2)
-	{
-                count = count*10/13;
-                if (count - 9 < 2) /* 9, 10 -> 11 */
-                        count = 11;
-                for (p = top, q = p - count; q >= map; p--, q--)
-                        if (p->hash < q->hash)
-                                swap(*p, *q);
-        }
-        /* Garden variety bubble sort */
-        do {
-                more = 0;
-                q = top;
-                while (q-- > map)
-		{
-                        if (q[1].hash >= q[0].hash)
+	struct dx_map_entry *p, *q, *top = map + count - 1;
+	int more;
+	/* Combsort until bubble sort doesn't suck */
+	while (count > 2) {
+		count = count * 10 / 13;
+		if (count - 9 < 2) /* 9, 10 -> 11 */
+			count = 11;
+		for (p = top, q = p - count; q >= map; p--, q--)
+			if (p->hash < q->hash)
+				swap(*p, *q);
+	}
+	/* Garden variety bubble sort */
+	do {
+		more = 0;
+		q = top;
+		while (q-- > map) {
+			if (q[1].hash >= q[0].hash)
 				continue;
-                        swap(*(q+1), *q);
-                        more = 1;
+			swap(*(q+1), *q);
+			more = 1;
 		}
 	} while(more);
 }
@@ -788,8 +783,8 @@ static void ext3_update_dx_flag(struct inode *inode)
  * `len <= EXT3_NAME_LEN' is guaranteed by caller.
  * `de != NULL' is guaranteed by caller.
  */
-static inline int ext3_match (int len, const char * const name,
-			      struct ext3_dir_entry_2 * de)
+static inline int ext3_match(int len, const char *const name,
+			      struct ext3_dir_entry_2 *de)
 {
 	if (len != de->name_len)
 		return 0;
@@ -801,14 +796,14 @@ static inline int ext3_match (int len, const char * const name,
 /*
  * Returns 0 if not found, -1 on failure, and 1 on success
  */
-static inline int search_dirblock(struct buffer_head * bh,
+static inline int search_dirblock(struct buffer_head *bh,
 				  struct inode *dir,
 				  struct qstr *child,
 				  unsigned long offset,
-				  struct ext3_dir_entry_2 ** res_dir)
+				  struct ext3_dir_entry_2 **res_dir)
 {
-	struct ext3_dir_entry_2 * de;
-	char * dlimit;
+	struct ext3_dir_entry_2 *de;
+	char *dlimit;
 	int de_len;
 	const char *name = child->name;
 	int namelen = child->len;
@@ -820,7 +815,7 @@ static inline int search_dirblock(struct buffer_head * bh,
 		/* do minimal checking `by hand' */
 
 		if ((char *) de + namelen <= dlimit &&
-		    ext3_match (namelen, name, de)) {
+		    ext3_match(namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
 			if (!ext3_check_dir_entry("ext3_find_entry",
 						  dir, de, bh, offset))
@@ -854,9 +849,9 @@ static struct buffer_head *ext3_find_entry(struct inode *dir,
 					struct qstr *entry,
 					struct ext3_dir_entry_2 **res_dir)
 {
-	struct super_block * sb;
-	struct buffer_head * bh_use[NAMEI_RA_SIZE];
-	struct buffer_head * bh, *ret = NULL;
+	struct super_block *sb;
+	struct buffer_head *bh_use[NAMEI_RA_SIZE];
+	struct buffer_head *bh, *ret = NULL;
 	unsigned long start, block, b;
 	int ra_max = 0;		/* Number of bh's in the readahead
 				   buffer, bh_use[] */
@@ -953,15 +948,15 @@ restart:
 cleanup_and_exit:
 	/* Clean up the read-ahead blocks */
 	for (; ra_ptr < ra_max; ra_ptr++)
-		brelse (bh_use[ra_ptr]);
+		brelse(bh_use[ra_ptr]);
 	return ret;
 }
 
-static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
+static struct buffer_head *ext3_dx_find_entry(struct inode *dir,
 			struct qstr *entry, struct ext3_dir_entry_2 **res_dir,
 			int *err)
 {
-	struct super_block * sb;
+	struct super_block *sb;
 	struct dx_hash_info	hinfo;
 	u32 hash;
 	struct dx_frame frames[2], *frame;
@@ -986,11 +981,11 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 	hash = hinfo.hash;
 	do {
 		block = dx_get_block(frame->at);
-		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
+		if (!(bh = ext3_bread(NULL, dir, block, 0, err)))
 			goto errout;
 		de = (struct ext3_dir_entry_2 *) bh->b_data;
-		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
-				       EXT3_DIR_REC_LEN(0));
+		top = (struct ext3_dir_entry_2 *) ((char *) de +
+				       sb->s_blocksize - EXT3_DIR_REC_LEN(0));
 		for (; de < top; de = ext3_next_entry(de)) {
 			int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
 				  + ((char *) de - bh->b_data);
@@ -1007,7 +1002,7 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 				return bh;
 			}
 		}
-		brelse (bh);
+		brelse(bh);
 		/* Check to see if we should continue to search */
 		retval = ext3_htree_next_block(dir, hash, frame,
 					       frames, NULL);
@@ -1023,15 +1018,16 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 	*err = -ENOENT;
 errout:
 	dxtrace(printk("%s not found\n", name));
-	dx_release (frames);
+	dx_release(frames);
 	return NULL;
 }
 
-static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext3_lookup(struct inode *dir, struct dentry *dentry,
+				  struct nameidata *nd)
 {
-	struct inode * inode;
-	struct ext3_dir_entry_2 * de;
-	struct buffer_head * bh;
+	struct inode *inode;
+	struct ext3_dir_entry_2 *de;
+	struct buffer_head *bh;
 
 	if (dentry->d_name.len > EXT3_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1040,7 +1036,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 	inode = NULL;
 	if (bh) {
 		unsigned long ino = le32_to_cpu(de->inode);
-		brelse (bh);
+		brelse(bh);
 		if (!ext3_valid_inum(dir->i_sb, ino)) {
 			ext3_error(dir->i_sb, "ext3_lookup",
 				   "bad inode number: %lu", ino);
@@ -1050,8 +1046,8 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 		if (unlikely(IS_ERR(inode))) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext3_error(dir->i_sb, __func__,
-						"deleted inode referenced: %lu",
-						ino);
+					   "deleted inode referenced: %lu",
+					   ino);
 				return ERR_PTR(-EIO);
 			} else {
 				return ERR_CAST(inode);
@@ -1065,8 +1061,8 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 struct dentry *ext3_get_parent(struct dentry *child)
 {
 	unsigned long ino;
-	struct qstr dotdot = {.name = "..", .len = 2};
-	struct ext3_dir_entry_2 * de;
+	struct qstr dotdot = { .name = "..", .len = 2 };
+	struct ext3_dir_entry_2 *de;
 	struct buffer_head *bh;
 
 	bh = ext3_find_entry(child->d_inode, &dotdot, &de);
@@ -1097,7 +1093,8 @@ static unsigned char ext3_type_by_mode[S_IFMT >> S_SHIFT] = {
 
 static inline void ext3_set_de_type(struct super_block *sb,
 				struct ext3_dir_entry_2 *de,
-				umode_t mode) {
+				umode_t mode)
+{
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_FILETYPE))
 		de->file_type = ext3_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
 }
@@ -1112,9 +1109,10 @@ dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count)
 	unsigned rec_len = 0;
 
 	while (count--) {
-		struct ext3_dir_entry_2 *de = (struct ext3_dir_entry_2 *) (from + map->offs);
+		struct ext3_dir_entry_2 *de;
+		de = (struct ext3_dir_entry_2 *) (from + map->offs);
 		rec_len = EXT3_DIR_REC_LEN(de->name_len);
-		memcpy (to, de, rec_len);
+		memcpy(to, de, rec_len);
 		((struct ext3_dir_entry_2 *) to)->rec_len =
 				ext3_rec_len_to_disk(rec_len);
 		de->inode = 0;
@@ -1143,7 +1141,8 @@ static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize)
 				memmove(to, de, rec_len);
 			to->rec_len = ext3_rec_len_to_disk(rec_len);
 			prev = to;
-			to = (struct ext3_dir_entry_2 *) (((char *) to) + rec_len);
+			to = (struct ext3_dir_entry_2 *)
+				(((char *) to) + rec_len);
 		}
 		de = next;
 	}
@@ -1170,7 +1169,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	struct ext3_dir_entry_2 *de = NULL, *de2;
 	int	err = 0, i;
 
-	bh2 = ext3_append (handle, dir, &newblock, &err);
+	bh2 = ext3_append(handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1191,10 +1190,10 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 
 	/* create map in the end of data2 block */
 	map = (struct dx_map_entry *) (data2 + blocksize);
-	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
+	count = dx_make_map((struct ext3_dir_entry_2 *) data1,
 			     blocksize, hinfo, map);
 	map -= count;
-	dx_sort_map (map, count);
+	dx_sort_map(map, count);
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
@@ -1217,24 +1216,25 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	de = dx_pack_dirents(data1,blocksize);
 	de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
 	de2->rec_len = ext3_rec_len_to_disk(data2 + blocksize - (char *) de2);
-	dxtrace(dx_show_leaf (hinfo, (struct ext3_dir_entry_2 *) data1, blocksize, 1));
-	dxtrace(dx_show_leaf (hinfo, (struct ext3_dir_entry_2 *) data2, blocksize, 1));
+	dxtrace(dx_show_leaf(hinfo, (struct ext3_dir_entry_2 *) data1,
+			     blocksize, 1));
+	dxtrace(dx_show_leaf(hinfo, (struct ext3_dir_entry_2 *) data2,
+			     blocksize, 1));
 
 	/* Which block gets the new entry? */
-	if (hinfo->hash >= hash2)
-	{
+	if (hinfo->hash >= hash2) {
 		swap(*bh, bh2);
 		de = de2;
 	}
-	dx_insert_block (frame, hash2 + continued, newblock);
-	err = ext3_journal_dirty_metadata (handle, bh2);
+	dx_insert_block(frame, hash2 + continued, newblock);
+	err = ext3_journal_dirty_metadata(handle, bh2);
 	if (err)
 		goto journal_error;
-	err = ext3_journal_dirty_metadata (handle, frame->bh);
+	err = ext3_journal_dirty_metadata(handle, frame->bh);
 	if (err)
 		goto journal_error;
-	brelse (bh2);
-	dxtrace(dx_show_index ("frame", frame->entries));
+	brelse(bh2);
+	dxtrace(dx_show_index("frame", frame->entries));
 	return de;
 
 journal_error:
@@ -1261,7 +1261,7 @@ errout:
  */
 static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode, struct ext3_dir_entry_2 *de,
-			     struct buffer_head * bh)
+			     struct buffer_head *bh)
 {
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
@@ -1278,11 +1278,11 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 		while ((char *) de <= top) {
 			if (!ext3_check_dir_entry("ext3_add_entry", dir, de,
 						  bh, offset)) {
-				brelse (bh);
+				brelse(bh);
 				return -EIO;
 			}
-			if (ext3_match (namelen, name, de)) {
-				brelse (bh);
+			if (ext3_match(namelen, name, de)) {
+				brelse(bh);
 				return -EEXIST;
 			}
 			nlen = EXT3_DIR_REC_LEN(de->name_len);
@@ -1307,7 +1307,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	nlen = EXT3_DIR_REC_LEN(de->name_len);
 	rlen = ext3_rec_len_from_disk(de->rec_len);
 	if (de->inode) {
-		struct ext3_dir_entry_2 *de1 = (struct ext3_dir_entry_2 *)((char *)de + nlen);
+		struct ext3_dir_entry_2 *de1;
+		de1 = (struct ext3_dir_entry_2 *)((char *)de + nlen);
 		de1->rec_len = ext3_rec_len_to_disk(rlen - nlen);
 		de->rec_len = ext3_rec_len_to_disk(nlen);
 		de = de1;
@@ -1319,7 +1320,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	} else
 		de->inode = 0;
 	de->name_len = namelen;
-	memcpy (de->name, name, namelen);
+	memcpy(de->name, name, namelen);
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
@@ -1389,7 +1390,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	}
 	len = ((char *) root) + blocksize - (char *) de;
 
-	bh2 = ext3_append (handle, dir, &block, &retval);
+	bh2 = ext3_append(handle, dir, &block, &retval);
 	if (!(bh2)) {
 		brelse(bh);
 		return retval;
@@ -1397,7 +1398,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	EXT3_I(dir)->i_flags |= EXT3_INDEX_FL;
 	data1 = bh2->b_data;
 
-	memcpy (data1, de, len);
+	memcpy(data1, de, len);
 	de = (struct ext3_dir_entry_2 *) data1;
 	top = data1 + len;
 	while ((char *)(de2 = ext3_next_entry(de)) < top)
@@ -1406,13 +1407,13 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	/* Initialize the root; the dot dirents already exist */
 	de = (struct ext3_dir_entry_2 *) (&root->dotdot);
 	de->rec_len = ext3_rec_len_to_disk(blocksize - EXT3_DIR_REC_LEN(2));
-	memset (&root->info, 0, sizeof(root->info));
+	memset(&root->info, 0, sizeof(root->info));
 	root->info.info_length = sizeof(root->info);
 	root->info.hash_version = EXT3_SB(dir->i_sb)->s_def_hash_version;
 	entries = root->entries;
-	dx_set_block (entries, 1);
-	dx_set_count (entries, 1);
-	dx_set_limit (entries, dx_root_limit(dir, sizeof(root->info)));
+	dx_set_block(entries, 1);
+	dx_set_count(entries, 1);
+	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
 
 	/* Initialize as for dx_probe */
 	hinfo.hash_version = root->info.hash_version;
@@ -1425,8 +1426,8 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
+	de = do_split(handle, dir, &bh, frame, &hinfo, &retval);
+	dx_release(frames);
 	if (!(de))
 		return retval;
 
@@ -1443,13 +1444,13 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
  * may not sleep between calling this and putting something into
  * the entry, as someone else might have used it while you slept.
  */
-static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
+static int ext3_add_entry(handle_t *handle, struct dentry *dentry,
 	struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
-	struct buffer_head * bh;
+	struct buffer_head *bh;
 	struct ext3_dir_entry_2 *de;
-	struct super_block * sb;
+	struct super_block *sb;
 	int	retval;
 	int	dx_fallback=0;
 	unsigned blocksize;
@@ -1499,9 +1500,9 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	struct dx_frame frames[2], *frame;
 	struct dx_entry *entries, *at;
 	struct dx_hash_info hinfo;
-	struct buffer_head * bh;
+	struct buffer_head *bh;
 	struct inode *dir = dentry->d_parent->d_inode;
-	struct super_block * sb = dir->i_sb;
+	struct super_block *sb = dir->i_sb;
 	struct ext3_dir_entry_2 *de;
 	int err;
 
@@ -1511,7 +1512,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	entries = frame->entries;
 	at = frame->at;
 
-	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
+	if (!(bh = ext3_bread(handle, dir, dx_get_block(frame->at), 0, &err)))
 		goto cleanup;
 
 	BUFFER_TRACE(bh, "get_write_access");
@@ -1544,7 +1545,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			err = -ENOSPC;
 			goto cleanup;
 		}
-		bh2 = ext3_append (handle, dir, &newblock, &err);
+		bh2 = ext3_append(handle, dir, &newblock, &err);
 		if (!(bh2))
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
@@ -1556,37 +1557,42 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		if (err)
 			goto journal_error;
 		if (levels) {
-			unsigned icount1 = icount/2, icount2 = icount - icount1;
+			unsigned icount1 = icount/2;
+			unsigned icount2 = icount - icount1;
 			unsigned hash2 = dx_get_hash(entries + icount1);
-			dxtrace(printk("Split index %i/%i\n", icount1, icount2));
+			dxtrace(printk("Split index %i/%i\n",
+				       icount1, icount2));
 
-			BUFFER_TRACE(frame->bh, "get_write_access"); /* index root */
+			/* index root */
+			BUFFER_TRACE(frame->bh, "get_write_access");
 			err = ext3_journal_get_write_access(handle,
 							     frames[0].bh);
 			if (err)
 				goto journal_error;
 
-			memcpy ((char *) entries2, (char *) (entries + icount1),
+			memcpy((char *) entries2, (char *) (entries + icount1),
 				icount2 * sizeof(struct dx_entry));
-			dx_set_count (entries, icount1);
-			dx_set_count (entries2, icount2);
-			dx_set_limit (entries2, dx_node_limit(dir));
+			dx_set_count(entries, icount1);
+			dx_set_count(entries2, icount2);
+			dx_set_limit(entries2, dx_node_limit(dir));
 
 			/* Which index block gets the new entry? */
 			if (at - entries >= icount1) {
-				frame->at = at = at - entries - icount1 + entries2;
+				frame->at = at = at - entries - icount1 +
+								entries2;
 				frame->entries = entries = entries2;
 				swap(frame->bh, bh2);
 			}
-			dx_insert_block (frames + 0, hash2, newblock);
-			dxtrace(dx_show_index ("node", frames[1].entries));
-			dxtrace(dx_show_index ("node",
+			dx_insert_block(frames + 0, hash2, newblock);
+			dxtrace(dx_show_index("node", frames[1].entries));
+			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
 			err = ext3_journal_dirty_metadata(handle, bh2);
 			if (err)
 				goto journal_error;
-			brelse (bh2);
+			brelse(bh2);
 		} else {
+			struct dx_root *root;
 			dxtrace(printk("Creating second level index...\n"));
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
@@ -1595,7 +1601,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels = 1;
+			root = (struct dx_root *) frames[0].bh->b_data;
+			root->info.indirect_levels = 1;
 
 			/* Add new access path frame */
 			frame = frames + 1;
@@ -1629,19 +1636,18 @@ cleanup:
  * ext3_delete_entry deletes a directory entry by merging it with the
  * previous entry
  */
-static int ext3_delete_entry (handle_t *handle,
-			      struct inode * dir,
-			      struct ext3_dir_entry_2 * de_del,
-			      struct buffer_head * bh)
+static int ext3_delete_entry(handle_t *handle, struct inode *dir,
+			      struct ext3_dir_entry_2 *de_del,
+			      struct buffer_head *bh)
 {
-	struct ext3_dir_entry_2 * de, * pde;
+	struct ext3_dir_entry_2 *de, *pde;
 	int i;
 
 	i = 0;
 	pde = NULL;
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	while (i < bh->b_size) {
-		if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
+		if (!ext3_check_dir_entry(__func__, dir, de, bh, i))
 			return -EIO;
 		if (de == de_del)  {
 			int err;
@@ -1698,11 +1704,11 @@ static int ext3_add_nondir(handle_t *handle,
  * If the create succeeds, we fill in the inode information
  * with d_instantiate().
  */
-static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
+static int ext3_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
 	handle_t *handle;
-	struct inode * inode;
+	struct inode *inode;
 	int err, retries = 0;
 
 	dquot_initialize(dir);
@@ -1717,7 +1723,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, mode);
+	inode = ext3_new_inode(handle, dir, mode);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext3_file_inode_operations;
@@ -1731,7 +1737,7 @@ retry:
 	return err;
 }
 
-static int ext3_mknod (struct inode * dir, struct dentry *dentry,
+static int ext3_mknod(struct inode *dir, struct dentry *dentry,
 			int mode, dev_t rdev)
 {
 	handle_t *handle;
@@ -1753,7 +1759,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, mode);
+	inode = ext3_new_inode(handle, dir, mode);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -1768,12 +1774,12 @@ retry:
 	return err;
 }
 
-static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int ext3_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	handle_t *handle;
-	struct inode * inode;
-	struct buffer_head * dir_block = NULL;
-	struct ext3_dir_entry_2 * de;
+	struct inode *inode;
+	struct buffer_head *dir_block = NULL;
+	struct ext3_dir_entry_2 *de;
 	int err, retries = 0;
 
 	if (dir->i_nlink >= EXT3_LINK_MAX)
@@ -1791,7 +1797,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, S_IFDIR | mode);
+	inode = ext3_new_inode(handle, dir, S_IFDIR | mode);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -1799,7 +1805,7 @@ retry:
 	inode->i_op = &ext3_dir_inode_operations;
 	inode->i_fop = &ext3_dir_operations;
 	inode->i_size = EXT3_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext3_bread (handle, inode, 0, 1, &err);
+	dir_block = ext3_bread(handle, inode, 0, 1, &err);
 	if (!dir_block)
 		goto out_clear_inode;
 
@@ -1812,14 +1818,14 @@ retry:
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
 	de->rec_len = ext3_rec_len_to_disk(EXT3_DIR_REC_LEN(de->name_len));
-	strcpy (de->name, ".");
+	strcpy(de->name, ".");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
 	de = ext3_next_entry(de);
 	de->inode = cpu_to_le32(dir->i_ino);
 	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize -
 					EXT3_DIR_REC_LEN(1));
 	de->name_len = 2;
-	strcpy (de->name, "..");
+	strcpy(de->name, "..");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext3_journal_dirty_metadata");
@@ -1829,14 +1835,14 @@ retry:
 
 	err = ext3_mark_inode_dirty(handle, inode);
 	if (!err)
-		err = ext3_add_entry (handle, dentry, inode);
+		err = ext3_add_entry(handle, dentry, inode);
 
 	if (err) {
 out_clear_inode:
 		inode->i_nlink = 0;
 		unlock_new_inode(inode);
 		ext3_mark_inode_dirty(handle, inode);
-		iput (inode);
+		iput(inode);
 		goto out_stop;
 	}
 	inc_nlink(dir);
@@ -1858,37 +1864,36 @@ out_stop:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
-static int empty_dir (struct inode * inode)
+static int empty_dir(struct inode *inode)
 {
 	unsigned long offset;
-	struct buffer_head * bh;
-	struct ext3_dir_entry_2 * de, * de1;
-	struct super_block * sb;
+	struct buffer_head *bh;
+	struct ext3_dir_entry_2 *de, *de1;
+	struct super_block *sb;
 	int err = 0;
 
 	sb = inode->i_sb;
 	if (inode->i_size < EXT3_DIR_REC_LEN(1) + EXT3_DIR_REC_LEN(2) ||
-	    !(bh = ext3_bread (NULL, inode, 0, 0, &err))) {
+	    !(bh = ext3_bread(NULL, inode, 0, 0, &err))) {
 		if (err)
 			ext3_error(inode->i_sb, __func__,
 				   "error %d reading directory #%lu offset 0",
 				   err, inode->i_ino);
 		else
 			ext3_warning(inode->i_sb, __func__,
-				     "bad directory (dir #%lu) - no data block",
-				     inode->i_ino);
+				     "bad directory (dir #%lu)"
+				     " - no data block", inode->i_ino);
 		return 1;
 	}
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	de1 = ext3_next_entry(de);
 	if (le32_to_cpu(de->inode) != inode->i_ino ||
 			!le32_to_cpu(de1->inode) ||
-			strcmp (".", de->name) ||
-			strcmp ("..", de1->name)) {
-		ext3_warning (inode->i_sb, "empty_dir",
-			      "bad directory (dir #%lu) - no `.' or `..'",
-			      inode->i_ino);
-		brelse (bh);
+			strcmp(".", de->name) ||
+			strcmp("..", de1->name)) {
+		ext3_warning(inode->i_sb, __func__, "bad directory (dir #%lu)"
+			     " - no `.' or `..'", inode->i_ino);
+		brelse(bh);
 		return 1;
 	}
 	offset = ext3_rec_len_from_disk(de->rec_len) +
@@ -1898,8 +1903,8 @@ static int empty_dir (struct inode * inode)
 		if (!bh ||
 			(void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
 			err = 0;
-			brelse (bh);
-			bh = ext3_bread (NULL, inode,
+			brelse(bh);
+			bh = ext3_bread(NULL, inode,
 				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err);
 			if (!bh) {
 				if (err)
@@ -1912,20 +1917,20 @@ static int empty_dir (struct inode * inode)
 			}
 			de = (struct ext3_dir_entry_2 *) bh->b_data;
 		}
-		if (!ext3_check_dir_entry("empty_dir", inode, de, bh, offset)) {
+		if (!ext3_check_dir_entry(__func__, inode, de, bh, offset)) {
 			de = (struct ext3_dir_entry_2 *)(bh->b_data +
 							 sb->s_blocksize);
 			offset = (offset | (sb->s_blocksize - 1)) + 1;
 			continue;
 		}
 		if (le32_to_cpu(de->inode)) {
-			brelse (bh);
+			brelse(bh);
 			return 0;
 		}
 		offset += ext3_rec_len_from_disk(de->rec_len);
 		de = ext3_next_entry(de);
 	}
-	brelse (bh);
+	brelse(bh);
 	return 1;
 }
 
@@ -2046,8 +2051,11 @@ int ext3_orphan_del(handle_t *handle, struct inode *inode)
 		err = ext3_journal_dirty_metadata(handle, sbi->s_sbh);
 	} else {
 		struct ext3_iloc iloc2;
-		struct inode *i_prev =
-			&list_entry(prev, struct ext3_inode_info, i_orphan)->vfs_inode;
+		struct ext3_inode_info *ei;
+		struct inode *i_prev;
+
+		ei = list_entry(prev, struct ext3_inode_info, i_orphan);
+		i_prev = &ei->vfs_inode;
 
 		jbd_debug(4, "orphan inode %lu will point to %lu\n",
 			  i_prev->i_ino, ino_next);
@@ -2073,12 +2081,12 @@ out_brelse:
 	goto out_err;
 }
 
-static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
+static int ext3_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
-	struct inode * inode;
-	struct buffer_head * bh;
-	struct ext3_dir_entry_2 * de;
+	struct inode *inode;
+	struct buffer_head *bh;
+	struct ext3_dir_entry_2 *de;
 	handle_t *handle;
 
 	/* Initialize quotas before so that eventual writes go in
@@ -2105,14 +2113,14 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 		goto end_rmdir;
 
 	retval = -ENOTEMPTY;
-	if (!empty_dir (inode))
+	if (!empty_dir(inode))
 		goto end_rmdir;
 
 	retval = ext3_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_rmdir;
 	if (inode->i_nlink != 2)
-		ext3_warning (inode->i_sb, "ext3_rmdir",
+		ext3_warning(inode->i_sb, "ext3_rmdir",
 			      "empty directory has nlink!=2 (%d)",
 			      inode->i_nlink);
 	inode->i_version++;
@@ -2130,16 +2138,16 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 
 end_rmdir:
 	ext3_journal_stop(handle);
-	brelse (bh);
+	brelse(bh);
 	return retval;
 }
 
-static int ext3_unlink(struct inode * dir, struct dentry *dentry)
+static int ext3_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
-	struct inode * inode;
-	struct buffer_head * bh;
-	struct ext3_dir_entry_2 * de;
+	struct inode *inode;
+	struct buffer_head *bh;
+	struct ext3_dir_entry_2 *de;
 	handle_t *handle;
 
 	/* Initialize quotas before so that eventual writes go
@@ -2166,7 +2174,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 		goto end_unlink;
 
 	if (!inode->i_nlink) {
-		ext3_warning (inode->i_sb, "ext3_unlink",
+		ext3_warning(inode->i_sb, "ext3_unlink",
 			      "Deleting nonexistent file (%lu), %d",
 			      inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
@@ -2186,15 +2194,15 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 
 end_unlink:
 	ext3_journal_stop(handle);
-	brelse (bh);
+	brelse(bh);
 	return retval;
 }
 
-static int ext3_symlink (struct inode * dir,
-		struct dentry *dentry, const char * symname)
+static int ext3_symlink(struct inode *dir,
+		struct dentry *dentry, const char *symname)
 {
 	handle_t *handle;
-	struct inode * inode;
+	struct inode *inode;
 	int l, err, retries = 0;
 
 	l = strlen(symname)+1;
@@ -2213,12 +2221,12 @@ retry:
 	if (IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
-	inode = ext3_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
+	inode = ext3_new_inode(handle, dir, S_IFLNK|S_IRWXUGO);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
 
-	if (l > sizeof (EXT3_I(inode)->i_data)) {
+	if (l > sizeof(EXT3_I(inode)->i_data)) {
 		inode->i_op = &ext3_symlink_inode_operations;
 		ext3_set_aops(inode);
 		/*
@@ -2231,7 +2239,7 @@ retry:
 			drop_nlink(inode);
 			unlock_new_inode(inode);
 			ext3_mark_inode_dirty(handle, inode);
-			iput (inode);
+			iput(inode);
 			goto out_stop;
 		}
 	} else {
@@ -2248,8 +2256,8 @@ out_stop:
 	return err;
 }
 
-static int ext3_link (struct dentry * old_dentry,
-		struct inode * dir, struct dentry *dentry)
+static int ext3_link(struct dentry *old_dentry,
+		struct inode *dir, struct dentry *dentry)
 {
 	handle_t *handle;
 	struct inode *inode = old_dentry->d_inode;
@@ -2301,13 +2309,13 @@ retry:
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
-			   struct inode * new_dir,struct dentry *new_dentry)
+static int ext3_rename(struct inode *old_dir, struct dentry *old_dentry,
+			   struct inode *new_dir, struct dentry *new_dentry)
 {
 	handle_t *handle;
-	struct inode * old_inode, * new_inode;
-	struct buffer_head * old_bh, * new_bh, * dir_bh;
-	struct ext3_dir_entry_2 * old_de, * new_de;
+	struct inode *old_inode, *new_inode;
+	struct buffer_head *old_bh, *new_bh, *dir_bh;
+	struct ext3_dir_entry_2 *old_de, *new_de;
 	int retval, flush_file = 0;
 
 	dquot_initialize(old_dir);
@@ -2344,18 +2352,18 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	new_bh = ext3_find_entry(new_dir, &new_dentry->d_name, &new_de);
 	if (new_bh) {
 		if (!new_inode) {
-			brelse (new_bh);
+			brelse(new_bh);
 			new_bh = NULL;
 		}
 	}
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
-			if (!empty_dir (new_inode))
+			if (!empty_dir(new_inode))
 				goto end_rename;
 		}
 		retval = -EIO;
-		dir_bh = ext3_bread (handle, old_inode, 0, 0, &retval);
+		dir_bh = ext3_bread(handle, old_inode, 0, 0, &retval);
 		if (!dir_bh)
 			goto end_rename;
 		if (le32_to_cpu(PARENT_INO(dir_bh->b_data)) != old_dir->i_ino)
@@ -2366,7 +2374,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 	if (!new_bh) {
-		retval = ext3_add_entry (handle, new_dentry, old_inode);
+		retval = ext3_add_entry(handle, new_dentry, old_inode);
 		if (retval)
 			goto end_rename;
 	} else {
@@ -2468,9 +2476,9 @@ journal_error2:
 	retval = 0;
 
 end_rename:
-	brelse (dir_bh);
-	brelse (old_bh);
-	brelse (new_bh);
+	brelse(dir_bh);
+	brelse(old_bh);
+	brelse(new_bh);
 	ext3_journal_stop(handle);
 	if (retval == 0 && flush_file)
 		filemap_flush(old_inode->i_mapping);
-- 
1.7.0.4
