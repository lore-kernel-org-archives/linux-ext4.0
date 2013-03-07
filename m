From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [BUG][Bigalloc] applictions will be blocked for more than 120s when
 we run xfstests #083
Date: Thu, 7 Mar 2013 20:11:49 +0800
Message-ID: <20130307121149.GB2800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54373 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3CGL4h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 06:56:37 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so418220pad.27
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2013 03:56:37 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This bug has been confirmed by Ted and Lukas.  When we run xfstests #083
in a ext4 file system with bigalloc feature, it will be blocked for more
than 120s.  I hit this bug in 3.8 kernel, and I can confirm that it
doesn't be fixed in dev branch until now.  This bug is very hard to be
hitted in my sand box.  I need to run the following commands to trigger
it.

  for i in {0..9}
  do
    ./check 083
  done

My sand box is a Dell Desktop with a Intel(R) Core(TM)2 Duo CPU E8400
@ 3.00GHz, 4G memory, a 160G HDD and a Intel SSD.  The test runs against
SSD.

In 3.8 kernel, we will get the follwing messages from dmesg, and will
be blocked for more than 120s:

Mar  7 15:15:17 lz-desktop wenqing: run xfstest 083 
Mar  7 15:15:17 lz-desktop kernel: EXT4-fs (sda2): mounted filesystem
with ordered data mode. Opts: acl,user_xattr
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): delayed block
allocation failed for inode 32 at logical offset 631 with max blocks 29
 with error -28 
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): This should not
happen!! Data will be lost
Mar  7 15:15:18 lz-desktop kernel:
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Total free blocks count 288
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Free/Dirty block details
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): free_blocks=288
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): dirty_blocks=96
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): Block reservation details
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): i_reserved_data_blocks=3
Mar  7 15:15:18 lz-desktop kernel: EXT4-fs (sda2): i_reserved_meta_blocks=3

These messages *disappears* in dev branch because Lukas's patches.

But we still are blocked for more than 120s as below (after running 9
times):

wenqing: run xfstest 083
kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,
user_xattr
kernel: INFO: task fsstress:9190 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9190   9189 0x00000000
kernel: ffff88010878dd58 0000000000000086 ffff880102928230 ffff88010878c010
kernel: ffff880110d526f0 0000000000012080 ffff88010878dfd8 0000000000004000
kernel: ffff88010878dfd8 0000000000012080 ffffffff82613410 ffff880110d526f0
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205e797>] ? enqueue_task_fair+0x14a/0x16c
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9191 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000001     0  9191   9189 0x00000000
kernel: ffff880102db3d58 0000000000000086 ffff88011238ad18 ffff880102db2010
kernel: ffff880112d3a6f0 0000000000012080 ffff880102db3fd8 0000000000004000
kernel: ffff880102db3fd8 0000000000012080 ffff880112c84670 ffff880112d3a6f0
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205da55>] ? check_preempt_wakeup+0x11a/0x1b6
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9192 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9192   9189 0x00000000
kernel: ffff880112317d58 0000000000000086 0000000000000000 ffff880112316010
kernel: ffff880112c1b950 0000000000012080 ffff880112317fd8 0000000000004000
kernel: ffff880112317fd8 0000000000012080 ffff880112c5ad50 ffff880112c1b950
kernel: Call Trace:
kernel: [<ffffffff820b02c3>] ? find_get_pages_tag+0xfb/0x130
kernel: [<ffffffff8237ebe7>] ? __schedule+0x740/0x7d2
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9193 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9193   9189 0x00000000
kernel: ffff8801122f7d58 0000000000000082 ffffffffa01f5eea ffff8801122f6010
kernel: ffff8801128492b0 0000000000012080 ffff8801122f7fd8 0000000000004000
kernel: ffff8801122f7fd8 0000000000012080 ffffffff82613410 ffff8801128492b0
kernel: Call Trace:
kernel: [<ffffffffa01f5eea>] ? ext4_release_file+0xb2/0xb2 [ext4]
kernel: [<ffffffff821074eb>] ? mntput+0x2a/0x2c
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205e797>] ? enqueue_task_fair+0x14a/0x16c
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9194 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9194   9189 0x00000000
kernel: ffff88010371bd58 0000000000000086 ffff88011238ad18 ffff88010371a010
kernel: ffff880112c5ad50 0000000000012080 ffff88010371bfd8 0000000000004000
kernel: ffff88010371bfd8 0000000000012080 ffffffff82613410 ffff880112c5ad50
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205e797>] ? enqueue_task_fair+0x14a/0x16c
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9195 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000001     0  9195   9189 0x00000000
kernel: ffff8801036f3d58 0000000000000086 ffff88011238ad18 ffff8801036f2010
kernel: ffff880112c912f0 0000000000012080 ffff8801036f3fd8 0000000000004000
kernel: ffff8801036f3fd8 0000000000012080 ffff88011331d950 ffff880112c912f0
kernel: Call Trace:
kernel: [<ffffffff8201e533>] ? native_smp_send_reschedule+0x5c/0x5e
kernel: [<ffffffff82055b9e>] ? resched_task+0x61/0x63
kernel: [<ffffffff8205da8f>] ? check_preempt_wakeup+0x154/0x1b6
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9196 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9196   9189 0x00000000
kernel: ffff8801081d9d58 0000000000000082 ffff88011238ad18 ffff8801081d8010
kernel: ffff88011238a6b0 0000000000012080 ffff8801081d9fd8 0000000000004000
kernel: ffff8801081d9fd8 0000000000012080 ffff880112d0a0d0 ffff88011238a6b0
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205da55>] ? check_preempt_wakeup+0x11a/0x1b6
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9197 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000001     0  9197   9189 0x00000000
kernel: ffff88011087bd58 0000000000000086 ffff8801110c0800 ffff88011087a010
kernel: ffff880112c84670 0000000000012080 ffff88011087bfd8 0000000000004000
kernel: ffff88011087bfd8 0000000000012080 ffff880112cd4c90 ffff880112c84670
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205e797>] ? enqueue_task_fair+0x14a/0x16c
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9198 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000000     0  9198   9189 0x00000000
kernel: ffff880110993d58 0000000000000082 ffff88011238ad18 ffff880110992010
kernel: ffff880112c1a0d0 0000000000012080 ffff880110993fd8 0000000000004000
kernel: ffff880110993fd8 0000000000012080 ffff88011238a6b0 ffff880112c1a0d0
kernel: Call Trace:
kernel: [<ffffffff820b02c3>] ? find_get_pages_tag+0xfb/0x130
kernel: [<ffffffff8205da8f>] ? check_preempt_wakeup+0x154/0x1b6
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b
kernel: INFO: task fsstress:9199 blocked for more than 120 seconds.
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: fsstress        D 0000000000000001     0  9199   9189 0x00000000
kernel: ffff88010365dd58 0000000000000082 ffff880101128170 ffff88010365c010
kernel: ffff880112cec0d0 0000000000012080 ffff88010365dfd8 0000000000004000
kernel: ffff88010365dfd8 0000000000012080 ffff88011331d950 ffff880112cec0d0
kernel: Call Trace:
kernel: [<ffffffff8205c88d>] ? sched_clock_local+0x1c/0x82
kernel: [<ffffffff8205e797>] ? enqueue_task_fair+0x14a/0x16c
kernel: [<ffffffff8237ef2f>] schedule+0x64/0x66
kernel: [<ffffffff8237d4cc>] schedule_timeout+0x2b/0x178
kernel: [<ffffffff8205c547>] ? ttwu_do_activate.clone.0+0x3f/0x44
kernel: [<ffffffff8237edbc>] wait_for_common+0xbd/0x112
kernel: [<ffffffff8205c76a>] ? try_to_wake_up+0x21e/0x21e
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8237eec9>] wait_for_completion+0x1d/0x1f
kernel: [<ffffffff821105c8>] sync_inodes_sb+0xb3/0x198
kernel: [<ffffffff82114559>] ? fdatawrite_one_bdev+0x18/0x18
kernel: [<ffffffff8211456d>] sync_inodes_one_sb+0x14/0x16
kernel: [<ffffffff820f0f0a>] iterate_supers+0x6d/0xbf
kernel: [<ffffffff821145a4>] sys_sync+0x35/0x83
kernel: [<ffffffff82386942>] system_call_fastpath+0x16/0x1b

Regards,
                                                - Zheng
