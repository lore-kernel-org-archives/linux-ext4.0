From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Thu, 13 Mar 2014 17:04:44 +1100
Message-ID: <20140313060444.GH6851@dastard>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140313003635.GA4263@dastard>
 <20140313011629.GA2796@thunk.org>
 <20140313031440.GA13367@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140313031440.GA13367@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 12, 2014 at 11:14:40PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 12, 2014 at 09:16:29PM -0400, Theodore Ts'o wrote:
> > > IMO, I think that you should be looking to fix ext4 syncfs issues,
> > > not changing the VFS behaviour that might cause subtle and unnoticed
> > > problems for other filesystems. We should not be moving data
> > > inegrity operations without first auditing of all the filesystem
> > > remount operations for issues.
> > 
> > The issue is that it's forcing a CACHE FLUSH if we don't need to force
> > a journal commit, since it's possible that data writes could have been
> > sent to the disk without modifying fs metadata that would require a
> > commit.  So arguably what we're doing with ext4 is _correct_, where as
> > with ext3 we would simply not calling blkdev_issue_barrier() in that
> > situation.
> 
> Doing some more digging, ext4 is currently interpreting syncfs() as
> requiring a data integrity sync.  So we go through some extra work to
> guarantee that we call blkdev_issue_barrier(), even if a journal
> commit is not required.
> 
> This change was made by Dmitry last June:
> 
> commit 06a407f13daf9e48f0ef7189c7e54082b53940c7
> Author: Dmitry Monakhov <dmonakhov@openvz.org>
> Date:   Wed Jun 12 22:25:07 2013 -0400
> 
>     ext4: fix data integrity for ext4_sync_fs
>     
>     Inode's data or non journaled quota may be written w/o jounral so we
>     _must_ send a barrier at the end of ext4_sync_fs. But it can be
>     skipped if journal commit will do it for us.
>     
>     Also fix data integrity for nojournal mode.
>     
>     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Both ext3 and xfs do *not* do this.

XFS most definitely considered sync_filesystem(sb) to be a data
integrity operation. xfs_fs_sync_fs() calls this:

	xfs_log_force(mp, XFS_LOG_SYNC);

Which will issue a blocking journal commit which will uses
REQ_FLUSH|REQ_FUA for the journal writes. Hence if there was
anything dirty in the filesystem that sync_filesystem wrote to disk,
it will issue a cache flush just like ext4 does.

> Looking more closely at the syncfs(2) manpage, it's not clear it
> requires this:
> 
>        sync() causes all buffered modifications to file metadata and
>        data to be written to the underlying filesystems.
> 
>        syncfs() is like sync(), but synchronizes just the filesystem
>        containing file referred to by the open file descriptor fd.
> 
> Unlike the fsync(2) system call, it does *not* state that the data
> flushed to the disk is guaranteed to be there after a crash, which I
> suppose justifies ext3 and xfs's current behavior.

sync() data integrity is provided by sync_inodes_sb() followed by
->sync_fs().

syncfs() data integrity is provided by sync_inodes_sb() followed by
->sync_fs().

They are functionally identical and so provide the same guarantees.
That is the intent of the syncfs syscall, and there are lots of
people out there using it for data integrity purposes.

> 1)  Nowhere in the remount system call is it stated that it has
>     ***any*** data integrity implifications.   If you are making the rw->ro
>     transition, sure, you'll need to flush out any pending changes.  But there
>     doesn't seem to be any justification for requiring this this if the
>     remount is a no-op.   So I think changing the remount code path as I
>     suggested is a valid option.

What the man page says doesn't change the fact we need to audit all
the existing filesystems before such a change is made.

> 2) We could revert Dmitry's change from last June.  This would make
>    ext4 work the same way as ext3 and xfs.  Which I think is also
>    valid, since the syncfs(2) system call says nothing about
>    guaranteeing data being preserved after a crash, unlike fsync(2).

It wouldmake ext4 the same as ext3. XFS definitely guarantees
data integrity through syncfs()....

> 3) We could say that a workload that calls thousands of no-op remounts
>    to be stupid/busted/silly, and not do anything at all.

Sure, but the reporter indicated that if he replaced the remount
with sync then the problem still existed. IOWs, you haven't fixed
root cause of the problem, merely papered over a symptom.

> #1 requires core VFS changes, and Dave seems unhappy with it.

I'm unhappy with your approach to the change (i.e. no validation of
the assertions made about other filesystems), not about the actual
change.

So:

4) fix ext4 not to issue unnecessary cache flushes, or find and fix
whatever is actually causing sync to be slow (maybe some of these
issues: https://lwn.net/Articles/561569/).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
