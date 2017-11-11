From: betacentauri@arcor.de
Subject: Re: Significant difference in 'file size' and 'disk usage' for
 single files
Date: Sat, 11 Nov 2017 13:14:10 +0100 (CET)
Message-ID: <2026906696.68008.1510402451094@mail.vodafone.de>
References: <25940a6a-a2e5-444f-9a74-0c1f91720868@clearskydata.com>
 <7e9c7d78-baa5-5680-2e33-b6c5db3590ef@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Martin <linux@clearskydata.com>, mfe555 <mfe555@web.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:52218 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752890AbdKKMOT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 11 Nov 2017 07:14:19 -0500
In-Reply-To: <7e9c7d78-baa5-5680-2e33-b6c5db3590ef@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi together,

I have same problem with bigalloc ext4 filesystem. 

It's not a cosmetic problem! The space really "disappears" and cannot be used until you umount and mount the filesystem again.

This shows the problem:

root@sf4008:/media# uname -a
Linux sf4008 4.1.37 #1 SMP Fri Nov 3 20:41:50 CET 2017 armv7l GNU/Linux
root@sf4008:/media# fsck.ext4 -f /dev/sda
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sda: 11/3872 files (0.0% non-contiguous), 16736/985856 blocks
root@sf4008:/media# mount /dev/sda /media/sda
root@sf4008:/media# cd sda/
root@sf4008:/media/sda# tune2fs -l /dev/sda
tune2fs 1.43.4 (31-Jan-2017)
Filesystem volume name: <none>
Last mounted on: /media/sda
Filesystem UUID: 34f67143-5a31-46c1-b5ea-98e1a72294a4
Filesystem magic number: 0xEF53
Filesystem revision #: 1 (dynamic)
Filesystem features: has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize bigalloc
Filesystem flags: unsigned_directory_hash 
Default mount options: user_xattr acl
Filesystem state: clean
Errors behavior: Continue
Filesystem OS type: Linux
Inode count: 3872
Block count: 985856
Reserved block count: 0
Free blocks: 969120
Free inodes: 3861
First block: 0
Block size: 4096
Cluster size: 65536
Reserved GDT blocks: 15
Blocks per group: 524288
Clusters per group: 32768
Inodes per group: 1936
Inode blocks per group: 121
Flex block group size: 16
Filesystem created: Thu Jan 1 01:28:53 1970
Last mount time: Sat Nov 11 11:51:00 2017
Last write time: Sat Nov 11 11:51:00 2017
Mount count: 1
Maximum mount count: -1
Last checked: Sat Nov 11 11:50:34 2017
Check interval: 0 (<none>)
Lifetime writes: 24 GB
Reserved blocks uid: 0 (user root)
Reserved blocks gid: 0 (group root)
First inode: 11
Inode size: 256
Required extra isize: 32
Desired extra isize: 32
Journal inode: 8
Default directory hash: half_md4
Directory Hash Seed: ebfabc52-1513-473e-8ba7-2dbd6ffbee6c
Journal backup: inode blocks
root@sf4008:/media/sda# df .
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda 3876736 256 3797632 0% /media/sda
root@sf4008:/media/sda# ls -las
 64 drwxr-xr-x 3 root root 4096 Nov 11 11:50 .
 0 drwxrwxrwt 4 root root 80 Jan 7 1970 ..
 64 drwx------ 2 root root 16384 Jan 1 1970 lost+found
root@sf4008:/media/sda# du -s
128 .
root@sf4008:/media/sda# dd if=/dev/zero of=test bs=1M count=3650
3650+0 records in
3650+0 records out
3827302400 bytes (3.6GB) copied, 541.852403 seconds, 6.7MB/s
root@sf4008:/media/sda# df .
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda 3876736 3739776 58112 98% /media/sda
root@sf4008:/media/sda# du -s 
3798336 .
root@sf4008:/media/sda# rm test 
root@sf4008:/media/sda# df .
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda 3876736 2112 3795776 0% /media/sda
root@sf4008:/media/sda# ls -las
 64 drwxr-xr-x 3 root root 4096 Nov 11 12:03 .
 0 drwxrwxrwt 4 root root 80 Jan 7 1970 ..
 64 drwx------ 2 root root 16384 Jan 1 1970 lost+found
root@sf4008:/media/sda# du -s
128 .
root@sf4008:/media/sda# ~/stress_ext4_bigalloc.sh 
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda 3876736 2112 3795776 0% /media/sda
10+0 records in
10+0 records out
10485760 bytes (10.0MB) copied, 0.043008 seconds, 232.5MB/s
1
10+0 records in
10+0 records out
10485760 bytes (10.0MB) copied, 0.040627 seconds, 246.1MB/s
2
10+0 records in
10+0 records out
10485760 bytes (10.0MB) copied, 0.042517 seconds, 235.2MB/s
3
....

48
10+0 records in
10+0 records out
10485760 bytes (10.0MB) copied, 0.044424 seconds, 225.1MB/s
49
10+0 records in
10+0 records out
10485760 bytes (10.0MB) copied, 0.046012 seconds, 217.3MB/s
50
Filesystem 1K-blocks Used Available Use% Mounted on
/dev/sda 3876736 98432 3699456 3% /media/sda

root@sf4008:/media/sda# ls -las
 64 drwxr-xr-x 3 root root 4096 Nov 11 12:06 .
 0 drwxrwxrwt 4 root root 80 Jan 7 1970 ..
 64 drwx------ 2 root root 16384 Jan 1 1970 lost+found
root@sf4008:/media/sda# du -s
128 .

root@sf4008:/media/sda# dd if=/dev/zero of=test bs=1M count=3650
dd: writing 'test': No space left on device
3608+0 records in
3606+1 records out
3782017024 bytes (3.5GB) copied, 503.133933 seconds, 7.2MB/s
root@sf4008:/media/sda# 

So after mount I could create a 3650MB big file. After the test I couldn't create the same file in the empty filesystem. df shows 98432 used space. du only 128. 

The "stress test" does this:

#!/bin/sh

df .

cd /media/sda
mkdir testfiles
cd testfiles

i=0
while [ $i -lt 50 ]; do
 dd if=/dev/zero of=./test$i bs=1M count=10 > /dev/null
 cp test$i testx_$i
 sync
 let i=i+1
 echo $i
done

sync

cd ..
rm -rf testfiles

df .


Regards,
Frank

>  -------- Weitergeleitete Nachricht --------
> 
> Betreff:
> Re: Significant difference in 'file size' and 'disk usage' for single files
> 
> Datum:
> Fri, 10 Nov 2017 09:43:47 -0500
> 
> Von:
> Mattthew L. Martin linux@clearskydata.com
> 
> An:
> mfe555 mfe555@web.de, linux-ext4@vger.kernel.org
> 
> Lukas,
> 
> Yes, please add any information you have to that bug report. We may be 
> developing more information here which I will add to the report once I 
> have proven it to the the issue. If it is, I will have a reproducer. 
> That may help things along.
> 
> Matthew
> 
> On 11/7/17 02:30, mfe555 wrote:
> > Dear Matthew,
> >
> > sorry about the misunderstanding. If you agree I will reply to your 
> > bug report at bugzilla.kernel.org, providing the details I have posted 
> > here initially. Is there anything else you would recommend me to do, 
> > or any other information you can share?
> >
> > Thanks a lot
> > Lukas
> >
> >
> > Am 06.11.2017 um 19:56 schrieb Mattthew L. Martin:
> >> Lukas,
> >>
> >> I think you might have misunderstood me. We are pretty much in the 
> >> same situation that you find yourself. We currently un-mount and 
> >> remount the file systems that have this behavior to ameliorate the 
> >> issue. We can provide information, but we don't have the manpower or 
> >> skill set to effect a fix.
> >>
> >> Matthew
> >>
> >>
> >> On 11/6/17 12:35, mfe555 wrote:
> >>> Dear Mathew,
> >>>
> >>> thank you very much for your message and for your offer of helping me.
> >>>
> >>> In my case, the file system has a cluster size of 262144. bigalloc 
> >>> is enabled, please see below for details (tune2fs). I have been able 
> >>> to confirm that unmounting and re-mounting the file system helps.
> >>>
> >>> Please let me know what else I can do for giving you more clues. For 
> >>> example, as our linux system is built for over 100 different settop 
> >>> boxes, I might be able to get help from other people, performing 
> >>> tests on specific linux kernels.
> >>>
> >>> Kind regards
> >>> Lukas
> >>>
> >>> =================================
> >>> # tune2fs -l /dev/sdb1
> >>> tune2fs 1.43.4 (31-Jan-2017)
> >>> Filesystem volume name:   
> >>> Last mounted on:          /media/hdd
> >>> Filesystem UUID:          1dbc401d-3ff4-4a46-acc7-8ec7b841bdb0
> >>> Filesystem magic number:  0xEF53
> >>> Filesystem revision #:    1 (dynamic)
> >>> Filesystem features:      has_journal ext_attr resize_inode 
> >>> dir_index filetype needs_recovery extent flex_bg sparse_super 
> >>> large_file huge_file uninit_bg dir_nlink extra_isize bigalloc
> >>> Filesystem flags:         signed_directory_hash
> >>> Default mount options:    user_xattr acl
> >>> Filesystem state:         clean
> >>> Errors behavior:          Continue
> >>> Filesystem OS type:       Linux
> >>> Inode count:              264688
> >>> Block count:              488378368
> >>> Reserved block count:     0
> >>> Free blocks:              146410368
> >>> Free inodes:              260432
> >>> First block:              0
> >>> Block size:               4096
> >>> Cluster size:             262144
> >>> Reserved GDT blocks:      14
> >>> Blocks per group:         2097152
> >>> Clusters per group:       32768
> >>> Inodes per group:         1136
> >>> Inode blocks per group:   71
> >>> Flex block group size:    16
> >>> Filesystem created:       Sun Mar 13 16:31:29 2016
> >>> Last mount time:          Thu Jan  1 01:00:04 1970
> >>> Last write time:          Thu Jan  1 01:00:04 1970
> >>> Mount count:              884
> >>> Maximum mount count:      -1
> >>> Last checked:             Sun Mar 13 16:31:29 2016
> >>> Check interval:           0 ()
> >>> Lifetime writes:          6971 GB
> >>> Reserved blocks uid:      0 (user root)
> >>> Reserved blocks gid:      0 (group root)
> >>> First inode:              11
> >>> Inode size:               256
> >>> Required extra isize:     28
> >>> Desired extra isize:      28
> >>> Journal inode:            8
> >>> Default directory hash:   half_md4
> >>> Directory Hash Seed:      c69a1039-0065-4c1b-8732-ff1b52b57313
> >>> Journal backup:           inode blocks
> >>>
> >>>
> >>>
> >>>
> >>> Am 06.11.2017 um 16:35 schrieb Mattthew L. Martin:
> >>>> I filed a bug for this a while ago:
> >>>>
> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=151491
> >>>>
> >>>> We would be happy to help track this down as it is a pain to manage 
> >>>> this on running servers.
> >>>>
> >>>> Matthew
> >>>>
> >>>>
> >>>> On 11/5/17 06:16, mfe555 wrote:
> >>>>> Some follow-up:
> >>>>>
> >>>>> The issue only occurs with "bigalloc" enabled.
> >>>>>
> >>>>>     echo 3 > /proc/sys/vm/drop_caches
> >>>>>
> >>>>> seems to detach the blocked disk space from the files (so that 'du 
> >>>>> file' no longer includes the offset), but it does not free the 
> >>>>> space, 'df' still shows all file overheads as used disk space.
> >>>>>
> >>>>>
> >>>>>
> >>>>> Am 02.11.2017 um 20:17 schrieb mfe555:
> >>>>>> Hi, I'm using ext4 on a Linux based Enigma2 set-top box, kernel 
> >>>>>> 4.8.3.
> >>>>>>
> >>>>>> When creating a fresh file, there is a significant difference in 
> >>>>>> file size (ls -la) and disk usage (du). When making two copies of 
> >>>>>> the file ..
> >>>>>>
> >>>>>> gbquad:/hdd/test# cp file file.copy1
> >>>>>> gbquad:/hdd/test# cp file file.copy2
> >>>>>> gbquad:/hdd/test# ls -la
> >>>>>> -rw-------    1 root     root     581821460 Nov  1 18:52 file
> >>>>>> -rw-------    1 root     root     581821460 Nov  1 18:56 file.copy1
> >>>>>> -rw-------    1 root     root     581821460 Nov  1 18:57 file.copy2
> >>>>>> gbquad:/hdd/test# du *
> >>>>>> 607232  file
> >>>>>> 658176  file.copy1
> >>>>>> 644864  file.copy2
> >>>>>>
> >>>>>> ... all three files show an overhead in the ~10% range, and the 
> >>>>>> overhead is different for these files although their md5sums are 
> >>>>>> equal.
> >>>>>>
> >>>>>> When deleting a file (rm), the overhead remains occupied on the 
> >>>>>> disk. For example, after deleting "file", "df" reports approx. 
> >>>>>> 581821460 more bytes free, not 607232 kbytes more free space. The 
> >>>>>> overhead (607232 kB - 581821460 B =pprox. 39 MB) remains blocked.
> >>>>>>
> >>>>>> When re-booting, the blocked space becomes free again, and in 
> >>>>>> addition the overhead of those files that were not deleted also 
> >>>>>> disappears, so that after a reboot the'file size' and 'disk 
> >>>>>> usage' match for all files (except for rounding up to some block 
> >>>>>> size).
> >>>>>>
> >>>>>> A colleague and I have observed this on two different "kernel 
> >>>>>> 4.8.3" boxes and three ext4 disks, but not on a "kernel 3.14" box 
> >>>>>> also using ext4.
> >>>>>>
> >>>>>> Can anyone help me with this ?
> >>>>>>
> >>>>>> Thanks a lot
> >>>>>> Lukas
> >>>>>>
> >>>>>
> >>>>
> >>>
> >>
> >
