From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
 CPUs in build-all
Date: Mon, 31 Mar 2014 22:37:11 -0400
Message-ID: <20140401023711.GE4911@thunk.org>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
 <20140328161806.GA31772@thunk.org>
 <20140331025148.GF16336@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
	lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48076 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaDAChU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 22:37:20 -0400
Content-Disposition: inline
In-Reply-To: <20140331025148.GF16336@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2014 at 01:51:48PM +1100, Dave Chinner wrote:
> /me puts on his xfstests Maintainer Hat
> 
> That's a problem of your own making, Ted: please don't speak on
> behalf of what the upstream xfstests developers might or might not
> do just because of what you do with it as a user. The existance of
> many different environments people have built up around it is one of
> the strengths of xfstests. Hence the very act of considering
> enforcing One True Way of running xfstests is, IMO, harmful
> to the wider filesystem and xfstests community.

I wasn't presuming to do so.

I am merely pushing xfstests-bld because it's better that more people
run tests.  And if it makes it easier for people to run tests because
there is a turn-key way to run them, so much the better.  Having a
diversity of ways of running xfstests is good.  Having lots of people
run xfstests, even if many of them run it the same way, is better.

> You're also being rather presumptive that the existence of
> xfstests-bld requires us to change anything about the way xfstests
> is run.

I never said that any changes was needed to xfstests repository, or
how anyone else might choose to run xfstests.

> > especially given that based on a challenge which
> > Greg K-H gave us at the kernel pannel at Collab Summit,
>                ^^^^
> 
> Hmmmm. Not the way I remember it. Perhaps I should go look at the
> video and check that Greg was addressing me directly as the xfstests
> maintainer with those comments. After all, those lights on stage can
> be blinding.....

Sorry, I thought in the discussions we had afterwards you agreed with
me that *some* way of running xfststs easily was going to be a
requirement, as it is somewhat doubtful that most non-file system
developers will have the patience to deal with the "some assembly
required" in order to actually run xfstests, and actually putting
xfstests into the kernel sources wasn't going to be particularly
useful unless we have some way of making it possible to run the tests
in a semi-automated fashion.

Whether that method is based on what I have in xfstests-bld, or some
other way is I agree certainly up for discussion.  At the moment the
system I have is only set up for ext4, although I will happily accept
patches and work with other file system developers to enhance it so it
can work with other file systems.

And of course, whether changes in the mainline kernel tree are
manually propagated changes from the xfstests.git tree, or whether
primary development happens in the kernel tree, is ultimately going to
be up to you and the XFS developers who have stewardship of xfstests.
I'm not sure I would be that excited about manual propagation of
changes from one git tree to another, but that is of course, up to
you.

Cheers,

						- Ted
