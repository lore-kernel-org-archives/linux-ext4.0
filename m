From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 23 Jan 2012 14:04:22 +1100
Message-ID: <20120123030422.GE15102@dastard>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
 <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26833 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab2AWDE1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jan 2012 22:04:27 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ LCA delayed responding to this... ]

On Mon, Jan 16, 2012 at 04:59:41PM -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 4:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Jan is right, Linus. His definition of what up-to-date means for
> > dirty buffers is correct, especially in the case of write errors.
> 
> It's not a dirty buffer any more.

Yes it is. The write has not completed, so by definition the buffer
is not clean.

> Go look. We've long since cleared the dirty bit.

Sure, but the buffer contents are dirty until the IO completes
successfully and what is on disk matches the contents of the buffer
in memory. It doesn't magically become clean when we clear the dirty
bit. We only clear the dirty bit before submitting the IO to stop
multiple callers from trying to submit it for write at the same
time. IOWs, the buffer dirty bit doesn't really track the dirty
state of the buffer correctly.

> So stop spouting garbage.
>
> My argument is simple: the contents ARE NOT CORRECT ENOUGH to be
> called "up-to-date and clean".

I didn't say it was clean - I said a buffer that failed a write is
not invalid but was still up-to-date and the error handling should
treat it that way. I thought it was obvious that this meant we have
to redirty the buffer at the same time we mark it with an IO error
so that it's state was correct....

> And I outlined the two choices:
> 
>  - mark it dirty and continue trying to write it out forever
> 
>  - invalidate it.
> 
> Anything else is crazy talk.

I can only assume that you didn't read what I said about how
different filesystems can (and do) handle write errors differently.
Indeed, even within a filesystem there can be different error
handling methods for different types of write IO errors (e.g.
transient vs unrecoverable).  Hence there are any number of valid
error handling strategies that can be added to the above list. One
size does not fit all...

> And marking it dirty forever isn't really
> an option. So..

I guess you don't realise that Linux already has a filesystem that
uses this technique. It's called XFS.  ;)

FYI, XFS has used the redirtying method to retry failed delayed
write buffer IO since day zero (i.e. 1993). EFS (XFS's predecessor
on Irix) was doing this long before XFS came along so this technique
for handling certain types of transient write IO errors has been
used in production filesystems for somewhere around 25 years.

The thing is, transient write errors tend to be isolated and go away
when a retry occurs (think of IO timeouts when multipath failover
occurs). When non-isolated IO or unrecoverable problems occur (e.g.
no paths left to fail over onto), critical other metadata reads and
writes will fail and shut down the filesystem, thereby terminating
the "try forever" background writeback loop those delayed write
buffers may be in. So the truth is that "trying forever" on write
errors can handle a whole class of write IO errors very
effectively....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
