From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Tue, 19 Mar 2013 13:07:09 +1100
Message-ID: <20130319020709.GW6369@dastard>
References: <20130315222818.GA16100@wallace>
 <20130316150923.GA18589@gmail.com>
 <20130317030648.GA14225@thunk.org>
 <51473C8B.5070509@redhat.com>
 <20130318170927.GA5639@thunk.org>
 <51475043.4010505@redhat.com>
 <20130318204133.GE22182@sgi.com>
 <20130318231233.GQ6369@dastard>
 <20130319014014.GA4660@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@redhat.com>,
	xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	Eric Whitney <enwlinux@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:44406 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288Ab3CSCHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 22:07:13 -0400
Content-Disposition: inline
In-Reply-To: <20130319014014.GA4660@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 09:40:14PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 19, 2013 at 10:12:33AM +1100, Dave Chinner wrote:
> > I know that Ted has already asked "what is an extent", but that's
> > also missing the point. An extent is defined, just like for on-disk
> > extent records, as a region of a file that is both logically and
> > physically contiguous. From that, a fragmented file is a file that
> > is logically contiguous but physically disjointed, and a sparse file
> > is one that is logically disjointed. i.e. it is the relationship
> > between extents that defines "sparse" and "fragmented", not the
> > definition of an extent itself.
> 
> Dave --- I think we're talking about two different tests.  This
> particular test is xfstest #285.

Yeah, I just realised that as I was reading through my ext4 list
feed...

> The test in question is subtest #8, which preallocates a 4MB file, and
> then writes a block filled with 'a' which is sized to the file system
> block size, at offset 10*fs_block_size.  It then checks to make sure
> SEEK_HOLE and SEEK_DATA is what it expects.

Yup, and as I just said in reply to myself, this means the same
reasoning applies - we can simply change the file layout to make
holes large enough that zero-out isn't an issue.

> > Looking at the test itself, then.  The backwards synchronous write
> > trick that is used by 218?  That's an underhanded trick to make XFS
> > create a fragmented file. We are not testing that the defragmenter
> > knows that it's a backwards written file - we are testing that it
> > sees the file as logically contiguous and physically disjointed, and
> > then defragments it successfully.
> 
> What I was saying --- in the other mail thread --- is that it's open
> to question whether a file which is being written via a random-write
> pattern, resulting in a physically contiguous, but not contiguous from
> a logical block number point of view, is worth defragging or not.  It
> all depends on whether the file is likely to be read sequentially in
> the future, or whether it will continue to be accessed via a random
> access pattern.  In the latter case, it might not be worth defragging
> the file.

AFAICT, that's something the defragmenter has no information on.
For example, two files with identical fragmentation patterns may be
accessed differently - how does the defragmenter know about that and
hence treat each file differently?

> In fact, I tend to agree with the argument we might as well attempt to
> make the file logically contiguous so that it's efficient to read the
> file sequentially.  But the people at Fujitsu who wrote the algorithms
> in e2defrag had gone out of their way to detect this case and avoid
> defragging the file so long as the physical blocks in use were
> contiguous --- and I believe that's also a valid design decision.

Sure - I never said it wasn't a valid categorisation. What is now
obvious to everyone is that it's a different defintion of
fragmentation to what the test (and xfs_fsr) expects. ;)

> Depending on how we resolve this particular design question, we can
> then decide whether we need to make test #218 fs specific or not.
> There was no thought design choics made by ext4 should drive changes
> in how the defragger works in xfs or btrfs, or vice versa.

Exactly. :)

> So I was looking for discussion by the ext4 developers; I was not
> requesting any changes from the XFS developers with respect to test
> #218.  (Not yet; and perhaps not ever.)

I know - what i was trying to do was to make sure that everyone
understood the theory behind the test before the discussion went too
far off the beaten track...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
