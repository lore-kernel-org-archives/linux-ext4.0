From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Fri, 14 Nov 2014 09:49:46 +1100
Message-ID: <20141113224946.GK28565@dastard>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
 <20141113064150.GI28565@dastard>
 <20141113163511.GA15585@thunk.org>
 <20141113204832.GJ28565@dastard>
 <20141113213450.GA28780@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4843 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933065AbaKMWuC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 17:50:02 -0500
Content-Disposition: inline
In-Reply-To: <20141113213450.GA28780@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 04:34:50PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 14, 2014 at 07:48:32AM +1100, Dave Chinner wrote:
> > However, we'd be fools to ignore the development of relatime, which
> > in it's original form never updated the atime until m/ctime updated.
> > 3 years after it was introduced, relatime was changed to limit the
> > update delay to 24 hours (before it was made the default) so that
> > applications that required regular updates to timestamps didn't
> > silently stop working.
> > 
> > So perhaps what we should simply define "lazytime" policy to be
> > "only update timestamps once a day or whenever the inode is
> > otherwise modified, whichever comes first".
> 
> Yes, that's reasonable thing to do.  Right after I hit send on my last
> email I thought about adding a tunable that would do this sort of time
> delay, but making it be a hard-coded 24 hours is simpler.

*nod*

> > lazytime isn't POSIX compliant as it is implemented in the patch.
> > sync() won't write back inodes with lazy timestamp updates as they
> > are not tracked in dirty lists or the ext4 journal, therefore a
> > crash after a sync() can still lose timestamp updates from before
> > the sync() ran.
> 
> Good point, I had fixed it for fsync(), but not for sync();
> fortunately it's easy enough to make sure this gets fixed if we
> implement it at the VFS Layer.

Yup, though it probably requires adding those inodes to a special
dirty list so we can find them easily when needed. That would also
make a periodic writeback scan simple.

I suspect this could be easily integrated into the existing
mark_inode_dirty() infrastructure as I_DIRTY_TIME,
mark_inode_dirty_time() and putting them onto the wb->b_dirty list
with an expiry time 24 hours in the future....

The only difference is that we'd need to call ->update_time() if it
existed rather than write_inode() so that we log the timestamp
changes rather than just write the unlogged changes to the inode
(especially as XFS doesn't implement ->write_inode).

> > w.r.t. default behaviour, like relatime, I think this it will be a
> > couple of years before we can consider it to be a default.  We'll
> > need to shake out it's impact on the Real World first....
> 
> Fair enough, although that will only work if distributions actually
> enable it by default so we get that real world experience.  Otherwise,
> we'll not gain any experience wrt to Real World impact.

I think there'll be enough interest in this for there to be plenty
of real world testing done.

Besides, my Magic Crystal Ball(tm) says this:

"The racer-boys who run $FASTEST_DISTRO_OF_THE_MONTH and infest
racer-boy tech forums always tune atime for maximum warp speed.  One
of them will make the connection between atime updates and lazytime
and so turn on lazytime. They will then make a forum post saying how
their bonnie++ test runs 3.4% faster but only when they stand on
their head, go cross-eyed and stick their tongue out and so everyone
should do that it because it's Clearly Better.

Me Too posts will rapidly spread across racer forums around the
world and Google will then start returning them as the first hits
when someone searches for lazytime.  We'll see a cargo cult of users
doing headstands and using "-o noatime,nodiratime,lazytime" because
that's what the first guy did and everyone who has tried it since
has agreed that it was Clearly Better.

In ten years time we'll still be telling people that bonnie++
numbers are meaningless, nodiratime is redundant when you specific
noatime, that both are redundant when you specific lazytime and that
standing on your head making faces just makes you look like an idiot
and gives you a headache.

Meanwhile Eric will be sitting in the corner muttering quietly
to himself about how there *still* isn't a Sed For Google API that
would let him revise history to stop people finding old posts about
the performance benefits of standing on your head, making faces and
using noatime,nodiratime,lazytime..."

:)

> What I'm thinking about doing is adding a way to enable lazytime via a
> flag in the ext4 superblock, which in turn can be set by tune2fs or
> mke2fs (if so enabled by /etc/mke2fs.conf), so that we _can_ get this
> real world experience.

If you want, but I don't see the point - it's easy enough to add it
to /etc/fstab or a config section in xfstests without needing to
modify mkfs binaries.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
