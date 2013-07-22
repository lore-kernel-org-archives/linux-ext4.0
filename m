From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Mon, 22 Jul 2013 20:57:45 +0800
Message-ID: <20130722125745.GA2827@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56698 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3GVM5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jul 2013 08:57:51 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so7012005pbc.31
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jul 2013 05:57:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130722100255.GF11674@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 22, 2013 at 08:02:55PM +1000, Dave Chinner wrote:
> On Mon, Jul 22, 2013 at 10:17:42AM +0800, Zheng Liu wrote:
> > On Mon, Jul 22, 2013 at 11:38:31AM +1000, Dave Chinner wrote:
> > > On Fri, Jul 19, 2013 at 12:19:30PM -0400, Theodore Ts'o wrote:
> > > > On Fri, Jul 19, 2013 at 01:33:09PM +1000, Dave Chinner wrote:
> > > > > An ioctl is kinda silly for this. Just use O_NONBLOCK when calling
> > > > > open() and do the prefetch right in the open call. The open() can
> > > > > block, anyway, and what you are trying to do is non-blocking IO with
> > > > > AIO, so it seems like we've already got a sensible, generic
> > > > > interface for triggering this sort of prefetch operation.
> > > > 
> > > > O_NONBLOCK (either set via open or fcntl) is a possibility, since it's
> > > > carefully defined to be unspecified for regular files by SUSv3.  It is
> > > > quite different from the existing semantics for O_NONBLOCK, though.
> > > > Currently, for all file types where O_NONBLOCK is not ignored, open(2)
> > > > is guaranteed itself not to block.  If we use O_NONBLOCK for regular
> > > > files to mean that any necessary metadata blocks required for AIO to
> > > > be "A" will be cached, then it will make open(2) much more likely to
> > > > block.  Also, for all file types where O_NONBLOCK is not ignored,
> > > > read(2) will not block but instead return -1 and set errno to EAGAIN.
> > > > This would also be a change.
> > > > 
> > > > If we tried to get this new semantics for O_NONBLOCK to be accepted by
> > > > the Austin Group for standardization in the future, would they accept
> > > > it, or would they say, "this makes me vommit"?  I have a suspicion
> > > > there reaction might be closer to the latter....
> > > > 
> > > > If we want a VFS-level API, in my opinion an fadvise() flag would be a
> > > > better choice.
> > > 
> > > Sure. Make it an fadvise() flag - just don't add ioctls for things
> > > that are generically useful.
> > > 
> > > On second thoughts - you're trying to get the extent map read in. We
> > > already have an interface for querying extent maps - fiemap.
> > > FIEMAP_FLAG_PREFETCH along with the range of the file you want the
> > > extent map prefetched for?
> > 
> > I don't think fiemap is a good interface.  The application uses
> > fiemap(2) to retrieve extent mapping. 
> 
> fiemap is used to query information about extent maps. What it
> returns is entirely dependent on the input parameters that are
> passed to it. Indeed, from Documentation/filesystems/fiemap.txt:
> 
> "If fm_extent_count is zero, then the fm_extents[] array is ignored
> (no extents will be returned), and the fm_mapped_extents count will
> hold the number of extents needed in fm_extents[] to hold the file's
> current mapping."
> 
> Think about that for a minute. What does the filesystem do with such
> an fiemap query when the extent map is not cached?  That's right,
> *fiemap reads the extent map from disk into the cache* and then
> returns the number of extents in the range.
> 
> All I have suggested is adding a flag to make this an *explicit
> operation* rather than a side effect of a "count extents" query. I
> fail to see any justification for a whole new interface when we
> already have a perfectly functional one that already provides the
> functionality that is required...

Yes, I understand your point of view.  We can use fiemap to do that.
All I concern is about semantics.  When someone mention about fiemap,
first I remember is that I can use it to retrieve the extent mappings.
But for fadvise, it looks like more naturally.  When I look at it, I
always think that I can use it to provide a hint to the kernel, and then
the kernel will do the rest of things for me.   So that is why I prefer
to use a fadvise flag rather than use fiemap.

Regards,
                                                - Zheng
