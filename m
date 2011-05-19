From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] mm: vmscan: Correctly check if reclaimer should schedule
 during shrink_slab
Date: Thu, 19 May 2011 09:09:37 +0900
Message-ID: <BANLkTimUJeTbWV_0BzgjrDjY=Wpc-PaG5Q@mail.gmail.com>
References: <1305295404-12129-5-git-send-email-mgorman@suse.de>
	<4DCFAA80.7040109@jp.fujitsu.com>
	<1305519711.4806.7.camel@mulgrave.site>
	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
	<20110516084558.GE5279@suse.de>
	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
	<20110516102753.GF5279@suse.de>
	<BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
	<20110517103840.GL5279@suse.de>
	<1305640239.2046.27.camel@lenovo>
	<20110517161508.GN5279@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
	cl@linux.com, penberg@kernel.org, riel@redhat.com,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>,
	Colin Ian King <colin.king@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39727 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1ESAJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 20:09:39 -0400
In-Reply-To: <20110517161508.GN5279@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Colin.

Sorry for bothering you. :(
I hope this test is last.

We(Mel, KOSAKI and me) finalized opinion.

Could you test below patch with patch[1/4] of Mel's series(ie,
!pgdat_balanced  of sleeping_prematurely)?
If it is successful, we will try to merge this version instead of
various cond_resched sprinkling version.


On Wed, May 18, 2011 at 1:15 AM, Mel Gorman <mgorman@suse.de> wrote:
> It has been reported on some laptops that kswapd is consuming large
> amounts of CPU and not being scheduled when SLUB is enabled during
> large amounts of file copying. It is expected that this is due to
> kswapd missing every cond_resched() point because;
>
> shrink_page_list() calls cond_resched() if inactive pages were isolat=
ed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0which in turn may not happen if all_unrecl=
aimable is set in
> =C2=A0 =C2=A0 =C2=A0 =C2=A0shrink_zones(). If for whatver reason, all=
_unreclaimable is
> =C2=A0 =C2=A0 =C2=A0 =C2=A0set on all zones, we can miss calling cond=
_resched().
>
> balance_pgdat() only calls cond_resched if the zones are not
> =C2=A0 =C2=A0 =C2=A0 =C2=A0balanced. For a high-order allocation that=
 is balanced, it
> =C2=A0 =C2=A0 =C2=A0 =C2=A0checks order-0 again. During that window, =
order-0 might have
> =C2=A0 =C2=A0 =C2=A0 =C2=A0become unbalanced so it loops again for or=
der-0 and returns
> =C2=A0 =C2=A0 =C2=A0 =C2=A0that it was reclaiming for order-0 to kswa=
pd(). It can then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0find that a caller has rewoken kswapd for =
a high-order and
> =C2=A0 =C2=A0 =C2=A0 =C2=A0re-enters balance_pgdat() without ever cal=
ling cond_resched().
>
> shrink_slab only calls cond_resched() if we are reclaiming slab
> =C2=A0 =C2=A0 =C2=A0 =C2=A0pages. If there are a large number of dire=
ct reclaimers, the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker_rwsem can be contended and preven=
t kswapd calling
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched().
>
> This patch modifies the shrink_slab() case. If the semaphore is
> contended, the caller will still check cond_resched(). After each
> successful call into a shrinker, the check for cond_resched() is
> still necessary in case one shrinker call is particularly slow.
>
> This patch replaces
> mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep.patch
> in -mm.
>
> [mgorman@suse.de: Preserve call to cond_resched after each call into =
shrinker]
> From: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
> =C2=A0mm/vmscan.c | =C2=A0 =C2=A09 +++++++--
> =C2=A01 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index af24d1e..0bed248 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -230,8 +230,11 @@ unsigned long shrink_slab(unsigned long scanned,=
 gfp_t gfp_mask,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (scanned =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scanned =3D SW=
AP_CLUSTER_MAX;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!down_read_trylock(&shrinker_rwsem))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1; =C2=A0 =C2=
=A0 =C2=A0 /* Assume we'll be able to shrink next time */
> + =C2=A0 =C2=A0 =C2=A0 if (!down_read_trylock(&shrinker_rwsem)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Assume we'll be=
 able to shrink next time */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(shrinker, &shrinker_li=
st, list) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long =
long delta;
> @@ -282,6 +285,8 @@ unsigned long shrink_slab(unsigned long scanned, =
gfp_t gfp_mask,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker->nr +=
=3D total_scan;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0up_read(&shrinker_rwsem);
> +out:
> + =C2=A0 =C2=A0 =C2=A0 cond_resched();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
>
>



--=20
Kind regards,
Minchan Kim
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
