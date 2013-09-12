From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 17:29:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1309121724540.2035@localhost.localdomain>
References: <20130912141856.GA17640@jak-x230> <1378997643.28638.53.camel@hp-a6734f>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Julian Andres Klode <jak@jak-linux.org>, linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab3ILP3v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 11:29:51 -0400
In-Reply-To: <1378997643.28638.53.camel@hp-a6734f>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Sep 2013, Calvin Walton wrote:

> Date: Thu, 12 Sep 2013 10:54:03 -0400
> From: Calvin Walton <calvin.walton@kepstin.ca>
> To: Julian Andres Klode <jak@jak-linux.org>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Please help: Is ext4 counting trims as writes,
>     or is something killing my SSD?
> 
> On Thu, 2013-09-12 at 16:18 +0200, Julian Andres Klode wrote:
> > Hi,
> > 
> > I installed my new laptop on Saturday and setup an ext4 filesystem
> > on my / and /home partitions. Without me doing much file transfers,
> > I noticed today:
> > 
> > jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes 
> > 342614039
> > 
> > This is on a 100GB partition. I used fstrim multiple times. I analysed
> > the increase over some time today and issued an fstrim in between:
> <snip>
> > So it seems that ext4 counts the trims as writes? I don't know how I could
> > get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
> > -- otherwise.
> 
> The way fstrim works is that it allocates a temporary file that fills
> almost the entire free space on the partition. I believe it does this
> with fallocate in order to ensure that space for the file is actually
> reserved on disc (but it does not get written to!). It then looks up
> where on disc the file's reserved space is, and sends a trim command to
> the drive to free that space. Afterwards, it deletes the temporary file.

As Eric already mentioned that's not how it works. You're confusing
it with wiper.sh script which did exactly that without any support
from the file system.

Fstrim is entirely different thing and it require support from file
system which ext4 and ext3 has (and xfs,btrfs,gfs2,ocfs2 and
possibly more)

What Julian is probably seeing is that in older kernel there was a
behaviour where all DISCARD requests were accounted as WRITE requests.
This should be fixed in the recent kernel already.

-Lukas

> 
> So what you are seeing means means that it's probably just an issue with
> the write accounting, where the blocks reserved by the fallocate are
> counted as writes.
> 
> > My smart values for my SSD are:
> > 
> > SMART Attributes Data Structure revision number: 1
> > Vendor Specific SMART Attributes with Thresholds:
> > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
> > 241 Total_LBAs_Written      0x0003   100   100   000    Pre-fail  Always       -       1494
> 
> You should be able to confirm this by checking the 'Total_LBAs_Written'
> attribute before and after doing the fstrim; it should either not go up,
> or go up only be a small amount. Although to be honest, I'm not sure
> what this is counting - if that raw value is actually LBAs, that would
> only account for 747KiB of writes! I guess it's probably a count of
> erase blocks or something - what model is the SSD?
> 
> 
