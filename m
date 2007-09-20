From: akpm@linux-foundation.org
Subject: - ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:48 -0700
Message-ID: <200709202115.l8KLFmVm002940@imap1.linux-foundation.org>
To: sandeen@redhat.com, adilger@clusterfs.com, hooanon05@yahoo.co.jp,
	linux-ext4@vger.kernel.org, stable@kernel.org, tytso@mit.edu,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXITV3g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext34: ensure do_split leaves enough free space in both blocks
has been removed from the -mm tree.  Its filename was
     ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext34: ensure do_split leaves enough free space in both blocks
From: Eric Sandeen <sandeen@redhat.com>

The do_split() function for htree dir blocks is intended to split a leaf
block to make room for a new entry.  It sorts the entries in the original
block by hash value, then moves the last half of the entries to the new
block - without accounting for how much space this actually moves.  (IOW,
it moves half of the entry *count* not half of the entry *space*).  If by
chance we have both large & small entries, and we move only the smallest
entries, and we have a large new entry to insert, we may not have created
enough space for it.

The patch below stores each record size when calculating the dx_map, and
then walks the hash-sorted dx_map, calculating how many entries must be
moved to more evenly split the existing entries between the old block and
the new block, guaranteeing enough space for the new entry.

The dx_map "offs" member is reduced to u16 so that the overall map size
does not change - it is temporarily stored at the end of the new block, and
if it grows too large it may be overwritten.  By making offs and size both
u16, we won't grow the map size.

Also add a few comments to the functions involved.

This fixes the testcase reported by hooanon05@yahoo.co.jp on the
linux-ext4 list, "ext3 dir_index causes an error"

Thanks to Andreas Dilger for discussing the problem & solution with me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Tested-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   39 +++++++++++++++++++++++++++++++++++----
 fs/ext4/namei.c |   39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 70 insertions(+), 8 deletions(-)

diff -puN fs/ext3/namei.c~ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks
+++ a/fs/ext3/namei.c
@@ -140,7 +140,8 @@ struct dx_frame
 struct dx_map_entry
 {
 	u32 hash;
-	u32 offs;
+	u16 offs;
+	u16 size;
 };
 
 #ifdef CONFIG_EXT3_INDEX
@@ -697,6 +698,10 @@ errout:
  * Directory block splitting, compacting
  */
 
+/*
+ * Create map of hash values, offsets, and sizes, stored at end of block.
+ * Returns number of entries mapped.
+ */
 static int dx_make_map (struct ext3_dir_entry_2 *de, int size,
 			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
@@ -710,7 +715,8 @@ static int dx_make_map (struct ext3_dir_
 			ext3fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
-			map_tail->offs = (u32) ((char *) de - base);
+			map_tail->offs = (u16) ((char *) de - base);
+			map_tail->size = le16_to_cpu(de->rec_len);
 			count++;
 			cond_resched();
 		}
@@ -720,6 +726,7 @@ static int dx_make_map (struct ext3_dir_
 	return count;
 }
 
+/* Sort map by hash value */
 static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 {
         struct dx_map_entry *p, *q, *top = map + count - 1;
@@ -1117,6 +1124,10 @@ static inline void ext3_set_de_type(stru
 }
 
 #ifdef CONFIG_EXT3_INDEX
+/*
+ * Move count entries from end of map between two memory locations.
+ * Returns pointer to last entry moved.
+ */
 static struct ext3_dir_entry_2 *
 dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count)
 {
@@ -1135,6 +1146,10 @@ dx_move_dirents(char *from, char *to, st
 	return (struct ext3_dir_entry_2 *) (to - rec_len);
 }
 
+/*
+ * Compact each dir entry in the range to the minimal rec_len.
+ * Returns pointer to last entry in range.
+ */
 static struct ext3_dir_entry_2* dx_pack_dirents(char *base, int size)
 {
 	struct ext3_dir_entry_2 *next, *to, *prev, *de = (struct ext3_dir_entry_2 *) base;
@@ -1157,6 +1172,11 @@ static struct ext3_dir_entry_2* dx_pack_
 	return prev;
 }
 
+/*
+ * Split a full leaf block to make room for a new dir entry.
+ * Allocate a new block, and move entries so that they are approx. equally full.
+ * Returns pointer to de in block into which the new entry will be inserted.
+ */
 static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
 			struct dx_hash_info *hinfo, int *error)
@@ -1168,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split;
+	unsigned split, move, size, i;
 	struct ext3_dir_entry_2 *de = NULL, *de2;
 	int	err = 0;
 
@@ -1196,8 +1216,19 @@ static struct ext3_dir_entry_2 *do_split
 	count = dx_make_map ((struct ext3_dir_entry_2 *) data1,
 			     blocksize, hinfo, map);
 	map -= count;
-	split = count/2; // need to adjust to actual middle
 	dx_sort_map (map, count);
+	/* Split the existing block in the middle, size-wise */
+	size = 0;
+	move = 0;
+	for (i = count-1; i >= 0; i--) {
+		/* is more than half of this entry in 2nd half of the block? */
+		if (size + map[i].size/2 > blocksize/2)
+			break;
+		size += map[i].size;
+		move++;
+	}
+	/* map index at which we will split */
+	split = count - move;
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
 	dxtrace(printk("Split block %i at %x, %i/%i\n",
diff -puN fs/ext4/namei.c~ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks
+++ a/fs/ext4/namei.c
@@ -140,7 +140,8 @@ struct dx_frame
 struct dx_map_entry
 {
 	u32 hash;
-	u32 offs;
+	u16 offs;
+	u16 size;
 };
 
 #ifdef CONFIG_EXT4_INDEX
@@ -697,6 +698,10 @@ errout:
  * Directory block splitting, compacting
  */
 
+/*
+ * Create map of hash values, offsets, and sizes, stored at end of block.
+ * Returns number of entries mapped.
+ */
 static int dx_make_map (struct ext4_dir_entry_2 *de, int size,
 			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
@@ -710,7 +715,8 @@ static int dx_make_map (struct ext4_dir_
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
-			map_tail->offs = (u32) ((char *) de - base);
+			map_tail->offs = (u16) ((char *) de - base);
+			map_tail->size = le16_to_cpu(de->rec_len);
 			count++;
 			cond_resched();
 		}
@@ -720,6 +726,7 @@ static int dx_make_map (struct ext4_dir_
 	return count;
 }
 
+/* Sort map by hash value */
 static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 {
 	struct dx_map_entry *p, *q, *top = map + count - 1;
@@ -1115,6 +1122,10 @@ static inline void ext4_set_de_type(stru
 }
 
 #ifdef CONFIG_EXT4_INDEX
+/*
+ * Move count entries from end of map between two memory locations.
+ * Returns pointer to last entry moved.
+ */
 static struct ext4_dir_entry_2 *
 dx_move_dirents(char *from, char *to, struct dx_map_entry *map, int count)
 {
@@ -1133,6 +1144,10 @@ dx_move_dirents(char *from, char *to, st
 	return (struct ext4_dir_entry_2 *) (to - rec_len);
 }
 
+/*
+ * Compact each dir entry in the range to the minimal rec_len.
+ * Returns pointer to last entry in range.
+ */
 static struct ext4_dir_entry_2* dx_pack_dirents(char *base, int size)
 {
 	struct ext4_dir_entry_2 *next, *to, *prev, *de = (struct ext4_dir_entry_2 *) base;
@@ -1155,6 +1170,11 @@ static struct ext4_dir_entry_2* dx_pack_
 	return prev;
 }
 
+/*
+ * Split a full leaf block to make room for a new dir entry.
+ * Allocate a new block, and move entries so that they are approx. equally full.
+ * Returns pointer to de in block into which the new entry will be inserted.
+ */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
 			struct dx_hash_info *hinfo, int *error)
@@ -1166,7 +1186,7 @@ static struct ext4_dir_entry_2 *do_split
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split;
+	unsigned split, move, size, i;
 	struct ext4_dir_entry_2 *de = NULL, *de2;
 	int	err = 0;
 
@@ -1194,8 +1214,19 @@ static struct ext4_dir_entry_2 *do_split
 	count = dx_make_map ((struct ext4_dir_entry_2 *) data1,
 			     blocksize, hinfo, map);
 	map -= count;
-	split = count/2; // need to adjust to actual middle
 	dx_sort_map (map, count);
+	/* Split the existing block in the middle, size-wise */
+	size = 0;
+	move = 0;
+	for (i = count-1; i >= 0; i--) {
+		/* is more than half of this entry in 2nd half of the block? */
+		if (size + map[i].size/2 > blocksize/2)
+			break;
+		size += map[i].size;
+		move++;
+	}
+	/* map index at which we will split */
+	split = count - move;
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
 	dxtrace(printk("Split block %i at %x, %i/%i\n",
_

Patches currently in -mm which might be from sandeen@redhat.com are

remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
limit-minixfs-printks-on-corrupted-dir-i_size.patch
