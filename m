From: Theodore Tso <tytso@mit.edu>
Subject: Re: with -b N and block count, should mkfs.ext4 fail with
	dev-too-big?
Date: Wed, 11 Feb 2009 09:09:05 -0500
Message-ID: <20090211140905.GG29220@mini-me.lan>
References: <87ab8ti1cw.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext <linux-ext4@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33754 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBKPQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 10:16:14 -0500
Content-Disposition: inline
In-Reply-To: <87ab8ti1cw.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 11, 2009 at 01:50:39PM +0100, Jim Meyering wrote:
> 
> FWIW, I was trying to create an ext4 file system with more than 2^32
> blocks to demonstrate a parted bug fix, but with the particular device
> I was using, I couldn't even create one with 2^31-1 blocks.
> 
> When I try to create an ext4 file system specifying both block size and
> the number of blocks, the size of the underlying device should not matter,
> as long as it is large enough.

Oops, my fault.  I fixed the case where the device was exactly 16TB
(as in created via lvcreate --size 16TB, but the fix was very minimal,
since it was just before a maintenance release.  I didn't consider (or
test) the case where the device was larger than or equal to 2*32
blocks (given a specified blocksize, or 4k if no blocksize was
specified), and an explicit block size less than 2*32 was specified.

I'll put it on my todo list to fix for e2fsprogs 1.41.5.

							- Ted
