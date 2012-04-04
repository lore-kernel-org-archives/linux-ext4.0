From: Ted Ts'o <tytso@mit.edu>
Subject: Re: backup of the last group descriptor when it is the 1st group
 of a meta_bg
Date: Wed, 4 Apr 2012 12:28:06 -0700
Message-ID: <20120404192806.GD24502@thunk.org>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
 <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
 <20120403183951.GA24502@thunk.org>
 <2E05166B-2C63-4DA0-BD80-7C91C9623BDF@dilger.ca>
 <20120403212654.GB24502@thunk.org>
 <C7884065-00E0-4EA1-909C-D8BFA7461ACA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50059 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab2DDT2J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Apr 2012 15:28:09 -0400
Content-Disposition: inline
In-Reply-To: <C7884065-00E0-4EA1-909C-D8BFA7461ACA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 03, 2012 at 04:07:54PM -0600, Andreas Dilger wrote:
> > And even if there is a "harmless" corruption, it will still
> > potentially alarm users who happen to format an ext4 file system with
> > this this change implemented, and then they boot a rescue CD which is
> > using an older e2fsprogs.
> 
> I modified a filesystem with debugfs to check this.  e2fsck -fn reports:...
> which I agree isn't completely silent.  Running e2fsck -fy reports:
> 
>     Pass 1: Checking inodes, blocks, and sizes
>     Pass 2: Checking directory structure
>     Pass 3: Checking directory connectivity
>     Pass 4: Checking reference counts
>     Pass 5: Checking group summary information
>     Block bitmap differences:  -4194303
>     Fix? yes
> 
>     Free blocks count wrong for group #127 (32253, counted=32254).
>     Fix? yes
> 
>     Free blocks count wrong (4117230, counted=4117231).
>     Fix? yes
> 
>     /dev/sdc: ***** FILE SYSTEM WAS MODIFIED *****
>     /dev/sdc: 11/1048576 files (0.0% non-contiguous), 77073/4194304 blocks
> 
> e2fsck -fp is quiet, since all of these errors are harmless:
> 
>     /dev/sdc: 11/1048576 files (0.0% non-contiguous), 77073/4194304 blocks

Granted that in preen mode the error messages aren't printed.  But if
someone runs e2fsck by hand, they'll see the output of e2fsck -fy.

I was chatting with Alasdair last evening at the Collab Summit
reception, and he pointed out to me (in relation to another technical
issue, but it applies here too) that if you're a distro, you really
want to engineer to avoid support calls.  If you have error messages
that are confusing or are needlessly scary, if that causes even a
small number of support calls to your help desk, that costs you (the
distro) real money.  So it's really important to consider carefully
how you write your error messages; on the one hand you want to make
sure enough information ends up in the dmesg log so that a helpdesk
can debug the problem; but if the printk's are scary, it can cause
needless calls to a support desk, and that costs money, and can be the
difference between profit and loss.

Granted that would only happen if you have a mix between older and
newer versions of e2fsprogs, so perhaps this won't be that likely.  I
suppose we could use a compat feature to prevent an older version of
e2fsck from running on that file system.  Is it worth it?  Perhaps...

> This is guesswork that could be wrong, and doesn't get any closer to
> actually getting a proper backup.  Adding the backup gives a long-term
> robust solution, and it only has very minor drawbacks (spurious error
> messages in e2fsck, some chance of no backup) with a combination of
> extremely rare failure of cases.  It is still possible to fall back to
> guessing, but I'd rather avoid it.

Well, once you have metadata checksums (which should be landing soon),
the "guesswork" is actually going to be reliable, since we won't need
to use hueristics to determine whether or not a potential inode table
block really is an ITB.

In fact, one of the things I'm looking forward to doing is using this
techinque to make a completely safe mke2fs -S functionality.  Whether
we do this in the mke2fs program, or in e2fsck, it will substantially
improve our ability to recover even if the backup descriptors aren't
available for some reason.  (Users do use mke2fs -S, so there are
definitely times when the backup bgd's aren't sufficient all the
time.)

Ultimately, it's a tradeoff.  The kludge of putting the backup in the
last block in the file system (whether or not we decrement
s_blocks_count, which to me isn't that different in terms of
kludginess) has the advantage that it only requires a new version of
e2fsprogs.

If we try to use a hueristics, with metadata checksums I think solves
the problem completely, but it requires an updated kernel plus an
updated e2fsprogs.  Without metadata checksums, your criticism of
whether or not the hueristic is fair, although I suspect most of the
time it would actually work.

Regards,

						- Ted
