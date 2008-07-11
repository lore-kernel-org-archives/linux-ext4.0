From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: suspiciously good fsck times?
Date: Fri, 11 Jul 2008 11:39:48 -0400
Message-ID: <48777EC4.70504@redhat.com>
References: <20080710172829.GF10402@mit.edu> <20080710175354.GA3447@mit.edu>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbYGKPjz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2008 11:39:55 -0400
In-Reply-To: <20080710175354.GA3447@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Based on the graphs which Eric posted, One interesting thing I think
> you'll find if you repeat the ext3 experiment with e2fsck -t -t is
> that pass2 will be about seven times longer than pass1.  (Which is
> backwards from most e2fsck runs, where pass2 is about half pass 1's
> run time --- although obviously that depends on how many directory
> blocks you have.)
>
> Yes, some kind of reservation windows would help on ext3 --- but the
> question is whether such a change would be too-specific for this
> benchmark or not.  Most of the time directories don't grow to such a
> huge size.  So if you use a smallish (around 8 blocks, say) for many
> directories this might lead to more filesystem fragmentation that in
> the long run would cause the filesystem not to age well; it also
> wouldn't help much when you have over 11 million files in the
> directory, and a directory with over 100,000 blocks.
>
> I don't think delayed allocation is what's helping here either,
> because the journal will force the directory blocks to be placed as
> soon as we commit a transaction.  I think what's saving us here is
> that flex_bg and mballoc is separating the directory blocks from the
> data blocks, allowng the directory blocks to be closely packed
> together.
>
> 					- Ted
>   

I made a new ext4 file system without flex_bg or uninit:[

root@localhost Perf]# /sbin/debuge4fs /dev/sdb1
debuge4fs 1.41-WIP (07-Jul-2008)
debuge4fs:  feature
Filesystem features: has_journal ext_attr resize_inode dir_index 
filetype extent sparse_super large_file


The fsck time was a bit slower, but still looks like 8 minutes on ext4 
vs 1 hour on ext3:

[root@localhost Perf]# umount /mnt
[root@localhost Perf]# time /sbin/fsck.ext4 -t -t -f /dev/sdb1
e4fsck 1.41-WIP (07-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 43944k/69424k (36476k/7469k), time: 352.48/93.27/29.45
Pass 1: I/O read: 14914MB, write: 0MB, rate: 42.31MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 71396k/61968k (51854k/19543k), time: 73.00/50.46/ 7.65
Pass 2: I/O read: 3023MB, write: 0MB, rate: 41.41MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 71396k/61968k (59307k/12090k), time: 
425.82/143.83/37.10
Pass 3A: Memory used: 71396k/61968k (59307k/12090k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 71396k/61968k (51854k/19543k), time:  0.01/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 76.91MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 71396k/44968k (27406k/43991k), time:  2.37/ 2.36/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 71396k/240k (64671k/6726k), time: 63.60/ 4.98/ 0.33
Pass 5: I/O read: 37MB, write: 0MB, rate: 0.58MB/s
/dev/sdb1: 45600268/61054976 files (0.0% non-contiguous), 
232657587/244190000 blocks
Memory used: 71396k/240k (64671k/6726k), time: 491.82/151.17/37.43
I/O read: 17974MB, write: 1MB, rate: 36.55MB/s

real    8m12.260s
user    2m31.167s
sys     0m37.766s

