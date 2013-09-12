From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 10:18:11 -0500
Message-ID: <5231DB33.9090104@redhat.com>
References: <20130912141856.GA17640@jak-x230> <1378997643.28638.53.camel@hp-a6734f>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Julian Andres Klode <jak@jak-linux.org>, linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3ILPSP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 11:18:15 -0400
In-Reply-To: <1378997643.28638.53.camel@hp-a6734f>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/12/13 9:54 AM, Calvin Walton wrote:
> On Thu, 2013-09-12 at 16:18 +0200, Julian Andres Klode wrote:
>> Hi,
>>
>> I installed my new laptop on Saturday and setup an ext4 filesystem
>> on my / and /home partitions. Without me doing much file transfers,
>> I noticed today:
>>
>> jak@jak-x230:~$ cat /sys/fs/ext4/sdb3/lifetime_write_kbytes 
>> 342614039
>>
>> This is on a 100GB partition. I used fstrim multiple times. I analysed
>> the increase over some time today and issued an fstrim in between:
> <snip>
>> So it seems that ext4 counts the trims as writes? I don't know how I could
>> get 300GB of writes on a 100GB partition -- of which only 8 GB are occupied
>> -- otherwise.
> 
> The way fstrim works is that it allocates a temporary file that fills
> almost the entire free space on the partition.

No, that's not correct.

> I believe it does this
> with fallocate in order to ensure that space for the file is actually
> reserved on disc (but it does not get written to!). It then looks up
> where on disc the file's reserved space is, and sends a trim command to
> the drive to free that space. Afterwards, it deletes the temporary file.

Nope.  ;)  strace it and see, it does nothing like this - it calls a special
ioctl to ask the fs to find and issue discards on unused blocks.

# strace -e open,write,fallocate,unlink,ioctl  fstrim mnt/
open("/etc/ld.so.cache", O_RDONLY)      = 3
open("/lib64/libc.so.6", O_RDONLY)      = 3
open("/usr/lib/locale/locale-archive", O_RDONLY) = 3
open("mnt/", O_RDONLY)                  = 3
ioctl(3, 0xc0185879, 0x7fff6ac47d40)    = 0  <=== FITRIM ioctl

(old hdparm discard might have done what you say, but that was a hack).

> So what you are seeing means means that it's probably just an issue with
> the write accounting, where the blocks reserved by the fallocate are
> counted as writes.

I also think that it is just accounting, and probably just an error,
which seems to be fixed by now - what kernel are you running?

When you report it in ext4, it calculates it like this:

        return snprintf(buf, PAGE_SIZE, "%llu\n",
                        (unsigned long long)(sbi->s_kbytes_written +
                        ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
                          EXT4_SB(sb)->s_sectors_written_start) >> 1)));

so it counts partition stats in the mix (outside of ext4's accounting)

On io completion, we add the bytes "completed" (blk_account_io_completion())

And it sounds like it's counting trim/discard completions in the mix.

does /proc/diskstats show a jump for your partition after an fstrim as well?



But what kernel are you running?  I don't see it on a 3.11 kernel:

After a fresh mkfs I'm at:
[root@bp-05 tmp]# dumpe2fs -h fsfile  | grep Lifetime
dumpe2fs 1.41.12 (17-May-2010)
Lifetime writes:          8135 MB

and then several fstrims don't budge it:

[root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
8330683
[root@bp-05 tmp]# fstrim mnt/
[root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
8330683
[root@bp-05 tmp]# fstrim mnt/
[root@bp-05 tmp]# cat /sys/fs/ext4/loop0/lifetime_write_kbytes
8330683

-Eric
