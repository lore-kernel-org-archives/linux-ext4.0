From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 4 May 2007 01:02:12 -0700
Message-ID: <20070504010212.ce6eca53.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<20070427013350.d0d7ac38.akpm@linux-foundation.org>
	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	<20070427193130.GD5967@schatzie.adilger.int>
	<20070427151837.f1439639.akpm@linux-foundation.org>
	<463A1E02.8020506@clusterfs.com>
	<20070503165428.855eb7d7.akpm@linux-foundation.org>
	<463AD024.6060208@clusterfs.com>
	<20070503233804.9dace4a7.akpm@linux-foundation.org>
	<463AD948.9090103@clusterfs.com>
	<20070504001802.0e86e9dd.akpm@linux-foundation.org>
	<463AE32A.5000902@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marat Buharov <marat.buharov@gmail.com>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965706AbXEDIDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2007 04:03:41 -0400
In-Reply-To: <463AE32A.5000902@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 04 May 2007 11:39:22 +0400 Alex Tomas <alex@clusterfs.com> wrote:

> Andrew Morton wrote:
> > I'm still not understanding.  The terms you're using are a bit ambiguous.
> > 
> > What does "find some dirty unallocated blocks" mean?  Find a page which is
> > dirty and which does not have a disk mapping?
> > 
> > Normally the above operation would be implemented via
> > ext4_writeback_writepage(), and it runs under lock_page().
> 
> I'm mostly worried about delayed allocation case. My impression was that
> holding number of pages locked isn't a good idea, even if they're locked
> in index order. so, I was going to turn number of pages writeback, then
> allocate blocks for all of them at once, then put proper blocknr's into
> bh's (or PG_mappedtodisk?).

ooh, that sounds hacky and quite worrisome.  If someone comes in and does
an fsync() we've lost our synchronisation point.  Yes, all callers happen
to do

	lock_page();
	wait_on_page_writeback();

(I think) but we've never considered a bare PageWriteback() as something
which protects page internals.  We're OK wrt page reclaim and we're OK wrt
truncate and invalidate.  As long as the page is uptodate we _should_ be OK
wrt readpage().  But still, it'd be better to use the standard locking
rather than inventing new rules, if poss.


I'd be 100% OK with locking multiple pages in ascending pgoff_t order. 
Locking the page is the standard way of doing this synchronisation and the
only problem I can think of is that having a tremendous number of pages
locked could cause the wake_up_page() waitqueue hashes to get overloaded
and go slow.  But it's also possible to lock many, many pages with
readahead and nobody has reported problems in there.


> > 
> > 
> >> 					going to commit
> >> 					find inode I dirty
> >> 					do NOT find these blocks because they're
> >> 					  allocated only, but pages/bhs aren't mapped
> >> 					  to them
> >> 					start commit
> > 
> > I think you're assuming here that commit would be using ->t_sync_datalist
> > to locate dirty buffer_heads.
> 
> nope, I mean sb->inode->page walk.
> 
> > But under this proposal, t_sync_datalist just gets removed: the new
> > ordered-data mode _only_ need to do the sb->inode->page walk.  So if I'm
> > understanding you, the way in which we'd handle any such race is to make
> > kjournald's writeback of the dirty pages block in lock_page().  Once it
> > gets the page lock it can look to see if some other thread has mapped the
> > page to disk.
> 
> if I'm right holding number of pages locked, then they won't be locked, but
> writeback. of course kjournald can block on writeback as well, but how does
> it find pages with *newly allocated* blocks only?

I don't think we'd want kjournald to do that.  Even if a page was dirtied
by an overwrite, we'd want to write it back during commit, just from a
quality-of-implementation point of view.  If we were to leave these pages
unwritten during commit then a post-recovery file could have a mix of
up-to-five-second-old data and up-to-30-seconds-old data.

> > It may turn out that kjournald needs a private way of getting at the
> > I_DIRTY_PAGES inodes to do this properly, but I don't _think_ so.  If we
> > had the radix-tree-of-dirty-inodes thing then that's easy enough to do
> > anyway, with a tagged search.  But I expect that a single pass through the
> > superblock's dirty inodes would suffice for ordered-data.  Files which
> > have chattr +j would screw things up, as usual.
> 
> not dirty inodes only, but rather some fast way to find pages with newly
> allocated pages.

Newly allocated blocks, you mean?

Just write out the overwritten blocks as well as the new ones, I reckon. 
It's what we do now.
