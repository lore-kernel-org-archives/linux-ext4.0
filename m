From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 19:21:04 +0200
Message-ID: <20140704172104.GA4877@xo-6d-61-c0.localdomain>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140704121119.GB10514@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> > pavel@duo:~$ uname -a
> > Linux duo 3.15.0-rc8+ #365 SMP Mon Jun 9 09:18:29 CEST 2014 i686
> > GNU/Linux
> > 
> > EXT4-fs (sda3): error count: 11
> > EXT4-fs (sda3): initial error at 1401714179: ext4_mb_generate_buddy:756
> > EXT4-fs (sda3): last error at 1401714179: ext4_reserve_inode_write:4877
> > 
> > That sounds like media error to me?
> 
> If you search your system logs since the last fsck, you should find 11
> instances of "EXT4-fs error" message, which means that there was some
> file system inconsisntencies detected.  The first error was detected at:
> 
> % date -d @1401714179
> Mon Jun  2 09:02:59 EDT 2014

Interesting. I always assumed 140... was block number.

> ... which means that you haven't rebooted in a month, or your boot
> scripts aren't automatically running fsck, or your clock is
> incorrect.

I suspect something is wrong with the reporting. I got this in kernel log _while
running fsck_. fsck was clean (take a look in the original email). I got weird
report with fsck -c, it told me filesystem modified but I don't think I got bad
blocks there.

I believe my scripts are running fsck automatically, and yes, I rebooted a lot
in a last month. It _may_ be possible that last month this x60 had different hard drive,
and I copied it bit-by-bit.

> It does seem to happen more often after an unclean shutdown, and there
> does seem to be a very high correlation with eMMC devices.  It's
> possible there is a jbd2 bug that got introduced recently, where ext4
> is modifying some field outside of a journal transaction.  But I
> haven't been able to reproduce this yet in controlled circumstances.
> 
> What I need from people reporting problems: 
> 
> * What is the HDD/SSD/eMMC device involved

SATA hdd, will get you exact data.

> * What kernel version were you running

For last month? Various, 3.10 to 3.16-rc, mostly 3.15+.

> * What distribution are you running (more so I know what the init
>   scripts might or might not have been doing vis-a-vis running fsck
>   after a crash)

Debian 6.
 
> * Was there an unclean shutdown / power drop / hard reset involved?
>   If so, did the HDD/SSD/eMMC lose power, or was the reset button hit
>   on the machine?

Crash in last month? Probably yes.

> * What sort of workload / application / test program running before
>   the crash, if any?

Just usual desktop / kernel development.

> and so they don't need to report anymore info.  I need as many data
> points as possible at this point.

You'll get them.

Is it possible that my fsck is so old it does not clear this "filesystem
had error in past" flag? Because I strongly suspect I'll boot into
init=/bin/bash, run fsck, it will tell me "all clean", and the messages
will repeat in the middle of fsck run.

Best regards,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
