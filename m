From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 1 Mar 2010 10:07:34 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003011002240.26228@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan> <20100228054240.GE14646@thunk.org> <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
 <832C6227-BF34-43C2-8768-1308C00AB17F@sun.com> <alpine.DEB.2.00.1003010419090.20072@p34.internal.lan> <4B8BD3B0.3020502@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Andreas Dilger <adilger@sun.com>, tytso@mit.edu,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:54534 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0CAPHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 10:07:35 -0500
In-Reply-To: <4B8BD3B0.3020502@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 1 Mar 2010, Michael Tokarev wrote:

> Justin Piszcz wrote:
>>
>> On Mon, 1 Mar 2010, Andreas Dilger wrote:
>>
>>> On 2010-02-28, at 07:55, Justin Piszcz wrote:
>>>> === CREATE RAID-0 WITH 11 DISKS
>>>
>>> Have you tried testing with "nice" numbers of disks in your RAID set
>>> (e.g. 8 disks for RAID-0, 9 for RAID-5, 10 for RAID-6)?  The mballoc
>>> code is really much better tuned for power-of-two sized allocations.
>>
>> Hi,
>>
>> Yes, the second system (RAID-5) has 8 disks and it shows the same
>> performance problems with ext4 and not XFS (as shown from previous
>> e-mail), where XFS usually got 500-600MiB/s for writes.
>>
>> http://groups.google.com/group/linux.kernel/browse_thread/thread/e7b189bcaa2c1cb4/ad6c2a54b678cf5f?show_docid=ad6c2a54b678cf5f&pli=1
>>
>>
>> For the RAID-5 (from earlier testing):  <- This one has 8 disks.
>
> Note that for RAID-5, the "nice" number of disks is 9 as Andreas
> said, not 8 as in your example.
>
> /mjt
>

Hi, thanks for this.

RAID-0 with 12 disks:

p63:~# mdadm --create -e 0.90 /dev/md0 /dev/sd[b-m]1 --level=0 -n 12 -c 64
mdadm: /dev/sdb1 appears to contain an ext2fs file system
     size=1077256000K  mtime=Sun Feb 28 08:35:47 2010
mdadm: /dev/sdb1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdd1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdf1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdg1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdh1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdi1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdj1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdk1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdl1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 08:11:10 2010
mdadm: /dev/sdm1 appears to be part of a raid array:
     level=raid6 devices=11 ctime=Sat Feb 27 06:57:29 2010
Continue creating array? y
mdadm: array /dev/md0 started.
p63:~# mkfs.ext4 /dev/md0
mke2fs 1.41.10 (10-Feb-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
366288896 inodes, 1465151808 blocks
73257590 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
44713 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544

Writing inode tables: 28936/44713..etc

p63:~# mount -o nobarrier /dev/md0 /r1
p63:~# cd /r1
p63:/r1# dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 34.9723 s, 307 MB/s
p63:/r1#

Same issue for EXT4, with XFS, it gets faster:

p63:~# mkfs.xfs /dev/md0 -f
meta-data=/dev/md0               isize=256    agcount=32, agsize=45786000 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1465151808, imaxpct=5
          =                       sunit=16     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mount /dev/md0 /r1
p63:~# mount /dev/md0 /r1
p63:~# cd /r1
p63:/r1# dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 17.6473 s, 608 MB/s
p63:/r1#

Justin.




