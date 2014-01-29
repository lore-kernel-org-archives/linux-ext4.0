From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: same ext4 file system corruption on different machines
Date: Wed, 29 Jan 2014 12:38:26 -0500
Message-ID: <20140129173826.GA30419@thunk.org>
References: <1390999955.2601.22.camel@snow.station>
 <1391000743.2601.26.camel@snow.station>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Luca Ognibene <luca.ognibene@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1391000743.2601.26.camel@snow.station>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 29, 2014 at 02:05:43PM +0100, Luca Ognibene wrote:
> I say "same ext4 file system corruption" because e2fsck reports errors
> on inodes around 127233 on all file systems.a I'm not sure about the
> syslog errors because i have syslog logs for only the latest faulty
> partition.

The e2fsck output shows that all of the inodes in a tight sequential
range around 127233 are getting corrupted.  That implies that a
specific block is getting corrupted.  You can see which block by using
the imap command in debugfs:

# debugfs -R "imap <12345>" /dev/sda3
debugfs 1.42.9 (28-Dec-2013)
Inode 12345 is part of block group 1
      located at block 1828, offset 0x0800

The fact that the corruption is so consistenth is highly suspicious.
It tends to rule out hardware errrors, but it tends to also rule out
most kernel bugs.  If it's caused by some race condition, or wild
pointer dereference, it's highly unlikely it would result in the same
block getting overwritten with garbage.

It might be worthwhile to try using the block_dump command, but that's
not in the 1.42 version of e2fsprogs.  You'd have to upgrade to a
newer version of e2fsprogs, or find some other block editor that
understands 4k block numbers.  For example:

502# debugfs /dev/sda3
debugfs 1.42.9 (28-Dec-2013)
debugfs:  imap <11>
Inode 11 is part of block group 0
      located at block 1057, offset 0x0a00
debugfs:  bd 1057
0000  0000 0000 0000 0000 3650 6951 3650 6951  ........6PiQ6PiQ
0020  3650 6951 0000 0000 0000 0000 0000 0000  6PiQ............
0040  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0400  ed41 0000 0010 0000 76f5 e852 2797 e252  .A......v..R'..R
0420  2797 e252 0000 0000 0000 2400 0800 0000  '..R......$.....
0440  0000 0800 4201 0000 0af3 0100 0400 0000  ....B...........
0460  0000 0000 0000 0000 0100 0000 2124 0000  ............!$..
0500  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0600  1c00 0000 d08b 1ed0 d08b 1ed0 f426 f411  .............&..
0620  3650 6951 0000 0000 0000 0000 0000 02ea  6PiQ............
0640  0706 4400 0000 0000 1c00 0000 0000 0000  ..D.............
0660  7365 6c69 6e75 7800 0000 0000 0000 0000  selinux.........
0700  0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0740  0000 0000 7379 7374 656d 5f75 3a6f 626a  ....system_u:obj
0760  6563 745f 723a 726f 6f74 5f74 3a73 3000  ect_r:root_t:s0.
1000  0000 0000 0000 0000 0000 0000 0000 0000  ................
 ...

Do this *before* you allow e2fsck to fix the file system.  It may be
that you'll see something that will identify the source of where the
data which is corrupting the inode table.

Cheers,

					- Ted
