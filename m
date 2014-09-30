From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 22:27:12 +0200
Message-ID: <542B1220.8020208@bitsync.net>
References: <542AEED4.5050303@bitsync.net> <20140930183012.GA9942@birch.djwong.org> <542AF9B8.2090800@bitsync.net> <20140930195408.GD17142@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:46671 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaI3U1T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 16:27:19 -0400
In-Reply-To: <20140930195408.GD17142@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30.09.2014 21:54, Theodore Ts'o wrote:
> On Tue, Sep 30, 2014 at 08:43:04PM +0200, Zlatko Calusic wrote:
>> Full error message from the kernel log, together with data check I did in
>> the evening:
>>
>> Sep 29 05:07:51 atlas kernel: ata2.00: exception Emask 0x10 SAct 0x0 SErr
>> 0x4010000 action 0xe frozen
>> Sep 29 05:07:51 atlas kernel: ata2.00: irq_stat 0x00400040, connection
>> status changed
>> Sep 29 05:07:51 atlas kernel: ata2: SError: { PHYRdyChg DevExch }
>> Sep 29 05:07:51 atlas kernel: ata2.00: failed command: FLUSH CACHE EXT
>> Sep 29 05:07:51 atlas kernel: ata2.00: cmd
>> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0\x0a         res
>> 40/00:f4:e2:7f:14/00:00:3a:00:00/40 Emask 0x10 (ATA bus error)
>> Sep 29 05:07:51 atlas kernel: ata2.00: status: { DRDY }
>> Sep 29 05:07:51 atlas kernel: ata2: hard resetting link
>> Sep 29 05:07:57 atlas kernel: ata2: link is slow to respond, please be
>> patient (ready=0)
>> Sep 29 05:08:00 atlas kernel: ata2: SATA link up 3.0 Gbps (SStatus 123
>> SControl 300)
>> Sep 29 05:08:00 atlas kernel: ata2.00: configured for UDMA/133
>> Sep 29 05:08:00 atlas kernel: ata2.00: retrying FLUSH 0xea Emask 0x10
>> Sep 29 05:08:00 atlas kernel: ata2: EH complete
>
> That looks really bad; it sounds like you have a hardware error on at
> least one of your disks.  Have you tried running running badblocks on
> both disks to make sure the disk isn't flagging more bad blocks, and
> then resynchronizing the RAID 1 array?   Then try running e2fsck again.
>

Yep, both disks are pretty old, somewhere at the end of warranty. Yet 
the interesting thing is that exactly that error (FLUSH CACHE EXT) 
happened from time to time, say once a year, but never before I got in 
such trouble that e2fsck wouldn't save the day after one quick run.

I now remember Darrick also asked for smartctl data. Here it is:

/dev/sda
========
Power_On_Hours 40984

and only 2 SMART READ/WRITE LOG errors in the log from long time ago...

ATA Error Count: 2
Error 1 occurred at disk power-on lifetime: 14493 hours (603 days + 21 
hours)
Error 2 occurred at disk power-on lifetime: 14493 hours (603 days + 21 
hours)

Full: http://pastebin.com/GnQhACXf

/dev/sdb (I believe the disk responsible for the problem)
========
Power_On_Hours 40978

No Errors Logged

Full: http://pastebin.com/nUB2q0Tk

Unless you have other ideas, I will run badblocks. Although, as ext4 fs 
is on /dev/md2, I think I should run it on /dev/md2 only? Do you really 
mean to run it on /dev/sda2, /dev/sdb2 - underlying devices? I'm not 
sure how MD would cope with it.

But, I'm pretty sure that it will come out clean. The md check I did 
last night would surely detected bad blocks if there were any. Or not?

Thanks for your help!
-- 
Zlatko

