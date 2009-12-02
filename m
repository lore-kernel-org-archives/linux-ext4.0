From: Jan Kara <jack@suse.cz>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Wed, 2 Dec 2009 20:04:26 +0100
Message-ID: <20091202190425.GA30315@quack.suse.cz>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
 <1259667765.9614.19.camel@marge.simson.net>
 <20091201143558.GB12730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Y Knight <foom@fuhm.net>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	npiggin@suse.de
To: Mike Galbraith <gleep@gmx.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755484AbZLBTEc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091201143558.GB12730@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 01-12-09 15:35:59, Jan Kara wrote:
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
> corruption anyway.
  I've looked into why writev fails reliably the writes. The reason is that
iov_iter_fault_in_readable() faults in only the first IO buffer. Because
this is just 600 bytes big, following iov_iter_copy_from_user_atomic copies
only 600 bytes and block_write_end sets number of copied bytes to 0. Thus
we restart the write and do it one iov per iteration which succeeds. So
everything works as designed only it gets inefficient in this particular
case.

								Honza
