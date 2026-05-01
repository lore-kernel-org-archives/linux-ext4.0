Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601462A1AA
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2026 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777594728; cv=none; b=aS2toZfDVAVakZ4tCriQ5SU9JhikUzmfG5fzhROwow5HblKY7mdZDLr8u1Ch2ZyMN+AWebdfHEKMseUPAsedKTCOvj15jFKZnh+oYzB5bUyMUDqoyxG33CvWr+Z7YCpeKrcrtL682wmauqrqUkrIaF1dxbPJqVhWfiOlDb6SDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777594728; c=relaxed/simple;
	bh=LIqLdQ+lt/oAjzOpLRsIxOHKCtanQGwr36lxb312kjg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=R5rKiEKl6nSkrADaMB9wPlnSQ4XZrKmOiP8q2DoZlmdo0Vn/WVFD6xmJ6UozSOv54KdlCo51RrhjU/TzikDIlZaPJT5/gtiwQMSDNi9daUUN6L3YKpy4snmiW0y946FBqarfMQf3ZWlv1hXAjKb4WUH6Yu589xF8GYZ4XEzBPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7dbc09d4e43so3899694a34.1
        for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2026 17:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777594725; x=1778199525;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ao7kzclg7hdYHDKtCtSG3UcRNMsl5IlpceJU6iQoAm8=;
        b=nbgVmSiF8Vg21XWQPxT5b2EeOoTyI0gy2XLkkvhLGfiJhmT3oXJBo7o1MdPW9qY1kB
         XOKLVI1dfddNOGCgnE0mz4l6NuHGV9iuF2ny0bKVkL768Ddn8RhE7sZCALIFYGRs7UQV
         ZPJjqdJQkZkLiSki7rEnxoG/BD15uXSrADxJQTqOk+Da2CzGkhLIQgI3+Kjsfk1jdfom
         bWRAA5e/XJKRK93KGvHOe7RnbOCGyQV8X9Xm200AzybFyUKWaPFd95GURL8P0nGkvoPi
         N7NwsCP91AjwLqjM9vHLBz6G/qT352ognla8iBC4dzai7zXze+Gzd0wCAvP0nzi4GbZi
         mdWw==
X-Forwarded-Encrypted: i=1; AFNElJ/Q25CmwGX7yAYsOqKj2CIqvk0t1TRHxLmAVw/BwdB9rws5KK03vOUh8pBNAwwTj4OMGJTX4BH34wjY@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgu2d5yz3xcB0GayEL60ny1kRxv5/vbUeZJyvZN7eruu2zU+UF
	gij/VScwdDCMuKRgazd/h60+mov8WhhFcMrTGP5lyKSs/bHL/e5WwNReXl70jtWNvqrOL36dCKu
	qMB5J/OZORffElU8yu8iA+ppjZ/zM+sEM38nKywfVxVUBUtvGmU1jKNLwV0M=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f096:b0:696:89a4:1130 with SMTP id
 006d021491bc7-69689a418ccmr467677eaf.7.1777594725454; Thu, 30 Apr 2026
 17:18:45 -0700 (PDT)
Date: Thu, 30 Apr 2026 17:18:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f3f165.170a0220.5f1b.0010.GAE@google.com>
Subject: [syzbot] INFO: task jbd2/sda1-NUM:NUM blocked in I/O wait for more
 than NUM seconds.
From: syzbot <syzbot+c7604c9fdd7580cca4e0@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dd6c438c3e64 Merge tag 'vfs-7.1-rc1.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128692d2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf32d14ab63e8442
dashboard link: https://syzkaller.appspot.com/bug?extid=c7604c9fdd7580cca4e0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8b40cfa7daf/disk-dd6c438c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/50e3a472008e/vmlinux-dd6c438c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dee724704545/bzImage-dd6c438c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c7604c9fdd7580cca4e0@syzkaller.appspotmail.com

INFO: task jbd2/sda1-8:5176 blocked in I/O wait for more than 143 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:jbd2/sda1-8     state:D stack:26072 pid:5176  tgid:5176  ppid:2      task_flags:0x240040 flags:0x00080000
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
INFO: task syz-executor:5832 blocked in I/O wait for more than 143 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:22688 pid:5832  tgid:5832  ppid:5831   task_flags:0x440100 flags:0x00080000
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
 wp_page_shared mm/memory.c:4069 [inline]
 do_wp_page+0xa77/0x4350 mm/memory.c:4288
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x1ab6/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fa035d6eec0
RSP: 002b:00007ffc588679c8 EFLAGS: 00010246
RAX: 00007fa02f7e2ffc RBX: 00007ffc58867b70 RCX: 0000000000000000
RDX: 0000000000000010 RSI: 0000000000000000 RDI: 00007fa02f7e2ffc
RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000000
R10: 00007fa02f40021c R11: 000000000000000e R12: 000000000001cff4
R13: 000000000001cfda R14: 0000000000000010 R15: 00007ffc58867b70
 </TASK>
INFO: task syz.0.297:7190 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.297       state:D stack:27128 pid:7190  tgid:7190  ppid:5849   task_flags:0x440040 flags:0x00080002
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
RIP: 0033:0x7f4957e70f40
RSP: 002b:00007fffdf4618d0 EFLAGS: 00010202
RAX: 0000001b31ef5000 RBX: ffffffff82568f11 RCX: 0000001b31ef4ff8
RDX: 0000001b31b24220 RSI: 0000000000000008 RDI: 00007f4958d45720
RBP: 00000000000001a6 R08: 00007f4958200000 R09: 00007f4958202000
R10: 0000000082568f15 R11: 0000000000000010 R12: 00007f4958216038
R13: 00000000000002e8 R14: ffffffff825688e4 R15: 00007f4958d45720
 </TASK>
INFO: task syz.1.299:7195 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.299       state:D stack:27384 pid:7195  tgid:7195  ppid:5843   task_flags:0x440040 flags:0x00080002
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
 touch_atime+0x642/0x7a0 fs/inode.c:2267
 file_accessed include/linux/fs.h:2264 [inline]
 ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 vfs_mmap_prepare include/linux/fs.h:2076 [inline]
 call_mmap_prepare mm/vma.c:2672 [inline]
 __mmap_region+0xe98/0x2da0 mm/vma.c:2755
 mmap_region+0x527/0x620 mm/vma.c:2856
 do_mmap+0xc63/0x12f0 mm/mmap.c:560
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0x3cb/0x610 mm/mmap.c:606
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8e3d39c582
RSP: 002b:00007fffab0ea828 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 0000001b31c64000 RCX: 00007f8e3d39c582
RDX: 0000000000000003 RSI: 00000000003c0000 RDI: 0000001b31c64000
RBP: 0000000000100001 R08: 0000000000000004 R09: 0000000000040000
R10: 0000000000100001 R11: 0000000000000206 R12: 0000000000000047
R13: 00000000000927c0 R14: 000000000002f9d5 R15: 00007fffab0eab00
 </TASK>
INFO: task syz.2.298:7196 blocked in I/O wait for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.298       state:D stack:27384 pid:7196  tgid:7196  ppid:5853   task_flags:0x440040 flags:0x00080002
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
 touch_atime+0x642/0x7a0 fs/inode.c:2267
 file_accessed include/linux/fs.h:2264 [inline]
 ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 vfs_mmap_prepare include/linux/fs.h:2076 [inline]
 call_mmap_prepare mm/vma.c:2672 [inline]
 __mmap_region+0xe98/0x2da0 mm/vma.c:2755
 mmap_region+0x527/0x620 mm/vma.c:2856
 do_mmap+0xc63/0x12f0 mm/mmap.c:560
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0x3cb/0x610 mm/mmap.c:606
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6eda39c582
RSP: 002b:00007ffc7d052448 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 0000001b31d64000 RCX: 00007f6eda39c582
RDX: 0000000000000003 RSI: 00000000003c0000 RDI: 0000001b31d64000
RBP: 0000000000100001 R08: 0000000000000004 R09: 0000000000040000
R10: 0000000000100001 R11: 0000000000000206 R12: 0000000000000048
R13: 00000000000927c0 R14: 000000000002fd0a R15: 00007ffc7d052720
 </TASK>

Showing all locks held in the system:
6 locks held by kworker/u8:1/13:
 #0: ffff888020e8a940 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x12d6/0x1980 kernel/workqueue.c:3277
 #1: ffffc90000127d08 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x973/0x1980 kernel/workqueue.c:3278
 #2: ffff88803313a0d8 (&type->s_umount_key#33){++++}-{4:4}, at: super_trylock_shared+0x1e/0xf0 fs/super.c:565
 #3: ffff888033138c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x278/0x600 mm/page-writeback.c:2575
 #4: ffff8880330b6938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
 #5: ffff88807a935fd0 (&ei->i_data_sem){++++}-{4:4}, at: ext4_map_blocks+0x45a/0xd30 fs/ext4/inode.c:823
1 lock held by khungtaskd/31:
 #0: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3d/0x184 kernel/locking/lockdep.c:6775
2 locks held by getty/5602:
 #0: ffff888038d560a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000322b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x419/0x14f0 drivers/tty/n_tty.c:2211
3 locks held by syz-executor/5832:
 #0: ffff888037e99448 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff88803313a508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3668
 #2: ffff8880330b6938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.0.297/7190:
 #0: ffff8880565b7948 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310
 #1: ffff88803313a508 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x440 mm/memory.c:3668
 #2: ffff8880330b6938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.1.299/7195:
 #0: ffff888028438f78 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #0: ffff888028438f78 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1f5/0x470 mm/util.c:579
 #1: ffff88803313a410 (sb_writers#4){.+.+}-{0:0}, at: file_accessed include/linux/fs.h:2264 [inline]
 #1: ffff88803313a410 (sb_writers#4){.+.+}-{0:0}, at: ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 #2: ffff8880330b6938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
3 locks held by syz.2.298/7196:
 #0: ffff888028438338 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #0: ffff888028438338 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1f5/0x470 mm/util.c:579
 #1: ffff88803313a410 (sb_writers#4){.+.+}-{0:0}, at: file_accessed include/linux/fs.h:2264 [inline]
 #1: ffff88803313a410 (sb_writers#4){.+.+}-{0:0}, at: ext4_file_mmap_prepare+0x56d/0x670 fs/ext4/file.c:840
 #2: ffff8880330b6938 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Tainted: G             L      syzkaller #0 PREEMPT(full) 
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
