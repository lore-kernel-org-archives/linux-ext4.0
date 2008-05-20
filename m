From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 13:08:03 -0400
Message-ID: <200805201308.03956.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <200805201202.54420.chris.mason@oracle.com> <20080520162710.GM16676@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:19730 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYETRJc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 13:09:32 -0400
In-Reply-To: <20080520162710.GM16676@shareable.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 May 2008, Jamie Lokier wrote:
> Chris Mason wrote:
> > > You don't need the barrier after in some cases, or it can be deferred
> > > until a better time.  E.g. when the disk write cache is probably empty
> > > (some time after write-idle), barrier flushes may take the same time
> > > as NOPs.
> >
> > I hesitate to get too fancy here, if the disk is idle we probably
> > won't notice the performance gain.
>
> I think you're right, but it's hard to be sure.  One of the problems
> with barrier-implemented-as-flush-all is that it flushes data=ordered
> data, even when that's not wanted, and there can be a lot of data in
> the disk's write cache, spread over many seeks.

Jens and I talked about tossing the barriers completely and just doing FUA for 
all metadata writes.  For drives with NCQ, we'll get something close to 
optimal because the higher layer elevators are already doing most of the hard 
work.

Either way, you do want the flush to cover all the data=ordered writes, at 
least all the ordered writes from the transaction you're about to commit.  
Telling the difference between data=ordered from an old transaction or from 
the running transaction gets into pushing ordering down to the lower levels 
(see below)

>
> Then it's good to delay barrier-flushes to batch metadata commits, but
> good to issue the barrier-flushes prior to large batches of
> data=ordered data, so the latter can be survive in the disk write
> cache for seek optimisations with later requests which aren't yet
> known.
>
> All this sounds complicated at the JBD layer, and IMHO much simpler at
> the request elevator layer.
>
> > But, it complicates the decision about when you're allowed to dirty
> > a metadata block for writeback.  It used to be dirty-after-commit
> > and it would change to dirty-after-barrier.  I suspect that is some
> > significant surgery into jbd.
>
> Rather than tracking when it's "allowed" to dirty a metadata block, it
> will be simpler to keep a flag saying "barrier needed", and just issue
> the barrier prior to writing a metadata block, if the flag is set.
>

Adding explicit ordering into the IO path is really interesting.  We toss a 
bunch of IO down to the lower layers with information about dependencies and 
let the lower layers figure it out.  James had a bunch of ideas here, but I'm 
afraid the only people that understood it were James and the whiteboard he 
was scribbling on.

The trick is to code the ordering in such a way that an IO failure breaks the 
chain, and that the filesystem has some sensible chance to deal with all 
these requests that have failed because an earlier write failed.

Also, once we go down the ordering road, it is really tempting to forget that 
ordering does ensure consistency but doesn't tell us the write actually 
happened.  fsync and friends need to hook into the dependency chain to wait 
for the barrier instead of waiting for the commit.

But, back to the short term for a second, what we need are some benchmarks for 
barriers on and off and some guidance from the ext34 maintainers about 
turning them on by default.  We shouldn't be pushing this FS integrity 
decision off on the distros.

My test prog is definitely a worst case, but I'm pretty confident that most 
mail server workloads end up doing similar IO.

A 16MB or 32MB disk cache is common these days, and that is a very sizable 
percentage of the jbd log size.  I think the potential for corruptions on 
power failure is only growing over time.

-chris
