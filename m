From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mballoc changes from ldiskfs
Date: Mon, 7 Jan 2008 23:58:00 +0530
Message-ID: <20080107182800.GA15183@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59849 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbYAGS2g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2008 13:28:36 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m07ISPEe024826
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:28:25 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m07IW8Pm199544
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:32:08 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m07ISF9d027050
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:28:15 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch is  not even compile tested. I am sending it over to find out
whether some of the changes are even needed and to make sure i didn't
drop any bug fix in the merge.

something I noticed.

a) prealloc table is completely gone.
b) ext4_mb_put_pa change. ( I guess that is a bug with ldiskfs ).


now by default request less that 64K use locality group preallocation.

The ldiskfs change i looked at is from
lustre/ldiskfs/kernel_patches/patches/ext3-mballoc3-core.patch

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 58a70a1..cb84516 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -532,10 +532,10 @@ static inline void mb_set_bit(int bit, void *addr)
 	ext4_set_bit(bit, addr);
 }
 
-static inline void mb_set_bit_atomic(int bit, void *addr)
+static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
 {
 	mb_correct_addr_and_bit(bit, addr);
-	ext4_set_bit_atomic(NULL, bit, addr);
+	ext4_set_bit_atomic(lock, bit, addr);
 }
 
 static inline void mb_clear_bit(int bit, void *addr)
@@ -544,10 +544,10 @@ static inline void mb_clear_bit(int bit, void *addr)
 	ext4_clear_bit(bit, addr);
 }
 
-static inline void mb_clear_bit_atomic(int bit, void *addr)
+static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
 {
 	mb_correct_addr_and_bit(bit, addr);
-	ext4_clear_bit_atomic(NULL, bit, addr);
+	ext4_clear_bit_atomic(lock, bit, addr);
 }
 
 static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
@@ -1155,7 +1155,7 @@ static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
 	return 0;
 }
 
-static void mb_clear_bits(void *bm, int cur, int len)
+static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1168,12 +1168,12 @@ static void mb_clear_bits(void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_clear_bit_atomic(cur, bm);
+		mb_clear_bit_atomic(lock, cur, bm);
 		cur++;
 	}
 }
 
-static void mb_set_bits(void *bm, int cur, int len)
+static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1186,7 +1186,7 @@ static void mb_set_bits(void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(cur, bm);
+		mb_set_bit_atomic(lock, cur, bm);
 		cur++;
 	}
 }
@@ -1403,7 +1403,8 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 		e4b->bd_info->bb_counters[ord]++;
 	}
 
-	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
+	mb_set_bits(sb_bgl_lock(EXT4_SB(e4b->bd_sb), ex->fe_group),
+			EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
 	mb_check_buddy(e4b);
 
 	return ret;
@@ -1439,14 +1440,6 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
 	get_page(ac->ac_buddy_page);
-
-	/* store last allocated for subsequent stream allocation */
-	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
-		spin_lock(&sbi->s_md_lock);
-		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
-		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
-		spin_unlock(&sbi->s_md_lock);
-	}
 }
 
 /*
@@ -1509,8 +1502,8 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
-	BUG_ON(ex->fe_start >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
+	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
 	ac->ac_found++;
@@ -1553,7 +1546,6 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 		/* if the request is satisfied, then we try to find
 		 * an extent that still satisfy the request, but is
 		 * smaller than previous one */
-		if (ex->fe_len < bex->fe_len)
 			*bex = *ex;
 	}
 
@@ -1702,8 +1694,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	i = e4b->bd_info->bb_first_free;
 
 	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
-		i = ext4_find_next_zero_bit(bitmap, sb->s_blocksize * 8, i);
-		if (i >= sb->s_blocksize * 8) {
+		i = ext4_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
+		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			BUG_ON(free != 0);
 			break;
 		}
@@ -1744,7 +1736,7 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 	i = (i - le32_to_cpu(sbi->s_es->s_first_data_block))
 			% EXT4_BLOCKS_PER_GROUP(sb);
 
-	while (i < sb->s_blocksize * 8) {
+	while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
 		if (!mb_test_bit(i, bitmap)) {
 			max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
 			if (max >= sbi->s_stripe) {
@@ -1839,20 +1831,6 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			ac->ac_2order = i;
 	}
 
-	/* if stream allocation is enabled, use global goal */
-
-	/* FIXME!!
-	 * Need more explanation on what it is and how stream
-	 * allocation is represented by the below conditional
-	 */
-	if ((ac->ac_g_ex.fe_len < sbi->s_mb_large_req) &&
-			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
-		/* TBD: may be hot point */
-		spin_lock(&sbi->s_md_lock);
-		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
-		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
-		spin_unlock(&sbi->s_md_lock);
-	}
 
 	group = ac->ac_g_ex.fe_group;
 
@@ -2291,7 +2269,8 @@ static void ext4_mb_history_init(struct super_block *sb)
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
 	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
-	memset(sbi->s_mb_history, 0, i);
+	if (likely(sbi->s_mb_history != NULL))
+		memset(sbi->s_mb_history, 0, i);
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2300,7 +2279,7 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_mb_history h;
 
-	if (likely(sbi->s_mb_history == NULL))
+	if (unlikely(sbi->s_mb_history == NULL))
 		return;
 
 	if (!(ac->ac_op & sbi->s_mb_history_filter))
@@ -2312,11 +2291,6 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 	h.orig = ac->ac_o_ex;
 	h.result = ac->ac_b_ex;
 	h.flags = ac->ac_flags;
-	h.found = ac->ac_found;
-	h.groups = ac->ac_groups_scanned;
-	h.cr = ac->ac_criteria;
-	h.tail = ac->ac_tail;
-	h.buddy = ac->ac_buddy;
 	h.merged = 0;
 	if (ac->ac_op == EXT4_MB_HISTORY_ALLOC) {
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&
@@ -2404,6 +2378,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 				"EXT4-fs: can't read descriptor %lu\n", i);
 			goto err_freebuddy;
 		}
+		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
@@ -2512,32 +2487,10 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
 	sbi->s_mb_max_groups_to_scan = MB_DEFAULT_MAX_GROUPS_TO_SCAN;
 	sbi->s_mb_stats = MB_DEFAULT_STATS;
+	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
 
-	sbi->s_mb_prealloc_table_size = 7;
-	i = sbi->s_mb_prealloc_table_size;
-	sbi->s_mb_prealloc_table = kmalloc(sizeof(unsigned long) * i,
-						GFP_NOFS);
-	if (sbi->s_mb_prealloc_table == NULL) {
-		clear_opt(sbi->s_mount_opt, MBALLOC);
-		kfree(sbi->s_mb_offsets);
-		kfree(sbi->s_mb_maxs);
-		return -ENOMEM;
-	}
-
-	sbi->s_mb_prealloc_table[0] = 4;
-	sbi->s_mb_prealloc_table[1] = 8;
-	sbi->s_mb_prealloc_table[2] = 16;
-	sbi->s_mb_prealloc_table[3] = 32;
-	sbi->s_mb_prealloc_table[4] = 64;
-	sbi->s_mb_prealloc_table[5] = 128;
-	sbi->s_mb_prealloc_table[6] = 256;
-
-	sbi->s_mb_small_req = 256;
-	sbi->s_mb_large_req = 1024;
-	sbi->s_mb_group_prealloc = 512;
-
 	i = sizeof(struct ext4_locality_group) * NR_CPUS;
 	sbi->s_locality_groups = kmalloc(i, GFP_NOFS);
 	if (sbi->s_locality_groups == NULL) {
@@ -2713,75 +2666,9 @@ static void ext4_mb_free_committed_blocks(struct super_block *sb)
 #define EXT4_MB_MAX_TO_SCAN_NAME	"max_to_scan"
 #define EXT4_MB_MIN_TO_SCAN_NAME	"min_to_scan"
 #define EXT4_MB_ORDER2_REQ		"order2_req"
-#define EXT4_MB_SMALL_REQ		"small_req"
-#define EXT4_MB_LARGE_REQ		"large_req"
-#define EXT4_MB_PREALLOC_TABLE		"prealloc_table"
-#define EXT4_MB_GROUP_PREALLOC		"group_prealloc"
-
-static int ext4_mb_read_prealloc_table(char *page, char **start,
-			off_t off, int count, int *eof, void *data)
-{
-	struct ext4_sb_info *sbi = data;
-	int len = 0;
-	int i;
-
-	*eof = 1;
-	if (off != 0)
-		return 0;
-	for (i = 0; i < sbi->s_mb_prealloc_table_size; i++)
-		len += sprintf(page + len, "%ld ",
-				sbi->s_mb_prealloc_table[i]);
-	len += sprintf(page + len, "\n");
-	*start = page;
-	return len;
-}
-
-static int ext4_mb_write_prealloc_table(struct file *file,
-			const char __user *buf, unsigned long cnt, void *data)
-{
-	struct ext4_sb_info *sbi = data;
-	unsigned long value;
-	unsigned long prev = 0;
-	char str[128];
-	char *cur;
-	char *end;
-	unsigned long *new_table;
-	int num = 0;
-	int i = 0;
-
-	if (cnt >= sizeof(str))
-		return -EINVAL;
-	if (copy_from_user(str, buf, cnt))
-		return -EFAULT;
+#define EXT4_MB_STREAM_REQ		"stream_req"
 
-	num = 0;
-	cur = str;
-	end = str + cnt;
-	while (cur < end) {
-		while ((cur < end) && (*cur == ' ')) cur++;
-		value = simple_strtol(cur, &cur, 0);
-		if (value == 0)
-			break;
-		if (value <= prev)
-			return -EINVAL;
-		prev = value;
-		num++;
-	}
 
-	new_table = kmalloc(num * sizeof(*new_table), GFP_KERNEL);
-	if (new_table == NULL)
-		return -ENOMEM;
-	kfree(sbi->s_mb_prealloc_table);
-	sbi->s_mb_prealloc_table = new_table;
-	sbi->s_mb_prealloc_table_size = num;
-	cur = str;
-	end = str + cnt;
-	while (cur < end && i < num) {
-		while ((cur < end) && (*cur == ' ')) cur++;
-		new_table[i++] = simple_strtol(cur, &cur, 0);
-	}
-	return cnt;
-}
 
 #define MB_PROC_VALUE_READ(name)				\
 static int ext4_mb_read_##name(char *page, char **start,	\
@@ -2823,12 +2710,8 @@ MB_PROC_VALUE_READ(min_to_scan);
 MB_PROC_VALUE_WRITE(min_to_scan);
 MB_PROC_VALUE_READ(order2_reqs);
 MB_PROC_VALUE_WRITE(order2_reqs);
-MB_PROC_VALUE_READ(small_req);
-MB_PROC_VALUE_WRITE(small_req);
-MB_PROC_VALUE_READ(large_req);
-MB_PROC_VALUE_WRITE(large_req);
-MB_PROC_VALUE_READ(group_prealloc);
-MB_PROC_VALUE_WRITE(group_prealloc);
+MB_PROC_VALUE_READ(stream_request);
+MB_PROC_VALUE_WRITE(stream_request);
 
 #define	MB_PROC_HANDLER(name, var)					\
 do {									\
@@ -2857,18 +2740,13 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
 	MB_PROC_HANDLER(EXT4_MB_MIN_TO_SCAN_NAME, min_to_scan);
 	MB_PROC_HANDLER(EXT4_MB_ORDER2_REQ, order2_reqs);
-	MB_PROC_HANDLER(EXT4_MB_SMALL_REQ, small_req);
-	MB_PROC_HANDLER(EXT4_MB_LARGE_REQ, large_req);
-	MB_PROC_HANDLER(EXT4_MB_PREALLOC_TABLE, prealloc_table);
-	MB_PROC_HANDLER(EXT4_MB_GROUP_PREALLOC, group_prealloc);
+	MB_PROC_HANDLER(EXT3_MB_STREAM_REQ, stream_request);
 
 	return 0;
 
 err_out:
-	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_PREALLOC_TABLE, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_LARGE_REQ, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_SMALL_REQ, sbi->s_mb_proc);
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", name);
+	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MIN_TO_SCAN_NAME, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MAX_TO_SCAN_NAME, sbi->s_mb_proc);
@@ -2889,10 +2767,7 @@ static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 
 	snprintf(devname, sizeof(devname) - 1, "%s",
 		bdevname(sb->s_bdev, devname));
-	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_PREALLOC_TABLE, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_SMALL_REQ, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_LARGE_REQ, sbi->s_mb_proc);
+	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MIN_TO_SCAN_NAME, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MAX_TO_SCAN_NAME, sbi->s_mb_proc);
@@ -3035,7 +2910,11 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg = ac->ac_lg;
 
 	BUG_ON(lg == NULL);
-	ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
+	if (EXT4_SB(sb)->s_stripe)
+		ac->ac_g_ex.fe_len = EXT3_SB(sb)->s_stripe;
+	else
+		ac->ac_g_ex.fe_len = (1024 * 1024) >> sb->s_blocksize_bits;
+
 	mb_debug("#%u: goal %lu blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
@@ -3085,34 +2964,50 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		size = i_size_read(ac->ac_inode);
 	size = (size + ac->ac_sb->s_blocksize - 1) >> bsbits;
 
-	start = 0;
-	wind = 0;
+	/* max available blocks in a free group */
+	max = EXT3_BLOCKS_PER_GROUP(ac->ac_sb) - 1 - 1
+		- EXT3_SB(ac->ac_sb)->s_itb_per_group;
 
-	/* let's choose preallocation window depending on file size */
-	for (i = 0; i < sbi->s_mb_prealloc_table_size; i++) {
-		if (size <= sbi->s_mb_prealloc_table[i]) {
-			wind = sbi->s_mb_prealloc_table[i];
-			break;
-		}
-	}
-	size = wind;
-
-	if (wind == 0) {
-		__u64 tstart, tend;
-		/* file is quite large, we now preallocate with
-		 * the biggest configured window with regart to
-		 * logical offset */
-		wind = sbi->s_mb_prealloc_table[i - 1];
-		tstart = ac->ac_o_ex.fe_logical;
-		do_div(tstart, wind);
-		start = tstart * wind;
-		tend = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len - 1;
-		do_div(tend, wind);
-		tend = tend * wind + wind;
-		size = tend - start;
+#define NRL_CHECK_SIZE(req,size,max,bits)	\
+		(req <= (size) || max <= ((size) >> bits))
+
+	/* first, try to predict filesize */
+	/* XXX: should this table be tunable? */
+	start = 0;
+	if (size <= 16 * 1024) {
+		size = 16 * 1024;
+	} else if (size <= 32 * 1024) {
+		size = 32 * 1024;
+	} else if (size <= 64 * 1024) {
+		size = 64 * 1024;
+	} else if (size <= 128 * 1024) {
+		size = 128 * 1024;
+	} else if (size <= 256 * 1024) {
+		size = 256 * 1024;
+	} else if (size <= 512 * 1024) {
+		size = 512 * 1024;
+	} else if (size <= 1024 * 1024) {
+		size = 1024 * 1024;
+	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
+		start = ac->ac_o_ex.fe_logical << bsbits;
+		start = (start / (1024 * 1024)) * (1024 * 1024);
+		size = 1024 * 1024;
+	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
+		start = ac->ac_o_ex.fe_logical << bsbits;
+		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
+		size = 4 * 1024 * 1024;
+	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
+		start = ac->ac_o_ex.fe_logical;
+		start = start << bsbits;
+		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
+		size = 8 * 1024 * 1024;
+	} else {
+		start = ac->ac_o_ex.fe_logical;
+		start = start << bsbits;
+		size = ac->ac_o_ex.fe_len << bsbits;
 	}
-	orig_size = size;
-	orig_start = start;
+	orig_size = size = size >> bsbits;
+	orig_start = start = start >> bsbits;
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
@@ -3203,22 +3098,6 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	ac->ac_g_ex.fe_logical = start;
 	ac->ac_g_ex.fe_len = size;
 
-	/* define goal start in order to merge */
-	if (ar->pright && (ar->lright == (start + size))) {
-		/* merge to the right */
-		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
-		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
-	}
-	if (ar->pleft && (ar->lleft + 1 == start)) {
-		/* merge to the left */
-		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
-		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
-	}
-
 	mb_debug("goal: %u(was %u) blocks at %u\n", (unsigned) size,
 		(unsigned) orig_size, (unsigned) start);
 }
@@ -3395,8 +3274,10 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					     &groupnr, &start);
 		len = pa->pa_len;
 		spin_unlock(&pa->pa_lock);
+		if (unlikely(len == 0))
+			continue;
 		BUG_ON(groupnr != group);
-		mb_set_bits(bitmap, start, len);
+		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group), bitmap, start, len);
 		preallocated += len;
 		count++;
 	}
@@ -3425,7 +3306,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 
 	/* in this short window concurrent discard can set pa_deleted */
 	spin_lock(&pa->pa_lock);
-	if (pa->pa_deleted == 1) {
+	if (pa->pa_deleted == 0) {
 		spin_unlock(&pa->pa_lock);
 		return;
 	}
@@ -3641,7 +3522,7 @@ static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group);
+	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	end = bit + pa->pa_len;
 
 	ac.ac_sb = sb;
@@ -3696,7 +3577,7 @@ static int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group);
+	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
 	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 
@@ -3997,19 +3878,19 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	int bsbits = ac->ac_sb->s_blocksize_bits;
+	loff_t size, isize;
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
 
-	/* request is so large that we don't care about
-	 * streaming - it overweights any possible seek */
-	if (ac->ac_o_ex.fe_len >= sbi->s_mb_large_req)
-		return;
+	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
+	isize = i_size_read(ac->ac_inode) >> bsbits;
+	if (size < isize)
+		size = isize;
 
-	/* FIXME!!
-	 * is this  >=  considering the above ?
-	 */
-	if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)
+	/* don't use group allocation for large files */
+	if (size >= sbi->s_mb_stream_request)
 		return;
 
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
@@ -4419,7 +4300,8 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
-	mb_clear_bits(bitmap_bh->b_data, bit, count);
+	mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+			bit, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 85100ea..4d4ad18 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -107,19 +107,12 @@ struct ext4_sb_info {
 	/* tunables */
 	unsigned long s_mb_factor;
 	unsigned long s_stripe;
-	unsigned long s_mb_small_req;
-	unsigned long s_mb_large_req;
+	unsigned long s_mb_stream_request;
 	unsigned long s_mb_max_to_scan;
 	unsigned long s_mb_min_to_scan;
 	unsigned long s_mb_max_groups_to_scan;
 	unsigned long s_mb_stats;
 	unsigned long s_mb_order2_reqs;
-	unsigned long *s_mb_prealloc_table;
-	unsigned long s_mb_prealloc_table_size;
-	unsigned long s_mb_group_prealloc;
-	/* where last allocation was done - for stream allocation */
-	unsigned long s_mb_last_group;
-	unsigned long s_mb_last_start;
 
 	/* history to debug policy */
 	struct ext4_mb_history *s_mb_history;
