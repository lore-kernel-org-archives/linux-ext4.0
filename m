From: Mel Gorman <mgorman@suse.de>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
Date: Tue, 10 May 2011 15:35:09 +0100
Message-ID: <20110510143509.GD4146@suse.de>
References: <1304025145.2598.24.camel@mulgrave.site>
 <1304030629.2598.42.camel@mulgrave.site>
 <20110503091320.GA4542@novell.com>
 <1304431982.2576.5.camel@mulgrave.site>
 <1304432553.2576.10.camel@mulgrave.site>
 <20110506074224.GB6591@suse.de>
 <20110506080728.GC6591@suse.de>
 <1304964980.4865.53.camel@mulgrave.site>
 <20110510102141.GA4149@novell.com>
 <1305036064.6737.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Cc: Mel Gorman <mgorman@novell.com>, Jan Kara <jack@suse.cz>,
	colin.king@canonical.com, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab1EJOfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 10:35:13 -0400
Content-Disposition: inline
In-Reply-To: <1305036064.6737.8.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Tue, May 10, 2011 at 09:01:04AM -0500, James Bottomley wrote:
> On Tue, 2011-05-10 at 11:21 +0100, Mel Gorman wrote:
> > I really would like to hear if the fix makes a big difference or
> > if we need to consider forcing SLUB high-order allocations bailing
> > at the first sign of trouble (e.g. by masking out __GFP_WAIT in
> > allocate_slab). Even with the fix applied, kswapd might be waking up
> > less but processes will still be getting stalled in direct compaction
> > and direct reclaim so it would still be jittery.
> 
> "the fix" being this
> 
> https://lkml.org/lkml/2011/3/5/121
> 

Drop this for the moment. It was a long shot at best and there is little
evidence the problem is in this area.

I'm attaching two patches. The first is the NO_KSWAPD one to stop
kswapd being woken up by SLUB using speculative high-orders. The second
one is more drastic and prevents slub entering direct reclaim or
compaction. It applies on top of patch 1. These are both untested and
afraid are a bit rushed as well :(

-- 
Mel Gorman
SUSE Labs

--vkogqOf2sHV7VnPd
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename="mm-slub-do-not-wake-kswapd-for-slub-high-orders.patch"

>From b48dee7d13980d4d901e3035dc6096c28c42c2ed Mon Sep 17 00:00:00 2001
From: Mel Gorman <mgorman@suse.de>
Date: Tue, 10 May 2011 15:13:30 +0100
Subject: [PATCH] mm: slub: Do not wake kswapd for SLUBs speculative high-order allocations

To avoid locking and per-cpu overhead, SLUB optimisically uses
high-order allocations and falls back to lower allocations if they fail.
However, by simply trying to allocate, kswapd is woken up to start
reclaiming at that order. On a desktop system, two users report that the
system is getting locked up with kswapd using large amounts of CPU.
Using SLAB instead of SLUB makes this problem go away.

This patch prevents kswapd being woken up for high-order allocations.

Not-signed-off-yet: Mel Gorman <mgorman@suse.de>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9d2e5e4..98c358d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1170,7 +1170,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	 * Let the initial higher-order allocation fail under memory pressure
 	 * so we fall-back to the minimum order allocation.
 	 */
-	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
+	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY | __GFP_NO_KSWAPD) & ~__GFP_NOFAIL;
 
 	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {

--vkogqOf2sHV7VnPd
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename="mm-slub-do-not-take-expensive-steps-for-slub-high-orders.patch"

>From 59220aa310c0ba60afee29eeea1e602f4a374c60 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mgorman@suse.de>
Date: Tue, 10 May 2011 15:30:20 +0100
Subject: [PATCH] mm: slub: Do not take expensive steps for SLUBs speculative high-order allocations

To avoid locking and per-cpu overhead, SLUB optimisically uses
high-order allocations and falls back to lower allocations if they
fail.  However, by simply trying to allocate, the caller can enter
compaction or reclaim - both of which are likely to cost more than
the benefit of using high-order pages in SLUB. On a desktop system,
two users report that the system is getting locked up with kswapd
using large amounts of CPU. Using SLAB instead of SLUB makes this
problem go away.

This patch prevents SLUB taking any expensive steps when trying to use
high-order allocations. Instead, it is expected to fall back to smaller
orders more aggressively.

Not-signed-off-yet: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    3 ++-
 mm/slub.c       |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f8a97b..f160d93 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1972,6 +1972,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
+	const gfp_t wakes_kswapd = !(gfp_mask & __GFP_NO_KSWAPD);
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
@@ -1984,7 +1985,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 */
 	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
-	if (!wait) {
+	if (!wait && wakes_kswapd) {
 		/*
 		 * Not worth trying to allocate harder for
 		 * __GFP_NOMEMALLOC even if it can't schedule.
diff --git a/mm/slub.c b/mm/slub.c
index 98c358d..1071723 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1170,7 +1170,8 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	 * Let the initial higher-order allocation fail under memory pressure
 	 * so we fall-back to the minimum order allocation.
 	 */
-	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY | __GFP_NO_KSWAPD) & ~__GFP_NOFAIL;
+	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY | __GFP_NO_KSWAPD) &
+			~(__GFP_NOFAIL | __GFP_WAIT);
 
 	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {

--vkogqOf2sHV7VnPd--
