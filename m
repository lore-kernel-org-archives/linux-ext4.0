From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 11:29:25 -0400
Message-ID: <1378999765.28638.59.camel@hp-a6734f>
References: <20130912141856.GA17640@jak-x230>
	 <1378997643.28638.53.camel@hp-a6734f> <5231DB33.9090104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Julian Andres Klode <jak@jak-linux.org>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35636 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3ILP3u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 11:29:50 -0400
Received: by mail-vc0-f174.google.com with SMTP id gd11so7283679vcb.5
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 08:29:49 -0700 (PDT)
In-Reply-To: <5231DB33.9090104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-09-12 at 10:18 -0500, Eric Sandeen wrote:
> On 9/12/13 9:54 AM, Calvin Walton wrote:
> > On Thu, 2013-09-12 at 16:18 +0200, Julian Andres Klode wrote:
> >> Hi,
> >>
> >> I installed my new laptop on Saturday and setup an ext4 filesystem
> >> on my / and /home partitions. Without me doing much file transfers,
> >> I noticed today:
> >>
> >> jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes 
> >> 342614039
> >>
> >> This is on a 100GB partition. I used fstrim multiple times. I analysed
> >> the increase over some time today and issued an fstrim in between:
> > <snip>
> >> So it seems that ext4 counts the trims as writes? I don't know how I could
> >> get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
> >> -- otherwise.
> > 
> > The way fstrim works is that it allocates a temporary file that fills
> > almost the entire free space on the partition.
> 
> No, that's not correct.

> Nope.  ;)  strace it and see, it does nothing like this - it calls a special
> ioctl to ask the fs to find and issue discards on unused blocks.
> 
> # strace -e open,write,fallocate,unlink,ioctl  fstrim mnt/
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> open("/lib64/libc.so.6", O_RDONLY)      = 3
> open("/usr/lib/locale/locale-archive", O_RDONLY) = 3
> open("mnt/", O_RDONLY)                  = 3
> ioctl(3, 0xc0185879, 0x7fff6ac47d40)    = 0  <=== FITRIM ioctl
> 
> (old hdparm discard might have done what you say, but that was a hack).

Alright, you got me there :) To be honest, I got the name 'fstrim'
confused with the old 'wiper.sh' script that used to be the only way to
do this, and did in fact function as I said.

Having this all integrated into the filesystem itself is quite a nice
change for the better - the old way was definitely a hack! I suppose
this was added sometime in the 2011 timeframe?

-- 
Calvin Walton <calvin.walton@kepstin.ca>

