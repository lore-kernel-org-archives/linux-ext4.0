From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Sat, 27 Dec 2014 10:39:24 -0500
Message-ID: <20141227153924.GC24553@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
 <20141211200540.GE31008@thunk.org>
 <878uidgshe.fsf@openvz.org>
 <20141217035713.GW17575@thunk.org>
 <87y4q6joy4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44121 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0PjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Dec 2014 10:39:25 -0500
Content-Disposition: inline
In-Reply-To: <87y4q6joy4.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 17, 2014 at 06:06:27PM +0300, Dmitry Monakhov wrote:
> I'm working on that. Sorry for delay. Delay is caused by confusion of
> existing seek_xxx implementation (even w/o my changes)
> For example: it is not obvious to believe that if bh is (bh_unwritten |
> bh_uptodate) then it contains valid data. IMHO it is just a fallocated
> area.  I already have simple fix for actual regression. But I try to
> review,optimize and retest all related logic.

Hi Dmitry,

Any update on how your testing is going?  I was wondering if I could
take a look at your fix just so I can understand what is going on.

> FYI: Currently test failed only on EXT4 w/o extents but w/ -odelalloc enabled.
> This configuration is absent in xfstest-bld where conf/ext3 is EXT4 w/o
> extents and w/ nodelalloc. That is why we oversee this from very beginning.

One of the reasons why I'm having trouble understanding what is
happening is that I can *only* reproduce the test if I use

./kvm-xfstests -c ext3 generic/285

If I run it by hand, I get this instead:

# xfstests/src/seek_sanity_test  /mnt/test
File system magic#: 0xef53
Allocation size: 4096
Kernel does not support llseek(2) extensions SEEK_HOLE and/or SEEK_DATA. Aborting.

... which is what I would expect, since this test should be refusing
to run in the first place if extents aren't available.  Also, if
extents aren't available, then we shouldn't be seeing *any* fallocated
space, so if the fault is in handling (bh_unwritten | bh_uptodate),
then this case shouldn't be happening at all on a file system w/o
extents, right?

One of the reasons why I am worrying is now that it's post -rc1, more
people will be testing out the kernel, and I'm concerned that I don't
understand what the risk exposure might be, especially since there are
programs like /bin/cp that assume SEEK_DATA and SEEK_HOLE work
correctly, and early testers might suffer data loss if they aren't
working correctly.

So I'm trying to determine whether this is something where we
understand what is going on so we can fix the bug, or whether I'm
better off reverting the commit and waiting until we have fully
characterized the bug.

Thanks,

					- Ted
