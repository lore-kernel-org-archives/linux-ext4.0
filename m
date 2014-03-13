From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Wed, 12 Mar 2014 23:14:40 -0400
Message-ID: <20140313031440.GA13367@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140313003635.GA4263@dastard>
 <20140313011629.GA2796@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40680 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaCMDOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 23:14:53 -0400
Content-Disposition: inline
In-Reply-To: <20140313011629.GA2796@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 09:16:29PM -0400, Theodore Ts'o wrote:
> > IMO, I think that you should be looking to fix ext4 syncfs issues,
> > not changing the VFS behaviour that might cause subtle and unnoticed
> > problems for other filesystems. We should not be moving data
> > inegrity operations without first auditing of all the filesystem
> > remount operations for issues.
> 
> The issue is that it's forcing a CACHE FLUSH if we don't need to force
> a journal commit, since it's possible that data writes could have been
> sent to the disk without modifying fs metadata that would require a
> commit.  So arguably what we're doing with ext4 is _correct_, where as
> with ext3 we would simply not calling blkdev_issue_barrier() in that
> situation.

Doing some more digging, ext4 is currently interpreting syncfs() as
requiring a data integrity sync.  So we go through some extra work to
guarantee that we call blkdev_issue_barrier(), even if a journal
commit is not required.

This change was made by Dmitry last June:

commit 06a407f13daf9e48f0ef7189c7e54082b53940c7
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Jun 12 22:25:07 2013 -0400

    ext4: fix data integrity for ext4_sync_fs
    
    Inode's data or non journaled quota may be written w/o jounral so we
    _must_ send a barrier at the end of ext4_sync_fs. But it can be
    skipped if journal commit will do it for us.
    
    Also fix data integrity for nojournal mode.
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Both ext3 and xfs do *not* do this.

Looking more closely at the syncfs(2) manpage, it's not clear it
requires this:

       sync() causes all buffered modifications to file metadata and
       data to be written to the underlying filesystems.

       syncfs() is like sync(), but synchronizes just the filesystem
       containing file referred to by the open file descriptor fd.

Unlike the fsync(2) system call, it does *not* state that the data
flushed to the disk is guaranteed to be there after a crash, which I
suppose justifies ext3 and xfs's current behavior.

So the way I see it, we have three choices.

1)  Nowhere in the remount system call is it stated that it has
    ***any*** data integrity implifications.   If you are making the rw->ro
    transition, sure, you'll need to flush out any pending changes.  But there
    doesn't seem to be any justification for requiring this this if the
    remount is a no-op.   So I think changing the remount code path as I
    suggested is a valid option.

2) We could revert Dmitry's change from last June.  This would make
   ext4 work the same way as ext3 and xfs.  Which I think is also
   valid, since the syncfs(2) system call says nothing about
   guaranteeing data being preserved after a crash, unlike fsync(2).

3) We could say that a workload that calls thousands of no-op remounts
   to be stupid/busted/silly, and not do anything at all.


#1 requires core VFS changes, and Dave seems unhappy with it.

#2 requires rolling back an ext4 change, and I wonder if Dmitry had a
situation where he really needed syncfs(2) to have data integrity
guarantees.

#3 is the default if we can't come to consensus over what else to do.

Cheers,

						- Ted
