From: Nick Piggin <npiggin@suse.de>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Thu, 3 Dec 2009 06:22:39 +0100
Message-ID: <20091203052239.GK31517@wotan.suse.de>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net> <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net> <1259667765.9614.19.camel@marge.simson.net> <20091201143558.GB12730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Galbraith <gleep@gmx.de>, James Y Knight <foom@fuhm.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZLCFWe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2009 00:22:34 -0500
Content-Disposition: inline
In-Reply-To: <20091201143558.GB12730@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2009 at 03:35:59PM +0100, Jan Kara wrote:
> On Tue 01-12-09 12:42:45, Mike Galbraith wrote:
> > On Mon, 2009-11-30 at 19:48 -0500, James Y Knight wrote:
> > > On Nov 30, 2009, at 3:55 PM, James Y Knight wrote:
> > > 
> > > > This test case fails in 2.6.23-2.6.25, because of the bug fixed in 864f24395c72b6a6c48d13f409f986dc71a5cf4a, and now again in at least 2.6.31 and 2.6.32pre8 because of a *different* bug. This test *does not* fail 2.6.26. I have not tested anything between 2.6.26 and 2.6.31.
> > > > 
> > > > The bug in 2.6.31 is definitely not the same bug as 2.6.23's. This time, the zero'd area of the file doesn't show up immediately upon writing the file. Instead, the kernel waits to mangle the file until it has to flush the buffer to disk. *THEN* it zeros out parts of the file.
> > > > 
> > > > So, after writing out the new file with writev, and checking the md5sum (which is correct), this test case asks the kernel to flush the cache for that file, and then checks the md5sum again. ONLY THEN is the file corrupted. That is, I won't hesitate to say *incredibly evil* behavior: it took me quite some time to figure out WTH was going wrong with my program before determining it was a kernel bug.
> > > > 
> > > > This test case is distilled from an actual application which doesn't even intentionally use writev: it just uses C++'s ofstream class to write data to a file. Unfortunately, that class smart and uses writev under the covers. Unfortunately, I guess nobody ever tests linux writev behavior, since it's broken _so_much_of_the_time_. I really am quite astounded to see such a bad track record for such a fundamental core system call....
> > > > 
> > > > My /tmp is an ext3 filesystem, in case that matters.
> > > 
> > > Further testing shows that the filesystem type *does* matter. The bug does not exhibit when the test is run on ext2, ext4, vfat, btrfs, jfs, or xfs (and probably all the others too). Only, so far as I can determine, on ext3.
> > 
> > I bisected it this morning.  Bisected cleanly to...
> > 
> > 9eaaa2d5759837402ec5eee13b2a97921808c3eb is the first bad commit
>   OK, I've debugged it. This commit is really at fault. The problem is
> following:
>   When using writev, the page we copy from is not paged in (while when we
> use ordinary write, it is paged in). This difference might be worth
> investigation on its own (as it is likely to heavily impact performance of
> writev) but is irrelevant for us now - we should handle this without data
> corruption anyway. Because the source page is not available, we pass 0 as
> the number of copied bytes to write_end and thus ext3_write_end decides to
> truncate the file to original size. This is perfectly fine. The problem is
> that we do this by ext3_truncate() which just frees corresponding block but
> does not unmap buffers. So we leave mapped buffers beyond i_size (they
> actually never were inside i_size) but the blocks they are mapped to are
> already free. The write is then retried (after mapping the page),
> block_write_begin() sees the buffer is mapped (although it is beyond
> i_size) and thus it does not call ext3_get_block() anymore. So as a result,
> data is written to a block that is no longer allocated to the file. Bummer
> - welcome filesystem corruption.
>   Ext4 also has this problem but delayed allocation mitigates the effect to
> an error in accounting of blocks reserved for delayed allocation and thus
> under normal circumstances nothing bad happens.
>   The question is how to solve this in the cleanest way. We can call
> vmtruncate() instead of ext3_truncate() as we used to do but Nick wants to
> get rid of that (that's why I originally changed the code to what it is
> now). So probably we could just manually call truncate_pagecache() instead.
> Nick, I think your truncate calling sequence patch set needs similar fix
> for all filesystems as well.

Thanks Jan, good analysis and yes I believe I will need to do a similar
fix there.

