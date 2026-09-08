Received: from mail-oo2-f4.google.com (mail-oo2-f4.google.com [74.125.231.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9491D48F02B
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2026 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788905329; cv=none; b=TVk4Hh+cskgWkqTfeHZ73on5OW31jtsFJYCLOeHLU8g/fkjBUKVjbbAnW5njlj4/PPVLTejybfqxNRxJ3lpthZaXowFrL00i18gFKiP3hUv3o0CVRJA65MvpucOJ5YX8FQxxlZHz/2sT7WIiQ0ak31+xz2Uz2RvWv29jGEmIrUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788905329; c=relaxed/simple;
	bh=kL1be+1n2xXuZeI05oshAxLXJ35j1Dn4wAKqPBd1L3w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NcPtDrf6JlKmwJH9vQ04q7Xvn6P9P4q5oHh0PTgdrLJrMtOpgLHz/KvzTEOCPigIOSc4NW2tJUyDI3upTFH5FiMmCz1xrmYfNNnnazDAFw8ENl0Ss+Ns2hvWRCWk+q/7pmfctKjnhDyBbGiVt38kurtRLWrMDEm2K5bKjxWTnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f4.google.com with SMTP id 46e09a7af769-7f4e2118db8so1763814a34.1
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2026 15:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788905326; x=1789510126;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kzJLngJ9sIpOAhXA1n2+iUvn4oLCSr6EXvDZpAJyHQ=;
        b=TF0426GvPnXF/f8frX1UPnebaEechZmw0hgdiJm0x67jiAaVeHi3mvOehzcR7atDi1
         gwuygdZwtiB/tQQh214BgnQ8paXe/tPpqkTU97sh5tLPnhwCZFW0x+X6cS7FvZ14GSMe
         lJe1IiNP5YRDCTz4yoKszkZUhiFotg1j1jauWyrWb8cpQ2hlWtx1oglwJN/MDGo7k/t8
         0DW0dhk4uWmTXobJgFRUnOSjuvjDKeNqx4lqLuTj0/VBjIiRiNtYlFhNgtAGtzq9gQGZ
         mXFNd7A545LQOKsikj5sIAys02aY5vafLlROS7LbVCj4o7qPcYSSIz5ZtBWcP4g0JuRI
         gYWw==
X-Forwarded-Encrypted: i=1; AKwUvBzLIwcQTIVZFV4p//6U0eTgT9l3Qvzag3PyTOUOT4nA2+dFTWaKi+uIoOX08CYl2DybMXaWzgepVZ/N@vger.kernel.org
X-Gm-Message-State: AFuF++kvKvSil4qW0oaanSsgxr1whxsgtAheFZD+KIG8YEhsrNW9j4zl
	JDwNGJ6DyZElmI5/ZytezM5L4SLyIe5pIL4HLaG5f4bY86YXoisU9QrXDphXNnYp6sfS8AtgIIU
	42t9Ci60gGvFOBNopJgdOw8olu0xsakgtzI10OZg1Z8P/ImbVXjXR1JG+0is=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:200f:b0:6b9:7d9e:5708 with SMTP id
 006d021491bc7-6bdc949e3b9mr2550901eaf.3.1788905326349; Tue, 08 Sep 2026
 15:08:46 -0700 (PDT)
Date: Tue, 08 Sep 2026 15:08:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa0876e.f81106d8.285f0a.0005.GAE@google.com>
Subject: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
From: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    28924df2a08f Merge tag 'perf-tools-fixes-for-v7.3-2026-09-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13842af9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=2eb3d983669d3e49d4fa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160d1749580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13993af9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-28924df2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/309bf243aefc/vmlinux-28924df2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5baa1c49144e/bzImage-28924df2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7dba324ffac0/mount_1.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15842af9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com

INFO: task iou-wrk-5725:5730 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-5725    state:D stack:22112 pid:5730  tgid:5724  ppid:5438   task_flags:0x404050 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7276
 __schedule_loop kernel/sched/core.c:7353 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7368
 percpu_rwsem_wait+0x326/0x490 kernel/locking/percpu-rwsem.c:164
 __percpu_down_read+0xee/0x130 kernel/locking/percpu-rwsem.c:180
 percpu_down_read_internal include/linux/percpu-rwsem.h:67 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write include/linux/fs/super.h:125 [inline]
 kiocb_start_write include/linux/fs.h:2787 [inline]
 io_kiocb_start_write io_uring/rw.c:1109 [inline]
 io_write+0x120c/0x1680 io_uring/rw.c:1163
 __io_issue_sqe+0x188/0x4d0 io_uring/io_uring.c:1386
 io_issue_sqe+0x16d/0x1020 io_uring/io_uring.c:1409
 io_wq_submit_work+0x7ab/0xc90 io_uring/io_uring.c:1525
 io_worker_handle_work+0x7a1/0x1140 io_uring/io-wq.c:659
 io_wq_worker+0x452/0xf10 io_uring/io-wq.c:714
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
locks held by kworker/u4:1/13: 2, last CPU#0:
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc9000026fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc9000026fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc9000026fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc9000026fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
locks held by khungtaskd/26: 1, last CPU#0:
 #0: ffffffff8ed5c760 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8ed5c760 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8ed5c760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6871
locks held by kworker/u4:2/37: 3, last CPU#0:
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc900003f7c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc900003f7c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc900003f7c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc900003f7c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #2: ffff888051872258 (&devlink->lock_key#4){+.+.}-{4:4}, at: nsim_dev_trap_report_work+0x57/0xb40 drivers/net/netdevsim/dev.c:834
locks held by kworker/u4:3/43: 2, on CPU#0:
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88801b094140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc90000877c40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90000877c40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90000877c40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc90000877c40 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
locks held by kworker/u4:7/187: 4, last CPU#0:
 #0: ffff88803fa20140 ((wq_completion)bat_events){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88803fa20140 ((wq_completion)bat_events){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88803fa20140 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88803fa20140 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc900019dfc40 ((work_completion)(&(&forw_packet_aggr->delayed_work)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc900019dfc40 ((work_completion)(&(&forw_packet_aggr->delayed_work)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc900019dfc40 ((work_completion)(&(&forw_packet_aggr->delayed_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc900019dfc40 ((work_completion)(&(&forw_packet_aggr->delayed_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #2: ffff88801fc3bb20 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2d/0x160 kernel/sched/core.c:677
 #3: ffff88801fc24408 (psi_seq){-.-.}-{0:0}, at: psi_task_switch+0x57/0x7d0 kernel/sched/psi.c:933
locks held by getty/5086: 2, on CPU#0:
 #0: ffff88803ee570a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90000d202e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
locks held by kworker/0:10/5721: 3, last CPU#0:
 #0: ffff88801b0a8940 ((wq_completion)events){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88801b0a8940 ((wq_completion)events){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88801b0a8940 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88801b0a8940 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc900052f7c40 ((work_completion)(&adapter->watchdog_task)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc900052f7c40 ((work_completion)(&adapter->watchdog_task)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc900052f7c40 ((work_completion)(&adapter->watchdog_task)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc900052f7c40 ((work_completion)(&adapter->watchdog_task)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #2: ffff88801fc26118 (&base->lock){-.-.}-{2:2}, at: lock_timer_base kernel/time/timer.c:1004 [inline]
 #2: ffff88801fc26118 (&base->lock){-.-.}-{2:2}, at: __mod_timer+0x1a9/0xed0 kernel/time/timer.c:1085
locks held by syz.0.23/5725: 2, on CPU#0:
 #0: ffff88801d025220 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x33/0x2f0 block/bdev.c:304
 #1: ffff888048fa4460 (sb_writers#4){++++}-{0:0}, at: sb_wait_write fs/super.c:2043 [inline]
 #1: ffff888048fa4460 (sb_writers#4){++++}-{0:0}, at: freeze_super+0x4f4/0x11c0 fs/super.c:2307
locks held by iou-wrk-5725/5730: 1, on CPU#0:
 #0: ffff888048fa4460 (sb_writers#4){++++}-{0:0}, at: __io_issue_sqe+0x188/0x4d0 io_uring/io_uring.c:1386

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:123
 nmi_trigger_cpumask_backtrace+0x17d/0x390 lib/nmi_backtrace.c:66
 trigger_all_cpu_backtrace include/linux/nmi.h:164 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
