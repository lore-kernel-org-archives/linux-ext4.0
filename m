From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Wed, 09 Jan 2008 14:01:32 -0800
Message-ID: <1199916092.4011.3.camel@localhost.localdomain>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080109121041.GA1013@atrey.karlin.mff.cuni.cz>
	 <20080109182428.GC11852@skywalker> <20080109184430.GB2215@duck.suse.cz>
	 <20080109191108.GA13294@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger@sun.com,
	bzzz@sun.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47272 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYAIWCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 17:02:21 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m09M2D4f021021
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:13 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09M2D3T116762
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:13 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m09M2Dl9008795
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:13 -0500
In-Reply-To: <20080109191108.GA13294@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-01-10 at 00:41 +0530, Aneesh Kumar K.V wrote:
> On Wed, Jan 09, 2008 at 07:44:30PM +0100, Jan Kara wrote:
> > On Wed 09-01-08 23:54:28, Aneesh Kumar K.V wrote:
> > > On Wed, Jan 09, 2008 at 01:10:41PM +0100, Jan Kara wrote:
> > > > > With the multi block allocator when we don't have prealloc space we discard
> > > > > @@ -3790,7 +3782,9 @@ repeat:
> > > > >  
> > > > >  	/* if we still need more blocks and some PAs were used, try again */
> > > > >  	if (free < needed && busy) {
> > > > > +		busy = 0;
> > > > >  		ext4_unlock_group(sb, group);
> > > > > +		schedule_timeout(HZ);
> > > > >  		goto repeat;
> > > > >  	}
> > > >   Hmm, wouldn't just schedule() be enough here? That would give a good
> > > > chance to other processes to proceed and we would avoid this artificial
> > > > wait of 1s which is quite ugly IMO.
> > > > 
> > > 
> > > But then who will wake up the task ?. I have the below comment added to
> > > the patch in the patch queue.
> >   As far as I know, you don't have to wake-up the task explicitely.
> > Scheduler will simply schedule the task sometime in future (it is a similar
> > situation as if the task got preempted in the kernel).
> 
> I missed the current->state = TASK_UNINTERRUPTIBLE; in that code piece.
> So yes without setting the task state yes it would put it back to the run
> queue.Infact schedule_timeout() without changing the task state also
> behaves similarly. Now that that we know that it if fine just to have a
> schedule() there since schedule_timeout() was just behaving as
> schedule(). I guess we should make the change you suggested. In that
> case we can remove the comment which says we need to add the wait queue.
> 
> Mingming,
> 
> Do you want me to send a patch or can you make the modification ?
> 

I could make the changes and update the mballoc patch in the queue.

Mingming
> -aneesh
> 
