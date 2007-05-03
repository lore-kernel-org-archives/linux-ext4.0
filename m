From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Thu, 3 May 2007 16:54:28 -0700
Message-ID: <20070503165428.855eb7d7.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<20070427013350.d0d7ac38.akpm@linux-foundation.org>
	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	<20070427193130.GD5967@schatzie.adilger.int>
	<20070427151837.f1439639.akpm@linux-foundation.org>
	<463A1E02.8020506@clusterfs.com>
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
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbXECXzS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 May 2007 19:55:18 -0400
In-Reply-To: <463A1E02.8020506@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 03 May 2007 21:38:10 +0400
Alex Tomas <alex@clusterfs.com> wrote:

> Andrew Morton wrote:
> > We can make great improvements here, and I've (twice) previously decribed
> > how: hoist the entire ordered-mode data handling out of ext3, and out of
> > the buffer_head layer and move it up into the VFS pagecache layer. 
> > Basically, do ordered-data with a commit-time inode walk, calling
> > do_sync_mapping_range().
> > 
> > Do it in the VFS.  Make reiserfs use it, remove reiserfs ordered-mode too. 
> > Make XFS use it, fix the hey-my-files-are-all-full-of-zeroes problem there.
> 
> I'm not sure it's that easy.
> 
> if we move to pages, then we have to mark pages to be flushed holding
> transaction open. now take delayed allocation into account: we need
> to allocate number of blocks at once and then mark all pages mapped,
> again within context of the same transaction.

Yes, there can be issues with needing to allocate journal space within the
context of a commit.  But

a) If the page has newly allocated space on disk then the metadata which
   refers to that page is already in the journal: no new journal space
   needed.

b) If the page doesn't have space allocated on disk then we don't need
   to write it out at ordered-mode commit time, because the post-recovery
   filesystem will not have any references to that page.

c) If the page is dirty due to overwrite then no metadata update was required.

IOW, under what circumstances would an ordered-mode commit need to allocate
space for a delayed-allocate page?

However b) might lead to the hey-my-file-is-full-of-zeroes problem.

> so, an implementation
> would look like the following?
> 
> generic_writepages() {
> 	/* collect set of contig. dirty pages */
> 	foo_get_blocks() {
> 		foo_journal_start();
> 		foo_new_blocks();
> 		foo_attach_blocks_to_inode();
> 		generic_mark_pages_mapped();
> 		foo_journal_stop();
> 	}
> }
> 
> another question is will it scale well given number of dirty inodes
> can be much larger than number of inodes with dirty mapped blocks
> (in delayed allocation case, for example) ?

Possibly - zillions of dirty-for-atime inodes might get in the way.  A
short-term fix would be to create a separate dirty-inode list on the
superblock (ug).  A long-term fix is to rip all the per-superblock
dirty-inode lists and use a radix-tree.  Not for lookup purposes, but for
the tree's ability to do tagged and restartable searches.
