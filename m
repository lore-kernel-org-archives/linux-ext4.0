From: Jan Kara <jack@suse.cz>
Subject: [RFC] Block reservation for ext3 (continued)
Date: Tue, 19 Oct 2010 00:16:25 +0200
Message-ID: <20101018221624.GA30303@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab0JRWRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 18:17:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I'd like to sum up results of the discussion about the patches for ext3
block reservation on page fault
(http://www.spinics.net/lists/linux-ext4/msg21148.html) plus I have the
current performance numbers.
  Some programs like Berkeley DB like to mmap huge sparse file and then
randomly fill holes in it by writing to the mmap. When mmapped write is
done to a file backed by ext3, the filesystem does nothing to make sure
blocks will be available when we need to write them out. This has two nasty
consequences:
1) When flusher thread does writeback of the mmapped data, allocation
   happens in the context of flusher thread (i.e., as root). Thus user
   can effectively arbitrarily exceed quota limits or use space reserved
   only for sysadmin. Note that to fix this bug, we have to do the
   allocation/block reservation on page fault because that's the only
   place in which we know the real originator of the write and can thus
   apply appropriate restrictions.
2) When a filesystem runs out of space, we just drop data on the
   floor (the same happens when writeout is performed in the context of
   the user and he hits his quota limit). Subsequent fsync reports
   the error (ENOSPC) but that's kind of racy as concurrent sync(2) can
   eat the error return before fsync gets to it.

Because of (1) I see no other way to fix the problem than to change a
behavior of ext3 and fail the page fault if quota limit is exceeded (and
preferably also if filesystem runs out of space to fix (2)).

I'm aware of three realistic possibilities of tackling the problem.
a) Allocate blocks directly during page fault.
b) Allocate indirect blocks during page fault, reserve data blocks during
   page fault but allocate them only during writeout.
c) Do just block reservation during page fault, all allocations happens
   during writeout.

To benchmark the approaches, I've run slapadd on top of Berkeley DB adding
500k entries to an ldap database. The machine has 4 GB of ram, 8 processors
and 1TB SATA drive (reformatted before each run). I did 5 runs of each
test. The results are:
            AVG
orig ext3:  1564s (26m16.898s 25m58.215s 26m5.609s 26m0.291s 26m1.812s)
alloc ext3: 2885s (49m46.904s 37m27.507s 48m12.303s 47m26.368s 46m59.535s)
                - didn't count the second run into AVG
da ext3:    1934s (26m30.785s 32m14.243s 32m5.354s 32m17.017s 32m22.252s)
                - didn't count the first run into AVG
Note: I might look into what causes those outliers but for now I just
      ignore them.

We see that when doing allocation on page fault, slapadd is 84% slower.
When doing delayed allocation, it's 23% slower. The slowness of
ext3 doing allocation on commit is caused by fragmentation: In particular
__db.003 file has 100055 extents with allocation on page fault but only
183 extents with original ext3. With ext3 + delayed allocation, the number
of extents is practically the same as with original ext3. I have yet to
investigate, what causes the 23% slowdown there.

So although (a) is trivial to implement I don't think it's really usable
because of performance hit. (c) is also not quite there with the performance
but I can work on that if we agree that's the way to go. The main
disadvantage of (c) is the code complexity (code for tracking reserved
blocks and especially indirect blocks so that we avoid overestimating
needed indirect blocks by too much). (b) is going to me somewhere between
both complexity-wise and performance-wise.

Now I'd like to get to some agreement what we should do. Bite the bullet
and use (a), or should I continue improving (c)? Or is (b) considered a
better alternative (we would only need to track reserved data blocks and
use page dirty tag to detect whether indirect block has some (possibly)
delayed write pending and thus should be preserved even though there are
no blocks allocated under it during truncate)? Or something totally
different?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
