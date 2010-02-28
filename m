From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Sun, 28 Feb 2010 09:55:41 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan> <20100228054240.GE14646@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:46974 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968507Ab0B1Ozm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Feb 2010 09:55:42 -0500
In-Reply-To: <20100228054240.GE14646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sun, 28 Feb 2010, tytso@mit.edu wrote:

> On Sat, Feb 27, 2010 at 06:36:37AM -0500, Justin Piszcz wrote:
>>
>> I still would like to know however, why 350MiB/s seems to be the maximum
>> performance I can get from two different md raids (that easily do 600MiB/s
>> with XFS).

> Can you run "filefrag -v <filename>" on the large file you created
> using dd?  Part of the problem may be the block allocator simply not
> being well optimized super large writes.  To be honest, that's not
> something we've tried (at all) to optimize, mainly because for most
> users of ext4 they're more interested in much more reasonable sized
> files, and we only have so many hours in a day to hack on ext4.  :-)
> XFS in contrast has in the past had plenty of paying customers
> interested in writing really large scientific data sets, so this is
> something Irix *has* spent time optimizing.
Yes, this is shown at the bottom of the e-mail both with -o data=ordered
and data=writeback.

[ .. ]

> So if you can gather some data, such as the filefrag information, that
> would be a great first step.  Something else that would be useful is
> gathering blktrace information, so we can see how we are scheduling
> the writes and whether we have something bad going on there.  I
> wouldn't be surprised if there is some stupidity going on in the
> generic FS/MM writeback code which is throttling us, and which XFS has
> worked around.  Ext4 has worked around some writeback brain-damage
> already, but I've been focused on much smaller files (files in the
> tens or hundreds megabytes) since that's what I tend to use much more
> frequently.
>
> It's great to see that you're really interested in this; if you're
> willing to do some investigative work, hopefully it's something we can
> address.

[ .. ]

> P.S.  I'm a bit unclear regarding your comment about "-o nodelalloc"
> in one of your earlier threads.  Does using nodelalloc actually speeds
> things up?  There were a bunch of numbers being thrown around, and in
> some configurations I thought you were getting around 300 MB/s without
> using nodelalloc?  Or am I misunderstanding your numbers and what
> configuratoins you used with each test run?
This is more dramatic on the software raid (mdadm) RAID-5 configuration. 
Without -o nodelalloc, I see roughly 200MiB/s.  With -o nodelalloc, I hit 
the same barrier as the RAID-0, 350MiB/s, but its effect on RAID-0 is less 
dramatic.  The full tests and output appear at the bottom of this e-mail; 
however, for brevity, the example below shows 55MiB/s and 132MiB/s
performance increases with RAID-0 and RAID-5 respectively:

For the RAID-0:

-o data=writeback,nobarrier:
10737418240 bytes (11 GB) copied, 34.755 s, 309 MB/s
-o data=writeback,nobarrier,nodelalloc:
10737418240 bytes (11 GB) copied, 29.5299 s, 364 MB/s
An increase of 55MiB/s.

For the RAID-5 (from earlier testing):

-o data=writeback,nobarrier:
10737418240 bytes (11 GB) copied, 48.7335 s, 220 MB/s
-o data=writeback,nobarrier,nodelalloc:
10737418240 bytes (11 GB) copied, 30.5425 s, 352 MB/s
An increase of 132MiB/s.

>
> If nodelalloc is actually speeding things up, then we almost certainly
> have some kind of writeback problem.  So filefrag and blktrace are
> definitely the tools we need to look at to understand what is going
> on.
>

=== CREATE RAID-0 WITH 11 DISKS

p63:~# mdadm --create -e 0.90 /dev/md0 /dev/sd[b-l]1 --level=0 -n 11 -c 64
mdadm: /dev/sdb1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdd1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdf1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdg1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdh1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdi1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdj1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdk1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
mdadm: /dev/sdl1 appears to be part of a raid array:
     level=raid0 devices=11 ctime=Sun Feb 28 06:24:58 2010
Continue creating array? y
mdadm: array /dev/md0 started.
p63:~#

=== SHOW MDADM RAID-0

p63:~# mdadm -D /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Sun Feb 28 06:31:41 2010
      Raid Level : raid0
      Array Size : 5372223296 (5123.35 GiB 5501.16 GB)
    Raid Devices : 11
   Total Devices : 11
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sun Feb 28 06:31:41 2010
           State : clean
  Active Devices : 11
Working Devices : 11
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 64K

            UUID : 077d4d5c:5acbcb29:26614430:c3345183 (local to host p63)
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1
        4       8       81        4      active sync   /dev/sdf1
        5       8       97        5      active sync   /dev/sdg1
        6       8      113        6      active sync   /dev/sdh1
        7       8      129        7      active sync   /dev/sdi1
        8       8      145        8      active sync   /dev/sdj1
        9       8      161        9      active sync   /dev/sdk1
       10       8      177       10      active sync   /dev/sdl1
p63:~#

=== KERNEL CONFIGURATION BASELINE

The following kernel configuration was used:
http://home.comcast.net/~jpiszcz/20100228/config-2.6.33-baseline.txt

=== ESTABLISH CONTROL / BASELINE

p63:~# mkfs.xfs /dev/md0 -f
meta-data=/dev/md0               isize=256    agcount=32, agsize=41970496 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1343055824, imaxpct=5
          =                       sunit=16     swidth=176 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
p63:~# mount /dev/md0 /r1 -o nobarrier
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 17.9816 s, 597 MB/s
0.03user 16.10system 0:17.99elapsed 89%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (1major+495minor)pagefaults 0swaps
p63:/r1#

p63:/r1# xfs_bmap -v /r1/bigfile 
/r1/bigfile:
  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET           TOTAL FLAGS
    0: [0..20971519]:   671528064..692499583  2 (128..20971647)  20971520 00011
p63:/r1#

=== CREATE EXT4 FILESYSTEM ON ARRAY (note the stripe/width appears to be
                                      irrelevant to to the speed problem as
                                      as the cap is '350MiB/s' whether it is
                                      aligned or not, see the following URL
                                      for those tests)
                                      http://lkml.org/lkml/2010/2/27/77

                                      NOTE: It compares ext2 vs. ext3 vs. ext4
                                            vs. XFS.

                                      NOTE: nobarrier does not seem to be a
                                            factor either, but I will include
                                            it below to ensure it is not
                                            somehow impacting the tests
                                            performed.

p63:~# /usr/bin/time mkfs.ext4 /dev/md0
mke2fs 1.41.10 (10-Feb-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
335765504 inodes, 1343055824 blocks
67152791 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
40987 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
         102400000, 214990848, 512000000, 550731776, 644972544

Writing inode tables: done 
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 36 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
6.50user 83.89system 2:01.86elapsed 74%CPU (0avgtext+0avgdata 829552maxresident)k
0inputs+0outputs (5major+51889minor)pagefaults 0swaps
p63:~#

=== MOUNT FILESYSTEM WITH NOBARRIER, ORDERED (DEFAULT) & RUN TEST

p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 35.2676 s, 304 MB/s
0.02user 19.40system 0:35.29elapsed 55%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (3major+493minor)pagefaults 0swaps
p63:/r1#

=== SHOW FILEFRAG OUTPUT (NOBARRIER,ORDERED)

p63:/r1# filefrag -v /r1/bigfile 
Filesystem type is: ef53
File size of /r1/bigfile is 10737418240 (2621440 blocks, blocksize 4096)
  ext logical  physical  expected length flags
    0       0     34816            32768
    1   32768     67584            30720
    2   63488    100352     98303  32768
    3   96256    133120            30720
    4  126976    165888    163839  32768
    5  159744    198656            30720
    6  190464    231424    229375  32768
    7  223232    264192            30720
    8  253952    296960    294911  32768
    9  286720    329728            32768
   10  319488    362496            32768
   11  352256    395264            32768
   12  385024    428032            32768
   13  417792    460800            32768
   14  450560    493568            30720
   15  481280    557056    524287  32768
   16  514048    589824            32768
   17  546816    622592            32768
   18  579584    655360            32768
   19  612352    688128            32768
   20  645120    720896            32768
   21  677888    753664            32768
   22  710656    786432            32768
   23  743424    821248    819199  32768
   24  776192    854016            30720
   25  806912    886784    884735  32768
   26  839680    919552            32768
   27  872448    952320            32768
   28  905216    985088            32768
   29  937984   1017856            30720
   30  968704   1081344   1048575  32768
   31 1001472   1114112            32768
   32 1034240   1146880            32768
   33 1067008   1179648            32768
   34 1099776   1212416            32768
   35 1132544   1245184            32768
   36 1165312   1277952            32768
   37 1198080   1310720            32768
   38 1230848   1343488            32768
   39 1263616   1376256            32768
   40 1296384   1409024            32768
   41 1329152   1441792            32768
   42 1361920   1474560            32768
   43 1394688   1507328            32768
   44 1427456   1540096            32768
   45 1460224   1607680   1572863  32768
   46 1492992   1640448            32768
   47 1525760   1673216            32768
   48 1558528   1705984            32768
   49 1591296   1738752            32768
   50 1624064   1771520            32768
   51 1656832   1804288            32768
   52 1689600   1837056            32768
   53 1722368   1869824            32768
   54 1755136   1902592            32768
   55 1787904   1935360            32768
   56 1820672   1968128            32768
   57 1853440   2000896            32768
   58 1886208   2033664            32768
   59 1918976   2066432            30720
   60 1949696   2129920   2097151  32768
   61 1982464   2162688            32768
   62 2015232   2195456            32768
   63 2048000   2228224            32768
   64 2080768   2260992            32768
   65 2113536   2293760            32768
   66 2146304   2326528            32768
   67 2179072   2359296            32768
   68 2211840   2392064            32768
   69 2244608   2424832            32768
   70 2277376   2457600            32768
   71 2310144   2490368            32768
   72 2342912   2523136            32768
   73 2375680   2555904            32768
   74 2408448   2588672            32768
   75 2441216   2656256   2621439  32768
   76 2473984   2689024            32768
   77 2506752   2721792            32768
   78 2539520   2754560            32768
   79 2572288   2787328            18432
   80 2590720   2818048   2805759  30720 eof
/r1/bigfile: 13 extents found
p63:/r1#

=== MOUNT FILESYSTEM WITH NOBARRIER, WRITEBACK & RUN TEST

p63:/# mount /dev/md0 -o data=writeback,nobarrier /r1
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 34.755 s, 309 MB/s
0.02user 19.38system 0:34.78elapsed 55%CPU (0avgtext+0avgdata 7280maxresident)k
0inputs+0outputs (3major+491minor)pagefaults 0swaps
p63:/r1#

=== SHOW FILEFRAG OUTPUT (NOBARRIER,WRITEBACK)

p63:/r1# filefrag -v /r1/bigfile 
Filesystem type is: ef53
File size of /r1/bigfile is 10737418240 (2621440 blocks, blocksize 4096)
  ext logical  physical  expected length flags
    0       0     34816            32768
    1   32768     67584            30720
    2   63488    100352     98303  32768
    3   96256    133120            30720
    4  126976    165888    163839  32768
    5  159744    198656            30720
    6  190464    231424    229375  32768
    7  223232    264192            30720
    8  253952    296960    294911  32768
    9  286720    329728            32768
   10  319488    362496            32768
   11  352256    395264            32768
   12  385024    428032            32768
   13  417792    460800            32768
   14  450560    493568            30720
   15  481280    557056    524287  32768
   16  514048    589824            32768
   17  546816    622592            32768
   18  579584    655360            32768
   19  612352    688128            32768
   20  645120    720896            32768
   21  677888    753664            32768
   22  710656    786432            32768
   23  743424    821248    819199  32768
   24  776192    854016            30720
   25  806912    886784    884735  32768
   26  839680    919552            32768
   27  872448    952320            32768
   28  905216    985088            32768
   29  937984   1017856            30720
   30  968704   1081344   1048575  32768
   31 1001472   1114112            32768
   32 1034240   1146880            32768
   33 1067008   1179648            32768
   34 1099776   1212416            32768
   35 1132544   1245184            32768
   36 1165312   1277952            32768
   37 1198080   1310720            32768
   38 1230848   1343488            32768
   39 1263616   1376256            32768
   40 1296384   1409024            32768
   41 1329152   1441792            32768
   42 1361920   1474560            32768
   43 1394688   1507328            32768
   44 1427456   1540096            32768
   45 1460224   1607680   1572863  32768
   46 1492992   1640448            32768
   47 1525760   1673216            32768
   48 1558528   1705984            32768
   49 1591296   1738752            32768
   50 1624064   1771520            32768
   51 1656832   1804288            32768
   52 1689600   1837056            32768
   53 1722368   1869824            32768
   54 1755136   1902592            32768
   55 1787904   1935360            32768
   56 1820672   1968128            32768
   57 1853440   2000896            32768
   58 1886208   2033664            32768
   59 1918976   2066432            30720
   60 1949696   2129920   2097151  32768
   61 1982464   2162688            32768
   62 2015232   2195456            32768
   63 2048000   2228224            32768
   64 2080768   2260992            32768
   65 2113536   2293760            32768
   66 2146304   2326528            32768
   67 2179072   2359296            32768
   68 2211840   2392064            32768
   69 2244608   2424832            32768
   70 2277376   2457600            32768
   71 2310144   2490368            32768
   72 2342912   2523136            32768
   73 2375680   2555904            32768
   74 2408448   2588672            32768
   75 2441216   2656256   2621439  32768
   76 2473984   2689024            32768
   77 2506752   2721792            32768
   78 2539520   2754560            16384 
/r1/bigfile: 12 extents found
p63:/r1#

=== USE OF -o nodelalloc WITH SOFTWARE RAID-0 (SPEED IMPROVEMENT)

p63:/r1# mount /dev/md0 -o data=writeback,nobarrier,nodelalloc /r1
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 29.5299 s, 364 MB/s
0.02user 28.95system 0:29.56elapsed 98%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (3major+493minor)pagefaults 0swaps
p63:/r1#

While it does help, I have not been able to get > 400MiB/s, it stops at 
roughly 350-360MiB/s.

=== FIRST ATTEMPT AT USING BLKTRACE

Following these docs:
http://git.kernel.org/?p=linux/kernel/git/axboe/blktrace.git;a=blob;f=README
http://github.com/znmeb/linux_perf_viz/raw/master/blktrace-howto/blktrace-howto.pdf
http://pdfedit.petricek.net/bt/file_download.php?file_id=17&type=bug
http://www.cse.unsw.edu.au/~aaronc/iosched/doc/blktrace.html

Options required in the kernel:

Kernel hacking:
   | |    [*] Debug Filesystem                                             | |

Then the BLK_IO_TRACE (it has moved from where the old docs say to go)
Kernel Hacking:
   | |    [ ] Tracers  --->                                                | |
   | |    [*]   Support for tracing block IO actions                       | |

Compile new kernel, reboot.

New kernel configuration used (only enabled the options shown above)
http://home.comcast.net/~jpiszcz/20100228/config-2.6.33-blktrace.txt

Next step, create a fresh filesystem for the trace event:

p63:~# /usr/bin/time mkfs.ext4 /dev/md0
< .. >
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

Reboot to new kernel.

Per:
http://pdfedit.petricek.net/bt/file_download.php?file_id=17&type=bug

Mount the debug filesystem/make sure it iss mounted:

p63:~# mount -t debugfs debugfs /sys/kernel/debug
mount: debugfs already mounted or /sys/kernel/debug busy
mount: according to mtab, debugfs is already mounted on /sys/kernel/debug
p63:~#

Then follow instructions on page 14 from:
http://github.com/znmeb/linux_perf_viz/raw/master/blktrace-howto/blktrace-howto.pdf

p63:/dev/shm/server# blktrace -l
server: waiting for connections...
server: connection from 192.168.168.113

p63:/dev/shm/client# blktrace -h 192.168.168.113 /dev/md0
blktrace: connecting to 192.168.168.113
blktrace: connected!

Mount filesystem with -o data=writeback,nobarrier, run test blktrace1.

p63:~# mount -o data=writeback,nobarrier /dev/md0 /r1
p63:~# cd /r1
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 35.6317 s, 301 MB/s
0.03user 19.41system 0:35.67elapsed 54%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (2major+494minor)pagefaults 0swaps
p63:/r1# rm bigfile 
p63:/r1# sync
p63:/r1# cd
p63:~# umount /r1
p63:~#

SERVER PROCESS:

p63:/dev/shm/server# blktrace -l
server: waiting for connections...
server: connection from 192.168.168.113
server: end of run for 192.168.168.113:md0
=== md0 ===
   CPU  0:              1548634 events,    72593 KiB data
   CPU  1:              1009268 events,    47310 KiB data
   Total:               2557902 events (dropped 0),   119902 KiB data
p63:/dev/shm/server# ls

CLIENT PROCESS:

# blktrace -h 192.168.168.113 /dev/md0
blktrace: connecting to 192.168.168.113
blktrace: connected!
^C=== md0 ===
   CPU  0:              1548634 events,    72593 KiB data
   CPU  1:              1009268 events,    47310 KiB data
   Total:               2557902 events (dropped 0),   119902 KiB data

>From this test, the following resulted:
# du -sh *
56K     192.168.168.113-2010-02-28-13:10:48
118M    192.168.168.113-2010-02-28-13:14:00

Let this trace be called blktrace1.

p63:/dev/shm/server# du -sh blktrace1/*
56K     blktrace1/192.168.168.113-2010-02-28-13:10:48
118M    blktrace1/192.168.168.113-2010-02-28-13:14:00
p63:/dev/shm/server#

Mount with -o data=writeback,nobarrier,nodelalloc, run test blktrace2.

p63:~# umount /r1
p63:~# mount -o data=writeback,nobarrier,nodelalloc /dev/md0 /r1
p63:~# cd /r1
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.6692 s, 350 MB/s
0.03user 29.55system 0:30.70elapsed 96%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (1major+495minor)pagefaults 0swaps
p63:/r1# rm bigfile 
p63:/r1# sync
p63:/r1# cd
p63:~# umount /r1
p63:~#

SERVER PROCESS:

p63:/dev/shm/server# blktrace -l
server: waiting for connections...
server: connection from 192.168.168.113
server: end of run for 192.168.168.113:md0
=== md0 ===
   CPU  0:                50056 events,     2347 KiB data
   CPU  1:              2478242 events,   116168 KiB data
   Total:               2528298 events (dropped 0),   118515 KiB data

CLIENT PROCESS:

# blktrace -h 192.168.168.113 /dev/md0
blktrace: connecting to 192.168.168.113
blktrace: connected!
^C=== md0 ===
   CPU  0:                50056 events,     2347 KiB data
   CPU  1:              2478242 events,   116168 KiB data
   Total:               2528298 events (dropped 0),   118515 KiB data
#

p63:/dev/shm/server# du -sh 192.168.168.113-2010-02-28-13\:17\:22/*
2.4M    192.168.168.113-2010-02-28-13:17:22/md0.blktrace.0
114M    192.168.168.113-2010-02-28-13:17:22/md0.blktrace.1

This is blktrace2.

One more time (blktrace3) with ordered.

p63:~# mount -o nobarrier /dev/md0 /r1
p63:~# dmesg | tail -n 2
[ 2788.928806] EXT4-fs (md0): barriers disabled
[ 2789.340573] EXT4-fs (md0): mounted filesystem with ordered data mode
p63:~# cd /r1
p63:/r1# /usr/bin/time dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 36.2893 s, 296 MB/s
0.04user 19.29system 0:36.32elapsed 53%CPU (0avgtext+0avgdata 7296maxresident)k
0inputs+0outputs (1major+494minor)pagefaults 0swaps
p63:/r1# rm bigfile 
p63:/r1# sync
p63:/r1# cd
p63:~# umount /r1
p63:~#

SERVER PROCESS:

p63:/dev/shm/server# blktrace -l
server: waiting for connections...
server: connection from 192.168.168.113
server: end of run for 192.168.168.113:md0
=== md0 ===
   CPU  0:              1587087 events,    74395 KiB data
   CPU  1:               970979 events,    45515 KiB data
   Total:               2558066 events (dropped 0),   119910 KiB data
p63:/dev/shm/server#

CLIENT PROCESS:

# blktrace -h 192.168.168.113 /dev/md0
blktrace: connecting to 192.168.168.113
blktrace: connected!
=== md0 ===
   CPU  0:              1587087 events,    74395 KiB data
   CPU  1:               970979 events,    45515 KiB data
   Total:               2558066 events (dropped 0),   119910 KiB data
#

TRACE OUTPUT TOTAL AND SUMMARY:


p63:~/results-20100228# du -sh *
570M    blktrace1       => -o data=writeback,nobarrier
570M    blktrace1-redo  => -o data=writeback,nobarrier
563M    blktrace2       => -o data=writeback,nobarrier,nodelalloc
570M    blktrace3       => -o data=nobarrier
4.0K    script
p63:~/results-20100228#

USING SCRIPT ON PAGE 24/30:

Running post-process.sh for each trace: blktrace{1,2,3}, the script itself
from page 24/30:

# cat /root/post-process.sh 
#! /bin/bash
blkrawverify md0 # check data for errors
blkparse -d md0.bin -i md0 > md0.blkparse # merged binary, parsed
btt -i md0.bin --all-data > md0.btt # basic btt report
# now the whole enchilada!
btt -i md0.bin -o md0x --all-data --easy-parse-avgs \
--iostat=md0x.iostat \
--per-io-dump=md0x.pid \
--q2d-latencies=md0x \
--d2c-latencies=md0x \
--q2c-latencies=md0x \
--dump-blocknos=md0x_dbn \
--active-queue-depth=md0x \
--unplug-hist=md0x_uph \
--seeks=seeks \
--seeks-per-second=sps \
--per-io-trees=md0x_pit \
> md0x.btt # md0x.btt is empty

#

Before running any tests, backup raw data:

p63:/dev/shm# tar cf /root/server.tar server
p63:/dev/shm#

For each directory, run post-process:

blktrace1: (I must have waited too long in between steps here so it made two)

p63:/dev/shm/server/blktrace1# ls -1
192.168.168.113-2010-02-28-13:10:48
192.168.168.113-2010-02-28-13:14:00
p63:/dev/shm/server/blktrace1# cd *48
p63:/dev/shm/server/blktrace1/192.168.168.113-2010-02-28-13:10:48# /root/post-process.sh 
Verifying md0
     CPU 0
     CPU 1 
Wrote output to md0.verify.out
p63:/dev/shm/server/blktrace1/192.168.168.113-2010-02-28-13:10:48# cd ../*00
p63:/dev/shm/server/blktrace1/192.168.168.113-2010-02-28-13:14:00# /root/post-process.sh 
Verifying md0
     CPU 0
     CPU 1 
Wrote output to md0.verify.out
p63:/dev/shm/server/blktrace1/192.168.168.113-2010-02-28-13:14:00#

I will make another blktrace1 and be faster this time so all data results
are of the same type, it is called blktrace1-redo:

blktrace1-redo:

p63:/dev/shm/server/blktrace1-redo/192.168.168.113-2010-02-28-13:35:45# /root/post-process.sh 
Verifying md0
     CPU 0
     CPU 1 
Wrote output to md0.verify.out
p63:/dev/shm/server/blktrace1-redo/192.168.168.113-2010-02-28-13:35:45#

blktrace2:

p63:/dev/shm/server/blktrace2/192.168.168.113-2010-02-28-13:17:22# /root/post-process.sh 
Verifying md0
     CPU 0
     CPU 1 
Wrote output to md0.verify.out
p63:/dev/shm/server/blktrace2/192.168.168.113-2010-02-28-13:17:22#

blktrace3:

p63:/dev/shm/server/blktrace3/192.168.168.113-2010-02-28-13:31:29# /root/post-process.sh 
Verifying md0
     CPU 0
     CPU 1 
Wrote output to md0.verify.out
p63:/dev/shm/server/blktrace3/192.168.168.113-2010-02-28-13:31:29#

------------

=== FINAL RESULTS


p63:~/results-20100228# du -sh */*
216K    blktrace1/192.168.168.113-2010-02-28-13:10:48
570M    blktrace1/192.168.168.113-2010-02-28-13:14:00
570M    blktrace1-redo/192.168.168.113-2010-02-28-13:35:45
563M    blktrace2/192.168.168.113-2010-02-28-13:17:22
570M    blktrace3/192.168.168.113-2010-02-28-13:31:29
4.0K    script/post-process.sh
p63:~/results-20100228#

I used 7zip to compress the results because it offers the best compression
ratio of any other utility, including the latest 'xz' utility:
http://fixunix.com/kernel/238089-response-kernel-compression-e-mail-few-months-ago.html

$ xz -9 linux-2.6.16.17.tar

$ du -sk * | sort -n
32392 linux-2.6.16.17.tar.7z
32404 linux-2.6.16.17.tar.xz
33520 linux-2.6.16.17.tar.lzma
33760 linux-2.6.16.17.tar.rar
38064 linux-2.6.16.17.tar.rz
39472 linux-2.6.16.17.tar.szip
39520 linux-2.6.16.17.tar.bz
39936 linux-2.6.16.17.tar.bz2
40000 linux-2.6.16.17.tar.bicom
40656 linux-2.6.16.17.tar.sit
47664 linux-2.6.16.17.tar.lha
49968 linux-2.6.16.17.tar.dzip
50000 linux-2.6.16.17.tar.gz
51344 linux-2.6.16.17.tar.arj
57552 linux-2.6.16.17.tar.lzo
57984 linux-2.6.16.17.tar.F
81136 linux-2.6.16.17.tar.Z
94544 linux-2.6.16.17.tar.zoo
101216 linux-2.6.16.17.tar.arc
228608 linux-2.6.16.17.tar

=== COMPRESSION RESULTS:

-rw-r--r-- 1 abc users 155M 2010-02-28 09:02 results-20100228.tar.7z
-rw-r--r-- 1 abc users 290M 2010-02-28 08:42 results-20100228.tar.bz2
-rw-r--r-- 1 abc users 2.3G 2010-02-28 08:42 results-20100228.tar

=== LOCATION:

http://liquidswords.org/~war/results-20100228.tar.7z
wget http://liquidswords.org/~war/results-20100228.tar.7z

=== MD5 CHECKSUM:

$ md5sum *
1db01600ce2700854b4bafcfd68f7028  results-20100228.tar.7z
35793b283edf5c0f38738276812aad52  results-20100228.tar

=== VERIFICATION: MAKE SURE IT WORKS FOR OTHERS:

$ wget http://liquidswords.org/~war/results-20100228.tar.7z
--2010-02-28 09:48:36--  http://liquidswords.org/~war/results-20100228.tar.7z
Resolving liquidswords.org... 71.6.165.232
Connecting to liquidswords.org|71.6.165.232|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 161814574 (154M) [application/x-tar]
Saving to: "results-20100228.tar.7z"

100%[======================================>] 161,814,574 2.00M/s   in 69s

$

$ md5sum *7z
1db01600ce2700854b4bafcfd68f7028  results-20100228.tar.7z

CORRECT

$ 7z x results-20100228.tar.7z

7-Zip  4.58 beta  Copyright (c) 1999-2008 Igor Pavlov  2008-05-05
p7zip Version 4.58 (locale=en_US,Utf16=on,HugeFiles=on,8 CPUs)

Processing archive: results-20100228.tar.7z

Extracting  results-20100228.tar

Everything is Ok

Size:       2382561280
Compressed: 161814574

$ md5sum *tar
35793b283edf5c0f38738276812aad52  results-20100228.tar

CORRECT

Again, the trace information details:

p63:~/results-20100228# du -sh *
570M    blktrace1       => -o data=writeback,nobarrier
570M    blktrace1-redo  => -o data=writeback,nobarrier
563M    blktrace2       => -o data=writeback,nobarrier,nodelalloc
570M    blktrace3       => -o data=nobarrier
4.0K    script
p63:~/results-20100228#

Let me know if you need anything else, thanks.

Justin.

