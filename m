Return-Path: <SRS0=4ybF=RB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5663BC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 06:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 280D9213A2
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 06:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfBZGuL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 01:50:11 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:39678 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfBZGuG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2019 01:50:06 -0500
Received: by mail-io1-f70.google.com with SMTP id a9so9739850iol.6
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2019 22:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pNBuHJLun1rHOc8gVW0SLLF2VdJoZGeB0YR6UXsnGq4=;
        b=D5zyR+v6QOlS15vkdlysKVxY4fFaV2I+o/OW1IGtxg2r1hltzz0G8cg6gDpE+aF8oN
         yNMgRHK98Hrb4RcpspBgYoHPZD6pm3uvdYGUdk0W3MYsSaTdm2AyS05Ypkh4W5JEKAkr
         G61h13VALq9sqWuiaxuGcda/ACYx7eelKnabbJc8KF3ZO4cMjM6Tv90hMfexI/XluEUx
         WwOF4ctydEImozp7gypLJXjdh92FtaSE7GHcDIyXGmCD6vb6kxtIoqKrljFyDJtkY16k
         vxBZZzu7o/TeeIDDAy9bc8jjte3DCqCxRF4cfszif9S/tB0L95QJ+mhEggiMoH8ATnUp
         rMyg==
X-Gm-Message-State: AHQUAuYmbx9PMYHDMuEoqXQJ2OoB1ps2YGsE2i6Al7srAzyrveCZSLWn
        dgHkS8noRMNz0UnSAZK/SMNaraAszGTHQmRHd1mpxb9WEnBc
X-Google-Smtp-Source: AHgI3IaDfDUgyCiO4KjV1yV/jIa0SuEjgYMDfK4VbpVrsc3lH8dk53allNdL4Ly2fLJNeaFUsY6noMc6wuA1LQVWOCtNbWS0F6e2
MIME-Version: 1.0
X-Received: by 2002:a02:3941:: with SMTP id w1mr9916044jae.7.1551163805266;
 Mon, 25 Feb 2019 22:50:05 -0800 (PST)
Date:   Mon, 25 Feb 2019 22:50:05 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a01370582c6772a@google.com>
Subject: INFO: rcu detected stall in ext4_file_write_iter
From:   syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8a61716ff2ab Merge tag 'ceph-for-5.0-rc8' of git://github...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161b71d4c00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
dashboard link: https://syzkaller.appspot.com/bug?extid=7d19c5fe6a3f1161abb7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103908f8c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105e5cd0c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com

audit: type=1400 audit(1550814986.750:36): avc:  denied  { map } for   
pid=8058 comm="syz-executor004" path="/root/syz-executor004991115"  
dev="sda1" ino=1426 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
hrtimer: interrupt took 42841 ns
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 1, t=10502 jiffies, g=5873, q=2)
rcu: All QSes seen, last rcu_preempt kthread activity 10502  
(4295059997-4295049495), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor004 R  running task    26448  8069   8060 0x00000000
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5306 [inline]
  sched_show_task.cold+0x292/0x30b kernel/sched/core.c:5281
  print_other_cpu_stall kernel/rcu/tree.c:1301 [inline]
  check_cpu_stall kernel/rcu/tree.c:1429 [inline]
  rcu_pending kernel/rcu/tree.c:3018 [inline]
  rcu_check_callbacks.cold+0xa10/0xa4a kernel/rcu/tree.c:2521
  update_process_times+0x32/0x80 kernel/time/timer.c:1635
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:161
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1271
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x33e/0xde0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1035 [inline]
  smp_apic_timer_interrupt+0x120/0x570 arch/x86/kernel/apic/apic.c:1060
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:807
  </IRQ>
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x50 kernel/kcov.c:94
Code: e5 08 41 bc f4 ff ff ff e8 11 9f ea ff 48 c7 05 12 fb e5 08 00 00 00  
00 e9 c8 e9 ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 48 89 e5 48  
8b 75 08 65 48 8b 04 25 40 ee 01 00 65 8b 15 38 0c
RSP: 0018:ffff888084ed72c0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: dffffc0000000000 RBX: ffff88809a2205c0 RCX: ffffffff81e7c36c
RDX: 1ffff11013444114 RSI: ffffffff81e7c37a RDI: ffff88809a2208a0
RBP: ffff888084ed7300 R08: ffff88808fa28240 R09: ffffed1015d25bd0
R10: ffffed1015d25bcf R11: ffff8880ae92de7b R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
  __ext4_journal_start fs/ext4/ext4_jbd2.h:311 [inline]
  ext4_dirty_inode+0x64/0xc0 fs/ext4/inode.c:6081
  __mark_inode_dirty+0x919/0x1290 fs/fs-writeback.c:2155
  mark_inode_dirty include/linux/fs.h:2125 [inline]
  __generic_write_end+0x1b9/0x240 fs/buffer.c:2118
  generic_write_end+0x6c/0x90 fs/buffer.c:2163
  ext4_da_write_end+0x3c8/0xa50 fs/ext4/inode.c:3204
  generic_perform_write+0x2f0/0x530 mm/filemap.c:3219
  __generic_file_write_iter+0x25e/0x630 mm/filemap.c:3333
  ext4_file_write_iter+0x33f/0x1160 fs/ext4/file.c:266
  call_write_iter include/linux/fs.h:1863 [inline]
  do_iter_readv_writev+0x5e0/0x8e0 fs/read_write.c:680
  do_iter_write fs/read_write.c:956 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:937
  vfs_iter_write+0x77/0xb0 fs/read_write.c:969
  iter_file_splice_write+0x667/0xbe0 fs/splice.c:749
  do_splice_from fs/splice.c:851 [inline]
  direct_splice_actor+0x126/0x1a0 fs/splice.c:1023
  splice_direct_to_actor+0x369/0x970 fs/splice.c:978
  do_splice_direct+0x1da/0x2a0 fs/splice.c:1066
  do_sendfile+0x597/0xd00 fs/read_write.c:1436
  __do_sys_sendfile64 fs/read_write.c:1491 [inline]
  __se_sys_sendfile64 fs/read_write.c:1483 [inline]
  __x64_sys_sendfile64+0x15a/0x220 fs/read_write.c:1483
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446a59
Code: e8 dc e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fce454e5db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00000000006dcc28 RCX: 0000000000446a59
RDX: 0000000020000000 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 00000000006dcc20 R08: 0000000000000000 R09: 0000000000000000
R10: 00008080fffffffe R11: 0000000000000246 R12: 00000000006dcc2c
R13: 00007ffd7bf04daf R14: 00007fce454e69c0 R15: 20c49ba5e353f7cf
rcu: rcu_preempt kthread starved for 10502 jiffies! g5873 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29200    10      2 0x80000000
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_timeout+0x4db/0xfd0 kernel/time/timer.c:1803
  rcu_gp_fqs_loop kernel/rcu/tree.c:1948 [inline]
  rcu_gp_kthread+0x956/0x17a0 kernel/rcu/tree.c:2105
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
