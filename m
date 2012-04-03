From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: backup of the last group descriptor when it is the 1st group of a meta_bg
Date: Tue, 3 Apr 2012 16:07:54 -0600
Message-ID: <C7884065-00E0-4EA1-909C-D8BFA7461ACA@dilger.ca>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com> <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca> <20120403183951.GA24502@thunk.org> <2E05166B-2C63-4DA0-BD80-7C91C9623BDF@dilger.ca> <20120403212654.GB24502@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15095 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2DCWFj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2012 18:05:39 -0400
In-Reply-To: <20120403212654.GB24502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-03, at 3:26 PM, Ted Ts'o wrote:
> On Tue, Apr 03, 2012 at 01:28:14PM -0600, Andreas Dilger wrote:
>> It would probably not even cause the backup group descriptor to be
>> lost in the worst case (new mke2fs/e2fsck/resize2fs creates gd backup,
>> old e2fsck "deletes" gd backup block, use filesystem for a long time,
>> corrupt primary group descriptors, try to recover using new e2fsck).
> 
> Well, it can only be repaired if that block hasn't been allocated and
> assigned to a file.

True, but this is IMHO a fairly rare case, since inode and block
allocation is biased toward the beginning of the filesystem and
the beginning of each group.  19 of 20 filesystems I checked didn't
have the last block allocated.

> If it has, then you can't easily repair it and you have to resign
> yourself to not having a backup of the bgd.  And that means more
> complexity since e2fsck would have to deal with the possibility that
> the last block might contain a backup bgd, or might be allocated to
> a file.

Sure, but it is not worse than having no backup as you propose below.

> And even if there is a "harmless" corruption, it will still
> potentially alarm users who happen to format an ext4 file system with
> this this change implemented, and then they boot a rescue CD which is
> using an older e2fsprogs.

I modified a filesystem with debugfs to check this.  e2fsck -fn reports:

    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    Block bitmap differences:  -4194303

    /dev/sdc: ********** WARNING: Filesystem still has errors **********
    /dev/sdc: 11/1048576 files (0.0% non-contiguous), 77074/4194304 blocks


which I agree isn't completely silent.  Running e2fsck -fy reports:

    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    Block bitmap differences:  -4194303
    Fix? yes

    Free blocks count wrong for group #127 (32253, counted=32254).
    Fix? yes

    Free blocks count wrong (4117230, counted=4117231).
    Fix? yes

    /dev/sdc: ***** FILE SYSTEM WAS MODIFIED *****
    /dev/sdc: 11/1048576 files (0.0% non-contiguous), 77073/4194304 blocks

e2fsck -fp is quiet, since all of these errors are harmless:

    /dev/sdc: 11/1048576 files (0.0% non-contiguous), 77073/4194304 blocks


> Ultimately I suspect the best approach might be to simply try to
> reconstruct the last bgd by attempting to find the inode table in case
> the last meta_bg bgd is destroyed.  Since this only comes up for file
> systems with a single block group in a meta_bg, it's a relatively easy
> thing to do.....

This is guesswork that could be wrong, and doesn't get any closer to
actually getting a proper backup.  Adding the backup gives a long-term
robust solution, and it only has very minor drawbacks (spurious error
messages in e2fsck, some chance of no backup) with a combination of
extremely rare failure of cases.  It is still possible to fall back to
guessing, but I'd rather avoid it.

Cheers, Andreas





