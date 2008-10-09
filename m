From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Thu, 09 Oct 2008 11:11:20 -0400
Message-ID: <1223565080.14090.28.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081001215239.ee2ae63f.akpm@linux-foundation.org>
	 <1222950054.6745.18.camel@think.oraclecorp.com>
	 <20081002181856.GB29613@skywalker>  <20081002234309.GH30001@disturbed>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760005AbYJIPMz@vger.kernel.org>
In-Reply-To: <20081002234309.GH30001@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-10-03 at 09:43 +1000, Dave Chinner wrote:
> On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> > On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > > For a 4.5GB streaming buffered write, this printk inside
> > > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > > 
> > 
> > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > call back with lots of unallocated buffer_heads(blocks).
> 
> Quite frankly, a simple streaming buffered write should *never*
> trigger writeback from the LRU in memory reclaim. That indicates
> that some feedback loop has broken down and we are not cleaning
> pages fast enough or perhaps in the correct order. Page reclaim in
> this case should be reclaiming clean pages (those that have already
> been written back), not writing back random dirty pages.

Here are some go faster stripes for the XFS buffered writeback.  This
patch has a lot of debatable features to it, but the idea is to show
which knobs are slowing us down today.

The first change is to avoid calling balance_dirty_pages_ratelimited on
every page.  When we know we're doing a largeish write it makes more
sense to balance things less often.  This might just mean our
ratelimit_pages magic value is too small.

The second change makes xfs bump wbc->nr_to_write (suggested by
Christoph), which probably makes delalloc go in bigger chunks.

On unpatched kernels, XFS does streaming writes to my 4 drive array at
around 205MB/s.  With the patch below, I come in at 326MB/s.  O_DIRECT
runs at 330MB/s, so that's pretty good.

With just the nr_to_write change, I get around 315MB/s.

With just the balance_dirty_pages_nr change, I get around 240MB/s.

-chris

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index a44d68e..c72bd54 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -944,6 +944,9 @@ xfs_page_state_convert(
 	int			trylock = 0;
 	int			all_bh = unmapped;
 
+
+	wbc->nr_to_write *= 4;
+
 	if (startio) {
 		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
 			trylock |= BMAPI_TRYLOCK;
diff --git a/mm/filemap.c b/mm/filemap.c
index 876bc59..b6c26e3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2389,6 +2389,7 @@ static ssize_t generic_perform_write(struct file *file,
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = 0;
+	unsigned long nr = 0;
 
 	/*
 	 * Copies from kernel address space cannot fail (NFSD is a big user).
@@ -2460,11 +2461,17 @@ again:
 		}
 		pos += copied;
 		written += copied;
-
-		balance_dirty_pages_ratelimited(mapping);
+		nr++;
+		if (nr > 256) {
+			balance_dirty_pages_ratelimited_nr(mapping, nr);
+			nr = 0;
+		}
 
 	} while (iov_iter_count(i));
 
+	if (nr)
+		balance_dirty_pages_ratelimited_nr(mapping, nr);
+
 	return written ? written : status;
 }
 
