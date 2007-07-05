From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] Add some new  function for searching extent tree.
Date: Thu,  5 Jul 2007 23:33:22 +0530
Message-ID: <11836587021546-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1183658603788-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11836586131887-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1183658628862-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, Alex Tomas <alex@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:60815 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694AbXGESFg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:05:36 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l65I6Orq3154138
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:06:26 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65I8xHm137114
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:08:59 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65I5QbV015288
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:05:26 +1000
In-Reply-To: <1183658628862-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <8a5f723608dee42cd37ef2ad2e67dea4d8dfb75f.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <c69d5860cee44bebe28450367491b96c57225402.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
References: <c69d5860cee44bebe28450367491b96c57225402.1183658085.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Alex Tomas <alex@clusterfs.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |  142 +++++++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs_extents.h |    2 +
 2 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 16df6e0..4e31439 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1011,6 +1011,148 @@ out:
 }
 
 /*
+ * search the closest allocated block to the left for *logical
+ * and returns it at @logical + it's physical address at @phys
+ * if *logical is the smallest allocated block, the function
+ * returns 0 at @phys
+ * return value contains 0 (success) or error code
+ */
+int
+ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
+			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
+{
+	struct ext4_extent_idx *ix;
+	struct ext4_extent *ex;
+	int depth;
+
+	BUG_ON(path == NULL);
+	depth = path->p_depth;
+	*phys = 0;
+
+	if (depth == 0 && path->p_ext == NULL)
+		return 0;
+
+	/* usually extent in the path covers blocks smaller
+	 * then *logical, but it can be that extent is the
+	 * first one in the file */
+
+	ex = path[depth].p_ext;
+	if (*logical < le32_to_cpu(ex->ee_block)) {
+		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
+		while (--depth >= 0) {
+			ix = path[depth].p_idx;
+			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
+		}
+		return 0;
+	}
+
+	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+
+	*logical = le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len) - 1;
+	*phys = ext_pblock(ex) + le16_to_cpu(ex->ee_len) - 1;
+	return 0;
+}
+
+/*
+ * search the closest allocated block to the right for *logical
+ * and returns it at @logical + it's physical address at @phys
+ * if *logical is the smallest allocated block, the function
+ * returns 0 at @phys
+ * return value contains 0 (success) or error code
+ */
+int
+ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
+			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
+{
+	struct buffer_head *bh = NULL;
+	struct ext4_extent_header *eh;
+	struct ext4_extent_idx *ix;
+	struct ext4_extent *ex;
+	ext4_fsblk_t block;
+	int depth;
+
+	BUG_ON(path == NULL);
+	depth = path->p_depth;
+	*phys = 0;
+
+	if (depth == 0 && path->p_ext == NULL)
+		return 0;
+
+	/* usually extent in the path covers blocks smaller
+	 * then *logical, but it can be that extent is the
+	 * first one in the file */
+
+	ex = path[depth].p_ext;
+	if (*logical < le32_to_cpu(ex->ee_block)) {
+		BUG_ON(EXT_FIRST_EXTENT(path[depth].p_hdr) != ex);
+		while (--depth >= 0) {
+			ix = path[depth].p_idx;
+			BUG_ON(ix != EXT_FIRST_INDEX(path[depth].p_hdr));
+		}
+		*logical = le32_to_cpu(ex->ee_block);
+		*phys = ext_pblock(ex);
+		return 0;
+	}
+
+	BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
+
+	if (ex != EXT_LAST_EXTENT(path[depth].p_hdr)) {
+		/* next allocated block in this leaf */
+		ex++;
+		*logical = le32_to_cpu(ex->ee_block);
+		*phys = ext_pblock(ex);
+		return 0;
+	}
+
+	/* go up and search for index to the right */
+	while (--depth >= 0) {
+		ix = path[depth].p_idx;
+		if (ix != EXT_LAST_INDEX(path[depth].p_hdr))
+			break;
+	}
+
+	if (depth < 0) {
+		/* we've gone up to the root and
+		 * found no index to the right */
+		return 0;
+	}
+
+	/* we've found index to the right, let's
+	 * follow it and find the closest allocated
+	 * block to the right */
+	ix++;
+	block = idx_pblock(ix);
+	while (++depth < path->p_depth) {
+		bh = sb_bread(inode->i_sb, block);
+		if (bh == NULL)
+			return -EIO;
+		eh = ext_block_hdr(bh);
+		if (ext4_ext_check_header(inode, eh, depth)) {
+			brelse(bh);
+			return -EIO;
+		}
+		ix = EXT_FIRST_INDEX(eh);
+		block = idx_pblock(ix);
+		brelse(bh);
+	}
+
+	bh = sb_bread(inode->i_sb, block);
+	if (bh == NULL)
+		return -EIO;
+	eh = ext_block_hdr(bh);
+	if (ext4_ext_check_header(inode, eh, depth)) {
+		brelse(bh);
+		return -EIO;
+	}
+	ex = EXT_FIRST_EXTENT(eh);
+	*logical = le32_to_cpu(ex->ee_block);
+	*phys = ext_pblock(ex);
+	brelse(bh);
+	return 0;
+
+}
+
+/*
  * ext4_ext_next_allocated_block:
  * returns allocated block in subsequent extent or EXT_MAX_BLOCK.
  * NOTE: it considers block number from index entry as
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index f67c755..1909a78 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -213,6 +213,8 @@ extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_pa
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
 int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
+extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
+extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
 
 #endif /* _LINUX_EXT4_EXTENTS */
 
-- 
1.5.3.rc0.30.g114fd-dirty
