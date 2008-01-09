From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Thu, 10 Jan 2008 00:41:08 +0530
Message-ID: <20080109191108.GA13294@skywalker>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080109121041.GA1013@atrey.karlin.mff.cuni.cz> <20080109182428.GC11852@skywalker> <20080109184430.GB2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, bzzz@sun.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:35006 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbYAITLR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 14:11:17 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09JBApI031228
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 00:41:10 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09JBAFW852178
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 00:41:10 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09JBBX7005248
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 19:11:12 GMT
Content-Disposition: inline
In-Reply-To: <20080109184430.GB2215@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 09, 2008 at 07:44:30PM +0100, Jan Kara wrote:
> On Wed 09-01-08 23:54:28, Aneesh Kumar K.V wrote:
> > On Wed, Jan 09, 2008 at 01:10:41PM +0100, Jan Kara wrote:
> > > > With the multi block allocator when we don't have prealloc space we discard
> > > > @@ -3790,7 +3782,9 @@ repeat:
> > > >  
> > > >  	/* if we still need more blocks and some PAs were used, try again */
> > > >  	if (free < needed && busy) {
> > > > +		busy = 0;
> > > >  		ext4_unlock_group(sb, group);
> > > > +		schedule_timeout(HZ);
> > > >  		goto repeat;
> > > >  	}
> > >   Hmm, wouldn't just schedule() be enough here? That would give a good
> > > chance to other processes to proceed and we would avoid this artificial
> > > wait of 1s which is quite ugly IMO.
> > > 
> > 
> > But then who will wake up the task ?. I have the below comment added to
> > the patch in the patch queue.
>   As far as I know, you don't have to wake-up the task explicitely.
> Scheduler will simply schedule the task sometime in future (it is a similar
> situation as if the task got preempted in the kernel).

I missed the current->state = TASK_UNINTERRUPTIBLE; in that code piece.
So yes without setting the task state yes it would put it back to the run
queue.Infact schedule_timeout() without changing the task state also
behaves similarly. Now that that we know that it if fine just to have a
schedule() there since schedule_timeout() was just behaving as
schedule(). I guess we should make the change you suggested. In that
case we can remove the comment which says we need to add the wait queue.

Mingming,

Do you want me to send a patch or can you make the modification ?

-aneesh
