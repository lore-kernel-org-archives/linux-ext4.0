From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Mon, 11 Oct 2010 16:28:13 +0200
Message-ID: <20101011142813.GC3830@quack.suse.cz>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
 <20101009180357.GG18454@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0JKO3M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 10:29:12 -0400
Content-Disposition: inline
In-Reply-To: <20101009180357.GG18454@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-10-10 14:03:58, Ted Ts'o wrote:
> On Sat, Oct 09, 2010 at 02:12:24AM +0200, Jan Kara wrote:
> > 
> >   currently, when mmapped write is done to a file backed by ext3, the
> > filesystem does nothing to make sure blocks will be available when we need
> > to write them out.
> 
> Hmm, you've done all of this work already, so this isn't the best time
> to suggest this, but I wonder if we've explored all of the
> alternatives that might allow for a less drastic set of changes to
> ext3, just out of stability's sake.
  Yeah, I understand that and I've been also thinking for some time whether
I cannot avoid implementing block reservation but I haven't come up with
anything really acceptable. Moreover, unless we write via mmap to a sparse
file, the code paths taken are changed only a little (only when and how
we account for allocated blocks)...

> How often do legitimate workloads mmap a sparse file then write into
> it?  As I recall, the original POSIX.1 spec didn't allow mmap beyond
> the end of the file; this I believe was lifted later on (at least I
> don't see it in SUSv3 spec).
  Well, mmap beyond EOF is still undefined AFAIK (although Linux
traditionally supports it) but mmap of sparse files was always supposed
to work. My favorite user of sparse-file mmap is Berkeley DB, some torrent
clients do that as well and I believe there are others. So it's not the most
common thing but it happens often enough.

> If it's not all that common, then other options are:
> 
> 1) Fail an mmap with EINVAL if there is an attempt to map a file
> region which is either sparse or extends beyond the end of a file.
> This is probably not a great alternative, but it's a possibility.
  This is no-go IMHO. We would surely get lots of users complaining...

> 2) Allocate all of the pages that are not allocated at mmap time.
> Since ext3 doesn't have space for an uninitialized bit, we'd have to
> either (2a) forcing a disk write out for all of the newly initialized
> pages, or (2b) keep track of the allocated disk blocks in memory, but
> don't actually write the block mappings to the indirect blocks until
> the blocks are actually written out.  (This last might be just as
> complex, alas).
  Doing allocation at mmap time does not really work - on each mmap we
would have to map blocks for the whole file which would make mmap really
expensive operation. Doing it at page-fault as you suggest in (2a) works
(that's the second plausible option IMO) but the increased fragmentation
and thus loss of performance is rather noticeable. I don't have current
numbers but when I tried that last year Berkeley DB was like two or three
times slower.
  In your (2b) suggestion, I don't see how we would avoid leaking allocated
blocks when we crash before writing allocation to indirect block. Also the
fragmentation problem which seems to be the main source of performance
issues would stay the same.
  
> 3) Keep a global counter of sparse blocks which are mapped at mmap()
> time, and update it as blocks are allocated, or when the region is
> freed at munmap() time.
  Here again I see the problem that mapping all file blocks at mmap time
is rather expensive and so does not seem viable to me. Also the
overestimation of needed blocks could be rather huge.
  
> #3 might be much simpler, at the end of the day.  Note that there are
> some Japanese customers that really freaked with ext4 just because it
> was *different*, and begged a distribution not to ship ext4 because it
> might destablize their customers.  Not that I think we are obliged to
> listen to some of the more extremely conservative customers, but there
> was something nice about telling people (well, if you want something
> which is nice and stable and conservative, you can pick ext3).
  I'm aware of this. Actually, the user observable differences should be
rather minimal. The only one I'm aware of is that you can get SIGSEGV at
page fault time because the filesystem runs out of disk space (or out of
disk quota) which seems better than throwing away the data later. Also I
don't think anybody serious runs systems close to ENOSPC regularly and if
that happens accidentally, manual intervention is usually needed anyway...
  Thanks for your ideas!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
