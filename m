From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 09:56:52 -0400
Message-ID: <20140726135652.GC6725@thunk.org>
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
Received: from imap.thunk.org ([74.207.234.97]:58070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaGZN5A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:57:00 -0400
Content-Disposition: inline
In-Reply-To: <53D3B12C.5040703@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 09:46:20PM +0800, Brad Campbell wrote:
> This was the first resize of this FS. Initially this array was about 15T.
> About 12 months ago I attempted to resize it up to 19T and bumped up against
> the fact I had not created the initial filesystem with 64 bit support, so I
> cobbled together some storage and did a backup/create/restore. At that point
> I would probably have specified resize_inode manually as an option (as
> reading the man page it looked like a good idea as I always had plans to
> expand in future) to mke2fs along with 64bit. Fast forward 12 months and
> I've added 2 drives to the array and bumped up against this issue. So it was
> initially 4883458240 blocks. It would have been created with e2fsprogs from
> Debian Stable (so 1.42.5).

So mke2fs 1.42.11 does the right thing (although it really should just
tell you that there's no point using the resize_inode).

% mke2fs -Fq -t ext4 -O resize_inode,64bit /mnt/foo.img 19T
/mnt/foo.img contains a ext4 file system
	     created on Sat Jul 26 09:54:30 2014

% dumpe2fs -h /mnt/foo.img  | grep "Reserved GDT"
dumpe2fs 1.42.11 (09-Jul-2014)

% debugfs -R "stat <7>" /mnt/foo.img
debugfs 1.42.11 (09-Jul-2014)
Inode: 7   Type: bad type    Mode:  0000   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x00000000 -- Wed Dec 31 19:00:00 1969
atime: 0x00000000 -- Wed Dec 31 19:00:00 1969
mtime: 0x00000000 -- Wed Dec 31 19:00:00 1969
Size of extra inode fields: 0
BLOCKS:

> I can't test this to verify my memory however as I don't seem to be able to
> create a sparse file large enough to create a filesystem in. I appear to be
> bumping up against a 2T filesize limit.

Yep, when I do this testing I create a loopback mounted (sparse) xfs
file system, so I can create the sparse files needed to do this sort
of testing.

My guess is that 1.42.5 is not doing the right thing, although I
haven't had a chance to test it yet.

					- Ted
