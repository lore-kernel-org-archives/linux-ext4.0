From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 10:54:03 -0400
Message-ID: <1378997643.28638.53.camel@hp-a6734f>
References: <20130912141856.GA17640@jak-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Julian Andres Klode <jak@jak-linux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:56242 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ILOy3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 10:54:29 -0400
Received: by mail-vb0-f43.google.com with SMTP id h11so7188262vbh.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 07:54:28 -0700 (PDT)
In-Reply-To: <20130912141856.GA17640@jak-x230>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-09-12 at 16:18 +0200, Julian Andres Klode wrote:
> Hi,
> 
> I installed my new laptop on Saturday and setup an ext4 filesystem
> on my / and /home partitions. Without me doing much file transfers,
> I noticed today:
> 
> jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes 
> 342614039
> 
> This is on a 100GB partition. I used fstrim multiple times. I analysed
> the increase over some time today and issued an fstrim in between:
<snip>
> So it seems that ext4 counts the trims as writes? I don't know how I could
> get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
> -- otherwise.

The way fstrim works is that it allocates a temporary file that fills
almost the entire free space on the partition. I believe it does this
with fallocate in order to ensure that space for the file is actually
reserved on disc (but it does not get written to!). It then looks up
where on disc the file's reserved space is, and sends a trim command to
the drive to free that space. Afterwards, it deletes the temporary file.

So what you are seeing means means that it's probably just an issue with
the write accounting, where the blocks reserved by the fallocate are
counted as writes.

> My smart values for my SSD are:
> 
> SMART Attributes Data Structure revision number: 1
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
> 241 Total_LBAs_Written      0x0003   100   100   000    Pre-fail  Always       -       1494

You should be able to confirm this by checking the 'Total_LBAs_Written'
attribute before and after doing the fstrim; it should either not go up,
or go up only be a small amount. Although to be honest, I'm not sure
what this is counting - if that raw value is actually LBAs, that would
only account for 747KiB of writes! I guess it's probably a count of
erase blocks or something - what model is the SSD?

-- 
Calvin Walton <calvin.walton@kepstin.ca>

