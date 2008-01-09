From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Wed, 9 Jan 2008 23:54:28 +0530
Message-ID: <20080109182428.GC11852@skywalker>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080109121041.GA1013@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, bzzz@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:32868 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754659AbYAISYf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 13:24:35 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09IOUUV027595
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 23:54:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09IOULd794818
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 23:54:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09IOT4k004453
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 18:24:30 GMT
Content-Disposition: inline
In-Reply-To: <20080109121041.GA1013@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 09, 2008 at 01:10:41PM +0100, Jan Kara wrote:
> > With the multi block allocator when we don't have prealloc space we discard
> > @@ -3790,7 +3782,9 @@ repeat:
> >  
> >  	/* if we still need more blocks and some PAs were used, try again */
> >  	if (free < needed && busy) {
> > +		busy = 0;
> >  		ext4_unlock_group(sb, group);
> > +		schedule_timeout(HZ);
> >  		goto repeat;
> >  	}
>   Hmm, wouldn't just schedule() be enough here? That would give a good
> chance to other processes to proceed and we would avoid this artificial
> wait of 1s which is quite ugly IMO.
> 
> 									Honza

But then who will wake up the task ?. I have the below comment added to
the patch in the patch queue.

/*
 * We see this quiet rare. But if a particular workload is
 * effected by this we may need to add a waitqueue
 */


-aneesh
