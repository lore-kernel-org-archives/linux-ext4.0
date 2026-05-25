Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA5235C01
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779732512; cv=none; b=eBpBMrptj8yliidVkaFmD98iJg1+3PiACCrIr/KOBCAqR0rq2aXMe+iGFC403YXVVZrePyqmnbZLchSmaAhkrTSzNLn4GXfSxtDFZTR/Xm//DAjQm3xS19V0VjSZqkt4Gcjf1E026PP6GbBPVDIzpVsG6yJ+ViiKq0UtpAeoVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779732512; c=relaxed/simple;
	bh=b3XgTS/txFXLKhn98eeuLyNJTF6ekIsYvSXJ0vfw4q8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CkzPzG9FlbIjYWu3eXajcgtDMFoZFK/9L+7yYUxlz5l0l+T5fD6ukFZXfDbYsEGi3ZS5WYx2o4XusKTF2fHcGXQwd04MagdE2aVYhsYe4eRPvEZObyoZ57PWoypQmEIsdO086kbXcHYotybnPSbS/wyORYgKzCzrSLaNfB42qkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7e60dfcced4so6117368a34.2
        for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 11:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779732509; x=1780337309;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h7nQ18ivxQ3hBmgb0qE4UDctNTmQnf20t1hDFhllpIY=;
        b=LePWBntjU/isKCyYZXZkNBmvalZweRzpxjK6u3XgS/iUtUHdoUKsMVqo5hxtyxjcos
         VPPm0dGuhmqmKP3OhdEgpoRw15Oe3jZv2Ab1CLLeSByRvM69oeG668X1S4+1dEViGjZm
         +HlJ+RMhE8Btb73dZj3nRKrJ90+eFynZWSbZyNenQjeUoGp590yqlzzX41WVZwnwnnxK
         i10wVrk/fGIt9NjlYOs6xZImbR39eYjJXRVlGbEbnYEXOWawY95H/CRSxRknzqOTvSgp
         2g4IqeskLIa3ZeVm4kr8/s2tL8co0guEFRggc1s2ndSguGjEt0tqVN1zoHMrMWtcfKEB
         eN8g==
X-Forwarded-Encrypted: i=1; AFNElJ+sohB/pQ3iKbv8gFVL4eiSaKM8lWWJ3SdoQvRXf0xPPFxb5r6Lyyp/PA/1Kb3I/ExRL8HtRL59af6d@vger.kernel.org
X-Gm-Message-State: AOJu0YzXLKKo85HgpNV21HFZ4EmbYhUmQufRKdMXNPmlNsmkfXEBTRei
	q9SUbcfy+hTi4JQ3xmcifa9pX6YFT4QLIPWANLaAEKl/Y0JlTfP+D9oml3KfTi8WunJs+03vV1D
	/jfUPHbKwebZVliD+EpT2JFFQPDFRMi/eKej/gqtZFaYfh5e6f1OWCCJ7KDI=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2006:b0:69d:8c39:4152 with SMTP id
 006d021491bc7-69d8c3943c8mr6681991eaf.4.1779732509095; Mon, 25 May 2026
 11:08:29 -0700 (PDT)
Date: Mon, 25 May 2026 11:08:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a14901d.170a0220.22ae77.000c.GAE@google.com>
Subject: [syzbot] INFO: task kworker/u8:NUM:NUM blocked in I/O wait for more
 than NUM seconds. (2)
From: syzbot <syzbot+ce3f1479b6afc3f5d0cc@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e7ae89a0c97c Linux 7.1-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104f6e1f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58acee1ac5406016
dashboard link: https://syzkaller.appspot.com/bug?extid=ce3f1479b6afc3f5d0cc
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9b0c5b4e3645/disk-e7ae89a0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ed163d3ad68b/vmlinux-e7ae89a0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2408b333334/bzImage-e7ae89a0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ce3f1479b6afc3f5d0cc@syzkaller.appspotmail.com

INFO: task kworker/u8:6:1008 blocked in I/O wait for more than 143 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:6    state:D stack:20696 pid:1008  tgid:1008  ppid:2      task_flags:0x4248060 flags:0x00080000
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
 bit_wait_io+0xd/0xe0 kernel/sched/wait_bit.c:250
 __wait_on_bit+0x65/0x180 kernel/sched/wait_bit.c:52
 out_of_line_wait_on_bit+0xdc/0x110 kernel/sched/wait_bit.c:67
 wait_on_bit_io include/linux/wait_bit.h:105 [inline]
 do_get_write_access+0x84f/0x1220 fs/jbd2/transaction.c:1113
 jbd2_journal_get_write_access+0x1d6/0x280 fs/jbd2/transaction.c:1263
 __ext4_journal_get_write_access+0x6a/0x340 fs/ext4/ext4_jbd2.c:241
 ext4_reserve_inode_write+0x1b7/0x330 fs/ext4/inode.c:6375
 __ext4_mark_inode_dirty+0x18f/0x890 fs/ext4/inode.c:6550
 __ext4_ext_dirty+0x1b2/0x230 fs/ext4/extents.c:207
 ext4_ext_insert_extent+0x11ff/0x4540 fs/ext4/extents.c:2210
 ext4_ext_map_blocks+0x21c8/0x5930 fs/ext4/extents.c:4482
 ext4_map_create_blocks+0xec/0x5e0 fs/ext4/inode.c:631
 ext4_map_blocks+0x46b/0xd30 fs/ext4/inode.c:824
 mpage_map_one_extent fs/ext4/inode.c:2396 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2490 [inline]
 ext4_do_writepages+0x2313/0x3f20 fs/ext4/inode.c:2948
 ext4_writepages+0x347/0x790 fs/ext4/inode.c:3042
 do_writepages+0x278/0x600 mm/page-writeback.c:2571
 __writeback_single_inode+0x164/0x1350 fs/fs-writeback.c:1764
 writeback_sb_inodes+0x766/0x1c60 fs/fs-writeback.c:2056
 __writeback_inodes_wb+0xf8/0x2d0 fs/fs-writeback.c:2132
 wb_writeback+0x720/0xb90 fs/fs-writeback.c:2243
 wb_check_old_data_flush fs/fs-writeback.c:2347 [inline]
 wb_do_writeback fs/fs-writeback.c:2400 [inline]
 wb_workfn+0x8dd/0xc00 fs/fs-writeback.c:2428
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3314
 process_scheduled_works kernel/workqueue.c:3397 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3478
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task jbd2/sda1-8:4956 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:jbd2/sda1-8     state:D stack:27000 pid:4956  tgid:4956  ppid:2      task_flags:0x240040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
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
INFO: task syz-executor:5615 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:22480 pid:5615  tgid:5615  ppid:5614   task_flags:0x440100 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
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
 generic_update_time fs/inode.c:2198 [inline]
 file_update_time_flags+0x46b/0x500 fs/inode.c:2428
 ext4_page_mkwrite+0x324/0x1890 fs/ext4/inode.c:6753
 do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 do_shared_fault mm/memory.c:5985 [inline]
 do_fault+0x3b5/0x1750 mm/memory.c:6047
 do_pte_missing mm/memory.c:4566 [inline]
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6565
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6734
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f7c33c7b467
RSP: 002b:00007ffd3e90b380 EFLAGS: 00010202
RAX: 00007f7c31f0c000 RBX: 00005555940107b0 RCX: 0000000000000006
RDX: 0000000000000ed3 RSI: 000055559400d0d8 RDI: 0000000000000040
RBP: 00007ffd3e90b880 R08: 00000000000000c4 R09: 000055559400d0d8
R10: 00007f7c33c00000 R11: 0000000000000202 R12: 00007ffd3e90b6c0
R13: 00007ffd3e90b4b0 R14: 585858582e7a7973 R15: 00007ffd3e90b400
 </TASK>
INFO: task syz.3.261:7085 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.261       state:D stack:27128 pid:7085  tgid:7085  ppid:5630   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
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
 generic_update_time fs/inode.c:2198 [inline]
 file_update_time_flags+0x46b/0x500 fs/inode.c:2428
 ext4_page_mkwrite+0x324/0x1890 fs/ext4/inode.c:6753
 do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 do_shared_fault mm/memory.c:5985 [inline]
 do_fault+0x3b5/0x1750 mm/memory.c:6047
 do_pte_missing mm/memory.c:4566 [inline]
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6565
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6734
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f5e25071580
RSP: 002b:00007ffdb95adcf0 EFLAGS: 00010202
RAX: 0000001b34904000 RBX: ffffffff89ed2dd7 RCX: 0000001b34903ff8
RDX: 0000001b34524220 RSI: 0000000000000008 RDI: 00007f5e25f45720
RBP: 0000000000000078 R08: 00007f5e25400000 R09: 00007f5e25402000
R10: 0000000089ed2ddb R11: 0000000000000017 R12: 00007f5e25416128
R13: 0000000000000077 R14: ffffffff89ed2dd7 R15: 00007f5e25f45720
 </TASK>
INFO: task syz.2.260:7087 blocked in I/O wait for more than 145 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.260       state:D stack:27128 pid:7087  tgid:7087  ppid:5637   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
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
 generic_update_time fs/inode.c:2198 [inline]
 file_update_time_flags+0x46b/0x500 fs/inode.c:2428
 ext4_page_mkwrite+0x324/0x1890 fs/ext4/inode.c:6753
 do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 do_shared_fault mm/memory.c:5985 [inline]
 do_fault+0x3b5/0x1750 mm/memory.c:6047
 do_pte_missing mm/memory.c:4566 [inline]
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6565
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6734
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f095de65711
RSP: 002b:00007ffcba281b70 EFLAGS: 00010202
RAX: 0000001b34464000 RBX: 0000000000000000 RCX: 000000000003fde8
RDX: 0000001b34463fff RSI: 0000000000000008 RDI: 00007f095ed45720
RBP: 00007f095ed45720 R08: 0000000000000000 R09: 00007f095e216218
R10: 00007f095ed45700 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
 </TASK>
INFO: task syz.0.262:7095 blocked in I/O wait for more than 145 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.262       state:D stack:27384 pid:7095  tgid:7095  ppid:5638   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1295/0x67a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7283
 io_schedule+0x8a/0xf0 kernel/sched/core.c:8110
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
 generic_update_time fs/inode.c:2198 [inline]
 touch_atime+0x642/0x7a0 fs/inode.c:2273
 file_accessed include/linux/fs.h:2264 [inline]
 ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 vfs_mmap_prepare include/linux/fs.h:2076 [inline]
 call_mmap_prepare mm/vma.c:2672 [inline]
 __mmap_region+0xe98/0x2da0 mm/vma.c:2755
 mmap_region+0x527/0x620 mm/vma.c:2857
 do_mmap+0xc63/0x12f0 mm/mmap.c:560
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0x3cb/0x610 mm/mmap.c:606
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0x830 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f94ab39cbc2
RSP: 002b:00007ffda7897338 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 0000001b34264000 RCX: 00007f94ab39cbc2
RDX: 0000000000000003 RSI: 00000000003c0000 RDI: 0000001b34264000
RBP: 0000000000100001 R08: 0000000000000004 R09: 0000000000040000
R10: 0000000000100001 R11: 0000000000000206 R12: 000000000000003f
R13: 00000000000927c0 R14: 00000000000215f4 R15: 00007ffda7897610
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e7e5420 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e5420 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e5420 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3d/0x184 kernel/locking/lockdep.c:6775
6 locks held by kworker/u8:6/1008:
 #0: ffff888020af0940 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x12d6/0x1980 kernel/workqueue.c:3289
 #1: ffffc90005407d08 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x973/0x1980 kernel/workqueue.c:3290
 #2: ffff88802be4a0d8 (&type->s_umount_key#33){++++}-{4:4}, at: super_trylock_shared+0x1e/0xf0 fs/super.c:565
 #3: ffff88802be48c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x278/0x600 mm/page-writeback.c:2571
 #4: ffff88802bf7e938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
 #5: ffff888076429e30 (&ei->i_data_sem){++++}-{4:4}, at: ext4_map_blocks+0x45a/0xd30 fs/ext4/inode.c:823
2 locks held by getty/5386:
 #0: ffff8880334de0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x419/0x14f0 drivers/tty/n_tty.c:2211
3 locks held by syz-executor/5615:
 #0: ffff888034479448 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff88802be4a508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 #2: ffff88802bf7e938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.3.261/7085:
 #0: ffff88807f470e48 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff88802be4a508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 #2: ffff88802bf7e938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.2.260/7087:
 #0: ffff888079bb7588 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff88802be4a508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3684
 #2: ffff88802bf7e938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.0.262/7095:
 #0: ffff888036958f78 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #0: ffff888036958f78 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1f5/0x470 mm/util.c:579
 #1: ffff88802be4a410 (sb_writers#4){.+.+}-{0:0}, at: file_accessed include/linux/fs.h:2264 [inline]
 #1: ffff88802be4a410 (sb_writers#4){.+.+}-{0:0}, at: ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 #2: ffff88802bf7e938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
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
