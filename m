From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 6/6] ext4: update extent status tree after an extent is zeroed out
Date: Fri,  1 Mar 2013 02:26:44 +0800
Message-ID: <1362076004-10087-7-git-send-email-wenqing.lz@taobao.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:38502 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3B1SMF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:12:05 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so972403dak.34
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:12:04 -0800 (PST)
In-Reply-To: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When we try to split an extent, this extent could be zeroed out and mark
as initialized.  But we don't know this in ext4_map_blocks because it
only returns a allocated length of extent.  Meanwhile we will mark this
extent as uninitialized because we only check m_flags.

This commit update extent status tree when we try to split an unwritten
extent.  We don't need to worry about the status of this extent because
we always mark it as initialized.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c        | 27 +++++++++++++++++++++++++--
 fs/ext4/extents_status.c | 14 ++++++++++++++
 fs/ext4/extents_status.h |  3 +++
 fs/ext4/inode.c          | 10 ++++++++++
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 835d82b..a2cf028 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3007,6 +3007,19 @@ static int ext4_split_extent_at(handle_t *handle,
 		ex->ee_len = cpu_to_le16(ee_len);
 		ext4_ext_try_to_merge(handle, inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
+		if (err)
+			goto fix_extent_len;
+
+		/* update extent status tree */
+		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
+			if (split_flag & EXT4_EXT_DATA_VALID1)
+				err = ext4_es_zeroout(inode, ex2);
+			else
+				err = ext4_es_zeroout(inode, ex);
+		} else {
+			err = ext4_es_zeroout(inode, &orig_ex);
+		}
+
 		goto out;
 	} else if (err)
 		goto fix_extent_len;
@@ -3128,7 +3141,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int ee_len, depth;
 	int allocated, max_zeroout = 0;
-	int err = 0;
+	int err = 0, has_zeroout = 0;
 	int split_flag = 0;
 
 	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
@@ -3251,6 +3264,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ext4_ext_mark_initialized(ex);
 		ext4_ext_try_to_merge(handle, inode, path, ex);
 		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
+		if (err)
+			goto out;
+		err = ext4_es_zeroout(inode, ex);
 		goto out;
 	}
 
@@ -3277,6 +3293,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				goto out;
 			split_map.m_lblk = map->m_lblk;
 			split_map.m_len = allocated;
+			has_zeroout = 1;
 		} else if (map->m_lblk - ee_block + map->m_len < max_zeroout) {
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
@@ -3293,13 +3310,19 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			split_map.m_lblk = ee_block;
 			split_map.m_len = map->m_lblk - ee_block + map->m_len;
 			allocated = map->m_len;
+			has_zeroout = 1;
 		}
 	}
 
 	allocated = ext4_split_extent(handle, inode, path,
 				      &split_map, split_flag, 0);
-	if (allocated < 0)
+	if (allocated < 0) {
 		err = allocated;
+		goto out;
+	}
+
+	if (has_zeroout)
+		err = ext4_es_zeroout(inode, &zero_ex);
 
 out:
 	return err ? err : allocated;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 02df536..7289e5f 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -745,6 +745,20 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	return err;
 }
 
+int ext4_es_zeroout(struct inode *inode, struct ext4_extent *ex)
+{
+	ext4_lblk_t  ee_block;
+	ext4_fsblk_t ee_pblock;
+	unsigned int ee_len;
+
+	ee_block  = le32_to_cpu(ex->ee_block);
+	ee_len    = ext4_ext_get_actual_len(ex);
+	ee_pblock = ext4_ext_pblock(ex);
+
+	return ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
+				     EXTENT_STATUS_WRITTEN);
+}
+
 static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct ext4_sb_info *sbi = container_of(shrink,
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 56140ad..d8e2d4d 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -39,6 +39,8 @@
 				 EXTENT_STATUS_DELAYED | \
 				 EXTENT_STATUS_HOLE)
 
+struct ext4_extent;
+
 struct extent_status {
 	struct rb_node rb_node;
 	ext4_lblk_t es_lblk;	/* first logical block extent covers */
@@ -64,6 +66,7 @@ extern void ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t lblk,
 					struct extent_status *es);
 extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 				 struct extent_status *es);
+extern int ext4_es_zeroout(struct inode *inode, struct ext4_extent *ex);
 
 static inline int ext4_es_is_written(struct extent_status *es)
 {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d22170..e2ceab6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -721,6 +721,15 @@ found:
 		}
 #endif
 
+		/*
+		 * If the extent has been zeroed out, we don't need to update
+		 * extent status tree.
+		 */
+		if ((flags & EXT4_GET_BLOCKS_PRE_IO) &&
+		    ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
+			if (ext4_es_is_written(&es))
+				goto has_zeroout;
+		}
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
@@ -733,6 +742,7 @@ found:
 			retval = ret;
 	}
 
+has_zeroout:
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 		int ret = check_block_validity(inode, map);
-- 
1.7.12.rc2.18.g61b472e

