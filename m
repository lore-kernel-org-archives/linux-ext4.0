From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 73051] New: Hung Tasks possibly related to ext4 IO
Date: Thu, 27 Mar 2014 20:26:48 +0000
Message-ID: <bug-73051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbaC0U0w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Mar 2014 16:26:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0480620253
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2014 20:26:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 82460201EF
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2014 20:26:49 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=73051

            Bug ID: 73051
           Summary: Hung Tasks possibly related to ext4 IO
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: nik.martin@gmail.com
        Regression: No

When my computer is doing any task that creates a moderate amount of IO, I get
a hung task, and the call trace is always as follows.  This usually force a
reboot via sysctl+REISUB. In this case I was compiling a java project in
Android Studio.  I build my own kernel out of mainline stable branch:
Linux xyz-deb 3.13.6-201403190021nik-deb-dirty #4 SMP PREEMPT Wed Mar 19
00:31:09 CDT 2014 x86_64 GNU/Linux

Mar 27 14:51:18 xyz-deb kernel: [259345.574164] INFO: task
BrowserBlocking:11047 blocked for more than 120 seconds.
Mar 27 14:51:18 xyz-deb kernel: [259345.574172]       Tainted: P           O
3.13.6-201403190021xyz-deb-dirty #4
Mar 27 14:51:18 xyz-deb kernel: [259345.574175] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 14:51:18 xyz-deb kernel: [259345.574179] BrowserBlocking D
ffff8800b93acb68     0 11047      1 0x00000000
Mar 27 14:51:18 xyz-deb kernel: [259345.574187]  ffff8800b93ac840
0000000000000082 0000000000000004 ffff880235cfe740
Mar 27 14:51:18 xyz-deb kernel: [259345.574193]  0000000000012dc0
ffff8801e63d3fd8 0000000000012dc0 ffff8800b93ac840
Mar 27 14:51:18 xyz-deb kernel: [259345.574199]  0000000000000000
ffff8800b93ac840 ffff88023ec93600 ffff8801e63d3da0
Mar 27 14:51:18 xyz-deb kernel: [259345.574205] Call Trace:
Mar 27 14:51:18 xyz-deb kernel: [259345.574216]  [<ffffffff810fe240>] ?
__lock_page+0x80/0x80
Mar 27 14:51:18 xyz-deb kernel: [259345.574224]  [<ffffffff8146aea8>] ?
io_schedule+0x88/0xe0
Mar 27 14:51:18 xyz-deb kernel: [259345.574230]  [<ffffffff810fe249>] ?
sleep_on_page+0x9/0x20
Mar 27 14:51:18 xyz-deb kernel: [259345.574236]  [<ffffffff8146b432>] ?
__wait_on_bit+0x52/0x80
Mar 27 14:51:18 xyz-deb kernel: [259345.574241]  [<ffffffff810fe373>] ?
wait_on_page_bit+0x73/0x80
Mar 27 14:51:18 xyz-deb kernel: [259345.574248]  [<ffffffff81082180>] ?
wake_atomic_t_function+0x40/0x40
Mar 27 14:51:18 xyz-deb kernel: [259345.574253]  [<ffffffff810fe450>] ?
filemap_fdatawait_range+0xd0/0x160
Mar 27 14:51:18 xyz-deb kernel: [259345.574259]  [<ffffffff810ff9ec>] ?
__filemap_fdatawrite_range+0x4c/0x60
Mar 27 14:51:18 xyz-deb kernel: [259345.574264]  [<ffffffff810ffa39>] ?
filemap_write_and_wait_range+0x39/0x60
Mar 27 14:51:18 xyz-deb kernel: [259345.574298]  [<ffffffffa00d5256>] ?
ext4_sync_file+0xb6/0x340 [ext4]
Mar 27 14:51:18 xyz-deb kernel: [259345.574305]  [<ffffffff8118a068>] ?
do_fsync+0x48/0x80
Mar 27 14:51:18 xyz-deb kernel: [259345.574310]  [<ffffffff8118a2ee>] ?
SyS_fdatasync+0xe/0x20
Mar 27 14:51:18 xyz-deb kernel: [259345.574317]  [<ffffffff81473ce2>] ?
system_call_fastpath+0x16/0x1b
Mar 27 14:53:18 xyz-deb kernel: [259465.752466] INFO: task
BrowserBlocking:11047 blocked for more than 120 seconds.
Mar 27 14:53:18 xyz-deb kernel: [259465.752475]       Tainted: P           O
3.13.6-201403190021xyz-deb-dirty #4
Mar 27 14:53:18 xyz-deb kernel: [259465.752478] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 14:53:18 xyz-deb kernel: [259465.752482] BrowserBlocking D
ffff8800b93acb68     0 11047      1 0x00000000
Mar 27 14:53:18 xyz-deb kernel: [259465.752489]  ffff8800b93ac840
0000000000000082 0000000000000004 ffff880235cfe740
Mar 27 14:53:18 xyz-deb kernel: [259465.752496]  0000000000012dc0
ffff8801e63d3fd8 0000000000012dc0 ffff8800b93ac840
Mar 27 14:53:18 xyz-deb kernel: [259465.752502]  0000000000000000
ffff8800b93ac840 ffff88023ec93600 ffff8801e63d3da0
Mar 27 14:53:18 xyz-deb kernel: [259465.752508] Call Trace:
Mar 27 14:53:18 xyz-deb kernel: [259465.752519]  [<ffffffff810fe240>] ?
__lock_page+0x80/0x80
Mar 27 14:53:18 xyz-deb kernel: [259465.752528]  [<ffffffff8146aea8>] ?
io_schedule+0x88/0xe0
Mar 27 14:53:18 xyz-deb kernel: [259465.752533]  [<ffffffff810fe249>] ?
sleep_on_page+0x9/0x20
Mar 27 14:53:18 xyz-deb kernel: [259465.752539]  [<ffffffff8146b432>] ?
__wait_on_bit+0x52/0x80
Mar 27 14:53:18 xyz-deb kernel: [259465.752544]  [<ffffffff810fe373>] ?
wait_on_page_bit+0x73/0x80
Mar 27 14:53:18 xyz-deb kernel: [259465.752551]  [<ffffffff81082180>] ?
wake_atomic_t_function+0x40/0x40
Mar 27 14:53:18 xyz-deb kernel: [259465.752556]  [<ffffffff810fe450>] ?
filemap_fdatawait_range+0xd0/0x160
Mar 27 14:53:18 xyz-deb kernel: [259465.752562]  [<ffffffff810ff9ec>] ?
__filemap_fdatawrite_range+0x4c/0x60
Mar 27 14:53:18 xyz-deb kernel: [259465.752567]  [<ffffffff810ffa39>] ?
filemap_write_and_wait_range+0x39/0x60
Mar 27 14:53:18 xyz-deb kernel: [259465.752600]  [<ffffffffa00d5256>] ?
ext4_sync_file+0xb6/0x340 [ext4]
Mar 27 14:53:18 xyz-deb kernel: [259465.752607]  [<ffffffff8118a068>] ?
do_fsync+0x48/0x80
Mar 27 14:53:18 xyz-deb kernel: [259465.752613]  [<ffffffff8118a2ee>] ?
SyS_fdatasync+0xe/0x20
Mar 27 14:53:18 xyz-deb kernel: [259465.752619]  [<ffffffff81473ce2>] ?
system_call_fastpath+0x16/0x1b
Mar 27 14:55:01 xyz-deb /USR/SBIN/CRON[29006]: (root) CMD (command -v
debian-sa1 > /dev/null && debian-sa1 1 1)
Mar 27 14:55:18 xyz-deb kernel: [259585.930755] INFO: task
BrowserBlocking:11047 blocked for more than 120 seconds.
Mar 27 14:55:18 xyz-deb kernel: [259585.930764]       Tainted: P           O
3.13.6-201403190021xyz-deb-dirty #4
Mar 27 14:55:18 xyz-deb kernel: [259585.930767] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 14:55:18 xyz-deb kernel: [259585.930777] BrowserBlocking D
ffff8800b93acb68     0 11047      1 0x00000000
Mar 27 14:55:18 xyz-deb kernel: [259585.930785]  ffff8800b93ac840
0000000000000082 0000000000000004 ffff880235cfe740
Mar 27 14:55:18 xyz-deb kernel: [259585.930792]  0000000000012dc0
ffff8801e63d3fd8 0000000000012dc0 ffff8800b93ac840
Mar 27 14:55:18 xyz-deb kernel: [259585.930797]  0000000000000000
ffff8800b93ac840 ffff88023ec93600 ffff8801e63d3da0
Mar 27 14:55:18 xyz-deb kernel: [259585.930804] Call Trace:
Mar 27 14:55:18 xyz-deb kernel: [259585.930815]  [<ffffffff810fe240>] ?
__lock_page+0x80/0x80
Mar 27 14:55:18 xyz-deb kernel: [259585.930823]  [<ffffffff8146aea8>] ?
io_schedule+0x88/0xe0
Mar 27 14:55:18 xyz-deb kernel: [259585.930828]  [<ffffffff810fe249>] ?
sleep_on_page+0x9/0x20
Mar 27 14:55:18 xyz-deb kernel: [259585.930835]  [<ffffffff8146b432>] ?
__wait_on_bit+0x52/0x80
Mar 27 14:55:18 xyz-deb kernel: [259585.930840]  [<ffffffff810fe373>] ?
wait_on_page_bit+0x73/0x80
Mar 27 14:55:18 xyz-deb kernel: [259585.930846]  [<ffffffff81082180>] ?
wake_atomic_t_function+0x40/0x40
Mar 27 14:55:18 xyz-deb kernel: [259585.930852]  [<ffffffff810fe450>] ?
filemap_fdatawait_range+0xd0/0x160
Mar 27 14:55:18 xyz-deb kernel: [259585.930857]  [<ffffffff810ff9ec>] ?
__filemap_fdatawrite_range+0x4c/0x60
Mar 27 14:55:18 xyz-deb kernel: [259585.930862]  [<ffffffff810ffa39>] ?
filemap_write_and_wait_range+0x39/0x60
Mar 27 14:55:18 xyz-deb kernel: [259585.930895]  [<ffffffffa00d5256>] ?
ext4_sync_file+0xb6/0x340 [ext4]
Mar 27 14:55:18 xyz-deb kernel: [259585.930902]  [<ffffffff8118a068>] ?
do_fsync+0x48/0x80
Mar 27 14:55:18 xyz-deb kernel: [259585.930908]  [<ffffffff8118a2ee>] ?
SyS_fdatasync+0xe/0x20
Mar 27 14:55:18 xyz-deb kernel: [259585.930915]  [<ffffffff81473ce2>] ?
system_call_fastpath+0x16/0x1b



To add some information, here is how my filesystem is laid out:
Filesystem                 Size  Used Avail Use% Mounted on
rootfs                     9.7G  553M  8.7G   6% /
udev                        10M     0   10M   0% /dev
tmpfs                      790M  568K  789M   1% /run
/dev/mapper/xyz--deb-root  9.7G  553M  8.7G   6% /
tmpfs                      5.0M     0  5.0M   0% /run/lock
tmpfs                      4.8G   79M  4.7G   2% /run/shm
/dev/sda1                  228M   46M  170M  22% /boot
tmpfs                      3.9G   12M  3.9G   1% /tmp
/dev/mapper/xyz--deb-usr   8.2G  5.9G  1.8G  77% /usr
/dev/mapper/xyz--deb-var   2.7G  1.3G  1.3G  50% /var
/dev/bcache0               394G  100G  275G  27% /home
tmpfs                      256M     0  256M   0% /home/nmartin/.chromecache

sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
udev on /dev type devtmpfs (rw,relatime,size=10240k,nr_inodes=1009238,mode=755)
devpts on /dev/pts type devpts
(rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,noexec,relatime,size=808044k,mode=755)
/dev/mapper/xyz--deb-root on / type ext4
(rw,relatime,errors=remount-ro,stripe=4,data=ordered)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
tmpfs on /run/shm type tmpfs (rw,nosuid,nodev,noexec,relatime,size=4949400k)
/dev/sda1 on /boot type ext2 (rw,relatime,errors=continue)
tmpfs on /tmp type tmpfs (rw,relatime)
/dev/mapper/xyz--deb-usr on /usr type ext4 (rw,relatime,data=ordered)
/dev/mapper/xyz--deb-var on /var type ext4 (rw,relatime,data=ordered)
/dev/bcache0 on /home type ext4 (rw,relatime,data=ordered)
tmpfs on /home/nmartin/.chromecache type tmpfs
(rw,nosuid,nodev,noatime,size=262144k)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,nosuid,nodev,noexec,relatime)

I have a 55 GB partition on an SSD that is a bcache cache of /home, which is an
lv

  --- Physical volume ---
  PV Name               /dev/sda5
  VG Name               xyz-deb
  PV Size               1.82 TiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              476870
  Free PE               262486
  Allocated PE          214384
  PV UUID               VNCi4f-9rZl-T7dd-TETi-URJ7-SsYi-JQnmoO

  --- Volume group ---
  VG Name               xyz-deb
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  13
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                7
  Open LV               5
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1.82 TiB
  PE Size               4.00 MiB
  Total PE              476870
  Alloc PE / Size       214384 / 837.44 GiB
  Free  PE / Size       262486 / 1.00 TiB
  VG UUID               EHBENC-dT2G-SxxB-fBNd-3zV2-vorO-16xV34


--- Logical volume ---
  LV Path                /dev/xyz-deb/root
  LV Name                root
  VG Name                xyz-deb
  LV UUID                nUS1LF-VIPc-1KNp-Nu8Y-Sabv-pe5a-nJfn8k
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:03 -0600
  LV Status              available
  # open                 1
  LV Size                10.00 GiB
  Current LE             2560
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/xyz-deb/usr
  LV Name                usr
  VG Name                xyz-deb
  LV UUID                6cNQ6o-4rMI-8NGO-6gYD-ADE2-pf3g-uVoB8C
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:03 -0600
  LV Status              available
  # open                 1
  LV Size                8.38 GiB
  Current LE             2145
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

  --- Logical volume ---
  LV Path                /dev/xyz-deb/var
  LV Name                var
  VG Name                xyz-deb
  LV UUID                wIojaY-ju1D-wcVb-WyJI-8264-Txy0-WMaRLd
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:03 -0600
  LV Status              available
  # open                 1
  LV Size                2.79 GiB
  Current LE             715
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3

  --- Logical volume ---
  LV Path                /dev/xyz-deb/swap_1
  LV Name                swap_1
  VG Name                xyz-deb
  LV UUID                KNevOm-qWv0-TdKm-wfkZ-GFNJ-Xjox-SkTTT4
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:03 -0600
  LV Status              available
  # open                 2
  LV Size                15.89 GiB
  Current LE             4069
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/xyz-deb/tmp
  LV Name                tmp
  VG Name                xyz-deb
  LV UUID                3RgsAJ-I6CM-ChT9-nlJI-scPd-eIEA-BVnmis
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:04 -0600
  LV Status              available
  # open                 0
  LV Size                380.00 MiB
  Current LE             95
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4

  --- Logical volume ---
  LV Path                /dev/xyz-deb/home
  LV Name                home
  VG Name                xyz-deb
  LV UUID                oX5edl-Dut2-67rF-j7Dr-Nrx3-7wLf-2JZljv
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2013-11-22 14:47:04 -0600
  LV Status              available
  # open                 0
  LV Size                400.00 GiB
  Current LE             102400
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:5

  --- Logical volume ---
  LV Path                /dev/xyz-deb/home-cache
  LV Name                home-cache
  VG Name                xyz-deb
  LV UUID                ZFf8rc-IRbm-1uSi-6iAW-7I8r-bMSA-di75Bk
  LV Write Access        read/write
  LV Creation host, time xyz-deb, 2014-02-01 19:50:47 -0600
  LV Status              available
  # open                 1
  LV Size                400.00 GiB
  Current LE             102400
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
