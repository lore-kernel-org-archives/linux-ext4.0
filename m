From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 20:06:51 +0200
Message-ID: <20140704180651.GA22322@amd.pavel.ucw.cz>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> > What I need from people reporting problems: 
> > 
> > * What is the HDD/SSD/eMMC device involved
> 
> SATA hdd, will get you exact data.

Hitachi HTS545050A7E380, got it from ps/3 at april 25, 2014, never had
problems according to smart.

> > * What kernel version were you running
> 
> For last month? Various, 3.10 to 3.16-rc, mostly 3.15+.
> 
> > * What distribution are you running (more so I know what the init
> >   scripts might or might not have been doing vis-a-vis running fsck
> >   after a crash)
> 
> Debian 6.

6.0.9

> Is it possible that my fsck is so old it does not clear this "filesystem
> had error in past" flag? Because I strongly suspect I'll boot into
> init=/bin/bash, run fsck, it will tell me "all clean", and the messages
> will repeat in the middle of fsck run.

And indeed:

..init=/bin/bash
# fsck /dev/sda3
e2fsck 1.41.12
rootfs: clean
# date +%s
1404496...
#
EXT4-fs (sda3): error count: 11
EXT4-fs (sda3): initial error at 1401741...
...

(hand copied)

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
