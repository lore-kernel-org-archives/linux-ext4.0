Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795520187;
	b=SHCZBeflj2A0Ppxj7ESqyILc4BF5pLljdY3X+8ve3rG6bcvSufAsggaVTm3aO6kHfSQG
	 qdz4ugoXcAIPHsWEgPgEVGAcDohHILdSe5QEE9fbtgbrbRpoiGsQFBkTdepDfXtNGCdTk
	 jHSOOa5cwSoXqYWiWAWCwLEh54P37DbxZzc/UJymUQ50quI8idW1mo9g2dnhhxy2ANacl
	 f/Sq+SYKyCnSm+dUoTb8PAFDFMFG34jRaS5fVY57P7YJxW3MdMU/2fehRXytgUXeY6lOU
	 G1LTX8n+aONKblE+FUZnRrTFquAkdpPDSaYpbz9BVqgzeJ5FOqCbdwC3atvrK7dN+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795520187;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=5+z0RjfvMj/pFpchqzNvBrhynlyvv9N8yyd9ZoIwcDk=;
	b=M6HTaxcHpq2ACTW4vTF0SfWr+g9AwdUFM1FPmqpVh13Q8BP+vP2CyEE5k8gQFoEjmXTm
	 ev+e2c+9udauCeCod/AUwENhPT5zMH7hCXOtdNO9wEIyHgMMGS+gZ+caAZ/TG4e4TMcEH
	 G52g+GTGTbn+EhjE3JEHUdXUWXbHMEhTrMDv9/YEYybZuVg78LYgxMJuEDP/58gG4BSq7
	 DpPkfGlrbJPLG1zK1eainLAKDyM2+IGFm0evW0oaJOLuoZY8VkEJ62KHbRWWfxYiQh4NA
	 yY+lifnzKy6L4ZLDbSYrE4fSGdSnCiHw/0xuQWRnHTI+SCq3RX3650yQ0qx38yIje7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC39606A335
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 11:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FC39606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f8281066c4so5323544b6e.2
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:36:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795520186; x=1796124986;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+z0RjfvMj/pFpchqzNvBrhynlyvv9N8yyd9ZoIwcDk=;
        b=vA5Vuox1AyBx98RQjKW9lIBmt1Y4cUCL4/xuPeeQOGNCxMgw4EujfQEhgkieQZF1Fm
         t0uMwNoD4owJguCvVSHojrYtz+nsALzWSe4qZNYZpZZVvnQDKAeQ83ZWlBL9MBsxOPva
         CHeQNx9yt9rcAq72izW113rFfioEEOzX3CzUteoNjdgGD3pPfQfJTW4AH7zMygirRg72
         cALJU1GFYoKiJOeVeiacjoogN/UKwoT4p13tNBXdm45a8F4yuoowP6PXqpxmBLt1x4b3
         Zl1GPE7CP6lrYoEjaB8oECxUMF78MZntOESkBbPJc7kvOwIfT++lANKp0Ui3cuBK01Tt
         vwYw==
X-Forwarded-Encrypted: i=1; AL+hErH4IswgSz5pW93/gVfadif3r0cXR07Y+1kQkfvOMjBGiopFPAgG9UrWpgNfaqHD6nt24fhR9i7NE3sY@vger.kernel.org
X-Gm-Message-State: APuU4Z/GCsDIxS5iJjpaSYLlEe0p52kdCXGCfdCeOkkL2uaHrzGYhgfr
	hwXOtpYz+5JMjJsDHVcH2jBntVAWoada6Bg7iSK0ATwZDS32oxO7d0cctSknIH/SEcmeBOrNpPQ
	5wM1KdF34EE5OStp3dN8hS4C0rjDaEOVDECYRu0j7pL9kcJUYHzIBLefFjCw=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6711:b0:4c4:a240:9c3a with SMTP id
 5614622812f47-57a077151demr14292068b6e.4.1795520186508; Tue, 24 Nov 2026
 03:36:26 -0800 (PST)
Date: Tue, 24 Nov 2026 03:36:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b0576ba.a481e175.27cf24.0027.GAE@google.com>
Subject: [syzbot] [ext4?] BUG: workqueue lockup in update_super_work
From: syzbot <syzbot+97fde463a8ffb9e839d2@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a041bdbe1f3a arm64: Drop stdint.h type overrides from asm/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1410c1d9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e8e6c1701ad8af2
dashboard link: https://syzkaller.appspot.com/bug?extid=97fde463a8ffb9e839d2
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17576985580000

AI-generated root cause summary:
The workqueue watchdog detected a 35-second lockup on CPU 0's per-CPU worker
pool (`pool 2`), where all four busy workers (`update_super_work`,
`smc_ib_port_event_work`, `srcu_invoke_callbacks`, and `wg_packet_tx_worker`)
are in `TASK_RUNNING` (`state:R`) and switched out at `__switch_to`, unable to
be scheduled onto CPU 0 while CPU 1 (`pool 6`) continues running normally.
Because `srcu_invoke_callbacks` and `smc_ib_port_event_work` (which blocked on
`rtnl_lock`) cannot resume on CPU 0, the stall cascades to
`fsnotify_mark_destroy_workfn` (`synchronize_srcu`), `cfg80211_wiphy_work`,
`reg_todo`, and `batadv_tt_purge`. The exact code currently monopolizing CPU 0
cannot be conclusively determined from this report because
`show_cpu_pool_busy_workers()` checks `task_is_running()` rather than whether a
worker is actively executing on the CPU, and therefore skipped
`trigger_single_cpu_backtrace(0)`.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=97fde463a8ffb9e839d2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97fde463a8ffb9e839d2@syzkaller.appspotmail.com

BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 5s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x100
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=6 refcnt=8
    in-flight: 4867:update_super_work for 6s
    pending: refresh_vm_stats BAR(5070), vmstat_shepherd, 2*nsim_dev_hwstats_traffic_work, free_obj_work
  pwq 6: cpus=1 node=0 flags=0x0 nice=0 active=1 refcnt=2
    in-flight: 24:request_firmware_work_func for 42s
workqueue mm_percpu_wq: flags=0x108
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=1 refcnt=2
    pending: vmstat_update
workqueue kblockd: flags=0x118
  pwq 3: cpus=0 node=0 flags=0x0 nice=-20 active=2 refcnt=3
    pending: 2*blk_mq_timeout_work
pool 2: cpus=0 node=0 flags=0x0 nice=0 hung=5s workers=5 idle: 1171 10 1104 9
pool 6: cpus=1 node=0 flags=0x0 nice=0 hung=0s workers=6 idle: 26 4849 876 4848 4769
Showing backtraces of busy workers in stalled worker pools:
pool 2:
task:kworker/0:4     state:R  running task     stack:0     pid:4867  tgid:4867  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events update_super_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 io_schedule+0x1c/0xe0 kernel/sched/core.c:8146
 bit_wait_io+0x1c/0xe8 kernel/sched/wait_bit.c:258
 __wait_on_bit+0xb8/0x178 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0x130/0x184 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:106 [inline]
 __wait_on_buffer+0x6c/0x7c fs/buffer.c:118
 wait_on_buffer include/linux/buffer_head.h:476 [inline]
 ext4_commit_super+0x2b4/0x458 fs/ext4/super.c:6417
 update_super_work+0x2dc/0x384 fs/ext4/super.c:817
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 8s!
BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=-20 stuck for 3s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x100
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=7 refcnt=9
    in-flight: 4867:update_super_work for 9s
    pending: refresh_vm_stats BAR(5070), vmstat_shepherd, 2*nsim_dev_hwstats_traffic_work, free_obj_work, psi_avgs_work
  pwq 6: cpus=1 node=0 flags=0x0 nice=0 active=1 refcnt=2
    in-flight: 24:request_firmware_work_func for 45s
workqueue events_dfl_long: flags=0x2
  pwq 8: cpus=0-1 flags=0x4 nice=0 active=1 refcnt=2
    pending: defense_work_handler
workqueue mm_percpu_wq: flags=0x108
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=1 refcnt=2
    pending: vmstat_update
workqueue kblockd: flags=0x118
  pwq 3: cpus=0 node=0 flags=0x0 nice=-20 active=2 refcnt=3
    pending: 2*blk_mq_timeout_work
pool 2: cpus=0 node=0 flags=0x0 nice=0 hung=8s workers=5 idle: 1171 10 1104 9
pool 6: cpus=1 node=0 flags=0x0 nice=0 hung=0s workers=6 idle: 4849 26 876 4848 4769
Showing backtraces of busy workers in stalled worker pools:
pool 2:
task:kworker/0:4     state:R  running task     stack:0     pid:4867  tgid:4867  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events update_super_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 io_schedule+0x1c/0xe0 kernel/sched/core.c:8146
 bit_wait_io+0x1c/0xe8 kernel/sched/wait_bit.c:258
 __wait_on_bit+0xb8/0x178 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0x130/0x184 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:106 [inline]
 __wait_on_buffer+0x6c/0x7c fs/buffer.c:118
 wait_on_buffer include/linux/buffer_head.h:476 [inline]
 ext4_commit_super+0x2b4/0x458 fs/ext4/super.c:6417
 update_super_work+0x2dc/0x384 fs/ext4/super.c:817
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 3: no worker in running state, cpu=0 is busy (nr_workers=2 nr_idle=2)
The pool might have trouble waking an idle worker.
Backtrace of last woken worker:
task:kworker/0:1H    state:R  running task     stack:0     pid:4368  tgid:4368  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue:  0x0 (kblockd)
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 worker_thread+0x924/0xbd0 kernel/workqueue.c:3674
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5064 Comm: syz-executor298 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 00001000 (nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : 0000ffff92d12354
lr : 0000ffff92c64e84
sp : 0000ffffd134ccf0
x29: 0000ffffd134ccf0 x28: 0000ffff92cb3000 x27: 0000ffff92cb3000
x26: 0000ffff92cb3000 x25: 0000ffff92cb3000 x24: 0000000000000004
x23: 0000ffffd134cdd0 x22: 0000000000000001 x21: 0000ffff92d00000
x20: 0000ffffd134ce90 x19: 0000ffff92d01000 x18: 0000000001503538
x17: 0000000ca3baf921 x16: 0000000000000017 x15: 0000000000800000
x14: 0000000ca3c7df44 x13: 0000000000002490 x12: 000000007fffffff
x11: 0000000000000001 x10: 0000000000000001 x9 : 0000ffff92d0e010
x8 : 0000ffff92d0e000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000002490 x3 : 0012c684c0000000
x2 : 0000ffff92d12310 x1 : 0000ffffd134ce90 x0 : 0000000000000001
BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 11s!
BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=-20 stuck for 6s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x100
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=7 refcnt=9
    in-flight: 4867:update_super_work for 12s
    pending: refresh_vm_stats BAR(5070), vmstat_shepherd, 2*nsim_dev_hwstats_traffic_work, free_obj_work, psi_avgs_work
  pwq 6: cpus=1 node=0 flags=0x0 nice=0 active=1 refcnt=2
    in-flight: 24:request_firmware_work_func for 48s
workqueue events_unbound: flags=0x2
  pwq 8: cpus=0-1 flags=0x4 nice=0 active=3 refcnt=4
    pending: nsim_dev_trap_report_work, toggle_allocation_gate, nsim_dev_trap_report_work
workqueue mm_percpu_wq: flags=0x108
  pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=1 refcnt=2
    pending: vmstat_update
workqueue kblockd: flags=0x118
  pwq 3: cpus=0 node=0 flags=0x0 nice=-20 active=2 refcnt=3
    pending: 2*blk_mq_timeout_work
pool 2: cpus=0 node=0 flags=0x0 nice=0 hung=11s workers=5 idle: 1171 10 1104 9
pool 6: cpus=1 node=0 flags=0x0 nice=0 hung=0s workers=6 idle: 4849 26 876 4848 4769
Showing backtraces of busy workers in stalled worker pools:
pool 2:
task:kworker/0:4     state:R  running task     stack:0     pid:4867  tgid:4867  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue: events update_super_work
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 io_schedule+0x1c/0xe0 kernel/sched/core.c:8146
 bit_wait_io+0x1c/0xe8 kernel/sched/wait_bit.c:258
 __wait_on_bit+0xb8/0x178 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0x130/0x184 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:106 [inline]
 __wait_on_buffer+0x6c/0x7c fs/buffer.c:118
 wait_on_buffer include/linux/buffer_head.h:476 [inline]
 ext4_commit_super+0x2b4/0x458 fs/ext4/super.c:6417
 update_super_work+0x2dc/0x384 fs/ext4/super.c:817
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0x91c/0x1250 kernel/workqueue.c:3578
 worker_thread+0x798/0xbd0 kernel/workqueue.c:3659
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
pool 3: no worker in running state, cpu=0 is busy (nr_workers=2 nr_idle=2)
The pool might have trouble waking an idle worker.
Backtrace of last woken worker:
task:kworker/0:1H    state:R  running task     stack:0     pid:4368  tgid:4368  ppid:2      task_flags:0x4208060 flags:0x00000010
Workqueue:  0x0 (kblockd)
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 worker_thread+0x924/0xbd0 kernel/workqueue.c:3674
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5064 Comm: syz-executor298 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 00001000 (nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : 0000ffff92d12364
lr : 0000ffff92c64e84
sp : 0000ffffd134ccf0
x29: 0000ffffd134ccf0 x28: 0000ffff92cb3000 x27: 0000ffff92cb3000
x26: 0000ffff92cb3000 x25: 0000ffff92cb3000 x24: 0000000000000004
x23: 0000ffffd134cdd0 x22: 0000000000000001 x21: 0000ffff92d00000
x20: 0000ffffd134ce90 x19: 0000ffff92d01000 x18: 0000000001503538
x17: 0000000d5ab774a1 x16: 0000000000000017 x15: 0000000000800000
x14: 0000000d5ac496d8 x13: 00000000000026f6 x12: 000000007fffffff
x11: 0000000000000001 x10: 0000ffffd134ccf0 x9 : 0000ffff92d0e010
x8 : 0000ffff92d0e000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 00000000000026f6 x3 : 0014dc9380000000
x2 : 0000ffff92d12310 x1 : 0000ffffd134ce90 x0 : 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
