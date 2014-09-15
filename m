From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Mon, 15 Sep 2014 10:10:18 +0900
Message-ID: <20140915011018.GA2676@js1304-P5Q-DELUXE>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
 <20140905031735.GD1971@thunk.org>
 <20140905073247.GA31827@js1304-P5Q-DELUXE>
 <20140905141416.GA1510@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mel Gorman <mgorman@suse.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Nazarewicz <mina86@mina86.com>
To: Theodore Ts'o <tytso@mit.edu>, Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140905141416.GA1510@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 05, 2014 at 10:14:16AM -0400, Theodore Ts'o wrote:
> On Fri, Sep 05, 2014 at 04:32:48PM +0900, Joonsoo Kim wrote:
> > I also test another approach, such as allocate freepage in CMA
> > reserved region as late as possible, which is also similar to your
> > suggestion and this doesn't works well. When reclaim is started,
> > too many pages reclaim at once, because lru list has successive pages
> > in CMA region and these doesn't help kswapd's reclaim. kswapd stop
> > reclaiming when freepage count is recovered. But, CMA pages isn't
> > counted for freepage for kswapd because they can't be usable for
> > unmovable, reclaimable allocation. So kswap reclaim too many pages
> > at once unnecessarilly.
> 
> Have you considered putting the pages in a CMA region in a separate
> zone?  After all, that's what we originally did with brain-damaged
> hardware that could only DMA into the low 16M of memory.  We just
> reserved a separate zone for that?  That way, we could do
> zone-directed reclaim and free pages in that zone, if that was what
> was actually needed.

Sorry for long delay. It was long holidays.

No, I haven't consider it. It sounds good idea to place the pages in a
CMA region into a separate zone. Perhaps we can remove one of
migratetype, MIGRATE_CMA, with this way and it would be a good long-term
architecture for CMA.

I don't know exact history and reason why CMA is implemented in current
form. Ccing some experts in this area.

Thanks.
