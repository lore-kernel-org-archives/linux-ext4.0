From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl warnings and errors
Date: Sat, 25 Sep 2010 14:32:01 -0400
Message-ID: <1285439521-2557-10-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0IYSdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Sep 2010 14:33:05 -0400
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tracey Dent <Tdent48227@gmail.com>

Fixed numerous checkpat.pl errors and warnings

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/namei.c |   72 ++++++++++++++++++++----------------------------------
 1 files changed, 27 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 314c0d3..0efa236 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -46,7 +46,7 @@
 #define NAMEI_RA_CHUNKS  2
 #define NAMEI_RA_BLOCKS  4
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
-#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
+#define NAMEI_RA_INDEX(c, b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
@@ -79,22 +79,19 @@ static struct buffer_head *ext4_append(handle_t *handle,
 #define dxtrace(command)
 #endif
 
-struct fake_dirent
-{
+struct fake_dirent	{
 	__le32 inode;
 	__le16 rec_len;
 	u8 name_len;
 	u8 file_type;
 };
 
-struct dx_countlimit
-{
+struct dx_countlimit	{
 	__le16 limit;
 	__le16 count;
 };
 
-struct dx_entry
-{
+struct dx_entry	{
 	__le32 hash;
 	__le32 block;
 };
@@ -105,14 +102,12 @@ struct dx_entry
  * hash version mod 4 should never be 0.  Sincerely, the paranoia department.
  */
 
-struct dx_root
-{
+struct dx_root	{
 	struct fake_dirent dot;
 	char dot_name[4];
 	struct fake_dirent dotdot;
 	char dotdot_name[4];
-	struct dx_root_info
-	{
+	struct dx_root_info	{
 		__le32 reserved_zero;
 		u8 hash_version;
 		u8 info_length; /* 8 */
@@ -123,22 +118,19 @@ struct dx_root
 	struct dx_entry	entries[0];
 };
 
-struct dx_node
-{
+struct dx_node	{
 	struct fake_dirent fake;
 	struct dx_entry	entries[0];
 };
 
 
-struct dx_frame
-{
+struct dx_frame	{
 	struct buffer_head *bh;
 	struct dx_entry *entries;
 	struct dx_entry *at;
 };
 
-struct dx_map_entry
-{
+struct dx_map_entry	{
 	u32 hash;
 	u16 offs;
 	u16 size;
@@ -253,7 +245,7 @@ static inline unsigned dx_node_limit(struct inode *dir)
 #ifdef DX_DEBUG
 static void dx_show_index(char * label, struct dx_entry *entries)
 {
-	int i, n = dx_get_count (entries);
+	int i, n = dx_get_count(entries);
 	printk(KERN_DEBUG "%s index ", label);
 	for (i = 0; i < n; i++) {
 		printk("%x->%lu ", i ? dx_get_hash(entries + i) :
@@ -262,8 +254,7 @@ static void dx_show_index(char * label, struct dx_entry *entries)
 	printk("\n");
 }
 
-struct stats
-{
+struct stats	{
 	unsigned names;
 	unsigned space;
 	unsigned bcount;
@@ -277,12 +268,9 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 	struct dx_hash_info h = *hinfo;
 
 	printk("names: ");
-	while ((char *) de < base + size)
-	{
-		if (de->inode)
-		{
-			if (show_names)
-			{
+	while ((char *) de < base + size)	{
+		if (de->inode)	{
+			if (show_names)		{
 				int len = de->name_len;
 				char *name = de->name;
 				while (len--) printk("%c", *name++);
@@ -308,16 +296,15 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 	struct buffer_head *bh;
 	int err;
 	printk("%i indexed blocks...\n", count);
-	for (i = 0; i < count; i++, entries++)
-	{
+	for (i = 0; i < count; i++, entries++)	{
 		ext4_lblk_t block = dx_get_block(entries);
-		ext4_lblk_t hash  = i ? dx_get_hash(entries): 0;
-		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
+		ext4_lblk_t hash  = i ? dx_get_hash(entries) : 0;
+		u32 range = i < count - 1 ? (dx_get_hash(entries + 1) - hash) : ~hash;
 		struct stats stats;
-		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
-		if (!(bh = ext4_bread (NULL,dir, block, 0,&err))) continue;
-		stats = levels?
-		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
+		printk("%s%3u:%03u hash %8x/%8x ", levels ? "":"   ", i, block, hash, range);
+		if (!(bh = ext4_bread(NULL,dir, block, 0,&err))) continue;
+		stats = levels ?
+		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1) :
 		   dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) bh->b_data, blocksize, 0);
 		names += stats.names;
 		space += stats.space;
@@ -353,7 +340,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	u32 hash;
 
 	frame->bh = NULL;
-	if (!(bh = ext4_bread (NULL,dir, 0, 0, err)))
+	if (!(bh = ext4_bread(NULL, dir, 0, 0, err)))
 		goto fail;
 	root = (struct dx_root *) bh->b_data;
 	if (root->info.hash_version != DX_HASH_TEA &&
@@ -401,8 +388,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	}
 
 	dxtrace(printk("Look up %x", hash));
-	while (1)
-	{
+	while (1)	{
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
 			ext4_warning(dir->i_sb,
@@ -414,8 +400,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 
 		p = entries + 1;
 		q = entries + count - 1;
-		while (p <= q)
-		{
+		while (p <= q)	{
 			m = p + (q - p)/2;
 			dxtrace(printk("."));
 			if (dx_get_hash(m) > hash)
@@ -424,15 +409,12 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 				p = m + 1;
 		}
 
-		if (0) // linear search cross check
-		{
+		if (0) /* linear search cross check */	{
 			unsigned n = count - 1;
 			at = entries;
-			while (n--)
-			{
+			while (n--)		{
 				dxtrace(printk(","));
-				if (dx_get_hash(++at) > hash)
-				{
+				if (dx_get_hash(++at) > hash)	{
 					at--;
 					break;
 				}
-- 
1.7.3

