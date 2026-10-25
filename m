Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792919334;
	b=oFjhTsJfRTL4HOSRyw6aaL6yBjCPc4w7AuWXWh+nnRnZOtnHkz83y9WbBXvi5AM2jBfa
	 C8ArffbBQuEXgNyCMcVbs364KfOrn9Pv4PQbHliHndrDfVs/QvgVVqCLIMcOpBEJwHRrE
	 rQPXMVm2KqWAjJc/otSS/UBPnQUD7bpKyUPLxIIRf9ZzgqQG1HN3saUjuvSW0+kpGpA8Y
	 muxEGdYiy0paLfuHKVg0UNv2f2YQgJMgcfBtPOLmtQMxUQ5kvruHTX0/crkyRrnuU9eV9
	 tHq1iXi72OrVIbU4mi6MnHWVeafacu0QPgUNyPI7wRbihGOGW7pGHrYXk8Yav9PrfWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792919334;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=acY1FDyEXMjDSiClFo0V8gS9Ia16WlR2yri1y2QRPiE=;
	b=oUFpDeKYCiPJRUL0tcveGYszMRxQ2s1/jbk1++EkOvZgGvxfNZzmTe1wbNdKlPyJHNQK
	 bSYlCyzdtWMwiJbT1OkCwLdxbjaAiJMh0tpx2JRFY/Znv6MOs1T0tOzIPLZ8quK1Cx5tx
	 HlZNPG/wq7Sgc4hEjf1XN6TpGL+q42xiyed9L07/N4tv0x4uVfoN0zyQ2IwACpiAYEBIz
	 Bvfr/T8BTdkk5n4B1ONvHAS8J0WpaBwcS1ieiDjpDlRNj4WYJ2RgrNnz80sAUgGsWjv5c
	 K6sMKOHSaOWkyT6pJa4Dii//l1HL5LA4H7xSXtAlgjTbUHn1SnnQjFxo5laFvU2l3sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C94606A31B
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 09:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7C94606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28deb7ee3so3570454b6e.0
        for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 02:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792919332; x=1793524132;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=acY1FDyEXMjDSiClFo0V8gS9Ia16WlR2yri1y2QRPiE=;
        b=aPwTUyZLWnNoGvUZG2rEnKfo2a1JUc6Mh3frcJVrlksV+M+bNVPF1+I0DliEqyNgzm
         bDIwwX9HWqsyiIEV9yiKp7hw2d6Nu13zs64IEwUvsWgJoOJYpoctJtI4Ea8M6J2FIKnr
         YEihCf5wGVgcxNzZMWUA+c3Gk8eoNNQjuK3W5t3hkHv4CQWzLrevokwRbZuV7gpzkxbZ
         kmcquBOEYAPr8muPHv5eMtOy15kgS7Z3MnJC2ekXxGcWg+oyj7sR+i/kNARd19Fqf3eh
         CFsbo7xqKphuRIojX5BV5JdiGN3sa2FEsc2ckuA911+GQoeJpRNAIeW20BAnXA9PGFXv
         mffA==
X-Forwarded-Encrypted: i=1; AKwUvBxuZOH4lhhnCUvAesdeTEi6lVzaDNmOfBlfFhEM8GxmHWVwr83rLS5R7aQZ1gPyzKnAcLkY1dfRll2L@vger.kernel.org
X-Gm-Message-State: AFq9FYKf1/gYB4F4NB7S+Cur7x7ke5GGTBDxleQShQNur0TXkR8Vy/YR
	uHMfSkgxUKtVMTQwH/OB6N2oA9eyxFfWgY3nOchuomZQKe9oe4xOFK7+W6axUpFK6TlnwcRQZ7N
	n+7gawQ5CR+C67oxw3KjmhC5YE4mS+qNXDGJMZSdKYN/8YeRj3T8Jm7aCMzw=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1522:b0:4f4:813c:6a21 with SMTP id
 5614622812f47-55c0026b6e3mr2453108b6e.20.1792919332647; Sun, 25 Oct 2026
 02:08:52 -0700 (PDT)
Date: Sun, 25 Oct 2026 02:08:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6addc724.a6443767.132891.001c.GAE@google.com>
Subject: [syzbot] [ext4?] possible deadlock in dqget (3)
From: syzbot <syzbot+d40725440a13ae53e0c4@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9e947d96915a Merge tag 'chrome-platform-firmware-v7.4' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17afc58e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3355e7b9dd6fe8f
dashboard link: https://syzkaller.appspot.com/bug?extid=d40725440a13ae53e0c4
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3c5e7318955b/disk-9e947d96.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b9f0f48a2f8b/vmlinux-9e947d96.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ddb2172ffb17/bzImage-9e947d96.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d40725440a13ae53e0c4@syzkaller.appspotmail.com

EXT4-fs (loop6): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
ext4 filesystem being mounted at /87/file1 supports timestamps until 2038-01-19 (0x7fffffff)
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.6.3297/16861 is trying to acquire lock:
ffff888054410960 (&dquot->dq_lock){+.+.}-{4:4}, at: wait_on_dquot fs/quota/dquot.c:357 [inline]
ffff888054410960 (&dquot->dq_lock){+.+.}-{4:4}, at: dqget+0x69d/0xbd0 fs/quota/dquot.c:997

but task is already holding lock:
ffff888076702500 (&ei->xattr_sem){++++}-{4:4}, at: ext4_setattr+0x891/0x1df0 fs/ext4/inode.c:6061

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #10 (&ei->xattr_sem){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       ext4_readpage_inline+0x36/0x6a0 fs/ext4/inline.c:548
       ext4_read_folio+0x15e/0x520 fs/ext4/readpage.c:330
       filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2520
       filemap_create_folio mm/filemap.c:2658 [inline]
       filemap_get_pages+0xc86/0x1ec0 mm/filemap.c:2720
       filemap_read+0x421/0x11e0 mm/filemap.c:2824
       ext4_file_read_iter+0x553/0xad0 fs/ext4/file.c:-1
       __kernel_read+0x4ca/0x960 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x451/0x890 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
       process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4847 [inline]
       path_openat+0x174c/0x20f0 fs/namei.c:5010
       do_file_open+0x23e/0x4a0 fs/namei.c:5039
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #9 (mapping.invalidate_lock#2){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
       do_page_cache_ra mm/readahead.c:347 [inline]
       page_cache_ra_order+0xb37/0xee0 mm/readahead.c:558
       do_sync_mmap_readahead+0x75e/0x990 mm/filemap.c:3443
       filemap_fault+0x7d9/0x13b0 mm/filemap.c:3597
       __do_fault+0x138/0x2a0 mm/memory.c:5565
       do_read_fault mm/memory.c:6000 [inline]
       do_fault mm/memory.c:6134 [inline]
       do_pte_missing+0x2215/0x34b0 mm/memory.c:4700
       handle_pte_fault mm/memory.c:6558 [inline]
       __handle_mm_fault mm/memory.c:6707 [inline]
       handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
       do_user_addr_fault+0x7f6/0x1480 arch/x86/mm/fault.c:1394
       handle_page_fault arch/x86/mm/fault.c:1483 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
       copy_from_user_iter lib/iov_iter.c:67 [inline]
       iterate_ubuf include/linux/iov_iter.h:30 [inline]
       iterate_and_advance2 include/linux/iov_iter.h:302 [inline]
       iterate_and_advance include/linux/iov_iter.h:330 [inline]
       __copy_from_iter lib/iov_iter.c:261 [inline]
       _copy_from_iter+0x216/0x1660 lib/iov_iter.c:272
       copy_from_iter include/linux/uio.h:228 [inline]
       copy_from_iter_full include/linux/uio.h:245 [inline]
       skb_do_copy_data_nocache include/net/sock.h:2331 [inline]
       skb_copy_to_page_nocache include/net/sock.h:2357 [inline]
       tcp_sendmsg_locked+0x20cf/0x5400 net/ipv4/tcp.c:1310
       tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1451
       sock_sendmsg_nosec+0x10e/0x180 net/socket.c:801
       __sock_sendmsg net/socket.c:815 [inline]
       sock_write_iter+0x2de/0x3e0 net/socket.c:1266
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #8 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0x41/0x100 net/core/sock.c:3865
       lock_sock include/net/sock.h:1715 [inline]
       inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:913
       nbd_mark_nsock_dead+0x2cb/0x550 drivers/block/nbd.c:319
       recv_work+0x1cee/0x1e10 drivers/block/nbd.c:1030
       process_one_work kernel/workqueue.c:3396 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #7 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x373/0xff0 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2130
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2545
       process_one_work kernel/workqueue.c:3396 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #6 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_queue_rq+0xc1/0xff0 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2130
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2545
       process_one_work kernel/workqueue.c:3396 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #5 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:210 [inline]
       __synchronize_srcu+0xc9/0x2e0 kernel/rcu/srcutree.c:1462
       elevator_switch+0x1e8/0x7b0 block/elevator.c:576
       elevator_change+0x2fa/0x480 block/elevator.c:681
       elevator_set_default+0x375/0x440 block/elevator.c:754
       blk_register_queue+0x3f3/0x4e0 block/blk-sysfs.c:992
       __add_disk+0x6b8/0xdb0 block/genhd.c:531
       add_disk_fwnode+0x100/0x3a0 block/genhd.c:600
       add_disk include/linux/blkdev.h:798 [inline]
       nbd_dev_add+0x733/0xb60 drivers/block/nbd.c:2026
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2743
       do_one_initcall+0x250/0x870 init/main.c:1362
       do_initcall_level+0x10a/0x1a0 init/main.c:1424
       do_initcalls+0x59/0xa0 init/main.c:1440
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1675
       kernel_init+0x22/0x1d0 init/main.c:1565
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #4 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       elevator_change+0x1af/0x480 block/elevator.c:679
       elv_iosched_store+0x504/0x630 block/elevator.c:826
       queue_attr_store+0x207/0x2b0 block/blk-sysfs.c:906
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&q->q_usage_counter(io)#66){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:504
       blk_mq_alloc_queue block/blk-mq.c:4431 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4478
       null_add_dev+0xe82/0x1d70 drivers/block/null_blk/main.c:2017
       null_create_dev drivers/block/null_blk/main.c:2114 [inline]
       null_init+0x1e3/0x390 drivers/block/null_blk/main.c:2178
       do_one_initcall+0x250/0x870 init/main.c:1362
       do_initcall_level+0x10a/0x1a0 init/main.c:1424
       do_initcalls+0x59/0xa0 init/main.c:1440
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1675
       kernel_init+0x22/0x1d0 init/main.c:1565
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4636 [inline]
       slab_alloc_node mm/slub.c:4974 [inline]
       __do_kmalloc_node mm/slub.c:5413 [inline]
       __kmalloc_noprof+0xbc/0x710 mm/slub.c:5439
       _kmalloc_noprof include/linux/slab.h:995 [inline]
       find_tree_dqentry+0x5c/0x1090 fs/quota/quota_tree.c:663
       find_dqentry fs/quota/quota_tree.c:716 [inline]
       qtree_read_dquot+0x5ac/0x8a0 fs/quota/quota_tree.c:736
       ocfs2_acquire_dquot+0x2d4/0xb70 fs/ocfs2/quota_global.c:852
       dqget+0x725/0xbd0 fs/quota/dquot.c:1002
       __dquot_initialize+0x3c8/0xd40 fs/quota/dquot.c:1462
       ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
       ocfs2_mknod+0x8af/0x21a0 fs/ocfs2/namei.c:315
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:678
       lookup_open+0xee3/0x1970 fs/namei.c:4569
       open_last_lookups fs/namei.c:4768 [inline]
       path_openat+0x710/0x20f0 fs/namei.c:5007
       do_file_open+0x23e/0x4a0 fs/namei.c:5039
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]){+.+.}-{4:4}:
       down_write+0x91/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       ocfs2_lock_global_qf+0x206/0x400 fs/ocfs2/quota_global.c:313
       ocfs2_acquire_dquot+0x28c/0xb70 fs/ocfs2/quota_global.c:842
       dqget+0x725/0xbd0 fs/quota/dquot.c:1002
       __dquot_initialize+0x3c8/0xd40 fs/quota/dquot.c:1462
       ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
       ocfs2_mknod+0x8af/0x21a0 fs/ocfs2/namei.c:315
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:678
       lookup_open+0xee3/0x1970 fs/namei.c:4569
       open_last_lookups fs/namei.c:4768 [inline]
       path_openat+0x710/0x20f0 fs/namei.c:5007
       do_file_open+0x23e/0x4a0 fs/namei.c:5039
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&dquot->dq_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       wait_on_dquot fs/quota/dquot.c:357 [inline]
       dqget+0x69d/0xbd0 fs/quota/dquot.c:997
       dquot_transfer+0x2ac/0x660 fs/quota/dquot.c:2097
       ext4_setattr+0x8a3/0x1df0 fs/ext4/inode.c:6062
       notify_change+0xbba/0xea0 fs/attr.c:556
       chown_common+0x41c/0x630 fs/open.c:825
       vfs_fchown fs/open.c:890 [inline]
       ksys_fchown+0xe9/0x160 fs/open.c:902
       __do_sys_fchown fs/open.c:907 [inline]
       __se_sys_fchown fs/open.c:905 [inline]
       __x64_sys_fchown+0x7a/0x90 fs/open.c:905
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &dquot->dq_lock --> mapping.invalidate_lock#2 --> &ei->xattr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&ei->xattr_sem);
                               lock(mapping.invalidate_lock#2);
                               lock(&ei->xattr_sem);
  lock(&dquot->dq_lock);

 *** DEADLOCK ***

locks held by syz.6.3297/16861: 3, last CPU#1:
 #0: ffff88807a788460 (sb_writers#4){++++}-{0:0}, at: mnt_want_write_file+0x60/0x200 fs/namespace.c:575
 #1: ffff8880767027c0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1029 [inline]
 #1: ffff8880767027c0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: chown_common+0x313/0x630 fs/open.c:813
 #2: ffff888076702500 (&ei->xattr_sem){++++}-{4:4}, at: ext4_setattr+0x891/0x1df0 fs/ext4/inode.c:6061

stack backtrace:
CPU: 1 UID: 0 PID: 16861 Comm: syz.6.3297 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 wait_on_dquot fs/quota/dquot.c:357 [inline]
 dqget+0x69d/0xbd0 fs/quota/dquot.c:997
 dquot_transfer+0x2ac/0x660 fs/quota/dquot.c:2097
 ext4_setattr+0x8a3/0x1df0 fs/ext4/inode.c:6062
 notify_change+0xbba/0xea0 fs/attr.c:556
 chown_common+0x41c/0x630 fs/open.c:825
 vfs_fchown fs/open.c:890 [inline]
 ksys_fchown+0xe9/0x160 fs/open.c:902
 __do_sys_fchown fs/open.c:907 [inline]
 __se_sys_fchown fs/open.c:905 [inline]
 __x64_sys_fchown+0x7a/0x90 fs/open.c:905
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f97ffd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9800cf4028 EFLAGS: 00000246 ORIG_RAX: 000000000000005d
RAX: ffffffffffffffda RBX: 00007f9800025fa0 RCX: 00007f97ffd9f559
RDX: 000000000000ee01 RSI: 000000000000ee00 RDI: 0000000000000004
RBP: 00007f97ffe36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9800026038 R14: 00007f9800025fa0 R15: 00007ffebd0b9088
 </TASK>


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
