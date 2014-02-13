From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Thu, 13 Feb 2014 16:27:00 -0500
Message-ID: <20140213212700.GC11480@thunk.org>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
 <20140206210844.GA4335@helmut>
 <87sirnp2m3.fsf@openvz.org>
 <20140213145323.GA6296@helmut>
 <20140213211831.GA11480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jon Bernard <jbernard@tuxion.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57688 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBMV1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Feb 2014 16:27:05 -0500
Content-Disposition: inline
In-Reply-To: <20140213211831.GA11480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

+Jon Bernard (who somehow got dropped from the e-mail thread when I tried to reply)

On Thu, Feb 13, 2014 at 04:18:31PM -0500, Theodore Ts'o wrote:
> On Thu, Feb 13, 2014 at 09:53:23AM -0500, Jon Bernard wrote:
> > The image should be available here:
> > 
> > http://c5a6e06e970802d5126f-8c6b900f6923cc24b844c506080778ec.r72.cf1.rackcdn.com/fedora_resize_fails.qcow2
> 
> Thanks for the image.  I've been able to reproduce the problem, and
> it's caused by the fact that the inode table is so large that it's
> overflowing into a subsequent block group, and the resize code isn't
> handling this.  Fixing this may be a bit tricky, since the flex_bg
> online resize code is a big ugly at the moment, and needs some clean
> up so this can be fixed properly.
> 
> Until that can be done --- one question: was there a deliberate reason
> why the file system was created with parameters which allocate 32,752
> inodes per block group?  That means that a bit over 8 megabytes of
> inode table are being reserved for every 128 megabyte (32768 4k
> blocks) block group, and that you have more inodes reserved than could
> be used if the average file size is 4k or less.  In fact, the only way
> you could run out of inodes is if you had huge numbers of devices,
> sockets, small symlinks, or zero-length files in your file system.
> This seems to be a bit of a waste of space, in all liklihood.
> 
> Don't get me wrong; we should be able to handle this case correctly,
> and not trigger a BUG_ON, but this is why most people aren't seeing
> this particular fault --- it requires a far greater number of inodes
> than mke2fs would ever create by default, or that most system
> administrators would try to deliberately specify, when creating the
> file system.
> 
> I'll look and see what's the best way to fix up fs/ext4/resize.c in
> the kernel.
> 
> Regards,
> 
> 						- Ted
