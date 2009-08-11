From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Questions about mballoc's stream allocation
Date: Tue, 11 Aug 2009 21:09:05 +0530
Message-ID: <20090811153905.GA2914@skywalker>
References: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52333 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZHKPjM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 11:39:12 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id n7BFdANU004091
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 21:09:10 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7BFdAXE1630438
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 21:09:10 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7BFdA7X004716
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 21:09:10 +0530
Content-Disposition: inline
In-Reply-To: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 07, 2009 at 09:07:53AM -0400, Theodore Ts'o wrote:
> 
> I've got two questions about mballoc's stream allocation.
> 
> First of all, in ext4_mb_regular_allocator(), I'm 99% sure this is a
> bug:
> 
> 	/* if stream allocation is enabled, use global goal */
> 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> 	isize = i_size_read(ac->ac_inode) >> bsbits;
> 	if (size < isize)
> 		size = isize;
> 
> 	if (size < sbi->s_mb_stream_request &&
> 	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
> 		/* TBD: may be hot point */
> 		spin_lock(&sbi->s_md_lock);
> 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
> 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
> 		spin_unlock(&sbi->s_md_lock);
> 	}
> 
> Shouldn't that be ">=", not "<".  We want to use the values saved in
> sbi->s_mb_last_{group,start} only if we are doing a stream allocation,
> which would be true only if the file is *larger* than
> s_mb_stream_request, no?
> 
> 
> The second question I have is with regards to ext4_mb_use_best_found(),
> we set sbi->s_mb_last_{group,start} on any data allocation; shouldn't we
> only be setting those values only if we were doing a stream allocation
> in the first place?
> 
> Otherwise, any kind of allocation will end up moving the global goal
> block for stream allocations; even if it is a small allocation in the
> middle of some block group caused by the flag EXT4_MB_HINT_NO_PREALLOC
> being set.
> 
> Am I missing anything?
> 

I guess we should be setting the sbi->s_mb_last_{group,start} only when doing
small file allocation. We want to make sure small file allocation always
use the goal block near to the previous small file allocation request. So
(size <  sbi->s_mb_stream_request) is correct. But we should not be doing

         sbi->s_mb_last_group = ac->ac_f_ex.fe_group;  
always.

For large file allocation we wanted the new blocks to closer to that files previous
allocated block which ext4_ext_find_goal return as the goal value. So for
large files the goal value passed should represent the correct value.

NOTE: I am still behind ext4 list mails due to other commitments. Will start looking
at the mails, but mostly would be slow in replies

-aneesh
