From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: Some 64-bit tests
Date: Mon, 8 Jun 2009 12:00:13 -0700
Message-ID: <20090608190013.GB4363@fsbox>
References: <18887.1244469441@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZFHTAR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2009 15:00:17 -0400
Content-Disposition: inline
In-Reply-To: <18887.1244469441@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 08, 2009 at 09:57:21AM -0400, Nick Dokos wrote:
> I built and ran e2fsprogs bits from the pu branch from last week
> (not including the changes that you made yesterday.)
> 
> The basic cycle of mkfs/fill up the fs/fsck seemed to work without
> fatal errors but there are several problematic points.

That's great news!  Thanks.

> The mkfs looked like this:
> 
> ,----
> | $ sudo time mke2fs -q -t ext4 -O ^resize_inode -E stride=32,stripe-width=512 /dev/mapper/bigvg-bigvol
> | 64.02user 722.30system 13:14.25elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
> | 1240inputs+1026586096outputs (6major+317202minor)pagefaults 0swaps
> `----
> 
> I then ran the Lustre test that Andreas posted:
> 
> ,----
> | $ sudo time ~/src/tools/lustre/liverfs -l -r -w /mnt
> | Timestamp: 1243984976
> | -- 0:bash -- time-stamp -- Jun/02/09 19:24:49 --
> | -- 0:bash -- time-stamp -- Jun/03/09  9:42:50 --
> | write File name: /mnt/dir00240/file020          
> | write complete
> | 
> | liverfs: writing /mnt/liverfs.filecount failed :No space left on device
> | -- 0:bash -- time-stamp -- Jun/03/09  9:44:41 --
> | -- 0:bash -- time-stamp -- Jun/03/09 12:11:14 --
> | 
> | -- 0:bash -- time-stamp -- Jun/03/09 12:13:10 --
> | -- 0:bash -- time-stamp -- Jun/04/09  2:39:01 --
> | 374.48user 87720.31system 31:16:05elapsed 78%CPU (0avgtext+0avgdata 0maxresident)k
> | 64604538992inputs+64670728952outputs (3major+460minor)pagefaults 0swaps
> `----
> 
> roughly 14 hours to write and 17 hours to read everything back (the
> ENOSPC error message is an artifact of the program and does not affect
> the rest of the run). liverfs performs some consistency checking on the
> contents of the files, so the fact that it did not find anything wrong
> is encouraging.
> 
> It created 241 directories, each with 32 4GiB files in it (except the last
> one, which had 20 files). That comes out to about 30TiB which is OK.
> 
> The fsck looks like this:
> 
> ,----
> | root@shifter:~/src/tests/2009/06-03# e2fsck -t -t -n -f /dev/mapper/bigvg-bigvol
> | e2fsck 1.41.6 (30-May-2009)
> | Pass 1: Checking inodes, blocks, and sizes
> | Pass 1: Memory used: 31180k/18014398507629424k (31004k/177k), time: 384.17/294.25/ 2.24
> | Pass 1: I/O read: 63MB, write: 0MB, rate: 0.16MB/s
> | Pass 2: Checking directory structure
> | Pass 2: Memory used: 31180k/18014398508200200k (30993k/188k), time:  1.00/ 0.40/ 0.49
> | Pass 2: I/O read: 1MB, write: 0MB, rate: 1.00MB/s
> | Pass 3: Checking directory connectivity
> | Peak memory: Memory used: 31180k/18014398508450540k (30993k/188k), time: 389.75/298.39/ 3.52
> | Pass 3: Memory used: 31180k/18014398508200200k (30993k/188k), time:  0.28/ 0.12/ 0.16
> | Pass 3: I/O read: 1MB, write: 0MB, rate: 3.53MB/s
> | Pass 4: Checking reference counts
> | Pass 4: Memory used: 31180k/1520628k (30993k/188k), time: 70.32/70.17/ 0.13
> | Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
> | Pass 5: Checking group summary information
> | Pass 5: Memory used: 31212k/1270288k (30993k/220k), time: 409.82/270.69/ 5.29
> | Pass 5: I/O read: 979MB, write: 0MB, rate: 2.39MB/s
> | /dev/mapper/bigvg-bigvol: 7954/2050768896 files (0.0% non-contiguous), 8203066502/8203075584 blocks
> | Memory used: 31212k/1270288k (30993k/220k), time: 869.92/639.26/ 8.96
> | I/O read: 1058MB, write: 0MB, rate: 1.22MB/s
> | 
> | real	14m31.299s
> | user	10m39.257s
> | sys	0m10.336s
> `----
> 
> The "-t -t" part of the reporting may be truncating large quantities,
> and the "peaK" and "pass 3" memory seem bogus:
> 
>   Peak memory: Memory used: 31180k/18014398508450540k (30993k/188k), time: 389.75/298.39/ 3.52
>   Pass 3: Memory used: 31180k/18014398508200200k (30993k/188k), time:  0.28/ 0.12/ 0.16
> 
> The box has "only" 256GiB of memory and about 36GB of swap.

Part of this can be explained by overflow/wraparound/formatting bugs.
The bogus enormously large values look more like addresses than counters:

[val@fsbox ~]$ bc
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
obase=16
18014398507629424
3FFFFFFFE3BB70
18014398508200200
3FFFFFFFEC7108
18014398508450540
3FFFFFFFF042EC
18014398508200200
3FFFFFFFEC7108

> In addition, filefrag seems to have some problems. It reports
> that every file has about 512 extents (most of them exactly 512, but a
> few with less than that -- as little as 205 -- and a few more with more
> than that -- as much as 1155. Since the program is single threaded, and
> nothing else is happening on the file system, I (naively?) expected
> maximal extents allocated (iiuc, that's 128MiB - so I'd expect 32
> extents for most of the files).

Eric Sandeen (cc'd) is who I usually send ext4 file fragmentation
problems to.  In my experience, ext4 never allocates just one extent
for a file, but always exactly 512 sounds interesting.  Eric?

> filefrag -v has problems:
> 
> # filefrag -v file010
> Filesystem type is: ef53
> File size of file010 is 4294967296 (1048576 blocks, blocksize 4096)
>  ext logical  physical  expected length flags
>    0       0  40931328             2048 
>    1    2048  40951808  40933375   2048 
>    2    4096  40970240  40953855   2048 
>    3    6144  40988672  40972287   2048 
>    4    8192  41007104  40990719   2048 
>    5   10240  41027584  41009151   2048 
>  ...   .....  ........  ........   ....
> 
>  217 1034240  49362944  49348607   2048 
>  218 1036288  49379328  49364991   2048 
>  219 1038336  49397760  49381375   2048 
>  220 1040384  49414144  49399807   2048 
>  221 1042432  49430528  49416191   2048 
>  222 1044480  49446912  49432575   2048 
>  223 1046528  49463296  49448959   2048 eof
> file010: 224 extents found
> 
> # filefrag file010
> file010: 512 extents found

That ought to help a lot narrowing down the bug.

Thanks,

-VAL
