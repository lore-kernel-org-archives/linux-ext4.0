From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: ext4_find_next_zero_bit needs an aligned address on some arch
Date: Wed, 20 Feb 2008 20:11:27 +0530
Message-ID: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sandeen@redhat.com, tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57449 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYBTOle (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2008 09:41:34 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1KEfKGZ006122
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 01:41:20 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1KEfVPK2310348
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 01:41:31 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1KEfVBw027081
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 01:41:31 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_find_next_zero_bit and ext4_find_next_bit needs a long aligned
address on x8_64. Add mb_find_next_zero_bit and mb_find_next_bit
and use them in the mballoc.

Fix: https://bugzilla.redhat.com/show_bug.cgi?id=433286

Eric Sandeen debugged the problem and suggested the fix.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/mballoc.c |   62 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 89772b9..ccddd21 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -627,21 +627,19 @@ static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 	return block;
 }
 
+static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
+{
 #if BITS_PER_LONG == 64
-#define mb_correct_addr_and_bit(bit, addr)		\
-{							\
-	bit += ((unsigned long) addr & 7UL) << 3;	\
-	addr = (void *) ((unsigned long) addr & ~7UL);	\
-}
+	*bit += ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
 #elif BITS_PER_LONG == 32
-#define mb_correct_addr_and_bit(bit, addr)		\
-{							\
-	bit += ((unsigned long) addr & 3UL) << 3;	\
-	addr = (void *) ((unsigned long) addr & ~3UL);	\
-}
+	*bit += ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
 #else
 #error "how many bits you are?!"
 #endif
+	return addr;
+}
 
 static inline int mb_test_bit(int bit, void *addr)
 {
@@ -649,34 +647,54 @@ static inline int mb_test_bit(int bit, void *addr)
 	 * ext4_test_bit on architecture like powerpc
 	 * needs unsigned long aligned address
 	 */
-	mb_correct_addr_and_bit(bit, addr);
+	addr = mb_correct_addr_and_bit(&bit, addr);
 	return ext4_test_bit(bit, addr);
 }
 
 static inline void mb_set_bit(int bit, void *addr)
 {
-	mb_correct_addr_and_bit(bit, addr);
+	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_set_bit(bit, addr);
 }
 
 static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
 {
-	mb_correct_addr_and_bit(bit, addr);
+	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_set_bit_atomic(lock, bit, addr);
 }
 
 static inline void mb_clear_bit(int bit, void *addr)
 {
-	mb_correct_addr_and_bit(bit, addr);
+	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_clear_bit(bit, addr);
 }
 
 static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
 {
-	mb_correct_addr_and_bit(bit, addr);
+	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_clear_bit_atomic(lock, bit, addr);
 }
 
+static inline int mb_find_next_zero_bit(void *addr, int max, int start)
+{
+	int fix = 0;
+	addr = mb_correct_addr_and_bit(&fix, addr);
+	max += fix;
+	start += fix;
+
+	return ext4_find_next_zero_bit(addr, max, start) - fix;
+}
+
+static inline int mb_find_next_bit(void *addr, int max, int start)
+{
+	int fix = 0;
+	addr = mb_correct_addr_and_bit(&fix, addr);
+	max += fix;
+	start += fix;
+
+	return ext4_find_next_bit(addr, max, start) - fix;
+}
+
 static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
@@ -946,12 +964,12 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 
 	/* initialize buddy from bitmap which is aggregation
 	 * of on-disk bitmap and preallocations */
-	i = ext4_find_next_zero_bit(bitmap, max, 0);
+	i = mb_find_next_zero_bit(bitmap, max, 0);
 	grp->bb_first_free = i;
 	while (i < max) {
 		fragments++;
 		first = i;
-		i = ext4_find_next_bit(bitmap, max, i);
+		i = mb_find_next_bit(bitmap, max, i);
 		len = i - first;
 		free += len;
 		if (len > 1)
@@ -959,7 +977,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 		else
 			grp->bb_counters[0]++;
 		if (i < max)
-			i = ext4_find_next_zero_bit(bitmap, max, i);
+			i = mb_find_next_zero_bit(bitmap, max, i);
 	}
 	grp->bb_fragments = fragments;
 
@@ -1783,7 +1801,7 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		buddy = mb_find_buddy(e4b, i, &max);
 		BUG_ON(buddy == NULL);
 
-		k = ext4_find_next_zero_bit(buddy, max, 0);
+		k = mb_find_next_zero_bit(buddy, max, 0);
 		BUG_ON(k >= max);
 
 		ac->ac_found++;
@@ -1823,7 +1841,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	i = e4b->bd_info->bb_first_free;
 
 	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
-		i = ext4_find_next_zero_bit(bitmap,
+		i = mb_find_next_zero_bit(bitmap,
 						EXT4_BLOCKS_PER_GROUP(sb), i);
 		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			/*
@@ -3744,10 +3762,10 @@ static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 	}
 
 	while (bit < end) {
-		bit = ext4_find_next_zero_bit(bitmap_bh->b_data, end, bit);
+		bit = mb_find_next_zero_bit(bitmap_bh->b_data, end, bit);
 		if (bit >= end)
 			break;
-		next = ext4_find_next_bit(bitmap_bh->b_data, end, bit);
+		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
 		if (next > end)
 			next = end;
 		start = group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
-- 
1.5.4.1.97.g40aab-dirty
