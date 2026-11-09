Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794238305;
	b=yObX2vFmA3LLtCbPMj/kB554GxIX3ph1cIiXNcL0iDxGxQC3tffPQirnKeJnlYmqXF6Q
	 FvftR9tIdk8DNBsD40+WG9Zfm09s6S4WeKeq6Do+/WqJvpdlsdRZLwAu5hPY5H6t9f7Wi
	 UDNj5+M4MVNu9yiYhPU+XjikJ69HrCqn+Qgi9rDk8sqZM8n17m3y/DxzYm/2620GAHtuU
	 ibgDpy1F7Aw+vnUUOtQSDGY6S1ogjt3J3q7KO9IPbyDz+1hocKh5F9qrpVP+o45ImUc2y
	 51+GauBv+BLaRih/IOjxptdIxU3hPnfZPiGlFXP1AbFy/nsSVg4ZF9nBFuRsPbgi8ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794238305;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=3TCmelbJhrC1Gcjo8LWEm8yQBYz7VAtFIcxL7M2b5HE=;
	b=1/DnTL3Pfr6TB67HQnMdoQMSkvAkRLKQj288AeuJQkK81PcqQ7Y4RlVlpAjsa1sMrQY2
	 SDP5H3ZgoZ2jBSjJZonxxYu/SHvmU0nqYozq52ia94xEmuSrw0nD01hU/W/SnfstUvVIl
	 BAVGqzAc69oK21dv6780TxdNSbapHRbH9UMC+h8Ks/x2id4HELEVANHgqQgg8miJrxYo7
	 vWLAqKAwCHkRWS+yNl8y6BJk7t0n837RO7ISJzUXhhozBDgMbphJGmcvpcXkT7C02fUcs
	 5LmHxJJNhdZv5bEuX3OSeR5QM8Rsdc9gAMMpoUIH+eOjYrrkJcOsYudelKcpHpOdbig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56D606A326
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 15:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C56D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a41f46d629so1356725b6e.3
        for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2026 07:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794238303; x=1794843103;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3TCmelbJhrC1Gcjo8LWEm8yQBYz7VAtFIcxL7M2b5HE=;
        b=rQptKTxqwQ30lJej2UYaHTheuCgAikZw9N3m2kJK7n4y9wJPwfZ5xGQMWra3UVZFlf
         bNc7f3MEBDv7nI3CrqEE3s6LP0iRpit8fErAV1T3p5ueJ/n6ZbrnCp/XPNERex2HtRcB
         gl38JKbUeLQ+OorXJMCLt5/5H563MG8SMLlG6xx8lziOTRGE6O6u2fEFyLTk/te8fmsi
         5lecqpQzPNdZVfZaNNcwCP9+01dOxlUnYwmog5u7yuR2r1mOmblZN7ChW6KEUiRPKo9u
         Cfjo0A0vZzZO0For/n+gc/GlnogwH19FqwNXI7XG1Wfwu+xBP83kJA5egjkPP0m42G3k
         GXqQ==
X-Forwarded-Encrypted: i=1; AL+hErHw2rM/SbAtGE69/r32gGW5VcklPjMWHnZjC6PPAtIdUKjLhVARyP1l3Hvmh4VhcacqIanCZ4fvrGgR@vger.kernel.org
X-Gm-Message-State: APuU4Z8g3TZGt3ff36Tp9Y6dstFkCbZhf1cRfFT0nS/Pg0j1an70/9wH
	JPDrf7B/pweCKkEd9d3suY70tczKnYTneKaOvsAMZhvUbRwXf1jL7OWXYTigBpakalZ2+0A8gy1
	k2dkoK4FRkHT+qaMPeoqOuPw2scvLztfvwpOWccsuO1ahHQYfpSdsyBVcWts=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:318b:b0:4e6:9390:e153 with SMTP id
 5614622812f47-568145f2896mr3186082b6e.24.1794238303329; Mon, 09 Nov 2026
 07:31:43 -0800 (PST)
Date: Mon, 09 Nov 2026 07:31:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
Subject: [syzbot] [block?] [ext4?] INFO: task hung in bdev_freeze
From: syzbot <syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com>
To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    58c1eb84e977 arm64: sdei: Preserve the interrupted context..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11932a4e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a58b6b4d667e7a61
dashboard link: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111be7a5580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e99409580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b1ec47537e12/disk-58c1eb84.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3bca0c2b1169/vmlinux-58c1eb84.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a7c49594d5a/Image-58c1eb84.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/80e50d025158/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17699409580000)

AI-generated root cause summary:
In ext4_force_shutdown(), EXT4_GOING_FLAGS_DEFAULT invokes
bdev_freeze(sb->s_bdev) to freeze the underlying block device before setting
EXT4_FLAGS_SHUTDOWN, and thaws it immediately afterwards via bdev_thaw().
Because ext4_forced_shutdown() is tested only prior to bdev_freeze() and
EXT4_FLAGS_SHUTDOWN is not set until bdev_freeze() returns, concurrent callers
of EXT4_IOC_SHUTDOWN all bypass the shutdown check and serialize on
bdev->bd_fsfreeze_mutex. Each caller must execute a full freeze_super() cycle
involving s_umount exclusion, percpu_rwsem write transitions, and
synchronize_rcu() calls, causing waiting tasks to stall in uninterruptible sleep
(D state) on bd_fsfreeze_mutex and trigger hung-task timeouts.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=d4ecb9a1e5b3dcf8baec

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com

INFO: task syz.1.3811:25659 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.3811      state:D stack:0     pid:25659 tgid:25638 ppid:20649  task_flags:0x400140 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x5d8/0x10b8 kernel/locking/mutex.c:821
 mutex_lock_nested+0x24/0x30 kernel/locking/mutex.c:874
 bdev_freeze+0x38/0x2e8 block/bdev.c:304
 ext4_force_shutdown+0x288/0x5ac fs/ext4/ioctl.c:826
 ext4_ioctl_shutdown fs/ext4/ioctl.c:868 [inline]
 __ext4_ioctl fs/ext4/ioctl.c:1888 [inline]
 ext4_ioctl+0x21dc/0x4430 fs/ext4/ioctl.c:1932
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
INFO: task syz.1.3811:25660 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.3811      state:D stack:0     pid:25660 tgid:25638 ppid:20649  task_flags:0x400040 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
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
INFO: task syz.0.3808:25667 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.3808      state:D stack:0     pid:25667 tgid:25642 ppid:21229  task_flags:0x400140 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x5d8/0x10b8 kernel/locking/mutex.c:821
 mutex_lock_nested+0x24/0x30 kernel/locking/mutex.c:874
 bdev_freeze+0x38/0x2e8 block/bdev.c:304
 ext4_force_shutdown+0x288/0x5ac fs/ext4/ioctl.c:826
 ext4_ioctl_shutdown fs/ext4/ioctl.c:868 [inline]
 __ext4_ioctl fs/ext4/ioctl.c:1888 [inline]
 ext4_ioctl+0x21dc/0x4430 fs/ext4/ioctl.c:1932
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
INFO: task syz.2.3812:25664 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.3812      state:D stack:0     pid:25664 tgid:25645 ppid:21748  task_flags:0x400140 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x5d8/0x10b8 kernel/locking/mutex.c:821
 mutex_lock_nested+0x24/0x30 kernel/locking/mutex.c:874
 bdev_freeze+0x38/0x2e8 block/bdev.c:304
 ext4_force_shutdown+0x288/0x5ac fs/ext4/ioctl.c:826
 ext4_ioctl_shutdown fs/ext4/ioctl.c:868 [inline]
 __ext4_ioctl fs/ext4/ioctl.c:1888 [inline]
 ext4_ioctl+0x21dc/0x4430 fs/ext4/ioctl.c:1932
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
INFO: task syz.2.3812:25665 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.3812      state:D stack:0     pid:25665 tgid:25645 ppid:21748  task_flags:0x400040 flags:0x00800001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
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
INFO: task kmmpd-loop1:25649 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kmmpd-loop1     state:D stack:0     pid:25649 tgid:25649 ppid:2      task_flags:0x208040 flags:0x00000010
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 percpu_rwsem_wait+0x2a0/0x2f8 kernel/locking/percpu-rwsem.c:164
 __percpu_down_read+0x84/0xb4 kernel/locking/percpu-rwsem.c:180
 percpu_down_read_internal include/linux/percpu-rwsem.h:67 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write include/linux/fs/super.h:125 [inline]
 class_super_write_constructor include/linux/fs/super.h:130 [inline]
 write_mmp_block+0x358/0x3e4 fs/ext4/mmp.c:63
 kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
INFO: task kmmpd-loop2:25651 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kmmpd-loop2     state:D stack:0     pid:25651 tgid:25651 ppid:2      task_flags:0x208040 flags:0x00000010
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 percpu_rwsem_wait+0x2a0/0x2f8 kernel/locking/percpu-rwsem.c:164
 __percpu_down_read+0x84/0xb4 kernel/locking/percpu-rwsem.c:180
 percpu_down_read_internal include/linux/percpu-rwsem.h:67 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write include/linux/fs/super.h:125 [inline]
 class_super_write_constructor include/linux/fs/super.h:130 [inline]
 write_mmp_block+0x358/0x3e4 fs/ext4/mmp.c:63
 kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
 kthread+0x304/0x3d4 kernel/kthread.c:436
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:854
INFO: task syz.3.3813:25671 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.3813      state:D stack:0     pid:25671 tgid:25657 ppid:22407  task_flags:0x400140 flags:0x00000001
Call trace:
 __switch_to+0x2b4/0x6e4 arch/arm64/kernel/process.c:792 (T)
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x1368/0x2b50 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7474
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7531
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x5d8/0x10b8 kernel/locking/mutex.c:821
 mutex_lock_nested+0x24/0x30 kernel/locking/mutex.c:874
 bdev_freeze+0x38/0x2e8 block/bdev.c:304
 ext4_force_shutdown+0x288/0x5ac fs/ext4/ioctl.c:826
 ext4_ioctl_shutdown fs/ext4/ioctl.c:868 [inline]
 __ext4_ioctl fs/ext4/ioctl.c:1888 [inline]
 ext4_ioctl+0x21dc/0x4430 fs/ext4/ioctl.c:1932
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0x154/0x1cc fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606

Showing all locks held in the system:
locks held by kworker/u8:0/12: 2, on CPU#1:
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff80008fa47c20 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff80008fa47c20 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
locks held by khungtaskd/31: 1, last CPU#1:
 #0: ffff800089aa56a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff800089aa56a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff800089aa56a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x4c/0x188 kernel/locking/lockdep.c:6871
locks held by kworker/u8:2/40: 3, last CPU#1:
 #0: ffff0000c004b948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c004b948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800090f97c20 ((work_completion)(&(&par->cursor_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800090f97c20 ((work_completion)(&(&par->cursor_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff800089a9ada0 (console_lock){+.+.}-{0:0}, at: fb_flashcursor+0x28/0x398 drivers/video/fbdev/core/fbcon.c:403
locks held by kworker/u8:3/42: 3, on CPU#0:
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800090fb7c20 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800090fb7c20 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80
locks held by kworker/u8:4/63: 3, on CPU#0:
 #0: ffff0000c3d1e148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c3d1e148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800092147c20 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800092147c20 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80
locks held by kworker/u8:12/3416: 2, on CPU#0:
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c004c148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff80009c0f7c20 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff80009c0f7c20 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
locks held by getty/4496: 2, on CPU#0:
 #0: ffff0000cd6e50a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff8000932bb2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x350/0xffc drivers/tty/n_tty.c:2211
locks held by kworker/1:2/4689: 3, on CPU#1:
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff80009a037c20 (deferred_process_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff80009a037c20 (deferred_process_work){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80
locks held by kworker/1:3/4758: 3, last CPU#1:
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff800099ee7c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff800099ee7c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000cde94258 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x198/0x320 drivers/net/netdevsim/fib.c:1490
locks held by kworker/1:4/4869: 3, on CPU#1:
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff8000966c7c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff8000966c7c20 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000c8af0258 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x198/0x320 drivers/net/netdevsim/fib.c:1490
locks held by kworker/1:5/5032: 4, on CPU#1:
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #0: ffff0000c002ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x8c8/0x1250 kernel/workqueue.c:3578
 #1: ffff80009b147c20 ((work_completion)(&helper->damage_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3470 [inline]
 #1: ffff80009b147c20 ((work_completion)(&helper->damage_work)){+.+.}-{0:0}, at: process_scheduled_works+0x8d0/0x1250 kernel/workqueue.c:3578
 #2: ffff0000c6fc6270 (&helper->lock){+.+.}-{4:4}, at: drm_fb_helper_fb_dirty drivers/gpu/drm/clients/drm_fbdev_helper.c:295 [inline]
 #2: ffff0000c6fc6270 (&helper->lock){+.+.}-{4:4}, at: drm_fb_helper_damage_work+0x120/0xbc0 drivers/gpu/drm/clients/drm_fbdev_helper.c:336
 #3: ffff0000c6f80128 (&dev->master_mutex){+.+.}-{4:4}, at: drm_master_internal_acquire+0x24/0x78 drivers/gpu/drm/drm_auth.c:435
locks held by syz.1.3811/25641: 5, last CPU#1:
 #0: ffff0000c14946a0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #1: ffff0000c9688478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #1: ffff0000c9688478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
 #2: ffff0000c9688100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:60 [inline]
 #2: ffff0000c9688100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock_excl fs/super.c:75 [inline]
 #2: ffff0000c9688100 (&type->s_umount_key#32){++++}-{4:4}, at: freeze_super+0x4a0/0xf6c fs/super.c:2242
 #3: ffff0000c9688570 (sb_pagefaults){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #3: ffff0000c9688570 (sb_pagefaults){++++}-{0:0}, at: freeze_super+0x4b8/0xf6c fs/super.c:2246
 #4: ffff0000c9688668 (sb_internal){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #4: ffff0000c9688668 (sb_internal){++++}-{0:0}, at: freeze_super+0x780/0xf6c fs/super.c:2260
locks held by syz.1.3811/25659: 1, on CPU#1:
 #0: ffff0000c14946a0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
locks held by syz.1.3811/25660: 1, on CPU#1:
 #0: ffff0000c9688100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:62 [inline]
 #0: ffff0000c9688100 (&type->s_umount_key#32){++++}-{4:4}, at: super_lock+0x258/0x344 fs/super.c:124
locks held by syz.0.3808/25644: 2, last CPU#1:
 #0: ffff0000c1495220 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #1: ffff0000f0a58478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #1: ffff0000f0a58478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
locks held by syz.0.3808/25667: 1, on CPU#1:
 #0: ffff0000c1495220 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
locks held by syz.0.3808/25668: 1, last CPU#1:
 #0: ffff0000f0a58100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:62 [inline]
 #0: ffff0000f0a58100 (&type->s_umount_key#32){++++}-{4:4}, at: super_lock+0x258/0x344 fs/super.c:124
locks held by syz.2.3812/25646: 4, last CPU#0:
 #0: ffff0000c1493b20 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #1: ffff0000ea2de478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #1: ffff0000ea2de478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
 #2: ffff0000ea2de100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:60 [inline]
 #2: ffff0000ea2de100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock_excl fs/super.c:75 [inline]
 #2: ffff0000ea2de100 (&type->s_umount_key#32){++++}-{4:4}, at: freeze_super+0x4a0/0xf6c fs/super.c:2242
 #3: ffff0000ea2de570 (sb_pagefaults){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #3: ffff0000ea2de570 (sb_pagefaults){++++}-{0:0}, at: freeze_super+0x4b8/0xf6c fs/super.c:2246
locks held by syz.2.3812/25664: 1, on CPU#0:
 #0: ffff0000c1493b20 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
locks held by syz.2.3812/25665: 1, on CPU#0:
 #0: ffff0000ea2de100 (&type->s_umount_key#32){++++}-{4:4}, at: __super_lock fs/super.c:62 [inline]
 #0: ffff0000ea2de100 (&type->s_umount_key#32){++++}-{4:4}, at: super_lock+0x258/0x344 fs/super.c:124
locks held by kmmpd-loop1/25649: 1, on CPU#1:
 #0: ffff0000c9688478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by kmmpd-loop2/25651: 1, on CPU#1:
 #0: ffff0000ea2de478 (sb_writers#3){++++}-{0:0}, at: kmmpd+0x2fc/0x938 fs/ext4/mmp.c:173
locks held by syz.3.3813/25658: 2, last CPU#0:
 #0: ffff0000c1492fa0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #1: ffff0000eab62478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #1: ffff0000eab62478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
locks held by syz.3.3813/25671: 1, on CPU#0:
 #0: ffff0000c1492fa0 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
locks held by syz.3.3813/25672: 1, last CPU#0:
 #0: ffff0000eab62478 (sb_writers#3){++++}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff0000eab62478 (sb_writers#3){++++}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff0000eab62478 (sb_writers#3){++++}-{0:0}, at: rcuwait_wake_up+0x38/0x25c kernel/exit.c:322
locks held by syz.4.3814/25662: 2, last CPU#0:
 #0: ffff0000c1492420 (&bdev->bd_fsfreeze_mutex){+.+.}-{4:4}, at: bdev_freeze+0x38/0x2e8 block/bdev.c:304
 #1: ffff0000da54c478 (sb_writers#3){++++}-{0:0}, at: sb_wait_write fs/super.c:1977 [inline]
 #1: ffff0000da54c478 (sb_writers#3){++++}-{0:0}, at: freeze_super+0x498/0xf6c fs/super.c:2241
locks held by syz-executor/25983: 1, on CPU#1:
 #0: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80
locks held by syz-executor/26125: 7, on CPU#0:
 #0: ffff0000d11a0478 (sb_writers#6){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2762 [inline]
 #0: ffff0000d11a0478 (sb_writers#6){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:683
 #1: ffff0000c9acb880 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1b0/0x3b8 fs/kernfs/file.c:336
 #2: ffff0000ca4c5008 (kn->active#55){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff0000ca4c5008 (kn->active#55){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x1f0/0x3b8 fs/kernfs/file.c:337
 #3: ffff80008a3ad460 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: del_device_store+0xd8/0x2d4 drivers/net/netdevsim/bus.c:233
 #4: ffff0000da8f3128 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1109 [inline]
 #4: ffff0000da8f3128 (&dev->mutex){....}-{4:4}, at: __device_driver_lock+0x94/0xcc drivers/base/dd.c:1046
 #5: ffff0000da8f2258 (&devlink->lock_key#14){+.+.}-{4:4}, at: devl_lock+0x24/0x34 net/devlink/core.c:314
 #6: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80
locks held by syz-executor/26181: 3, on CPU#0:
 #0: ffff8000898bbaf8 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:213 [inline]
 #0: ffff8000898bbaf8 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:320 [inline]
 #0: ffff8000898bbaf8 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x17c/0x26c net/core/rtnetlink.c:602
 #1: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock+0x38/0x10c net/core/rtnetlink.c:366
 #2: ffff80008994a5a0 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa84/0x121c kernel/workqueue.c:6201
locks held by syz-executor/26191: 1, on CPU#0:
 #0: ffff80008abcf5a0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x20/0x2c net/core/rtnetlink.c:80

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
