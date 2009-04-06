From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 02:05:42 -0400
Message-ID: <20090406060542.GA7376@mit.edu>
References: <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754193AbZDFGZI@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 05, 2009 at 10:01:06AM -0700, Linus Torvalds wrote:
> Of course, different IO schedulers react differently to that whole "sync 
> vs unplug" thing. I think CFQ is the only one that actually cares about 
> the "sync" bit (using different queues for sync vs async). 

It looks liks AS and CFQ both care about the "sync" bit; they both use
rq_is_sync defined in include/lonux/blkdev.h.  Deadline apparently
only distinguishes between read and write requests, and not whether
they are considered synchronous or not.  The noop scheduler, obviously
also doesn't care.  :-)

> The other schedulers only care about the plugging. So the patch
> below really doesn't make much sense as-is, because as things are
> right now, the scheduler behaviors are so different for the
> unplug-vs-sync thing that no sane user can ever know whether they
> should use WRITE_SYNC (== higher priority queueing for CFQ, no-op
> for others) or WRITE_UNPLUG (unplug on all, and additionally higher
> priority for CFQ).

Well, if the deadline scheduler ignores the SYNC bit, it would still
make sense for it to only unplug the queue after for the commit block,
and not for any of the other writes to the journal.  Unplugging after
every synchronous write is going to lead to a performance problem,
which I've demonstrated using the fopen/fprintf/fsync/fclose scenario
that Jens pointed me at.  

						- Ted
