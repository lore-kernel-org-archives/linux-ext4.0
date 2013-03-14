From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: reserve metadata block for every delayed write
Date: Thu, 14 Mar 2013 08:08:59 +0100
Message-ID: <1363244939-17310-1-git-send-email-lczerner@redhat.com>
References: <alpine.LFD.2.00.1303140736430.18319@dhcp-1-104.brq.redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab3CNHJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 03:09:07 -0400
In-Reply-To: <alpine.LFD.2.00.1303140736430.18319@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we only reserve space (data+metadata) in delayed allocation if
we're allocating from new cluster (which is always in non-bigalloc file
system) which is ok for data blocks, because we reserve whole cluster.

However we have to reserve metadata for every delayed block we're going
to write because every block could potentially require metedata block
when we need to grow the extent tree.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Move ext4_da_reserve_metadata() function into this patch

 fs/ext4/inode.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ea0cde..878ace9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1216,6 +1216,55 @@ static int ext4_journalled_write_end(struct file *file,
 }
 
 /*
+ * Reserve a metadata for a single block located at lblock
+ */
+static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
+{
+	int retries = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int md_needed;
+	ext4_lblk_t save_last_lblock;
+	int save_len;
+
+	/*
+	 * recalculate the amount of metadata blocks to reserve
+	 * in order to allocate nrblocks
+	 * worse case is one extent per block
+	 */
+repeat:
+	spin_lock(&ei->i_block_reservation_lock);
+	/*
+	 * ext4_calc_metadata_amount() has side effects, which we have
+	 * to be prepared undo if we fail to claim space.
+	 */
+	save_len = ei->i_da_metadata_calc_len;
+	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
+	md_needed = EXT4_NUM_B2C(sbi,
+				 ext4_calc_metadata_amount(inode, lblock));
+	trace_ext4_da_reserve_space(inode, md_needed);
+
+	/*
+	 * We do still charge estimated metadata to the sb though;
+	 * we cannot afford to run out of free blocks.
+	 */
+	if (ext4_claim_free_clusters(sbi, md_needed, 0)) {
+		ei->i_da_metadata_calc_len = save_len;
+		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
+		spin_unlock(&ei->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			cond_resched();
+			goto repeat;
+		}
+		return -ENOSPC;
+	}
+	ei->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&ei->i_block_reservation_lock);
+
+	return 0;       /* success */
+}
+
+/*
  * Reserve a single cluster located at lblock
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
@@ -1843,8 +1892,11 @@ add_delayed:
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
-		/* If the block was allocated from previously allocated cluster,
-		 * then we dont need to reserve it again. */
+		/*
+		 * If the block was allocated from previously allocated cluster,
+		 * then we don't need to reserve it again. However we still need
+		 * to reserve metadata for every block we're going to write.
+		 */
 		if (!(map->m_flags & EXT4_MAP_FROM_CLUSTER)) {
 			ret = ext4_da_reserve_space(inode, iblock);
 			if (ret) {
@@ -1852,6 +1904,13 @@ add_delayed:
 				retval = ret;
 				goto out_unlock;
 			}
+		} else {
+			ret = ext4_da_reserve_metadata(inode, iblock);
+			if (ret) {
+				/* not enough space to reserve */
+				retval = ret;
+				goto out_unlock;
+			}
 		}
 
 		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
-- 
1.7.7.6

