From: Mel Gorman <mgorman@suse.de>
Subject: Re: [patch 1/5] mm: exclude reserved pages from dirtyable memory
Date: Mon, 3 Oct 2011 12:22:05 +0100
Message-ID: <20111003112205.GA5011@suse.de>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
 <1317367044-475-2-git-send-email-jweiner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@redhat.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Shaohua Li <shaohua.li@intel.com>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Weiner <jweiner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1JCLWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 07:22:12 -0400
Content-Disposition: inline
In-Reply-To: <1317367044-475-2-git-send-email-jweiner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 09:17:20AM +0200, Johannes Weiner wrote:
> The amount of dirtyable pages should not include the full number of
> free pages: there is a number of reserved pages that the page
> allocator and kswapd always try to keep free.
> 
> The closer (reclaimable pages - dirty pages) is to the number of
> reserved pages, the more likely it becomes for reclaim to run into
> dirty pages:
> 
>        +----------+ ---
>        |   anon   |  |
>        +----------+  |
>        |          |  |
>        |          |  -- dirty limit new    -- flusher new
>        |   file   |  |                     |
>        |          |  |                     |
>        |          |  -- dirty limit old    -- flusher old
>        |          |                        |
>        +----------+                       --- reclaim
>        | reserved |
>        +----------+
>        |  kernel  |
>        +----------+
> 
> This patch introduces a per-zone dirty reserve that takes both the
> lowmem reserve as well as the high watermark of the zone into account,
> and a global sum of those per-zone values that is subtracted from the
> global amount of dirtyable pages.  The lowmem reserve is unavailable
> to page cache allocations and kswapd tries to keep the high watermark
> free.  We don't want to end up in a situation where reclaim has to
> clean pages in order to balance zones.
> 
> Not treating reserved pages as dirtyable on a global level is only a
> conceptual fix.  In reality, dirty pages are not distributed equally
> across zones and reclaim runs into dirty pages on a regular basis.
> 
> But it is important to get this right before tackling the problem on a
> per-zone level, where the distance between reclaim and the dirty pages
> is mostly much smaller in absolute numbers.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
