From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: check for a good block group before loading buddy pages
Date: Fri, 7 May 2010 09:00:16 -0700
Message-ID: <AANLkTikhy3LJl9vRhonzIP90tYmOsm98-B8VXPFAhPt5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab0EGQAV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 12:00:21 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id o47G0JCc027658
	for <linux-ext4@vger.kernel.org>; Fri, 7 May 2010 09:00:19 -0700
Received: from gwb19 (gwb19.prod.google.com [10.200.2.19])
	by hpaq11.eem.corp.google.com with ESMTP id o47G0HKa014878
	for <linux-ext4@vger.kernel.org>; Fri, 7 May 2010 09:00:18 -0700
Received: by gwb19 with SMTP id 19so704142gwb.25
        for <linux-ext4@vger.kernel.org>; Fri, 07 May 2010 09:00:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a new field in ext4_group_info to cache the largest available
block range in a block group; and don't load the buddy pages until *after*
we've done a sanity check on the block group.

With large allocation requests (e.g., fallocate(), 8MiB) and relatively full
partitions, it's easy to have no block groups with a block extent large
enough to satisfy the input request length.  This currently causes the loop
during cr == 0 in ext4_mb_regular_allocator() to load the buddy bitmap pages
for EVERY block group.  That can be a lot of pages.  The patch below allows
us to call ext4_mb_good_group() BEFORE we load the buddy pages.

       Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..d266003 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1678,6 +1678,7 @@ struct ext4_group_info {
 	ext4_grpblk_t	bb_first_free;	/* first free block */
 	ext4_grpblk_t	bb_free;	/* total free blocks */
 	ext4_grpblk_t	bb_fragments;	/* nr of freespace fragments */
+	ext4_grpblk_t	bb_largest_free_order;/* order of largest frag in BG */
 	struct          list_head bb_prealloc_list;
 #ifdef DOUBLE_CHECK
 	void            *bb_bitmap;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b423a36..9b3621f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -658,6 +658,26 @@ static void ext4_mb_mark_free_simple(struct
super_block *sb,
 	}
 }

+
+/* Cache the order of the largest free extent we have available in this block
+ * group. */
+static void
+mb_set_largest_free_order(struct super_block *sb, struct ext4_group_info *grp)
+{
+	int i;
+	int bits;
+
+	grp->bb_largest_free_order = -1; /* uninit */
+
+	bits = sb->s_blocksize_bits + 1;
+	for (i = bits; i >= 0; i--) {
+		if (grp->bb_counters[i] > 0) {
+			grp->bb_largest_free_order = i;
+			break;
+		}
+	}
+}
+
 static noinline_for_stack
 void ext4_mb_generate_buddy(struct super_block *sb,
 				void *buddy, void *bitmap, ext4_group_t group)
@@ -700,6 +720,7 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 		 */
 		grp->bb_free = free;
 	}
+	mb_set_largest_free_order(sb, grp);

 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));

@@ -725,6 +746,9 @@ void ext4_mb_generate_buddy(struct super_block *sb,
  * contain blocks_per_page (PAGE_CACHE_SIZE / blocksize)  blocks.
  * So it can have information regarding groups_per_page which
  * is blocks_per_page/2
+ *
+ * Locking note:  This routine takes the block group lock of all groups
+ * for this page; do not hold this lock when calling this routine!
  */

 static int ext4_mb_init_cache(struct page *page, char *incore)
@@ -910,6 +934,11 @@ out:
 	return err;
 }

+/*
+ * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
+ * block group lock of all groups for this page; do not hold the BG lock when
+ * calling this routine!
+ */
 static noinline_for_stack
 int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 {
@@ -1004,6 +1033,11 @@ err:
 	return ret;
 }

+/*
+ * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
+ * block group lock of all groups for this page; do not hold the BG lock when
+ * calling this routine!
+ */
 static noinline_for_stack int
 ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
@@ -1299,6 +1333,7 @@ static void mb_free_blocks(struct inode *inode,
struct ext4_buddy *e4b,
 			buddy = buddy2;
 		} while (1);
 	}
+	mb_set_largest_free_order(sb, e4b->bd_info);
 	mb_check_buddy(e4b);
 }

@@ -1427,6 +1462,7 @@ static int mb_mark_used(struct ext4_buddy *e4b,
struct ext4_free_extent *ex)
 		e4b->bd_info->bb_counters[ord]++;
 		e4b->bd_info->bb_counters[ord]++;
 	}
+	mb_set_largest_free_order(e4b->bd_sb, e4b->bd_info);

 	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
 	mb_check_buddy(e4b);
@@ -1821,16 +1857,22 @@ void ext4_mb_scan_aligned(struct
ext4_allocation_context *ac,
 	}
 }

+/* This is now called BEFORE we load the buddy bitmap. */
 static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 				ext4_group_t group, int cr)
 {
 	unsigned free, fragments;
-	unsigned i, bits;
 	int flex_size = ext4_flex_bg_size(EXT4_SB(ac->ac_sb));
 	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);

 	BUG_ON(cr < 0 || cr >= 4);
-	BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
+
+	/* We only do this if the grp has never been initialized */
+	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+		int ret = ext4_mb_init_group(ac->ac_sb, group);
+		if (ret)
+			return 0;
+	}

 	free = grp->bb_free;
 	fragments = grp->bb_fragments;
@@ -1843,17 +1885,17 @@ static int ext4_mb_good_group(struct
ext4_allocation_context *ac,
 	case 0:
 		BUG_ON(ac->ac_2order == 0);

+		if (grp->bb_largest_free_order < ac->ac_2order) {
+			return 0;
+		}
+
 		/* Avoid using the first bg of a flexgroup for data files */
 		if ((ac->ac_flags & EXT4_MB_HINT_DATA) &&
 		    (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) &&
 		    ((group % flex_size) == 0))
 			return 0;

-		bits = ac->ac_sb->s_blocksize_bits + 1;
-		for (i = ac->ac_2order; i <= bits; i++)
-			if (grp->bb_counters[i] > 0)
-				return 1;
-		break;
+		return 1;
 	case 1:
 		if ((free / fragments) >= ac->ac_g_ex.fe_len)
 			return 1;
@@ -2024,15 +2066,13 @@ repeat:
 		group = ac->ac_g_ex.fe_group;

 		for (i = 0; i < ngroups; group++, i++) {
-			struct ext4_group_info *grp;
 			struct ext4_group_desc *desc;

 			if (group == ngroups)
 				group = 0;

-			/* quick check to skip empty groups */
-			grp = ext4_get_group_info(sb, group);
-			if (grp->bb_free == 0)
+			/* This now checks without needing the buddy page */
+			if (!ext4_mb_good_group(ac, group, cr))
 				continue;

 			err = ext4_mb_load_buddy(sb, group, &e4b);
@@ -2040,12 +2080,6 @@ repeat:
 				goto out;

 			ext4_lock_group(sb, group);
-			if (!ext4_mb_good_group(ac, group, cr)) {
-				/* someone did allocation from this group */
-				ext4_unlock_group(sb, group);
-				ext4_mb_release_desc(&e4b);
-				continue;
-			}

 			ac->ac_groups_scanned++;
 			desc = ext4_get_group_desc(sb, group, NULL);
@@ -2255,6 +2289,7 @@ int ext4_mb_add_groupinfo(struct super_block
*sb, ext4_group_t group,
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
 	meta_group_info[i]->bb_free_root = RB_ROOT;
+	meta_group_info[i]->bb_largest_free_order = -1;  /* uninit */

 #ifdef DOUBLE_CHECK
 	{
