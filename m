From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Mon, 23 Apr 2012 09:23:03 +0100
Message-ID: <1335169383.4191.9.camel@dabdike.lan>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
	 <4F912880.70708@panasas.com>
	 <alpine.LFD.2.00.1204201120060.27750@dhcp-27-109.brq.redhat.com>
	 <1334919662.5879.23.camel@dabdike>
	 <alpine.LFD.2.00.1204201313231.27750@dhcp-27-109.brq.redhat.com>
	 <1334932928.13001.11.camel@dabdike> <20120420145856.GC24486@thunk.org>
	 <CAHGf_=oWtpgRfqaZ1YDXgZoQHcFY0=DYVcwXYbFtZt2v+K532w@mail.gmail.com>
	 <CAPa8GCDkP_53VGAeQPeYgf3GW3KZ09BvnqduArQE7svf2mMj4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
	Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-mm@kvack.org
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPa8GCDkP_53VGAeQPeYgf3GW3KZ09BvnqduArQE7svf2mMj4A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2012-04-22 at 16:30 +1000, Nick Piggin wrote:
> On 22 April 2012 09:56, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> > On Fri, Apr 20, 2012 at 10:58 AM, Ted Ts'o <tytso@mit.edu> wrote:
> >> On Fri, Apr 20, 2012 at 06:42:08PM +0400, James Bottomley wrote:
> >>>
> >>> I'm not at all wedded to O_HOT and O_COLD; I think if we establish a
> >>> hint hierarchy file->page cache->device then we should, of course,
> >>> choose the best API and naming scheme for file->page cache.  The only
> >>> real point I was making is that we should tie in the page cache, and
> >>> currently it only knows about "hot" and "cold" pages.
> >>
> >> The problem is that "hot" and "cold" will have different meanings from
> >> the perspective of the file system versus the page cache.  The file
> >> system may consider a file "hot" if it is accessed frequently ---
> >> compared to the other 2 TB of data on that HDD.  The memory subsystem
> >> will consider a page "hot" compared to what has been recently accessed
> >> in the 8GB of memory that you might have your system.  Now consider
> >> that you might have a dozen or so 2TB disks that each have their "hot"
> >> areas, and it's not at all obvious that just because a file, or even
> >> part of a file is marked "hot", that it deserves to be in memory at
> >> any particular point in time.
> >
> > So, this have intentionally different meanings I have no seen a reason why
> > fs uses hot/cold words. It seems to bring a confusion.
> 
> Right. It has nothing to do with hot/cold usage in the page allocator,
> which is about how many lines of that page are in CPU cache.

Well, no it's a similar concept:  we have no idea whether the page is
cached or not.  What we do is estimate that by elapsed time since we
last touched the page.  In some sense, this is similar to the fs
definition: a hot page hint would mean we expect to touch the page
frequently and a cold page means we wouldn't.  i.e. for a hot page, the
elapsed time between touches would be short and for a cold page it would
be long.  Now I still think there's a mismatch in the time scales: a
long elapsed time for mm making the page cold isn't necessarily the same
long elapsed time for the file, because the mm idea is conditioned by
local events (like memory pressure).

> However it could be propagated up to page reclaim level, at least.
> Perhaps readahead/writeback too. But IMO it would be better to nail down
> the semantics for block and filesystem before getting worried about that.

Sure ... I just forwarded the email in case mm people had an interest.
If you want FS and storage to develop the hints first and then figure
out if we can involve the page cache, that's more or less what was
happening anyway.

> > But I don't know full story of this feature and I might be overlooking
> > something.
> 
> Also, "hot" and "cold" (as others have noted) is a big hammer that perhaps
> catches a tiny subset of useful work (probably more likely: benchmarks).
> 
> Is it read often? Written often? Both? Are reads and writes random or linear?
> Is it latency bound, or throughput bound? (i.e., are queue depths high or
> low?)
> 
> A filesystem and storage device might care about all of these things.
> Particularly if you have something more advanced than a single disk.
> Caches, tiers of storage, etc.

Experience has taught me to be wary of fine grained hints: they tend to
be more trouble than they're worth (the definitions are either
inaccurate or so tediously precise that no-one can be bothered to read
them).  A small set of broad hints is usually more useable than a huge
set of fine grained ones, so from that point of view, I like the
O_HOT/O_COLD ones.

James


