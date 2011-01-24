From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Date: Mon, 24 Jan 2011 12:31:55 -0800
Message-ID: <20110124203155.GA32261@tux1.beaverton.ibm.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org> <1295625598-15203-4-git-send-email-tj@kernel.org> <20110121185617.GI12072@redhat.com> <20110123102526.GA23121@htj.dyndns.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49030 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1AXUeF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Jan 2011 15:34:05 -0500
Content-Disposition: inline
In-Reply-To: <20110123102526.GA23121@htj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 23, 2011 at 11:25:26AM +0100, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 21, 2011 at 01:56:17PM -0500, Vivek Goyal wrote:
> > > + * Currently, the following conditions are used to determine when to issue
> > > + * flush.
> > > + *
> > > + * C1. At any given time, only one flush shall be in progress.  This makes
> > > + *     double buffering sufficient.
> > > + *
> > > + * C2. Flush is not deferred if any request is executing DATA of its
> > > + *     sequence.  This avoids issuing separate POSTFLUSHes for requests
> > > + *     which shared PREFLUSH.
> > 
> > Tejun, did you mean "Flush is deferred" instead of "Flush is not deferred"
> > above?
> 
> Oh yeah, I did.  :-)
> 
> > IIUC, C2 might help only if requests which contain data are also going to 
> > issue postflush. Couple of cases come to mind.
> 
> That's true.  I didn't want to go too advanced on it.  I wanted
> something which is fairly mechanical (without intricate parameters)
> and effective enough for common cases.
> 
> > - If queue supports FUA, I think we will not issue POSTFLUSH. In that
> >   case issuing next PREFLUSH which data is in flight might make sense.
> >
> > - Even if queue does not support FUA and we are only getting requests
> >   with REQ_FLUSH then also waiting for data requests to finish before
> >   issuing next FLUSH might not help.
> > 
> > - Even if queue does not support FUA and say we have a mix of REQ_FUA
> >   and REQ_FLUSH, then this will help only if in a batch we have more
> >   than 1 request which is going to issue POSTFLUSH and those postflush
> >   will be merged.
> 
> Sure, not applying C2 and 3 if the underlying device supports REQ_FUA
> would probably be the most compelling change of the bunch; however,
> please keep in mind that issuing flush as soon as possible doesn't
> necessarily result in better performance.  It's inherently a balancing
> act between latency and throughput.  Even inducing artificial issue
> latencies is likely to help if done right (as the ioscheds do).
> 
> So, I think it's better to start with something simple and improve it
> with actual testing.  If the current simple implementation can match
> Darrick's previous numbers, let's first settle the mechanisms.  We can

Yep, the fsync-happy numbers more or less match... at least for 2.6.37:
http://tinyurl.com/4q2xeao

I'll give 2.6.38-rc2 a try later, though -rc1 didn't boot for me, so these
numbers are based on a backport to .37. :(

In general, the effect of this patchset is to change a 100% drop in fsync-happy
performance into a 20% drop.  As always, the higher the average flush time, the
more the storage system benefits from having flush coordination.  The only
exception to that is elm3b231_ipr, which is a md array of disks that are
attached to a controller that is now throwing errors, so I'm not sure I
entirely trust that machine's numbers.

As for elm3c44_sas, I'm not sure why enabling flushes always increases
performance, other than to say that I suspect it has something to do with
md-raid'ing disk trays together, because elm3a4_sas and elm3c71_extsas consist
of the same configuration of disk trays, only without the md.  I've also been
told by our storage folks that md atop raid trays is not really a recommended
setup anyway.

The long and short of it is that this latest patchset looks and delivers the
behavior that I was aiming for. :)

> tune the latency/throughput balance all we want later.  Other than the
> double buffering contraint (which can be relaxed too but I don't think
> that would be necessary or a good idea) things can be easily adjusted
> in blk_kick_flush().  It's intentionally designed that way.
> 
> > - Ric Wheeler was once mentioning that there are boxes which advertise
> >   writeback cache but are battery backed so they ignore flush internally and
> >   signal completion immediately. I am not sure how prevalent those
> >   cases are but I think waiting for data to finish will delay processing
> >   of new REQ_FLUSH requests in pending queue for such array. There
> >   we will not anyway benefit from merging of FLUSH.
> 
> I don't really think we should design the whole thing around broken
> devices which incorrectly report writeback cache when it need not.
> The correct place to work around that is during device identification
> not in the flush logic.

elm3a4_sas and elm3c71_extsas advertise writeback cache yet the flush completion
times are suspiciously low.  I suppose it could be useful to disable flushes to
squeeze out that last bit of performance, though I don't know how one goes
about querying the disk array to learn if there's a battery behind the cache.
I guess the current mechanism (admin knob that picks a safe default) is good
enough.

> > Given that C2 is going to benefit primarily only if queue does not support
> > FUA and we have many requets with REQ_FUA set, will it make sense to 
> > put additional checks for C2. Atleast a simple queue support FUA
> > check might help.
> > 
> > In practice does C2 really help or we can get rid of it entirely?
> 
> Again, issuing flushes as fast as possible isn't necessarily better.
> It might feel counter-intuitive but it generally makes sense to delay
> flush if there are a lot of concurrent flush activities going on.
> Another related interesting point is that with flush merging,
> depending on workload, there's a likelihood that FUA, even if the
> device supports it, might result in worse performance than merged DATA
> + single POSTFLUSH sequence.
> 
> Thanks.
> 
> -- 
> tejun
