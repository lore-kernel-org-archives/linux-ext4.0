From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Fri, 29 Aug 2008 09:14:51 +0530
Message-ID: <20080829034451.GA6444@skywalker>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219960669.6384.58.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:54689 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281AbYH2Do6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 23:44:58 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7T3itT1003333
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 09:14:55 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T3itHL921702
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 09:14:55 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7T3is2e032286
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 09:14:54 +0530
Content-Disposition: inline
In-Reply-To: <1219960669.6384.58.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 02:57:49PM -0700, Mingming Cao wrote:
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> ext4: Fix ext4 nomballoc allocator for ENOSPC
>     
> We run into ENOSPC error on nonmballoc ext4, even when there is free blocks
> on the filesystem.
> 
> The problem is triggered in the case the goal block group has 0 free blocks
> , and the rest block groups are skipped due to the check of "free_blocks 
> < windowsz/2".

The goal block group had free blocks < windowsz .


>Current code could fall back to non reservation allocation
> to prevent early ENOSPC after examing all the block groups with reservation on
> , but this code was  bypassed if the reservation window is turned off already,
> which is true in this case.
> 
> This patch fixed two issues:
> 1) We don't need to turn off block reservation if the goal block group has 
> 0 free blocks left and continue search for the rest of block groups.
> 
> Current code the intention is to turn off the block reservation if the
>  goal allocation group has a few (some) free blocks left (not enough 
> for make the desired reservation window),to try to allocation in the
>  goal block group, to get better locality. But if the goal blocks have 
> 0 free blocks,  it should leave the block reservation on, and continues
> search for the next block groups,rather than turn off block reservation
> completely.

I don't see how this change is going to make a difference. The goal group
had free blocks < windowsz and that made my_rsv = NULL. I guess we
should not make my_rsv in the first loop. Or in otherwords we can remove

/*
 * if there is not enough free blocks to make a new
 * resevation
 * turn off reservation for this allocation
 */
if (my_rsv && (free_blocks < windowsz)
		&& (free_blocks > 0)
		&& (rsv_is_empty(&my_rsv->rsv_window)))
	my_rsv = NULL;

And since we have the below check in the for loop

if (my_rsv && (free_blocks <= (windowsz/2)))
	continue;

We would skip all the groups that have low free block count.
Now if we are not able to allocate any blocks (ENOSPC)
we loop back because of 

if (my_rsv) {
	my_rsv = NULL;
	windowsz = 0;
	group_no = goal_group;
	goto retry_alloc;
}

and that would allocate blocks from the first group available.
This also give a chance to scan all the groups to make sure
if we have any of them left with enough free blocks to 
add to the reservation.


> 
> 2) we don't need to check the window size if the block reservation is off. 


This change i have already tested.

> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> 
> Index: linux-2.6.27-rc3/fs/ext4/balloc.c
> ===================================================================
> --- linux-2.6.27-rc3.orig/fs/ext4/balloc.c	2008-08-28 12:41:55.000000000 -0700
> +++ linux-2.6.27-rc3/fs/ext4/balloc.c	2008-08-28 14:40:43.000000000 -0700
> @@ -1807,6 +1807,7 @@
>  	 * turn off reservation for this allocation
>  	 */
>  	if (my_rsv && (free_blocks < windowsz)
> +		&& (free_blocks > 0)
>  		&& (rsv_is_empty(&my_rsv->rsv_window)))
>  		my_rsv = NULL;
> 
> @@ -1843,7 +1844,7 @@
>  		 * free blocks is less than half of the reservation
>  		 * window size.
>  		 */
> -		if (free_blocks <= (windowsz/2))
> +		if (my_rsv && (free_blocks <= (windowsz/2)))
>  			continue;
> 
>  		brelse(bitmap_bh);
> 
> 
