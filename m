From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Tue, 24 Jan 2012 17:12:11 +1100
Message-ID: <20120124061211.GK15102@dastard>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz>
 <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
 <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard>
 <20120123214709.GB17974@thunk.org>
 <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38107 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2AXGMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 01:12:16 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 03:49:39PM -0800, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 1:47 PM, Ted Ts'o <tytso@mit.edu> wrote:
> >
> > So how does XFS decide whether a write should fail and shutdown the
> > file system, or just "try forever"?
> 
> Why would it bother? XFS tends to be a filesystem that you'd only use
> for core files in environments where you have a system manager that
> knows what he is doing.

Oh, man, what a troll.

Even my *TV* uses XFS. First google reference:

http://settorezero.blogspot.com/2010/10/xfs-filesystem-and-samsung-ledtvs.html

You won't find a more hostile "pull-the-drive-without-unmounting"
environment than a TV. XFS handles this sort of stuff just fine and
it has for a long time.

> So there, maybe "try forever" is the right
> thing to do.

You still haven't grasped that there are many different
classes of IO errors and that some require different handling to
others. :/

> Things are a bit different with some random unreliable USB stick FAT32
> filesystem that just died on you, with a normal user that just removes
> the thing or doesn't even notice that the stick is now dead. There the
> "try forever" is totally the wrong thing to do.

I'm not saying that "try forever" is how all errors should be
handled. You are completely focussed on that as the only possible
error handling technique that can be used. Stop being stupid!

I'm saying that the dirty, uptodate, errored buffer should
be handled back to the filesystem so that it can decide what to do
with it.  For filesystems that can differentiate the types of
errors, let them choose how to handle the problem. Those that are
unable to handle the error can do the invalidation themselves. One
size does not fit all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
