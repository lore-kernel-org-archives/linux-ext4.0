From: Julian Andres Klode <jak@jak-linux.org>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 17:19:55 +0200
Message-ID: <20130912151955.GA19285@jak-x230>
References: <20130912141856.GA17640@jak-x230>
 <1378997643.28638.53.camel@hp-a6734f>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45128 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3ILPT7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 11:19:59 -0400
Received: by mail-bk0-f41.google.com with SMTP id na10so4397532bkb.28
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 08:19:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1378997643.28638.53.camel@hp-a6734f>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 12, 2013 at 10:54:03AM -0400, Calvin Walton wrote:
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

According to http://www.plextoramericas.com/index.php/forum/27-ssd/7881-my-m5pro-wear-leveling-count-problem
those are 32 MB blocks. And 177 Wear_Leveling_Count corresponds to 64 MB
blocks.

So Total_LBAs_Written corresponds to 46 GB of writes and Wear_Leveling_Count 
corresponds to 29 GB. This seems realistic for 5 days of use with an initial
installation and more than 100MB of writes per hour (roughly 1GB per day).

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
