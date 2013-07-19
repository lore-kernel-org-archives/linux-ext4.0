From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 19 Jul 2013 12:19:30 -0400
Message-ID: <20130719161930.GF17938@thunk.org>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39305 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab3GSQTi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jul 2013 12:19:38 -0400
Content-Disposition: inline
In-Reply-To: <20130719033309.GQ11674@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 01:33:09PM +1000, Dave Chinner wrote:
> An ioctl is kinda silly for this. Just use O_NONBLOCK when calling
> open() and do the prefetch right in the open call. The open() can
> block, anyway, and what you are trying to do is non-blocking IO with
> AIO, so it seems like we've already got a sensible, generic
> interface for triggering this sort of prefetch operation.

O_NONBLOCK (either set via open or fcntl) is a possibility, since it's
carefully defined to be unspecified for regular files by SUSv3.  It is
quite different from the existing semantics for O_NONBLOCK, though.
Currently, for all file types where O_NONBLOCK is not ignored, open(2)
is guaranteed itself not to block.  If we use O_NONBLOCK for regular
files to mean that any necessary metadata blocks required for AIO to
be "A" will be cached, then it will make open(2) much more likely to
block.  Also, for all file types where O_NONBLOCK is not ignored,
read(2) will not block but instead return -1 and set errno to EAGAIN.
This would also be a change.

If we tried to get this new semantics for O_NONBLOCK to be accepted by
the Austin Group for standardization in the future, would they accept
it, or would they say, "this makes me vommit"?  I have a suspicion
there reaction might be closer to the latter....

If we want a VFS-level API, in my opinion an fadvise() flag would be a
better choice.

					- Ted
