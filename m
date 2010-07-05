From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] Support discard if at least one underlying device
 supports it
Date: Mon, 5 Jul 2010 07:32:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007050718250.17168@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com> <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
 <20100702204709.GB21915@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	axboe@kernel.dk, dmonakhov@openvz.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100702204709.GB21915@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Fri, 2 Jul 2010, Mike Snitzer wrote:

> On Fri, Jul 02 2010 at  4:00pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Fri, 2 Jul 2010, Mikulas Patocka wrote:
> > 
> > > > As we discussed, we have a challenge where we need DM to avoid issuing
> > > > a barrier before the discard IFF a target doesn't support the discard
> > > > (which the barrier is paired with).
> > > > 
> > > > My understanding is that blkdev_issue_discard() only cares if the
> > > > discard was supported.  Barrier is used just to decorate the discard
> > > > (for correctness).  So by returning -EOPNOTSUPP we're saying the discard
> > > > isn't supported; we're not making any claims about the implict barrier,
> > > > so best to avoid the barrier entirely.
> > > > 
> > > > Otherwise we'll be issuing unnecessary barriers (and associated
> > > > performance loss).
> > > > 
> > > > So yet another TODO item... Anyway:
> > > > 
> > > > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > > 
> > > Unnecessary barriers are issued anyway. With each freed extent.
> > > 
> > > The code must issue a "SYNCHRONIZE CACHE" to flush cache for previous 
> > > writes, then "UNMAP" and then another "SYNCHRONIZE CACHE" to commit that 
> > > unmap to disk. And this in loop for all extents in 
> > > "release_blocks_on_commit".
> > > 
> > > One idea behind "discard barriers" was to submit a discard request and not 
> > > wait for it. Then the request would need a barrier so that it doesn't get 
> > > reordered with further writes (that may potentially write to the same area 
> > > as the discarded area). But discard isn't used this way anyway, 
> > > sb_issue_discard waits for completion, so the barrier isn't needed.
> > > 
> > > Even if ext4 developers wanted asynchronous discard requests, they should 
> > > fire all the discards at once and then submit one zero-sized barrier. Not 
> > > barrier with each discard request.
> > > 
> > > This is up to ext4 developers to optimize and remove the barriers and we 
> > > can't do anything with it. Just send "SYNCHRONIZE 
> > > CACHE"+"UNMAP"+"SYNCHRONIZE CACHE" like the barrier specification wants...
> > > 
> > > Mikulas
> > 
> > BTW. I understand that the current dm implementation will send two useless 
> > consecutive "SYNCHRONIZE CACHE" commands discard is directed to the part 
> > of the device that doesn't support it.
> 
> Issue 1 ^^^
> 
> > But the problem is that when you use discard on a part of the device that 
> > supports discard, it also sends two useless "SYNCHRONIZE CACHE" commands 
> > --- they are useless for functionality, but mandated by the barrier 
> > specification.
> 
> Issue 2 ^^^
> 
> Those are 2 different issues.  Please don't join them as if they are one
> in the same.  DM should treat a discard as a first class request (which
> may or may not have a barrier).

What I mean --- if you fix Issue 2, Issue 1 is no longer a problem.

> If a region doesn't support the discard
> DM has no business processing anything related to the discard (barriers
> included).  It is as simple as that.

You can optimize out the second SYNCHRONIZE CACHE, but not the first one 
(because when it is sent, we don't know if the discard will succeed or 
not).

Basically, the fix is to prefix the second dm_flush in process_barrier 
with if (md->barrier_error != -EOPNOTSUPP).

The "barrier+discard" concept is problematic anyway. If we specify that 
"barrier+discard" request doesn't have to do the barrier if discard fails 
(as it is currently), then the request is useless to maintain disk 
integrity because the discard may fail anytime (and so the barrier).

I think they will eventually remove "barrier+discard" from the filesystems 
at all.

Mikulas
