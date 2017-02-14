From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck exit codes
Date: Tue, 14 Feb 2017 12:01:01 -0500
Message-ID: <20170214170101.irgf4uvvvbbepmip@thunk.org>
References: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: thanumalayan mad <madthanu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39558 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752726AbdBNRBE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 14 Feb 2017 12:01:04 -0500
Content-Disposition: inline
In-Reply-To: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2017 at 04:59:49PM -0800, thanumalayan mad wrote:
> root@lappy:/home/madthanu# fsck.ext4 -f /dev/sda8
> e2fsck 1.42.12 (29-Aug-2014)
> /dev/sda8: recovering journal
> Clearing orphaned inode 6063 (uid=0, gid=0, mode=0100664, size=2377)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong (2710767, counted=2681703).
> Fix<y>? no
> Free inodes count wrong (698998, counted=684135).
> Fix<y>? no
> /dev/sda8: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sda8: 10/699008 files (80.0% non-contiguous), 83473/2794240 blocks

This is expected; ext4 doesn't use the overall number of free blocks
and free inodes summarized in the inodes --- and so to improve
scalability, quite a whle back we stoped updating those fields except
on a clean shutdown.  This means that if you crash your system or
other wise leave the file system with an unclean mount, the total
number of free blocks and free inodes will not be updated.

When the kernel mounts the file system, it will tally up the free
block/inode counts from all of the block group descriptors, and use
that value, and on the next clean shutdown, they will be updated
appropriately.  E2fsck is doing the same thing here.  The difference
is that we're asking the user's permission before we fix things, so it
looks like something more serious than it is.

The way you can tell whether or not the file system has errors is to
run e2fsck -fn:

% e2fsck -fn /tmp/foo.img
e2fsck 1.43.4 (31-Jan-2017)
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Inode 15 extent tree (at level 1) could be shorter.  Fix? no

Inode 115 extent tree (at level 1) could be shorter.  Fix? no

Inode 365 extent tree (at level 1) could be shorter.  Fix? no

Inode 741 extent tree (at level 1) could be shorter.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (6830, counted=163).
Fix? no

Free inodes count wrong (2037, counted=0).
Fix? no

/tmp/foo.img: 11/2048 files (900.0% non-contiguous), 1362/8192 blocks
% echo $?
0

If the file system has an error that needs to be fixed, it will return
an exit status of 4:

% e2fsck -fn /tmp/foo.img
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry 'p0' in /fs (12) has deleted/unused inode 14.  Clear? no

Entry 'p0' in /fs (12) has an incorrect filetype (was 2, should be 0).
Fix? no

Entry '..' in <14>/<17> (17) has deleted/unused inode 14.  Clear? no

Entry '..' in <14>/<17> (17) has an incorrect filetype (was 2, should be 0).
Fix? no

Pass 3: Checking directory connectivity
Unconnected directory inode 17 (<14>/<17>)
Connect to /lost+found? no

'..' in ... (17) is <14> (14), should be <The NULL inode> (0).
Fix? no

Pass 4: Checking reference counts
Inode 12 ref count is 7, should be 6.  Fix? no

Inode 17 ref count is 5, should be 4.  Fix? no

Pass 5: Checking group summary information
Block bitmap differences:  -1363
Fix? no

Inode bitmap differences:  -14
Fix? no

Directories count wrong for group #0 (79, counted=78).
Fix? no


/tmp/foo.img: ********** WARNING: Filesystem still has errors **********

/tmp/foo.img: 2047/2048 files (4.8% non-contiguous), 8025/8192 blocks

% echo $?
4

See the fsck.ext4 man page, the "EXIT CODE" section for an explanation
for how the exit codes work.

					- Ted
					
