From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Thu, 16 Aug 2012 00:50:04 -0700
Message-ID: <20120816075004.GE8802@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org> <20120801053042.GG12695@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49052 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2HPHuI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 03:50:08 -0400
Content-Disposition: inline
In-Reply-To: <20120801053042.GG12695@merlins.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 10:30:42PM -0700, Marc MERLIN wrote:
> First: btrfs is the slowest:
> gandalfthegreat:/mnt/ssd/var/local# time du -sh src/
> 514M	src/
> real	0m25.741s
> 
> Second: ext4 with mkfs.ext4 -O extent -b 4096 /dev/sda3
> gandalfthegreat:/mnt/mnt3# reset_cache
> gandalfthegreat:/mnt/mnt3# time du -sh src/
> 519M	src/
> real	0m12.459s
> gandalfthegreat:~# grep mnt3 /proc/mounts
> /dev/sda3 /mnt/mnt3 ext4 rw,noatime,discard,data=ordered 0 0
> 
> A freshly made ntfs filesystem through fuse is actually FASTER!
> gandalfthegreat:/mnt/mnt2# reset_cache 
> gandalfthegreat:/mnt/mnt2# time du -sh src/
> 506M	src/
> real	0m8.928s
> gandalfthegreat:/mnt/mnt2# grep mnt2 /proc/mounts
> /dev/sda2 /mnt/mnt2 fuseblk rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096 0 0
> 
> How can ntfs via fuse be the fastest?

To provide closure to this thread.

I owed everyone an update, which I just finished typing:
http://marc.merlins.org/perso/linux/post_2012-08-15_The-tale-of-SSDs_-Crucial-C300-early-Death_-Samsung-830-extreme-random-IO-slowness_-and-settling-with-OCZ-Vertex-4.html

Basically, the samsung 830 just sucks. I got 2 of them, they both utterly
sucked. There is no excuse for an SSD being several times slower than a slow
hard drive on _READs_ (not even talking about writes).

I'm not sure how I could have gotten 2 bad drives from Samsung in 2
different shipments, so I'm afraid the entire line may be bad. At least, it
was for me after extensive benchmarking, and even using their own windows
benchmarking tool.

In the end, I got a OCZ Vertex 4 and it's superfast as per the benchmarks I
posted in the link above.

As good news, ext4 is faster than btrfs in my (limited) tests across both
SSDs and my hard drive.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
