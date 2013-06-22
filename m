From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 00:47:18 -0400
Message-ID: <20130622044718.GC4727@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org>
 <20130622032944.GX29376@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ryan Lortie <desrt@desrt.ca>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60203 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3FVErX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jun 2013 00:47:23 -0400
Content-Disposition: inline
In-Reply-To: <20130622032944.GX29376@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 22, 2013 at 01:29:44PM +1000, Dave Chinner wrote:
> > This will work on today's kernels, and it should be safe to do for all
> > file systems.
> 
> No, it's not. SYNC_FILE_RANGE_WRITE does not wait for IO completion,
> and not all filesystems sychronise journal flushes with data write
> IO completion.

Sorry, what I should have said is:

sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER);

This *does* wait for I/O completion; the result is the equivalent
filemap_fdatawrite() followed by filemap_fdatawait().

> Indeed, we have a current "data corruption after power failure"
> problem found on Ceph storage clusters using XFS for the OSD storage
> that is specifically triggered by the use of SYNC_FILE_RANGE_WRITE
> rather than using fsync() to get data to disk.
> 
> http://oss.sgi.com/pipermail/xfs/2013-June/027390.html

This woudn't be a problem in the sequence I suggested.

1)  write foo.new
2)  sync_file_range(...)
3)  rename foo.new to foo

If the system crashes right after foo.new, yes, there's no guarantee
since the metadata blocks are written.  (Although if XFS is exposing
stale data as a result of sync_file_range, that's arguably a security
bug, since sync_file_range doesn't require root to execute, and it
_has_ been part of the Linux interface for a long time.)

Unlike in the Ceph case, in this sequence as are calling
sync_file_range on the new file (foo.new).  And if we haven't done the
rename yet, we don't care about the contents of foo.new.  (Although if
the file system is causing stale data to be revealed, I'd claim that's
a fs bug.)  If the rename has completed, the metadata blocks will
definitely be journalled and committed for both ext3 and ext4.

So for ext3 and ext4, this sequence will guarantee that the file named
"foo" will have either the old data or the new data --- and this is
true for either data=ordered, or data=writeback.  You're the expert
for xfs, but I didn't think this sequence was depending on anything
file system specific, since filemap_fdatawrite() and
filemap_fdatawait() are part of the core Linux FS/MM layer.

> But, let me make a very important point here. Nobody should be
> trying to optimise a general purpose application for a specific
> filesystem's data integrity behaviour. fsync() and fdatasync() are
> the gold standards as it is consistently implemented across all
> Linux filesystems.

>From a philosophical point of view, I agree with you.  As I wrote in
my earlier messages, assuming the applications aren't abusively
calling g_file_set_contents() several times per second, I don't
understand why Ryan is trying so hard to optimize it.  The fact that
he's trying to optimize it at least to me seems to indicate a simple
admission that there *are* broken applications out there, some of
which may be calling it with high frequency, perhaps out of the UI
thread.  

And having general applications or generic desktop libraries trying to
depend on specific implementation details of file systems is really
ugly.  So it's not something I'm all that excited about.

However, regardless of whether wish it or not, abusive applications
written by incompetent application authors *will* exist, and whether
we like it or not, desktop library authors are going to try to coddle
said abusive applications by do these filesystem implemenatation
dependent optimization.  GNOME is *already* detecting btrfs and has
made optimization decisions based on it in its libraries.  Trying to
prevent this is (in my opinion) the equivalent of claiming that the
command of King Canute could hold back the tide.

Given that, my thinking was to try to suggest the least harmful way of
doing so, and so my eye fell on sync_file_range(2) as a generic system
call that is not file system specific, with some relatively well
defined semantics.  And given that we don't care about foo.new until
after the rename operation has completed, it seemed to me that this
should be safe for more than just ext3 and ext4 (where I am quite sure
it is safe).

But if XFS is doing something sufficiently clever that
sync_file_range() isn't going to do the right thing, and if we presume
that abusive applications will always exist, then maybe it's time to
consider implementing a new system call which has very well defined
semantics, for those applications that insist on updating a file
hundreds of times an hour, demand good performance, and aren't picky
about consistency semantics, so long that some version of the file
contents is available after a crash.

This system call would of course have to be optional, and so for file
systems that don't support it, applications will have to fall back
more traditional approachses, whether that involves fsync() or perhaps
sync_file_range(), if that can be made safe and generic for all/most
file systems.

Personally, I think application programmers *shouldn't* need such a
facility, if their applications are competently designed and
implemented.  But unfortunately, they outnumber us file system
developers, and apparently many of them seem to want to do things
their way, whether we like it or not.

Regards,

						- Ted
