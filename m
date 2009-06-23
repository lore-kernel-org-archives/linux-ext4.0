From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 4/7]ext4: Implement the block allocation with restricted
 blocks
Date: Tue, 23 Jun 2009 17:25:32 +0900
Message-ID: <4A40917C.90508@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4: Implement the block allocation with restricted blocks

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This patch changes the block allocator to use blocks based on
block allocation restriction.

If block allocation restriction is set, block allocator can not use
blocks of a set range.  But flag is "advisory",
these blocks can be used only if there is no blocks to use on FS.

 "mandatory" might be able to used for the thing such as block reservation.
Blocks that "mandatory" flag is set are protected by any block allocator,
therefore no one can use these blocks without clearing
block allocation restriction (EXT4_IOC_CLR_GLOBAL_ALLOC_RULE).

df command output:
If you set block allocation restriction with "mandatory",
FS's free blocks count decreases as many as restricted blocks count you set.
In case of "advisory", there is no effect to FS's free blocks.
Because blocks with "advisory" will be used
if there is no other blocks to use.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/mballoc.c |  324 +++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/mballoc.h |    4 +
 2 files changed, 306 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 031b37f..1a97a3d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1210,6 +1210,113 @@ static void mb_arule_find_group(struct ext4_sb_info *sbi,
 	}
 }

+/*
+ * Find the range where overlaps with block unallocatable range and
+ * set the non-overlapped range to @ex.
+ *
+ * If the range from @start to @start + @len overlaps with, return 1.
+ * If not return 0.
+ */
+static int
+__mb_arule_check_range(struct ext4_bg_alloc_rule_list *arule,
+			struct ext4_free_extent **ex,
+			ext4_grpblk_t start, int len, __u16 ac_flags)
+{
+	struct list_head *arule_head = &arule->arule_list;
+	struct ext4_bg_alloc_rule *pos, *n;
+	ext4_grpblk_t end;
+	int diff;
+	int ret = 0;
+
+	if (ex != NULL) {
+		(*ex)->fe_start = start;
+		(*ex)->fe_len = len;
+	}
+
+	end = start + len - 1;
+	list_for_each_entry_safe(pos, n, arule_head, arule_list) {
+
+		if (pos->start > end)
+			goto out;
+
+		if (EXT4_MB_CHECK_ADVISORY(pos, ac_flags))
+			continue;
+
+		if (pos->start <= end && pos->end >= start) {
+			ret = 1;
+			/* Does not need to set @ex */
+			if (ex == NULL)
+				goto out;
+
+			/* compute free extent */
+			/*
+			 * ex     |--------|
+			 * pos         |-|
+			 * ex(new)|----|
+			 */
+			if (pos->start >= start) {
+				(*ex)->fe_len = pos->start - (*ex)->fe_start;
+				goto out;
+			} else if (pos->end < end) {
+				/*
+				 * ex       |-------|
+				 * pos    |---|
+				 * ex(new)    |-----|
+				 */
+				diff = pos->end - (*ex)->fe_start + 1;
+				(*ex)->fe_start += diff;
+				(*ex)->fe_len -= diff;
+
+				/*
+				 * consider the case 'ex'(new) overlaps with
+				 * next 'pos'.
+				 */
+				continue;
+			} else {
+				/*
+				 * ex       |-------|
+				 * pos     |-----------|
+				 * ex(new)
+				 */
+				(*ex)->fe_len = 0;
+				goto out;
+			}
+		}
+	}
+out:
+	return ret;
+}
+
+/*
+ * Check whether the range from @start to @len is on the unallocatable space
+ * or not, and truncate @ex not to overlap with unallocatable space.
+ * If there are any overlaps, return 1.
+ */
+static int mb_arule_check_range(struct ext4_allocation_context *ac,
+			struct ext4_free_extent **ex, ext4_group_t bg,
+			ext4_grpblk_t start, int len)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_inode->i_sb);
+	struct ext4_bg_alloc_rule_list *target_bg_list = NULL;
+	int ret;
+
+	if (!(ac->ac_flags & EXT4_MB_BLOCKS_RESTRICTED))
+		return 0;
+
+	read_lock(&sbi->s_bg_arule_lock);
+	mb_arule_find_group(sbi, &target_bg_list, bg);
+	if (target_bg_list == NULL) {
+		read_unlock(&sbi->s_bg_arule_lock);
+		return 0;
+	}
+
+	ret = __mb_arule_check_range(target_bg_list, ex, start, len,
+					ac->ac_flags);
+	read_unlock(&sbi->s_bg_arule_lock);
+
+	return ret;
+}
+
 static ext4_grpblk_t
 ext4_mb_count_unused_blocks(void *bd_bitmap, ext4_grpblk_t start,
 				ext4_grpblk_t end) {
@@ -1287,6 +1394,83 @@ mb_arule_count_overlap(struct ext4_allocation_context *ac,
 	read_unlock(&sbi->s_bg_arule_lock);
 }

+/*
+ * Find the range where overlaps with block unallocatable range.
+ * and return the tail block number of the range.
+ * If there is no overlap, return -1.
+ */
+static ext4_grpblk_t
+__mb_arule_check_overlap(struct ext4_bg_alloc_rule_list *arule,
+			__u16 ac_flags, ext4_grpblk_t blk)
+{
+	struct list_head *arule_head = &arule->arule_list;
+	struct ext4_bg_alloc_rule *pos, *n;
+	ext4_grpblk_t ret = -1;
+
+	list_for_each_entry_safe(pos, n, arule_head, arule_list) {
+		if (pos->start > blk)
+			break;
+
+		if (EXT4_MB_CHECK_ADVISORY(pos, ac_flags))
+			continue;
+
+		if (pos->start <= blk && pos->end >= blk) {
+			ret = pos->end;
+			break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * If @blk is on unallocatable range, return the last block number of the
+ * unallocatable range.
+ * If not, return -1.
+ */
+static ext4_grpblk_t
+mb_arule_check_overlap(struct ext4_allocation_context *ac, ext4_group_t bg,
+		ext4_grpblk_t blk)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_inode->i_sb);
+	struct ext4_bg_alloc_rule_list *target_bg_list = NULL;
+	ext4_grpblk_t ret = -1;
+
+	if (!(ac->ac_flags & EXT4_MB_BLOCKS_RESTRICTED))
+		return ret;
+
+	read_lock(&sbi->s_bg_arule_lock);
+	mb_arule_find_group(sbi, &target_bg_list, bg);
+	if (target_bg_list == NULL)
+		goto out;
+
+	ret = __mb_arule_check_overlap(target_bg_list, ac->ac_flags, blk);
+out:
+	read_unlock(&sbi->s_bg_arule_lock);
+
+	return ret;
+}
+
+/*
+ * This function returns the number of the unallocatable blocks.
+ * If ac_flags has advisory flag, we may use the unallocatable blocks
+ * that marked as 'advisory'.
+ * If not, all of the unallocatable blocks are not allocatable.
+ */
+static ext4_grpblk_t
+ext4_mb_get_restricted(struct ext4_bg_alloc_rule_list *arule_list,
+			struct ext4_allocation_context *ac)
+{
+	ext4_grpblk_t restricted;
+
+	if (ac->ac_flags & EXT4_MB_ALLOC_ADVISORY)
+		restricted = arule_list->mand_restricted_blks;
+	else
+		restricted = arule_list->adv_restricted_blks +
+				arule_list->mand_restricted_blks;
+
+	return restricted;
+}
+
 static void
 ext4_mb_calc_restricted(struct ext4_sb_info *sbi,
 			struct ext4_bg_alloc_rule_list **arule_list,
@@ -1302,8 +1486,9 @@ ext4_mb_calc_restricted(struct ext4_sb_info *sbi,
 	}
 }

-static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
-				int needed, struct ext4_free_extent *ex)
+static int mb_find_extent(struct ext4_allocation_context *ac,
+			struct ext4_buddy *e4b, int order, int block,
+			int needed, struct ext4_free_extent *ex)
 {
 	int next = block;
 	int max;
@@ -1356,6 +1541,14 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 		ex->fe_len += 1 << order;
 	}

+	/*
+	 * We should truncate found extent.
+	 * ex                |--------------|
+	 * unallocatable   |---|   |-----|
+	 * ex(truncated)       |---|
+	 */
+	mb_arule_check_range(ac, &ex, e4b->bd_group, ex->fe_start, ex->fe_len);
+
 	BUG_ON(ex->fe_start + ex->fe_len > (1 << (e4b->bd_blkbits + 3)));
 	return ex->fe_len;
 }
@@ -1517,7 +1710,8 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
 		/* recheck chunk's availability - we don't know
 		 * when it was found (within this lock-unlock
 		 * period or not) */
-		max = mb_find_extent(e4b, 0, bex->fe_start, gex->fe_len, &ex);
+		max = mb_find_extent(ac, e4b, 0, bex->fe_start, gex->fe_len,
+					&ex);
 		if (max >= gex->fe_len) {
 			ext4_mb_use_best_found(ac, e4b);
 			return;
@@ -1608,7 +1802,7 @@ static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		return err;

 	ext4_lock_group(ac->ac_sb, group);
-	max = mb_find_extent(e4b, 0, ex.fe_start, ex.fe_len, &ex);
+	max = mb_find_extent(ac, e4b, 0, ex.fe_start, ex.fe_len, &ex);

 	if (max > 0) {
 		ac->ac_b_ex = ex;
@@ -1639,7 +1833,7 @@ static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 		return err;

 	ext4_lock_group(ac->ac_sb, group);
-	max = mb_find_extent(e4b, 0, ac->ac_g_ex.fe_start,
+	max = mb_find_extent(ac, e4b, 0, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);

 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
@@ -1686,9 +1880,12 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_group_info *grp = e4b->bd_info;
 	void *buddy;
+	ext4_grpblk_t start;
+	int len;
 	int i;
 	int k;
 	int max;
+	int dup;

 	BUG_ON(ac->ac_2order <= 0);
 	for (i = ac->ac_2order; i <= sb->s_blocksize_bits + 1; i++) {
@@ -1701,6 +1898,16 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		k = mb_find_next_zero_bit(buddy, max, 0);
 		BUG_ON(k >= max);

+		len = 1 << i;
+		start = k << i;
+
+		/* Can we use all of the found free space? */
+		dup = mb_arule_check_range(ac, (struct ext4_free_extent **)NULL,
+						e4b->bd_group, start, len);
+		if (dup)
+			/* the free space overlaps with unallocatable range. */
+			continue;
+
 		ac->ac_found++;

 		ac->ac_b_ex.fe_len = 1 << i;
@@ -1724,15 +1931,17 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
  * free blocks in the group, so the routine can know upper limit.
  */
 static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
-					struct ext4_buddy *e4b)
+					struct ext4_buddy *e4b,
+					ext4_grpblk_t restricted_blocks)
 {
 	struct super_block *sb = ac->ac_sb;
 	void *bitmap = EXT4_MB_BITMAP(e4b);
 	struct ext4_free_extent ex;
 	int i;
 	int free;
+	int next;

-	free = e4b->bd_info->bb_free;
+	free = e4b->bd_info->bb_free - restricted_blocks;
 	BUG_ON(free <= 0);

 	i = e4b->bd_info->bb_first_free;
@@ -1740,6 +1949,17 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
 		i = mb_find_next_zero_bit(bitmap,
 						EXT4_BLOCKS_PER_GROUP(sb), i);
+
+		/*
+		 * If block number 'i' is unallocatable, next search
+		 * should begin from the end of unallocatable range.
+		 */
+		next = mb_arule_check_overlap(ac, e4b->bd_group, i);
+		if (next >= 0 && i < EXT4_BLOCKS_PER_GROUP(sb)) {
+			i = next + 1;
+			continue;
+		}
+
 		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			/*
 			 * IF we have corrupt bitmap, we won't find any
@@ -1753,7 +1973,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			break;
 		}

-		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
+		mb_find_extent(ac, e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
 		BUG_ON(ex.fe_len <= 0);
 		if (free < ex.fe_len) {
 			ext4_grp_locked_error(sb, e4b->bd_group,
@@ -1805,7 +2025,7 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,

 	while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
 		if (!mb_test_bit(i, bitmap)) {
-			max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
+			max = mb_find_extent(ac, e4b, 0, i, sbi->s_stripe, &ex);
 			if (max >= sbi->s_stripe) {
 				ac->ac_found++;
 				ac->ac_b_ex = ex;
@@ -1818,19 +2038,20 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 }

 static int ext4_mb_good_group(struct ext4_allocation_context *ac,
-				ext4_group_t group, int cr)
+				ext4_group_t group,
+				ext4_grpblk_t restricted_blocks, int cr)
 {
-	unsigned free, fragments;
-	unsigned i, bits;
+	int free;
+	unsigned i, bits, fragments;
 	int flex_size = ext4_flex_bg_size(EXT4_SB(ac->ac_sb));
 	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);

 	BUG_ON(cr < 0 || cr >= 4);
 	BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));

-	free = grp->bb_free;
+	free = grp->bb_free - restricted_blocks;
 	fragments = grp->bb_fragments;
-	if (free == 0)
+	if (free <= 0)
 		return 0;
 	if (fragments == 0)
 		return 0;
@@ -2045,6 +2266,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
+	struct ext4_bg_alloc_rule_list *arule_list = NULL;
 	loff_t size, isize;

 	sb = ac->ac_sb;
@@ -2113,6 +2335,7 @@ repeat:
 		for (i = 0; i < ngroups; group++, i++) {
 			struct ext4_group_info *grp;
 			struct ext4_group_desc *desc;
+			ext4_grpblk_t restricted_blocks = 0;

 			if (group == ngroups)
 				group = 0;
@@ -2140,7 +2363,7 @@ repeat:
 			 * If the particular group doesn't satisfy our
 			 * criteria we continue with the next group
 			 */
-			if (!ext4_mb_good_group(ac, group, cr))
+			if (!ext4_mb_good_group(ac, group, 0, cr))
 				continue;

 			err = ext4_mb_load_buddy(sb, group, &e4b);
@@ -2148,7 +2371,18 @@ repeat:
 				goto out;

 			ext4_lock_group(sb, group);
-			if (!ext4_mb_good_group(ac, group, cr)) {
+			if (ac->ac_flags & EXT4_MB_BLOCKS_RESTRICTED) {
+				mb_arule_find_group(sbi, &arule_list, group);
+				if (arule_list == NULL)
+					restricted_blocks = 0;
+				else
+					restricted_blocks =
+						ext4_mb_get_restricted(
+								arule_list, ac);
+			}
+
+			if (!ext4_mb_good_group(ac, group, restricted_blocks,
+						cr)) {
 				/* someone did allocation from this group */
 				ext4_unlock_group(sb, group);
 				ext4_mb_release_desc(&e4b);
@@ -2163,7 +2397,8 @@ repeat:
 					ac->ac_g_ex.fe_len == sbi->s_stripe)
 				ext4_mb_scan_aligned(ac, &e4b);
 			else
-				ext4_mb_complex_scan_group(ac, &e4b);
+				ext4_mb_complex_scan_group(ac, &e4b,
+							restricted_blocks);

 			ext4_unlock_group(sb, group);
 			ext4_mb_release_desc(&e4b);
@@ -3132,6 +3367,37 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
 	}

+	/* Reduce restricted block count if we allocate from advisory range */
+	if (ac->ac_flags & EXT4_MB_ALLOC_ADVISORY) {
+		struct ext4_buddy e4b;
+		struct ext4_free_extent tmp_ext, *tmp_extp;
+		struct ext4_bg_alloc_rule_list *arule_list;
+		int mand, adv;
+		int group;
+
+		tmp_ext = ac->ac_b_ex;
+		tmp_extp = &tmp_ext;
+		group = tmp_extp->fe_group;
+		ac->ac_flags &= ~EXT4_MB_ALLOC_ADVISORY;
+		err = ext4_mb_load_buddy(sb, group, &e4b);
+		if (err) {
+			ext4_error(sb, __func__, "Error in loading buddy "
+					"information for %u", group);
+			goto out_err;
+		}
+		mb_arule_count_overlap(ac, &e4b, group, tmp_ext.fe_start,
+						tmp_ext.fe_len, &mand, &adv);
+		if (adv) {
+			mb_arule_find_group(sbi, &arule_list, group);
+			/* How many blocks we allocate from advisory range */
+			if (arule_list != NULL)
+				ext4_mb_calc_restricted(sbi, &arule_list,
+						EXT4_MB_ALLOC_RULE_ADVISORY,
+						(s64)-adv);
+		}
+		ext4_mb_release_desc(&e4b);
+	}
+
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
@@ -4353,6 +4619,8 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ac->ac_g_ex.fe_len = len;
 	ac->ac_f_ex.fe_len = 0;
 	ac->ac_flags = ar->flags;
+	if (!list_empty(&sbi->s_bg_arule_list))
+		ac->ac_flags |= EXT4_MB_BLOCKS_RESTRICTED;
 	ac->ac_2order = 0;
 	ac->ac_criteria = 0;
 	ac->ac_pa = NULL;
@@ -4653,7 +4921,8 @@ repeat:
 		/* as we've just preallocated more space than
 		 * user requested orinally, we store allocated
 		 * space in a special descriptor */
-		if (ac->ac_status == AC_STATUS_FOUND &&
+		if (!(ac->ac_flags & EXT4_MB_ALLOC_ADVISORY) &&
+				ac->ac_status == AC_STATUS_FOUND &&
 				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
 			ext4_mb_new_preallocation(ac);
 	}
@@ -4682,10 +4951,21 @@ repeat:
 		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
 		if (freed)
 			goto repeat;
-		*errp = -ENOSPC;
-		ac->ac_b_ex.fe_len = 0;
-		ar->len = 0;
-		ext4_mb_show_ac(ac);
+		if (ac->ac_flags & EXT4_MB_BLOCKS_RESTRICTED
+			&& !(ac->ac_flags & EXT4_MB_ALLOC_ADVISORY)) {
+			ext4_mb_release_context(ac);
+			ac->ac_b_ex.fe_group = 0;
+			ac->ac_b_ex.fe_start = 0;
+			ac->ac_b_ex.fe_len = 0;
+			ac->ac_flags |= EXT4_MB_ALLOC_ADVISORY;
+			ac->ac_status = AC_STATUS_CONTINUE;
+			goto repeat;
+		} else {
+			*errp = -ENOSPC;
+			ac->ac_b_ex.fe_len = 0;
+			ar->len = 0;
+			ext4_mb_show_ac(ac);
+		}
 	}

 	ext4_mb_release_context(ac);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index c96bb19..0fab1b7 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -258,4 +258,8 @@ static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	return block;
 }
+
+#define EXT4_MB_CHECK_ADVISORY(bg_arule, ac_flags)			\
+		((bg_arule->alloc_flag & EXT4_MB_ALLOC_RULE_ADVISORY) &&\
+		(ac_flags & EXT4_MB_ALLOC_ADVISORY)	? 1 : 0)
 #endif
