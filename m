From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovering folder and files from ext4 partition
Date: Sat, 23 Jul 2016 22:19:33 -0400
Message-ID: <20160724021933.GD10966@thunk.org>
References: <114184338.3467667.1469315793830.JavaMail.yahoo.ref@mail.yahoo.com>
 <114184338.3467667.1469315793830.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Bhatia Amit <amitbhatia@rocketmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51664 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcGXCTp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jul 2016 22:19:45 -0400
Content-Disposition: inline
In-Reply-To: <114184338.3467667.1469315793830.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So the thing about superblock write times is that the backup
superblocks are only written (a) at mkfs time, and (b) when the file
system has been damaged enough that e2fsck needs to do repair work.
So the fact that the last write times in the superblock are different
doesn't mean that they are from different file systems.

In fact, the UUID for the file system is located at offset 0x68 from
the beginning of the superblock, and these seem to be the same across
your three superblocks:

 FFF80060:  42 02 00 00 7B 00 00 00 - B6 7F 9F FD 12 BF 4D 57  B...{.........MW
 FFF80070:  A8 34 DD 09 E9 E8 BA C0 - 00 00 00 00 00 00 00 00  .4.............

So the UUID is b67f9ffd-12bf-4d57-a834-dd09e9e8bac0

The odd thing is that the file system creation time (located at
offset 0x108) is also the same across all three superblocks, but it's
Fri Jan 2 20:17:47 EST 1970.  The only thing I can think of is that
the file system was actually created in the factory, before the time
was properly set.

However, the *really* weird thing is that the superblock with the
recent last write time is at sector 5781334786 --- and normally the
superblock where the primary superblock is located is the first
superblock.  Fortunately, we can figure out where this is by looking
at s_block_group_nr, located at offset 0x5A.   Across your superblocks:

Sector #     Block group
==========================
8387584      1
2038182912   243
5781334786   0

This is consistent with the superblock from 5781334786 having the
updated timestamp.  Unfortunately, it also means that the partition
was *not* laid out sequentially across your disk.  I'm guessing that
WD Live Duo is using some kind of LVM scheme, and somehow the sectors
have gotten allocated in a very odd way indeed, perhaps because of how
disks were added and removed from your system.  (When you replaced the
disks, were they by any chance different sizes from the disk that they
replaced?)

I'm not sure what to tell you at this point.  If you want to try to
get at least some data off your drive, we can hope the files you care
about where laid out w/o sequentially, and maybe the photorec program
(originally designed to pull images off of failed SD cards, but it now
recognizes some 300+ different file formats) can pull some data off
the disk.

But unless you can figure out how to get the blocks reconstructed in
the correct order, you're not going to be able to mount it or
otherwise get any data off of it using file system recovery tools....

Good luck,

						- Ted
