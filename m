From: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Tue, 31 Jul 2012 23:01:35 -0700
Message-ID: <20120801060135.GH12695@merlins.org>
References: <201207222135.11159.Martin@lichtvoll.de> <20120202124241.GW16796@shiny> <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120722204428.GC3925@merlins.org> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <20120727110835.GA6933@shiny> <20120727184238.GA6713@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120801053042.GG12695@merlins.org> <20120727184238.GA6713@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2012 at 11:42:39AM -0700, Marc MERLIN wrote:
> > https://oss.oracle.com/~mason/latencytop.patch
> 
> Thanks for the patch, and yes I can confirm I'm definitely not pegged on CPU 
> (not even close and I get the same problem with unencrypted filesystem, actually
> du -sh is exactly the same speed on encrypted and unecrypted).
> 
> Here's the result I think you were looking for. I'm not good at reading this,
> but hopefully it tells you something useful :)
> 
> The full run is here if that helps:
> http://marc.merlins.org/tmp/latencytop.txt
 
I did some other tests since last week since my laptop is hard to use
considering how slow the SSD is.

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

3) I just got a 2nd ssd from samsung (same kind), just to make sure the one
I had wasn't bad. It's brand new, and I formatted it carefully on 512
boundaries:
/dev/sda1            2048      502271      250112   83  Linux
/dev/sda2          502272    52930559    26214144    7  HPFS/NTFS/exFAT
/dev/sda3        52930560    73902079    10485760   82  Linux swap / Solaris
/dev/sda4        73902080  1000215215   463156568   83  Linux

I also upgraded to 3.5.0 in the meantime but unfortunately the results are
similar.

First: btrfs is the slowest:
gandalfthegreat:/mnt/ssd/var/local# time du -sh src/
514M	src/
real	0m25.741s
gandalfthegreat:/mnt/ssd/var/local# grep /mnt/ssd/var /proc/mounts 
/dev/mapper/ssd /mnt/ssd/var btrfs rw,noatime,compress=lzo,ssd,discard,space_cache 0 0


Second: ext4 is 2x faster than btrfs with mkfs.ext4 -O extent -b 4096 /dev/sda3
gandalfthegreat:/mnt/mnt3# reset_cache
gandalfthegreat:/mnt/mnt3# time du -sh src/
519M	src/
real	0m12.459s
gandalfthegreat:~# grep mnt3 /proc/mounts
/dev/sda3 /mnt/mnt3 ext4 rw,noatime,discard,data=ordered 0 0

Third, A freshly made ntfs filesystem through fuse is actually FASTER!
gandalfthegreat:/mnt/mnt2# reset_cache 
gandalfthegreat:/mnt/mnt2# time du -sh src/
506M	src/
real	0m8.928s
gandalfthegreat:/mnt/mnt2# grep mnt2 /proc/mounts
/dev/sda2 /mnt/mnt2 fuseblk rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096 0 0

How can ntfs via fuse be the fastest and btrfs so slow?
Of course, all 3 are slower than the same filesystem on spinning too, but
I'm wondering if there is a scheduling issue that is somehow causing the
extreme slowness I'm seeing.

Did the latencytop trace I got help in any way?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
