From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Wed, 03 Aug 2016 02:10:02 +0000
Message-ID: <bug-76261-13602-jhvIFda8en@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbcHCCRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2016 22:17:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9C110203AB
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 02:10:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E5375203A1
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 02:10:02 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

yongjun xiao <yongjun.xiao@spreadtrum.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yongjun.xiao@spreadtrum.com

--- Comment #15 from yongjun xiao <yongjun.xiao@spreadtrum.com> ---
Hi all,
   I meet the same bug with kernel3.10.65 as the following:
>[26287.698059] c1 EXT4-fs (mmcblk0p24): ext4_da_writepages: jbd2_start: 2048 pages, ino 59319; err -30
[26287.698089] c1 EXT4-fs (mmcblk0p24): ext4_da_writepages: jbd2_start: 2048
pages, ino 59319; err -30
[26287.698089] c1 EXT4-fs (mmcblk0p24): ext4_da_writepages: jbd2_start: 2048
pages, ino 59319; err -30
[26287.698120] c1 EXT4-fs (mmcblk0p24): ext4_da_writepages: jbd2_start: 2048
pages, ino 59319; err -30
[26287.510345] c1 EXT4-fs (mmcblk0p24): ext4_da_writepages: jbd2_start: 1024
pages, ino 59319; err -30
......

And at last caused kernel crash.
you can see many threads blocked:

crash> ps | grep UN
      1      0   0  dc054000  UN   0.1    1168    508  init
     25      2   3  dc08b300  UN   0.0       0      0  [kworker/3:0]
     88      2   0  dc9e1980  UN   0.0       0      0  [sprd_tb_thread]
     89      2   2  dc9e1dc0  UN   0.0       0      0  [sprd_hotplug]
    194      1   0  dd2c1100  UN   0.2    2208    840  perfprofd
    210      1   0  dd2c3300  UN   0.0     376     84  batterysrv
    300      1   0  dd60f740  UN   0.2    6876   1160  collect_apr
   1465    256   2  d803c000  UN  14.9  820188  78000  system_server
   1478    256   3  d825e640  UN  14.9  820188  78000  android.bg
   1479    256   3  d803d980  UN  14.9  820188  78000  ActivityManager
   1489    256   1  dd293b80  UN  14.9  820188  78000  CpuTracker
   1532    256   0  dd67b300  UN  14.9  820188  78000  InputReader
   1552    256   1  d8031980  UN  14.9  820188  78000  UEventObserver
   1615    256   2  d8046ec0  UN   9.6  598176  50240  ndroid.systemui
   2034    256   2  d9713b80  UN   3.7  529732  19416  .android.dialer
   2145    256   0  d9100880  UN  14.9  820188  78000  watchdog
   2592    256   3  d7a10440  UN  14.9  820188  78000  Thread-164
   2616    256   2  d97b9100  UN  14.9  820188  78000  Error dump: sys
   2638      1   0  d61b8440  UN   0.4  243412   2116  ylog
crash> 
crash> bt 1
PID: 1      TASK: dc054000  CPU: 0   COMMAND: "init"
 #0 [<c05a8364>] (__schedule) from [<c05a6a08>]
 #1 [<c05a6a08>] (schedule_timeout) from [<c05a7a80>]
 #2 [<c05a7a80>] (__down) from [<c003fab4>]
 #3 [<c003fab4>] (down) from [<c0389110>]
 #4 [<c0389110>] (_mmc_blk_suspend) from [<c037e824>]
 #5 [<c037e824>] (mmc_bus_shutdown) from [<c024a8e4>]
 #6 [<c024a8e4>] (device_shutdown) from [<c0030924>]
 #7 [<c0030924>] (kernel_restart) from [<c0030ad8>]
 #8 [<c0030ad8>] (sys_reboot) from [<c000f1c0>]
    pc : [<0005c4c0>]    lr : [<00016071>]    psr: 200e0010
    sp : be8f79b8  ip : be8f79c8  fp : 0007c657
    r10: 0007adb9  r9 : 0007beb8  r8 : 0007c64a
    r7 : 00000058  r6 : 00000000  r5 : 00000000  r4 : 00000000
    r3 : be8f7a07  r2 : a1b2c3d4  r1 : 28121969  r0 : fee1dead
    Flags: nzCv  IRQs on  FIQs on  Mode USER_32  ISA ARM
crash> 
>when reboot,init thread was blocked.

crash> bt 25
PID: 25     TASK: dc08b300  CPU: 3   COMMAND: "kworker/3:0"
 #0 [<c05a8364>] (__schedule) from [<c05a885c>]
 #1 [<c05a885c>] (io_schedule) from [<c00eb68c>]
 #2 [<c00eb68c>] (sleep_on_buffer) from [<c05a6c10>]
 #3 [<c05a6c10>] (__wait_on_bit) from [<c05a6cd4>]
 #4 [<c05a6cd4>] (out_of_line_wait_on_bit) from [<c00eef4c>]
 #5 [<c00eef4c>] (__sync_dirty_buffer) from [<c014d054>]
 #6 [<c014d054>] (ext4_commit_super) from [<c014d1f4>]
 #7 [<c014d1f4>] (ext4_mark_recovery_complete) from [<c014eb24>]
 #8 [<c014eb24>] (ext4_remount) from [<c00c9360>]
 #9 [<c00c9360>] (do_remount_sb) from [<c00c9490>]
#10 [<c00c9490>] (do_emergency_remount) from [<c0035bb0>]
#11 [<c0035bb0>] (process_one_work) from [<c00367fc>]
#12 [<c00367fc>] (worker_thread) from [<c003b2f0>]
#13 [<c003b2f0>] (kthread) from [<c000f258>]
crash>

Is this bug fixed?
Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
