From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sat, 28 Mar 2009 00:47:19 +0100
Message-ID: <p0624058ec5f30b501efb@[130.161.115.44]>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]>
 <20090327224616.GD5176@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:53602 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764699AbZC0XrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 19:47:12 -0400
In-Reply-To: <20090327224616.GD5176@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 18:46 -0400 27-03-2009, Theodore Tso wrote:
>Thanks, we've been trying to track this down.  The hint that you were
>trying to delete a large (~2 GB) file may be what I need to reproduce
>it locally.

For the record, I've had it (=the soft lockup) happen to me six times 
now since I built the box last December. Three times the machine 
would reboot/fsck without any issues, one time it had errors which 
were fixable with fsck -y, and this is the second time I've gotten 
"WARNING: SEVERE DATA LOSS POSSIBLE". Kernels involved were 2.6.28, 
2.6.28.4 and 2.6.29-rc6, no patches, almost identical .config (ie: 
upgraded through 'make oldconfig').

All six times the process experiencing the lockup was trying to 
delete a file no smaller than 700MB which had just been read from. 
This time the process was mythtranscode (which had obviously just 
read the entire file), the last time it was an rm on a movie I'd just 
finished watching.

>If it happens again, could you try doing this:
>
>    echo w > /proc/sysrq-trigger
>    dmesg > /tmp/dmesg.txt
>
>And send the output of dmesg.txt to us?

Will do.

>It's rather disturbing that there was this much damage done from what
>looks like a deadlock condition.  Others who have report this soft
>lockup condition haven't reported this kind of filesystem damage.  I
>wonder if it might be caused by power-cycling the box; if possible, I
>do recommend that people use the reset button rather than power
>cycling the box; it tends to be much safer and gentler on the machine.

ACK. I have this nagging feeling that this time the damage was more 
extensive because I waited only a few minutes before power cycling; 
my last soft lockup was last Tuesday, and then I waited about half an 
hour before reaching for the power button.

[I have gotten into the habit of power cycling vs resets, as my two 
ivtv TV grabber cards sometimes fail to re-init their firmware after 
anything other than a cold boot following a minute of power-off]

>Given that your system seems to have this prediction to wipe out the
>first part of your block group descriptors, what I would recommend is
>backing up your block group descriptors like this:
>
>	dd if=/dev/XXXX of=backup-bg.img bs=4k count=234
>
>This will backup just your block group descriptors, and will allow you
>to restore them later (although you will have to run e2fsck restoring
>them).

Thanks, will add that to my nightly backup. The last sentence should 
read "...run e2fsck *after* restoring them", right?

>The bigger question is how 16 4k blocks between block numbers 1 and 17
>are getting overwritten by garbage.  As I mentioned, I haven't seen
>anything like this except from your system.  Some others have reported
>a soft lockup when doing an "rm -rf" of a large hierarchy, but they
>haven't reported this kind of filesystem corruption.  I haven't been
>able to replicate it yet myself.

I have a few suspects, but no hard evidence beyond that. Two of the 
six drives in my (linux) software RAID-6 hang off a Marvell SATA/SAS 
RAID controller. Support for that chip (mvsas) is very recent, and 
I'll Google around to see if the BIOS has a habit of scribbling over 
data blocks. I pretty much never reboot the machine other than to get 
out of hangs, so it's not impossible that the soft lockups are a red 
herring.

As I mentioned before I am running the (closed) NVidia X drivers, but 
during none of the hangs have I done anything more challenging than 
watching xterms under fvwm. Other than that the entire setup (CPU, MB 
et al) is reasonably bleeding edge, but I don't see why that should 
manifest itself in this particular way (as opposed to, say, video 
glitches or compiler SIG11s).

>And if you're not willing to take the risk, I'll completely understand
>your deciding that you need to switch back to ext3.  But if you are
>willing to continue testing, and helping us find the root cause
>of the problem, we will be very grateful.

I'd prefer to stay with ext4, as its benefits make sense for the 
simulations I'm running. The downside is that this is my main 
home/office server and MythTV backend; not only is restoring from 
backup tedious, but I'll also have to explain to my SO that the RAID 
ate her shows.

>P.S.  You were using a completely stock kernel, correct?  No other
>patches installed?

Yes.

Thanks,

JDB.
[off to read up on mke2fs -S]
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
