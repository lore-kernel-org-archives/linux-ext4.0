From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Tue, 17 May 2011 09:48:59 +0900
Message-ID: <BANLkTimHgtzAYQuEXEVc3-qsTyVCohFK6w@mail.gmail.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
	<1305295404-12129-5-git-send-email-mgorman@suse.de>
	<4DCFAA80.7040109@jp.fujitsu.com>
	<1305519711.4806.7.camel@mulgrave.site>
	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
	<20110516084558.GE5279@suse.de>
	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
	<20110516102753.GF5279@suse.de>
	<BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	akpm@linux-foundation.org, colin.king@canonical.com,
	raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
	cl@linux.com, penberg@kernel.org, riel@redhat.com,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45092 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1EQAtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 20:49:01 -0400
In-Reply-To: <BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 8:50 AM, Minchan Kim <minchan.kim@gmail.com> wr=
ote:
> On Mon, May 16, 2011 at 7:27 PM, Mel Gorman <mgorman@suse.de> wrote:
>> On Mon, May 16, 2011 at 05:58:59PM +0900, Minchan Kim wrote:
>>> On Mon, May 16, 2011 at 5:45 PM, Mel Gorman <mgorman@suse.de> wrote=
:
>>> > On Mon, May 16, 2011 at 02:04:00PM +0900, Minchan Kim wrote:
>>> >> On Mon, May 16, 2011 at 1:21 PM, James Bottomley
>>> >> <James.Bottomley@hansenpartnership.com> wrote:
>>> >> > On Sun, 2011-05-15 at 19:27 +0900, KOSAKI Motohiro wrote:
>>> >> >> (2011/05/13 23:03), Mel Gorman wrote:
>>> >> >> > Under constant allocation pressure, kswapd can be in the si=
tuation where
>>> >> >> > sleeping_prematurely() will always return true even if kswa=
pd has been
>>> >> >> > running a long time. Check if kswapd needs to be scheduled.
>>> >> >> >
>>> >> >> > Signed-off-by: Mel Gorman<mgorman@suse.de>
>>> >> >> > ---
>>> >> >> > =C2=A0 mm/vmscan.c | =C2=A0 =C2=A04 ++++
>>> >> >> > =C2=A0 1 files changed, 4 insertions(+), 0 deletions(-)
>>> >> >> >
>>> >> >> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> >> >> > index af24d1e..4d24828 100644
>>> >> >> > --- a/mm/vmscan.c
>>> >> >> > +++ b/mm/vmscan.c
>>> >> >> > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_=
data_t *pgdat, int order, long remaining,
>>> >> >> > =C2=A0 =C2=A0 unsigned long balanced =3D 0;
>>> >> >> > =C2=A0 =C2=A0 bool all_zones_ok =3D true;
>>> >> >> >
>>> >> >> > + =C2=A0 /* If kswapd has been running too long, just sleep=
 */
>>> >> >> > + =C2=A0 if (need_resched())
>>> >> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
>>> >> >> > +
>>> >> >>
>>> >> >> Hmm... I don't like this patch so much. because this code doe=
s
>>> >> >>
>>> >> >> - don't sleep if kswapd got context switch at shrink_inactive=
_list
>>> >> >
>>> >> > This isn't entirely true: =C2=A0need_resched() will be false, =
so we'll follow
>>> >> > the normal path for determining whether to sleep or not, in ef=
fect
>>> >> > leaving the current behaviour unchanged.
>>> >> >
>>> >> >> - sleep if kswapd didn't
>>> >> >
>>> >> > This also isn't entirely true: whether need_resched() is true =
at this
>>> >> > point depends on a whole lot more that whether we did a contex=
t switch
>>> >> > in shrink_inactive. It mostly depends on how long we've been r=
unning
>>> >> > without giving up the CPU. =C2=A0Generally that will mean we'v=
e been round
>>> >> > the shrinker loop hundreds to thousands of times without sleep=
ing.
>>> >> >
>>> >> >> It seems to be semi random behavior.
>>> >> >
>>> >> > Well, we have to do something. =C2=A0Chris Mason first suspect=
ed the hang was
>>> >> > a kswapd rescheduling problem a while ago. =C2=A0We tried putt=
ing
>>> >> > cond_rescheds() in several places in the vmscan code, but to n=
o avail.
>>> >>
>>> >> Is it a result of =C2=A0test with patch of Hannes(ie, !pgdat_bal=
anced)?
>>> >>
>>> >> If it isn't, it would be nop regardless of putting cond_reshed a=
t vmscan.c.
>>> >> Because, although we complete zone balancing, kswapd doesn't sle=
ep as
>>> >> pgdat_balance returns wrong result. And at last VM calls
>>> >> balance_pgdat. In this case, balance_pgdat returns without any w=
ork as
>>> >> kswap couldn't find zones which have not enough free pages and g=
oto
>>> >> out. kswapd could repeat this work infinitely. So you don't have=
 a
>>> >> chance to call cond_resched.
>>> >>
>>> >> But if your test was with Hanne's patch, I am very curious how c=
ome
>>> >> kswapd consumes CPU a lot.
>>> >>
>>> >> > The need_resched() in sleeping_prematurely() seems to be about=
 the best
>>> >> > option. =C2=A0The other option might be just to put a cond_res=
ched() in
>>> >> > kswapd_try_to_sleep(), but that will really have about the sam=
e effect.
>>> >>
>>> >> I don't oppose it but before that, I think we have to know why k=
swapd
>>> >> consumes CPU a lot although we applied Hannes' patch.
>>> >>
>>> >
>>> > Because it's still possible for processes to allocate pages at th=
e same
>>> > rate kswapd is freeing them leading to a situation where kswapd d=
oes not
>>> > consider the zone balanced for prolonged periods of time.
>>>
>>> We have cond_resched in shrink_page_list, shrink_slab and balance_p=
gdat.
>>> So I think kswapd can be scheduled out although it's scheduled in
>>> after a short time as task scheduled also need page reclaim. Althou=
gh
>>> all task in system need reclaim, kswapd cpu 99% consumption is a
>>> natural result, I think.
>>> Do I miss something?
>>>
>>
>> Lets see;
>>
>> shrink_page_list() only applies if inactive pages were isolated
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0which in turn may not happen if all_unrec=
laimable is set in
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0shrink_zones(). If for whatver reason, al=
l_unreclaimable is
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0set on all zones, we can miss calling con=
d_resched().
>>
>> shrink_slab only applies if we are reclaiming slab pages. If the fir=
st
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker returns -1, we do not call cond_=
resched(). If that
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0first shrinker is dcache and __GFP_FS is =
not set, direct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0reclaimers will not shrink at all. Howeve=
r, if there are
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0enough of them running or if one of the o=
ther shrinkers
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0is running for a very long time, kswapd c=
ould be starved
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0acquiring the shrinker_rwsem and never re=
aching the
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched().
>
> Don't we have to move cond_resched?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 292582c..633e761 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -231,8 +231,10 @@ unsigned long shrink_slab(struct shrink_control =
*shrink,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (scanned =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D SW=
AP_CLUSTER_MAX;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!down_read_trylock(&shrinker_rwsem))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1; =C2=A0 =C2=
=A0 =C2=A0 /* Assume we'll be able to shrink next time */
> + =C2=A0 =C2=A0 =C2=A0 if (!down_read_trylock(&shrinker_rwsem)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out; /* Assum=
e we'll be able to shrink next time */
> + =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(shrinker, &shrinker_li=
st, list) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long =
long delta;
> @@ -280,12 +282,14 @@ unsigned long shrink_slab(struct shrink_control=
 *shrink,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0count_vm_events(SLABS_SCANNED, this_scan);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0total_scan -=3D this_scan;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cond_resched();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker->nr +=
=3D total_scan;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cond_resched();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0up_read(&shrinker_rwsem);
> +out:
> + =C2=A0 =C2=A0 =C2=A0 cond_resched();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
>
>
>>
>> balance_pgdat() only calls cond_resched if the zones are not
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0balanced. For a high-order allocation tha=
t is balanced, it
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0checks order-0 again. During that window,=
 order-0 might have
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0become unbalanced so it loops again for o=
rder-0 and returns
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0that was reclaiming for order-0 to kswapd=
(). It can then find
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0that a caller has rewoken kswapd for a hi=
gh-order and re-enters
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0balance_pgdat() without ever have called =
cond_resched().
>
> If kswapd reclaims order-o followed by high order, it would have a
> chance to call cond_resched in shrink_page_list. But if all zones are
> all_unreclaimable is set, balance_pgdat could return any work.

    Typo : without any work.

--=20
Kind regards,
Minchan Kim
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
