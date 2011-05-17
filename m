From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 3/4] mm: slub: Do not take expensive steps for SLUBs
 speculative high-order allocations
Date: Tue, 17 May 2011 12:52:14 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1105171251450.15604@router.home>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161411440.4353@chino.kir.corp.google.com> <20110517084227.GI5279@suse.de> <alpine.DEB.2.00.1105170847550.11187@router.home>
 <20110517162256.GO5279@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Rientjes <rientjes@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,
  James Bottomley <James.Bottomley@hansenpartnership.com>,
  Colin King <colin.king@canonical.com>,
  Raghavendra D Prabhu <raghu.prabhu13@gmail.com>, Jan Kara <jack@suse.cz>,
  Chris Mason <chris.mason@oracle.com>, Pekka Enberg <penberg@kernel.org>,
  Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
  linux-fsdevel <linux-fsdevel@vger.kernel.org>,
  linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
  linux-ext4 <linux-ext4@vger.kernel.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20110517162256.GO5279@suse.de>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 17 May 2011, Mel Gorman wrote:

> > That is not what I meant. I would like more higher order allocations to
> > succeed. That does not mean that slubs allocation methods and flags passed
> > have to stay the same. You can change the slub behavior if it helps.
> >
>
> In this particular patch, the success rate for high order allocations
> would likely decrease in low memory conditions albeit the latency when
> calling the page allocator will be lower and the disruption to the
> system will be less (no copying or reclaim of pages). My expectation
> would be that it's cheaper for SLUB to fall back than compact memory
> or reclaim pages even if this means a slab page is smaller until more
> memory is free. However, if the "goodness" criteria is high order
> allocation success rate, the patch shouldn't be merged.

The criteria is certainly overall system performance and not a high order
allocation rate.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
