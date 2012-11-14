From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: Wed, 14 Nov 2012 00:43:47 -0500
Message-ID: <20121114054347.GA20380@thunk.org>
References: <20121114035101.15686.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60964 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2KNFnw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2012 00:43:52 -0500
Content-Disposition: inline
In-Reply-To: <20121114035101.15686.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 13, 2012 at 10:51:01PM -0500, George Spelvin wrote:
> As people might know from my recent postings, I've been expanding a RAID
> with an ext4 file system.  This has uncovered Some Issues.
> 
> Because the final size exceeded 16 TiB, I had to use the 64bit support
> which is relatively recent.
> 
> But now carrying out the resize has produced some problems...
> 
> # resize2fs -p /dev/md1
> resize2fs 1.43-WIP (22-Sep-2012)
> Filesystem at /dev/md1 is mounted on /data; on-line resizing required
> old_desc_blocks = 932, new_desc_blocks = 2562
> resize2fs: Not enough reserved gdt blocks for resizing

OK, based on your description, you started with a device which was
8001057980416 bytes, and then grew it to 22002909446144 bytes.  So I
tried to exactly the same thing using a file located on an xfs
partition (so I could make it that big):

# mkfs.xfs /dev/closure/bigscratch
# mount /dev/closure/bigscratch /mnt
# touch /mnt/foo.img
# truncate --size 8001057980416 /mnt/foo.img
# mke2fs -F -t ext4 -O 64bit /mnt/foo.img
# truncate --size 22002909446144 /mnt/foo.img
# mount /mnt/foo.img /u2
# resize2fs /dev/loop0

This succeeded for me:

# resize2fs /dev/loop0
resize2fs 1.43-WIP (21-Sep-2012)
Filesystem at /dev/loop0 is mounted on /u2; on-line resizing required
old_desc_blocks = 932, new_desc_blocks = 2562
The filesystem on /dev/loop0 is now 5371804064 blocks long.

What version of resize2fs were you using --- I know it says 1.43-WIP,
but what git ocmmit version specifically were you using?  And how did
you compile it, and how did you install it.

Also, which kernel version were you using?

OK, let's try an off-line resize:

# truncate --size 8001057980416 /mnt/foo.img
# mke2fs -F -t ext4 -O 64bit /mnt/foo.img
# truncate --size 22002909446144 /mnt/foo.img
# e2fsck -fy /mnt/foo.img
# resize2fs -p /mnt/foo.img

So first of all, I don't see this line when running e2fsck:

> eh_magic = 0000 != f30a

# e2fsck -fy /mnt/foo.img
e2fsck 1.43-WIP (21-Sep-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/mnt/foo.img: 11/244174848 files (0.0% non-contiguous), 15457939/1953383296 blocks

.... and the resize2fs output is a little different:

# resize2fs -p /mnt/foo.img
resize2fs 1.43-WIP (21-Sep-2012)
Resizing the filesystem on /mnt/foo.img to 5371804064 (4k) blocks.

Begin pass 5 (max = 1)
Moving inode table            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /mnt/foo.img is now 5371804064 blocks long.

However, when I try doing an e2fsck on the resulting file system, I do
see a very similar set of errors:

e2fsck 1.43-WIP (21-Sep-2012)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
e2fsck: Group descriptors look bad... trying backup blocks...
Pass 1: Checking inodes, blocks, and sizes
Group 1's inode table at 2245 conflicts with some other fs block.
Relocate? yes

Group 1's block bitmap at 1958 conflicts with some other fs block.
Relocate? yes

Group 1's inode bitmap at 1974 conflicts with some other fs block.
Relocate? yes

....

Given that I was primarily focused on making resize2fs work using
on-line resizing, this doesn't completely surprise me, but it is
definitely a bug with resize2fs that needs fixing --- we need to make
off-line resizing work, and if there are bugs related to it, we need
to simply make resize2fs refuse to do the off-line resize.

So the first question is figuring out why the on-line resizing didn't
work for you, since that is what I've spent most of my time trying to
fix up.  The secondary question then is trying to figure out whappened
with the off-line resize, and to fix that bug in e2fsprogs.

Regards,

						- Ted
