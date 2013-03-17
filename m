From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] filefrag: count a contiguous extent when both
 logical and physical blocks are contiguous
Date: Mon, 18 Mar 2013 10:11:15 +1100
Message-ID: <20130317231115.GJ6369@dastard>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
 <1362327978-30423-3-git-send-email-wenqing.lz@taobao.com>
 <20130313201611.GH5604@thunk.org>
 <20130314125441.GA16350@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10881 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698Ab3CQXLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Mar 2013 19:11:18 -0400
Content-Disposition: inline
In-Reply-To: <20130314125441.GA16350@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 14, 2013 at 08:54:42PM +0800, Zheng Liu wrote:
> On Wed, Mar 13, 2013 at 04:16:11PM -0400, Theodore Ts'o wrote:
> > On Mon, Mar 04, 2013 at 12:26:18AM +0800, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > This commit fixes a bug in filefrag that filefrag miss calculates
> > > contiguous extent when physical blocks are contiguous but logical blocks
> > > aren't.  This case can be created by xfstests #218 or the following
> > > script.
> > > 
> > > 	for I in `seq 0 2 31`; do
> > > 		dd if=/dev/zero of=$testfile bs=4k count=1 conv=notrunc \
> > > 			seek=$I oflag=sync &>/dev/null
> > > 	done
> > > 
> > > Meanwhile this commit prints expected logical block.
> > 
> > Hmm, this (and your previous patch) fundamentally raises the question
> > of what do we call an "extent", doesn't it?
> > 
> > Ignoring for now the question of what xfstests #218 is expecting (if
> > we disagree with what's "best", we should have a discussion with the
> > other fs maintainers, and in the worst case, make our own version of
> > the test), the question is how should defragmentation handle sparse
> > files?  In general, sparse files imply that random access workload, so
> > whether or not the file is contiguous doesn't really matter much.
> > 
> > If we want to optimize the time to copy said sparse file, and if we
> > assume that by the time we are defragging said sparse file, we are
> > done doing writes which will allocate new blocks, then having defrag
> > optimize the file so that when the extents are sorted by logical block
> > number, the physical block numbers are contiguous, then that's
> > probably the best "figure of merit" to use.  And I'll note that right
> > now that's what filefrag is reporting, and what I think e4defrag
> > should be changed to use when deciding whether the donor file is
> > "better" than the original file.
> > 
> > But that's not necessarily the only way to measure extents, and the
> > current e4defrag code is clearly of the opinion that if the file is
> > using a contiguous region of blocks, even if the blocks were allocated
> > "backwards", that there's no point defragging the file, since after
> > all, if the file was written in such a random order with respect to
> > logical block numbers, it will probably be read in a random order, so
> > keeping the file blocks used contiguous to minimize free block
> > fragmentation is the best thing to shoot for.
> > 
> > It's not clear that there's one right answer, but things will be a lot
> > less confusing if we can agree amongst ourselves what answer we want
> > to use --- and then if we need to either change the xfstests, or maybe
> > create an option to filefrag to calculate the number of fragments that
> > the xfstest is expecting.  But we should first decide what is the
> > right thing, and then we can see whether or not what it matches what
> > the test is demanding.
> 
> Thanks for the explanation.  Indeed the key problem is how to define an
> extent.  I agree with you that we shouldn't only match what the test
> expects, and just let test case pass.

AFAIC, there is no ambiguity into what defines an extent. An extent
defines a single logical offset to physical block relationship. As
soon as either logical offset or physical block are no longer able
to be described by the relationship, you need to define a new
relationship. That's the definition every filesystem uses for
recording extents on disk, and that gives a pretty solid basis for
what everyone expects filefrag to report to users as an extent.

IOWs, a sparse file is simply a bunch of extent records that have
discontiguous logical offsets.  Similarly, a fragmented file is
simply a bunch of extent records that are physically discontiguous.

Therefore, the definition of "sparse" and "fragmented" is not
dependent on the definition of "extent", rather it is dependent on
the relationship between extents and how the filesystem itself
defines that relationship.

So, back to test 218. If you have 10 extents that are logically
contiguous, but physically discontiguous, is that a fragmented file?

The question 218 is asking is not whether those 10 extents were
allocated backwards (that's just an underhanded trick to make the
XFS allocator create a fragmented file), but rather whether the
defragmenter can recognise files that match the above definition
of a fragmented file and hence defragment them down to a single
extent.

Similarly, 218 then creates sparse files and determines whether the
defragmenter behaves as expected for a sparse file. That is, you
cannot physically merge the extents because they are discontiguous,
and hence the file should not be touched by the defragmenter.

Hence I think you are reading way too much into the test case. It's
testing a basic premise of defragmenter behaviour - recognising
sparse and/or fragmented files and dealing with them appropriately.
If you want to change how e2defrag defines "fragmented" and "sparse"
to be something more complex and different to what 218 expects, then
you'll need a new e2defrag specific test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
