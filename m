From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Wed, 13 Oct 2010 01:14:08 +0200
Message-ID: <20101012231408.GC3812@quack.suse.cz>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
 <20101009180357.GG18454@thunk.org>
 <20101011142813.GC3830@quack.suse.cz>
 <20101011145945.166695e3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0JLXPJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Oct 2010 19:15:09 -0400
Content-Disposition: inline
In-Reply-To: <20101011145945.166695e3.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-10-10 14:59:45, Andrew Morton wrote:
> On Mon, 11 Oct 2010 16:28:13 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Sat 09-10-10 14:03:58, Ted Ts'o wrote:
> > > On Sat, Oct 09, 2010 at 02:12:24AM +0200, Jan Kara wrote:
> > > > 
> > > >   currently, when mmapped write is done to a file backed by ext3, the
> > > > filesystem does nothing to make sure blocks will be available when we need
> > > > to write them out.
> 
> I thought we'd actually fixed this.  I guess we didn't.  I think what
> we did do was to ensure that a subsequent fsync()/msync() would
> reliably report the data loss (has anyone tested this in the past few
> years??).  This is something, but it's quite lame.
  Yes, that's what we do these days - we set bit in address space in
generic_writepages() and the nearest syncing function (in fact the first
caller of filemap_fdatawait()) will get the error. It's kind of suboptimal,
that if e.g. sys_sync() runs before you manage to call fsync(), you've just
lost the chance to see possible error. So I agree the current interface is
lame (but not that I would know better at least for EIO handling)...

> > > 2) Allocate all of the pages that are not allocated at mmap time.
> > > Since ext3 doesn't have space for an uninitialized bit, we'd have to
> > > either (2a) forcing a disk write out for all of the newly initialized
> > > pages, or (2b) keep track of the allocated disk blocks in memory, but
> > > don't actually write the block mappings to the indirect blocks until
> > > the blocks are actually written out.  (This last might be just as
> > > complex, alas).
> >   Doing allocation at mmap time does not really work - on each mmap we
> > would have to map blocks for the whole file which would make mmap really
> > expensive operation. Doing it at page-fault as you suggest in (2a) works
> > (that's the second plausible option IMO) but the increased fragmentation
> > and thus loss of performance is rather noticeable. I don't have current
> > numbers but when I tried that last year Berkeley DB was like two or three
> > times slower.
> 
> ouch.
> 
> Can we fix the layout problem?  Are reservation windows of no use here?
  Reservation windows do not work for this load. The reason is that the
page-fault order is completely random so we just spend time creating and
removing tiny reservation windows because the next page fault doing
allocation is scarcely close enough to fall into the small window.
  The logic in ext3_find_goal() ends up picking blocks close together for
blocks belonging to the same indirect block if we are lucky but they
definitely won't be sequentially ordered. For Berkeley DB the situation is
made worse by the fact that there are several database files and their
blocks end up interleaved.
  So we could improve the layout but we'd have to tweak the reservation
logic and allocator and it's not completely clear to me how.
  One thing to note is that currently, ext3 *is* in fact doing delayed
allocation for writes via mmap. We just never called it like that and never
bothered to do proper space estimation...

> > > 3) Keep a global counter of sparse blocks which are mapped at mmap()
> > > time, and update it as blocks are allocated, or when the region is
> > > freed at munmap() time.
> >   Here again I see the problem that mapping all file blocks at mmap time
> > is rather expensive and so does not seem viable to me. Also the
> > overestimation of needed blocks could be rather huge.
> 
> When I did ext2 delayed allocation back in, err, 2001 I had
> considerable trouble working out how many blocks to actually reserve
> for a file block, because it also had to reserve the indirect blocks. 
> One file block allocation can result in reserving four disk blocks! 
> And iirc it was not possible with existing in-core data structures to
> work out whether all four blocks needed reserving until the actual
> block allocation had occurred.  So I ended up reserving the worst-case
> number of indirects, based upon the file offset.  If the disk ran out
> of "space" I'd do a forced writeback to empty all the reservations and
> would then take a look to see if the disk was _really_ out of space.
> 
> Is all of this an issue with this work?  If so, what approach did you
> take?
  Yeah, I've spotted exactly the same problem. How I decided to solve it in
the end is that in memory we keep track of each indirect block that has
delay-allocated buffer under it. This allows us to reserve space for each
indirect block at most once (I didn't bother with making the accounting
precise for double or triple indirect blocks so when I need to reserve
space for indirect block, I reserve the whole path just to be sure). This
pushes the error in estimation to rather acceptable range for reasonably
common workloads - the error can still be 50% for workloads which use just
one data block in each indirect block but even in this case the absolute
number of blocks falsely reserved is small.
  The cost is of course increased complexity of the code, the memory
spent for tracking those indirect blocks (32 bytes per indirect block), and
some time for lookups in the RB-tree of the structures. At least the nice
thing is that when there are no delay-allocated blocks, there isn't any
overhead (tree is empty).

> > > #3 might be much simpler, at the end of the day.  Note that there are
> > > some Japanese customers that really freaked with ext4 just because it
> > > was *different*, and begged a distribution not to ship ext4 because it
> > > might destablize their customers.  Not that I think we are obliged to
> > > listen to some of the more extremely conservative customers, but there
> > > was something nice about telling people (well, if you want something
> > > which is nice and stable and conservative, you can pick ext3).
> >   I'm aware of this. Actually, the user observable differences should be
> > rather minimal. The only one I'm aware of is that you can get SIGSEGV at
> > page fault time because the filesystem runs out of disk space (or out of
> > disk quota) which seems better than throwing away the data later. Also I
> > don't think anybody serious runs systems close to ENOSPC regularly and if
> > that happens accidentally, manual intervention is usually needed anyway...
> 
> Gee.  I remember people having issues with forcing the SEGV at
> pagefault time.  It _is_ a behaviour change: the application might be
> about to free up some disk space, so the msync() would have succeeded
> anyway.  
> 
> iirc another issue was that the standards (posix?) don't anticipate
> getting a SEGV in response to ENOSPC.  There might have been other
> concerns - it's all foggy now.
> 
> Our general answer to this overall problem is: "run msync() and check
> the result".  That's a bit weaselly, but it's not a _bad_ answer. 
> After all, there might be an EIO as well!  So a good application should
> be checking for both ENOSPC and EIO.  Your patches only address the
> ENOSPC.
  Yes, here my main concern is that the patch set is not only about ENOSPC
(I can imagine we could live with that when we lived with that upto now)
but also about the quota problem.  To reiterate - if the allocation happens
during writeback, we don't know who originally did the write and thus
whether he was allowed to exceed quota limit or not. Currently, since
flusher threads run as root, we always ignore quota limits and thus user
can write arbirary amount of data by writing via mmap. Sysadmins don't like
that... BTW the same problem happens with checking reserved space for root
in ext? filesystems.
  I don't see a different solution than to check quotas at page fault
because that is the only moment when we know the identity of the writer and
if quota check fails we have to refuse the fault - SIGSEGV is the only
option I know about. And when I have to do all the reservation because of
quotas, ENOSPC handling is a nice bonus.

  IMHO there are three separate questions:
a) Do we want to fix the quota problem?
   - I'm convinced that yes.
b) Can we solve it without behavior change of sending SIGSEGV on error?
   - I don't see how but maybe you have some bright idea...
c) When we decide some reservation scheme is unavoidable, there is question
   how to estimate amount of indirect blocks. My scheme is one possibility,
   but there is a wider variety of tradeoffs between complexity and
   accuracy. A special low effort, low impact possibility here might be to
   just ignore the ENOSPC problem as we did so far, reserve only quota for
   data block on page fault, and rely on the fact that there isn't going to
   be that much metadata so user cannot exceed his quota limit by too
   much... But when we already have the interface change, it seems a bit
   stupid not to fix it properly and also handle ENOSPC with it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
