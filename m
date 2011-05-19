From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/2] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Thu, 19 May 2011 10:19:06 +0100
Message-ID: <20110519091906.GT5279@suse.de>
References: <1305558417-24354-1-git-send-email-mgorman@suse.de>
 <1305558417-24354-3-git-send-email-mgorman@suse.de>
 <20110516141654.2728f05a.akpm@linux-foundation.org>
 <1305614225.6008.19.camel@mulgrave.site>
 <20110517162226.96974d89.akpm@linux-foundation.org>
 <20110518094718.GP5279@suse.de>
 <BANLkTimtHL15Dc9xg8omQOW8wR0q-RQdww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	stable <stable@kernel.org>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832Ab1ESJTS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 05:19:18 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimtHL15Dc9xg8omQOW8wR0q-RQdww@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2011 at 07:42:29AM +0900, Minchan Kim wrote:
> On Wed, May 18, 2011 at 6:47 PM, Mel Gorman <mgorman@suse.de> wrote:
> > On Tue, May 17, 2011 at 04:22:26PM -0700, Andrew Morton wrote:
> >> On Tue, 17 May 2011 10:37:04 +0400
> >> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >>
> >> > On Mon, 2011-05-16 at 14:16 -0700, Andrew Morton wrote:
> >> > > On Mon, 16 May 2011 16:06:57 +0100
> >> > > Mel Gorman <mgorman@suse.de> wrote:
> >> > >
> >> > > > Under constant allocation pressure, kswapd can be in the sit=
uation where
> >> > > > sleeping_prematurely() will always return true even if kswap=
d has been
> >> > > > running a long time. Check if kswapd needs to be scheduled.
> >> > > >
> >> > > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> >> > > > Acked-by: Rik van Riel <riel@redhat.com>
> >> > > > ---
> >> > > > =A0mm/vmscan.c | =A0 =A04 ++++
> >> > > > =A01 files changed, 4 insertions(+), 0 deletions(-)
> >> > > >
> >> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> > > > index af24d1e..4d24828 100644
> >> > > > --- a/mm/vmscan.c
> >> > > > +++ b/mm/vmscan.c
> >> > > > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_d=
ata_t *pgdat, int order, long remaining,
> >> > > > =A0 =A0 =A0 =A0 unsigned long balanced =3D 0;
> >> > > > =A0 =A0 =A0 =A0 bool all_zones_ok =3D true;
> >> > > >
> >> > > > + =A0 =A0 =A0 /* If kswapd has been running too long, just s=
leep */
> >> > > > + =A0 =A0 =A0 if (need_resched())
> >> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> >> > > > +
> >> > > > =A0 =A0 =A0 =A0 /* If a direct reclaimer woke kswapd within =
HZ/10, it's premature */
> >> > > > =A0 =A0 =A0 =A0 if (remaining)
> >> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> >> > >
> >> > > I'm a bit worried by this one.
> >> > >
> >> > > Do we really fully understand why kswapd is continuously runni=
ng like
> >> > > this? =A0The changelog makes me think "no" ;)
> >> > >
> >> > > Given that the page-allocating process is madly reclaiming pag=
es in
> >> > > direct reclaim (yes?) and that kswapd is madly reclaiming page=
s on a
> >> > > different CPU, we should pretty promptly get into a situation =
where
> >> > > kswapd can suspend itself. =A0But that obviously isn't happeni=
ng. =A0So
> >> > > what *is* going on?
> >> >
> >> > The triggering workload is a massive untar using a file on the s=
ame
> >> > filesystem, so that's a continuous stream of pages read into the=
 cache
> >> > for the input and a stream of dirty pages out for the writes. =A0=
We
> >> > thought it might have been out of control shrinkers, so we alrea=
dy
> >> > debugged that and found it wasn't. =A0It just seems to be an imb=
alance in
> >> > the zones that the shrinkers can't fix which causes
> >> > sleeping_prematurely() to return true almost indefinitely.
> >>
> >> Is the untar disk-bound? =A0The untar has presumably hit the write=
back
> >> dirty_ratio? =A0So its rate of page allocation is approximately eq=
ual to
> >> the write speed of the disks?
> >>
> >
> > A reasonable assumption but it gets messy.
> >
> >> If so, the VM is consuming 100% of a CPU to reclaim pages at a mer=
e
> >> tens-of-megabytes-per-second. =A0If so, there's something seriousl=
y wrong
> >> here - under favorable conditions one would expect reclaim to free=
 up
> >> 100,000 pages/sec, maybe more.
> >>
> >> If the untar is not disk-bound and the required page reclaim rate =
is
> >> equal to the rate at which a CPU can read, decompress and write to
> >> pagecache then, err, maybe possible. =A0But it still smells of
> >> inefficient reclaim.
> >>
> >
> > I think it's higher than just the rate of data but couldn't guess b=
y
> > how much exactly. Reproducing this locally would have been nice but
> > the following conditions are likely happening on the problem machin=
e.
> >
> > =A0 SLUB is using high-orders for its slabs, kswapd and reclaimers =
are
> > =A0 reclaiming at a faster rate than required for just the data. SL=
UB
> > =A0 is using order-2 allocs for inodes so every 18 files created by
> > =A0 untar, we need an order-2 page. For ext4_io_end, we need order-=
3
> > =A0 allocs and we are allocating these due to delayed block allocat=
ion.
> >
> > =A0 So for example: 50 files, each less than 1 page in size needs 5=
0
> > =A0 order-0 pages, 3 order-2 page and 2 order-3 pages
> >
> > =A0 To satisfy the high order pages, we are reclaiming at least 28
> > =A0 pages. For compaction, we are migrating these so we are allocat=
ing
> > =A0 a further 28 pages and then copying putting further pressure on
> > =A0 the system. We may do this multiple times as order-0 allocation=
s
> > =A0 could be breaking up the pages again. Without compaction, we ar=
e
> > =A0 only reclaiming but can get stalled for significant periods of
> > =A0 time if dirty or writeback pages are encountered in the contigu=
ous
> > =A0 blocks and can reclaim too many pages quite easily.
> >
> > So the rate of allocation required to write out data is higher than
> > just the data rate. The reclaim rate could be just fine but the num=
ber
> > of pages we need to reclaim to allocate slab objects can be screwy.
> >
> >> > > Secondly, taking an up-to-100ms sleep in response to a need_re=
sched()
> >> > > seems pretty savage and I suspect it risks undesirable side-ef=
fects. =A0A
> >> > > plain old cond_resched() would be more cautious. =A0But presum=
ably
> >> > > kswapd() is already running cond_resched() pretty frequently, =
so why
> >> > > didn't that work?
> >> >
> >> > So the specific problem with cond_resched() is that kswapd is st=
ill
> >> > runnable, so even if there's other work the system can be gettin=
g on
> >> > with, it quickly comes back to looping madly in kswapd. =A0If we=
 return
> >> > false from sleeping_prematurely(), we stop kswapd until its woke=
n up to
> >> > do more work. =A0This manifests, even on non sandybridge systems=
 that
> >> > don't hang as a lot of time burned in kswapd.
> >> >
> >> > I think the sandybridge bug I see on the laptop is that cond_res=
ched()
> >> > is somehow ineffective: =A0kswapd is usually hogging one CPU and=
 there are
> >> > runnable processes but they seem to cluster on other CPUs, leavi=
ng
> >> > kswapd to spin at close to 100% system time.
> >> >
> >> > When the problem was first described, we tried sprinkling more
> >> > cond_rescheds() in the shrinker loop and it didn't work.
> >>
> >> Seems to me that kswapd for some reason is doing too much work. =A0=
Or,
> >> more specifically is doing its work very inefficiently. =A0Making =
kswapd
> >> take arbitrary naps when it's misbehaving didn't fix that misbehav=
iour!
> >>
> >
> > It is likely to be doing work inefficiently in one of two ways
> >
> > =A01. We are reclaiming far more pages than required by the data
> > =A0 =A0 for slab objects
> >
> > =A02. The rate we are reclaiming is fast enough that dirty pages ar=
e
> > =A0 =A0 reaching the end of the LRU quickly
> >
> > The latter part is also important. I doubt we are getting stalled i=
n
> > writepage as this is new data being written to disk to blocks aren'=
t
> > allocated yet but kswapd is encountering the dirty_ratio of pages
> > on the LRU and churning them through the LRU and reclaims the clean
> > pages in between.
> >
> > In effect, this "sorts" the LRU lists so the dirty pages get groupe=
d
> > together. At worst on a 2G system such as James', we have 104857
> > (20% of memory in pages) pages together on the LRU, all dirty and
> > all being skipped over by kswapd and direct reclaimers. This is at
> > least 3276 takings of the zone LRU lock assuming we isolate pages i=
n
> > groups of SWAP_CLUSTER_MAX which a lot of list walking and CPU usag=
e
> > for no pages reclaimed.
> >
> > In this case, kswapd might as well take a brief nap as it can't cle=
an
> > the pages so the flusher threads can get some work done.
> >
> >> It would be interesting to watch kswapd's page reclaim inefficienc=
y
> >> when this is happening: /proc/vmstat:pgscan_kswapd_* versus
> >> /proc/vmstat:kswapd_steal. =A0If that ration is high then kswapd i=
s
> >> scanning many pages and not reclaiming them.
> >>
> >> But given the prominence of shrink_slab in the traces, perhaps tha=
t
> >> isn't happening.
> >>
> >
> > As we are aggressively shrinking slab, we can reach the stage where
> > we scan the requested number of objects and reclaim none of them
> > potentially setting zone->all_unreclaimable to 1 if a lot of scanni=
ng
> > has also taken place recently without pages being freed. Once this
> > happens, kswapd isn't even trying to reclaim pages and is instead s=
tuck
> > in shrink_slab until a page is freed clearing zone->all_unreclaimab=
le
> > and zone->pages-scanned.
>=20
> Why does it stuck in shrink_slab?
> If the zone is trouble to reclaim(ie, all_unreclaimable is set),
> kswapd will poll the zone only in case of DEF_PRIORITY(ie, small
> window) for when the problem goes away.

"stuck in shrink" was a poor choice of words. I should have said we
can spend a lot of time in there.

True, kswapd will only poll the zones while all_unreclaimable is
set but it only takes one page to be freed to the per-cpu list to
clear all_unreclaimable again. Once any zone has all_unreclaimable
cleared, the watermarks are checked but with enough direct
reclaimers, it's possible watermarks are met so shrink_zone is not
called but shrink_slab is called anyway. Depending on the result,
all_unreclaimable can get set again (possibly incorrectly as there
is simply no reclaimable slab objects rather than the zone is truely
unreclaimable). Another scenario is all zones except ZONE_DMA have
all_unreclaimable set when kswapd runs. kswapd finds the watermarks
to be ok as the zone is only lightly used so skips shrink_zone()
but calls shrink_slab() anyway.

Both of these situations would allow kswapd to use a lot of CPU while
spending a significant percentage of it in shrink_slab().

--=20
Mel Gorman
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
