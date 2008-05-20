From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 17:27:10 +0100
Message-ID: <20080520162710.GM16676@shareable.org>
References: <482DDA56.6000301@redhat.com> <200805190926.41970.chris.mason@oracle.com> <20080520153658.GH16676@shareable.org> <200805201202.54420.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:48997 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYETQ1b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 12:27:31 -0400
Content-Disposition: inline
In-Reply-To: <200805201202.54420.chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason wrote:
> > You don't need the barrier after in some cases, or it can be deferred
> > until a better time.  E.g. when the disk write cache is probably empty
> > (some time after write-idle), barrier flushes may take the same time
> > as NOPs.
> 
> I hesitate to get too fancy here, if the disk is idle we probably
> won't notice the performance gain.

I think you're right, but it's hard to be sure.  One of the problems
with barrier-implemented-as-flush-all is that it flushes data=ordered
data, even when that's not wanted, and there can be a lot of data in
the disk's write cache, spread over many seeks.

Then it's good to delay barrier-flushes to batch metadata commits, but
good to issue the barrier-flushes prior to large batches of
data=ordered data, so the latter can be survive in the disk write
cache for seek optimisations with later requests which aren't yet
known.

All this sounds complicated at the JBD layer, and IMHO much simpler at
the request elevator layer.

> But, it complicates the decision about when you're allowed to dirty
> a metadata block for writeback.  It used to be dirty-after-commit
> and it would change to dirty-after-barrier.  I suspect that is some
> significant surgery into jbd.

Rather than tracking when it's "allowed" to dirty a metadata block, it
will be simpler to keep a flag saying "barrier needed", and just issue
the barrier prior to writing a metadata block, if the flag is set.

So metadata write scheduling doesn't need to be changed at all.  That
will be quite simple.

You might still change the scheduling, but only as a performance
heuristic in any way which turns out to be easy.

Really, that flag should live in the request elevator instead, where
it could do more good.  I.e. WRITE_BARRIER wouldn't actually issue a
barrier op to disk after writing.  It would just set a request
elevator flag, so a barrier op is issued prior to the next WRITE.
That road opens some nice optimisations on software RAID, which aren't
possible if it's done at the JBD layer.

> Also, since a commit isn't really done until the barrier is done, you can't 
> reuse blocks freed by the committing transaction until after the barrier, 
> which means changes in the deletion handling code.  

Good point.

In this case, re-allocating time isn't the problem: actually writing
to them is.  Writes to recycled block require to be ordered after
commits which recycled them.

As above, just issue the barrier prior to the next write which needs
to be ordered - effectively it's glued on the front of the write op.

This comes for free with no change to deletion code (wow :-) if the
only operations are WRITE_BARRIER (= flush before and after or
equivalent) and WRITE (ordered by WRITE_BARRIER).

> > What's more, barriers can be deferred past data=ordered in-place data
> > writes, although that's not always an optimisation.
> >
> 
> It might be really interesting to have a 
> i'm-about-to-barrier-find-some-io-to-run call.  Something along the lines of 
> draining the dirty pages when the drive is woken up in laptop mode.  There's 
> lots of fun with page lock vs journal lock ordering, but Jan has a handle on 
> that I think.

I'm suspecting the opposite might be better.

I'm-about-to-barrier-please-move-the-barrier-in-front-of-unordered-writes.
The more writes you _don't_ flush synchronously, the more
opportunities you give the disk's cache to reduce seeking.

It's only a hunch though.

-- Jamie
