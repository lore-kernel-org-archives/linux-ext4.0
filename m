From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 21:23:36 +0200
Message-ID: <20100408192336.GV10103@kernel.dk>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100407214631.GL3206@redhat.com> <20100408110442.GK10103@kernel.dk> <20100408140515.GB10879@redhat.com> <20100408140944.GQ10103@kernel.dk> <x49ljcy9g4t.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50847 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0DHTXi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 15:23:38 -0400
Content-Disposition: inline
In-Reply-To: <x49ljcy9g4t.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 08 2010, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > Precisely. The next question would be how to control the yielding. In
> > this particular case, you want to be yielding to a specific cfqq. IOW,
> > you essentially want to pass your slide on to that queue. The way the
> > above is implemented, you could easily just switch to another unrelated
> > queue. And if that is done, fairness is skewed without helping the
> > yielding process at all (which was the intention).
> 
> Well, that's true in part.  Prior to this patch, the process would idle,
> keeping all other cfq_queues on the system from making progress.  With
> this patch, at least *somebody* else makes progress, getting you closer
> to running the journal thread that you're blocked on.  Ideally, you'd
> want the thread you're waiting on to get disk time next, sure.  You
> would have to pass the process information down to the I/O scheduler for
> that, and I'm not sure that the file system code knows which process to
> hand off to.  Does it?
> 
> Do we really want to go down this road at all?  I'm not convinced.

Don't get me wrong, neither am I. I'm just thinking out loud and
pondering. As a general mechanism, yield to a specific cfqq is going to
be tricky and doing a generic yield to signal that _someone_ else must
make progress before we can is better than nothing.

Continuing that train of thought, I don't think we'll ever need full
'yield to X' functionality where 'X' is a really specific target. But
for this fsync case, we know at least what we are yielding to and it
seems like a shame to throw away that information. So you could include
a hint of what to yield to, which cfq could factor in.

Dunno, I need to think a bit about the cleanliness of such an approach.
We can definitely use your patch as a starting point.

-- 
Jens Axboe

