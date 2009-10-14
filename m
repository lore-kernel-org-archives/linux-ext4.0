From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Help understanding prealloc space choice?
Date: Wed, 14 Oct 2009 10:53:15 +0530
Message-ID: <20091014052314.GA29704@skywalker.linux.vnet.ibm.com>
References: <6601abe90910131106u3a569d51g1322fe6764a2fbb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34315 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZJNFXv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 01:23:51 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n9E5NCCx031534
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 10:53:12 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9E5NBUL2854956
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 10:53:12 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9E5NBe5025106
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 16:23:11 +1100
Content-Disposition: inline
In-Reply-To: <6601abe90910131106u3a569d51g1322fe6764a2fbb6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 13, 2009 at 11:06:35AM -0700, Curt Wohlgemuth wrote:
> Hi all:
> 
> I'm looking in ext4_mb_use_preallocated() and am seeing something odd.
> 
> First we look through the inode prealloc list, and see if we have a
> preallocation that satisfies the allocation context:
> 
>        /* all fields in this condition don't change,
>         * so we can skip locking for them */
>        if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
>                ac->ac_o_ex.fe_logical >= pa->pa_lstart + pa->pa_len)
>                continue;
> 
>        /* non-extent files can't have physical blocks past 2^32 */
>        if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL) &&
>                pa->pa_pstart + pa->pa_len > EXT4_MAX_BLOCK_FILE_PHYS)
>                continue;
> 
>        /* found preallocated blocks, use them */
>        spin_lock(&pa->pa_lock);
>        if (pa->pa_deleted == 0 && pa->pa_free) {
> 
>             => Now we're good, and have an AC that satisfies us.
>             => We call ext4_mb_use_inode_pa(ac, pa);
> 
> 
> But ext4_mb_use_inode_pa() has this:
> 
> 	BUG_ON(pa->pa_free < len);
> 
> Nowhere do we check the 'pa_free' value to decide if this preallocation is
> okay to use.
> 

the 'len' value above is derived out of what we have in prealloc space.
ie, we do this

     start = pa->pa_pstart + (ac->ac_o_ex.fe_logical - pa->pa_lstart);                                                                 
     end = min(pa->pa_pstart + pa->pa_len, start + ac->ac_o_ex.fe_len);                                                                
     len = end - start;     

Now to decide whether we need to use a particular inode prealloc space
we look at the pa->pa_lstart which is the start logical block number
mapping this prealloc space. So if the requested logical block number
falls within a prealloc space (ie within pa->pa_lstart , pa->pa_lstart + pa->pa_len)
we use the prealloc space. Done by the below conditional ext4_mb_use_preallocated

      /* all fields in this condition don't change,                                                                             
       * so we can skip locking for them */                                                                                     
       if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||                                                                             
             ac->ac_o_ex.fe_logical >= pa->pa_lstart + pa->pa_len)                                                             
                        continue;               



> 
> Further down in ext4_mb_use_preallocated() we check the locality group
> prealloc list; for this, we DO check pa_free:
> 
>          spin_lock(&pa->pa_lock);
>          if (pa->pa_deleted == 0 &&
>                          pa->pa_free >= ac->ac_o_ex.fe_len) {
> 
>                  cpa = ext4_mb_check_group_pa(goal_block,
>                                                  pa, cpa);
> 

 
locality group prealloc space is not looked with the logical block number.
We just claim need blocks from the prealloc space. Hence we check for the
available free blocks and the needed free blocks.



> So my question is:  Is it a bug that we don't check that an inode
> preallocation has enough free blocks for the AC before we try to use it?  I
> have hit the BUG_ON above at least once in my testing, but I can't
> characterize what the workload was at the time (nor can I reproduce it...).
> 

You should not hit that. That would mean prealloc space accounting went wrong.
Which is really a BUG

-aneesh
