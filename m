From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Sat, 27 Feb 2010 05:14:50 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:35706 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968123Ab0B0KOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Feb 2010 05:14:52 -0500
In-Reply-To: <4B887548.50508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 26 Feb 2010, Eric Sandeen wrote:

> Eric Sandeen wrote:
>
> Oh, you need very recent util-linux-ng as well, and use libblkid from there
> with:
>
> [e2fsprogs] # ./configure --disable-libblkid
>
> Otherwise you can just feed mkfs.ext4 stripe & stride manually.
>
> -Eric
>

Hi,

Even when set, there is still poor performance:

http://busybox.net/~aldot/mkfs_stride.html
Raid Level: 0
Number of Physical Disks: 11
RAID chunk size (in KiB): 1024
number of filesystem blocks (in KiB)
mkfs.ext4 -b 4096 -E stride=256,stripe-width=2816

p63:~# /usr/bin/time mkfs.ext4 -b 4096 -E stride=256,stripe-width=2816 /dev/md0
mke2fs 1.41.10 (10-Feb-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=256 blocks, Stripe width=2816 blocks
335765504 inodes, 1343055824 blocks
67152791 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
40987 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544

Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 38 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
p63:~#

p63:~# mount /dev/md0 /r1 -o nobarrier,data=writeback
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 39.3674 s, 273 MB/s
p63:/r1#

Still very slow?

Let's try with some optimizations:
p63:/r1#  mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,max_batch_time=0^C

Still not anywhere near 500-600MiB/s of XFS:
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.4824 s, 352 MB/s
p63:/r1#

Am I doing something wrong/is there a flag I am missing that will speed it
up?  Or is this performance for sequential writes on EXT4?

Justin.

