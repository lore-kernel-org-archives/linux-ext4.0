From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] Add some new  function for searching extent tree.
Date: Mon, 13 Aug 2007 15:52:22 +0530
Message-ID: <11870005502857-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>
To: alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:55061 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937868AbXHMKYW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:24:22 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DARCob234980
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:27:14 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7DAQ79e163536
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:26:07 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DAMXKJ028133
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:22:33 +1000
In-Reply-To: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Alex Tomas <alex@clusterfs.com>

ext4_ext_search_left
ext4_ext_search_right
---
 fs/ext4/extents.c               |  142 +++++++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs_extents.h |    2 +
 2 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 78beb09..3084e09 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1015,6 +1015,148 @@ out:
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
index 81406f3..5ed0891 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -236,5 +236,7 @@ extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_pa
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
 
+extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
+extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
 #endif /* _LINUX_EXT4_EXTENTS */
 
-- 
1.5.3.rc4.67.gf9286-dirty
