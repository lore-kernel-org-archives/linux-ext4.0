Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53BD305680
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785774611; cv=none; b=Ph1NzdIuKgWsrI/EG1JXBaPlaImwVhU9NpjrfYHJwiCXCaQCx4P38cAw0rW7IqFXWi7iKtp14X2J14JgUA3A5gBeTwV5xD3qu8tS8qprnTsrG7WX0+OGpKiiB48o9DLxExvV+9wMl5SZnIWkGM7+A0z6TwEO6qouTE7q5sBgff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785774611; c=relaxed/simple;
	bh=+7pzADnKLNtv2pra3Vbz+yFi8qUQoT5saG+bf3CbnZE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=V53uyHoJZ1ee14ldwNTro6I+Ce2kNGZZ0AwCYbkDNXiSLathX6m8wUKvizB4faLke+A1qeGds1YZUau+AeBYLsVUHGbKQVZW1nHMaMS0YjiedLtOpcDVrzsp1NW84H0AUIc+jH0NZWqcx7xA8deIm4iHW5XNZ6EN6RDpumGn994=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7eb60cfd476so2590896a34.3
        for <linux-ext4@vger.kernel.org>; Mon, 03 Aug 2026 09:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785774608; x=1786379408;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oOeDRPvcR7w5w8w4/kKfhsXYC5m3ML3m7cV7+8f8wM8=;
        b=Humer3waCpA4VIx4fYjFvpLYrnUujch1J8TZ4HZRHL/Fw4pb9GvIuim/KFOc5X6MH7
         m6haKTg7Il7fcuNzeJJ8rO/FOPn96+5TCBbfmxiijWEqgy1m4SyCPVRWwn0WSA7chy0c
         gtNYhNV6SB/9xVap3glJccQRDvhpQef/19q9WK8bp+WRMFBF0hhjuaf3paQzRc8nOc3j
         EXdqCq/vs9WyGgsSMhW5rh72Y4fsCwMtnryb4AUAeGQ2cGdROi6x1sUSW0qKZaSrwBIL
         d35JLGtZuI4VQeFGlHlikdGA4EKVmj+UDNkPPr1WHd+MC6VuSgEMyZzwz4f2F3uKVcOj
         sBkQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro7D4RiPhA8ZHHEiS6ueKblxMjD7/G6r4wXROKuHbMnDy/F6P2B8bxehEHHqF1qt7X6NBsHt+5OQzaM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9xd+FmuAldm4Y3oR7WAquN1xif1OTpBX0PvBRIvGANfxtGPgK
	oUCkYKbBtogjeDuBn5e1Ul7PYRR1x4wOYymqKiy6ExARyJYhqxqu19Gt4pUxQavegRB5y4mS2dy
	HiFFkJfgEVn3RYVxVcTI78oeYolsXroH9tKMU0861oQgPrrtTVi/Sp8any/g=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:bce:b0:4a4:2424:eb1a with SMTP id
 5614622812f47-4af5e0d2d04mr15584238b6e.9.1785774608545; Mon, 03 Aug 2026
 09:30:08 -0700 (PDT)
Date: Mon, 03 Aug 2026 09:30:08 -0700
In-Reply-To: <tencent_815048083723E7EA4309DA0B7DA35B78D106@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a70c210.f794c993.27aeb.0033.GAE@google.com>
Subject: [syzbot ci] Re: jbd2:remove unnecessary finish_wait call in jbd2_journal_wait_updates
From: syzbot ci <syzbot+ci407e981f13443dd3@syzkaller.appspotmail.com>
To: 1289151713@qq.com, linux-ext4@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] jbd2:remove unnecessary finish_wait call in jbd2_journal_wait_updates
https://lore.kernel.org/all/tencent_815048083723E7EA4309DA0B7DA35B78D106@qq.com
* [PATCH] jbd2:remove unnecessary finish_wait call in jbd2_journal_wait_updates

and found the following issue:
INFO: task hung in start_this_handle

Full report is available here:
https://ci.syzbot.org/series/73998915-3df1-4ace-8b1c-a5696f54030a

***

INFO: task hung in start_this_handle

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      075b74841bd0065a3bda3440873c747938e69b68
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a996e3f8-10dc-4864-a50b-8ec9751a77fa/config
syz repro: https://ci.syzbot.org/findings/189b0cba-cb40-4fb0-8fe5-1fb8f8edbabf/syz_repro

INFO: task syz.0.17:5845 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:19240 pid:5845  tgid:5844  ppid:5752   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 wait_transaction_locked+0x1d6/0x280 fs/jbd2/transaction.c:152
 add_transaction_credits fs/jbd2/transaction.c:-1 [inline]
 start_this_handle+0x7ea/0x2210 fs/jbd2/transaction.c:403
 jbd2__journal_start+0x2c0/0x5c0 fs/jbd2/transaction.c:502
 jbd2_journal_start+0x2a/0x40 fs/jbd2/transaction.c:541
 ocfs2_start_trans+0x3b7/0x700 fs/ocfs2/journal.c:371
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 dio_complete+0x251/0x760 fs/direct-io.c:281
 __blockdev_direct_IO+0x2ce1/0x3380 fs/direct-io.c:1296
 ocfs2_direct_IO+0x249/0x2c0 fs/ocfs2/aops.c:2460
 generic_file_direct_write+0x1d0/0x3f0 mm/filemap.c:4292
 __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4461
 ocfs2_file_write_iter+0x1706/0x1f10 fs/ocfs2/file.c:2481
 iter_file_splice_write+0xa31/0x1240 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x57b/0xcb0 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
 __do_sys_sendfile64 fs/read_write.c:1432 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f281339e019
RSP: 002b:00007f281419a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f2813625fa0 RCX: 00007f281339e019
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000004
RBP: 00007f281343500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020fffe82 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2813626038 R14: 00007f2813625fa0 R15: 00007ffd9d864f08
 </TASK>
INFO: task jbd2/loop0-75:5849 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:jbd2/loop0-75   state:D stack:26992 pid:5849  tgid:5849  ppid:2      task_flags:0x240040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 jbd2_journal_wait_updates+0x1a3/0x280 fs/jbd2/transaction.c:841
 jbd2_journal_commit_transaction+0x93c/0x5b70 fs/jbd2/commit.c:482
 kjournald2+0x3bc/0x750 fs/jbd2/journal.c:199
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/35:
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8eb59c60 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5438:
 #0: ffff888113f2b0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900034732e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
5 locks held by syz.0.17/5845:
 #0: ffff8881be206450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff8881b1044fa0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff8881b1044fa0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff8881b1044c58 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff8881b1044c58 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff8881be206640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff8881be206640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff8881a51ab0e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.1.27/5936:
 #0: ffff8881bdd42450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff8881b8bb79a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff8881b8bb79a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff8881b8bd4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff8881b8bd4fa0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_lookup_lock_orphan_dir+0xec/0x2e0 fs/ocfs2/namei.c:2129
 #3: ffff8881bdd42640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_add_inode_to_orphan+0x22b/0x7c0 fs/ocfs2/namei.c:2680
 #4: ffff8881bdd0ece0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.2.28/5938:
 #0: ffff88811152c450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff888120e741a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff888120e741a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff888120e73e58 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff888120e73e58 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff88811152c640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff88811152c640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff8881159438e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.3.29/5981:
 #0: ffff888104af8450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff88801c8917a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff88801c8917a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff888120db5da0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff888120db5da0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_del_inode_from_orphan+0x12e/0x7b0 fs/ocfs2/namei.c:2728
 #3: ffff888104af8640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_del_inode_from_orphan+0x16c/0x7b0 fs/ocfs2/namei.c:2737
 #4: ffff888110b7f8e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.5.31/6074:
 #0: ffff88801c03e450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff888120db41a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff888120db41a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff888120db3e58 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff888120db3e58 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff88801c03e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff88801c03e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff888115943ce0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.4.32/6079:
 #0: ffff888172ede450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff8881b1045da0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff8881b1045da0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff8881b10417a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff8881b10417a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_del_inode_from_orphan+0x12e/0x7b0 fs/ocfs2/namei.c:2728
 #3: ffff888172ede640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_del_inode_from_orphan+0x16c/0x7b0 fs/ocfs2/namei.c:2737
 #4: ffff88816d09cce0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.6.33/6125:
 #0: ffff8881bc03e450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff88801c8ab3a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff88801c8ab3a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff88801c8ab058 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff88801c8ab058 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff8881bc03e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff8881bc03e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff8881bd7454e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.7.36/6223:
 #0: ffff888168f9e450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff8881a20217a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff8881a20217a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff8881a2021458 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff8881a2021458 (&oi->ip_alloc_sem){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff888168f9e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff888168f9e640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff8881be92f0e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.8.38/6233:
 #0: ffff88801e146450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff888120ecdda0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff888120ecdda0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff88801c8925a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88801c8925a0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at: ocfs2_del_inode_from_orphan+0x12e/0x7b0 fs/ocfs2/namei.c:2728
 #3: ffff88801e146640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_del_inode_from_orphan+0x16c/0x7b0 fs/ocfs2/namei.c:2737
 #4: ffff8881155170e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
5 locks held by syz.9.40/6285:
 #0: ffff888116eba450 (sb_writers#12){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x160 fs/splice.c:1158
 #1: ffff88801c8aa5a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff88801c8aa5a0 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: ocfs2_file_write_iter+0x440/0x1f10 fs/ocfs2/file.c:2411
 #2: ffff88801c8aa258 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2299 [inline]
 #2: ffff88801c8aa258 (&ocfs2_file_ip_alloc_sem_key){++++}-{4:4}, at: ocfs2_dio_end_io+0x441/0x13c0 fs/ocfs2/aops.c:2423
 #3: ffff888116eba640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io_write fs/ocfs2/aops.c:2357 [inline]
 #3: ffff888116eba640 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_dio_end_io+0xb55/0x13c0 fs/ocfs2/aops.c:2423
 #4: ffff88801b9554e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
3 locks held by syz.2.306/6936:
2 locks held by syz.0.305/6938:
2 locks held by syz.1.307/6940:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6940 Comm: syz.1.307 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__lock_acquire+0x56/0x2cf0 kernel/locking/lockdep.c:5098
Code: 3d ee 07 b5 0e 00 0f 84 6e 13 00 00 49 89 fb 48 8b 07 48 3d 20 15 31 94 0f 84 5c 13 00 00 41 89 cd 41 89 d2 8b 0d 8a b4 ff 0c <85> c9 44 0f 44 c1 31 ff 48 3d 10 15 31 94 41 0f 45 f8 8b 0d f2 dc
RSP: 0018:ffffc90000a08be0 EFLAGS: 00000087
RAX: ffff8881210281d8 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88823c6281d8
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: ffff88823c6281d8 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88816bf63b80 R15: 0000000000000046
FS:  00007f58059476c0(0000) GS:ffff8882a8f4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f57fc9ff000 CR3: 000000016d1f6000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock_irq+0x3d/0x50 kernel/locking/spinlock.c:174
 __run_hrtimer kernel/time/hrtimer.c:2036 [inline]
 __hrtimer_run_queues+0x466/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:arch_atomic_sub_and_test arch/x86/include/asm/atomic.h:47 [inline]
RIP: 0010:raw_atomic_sub_and_test include/linux/atomic/atomic-arch-fallback.h:2258 [inline]
RIP: 0010:atomic_sub_and_test include/linux/atomic/atomic-instrumented.h:1366 [inline]
RIP: 0010:page_ref_sub_and_test include/linux/page_ref.h:195 [inline]
RIP: 0010:folio_ref_sub_and_test include/linux/page_ref.h:204 [inline]
RIP: 0010:folios_put_refs+0x28b/0xb30 mm/swap.c:1029
Code: 00 e8 49 31 bc ff e9 dc 03 00 00 e8 3f 31 bc ff e9 d2 03 00 00 49 8d 7d 34 be 04 00 00 00 e8 ec cc 29 00 31 db f0 45 29 65 34 <41> 0f 94 c4 0f 94 c3 bf 02 00 00 00 89 de e8 12 34 bc ff 31 ff 89
RSP: 0018:ffffc900075674e0 EFLAGS: 00000202
RAX: ffffffff820ae301 RBX: 0000000000000000 RCX: ffffffff820ae3b4
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffea00066d18f4
RBP: ffffc900075675f0 R08: ffffea00066d18f7 R09: 1ffffd4000cda31e
R10: dffffc0000000000 R11: fffff94000cda31f R12: 0000000000000001
R13: ffffea00066d18c0 R14: 1ffffd4000cda318 R15: 0200000000000000
 folios_put include/linux/mm.h:2183 [inline]
 folio_batch_move_lru+0x908/0xa60 mm/swap.c:214
 __folio_batch_add_and_move+0x510/0xc50 mm/swap.c:231
 shmem_alloc_and_add_folio+0xcc2/0xf60 mm/shmem.c:2018
 shmem_get_folio_gfp+0x5da/0x16d0 mm/shmem.c:2512
 shmem_get_folio mm/shmem.c:2618 [inline]
 shmem_write_begin+0x16c/0x330 mm/shmem.c:3249
 generic_perform_write+0x2d5/0x8f0 mm/filemap.c:4358
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3424
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f580495e84e
Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
RSP: 002b:00007f5805946da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f58059476c0 RCX: 00007f580495e84e
RDX: 0000000001000000 RSI: 00007f57fba00000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007f5805946ee0 R14: 00007f5805946ea0 R15: 00007f57fba00000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
