From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: update writeback_index based on last page
 scanned
Date: Tue, 26 Oct 2010 10:14:54 -0400
Message-ID: <20101026141454.GL16981@thunk.org>
References: <4CC2023A.7060607@redhat.com>
 <4CC205ED.4090007@redhat.com>
 <20101025213550.GK16981@thunk.org>
 <4CC5F8FE.6000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60926 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0JZOO7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 10:14:59 -0400
Content-Disposition: inline
In-Reply-To: <4CC5F8FE.6000100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 04:39:10PM -0500, Eric Sandeen wrote:
> 
> Not compilebench specifically, but I did do some benchmarking
> with out of cache buffered IO; to be honest I didn't see
> striking performance differences, but I did see the writeback
> behave better in terms of not wandering all over, even if it
> might recover well.
> 
> I can try compilebench; do you have specific concerns?

My specific concern is that what happens if __mpage_da_writepage()
accumulates 200 pages, but then we were only able to accumulate 50
pages, and we only write 50 pages.

In the long run what I really want to do is to not call
clear_page_dirty_for_io() in the renamed write_cache_pages_da(), but
rather be as greedy as possible about finding dirty/delayed allocate
pages, and then try to allocate pages for all of them.

We would then scan the pages for PAGECACHE_TAG_TOWRITE in
mpage_submit_data_io(), and then write out whatever number of pages we
need.  At that point we will be a good citizen and writing back what
the writeback system asks of us --- but we'll be allocating as much
pages as possible so that the block allocations are sane.  (At that
point we may find out that the core writeback is screwing us because
it's not asking us to write back enough; note that XFS decides on its
own how many pages to writeback in the first call to xfs_writepage(),
and even if writeback is silly enough to think that XFS should write
4MB, then switch to another inode, write 4MB, then write to another
inode, etc., XFS ignores what writeback asks of it.  But we'll cross
that road when we get to it....)

So the bottom line is that I believe that what we were doing before is
wrong; and what we're doing is still wrong, even after your patches.
I just want to make sure that our performance doesn't go crashing
through the floor in order to avoid the livelock problem.  (Which I
agree is a real problem, but we've lived it for quite a while, and I
haven't seen any evidence of it showing up in production.)

						- Ted
