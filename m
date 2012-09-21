From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH V2] ext4: speed-up releasing blocks on commit
Date: Fri, 21 Sep 2012 00:11:19 -0400
Message-ID: <20120921041119.GA4310@qrxd43-motbuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:51619 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2IUEL1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 00:11:27 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.176.129.42])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q8L42L2o002174
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 00:02:21 -0400 (EDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com [209.85.216.174])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q8L42KK6002171
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 00:02:21 -0400 (EDT)
Received: by qcro28 with SMTP id o28so2302551qcr.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 21:11:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Improve mb_free_blocks speed by clearing bits all at once instead of going one by one.
Rebuild buddy bitmap by going up only once per range instead of once per block.
For example, for 60G file commit callback time drops from 2.7s to 5ms.
This is especially good for non-preemptive kernels as there is no rescheduling during release.

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>

---
 mballoc.c |  197 ++++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 136 insertions(+), 61 deletions(-)

Index: linux-3.6-rc6/fs/ext4/mballoc.c
===================================================================
--- linux-3.6-rc6.orig/fs/ext4/mballoc.c	2012-09-20 23:35:41.608663578 -0400
+++ linux-3.6-rc6/fs/ext4/mballoc.c	2012-09-20 23:36:00.816190042 -0400
@@ -397,6 +397,12 @@ static inline void mb_clear_bit(int bit,
 	ext4_clear_bit(bit, addr);
 }
 
+static inline int mb_test_and_clear_bit(int bit, void *addr)
+{
+	addr = mb_correct_addr_and_bit(&bit, addr);
+	return ext4_test_and_clear_bit(bit, addr);
+}
+
 static inline int mb_find_next_zero_bit(void *addr, int max, int start)
 {
 	int fix = 0, ret, tmpmax;
@@ -756,6 +762,24 @@ void ext4_mb_generate_buddy(struct super
 	spin_unlock(&EXT4_SB(sb)->s_bal_lock);
 }
 
+static void mb_regenerate_buddy(struct ext4_buddy *e4b)
+{
+	int count;
+	int order = 1;
+	void *buddy;
+
+	while ((buddy = mb_find_buddy(e4b, order++, &count))) {
+		ext4_set_bits(buddy, 0, count);
+	}
+	e4b->bd_info->bb_fragments = 0;
+	memset(e4b->bd_info->bb_counters, 0,
+		sizeof(*e4b->bd_info->bb_counters) *
+		(e4b->bd_sb->s_blocksize_bits + 2));
+
+	ext4_mb_generate_buddy(e4b->bd_sb, e4b->bd_buddy,
+		e4b->bd_bitmap, e4b->bd_group);
+}
+
 /* The buddy information is attached the buddy cache inode
  * for convenience. The information regarding each group
  * is loaded via ext4_mb_load_buddy. The information involve
@@ -1236,6 +1260,33 @@ static void mb_clear_bits(void *bm, int
 	}
 }
 
+/* clear bits in given range
+ * will return first found zero bit if any, -1 otherwise
+ */
+static int mb_test_and_clear_bits(void *bm, int cur, int len)
+{
+	__u32 *addr;
+	int zero_bit = -1;
+
+	len = cur + len;
+	while (cur < len) {
+		if ((cur & 31) == 0 && (len - cur) >= 32) {
+			/* fast path: clear whole word at once */
+			addr = bm + (cur >> 3);
+			if (*addr != (__u32)(-1) && zero_bit == -1)
+				zero_bit = cur + mb_find_next_zero_bit(addr, 32, 0);
+			*addr = 0;
+			cur += 32;
+			continue;
+		}
+		if (!mb_test_and_clear_bit(cur, bm) && zero_bit == -1)
+			zero_bit = cur;
+		cur++;
+	}
+
+	return zero_bit;
+}
+
 void ext4_set_bits(void *bm, int cur, int len)
 {
 	__u32 *addr;
@@ -1254,17 +1305,57 @@ void ext4_set_bits(void *bm, int cur, in
 	}
 }
 
+static inline int mb_buddy_adjust_border(int* bit, void* bitmap, int side)
+{
+	if (mb_test_bit(*bit + side, bitmap)) {
+		mb_clear_bit(*bit, bitmap);
+		(*bit) -= side;
+		return 1;
+	}
+	else {
+		mb_set_bit(*bit += side, bitmap);
+		return -1;
+	}
+}
+
+static void mb_buddy_mark_free(struct ext4_buddy *e4b, int first, int last)
+{
+	int max;
+	int order = 1;
+	void *buddy = mb_find_buddy(e4b, order, &max);
+
+	while (buddy) {
+		void *buddy2;
+
+		if (first & 1)
+			e4b->bd_info->bb_counters[order] += mb_buddy_adjust_border(&first, buddy, -1);
+		if (!(last & 1))
+			e4b->bd_info->bb_counters[order] += mb_buddy_adjust_border(&last, buddy, 1);
+		if (first > last)
+			break;
+		order++;
+
+		if (first == last || !(buddy2 = mb_find_buddy(e4b, order, &max))) {
+			mb_clear_bits(buddy, first, last - first + 1);
+			e4b->bd_info->bb_counters[order - 1] += last - first + 1;
+			break;
+		}
+		first >>= 1;
+		last >>= 1;
+		buddy = buddy2;
+	}
+}
+
 static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
-	int block = 0;
-	int max = 0;
-	int order;
-	void *buddy;
-	void *buddy2;
+	int left_is_free = 0;
+	int right_is_free = 0;
+	int block;
+	int last = first + count - 1;
 	struct super_block *sb = e4b->bd_sb;
 
-	BUG_ON(first + count > (sb->s_blocksize << 3));
+	BUG_ON(last >= (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
@@ -1273,67 +1364,51 @@ static void mb_free_blocks(struct inode
 	if (first < e4b->bd_info->bb_first_free)
 		e4b->bd_info->bb_first_free = first;
 
-	/* let's maintain fragments counter */
+	/* access memory sequentially: check left neighbour,
+	 * clear range and then check right neighbour
+	 */
 	if (first != 0)
-		block = !mb_test_bit(first - 1, e4b->bd_bitmap);
-	if (first + count < EXT4_SB(sb)->s_mb_maxs[0])
-		max = !mb_test_bit(first + count, e4b->bd_bitmap);
-	if (block && max)
+		left_is_free = !mb_test_bit(first - 1, e4b->bd_bitmap);
+	block = mb_test_and_clear_bits(e4b->bd_bitmap, first, count);
+	if (last + 1 < EXT4_SB(sb)->s_mb_maxs[0])
+		right_is_free = !mb_test_bit(last + 1, e4b->bd_bitmap);
+
+	if (unlikely(block != -1)) {
+		ext4_fsblk_t blocknr;
+
+		blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
+		blocknr += EXT4_C2B(EXT4_SB(sb), block);
+		ext4_grp_locked_error(sb, e4b->bd_group,
+							inode ? inode->i_ino : 0,
+							blocknr,
+							"freeing already freed block "
+							"(bit %u)", block);
+		mb_regenerate_buddy(e4b);
+		goto done;
+	}
+
+	/* let's maintain fragments counter */
+	if (left_is_free && right_is_free)
 		e4b->bd_info->bb_fragments--;
-	else if (!block && !max)
+	else if (!left_is_free && !right_is_free)
 		e4b->bd_info->bb_fragments++;
 
-	/* let's maintain buddy itself */
-	while (count-- > 0) {
-		block = first++;
-		order = 0;
-
-		if (!mb_test_bit(block, e4b->bd_bitmap)) {
-			ext4_fsblk_t blocknr;
-
-			blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
-			blocknr += EXT4_C2B(EXT4_SB(sb), block);
-			ext4_grp_locked_error(sb, e4b->bd_group,
-					      inode ? inode->i_ino : 0,
-					      blocknr,
-					      "freeing already freed block "
-					      "(bit %u)", block);
-		}
-		mb_clear_bit(block, e4b->bd_bitmap);
-		e4b->bd_info->bb_counters[order]++;
-
-		/* start of the buddy */
-		buddy = mb_find_buddy(e4b, order, &max);
+	/* check if neighbours are to be coaleasced and
+	 * adjust bitmap bb_counters appropriately
+	 */
+	if (first & 1) {
+		first += !left_is_free;
+		e4b->bd_info->bb_counters[0] += left_is_free ? -1 : 1;
+	}
+	if (!(last & 1)) {
+		last -= !right_is_free;
+		e4b->bd_info->bb_counters[0] += right_is_free ? -1 : 1;
+	}
 
-		do {
-			block &= ~1UL;
-			if (mb_test_bit(block, buddy) ||
-					mb_test_bit(block + 1, buddy))
-				break;
-
-			/* both the buddies are free, try to coalesce them */
-			buddy2 = mb_find_buddy(e4b, order + 1, &max);
-
-			if (!buddy2)
-				break;
-
-			if (order > 0) {
-				/* for special purposes, we don't set
-				 * free bits in bitmap */
-				mb_set_bit(block, buddy);
-				mb_set_bit(block + 1, buddy);
-			}
-			e4b->bd_info->bb_counters[order]--;
-			e4b->bd_info->bb_counters[order]--;
+	if (first <= last)
+		mb_buddy_mark_free(e4b, first >> 1, last >> 1);
 
-			block = block >> 1;
-			order++;
-			e4b->bd_info->bb_counters[order]++;
