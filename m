From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: FAST paper on ffsck
Date: Wed, 29 Jan 2014 23:21:07 +0400
Message-ID: <CAG5DWogJ5SiBfpK6k-_4gB-Roea-F+KWTnDm8xRF1Sf-vmOFFw@mail.gmail.com>
References: <20131209180149.GA6096@thunk.org>
	<20140129185741.GA8798@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:38903 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaA2TVI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jan 2014 14:21:08 -0500
Received: by mail-qc0-f181.google.com with SMTP id e9so3376426qcy.26
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 11:21:08 -0800 (PST)
In-Reply-To: <20140129185741.GA8798@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 29, 2014 at 10:57 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Dec 09, 2013 at 01:01:49PM -0500, Theodore Ts'o wrote:
>> Andreas brought up on today's conference call Kirk McKusick's recent
>> changes[1] to try to improve fsck times for FFS, in response to the
>> recent FAST paper covering fsck speed ups for ext3, "ffsck: The Fast
>> Filesystem Checker"[2]
>>
>> [1] http://www.mckusick.com/publications/faster_fsck.pdf
>> [2] https://www.usenix.org/system/files/conference/fast13/fast13-final52_0.pdf
>>
>> All of the changes which Kirk outlined are ones which we had done
>> several years ago, in the early days of ext4 development.  I talked
>> about some of these in some blog entries, "Fast ext4 fsck times"[3], and
>> "Fast ext4 fsck times, revisited"[4]
>>
>> [3] http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times/
>> [4] http://thunk.org/tytso/blog/2009/02/26/fast-ext4-fsck-times-revisited/
>>
>> (Apologies for the really bad formatting; I recovered my blog from
>> backups a few months ago, installed onto a brand-new Wordpress
>> installation --- since the old one was security bug ridden and
>> horribly obsolete --- and I haven't had a chance to fix up some of the
>> older blog entries that had explicit HTML for tables to work with the
>> new theme.)
>>
>> One further observation from reading the ffsck paper.  Their method of
>> introducing heavy file system fragmentation resulted in a file system
>> where most of the files had external extent tree blocks; that is, the
>> trees had a depth > 1.  I have not observed this in file systems under
>> normal load, since most files are written once and not rewritten, and
>> those that are rewritten (i.e., database files) are not the common
>> case, and even then, generally aren't written in a random append
>> workload where there are hundreds of files in the same directory which
>> are appended to in random order.  So looking at at a couple file
>> systems' fsck -v output, I find results such as this:
>>
>>              Extent depth histogram: 1229346/569/3
>>              Extent depth histogram: 332256/141
>>              Extent depth histogram: 23253/456
>>
>> ... where the first number is the number of inode where all of the
>> extent information stored in the inode, and the second number is the
>> number of inodes with a single level of external extent tree blocks,
>> and so on.
>>
>> As a result, I'm not seeing the fsck time degradation resulting from
>> file system aging, because with at leat my workloads, the file system
>> isn't getting fragmented in enough to result in a large number of
>> inodes with external extent tree blocks.
>>
>> We could implement schemes to optimize fsck performance for heavily
>> fragmented file systems; a few which could be done using just e2fsck
>> optimizations, and some which would require file system format
>> changes.  However, it's not clear to me that it's worth it.
>>
>> If folks would like help run some experiments, it would be useful to
>> run a test e2fsck on a partition: "e2fsck -Fnfvtt /dev/sdb1" and look
>> at the extent depth histogram and the I/O rates for the various e2fsck
>> passes (see below for an example).
>>
>> If you have examples where the file system has a very large number of
>> inodes with extent tree depths > 1, it would be useful to see these
>> numbers, with a description of how old the file system has been, and
>> what sort of workload might have contributed to its aging.
>>
>
> I don't know about "very large", but here's what I see on the server that I
> share with some friends.  Afaik it's used mostly for VM images and test
> kernels... and other parallel-write-once files. ;)  This FS has been running
> since Nov. 2012.  That said, I think the VM images were created without
> fallocate; some of these files have tens of thousands of tiny extents.
>
>      5386404 inodes used (4.44%, out of 121307136)
>        22651 non-contiguous files (0.4%)
>         7433 non-contiguous directories (0.1%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 5526723/1334/16
>    202583901 blocks used (41.75%, out of 485198848)
>            0 bad blocks
>           34 large files
>
>      5207070 regular files
>       313009 directories
>          576 character device files
>          192 block device files
>           11 fifos
>      1103023 links
>        94363 symbolic links (86370 fast symbolic links)
>           73 sockets
> ------------
>      6718317 files
>
> On my main dev box, which is entirely old photos, mp3s, VM images, and kernel
> builds, I see:
>
>      2155348 inodes used (2.94%, out of 73211904)
>        14923 non-contiguous files (0.7%)
>         1528 non-contiguous directories (0.1%)
>              # of inodes with ind/dind/tind blocks: 0/0/0
>              Extent depth histogram: 2147966/685/3
>     85967035 blocks used (29.36%, out of 292834304)
>            0 bad blocks
>            6 large files
>
>      1862617 regular files
>       284915 directories
>          370 character device files
>           59 block device files
>            6 fifos
>       609215 links
>         7454 symbolic links (6333 fast symbolic links)
>           24 sockets
> ------------
>      2764660 files


Workload: there are _many_ files that don't deleted, append/full
rewrite/create only, lifetime 1-2 years:

     8988871 inodes used (2.09%, out of 429817856)
     1012499 non-contiguous files (1.7%)
        2039 non-contiguous directories (0.0%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 8616444/372389/30
# about 99% blocks in use wrong information, I shrinked fs before
this, to minimal size
   428752124 blocks used (99.76%, out of 429788930)
           0 bad blocks
          50 large files

     5988792 regular files
     3000070 directories
           0 character device files
           0 block device files
           0 fifos
           0 links
           0 symbolic links (0 fast symbolic links)
           0 sockets
------------
     8988862 files


>
> Sadly, since I've left the LTC I no longer have access to tux1, which had a
> rather horrifically fragmented ext3.  Its backup server, which created a Time
> Machine-like series of "snapshots" with rsync --link-dest, took days to fsck,
> despite being ext4.
>
> --D
>
>> Thanks, regards,
>>
>>                                       - Ted
>>
>> e2fsck 1.42.8 (20-Jun-2013)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 1: Memory used: 668k/7692k (575k/94k), time:  0.92/ 0.42/ 0.02
>> Pass 1: I/O read: 11MB, write: 0MB, rate: 11.95MB/s
>> Pass 2: Checking directory structure
>> Pass 2: Memory used: 784k/15196k (466k/319k), time:  0.44/ 0.03/ 0.00
>> Pass 2: I/O read: 10MB, write: 0MB, rate: 22.76MB/s
>> Pass 3: Checking directory connectivity
>> Peak memory: Memory used: 784k/15196k (466k/319k), time:  1.60/ 0.63/ 0.02
>> Pass 3: Memory used: 784k/15196k (439k/346k), time:  0.00/ 0.00/ 0.00
>> Pass 3: I/O read: 1MB, write: 0MB, rate: 2793.30MB/s
>> Pass 4: Checking reference counts
>> Pass 4: Memory used: 784k/188k (432k/353k), time:  0.63/ 0.63/ 0.00
>> Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
>> Pass 5: Checking group summary information
>> Pass 5: Memory used: 784k/188k (426k/359k), time:  4.95/ 0.16/ 0.10
>> Pass 5: I/O read: 19MB, write: 0MB, rate: 3.84MB/s
>>
>>        13825 inodes used (0.03%, out of 47906816)
>>         1425 non-contiguous files (10.3%)
>>           11 non-contiguous directories (0.1%)
>>              # of inodes with ind/dind/tind blocks: 0/0/0
>>              Extent depth histogram: 12986/831
>>    141525383 blocks used (73.85%, out of 191627264)
>>            0 bad blocks
>>            4 large files
>>
>>        11537 regular files
>>         2279 directories
>>            0 character device files
>>            0 block device files
>>            0 fifos
>>            0 links
>>            0 symbolic links (0 fast symbolic links)
>>            0 sockets
>> ------------
>>        13816 files
>> Memory used: 784k/188k (426k/359k), time:  7.19/ 1.42/ 0.12
>> I/O read: 39MB, write: 0MB, rate: 5.43MB/s
>>
>> Note: the reason why this file system has so many files with large
>> extents is because there are some video files which large enough that
>> even when contiguous, they will require an external extent block, e.g:
>>
>> File size of 01 Yankee White.m4v is 499375730 (121918 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       0:   19802112..  19802112:      1:
>>    1:        2..     315:   19802114..  19802427:    314:   19802113:
>>    2:      543..   14335:   19802655..  19816447:  13793:   19802428:
>>    3:    14336..   47103:   19830784..  19863551:  32768:   19816448:
>>    4:    47104..   73727:   19896320..  19922943:  26624:   19863552:
>>    5:    73728..   79871:   19955712..  19961855:   6144:   19922944:
>>    6:    79872..  112639:   19994624..  20027391:  32768:   19961856:
>>    7:   112640..  121917:   20060160..  20069437:   9278:   20027392: eof
>> 01 Yankee White.m4v: 8 extents found
>>
>> BTW, looking at the output of filefrag -v on large files, it does look
>> like there is some work we can do to improve the block allocation
>> hueristics.  These files were written w/o the benefit of fallocate,
>> but with delayed allocation, and apparently we aren't automatically
>> figuring out that we should be in stream mode from the get-go.  This
>> pattern is reproduced in most of the files in the directory:
>>
>> File size of 02 Hung Out to Dry.m4v is 552382434 (134859 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       0:   19816448..  19816448:      1:
>>    1:        2..     314:   19816450..  19816762:    313:   19816449:
>>    2:      542..   14335:   19816990..  19830783:  13794:   19816763:
>>    3:    14336..   47103:   19863552..  19896319:  32768:   19830784:
>>    4:    47104..   79871:   19961856..  19994623:  32768:   19896320:
>>    5:    79872..  112639:   20027392..  20060159:  32768:   19994624:
>>    6:   112640..  134858:   20070400..  20092618:  22219:   20060160: eof
>> 02 Hung Out to Dry.m4v: 7 extents found
>>
>> File size of 03 Sea Dog.m4v is 553146161 (135046 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       0:   20092928..  20092928:      1:
>>    1:        2..     159:   20092930..  20093087:    158:   20092929:
>>    2:      161..     306:   20093089..  20093234:    146:   20093088:
>>    3:      534..   14335:   20093462..  20107263:  13802:   20093235:
>>    4:    14336..   47103:   20121600..  20154367:  32768:   20107264:
>>    5:    47104..   79871:   20187136..  20219903:  32768:   20154368:
>>    6:    79872..  112639:   20252672..  20285439:  32768:   20219904:
>>    7:   112640..  135045:   20318208..  20340613:  22406:   20285440: eof
>> 03 Sea Dog.m4v: 8 extents found
>>
>> File size of 04 The Immortals.m4v is 516091162 (125999 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       0:   20107264..  20107264:      1:
>>    1:        2..     162:   20107266..  20107426:    161:   20107265:
>>    2:      164..     312:   20107428..  20107576:    149:   20107427:
>>    3:      540..   14335:   20107804..  20121599:  13796:   20107577:
>>    4:    14336..   47103:   20154368..  20187135:  32768:   20121600:
>>    5:    47104..   79871:   20219904..  20252671:  32768:   20187136:
>>    6:    79872..  112639:   20285440..  20318207:  32768:   20252672:
>>    7:   112640..  125998:   20340736..  20354094:  13359:   20318208: eof
>> 04 The Immortals.m4v: 8 extents found
>>
>> Looking at all of these files, actually, if we had managed to allocate
>> them using contiguous 32768 block extents, these 45 minute TV episodes
>> would have just fit inside the in-inode's 4 extent slots.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Respectfully
Azat Khuzhin
