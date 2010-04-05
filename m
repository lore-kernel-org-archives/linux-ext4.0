From: tytso@mit.edu
Subject: Re: [PATCH (RESEND)] don't scan/accumulate more pages than mballoc
 will allocate
Date: Mon, 5 Apr 2010 09:11:05 -0400
Message-ID: <20100405131105.GB22104@thunk.org>
References: <4BB0C761.50204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0DENLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 09:11:07 -0400
Content-Disposition: inline
In-Reply-To: <4BB0C761.50204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 10:29:37AM -0500, Eric Sandeen wrote:
> This patch makes mpage_add_bh_to_extent stop the loop after we've
> accumulated 2048 pages, by setting mpd->io_done = 1; which ultimately
> causes the write_cache_pages loop to break.
> 
> Repeating the test with a dirty_ratio of 80 (to leave something for
> fsync to do), I don't see huge IO performance gains, but the reduction
> in cpu usage is striking: 80% usage with stock, and 2% with the
> below patch.  Instrumenting the loop in write_cache_pages clearly
> shows that we are wasting time here.
> 
> It'd be better to not have a magic number of 2048 in here, so I'll
> look for a cleaner way to get this info out of mballoc; I still need
> to look at what Aneesh has in the patch queue, that might help.
> This is something we could probably put in for now, though; the 2048
> is already enshrined in a comment in inode.c, at least.

I wonder if a better way of fixing this is to changing
mpage_da_map_pages() to call ext4_get_blocks() multiple times.  This
should be a lot easier after we integrate mpage_da_submit_io() into
mpage_da_map_pages().  That way we can way more efficient; in a loop,
we accumulate the pages, call ext4_get_blocks(), then submit the IO
(as a single block I/O submission, instead of 4k at a time through
ext4_writepages()), and then call ext4_get_blocks() again, etc.

I'm willing to include this patch as an interim stopgap, but
eventually, I think we need to refactor and reorganize
mpage_da_map_pages() and and mpage_da_submit_IO(), and let them call
mballoc (via ext4_get_blocks) multiple times in a loop.

Thoughts, suggestions?

					- Ted
