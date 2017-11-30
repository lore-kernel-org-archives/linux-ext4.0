From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 1/3] ext4: Removes static definition of dx_root struct
Date: Thu, 30 Nov 2017 18:17:51 +0300
Message-ID: <20171130151753.24986-2-artem.blagodarenko@gmail.com>
References: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca, Yang Sheng <yang.sheng@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40765 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbdK3PSA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 10:18:00 -0500
Received: by mail-lf0-f68.google.com with SMTP id t197so8286283lfe.7
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 07:17:59 -0800 (PST)
In-Reply-To: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yang Sheng <yang.sheng@intel.com>

Removes static definition of dx_root struct. so that "." and ".." dirent
can have extra data. This patch does not change any functionality but is
required for ext4_data_in_dirent patch.

Signed-off-by: Yang Sheng <yang.sheng@intel.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 130 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 71 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c1cf020d1889..7c649cf2b630 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -193,23 +193,13 @@ struct dx_entry
  * dirent the two low bits of the hash version will be zero.  Therefore, the
  * hash version mod 4 should never be 0.  Sincerely, the paranoia department.
  */
-
-struct dx_root
+struct dx_root_info
 {
-	struct fake_dirent dot;
-	char dot_name[4];
-	struct fake_dirent dotdot;
-	char dotdot_name[4];
-	struct dx_root_info
-	{
-		__le32 reserved_zero;
-		u8 hash_version;
-		u8 info_length; /* 8 */
-		u8 indirect_levels;
-		u8 unused_flags;
-	}
-	info;
-	struct dx_entry	entries[0];
+	__le32 reserved_zero;
+	u8 hash_version;
+	u8 info_length; /* 8 */
+	u8 indirect_levels;
+	u8 unused_flags;
 };
 
 struct dx_node
@@ -521,6 +511,17 @@ static inline void dx_set_block(struct dx_entry *entry, ext4_lblk_t value)
 	entry->block = cpu_to_le32(value);
 }
 
+struct dx_root_info *dx_get_dx_info(struct ext4_dir_entry_2 *de)
+{
+	/* get dotdot first */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_NAME_LEN(1));
+
+	/* dx root info is after dotdot entry */
+	de = (struct ext4_dir_entry_2 *)((char *)de + EXT4_DIR_NAME_LEN(2));
+
+	return (struct dx_root_info *)de;
+}
+
 static inline unsigned dx_get_hash(struct dx_entry *entry)
 {
 	return le32_to_cpu(entry->hash);
@@ -734,7 +735,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 {
 	unsigned count, indirect;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *info;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
@@ -744,17 +745,17 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	if (IS_ERR(frame->bh))
 		return (struct dx_frame *) frame->bh;
 
-	root = (struct dx_root *) frame->bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY) {
-		ext4_warning_inode(dir, "Unrecognised inode hash code %u",
-				   root->info.hash_version);
+	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frame->bh->b_data);
+	if (info->hash_version != DX_HASH_TEA &&
+	    info->hash_version != DX_HASH_HALF_MD4 &&
+	    info->hash_version != DX_HASH_LEGACY) {
+		ext4_warning(dir->i_sb, "inode #%lu: unrecognised hash code %u",
+			     dir->i_ino, info->hash_version);
 		goto fail;
 	}
 	if (fname)
 		hinfo = &fname->hinfo;
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -762,18 +763,18 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		ext4fs_dirhash(fname_name(fname), fname_len(fname), hinfo);
 	hash = hinfo->hash;
 
-	if (root->info.unused_flags & 1) {
-		ext4_warning_inode(dir, "Unimplemented hash flags: %#06x",
-				   root->info.unused_flags);
+	if (info->unused_flags & 1) {
+		ext4_warning_inode(dir,
+				"inode #%lu: Unimplemented hash flags: %#06x",
+				dir->i_ino, info->unused_flags);
 		goto fail;
 	}
 
-	indirect = root->info.indirect_levels;
+	indirect = info->indirect_levels;
 	if (indirect >= ext4_dir_htree_level(dir->i_sb)) {
 		ext4_warning(dir->i_sb,
-			     "Directory (ino: %lu) htree depth %#06x exceed"
-			     "supported value", dir->i_ino,
-			     ext4_dir_htree_level(dir->i_sb));
+			     "inode #%lu unimplemented hash depth %#06x",
+			     dir->i_ino, ext4_dir_htree_level(dir->i_sb));
 		if (ext4_dir_htree_level(dir->i_sb) < EXT4_HTREE_LEVEL) {
 			ext4_warning(dir->i_sb, "Enable large directory "
 						"feature to access it");
@@ -781,14 +782,17 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		goto fail;
 	}
 
-	entries = (struct dx_entry *)(((char *)&root->info) +
-				      root->info.info_length);
+	entries = (struct dx_entry *)(((char *)info) + info->info_length);
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
-		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
-				   dx_get_limit(entries),
-				   dx_root_limit(dir, root->info.info_length));
+				(struct ext4_dir_entry_2 *) frame->bh->b_data,
+				info->info_length)) {
+		ext4_warning(dir->i_sb, "dx entry: limit != root limit "
+			     "inode #%lu: dx entry: limit %u != root limit %u",
+			     dir->i_ino, dx_get_limit(entries),
+			     dx_root_limit(dir, (struct ext4_dir_entry_2 *)
+					   frame->bh->b_data,
+					   info->info_length));
 		goto fail;
 	}
 
@@ -872,7 +876,7 @@ static void dx_release(struct dx_frame *frames)
 	if (frames[0].bh == NULL)
 		return;
 
-	info = &((struct dx_root *)frames[0].bh->b_data)->info;
+	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frames[0].bh->b_data);
 	for (i = 0; i <= info->indirect_levels; i++) {
 		if (frames[i].bh == NULL)
 			break;
@@ -1907,17 +1911,16 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 			    struct inode *inode, struct buffer_head *bh)
 {
 	struct buffer_head *bh2;
-	struct dx_root	*root;
 	struct dx_frame	frames[EXT4_HTREE_LEVEL], *frame;
 	struct dx_entry *entries;
-	struct ext4_dir_entry_2	*de, *de2;
+	struct ext4_dir_entry_2 *de, *de2, *dot_de, *dotdot_de;
 	struct ext4_dir_entry_tail *t;
 	char		*data1, *top;
 	unsigned	len;
 	int		retval;
 	unsigned	blocksize;
 	ext4_lblk_t  block;
-	struct fake_dirent *fde;
+	struct dx_root_info *dx_info;
 	int csum_size = 0;
 
 	if (ext4_has_metadata_csum(inode->i_sb))
@@ -1932,18 +1935,19 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		brelse(bh);
 		return retval;
 	}
-	root = (struct dx_root *) bh->b_data;
+
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
+	dotdot_de = ext4_next_entry(dot_de, blocksize);
 
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	if ((char *) de >= (((char *) root) + blocksize)) {
+	de = (struct ext4_dir_entry_2 *)((char *)dotdot_de +
+		ext4_rec_len_from_disk(dotdot_de->rec_len, blocksize));
+	if ((char *)de >= (((char *)dot_de) + blocksize)) {
 		EXT4_ERROR_INODE(dir, "invalid rec_len for '..'");
 		brelse(bh);
 		return -EFSCORRUPTED;
 	}
-	len = ((char *) root) + (blocksize - csum_size) - (char *) de;
+	len = ((char *)dot_de) + (blocksize - csum_size) - (char *)de;
 
 	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append(handle, dir, &block);
@@ -1969,19 +1973,26 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* Initialize the root; the dot dirents already exist */
-	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2),
-					   blocksize);
-	memset (&root->info, 0, sizeof(root->info));
-	root->info.info_length = sizeof(root->info);
-	root->info.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
-	entries = root->entries;
+	dotdot_de->rec_len =
+		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
+				     blocksize);
+
+	/* initialize hashing info */
+	dx_info = dx_get_dx_info(dot_de);
+	memset(dx_info, 0, sizeof(*dx_info));
+	dx_info->info_length = sizeof(*dx_info);
+	dx_info->hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
+
+	entries = (void *)dx_info + sizeof(*dx_info);
+
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
+	dx_set_limit(entries, dx_root_limit(dir, (struct ext4_dir_entry_2 *)
+					    frame->bh->b_data,
+					    sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
-	fname->hinfo.hash_version = root->info.hash_version;
+	fname->hinfo.hash_version = dx_info->hash_version;
 	if (fname->hinfo.hash_version <= DX_HASH_TEA)
 		fname->hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	fname->hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -2252,7 +2263,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 				goto journal_error;
 			}
 		} else {
-			struct dx_root *dxroot;
+			struct dx_root_info *info;
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
@@ -2260,8 +2271,9 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			dxroot = (struct dx_root *)frames[0].bh->b_data;
-			dxroot->info.indirect_levels += 1;
+			info = dx_get_dx_info((struct ext4_dir_entry_2 *)
+					      frames[0].bh->b_data);
+			info->indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
 				       info->indirect_levels));
-- 
2.13.6 (Apple Git-96)
