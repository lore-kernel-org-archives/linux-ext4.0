From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Fri, 13 Sep 2013 09:38:11 -0400
Message-ID: <52331543.4090402@gmail.com>
References: <20130912141856.GA17640@jak-x230> <1378997643.28638.53.camel@hp-a6734f> <5231DB33.9090104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	Julian Andres Klode <jak@jak-linux.org>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:51564 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab3IMNiR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Sep 2013 09:38:17 -0400
Received: by mail-qe0-f50.google.com with SMTP id a11so965298qen.37
        for <linux-ext4@vger.kernel.org>; Fri, 13 Sep 2013 06:38:15 -0700 (PDT)
In-Reply-To: <5231DB33.9090104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/12/2013 11:18 AM, Eric Sandeen wrote:
> On 9/12/13 9:54 AM, Calvin Walton wrote:
>> On Thu, 2013-09-12 at 16:18 +0200, Julian Andres Klode wrote:
>>> Hi,
>>>
>>> I installed my new laptop on Saturday and setup an ext4 filesystem
>>> on my / and /home partitions. Without me doing much file transfers,
>>> I noticed today:
>>>
>>> jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes
>>> 342614039
>>>
>>> This is on a 100GB partition. I used fstrim multiple times. I analysed
>>> the increase over some time today and issued an fstrim in between:
>> <snip>
>>> So it seems that ext4 counts the trims as writes? I don't know how I could
>>> get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
>>> -- otherwise.
>> The way fstrim works is that it allocates a temporary file that fills
>> almost the entire free space on the partition.
> No, that's not correct.

That is how an older tool (from Mark Lord) used to work :)

ric

>
>> I believe it does this
>> with fallocate in order to ensure that space for the file is actually
>> reserved on disc (but it does not get written to!). It then looks up
>> where on disc the file's reserved space is, and sends a trim command to
>> the drive to free that space. Afterwards, it deletes the temporary file.
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
>> So what you are seeing means means that it's probably just an issue with
>> the write accounting, where the blocks reserved by the fallocate are
>> counted as writes.
> I also think that it is just accounting, and probably just an error,
> which seems to be fixed by now - what kernel are you running?
>
> When you report it in ext4, it calculates it like this:
>
>          return snprintf(buf, PAGE_SIZE, "%llu\n",
>                          (unsigned long long)(sbi->s_kbytes_written +
>                          ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
>                            EXT4_SB(sb)->s_sectors_written_start) >> 1)));
>
> so it counts partition stats in the mix (outside of ext4's accounting)
>
> On io completion, we add the bytes "completed" (blk_account_io_completion())
>
> And it sounds like it's counting trim/discard completions in the mix.
>
> does /proc/diskstats show a jump for your partition after an fstrim as well?
>
>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

