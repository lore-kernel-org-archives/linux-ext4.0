From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Ocfs2-devel] [PATCH, RFC 0/3] *** SUBJECT HERE ***
Date: Tue, 3 Aug 2010 16:07:55 -0400
Message-ID: <20100803200755.GD9453@thunk.org>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
 <20100803190703.GA15416@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>,
	John Stultz <johnstul@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44025 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0HCUH5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 16:07:57 -0400
Content-Disposition: inline
In-Reply-To: <20100803190703.GA15416@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 12:07:03PM -0700, Joel Becker wrote:
> 
> 	The atomic changes make absolute sense.  Ack on them.  I had two
> reactions to the rwlock: first, a lot of your rwlock changes are on
> the write_lock() side.  You get journal start/stop parallelized, but
> what about all the underlying access/dirty/commit paths?  Second,
> rwlocks are known to behave worse than spinlocks when they ping the
> cache line across CPUs.
> 	That said, I have a hunch that you've tested both of the above
> concerns.  You mention 48 core systems, and clearly if cachelines were
> going to be a problem, you would have noticed.  So if the rwlock changes
> are faster on 48 core than the spinlocks, I say ack ack ack.

We don't have the results from the 48-core machine yet.  I was going
to try to get measurements from the 48-core machine I have access to
at $WORK, but it doesn't have enough hard drive spindles on it.  :-(

But yes, I am worried about the cache-line bounce issue, and I'm
hoping that we'll get some input from people who can run some
measurements on an 8-core and 48-core machine.

I haven't worried about the commit paths yet because they haven't
shown up as being significant on any of the lockstat reports.
Remember that with jbd2, the commit code only runs on in kjournald,
and in general only once every 5 seconds or for every fsync.  In
contrast, essentially every single file system syscall that modifies
the filesystem is going to end up calling start_this_handle().  So if
you have multiple threads all creating files, or writing to files, or
even just changing the mtime or permissions, it's going to call
start_this_handle(), so we're seeing nearly all of the contention on
start_this_handle() and to a lesser extent, jbd2_journal_stop(), the
function which retires a handle.

Things would probably be different on a workload that tries to
simulate a mail transfer agent or a database which is _not_ using
O_DIRECT on a preallocated table space file, since there will be many
more fsync() calls and thus much more pressure on the commit code.
But I didn't want to do any premature optimization until we see how
bad it actually gets in those cases.

If you are set up to do some performance measurements on OCFS2, I'd
appreciate if you could give it a try and let me know how the patches
fare on OCFS2.

Thanks,

						- Ted
