From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Recovering folder and files from ext4 partition
Date: Sun, 24 Jul 2016 08:04:25 +0000 (UTC)
Message-ID: <1347602750.3566292.1469347465293.JavaMail.yahoo@mail.yahoo.com>
References: <114184338.3467667.1469315793830.JavaMail.yahoo.ref@mail.yahoo.com> <114184338.3467667.1469315793830.JavaMail.yahoo@mail.yahoo.com> <20160724021933.GD10966@thunk.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.23]:50180 "EHLO
	nm8-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbcGXILH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jul 2016 04:11:07 -0400
In-Reply-To: <20160724021933.GD10966@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,


Pardon my ignorance here, in some replies.

> So the thing about superblock write times is that the backup

> superblocks are only written (a) at mkfs time, and (b) when the file

> system has been damaged enough that e2fsck needs to do repair work.
> So the fact that the last write times in the superblock are different

> doesn't mean that they are from different file systems.

I had in fact tried running e2fsck on sdc4 earlier this month, based on some forum post I was viewing, but obviously that didn't work:
$ sudo e2fsck /dev/sdc4
e2fsck 1.42.9 (4-Feb-2014)
ext2fs_open2: Bad magic number in super-block
e2fsck: Superblock invalid, trying backup blocks...
e2fsck: Bad magic number in super-block while trying to open /dev/sdc4

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
e2fsck -b 8193 <device>
or
e2fsck -b 32768 <device>

$ 


> In fact, the UUID for the file system is located at offset 0x68 from
> the beginning of the superblock, and these seem to be the same across
> your three superblocks:
> 
> FFF80060:  42 02 00 00 7B 00 00 00 - B6 7F 9F FD 12 BF 4D 57  B...{.........MW
> FFF80070:  A8 34 DD 09 E9 E8 BA C0 - 00 00 00 00 00 00 00 00  .4.............
> 
> So the UUID is b67f9ffd-12bf-4d57-a834-dd09e9e8bac0


I assume this is a good thing that UUID is same, i.e. implies all the 3 superblocks are from same filesystem.

> The odd thing is that the file system creation time (located at
> offset 0x108) is also the same across all three superblocks, but it's
> Fri Jan 2 20:17:47 EST 1970.  The only thing I can think of is that
> the file system was actually created in the factory, before the time

> was properly set.

This disk was a RMA disk that I had received from WDC, to replace a failed disk earlier this year (Feb 2016), although that might still not explain the odd filesystem creation time of Jan 2 1970.

> However, the *really* weird thing is that the superblock with the
> recent last write time is at sector 5781334786 --- and normally the
> superblock where the primary superblock is located is the first
> superblock.  Fortunately, we can figure out where this is by looking
> at s_block_group_nr, located at offset 0x5A.   Across your superblocks:
> 
> Sector #     Block group
> ==========================
> 8387584      1
> 2038182912   243

> 5781334786   0

So, is the superblock with smallest value of s_block_group_nr is the primary superblock, i.e. at sector 5781334786 in this case ?



> This is consistent with the superblock from 5781334786 having the
> updated timestamp.  Unfortunately, it also means that the partition
> was *not* laid out sequentially across your disk.  I'm guessing that
> WD Live Duo is using some kind of LVM scheme, and somehow the sectors
> have gotten allocated in a very odd way indeed, perhaps because of how
> disks were added and removed from your system.  (When you replaced the
> disks, were they by any chance different sizes from the disk that they

> replaced?)

The disks in the WD enclosure were always 3TB disks. So, when you say "not laid out sequentially", it implies you would have expected the first superblock to be the primary superblock and with latest write time, but this disk kind of shows them in reverse order?

> I'm not sure what to tell you at this point.  If you want to try to
> get at least some data off your drive, we can hope the files you care
> about where laid out w/o sequentially, and maybe the photorec program
> (originally designed to pull images off of failed SD cards, but it now
> recognizes some 300+ different file formats) can pull some data off

> the disk.

Yes, the files are laid out sequentially in the sense that when I clicked on one of the PNG files recovered by r-linux, it showed me the correct photo, i.e not corrupted or anything. The missing piece is the true file name and its folder information. Right now I have a very large number of files that possibly r-linux can recover, but I cannot have them sorted into folders.

> But unless you can figure out how to get the blocks reconstructed in
> the correct order, you're not going to be able to mount it or
> otherwise get any data off of it using file system recovery tools....


I am not sure I understand this. So, can I write a program to reconstruct blocks in the correct order, in memory, and then write these correct blocks to a new disk? If so, can you suggest some existing code on how to get started in this direction? Are there tools to scan a disk for superblock locations and give them in sorted order? Also, how do I confirm whether this is an ext4 or ext3 filesystem?




Thanks,
Amit
