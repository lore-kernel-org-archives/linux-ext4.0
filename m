From: Viji V Nair <viji@fedoraproject.org>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 18:44:40 +0530
Message-ID: <84c89ac10910180614l5d2d476ehb91d210820761039@mail.gmail.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
	 <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	 <20091018114100.GA26721@eagle102.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Matija Nalis <mnalis-ml@voyager.hr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:50941 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZJRNOg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 09:14:36 -0400
Received: by pxi1 with SMTP id 1so602343pxi.33
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 06:14:40 -0700 (PDT)
In-Reply-To: <20091018114100.GA26721@eagle102.home.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 18, 2009 at 5:11 PM, Matija Nalis <mnalis-ml@voyager.hr> wrote:
> On Sun, Oct 18, 2009 at 03:01:46PM +0530, Viji V Nair wrote:
>> The application which we are using are modified versions of mapnik and
>> tilecache, these are single threaded so we are running 4 process at a
>
> How does it scale if you reduce the number or processes - especially if you
> run just one of those ? As this is just a single disk, 4 simultaneous
> readers/writers would probably *totally* kill it with seeks.
>
> I suspect it might even run faster with just 1 process then with 4 of
> them...

with one process it is giving me 6 seconds

>
>> time. We can say only four images are created at a single point of
>> time. Some times a single image is taking around 20 sec to create. I
>
> is that 20 secs just the write time for an precomputed file of 10k ?
> Or does it also include reading and processing and writing ?

this include processing and writing

>
>> can see lots of system resources are free, memory, processors etc
>> (these are 4G, 2 x 5420 XEON)
>
> I do not see how the "lots of memory" could be free, especially with such a
> large number of inodes. dentry and inode cache alone should consume those
> pretty fast as the number of files grow, not to mention (dirty and
> otherwise) buffers...

[root test ~]# free
             total       used       free     shared    buffers     cached
Mem:       4011956    3100900     911056          0     550576    1663656
-/+ buffers/cache:     886668    3125288
Swap:      4095992          0    4095992

[root test ~]# cat /proc/meminfo
MemTotal:        4011956 kB
MemFree:          907968 kB
Buffers:          550016 kB
Cached:          1668984 kB
SwapCached:            0 kB
Active:          1084492 kB
Inactive:        1154608 kB
Active(anon):       5100 kB
Inactive(anon):    15148 kB
Active(file):    1079392 kB
Inactive(file):  1139460 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4095992 kB
SwapFree:        4095992 kB
Dirty:              7088 kB
Writeback:             0 kB
AnonPages:         19908 kB
Mapped:             6476 kB
Slab:             813968 kB
SReclaimable:     796868 kB
SUnreclaim:        17100 kB
PageTables:         4376 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6101968 kB
Committed_AS:      99748 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      290308 kB
VmallocChunk:   34359432003 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8192 kB
DirectMap2M:     4182016 kB


>
> You may want to tune following sysctls to allow more stuff to remain in
> write-back cache (but then again, you will probably need more memory):
>
> vm.vfs_cache_pressure
> vm.dirty_writeback_centisecs
> vm.dirty_expire_centisecs
> vm.dirty_background_ratio
> vm.dirty_ratio
>

I will give a try.

>
>> The file system is crated with "-i 1024 -b 1024" for larger inode
>> number, 50% of the total images are less than 10KB. I have disabled
>> access time and given a large value to the commit also. Do you have
>> any other recommendation of the file system creation?
>
> for ext3, larger journal on external journal device (if that is an option)
> should probably help, as it would reduce some of the seeks which are most
> probably slowing this down immensely.
>
>
> If you can modify hardware setup, RAID10 (better with many smaller disks
> than with fewer bigger ones) should help *very* much. Flash-disk-thingies of
> appropriate size are even better option (as the seek issues are few orders
> of magnitude smaller problem). Also probably more RAM (unless you full
> dataset is much smaller than 2 GB, which I doubt).
>
> On the other hand, have you tried testing some other filesystems ?
> I've had much better performance with lots of small files of XFS (but that
> was on big RAID5, so YMMV), for example.
>
> --
> Opinions above are GNU-copylefted.
>

I have not tried XFS, but tried reiserfs. I could not see a large
difference when compared with mkfs.ext4 -T small. I could see that
reiser is giving better performance on overwrite, not on new writes.
some times we overwrite existing image with new ones.

Now the total files are 50Million, soon (with in an year) it will grow
to 1 Billion. I know that we should move ahead with the hardware
upgrades, also files system access is a large concern for us. There
images are accessed over the internet and expecting a 100 million
visits every month. For each user we need to transfer at least 3Mb of
data.
