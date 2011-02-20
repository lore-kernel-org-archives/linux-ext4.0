From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: fsck performance.
Date: Sun, 20 Feb 2011 10:06:56 +0100
Message-ID: <20110220090656.GA11402@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:49048 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752084Ab1BTJNj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 04:13:39 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I was running debian-stable, on my backup-server (the server that
does backups, not the "just-in-case" server). 

Debian apparently recently pointed that to the new release squeeze, so
I got upgraded. I went from kernel 2.6.26 to 2.6.32. After about a day
my system rebooted without my consent. So now it's running 2.6.32.

Since then I'm getting kernel-oops-lookalikes that start with:
[71664.306573] swapper: page allocation failure. order:5, mode:0x4020

Lots of them actually. 

(on the other hand, none of these happened before my filesystem got
thrashed...)



Anyway, upon boot into the new kernel ext3 printed abunch of these: 
[    5.212119] ext3_orphan_cleanup: deleting unreferenced inode 1335743

A few hours later, my storage partition was marked read-only and the
backups started failing.

kern.log.1.gz:Feb 18 05:39:53 driepoot kernel: [10328.424778] 
  EXT3-fs error (device md3): ext3_lookup: deleted inode referenced: 277447722

So to correct the situation I started an fsck. 

After about 24 hours, I decided that the fsck was taking too long and
decided to upgrade e2fsck. It has now been running for an hour and a
half. Now I don't mind fsck taking an hour or two. But I expect fsck
to be disk bound.

However iostat shows me it's doing next to nothing for seconds
at a time: 

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
md3               0.00         0.00         0.00          0          0
md3               0.00         0.00         0.00          0          0
md3               0.00         0.00         0.00          0          0
md3             733.33      2933.33         0.00       2904          0
md3               0.00         0.00         0.00          0          0
md3              63.37       253.47         0.00        256          0
md3               0.00         0.00         0.00          0          0
md3               0.00         0.00         0.00          0          0
md3               5.88        23.53         0.00         24          0

and it turns out that fsck is completely CPU bound: 


top - 09:26:29 up 2 days,  6:38, 10 users,  load average: 1.06, 1.07, 1.27
Tasks: 136 total,   2 running, 134 sleeping,   0 stopped,   0 zombie
Cpu(s): 79.1%us,  4.9%sy,  0.0%ni,  0.0%id,  0.4%wa,  1.5%hi, 14.1%si,  0.0%st
Mem:    969400k total,   956624k used,    12776k free,   226828k buffers
Swap:  1975976k total,   252220k used,  1723756k free,    67768k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
10274 root      20   0  839m 631m  52m R 97.7 66.7  50:07.09 e2fsck 

and when I trace fsck I get: 


fcntl64(6, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0
fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=164, len=1}) = 0
fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=264, len=1}) = 0
fcntl64(5, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=572, len=1}) = 0
fcntl64(5, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0
fcntl64(5, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=164, len=1}) = 0
fcntl64(5, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=572, len=1}) = 0
fcntl64(6, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=572, len=1}) = 0
fcntl64(6, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0

So, my question is: Are these fcntl calls neccesary? 
As far as I know locking is neccesary if another process might be 
handling the same data. Here is is doing this with the cache 
files: 

lrwx------ 1 root root 64 Feb 20 09:28 5 -> 
       /var/cache/e2fsck/123a1cfe-2455-4646-aa32-87492ed1ac97-icount-ayxVou
lrwx------ 1 root root 64 Feb 20 09:28 6 -> 
       /var/cache/e2fsck/123a1cfe-2455-4646-aa32-87492ed1ac97-dirinfo-rBBTtb

were, using these swap files makes sense as some machines don't have
the memory and/or addressingspace to handle a big fsck, but in my
case I have 1G RAM, and these two files are 56M total: 
-rw------- 1 root root 21M Feb 20 09:30 ...97-dirinfo-rBBTtb
-rw------- 1 root root 35M Feb 20 09:30 ...97-icount-ayxVou

# strace -p 10274 | & head -100000 | sort | uniq -c | sort -n

shows me that out of 100k system calls 

  10876 fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=164, len=1}) = 0
  10877 fcntl64(6, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0
  13339 fcntl64(5, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=164, len=1}) = 0
  13339 fcntl64(5, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=164, len=1}) = 0

and 60-139 locks for different locations.

Oh... and fsck is now at the stage: 
 Pass 1: Checking inodes, blocks, and sizes

The filesystem is 3T: 
md3 : active raid5 sda3[0] sdd3[3] sdc3[2] sdb3[1]
      2868686592 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

I'm studying e2fsck source code abit, but I don't yet see where the
fcntl calls are coming from.

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
