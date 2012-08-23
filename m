From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Dump file inode information from ext2/3 partition
Date: Thu, 23 Aug 2012 15:39:04 -0400
Message-ID: <20120823193904.GA6234@thunk.org>
References: <CAD6i1fJF5wcX2dj2P8mUR4J5Qz3x58CiSfzubYoy0b1ZcRYcRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46423 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934223Ab2HWTjQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Aug 2012 15:39:16 -0400
Content-Disposition: inline
In-Reply-To: <CAD6i1fJF5wcX2dj2P8mUR4J5Qz3x58CiSfzubYoy0b1ZcRYcRw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 23, 2012 at 07:43:29PM +0530, Prashant Shah wrote:
> 
> We wrote a small tool to dump file inode information from ext2/3
> partition as an assignment related to learning about file systems.
> 
> https://github.com/prashants/tools/tree/master/ext
> https://github.com/prashants/tools/blob/master/ext/ext3dump.c
> 
> I am not sure if there is any future use for it other than for
> learning purposes.

I hope it was enjoyable learning how to access an ext2/3 filesystem
directly!

Some comments about your code:

*) It requires that the file system be mounted (so you can get the
   inode number), and then it accesses the file directly through the
   block device.  This is a no-no, since the block might not have been
   flushed out to disk yet if it was a newly created file.

*) You don't check that the inode number that you got by using
   open()/stat() is from the same file system that you are accessing
   via the block device.

*) You don't check to see if the filesystem feature flags are as you
   expect; this utility will blow up pretty spectacularly on an ext4
   file system.

If you want to see how a better version of this functionality can be
built, please see the "debugfs" program which is part of e2fsprogs.
It uses the libext2fs libraries, and is a much more robust program for
direct access to a file system via the block device for debugging
purposes.

If you want to see a more user-friendly interface, please take a look
at the e2tools package.  It also uses the libext2fs library which is
distributed as part of e2fsprogs (and installed on pretty much all
Linux distributions), and is a more polished way of accessing a file
directly meant to be used by end users --- as opposed to debugfs,
which is really meant for file system engineers.

So debugfs is more powerful, but you can also do severe harm to the
file system if you open the filesystem read/write and you start
messing with it.  At the same time, debugfs is also a more interesting
if you are a student who wants to get a much better understanding of
the underlying file system format.

Regards,

						- Ted
