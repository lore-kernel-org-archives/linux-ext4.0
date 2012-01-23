From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 23 Jan 2012 16:47:09 -0500
Message-ID: <20120123214709.GB17974@thunk.org>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
 <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43155 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2AWXmi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 18:42:38 -0500
Content-Disposition: inline
In-Reply-To: <20120123030422.GE15102@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 02:04:22PM +1100, Dave Chinner wrote:
> 
> Sure, but the buffer contents are dirty until the IO completes
> successfully and what is on disk matches the contents of the buffer
> in memory. It doesn't magically become clean when we clear the dirty
> bit. We only clear the dirty bit before submitting the IO to stop
> multiple callers from trying to submit it for write at the same
> time. IOWs, the buffer dirty bit doesn't really track the dirty
> state of the buffer correctly.

Doesn't BH_Lock prevent multple callers from submitting it for write
at the same time?  If memory serves, one of the reasons why we cleared
the dirty bit before submitting the write was because we allowed
writers to dirty the buffer_head while the write was "in flight".  Of
course, this is becomes problematic if we're trying to support DIF/DIX.

What if we simply disallow BH_Dirty from being set (and disallow the
modification of the buffer) while the buffer is locked?  Then the
dirty bit would indeed correctly track the state of the buffer
correctly.

> I can only assume that you didn't read what I said about how
> different filesystems can (and do) handle write errors differently.
> Indeed, even within a filesystem there can be different error
> handling methods for different types of write IO errors (e.g.
> transient vs unrecoverable).  Hence there are any number of valid
> error handling strategies that can be added to the above list. One
> size does not fit all...

That's another problem, which is that we need more context than just
!uptodate.  We need to know what sort of write I/O errors occurred, so
we can determine whether it's likely to be transient or permanent.

> The thing is, transient write errors tend to be isolated and go away
> when a retry occurs (think of IO timeouts when multipath failover
> occurs). When non-isolated IO or unrecoverable problems occur (e.g.
> no paths left to fail over onto), critical other metadata reads and
> writes will fail and shut down the filesystem, thereby terminating
> the "try forever" background writeback loop those delayed write
> buffers may be in. So the truth is that "trying forever" on write
> errors can handle a whole class of write IO errors very
> effectively....

So how does XFS decide whether a write should fail and shutdown the
file system, or just "try forever"?

						- Ted
