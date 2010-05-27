From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
 scanning to current EOF
Date: Thu, 27 May 2010 14:33:41 -0700
Message-ID: <20100527143341.d4258798.akpm@linux-foundation.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-7-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998Ab0E0VeR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 May 2010 17:34:17 -0400
In-Reply-To: <1274784852-30502-7-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 May 2010 20:54:12 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> sync can currently take a really long time if a concurrent writer is
> extending a file. The problem is that the dirty pages on the address
> space grow in the same direction as write_cache_pages scans, so if
> the writer keeps ahead of writeback, the writeback will not
> terminate until the writer stops adding dirty pages.

<looks at Jens>

The really was a pretty basic bug.  It's writeback 101 to test that case :(

> For a data integrity sync, we only need to write the pages dirty at
> the time we start the writeback, so we can stop scanning once we get
> to the page that was at the end of the file at the time the scan
> started.
> 
> This will prevent operations like copying a large file preventing
> sync from completing as it will not write back pages that were
> dirtied after the sync was started. This does not impact the
> existing integrity guarantees, as any dirty page (old or new)
> within the EOF range at the start of the scan will still be
> captured.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/page-writeback.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0fe713d..c97e973 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
>  		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
>  			range_whole = 1;
>  		cycled = 1; /* ignore range_cyclic tests */
> +
> +		/*
> +		 * If this is a data integrity sync, cap the writeback to the
> +		 * current end of file. Any extension to the file that occurs
> +		 * after this is a new write and we don't need to write those
> +		 * pages out to fulfil our data integrity requirements. If we
> +		 * try to write them out, we can get stuck in this scan until
> +		 * the concurrent writer stops adding dirty pages and extending
> +		 * EOF.
> +		 */
> +		if (wbc->sync_mode == WB_SYNC_ALL &&
> +		    wbc->range_end == LLONG_MAX) {
> +			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
> +		}
>  	}
> +

This is somewhat inefficient.  It's really trivial and fast to find the
highest-index dirty page by walking straight down the
PAGECACHE_TAG_DIRTY-tagged nodes.

However pagevec_lookup_tag(..., PAGECACHE_TAG_DIRTY) should do a pretty
good job of skipping over the (millions of) pages between the (last
dirty page before `end') and (`end').  So it _should_ be OK.  Some thought
and runtime testing would be good.



That being said, I think the patch is insufficient.  If I create an
enormous (possibly sparse) file with a 16TB hole (or a run of clean
pages) in the middle and then start busily writing into that hole (run
of clean pages), the problem will still occur.

One obvious fix for that (a) would be to add another radix-tree tag and
do two passes across the radix-tree.

Another fix (b) would be to track the number of dirty pages per
adddress_space, and only write that number of pages.

Another fix would be to work out how the code handled this situation
before we broke it, and restore that in some fashion.  I guess fix (b)
above kinda does that.


