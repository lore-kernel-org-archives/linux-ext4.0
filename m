From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to resize to an bigger then 16TB ext4 filesysteem on Debian
Date: Thu, 10 Apr 2014 20:22:45 -0400
Message-ID: <20140411002245.GE31614@thunk.org>
References: <53468055.4070700@powercraft.nl>
 <20140410140937.GE15925@thunk.org>
 <5346B3B6.7020806@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jelle de Jong <jelledejong@powercraft.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52693 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303AbaDKAWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 20:22:50 -0400
Content-Disposition: inline
In-Reply-To: <5346B3B6.7020806@powercraft.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 05:07:34PM +0200, Jelle de Jong wrote:
> 
> In october 2012 I created the ext4 file system with the command:
> mkfs.ext4 -m 1 /dev/lvm0-vol/storage
> 
> I assumed by using ext4 with lvm2 I would have had a solid basis for
> some future storage expeditions. Apparently I made a mistake somewhere
> but I don't know where yet or did I hit a bug?
> 
> # tune2fs -l /dev/lvm0-vol/storage
> # dumpe2fs -h /dev/lvm0-vol/storage
> http://paste.debian.net/plain/92953
> 
> Where can I see that my ext4 file system is limed to 16TB?

So here's the problem.  The original ext2/3 block group descriptors
only had room for 32-bit block numbers.  So in order to resize the
file system past 16TB, it was necessary to change the layout of the
block group descriptors, and change them from needing 32 bytes to 64
bytes per block group.

So in order to make this change there was a new "64-bit" feature flag
that changes the size of the block group descriptors.  We didn't
enable this feature at first, because we wanted to make sure the
64-bit support was well shaken down and "production ready" before it
was enabled.

(In particular there were some online resizing bugs relating to 64-bit
file systems that wasn't ironed out until relatively recently, so you
should be glad we didn't enable this feature by default.  :-)

> Your suggestion to use a development version of e2fsprogs doesn't
> really suit my needs for a stable solution that is maintainable.

Well, unfortunately, there is no way to do what you request using the
stable version of e2fsprogs.  Sorry.

> 1. I can temporary transfer all the data to an other system and
> recreate the ext4 file system, but will this be stable with version
> 1.42.5 and how much TB can the file-system handle?

You should definitely go to the 1.42.9 version of e2fsprogs to make
sure you have the latest fixes.

As far as the kernel is concerned, are you still using the Debian
stable 3.2 kernel?  The problem is that not all of the bug fixes get
backported to a stable kernel which is that old.  One of the value
adds that a company like Red Hat provides is that they have someone
paid to try to support ext4 on older kernels.  But there have been
some online resize fixes on the kernel side since 3.2, and I don't
think all of them have been backported because they are fairly complex
and involved patches.

If you're not willing to use the kernel from Debian testing, it may
very well be that you will be better off waiting for Debian testing to
ship before you even try to use ext4 file systems > that 16TB.  I
really can't guarantee that all of the necessary fixes have been
backported to the 3.2 stable kernel.

Is there some way you could live with two large file systems instead
of trying to create one very large file system?

Regards,

						- Ted
