From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: with -b N and block count, should mkfs.ext4 fail with dev-too-big?
Date: Wed, 11 Feb 2009 16:17:09 -0500
Message-ID: <20090211211709.GB9501@shell>
References: <87ab8ti1cw.fsf@meyering.net> <20090211140905.GG29220@mini-me.lan> <20090211192617.GA9501@shell> <499327D2.8010502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jim Meyering <jim@meyering.net>,
	ext <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZBKVRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 16:17:13 -0500
Content-Disposition: inline
In-Reply-To: <499327D2.8010502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 11, 2009 at 01:32:34PM -0600, Eric Sandeen wrote:
> Valerie Aurora Henson wrote:
> > On Wed, Feb 11, 2009 at 09:09:05AM -0500, Theodore Tso wrote:
> >> On Wed, Feb 11, 2009 at 01:50:39PM +0100, Jim Meyering wrote:
> >>> FWIW, I was trying to create an ext4 file system with more than 2^32
> >>> blocks to demonstrate a parted bug fix, but with the particular device
> >>> I was using, I couldn't even create one with 2^31-1 blocks.
> >>>
> >>> When I try to create an ext4 file system specifying both block size and
> >>> the number of blocks, the size of the underlying device should not matter,
> >>> as long as it is large enough.
> >> Oops, my fault.  I fixed the case where the device was exactly 16TB
> >> (as in created via lvcreate --size 16TB, but the fix was very minimal,
> >> since it was just before a maintenance release.  I didn't consider (or
> >> test) the case where the device was larger than or equal to 2*32
> >> blocks (given a specified blocksize, or 4k if no blocksize was
> >> specified), and an explicit block size less than 2*32 was specified.
> >>
> >> I'll put it on my todo list to fix for e2fsprogs 1.41.5.
> > 
> > Note that this is fixed in effect by the 64bit patches, since we use
> > the 64bit get device size function.
> > 
> > git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> > 
> > Branch "shared-64bit".
> > 
> > -VAL
> 
> That won't fix it for ext3 though will it?  (not that I've looked in
> detail) but the issue is not whether we can properly get the device
> size; it's that the device size, rather than the filesystem size, is
> checked for overflow vs. the filesystem's limits...

Without actually going to the effort of trying to understand that code
again :), what I remember is that it's the order of the checks that
mattered.  When we used the 32-bit device size function, that would
fail before we got around to checking the user-specified number of
blocks to be in range.  Now the 64-bit call works and we can go on to
the range check for the user-specified number of blocks.

At any rate, it works for 2^31-1 4096 byte blocks:

[val@clunky e2fsprogs]$ ls -lh /terabyte/20TB -rw-rw-r-- 1 val val 19T 2009-02-11 13:11 /terabyte/20TB
[val@clunky e2fsprogs]$ ~/src/build/misc/mke2fs -b 4096 -t ext3 /terabyte/20TB `echo '2*1024^3-1'|bc`
mke2fs 1.41.4 (27-Jan-2009)
/terabyte/20TB is not a block special device.
Proceed anyway? (y,n) y
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
536870912 inodes, 2147483647 blocks
[etc]

It doesn't work for 1024 byte blocks - fails on number of inodes no
matter how few inodes I specify.  This might be a bug but I don't have
time to check it out right now.

-VAL
