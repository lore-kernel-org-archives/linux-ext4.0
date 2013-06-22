From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 13:29:44 +1000
Message-ID: <20130622032944.GX29376@dastard>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ryan Lortie <desrt@desrt.ca>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24625 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423470Ab3FVD3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 23:29:51 -0400
Content-Disposition: inline
In-Reply-To: <20130621203547.GA10582@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 04:35:47PM -0400, Theodore Ts'o wrote:
> So I've been taking a closer look at the the rename code, and there's
> something I can do which will improve the chances of avoiding data
> loss on a crash after an application tries to replace file contents
> via:
> 
> 1)  write foo.new
> 2)  <omit fsync of foo.new>
> 3)  rename foo.new to foo
> 
> Those are the kernel patches that I cc'ed you on.
> 
> The reason why it's still not a guarantee is because we are not doing
> a file integrity writeback; this is not as important for small files,
> but if foo.new is several megabytes, not all of the data blocks will
> be flushed out before the rename, and this will kill performance, and
> in somoe cases it might not be necessary.
> 
> Still, for small files ("most config files are smaller than 100k"),
> this should serve you just fine.  Of course, it's not going to be in
> currently deployed kernels, so I don't know how much these proposed
> patches will help you,.  I'm doing mainly because it helps protects
> users against (in my mind) unwise application programmers, and it
> doesn't cost us any extra performance from what we are currently
> doing, so why not improve things a little?
> 
> 
> If you want better guarantees than that, this is the best you can do:
> 
> 1)  write foo.new using file descriptor fd
> 2)  sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE);
> 3)  rename foo.new to foo
> 
> This will work on today's kernels, and it should be safe to do for all
> file systems.

No, it's not. SYNC_FILE_RANGE_WRITE does not wait for IO completion,
and not all filesystems sychronise journal flushes with data write
IO completion.

Indeed, we have a current "data corruption after power failure"
problem found on Ceph storage clusters using XFS for the OSD storage
that is specifically triggered by the use of SYNC_FILE_RANGE_WRITE
rather than using fsync() to get data to disk.

http://oss.sgi.com/pipermail/xfs/2013-June/027390.html

The question was raised as to whether sync_file_range() was safe on
ext4 was asked and my response was:

http://oss.sgi.com/pipermail/xfs/2013-June/027452.html

"> Is sync_file_range(2) similarly problematic with ext4?

In data=writeback mode, most definitely. For data=ordered, I have no
idea - the writeack paths in ext4 are ... convoluted, and I hurt my
brain every time I look at them. I wouldn't be surprised if there
are problems, but they'll be different problems because ext4 doesn't
do speculative prealloc..."

.....

> > aside: what's your opinion on fdatasync()?  Seems like it wouldn't be
> > good enough for my usecase because I'm changing the size of the file....
> 
> fdatasync() is basically sync_file_range() plus a CACHE FLUSH command.
> Like sync_file_range, it doesn't sync the metadata (and by the way,
> this includes things like indirect blocks for ext2/3 or extent tree
> blocks for ext4).

If fdatasync() on ext4 doesn't sync metadata blocks required to
access the data that was just written by the fdatasync() call, then
it is broken.

fdatasync() is supposed to guarantee all the data in the file and
all the metadata *needed to access that data* is on stable storage
by the time the fdatasync() completes. i.e. fdatasync() might just
be a data write and cache flush, but in the case where allocation,
file size changes, etc have occurred, it is effectively the
equivalent of a full fsync().

So, fdatasync() will do what you want, but the performance overhead
will be no different to fsync() in the rename case because all the
metadata pointing to the tmp file needs to comitted as well...

----

But, let me make a very important point here. Nobody should be
trying to optimise a general purpose application for a specific
filesystem's data integrity behaviour. fsync() and fdatasync() are
the gold standards as it is consistently implemented across all
Linux filesystems.

The reason I say this is that we've been down this road before and
we shoul dhave learnt better from it. Ted, you should recognise this
because you were front and centre in the fallout of it:

http://tytso.livejournal.com/61989.html

".... Application writers had gotten lazy, because ext3 by default
has a commit interval of 5 seconds, and and uses a journalling mode
called data=ordered. What does this mean? ....

... Since ext3 became the dominant filesystem for Linux, application
writers and users have started depending on this, and so they become
shocked and angry when their system locks up and they lose data -
even though POSIX never really made any such guarantee. ..."

This discussion of "how can we abuse ext4 data=ordered sematics to
avoid using fsync()" is heading right going down this path again.
It is starting from "fsync on ext4 is too slow", and solutions are
being proposed that assume that either everyone is use ext4
(patently untrue) and that all filesystems behave like ext4 (also
patently untrue).

To all the application developers reading this: just use
fsync()/fdatasync() for operations that require data integrity. Your
responisbility is to your users: using methods that don't guarantee
data integrity and therefore will result in data loss is indicating
you don't place any value on your user's data what-so-ever. There is
no place for being fancy when it comes to data integrity - it needs
to be reliable and rock-solid.

If that means your application is slow, then you need to explain why
it is slow to your users and how they can change a knob to make it
fast by trading off data integrity. The user can make the choice at
that point, and they have no grounds to complain if they lose data
at that point because they made a conscious choice to configure
their system that way.

IOWs, the choice of whether data can be lost on a crash is one that
only the user can make. As such, applications need be
safe-by-default when it comes to data integrity.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
