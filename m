From: Andreas Dilger <adilger@sun.com>
Subject: Re: streaming read and write - test results
Date: Mon, 23 Jun 2008 16:20:50 -0600
Message-ID: <20080623222050.GC6239@webber.adilger.int>
References: <4278.1214242602@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50601 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYFWWUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 18:20:54 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5NMKr17021260
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 15:20:53 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2X00401S44F800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 23 Jun 2008 15:20:53 -0700 (PDT)
In-reply-to: <4278.1214242602@alphaville.zko.hp.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 23, 2008  13:36 -0400, Nick Dokos wrote:
> o 8 MSA1000 RAID controllers, each with four back-end SCSI busses, each
> bus with 7 300GB 15K disks. Only one bus on each controller is used for
> the tests below (the rest are going to be used for larger filesystem
> testing). The 7 disks are striped ("horizontally" @ 128KB stripe size) at
> the hardware level and exported as a single 2TB LUN (that's the current
> hardware LUN size limit).
> 
> o the 8 LUNs are striped ("vertically" @ 128KB also) at the LVM level to
> produce a 16TB logical volume.

With 56 disks, I'd expect on the order of 2.5GB/s of throughput...

> o the test used was aiod (http://sourceforge.net/projects/aiod/) with the
>   following command line:
> 
>   aiod -S -B -b4M -I -v -w 3500000 -W|-R
> 
>   (aiod uses AIO by default, but reverts back to ordinary read/write with -S
>   - note that the documentation calls this "sync-io" but that's a
>   misnomer: there is nothing synchronous about it, it just means non-AIO;
>   aiod uses directIO by default, but reverts to buffered IO with -B;
>   -b4M makes aiod issue 4MB IOs and -w <N> makes it issue that many IOs.)
> 
>   The test first sequentially writes a ~14TB (4MB*3500000) file,
>   unmounts the fs, remounts it and then sequentially reads the file back.

At a guess you are consuming a lot of CPU in copy_from_user() because of
buffered IO instead of directIO.  Is this a single-threaded write test?
In that case it is almost impossible to copy data fast enough from userspace
to saturate the back-end storage.

> top - 15:07:20 up 2 days, 20:08,  0 users,  load average: 1.12, 1.38, 1.33
> Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.0%us, 13.1%sy,  0.0%ni, 84.8%id,  0.6%wa,  0.2%hi,  1.2%si,  0.0%st
> Mem:  66114888k total, 66005660k used,   109228k free,     4196k buffers
> Swap:  2040212k total,     3884k used,  2036328k free, 19773724k cached
> 
>     PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND          
>   80046 root      20   0 18808 4796  564 S   86  0.0 186:21.78 aiod             
>     391 root      15  -5     0    0    0 S   10  0.0 196:19.05 kswapd1          

So this is pretty much pegging the single CPU, leaving 7 virtually idle...
If you enable the per-CPU top output (number '1') this would be clear,
instead of the misleading "13.15 system, 84.8% idle" shown above.

Try running 8 threads and measure the aggregate throughput.  IOZONE will
do this, if aiod won't.

> PS. One additional tidbit: I ran fsck on the ext4 filesystem - it took about an
> hour and a half (I presume uninit_bg would speed that up substantially since
> there are only a handful of inodes in use). But I got an interesting question
> from it:
> 
>     # time fsck.ext4 /dev/mapper/bigvg-bigvol
>     e2fsck 1.41-WIP (17-Jun-2008)
>     /dev/mapper/bigvg-bigvol primary superblock features different from backup, check forced.
>     Pass 1: Checking inodes, blocks, and sizes
>     Inode 49153, i_size is 14680064000000, should be 14680064000000.  Fix<y>? y
>     yes

This is interesting.  Can you add debugging to e2fsck to see what "bad_size"
is being used?  I'm guessing it is just overflowing the ext2_max_sizes[]
array, and isn't taking the HUGE_FILE flag into account.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

