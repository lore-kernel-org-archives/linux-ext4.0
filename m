From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH RFC 2/2] ext4: speed-up releasing blocks on commit
Date: Tue, 18 Sep 2012 01:00:58 +0400
Message-ID: <CAA0+VHwvmr5Pi+86tcEsZ7L8gE30UdwivBTFy0_Q8bEgxw_uqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:50208 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab2IQWEv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 18:04:51 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8HL3EAK002810
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 17:03:14 -0400 (EDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com [209.85.216.174])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8HL2klC002386
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 17:03:14 -0400 (EDT)
Received: by mail-qc0-f174.google.com with SMTP id o28so4854039qcr.19
        for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:00:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Improve mb_free_blocks speed by clearing bits all at once instead of
going one by one. Rebuild buddy bitmap by going up only once per range
instead of once per block.
This algorithm relies on buddy bitmap to be correct and it can't
handle ranges with already freed blocks producing incorrect results in
these conditions.
I will add checking for error cases is to be added as soon as I get
some inputs on how to do that (and if this patch has some interest at
all). To simplify things I'd add mb_test_and_clear_bits() that will
clear given bit range, but will revert any changes made and
mb_free_blocks will go via slow one by one path in this case. But if
bitmap itself is ok, should buddies be checked?
Suggestions are welcome. Thanks!

This change was tested with AGGRESSIVE_CHECK enabled and
"mb_check_counter++ % 100" commented out in __mb_check_buddy.

Commit after unlinking 60G fallocated file (no bigalloc):
X86 before (linux 3.6-rc4):
[ 1257.114601] ext4_journal_commit_callback: enter
[ 1259.848202] ext4_journal_commit_callback: leave

X86 after:
[ 2157.358295] ext4_journal_commit_callback: enter
[ 2157.363268] ext4_journal_commit_callback: leave

MIPS before (linux 2.6.37):
<7>[240123.058000] release_blocks_on_commit: enter
<7>[240127.551000] release_blocks_on_commit: leave

MIPS after:
<7>[240313.049000] release_blocks_on_commit: enter
<7>[240313.056000] release_blocks_on_commit: leave

---
 fs/ext4/mballoc.c |  100 ++++++++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 51 deletions(-)

Index: linux-3.6-rc6/fs/ext4/mballoc.c
===================================================================
--- linux-3.6-rc6.orig/fs/ext4/mballoc.c	2012-09-16 17:58:51.000000000 -0400
+++ linux-3.6-rc6/fs/ext4/mballoc.c	2012-09-17 12:13:02.726293353 -0400
@@ -1254,14 +1254,27 @@ void ext4_set_bits(void *bm, int cur, in
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
 static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
 	int block = 0;
 	int max = 0;
-	int order;
+	int order = 1;
+	int start = first, end = first + count - 1;
 	void *buddy;
-	void *buddy2;
 	struct super_block *sb = e4b->bd_sb;

 	BUG_ON(first + count > (sb->s_blocksize << 3));
@@ -1283,57 +1296,42 @@ static void mb_free_blocks(struct inode
 	else if (!block && !max)
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
+	if ((start & 1) && mb_test_bit(start - 1, e4b->bd_bitmap))
+		start++;
+	mb_clear_bits(e4b->bd_bitmap, first, count);
+	if (!(end & 1) && mb_test_bit(end + 1, e4b->bd_bitmap))
+		end--;
+
+	e4b->bd_info->bb_counters[0] += count;
+
+	if (start > end) goto done;
+
+	start >>= 1;
+	end >>= 1;
+	buddy = mb_find_buddy(e4b, order, &max);
+
+	while (buddy) {
+		void *buddy2;
+
+		if (start & 1)
+			e4b->bd_info->bb_counters[order] += mb_buddy_adjust_border(&start,
buddy, -1);
+		if (!(end & 1))
+			e4b->bd_info->bb_counters[order] += mb_buddy_adjust_border(&end, buddy, 1);
+		if (start > end)
+			break;
+		order++;
+
+		if (start == end || !(buddy2 = mb_find_buddy(e4b, order, &max))) {
+			mb_clear_bits(buddy, start, end - start + 1);
+			e4b->bd_info->bb_counters[order - 1] += end - start + 1;
+			break;
 		}
-		mb_clear_bit(block, e4b->bd_bitmap);
-		e4b->bd_info->bb_counters[order]++;
-
-		/* start of the buddy */
-		buddy = mb_find_buddy(e4b, order, &max);
-
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
-
-			block = block >> 1;
-			order++;
-			e4b->bd_info->bb_counters[order]++;
