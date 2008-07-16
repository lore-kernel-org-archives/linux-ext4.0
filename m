From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Cleanup the block reservation code path
Date: Wed, 16 Jul 2008 12:29:10 +0530
Message-ID: <1216191550-32523-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:56963 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753612AbYGPG7P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 02:59:15 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6G6xCIe016746
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:29:12 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6G6xBfW938226
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:29:11 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6G6xB4F003638
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:29:11 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The truncate patch should not use the i_allocated_meta_blocks
value. So add seperate functions to be used in the truncate
and alloc path. We also need to release the meta-data block
that we reserved for the blocks that we are truncating.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h  |    1 -
 fs/ext4/inode.c |  108 ++++++++++++++++++++++++++++++++++---------------------
 2 files changed, 67 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 303e41c..6c7924d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1044,7 +1044,6 @@ extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
 
 
 /* inode.c */
-void ext4_da_release_space(struct inode *inode, int used, int to_free);
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t blocknr);
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8ca2763..b9af360 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -952,6 +952,67 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+/*
+ * Calculate the number of metadata blocks need to reserve
+ * to allocate @blocks for non extent file based file
+ */
+static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+	int ind_blks, dind_blks, tind_blks;
+
+	/* number of new indirect blocks needed */
+	ind_blks = (blocks + icap - 1) / icap;
+
+	dind_blks = (ind_blks + icap - 1) / icap;
+
+	tind_blks = 1;
+
+	return ind_blks + dind_blks + tind_blks;
+}
+
+/*
+ * Calculate the number of metadata blocks need to reserve
+ * to allocate given number of blocks
+ */
+static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+		return ext4_ext_calc_metadata_amount(inode, blocks);
+
+	return ext4_indirect_calc_metadata_amount(inode, blocks);
+}
+
+static void ext4_da_update_reserve_space(struct inode *inode, int used)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int total, mdb, mdb_free;
+
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	/* recalculate the number of metablocks still need to be reserved */
+	total = EXT4_I(inode)->i_reserved_data_blocks - used;
+	mdb = ext4_calc_metadata_amount(inode, total);
+
+	/* figure out how many metablocks to release */
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
+
+	/* Account for allocated meta_blocks */
+	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+
+	/* update fs free blocks counter for truncate case */
+	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+
+	/* update per-inode reservations */
+	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
+	EXT4_I(inode)->i_reserved_data_blocks -= used;
+
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+	EXT4_I(inode)->i_allocated_meta_blocks = 0;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+}
+
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
 /*
@@ -1069,7 +1130,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		 * which were deferred till now
 		 */
 		if ((retval > 0) && buffer_delay(bh))
-			ext4_da_release_space(inode, retval, 0);
+			ext4_da_update_reserve_space(inode, retval);
 	}
 
 	up_write((&EXT4_I(inode)->i_data_sem));
@@ -1437,36 +1498,6 @@ static int ext4_journalled_write_end(struct file *file,
 
 	return ret ? ret : copied;
 }
-/*
- * Calculate the number of metadata blocks need to reserve
- * to allocate @blocks for non extent file based file
- */
-static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
-{
-	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
-	int ind_blks, dind_blks, tind_blks;
-
-	/* number of new indirect blocks needed */
-	ind_blks = (blocks + icap - 1) / icap;
-
-	dind_blks = (ind_blks + icap - 1) / icap;
-
-	tind_blks = 1;
-
-	return ind_blks + dind_blks + tind_blks;
-}
-
-/*
- * Calculate the number of metadata blocks need to reserve
- * to allocate given number of blocks
- */
-static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
-{
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_calc_metadata_amount(inode, blocks);
-
-	return ext4_indirect_calc_metadata_amount(inode, blocks);
-}
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
@@ -1490,7 +1521,6 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -ENOSPC;
 	}
-
 	/* reduce fs free blocks counter */
 	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
 
@@ -1501,35 +1531,31 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	return 0;       /* success */
 }
 
-void ext4_da_release_space(struct inode *inode, int used, int to_free)
+static void ext4_da_release_space(struct inode *inode, int to_free)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int total, mdb, mdb_free, release;
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;
+	total = EXT4_I(inode)->i_reserved_data_blocks - to_free;
 	mdb = ext4_calc_metadata_amount(inode, total);
 
 	/* figure out how many metablocks to release */
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	/* Account for allocated meta_blocks */
-	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
-
 	release = to_free + mdb_free;
 
 	/* update fs free blocks counter for truncate case */
 	percpu_counter_add(&sbi->s_freeblocks_counter, release);
 
 	/* update per-inode reservations */
-	BUG_ON(used + to_free > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= (used + to_free);
+	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
+	EXT4_I(inode)->i_reserved_data_blocks -= to_free;
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
@@ -1551,7 +1577,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 		}
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
-	ext4_da_release_space(page->mapping->host, 0, to_release);
+	ext4_da_release_space(page->mapping->host, to_release);
 }
 
 /*
-- 
1.5.6.3.350.g6c11a.dirty

