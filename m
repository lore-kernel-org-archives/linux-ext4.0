From: Michal Hocko <mhocko@kernel.org>
Subject: Re: 4.7.0, cp -al causes OOM
Date: Sun, 14 Aug 2016 14:51:12 +0200
Message-ID: <20160814125111.GE9248@dhcp22.suse.cz>
References: <201608120901.41463.a.miskiewicz@gmail.com>
 <20160812074340.GC3639@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-mm@vger.kernel.org
To: arekm@maven.pl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35005 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbcHNMvP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2016 08:51:15 -0400
Content-Disposition: inline
In-Reply-To: <20160812074340.GC3639@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 12-08-16 09:43:40, Michal Hocko wrote:
> Hi,
> 
> On Fri 12-08-16 09:01:41, Arkadiusz Miskiewicz wrote:
[...]
> > [87259.568395] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15360kB
> > [87259.568403] Node 0 DMA32: 11467*4kB (UME) 1525*8kB (UME) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 58068kB
> > [87259.568411] Node 0 Normal: 9927*4kB (UMEH) 1119*8kB (UMH) 19*16kB (H) 8*32kB (H) 2*64kB (H) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 49348kB
> 
> As you can see there are barely some high order pages available. There
> are few in the atomic reserves which is a bit surprising because I would
> expect they would get released under a heavy memory pressure. I will
> double check that part.

OK, so the reason is that we are trying to preserve at least one page
block per zone. This is not really all that much to matter overall but I
guess we should just release those pageblocks because OOM is certainly
much worse than an high order GFP_ATOMIC request failing. The diff below
does that. I am a bit skeptical this will make much difference but let's
give it a try. I will also send another patch which should show
compaction/migration counters during high order OOMs. This might tell us
a bit more about the compaction behavior.
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9d46b65061be..b8600943184e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2053,8 +2053,7 @@ static void unreserve_highatomic_pageblock(const struct alloc_context *ac)
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->high_zoneidx,
 								ac->nodemask) {
-		/* Preserve at least one pageblock */
-		if (zone->nr_reserved_highatomic <= pageblock_nr_pages)
+		if (!zone->nr_reserved_highatomic)
 			continue;
 
 		spin_lock_irqsave(&zone->lock, flags);
@@ -3276,11 +3275,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
-	 * pages are pinned on the per-cpu lists or in high alloc reserves.
+	 * pages are pinned on the per-cpu lists.
 	 * Shrink them them and try again
 	 */
 	if (!page && !drained) {
-		unreserve_highatomic_pageblock(ac);
 		drain_all_pages(NULL);
 		drained = true;
 		goto retry;
@@ -3636,6 +3634,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 
 	/*
+	 * Make sure we are not pinning atomic higher order reserves when we
+	 * are really fighting to get !costly order and running out of memory
+	 */
+	unreserve_highatomic_pageblock(ac);
+
+	/*
 	 * It doesn't make any sense to retry for the compaction if the order-0
 	 * reclaim is not able to make any progress because the current
 	 * implementation of the compaction depends on the sufficient amount
-- 
Michal Hocko
SUSE Labs
