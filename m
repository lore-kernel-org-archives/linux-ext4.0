From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 settings in an embedded system
Date: Wed, 14 Nov 2012 15:51:18 -0500
Message-ID: <20121114205118.GB23511@thunk.org>
References: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32888 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2KNUvV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2012 15:51:21 -0500
Content-Disposition: inline
In-Reply-To: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 14, 2012 at 11:41:59AM +0100, Ohlsson, Fredrik (GE Healthcare, consultant) wrote:
> I am working with an embedded system equipped with an IDE Flash Disk
> and the ext4 filesystem. I have identified 3 problems that I would
> like to solve in our product. The power is abruptly turned off from
> time to time, this has sometimes resulted in broken Superblock
> (inode8) and empty files with size 0 bytes. It also happens that
> file changes is not committed to disk even if minutes pass before a
> power loss. This is very undesirable and expensive in our case, we
> are searching for a solution or a workaround to the problems.

I'm not sure what you mean by "broken Superblock (inode 8)".  Inode #8
is the journal superblock.  I'm guessing you're seeing some kind of
corrupted journal superblock?  It would be useful if you could send
kernel logs or e2fsck output so we can see exactly what is going on.

> List with my problems I like to solve:
> 1. Broken Superblock (inode8).
> 2. Empty files, size 0.
> 3. Very long auto commit times, several minutes with default settings.

The default auto commit time is 5 seconds.  *However*, with delayed
allocation, writeback takes place after a 30 second timer, and
depending on how many dirty pages are outstanding, it might take a
while for all of the writeback to be completed.  If you want to
simulate the behaviour you are used to with ext3, where at a journal
commit we force all writeback to complete before the commit is allowed
to proceed, you could use the nodelalloc mount option, but you will
see a corresponding hit in performance as a result.  The better thing
to do is to make sure programs that care about data hitting stable
store use fsync(2) as appropriate, but unfortunately there are many
applications out there which don't do this, and I do understand that
fixing them all might be problematic.  (On the other hand, for an
embedded system, it should be easier since you do control all of your
userspace applicaitons.)

The other thing which may be going on is that there is crappy flash
devices out there which do not handle unexpected power failures
correctly.  Hence, even if you have pushed data out to disk using a
CACHE FLUSH request (which is what barrier=1 does, and which is the
default BTW), there are flash devices which essentially lie and which
do not guarantee that data written before the CACHE FLUSH is stable by
the time the CACHE FLUSH command returns.

If you are seeing a corrupted journal superblock (which is what I
assume you meant by Broken Superblock inode 8), that's an indication
that the hardware is lying to us, and unfortuantely, there's not much
any file system can do in that case.  If the hardware is lying, you're
pretty much out of luck, and the only solution is to replace the
hardware with something which is competently engineered....

I would suggest trying to tackle these two problems separately.  If
you want to make sure fsync is handled correctly, so that files are
flushed out when you need them to be, try doing a reset of the device
--- without dropping power, and see if you can get rid of the zero
length files.   That should be relatively easy to handle.

Then you can try to see what happens with a power drop.
Unfortunately, if it's what I suspect is going on, you have faulty
hardware, and there really is not anything we can do at the OS layer.
If I am correct that your IDE Flash Disk is some cheap piece of cr*p,
you can try using any file system you want, but you're probably going
to end up losing big time.

Regards,

					- Ted
