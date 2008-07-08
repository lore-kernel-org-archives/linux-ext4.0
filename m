From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix mb_find_next_bit not to return larger than max
Date: Tue,  8 Jul 2008 22:14:56 +0530
Message-ID: <1215535496-15125-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34854 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492AbYGHQpY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 12:45:24 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m68Gj3gb014678
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 22:15:03 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m68Ghdbb1122410
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 22:13:39 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m68Gj26w018299
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 22:15:02 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some architectures implement ext4_find_next_bit and
ext4_find_next_zero_bit in such a way that they return
greater than max for some input values. Make sure
mb_find_next_bit and mb_find_next_zero_bit return the
right values.

On 2.6.25 we have include/asm-x86/bitops_32.h
static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
{
	unsigned x = 0;

	while (x < size) {
		unsigned long val = *addr++;
		if (val)
			return __ffs(val) + x;
		x += (sizeof(*addr)<<3);
	}
	return x;
}

This can return value greater than size.

Reported and fixed here for lustre

https://bugzilla.lustre.org/show_bug.cgi?id=15932
https://bugzilla.lustre.org/attachment.cgi?id=17205

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a1e58fb..d2c61eb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -381,22 +381,28 @@ static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
 
 static inline int mb_find_next_zero_bit(void *addr, int max, int start)
 {
-	int fix = 0;
+	int fix = 0, ret, tmpmax;
 	addr = mb_correct_addr_and_bit(&fix, addr);
-	max += fix;
+	tmpmax = max + fix;
 	start += fix;
 
-	return ext4_find_next_zero_bit(addr, max, start) - fix;
+	ret = ext4_find_next_zero_bit(addr, tmpmax, start) - fix;
+	if (ret > max)
+		return max;
+	return ret;
 }
 
 static inline int mb_find_next_bit(void *addr, int max, int start)
 {
-	int fix = 0;
+	int fix = 0, ret, tmpmax;
 	addr = mb_correct_addr_and_bit(&fix, addr);
-	max += fix;
+	tmpmax = max + fix;
 	start += fix;
 
-	return ext4_find_next_bit(addr, max, start) - fix;
+	ret = ext4_find_next_bit(addr, tmpmax, start) - fix;
+	if (ret > max)
+		return max;
+	return ret;
 }
 
 static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
@@ -3633,8 +3639,6 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 		if (bit >= end)
 			break;
 		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
-		if (next > end)
-			next = end;
 		start = group * EXT4_BLOCKS_PER_GROUP(sb) + bit +
 				le32_to_cpu(sbi->s_es->s_first_data_block);
 		mb_debug("    free preallocated %u/%u in group %u\n",
-- 
1.5.6.2.255.gbed62.dirty

