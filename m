From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 file replace guarantees
Date: Sun, 23 Jun 2013 11:58:05 +1000
Message-ID: <20130623015805.GY29376@dastard>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org>
 <20130622032944.GX29376@dastard>
 <20130622044718.GC4727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ryan Lortie <desrt@desrt.ca>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58589 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714Ab3FWB6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jun 2013 21:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20130622044718.GC4727@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 22, 2013 at 12:47:18AM -0400, Theodore Ts'o wrote:
> On Sat, Jun 22, 2013 at 01:29:44PM +1000, Dave Chinner wrote:
> > > This will work on today's kernels, and it should be safe to do for all
> > > file systems.
> > 
> > No, it's not. SYNC_FILE_RANGE_WRITE does not wait for IO completion,
> > and not all filesystems sychronise journal flushes with data write
> > IO completion.
> 
> Sorry, what I should have said is:
> 
> sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER);
> 
> This *does* wait for I/O completion; the result is the equivalent
> filemap_fdatawrite() followed by filemap_fdatawait().

Right, and now it is effectively identical to fsync() in terms of
speed. And when performance is the reason for avoiding fsync()....

> > Indeed, we have a current "data corruption after power failure"
> > problem found on Ceph storage clusters using XFS for the OSD storage
> > that is specifically triggered by the use of SYNC_FILE_RANGE_WRITE
> > rather than using fsync() to get data to disk.
> > 
> > http://oss.sgi.com/pipermail/xfs/2013-June/027390.html
> 
> This woudn't be a problem in the sequence I suggested.
> 
> 1)  write foo.new
> 2)  sync_file_range(...)
> 3)  rename foo.new to foo

You miss the point - it's not a data integrity operation, and to
present it as a way of obtaining data integrity across *all
filesystems* because it would work on ex4 is extremely dangerous.
You're relying on side effects of a specific filesystem implementation
to give you the desired result.

> If the system crashes right after foo.new, yes, there's no
> guarantee since the metadata blocks are written.

Sure, but focussing on ext4 behaviour misses the larger issue -
sync_file_range() has no well defined integrity rules and hence
exposes applications to unexpected behaviours on different
filesystems.

> (Although if XFS
> is exposing stale data as a result of sync_file_range, that's
> arguably a security bug, since sync_file_range doesn't require
> root to execute, and it _has_ been part of the Linux interface for
> a long time.)

Yes, it is.

But doesn't this point out one of the problems with
moving from a well known interface to something that almost nobody
uses and (obviously) has never tested in a data integrity test bench
previously? it's taken how many years for this problem to be
exposed? We test fsync crash integrity all the time, but do we test
sync_file_range()? No, we don't, because it doesn't have any data
integrity guarantees that we can validate.

So while the interface may have been around for years, the first
serious storage product I've heard of that has tried to use it to
optimise away fsync() calls to use it has found that:

	a) it exposes strange behaviours on different filesystems;
	b) doesn't provide data integrity guarantees worth a damn;
	and
	c) isn't any faster than using fsync/fdatasync() in the
	   first place.

And so has reverted back to using fsync()....

> So for ext3 and ext4, this sequence will guarantee that the file

Exactly my point. You're designing for ext3/4 data=ordered behaviour
and so it's not a replacement for fsync/fdatasync...

> > But, let me make a very important point here. Nobody should be
> > trying to optimise a general purpose application for a specific
> > filesystem's data integrity behaviour. fsync() and fdatasync()
> > are the gold standards as it is consistently implemented across
> > all Linux filesystems.
> 
> From a philosophical point of view, I agree with you.  As I wrote
> in my earlier messages, assuming the applications aren't abusively
> calling g_file_set_contents() several times per second, I don't
> understand why Ryan is trying so hard to optimize it.  The fact
> that he's trying to optimize it at least to me seems to indicate a
> simple admission that there *are* broken applications out there,
> some of which may be calling it with high frequency, perhaps out
> of the UI thread.  

That's not a problem that should be solved by trading off data
integrity and losing user's configurations. Have a backbone, Ted,
and tell people they are doing something stupid when they are doing
something stupid.

> And having general applications or generic desktop libraries
> trying to depend on specific implementation details of file
> systems is really ugly.  So it's not something I'm all that
> excited about.

Not excited? That's an understatement - it's the sort of thing that
gives me nightmares.

We've *been here before*. We've been telling application developer's
to use fsync/fdatasync() since the O_PONIES saga so we don't end up
back in that world of hurt. Yet here you are advocating that
application developers go back down the rat hole of relying on
implicit side effects of the design of a specific filesystem
configuration to provide them with data integrity guarantees....

> But if XFS is doing something sufficiently clever that
> sync_file_range() isn't going to do the right thing, and if we
> presume that abusive applications will always exist, then maybe
> it's time to consider implementing a new system call which has
> very well defined semantics,

That's fine - go and define the requirements for an
rename_datasync() syscall, write a bunch of xfstests to ensure the
API is usable and provides the required behaviour. Then do a slow
generic implementation that you wire all the filesystems up to so
it's available to everyone (i.e.  no fs probing needed).
Applications can start using it immediately, knowing it will work on
every filesystem. i.e:

generic_rename_datasync()
{
	vfs_fsync(src);
	->rename()
}

At that point you can implement a fast, optimal implementation in
ext3/4 that nobody outside ext3/4 needs to care about how it works.
The BTRFS guys can optimise it appropriately in their own time, as
can us XFS people. But the most important point is that we start
with on implementation that *works everywhere*...

> Personally, I think application programmers *shouldn't* need such
> a facility, if their applications are competently designed and
> implemented.  But unfortunately, they outnumber us file system
> developers, and apparently many of them seem to want to do things
> their way, whether we like it or not.

And you're too afraid to call out someone when they are doing something
stupid. If you don't call them out, they'll keep doing stupid things
and the problems will never get solved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
