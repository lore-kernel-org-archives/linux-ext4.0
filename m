Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C445223DE9;
	Thu, 29 May 2025 12:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748521467; cv=none; b=EjGn+s/GT3AkpDU6I+P33k6t1Yl3N5MhxsrHb0OK2wp7TINog/O32EAzpLYL9LVZ38bbjbV3b4nuIMUUUMxXuSSySMSUj7tZOm5iX5hBMbGkvX4QkP0KyX++EJapOSIEJTyfoeAeuTG717rYeLWklXfjabHPGTQPbMfaDbju6Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748521467; c=relaxed/simple;
	bh=HV/NYi6+0fgZ/GhUDaDJrWy55jTF5YKF1SfTHDfhzv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=V0X6rPfvYwFJLPZJpRrxWjMlcHk1Gfrw7rtT+BAM5AwiIJTYIcd/vQ/JQEW7eDde92aKTYBE8vuQlSQa9iYsq+l/yap5BvdUiRJMWeRMjzOAu4DDjKbnKSOm/Ahta+xbPkBPtEVzhEcZHvnz0bDfC4zpvHRpKuQx8SgsE51arW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4b7QWP01rYz2RVqs;
	Thu, 29 May 2025 20:23:12 +0800 (CST)
Received: from kwepemg500008.china.huawei.com (unknown [7.202.181.45])
	by mail.maildlp.com (Postfix) with ESMTPS id B99BE1401F0;
	Thu, 29 May 2025 20:24:15 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.71) by kwepemg500008.china.huawei.com
 (7.202.181.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 29 May
 2025 20:24:14 +0800
Message-ID: <f21507f9-ebc6-43ce-97c4-cd055c53747e@huawei.com>
Date: Thu, 29 May 2025 20:24:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] ext4: better scalability for ext4 block allocation
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<jack@suse.cz>, <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <libaokun@huaweicloud.com>, Baokun Li
	<libaokun1@huawei.com>
References: <20250523085821.1329392-1-libaokun@huaweicloud.com>
 <aDchmYDc_OOAu2yC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <aDchmYDc_OOAu2yC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemg500008.china.huawei.com (7.202.181.45)

On 2025/5/28 22:53, Ojaswin Mujoo wrote:
> On Fri, May 23, 2025 at 04:58:17PM +0800, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> Since servers have more and more CPUs, and we're running more containers
>> on them, we've been using will-it-scale to test how well ext4 scales. The
>> fallocate2 test (append 8KB to 1MB, truncate to 0, repeat) run concurrently
>> on 64 containers revealed significant contention in block allocation/free,
>> leading to much lower aggregate fallocate OPS compared to a single
>> container (see below).
>>
>>     1   |    2   |    4   |    8   |   16   |   32   |   64
>> -------|--------|--------|--------|--------|--------|-------
>> 295287 | 70665  | 33865  | 19387  | 10104  |  5588  |  3588
>>
>> The main bottleneck was the ext4_lock_group(), which both block allocation
>> and free fought over. While the block group for block free is fixed and
>> unoptimizable, the block group for allocation is selectable. Consequently,
>> the ext4_try_lock_group() helper function was added to avoid contention on
>> busy groups, and you can see more in Patch 1.
>>
>> After we fixed the ext4_lock_group bottleneck, another one showed up:
>> s_md_lock. This lock protects different data when allocating and freeing
>> blocks. We got rid of the s_md_lock call in block allocation by making
>> stream allocation work per inode instead of globally. You can find more
>> details in Patch 2.
>>
>> Patches 3 and 4 are just some minor cleanups.
>>
>> Performance test data follows:
>>
>> CPU: HUAWEI Kunpeng 920
>> Memory: 480GB
>> Disk: 480GB SSD SATA 3.2
>> Test: Running will-it-scale/fallocate2 on 64 CPU-bound containers.
>>   Observation: Average fallocate operations per container per second.
>> |--------|--------|--------|--------|--------|--------|--------|--------|
>> |    -   |    1   |    2   |    4   |    8   |   16   |   32   |   64   |
>> |--------|--------|--------|--------|--------|--------|--------|--------|
>> |  base  | 295287 | 70665  | 33865  | 19387  | 10104  |  5588  |  3588  |
>> |--------|--------|--------|--------|--------|--------|--------|--------|
>> | linear | 286328 | 123102 | 119542 | 90653  | 60344  | 35302  | 23280  |
>> |        | -3.0%  | 74.20% | 252.9% | 367.5% | 497.2% | 531.6% | 548.7% |
>> |--------|--------|--------|--------|--------|--------|--------|--------|
>> |mb_optim| 292498 | 133305 | 103069 | 61727  | 29702  | 16845  | 10430  |
>> |ize_scan| -0.9%  | 88.64% | 204.3% | 218.3% | 193.9% | 201.4% | 190.6% |
>> |--------|--------|--------|--------|--------|--------|--------|--------|
> Hey Baokun, nice improvements! The proposed changes make sense to me,
> however I suspect the performance improvements may come at a cost of
> slight increase in fragmentation, which might affect rotational disks
> especially. Maybe comparing e2freefrag numbers with and without the
> patches might give a better insight into this.
While this approach might slightly increase free space fragmentation on
the disk, it significantly reduces file fragmentation, leading to faster
read speeds on rotational disks.

When multiple processes contend for free blocks within the same block
group, the probability of blocks allocated by the same process being
merged on consecutive allocations is low. This is because other processes
may preempt the free blocks immediately following the current process's
last allocated region.

Normally, we rely on preallocation to avoid files becoming overly
fragmented (even though preallocation itself can cause fragmentation in
free disk space). But since fallocate doesn't support preallocation, the
fragmentation issue is more pronounced. Counterintuitively, skipping busy
groups actually boosts opportunities for file extent merging, which in turn
reduces overall file fragmentation.

Referencing will-it-scale/fallocate2, I tested 64 processes each appending
4KB via fallocate to 64 separate files until they reached 1GB. This test
specifically examines contention in block allocation, unlike fallocate2,
it omits the contention between fallocate and truncate. Preliminary results
are provided below; detailed scripts and full test outcomes are attached in
the email footer.

----------------------------------------------------------
                      |       base      |      patched    |
---------------------|--------|--------|--------|--------|
mb_optimize_scan     | linear |opt_scan| linear |opt_scan|
---------------------|--------|--------|--------|--------|
bw(MiB/s)            | 217    | 219    | 5685   | 5670   |
Avg. free extent size| 1943732| 1943728| 1439608| 1368328|
Avg. extents per file| 261879 | 262039 | 744    | 2084   |
Avg. size per extent | 4      | 4      | 1408   | 503    |
Fragmentation score  | 100    | 100    | 2      | 6      |
----------------------------------------------------------
> Regardless the performance benefits are significant and I feel it is
> good to have these patches.
>
> I'll give my reviews individually as I'm still going through patch 2
> However, I wanted to check on a couple things:
Okay, thank you for your feedback.
>
> 1. I believe you ran these in docker. Would you have any script etc open
>     sourced that I can use to run some benchmarks on my end (and also
> 	 understand your test setup).
Yes, these two patches primarily mitigate contention between block
allocations and between block allocation and release. The testing script
can be referenced from the fio script mentioned earlier in the email
footer. You can also add more truncate calls based on it.
> 2. I notice we are getting way less throughput in mb_optimize_scan? I
>     wonder why that is the case. Do you have some data on that? Are your
>     tests starting on an empty FS, maybe in that case linear scan works a
>     bit better since almost all groups are empty. If so, what are the
>     numbers like when we start with a fragmented FS?
The throughput of mb_optimize_scan is indeed much lower, and we continue
to optimize it, as mb_optimize_scan is the default mount option and
performs better in scenarios with large volume disks and high space usage.

Disk space used is about 7%; mb_optimize_scan should perform better with
less free space. However, this isn't the critical factor. The poor
throughput here is due to the following reasons。

One reason is that mb_optimize_scan's list traversal is unordered and
always selects the first group.

While traversing the list, holding a spin_lock prevents load_buddy, making
direct use of ext4_lock_group impossible. This can lead to a "bouncing"
scenario where spin_is_locked(grp_A) succeeds, but ext4_try_lock_group()
fails, forcing the list traversal to repeatedly restart from grp_A.

In contrast, linear traversal directly uses ext4_try_lock_group(),
avoiding this bouncing. Therefore, we need a lockless, ordered traversal
to achieve linear-like efficiency.

Another reason is that opt_scan tends to allocate from groups that have
just received freed blocks, causing it to constantly "jump around"
between certain groups.

This leads to intense contention between allocation and release, and even
between release events. In contrast, linear traversal always moves forward
without revisiting groups, resulting in less contention between allocation
and release.

However, because linear involves more groups in allocation, journal
becomes a bottleneck. If opt_scan first attempts to traverse block groups
to the right from the target group in all lists, and then from index 0 to
the left in all lists, competition between block groups would be
significantly reduced.

To enable ordered traversal, we attempted to convert list_head to an
ordered xarray. This ordering prevents "bouncing" during retries.
Additionally, traversing all right-side groups before left-side groups
significantly reduced contention. Performance improved from 10430 to 17730.

However, xarray traversal introduces overhead; list_head group selection
was O(1), while xarray becomes O(n log n). This results in a ~10%
performance drop in single-process scenarios, and I'm not entirely sure if
this trade-off is worthwhile. 🤔

Additionally, by attempting to merge before inserting in
ext4_mb_free_metadata(), we can eliminate contention on sbi->s_md_lock
during merges, resulting in roughly a 5% performance gain.
>
>     - Or maybe it is that the lazyinit thread has not yet initialized all
>     the buddies yet which means we have lesser BGs in the freefrag list
>     or the order list used by faster CRs. Hence, if they are locked we
>     are falling more to CR_GOAL_LEN_SLOW. To check if this is the case,
>     one hack is to cat /proc/fs/ext4/<disk>/mb_groups (or something along
>     the lines) before the benchmark, which forces init of all the group
>     buddies thus populating all the lists used by mb_opt_scan. Maybe we
>     can check if this gives better results.
All groups are already initialized at the time of testing, and that's not
where the problem lies.
>
> 3. Also, how much IO are we doing here, are we filling the whole FS?
>
In a single container, create a file, then repeatedly append 8KB using
fallocate until the file reaches 1MB. After that, truncate the file to
0 and continue appending 8KB with fallocate. The 64 containers will
occupy a maximum of 64MB of disk space in total, so they won't fill the
entire file system.


Cheers,
Baokun


======================== test script ========================

#!/bin/bash

dir="/tmp/test"
disk="/dev/sda"
numjobs=64
iodepth=128

mkdir -p $dir

for scan in 0 1 ; do
     mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0 -O 
orphan_file $disk
     mount -o mb_optimize_scan=$scan $disk $dir

     fio -directory=$dir -direct=1 -iodepth ${iodepth} -thread -rw=write 
-ioengine=falloc -bs=4k -fallocate=none \
         -size=1G -numjobs=${numjobs} -group_reporting -name=job1 
-cpus_allowed_policy=split -file_append=1

     e2freefrag $disk
     e4defrag -c $dir # ** NOTE ** Without the patch, this could take 
5-6 hours.
     filefrag ${dir}/job* | awk '{print $2}' | awk '{sum+=$1} END {print 
sum/NR}'
     umount $dir
done

======================== test results ========================

---------------------------------------------------------- ## base

------------------------### linear bw=217MiB/s (228MB/s)
------------ e2freefrag /dev/sda
Device: /dev/sda
Blocksize: 4096 bytes
Total blocks: 52428800
Free blocks: 34501259 (65.8%)

Min. free extent: 98172 KB
Max. free extent: 2064256 KB
Avg. free extent: 1943732 KB
Num. free extent: 71

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    64M...  128M-  :             2         49087    0.14%
   512M... 1024M-  :             3        646918    1.88%
     1G...    2G-  :            66      33805254   97.98%

------------ e4defrag -c /tmp/test
e4defrag 1.47.2 (1-Jan-2025)
<Fragmented files> now/best       size/ext
1. /tmp/test/job1.4.0                       262035/1 4 KB
2. /tmp/test/job1.2.0                       262034/1 4 KB
3. /tmp/test/job1.44.0                      262026/1 4 KB
4. /tmp/test/job1.15.0                      262025/1 4 KB
5. /tmp/test/job1.12.0                      262025/1 4 KB

  Total/best extents                             16760234/64
  Average size per extent                        4 KB
  Fragmentation score                            100
  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
  This directory (/tmp/test) needs defragmentation.
  Done.

------------ filefrag /tmp/test/job* | awk '{print $2}' | awk '{sum+=$1} 
END {print sum/NR}'
261879

------------------------### opt_scan  bw=219MiB/s (230MB/s)
------------ e2freefrag /dev/sda
Device: /dev/sda
Blocksize: 4096 bytes
Total blocks: 52428800
Free blocks: 34501238 (65.8%)

Min. free extent: 98172 KB
Max. free extent: 2064256 KB
Avg. free extent: 1943728 KB
Num. free extent: 71

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    64M...  128M-  :             2         49087    0.14%
   512M... 1024M-  :             3        646897    1.87%
     1G...    2G-  :            66      33805254   97.98%

------------ e4defrag -c /tmp/test
e4defrag 1.47.2 (1-Jan-2025)
<Fragmented files> now/best       size/ext
1. /tmp/test/job1.57.0                      262084/1 4 KB
2. /tmp/test/job1.35.0                      262081/1 4 KB
3. /tmp/test/job1.45.0                      262080/1 4 KB
4. /tmp/test/job1.25.0                      262078/1 4 KB
5. /tmp/test/job1.11.0                      262077/1 4 KB

  Total/best extents                             16770469/64
  Average size per extent                        4 KB
  Fragmentation score                            100
  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
  This directory (/tmp/test) needs defragmentation.
  Done.

------------ filefrag /tmp/test/job* | awk '{print $2}' | awk '{sum+=$1} 
END {print sum/NR}'
262039

==========================================================================================

---------------------------------------------------------- ## patched
------------------------ linear bw=5685MiB/s (5962MB/s)
------------ e2freefrag /dev/sda
Device: /dev/sda
Blocksize: 4096 bytes
Total blocks: 52428800
Free blocks: 34550601 (65.9%)

Min. free extent: 8832 KB
Max. free extent: 2064256 KB
Avg. free extent: 1439608 KB
Num. free extent: 96

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
     8M...   16M-  :             2          5267    0.02%
    32M...   64M-  :             9        129695    0.38%
    64M...  128M-  :            17        409917    1.19%
   512M... 1024M-  :             3        716532    2.07%
     1G...    2G-  :            65      33289190   96.35%

------------ e4defrag -c /tmp/test
e4defrag 1.47.2 (1-Jan-2025)
<Fragmented files> now/best       size/ext
1. /tmp/test/job1.18.0                         984/1 1065 KB
2. /tmp/test/job1.37.0                         981/1 1068 KB
3. /tmp/test/job1.36.0                         980/1 1069 KB
4. /tmp/test/job1.27.0                         954/1 1099 KB
5. /tmp/test/job1.30.0                         954/1 1099 KB

  Total/best extents                47629/64
  Average size per extent            1408 KB
  Fragmentation score                2
  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
  This directory (/tmp/test) does not need defragmentation.
  Done.

------------ filefrag /tmp/test/job* | awk '{print $2}' | awk '{sum+=$1} 
END {print sum/NR}'
744.203

------------------------ opt_scan  bw=5670MiB/s (5946MB/s)
------------ e2freefrag /dev/sda
Device: /dev/sda
Blocksize: 4096 bytes
Total blocks: 52428800
Free blocks: 34550296 (65.9%)

Min. free extent: 5452 KB
Max. free extent: 2064256 KB
Avg. free extent: 1368328 KB
Num. free extent: 101

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
     4M...    8M-  :             4          5935    0.02%
     8M...   16M-  :             3          9929    0.03%
    16M...   32M-  :             4         21775    0.06%
    32M...   64M-  :            13        164831    0.48%
    64M...  128M-  :             9        189227    0.55%
   512M... 1024M-  :             2        457702    1.32%
     1G...    2G-  :            66      33700897   97.54%

------------ e4defrag -c /tmp/test
e4defrag 1.47.2 (1-Jan-2025)
<Fragmented files> now/best       size/ext
1. /tmp/test/job1.43.0                        4539/1 231 KB
2. /tmp/test/job1.5.0                         4446/1 235 KB
3. /tmp/test/job1.14.0                        3851/1 272 KB
4. /tmp/test/job1.3.0                         3682/1 284 KB
5. /tmp/test/job1.50.0                        3597/1 291 KB

  Total/best extents                133415/64
  Average size per extent            503 KB
  Fragmentation score                6
  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
  This directory (/tmp/test) does not need defragmentation.
  Done.

------------ filefrag /tmp/test/job* | awk '{print $2}' | awk '{sum+=$1} 
END {print sum/NR}'
2084.61



