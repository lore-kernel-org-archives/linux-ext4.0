From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Tue, 8 Apr 2014 20:47:38 +1000
Message-ID: <20140408104738.GD22917@dastard>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
 <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
 <20140404202323.GB10275@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140404202323.GB10275@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 04, 2014 at 04:23:23PM -0400, Theodore Ts'o wrote:
> Ah yes, I had forgotten that you had sent those patches, thanks.
> 
> It looks like that since you worded it as "just RFC for now since they
> aren't in 3.15 yet", the xfstests folks never actually accepted your
> changes into xfstests, and so I never picked it up.
> 
> For future reference, the tests for COLLAPSE_RANGE and ZERO_RANGE were
> accepted into xfstests well before the merge window opened, and that
> was awfully convenience since we could pull the latest from the
> xfstests.git tree and do automated testing while those patches were in
> the ext4 and xfs trees.

The xfstests for those features were merged into xfstests at the
same time the the kernel code was pulled into the XFS tree. i.e.
once the kernel code had been merged into a maintainer's tree. That's
why they were there for the testing you needed to do with ext4.

There hasn't been any XFS patches written for renameat2 and the
patches that were posted as "here's some tests, maybe we'll get
renameat2 into 3.15" so there hasn't been any urgency indicated to
the xfstests folks that they were needed. We've been pretty much out
of the loop here....

> So feel free to be a bit more insistent about asking for your xfstests
> to be merged upstream; you don't have to wait until the changes reach
> mainline.

Actually, we don't add tests to xfstests until the patches that they
test are committed to an upstream repository somewhere. i.e. we need
some guarantee that the code is actually accepted by a maintainer
and is on it's way to mainline before we'll include the tests. We
don't want to have to waste time on reviewing and committing tests
for functionality that never goes into the mainline tree....

> If it's clear that the patches are going to be accepted,
> and they are in the subsystem trees, that's a fine time to push to get
> the changes into xfstests.

I asked whether this patchset is going to make 3.15 and reviewed the
xfstests patches that had been posted earlier today. About 12 hours
before I read this thread.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
