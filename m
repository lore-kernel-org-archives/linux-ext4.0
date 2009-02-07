From: Christian Ohm <chr.ohm@gmx.net>
Subject: Re: How to recover a damaged ext4 file system?
Date: Sat, 7 Feb 2009 17:27:25 +0100
Message-ID: <20090207162725.GA27086@moongate.localnet>
References: <20090105135347.GA3337@localdomain> <20090106120527.GT3932@webber.adilger.int> <20090106193404.GA18957@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Christian Ohm <chr.ohm@gmx.net>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56520 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752291AbZBGQ3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Feb 2009 11:29:46 -0500
Content-Disposition: inline
In-Reply-To: <20090106193404.GA18957@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday,  6 January 2009 at 14:34, Theodore Tso wrote:
> It looks like both the primary and the backup block group descriptors
> are bad.  I'm not sure how this happened; normally nothing touches the
> backup block superblocks at all.  Stupid question --- are you sure the
> partition table is sane; that's always the first thing to check.

I created a new partition on the second drive, and I hope I used exactly the
same options. The result of fdisk -l is the following:

corrupted drive:

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xaaaaaaaa

   Device Boot      Start         End      Blocks   Id  System
   /dev/sde1               1      121601   976760032   83  Linux

new partition on similar drive:

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xaaaaaaaa

   Device Boot      Start         End      Blocks   Id  System
   /dev/sdb1               1      121601   976760001   83  Linux

The only difference is the number of blocks of the partition, I guess since the
start and end are the same this should be equal as well.

> Can you upload someplace the output of
> 
> dumpe2fs /dev/XXX
> dumpe2fs -o superblock=32768 /dev/XXX
> dumpe2fs -o superblock=98304 /dev/XXX
> 
> That would be helpful to see what had happened.

Uploaded at http://www.filefactory.com/file/afg88b1/n/dumps_tar_bz2. dump-0 is
the output of the first command, dump-32768 the second, and the third was equal
to the second. The following two lines weren't redirected into the files (even
with 2>&1), and were the same for all three commands (well, at least for the
first line that's not really surprising).

dumpe2fs 1.41.3 (12-Oct-2008)
ext2fs_read_bb_inode: Invalid argument-

I couldn't yet compile the findsuper program (some missing headers), but since
dumpe2fs found some more or less valid data, it shouldn't be necessary, right?

I also tried the R-Linux recovery program mentioned from
http://www.data-recovery-software.net/Linux_Recovery.shtml, but that didn't
really work (not surprising, since it's for ext3 only).

Best regards,
Christian Ohm

PS: Sorry for the late answer, I'll reply more quickly now.
