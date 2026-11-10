Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346445;
	b=4xbQQC4HS0yPO3J8kZXUdz66p/BIQFhsYPWpiS1jQsjLtnSxTF9dE05lYTcM23bgBArJ
	 iW6Mg1aJDOG+azwbu/iB7bpf8u0wKliXfdxRAZRngmP2nZG7YlRXfi/itUTd8beStlg6K
	 rTeHDTReTsuqmjJmhvb9X2bxgBVFncOW2ACyHIw+xU520SFJJrT428L6XjGTuUxCIOWAz
	 G57Rrp8ILe29JSVsBNIyHIycYwRirEp4X6XL73+S1XZnfmKMO74ucNzS8yOKMfLf/5W6c
	 OYeLB9q79mJEUPIGn1o85AcF5k7FNY8ssqydbNr/aUngE2jnGEBtJGhbxM0m5TAK4nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346445;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=e0NJJuk/tzgO1znOT9Akzwk6lvWDfgdQGAQjaC8tB3Y=;
	b=0UzPG5DPsWr6kycto2Z4zaozH02Aq57SpnYMVVEHfbd2lXRgsEpNgrq3WwWl/ZzOdcT/
	 0dQi/seFOM9SALwJZhsDy/zDbeH5yKlQDFHi8TDuBeb5dJja5eNE0gP3YMQ9vpDlehNct
	 w6nJPgycC8QNZGRMgXLssOY8Jora1WSbEug8CpNx8r9VVY3JiqxcfhNbcDDFwAbqvlptK
	 xW+2M+dxbkklpAzlyUzJGGf1Lq20nLBOVk73A5Eyijvuv6MAugL1G31GGizdkjzi71v9w
	 nMaMIV9CIGxv2tL6Znb+dyk5FdHdBv8ea2JjeuanOiifDht9EnqvqGu+rkLBQHNtcnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83264606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 21:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83264606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b2d1eb484aso3188686b6e.2
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 13:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794346444; x=1794951244;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e0NJJuk/tzgO1znOT9Akzwk6lvWDfgdQGAQjaC8tB3Y=;
        b=ztgzoi9zd7BHAHyStLPClEAl2/Chl0kj1l2E9uDNo0HaZ5GAJezHTvkQrOFSaCP9oo
         XySkKxiDdkhHpQ/94n/H/SNZvzyoGtJQqEofXZkzavSj0nZHg7SR12vO2fFxnVw4n2mL
         P9e0nqSzJ2TPsSg0eQ1ynaUp7lpBKpLG15leNdju3H6wX0SmNs2bZlG4ZiMMhnOnoJAj
         enzFIR97eHh3m5zORl3yfkhzcIOiMq34xHZRFauHtOkABKs/Oy4fSB9ix1RJjoqYen/z
         c2XMaZKqMZs1usdEdp8beAKzvUDU8Pn5vfCkDIKfkbdOzmQclx6vtctxh/JxzhFa0BX1
         3unQ==
X-Forwarded-Encrypted: i=1; AL+hErHm4sI7MnnEU1k6rzZQCSfn8eJF78GRcWoPHTxDVlBhrQayi4wui1A/Uj0T+vitR1uI+IK8mPfYExW5@vger.kernel.org
X-Gm-Message-State: APuU4Z+10eedYUX4cLvSnn5zPwC/b+WIsf6d7NJ8/7uS6cJ1ia8r2p6B
	E+6YGLit4FHmWfZvrv6mGGDfP4g8GJKHuBU/V/kzl7F0Py3wEdwA3S0qAqZJjdoNI/kD3GmWbdH
	eQE2CTfFIUgjdsqq+fVKQxtVoa8zvfkWmWYwHD0lw2ogYeZJNr6JcVm6ud5g=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1691:b0:4e8:e664:f268 with SMTP id
 5614622812f47-56b96ac9cfcmr235239b6e.25.1794346444536; Tue, 10 Nov 2026
 13:34:04 -0800 (PST)
Date: Tue, 10 Nov 2026 13:34:04 -0800
In-Reply-To: <20261110132118.11265-1-diasyzhangqing@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af38dcc.b5c6bce2.3112f.0003.GAE@google.com>
Subject: Re: [syzbot] [block?] [ext4?] INFO: task hung in bdev_freeze
From: syzbot <syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, diasyzhang@tencent.com, diasyzhangqing@gmail.com, 
	jack@suse.cz, libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in user_get_super

INFO: task syz.4.3007:21757 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.3007      state:D stack:0     pid:21757 tgid:21733 ppid:5332   task_flags:0x400040 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5584 [inline]
 __schedule+0x13a0/0x2bd4 kernel/sched/core.c:7389
 __schedule_loop kernel/sched/core.c:7466 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7481
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7538
 rwsem_down_read_slowpath+0x544/0x7f8 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0xa0/0x2bc kernel/locking/rwsem.c:1576
 __super_lock fs/super.c:62 [inline]
 super_lock+0x258/0x344 fs/super.c:124
 user_get_super+0xb8/0x1bc fs/super.c:1022
 quotactl_block fs/quota/quota.c:889 [inline]
 __do_sys_quotactl fs/quota/quota.c:955 [inline]
 __se_sys_quotactl fs/quota/quota.c:917 [inline]
 __arm64_sys_quotactl+0x4c8/0x90c fs/quota/quota.c:917
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606

Showing all locks held in the system:
locks held by khungtaskd/32: 1, on CPU#0:
 #0: ffff800089ab5660 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff800089ab5660 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff800089ab5660 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x4c/0x188 kernel/locking/lockdep.c:6871
locks held by kworker/u9:0/50: 3, last CPU#0:
 #0: ffff0000ca34d948 ((wq_completion)hci9){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000ca34d948 ((wq_completion)hci9){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800092057c20 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800092057c20 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000f0c1cea0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1b0/0x380 net/bluetooth/hci_sync.c:337
locks held by getty/4498: 2, last CPU#1:
 #0: ffff0000ca5e80a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff8000932de2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x350/0xffc drivers/tty/n_tty.c:2211
locks held by kworker/1:5/5820: 3, on CPU#1:
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800093847c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800093847c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000ccb4d258 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x198/0x320 drivers/net/netdevsim/fib.c:1490
locks held by syz.2.3009/21731: 3, on CPU#1:
 #0: ffff0000c6600470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
 #1: ffff0000c148f4a0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #2: ffff0000d39a0478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #2: ffff0000d39a0478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
locks held by syz.2.3009/21762: 1, on CPU#1:
 #0: ffff0000c6600470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
locks held by syz.2.3009/21763: 1, on CPU#1:
 #0: ffff0000d39a0100 (&type->s_umount_key#32){++++}-{4:4}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff0000d39a0100 (&type->s_umount_key#32){++++}-{4:4}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff0000d39a0100 (&type->s_umount_key#32){++++}-{4:4}, at: rcuwait_wake_up+0x38/0x25c kernel/exit.c:322
locks held by syz.4.3007/21734: 5, on CPU#1:
 #0: ffff0000d6314470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
 #1: ffff0000c148dda0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #2: ffff0000d1490478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #2: ffff0000d1490478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
 #3: ffff0000d1490100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:60 [inline]
 #3: ffff0000d1490100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock_excl fs/super.c:75 [inline]
 #3: ffff0000d1490100 (&type->s_umount_key#32){++++}-{4:4}, at: freeze_super+0x4a0/0xf6c fs/super.c:2242
 #4: ffff0000d1490570 (sb_pagefaults){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #4: ffff0000d1490570 (sb_pagefaults){++++}-{0:0}, at: freeze_super+0x4b8/0xf6c fs/super.c:2246
locks held by syz.4.3007/21756: 1, on CPU#1:
 #0: ffff0000d6314470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
locks held by syz.4.3007/21757: 1, last CPU#1:
 #0: ffff0000d1490100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:62 [inline]
 #0: ffff0000d1490100 (&type->s_umount_key#32){++++}-{4:4}, at: super_lock+0x258/0x344 fs/super.c:124
locks held by syz.1.3010/21737: 3, on CPU#1:
 #0: ffff0000ef804470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
 #1: ffff0000c154dda0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #2: ffff0000eee66478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #2: ffff0000eee66478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
locks held by syz.1.3010/21767: 1, on CPU#0:
 #0: ffff0000ef804470 (&sbi->s_shutdown_lock){+.+.}-{4:4}, at: ext4_force_shutdown+0x17c/0x658 fs/ext4/ioctl.c:822
locks held by syz.1.3010/21768: 1, on CPU#0:
 #0: ffff0000eee66478 (sb_writers#3){++++}-{0:0}, at: __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 #0: ffff0000eee66478 (sb_writers#3){++++}-{0:0}, at: invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
locks held by kmmpd-loop4/21743: 1, last CPU#1:
 #0: ffff0000d1490478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by kmmpd-loop3/21772: 1, last CPU#1:
 #0: ffff0000eedc6478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by kmmpd-loop0/21796: 1, last CPU#1:
 #0: ffff0000eb87c478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by kworker/u9:4/21931: 3, last CPU#0:
 #0: ffff0000c98bf148 ((wq_completion)hci8){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c98bf148 ((wq_completion)hci8){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800098197c20 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800098197c20 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000ec4b0ea0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1b0/0x380 net/bluetooth/hci_sync.c:337
locks held by kmmpd-loop9/22058: 1, last CPU#1:
 #0: ffff0000c3d98478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by syz-executor/22236: 6, last CPU#1:
 #0: ffff0000d0912478 (sb_writers#6){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2765 [inline]
 #0: ffff0000d0912478 (sb_writers#6){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:663
 #1: ffff0000f6abf480 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1b0/0x3b8 fs/kernfs/file.c:336
 #2: ffff0000ca778e18 (kn->active#55){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff0000ca778e18 (kn->active#55){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x1f0/0x3b8 fs/kernfs/file.c:337
 #3: ffff80008a3bd8a0 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: del_device_store+0xd8/0x2d4 drivers/net/netdevsim/bus.c:233
 #4: ffff0000cfcc6128 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1109 [inline]
 #4: ffff0000cfcc6128 (&dev->mutex){....}-{4:4}, at: __device_driver_lock+0x94/0xcc drivers/base/dd.c:1046
 #5: ffff0000cfcc5258 (&devlink->lock_key#13){+.+.}-{4:4}, at: devl_lock+0x24/0x34 net/devlink/core.c:314
locks held by syz-executor/22244: 4, last CPU#1:
 #0: ffff0000d0912478 (sb_writers#6){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2765 [inline]
 #0: ffff0000d0912478 (sb_writers#6){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:663
 #1: ffff0000ec554080 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1b0/0x3b8 fs/kernfs/file.c:336
 #2: ffff0000ca778e18 (kn->active#55){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff0000ca778e18 (kn->active#55){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x1f0/0x3b8 fs/kernfs/file.c:337
 #3: ffff80008a3bd8a0 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: del_device_store+0xd8/0x2d4 drivers/net/netdevsim/bus.c:233

=============================================



Tested on:

commit:         067c5c24 Merge tag 'page_alloc-for-7.4-rc2' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110505a1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06331d9bb9c8204
dashboard link: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1314b1a1580000

