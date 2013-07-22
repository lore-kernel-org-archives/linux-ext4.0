From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Mon, 22 Jul 2013 11:38:31 +1000
Message-ID: <20130722013831.GE11674@dastard>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11484 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab3GVBif (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jul 2013 21:38:35 -0400
Content-Disposition: inline
In-Reply-To: <20130719161930.GF17938@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 12:19:30PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 19, 2013 at 01:33:09PM +1000, Dave Chinner wrote:
> > An ioctl is kinda silly for this. Just use O_NONBLOCK when calling
> > open() and do the prefetch right in the open call. The open() can
> > block, anyway, and what you are trying to do is non-blocking IO with
> > AIO, so it seems like we've already got a sensible, generic
> > interface for triggering this sort of prefetch operation.
> 
> O_NONBLOCK (either set via open or fcntl) is a possibility, since it's
> carefully defined to be unspecified for regular files by SUSv3.  It is
> quite different from the existing semantics for O_NONBLOCK, though.
> Currently, for all file types where O_NONBLOCK is not ignored, open(2)
> is guaranteed itself not to block.  If we use O_NONBLOCK for regular
> files to mean that any necessary metadata blocks required for AIO to
> be "A" will be cached, then it will make open(2) much more likely to
> block.  Also, for all file types where O_NONBLOCK is not ignored,
> read(2) will not block but instead return -1 and set errno to EAGAIN.
> This would also be a change.
> 
> If we tried to get this new semantics for O_NONBLOCK to be accepted by
> the Austin Group for standardization in the future, would they accept
> it, or would they say, "this makes me vommit"?  I have a suspicion
> there reaction might be closer to the latter....
> 
> If we want a VFS-level API, in my opinion an fadvise() flag would be a
> better choice.

Sure. Make it an fadvise() flag - just don't add ioctls for things
that are generically useful.

On second thoughts - you're trying to get the extent map read in. We
already have an interface for querying extent maps - fiemap.
FIEMAP_FLAG_PREFETCH along with the range of the file you want the
extent map prefetched for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
