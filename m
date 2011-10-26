From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/4] ext4: move variable to its scope
Date: Wed, 26 Oct 2011 15:11:50 +0800
Message-ID: <1319613112-16807-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60544 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1JZJHx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 05:07:53 -0400
Received: by ywm3 with SMTP id 3so1350467ywm.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 02:07:52 -0700 (PDT)
In-Reply-To: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f887023..8b09a47 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -117,10 +117,9 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 			      struct ext4_ext_path *path,
 			      ext4_lblk_t block)
 {
-	int depth;
-
 	if (path) {
 		struct ext4_extent *ex;
+		int depth;
 		depth = path->p_depth;
 
 		/*
@@ -247,7 +246,7 @@ static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
 int ext4_ext_calc_metadata_amount(struct inode *inode, ext4_lblk_t lblock)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	int idxs, num = 0;
+	int idxs;
 
 	idxs = ((inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 		/ sizeof(struct ext4_extent_idx));
@@ -262,6 +261,7 @@ int ext4_ext_calc_metadata_amount(struct inode *inode, ext4_lblk_t lblock)
 	 */
 	if (ei->i_da_metadata_calc_len &&
 	    ei->i_da_metadata_calc_last_lblock+1 == lblock) {
+		int num = 0;
 		if ((ei->i_da_metadata_calc_len % idxs) == 0)
 			num++;
 		if ((ei->i_da_metadata_calc_len % (idxs*idxs)) == 0)
@@ -324,8 +324,6 @@ static int ext4_valid_extent_entries(struct inode *inode,
 				struct ext4_extent_header *eh,
 				int depth)
 {
-	struct ext4_extent *ext;
-	struct ext4_extent_idx *ext_idx;
 	unsigned short entries;
 	if (eh->eh_entries == 0)
 		return 1;
@@ -334,6 +332,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 	if (depth == 0) {
 		/* leaf entries */
+		struct ext4_extent *ext;
 		ext = EXT_FIRST_EXTENT(eh);
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
@@ -342,6 +341,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 			entries--;
 		}
 	} else {
+		struct ext4_extent_idx *ext_idx;
 		ext_idx = EXT_FIRST_INDEX(eh);
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
@@ -3720,13 +3720,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t newblock = 0;
 	int free_on_err = 0, err = 0, depth, ret;
 	unsigned int allocated = 0, offset = 0;
-	unsigned int allocated_clusters = 0, reserved_clusters = 0;
+	unsigned int allocated_clusters = 0;
 	unsigned int punched_out = 0;
 	unsigned int result = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 	ext4_lblk_t cluster_offset;
-	struct ext4_map_blocks punch_map;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
 		  map->m_lblk, map->m_len, inode->i_ino);
@@ -3802,6 +3801,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 		/* if found extent covers block, simply return it */
 		if (in_range(map->m_lblk, ee_block, ee_len)) {
+			struct ext4_map_blocks punch_map;
 			ext4_fsblk_t partial_cluster = 0;
 
 			newblock = map->m_lblk - ee_block + ee_start;
@@ -4077,6 +4077,7 @@ got_allocated_blocks:
 	 * block allocation which had been deferred till now.
 	 */
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
+		unsigned int reserved_clusters = 0;
 		/*
 		 * Check how many clusters we had reserved this allocted range.
 		 */
-- 
1.7.5.1

