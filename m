From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Tue, 25 Aug 2009 14:21:35 -0400
Message-ID: <4A942BAF.9020904@redhat.com>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int> <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbZHYSWD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 14:22:03 -0400
In-Reply-To: <20090825175247.GX5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 01:52 PM, Andreas Dilger wrote:
> On Aug 24, 2009  20:15 -0400, Theodore Ts'o wrote:
>> On Mon, Aug 24, 2009 at 05:43:36PM -0600, Andreas Dilger wrote:
>>> Without transaction checksums waiting on all of the blocks together
>>> is NOT safe.  If the commit record is on disk, but the rest of the
>>> transaction's blocks are not then during replay it may cause garbage
>>> to be written from the journal into the filesystem metadata.
>>
>> That's the one optimization we using journal checksums buys us.
>> Unfortunately it does not allow us to omit the barrier
>> operation.... and have real-world testing experience that without the
>> barrier, a power drop can cause significant filesystem corruption and
>> potential data loss.
>>
>> Try using Chris Mason's torture-test workload with async-checksums
>> without this patch; you will get data corruption if you try dropping
>> power while his torture-test is running.  I know you really don't like
>> the barrier, but I'm afraid it's not safe to run without it, even with
>> journal checksums.
>
> In our performance testing of barriers (not with Chris' program), it
> was FAR better to disable the disk cache and wait for IO completion
> (i.e. barriers disabled) on just the journal blocks than to enable the
> cache and cause a cache flush for each "barrier".  The problem is that at
> high IO rates there is much more data in the cache vs. the actual journal
> blocks, and forcing the whole cache to be flushed each transaction commit
> hurt our performance noticably.
>
> Cheers, Andreas


Just for completeness, I ran a quick test on ext3 which was marginally better 
with barriers and xfs which was much better with barriers...

EXT3:

[root@ricdesktop ~]# mkfs.ext3 /dev/sdb
<snip>
[root@ricdesktop ~]# hdparm -W0 /dev/sdb

/dev/sdb:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
[root@ricdesktop ~]# mount -o barrier=0 /dev/sdb /mnt/
[root@ricdesktop ~]# rm -f /mnt/bigfile
[root@ricdesktop ~]# dd if=/dev/zero of=/mnt/bigfile bs=10M count=100
100+0 records in
100+0 records out
1048576000 bytes (1.0 GB) copied, 9.26707 s, 113 MB/s
[root@ricdesktop ~]# umount /mnt
[root@ricdesktop ~]# hdparm -W1 /dev/sdb

/dev/sdb:
  setting drive write-caching to 1 (on)
  write-caching =  1 (on)
[root@ricdesktop ~]# mount -o barrier=1 /dev/sdb /mnt/
[root@ricdesktop ~]# rm -f /mnt/bigfile
[root@ricdesktop ~]# dd if=/dev/zero of=/mnt/bigfile bs=10M count=100
100+0 records in
100+0 records out
1048576000 bytes (1.0 GB) copied, 8.90897 s, 118 MB/s
[root@ricdesktop ~]# umount /mnt

XFS:

[root@ricdesktop ~]# umount /mnt
[root@ricdesktop ~]# mkfs.xfs -f /dev/sdb
<snip>
[root@ricdesktop ~]# hdparm -W0 /dev/sdb

/dev/sdb:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
[root@ricdesktop ~]# mount -o nobarrier /dev/sdb /mnt
[root@ricdesktop ~]# rm -f /mnt/bigfile
[root@ricdesktop ~]# dd if=/dev/zero of=/mnt/bigfile bs=10M count=100
100+0 records in
100+0 records out
1048576000 bytes (1.0 GB) copied, 4.04406 s, 259 MB/s
[root@ricdesktop ~]# umount /mnt
[root@ricdesktop ~]# hdparm -W1 /dev/sdb

/dev/sdb:
  setting drive write-caching to 1 (on)
  write-caching =  1 (on)
[root@ricdesktop ~]# mount -o barrier /dev/sdb /mnt
[root@ricdesktop ~]# rm -f /mnt/bigfile
[root@ricdesktop ~]# dd if=/dev/zero of=/mnt/bigfile bs=10M count=100
100+0 records in
100+0 records out
1048576000 bytes (1.0 GB) copied, 3.03633 s, 345 MB/s


