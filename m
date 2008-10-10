From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Fri, 10 Oct 2008 16:13:39 +1100
Message-ID: <20081010051339.GD8181@disturbed>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223565080.14090.28.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:61557 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYJJFNp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 01:13:45 -0400
Content-Disposition: inline
In-Reply-To: <1223565080.14090.28.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 11:11:20AM -0400, Chris Mason wrote:
> On Fri, 2008-10-03 at 09:43 +1000, Dave Chinner wrote:
> > On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> > > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > > For a 4.5GB streaming buffered write, this printk inside
> > > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > > > 
> > > 
> > > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > > call back with lots of unallocated buffer_heads(blocks).
> > 
> > Quite frankly, a simple streaming buffered write should *never*
> > trigger writeback from the LRU in memory reclaim. That indicates
> > that some feedback loop has broken down and we are not cleaning
> > pages fast enough or perhaps in the correct order. Page reclaim in
> > this case should be reclaiming clean pages (those that have already
> > been written back), not writing back random dirty pages.
> 
> Here are some go faster stripes for the XFS buffered writeback.  This
> patch has a lot of debatable features to it, but the idea is to show
> which knobs are slowing us down today.
> 
> The first change is to avoid calling balance_dirty_pages_ratelimited on
> every page.  When we know we're doing a largeish write it makes more
> sense to balance things less often.  This might just mean our
> ratelimit_pages magic value is too small.

Ok, so how about doing something like this to reduce the
number of balances on large writes, but causing at least one
balance call for every write that occurs:

	int	nr = 0;
	.....
	while() {
		....
		if (!(nr % 256)) {
			/* do balance */
		}
		nr++;
		....
	}

That way you get a balance on the first page on every write,
but then hold off balancing on that write again for some
number of pages.

> The second change makes xfs bump wbc->nr_to_write (suggested by
> Christoph), which probably makes delalloc go in bigger chunks.

Hmmmm.  Reasonable theory. We used to do gigantic delalloc extents -
we paid no attention to congestion and could allocate and write
several GB at a time. Latency was an issue, though, so it got
changed to be bound by nr_to_write.

I guess we need to be issuing larger allocations. Can you remove
you patches and see what effect using the allocsize mount
option has on throughput? This changes the default delalloc EOF
preallocation size, which means more or less allocations. The
default is 64k and it can go as high as 1GB, IIRC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
