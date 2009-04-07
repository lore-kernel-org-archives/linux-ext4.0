From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12829] kernel complains on ENOSPC
Date: Tue, 7 Apr 2009 20:01:46 +0530
Message-ID: <20090407143146.GA29644@skywalker>
References: <bug-12829-13602@http.bugzilla.kernel.org/> <20090310163824.6C767108042@picon.linux-foundation.org> <20090406185823.GE7376@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48060 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZDGOie (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 10:38:34 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n37EcG2o010626
	for <linux-ext4@vger.kernel.org>; Wed, 8 Apr 2009 00:38:16 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n37EcWTO246186
	for <linux-ext4@vger.kernel.org>; Wed, 8 Apr 2009 00:38:32 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n37EcWIM001729
	for <linux-ext4@vger.kernel.org>; Wed, 8 Apr 2009 00:38:32 +1000
Content-Disposition: inline
In-Reply-To: <20090406185823.GE7376@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

No we don't need the patch. The patch is wrong. We are actually taking
into account the allocated blocks in mballoc.c 

3033          */
3034         if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
3035                 /* release all the reserved blocks if non delalloc */
3036                 percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
3037         else {
3038                 percpu_counter_sub(&sbi->s_dirtyblocks_counter,
3039							 ac->ac_b_ex.fe_len); 

-aneesh

On Mon, Apr 06, 2009 at 02:58:23PM -0400, Theodore Tso wrote:
> Aneesh,
> 
> What's the status of this patch; do you think we still need it?  If
> so, can you add a proper commit log and signed-off-by, tell me that
> you've tested it, etc.?
> 
> Thanks!!
> 
> 	    	    	  	 - Ted
> 
> 
> On Tue, Mar 10, 2009 at 09:38:24AM -0700, bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12829
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #4 from aneesh.kumar@linux.vnet.ibm.com  2009-03-10 09:38 -------
> > This patch will not fix the problem. But i guess we need this change
> > 
> > -aneesh
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 4415bee..671f215 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -4652,11 +4652,11 @@ out1:
> >         if (ar->len < inquota)
> >                 DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> >  out3:
> > -       if (!ar->len) {
> > +       if (ar->len < reserv_blks) {
> >                 if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> >                         /* release all the reserved blocks if non delalloc */
> >                         percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> > -                                               reserv_blks);
> > +                                               reserv_blks - ar->len);
> >         }
> > 
> >         trace_mark(ext4_allocate_blocks,
> > 
> > 
> > -- 
> > Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> > ------- You are receiving this mail because: -------
> > You are the assignee for the bug, or are watching the assignee.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
