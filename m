From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Fri, 5 Sep 2014 16:32:48 +0900
Message-ID: <20140905073247.GA31827@js1304-P5Q-DELUXE>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
 <20140905031735.GD1971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46518 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaIEHb6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2014 03:31:58 -0400
Content-Disposition: inline
In-Reply-To: <20140905031735.GD1971@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 11:17:35PM -0400, Theodore Ts'o wrote:
> Joonson,
> 
> Thanks for the update.  I've applied Gioh's patches to the ext4 tree,
> but I'd appreciate a further clarification.  My understanding with the
> problem you were trying to address is that with the current CMA
> implementation, kswapd was getting activiated too early, yes?
> 
> But it would still be a good idea to try to use non-moveable memory in
> preference in favor of CMA memory; even if the page migration can move
> the contents of the page elsewhere, wouldn't be better to avoid
> needing to do the page migation in the first place.  Given that the
> ext4 file systems are getting mounted very early in the boot process,
> when there should be plenty of CMA and non-CMA elegible memory
> available, why was CMA memory getting selected for the buffer cache
> allocations when non-CMA memory available?
> 
> In other words, even without Gioh's patch to force the use of non-CMA
> eligible memory, wouldn't it be better if the memory allocator used
> non-CMA preferentially if it were available.  This should be
> orthogonal to whether or not kswaped gets activiated, right?

Hello,

Yes, similar with your understanding.

With current CMA implementation, page allocator doesn't returns
freepages in CMA reserved region until there is no freepage of movable
type. If there is no freepage of movable type, freepages in CMA reserved
region is allocated via fallback allocation. This approach is simliar
with what you suggested.

In that situation, kswapd would start to reclaim because free memory
is already too low. By this reclaim, freepages of movable type are
refilled and page allocator would stop to allocate freepages in CMA
reserved region. So, with above approach, system would work as if
it has only (total memory - CMA reserved memory) memory.

CMA is intended for using reserved memory on general purpose when
reserved memory isn't used. But current implementation don't do that.
My patch fixes this situation by allocating freepages in CMA reserved
region aggrressively.

I also test another approach, such as allocate freepage in CMA
reserved region as late as possible, which is also similar to your
suggestion and this doesn't works well. When reclaim is started,
too many pages reclaim at once, because lru list has successive pages
in CMA region and these doesn't help kswapd's reclaim. kswapd stop
reclaiming when freepage count is recovered. But, CMA pages isn't
counted for freepage for kswapd because they can't be usable for
unmovable, reclaimable allocation. So kswap reclaim too many pages
at once unnecessarilly.

More detailed explanation may be in following link.
https://lkml.org/lkml/2014/5/28/57

Thanks.

