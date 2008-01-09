From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Wed, 9 Jan 2008 19:44:30 +0100
Message-ID: <20080109184430.GB2215@duck.suse.cz>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080109121041.GA1013@atrey.karlin.mff.cuni.cz> <20080109182428.GC11852@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, bzzz@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53757 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbYAISoc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 13:44:32 -0500
Content-Disposition: inline
In-Reply-To: <20080109182428.GC11852@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 09-01-08 23:54:28, Aneesh Kumar K.V wrote:
> On Wed, Jan 09, 2008 at 01:10:41PM +0100, Jan Kara wrote:
> > > With the multi block allocator when we don't have prealloc space we discard
> > > @@ -3790,7 +3782,9 @@ repeat:
> > >  
> > >  	/* if we still need more blocks and some PAs were used, try again */
> > >  	if (free < needed && busy) {
> > > +		busy = 0;
> > >  		ext4_unlock_group(sb, group);
> > > +		schedule_timeout(HZ);
> > >  		goto repeat;
> > >  	}
> >   Hmm, wouldn't just schedule() be enough here? That would give a good
> > chance to other processes to proceed and we would avoid this artificial
> > wait of 1s which is quite ugly IMO.
> > 
> 
> But then who will wake up the task ?. I have the below comment added to
> the patch in the patch queue.
  As far as I know, you don't have to wake-up the task explicitely.
Scheduler will simply schedule the task sometime in future (it is a similar
situation as if the task got preempted in the kernel).

> /*
>  * We see this quiet rare. But if a particular workload is
>  * effected by this we may need to add a waitqueue
>  */
  Yes, adding that comment is good in any case :).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
