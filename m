From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH, RFC] ext4_lock_group() vs. sb_bgl_lock()
Date: Wed, 08 Apr 2009 20:11:39 -0600
Message-ID: <20090409021139.GN17302@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Zhuravlev <Alex.Zhuravlev@sun.com>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54905 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZDICMH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2009 22:12:07 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n392BqDr027774
	for <linux-ext4@vger.kernel.org>; Wed, 8 Apr 2009 19:12:04 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHT00E009S4CT00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 08 Apr 2009 19:11:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We hit a bug in the Lustre mballoc code recently that exposed a race
condition between read_block_bitmap() and mark_diskspace_used().

This is caught by an extra sanity check that is in our mballoc, but
not upstream, and I suspect the same still exists in the upstream ext4
code.  In Lustre at least this doesn't result in data corruption
(AFAICS) but it BUGS on the sanity check, and since upstream doesn't
have that check it might slip by.

The root of the problem is that most of the ext4 code is using
sb_bgl_lock() to protect the group descriptors and block bitmaps, but
in some places the mballoc code uses ext4_lock_group() instead.

For example, mb_mark_used() only appears to be holding ext4_lock_group(),
but then calls mb_set_bit() instead of mb_set_bit_atomic().  Later on,
however, it calls mb_set_bits(sb_bgl_lock()), which is inconsistent.

Looking at the mballoc.c code it seems fairly straight forward to remove
the ext4_lock_group() entirely and stick with sb_bgl_lock() everywhere,
though in a few places both of them are used and it needs a bit of
a cleanup.

I've removed the mb_{set,clear}_bit_atomic() variants, since the code
always holds the sb_bgl_lock() over mb_set_bit() now.  I also moved the
flex_bg update inside the same sb_bgl_lock() as the mb_*_bit() instead
of dropping the lock and regetting it 2 lines later.  Callers of
mb_set_bits() must get the sb_bgl_lock() themselves, which is true 90%
of the time already, and avoids a branch for each call.

I'm not sure what to do with the lockdep "__releases(bitlock)" and
"__acquires(bitlock)" in ext4_grp_locked_error() as I know nothing
about it.

Patch (against 2.6.29) has only been compile tested, I wanted to get
some feedback from Aneesh on it.  There is in theory a chance that
there will be increased lock contention for sb_bgl_lock(), but in
most cases we already hold this lock.

========================================================================
--- ./fs/ext4/mballoc.c.orig	2009-04-08 19:13:13.000000000 -0600
+++ ./fs/ext4/mballoc.c	2009-04-08 20:05:48.000000000 -0600
@@ -373,24 +373,12 @@
 	ext4_set_bit(bit, addr);
 }
 
-static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
-{
-	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_set_bit_atomic(lock, bit, addr);
-}
-
 static inline void mb_clear_bit(int bit, void *addr)
 {
 	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_clear_bit(bit, addr);
 }
 
-static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
-{
-	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_clear_bit_atomic(lock, bit, addr);
-}
-
 static inline int mb_find_next_zero_bit(void *addr, int max, int start)
 {
 	int fix = 0, ret, tmpmax;
@@ -449,7 +437,7 @@
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	BUG_ON(!spin_is_locked(sb_bgl_lock(EXT4_SB(sb), e4b->bd_group)));
 	for (i = 0; i < count; i++) {
 		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
 			ext4_fsblk_t blocknr;
@@ -473,7 +461,7 @@
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	BUG_ON(!spin_is_locked(sb_bgl_lock(EXT4_SB(e4b->bd_sb),e4b->bd_group)));
 	for (i = 0; i < count; i++) {
 		BUG_ON(mb_test_bit(first + i, e4b->bd_info->bb_bitmap));
 		mb_set_bit(first + i, e4b->bd_info->bb_bitmap);
@@ -881,9 +869,9 @@
 			/*
 			 * incore got set to the group block bitmap below
 			 */
-			ext4_lock_group(sb, group);
+			spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 			ext4_mb_generate_buddy(sb, data, incore, group);
-			ext4_unlock_group(sb, group);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 			incore = NULL;
 		} else {
 			/* this is block of bitmap */
@@ -892,13 +880,13 @@
 				group, page->index, i * blocksize);
 
 			/* see comments in ext4_mb_put_pa() */
-			ext4_lock_group(sb, group);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 			memcpy(data, bitmap, blocksize);
 
 			/* mark all preallocated blks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
 			ext4_mb_generate_from_freelist(sb, data, group);
-			ext4_unlock_group(sb, group);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 
 			/* set incore so that the buddy information can be
 			 * generated using this
@@ -1079,7 +1067,7 @@
 	return 0;
 }
 
-static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
+static void mb_clear_bits(void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1092,15 +1080,12 @@
 			cur += 32;
 			continue;
 		}
-		if (lock)
-			mb_clear_bit_atomic(lock, cur, bm);
-		else
-			mb_clear_bit(cur, bm);
+		mb_clear_bit(cur, bm);
 		cur++;
 	}
 }
 
-static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
+static void mb_set_bits(void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1113,10 +1098,7 @@
 			cur += 32;
 			continue;
 		}
-		if (lock)
-			mb_set_bit_atomic(lock, cur, bm);
-		else
-			mb_set_bit(cur, bm);
+		mb_set_bit(cur, bm);
 		cur++;
 	}
 }
@@ -1132,7 +1114,7 @@
 	struct super_block *sb = e4b->bd_sb;
 
 	BUG_ON(first + count > (sb->s_blocksize << 3));
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	BUG_ON(!spin_is_locked(sb_bgl_lock(EXT4_SB(sb), e4b->bd_group)));
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
 
@@ -1213,7 +1195,7 @@
 	int ord;
 	void *buddy;
 
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	BUG_ON(!spin_is_locked(sb_bgl_lock(EXT4_SB(e4b->bd_sb),e4b->bd_group)));
 	BUG_ON(ex == NULL);
 
 	buddy = mb_find_buddy(e4b, order, &max);
@@ -1277,7 +1259,7 @@
 
 	BUG_ON(start + len > (e4b->bd_sb->s_blocksize << 3));
 	BUG_ON(e4b->bd_group != ex->fe_group);
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	BUG_ON(!spin_is_locked(sb_bgl_lock(EXT4_SB(e4b->bd_sb),e4b->bd_group)));
 	mb_check_buddy(e4b);
 	mb_mark_used_double(e4b, start, len);
 
@@ -1331,8 +1313,7 @@
 		e4b->bd_info->bb_counters[ord]++;
 	}
 
-	mb_set_bits(sb_bgl_lock(EXT4_SB(e4b->bd_sb), ex->fe_group),
-			EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
+	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
 	mb_check_buddy(e4b);
 
 	return ret;
@@ -1511,7 +1492,7 @@
 	if (err)
 		return err;
 
-	ext4_lock_group(ac->ac_sb, group);
+	spin_lock(sb_bgl_lock(EXT4_SB(ac->ac_sb), group));
 	max = mb_find_extent(e4b, 0, ex.fe_start, ex.fe_len, &ex);
 
 	if (max > 0) {
@@ -1519,7 +1500,7 @@
 		ext4_mb_use_best_found(ac, e4b);
 	}
 
-	ext4_unlock_group(ac->ac_sb, group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(ac->ac_sb), group));
 	ext4_mb_release_desc(e4b);
 
 	return 0;
@@ -1542,7 +1523,7 @@
 	if (err)
 		return err;
 
-	ext4_lock_group(ac->ac_sb, group);
+	spin_lock(sb_bgl_lock(EXT4_SB(ac->ac_sb), group));
 	max = mb_find_extent(e4b, 0, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);
 
@@ -1574,7 +1555,7 @@
 		ac->ac_b_ex = ex;
 		ext4_mb_use_best_found(ac, e4b);
 	}
-	ext4_unlock_group(ac->ac_sb, group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(ac->ac_sb), group));
 	ext4_mb_release_desc(e4b);
 
 	return 0;
@@ -2048,10 +2029,10 @@
 			if (err)
 				goto out;
 
-			ext4_lock_group(sb, group);
+			spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 			if (!ext4_mb_good_group(ac, group, cr)) {
 				/* someone did allocation from this group */
-				ext4_unlock_group(sb, group);
+				spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 				ext4_mb_release_desc(&e4b);
 				continue;
 			}
@@ -2068,7 +2049,7 @@
 			else
 				ext4_mb_complex_scan_group(ac, &e4b);
 
-			ext4_unlock_group(sb, group);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 			ext4_mb_release_desc(&e4b);
 
 			if (ac->ac_status != AC_STATUS_CONTINUE)
@@ -2360,9 +2341,9 @@
 		seq_printf(seq, "#%-5u: I/O error\n", group);
 		return 0;
 	}
-	ext4_lock_group(sb, group);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 	memcpy(&sg, ext4_get_group_info(sb, group), i);
-	ext4_unlock_group(sb, group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 	ext4_mb_release_desc(&e4b);
 
 	seq_printf(seq, "#%-5u: %-5u %-5u %-5u [", group, sg.info.bb_free,
@@ -2756,7 +2737,7 @@
 	return 0;
 }
 
-/* need to called with ext4 group lock (ext4_lock_group) */
+/* need to called with ext4 group lock (sb_bgl_lock) */
 static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
 	struct ext4_prealloc_space *pa;
@@ -2787,9 +2768,9 @@
 #ifdef DOUBLE_CHECK
 			kfree(grinfo->bb_bitmap);
 #endif
-			ext4_lock_group(sb, i);
+			spin_lock(sb_bgl_lock(EXT4_SB(sb), i));
 			ext4_mb_cleanup_pa(grinfo);
-			ext4_unlock_group(sb, i);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), i));
 			kfree(grinfo);
 		}
 		num_meta_group_infos = (sbi->s_groups_count +
@@ -2862,7 +2843,7 @@
 		/* there are blocks to put in buddy to make them really free */
 		count += entry->count;
 		count2++;
-		ext4_lock_group(sb, entry->group);
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), entry->group));
 		/* Take it out of per group rb tree */
 		rb_erase(&entry->node, &(db->bb_free_root));
 		mb_free_blocks(NULL, &e4b, entry->start_blk, entry->count);
@@ -2874,7 +2855,7 @@
 			page_cache_release(e4b.bd_buddy_page);
 			page_cache_release(e4b.bd_bitmap_page);
 		}
-		ext4_unlock_group(sb, entry->group);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), entry->group));
 		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
 			+ entry->start_blk
 			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
@@ -3049,14 +3030,17 @@
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
 		 */
-		mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group),
-				bitmap_bh->b_data, ac->ac_b_ex.fe_start,
-				ac->ac_b_ex.fe_len);
+		spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
+		mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
+			    ac->ac_b_ex.fe_len);
+		spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
 		goto out_err;
 	}
+
+	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 #ifdef AGGRESSIVE_CHECK
 	{
 		int i;
@@ -3066,9 +3050,7 @@
 		}
 	}
 #endif
-	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	mb_set_bits(NULL, bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
+	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,ac->ac_b_ex.fe_len);
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_blks_set(sb, gdp,
@@ -3078,6 +3060,13 @@
 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_blks_set(sb, gdp, len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
+
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t flex_group = ext4_flex_group(sbi,
+							  ac->ac_b_ex.fe_group);
+		sbi->s_flex_groups[flex_group].free_blocks -=ac->ac_b_ex.fe_len;
+	}
+
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 	/*
@@ -3090,14 +3079,6 @@
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
 						ac->ac_b_ex.fe_len);
 
-	if (sbi->s_log_groups_per_flex) {
-		ext4_group_t flex_group = ext4_flex_group(sbi,
-							  ac->ac_b_ex.fe_group);
-		spin_lock(sb_bgl_lock(sbi, flex_group));
-		sbi->s_flex_groups[flex_group].free_blocks -= ac->ac_b_ex.fe_len;
-		spin_unlock(sb_bgl_lock(sbi, flex_group));
-	}
-
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (err)
 		goto out_err;
@@ -3509,7 +3490,7 @@
  * the function goes through all block freed in the group
  * but not yet committed and marks them used in in-core bitmap.
  * buddy must be generated from this bitmap
- * Need to be called with ext4 group lock (ext4_lock_group)
+ * Need to be called with ext4 group lock (sb_bgl_lock)
  */
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 						ext4_group_t group)
@@ -3523,9 +3504,7 @@
 
 	while (n) {
 		entry = rb_entry(n, struct ext4_free_data, node);
-		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
-				bitmap, entry->start_blk,
-				entry->count);
+		mb_set_bits(bitmap, entry->start_blk, entry->count);
 		n = rb_next(n);
 	}
 	return;
@@ -3534,7 +3513,7 @@
 /*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
- * Need to be called with ext4 group lock (ext4_lock_group)
+ * Need to be called with ext4 group lock (sb_bgl_lock)
  */
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
@@ -3566,8 +3545,7 @@
 		if (unlikely(len == 0))
 			continue;
 		BUG_ON(groupnr != group);
-		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
-						bitmap, start, len);
+		mb_set_bits(bitmap, start, len);
 		preallocated += len;
 		count++;
 	}
@@ -3625,9 +3603,9 @@
 	 * we make "copy" and "mark all PAs" atomic and serialize "drop PA"
 	 * against that pair
 	 */
-	ext4_lock_group(sb, grp);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), grp));
 	list_del(&pa->pa_group_list);
-	ext4_unlock_group(sb, grp);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), grp));
 
 	spin_lock(pa->pa_obj_lock);
 	list_del_rcu(&pa->pa_inode_list);
@@ -3719,9 +3697,9 @@
 	pa->pa_obj_lock = &ei->i_prealloc_lock;
 	pa->pa_inode = ac->ac_inode;
 
-	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), ac->ac_b_ex.fe_group));
 	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
-	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), ac->ac_b_ex.fe_group));
 
 	spin_lock(pa->pa_obj_lock);
 	list_add_rcu(&pa->pa_inode_list, &ei->i_prealloc_list);
@@ -3781,9 +3759,9 @@
 	pa->pa_obj_lock = &lg->lg_prealloc_lock;
 	pa->pa_inode = NULL;
 
-	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), ac->ac_b_ex.fe_group));
 	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
-	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), ac->ac_b_ex.fe_group));
 
 	/*
 	 * We will later add the new pa to the right bucket
@@ -3966,7 +3944,7 @@
 	INIT_LIST_HEAD(&list);
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 repeat:
-	ext4_lock_group(sb, group);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
@@ -3995,7 +3973,7 @@
 	/* if we still need more blocks and some PAs were used, try again */
 	if (free < needed && busy) {
 		busy = 0;
-		ext4_unlock_group(sb, group);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 		/*
 		 * Yield the CPU here so that we don't get soft lockup
 		 * in non preempt case.
@@ -4028,7 +4006,7 @@
 	}
 
 out:
-	ext4_unlock_group(sb, group);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_release_desc(&e4b);
@@ -4136,10 +4114,10 @@
 			continue;
 		}
 
-		ext4_lock_group(sb, group);
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 		list_del(&pa->pa_group_list);
 		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
-		ext4_unlock_group(sb, group);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 
 		ext4_mb_release_desc(&e4b);
 		put_bh(bitmap_bh);
@@ -4197,7 +4175,7 @@
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
 		struct list_head *cur;
-		ext4_lock_group(sb, i);
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), i));
 		list_for_each(cur, &grp->bb_prealloc_list) {
 			pa = list_entry(cur, struct ext4_prealloc_space,
 					pa_group_list);
@@ -4208,7 +4186,7 @@
 			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
 							start, pa->pa_len);
 		}
-		ext4_unlock_group(sb, i);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), i));
 
 		if (grp->bb_free == 0)
 			continue;
@@ -4400,10 +4378,10 @@
 					"information for %u", group);
 			continue;
 		}
-		ext4_lock_group(sb, group);
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), group));
 		list_del(&pa->pa_group_list);
 		ext4_mb_release_group_pa(&e4b, pa, ac);
-		ext4_unlock_group(sb, group);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), group));
 
 		ext4_mb_release_desc(&e4b);
 		list_del(&pa->u.pa_tmp_list);
@@ -4901,37 +4879,31 @@
 		new_entry->group  = block_group;
 		new_entry->count = count;
 		new_entry->t_tid = handle->h_transaction->t_tid;
-		ext4_lock_group(sb, block_group);
-		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-				bit, count);
+
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
+		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
-		ext4_unlock_group(sb, block_group);
 	} else {
-		ext4_lock_group(sb, block_group);
 		/* need to update group_info->bb_free and bitmap
 		 * with group lock held. generate_buddy look at
 		 * them with group lock_held
 		 */
-		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-				bit, count);
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
+		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
-		ext4_unlock_group(sb, block_group);
 	}
 
-	spin_lock(sb_bgl_lock(sbi, block_group));
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
-	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		spin_lock(sb_bgl_lock(sbi, flex_group));
 		sbi->s_flex_groups[flex_group].free_blocks += count;
-		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	ext4_mb_release_desc(&e4b);
 
--- ./fs/ext4/super.c.orig	2009-04-08 19:13:13.000000000 -0600
+++ ./fs/ext4/super.c	2009-04-08 20:02:30.000000000 -0600
@@ -448,7 +448,7 @@
 		ext4_commit_super(sb, es, 0);
 		return;
 	}
-	ext4_unlock_group(sb, grp);
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), grp));
 	ext4_handle_error(sb);
 	/*
 	 * We only get here in the ERRORS_RO case; relocking the group
@@ -461,7 +461,7 @@
 	 * aggressively from the ext4 function in question, with a
 	 * more appropriate error code.
 	 */
-	ext4_lock_group(sb, grp);
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), grp));
 	return;
 }
 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

