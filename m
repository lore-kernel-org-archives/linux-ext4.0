From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Wed, 1 Feb 2012 14:57:08 +1100
Message-ID: <20120201035708.GR9090@dastard>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
 <20120125224847.GT15102@dastard>
 <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
 <20120127001904.GB15102@dastard>
 <4F22B436.9070306@tao.ma>
 <20120129220705.GE15102@dastard>
 <01B555EA-1364-4288-ACE8-0EF42533701E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Robin Dong <hao.bigrat@gmail.com>,
	Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30034 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab2BAD5N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 22:57:13 -0500
Content-Disposition: inline
In-Reply-To: <01B555EA-1364-4288-ACE8-0EF42533701E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 30, 2012 at 03:50:24PM -0700, Andreas Dilger wrote:
> On 2012-01-29, at 3:07 PM, Dave Chinner wrote:
> > yet all I see is people trying to make it something for big, bigger
> > and biggest. Bigalloc, new extent formats, no-journal mode,
> > dioread_nolock, COW snapshots, secure delete, etc. It's a list of
> > features that are somewhat incompatible with each other that are
> > useful to only a handful of vendors or companies. Most have no
> > relevance at all to the uses of the majority of ext4 users.
> 
> ???  This is quickly degrading into a mud slinging match.  You claim
> that "because ext4 is only relevant for desktops, it shouldn't try to
> scale or improve performance".  Should I similarly claim that "because
> XFS is only relevant to gigantic SMP systems with huge RAID arrays it
> shouldn't try to improve small file performance or be CPU efficient"?

You can if you want.....

But then I'll just point to Eric Whitney's latest results showing
XFS is generally slightly more CPU efficient that ext4, and performs
as well as ext4 on the small file workload he ran. :)

> Not at all.  The ext4 users and developers choose it because it meets
> their needs better than XFS for one reason or another, and we will

More likely is that most desktop users choose ext4 because it is the
default filesystem their distribution installs, not because they
know anything about it or any other linux filesystem....

> continue to improve it for everyone while we are interested to do so.
> The ext4 multi-block allocator was originally done for high-throughput
> file servers, but it is totally relevant for desktop workloads today.
> The same is true for delayed allocation, and other improvements in the
> past.  I imagine that bigalloc would be very welcome for media servers
> and other large file IO environments.

Yes, it will help certain workloads, but it isn't a general solution
to the allocation scalability problems. It also requires informed
and knowledgable users to about such features, when it is best to
use them and when not to use them.

One of the things that I'm concerned about is that the changes
being made add a new upfront decisions that users have to be
informed about and understand sufficiently to be able to make the
correct decision. You're making the assumption that users are
informed and knowledgable, and all filesystem developers should know
this is simply not true. Users repeatedly demonstrate that they
don't know how filesystems work, don't understand the knobs that
are provided, don't understand what their applications do in terms
of filesystem operations and don't really understand their data
sets. Education takes time and effort, but still users make the same
mistakes over and over again.

That's the reason why we have the mantra "use the defaults" when it
comes to users asking questions about how to optimise an XFS
filesystem.  XFS is almost at the point where the defaults work for
most people, from $300 ARM-based NAS boxes all the way up to
multi-million dollar supercomputers.  That's what we should be
delivering to users - something that just works.  Special case
solutions should be few and far between, and only in those cases
should education about the various options be necessary.

That ext4 now has a much more complex configuration matrix than XFS,
and that developers are expecting users to understand that matrix
and how it relates to their systems and workloads without prior
experience seems like a pretty valid concern to me.

> > IOWs, the slowness of the allocation greatly limits the ability to
> > test such a feature at the scale it is designed to support.  That's
> > my big, overriding concern - with ext4 allocation being so slow, we
> > can't really test large files with enough thoroughness *right now*.
> > Increasing the file size is only going to make that problem worse
> > and that, to me, is a show stopper. If you can't test it properly,
> > then the change should not be made.
> 
> Hmm, excellent suggestion.  Maybe if we implement faster allocation
> for ext4 your objections could be quieted?  Wait, that is what you
> are objecting to in the first place (bigalloc, large blocks, etc) or
> any changes to ext4 that don't meet your approval.

bigalloc is not a solution to the use case that I initially found
this problem on - filling large filesystems quickly before starting
testing. Regardless of the existence of bigalloc, we still need to
test large 4k block size, 4k alloc size filesystems because that is
what users will mostly use.

Further, bigalloc makes the large filesystem test matrix more
complex and time consuming - we now have to test default configs as
well as bigalloc filesystems. And if this new extent format change
goes in, suddenly it is "defaults X bigalloc (various sizes) X
extent format".  This gets impossible to test very quickly, and so
we end up with a mess of options that nobody really knows how well
they work together because they simply aren't adequately tested.

I've been trying to help address this large scale testing problem -
to make >16TB filesystem testing for ext4 and btrfs as well as XFS
easy to do through xfstests. Allocation speed is just one of the
initial problems I'm coming across for both ext4 and BTRFS. Having
easily repeatable tests for large filesystems is fundamental to
being able to support such filesystems.

However, requiring magic pixie dust to enable such testing raises a
serious question about the suitability of the filesystem for such
usage. And then further expanding support in an area that is known
to be deficient seems very misguided to me - it doesn't make testing
any easier, and it makes testing large files and filesystems even
more time consuming. Ths is a serious problem, and that's why I'm
asking whether this change is even something that should be done in
the first place.

Yes, I could have said it better than a throw-away, one-line
comment. But I'm trying to explain the many reasons I had for the
glib comment because that comment based on problems that I've seen
over the past year of so trying to use and test ext4....

> >> I have read and watched the talk you gave in this year's LCA,
> >> your assumption about ext4 may be a little frightening, but it
> >> is good for the ext4 community. In your talk "xfs is much
> >> slower than ext4 in 2009-2010 for meta-intensive workload", and
> >> now it works much faster. So why do you think ext4 can't be
> >> improved also like xfs?
> > 
> > Because all of the XFS changes talked about in that talk did not
> > change the on-disk format at all. They are *software-only*
> > changes and are completely transparent to users. They are even
> > the default behaviours now, so users with 10 year old XFS
> > filesystems will also benefit from them. And they can go back to
> > their old kernels if they don't like the new kernels, too...
> 
> That is only partly true.  XFS had to change the 32-bit vs. 64-bit
> inode numbers to get better performance, and that is not backward
> compatible on 32-bit systems.  XFS had changed the logging format
> to be more efficient in order to not suck at metadata benchmarks.

Not true, but it's irrelevant to the above discussion, anyway, so I
won't waste time going done this path any further....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
