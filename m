From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Mon, 6 Oct 2008 15:46:05 +0530
Message-ID: <20081006101605.GA15881@skywalker>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1223063155.13375.64.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 03, 2008 at 03:45:55PM -0400, Chris Mason wrote:
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
> > trigger writeback from the LRU in memory reclaim.
> 
> The blktrace runs on ext4 didn't show kswapd doing any IO.  It isn't
> clear if this is because ext4 did the redirty trick or if kswapd didn't
> call writepage.
> 
> -chris

This patch actually reduced the number of extents for the below test
from 564 to 171.

$dd if=/dev/zero of=test bs=1M count=1024

ext4 mballoc block allocator still can be improved to make sure we get
less extents. I am looking into this.

What the below change basically does is to make sure we advance
writeback_index after looking at the pages skipped. With delayed
allocation when we request for 100 blocks we just add each of these
blocks to the in memory extent. Once we get the contiguous chunk
of 100 block request we have the index updated to 100. Now we request
block allocator for 100 blocks. But allocator gives us back 50 blocks
So with the current code we have writeback_index pointing to 100
With the changes below it is pointing to 50.


We also force loop inside the ext4_da_writepags with the below condition
a) if nr_to_write is zero break the loop
b) if we are able to allocate blocks but we have pages_skipped move
the writeback_index/range_start to initial value and try with a new
nr_to_write value. This make sure we will be allocating blocks for
all requested dirty pages. The reason being __fsync_super. It does

sync_inodes_sb(sb, 0);
sync_blockdev(sb->s_bdev);
sync_inodes_sb(sb, 1);

I guess the first call is supposed to have done all the meta data
allocation ? So i was forcing the block allocation without even looking
at WB_SYNC_ALL

c) If we don't have anything to write break the loop

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 21f1d3a..58d010d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2386,14 +2386,16 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
 
-	if (!wbc->range_cyclic)
+	if (wbc->range_cyclic) {
+		range_start =  mapping->writeback_index;
+	} else {
 		/*
 		 * If range_cyclic is not set force range_cont
-		 * and save the old writeback_index
+		 * and save the old range_start;
 		 */
 		wbc->range_cont = 1;
-
-	range_start =  wbc->range_start;
+		range_start =  wbc->range_start;
+	}
 	pages_skipped = wbc->pages_skipped;
 
 	mpd.wbc = wbc;
@@ -2440,6 +2442,19 @@ static int ext4_da_writepages(struct address_space *mapping,
 			 */
 			to_write += wbc->nr_to_write;
 			ret = 0;
+			if (pages_skipped != wbc->pages_skipped) {
+				/* writepages skipped some pages */
+				if (wbc->range_cont) {
+					wbc->range_start = range_start;
+				} else {
+					/* range_cyclic */
+					mapping->writeback_index = range_start;
+				}
+				wbc->nr_to_write = to_write +
+					(wbc->pages_skipped - pages_skipped);
+				wbc->pages_skipped = pages_skipped;
+			} else
+				wbc->nr_to_write = to_write;
 		} else if (wbc->nr_to_write) {
 			/*
 			 * There is no more writeout needed
@@ -2449,18 +2464,27 @@ static int ext4_da_writepages(struct address_space *mapping,
 			to_write += wbc->nr_to_write;
 			break;
 		}
-		wbc->nr_to_write = to_write;
 	}
 
 	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
 		/* We skipped pages in this loop */
 		wbc->range_start = range_start;
 		wbc->nr_to_write = to_write +
-				wbc->pages_skipped - pages_skipped;
+				(wbc->pages_skipped - pages_skipped);
 		wbc->pages_skipped = pages_skipped;
 		goto restart_loop;
 	}
 
+	if (wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
+		/*
+		 * we need to make sure we don't move the
+		 * writeback_index further without looking
+		 * at the pages skipped.
+		 */
+		mapping->writeback_index = mapping->writeback_index -
+					(wbc->pages_skipped - pages_skipped);
+	}
+
 out_writepages:
 	wbc->nr_to_write = to_write - nr_to_writebump;
 	wbc->range_start = range_start;
