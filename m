From: Xupeng Yun <xupeng@xupeng.me>
Subject: Bad performance of ext4 with kernel 3.0.17
Date: Thu, 1 Mar 2012 13:31:58 +0800
Message-ID: <CACaf2aaqxM86DtdZMaaQZfrC+WbLwPjOVd=LmVjk+TvfObYUzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59097 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2CAFci (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 00:32:38 -0500
Received: by pbcup15 with SMTP id up15so454459pbc.19
        for <linux-ext4@vger.kernel.org>; Wed, 29 Feb 2012 21:32:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I just set up a new server (Gentoo 64bit with kernel 3.0.17) with 4 x
15000RPM SAS disks(sdc, sdd, sde and sdf), and created soft RAID10 on
top of them, the partitions are aligned at 1MB:

    # fdisk -lu /dev/sd{c,e,d,f}

    Disk /dev/sdc: 600.1 GB, 600127266816 bytes
    255 heads, 63 sectors/track, 72961 cylinders, total 1172123568 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xdd96eace

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdc1            2048  1172123567   586060760   fd  Linux raid
autodetect

    Disk /dev/sde: 600.1 GB, 600127266816 bytes
    3 heads, 63 sectors/track, 6201712 cylinders, total 1172123568 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xf869ba1c

       Device Boot      Start         End      Blocks   Id  System
    /dev/sde1            2048  1172123567   586060760   fd  Linux raid
autodetect

    Disk /dev/sdd: 600.1 GB, 600127266816 bytes
    81 heads, 63 sectors/track, 229693 cylinders, total 1172123568 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xf869ba1c

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdd1            2048  1172123567   586060760   fd  Linux raid
autodetect

    Disk /dev/sdf: 600.1 GB, 600127266816 bytes
    81 heads, 63 sectors/track, 229693 cylinders, total 1172123568 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xb4893c3c

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdf1            2048  1172123567   586060760   fd  Linux raid
autodetect


and here is the RAID 10 (md3) with 64K chunk size:

    cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid10]
    md3 : active raid10 sdf1[3] sde1[2] sdd1[1] sdc1[0]
          1172121344 blocks 64K chunks 2 near-copies [4/4] [UUUU]

    md1 : active raid1 sda1[0] sdb1[1]
          112320 blocks [2/2] [UU]

    md2 : active raid1 sda2[0] sdb2[1]
          41953664 blocks [2/2] [UU]

    unused devices: <none>

I did IO testing with `fio` against the raw RAID device (md3), and the
result looks good(read IOPS 1723 / write IOPS 168):

    # fio --filename=/dev/md3 --direct=1 --rw=randrw --bs=16k
--size=5G --numjobs=16 --runtime=60 --group_reporting --name=file1
--rwmixread=90 --thread --ioengine=p
    file1: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
    ...
    file1: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
    fio 2.0.3
    Starting 16 threads
    Jobs: 16 (f=16): [mmmmmmmmmmmmmmmm] [100.0% done] [28234K/2766K
/s] [1723 /168  iops] [eta 00m:00s]
    file1: (groupid=0, jobs=16): err= 0: pid=17107
      read : io=1606.3MB, bw=27406KB/s, iops=1712 , runt= 60017msec
        clat (usec): min=221 , max=123233 , avg=7693.00, stdev=7734.82
         lat (usec): min=221 , max=123233 , avg=7693.12, stdev=7734.82
        clat percentiles (usec):
         |  1.00th=[ 1128],  5.00th=[ 1560], 10.00th=[ 1928], 20.00th=[ 2640],
         | 30.00th=[ 3376], 40.00th=[ 4128], 50.00th=[ 4896], 60.00th=[ 6304],
         | 70.00th=[ 8256], 80.00th=[11200], 90.00th=[16768], 95.00th=[23168],
         | 99.00th=[38656], 99.50th=[45824], 99.90th=[62720]
        bw (KB/s)  : min=  888, max=13093, per=7.59%, avg=2079.11, stdev=922.54
      write: io=183840KB, bw=3063.2KB/s, iops=191 , runt= 60017msec
        clat (msec): min=1 , max=153 , avg=14.70, stdev=14.59
         lat (msec): min=1 , max=153 , avg=14.70, stdev=14.59
        clat percentiles (usec):
         |  1.00th=[ 1816],  5.00th=[ 2544], 10.00th=[ 3248], 20.00th=[ 4512],
         | 30.00th=[ 5728], 40.00th=[ 7648], 50.00th=[ 9536], 60.00th=[12480],
         | 70.00th=[16320], 80.00th=[22144], 90.00th=[32640], 95.00th=[43264],
         | 99.00th=[71168], 99.50th=[82432], 99.90th=[111104]
        bw (KB/s)  : min=   90, max= 5806, per=33.81%, avg=1035.45, stdev=973.10
        lat (usec) : 250=0.05%, 500=0.09%, 750=0.05%, 1000=0.19%
        lat (msec) : 2=9.61%, 4=26.05%, 10=38.46%, 20=16.82%, 50=8.02%
        lat (msec) : 100=0.63%, 250=0.03%
      cpu          : usr=1.02%, sys=2.87%, ctx=1926728, majf=0, minf=288891
      IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%,
32=0.0%, >=64=0.0%
         submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
64=0.0%, >=64=0.0%
         complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
64=0.0%, >=64=0.0%
         issued    : total=r=102801/w=11490/d=0, short=r=0/w=0/d=0

    Run status group 0 (all jobs):
       READ: io=1606.3MB, aggrb=27405KB/s, minb=28063KB/s,
maxb=28063KB/s, mint=60017msec, maxt=60017msec
      WRITE: io=183840KB, aggrb=3063KB/s, minb=3136KB/s,
maxb=3136KB/s, mint=60017msec, maxt=60017msec

    Disk stats (read/write):
        md3: ios=102753/11469, merge=0/0, ticks=0/0, in_queue=0,
util=0.00%, aggrios=25764/5746, aggrmerge=0/0, aggrticks=197378/51351,
aggrin_queue=248718, aggrutil=99.31%
      sdc: ios=26256/5723, merge=0/0, ticks=204328/68364,
in_queue=272668, util=99.20%
      sdd: ios=25290/5723, merge=0/0, ticks=187572/61628,
in_queue=249188, util=98.73%
      sde: ios=25689/5769, merge=0/0, ticks=197340/71828,
in_queue=269172, util=99.31%
      sdf: ios=25822/5769, merge=0/0, ticks=200272/3584,
in_queue=203844, util=97.87%

then I created ext4 filesystem on top of the RAID device and mounted
it to /mnt/test:

    mkfs.ext4 -E stride=16,stripe-width=32 /dev/md3
    mount /dev/md3 /mnt/test -o noatime,nodiratime,data=writeback,nobarrier

after that I did the very same IO testing, but the result looks very
bad(read IOPS 926 / write IOPS 97):

    # fio --filename=/mnt/test/test --direct=1 --rw=randrw --bs=16k
--size=5G --numjobs=16 --runtime=60 --group_reporting --name=file1
--rwmixread=90 --thread --ioengine=psync
    file1: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
    ...
    file1: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
    fio 2.0.3
    Starting 16 threads
    file1: Laying out IO file(s) (1 file(s) / 5120MB)
    Jobs: 16 (f=16): [mmmmmmmmmmmmmmmm] [100.0% done] [15172K/1604K
/s] [926 /97  iops] [eta 00m:00s]
    file1: (groupid=0, jobs=16): err= 0: pid=18764
      read : io=838816KB, bw=13974KB/s, iops=873 , runt= 60025msec
        clat (usec): min=228 , max=111583 , avg=16412.46, stdev=11632.03
         lat (usec): min=228 , max=111583 , avg=16412.60, stdev=11632.03
        clat percentiles (usec):
         |  1.00th=[ 1384],  5.00th=[ 2320], 10.00th=[ 3376], 20.00th=[ 5216],
         | 30.00th=[ 8256], 40.00th=[11456], 50.00th=[14656], 60.00th=[17792],
         | 70.00th=[21376], 80.00th=[25472], 90.00th=[32128], 95.00th=[37632],
         | 99.00th=[50944], 99.50th=[56576], 99.90th=[70144]
        bw (KB/s)  : min=  308, max= 4448, per=6.90%, avg=964.30, stdev=339.53
      write: io=94208KB, bw=1569.5KB/s, iops=98 , runt= 60025msec
        clat (msec): min=1 , max=89 , avg=16.91, stdev=10.24
         lat (msec): min=1 , max=89 , avg=16.92, stdev=10.24
        clat percentiles (usec):
         |  1.00th=[ 2384],  5.00th=[ 3888], 10.00th=[ 5088], 20.00th=[ 7776],
         | 30.00th=[10304], 40.00th=[12736], 50.00th=[15296], 60.00th=[17792],
         | 70.00th=[20864], 80.00th=[24960], 90.00th=[30848], 95.00th=[35584],
         | 99.00th=[47360], 99.50th=[51456], 99.90th=[62208]
        bw (KB/s)  : min=   31, max= 4676, per=62.37%, avg=978.64, stdev=896.53
        lat (usec) : 250=0.01%, 500=0.03%, 750=0.01%, 1000=0.06%
        lat (msec) : 2=3.15%, 4=9.42%, 10=22.23%, 20=31.61%, 50=32.39%
        lat (msec) : 100=1.08%, 250=0.01%
      cpu          : usr=0.59%, sys=2.63%, ctx=1700318, majf=0, minf=19888
      IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%,
32=0.0%, >=64=0.0%
         submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
64=0.0%, >=64=0.0%
         complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
64=0.0%, >=64=0.0%
         issued    : total=r=52426/w=5888/d=0, short=r=0/w=0/d=0

    Run status group 0 (all jobs):
       READ: io=838816KB, aggrb=13974KB/s, minb=14309KB/s,
maxb=14309KB/s, mint=60025msec, maxt=60025msec
      WRITE: io=94208KB, aggrb=1569KB/s, minb=1607KB/s, maxb=1607KB/s,
mint=60025msec, maxt=60025msec

    Disk stats (read/write):
        md3: ios=58848/13987, merge=0/0, ticks=0/0, in_queue=0,
util=0.00%, aggrios=14750/4159, aggrmerge=0/2861,
aggrticks=112418/28260, aggrin_queue=140664, aggrutil=84.95%
      sdc: ios=17688/4221, merge=0/2878, ticks=148664/37972,
in_queue=186628, util=84.95%
      sdd: ios=11801/4219, merge=0/2880, ticks=79396/29192,
in_queue=108572, util=70.71%
      sde: ios=16427/4099, merge=0/2843, ticks=129072/35252,
in_queue=164304, util=81.57%
      sdf: ios=13086/4097, merge=0/2845, ticks=92540/10624,
in_queue=103152, util=60.02%

anything goes wrong here?


--
Xupeng Yun
http://about.me/xupeng
