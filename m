From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 18 Jul 2016 09:38:43 -0400
Message-ID: <20160718133843.GA26664@thunk.org>
References: <20160718105707.GA4253@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Johannes Stezenbach <js@sig21.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160718105707.GA4253@sig21.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 18, 2016 at 12:57:07PM +0200, Johannes Stezenbach wrote:
> 
> I'm running 4.7.0-rc7 with ext4 on lvm on dm-crypt on SSD
> and out of the blue on idle machine the following error
> message appeared:
> 
> [373851.683131] EXT4-fs (dm-3): error count since last fsck: 1
> [373851.683151] EXT4-fs (dm-3): initial error at time 1468438194: dx_probe:740: inode 22288562
> [373851.683158] EXT4-fs (dm-3): last error at time 1468438194: dx_probe:740: inode 22288562
> 
> inode 22288562 is a directory with ~800 small files in it,
> but AFAICT nothing was accessing it, no cron job running etc.
> No further error message was logged.  Accessing the directory
> and the files in it also gives no further errors.

Yes, thes messages gets printed once a day in case there was a file
system corruption detected earlier.  The problem is people
unfortunately run with their file systems set to errors=continue,
which I sometimes refer to as the "don't worry, be happy" option.  The
problem is sometimes this can cause data loss, and people aren't
checking their logs so it's possible for errors to lurk hidden for a
long time without noticing.  Then they complain, and the people who
are trying to resolve the bug report might not realize that in fact
the file system has been corrupted for ages.

I strongly suggest that people either (a) run automatic log analaysis
software that informs you when a file system corruption was detected,
or (b) run with errors=panic which will at least force a file system
check when the system reboots, or (c) run with errors=remount-ro which
avoids the file system from getting further corrupted.

> Searching back in the log at date -d @1468438194 I found:
> 
> Jul 13 21:29:54 foo kernel: EXT4-fs error (device dm-3): dx_probe:740: inode #22288562: comm git: Directory index failed checksum
> 
> 
> Time to run fsck?  Is it the consequence of a previous crash
> (I had many recently)?

In general, whenever the an EXT4-fs error is registered, you probably
want to run fsck, right away.  The default of errors=continue was more
appropriate back in the day when servers were pets, and many people
would complain if we just unceremoniously forced a reboot when we
noticed a file system corruption, or remounted the file system
read-only, which could lead to some surprising failures at the
application stack level that could be hard to debug.  But in a
Cloud/Kuberneties world of "servers are cattle", forcing a reboot
right away probably is the best thing to do, so the fsck can be forced
right away.

As far as what caused it, I'm not sure.  If you can since look at the
directory without any problems, it's possible that it was caused by a
transient hardware glitch.  That's because when we issue the
"Directory index failed checksum", the directory block is discarded
(to avoid potential further file system corruption).  If you can list
the directory now, that would appear that a subsequent attempt to
reread the directory block was successful.

But, in matters like this, I generally advise a "better safe than
sorry", and run fsck.  If you are using LVM, then you might be able to
create a snapshot and then run fsck -n on the snapshot, to make sure
the file system is OK, without needing to shutdown your server.  An
example of such a script can be found here:

http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/tree/contrib/e2croncheck

Cheers,

						- Ted
