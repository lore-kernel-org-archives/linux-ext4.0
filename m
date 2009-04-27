From: Theodore Tso <tytso@mit.edu>
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Date: Mon, 27 Apr 2009 07:33:56 -0400
Message-ID: <20090427113356.GC9059@mit.edu>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de> <20090425151656.GH13608@mit.edu> <20090427095339.GW4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755548AbZD0LeZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090427095339.GW4593@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 27, 2009 at 11:53:39AM +0200, Jens Axboe wrote:
> > I'm kind of curious why you implemented things in this way, though.
> > Is there a reason why the bosting is happening deep in the guts of the
> > cfq code, instead of in blk-core.c when the submission of the block
> > I/O request is processed?
> 
> You would need to implement a lot more logic in the block layer to
> handle it there, as it stands it's basically a scheduler decision. So
> the positioning is right imho, the placement of fs hooks is probably
> mostly crap and could do with some work.

The question is whether you see this in terms of a scheduler decision
or in terms of an I/O priority issue.  At the moment I agree it's a
scheduler decision (which to be honest is implemented in somewhat of a
hacky way --- which I suspect won't bother you since, you yourself
called it "half-assed" :-) which happens to be implemented in the I/O
scheduler.

I tend to think of it more as an I/O priority issue, and specifically,
as you put it, an priority inversion issue, but much of that is no
doubt influenced by how I did the patches to reduce the fsync()
latencies in ext3 and ext4.  And indeed the
get_fs_excl()/put_fs_excl() paradigm doesn't really work well for
ext3/ext4 since all of the work which grabs a filesystem-wide
"exclusive lock" is done in a separate process, kjournald.  Hence with
the exception of freeze and unfreeze --- and while this might be
considered irresponsible for a system administrator to freeze a
filesystem in a ionice'd process, I could imagine a badly written
backup script which created a snapshot while being ionice'd --- ext3/4
can't really very profitably use get_fs_excl()/put_fs_excl().

Maybe ext3/ext4 are a special case, but perhaps we should nevertheless
ask some fundamental design questions about the get/put_fs_excl()
interface.

*) Most filesystems will go to great lengths to avoid having any kind
   of fs-wide "exclusive lock", simply because of the disastrous
   performance impacts.  This is *why* in ext3/ext4, we try to do most
   of the commit work in the context of another process, and normally
   usually we let other filesystem operations run in the "current
   transaction" while we let the "committing transaction" complete.
   If you have too many programs running fsync() this tends to screw
   things up, but that's a separate question.  So in practice, there
   really shouldn't be that many "fs-wide" locks.  

   On the other hand, there can be more subtle forms of I/O priority
   inversion; suppose a low priority process has grabbed a mutex which
   protects a directory, and a high (I/O) priority process needs
   access to the same directory.  Do we care about trying to solve
   that issue?

*) Do we only want to support instances where the fs-wide resource is
   held in kernel-space only, or do we want to support things like the
   FREEZE ioctl, where the filesystem has been frozen --- the very
   definition of an I/O wide resource?  (I would argue no, for
   simplicity's sake but document the fact that the well-written
   program using the FREEZE ioctl should strongly consider bumping up
   its I/O and possibly CPU priority levels to minimize the impact on
   the rest of the system.  Since the FREEZE ioctl requires root
   privileges, it's fair to assume a certain amount of competence by
   the users of this interface.)  If the answer to this question is
   no, then we can add warning/debugging code which warns if the
   filesystem ever tries returning to userspace with an elevated
   get_fs_excl() count.

*) Do we only care about processes whose I/O priority is below the
   default?  (i.e., either in the idle class, or in a low-priority
   best efforts class) What if the concern is a real-time process
   which is being blocked by a default I/O priority process taking its
   time while holding some fs-wide resource?

   If the answer to the previous question is no, it becomes more
   reasonable to consider bump the submission priority of the process
   in question to the highest priority "best efforts" level.  After
   all, if this truly is a "filesystem-wide" resource, then no one is
   going to make forward progress relating to this block device unless
   and until the filesystem-wide lock is resolved.  Also, if we don't
   allow this situation to return to userspace, presumably the
   kernel-code involved will only be writing to the block-device in
   question.  (This might not be entirely true if in the case of the
   sendfile(2) syscall, but currently we can only read from
   filesystems with sendfile, and so presumably a filesystem would
   never call get_fs_excl why servicing a sendfile request.)

*) Is implementing the bulk of this in the cfq scheduler really the
   best place to do this?  To explore something completely different,
   what if the filesystem simply explicitly set I/O priority levels in
   its block I/O submissions, and provided optional callback functions
   which could be used by the page writeback routines to determine the
   appropriate I/O priority level that should be used given a
   particular filesystem and inode number.  (That actually could be
   used to provide another cool function --- we could expose to
   userspace the concept that particular inode should always have its
   I/O go out with a higher priority, perhaps via chattr flag.)

   Basically, the argument here is that we already have the
   appropriate mechanism for ordering I/O requests, which is I/O
   priority mechanism, and the policy really needs to be set by the
   filesystem --- and it might be far more than just "do we have a
   filesystem-wide exclusive lock" or not.

What do other filesystem developers think?

						- Ted
