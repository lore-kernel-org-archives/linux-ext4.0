From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
 by fsync
Date: Tue, 30 Nov 2010 12:26:37 +1100
Message-ID: <20101130122637.5d97fd3b@notabene.brown>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
	<20101130113906.176ffcad@notabene.brown>
	<4CF449F4.3010303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab0K3B0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 20:26:55 -0500
In-Reply-To: <4CF449F4.3010303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 29 Nov 2010 19:48:52 -0500 Ric Wheeler <rwheeler@redhat.com> wrote:

> On 11/29/2010 07:39 PM, Neil Brown wrote:
> > On Mon, 29 Nov 2010 14:05:36 -0800 "Darrick J. Wong"<djwong@us.ibm.com>
> > wrote:
> >
> >> On certain types of hardware, issuing a write cache flush takes a considerable
> >> amount of time.  Typically, these are simple storage systems with write cache
> >> enabled and no battery to save that cache after a power failure.  When we
> >> encounter a system with many I/O threads that write data and then call fsync
> >> after more transactions accumulate, ext4_sync_file performs a data-only flush,
> >> the performance of which is suboptimal because each of those threads issues its
> >> own flush command to the drive instead of trying to coordinate the flush,
> >> thereby wasting execution time.
> >>
> >> Instead of each fsync call initiating its own flush, there's now a flag to
> >> indicate if (0) no flushes are ongoing, (1) we're delaying a short time to
> >> collect other fsync threads, or (2) we're actually in-progress on a flush.
> >>
> >> So, if someone calls ext4_sync_file and no flushes are in progress, the flag
> >> shifts from 0->1 and the thread delays for a short time to see if there are any
> >> other threads that are close behind in ext4_sync_file.  After that wait, the
> >> state transitions to 2 and the flush is issued.  Once that's done, the state
> >> goes back to 0 and a completion is signalled.
> > I haven't seen any of the preceding discussion do I might be missing
> > something important, but this seems needlessly complex and intrusive.
> > In particular, I don't like adding code to md to propagate these timings up
> > to the fs, and I don't the arbitrary '2ms' number.
> >
> > Would it not be sufficient to simply gather flushes while a flush is pending.
> > i.e
> >    - if no flush is pending, set the 'flush pending' flag, submit a flush,
> >      then clear the flag.
> >    - if a flush is pending, then wait for it to complete, and then submit a
> >      single flush on behalf of all pending flushes.
> >
> > That way when flush is fast, you do a flush every time, and when it is slow
> > you gather multiple flushes together.
> > I think it would issues a few more flushes than your scheme, but it would be
> > a much neater solution.  Have you tried that and found it to be insufficient?
> >
> > Thanks,
> > NeilBrown
> >
> 
> The problem with that is that you can introduce a wait for the next flush longer 
> than it would take to complete the flush. Having the wait adjust itself 
> according to the speed of the device is much better I think....
> 

Hi Ric,

  You certainly can introduce a wait longer than the flush would take, but
  the proposed code does that too.

  The proposed code waits "average flush time", then submits a flush for
  all threads that are waiting.
  My suggestion submits a flush (Which on average takes 'average flush time')
  and then submits a flush for all threads that started waiting during that
  time.

  So we do get two flushes rather than one, but also the flush starts
  straight away, so will presumably finish sooner.

  I do have the wait 'adjust itself according to the speed of the device' by
  making flushes wait for one flush to complete.


  I'm guessing that the situation where this is an issue is when you have a
  nearly constant stream of flush requests - is that right?

  In that case:
     - the current code would submit lots of over-lapping flush requests,
       reducing the opportunity for optimising multiple requests in the
       device,
     - my proposal would submit a steady sequence of flushes with minimal
       gaps
     - the code from Darrick would submit a steady sequence of flush requests
       which would be separated by pauses of 'average flush time'.
       This would increase latency, but might increase throughput too, I
       don't know.

  So it seems to me that the performance differences between my suggesting
  and Darrick's proposal are not obvious. So some testing would be
  interesting.

 I was going to suggest changes to Darrick's code to demonstrate my idea, but
 I think that code is actually wrong, so it wouldn't be a good base to start.

 In particular, the usage of a continuation seems racy.
 As soon as one thread sets EXT4_FLUSH_IDLE, another thread could call
 INIT_COMPLETION, before some other threads has had a chance to wake up and
 test the completion status in wait_for_completion.
 The effect is that the other thread would wait for an extra time+flush which
 it shouldn't have to.  So it isn't a serious race, but it looks wrong.

NeilBrown

