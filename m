From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/2] mm: vmscan: Correct use of pgdat_balanced in
 sleeping_prematurely
Date: Tue, 17 May 2011 13:26:21 +0800
Message-ID: <20110517052621.GA24069@localhost>
References: <1305558417-24354-1-git-send-email-mgorman@suse.de>
 <1305558417-24354-2-git-send-email-mgorman@suse.de>
 <20110516152608.GT16531@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, stable <stable@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20110516152608.GT16531@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 16, 2011 at 05:26:08PM +0200, Johannes Weiner wrote:
> On Mon, May 16, 2011 at 04:06:56PM +0100, Mel Gorman wrote:
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > Johannes Weiner poined out that the logic in commit [1741c877: mm:
> > kswapd: keep kswapd awake for high-order allocations until a percentage
> > of the node is balanced] is backwards. Instead of allowing kswapd to go
> > to sleep when balancing for high order allocations, it keeps it kswapd
> > running uselessly.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
