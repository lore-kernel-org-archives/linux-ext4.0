From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Fri, 6 Jun 2008 21:56:33 +0530
Message-ID: <20080606162633.GA22364@skywalker>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker> <20080605153701.GB25477@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35690 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYFFQ0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 12:26:49 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56GQGgs027583
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 02:26:16 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56GUv2j242862
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 02:30:57 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56GQjDV030539
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 02:26:46 +1000
Content-Disposition: inline
In-Reply-To: <20080605153701.GB25477@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 11:37:01AM -0400, Theodore Tso wrote:
> On Thu, Jun 05, 2008 at 02:13:29PM +0530, Aneesh Kumar K.V wrote:
> > 
> > Something like below ? . I will send a final patch once I get the
> > patchqueu updated. I am not able to reach repo.or.cz currently.
> 
> This is better, but it still means that we are exporting a large
> number of functions to the callers.  It's not clear to me we need so
> many different variants of ext4_new_blocks_* --- what is their
> justification to exist?
> 
> For example, why not just have:
> 
> static ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
>        				ext4_lblk_t iblock, ext4_fsblk_t goal,
> 				unsigned long *count, int *errp, int meta)
> 

Now that we have moved all the code to do_blk_alloc, we can be assured
that we won't miss bug fixes to those allocation APIs when fixing one of
them. IMHO having separate APIs reduces the risk of misusing them

-aneesh
