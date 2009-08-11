From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Questions about mballoc's stream allocation
Date: Tue, 11 Aug 2009 23:07:03 +0530
Message-ID: <20090811173703.GA5756@skywalker>
References: <E1MZPAn-0001Y0-TQ@closure.thunk.org> <20090811153905.GA2914@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55342 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZHKRhN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 13:37:13 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7BHYWjf021994
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 03:34:32 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7BHbCEg528576
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 03:37:12 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7BHbCqq009542
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 03:37:12 +1000
Content-Disposition: inline
In-Reply-To: <20090811153905.GA2914@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 09:09:05PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Aug 07, 2009 at 09:07:53AM -0400, Theodore Ts'o wrote:
> > 
> > I've got two questions about mballoc's stream allocation.
> > 
> > First of all, in ext4_mb_regular_allocator(), I'm 99% sure this is a
> > bug:
> > 
> > 	/* if stream allocation is enabled, use global goal */
> > 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> > 	isize = i_size_read(ac->ac_inode) >> bsbits;
> > 	if (size < isize)
> > 		size = isize;
> > 
> > 	if (size < sbi->s_mb_stream_request &&
> > 	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
> > 		/* TBD: may be hot point */
> > 		spin_lock(&sbi->s_md_lock);
> > 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
> > 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
> > 		spin_unlock(&sbi->s_md_lock);
> > 	}
> > 
> > Shouldn't that be ">=", not "<".  We want to use the values saved in
> > sbi->s_mb_last_{group,start} only if we are doing a stream allocation,
> > which would be true only if the file is *larger* than
> > s_mb_stream_request, no?
> > 
> > 
> > The second question I have is with regards to ext4_mb_use_best_found(),
> > we set sbi->s_mb_last_{group,start} on any data allocation; shouldn't we
> > only be setting those values only if we were doing a stream allocation
> > in the first place?
> > 
> > Otherwise, any kind of allocation will end up moving the global goal
> > block for stream allocations; even if it is a small allocation in the
> > middle of some block group caused by the flag EXT4_MB_HINT_NO_PREALLOC
> > being set.
> > 
> > Am I missing anything?
> > 
> 
> I guess we should be setting the sbi->s_mb_last_{group,start} only when doing
> small file allocation. We want to make sure small file allocation always
> use the goal block near to the previous small file allocation request. So
> (size <  sbi->s_mb_stream_request) is correct. But we should not be doing
> 
>          sbi->s_mb_last_group = ac->ac_f_ex.fe_group;  
> always.
> 
> For large file allocation we wanted the new blocks to closer to that files previous
> allocated block which ext4_ext_find_goal return as the goal value. So for
> large files the goal value passed should represent the correct value.
> 

Or may be the current code is fine. I guess what the aim was to make sure we spread
small file allocation near to the context. We use the ac_g_ex only when we don't find
blocks in prealloc space. The goal could be that, if we create lot of small files it would be that
the new small files created may be related to the process that did last block allocation.

-aneesh
