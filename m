Return-Path: <SRS0=jmd0=OE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:51209 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbeKYTlv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Nov 2018 14:41:51 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: jack@suse.cz, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 1/2] ext4: try to merge unwritten extents who are also not under io
Date: Sun, 25 Nov 2018 16:50:31 +0800
Message-Id: <20181125085031.7141-1-xiaoguang.wang@linux.alibaba.com>
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
 fs/ext4/extents.c        | 29 ++++++++++++++++++++++++++++-
 fs/ext4/extents_status.c |  9 +++++++++
 fs/ext4/extents_status.h | 10 +++++++++-
 fs/ext4/inode.c          | 10 ++++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..a93378cd1152 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1713,6 +1713,33 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static int ext4_unwritten_extent_under_io(struct inode *inode,
+			struct ext4_extent *ex1, struct ext4_extent *ex2)
+{
+	unsigned short len;
+
+	/*
+	 * The check for IO to unwritten extent is somewhat racy as we
+	 * increment i_unwritten / set EXT4_STATE_DIO_UNWRITTEN only after
+	 * dropping i_data_sem. But reserved blocks should save us in that
+	 * case.
+	 */
+	if (atomic_read(&EXT4_I(inode)->i_unwritten) == 0)
+		return 0;
+
+	len = ext4_ext_get_actual_len(ex1);
+	if (ext4_es_scan_range(inode, &ext4_es_is_under_io, ex1->ee_block,
+	    ex1->ee_block + len - 1))
+		return 1;
+
+	len = ext4_ext_get_actual_len(ex2);
+	if (ext4_es_scan_range(inode, &ext4_es_is_under_io, ex2->ee_block,
+	    ex2->ee_block + len - 1))
+		return 1;
+
+	return 0;
+}
+
 int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
@@ -1744,7 +1771,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	 */
 	if (ext4_ext_is_unwritten(ex1) &&
 	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
-	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
+	    ext4_unwritten_extent_under_io(inode, ex1, ex2) ||
 	     (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
 		return 0;
 #ifdef AGGRESSIVE_TEST
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 2b439afafe13..04bbd8b7f8f1 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1332,6 +1332,15 @@ static int es_do_reclaim_extents(struct ext4_inode_info *ei, ext4_lblk_t end,
 		 */
 		if (ext4_es_is_delayed(es))
 			goto next;
+
+		/*
+		 * we don't reclaim unwritten extent under io because we use
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
index 131a8b7df265..29a985600a47 100644
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
@@ -173,6 +176,11 @@ static inline int ext4_es_is_delayed(struct extent_status *es)
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
index 22a9d8159720..516966197257 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -704,6 +704,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
 				       map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
+		/*
+		 * track unwritten extent under io. when io completes, we'll
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
-- 
2.17.2
