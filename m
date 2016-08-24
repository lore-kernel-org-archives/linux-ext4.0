From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/6 linux-next] ext4: use bool for check in ext4_ext_space_()
Date: Wed, 24 Aug 2016 22:03:18 +0200
Message-ID: <1472069000-18897-5-git-send-email-fabf@skynet.be>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472069000-18897-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

check is used in 0/1 context.

Also use unsigned int instead of unsigned (checkpatch warning)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/extents.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ac54907..5b0913d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -241,7 +241,7 @@ ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 	return newblock;
 }
 
-static inline int ext4_ext_space_block(struct inode *inode, int check)
+static inline int ext4_ext_space_block(struct inode *inode, bool check)
 {
 	int size;
 
@@ -254,7 +254,7 @@ static inline int ext4_ext_space_block(struct inode *inode, int check)
 	return size;
 }
 
-static inline int ext4_ext_space_block_idx(struct inode *inode, int check)
+static inline int ext4_ext_space_block_idx(struct inode *inode, bool check)
 {
 	int size;
 
@@ -267,7 +267,7 @@ static inline int ext4_ext_space_block_idx(struct inode *inode, int check)
 	return size;
 }
 
-static inline int ext4_ext_space_root(struct inode *inode, int check)
+static inline int ext4_ext_space_root(struct inode *inode, bool check)
 {
 	int size;
 
@@ -363,14 +363,14 @@ ext4_ext_max_entries(struct inode *inode, int depth)
 
 	if (depth == ext_depth(inode)) {
 		if (depth == 0)
-			max = ext4_ext_space_root(inode, 1);
+			max = ext4_ext_space_root(inode, true);
 		else
-			max = ext4_ext_space_root_idx(inode, 1);
+			max = ext4_ext_space_root_idx(inode, true);
 	} else {
 		if (depth == 0)
-			max = ext4_ext_space_block(inode, 1);
+			max = ext4_ext_space_block(inode, true);
 		else
-			max = ext4_ext_space_block_idx(inode, 1);
+			max = ext4_ext_space_block_idx(inode, true);
 	}
 
 	return max;
@@ -864,7 +864,7 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_depth = 0;
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
-	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
+	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, false));
 	ext4_mark_inode_dirty(handle, inode);
 	return 0;
 }
@@ -1109,7 +1109,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 
 	neh = ext_block_hdr(bh);
 	neh->eh_entries = 0;
-	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
+	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, false));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	neh->eh_depth = 0;
 
@@ -1183,7 +1183,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		neh = ext_block_hdr(bh);
 		neh->eh_entries = cpu_to_le16(1);
 		neh->eh_magic = EXT4_EXT_MAGIC;
-		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode,
+								   false));
 		neh->eh_depth = cpu_to_le16(depth - i);
 		fidx = EXT_FIRST_INDEX(neh);
 		fidx->ei_block = border;
@@ -1310,9 +1311,10 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	/* old root could have indexes or leaves
 	 * so calculate e_max right way */
 	if (ext_depth(inode))
-		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode,
+								   false));
 	else
-		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, false));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
@@ -1328,7 +1330,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	ext4_idx_store_pblock(EXT_FIRST_INDEX(neh), newblock);
 	if (neh->eh_depth == 0) {
 		/* Root extent block becomes index block */
-		neh->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode, 0));
+		neh->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode,
+								  false));
 		EXT_FIRST_INDEX(neh)->ei_block =
 			EXT_FIRST_EXTENT(neh)->ee_block;
 	}
@@ -1816,7 +1819,7 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
 				     struct ext4_ext_path *path)
 {
 	size_t s;
-	unsigned max_root = ext4_ext_space_root(inode, 0);
+	unsigned int max_root = ext4_ext_space_root(inode, false);
 	ext4_fsblk_t blk;
 
 	if ((path[0].p_depth != 1) ||
@@ -3053,7 +3056,7 @@ again:
 		if (err == 0) {
 			ext_inode_hdr(inode)->eh_depth = 0;
 			ext_inode_hdr(inode)->eh_max =
-				cpu_to_le16(ext4_ext_space_root(inode, 0));
+				cpu_to_le16(ext4_ext_space_root(inode, false));
 			err = ext4_ext_dirty(handle, inode, path);
 		}
 	}
-- 
2.8.1
