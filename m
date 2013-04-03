From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed,  3 Apr 2013 14:58:31 +0400
Message-ID: <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:12387 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab3DCK67 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 06:58:59 -0400
In-Reply-To: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All new features are broken on bigendian hosts due to lack of conversion:
es_cache: https://lkml.org/lkml/2013/3/28/64
inode's csum and ext_to_ind_migrate are also broken.

Testcase: make C=2 CF="-D__CHECK_ENDIAN__

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c           |   12 ++++++------
 fs/ext4/indirect.c          |    4 ++--
 fs/ext4/inode.c             |    8 ++++----
 fs/ext4/mmp.c               |    2 +-
 fs/ext4/namei.c             |    4 ++--
 fs/ext4/super.c             |    4 ++--
 fs/ext4/xattr.c             |   11 +++++------
 include/trace/events/ext4.h |    6 +++---
 8 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1530cf4..3c3410e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2784,7 +2784,7 @@ again:
 	}
 
 	trace_ext4_ext_remove_space_done(inode, start, depth, partial_cluster,
-			path->p_hdr->eh_entries);
+					 path->p_hdr->eh_entries);
 
 	/* If we still have something in the partial cluster and we have removed
 	 * even the first extent, then we should free the blocks in the partial
@@ -2999,20 +2999,20 @@ static int ext4_split_extent_at(handle_t *handle,
 			if (split_flag & EXT4_EXT_DATA_VALID1) {
 				err = ext4_ext_zeroout(inode, ex2);
 				zero_ex.ee_block = ex2->ee_block;
-				zero_ex.ee_len = ext4_ext_get_actual_len(ex2);
+				zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex2));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex2));
 			} else {
 				err = ext4_ext_zeroout(inode, ex);
 				zero_ex.ee_block = ex->ee_block;
-				zero_ex.ee_len = ext4_ext_get_actual_len(ex);
+				zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex));
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex));
 			}
 		} else {
 			err = ext4_ext_zeroout(inode, &orig_ex);
 			zero_ex.ee_block = orig_ex.ee_block;
-			zero_ex.ee_len = ext4_ext_get_actual_len(&orig_ex);
+			zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(&orig_ex));
 			ext4_ext_store_pblock(&zero_ex,
 					      ext4_ext_pblock(&orig_ex));
 		}
@@ -3272,7 +3272,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		if (err)
 			goto out;
 		zero_ex.ee_block = ex->ee_block;
-		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
+		zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex));
 		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
 
 		err = ext4_ext_get_access(handle, inode, path + depth);
@@ -4639,7 +4639,7 @@ int ext4_ind_migrate(struct inode *inode)
 	eh = ext_inode_hdr(inode);
 	ex  = EXT_FIRST_EXTENT(eh);
 	if (ext4_blocks_count(es) > EXT4_MAX_BLOCK_FILE_PHYS ||
-	    eh->eh_depth != 0 || eh->eh_entries > 1) {
+	    eh->eh_depth != 0 || le16_to_cpu(eh->eh_entries) > 1) {
 		ret = -EOPNOTSUPP;
 		goto errout;
 	}
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 80a798b..98be6f6 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1324,9 +1324,9 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		blk = *i_data;
 		if (level > 0) {
 			ext4_lblk_t first2;
-			bh = sb_bread(inode->i_sb, blk);
+			bh = sb_bread(inode->i_sb, le32_to_cpu(blk));
 			if (!bh) {
-				EXT4_ERROR_INODE_BLOCK(inode, blk,
+				EXT4_ERROR_INODE_BLOCK(inode, le32_to_cpu(blk),
 						       "Read failure");
 				return -EIO;
 			}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7712aff..a2c4f14 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -55,21 +55,21 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 	__u16 csum_hi = 0;
 	__u32 csum;
 
-	csum_lo = raw->i_checksum_lo;
+	csum_lo = le16_to_cpu(raw->i_checksum_lo);
 	raw->i_checksum_lo = 0;
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
-		csum_hi = raw->i_checksum_hi;
+		csum_hi = le16_to_cpu(raw->i_checksum_hi);
 		raw->i_checksum_hi = 0;
 	}
 
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)raw,
 			   EXT4_INODE_SIZE(inode->i_sb));
 
-	raw->i_checksum_lo = csum_lo;
+	raw->i_checksum_lo = cpu_to_le16(csum_lo);
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
-		raw->i_checksum_hi = csum_hi;
+		raw->i_checksum_hi = cpu_to_le16(csum_hi);
 
 	return csum;
 }
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index f9b5515..b3b1f7d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,7 +7,7 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3825d6a..5a29ea6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -420,11 +420,11 @@ static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
 	int size;
 
 	size = count_offset + (count * sizeof(struct dx_entry));
-	old_csum = t->dt_checksum;
+	old_csum = le32_to_cpu(t->dt_checksum);
 	t->dt_checksum = 0;
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)dirent, size);
 	csum = ext4_chksum(sbi, csum, (__u8 *)t, sizeof(struct dx_tail));
-	t->dt_checksum = old_csum;
+	t->dt_checksum = cpu_to_le32(old_csum);
 
 	return cpu_to_le32(csum);
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 280a918..c712c8f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1954,13 +1954,13 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 		__u16 old_csum;
 		__u32 csum32;
 
-		old_csum = gdp->bg_checksum;
+		old_csum = le16_to_cpu(gdp->bg_checksum);
 		gdp->bg_checksum = 0;
 		csum32 = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&le_group,
 				     sizeof(le_group));
 		csum32 = ext4_chksum(sbi, csum32, (__u8 *)gdp,
 				     sbi->s_desc_size);
-		gdp->bg_checksum = old_csum;
+		gdp->bg_checksum = cpu_to_le16(old_csum);
 
 		crc = csum32 & 0xFFFF;
 		goto out;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3a120b2..34da740 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -123,16 +123,15 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	__u32 csum, old;
-
-	old = hdr->h_checksum;
+	__le64 dsk_block_nr = cpu_to_le64(block_nr);
+	old = le32_to_cpu(hdr->h_checksum);
 	hdr->h_checksum = 0;
-	block_nr = cpu_to_le64(block_nr);
-	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
-			   sizeof(block_nr));
+	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&dsk_block_nr,
+			   sizeof(dsk_block_nr));
 	csum = ext4_chksum(sbi, csum, (__u8 *)hdr,
 			   EXT4_BLOCK_SIZE(inode->i_sb));
 
-	hdr->h_checksum = old;
+	hdr->h_checksum = cpu_to_le32(old);
 	return cpu_to_le32(csum);
 }
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 58459b7..d0e6864 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1948,7 +1948,7 @@ TRACE_EVENT(ext4_remove_blocks,
 		__entry->to		= to;
 		__entry->partial	= partial_cluster;
 		__entry->ee_pblk	= ext4_ext_pblock(ex);
-		__entry->ee_lblk	= cpu_to_le32(ex->ee_block);
+		__entry->ee_lblk	= le32_to_cpu(ex->ee_block);
 		__entry->ee_len		= ext4_ext_get_actual_len(ex);
 	),
 
@@ -2052,7 +2052,7 @@ TRACE_EVENT(ext4_ext_remove_space,
 
 TRACE_EVENT(ext4_ext_remove_space_done,
 	TP_PROTO(struct inode *inode, ext4_lblk_t start, int depth,
-		ext4_lblk_t partial, unsigned short eh_entries),
+		ext4_lblk_t partial, __le16 eh_entries),
 
 	TP_ARGS(inode, start, depth, partial, eh_entries),
 
@@ -2071,7 +2071,7 @@ TRACE_EVENT(ext4_ext_remove_space_done,
 		__entry->start		= start;
 		__entry->depth		= depth;
 		__entry->partial	= partial;
-		__entry->eh_entries	= eh_entries;
+		__entry->eh_entries	= le16_to_cpu(eh_entries);
 	),
 
 	TP_printk("dev %d,%d ino %lu since %u depth %d partial %u "
-- 
1.7.1

