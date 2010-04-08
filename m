From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 13:04:42 +0200
Message-ID: <20100408110442.GK10103@kernel.dk>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100407214631.GL3206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57778 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455Ab0DHLEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 07:04:44 -0400
Content-Disposition: inline
In-Reply-To: <20100407214631.GL3206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07 2010, Vivek Goyal wrote:
> On Wed, Apr 07, 2010 at 05:18:12PM -0400, Jeff Moyer wrote:
> > Hi again,
> > 
> > So, here's another stab at fixing this.  This patch is very much an RFC,
> > so do not pull it into anything bound for Linus.  ;-)  For those new to
> > this topic, here is the original posting:  http://lkml.org/lkml/2010/4/1/344
> > 
> > The basic problem is that, when running iozone on smallish files (up to
> > 8MB in size) and including fsync in the timings, deadline outperforms
> > CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
> > files.  From examining the blktrace data, it appears that iozone will
> > issue an fsync() call, and will have to wait until it's CFQ timeslice
> > has expired before the journal thread can run to actually commit data to
> > disk.
> > 
> > The approach below puts an explicit call into the filesystem-specific
> > fsync code to yield the disk so that the jbd[2] process has a chance to
> > issue I/O.  This bring performance of CFQ in line with deadline.
> > 
> > There is one outstanding issue with the patch that Vivek pointed out.
> > Basically, this could starve out the sync-noidle workload if there is a
> > lot of fsync-ing going on.  I'll address that in a follow-on patch.  For
> > now, I wanted to get the idea out there for others to comment on.
> > 
> > Thanks a ton to Vivek for spotting the problem with the initial
> > approach, and for his continued review.
> > 
> 
> Thanks Jeff. Conceptually this appraoch makes lot of sense to me. Higher
> layers explicitly telling CFQ not to idle/yield the slice.
> 
> My firefox timing test is perfoming much better now.
> 
> real	0m15.957s
> user	0m0.608s
> sys	0m0.165s
> 
> real	0m12.984s
> user	0m0.602s
> sys	0m0.148s
> 
> real	0m13.057s
> user	0m0.624s
> sys	0m0.145s
> 
> So we got to take care of two issues now.
> 
> - Make it work with dm/md devices also. Somehow shall have to propogate
>   this yield semantic down the stack.

The way that Jeff set it up, it's completely parallel to eg congestion
or unplugging. So that should be easily doable.

> - The issue of making sure we don't yield if we are servicing sync-noidle
>   tree and there is other IO going on which relies on sync-noidle tree
>   idling (as you have already mentioned).

Agree.

> > +	/*
> > +	 * This is primarily called to ensure that the long synchronous
> > +	 * time slice does not prevent other I/O happenning (like journal
> > +	 * commits) while we idle waiting for it.  Thus, check to see if the
> > +	 * current cfqq is the sync cfqq for this process.
> > +	 */
> > +	cfqq = cic_to_cfqq(cic, 1);
> > +	if (!cfqq)
> > +		goto out_unlock;
> > +
> > +	if (cfqd->active_queue != cfqq)
> > +		goto out_unlock;
> > +
> > +	cfq_log_cfqq(cfqd, cfqq, "yielding queue");
> > +
> > +	__cfq_slice_expired(cfqd, cfqq, 1);
> > +	__blk_run_queue(cfqd->queue);
> 
> I think it would be good if we also check that cfqq is empty or not. If cfqq
> is not empty we don't want to give up slice? But this is a minor point. At
> least in case of fsync, we seem to be waiting for all the iozone request
> to finish and then calling yield. So cfqq should be empty at this point of
> time. 

That's a bit of a problem. Say the queue has one request left, it'll
service that and the start idling. But we already got this hint that we
should yield, but as it happened before we reached the idling state,
we'll not yield. Perhaps it would be better to mark the cfqq as yielding
if it isn't ready to yield just yet.

-- 
Jens Axboe

