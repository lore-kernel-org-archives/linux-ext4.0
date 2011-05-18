From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: vmscan: Correctly check if reclaimer should schedule
 during shrink_slab
Date: Wed, 18 May 2011 09:45:59 +0900
Message-ID: <4DD316C7.60003@jp.fujitsu.com>
References: <1305295404-12129-5-git-send-email-mgorman@suse.de> <4DCFAA80.7040109@jp.fujitsu.com> <1305519711.4806.7.camel@mulgrave.site> <BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com> <20110516084558.GE5279@suse.de> <BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com> <20110516102753.GF5279@suse.de> <BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com> <20110517103840.GL5279@suse.de> <1305640239.2046.27.camel@lenovo> <20110517161508.GN5279@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, minchan.kim@gmail.com,
	colin.king@canonical.com, James.Bottomley@hansenpartnership.com,
	raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
	cl@linux.com, penberg@kernel.org, riel@redhat.com,
	hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: mgorman@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35139 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab1ERAqS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 20:46:18 -0400
In-Reply-To: <20110517161508.GN5279@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(2011/05/18 1:15), Mel Gorman wrote:
> It has been reported on some laptops that kswapd is consuming large
> amounts of CPU and not being scheduled when SLUB is enabled during
> large amounts of file copying. It is expected that this is due to
> kswapd missing every cond_resched() point because;
>
> shrink_page_list() calls cond_resched() if inactive pages were isolated
>          which in turn may not happen if all_unreclaimable is set in
>          shrink_zones(). If for whatver reason, all_unreclaimable is
>          set on all zones, we can miss calling cond_resched().
>
> balance_pgdat() only calls cond_resched if the zones are not
>          balanced. For a high-order allocation that is balanced, it
>          checks order-0 again. During that window, order-0 might have
>          become unbalanced so it loops again for order-0 and returns
>          that it was reclaiming for order-0 to kswapd(). It can then
>          find that a caller has rewoken kswapd for a high-order and
>          re-enters balance_pgdat() without ever calling cond_resched().
>
> shrink_slab only calls cond_resched() if we are reclaiming slab
> 	pages. If there are a large number of direct reclaimers, the
> 	shrinker_rwsem can be contended and prevent kswapd calling
> 	cond_resched().
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
> [mgorman@suse.de: Preserve call to cond_resched after each call into shrinker]
> From: Minchan Kim<minchan.kim@gmail.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


