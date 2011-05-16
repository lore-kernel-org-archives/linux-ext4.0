From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Mon, 16 May 2011 11:27:53 +0100
Message-ID: <20110516102753.GF5279@suse.de>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
 <1305295404-12129-5-git-send-email-mgorman@suse.de>
 <4DCFAA80.7040109@jp.fujitsu.com>
 <1305519711.4806.7.camel@mulgrave.site>
 <BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
 <20110516084558.GE5279@suse.de>
 <BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	akpm@linux-foundation.org, colin.king@canonical.com,
	raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
	cl@linux.com, penberg@kernel.org, riel@redhat.com,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1EPK2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 06:28:01 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 05:58:59PM +0900, Minchan Kim wrote:
> On Mon, May 16, 2011 at 5:45 PM, Mel Gorman <mgorman@suse.de> wrote:
> > On Mon, May 16, 2011 at 02:04:00PM +0900, Minchan Kim wrote:
> >> On Mon, May 16, 2011 at 1:21 PM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> > On Sun, 2011-05-15 at 19:27 +0900, KOSAKI Motohiro wrote:
> >> >> (2011/05/13 23:03), Mel Gorman wrote:
> >> >> > Under constant allocation pressure, kswapd can be in the situ=
ation where
> >> >> > sleeping_prematurely() will always return true even if kswapd=
 has been
> >> >> > running a long time. Check if kswapd needs to be scheduled.
> >> >> >
> >> >> > Signed-off-by: Mel Gorman<mgorman@suse.de>
> >> >> > ---
> >> >> > =A0 mm/vmscan.c | =A0 =A04 ++++
> >> >> > =A0 1 files changed, 4 insertions(+), 0 deletions(-)
> >> >> >
> >> >> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> >> > index af24d1e..4d24828 100644
> >> >> > --- a/mm/vmscan.c
> >> >> > +++ b/mm/vmscan.c
> >> >> > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_da=
ta_t *pgdat, int order, long remaining,
> >> >> > =A0 =A0 unsigned long balanced =3D 0;
> >> >> > =A0 =A0 bool all_zones_ok =3D true;
> >> >> >
> >> >> > + =A0 /* If kswapd has been running too long, just sleep */
> >> >> > + =A0 if (need_resched())
> >> >> > + =A0 =A0 =A0 =A0 =A0 return false;
> >> >> > +
> >> >>
> >> >> Hmm... I don't like this patch so much. because this code does
> >> >>
> >> >> - don't sleep if kswapd got context switch at shrink_inactive_l=
ist
> >> >
> >> > This isn't entirely true: =A0need_resched() will be false, so we=
'll follow
> >> > the normal path for determining whether to sleep or not, in effe=
ct
> >> > leaving the current behaviour unchanged.
> >> >
> >> >> - sleep if kswapd didn't
> >> >
> >> > This also isn't entirely true: whether need_resched() is true at=
 this
> >> > point depends on a whole lot more that whether we did a context =
switch
> >> > in shrink_inactive. It mostly depends on how long we've been run=
ning
> >> > without giving up the CPU. =A0Generally that will mean we've bee=
n round
> >> > the shrinker loop hundreds to thousands of times without sleepin=
g.
> >> >
> >> >> It seems to be semi random behavior.
> >> >
> >> > Well, we have to do something. =A0Chris Mason first suspected th=
e hang was
> >> > a kswapd rescheduling problem a while ago. =A0We tried putting
> >> > cond_rescheds() in several places in the vmscan code, but to no =
avail.
> >>
> >> Is it a result of =A0test with patch of Hannes(ie, !pgdat_balanced=
)?
> >>
> >> If it isn't, it would be nop regardless of putting cond_reshed at =
vmscan.c.
> >> Because, although we complete zone balancing, kswapd doesn't sleep=
 as
> >> pgdat_balance returns wrong result. And at last VM calls
> >> balance_pgdat. In this case, balance_pgdat returns without any wor=
k as
> >> kswap couldn't find zones which have not enough free pages and got=
o
> >> out. kswapd could repeat this work infinitely. So you don't have a
> >> chance to call cond_resched.
> >>
> >> But if your test was with Hanne's patch, I am very curious how com=
e
> >> kswapd consumes CPU a lot.
> >>
> >> > The need_resched() in sleeping_prematurely() seems to be about t=
he best
> >> > option. =A0The other option might be just to put a cond_resched(=
) in
> >> > kswapd_try_to_sleep(), but that will really have about the same =
effect.
> >>
> >> I don't oppose it but before that, I think we have to know why ksw=
apd
> >> consumes CPU a lot although we applied Hannes' patch.
> >>
> >
> > Because it's still possible for processes to allocate pages at the =
same
> > rate kswapd is freeing them leading to a situation where kswapd doe=
s not
> > consider the zone balanced for prolonged periods of time.
>=20
> We have cond_resched in shrink_page_list, shrink_slab and balance_pgd=
at.
> So I think kswapd can be scheduled out although it's scheduled in
> after a short time as task scheduled also need page reclaim. Although
> all task in system need reclaim, kswapd cpu 99% consumption is a
> natural result, I think.
> Do I miss something?
>=20

Lets see;

shrink_page_list() only applies if inactive pages were isolated
	which in turn may not happen if all_unreclaimable is set in
	shrink_zones(). If for whatver reason, all_unreclaimable is
	set on all zones, we can miss calling cond_resched().

shrink_slab only applies if we are reclaiming slab pages. If the first
	shrinker returns -1, we do not call cond_resched(). If that
	first shrinker is dcache and __GFP_FS is not set, direct
	reclaimers will not shrink at all. However, if there are
	enough of them running or if one of the other shrinkers
	is running for a very long time, kswapd could be starved
	acquiring the shrinker_rwsem and never reaching the
	cond_resched().

balance_pgdat() only calls cond_resched if the zones are not
	balanced. For a high-order allocation that is balanced, it
	checks order-0 again. During that window, order-0 might have
	become unbalanced so it loops again for order-0 and returns
	that was reclaiming for order-0 to kswapd(). It can then find
	that a caller has rewoken kswapd for a high-order and re-enters
	balance_pgdat() without ever have called cond_resched().

While it appears unlikely, there are bad conditions which can result
in cond_resched() being avoided.

--=20
Mel Gorman
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
