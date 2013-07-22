From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Mon, 22 Jul 2013 10:17:42 +0800
Message-ID: <20130722021742.GA24195@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36783 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3GVCRw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jul 2013 22:17:52 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so2436043pad.36
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 19:17:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130722013831.GE11674@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 22, 2013 at 11:38:31AM +1000, Dave Chinner wrote:
> On Fri, Jul 19, 2013 at 12:19:30PM -0400, Theodore Ts'o wrote:
> > On Fri, Jul 19, 2013 at 01:33:09PM +1000, Dave Chinner wrote:
> > > An ioctl is kinda silly for this. Just use O_NONBLOCK when calling
> > > open() and do the prefetch right in the open call. The open() can
> > > block, anyway, and what you are trying to do is non-blocking IO with
> > > AIO, so it seems like we've already got a sensible, generic
> > > interface for triggering this sort of prefetch operation.
> > 
> > O_NONBLOCK (either set via open or fcntl) is a possibility, since it's
> > carefully defined to be unspecified for regular files by SUSv3.  It is
> > quite different from the existing semantics for O_NONBLOCK, though.
> > Currently, for all file types where O_NONBLOCK is not ignored, open(2)
> > is guaranteed itself not to block.  If we use O_NONBLOCK for regular
> > files to mean that any necessary metadata blocks required for AIO to
> > be "A" will be cached, then it will make open(2) much more likely to
> > block.  Also, for all file types where O_NONBLOCK is not ignored,
> > read(2) will not block but instead return -1 and set errno to EAGAIN.
> > This would also be a change.
> > 
> > If we tried to get this new semantics for O_NONBLOCK to be accepted by
> > the Austin Group for standardization in the future, would they accept
> > it, or would they say, "this makes me vommit"?  I have a suspicion
> > there reaction might be closer to the latter....
> > 
> > If we want a VFS-level API, in my opinion an fadvise() flag would be a
> > better choice.
> 
> Sure. Make it an fadvise() flag - just don't add ioctls for things
> that are generically useful.
> 
> On second thoughts - you're trying to get the extent map read in. We
> already have an interface for querying extent maps - fiemap.
> FIEMAP_FLAG_PREFETCH along with the range of the file you want the
> extent map prefetched for?

I don't think fiemap is a good interface.  The application uses
fiemap(2) to retrieve extent mapping.  That means that the app could use
these mappings in userspace.  But now we want to cache these mappings in
kernel space.  So it seems that an fadvise(2) flag is better.

Regards,
                                                - Zheng
