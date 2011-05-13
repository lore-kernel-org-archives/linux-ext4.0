From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct use of pgdat_balanced in
 sleeping_prematurely
Date: Fri, 13 May 2011 16:28:17 +0200
Message-ID: <20110513142817.GQ16531@cmpxchg.org>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
 <1305295404-12129-2-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zene.cmpxchg.org ([85.214.230.12]:54198 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab1EMO2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 10:28:34 -0400
Content-Disposition: inline
In-Reply-To: <1305295404-12129-2-git-send-email-mgorman@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 03:03:21PM +0100, Mel Gorman wrote:
> Johannes Weiner poined out that the logic in commit [1741c877: mm:
> kswapd: keep kswapd awake for high-order allocations until a percentage
> of the node is balanced] is backwards. Instead of allowing kswapd to go
> to sleep when balancing for high order allocations, it keeps it kswapd
> running uselessly.
> 
> From-but-was-not-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks for picking it up, Mel.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

> Will-sign-off-after-Johannes: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f6b435c..af24d1e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2286,7 +2286,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>  	 * must be balanced
>  	 */
>  	if (order)
> -		return pgdat_balanced(pgdat, balanced, classzone_idx);
> +		return !pgdat_balanced(pgdat, balanced, classzone_idx);
>  	else
>  		return !all_zones_ok;
>  }
> -- 
> 1.7.3.4
