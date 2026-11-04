Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834247;
	b=cbMiLn8PdFj2HLxT6SyTeWoodGb2f9q+IAYxNCCviPoJGWAY4stxmg9fpSIgvqlHq2MY
	 CYLkhbh+EQUbTfFZUQzvadd1VdELF/kIrxIl1lkKIZCbMYjIGbjWXZ5gq3pfsuLmdLk06
	 g10IHxczh/Rkv0VtIeAl2KCQNkDif/6n0qyJ8Fnh30M0kP1zY/VAek3KBlSzuE65FZF8S
	 wCpI1dOp9r6h/wpVXzzQ7AA4GtZqi8dVIZCUzkEpEeiSH5mJ4Zb+v+Q8Zn4DNaCSJxgoC
	 IbHtQAqkCM1omFGjMnsCKjE3AfT8MKX1kMNujY5wOUgNJMMI13JFuiynB2k4ioJUjtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834247;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=EUNPXgVS4+pPl4o6fy0hi9HXzpCvpznpRLhaacvk77s=;
	b=D5ZDtLV9PCA350f4INJLlOBI6OQrrVJzXMJz5kNk/EgTeVl3mU7SgI0Fl5y46feofPew
	 J2MaHdolSLg1pZElywNAQzSuUwEpiQvFaZLQ2CuyIlw0wO7UGuKdpOjwQFq542D6J0gHz
	 kRo9qW6nH59wiHXqUw0LfIzrX5koMm0VSH0NWeva8mU9rTD7JUnbZkVOeCO4kKBwkUJDd
	 jsY6PJnbq3GgMrNuFvLZycJ4DLsoYr1kOWQb0H5Ic5n8N7XPlJuEOQEbS/4u47+KWWICY
	 Z1hcS99DCarb+xKJp1uO029sc05JgThWLiOusA8sVathDVVELJrPazQuxd5qJtbBmzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2381D606A328
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 23:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2381D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4f9b643ae53so933929b6e.3
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2026 15:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793834246; x=1794439046;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EUNPXgVS4+pPl4o6fy0hi9HXzpCvpznpRLhaacvk77s=;
        b=vrpXxtni8kdGEow9gJdzEIsX5sMVSGm/3MVU97RvWnqY7/yW3ldnyavn8l6wbkS3Ni
         fiatCIsraNoxYPYlVkosm+vS20KizJd2XqPqzc7McQNoo33v66lkMHw4nB9PHIC0D5tV
         Of6IXdNOHXW0Y6INtWCrTK67/NrIGY70hCMs9QWYzGqT7yRc1rLH7eDV3+BM7sOdQ7fj
         X6vcEbCQJIgJMDk9VmkpK2zv8qFr/z6swT0STCXdxY3KfkDtcfUtWHe8kMdRklia62hy
         xbQyogH6Che2Gb9F+p1IlFcD/T9yt5ulgWnK98SVLOhEVUaX8cwefVERhhBBGbidhYut
         qCGA==
X-Forwarded-Encrypted: i=1; AKwUvBx4+AoqEO6nGYesuWL+KVo8+5391FQ8kGvkAMi8LCAnAzAeGC9AEyFLwhUwdvaJ6jQUE8W0dAI8rvwl@vger.kernel.org
X-Gm-Message-State: APuU4Z/ij1uVIRYrwrRvhSRcTpAiirDlcEwdAL82mTFCFP4FKlcupQIs
	CvFZTLQ+JkuyOMI89TBsYD/IE1QkP3DoGV3JHFpGMEZjmcpPWLuxboc4oCvMzP6Y5CGFlSGpwCS
	vHg/qTrwyvhf4Q6xGZ1vEduyBk6gkYb2aWgbiGpV5nxApGF0Tr+N380dV5xs=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3c49:b0:55c:928:6a0f with SMTP id
 5614622812f47-5640ddd105cmr12069524b6e.52.1793834246093; Wed, 04 Nov 2026
 15:17:26 -0800 (PST)
Date: Wed, 04 Nov 2026 15:17:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aebbd06.21d05368.325ed5.0000.GAE@google.com>
Subject: [syzbot] [btrfs?] [ext4?] [ntfs3?] memory leak in __pcs_replace_full_main
From: syzbot <syzbot+4d078516add5f4f12cea@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dsterba@suse.com, hpa@zytor.com, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, ntfs3@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    36aad21d50d1 Merge tag 'ksmbd-for-7.4-rc1-part2' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e205f1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afcef595c54d5d11
dashboard link: https://syzkaller.appspot.com/bug?extid=4d078516add5f4f12cea
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e205f1580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/67a38cdd86cf/disk-36aad21d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b8834e6d3d5/vmlinux-36aad21d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9103be67c72d/bzImage-36aad21d.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/a661f7a0d152/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=130fea8d580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/5aa6292982d9/mount_13.gz
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/5bf87b41f4ce/mount_16.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=13558981580000)

AI-generated root cause summary:
The SLUB allocator's sheaf caching layer allocates 'struct slab_sheaf' objects
via kmalloc_flags(), which registers them with kmemleak for leak tracking. When
full RCU sheaves are retired in __kfree_rcu_sheaf(), they are queued into RCU
via call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf). While pending in RCU's
singly-linked callback list, if any preceding callback resides in memory
untracked or ignored by kmemleak (such as struct slab from
call_rcu(&slab->rcu_head, rcu_free_slab)), kmemleak cannot traverse the chain to
reach subsequent callbacks. Because __alloc_empty_sheaf() does not mark the
sheaf with kmemleak_not_leak() (which marks the metadata grey so it is not
reported as a leak while still scanning its cached objects), kmemleak falsely
flags pending RCU sheaves as unreferenced memory leaks.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=4d078516add5f4f12cea

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d078516add5f4f12cea@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff8881009d4e00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937433
  hex dump (first 32 bytes):
    b0 7e 81 2d 81 88 ff ff 60 bd b3 81 ff ff ff ff  .~.-....`.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 91d5a5d8):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    vfree mm/vmalloc.c:3549 [inline]
    vfree+0xa8/0x390 mm/vmalloc.c:3521
    delayed_vfree_work+0x29/0x40 mm/vmalloc.c:3451
    process_one_work+0x2b7/0x5c0 kernel/workqueue.c:3495
    process_scheduled_works kernel/workqueue.c:3578 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3659
    kthread+0x150/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888102382600 (size 512):
  comm "kworker/u8:6", pid 403, jiffies 4294937442
  hex dump (first 32 bytes):
    10 45 0c 2d 81 88 ff ff 60 bd b3 81 ff ff ff ff  .E.-....`.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 2d83b05a):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:117
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881009e5600 (size 512):
  comm "softirq", pid 0, jiffies 4294937452
  hex dump (first 32 bytes):
    10 25 4b 2c 81 88 ff ff 60 bd b3 81 ff ff ff ff  .%K,....`.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 9cf07d25):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    security_task_free+0x6e/0x130 security/security.c:2827
    __put_task_struct+0x9f/0x260 kernel/fork.c:792
    rcu_do_batch kernel/rcu/tree.c:2650 [inline]
    rcu_core+0x269/0x720 kernel/rcu/tree.c:2919
    handle_softirqs+0x114/0x330 kernel/softirq.c:669
    run_ksoftirqd kernel/softirq.c:1133 [inline]
    run_ksoftirqd+0x20/0x30 kernel/softirq.c:1125
    smpboot_thread_fn+0x1f5/0x430 kernel/smpboot.c:162
    kthread+0x150/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888109c00000 (size 512):
  comm "udevadm", pid 4995, jiffies 4294938376
  hex dump (first 32 bytes):
    00 3e 67 26 81 88 ff ff 60 bd b3 81 ff ff ff ff  .>g&....`.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc acde3b3b):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
    alloc_from_pcs mm/slub.c:4887 [inline]
    slab_alloc_node mm/slub.c:5021 [inline]
    __kmalloc_cache_noprof+0x370/0x3f0 mm/slub.c:5676
    _kmalloc_noprof include/linux/slab.h:991 [inline]
    _kzalloc_noprof include/linux/slab.h:1312 [inline]
    kernfs_get_open_node fs/kernfs/file.c:537 [inline]
    kernfs_fop_open+0x523/0x620 fs/kernfs/file.c:725
    do_dentry_open+0x1d9/0x7e0 fs/open.c:1000
    vfs_open_consume+0x4e/0x1c0 fs/open.c:1131
    do_open fs/namei.c:4851 [inline]
    path_openat+0xb90/0x1250 fs/namei.c:5016
    do_file_open+0x121/0x200 fs/namei.c:5045
    do_sys_openat2+0xd9/0x140 fs/open.c:1442
    do_sys_open fs/open.c:1448 [inline]
    __do_sys_openat fs/open.c:1464 [inline]
    __se_sys_openat fs/open.c:1459 [inline]
    __x64_sys_openat+0x82/0xf0 fs/open.c:1459
    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
    do_syscall_64+0xe9/0x530 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888109bff800 (size 512):
  comm "udevd", pid 4994, jiffies 4294938441
  hex dump (first 32 bytes):
    70 76 fd 26 81 88 ff ff 60 bd b3 81 ff ff ff ff  pv.&....`.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 1107e34f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __kfree_rcu_sheaf+0x1aa/0x2d0 mm/slub.c:6282
    kfree_rcu_sheaf mm/slab_common.c:1689 [inline]
    kvfree_call_rcu+0x1ef/0x3a0 mm/slab_common.c:2044
    kernfs_unlink_open_file+0x18f/0x1a0 fs/kernfs/file.c:611
    kernfs_fop_release+0x55/0x110 fs/kernfs/file.c:790
    __fput+0x1a6/0x4f0 fs/file_table.c:512
    fput_close_sync+0x67/0x130 fs/file_table.c:618
    filp_close_sync fs/open.c:1573 [inline]
    __do_sys_close fs/open.c:1596 [inline]
    __se_sys_close fs/open.c:1583 [inline]
    __x64_sys_close+0x4a/0xc0 fs/open.c:1583
    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
    do_syscall_64+0xe9/0x530 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88810a9dae00 (size 512):
  comm "sshd", pid 5384, jiffies 4294938845
  hex dump (first 32 bytes):
    00 7e 05 26 81 88 ff ff 60 bd b3 81 ff ff ff ff  .~.&....`.......
    00 4a 04 00 81 88 ff ff 20 00 00 00 00 00 00 00  .J...... .......
  backtrace (crc b8bd2d90):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    kmem_cache_prefill_sheaf+0x1a2/0x2d0 mm/slub.c:5279
    mt_get_sheaf lib/maple_tree.c:154 [inline]
    mas_alloc_nodes lib/maple_tree.c:1079 [inline]
    mas_preallocate+0x3fb/0x6f0 lib/maple_tree.c:5016
    vma_iter_prealloc mm/vma.h:698 [inline]
    __mmap_new_vma mm/vma.c:2713 [inline]
    __mmap_region+0xd92/0x1be0 mm/vma.c:3054
    mmap_region+0x19c/0x2a0 mm/vma.c:3136
    do_mmap+0x950/0xdf0 mm/mmap.c:573
    vm_mmap_pgoff+0x195/0x310 mm/util.c:581
    ksys_mmap_pgoff+0x89/0x2e0 mm/mmap.c:619
    __do_sys_mmap arch/x86/kernel/sys_x86_64.c:96 [inline]
    __se_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
    __x64_sys_mmap+0x6f/0xa0 arch/x86/kernel/sys_x86_64.c:89
    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
    do_syscall_64+0xe9/0x530 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF
** replaying previous printk message **


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
