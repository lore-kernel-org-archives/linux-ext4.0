From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/inode.c:3709! (Re: open bugs found by
 fuzzing)
Date: Fri, 15 Jul 2016 13:24:53 -0400
Message-ID: <20160715172453.GA18010@thunk.org>
References: <5787FFBA.70406@oracle.com>
 <5788E787.106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43430 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbcGORZC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jul 2016 13:25:02 -0400
Content-Disposition: inline
In-Reply-To: <5788E787.106@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 15, 2016 at 03:39:19PM +0200, Vegard Nossum wrote:
> 
> I'm a bit puzzled that we're actually creating a mapping and trying to
> decrypt here in the first place, since if this is an orphan inode that
> is being recovered at mount time it means that we know _for sure_ that
> there is no existing memory mappings and we're truncating it to 0.

There are times when we need to make sure i_size is truncated down
(and/or blocks are removed) if we crash in the middle of an operation
that for whatever reason, spans multiple trnsactions.

The simplest such example is truncating down to a non-zero i_size.

If your proposed patch to ext4_block_zero_page_range() helps, then
presumably we're *not* truncating down to zero, but instead truncating
to some non-zero size.  Solving this problem is going to be a bit
tricky.  We could try zeroing the data page at the very begionning of
the truncate operation, but then we could run into the case where data
page write makes it to disk but the truncate oepration was never
committed before a crash.  This would result in a consistent file
system, but the data wouldn't be consistent (that is, it wouldn't be
either the contents before the truncate or after truncate, but
something in between --- so the truncate would no longer be atomic
with respect to crashes).

The other thing I've noticed is I think we're adding some inodes to
the orphan list which shouldn't be necessary if delayed allocation or
data=writeback is enabled.  And when we're deciding whether or not to
add the inode to orphan list we're testing against i_size instead of
i_disksize.  So there are some cases where I think we can avoid adding
inodes to the orphan list in the buffered write case.  And that is a
good thing not just because it avoids the problem with respect to
encrypted inodes, but the orphan list is also a scalability bottleneck
for ext4.

						- Ted
