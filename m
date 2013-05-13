From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 2/9] ext4: Allow sorting dx_map by inode as well
Date: Mon, 13 May 2013 17:42:03 +0200
Message-ID: <1368459730-3405-3-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab3EMQmp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:45 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit extends the code used by the dir index to sort its leaf
blocks by hash before splits. The implementation of itree needs to do
a similar sort when the tree is initialized. However, the order is
different.

The dx_sort_map() function now takes a pointer to a compare function
which determines the resulting ordering of the entries. At the moment,
there are two options avaiable -- hash_order() and inode_order().

Also a bit from the do_split() function was moved to a spearate helper
function called dx_map_split_point(). This will be used by the itree
code as well.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 77 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6653fc3..6f73f81 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -226,6 +226,7 @@ struct dx_frame
 
 struct dx_map_entry
 {
+	u32 inode;
 	u32 hash;
 	u16 offs;
 	u16 size;
@@ -257,7 +258,12 @@ static struct dx_frame *dx_probe(const struct qstr *d_name,
 static void dx_release(struct dx_frame *frames);
 static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 		       struct dx_hash_info *hinfo, struct dx_map_entry map[]);
-static void dx_sort_map(struct dx_map_entry *map, unsigned count);
+static void dx_sort_map(int (*cmp)(struct dx_map_entry*, struct dx_map_entry*),
+			struct dx_map_entry *map, unsigned count);
+static inline int hash_order(struct dx_map_entry *e1, struct dx_map_entry *e2);
+static inline int inode_order(struct dx_map_entry *e1, struct dx_map_entry *e2);
+static unsigned dx_map_split_point(struct dx_map_entry *map,
+				   unsigned count, unsigned long blocksize);
 static struct ext4_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count, unsigned blocksize);
 static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize);
@@ -1072,8 +1078,9 @@ static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 
 	while ((char *) de < base + blocksize) {
 		if (de->name_len && de->inode) {
-			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
+			map_tail->inode = le32_to_cpu(de->inode);
+			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail->hash = h.hash;
 			map_tail->offs = ((char *) de - base)>>2;
 			map_tail->size = le16_to_cpu(de->rec_len);
@@ -1086,8 +1093,21 @@ static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 	return count;
 }
 
-/* Sort map by hash value */
-static void dx_sort_map (struct dx_map_entry *map, unsigned count)
+static inline int hash_order(struct dx_map_entry *e1, struct dx_map_entry *e2)
+{
+	return e1->hash < e2->hash;
+}
+
+static inline int inode_order(struct dx_map_entry *e1, struct dx_map_entry *e2)
+{
+	if (e1->inode == e2->inode)
+		return e1->hash < e2->hash;
+	return e1->inode < e2->inode;
+}
+
+/* Sort map. The order is determined by the comparison function (first arg) */
+static void dx_sort_map(int (*cmp)(struct dx_map_entry*, struct dx_map_entry*),
+			struct dx_map_entry *map, unsigned count)
 {
 	struct dx_map_entry *p, *q, *top = map + count - 1;
 	int more;
@@ -1097,7 +1117,7 @@ static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 		if (count - 9 < 2) /* 9, 10 -> 11 */
 			count = 11;
 		for (p = top, q = p - count; q >= map; p--, q--)
-			if (p->hash < q->hash)
+			if (cmp(p, q))
 				swap(*p, *q);
 	}
 	/* Garden variety bubble sort */
@@ -1105,14 +1125,34 @@ static void dx_sort_map (struct dx_map_entry *map, unsigned count)
 		more = 0;
 		q = top;
 		while (q-- > map) {
-			if (q[1].hash >= q[0].hash)
-				continue;
-			swap(*(q+1), *q);
-			more = 1;
+			if (cmp(q + 1, q)) {
+				swap(*(q + 1), *q);
+				more = 1;
+			}
 		}
 	} while(more);
 }
 
+/* Split the existing block in the middle, size-wise */
+static unsigned dx_map_split_point(struct dx_map_entry *map,
+				   unsigned count, unsigned long blocksize)
+{
+	unsigned size, move;
+	int i;
+
+	size = 0;
+	move = 0;
+	for (i = count - 1; i >= 0; i--) {
+		/* is more than half of this entry in 2nd half of the block? */
+		if (size + map[i].size/2 > blocksize/2)
+			break;
+		size += map[i].size;
+		move++;
+	}
+
+	return count - move;
+}
+
 static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 {
 	struct dx_entry *entries = frame->entries;
@@ -1532,11 +1572,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split, move, size;
+	unsigned split;
 	struct ext4_dir_entry_2 *de = NULL, *de2;
 	struct ext4_dir_entry_tail *t;
 	int	csum_size = 0;
-	int	err = 0, i;
+	int	err = 0;
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
@@ -1567,19 +1607,10 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	count = dx_make_map((struct ext4_dir_entry_2 *) data1,
 			     blocksize, hinfo, map);
 	map -= count;
-	dx_sort_map(map, count);
-	/* Split the existing block in the middle, size-wise */
-	size = 0;
-	move = 0;
-	for (i = count-1; i >= 0; i--) {
-		/* is more than half of this entry in 2nd half of the block? */
-		if (size + map[i].size/2 > blocksize/2)
-			break;
-		size += map[i].size;
-		move++;
-	}
+	dx_sort_map(hash_order, map, count);
+
 	/* map index at which we will split */
-	split = count - move;
+	split = dx_map_split_point(map, count, blocksize);
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
-- 
1.7.11.7

