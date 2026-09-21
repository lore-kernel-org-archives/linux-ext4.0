Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB9F4D9F7E
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790006073; cv=none; b=DyWvIxytcNIS0VMjLy/pAIMRRuEfIwfy5oAkebGcij2yePkwh1ud4+8eJDwLcadM0fldz9o3EcawGOSchoexUwukf8+u0ZsQ+pG2uMZWKbTiQ1IYPl76wyTM76BkXDpl9U2bto1UzMw0cOQmJQPDZkAPp7YO8sNdFCuY7dhrprs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790006073; c=relaxed/simple;
	bh=oVm2yhyfTaWeUxuDx+ug4vi6XBjcPD1klU65n0vjc4g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OK3qaMbLFOqpEVQJme9dhAz+/JPgIW1rkDhsI4fFNNipSICip6fsGP5yALMmlb6bLzWYUnHuK5eacNwXqdA/daJEzlTNrnkq31ZAUYUmcNzTwIAzofvPDhRtLHzPHpO1jHmsLFOWSKzx0xJtj61GmlOiunR62UogFW/tAS2NvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6aaf6076546so1913452eaf.1
        for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 08:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790006070; x=1790610870;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=677zLfzDi4wxAqfqiiy9hD3NHGO5LfQ0HvhKV1QMpNU=;
        b=Ya78InTy9gAZv5dvAP3InN5wrvAeFoyqZZ6zT+td0XLtg0TdHn4GY43rmT3MWOqUXv
         CI7m2VEtGEM15iYTA4vrsvhc7J0zMGoHernsKrtYn9GT5sFMIXlF2VgSZdN2fnBkRwGk
         VNwNZyu91o09+t4iTN49WNRaItUVzPUv2YyvHfnrfZXasYBuTrQEewqyIOEmmQu9UaoM
         KDSzARRX97wwH3Jtm/he93ZJCTOKLiavJYH5HxNh/qUD4x9BdXzeZqh0b3oymc/EXjLa
         8jDdOQxMTERXT1dit1bLZn0cviiI+BteU5uoaGTxgMYVN29tfcegzSQFl2tabde9Xfyt
         GUDQ==
X-Gm-Message-State: AFuF++mk9fORRXgzXYX8CEninZZl/r90iqoGGMrkdPwxPLLwx5vk9FGM
	EY/ljGLJnCiqrasthk6+U8/e3nDiQuo8d4ztiW8gp6PbkDAo+PSE1LbMnVo6iQRH06QUUZ+CCcv
	lzxirTIA1DtCSCsMgm2XoUHAmWJ1zmDxLtWbg4h1wAtoGzD4YAtqVD0Rf2VjUwQ==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c8e:b0:6b1:a812:9871 with SMTP id
 006d021491bc7-6ca9a5471b7mr9727261eaf.18.1790006069674; Mon, 21 Sep 2026
 08:54:29 -0700 (PDT)
Date: Mon, 21 Sep 2026 08:54:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab15335.3179f8cd.1e36b2.0022.GAE@google.com>
Subject: [syzbot] [fuse?] [ext4?] INFO: task hung in do_new_mount (4)
From: syzbot <syzbot+2cb543a665f5f76997cb@syzkaller.appspotmail.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=126f64c9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=2cb543a665f5f76997cb
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1674e005580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/47713ec0651b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=146f64c9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2cb543a665f5f76997cb@syzkaller.appspotmail.com

INFO: task syz.0.17:4913 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:0     pid:4913  tgid:4912  ppid:4820   task_flags:0x400140 flags:0x00800011
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7369
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7426
 rwsem_down_write_slowpath+0x6ec/0x1174 kernel/locking/rwsem.c:1215
 __down_write_common kernel/locking/rwsem.c:1347 [inline]
 __down_write kernel/locking/rwsem.c:1356 [inline]
 down_write+0xb4/0xc0 kernel/locking/rwsem.c:1632
 inode_lock include/linux/fs.h:1024 [inline]
 do_lock_mount+0x158/0x63c fs/namespace.c:2768
 do_new_mount_fc fs/namespace.c:3790 [inline]
 do_new_mount+0x360/0x538 fs/namespace.c:3848
 path_mount+0x5f0/0xa88 fs/namespace.c:4168
 do_mount+0xe8/0x148 fs/namespace.c:4181
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount fs/namespace.c:4374 [inline]
 __arm64_sys_mount+0x33c/0x388 fs/namespace.c:4374
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
INFO: task syz.0.17:4914 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:0     pid:4914  tgid:4912  ppid:4820   task_flags:0x400140 flags:0x00000011
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5526 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7277
 __schedule_loop kernel/sched/core.c:7354 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7369
 request_wait_answer fs/fuse/dev.c:749 [inline]
 __fuse_request_send fs/fuse/dev.c:768 [inline]
 fuse_chan_send+0x840/0xf60 fs/fuse/dev.c:844
 __fuse_simple_request+0xa0/0xb8 fs/fuse/req.c:69
 fuse_simple_request fs/fuse/fuse_i.h:1012 [inline]
 fuse_do_setattr+0xb34/0x1468 fs/fuse/dir.c:2248
 fuse_setattr+0x1f4/0x5e0 fs/fuse/dir.c:2373
 notify_change+0x928/0xb7c fs/attr.c:556
 chmod_common+0x200/0x3a4 fs/open.c:686
 do_fchmodat+0x10c/0x1f8 fs/open.c:731
 __do_sys_fchmodat fs/open.c:750 [inline]
 __se_sys_fchmodat fs/open.c:747 [inline]
 __arm64_sys_fchmodat+0x88/0xa0 fs/open.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590

Showing all locks held in the system:
locks held by khungtaskd/31: 1, last CPU#0:
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x4c/0x188 kernel/locking/lockdep.c:6871
locks held by kworker/u9:0/50: 3, on CPU#1:
 #0: ffff0000d8e34140 ((wq_completion)hci2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #0: ffff0000d8e34140 ((wq_completion)hci2){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3479
 #1: ffff8000902f7c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #1: ffff8000902f7c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3479
 #2: ffff0000d0df0ea0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x178/0x374 net/bluetooth/hci_sync.c:331
locks held by kworker/u8:3/54: 5, last CPU#1:
 #0: ffff0000c004c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #0: ffff0000c004c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3479
 #1: ffff800090337c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #1: ffff800090337c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3479
 #2: ffff0001add89cd8 (&base->lock){-.-.}-{2:2}, at: devl_trylock+0x24/0x34 net/devlink/core.c:314
 #3: ffff0000d3bb38e0 (&nsim_trap_data->trap_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
 #3: ffff0000d3bb38e0 (&nsim_trap_data->trap_lock){+.+.}-{3:3}, at: nsim_dev_trap_report drivers/net/netdevsim/dev.c:787 [inline]
 #3: ffff0000d3bb38e0 (&nsim_trap_data->trap_lock){+.+.}-{3:3}, at: nsim_dev_trap_report_work+0x168/0x9cc drivers/net/netdevsim/dev.c:847
 #4: ffff800088d82320 (rcu_read_lock_sched){....}-{1:2}, at: spin_lock_bh include/linux/spinlock.h:353 [inline]
 #4: ffff800088d82320 (rcu_read_lock_sched){....}-{1:2}, at: nsim_dev_trap_report drivers/net/netdevsim/dev.c:812 [inline]
 #4: ffff800088d82320 (rcu_read_lock_sched){....}-{1:2}, at: nsim_dev_trap_report_work+0x5ec/0x9cc drivers/net/netdevsim/dev.c:847
locks held by kworker/u8:6/1181: 1, last CPU#1:
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff800088d82260 (rcu_read_lock){....}-{1:3}, at: process_scheduled_works+0x698/0x1250 kernel/workqueue.c:3479
locks held by getty/4488: 2, on CPU#1:
 #0: ffff0000c94b40a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009257e2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x348/0xf78 drivers/tty/n_tty.c:2211
locks held by kworker/1:5/4772: 3, on CPU#1:
 #0: ffff0000c002b540 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #0: ffff0000c002b540 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3479
 #1: ffff80009b387c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3371 [inline]
 #1: ffff80009b387c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3479
 #2: ffff0000d4d66250 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x198/0x320 drivers/net/netdevsim/fib.c:1490
locks held by syz.0.17/4913: 1, on CPU#0:
 #0: ffff0000eeb44b80 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000eeb44b80 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.0.17/4914: 2, on CPU#1:
 #0: ffff0000d33d6460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb44b80 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb44b80 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.1.18/4956: 1, on CPU#1:
 #0: ffff0000eeb444c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000eeb444c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.1.18/4957: 2, on CPU#0:
 #0: ffff0000cfc96460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb444c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb444c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.2.19/5003: 1, on CPU#1:
 #0: ffff0000e0a7a300 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000e0a7a300 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.2.19/5005: 2, on CPU#1:
 #0: ffff0000c60bc460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000e0a7a300 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000e0a7a300 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.3.20/5051: 1, on CPU#0:
 #0: ffff0000e0a79c40 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000e0a79c40 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.3.20/5053: 2, on CPU#1:
 #0: ffff0000d120a460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000e0a79c40 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000e0a79c40 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.4.21/5105: 1, on CPU#0:
 #0: ffff0000eeb43e00 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000eeb43e00 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.4.21/5107: 2, on CPU#0:
 #0: ffff0000d9608460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb43e00 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb43e00 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.5.22/5154: 1, on CPU#1:
 #0: ffff0000e0a79580 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000e0a79580 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.5.22/5156: 2, on CPU#1:
 #0: ffff0000d4608460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000e0a79580 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000e0a79580 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.6.23/5202: 1, on CPU#0:
 #0: ffff0000e0a78ec0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000e0a78ec0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.6.23/5203: 2, on CPU#0:
 #0: ffff0000cb9ae460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000e0a78ec0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000e0a78ec0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.7.24/5256: 1, on CPU#1:
 #0: ffff0000e0a78800 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000e0a78800 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.7.24/5257: 2, on CPU#0:
 #0: ffff0000f2b3a460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000e0a78800 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000e0a78800 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.8.25/5304: 1, on CPU#1:
 #0: ffff0000eeb43740 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000eeb43740 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.8.25/5305: 2, on CPU#0:
 #0: ffff0000f2054460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb43740 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb43740 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.9.26/5354: 1, on CPU#1:
 #0: ffff0000eeb43080 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff0000eeb43080 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: do_lock_mount+0x158/0x63c fs/namespace.c:2768
locks held by syz.9.26/5356: 2, on CPU#0:
 #0: ffff0000d454c460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb43080 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb43080 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678
locks held by syz.0.27/5397: 2, on CPU#0:
 #0: ffff0000ca324460 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:494
 #1: ffff0000eeb429c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff0000eeb429c0 (&type->i_mutex_dir_key#8){+.+.}-{4:4}, at: chmod_common+0x140/0x3a4 fs/open.c:678

=============================================



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
