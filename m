From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on block group allocation
Date: Thu, 23 Apr 2009 13:08:17 -0600
Message-ID: <20090423190817.GN3209@webber.adilger.int>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33942 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZDWTIi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 15:08:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3NJ8XNX007923
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 12:08:33 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIK00600I9FCB00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 23 Apr 2009 12:08:33 -0700 (PDT)
In-reply-to: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2009  09:41 -0700, Curt Wohlgemuth wrote:
> I'm seeing a performance problem on ext4 vs ext2, and in trying to
> narrow it down, I've got a question about block allocation in ext4
> that I'm having trouble figuring out.
> 
> Using dd, I created (in this order) two 4GB files and a 10GB file in
> the mount directory.
> 
> The extent blocks are reasonably close together for the two 4GB files,
> but the extents for the 10GB file show a huge gap, which seems to hurt
> the random read performance pretty substantially.  Here's the output
> from debugfs:
> 
> BLOCKS:
> (IND):8396832, (0-106495):8282112-8388607,
> (106496-399359):11241472-11534335, (399360-888831):20482048-20971519,
> (888832-1116159):23889920-24117247, (1116160-1277951):71665664-
> 71827455, (1277952-1767423):78678016-79167487,
> (1767424-2125823):102402048-102760447,
> (2125824-2148351):102768672-102791199,
> (2148352-2621439):102793216-103266303
> TOTAL: 2621441
> 
> Note the gap between blocks 79167487 and 102402048.

Well, there are other even larger gaps for other chunks of the file.

> I was lucky enough to capture the mb_history from this 10GB create:
> 
> 29109 14       735/30720/32758@1114112 735/30720/2048@1114112
> 735/30720/2048@1114112  1     0     0  1568  M     0     0
> 29109 14       736/0/32758@1116160     736/0/2048@1116160
> 2187/2048/2048@1116160  1     1     0  1568        0     0
> 29109 14       2187/4096/32758@1118208 2187/4096/2048@1118208
> 2187/4096/2048@1118208  1     0     0  1568  M     2048  4096
> 
> I've been staring at ext4_mb_regular_allocator() trying to understand
> why an allocation with a goal block of 736 ends up with a best found
> extent group of 2187, and I'm stuck -- at least without a lot of
> printk messages.  It seems to me that we just cycle through the block
> groups starting with the goal group until we find a group that fits.
> Again, according to dumpe2fs, block groups 737, 738, 739, ... all have
> 32768 free blocks.  So why we end up with a best fit group of 2187 is
> a mystery to me.

This is likely the "uninit_bg" feature that is causing the allocations
to skip groups which are marked BLOCK_UNINIT.  In some sense the benefit
of skipping the block bitmap read during e2fsck is probably not at all
beneficial compared to the cost of the extra seeking during IO.  As the
filesystem gets more full, the BLOCK_UNIIT flags would be cleared anyways,
so we might as well just keep the early allocations contiguous.

A simple change to verify this would be something like the following,
but it hasn't actually been tested.

--- ./fs/ext4/mballoc.c.uninit    2009-04-08 19:13:13.000000000 -0600
+++ ./fs/ext4/mballoc.c 2009-04-23 13:02:22.000000000 -0600
@@ -1742,10 +1723,6 @@ static int ext4_mb_good_group(struct ext
 	switch (cr) {
 	case 0:
 		BUG_ON(ac->ac_2order == 0);
-		/* If this group is uninitialized, skip it initially */
-		desc = ext4_get_group_desc(ac->ac_sb, group, NULL);
-		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
-			return 0;
 
 		bits = ac->ac_sb->s_blocksize_bits + 1;
 		for (i = ac->ac_2order; i <= bits; i++)
@@ -2039,9 +2035,7 @@ repeat:
 			ac->ac_groups_scanned++;
 			desc = ext4_get_group_desc(sb, group, NULL);
-			if (cr == 0 || (desc->bg_flags &
-				cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
-				ac->ac_2order != 0))
+			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 &&
 					ac->ac_g_ex.fe_len == sbi->s_stripe)


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

