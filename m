From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Sun, 23 Jan 2011 11:25:26 +0100
Message-ID: <20110123102526.GA23121@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110121185617.GI12072@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57346 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1AWKZd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 05:25:33 -0500
Content-Disposition: inline
In-Reply-To: <20110121185617.GI12072@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Fri, Jan 21, 2011 at 01:56:17PM -0500, Vivek Goyal wrote:
> > + * Currently, the following conditions are used to determine when to issue
> > + * flush.
> > + *
> > + * C1. At any given time, only one flush shall be in progress.  This makes
> > + *     double buffering sufficient.
> > + *
> > + * C2. Flush is not deferred if any request is executing DATA of its
> > + *     sequence.  This avoids issuing separate POSTFLUSHes for requests
> > + *     which shared PREFLUSH.
> 
> Tejun, did you mean "Flush is deferred" instead of "Flush is not deferred"
> above?

Oh yeah, I did.  :-)

> IIUC, C2 might help only if requests which contain data are also going to 
> issue postflush. Couple of cases come to mind.

That's true.  I didn't want to go too advanced on it.  I wanted
something which is fairly mechanical (without intricate parameters)
and effective enough for common cases.

> - If queue supports FUA, I think we will not issue POSTFLUSH. In that
>   case issuing next PREFLUSH which data is in flight might make sense.
>
> - Even if queue does not support FUA and we are only getting requests
>   with REQ_FLUSH then also waiting for data requests to finish before
>   issuing next FLUSH might not help.
> 
> - Even if queue does not support FUA and say we have a mix of REQ_FUA
>   and REQ_FLUSH, then this will help only if in a batch we have more
>   than 1 request which is going to issue POSTFLUSH and those postflush
>   will be merged.

Sure, not applying C2 and 3 if the underlying device supports REQ_FUA
would probably be the most compelling change of the bunch; however,
please keep in mind that issuing flush as soon as possible doesn't
necessarily result in better performance.  It's inherently a balancing
act between latency and throughput.  Even inducing artificial issue
latencies is likely to help if done right (as the ioscheds do).

So, I think it's better to start with something simple and improve it
with actual testing.  If the current simple implementation can match
Darrick's previous numbers, let's first settle the mechanisms.  We can
tune the latency/throughput balance all we want later.  Other than the
double buffering contraint (which can be relaxed too but I don't think
that would be necessary or a good idea) things can be easily adjusted
in blk_kick_flush().  It's intentionally designed that way.

> - Ric Wheeler was once mentioning that there are boxes which advertise
>   writeback cache but are battery backed so they ignore flush internally and
>   signal completion immediately. I am not sure how prevalent those
>   cases are but I think waiting for data to finish will delay processing
>   of new REQ_FLUSH requests in pending queue for such array. There
>   we will not anyway benefit from merging of FLUSH.

I don't really think we should design the whole thing around broken
devices which incorrectly report writeback cache when it need not.
The correct place to work around that is during device identification
not in the flush logic.

> Given that C2 is going to benefit primarily only if queue does not support
> FUA and we have many requets with REQ_FUA set, will it make sense to 
> put additional checks for C2. Atleast a simple queue support FUA
> check might help.
> 
> In practice does C2 really help or we can get rid of it entirely?

Again, issuing flushes as fast as possible isn't necessarily better.
It might feel counter-intuitive but it generally makes sense to delay
flush if there are a lot of concurrent flush activities going on.
Another related interesting point is that with flush merging,
depending on workload, there's a likelihood that FUA, even if the
device supports it, might result in worse performance than merged DATA
+ single POSTFLUSH sequence.

Thanks.

-- 
tejun
