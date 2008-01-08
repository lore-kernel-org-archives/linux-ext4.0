From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mballoc update
Date: Tue, 8 Jan 2008 12:01:14 +0530
Message-ID: <20080108063114.GA6615@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36332 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755952AbYAHGbu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jan 2008 01:31:50 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m086VI5a017010
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 12:01:18 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m086VH4v1052778
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 12:01:18 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m086VHNG012985
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 06:31:17 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This is the update for mballoc patch. The changes are result of merging
with the lustre cvs version of mballoc. I liked this patch better because
it is simple. I also the updated the commit message. The update commit
message is also attached below. We only have one FIXME!! in the commit
message now to explain the inode buddy cache  allocator.

Let me know what you think.

This is not yet for patch queue. I will update the mballoc-core.patch
and send it the full patch later.

--- commit message ---

ext4: Add multi block allocator for ext4

From: Alex Tomas <alex@clusterfs.com>

The allocation request involve request for multiple number of
blocks near to the goal(block) value specified.

During initialization phase of the allocator we decide to use the group
preallocation or inode preallocation depending on the size file. The size of
the file could be the resulting file size we would have after allocation or
the current file size which ever is larger. If the size is less that
sbi->s_mb_stream_request we select the group preallocation. The default value
of s_mb_stream_request is 16 blocks. This can also be tuned via
/proc/fs/ext4/<partition>/stream_req. The value is represented in terms of
number of blocks.

The main motivation for having small file use group preallocation is to ensure
that we have small file closer in the disk.


First stage the allocator looks at the inode prealloc list
ext4_inode_info->i_prealloc_list contain list of prealloc
spaces for this particular inode. The inode prealloc space
is represented as
pa_lstart -> the logical start block for this prealloc space
pa_pstart -> the physical start block for this prealloc space
pa_len    -> lenght for this prealloc space
pa_free   ->  free space available in this prealloc space

The inode preallocation space is used looking at the _logical_
start block. If only the logical file block falls within the
range of prealloc space we will consume the particular prealloc
space. This make sure that that the we have contiguous physical
blocks representing the file blocks

The important thing to be noted in case of inode prealloc space
is that we don't modify the values associated to inode prealloc
space except pa_free.

If we are not able to find blocks in the inode prealloc space and if we have
the group allocation flag set then we look at the locality group prealloc
space. These are per CPU prealloc list represented as

ext4_sb_info.s_locality_groups[smp_processor_id()]

The reason for having a per cpu locality group is to reduce the contention
between CPUs. It is possible to get scheduled at this point.

The locality group prealloc space is used looking at whether we have
enough free space (pa_free) withing the prealloc space.

If we can't allocate blocks via inode prealloc or/and locality group prealloc
then we look at the buddy cache. The buddy cache is represented by
ext4_sb_info.s_buddy_cache (struct inode) whose file offset gets mapped to the
buddy and bitmap information regarding different groups. The buddy information
is attached to buddy cache inode so that we can access them through the page
cache. The information regarding each group is loaded via ext4_mb_load_buddy.
The information involve block bitmap and buddy information. The information are
stored in the inode as

 {                        page                        }
 [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...


one block each for bitmap and buddy information.
So for each group we take up 2 blocks. A page can
contain blocks_per_page (PAGE_CACHE_SIZE / blocksize)  blocks.
So it can have information regarding groups_per_page which
is blocks_per_page/2

Buddy cache inode is not stored on disk. The inode get
thrown away at the end when unmounting the disk.

We look for count number of blocks in the buddy cache. If
we were able to locate that many free blocks we return
with additional information regarding rest of the
contiguous physical block available


Before allocating blocks via buddy cache we normalize the request blocks. This
ensure we ask for more blocks that we needed. The extra blocks that we get
after allocation is added to the respective prealloc list. In case of inode
preallocation we follow a list of heuristics based on file size. This can be
found in ext4_mb_normalize_request. If we are doing a group prealloc we try to
normalize the request to sbi->s_mb_group_prealloc. Default value of
s_mb_group_prealloc is set to 512 blocks. This can be tuned via
/proc/fs/ext4/<partition/group_prealloc. The value is represented in terms of
number of blocks. If we have mounted the file system with -O stripe=<value>
option the group prealloc request is normalized to the stripe value (sbi->s_stripe)

/* FIXME!! explanation of how blocks are picked from buddy cache and the tunable
max_to_scan min_to_scan  order2_req */

Both the prealloc space are getting populated
as above. So for the first request we will hit the buddy cache
which will result in this prealloc space getting filled. The prealloc
space is then later used for the subsequent request.

--- code diff ----

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 58a70a1..1c47364 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -290,6 +290,8 @@
  * files smaller than MB_DEFAULT_STREAM_THRESHOLD are served
  * by the stream allocator, which purpose is to pack requests
  * as close each to other as possible to produce smooth I/O traffic
+ * We use locality group prealloc space for stream request.
+ * We can tune the same via /proc/fs/ext4/<parition>/stream_req
  */
 #define MB_DEFAULT_STREAM_THRESHOLD	16	/* 64K */
 
@@ -299,9 +301,9 @@
 #define MB_DEFAULT_ORDER2_REQS		2
 
 /*
- * default stripe size = 1MB
+ * default group prealloc size 512 blocks
  */
-#define MB_DEFAULT_STRIPE		256
+#define MB_DEFAULT_GROUP_PREALLOC	512
 
 static struct kmem_cache *ext4_pspace_cachep;
 
@@ -532,10 +534,10 @@ static inline void mb_set_bit(int bit, void *addr)
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
@@ -544,10 +546,10 @@ static inline void mb_clear_bit(int bit, void *addr)
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
@@ -1155,7 +1157,7 @@ static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
 	return 0;
 }
 
-static void mb_clear_bits(void *bm, int cur, int len)
+static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1168,12 +1170,12 @@ static void mb_clear_bits(void *bm, int cur, int len)
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
 
@@ -1186,7 +1188,7 @@ static void mb_set_bits(void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(cur, bm);
+		mb_set_bit_atomic(lock, cur, bm);
 		cur++;
 	}
 }
@@ -1403,7 +1405,8 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 		e4b->bd_info->bb_counters[ord]++;
 	}
 
-	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
+	mb_set_bits(sb_bgl_lock(EXT4_SB(e4b->bd_sb), ex->fe_group),
+			EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
 	mb_check_buddy(e4b);
 
 	return ret;
@@ -1509,8 +1512,8 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
-	BUG_ON(ex->fe_start >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
+	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
 	ac->ac_found++;
@@ -1702,8 +1705,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	i = e4b->bd_info->bb_first_free;
 
 	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
-		i = ext4_find_next_zero_bit(bitmap, sb->s_blocksize * 8, i);
-		if (i >= sb->s_blocksize * 8) {
+		i = ext4_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
+		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			BUG_ON(free != 0);
 			break;
 		}
@@ -1744,7 +1747,7 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 	i = (i - le32_to_cpu(sbi->s_es->s_first_data_block))
 			% EXT4_BLOCKS_PER_GROUP(sb);
 
-	while (i < sb->s_blocksize * 8) {
+	while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
 		if (!mb_test_bit(i, bitmap)) {
 			max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
 			if (max >= sbi->s_stripe) {
@@ -1812,9 +1815,11 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	ext4_group_t i;
 	int cr;
 	int err = 0;
+	int bsbits;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
+	loff_t size, isize;
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
@@ -1839,13 +1844,14 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			ac->ac_2order = i;
 	}
 
+	bsbits = ac->ac_sb->s_blocksize_bits;
 	/* if stream allocation is enabled, use global goal */
+	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
+	isize = i_size_read(ac->ac_inode) >> bsbits;
+	if (size < isize)
+		size = isize;
 
-	/* FIXME!!
-	 * Need more explanation on what it is and how stream
-	 * allocation is represented by the below conditional
-	 */
-	if ((ac->ac_g_ex.fe_len < sbi->s_mb_large_req) &&
+	if (size < sbi->s_mb_stream_request &&
 			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
 		/* TBD: may be hot point */
 		spin_lock(&sbi->s_md_lock);
@@ -2291,7 +2297,8 @@ static void ext4_mb_history_init(struct super_block *sb)
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
 	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
-	memset(sbi->s_mb_history, 0, i);
+	if (likely(sbi->s_mb_history != NULL))
+		memset(sbi->s_mb_history, 0, i);
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2300,7 +2307,7 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_mb_history h;
 
-	if (likely(sbi->s_mb_history == NULL))
+	if (unlikely(sbi->s_mb_history == NULL))
 		return;
 
 	if (!(ac->ac_op & sbi->s_mb_history_filter))
@@ -2404,6 +2411,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 				"EXT4-fs: can't read descriptor %lu\n", i);
 			goto err_freebuddy;
 		}
+		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
@@ -2510,39 +2518,16 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 
 	sbi->s_mb_max_to_scan = MB_DEFAULT_MAX_TO_SCAN;
 	sbi->s_mb_min_to_scan = MB_DEFAULT_MIN_TO_SCAN;
-	sbi->s_mb_max_groups_to_scan = MB_DEFAULT_MAX_GROUPS_TO_SCAN;
 	sbi->s_mb_stats = MB_DEFAULT_STATS;
+	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
-
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
+	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
 
 	i = sizeof(struct ext4_locality_group) * NR_CPUS;
 	sbi->s_locality_groups = kmalloc(i, GFP_NOFS);
 	if (sbi->s_locality_groups == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
-		kfree(sbi->s_mb_prealloc_table);
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
 		return -ENOMEM;
@@ -2713,75 +2698,10 @@ static void ext4_mb_free_committed_blocks(struct super_block *sb)
 #define EXT4_MB_MAX_TO_SCAN_NAME	"max_to_scan"
 #define EXT4_MB_MIN_TO_SCAN_NAME	"min_to_scan"
 #define EXT4_MB_ORDER2_REQ		"order2_req"
-#define EXT4_MB_SMALL_REQ		"small_req"
-#define EXT4_MB_LARGE_REQ		"large_req"
-#define EXT4_MB_PREALLOC_TABLE		"prealloc_table"
+#define EXT4_MB_STREAM_REQ		"stream_req"
 #define EXT4_MB_GROUP_PREALLOC		"group_prealloc"
 
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
-
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
-
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
@@ -2823,10 +2743,8 @@ MB_PROC_VALUE_READ(min_to_scan);
 MB_PROC_VALUE_WRITE(min_to_scan);
 MB_PROC_VALUE_READ(order2_reqs);
 MB_PROC_VALUE_WRITE(order2_reqs);
-MB_PROC_VALUE_READ(small_req);
-MB_PROC_VALUE_WRITE(small_req);
-MB_PROC_VALUE_READ(large_req);
-MB_PROC_VALUE_WRITE(large_req);
+MB_PROC_VALUE_READ(stream_request);
+MB_PROC_VALUE_WRITE(stream_request);
 MB_PROC_VALUE_READ(group_prealloc);
 MB_PROC_VALUE_WRITE(group_prealloc);
 
@@ -2857,18 +2775,15 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
 	MB_PROC_HANDLER(EXT4_MB_MIN_TO_SCAN_NAME, min_to_scan);
 	MB_PROC_HANDLER(EXT4_MB_ORDER2_REQ, order2_reqs);
-	MB_PROC_HANDLER(EXT4_MB_SMALL_REQ, small_req);
-	MB_PROC_HANDLER(EXT4_MB_LARGE_REQ, large_req);
-	MB_PROC_HANDLER(EXT4_MB_PREALLOC_TABLE, prealloc_table);
+	MB_PROC_HANDLER(EXT4_MB_STREAM_REQ, stream_request);
 	MB_PROC_HANDLER(EXT4_MB_GROUP_PREALLOC, group_prealloc);
 
 	return 0;
 
 err_out:
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_PREALLOC_TABLE, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_LARGE_REQ, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_SMALL_REQ, sbi->s_mb_proc);
+	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MIN_TO_SCAN_NAME, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MAX_TO_SCAN_NAME, sbi->s_mb_proc);
@@ -2890,9 +2805,7 @@ static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 	snprintf(devname, sizeof(devname) - 1, "%s",
 		bdevname(sb->s_bdev, devname));
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_PREALLOC_TABLE, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_SMALL_REQ, sbi->s_mb_proc);
-	remove_proc_entry(EXT4_MB_LARGE_REQ, sbi->s_mb_proc);
+	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MIN_TO_SCAN_NAME, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_MAX_TO_SCAN_NAME, sbi->s_mb_proc);
@@ -2996,8 +2909,8 @@ static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
-		    ac->ac_b_ex.fe_len);
+	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
+				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
 
 	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -3027,6 +2940,10 @@ out_err:
 
 /*
  * here we normalize request for locality group
+ * Group request are normalized to s_strip size if we set the same via mount
+ * option. If not we set it to s_mb_group_prealloc which can be configured via
+ * /proc/fs/ext4/<partition>/group_prealloc
+ *
  * XXX: should we try to preallocate more than the group has now?
  */
 static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
@@ -3035,7 +2952,10 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg = ac->ac_lg;
 
 	BUG_ON(lg == NULL);
-	ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
+	if (EXT4_SB(sb)->s_stripe)
+		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
+	else
+		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
 	mb_debug("#%u: goal %lu blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
@@ -3047,14 +2967,12 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
-	unsigned long wind;
-	int bsbits, i;
+	int bsbits, max;
 	ext4_lblk_t end;
 	struct list_head *cur;
 	loff_t size, orig_size;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
-	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
 	/* do normalize only data requests, metadata requests
 	   do not need preallocation */
@@ -3083,36 +3001,51 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	size = size << bsbits;
 	if (size < i_size_read(ac->ac_inode))
 		size = i_size_read(ac->ac_inode);
-	size = (size + ac->ac_sb->s_blocksize - 1) >> bsbits;
 
-	start = 0;
-	wind = 0;
+	/* max available blocks in a free group */
+	max = EXT4_BLOCKS_PER_GROUP(ac->ac_sb) - 1 - 1 -
+				EXT4_SB(ac->ac_sb)->s_itb_per_group;
 
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
@@ -3395,8 +3328,10 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
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
@@ -3641,7 +3576,7 @@ static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group);
+	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	end = bit + pa->pa_len;
 
 	ac.ac_sb = sb;
@@ -3696,7 +3631,7 @@ static int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
-	BUG_ON(group != e4b->bd_group);
+	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
 	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
 
@@ -3989,27 +3924,29 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 #endif
 }
 
-/* FIXME!!
- * Need comment explaining when we look at locality group
- * based allocation
+/*
+ * We use locality group preallocation for small size file. The size of the
+ * file is determined by the current size or the resulting size after
+ * allocation which ever is larger
+ *
+ * One can tune this size via /proc/fs/ext4/<partition>/stream_req
  */
-
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
@@ -4419,7 +4356,8 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
-	mb_clear_bits(bitmap_bh->b_data, bit, count);
+	mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
+			bit, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 85100ea..3bc6583 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -105,17 +105,12 @@ struct ext4_sb_info {
 	unsigned short *s_mb_offsets, *s_mb_maxs;
 
 	/* tunables */
-	unsigned long s_mb_factor;
 	unsigned long s_stripe;
-	unsigned long s_mb_small_req;
-	unsigned long s_mb_large_req;
+	unsigned long s_mb_stream_request;
 	unsigned long s_mb_max_to_scan;
 	unsigned long s_mb_min_to_scan;
-	unsigned long s_mb_max_groups_to_scan;
 	unsigned long s_mb_stats;
 	unsigned long s_mb_order2_reqs;
-	unsigned long *s_mb_prealloc_table;
-	unsigned long s_mb_prealloc_table_size;
 	unsigned long s_mb_group_prealloc;
 	/* where last allocation was done - for stream allocation */
 	unsigned long s_mb_last_group;
