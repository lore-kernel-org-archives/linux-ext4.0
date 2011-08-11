From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] loop: add discard support for loop devices
Date: Thu, 11 Aug 2011 13:56:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108111348020.4160@dhcp-27-109.brq.redhat.com>
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab1HKL4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 07:56:40 -0400
In-Reply-To: <1313063143-14473-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 11 Aug 2011, Lukas Czerner wrote:

> This commit adds discard support for loop devices. Discard is usually
> supported by SSD and thinly provisioned devices as a method for
> reclaiming unused space. This is no different than trying to reclaim
> back space which is not used by the file system on the image, but it
> still occupies space on the host file system.
> 
> We can do the reclamation on file system which does support hole
> punching. So when discard request gets to the loop driver we can
> translate that to punch a hole to the underlying file, hence reclaim
> the free space.
> 
> This is very useful for trimming down the size of the image to only what
> is really used by the file system on that image. Fstrim may be used for
> that purpose.
> 
> It has been tested on ext4, xfs and btrfs with the image file systems
> ext4, ext3, xfs and btrfs. ext4, or ext6 image on ext4 file system has
> some problems but it seems that ext4 punch hole implementation is
> somewhat flawed and it is unrelated to this commit.
> 
> Also this is a very good method of validating file systems punch hole
> implementation.
> 
> Note that when encryption is used, discard support is disabled, because
> using it might leak some information useful for possible attacker.

Hi Allison,

as I mentioned in the commit description I believe that I have
seen problems with punch hole implementation. You can apply the
commit to add discard support for loop device and then here is how
to reproduce the problem:


# mkfs.ext4 /dev/sdd
# mount /dev/sdd /mnt/test
# dd if=/dev/zero of=/mnt/test/bigfil2 bs=4096 seek=100M count=1
# mkfs.ext4 /mnt/test/bigfil2
# mount -o loop /mnt/test/bigfil2 /mnt/test3/
# fstrim -v /mnt/test3/
422650347520 Bytes were trimmed

# fsck.ext4 -fn /mnt/test1/bigfil2
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(524288--532511)
Fix? no

Free blocks count wrong for group #16 (24544, counted=32768).
Fix? no

Free blocks count wrong (103161576, counted=103169800).
Fix? no


/mnt/test1/bigfil2: ********** WARNING: Filesystem still has errors
**********

/mnt/test1/bigfil2: 11/26214400 files (0.0% non-contiguous),
1696024/104857600 blocks

And we also get corrupted file system on the ext3 image. I did
not saw that for other file systems, but it is probably just the matter
of how are blocks laid out in the file system format and there are more
chunks of free blocks in ext[43] than xfs, or btrfs.

Also you can find fstrim in latest util-inux-ng. And lastly I believe
that this is great way to validate punch hole implementation. Just
create an image on ext4 file system and run xfstest 251 (or stress.sh -
oss.oracle.com/~mason/stress.sh) on it the image mounted with -o
discard.

Thanks!
-Lukas
