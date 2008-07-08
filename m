From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: error in ext4_mb_release_inode_pa
Date: Tue, 8 Jul 2008 13:19:07 +0530
Message-ID: <20080708074907.GB23723@skywalker>
References: <48723646.1050101@redhat.com> <20080707232022.GX6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:50382 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbYGHHto (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 03:49:44 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m687nMW4009699
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 13:19:22 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m687lwDb1093742
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 13:17:58 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m687nLex027596
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 13:19:22 +0530
Content-Disposition: inline
In-Reply-To: <20080707232022.GX6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2008 at 05:20:22PM -0600, Andreas Dilger wrote:
> On Jul 07, 2008  10:29 -0500, Eric Sandeen wrote:
> > This was on #linuxfs last night, and I think I've seen at least one
> > other report of it:
> > 
> > [22:44]  <shehjart> any ideas why i get the following two lines on the
> > serial console when writing to ext4 over software raid0:
> > [22:44]  <shehjart> pa e00001004112d450: logic 11928, phys. 47003288,
> > len 360
> > [22:45]  <shehjart> EXT4-fs error (device md0):
> > ext4_mb_release_inode_pa: free 176, pa_free 174
> 
> The bug that I recalled from Lustre is unlikely to be the same.  It is
> https://bugzilla.lustre.org/show_bug.cgi?id=15932
> 
> 	"error: N blocks in bitmap, M in gd"

The first part of the fix is not needed. I guess we are initializing
block bitmap properly. The second part which states "We cannot trust
find_next_bit() to return a value < max. So we must check its
return for overflow." can be done as below 

How about ?

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


> 
> There was a second bug in ext3_mb_use_best_found() hit on > 8TB filesystems:
> https://bugzilla.lustre.org/show_bug.cgi?id=16101
> 
> 	BUG_ON(ac->ac_b_ex.fe_group != e3b->bd_group);
> 

This fix is not needed I guess because we use the ext4_group_t for group
I don't know why the bd_blkbits change is needed

-+	__u16 bd_blkbits;
-+	__u16 bd_group;
++	unsigned bd_group;
++	unsigned bd_blkbits;
 +};


-aneesh
