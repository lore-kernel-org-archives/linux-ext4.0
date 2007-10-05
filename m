From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc BUG fix/workaround
Date: Fri, 05 Oct 2007 10:32:12 +0530
Message-ID: <4705C554.20903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50772 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXJEFC6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2007 01:02:58 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9552sJC010386
	for <linux-ext4@vger.kernel.org>; Fri, 5 Oct 2007 15:02:54 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9556RN5282430
	for <linux-ext4@vger.kernel.org>; Fri, 5 Oct 2007 15:06:27 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9550042011508
	for <linux-ext4@vger.kernel.org>; Fri, 5 Oct 2007 15:00:01 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> 
> 
> 
>> 115908 | fsstress--2.6.23-rc9--ppc64 | f | gekko-lp4 |
>>       http://abat.linux.ibm.com/abat-repo/logs/115908-avmathur@us.ibm.com
>>
> 
> Same here
> EXT4-fs: mballoc enabled
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/mballoc.c:1607!
> cpu 0x0: Vector: 700 (Program Check) at [c00000003e202c50]
>    pc: c0000000001a4ef4: .ext4_mb_new_blocks+0xe94/0x18f4
>    lr: c0000000001a4ed8: .ext4_mb_new_blocks+0xe78/0x18f4
>    sp: c00000003e202ed0
>   msr: 8000000000029032
>  current = 0xc00000002786a000
>  paca    = 0xc0000000005b2580
>    pid   = 10651, comm = fsstress
> kernel BUG at fs/ext4/mballoc.c:1607!
> enter ? for help
> [c00000003e202ed0] c0000000001a4d28 .ext4_mb_new_blocks+0xcc8/0x18f4 
> (unreliable)
> [c00000003e203160] c00000000019c258 .ext4_ext_get_blocks+0x5a8/0x774
> [c00000003e2032b0] c000000000189d8c .ext4_da_get_block_write+0xd4/0x234
> [c00000003e203370] c0000000001138b8 .mpage_da_map_blocks+0xc8/0x348
> [c00000003e203540] c000000000113dfc .mpage_da_writepages+0x80/0xa4
> [c00000003e203650] c000000000185218 .ext4_da_writepages+0x1c/0x34
> [c00000003e2036d0] c0000000000a7598 .do_writepages+0x74/0xac
> [c00000003e203750] c00000000009dcd4 .__filemap_fdatawrite_range+0x9c/0xd0
> [c00000003e2038a0] c00000000009dd28 .filemap_fdatawrite+0x20/0x30
> [c00000003e203920] c00000000009e2e4 .filemap_write_and_wait+0x2c/0x68
> [c00000003e2039b0] c0000000000a0af4 .generic_file_direct_IO+0xc4/0x1b0
> [c00000003e203a70] c0000000000a1400 .generic_file_aio_read+0xa8/0x1c4
> [c00000003e203b50] c0000000000d7d68 .do_sync_read+0xd0/0x130
> [c00000003e203cf0] c0000000000d7efc .vfs_read+0x134/0x1f8
> [c00000003e203d90] c0000000000d8334 .sys_read+0x4c/0x8c
> [c00000003e203e30] c00000000000852c syscall_exit+0x0/0x40
> 
> 


After some debugging i have a work around. The problem is in one of the test/clear/set APIs
I am yet to findout what is going wrong. 


The request for a block result in us looking at the order 11 buddy entry which ad bb_counter == 1
While initialzing the buddy the order 11 had 1st  bit in the buddy bitmap cleared.



The bb_counter for order 11 is 1
 bit cleared is 1
 the address of buddy is c0000000f9b82ffc
 Cleared the bit 
 Test bit pass 
 ext4_find_next zero returned 0


3:mon> dr c0000000f9b82ffc
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3:mon>
3:mon> d c0000000f9b82ffc
c0000000f9b82ffc ffffffff00000000 0000000000000000  |................|
c0000000f9b8300c 0000000000000000 0000000000000000  |................|
c0000000f9b8301c 0000000000000000 0000000000000000  |................|
c0000000f9b8302c 0000000000000000 0000000000000000  |................|
3:mon>


But xmon shows it not cleared. But a subsequest ext4_test_bit passes. 

And when we fail we have 

The value of bb_counter is 1
The value of order  is 11
The value of k  is 16 and max is 16
The  bitmap addr is c0000000f9b82ffc


Since i was looking for a quick fix. I ported back the changes related the set/test/clear bits which i had
removed. With those changes the powerpc stands the fsx_linux, fs_inode and fsstress tests.

http://abat.linux.ibm.com/abat-repo/logs/116059-aneesh.kumar@in.ibm.com/

I would request to add the below attached patch to the patch queue 


We will keep it as a separate patch until we fix the  BUG.

# This series applies on GIT commit 3146b39c185f8a436d430132457e84fa1d8f8208
jbd_slab_cleanup.patch
jbd_GFP_NOFAIL_flag_cleanup.patch
jbd2-ext4-cleanups-convert-to-kzalloc.patch
jbd_to_jbd2_naming_cleanups.patch
jbd2-fix-commit-code-to-properly-abort-journal.patch
jbd2-debug-code-cleanup.patch
remove-obsolete-fragments.patch
remove-ifdef-config_ext4_index.patch
uninitialized-block-groups.patch
fix-sparse-warnings.patch
flex_bg-kernel-support-v2.patch
ext4_large_blocksize_support.patch
ext4_rec_len_overflow_with_64kblk_fix-v2.patch
ext2_large_blocksize_support.patch
ext3_large_blocksize_support.patch
ext2_rec_len_overflow_with_64kblk_fix-v2.patch
ext3_rec_len_overflow_with_64kblk_fix-v2.patch
ext4-convert_bg_block_bitmap_to_bg_block_bitmap_lo.patch
ext4-convert_bg_inode_bitmap_and_bg_inode_table.patch
ext4-convert_s_blocks_count_to_s_blocks_count_lo.patch
ext4-convert_s_r_blocks_count_and_s_free_blocks_count.patch
ext4-convert_ext4_extent.ee_start_to_ext4_extent.ee_start_lo.patch
ext4-convert_ext4_extent_idx.ei_leaf_to_ext4_extent_idx.ei_leaf_lo.patch
ext4-sparse-fix.patch
jbd-stats-through-procfs
ext4-journal_chksum-2.6.20.patch
ext4-journal-chksum-review-fix.patch
64-bit-i_version.patch
i_version_hi.patch
ext4_i_version_hi_2.patch
i_version_update_ext4.patch
delalloc-vfs.patch
delalloc-ext4.patch
ext-truncate-mutex.patch
ext3-4-migrate.patch
generic-find-next-le-bit
new-extent-function.patch
mballoc-core.patch
mballoc-bug-workaround.patch
jbd-blocks-reservation-fix-for-large-blk.patch
jbd2-blocks-reservation-fix-for-large-blk.patch
ext4_fix_setup_new_group_blocks_locking.patch
ext4_lighten_up_resize_transaction_requirements.patch


-------------------------

Workaround for mballoc BUG on powerpc.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This patch adds some of the code removed. The changes
fixes the BUG on powerpc with mballoc. Untill we fix
the problem this should enable us to run  the patch
queue on powerpc.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/mballoc.c |  161 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 121 insertions(+), 40 deletions(-)


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4409c0c..79a3530 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -501,7 +501,88 @@ static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 	return block;
 }
 
-static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
+#if BITS_PER_LONG == 64
+#define mb_correct_addr_and_bit(bit, addr)		\
+{							\
+	bit += ((unsigned long) addr & 7UL) << 3;	\
+	addr = (void *) ((unsigned long) addr & ~7UL);	\
+}
+#elif BITS_PER_LONG == 32
+#define mb_correct_addr_and_bit(bit, addr)		\
+{							\
+	bit += ((unsigned long) addr & 3UL) << 3;	\
+	addr = (void *) ((unsigned long) addr & ~3UL);	\
+}
+#else
+#error "how many bits you are?!"
+#endif
+
+static inline int mb_test_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	return ext4_test_bit(bit, addr);
+}
+
+static inline void mb_set_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_set_bit(bit, addr);
+}
+
+static inline void mb_set_bit_atomic(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_set_bit_atomic(NULL, bit, addr);
+}
+
+static inline void mb_clear_bit(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_clear_bit(bit, addr);
+}
+
+static inline void mb_clear_bit_atomic(int bit, void *addr)
+{
+	mb_correct_addr_and_bit(bit, addr);
+	ext4_clear_bit_atomic(NULL, bit, addr);
+}
+
+static inline int mb_find_next_zero_bit(void *addr, int max, int start)
+{
+	int fix;
+#if BITS_PER_LONG == 64
+	fix = ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	fix = ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	max += fix;
+	start += fix;
+	return ext4_find_next_zero_bit(addr, max, start) - fix;
+}
+
+static inline int mb_find_next_bit(void *addr, int max, int start)
+{
+	int fix;
+#if BITS_PER_LONG == 64
+	fix = ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	fix = ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	max += fix;
+	start += fix;
+
+	return ext4_find_next_bit(addr, max, start) - fix;
+}
+
+static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
 
@@ -536,7 +617,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 		return;
 	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
-		if (!ext4_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
+		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
 			unsigned long blocknr;
 			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
 			blocknr += first + i;
@@ -548,7 +629,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
 		}
-		ext4_clear_bit(first + i, e4b->bd_info->bb_bitmap);
+		mb_clear_bit(first + i, e4b->bd_info->bb_bitmap);
 	}
 }
 
@@ -560,8 +641,8 @@ static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 		return;
 	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
-		BUG_ON(ext4_test_bit(first + i, e4b->bd_info->bb_bitmap));
-		ext4_set_bit(first + i, e4b->bd_info->bb_bitmap);
+		BUG_ON(mb_test_bit(first + i, e4b->bd_info->bb_bitmap));
+		mb_set_bit(first + i, e4b->bd_info->bb_bitmap);
 	}
 }
 
@@ -639,26 +720,26 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		count = 0;
 		for (i = 0; i < max; i++) {
 
-			if (ext4_test_bit(i, buddy)) {
+			if (mb_test_bit(i, buddy)) {
 				/* only single bit in buddy2 may be 1 */
-				if (!ext4_test_bit(i << 1, buddy2)) {
+				if (!mb_test_bit(i << 1, buddy2)) {
 					MB_CHECK_ASSERT(
-						ext4_test_bit((i<<1)+1, buddy2));
-				} else if (!ext4_test_bit((i << 1) + 1, buddy2)) {
+						mb_test_bit((i<<1)+1, buddy2));
+				} else if (!mb_test_bit((i << 1) + 1, buddy2)) {
 					MB_CHECK_ASSERT(
-						ext4_test_bit(i << 1, buddy2));
+						mb_test_bit(i << 1, buddy2));
 				}
 				continue;
 			}
 
 			/* both bits in buddy2 must be 0 */
-			MB_CHECK_ASSERT(ext4_test_bit(i << 1, buddy2));
-			MB_CHECK_ASSERT(ext4_test_bit((i << 1) + 1, buddy2));
+			MB_CHECK_ASSERT(mb_test_bit(i << 1, buddy2));
+			MB_CHECK_ASSERT(mb_test_bit((i << 1) + 1, buddy2));
 
 			for (j = 0; j < (1 << order); j++) {
 				k = (i * (1 << order)) + j;
 				MB_CHECK_ASSERT(
-					!ext4_test_bit(k, EXT4_MB_BITMAP(e4b)));
+					!mb_test_bit(k, EXT4_MB_BITMAP(e4b)));
 			}
 			count++;
 		}
@@ -669,7 +750,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	fstart = -1;
 	buddy = mb_find_buddy(e4b, 0, &max);
 	for (i = 0; i < max; i++) {
-		if (!ext4_test_bit(i, buddy)) {
+		if (!mb_test_bit(i, buddy)) {
 			MB_CHECK_ASSERT(i >= e4b->bd_info->bb_first_free);
 			if (fstart == -1) {
 				fragments++;
@@ -683,7 +764,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 			buddy2 = mb_find_buddy(e4b, j, &max2);
 			k = i >> j;
 			MB_CHECK_ASSERT(k < max2);
-			MB_CHECK_ASSERT(ext4_test_bit(k, buddy2));
+			MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
 		}
 	}
 	MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
@@ -698,7 +779,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		ext4_get_group_no_and_offset(sb, pa->pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->len; i++)
-			MB_CHECK_ASSERT(ext4_test_bit(k + i, buddy));
+			MB_CHECK_ASSERT(mb_test_bit(k + i, buddy));
 	}
 	return 0;
 }
@@ -757,7 +838,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 		/* mark multiblock chunks only */
 		grp->bb_counters[min]++;
 		if (min > 0)
-			ext4_clear_bit(first >> min,
+			mb_clear_bit(first >> min,
 				     buddy + sbi->s_mb_offsets[min]);
 
 		len -= chunk;
@@ -1095,7 +1176,7 @@ static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
 	bb = EXT4_MB_BUDDY(e4b);
 	while (order <= e4b->bd_blkbits + 1) {
 		block = block >> 1;
-		if (!ext4_test_bit(block, bb)) {
+		if (!mb_test_bit(block, bb)) {
 			/* this block is part of buddy of order 'order' */
 			return order;
 		}
@@ -1118,7 +1199,7 @@ static void mb_clear_bits(void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		ext4_clear_bit_atomic(NULL, cur, bm);
+		mb_clear_bit_atomic(cur, bm);
 		cur++;
 	}
 }
@@ -1136,7 +1217,7 @@ static void mb_set_bits(void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		ext4_set_bit_atomic(NULL, cur, bm);
+		mb_set_bit_atomic(cur, bm);
 		cur++;
 	}
 }
@@ -1162,9 +1243,9 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 
 	/* let's maintain fragments counter */
 	if (first != 0)
-		block = !ext4_test_bit(first - 1, EXT4_MB_BITMAP(e4b));
+		block = !mb_test_bit(first - 1, EXT4_MB_BITMAP(e4b));
 	if (first + count < EXT4_SB(sb)->s_mb_maxs[0])
-		max = !ext4_test_bit(first + count, EXT4_MB_BITMAP(e4b));
+		max = !mb_test_bit(first + count, EXT4_MB_BITMAP(e4b));
 	if (block && max)
 		e4b->bd_info->bb_fragments--;
 	else if (!block && !max)
@@ -1175,7 +1256,7 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 		block = first++;
 		order = 0;
 
-		if (!ext4_test_bit(block, EXT4_MB_BITMAP(e4b))) {
+		if (!mb_test_bit(block, EXT4_MB_BITMAP(e4b))) {
 			unsigned long blocknr;
 			blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
 			blocknr += block;
@@ -1187,7 +1268,7 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 				   inode ? inode->i_ino : 0, blocknr, block,
 				   e4b->bd_group);
 		}
-		ext4_clear_bit(block, EXT4_MB_BITMAP(e4b));
+		mb_clear_bit(block, EXT4_MB_BITMAP(e4b));
 		e4b->bd_info->bb_counters[order]++;
 
 		/* start of the buddy */
@@ -1195,8 +1276,8 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 
 		do {
 			block &= ~1UL;
-			if (ext4_test_bit(block, buddy) ||
-					ext4_test_bit(block + 1, buddy))
+			if (mb_test_bit(block, buddy) ||
+					mb_test_bit(block + 1, buddy))
 				break;
 
 			/* both the buddies are free, try to coalesce them */
@@ -1208,8 +1289,8 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			if (order > 0) {
 				/* for special purposes, we don't set
 				 * free bits in bitmap */
-				ext4_set_bit(block, buddy);
-				ext4_set_bit(block + 1, buddy);
+				mb_set_bit(block, buddy);
+				mb_set_bit(block + 1, buddy);
 			}
 			e4b->bd_info->bb_counters[order]--;
 			e4b->bd_info->bb_counters[order]--;
@@ -1218,7 +1299,7 @@ static int mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			order++;
 			e4b->bd_info->bb_counters[order]++;
 
-			ext4_clear_bit(block, buddy2);
+			mb_clear_bit(block, buddy2);
 			buddy = buddy2;
 		} while (1);
 	}
@@ -1241,7 +1322,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 	buddy = mb_find_buddy(e4b, order, &max);
 	BUG_ON(buddy == NULL);
 	BUG_ON(block >= max);
-	if (ext4_test_bit(block, buddy)) {
+	if (mb_test_bit(block, buddy)) {
 		ex->fe_len = 0;
 		ex->fe_start = 0;
 		ex->fe_group = 0;
@@ -1271,7 +1352,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 			break;
 
 		next = (block + 1) * (1 << order);
-		if (ext4_test_bit(next, EXT4_MB_BITMAP(e4b)))
+		if (mb_test_bit(next, EXT4_MB_BITMAP(e4b)))
 			break;
 
 		ord = mb_find_order_for_block(e4b, next);
@@ -1309,9 +1390,9 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 
 	/* let's maintain fragments counter */
 	if (start != 0)
-		mlen = !ext4_test_bit(start - 1, EXT4_MB_BITMAP(e4b));
+		mlen = !mb_test_bit(start - 1, EXT4_MB_BITMAP(e4b));
 	if (start + len < EXT4_SB(e4b->bd_sb)->s_mb_maxs[0])
-		max = !ext4_test_bit(start + len, EXT4_MB_BITMAP(e4b));
+		max = !mb_test_bit(start + len, EXT4_MB_BITMAP(e4b));
 	if (mlen && max)
 		e4b->bd_info->bb_fragments++;
 	else if (!mlen && !max)
@@ -1326,7 +1407,7 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 			mlen = 1 << ord;
 			buddy = mb_find_buddy(e4b, ord, &max);
 			BUG_ON((start >> ord) >= max);
-			ext4_set_bit(start >> ord, buddy);
+			mb_set_bit(start >> ord, buddy);
 			e4b->bd_info->bb_counters[ord]--;
 			start += mlen;
 			len -= mlen;
@@ -1341,14 +1422,14 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 		/* we have to split large buddy */
 		BUG_ON(ord <= 0);
 		buddy = mb_find_buddy(e4b, ord, &max);
-		ext4_set_bit(start >> ord, buddy);
+		mb_set_bit(start >> ord, buddy);
 		e4b->bd_info->bb_counters[ord]--;
 
 		ord--;
 		cur = (start >> ord) & ~1U;
 		buddy = mb_find_buddy(e4b, ord, &max);
-		ext4_clear_bit(cur, buddy);
-		ext4_clear_bit(cur + 1, buddy);
+		mb_clear_bit(cur, buddy);
+		mb_clear_bit(cur + 1, buddy);
 		e4b->bd_info->bb_counters[ord]++;
 		e4b->bd_info->bb_counters[ord]++;
 	}
@@ -1694,7 +1775,7 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 			% EXT4_BLOCKS_PER_GROUP(sb);
 
 	while (i < sb->s_blocksize * 8) {
-		if (!ext4_test_bit(i, bitmap)) {
+		if (!mb_test_bit(i, bitmap)) {
 			max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
 			if (max >= sbi->s_stripe) {
 				ac->ac_found++;
@@ -2930,7 +3011,7 @@ static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	{
 		int i;
 		for (i = 0; i < ac->ac_b_ex.fe_len; i++) {
-			BUG_ON(ext4_test_bit(ac->ac_b_ex.fe_start + i,
+			BUG_ON(mb_test_bit(ac->ac_b_ex.fe_start + i,
 						bitmap_bh->b_data));
 		}
 	}
@@ -4352,7 +4433,7 @@ do_more:
 	{
 		int i;
 		for (i = 0; i < count; i++)
-			BUG_ON(!ext4_test_bit(bit + i, bitmap_bh->b_data));
+			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
 	mb_clear_bits(bitmap_bh->b_data, bit, count);
