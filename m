From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Date: Wed, 18 May 2011 10:58:59 +0100
Message-ID: <20110518095859.GR5279@suse.de>
References: <1305295404-12129-5-git-send-email-mgorman@suse.de>
 <4DCFAA80.7040109@jp.fujitsu.com>
 <1305519711.4806.7.camel@mulgrave.site>
 <BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
 <20110516084558.GE5279@suse.de>
 <BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
 <20110516102753.GF5279@suse.de>
 <BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
 <4DD31B6E.8040502@jp.fujitsu.com>
 <BANLkTikLuWPEt7MitUYdJtzqyBSOkz2zxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org,
	colin.king@canonical.com, raghu.prabhu13@gmail.com, jack@suse.cz,
	chris.mason@oracle.com, cl@linux.com, penberg@kernel.org,
	riel@redhat.com, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab1ERJ7H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 05:59:07 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikLuWPEt7MitUYdJtzqyBSOkz2zxg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 02:44:48PM +0900, Minchan Kim wrote:
> On Wed, May 18, 2011 at 10:05 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> It would be better to put cond_resched after balance_pgdat?
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 292582c..61c45d0 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -2753,6 +2753,7 @@ static int kswapd(void *p)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ret) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_mm_vmscan_ks=
wapd_wake(pgdat->node_id,
> >> order);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 order =3D balance_=
pgdat(pgdat,
> >> order,&classzone_idx);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cond_resched();
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 return 0;
> >>
> >>>>> While it appears unlikely, there are bad conditions which can r=
esult
> >>>
> >>> in cond_resched() being avoided.
> >
> > Every reclaim priority decreasing or every shrink_zone() calling ma=
kes more
> > fine grained preemption. I think.
>=20
> It could be.
> But in direct reclaim case, I have a concern about losing pages
> reclaimed to other tasks by preemption.
>=20
> Hmm,, anyway, we also needs test.
> Hmm,, how long should we bother them(Colins and James)?
> First of all, Let's fix one just between us and ask test to them and
> send the last patch to akpm.
>=20
> 1. shrink_slab
> 2. right after balance_pgdat
> 3. shrink_zone
> 4. reclaim priority decreasing routine.
>=20
> Now, I vote 1) and 2).
>=20

I've already submitted a pair of patches for option 1. I don't think
option 2 gains us anything. I think it's more likely we should worry
about all_unreclaimable being set when shrink_slab is returning 0 and w=
e
are encountering so many dirty pages that pages_scanned is high enough.

--=20
Mel Gorman
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
