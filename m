From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Tue, 24 Jan 2012 11:36:57 +1100
Message-ID: <20120124003657.GJ15102@dastard>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
 <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard>
 <20120123214709.GB17974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:42045 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab2AXAhB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 19:37:01 -0500
Content-Disposition: inline
In-Reply-To: <20120123214709.GB17974@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 04:47:09PM -0500, Ted Ts'o wrote:
> > The thing is, transient write errors tend to be isolated and go away
> > when a retry occurs (think of IO timeouts when multipath failover
> > occurs). When non-isolated IO or unrecoverable problems occur (e.g.
> > no paths left to fail over onto), critical other metadata reads and
> > writes will fail and shut down the filesystem, thereby terminating
> > the "try forever" background writeback loop those delayed write
> > buffers may be in. So the truth is that "trying forever" on write
> > errors can handle a whole class of write IO errors very
> > effectively....
> 
> So how does XFS decide whether a write should fail and shutdown the
> file system, or just "try forever"?

The IO dispatcher decides that. If the dispatcher has handed the IO
off to the delayed write queue, then failed writes will be tried
again. If the caller is catching the IO completion (e.g. sync
writes) or attaching a completion callback (journal IO), then the
completion context will handle the error appropriately. Journal IO
errors tend to shutdown the filesystem on the first error, other
contexts may handle the error, retry or shutdown the filesystem
depending on their current state when the error occurs.

Reads are even more complex, because ithe dispatch context can be
within a transaction and the correct error handling is then
dependent on the current state of the transaction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
