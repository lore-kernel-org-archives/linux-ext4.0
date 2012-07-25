From: Marc MERLIN <marc@merlins.org>
Subject: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Wed, 25 Jul 2012 08:45:21 -0700
Message-ID: <20120725154521.GA3398@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52033 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2GYPpX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2012 11:45:23 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

First, I had he problem with btrfs (details below), and then I noticed that
while ext4 is actually twice as fast as btrfs, it's still a lot slower at
stat on my fast Samsung 830 512G SSD than my 1TB laptop hard drive (both
drives being in the same thinkpad T530 with 3.4.4 kernel).

How can things be so slow? 12-13 seconds to scan 15K inodes on a freshly
made filesystem (and 22 secs with btrfs, so at least ext4 wins). The same
thing on my spinning drive takes fewer than 4 seconds, and SSD should be
several times faster than that.
SSD throughput was measured over 400MB/s on the raw device and 268MB/s
through the filesystem:

gandalfthegreat:/mnt/mnt2# du -sh w2k-s002.vmdk
2.0G	w2k-s002.vmdk
gandalfthegreat:/mnt/mnt2# dd if=w2k-s002.vmdk of=/dev/null
2145320960 bytes (2.1 GB) copied, 8.01154 s, 268 MB/s

But stats are just super slow
gandalfthegreat:/mnt/mnt2# time du -sh src/
519M	src/
real	0m12.380s
gandalfthegreat:/mnt/mnt2# reset_cache 
gandalfthegreat:/mnt/mnt2# time bash -c 'find src | wc -l'
15261
real	0m11.612s

Partition was made with:
mkfs.ext4 -O extent -b 4096 -E stride=128,stripe-width=128 /dev/sda2

Disk /dev/sda: 512.1 GB, 512110190592 bytes
255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x09aaf50a

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      502271      250112   83  Linux
/dev/sda2          502272    52930559    26214144   83  Linux << this partition

Details of my btrfs tests below, showing that it's not a problem specific
to ext4.

/dev/sda: Device Model:     SAMSUNG SSD 830 Series
/dev/sda: Firmware Version: CXM03B1Q
/dev/sda: User Capacity:    512,110,190,592 bytes [512 GB]

Any idea what could be going wrong here?

Thanks,
Marc

----- Forwarded message from Marc MERLIN <marc@merlins.org> -----

On an _unencrypted_ partition on the SSD, running du -sh on a directory
with 15K files, takes 23 seconds on unencrypted SSD and 4 secs on
encrypted spinning drive, both with a similar btrfs filesystem, and 
the same kernel (3.4.4).

Unencrypted btrfs on SSD:
gandalfthegreat:~# mount -o compress=lzo,discard,nossd,space_cache,noatime /dev/sda2 /mnt/mnt2
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.667s

Encrypted btrfs on spinning drive of the same src directory:
gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m3.881s

I've run this many times and get the same numbers.
I've tried deadline and noop on /dev/sda (the SSD) and du is just as slow.  

I also tried with:
- space_cache and nospace_cache
- ssd and nossd
- noatime didn't seem to help even though I was hopeful on this one.

In all cases, I get:
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.537s


I'm having the same slow speed on 2 btrfs filesystems on the same SSD.
One is encrypted, the other one isnt:
Label: 'btrfs_pool1'  uuid: d570c40a-4a0b-4d03-b1c9-cff319fc224d
	Total devices 1 FS bytes used 144.74GB
	devid    1 size 441.70GB used 195.04GB path /dev/dm-0

Label: 'boot'  uuid: 84199644-3542-430a-8f18-a5aa58959662
	Total devices 1 FS bytes used 2.33GB
	devid    1 size 25.00GB used 5.04GB path /dev/sda2

If instead of stating a bunch of files, I try reading a big file, I do get speeds
that are quite fast (253MB/s and 423MB/s).

22 seconds for 15K files on an SSD is super slow and being 5 times
slower than a spinning disk with the same data.
What's going on?

Thanks,
Marc

----- End forwarded message -----

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
