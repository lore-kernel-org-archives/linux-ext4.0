From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: patch queue update
Date: Fri, 11 Jan 2008 09:39:14 +0530
Message-ID: <20080111040914.GA6959@skywalker>
References: <20080110153358.GA9367@skywalker> <20080110214323.GL3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:49039 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbYAKEJW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2008 23:09:22 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m0B49H7i026662
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 09:39:17 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0B49Hv9757954
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 09:39:17 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m0B49Ji2017004
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 04:09:19 GMT
Received: from skywalker ([9.124.218.74])
	by d28av01.in.ibm.com (8.13.1/8.12.11) with ESMTP id m0B49Htp016995
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 04:09:19 GMT
Content-Disposition: inline
In-Reply-To: <20080110214323.GL3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 10, 2008 at 02:43:23PM -0700, Andreas Dilger wrote:
> On Jan 10, 2008  21:03 +0530, Aneesh Kumar K.V wrote:
> >  	if (i >= sbi->s_mb_order2_reqs) {
> > -		i--;
> > -		if ((ac->ac_g_ex.fe_len & (~(1 << i))) == 0)
> > +		/*
> > +		 * This should tell if fe_len is exactly power of 2
> > +		 */
> > +		if ((ac->ac_g_ex.fe_len & (~(1 << (i - 1)))) == 0)
> >  			ac->ac_2order = i;
> 
> While you changed i to (i - 1) in the "if" you didn't change it when
> setting ac_2order...  Is that incorrect?

Yes that ac_2order should be i - 1;
Will fix it in the next update.

I see that the patch queue update doesn't have most of the changes I
have placed at http://www.radian.org/~kvaneesh/ext4/jan-10-2008-ver2/

> 
> >  		/*
> > +		 * Yield the CPU here so that we don't get soft lockup
> >  		 */
> > -		schedule_timeout(HZ);
> > +		schedule();
> >  		goto repeat;
> >  	}
> >  
> > @@ -3808,7 +3820,7 @@ repeat:
> >  			printk(KERN_ERR "uh-oh! used pa while discarding\n");
> >  			dump_stack();
> >  			current->state = TASK_UNINTERRUPTIBLE;
> > -			schedule();
> > +			schedule_timeout(HZ);
> >  			goto repeat;
> 
> Is this change to schedule_timeout() intentional?  The earlier code is
> removing the use of schedule_timeout.  I could be wrong, as I didn't
> follow this discussion closely, but sometimes changes like this happen
> accidentally and people don't look at the patch itself...


The patch queue had it modified from schedule_timeout to schedule(). I
am moving it back to the original version. If we have set the task state
to TASK_UNINTERRUPTIBLE it should be schedule_timeout. And at these
place we intent to wait uninterrupted for 1 sec. The place where we
wanted to just yield is ext4_mb_discard_group_preallocations.


> > +static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
> > +{
> > +	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
> > +	unsigned long stripe_width = le32_to_cpu(sbi->s_es->s_raid_stripe_width);
> > +
> > +	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group) {
> > +		return sbi->s_stripe;
> > +	} else if (stripe_width <= sbi->s_blocks_per_group) {
> > +		return stripe_width;
> > +	} else if (stride <= sbi->s_blocks_per_group) {
> > +		return stride;
> > +	}
> 
> If you are doing "return XXX" you don't need "else".
> 
> > +	/*
> > +	 * set the stripe size. If we have specified it via mount option, then
> > +	 * use the mount option value. If the value specified at mount time is
> > +	 * greater than the blocks per group use the super block value.
> > +	 * Allocator needs it be less than blocks per group.
> > +	 */
> > +	sbi->s_stripe = ext4_get_stripe_size(sbi);
> 
> This comment should probably go by ext4_get_stripe_size() definition instead
> of here at the caller.

Will move that to the function definition.

-aneesh
