From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Fri, 04 May 2007 11:39:22 +0400
Message-ID: <463AE32A.5000902@clusterfs.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>	<20070427013350.d0d7ac38.akpm@linux-foundation.org>	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>	<20070427193130.GD5967@schatzie.adilger.int>	<20070427151837.f1439639.akpm@linux-foundation.org>	<463A1E02.8020506@clusterfs.com>	<20070503165428.855eb7d7.akpm@linux-foundation.org>	<463AD024.6060208@clusterfs.com>	<20070503233804.9dace4a7.akpm@linux-foundation.org>	<463AD948.9090103@clusterfs.com> <20070504001802.0e86e9dd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marat Buharov <marat.buharov@gmail.com>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:56229 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbXEDHjn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 May 2007 03:39:43 -0400
In-Reply-To: <20070504001802.0e86e9dd.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> I'm still not understanding.  The terms you're using are a bit ambiguous.
> 
> What does "find some dirty unallocated blocks" mean?  Find a page which is
> dirty and which does not have a disk mapping?
> 
> Normally the above operation would be implemented via
> ext4_writeback_writepage(), and it runs under lock_page().

I'm mostly worried about delayed allocation case. My impression was that
holding number of pages locked isn't a good idea, even if they're locked
in index order. so, I was going to turn number of pages writeback, then
allocate blocks for all of them at once, then put proper blocknr's into
bh's (or PG_mappedtodisk?).

> 
> 
>> 					going to commit
>> 					find inode I dirty
>> 					do NOT find these blocks because they're
>> 					  allocated only, but pages/bhs aren't mapped
>> 					  to them
>> 					start commit
> 
> I think you're assuming here that commit would be using ->t_sync_datalist
> to locate dirty buffer_heads.

nope, I mean sb->inode->page walk.

> But under this proposal, t_sync_datalist just gets removed: the new
> ordered-data mode _only_ need to do the sb->inode->page walk.  So if I'm
> understanding you, the way in which we'd handle any such race is to make
> kjournald's writeback of the dirty pages block in lock_page().  Once it
> gets the page lock it can look to see if some other thread has mapped the
> page to disk.

if I'm right holding number of pages locked, then they won't be locked, but
writeback. of course kjournald can block on writeback as well, but how does
it find pages with *newly allocated* blocks only?

> It may turn out that kjournald needs a private way of getting at the
> I_DIRTY_PAGES inodes to do this properly, but I don't _think_ so.  If we
> had the radix-tree-of-dirty-inodes thing then that's easy enough to do
> anyway, with a tagged search.  But I expect that a single pass through the
> superblock's dirty inodes would suffice for ordered-data.  Files which
> have chattr +j would screw things up, as usual.

not dirty inodes only, but rather some fast way to find pages with newly
allocated pages.

> I assume (hope) that your delayed allocation code implements
> ->writepages()?  Doing the allocation one-page-at-a-time sounds painful...

indeed. this is a root cause of all this complexity.

thanks, Alex
