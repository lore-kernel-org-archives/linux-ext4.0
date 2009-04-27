From: Theodore Tso <tytso@mit.edu>
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Date: Mon, 27 Apr 2009 12:29:20 -0400
Message-ID: <20090427162920.GA6781@mit.edu>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de> <20090425151656.GH13608@mit.edu> <20090427095339.GW4593@kernel.dk> <20090427113356.GC9059@mit.edu> <20090427144742.GC4885@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090427144742.GC4885@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 27, 2009 at 03:47:42PM +0100, Jamie Lokier wrote:
> Personally, I'm interested in the following:
> 
>     - A process with RT I/O priority and RT CPU priority is reading
>       a series of files from disk.  It should be very reliable at this.
> 
>     - Other normal I/O priority and normal CPU priority processes are
>       reading and writing the disk.
> 
> I would like the first process to have a guaranteed minimum I/O
> performance: it should continuously make progress, even when it needs
> to read some file metadata which overlaps a page affected by the other
> processes.

That's pretty easy.  The much harder and much more interesting problem
is if the process with RT I/O and CPU priority is *writing* a series
of files to disk, and not just reading from disk.

> I don't mind all the interference from disk head seeks and
> so on, but I would like the I/O that the first process depends on to
> have RT I/O priority - including when it's waiting on I/O initiated by
> another process and the normal I/O priority queue is full.
> 
> So, I'm not exactly sure, but I think what I need for that is:
> 
>     - I/O priority boosting (re-queuing in the elevator) to fix the
>       inversion when waiting on I/O which was previously queued with
>       normal I/O priority, and
> 
>     - Task priority boosting when waiting on a filesystem resource
>       which is held by a normal priority task.

For the latter, I can't think of a filesystem where we would block a
read operation for long time just because someone was holding some
kind of filesytem-wide lock.  A spinlock, maybe, but the only time it
makes sense to worry about boosting an I/O priority is if we're going
to be blocing a filesystem for milliseconds or more, and not just a
few tens of microseconds.  

All of the latency problems people have been complaining about, such
as the infamous firefox fsync() problem, all involved write
operations, and specifically fsync(), and maybe a heavy read-workload
interfered with a write, but I can't think of a situation where a
real-time read operation would be disrupted by normal priority reads
and writes.

For the former, where a real-time read request gets blocked because
the read request for that block had already been submitted --- at a
lower priority --- that's something that should be solvable purely in
core block layer and in the I/O scheduler layer, I would expect.

						- Ted
