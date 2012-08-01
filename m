From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Tue, 31 Jul 2012 22:30:42 -0700
Message-ID: <20120801053042.GG12695@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43390 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2HAFar (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 01:30:47 -0400
Content-Disposition: inline
In-Reply-To: <20120726065412.GB20315@merlins.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 11:54:12PM -0700, Marc MERLIN wrote:
> and one on th HDD:
> 
> gandalfthegreat:/boot# find /boot/src | wc -l
> 6261
> gandalfthegreat:/boot# reset_cache; time du -sh /boot/src ; reset_cache; time du -sh /boot2/src
> 169M	/boot/src
> real	0m5.248s
> 
> 157M	/boot2/src
> real	0m0.698s
> 
> gandalfthegreat:/boot# df -h /boot /boot2
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda1       241M  226M  2.5M  99% /boot
> /dev/sdb2       298M  273M  9.3M  97% /boot2
> gandalfthegreat:/boot# grep boot /proc/mounts
> /dev/sdb2 /boot2 ext4 rw,relatime,stripe=4,data=ordered 0 0
> /dev/sda1 /boot ext4 rw,relatime,discard,stripe=32,data=ordered 0 0
> 
> The only sizeable difference is that sda1 is a 4K block size I forced to
> help with faster writes on the ssd.
> 
> In the example above, the SSD is almost 10 times slower than the HDD.
> 
> blktrace -d /dev/sda -o - | blkparse -i - during du is 
> http://marc.merlins.org/tmp/blktrace_du_sda1.txt
> 
> Does that give enough info on what's going on?

(TL;DR: ntfs on linux via fuse is 33% faster than ext4, which is 2x faster
than btrfs, but 3x slower than the same filesystem on spinning disk :( )


Ok, just to help with debuggging this,
1)  I put my samsung 830 SSD into another thinkpad and it wasn't faster or
slower.

2) Then I put a crucial 256 C300 SSD (the replacement for the one I had that
just died and killed all my data), and du took 0.3 seconds on both my old
and new thinkpads.
The old thinkpad is running ubuntu 32bit the new one debian testing 64bit
both with kernel 3.4.4.

So, clearly, there is something wrong with the samsung 830 SSD with linux
but I have no clue what :(
In raw speed (dd) the samsung is faster than the crucial (350MB/s vs
500MB/s).
It it were a random crappy SSD from a random vendor, I'd blame the SSD, but
I have a hard time believing that samsung is selling SSDs that are slower
than hard drives at random IO and 'seeks'.

Mmmh, and to do more tests, I eventually got a 2nd ssd from samsung (same
kind), just to make sure the one I had wasn't bad.

Unfortunately the results are similar.
I upgraded to 3.5.0 in the meantime:

First: btrfs is the slowest:
gandalfthegreat:/mnt/ssd/var/local# time du -sh src/
514M	src/
real	0m25.741s

Second: ext4 with mkfs.ext4 -O extent -b 4096 /dev/sda3
gandalfthegreat:/mnt/mnt3# reset_cache
gandalfthegreat:/mnt/mnt3# time du -sh src/
519M	src/
real	0m12.459s
gandalfthegreat:~# grep mnt3 /proc/mounts
/dev/sda3 /mnt/mnt3 ext4 rw,noatime,discard,data=ordered 0 0

A freshly made ntfs filesystem through fuse is actually FASTER!
gandalfthegreat:/mnt/mnt2# reset_cache 
gandalfthegreat:/mnt/mnt2# time du -sh src/
506M	src/
real	0m8.928s
gandalfthegreat:/mnt/mnt2# grep mnt2 /proc/mounts
/dev/sda2 /mnt/mnt2 fuseblk rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096 0 0

How can ntfs via fuse be the fastest?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
