From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] filefrag: count a contiguous extent when both
 logical and physical blocks are contiguous
Date: Wed, 13 Mar 2013 16:16:11 -0400
Message-ID: <20130313201611.GH5604@thunk.org>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
 <1362327978-30423-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53215 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3CMUQQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 16:16:16 -0400
Content-Disposition: inline
In-Reply-To: <1362327978-30423-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 04, 2013 at 12:26:18AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit fixes a bug in filefrag that filefrag miss calculates
> contiguous extent when physical blocks are contiguous but logical blocks
> aren't.  This case can be created by xfstests #218 or the following
> script.
> 
> 	for I in `seq 0 2 31`; do
> 		dd if=/dev/zero of=$testfile bs=4k count=1 conv=notrunc \
> 			seek=$I oflag=sync &>/dev/null
> 	done
> 
> Meanwhile this commit prints expected logical block.

Hmm, this (and your previous patch) fundamentally raises the question
of what do we call an "extent", doesn't it?

Ignoring for now the question of what xfstests #218 is expecting (if
we disagree with what's "best", we should have a discussion with the
other fs maintainers, and in the worst case, make our own version of
the test), the question is how should defragmentation handle sparse
files?  In general, sparse files imply that random access workload, so
whether or not the file is contiguous doesn't really matter much.

If we want to optimize the time to copy said sparse file, and if we
assume that by the time we are defragging said sparse file, we are
done doing writes which will allocate new blocks, then having defrag
optimize the file so that when the extents are sorted by logical block
number, the physical block numbers are contiguous, then that's
probably the best "figure of merit" to use.  And I'll note that right
now that's what filefrag is reporting, and what I think e4defrag
should be changed to use when deciding whether the donor file is
"better" than the original file.

But that's not necessarily the only way to measure extents, and the
current e4defrag code is clearly of the opinion that if the file is
using a contiguous region of blocks, even if the blocks were allocated
"backwards", that there's no point defragging the file, since after
all, if the file was written in such a random order with respect to
logical block numbers, it will probably be read in a random order, so
keeping the file blocks used contiguous to minimize free block
fragmentation is the best thing to shoot for.

It's not clear that there's one right answer, but things will be a lot
less confusing if we can agree amongst ourselves what answer we want
to use --- and then if we need to either change the xfstests, or maybe
create an option to filefrag to calculate the number of fragments that
the xfstest is expecting.  But we should first decide what is the
right thing, and then we can see whether or not what it matches what
the test is demanding.

					- Ted
