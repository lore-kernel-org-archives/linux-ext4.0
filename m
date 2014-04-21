From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Mon, 21 Apr 2014 21:50:07 +0800
Message-ID: <20140421135007.GA19966@gmail.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40435 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaDUNnq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2014 09:43:46 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so3760919pab.13
        for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2014 06:43:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140417153526.GF18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 11:35:26AM -0400, Theodore Ts'o wrote:
> So I've been thinking about this some more, and it seems to me is
> actually, what we need is *both* an LRU and a RR scheme.
> 
> The real problem here is that we have workloads that are generating a
> large number of "low value" extent cache entries.  That is, they are
> extremely unlikely to be used again, because they are small, and being
> generated when you have a highly fragmented extent status cache, and
> very often, the workload is a random read/write workload, so there is
> no way the full "working set" of extent cache entries could be kept in
> memory at the same time anyway.  These less valuable cache entries are
> being generated at a very high rate, and we want to make sure we don't
> penalize the "valuable" cache entries.
> 
> There's a classic solution to this problem for garbage collectors, and
> that's to have a "nursery" and "tenured" space.  So what we could do
> is to have two lists (as the proposed LRU improvement patch does), but
> in the first list, we put the delalloc and "tenured" cache entries,
> and in the second list we put the "nursery" cache entries.
> 
> The "nursery" cache items are cleaned using an RR scheme, and indeed,
> we might want to have a system where we try to keep the "nursery"
> cache items to a mangeable level, even if we aren't under memory
> pressure.  If a cache item gets used a certain number of times, then
> when we get to that item in the RR scheme, it gets "promoted" to the
> "tenured" space.
> 
> The "tenured" space is then kept under control using some kind of LRU
> scheme, and a target number of "tenured" items.  (We might or might
> not want to count delalloc entries for the purposes of this target.
> That's TBD.)
> 
> The system should ideally automatically tune itself to control the
> promotion rate from the nursery to tenured space based on the number
> of uses required before a cache entry gets promoted, and there will be
> a bunch of hueristics that we'll need to tune.  But I think this
> general approach should work pretty well.

Hi Ted,

Sorry for the late reply because of vacation, and thanks for thinking
about this deeply.

First question is about 'nr_to_scan'.  Do you want me to generate a
patch to fix it in this merge window?  Because I can imagine that this
patch should be trival and easy for reviewing.

Second question is about your deeply thought.  From your comment, it
seems that now we need a replacement algorithm that looks like we do in
memory management subsystem.  Now in memory management subsystem, we
have an active list and an inactive list which tracks some pages.  When
the system read/write some pages, these pages will be put on inactive
list.  Then if some pages are accessed again, they will be promoted into
active list.  When 'kswapd' thread tries to reclaim some pages, it will
drop some pages from inactive list and demote some pages from active
list to inactive list.  I am happy to give it a try later.

Regards,
                                                - Zheng
