From: tytso@mit.edu
Subject: Re: [Bug 15576] New: Data Loss (flex_bg and ext4_mb_generate_buddy
 errors)
Date: Sun, 21 Mar 2010 19:43:42 -0400
Message-ID: <20100321234342.GE26083@thunk.org>
References: <bug-15576-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51219 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab0CVCMT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:19 -0400
Content-Disposition: inline
In-Reply-To: <bug-15576-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 19, 2010 at 01:05:23AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> # create a 484 cylinder disk [3.7 GB]
> dd of=disk.bin bs=512 count=0 seek=$((484*255*63))
> 
> # associate with loop device
> losetup /dev/loop0 disk.bin
> 
> # generate bad blocks file [600 MB]
> for((i=360491;i<=497992;i++)); do echo $i; done > omit
> 
> # format disk with ext4
> mkfs.ext4 -l omit /dev/loop0

This is an e2fsprogs bug.  If you run e2fsck at this point, pass 5
errors will be reported, that exactly correspond with what you report
the kernel ends up complaining about:

Free blocks count wrong for group #12 (2, counted=0).

Free blocks count wrong for group #13 (2, counted=0).

Free blocks count wrong for group #14 (2, counted=0).

Free blocks count wrong for group #15 (9913, counted=9911).

Free blocks count wrong (800730, counted=800722).

> Worse off, however, if rather than creating a 2 GB file, you use
> this partition as the target root partition for installation using
> the latest [32-bit] Ubuntu installer ... consistently at 57 percent
> of the install ext4 reports data loss.

That's because the the file system is getting remounted read-only when
the file system corruption is detected:


> [ 1129.344600] EXT4-fs error (device sda1): ext4_mb_generate_buddy: EXT4-fs:
> group 12: 0 blocks in bitmap, 2 in gd
> [ 1129.380697] EXT4-fs (sda1): Remounting filesystem read-only

The basic idea behind this is when there is a discrepancy between the
pass #5 summary statistics and the block allocation bitmap, the
problem could be in the block allocation bitmap.  (In this case it is
the summary statistics, but there's no way for the code to know that.)
If the block allocation bitmap is bogus, it's very dangerous to
continue writing into the file system, since we may end up allocating
blocks that are already in use by other files, and this would cause
data loss when those data blocks get overwritten.

Once the file system is marked as read-only, data written just before
the file system was remounted read-only can't be pushed out to disk,
which is the reason for the warnign message:

> [ 1129.574343] mpage_da_map_blocks block allocation failed for inode 41510 at
> logical offset 0 with max blocks 6 with error -30
> [ 1129.574352] This should not happen.!! Data will be lost

(Error -30 is "EROFS".)

We should probably improve the error messages here, but there's not
much else we can do.

The real core issue is the fact that mke2fs isn't doing the right
thing when there are bad blocks and flex_bg is specified.  It's
something we don't test for, since in practice it never happens with
modern disk drives. 

						- Ted
