Return-Path: <SRS0=7LHW=OY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48608 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727757AbeLOFxa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Dec 2018 00:53:30 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2 1/2] ext4: try to merge unwritten extents who are also not under io
Date: Sat, 15 Dec 2018 13:48:39 +0800
Message-Id: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_can_extents_be_merged(), if one file has unwritten
extents under io, we will not merge any other unwritten extents, even
they are not in range of those unwritten extents under io. This limit
is coarse, indeed we can merge these unwritten extents that are not
under io.

Here add a new ES_IO_B flag to track unwritten extents under io in
extents status tree. When we try to merge unwritten extents, search
given extents in extents status tree, if not found, then we can merge
these unwritten extents.

Note currently we only track unwritten extents under io.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/ext4/extents.c        | 24 +++++++++++++++++++++--
 fs/ext4/extents_status.c | 41 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h | 12 +++++++++++-
 fs/ext4/inode.c          | 28 ++++++++++++++++++++++++++-
 4 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..444c739470a5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1713,6 +1713,25 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static int ext4_unwritten_extent_under_io(struct inode *inode,
+		ext4_lblk_t start, unsigned int len)
+{
+	/*
+	 * The check for IO to unwritten extent is somewhat racy as we
+	 * increment i_unwritten / set EXT4_STATE_DIO_UNWRITTEN only after
+	 * dropping i_data_sem. But reserved blocks should save us in that
+	 * case.
+	 */
+	if (atomic_read(&EXT4_I(inode)->i_unwritten) == 0)
+		return 0;
+
+	if (ext4_es_scan_range(inode, &ext4_es_is_under_io, start,
+	    start + len - 1))
+		return 1;
+
+	return 0;
+}
+
 int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
@@ -1744,8 +1763,9 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	 */
 	if (ext4_ext_is_unwritten(ex1) &&
 	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
-	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
-	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
+	    (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN) ||
+	    ext4_unwritten_extent_under_io(inode, le32_to_cpu(ex1->ee_block),
+					   ext1_ee_len + ext2_ee_len)))
 		return 0;
 #ifdef AGGRESSIVE_TEST
 	if (ext1_ee_len >= 4)
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 2b439afafe13..1262184dac29 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -860,6 +860,38 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	return err;
 }
 
+/*
+ * When writing unwritten extents, we mark EXTENT_STATUS_IO in es,
+ * but if some errors happen and stop submitting IO, also need to
+ * clear EXTENT_STATUS_IO flag.
+ */
+int ext4_es_clear_io_status(struct inode *inode, ext4_lblk_t lblk,
+			    ext4_lblk_t end, ext4_fsblk_t block)
+{
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
+	struct extent_status *es;
+	unsigned int status;
+	int err = 0;
+
+	read_lock(&EXT4_I(inode)->i_es_lock);
+	es = __es_tree_search(&tree->root, lblk);
+	if (!es || es->es_lblk > end) {
+		read_unlock(&EXT4_I(inode)->i_es_lock);
+		return err;
+	}
+	status = ext4_es_type(es);
+	status &= ~EXTENT_STATUS_IO;
+	read_unlock(&EXT4_I(inode)->i_es_lock);
+
+	/*
+	 * Note ext4_es_insert_extent will remove es firstly and insert new es
+	 * with new status without EXTENT_STATUS_IO.
+	 */
+	err = ext4_es_insert_extent(inode, lblk, end - lblk + 1, block, status);
+	return err;
+}
+
+
 /*
  * ext4_es_cache_extent() inserts information into the extent status
  * tree if and only if there isn't information about the range in
@@ -1332,6 +1364,15 @@ static int es_do_reclaim_extents(struct ext4_inode_info *ei, ext4_lblk_t end,
 		 */
 		if (ext4_es_is_delayed(es))
 			goto next;
+
+		/*
+		 * We don't reclaim unwritten extent under io because we use
+		 * it to check whether we can merge other unwritten extents
+		 * who are not under io, and when io completes, then we can
+		 * reclaim this extent.
+		 */
+		if (ext4_es_is_under_io(es))
+			goto next;
 		if (ext4_es_is_referenced(es)) {
 			ext4_es_clear_referenced(es);
 			goto next;
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 131a8b7df265..0452a98af90d 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -36,6 +36,7 @@ enum {
 	ES_DELAYED_B,
 	ES_HOLE_B,
 	ES_REFERENCED_B,
+	ES_IO_B,
 	ES_FLAGS
 };
 
@@ -47,11 +48,13 @@ enum {
 #define EXTENT_STATUS_DELAYED	(1 << ES_DELAYED_B)
 #define EXTENT_STATUS_HOLE	(1 << ES_HOLE_B)
 #define EXTENT_STATUS_REFERENCED	(1 << ES_REFERENCED_B)
+#define EXTENT_STATUS_IO	(1 << ES_IO_B)
 
 #define ES_TYPE_MASK	((ext4_fsblk_t)(EXTENT_STATUS_WRITTEN | \
 			  EXTENT_STATUS_UNWRITTEN | \
 			  EXTENT_STATUS_DELAYED | \
-			  EXTENT_STATUS_HOLE) << ES_SHIFT)
+			  EXTENT_STATUS_HOLE | \
+			  EXTENT_STATUS_IO) << ES_SHIFT)
 
 struct ext4_sb_info;
 struct ext4_extent;
@@ -147,6 +150,8 @@ extern bool ext4_es_scan_range(struct inode *inode,
 extern bool ext4_es_scan_clu(struct inode *inode,
 			     int (*matching_fn)(struct extent_status *es),
 			     ext4_lblk_t lblk);
+extern int ext4_es_clear_io_status(struct inode *inode, ext4_lblk_t lblk,
+				   ext4_lblk_t end, ext4_fsblk_t block);
 
 static inline unsigned int ext4_es_status(struct extent_status *es)
 {
@@ -173,6 +178,11 @@ static inline int ext4_es_is_delayed(struct extent_status *es)
 	return (ext4_es_type(es) & EXTENT_STATUS_DELAYED) != 0;
 }
 
+static inline int ext4_es_is_under_io(struct extent_status *es)
+{
+	return (ext4_es_type(es) & EXTENT_STATUS_IO) != 0;
+}
+
 static inline int ext4_es_is_hole(struct extent_status *es)
 {
 	return (ext4_es_type(es) & EXTENT_STATUS_HOLE) != 0;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..ba557a731081 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -704,6 +704,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
 				       map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
+		/*
+		 * Track unwritten extent under io. When io completes, we'll
+		 * convert unwritten extent to written, ext4_es_insert_extent()
+		 * will be called again to insert this written extent, then
+		 * EXTENT_STATUS_IO will be cleared automatically, see remove
+		 * logic in ext4_es_insert_extent().
+		 */
+		if ((status & EXTENT_STATUS_UNWRITTEN) && (flags &
+		    EXT4_GET_BLOCKS_IO_SUBMIT))
+			status |= EXTENT_STATUS_IO;
 		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
 					    map->m_pblk, status);
 		if (ret < 0) {
@@ -2526,6 +2536,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	int err;
 	loff_t disksize;
 	int progress = 0;
+	ext4_lblk_t start = 0, end = 0, submitted = 0;
+	ext4_fsblk_t phy_start = 0;
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
@@ -2565,13 +2577,27 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			return err;
 		}
 		progress = 1;
+
+		if (mpd->io_submit.io_end->flag & EXT4_IO_END_UNWRITTEN) {
+			start = mpd->map.m_lblk;
+			end = start + mpd->map.m_len - 1;
+			phy_start = mpd->map.m_pblk;
+		}
 		/*
 		 * Update buffer state, submit mapped pages, and get us new
 		 * extent to map
 		 */
 		err = mpage_map_and_submit_buffers(mpd);
-		if (err < 0)
+		if (err < 0) {
+			submitted = mpd->io_submit.io_end->size >>
+					inode->i_blkbits;
+			if (mpd->io_submit.io_end->flag & EXT4_IO_END_UNWRITTEN
+			    && submitted < (end - start + 1))
+				ext4_es_clear_io_status(inode,
+					start + submitted, end,
+					phy_start + submitted);
 			goto update_disksize;
+		}
 	} while (map->m_len);
 
 update_disksize:
-- 
2.17.2
