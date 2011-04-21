From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Date: Thu, 21 Apr 2011 04:32:58 -0400
Message-ID: <20110421083258.GA26784@infradead.org>
References: <1303322378-sup-1722@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
	jack@suse.cz, axboe@kernel.dk, dchinner@redhat.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1303322378-sup-1722@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 20, 2011 at 02:23:29PM -0400, Chris Mason wrote:
> # fsync-tester
> setting up random write file
> done setting up random write file
> starting fsync run
> starting random io!
> write time 0.0009s fsync time: 2.0142s
> write time 128.9305s fsync time: 2.6046s
> run done 2 fsyncs total, killing random writer
> 
> In this case the 128s spent in write was on a single 4K overwrite on a
> 4K file.

I can't really reproduce this locally on XFS:

setting up random write file
done setting up random write file
starting fsync run
starting random io!
write time: 0.0023s fsync time: 0.5949s
write time: 0.0605s fsync time: 0.2339s
write time: 0.0018s fsync time: 0.0179s
write time: 0.0020s fsync time: 0.0201s
write time: 0.0019s fsync time: 0.0176s
write time: 0.0018s fsync time: 0.0209s
write time: 0.0025s fsync time: 0.0197s
write time: 0.0013s fsync time: 0.0183s
write time: 0.0013s fsync time: 0.0217s
write time: 0.0016s fsync time: 0.0158s
write time: 0.0022s fsync time: 0.0240s
write time: 0.0024s fsync time: 0.0190s
write time: 0.0017s fsync time: 0.0205s
write time: 0.0030s fsync time: 0.0688s
write time: 0.0045s fsync time: 0.0193s
write time: 0.0022s fsync time: 0.0356s

But given that you are able to reproduce it, does the following patch
help your latencies?  Currently XFS actually does stop I/O when
nr_to_write reaches zero, but only for non-blocking I/O. This behaviour
was introduced in commit efceab1d563153a2b1a6e7d35376241a48126989

	"xfs: handle negative wbc->nr_to_write during sync writeback"

and works around issues in the generic writeback code.


Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-04-21 10:20:48.303550404 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-04-21 10:20:58.203496773 +0200
@@ -765,8 +765,7 @@ xfs_convert_page(
 		SetPageUptodate(page);
 
 	if (count) {
-		if (--wbc->nr_to_write <= 0 &&
-		    wbc->sync_mode == WB_SYNC_NONE)
+		if (--wbc->nr_to_write <= 0)
 			done = 1;
 	}
 	xfs_start_page_writeback(page, !page_dirty, count);
