From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Performance regressions in 2.6.30-rc7?
Date: Thu, 16 Jul 2009 10:59:45 -0400
Message-ID: <x49ab34ptb2.fsf@segfault.boston.devel.redhat.com>
References: <20090609103208.GB9235@duck.suse.cz> <20090609184818.GD9556@think>
	<20090610091211.GA13692@duck.suse.cz>
	<x4963f3rb4t.fsf@segfault.boston.devel.redhat.com>
	<20090715104319.GC25458@duck.suse.cz>
	<x4963du3vyp.fsf@segfault.boston.devel.redhat.com>
	<20090715145849.GE25458@duck.suse.cz>
	<20090715175028.GE22826@atrey.karlin.mff.cuni.cz>
	<20090715185452.GG22826@atrey.karlin.mff.cuni.cz>
	<x49iqhspue9.fsf@segfault.boston.devel.redhat.com>
	<20090716144601.GB25725@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Mike Galbraith <efault@gmx.de>,
	Diego Calleja <diegocg@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZGPPAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 11:00:30 -0400
In-Reply-To: <20090716144601.GB25725@duck.suse.cz> (Jan Kara's message of
	"Thu, 16 Jul 2009 16:46:01 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:
>> OK, looking back at the blktrace data I collected, we see[1]:
>> 
>> Total (cciss_c0d1):         2.6.29                  2.6.30-rc7
>> -------------------------------------------------------------------
>> Writes Queued:         8,531K,   34,126MiB  |   8,526K,   34,104MiB 
>> Write Dispatches:    556,256,   34,126MiB   | 294,809,   34,105MiB  <===
>> Writes Requeued:           0                |       0               
>> Writes Completed:    556,256,   34,126MiB   | 294,809,   34,105MiB  
>> Write Merges:          7,975K,   31,901MiB  |   8,231K,   32,924MiB 
>> --------------------------------------------------------------------
>> IO unplugs:          1,253,337              | 7,346,184             <===
>> Timer unplugs:         1,462                |       3               
>> 
>> Hmmm...

>   Yeah, this looks promissing. Although what I don't get is, how come that
> number of writes dispatched is roughly twice as much for 2.6.29 but the
> number of unplugs is higher on 2.6.30. My naive assumption would be that
> higher unplug rate -> less merging -> more requests dispatched.

Yeah, that's confusing!  I don't have an answer for you yet!

>> commit b029195dda0129b427c6e579a3bb3ae752da3a93
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Tue Apr 7 11:38:31 2009 +0200
>> 
>>     cfq-iosched: don't let idling interfere with plugging
>>     
>>     When CFQ is waiting for a new request from a process, currently it'll
>>     immediately restart queuing when it sees such a request. This doesn't
>>     work very well with streamed IO, since we then end up splitting IO
>>     that would otherwise have been merged nicely. For a simple dd test,
>>     this causes 10x as many requests to be issued as we should have.
>>     Normally this goes unnoticed due to the low overhead of requests
>>     at the device side, but some hardware is very sensitive to request
>>     sizes and there it can cause big slow downs.
>>     
>>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>> 
>> There were a couple of subsequent fixups to this commit:
>> 
>> commit d6ceb25e8d8bccf826848c2621a50d02c0a7f4ae
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Tue Apr 14 14:18:16 2009 +0200
>> 
>>     cfq-iosched: don't delay queue kick for a merged request
>> 
>> commit 2d870722965211de072bb36b446a4df99dae07e1
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Wed Apr 15 12:12:46 2009 +0200
>> 
>>     cfq-iosched: tweak kick logic a bit more
>> 
>> 
>> So I guess that's where we need to start looking.
>   OK, I can try to check whether backing out just these changes will help
> anything.

Well, that will help identify if they are, in fact, the cause.  I hope
it's not too hard to disentangle them from the current kernel!  Thanks
for all of your work on this!

Cheers,
Jeff
