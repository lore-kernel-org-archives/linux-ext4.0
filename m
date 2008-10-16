From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan: set try_to_release_page's gfp_mask to 0
Date: Wed, 15 Oct 2008 19:54:58 -0700
Message-ID: <20081015195458.cc203dd5.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080813111835.03d345b0@172.19.0.2>
	<20080812202127.b88e8250.akpm@linux-foundation.org>
	<6.0.0.20.2.20080813150454.03b13e30@172.19.0.2>
	<20081015153641.afcc94e5.akpm@linux-foundation.org>
	<6.0.0.20.2.20081016112735.04a68e70@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYJPCzL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 22:55:11 -0400
In-Reply-To: <6.0.0.20.2.20081016112735.04a68e70@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Oct 2008 11:44:39 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Hi Andrew.
> 
> >Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> >
> >> At 12:21 08/08/13, Andrew Morton wrote:
> >> >On Wed, 13 Aug 2008 11:21:16 +0900 Hisashi Hifumi 
> >> ><hifumi.hisashi@oss.ntt.co.jp> wrote:
> 
> >> >> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> >> >> 
> >> >> diff -Nrup linux-2.6.27-rc2.org/mm/vmscan.c 
> >linux-2.6.27-rc2.vmscan/mm/vmscan.c
> >> >> --- linux-2.6.27-rc2.org/mm/vmscan.c	2008-08-11 14:33:24.000000000 +0900
> >> >> +++ linux-2.6.27-rc2.vmscan/mm/vmscan.c	2008-08-12 18:57:05.000000000 +0900
> >> >> @@ -614,7 +614,7 @@ static unsigned long shrink_page_list(st
> >> >>  		* Otherwise, leave the page on the LRU so it is swappable.
> >> >>  		*/
> >> >>  		if (PagePrivate(page)) {
> >> >> -			if (!try_to_release_page(page, sc->gfp_mask))
> >> >> +			if (!try_to_release_page(page, 0))
> >> >>  				goto activate_locked;
> >> >>  			if (!mapping && page_count(page) == 1) {
> >> >>  				unlock_page(page);
> >> >
> >> >I think the change makes sense.
> >> >
> >> >Has this change been shown to improve any workloads?  If so, please
> >> >provide full information for the changelog.  If not, please mention
> >> >this and explain why benefits were not demonstrable.  This information
> >> >should _always_ be present in a "performance" patch's changelog!
> >> 
> >> Sorry, I do not have performance number yet. I'll try this.
> >> 
> >
> 
> Unfortunately, I did not succeed to get good performance number that
> prove this patch had some benefit.

OK, thanks, I dropped it.

> >This patch remains in a stalled state...
> >
> >And then there's this:
> >
> 
> >: 
> >: Really, I think what this patch tells us is that 3f31fddf ("jbd: fix
> >: race between free buffer and commit transaction") was an unpleasant
> >: hack which had undesirable and unexpected side-effects.  I think - that
> >: depends upon your as-yet-undisclosed testing results?
> >: 
> >: Perhaps we should revert 3f31fddf and have another think about how to
> >: fix the direct-io -EIO problem.  One option would be to hold our noses
> >: and add a new gfp_t flag for this specific purpose?
> >:
> 
> direct-io -EIO problem was already fixed by following patch.
> 
> commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
> Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> Date:   Tue Sep 2 14:35:40 2008 -0700
> 
>     VFS: fix dio write returning EIO when try_to_release_page fails
> 
> Dio falls back to buffered write when dio write gets EIO due to failure of try_to_release_page
> by above patch. So I think just reverting the patch 3f31fddf ("jbd: fix race between 
> free buffer and commit transaction") is good approach.

Fair enough.  Could I ask that you (or someone) send a suitable patch
sometime?

I could generate the patch, but I'd never get around to testing it. 
Too busy fixing rejects and compile errors :(

