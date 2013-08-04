From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Sat, 3 Aug 2013 21:27:40 -0400
Message-ID: <20130804012740.GC19781@thunk.org>
References: <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
 <20130730030807.GI21982@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39082 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3HDB7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Aug 2013 21:59:10 -0400
Content-Disposition: inline
In-Reply-To: <20130730030807.GI21982@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 30, 2013 at 01:08:07PM +1000, Dave Chinner wrote:
> But Ted's case is not a "hint" - it's a direct command to fetch the
> extent map from disk. You can do that already with FIEMAP, so no new
> code or interfaces are needed. fadvise() is not the proper interface
> for manipulating filesystem metadata behaviour, and fiemap can
> already do what you need. There is no need for any new interfaces
> here.

I've been looking at the definition of fiemap, and I'm not convinced.
To quote from the fiemap.txt:

   The fiemap ioctl is an efficient method for userspace to get file
   extent mappings.

That's not what is going on here.  We are pre-caching them into kernel
memory, not in user-space.  In addition, we're also setting a flag to
keep these extents preferentially in memory compared to other entries
in the extent cache.

I agree that posix_fadvise() isn't really a good match, either:

   "posix_fadvise - predeclare an access pattern for file data"

How about this?  FIEMAP is an ioctl, anyway.  How about if we just
declare this as a new fs-independent ioctl, much like FS_IOC_FIEMAP?

#define FS_IOC_PRECACHE_EXTENTS    _IO('f', 18)

This is, of course, assuming that other file systems are interested in
implementing this functionality.  If not, we can just keep it as
EXT4_IOC_PRECACHE_EXTENTS, and just call it a day.  (We can always add
a definition of FS_IOC_PRECACHE_EXTENTS set to ext4 ioctl's code
point, at some later point, if people change their minds.)

			       	    	      - Ted
