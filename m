From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Mon, 06 Oct 2008 10:21:43 -0400
Message-ID: <1223302903.16546.58.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
	 <1222950054.6745.18.camel@think.oraclecorp.com>
	 <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed>
	 <1223063155.13375.64.camel@think.oraclecorp.com>
	 <20081006101605.GA15881@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081006101605.GA15881@skywalker>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2008-10-06 at 15:46 +0530, Aneesh Kumar K.V wrote:
> On Fri, Oct 03, 2008 at 03:45:55PM -0400, Chris Mason wrote:
> > On Fri, 2008-10-03 at 09:43 +1000, Dave Chinner wrote:
> > > On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> > > > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > > > For a 4.5GB streaming buffered write, this printk inside
> > > > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > > > > 
> > > > 
> > > > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > > > call back with lots of unallocated buffer_heads(blocks).
> > > 
> > > Quite frankly, a simple streaming buffered write should *never*
> > > trigger writeback from the LRU in memory reclaim.
> > 
> > The blktrace runs on ext4 didn't show kswapd doing any IO.  It isn't
> > clear if this is because ext4 did the redirty trick or if kswapd didn't
> > call writepage.
> > 
> > -chris
> 
> This patch actually reduced the number of extents for the below test
> from 564 to 171.
> 

For my array, this patch brings the number of ext4 extents down from
over 4000 to 27.  The throughput reported by dd goes up from ~80MB/s to
330MB/s, which means buffered IO is going as fast as O_DIRECT.

Here's the graph:

http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-aneesh.png

The strange metadata writeback for the uninit block groups is gone.

Looking at the patch, I think the ext4_writepages code should just make
its own write_cache_pages.  It's pretty hard to follow the code that is
there for ext4 vs the code that is there to make write_cache_pages do
what ext4 expects it to.

-chris


