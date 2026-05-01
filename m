Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E7C2F617C
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2026 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777646905; cv=none; b=M2eUQXUwgC16ryf0pmCYJa3ynj/p27iZnjb+Hl2Q47TBBHgYnFuadyq/45RzVYAwKav+/SWaiPtG7v3x7vwIDzYTeC2orA9ToyQLQcqzDQ/7DndMj/8tMg+sMZVv1iPEe5qbYjZTnkKxnOPVUxCk2zaB/Q+Ofs2KysiP3njT9Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777646905; c=relaxed/simple;
	bh=iCn4il1+fR+xhzdRDO4/0pduJ++ArORnInOJYPi5JNo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XGyoDYLKd4s43l3+j41ismZ9ceBwZjWVCsF92htg5CgEtCAyppTrGKiUzecy5gkEzHYuJCY0TWa8Eufbo1mrvm012Grzsi0dk345rvIwGhUFu/Ug0SMdBeucZ+0i335BKHYrMp1udWaFSFP9vadoBwSK2L9t/cn5gtXOyrM/mEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6948d83a548so5588418eaf.0
        for <linux-ext4@vger.kernel.org>; Fri, 01 May 2026 07:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777646903; x=1778251703;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2JCmLeyeweVZ2HOndzR/fDb+J2Pz8pUafUEVYUwBkY=;
        b=YWMoZxMUuUER0pTd4+iPYQDjoQvX65Fj2R7kL0b2l5xtELn415OyVwwqkBtXmiN+Gq
         8q4SLrzyJwvigncDt/+3nMiQGFbykvEiw8BemVB9tPrRUMou8GwRMLyX1xcQzY6/LIca
         cwM/uVsWaRfMtort9+iuCpydbHKkTUEn7A52oDgtvJz1RrVWjz7h4GehrIy4CGIbi7dI
         JppJyvH5QEArGoG5AJUeQfRzlAd0lzqXxOCBPRCzM0Xeu9KSXFUtfmk4JIN5R9TYTL4z
         WRx4r+vtD8qD6JJapx8w7s+BCzLyQYRyDceY/2Qr+tGTumf5/wt3TB0Y4HmCiIWgOAs8
         rVBw==
X-Forwarded-Encrypted: i=1; AFNElJ/tf8Sbbdc9UbWxT536Tf+QsR0iNrABTuh18CIkWUc6Ny0oTLJDGa2kUCVuXuD6Uj+uFBFkSntoN5PT@vger.kernel.org
X-Gm-Message-State: AOJu0YzWr8xjklh/LQb7Uv68EKhjvZzk3jMRJnQKRjDyIJX0cBuD29sO
	tzFKR5FkzNu7VokYE8ksJQ2XrrBBpPnP/pYGSwuepIOaXQH021bRrpHAd0EEzaOCC1a6R8W5Y3S
	QvzmjDItZkBYhvJdD8NXJTHHDs7X4rNIB4vGwbDT7QDyx76ekPw7x5JGj9rg=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2912:b0:696:18a4:87c2 with SMTP id
 006d021491bc7-6967a529815mr4068872eaf.25.1777646902830; Fri, 01 May 2026
 07:48:22 -0700 (PDT)
Date: Fri, 01 May 2026 07:48:22 -0700
In-Reply-To: <69f3f165.170a0220.5f1b.0010.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f4bd36.050a0220.312cd3.0013.GAE@google.com>
Subject: Re: [syzbot] [ext4?] INFO: task jbd2/sda1-NUM:NUM blocked in I/O wait
 for more than NUM seconds.
From: syzbot <syzbot+c7604c9fdd7580cca4e0@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    26fd6bff2c05 Merge tag 'mtd/fixes-for-7.1-rc2' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1229bece580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=c7604c9fdd7580cca4e0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f37506580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171441ce580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7d72741f9879/disk-26fd6bff.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b02c6a1eba87/vmlinux-26fd6bff.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4f218b09b68f/bzImage-26fd6bff.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c7604c9fdd7580cca4e0@syzkaller.appspotmail.com

INFO: task jbd2/sda1-8:4955 blocked in I/O wait for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:jbd2/sda1-8     state:D stack:26088 pid:4955  tgid:4955  ppid:2      task_flags:0x240040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5387 [inline]
 __schedule+0x10e9/0x6820 kernel/sched/core.c:7188
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7282
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8109
 bit_wait_io+0xd/0xe0 kernel/sched/wait_bit.c:250
 __wait_on_bit+0x65/0x180 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0xdc/0x110 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:105 [inline]
 __wait_on_buffer+0x64/0x70 fs/buffer.c:123
 wait_on_buffer include/linux/buffer_head.h:420 [inline]
 jbd2_journal_commit_transaction+0x388a/0x6870 fs/jbd2/commit.c:837
 kjournald2+0x200/0x760 fs/jbd2/journal.c:201
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz.0.189:6070 blocked in I/O wait for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.189       state:D stack:28240 pid:6070  tgid:6070  ppid:5783   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5387 [inline]
 __schedule+0x10e9/0x6820 kernel/sched/core.c:7188
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7282
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8109
 bit_wait_io+0xd/0xe0 kernel/sched/wait_bit.c:250
 __wait_on_bit+0x65/0x180 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0xdc/0x110 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:105 [inline]
 do_get_write_access+0x84f/0x1220 fs/jbd2/transaction.c:1113
 jbd2_journal_get_write_access+0x1d6/0x280 fs/jbd2/transaction.c:1263
 __ext4_journal_get_write_access+0x6a/0x340 fs/ext4/ext4_jbd2.c:241
 ext4_reserve_inode_write+0x1b7/0x330 fs/ext4/inode.c:6375
 __ext4_mark_inode_dirty+0x18f/0x890 fs/ext4/inode.c:6550
 ext4_dirty_inode+0xd9/0x130 fs/ext4/inode.c:6587
 __mark_inode_dirty+0x1f3/0x1720 fs/fs-writeback.c:2623
 generic_update_time fs/inode.c:2192 [inline]
 file_update_time_flags+0x46b/0x500 fs/inode.c:2422
 ext4_page_mkwrite+0x324/0x1890 fs/ext4/inode.c:6753
 do_page_mkwrite+0x17a/0x440 mm/memory.c:3668
 do_shared_fault mm/memory.c:5969 [inline]
 do_fault+0x3b5/0x1750 mm/memory.c:6031
 do_pte_missing mm/memory.c:4550 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f97a466a883
RSP: 002b:00007ffc3f813c60 EFLAGS: 00010246
RAX: 000000000003fde8 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000001b2e124000 RSI: 0000000000040000 RDI: 00007f97a49db710
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffc3f813ef0
 </TASK>

Showing all locks held in the system:
1 lock held by ksoftirqd/1/23:
 #0: ffff8880b853b3e0 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2c/0x140 kernel/sched/core.c:652
1 lock held by khungtaskd/30:
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e52e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3d/0x184 kernel/locking/lockdep.c:6775
6 locks held by kworker/u8:3/47:
 #0: ffff88801c6ca140 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x12d6/0x1980 kernel/workqueue.c:3277
 #1: ffffc90000b77d08 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x973/0x1980 kernel/workqueue.c:3278
 #2: ffff8880389060d8 (&type->s_umount_key#33){++++}-{4:4}, at: super_trylock_shared+0x1e/0xf0 fs/super.c:565
 #3: ffff888038904c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x278/0x600 mm/page-writeback.c:2575
 #4: ffff888038902938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
 #5: ffff88807928f290 (&ei->i_data_sem){++++}-{4:4}, at: ext4_map_blocks+0x45a/0xd30 fs/ext4/inode.c:823
2 locks held by getty/5383:
 #0: ffff88802dace0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000322b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x419/0x14f0 drivers/tty/n_tty.c:2211
3 locks held by syz.0.189/6070:
 #0: ffff88807e006bc8 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff888038906508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3668
 #2: ffff888038902938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz-executor/6077:
 #0: ffff888038906410 (sb_writers#4){.+.+}-{0:0}, at: filename_create+0x10d/0x400 fs/namei.c:4943
 #1: ffff8880792b1f98 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #1: ffff8880792b1f98 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2914 [inline]
 #1: ffff8880792b1f98 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2938 [inline]
 #1: ffff8880792b1f98 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: filename_create+0x1c0/0x400 fs/namei.c:4950
 #2: ffff888038902938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x12d/0x151 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x1d7/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x141/0x190 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xcb1/0x1030 kernel/hung_task.c:561
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 1057 Comm: kworker/u8:7 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:smp_call_function_many_cond+0xdd4/0x1700 kernel/smp.c:871
Code: 00 00 0f 84 1e 05 00 00 e8 c9 6a 0c 00 83 c5 01 bf 07 00 00 00 48 63 dd 48 89 de e8 96 65 0c 00 48 83 fb 07 0f 86 22 fb ff ff <44> 8b 64 24 58 44 8b 7c 24 5c e8 9d 6a 0c 00 8b 5c 24 4c bf 01 00
RSP: 0018:ffffc90003d37870 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81fb686f
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888029b83d80
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003d37958
R13: ffff8880b843c6c0 R14: ffff8880b843c601 R15: ffff8880b853c710
FS:  0000000000000000(0000) GS:ffff88812447d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a400fed660 CR3: 000000000e596000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x40/0x90 kernel/smp.c:1057
 on_each_cpu include/linux/smp.h:72 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2773 [inline]
 smp_text_poke_batch_finish+0x976/0xc60 arch/x86/kernel/alternative.c:3045
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x37a/0x550 kernel/jump_label.c:910
 static_key_enable_cpuslocked+0x1bc/0x270 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate mm/kfence/core.c:906 [inline]
 toggle_allocation_gate+0xfe/0x2d0 mm/kfence/core.c:898
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	0f 84 1e 05 00 00    	je     0x526
   8:	e8 c9 6a 0c 00       	call   0xc6ad6
   d:	83 c5 01             	add    $0x1,%ebp
  10:	bf 07 00 00 00       	mov    $0x7,%edi
  15:	48 63 dd             	movslq %ebp,%rbx
  18:	48 89 de             	mov    %rbx,%rsi
  1b:	e8 96 65 0c 00       	call   0xc65b6
  20:	48 83 fb 07          	cmp    $0x7,%rbx
  24:	0f 86 22 fb ff ff    	jbe    0xfffffb4c
* 2a:	44 8b 64 24 58       	mov    0x58(%rsp),%r12d <-- trapping instruction
  2f:	44 8b 7c 24 5c       	mov    0x5c(%rsp),%r15d
  34:	e8 9d 6a 0c 00       	call   0xc6ad6
  39:	8b 5c 24 4c          	mov    0x4c(%rsp),%ebx
  3d:	bf                   	.byte 0xbf
  3e:	01 00                	add    %eax,(%rax)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
