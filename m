From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Mon, 28 Jul 2014 22:46:51 -0400
Message-ID: <20140729024651.GA14680@thunk.org>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
 <20140725081312.GO6397@azat>
 <53D24307.6050903@fnarfbargle.com>
 <20140725140715.GR1865@thunk.org>
 <53D320F6.40809@fnarfbargle.com>
 <20140726124557.GB6725@thunk.org>
 <53D3B12C.5040703@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33557 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaG2Cq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 22:46:56 -0400
Content-Disposition: inline
In-Reply-To: <53D3B12C.5040703@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 09:46:20PM +0800, Brad Campbell wrote:
> Fast forward 12 months and
> I've added 2 drives to the array and bumped up against this issue. So it was
> initially 4883458240 blocks. It would have been created with e2fsprogs from
> Debian Stable (so 1.42.5).

Confirmed; debian stable's mke2fs version 1.42.5 does the wrong thing
if you do:

   mke2fs -t ext4 -O 64bit,resize_inode /mnt/foo.img  19T

It creates a file system which is has a resize_inode which --- well,
is in a format that the kernel isn't capable of handling and which is
not something that was originally intended.  The interesting thing is
that resize2fs 1.42.11 is apparently able to handle resizing the above
file system created with mke2fs 1.42.5.

Mke2fs 1.42.12 will avoid creating a resize_inode for file systems >
16T, so this situation doesn't arise.

I need to take a closer look to see if there's some way I can teach
the kernel to be able to deal with this file system, but for now, you
can work around it by using tune2fs to remove the resize_inode, and
after running e2fsck and remounting the file system, the on-line
resize will work correctly.

Cheers,

					- Ted
