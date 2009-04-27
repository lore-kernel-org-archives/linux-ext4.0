From: Jamie Lokier <jamie@shareable.org>
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Date: Mon, 27 Apr 2009 15:47:42 +0100
Message-ID: <20090427144742.GC4885@shareable.org>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de> <20090425151656.GH13608@mit.edu> <20090427095339.GW4593@kernel.dk> <20090427113356.GC9059@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090427113356.GC9059@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> *) Do we only care about processes whose I/O priority is below the
>    default?  (i.e., either in the idle class, or in a low-priority
>    best efforts class) What if the concern is a real-time process
>    which is being blocked by a default I/O priority process taking its
>    time while holding some fs-wide resource?
> 
>    If the answer to the previous question is no, it becomes more
>    reasonable to consider bump the submission priority of the process
>    in question to the highest priority "best efforts" level.  After
>    all, if this truly is a "filesystem-wide" resource, then no one is
>    going to make forward progress relating to this block device unless
>    and until the filesystem-wide lock is resolved.  Also, if we don't
>    allow this situation to return to userspace, presumably the
>    kernel-code involved will only be writing to the block-device in
>    question.  (This might not be entirely true if in the case of the
>    sendfile(2) syscall, but currently we can only read from
>    filesystems with sendfile, and so presumably a filesystem would
>    never call get_fs_excl why servicing a sendfile request.)
> 
> *) Is implementing the bulk of this in the cfq scheduler really the
>    best place to do this?  To explore something completely different,
>    what if the filesystem simply explicitly set I/O priority levels in
>    its block I/O submissions, and provided optional callback functions
>    which could be used by the page writeback routines to determine the
>    appropriate I/O priority level that should be used given a
>    particular filesystem and inode number.  (That actually could be
>    used to provide another cool function --- we could expose to
>    userspace the concept that particular inode should always have its
>    I/O go out with a higher priority, perhaps via chattr flag.)
> 
>    Basically, the argument here is that we already have the
>    appropriate mechanism for ordering I/O requests, which is I/O
>    priority mechanism, and the policy really needs to be set by the
>    filesystem --- and it might be far more than just "do we have a
>    filesystem-wide exclusive lock" or not.

Personally, I'm interested in the following:

    - A process with RT I/O priority and RT CPU priority is reading
      a series of files from disk.  It should be very reliable at this.

    - Other normal I/O priority and normal CPU priority processes are
      reading and writing the disk.

I would like the first process to have a guaranteed minimum I/O
performance: it should continuously make progress, even when it needs
to read some file metadata which overlaps a page affected by the other
processes.  I don't mind all the interference from disk head seeks and
so on, but I would like the I/O that the first process depends on to
have RT I/O priority - including when it's waiting on I/O initiated by
another process and the normal I/O priority queue is full.

So, I'm not exactly sure, but I think what I need for that is:

    - I/O priority boosting (re-queuing in the elevator) to fix the
      inversion when waiting on I/O which was previously queued with
      normal I/O priority, and

    - Task priority boosting when waiting on a filesystem resource
      which is held by a normal priority task.

(I'm not sure if generic task priority boosting is already addressed to some
extent in the RT-PREEMPT Linux tree.)

-- Jamie
