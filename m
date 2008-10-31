From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ext4: don't use the block freed but not yet committed during buddy initialization
Date: Fri, 31 Oct 2008 22:20:59 +0530
Message-ID: <1225471859-19718-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	frederic.bohe@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50787 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYJaQvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 12:51:25 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9VGoP5T022341
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:50:25 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9VGpNrD280276
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:23 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9VGpMJ4002699
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:23 +1100
In-Reply-To: <1225471859-19718-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we generate buddy cache(especially during resize) we need to make
sure we don't use the blocks freed but not yet comitted. This make
sure we have the right value of free blocks count in the group
info and also in the bitmap. This also ensures the ordered mode
consistency

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   69 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34a365e..5824170 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -335,6 +335,9 @@
 static struct kmem_cache *ext4_free_ext_cachep;
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
+static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+					ext4_group_t group,
+					struct ext4_free_data *entry);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
@@ -858,7 +861,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			/*
 			 * incore got set to the group block bitmap below
 			 */
+			ext4_lock_group(sb, group);
 			ext4_mb_generate_buddy(sb, data, incore, group);
+			ext4_unlock_group(sb, group);
 			incore = NULL;
 		} else {
 			/* this is block of bitmap */
@@ -872,6 +877,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 			/* mark all preallocated blks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
+			ext4_mb_generate_from_freelist(sb, data, group, NULL);
 			ext4_unlock_group(sb, group);
 
 			/* set incore so that the buddy information can be
@@ -3432,6 +3438,42 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 }
 
 /*
+ * the function goes through all block freed in the group
+ * but not yet committed and marks them used in in-core bitmap.
+ * buddy must be generated from this bitmap
+ * Need to be called with ext4 group lock (ext4_lock_group)
+ */
+static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
+					ext4_group_t group,
+					struct ext4_free_data *entry)
+{
+	struct rb_node *n;
+	struct ext4_group_info *grp;
+	struct ext4_free_data *new_entry;
+	if (entry == NULL) {
+		grp = ext4_get_group_info(sb, group);
+		n = grp->bb_free_root.rb_node;
+	} else
+		n = &entry->node;
+
+	if (n == NULL)
+		return;
+	if (n->rb_left) {
+		new_entry = rb_entry(n->rb_left, struct ext4_free_data, node);
+		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
+	}
+	if (n->rb_right) {
+		new_entry = rb_entry(n->rb_right, struct ext4_free_data, node);
+		ext4_mb_generate_from_freelist(sb, bitmap, group, new_entry);
+	}
+	printk(KERN_CRIT "Aneesh updating bitmap");
+	mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
+					bitmap, entry->start_blk,
+					entry->count);
+	return;
+}
+
+/*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
  * Need to be called with ext4 group lock (ext4_lock_group)
@@ -4717,15 +4759,6 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
-	mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-			bit, count);
-
-	/* We dirtied the bitmap block */
-	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
-	if (err)
-		goto error_return;
-
 	if (ac) {
 		ac->ac_b_ex.fe_group = block_group;
 		ac->ac_b_ex.fe_start = bit;
@@ -4739,11 +4772,21 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
 	if (metadata) {
-		/* blocks being freed are metadata. these blocks shouldn't
-		 * be used until this transaction is committed */
+		/*
+		 * blocks being freed are metadata. these blocks shouldn't
+		 * be used until this transaction is committed
+		 */
+		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+				bit, count);
 		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
 	} else {
 		ext4_lock_group(sb, block_group);
+		/* need to update group_info->bb_free and bitmap
+		 * with group lock held. generate_buddy look at
+		 * them with group lock_held
+		 */
+		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+				bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
 		ext4_unlock_group(sb, block_group);
@@ -4766,6 +4809,10 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 
 	*freed += count;
 
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
-- 
1.6.0.3.514.g2f91b

