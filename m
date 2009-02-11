From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: with -b N and block count, should mkfs.ext4 fail with dev-too-big?
Date: Wed, 11 Feb 2009 14:26:17 -0500
Message-ID: <20090211192617.GA9501@shell>
References: <87ab8ti1cw.fsf@meyering.net> <20090211140905.GG29220@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Meyering <jim@meyering.net>, ext <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbZBKT0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 14:26:22 -0500
Content-Disposition: inline
In-Reply-To: <20090211140905.GG29220@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 11, 2009 at 09:09:05AM -0500, Theodore Tso wrote:
> On Wed, Feb 11, 2009 at 01:50:39PM +0100, Jim Meyering wrote:
> > 
> > FWIW, I was trying to create an ext4 file system with more than 2^32
> > blocks to demonstrate a parted bug fix, but with the particular device
> > I was using, I couldn't even create one with 2^31-1 blocks.
> > 
> > When I try to create an ext4 file system specifying both block size and
> > the number of blocks, the size of the underlying device should not matter,
> > as long as it is large enough.
> 
> Oops, my fault.  I fixed the case where the device was exactly 16TB
> (as in created via lvcreate --size 16TB, but the fix was very minimal,
> since it was just before a maintenance release.  I didn't consider (or
> test) the case where the device was larger than or equal to 2*32
> blocks (given a specified blocksize, or 4k if no blocksize was
> specified), and an explicit block size less than 2*32 was specified.
> 
> I'll put it on my todo list to fix for e2fsprogs 1.41.5.

Note that this is fixed in effect by the 64bit patches, since we use
the 64bit get device size function.

git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

Branch "shared-64bit".

-VAL
