From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 19 Jul 2013 07:54:51 +0800
Message-ID: <20130718235451.GA29997@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34044 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934751Ab3GRXgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jul 2013 19:36:02 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so3720823pbc.16
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jul 2013 16:36:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51E8356C.9030603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On Thu, Jul 18, 2013 at 01:35:24PM -0500, Eric Sandeen wrote:
> On 7/16/13 10:17 AM, Theodore Ts'o wrote:
> > In addition to fixing a few bugs and addressing review comments, we now
> > add a new ioctl, EXT4_IOC_PRECACHE_EXTENTS, which forces all of the
> > extents in an inode to be cached in the extents status tree, and marks
> > them to be preferentially protected when under memory pressure.  
> > 
> > This is critically important when using AIO to a preallocated file,
> > since if we need to read in blocks from the extent tree, the
> > io_submit(2) system call becomes synchronous, which is rather rude to
> > applications which were expecting the AIO to be "A".
> > 
> > As a bonus, using the extent status tree to store the logical to
> > physical block mapping is usually more compact that having to keep one
> > or more extent tree blocks in the buffer cache.
> > 
> > (Should we do this all the time, instead of when the application
> > explicitly requests it?  Maybe; there could be cases with very large,
> > fragmented files accessed by an application such as "file" is only needs
> > to look at a small subset of the file where this could result in an
> > unnecessary work and memory allocated.  OTOH, 95%+ of the time this
> > would probably be a win...)
> 
> I'd say yes, we should - maybe not in all cases but if you need it for
> AIO, try to make it "all the time" at least for that AIO?
> 
> We keep telling application writers not to assume certain things about
> various filesystems, or to write applications that treat ext4 differently 
> han ext3 differently than xfs etc...

Yes, I agree with you.  As Ted and I have discussed the problem of
setting 'data=writeback' by default in ext4.  Although most application
writers have realized that they need to explicit call fsync to flush all
dirty pages, there are still some legacy applications that depends on
the 'data=ordered' mode to flush all dirty pages.

> 
> This goes the other way.
> 
> In the end who (besides google?) is really going to call this IOCTL?
> 
> I wondered if only doing this when files are opened O_DIRECT might make
> sense, but Jeff Moyer pointed out that giant databases probably don't
> want to read in their entire block mapping tree - OTOH, they probably use
> preallocation if they're smart, and maybe it's not that bad.

I have talked with my colleague who is a MySQL contributor about whether
MySQL tries to preallocate some files or not.  As far as I know, at
least MySQL doesn't try to do it until now.  I don't have the source
code of Oracle or DB2, these giant databases might use preallocation I
guess.

> 
> Or what about tying this into POSIX_FADV_WILLNEED?  Hohum, that gets
> into force_page_cache_readahead().  We need POSIX_FADV_WILLNEED_META...

Yes, _WILLNEED_METADATA flag makes sense to me if other file systems
also want to support it.  But, as Ted said, now adding it in ioctl might
a good choice because we won't impact other file systems.

                                                - Zheng
