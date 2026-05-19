Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F6351C1F
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2026 05:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779170064; cv=none; b=XqK7R9nqshGDJBapQ8p3q/i3pI3AdfREMXbJTq6eiPLBcMkTBVV8DCp0IcgzoIE2fz4u7K9fqyyDy607fgstah4em3P3fIMIPHZ0WR8J3nAmHe+PwUXlGVYSXLB0H0LBJ6OcA5RjeGeiny7lkZiposFpsxdJoteMl2rmkyunE6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779170064; c=relaxed/simple;
	bh=2WCdrXQLXVQTIuXe7pwtzfT1+rmOGcL383smRcy3OSA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HbtWv6bRM54l3uHvPXWQInNo56E02ctlyLDuV2M72Z7jv19HNjT7B0N54PnbvaKOLWtHyKZzEjUUIFWcXo4Q4j4orrew7/E0zpKY4+4q5dT8BDp6Nf6/lFArT93girQEz3zYncDQV3QPaOTXSUzj/UmzGV9GJpLMhy/tiw/F8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7dca6ecdd85so5163083a34.1
        for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 22:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779170062; x=1779774862;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UHkYbplKCeopozw8mgtVusCxwUiCczK3MpH2iNZEZtQ=;
        b=BSrRe+ghn5uqgthdXqB/oI5/Gl/2Mo27k2m3/spghOTIaXImUGh29PSHKbruv4xa0n
         Bo+F4bgGa1hFiLCU41qfML4tyeUgiUksS5GIM5cyzxXX57ln71kzmIMTpc1OOim0Q7un
         YU2NKBxcIlNOoLmMVVs0l++VlLLLen7/6x6VsEcV6HmJj8M4p9TDVJ1MqwW+lCHZyOrj
         kOTEO0Yc02o2Y/LoAndVuM/NtDS4q32yg67HWGpwPvEe0rggBLhLM95GnOWcVRskqES2
         w+rc+VhLX2rx1nbSuele9/mOcqbJziPARFUUTazhKChYkrpGHo0uUhovWSdHsn5wlhQY
         qpPQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HNXm0PbzjE5aTWrBxOdz44nBD633Amx4Hm8yUDiOZfBRzfwsZTGiEjSuma0lA2kktmL2AzaunWM34@vger.kernel.org
X-Gm-Message-State: AOJu0YxRIGnjngJKQERxamtl5ShO1skWbqYxvGBQBs9MtRcfMLy6AjjA
	DUZ32wtdT1b+6ZFBgTR+DSr7Kgrra7da9mGPM/3S8c/jXqW7/ktKns+xzz+dFzKPyAeM4DV0mdZ
	UZddn6NtztQEIXtlu7+XF1wL0OzV4Hfztp7fBzQVNIx36g7q0CQxfRXX2PCk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:98c:b0:699:b131:d5a2 with SMTP id
 006d021491bc7-69c942aea4fmr11053383eaf.5.1779170061853; Mon, 18 May 2026
 22:54:21 -0700 (PDT)
Date: Mon, 18 May 2026 22:54:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0bfb0d.050a0220.188d2a.0002.GAE@google.com>
Subject: [syzbot] [ext4?] possible deadlock in ext4_map_blocks (3)
From: syzbot <syzbot+1d62d734f435d85cc693@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    66182ca873a4 Merge tag 'net-7.1-rc4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10328d6a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=1d62d734f435d85cc693
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/04f707fb980e/disk-66182ca8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/88110d832473/vmlinux-66182ca8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fd09a1619478/bzImage-66182ca8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1d62d734f435d85cc693@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.4.1400/19208 is trying to acquire lock:
ffff888040b26cd0 (&ei->i_data_sem/2){++++}-{4:4}, at: ext4_map_blocks+0x7b5/0x11d0 fs/ext4/inode.c:823

but task is already holding lock:
ffff888040b231c0 (&ei->i_data_sem/2){++++}-{4:4}, at: ext4_map_blocks+0x7b5/0x11d0 fs/ext4/inode.c:823

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ei->i_data_sem/2);
  lock(&ei->i_data_sem/2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by syz.4.1400/19208:
 #0: ffff888025696480 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2724 [inline]
 #0: ffff888025696480 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22d/0xba0 fs/read_write.c:684
 #1: ffff888040b23360 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffff888040b23360 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: ext4_buffered_write_iter+0xa1/0x3a0 fs/ext4/file.c:311
 #2: ffff888040b231c0 (&ei->i_data_sem/2){++++}-{4:4}, at: ext4_map_blocks+0x7b5/0x11d0 fs/ext4/inode.c:823
 #3: ffffffff8e170dd8 (dquot_srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:187 [inline]
 #3: ffffffff8e170dd8 (dquot_srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:294 [inline]
 #3: ffffffff8e170dd8 (dquot_srcu){.+.+}-{0:0}, at: __dquot_alloc_space+0x18d/0xea0 fs/quota/dquot.c:1729
 #4: ffff888062ce2a98 (&dquot->dq_lock){+.+.}-{4:4}, at: dquot_commit+0x5e/0x450 fs/quota/dquot.c:533
 #5: ffff8880256961e8 (&s->s_dquot.dqio_sem){++++}-{4:4}, at: v2_write_dquot+0x9c/0x260 fs/quota/quota_v2.c:369

stack backtrace:
CPU: 1 UID: 0 PID: 19208 Comm: syz.4.1400 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
 ext4_map_blocks+0x7b5/0x11d0 fs/ext4/inode.c:823
 ext4_getblk+0x1ca/0x780 fs/ext4/inode.c:992
 ext4_bread+0x2a/0x180 fs/ext4/inode.c:1055
 ext4_quota_write+0x239/0x580 fs/ext4/super.c:7398
 qtree_write_dquot+0x25b/0x5e0 fs/quota/quota_tree.c:462
 v2_write_dquot+0x183/0x260 fs/quota/quota_v2.c:372
 dquot_commit+0x377/0x450 fs/quota/dquot.c:540
 ext4_write_dquot+0x20a/0x380 fs/ext4/super.c:7010
 mark_dquot_dirty fs/quota/dquot.c:398 [inline]
 mark_all_dquot_dirty+0x205/0x460 fs/quota/dquot.c:438
 __dquot_alloc_space+0x620/0xea0 fs/quota/dquot.c:1765
 dquot_alloc_space_nodirty include/linux/quotaops.h:292 [inline]
 dquot_alloc_space include/linux/quotaops.h:305 [inline]
 dquot_alloc_block include/linux/quotaops.h:329 [inline]
 ext4_mb_new_blocks+0xfb1/0x46d0 fs/ext4/mballoc.c:6276
 ext4_ext_map_blocks+0x1515/0x5860 fs/ext4/extents.c:4461
 ext4_map_create_blocks+0x11d/0x540 fs/ext4/inode.c:631
 ext4_map_blocks+0x7cd/0x11d0 fs/ext4/inode.c:824
 _ext4_get_block+0x1e3/0x470 fs/ext4/inode.c:924
 ext4_get_block_unwritten+0x2e/0x100 fs/ext4/inode.c:957
 ext4_block_write_begin+0xb14/0x1950 fs/ext4/inode.c:1211
 ext4_write_begin+0xb40/0x1890 fs/ext4/ext4_jbd2.h:-1
 ext4_da_write_begin+0x355/0xd60 fs/ext4/inode.c:3152
 generic_perform_write+0x2af/0x8b0 mm/filemap.c:4325
 ext4_buffered_write_iter+0xd0/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x299/0x1c10 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x629/0xba0 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x19c/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f50b506ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f50b32be028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f50b52e5fa0 RCX: 00007f50b506ce59
RDX: 0000000000000001 RSI: 0000200000000140 RDI: 0000000000000007
RBP: 00007f50b5102d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000008080c61 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f50b52e6038 R14: 00007f50b52e5fa0 R15: 00007fff20f29238
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
