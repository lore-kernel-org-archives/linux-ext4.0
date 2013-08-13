From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Tue, 13 Aug 2013 13:10:57 +1000
Message-ID: <20130813031057.GV12779@dastard>
References: <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
 <20130730030807.GI21982@dastard>
 <20130804012740.GC19781@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2606 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756447Ab3HMDLC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Aug 2013 23:11:02 -0400
Content-Disposition: inline
In-Reply-To: <20130804012740.GC19781@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 03, 2013 at 09:27:40PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 30, 2013 at 01:08:07PM +1000, Dave Chinner wrote:
> > But Ted's case is not a "hint" - it's a direct command to fetch the
> > extent map from disk. You can do that already with FIEMAP, so no new
> > code or interfaces are needed. fadvise() is not the proper interface
> > for manipulating filesystem metadata behaviour, and fiemap can
> > already do what you need. There is no need for any new interfaces
> > here.
> 
> I've been looking at the definition of fiemap, and I'm not convinced.
> To quote from the fiemap.txt:
> 
>    The fiemap ioctl is an efficient method for userspace to get file
>    extent mappings.
> 
> That's not what is going on here.  We are pre-caching them into kernel
> memory, not in user-space.  In addition, we're also setting a flag to
> keep these extents preferentially in memory compared to other entries
> in the extent cache.
> 
> I agree that posix_fadvise() isn't really a good match, either:
> 
>    "posix_fadvise - predeclare an access pattern for file data"
> 
> How about this?  FIEMAP is an ioctl, anyway.  How about if we just
> declare this as a new fs-independent ioctl, much like FS_IOC_FIEMAP?
> 
> #define FS_IOC_PRECACHE_EXTENTS    _IO('f', 18)
> 
> This is, of course, assuming that other file systems are interested in
> implementing this functionality.  If not, we can just keep it as
> EXT4_IOC_PRECACHE_EXTENTS, and just call it a day.  (We can always add
> a definition of FS_IOC_PRECACHE_EXTENTS set to ext4 ioctl's code
> point, at some later point, if people change their minds.)

We *don't need to add any code* to the kernel to read extents into
the kernel cache. The FIEMAP interface as it exists today -without
modification- fulfils your stated requirement. 

I do no see any reason for adding a new, duplicated interface that
we have to maintain and hook up to all the relevant filesystems,
write test code for and then support forever more. It just makes no
sense at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
