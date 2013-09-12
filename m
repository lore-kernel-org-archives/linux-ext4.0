From: Julian Andres Klode <jak@jak-linux.org>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 17:32:32 +0200
Message-ID: <20130912153232.GA19548@jak-x230>
References: <20130912141856.GA17640@jak-x230>
 <1378997643.28638.53.camel@hp-a6734f>
 <5231DB33.9090104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:37385 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3ILPch (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 11:32:37 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so4271809bkb.41
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 08:32:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5231DB33.9090104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 12, 2013 at 10:18:11AM -0500, Eric Sandeen wrote:
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
> 
> > I believe it does this
> > with fallocate in order to ensure that space for the file is actually
> > reserved on disc (but it does not get written to!). It then looks up
> > where on disc the file's reserved space is, and sends a trim command to
> > the drive to free that space. Afterwards, it deletes the temporary file.
> 
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
> 
> > So what you are seeing means means that it's probably just an issue with
> > the write accounting, where the blocks reserved by the fallocate are
> > counted as writes.
> 
> I also think that it is just accounting, and probably just an error,
> which seems to be fixed by now - what kernel are you running?

Kernel 3.10.7

> 
> When you report it in ext4, it calculates it like this:
> 
>         return snprintf(buf, PAGE_SIZE, "%llu\n",
>                         (unsigned long long)(sbi->s_kbytes_written +
>                         ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
>                           EXT4_SB(sb)->s_sectors_written_start) >> 1)));
> 
> so it counts partition stats in the mix (outside of ext4's accounting)
> 
> On io completion, we add the bytes "completed" (blk_account_io_completion())
> 
> And it sounds like it's counting trim/discard completions in the mix.
> 
> does /proc/diskstats show a jump for your partition after an fstrim as well?
> 

I created a file using fallocate, deleted it (with discard option set
on the FS), and then sync'ed and got the following changes in sdb3:

jak@jak-x230:~$ diff /tmp/a /tmp/b
diff --git tmp/a tmp/b
index e0370bf..43c2fdd 100644
--- tmp/a
+++ tmp/b
@@ -1,7 +1,7 @@
    8       0 sda 1845 2122 15992 15268 6070 313375 3119314 5359680 0 85548 5391508
    8       1 sda1 500 0 3970 1104 4106 37774 2840016 1028656 0 29656 1046320
-   8      16 sdb 85114 4486 4281300 36344 143239 111626 282319450 1803288 0 101416 1839608
+   8      16 sdb 85114 4486 4281300 36344 143300 111658 284417426 1803492 0 101460 1839812
    8      17 sdb1 930 992 8152 316 2 0 2 0 0 68 316
    8      18 sdb2 72071 3316 3024626 29692 54309 29582 23201808 183432 0 37704 213060
-   8      19 sdb3 11858 175 1246458 6320 88381 82044 259117640 1619624 0 65880 1626200
+   8      19 sdb3 11858 175 1246458 6320 88442 82076 261215616 1619828 0 65924 1626404

> 
> But what kernel are you running?  I don't see it on a 3.11 kernel:
> 
> After a fresh mkfs I'm at:
> [root@bp-05 tmp]# dumpe2fs -h fsfile  | grep Lifetime
> dumpe2fs 1.41.12 (17-May-2010)
> Lifetime writes:          8135 MB
> 
> and then several fstrims don't budge it:
> 
> [root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
> 8330683
> [root@bp-05 tmp]# fstrim mnt/
> [root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
> 8330683
> [root@bp-05 tmp]# fstrim mnt/
> [root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
> 8330683
> 
> -Eric

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
