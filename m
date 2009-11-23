From: tytso@mit.edu
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 13:35:01 -0500
Message-ID: <20091123183501.GB2183@thunk.org>
References: <20091122222047.GB21944@fieldses.org>
 <20091123114831.GA2532@thunk.org>
 <20091123164445.GB3292@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59862 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZKWSe7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 13:34:59 -0500
Content-Disposition: inline
In-Reply-To: <20091123164445.GB3292@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 11:44:45AM -0500, J. Bruce Fields wrote:
> 
> Got it, thanks.  Is there an existing easy-to-setup workload I could
> start with, or would it be sufficient to try the simplest possible code
> that met the above description?  (E.g., fork a process for each cpu,
> each just overwriting byte 0 as fast as possible, and count total writes
> performed per second?)

We were actually talking about this on the ext4 call today.  The
problem is that there isn't a ready-made benchmark that will easily
measure this.  A database benchmark will show up (and we may have some
results from the DB2 folks indicating the cost of upgrading the
timestamps with a nanosecond granuality), but these of course aren't
easy to run.

The simplest possible workload that you have proposed is the worst
case, and I have no doubt that will show the contention on
inode->i_lock from inode_inc_version(), and I bet we'll see a big
improvement when we change inode->i_version to be an atomic64 type.
It will probably also show the overhead of ext4_mark_inode_dirty()
being called all the time.

Perhaps a slightly fairer and more realistic benchmark would do a
write to byte zero followed by an fsync(), and measures both the CPU
time per write as well as the writes per second.  Either will do the
job, though, and I'd recommend grabbing oprofile and lockstat
measurement to see what bottlenecks we are hitting with that the
workload.

> If the side we want to optimize is the modifications, I wonder if we
> could do all the i_version increments on *read* of i_version?:
> 
> 	- writes (and other inode modifications) set an "i_version_dirty"
> 	  flag.
> 	- reads of i_version clear the i_version_dirty flag, increment
> 	  i_version, and return the result.
> 
> As long as the reader sees i_version_flag set only after it sees the
> write that caused it, I think it all works?

I can see two potential problems with that.  One is that this implies
that the read needs to kick off a journal operation, which means that
the act of reading i_version might cause the caller to sleep (not all
the time, but in some cases, such as if we get unlucky and need to do
a journal commit or checkpoint before we can update i_version).  I
don't know if the NFSv4 server code would be happy with that!  

The second problem is what happens if we crash before a read happens.

On the ext4 call, Andreas suggested trying to do this work at commit
time.  This would either mean that i_version would only get updated at
the commit interval (default: 5 seconds), or that i_version might be
updated more frequently than that, but we would defer as much as
possible to the commit time, since it's already the case that if we
crash before the commit happens, i_version could end up going
backwards (since we may have returned i_version numbers that were
never committed).

I'm not entirely convinced how much this will actually help, since we
have to reserve space in the transaction for the inode update, even if
we don't do the copy to the journaled bufferheads on every
sys_write(), since we will end up having to take various journal locks
on every sys_write() anyway.  We'll have to code it up to see whether
or not it helps, or how painful it is to actually implement.

What I'm hoping we'll find is that for a typical desktop workload
i_version updates don't really hurt, and we can enable it by default
for desktop workloads.  My concern is that really with the database
workloads, i_version updates may be especially hurtful especially for
certain high dollar value (but rare) benchmarks, such as TPC-C/TPC-H.

	     	    	       	     		      - Ted
