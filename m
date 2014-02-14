From: Jon Bernard <jbernard@tuxion.com>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Fri, 14 Feb 2014 15:19:05 -0500
Message-ID: <20140214201905.GA26292@helmut>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
 <20140206210844.GA4335@helmut>
 <87sirnp2m3.fsf@openvz.org>
 <20140213145323.GA6296@helmut>
 <20140213211831.GA11480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38892 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbaBNU2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Feb 2014 15:28:18 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id D026B20F0C
	for <linux-ext4@vger.kernel.org>; Fri, 14 Feb 2014 15:19:16 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20140213211831.GA11480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu> wrote:
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

Ahh, I see.  Here's where this comes from: the particular usecase is
provisioning of new cloud instances whose root volume is of unknown
size.  The filesystem and its contents are created and bundled
before-hand into the smallest filesystem possible.  The instance is PXE
booted for provisioning and the root filesystem is then copied onto the
disk - and then resized to take advantage of the total amount of space.

In order to support very large partitions, the filesystem is created
with an abnormally large inode table so that large resizes would be
possible.  I traced it to this commit as best I can tell:

    https://github.com/openstack/diskimage-builder/commit/fb246a02eb2ed330d3cc37f5795b3ed026aabe07

I assumed that additional inodes would be allocated along with block
groups during an online resize, but that commit contradicts my current
understanding. 

I suggested that the filesystem be created during the time of
provisioning to allow a more optimal on-disk layout, and I believe this
is being considered now.

> Don't get me wrong; we should be able to handle this case correctly,
> and not trigger a BUG_ON, but this is why most people aren't seeing
> this particular fault --- it requires a far greater number of inodes
> than mke2fs would ever create by default, or that most system
> administrators would try to deliberately specify, when creating the
> file system.

Thank you for taking the time to look into this, it is very much
appreciated.

> I'll look and see what's the best way to fix up fs/ext4/resize.c in
> the kernel.

If it turns out to be not terribly complicated and there is not an
immediate time constraint, I would love to try to help with this or at
least test patches.

Cheers,

-- 
Jon
