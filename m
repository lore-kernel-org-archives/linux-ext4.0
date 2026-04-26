Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620572F39C7
	for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2026 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777238310; cv=none; b=pDd3z/PceBC2UsdJgHBbw22eYGacBhHwtZ4Y1WVRR+PMkkctT1xnRt0MxLtlvqKFacqI8ww3FpCurR4DqCIUtJIS9LV8Si8xk76JpyzWdfEEGi5RsQAel7RlGmBJZ3delMET+DUBGZ87ZO1SFxU13xixX0u26vcuoVv5aJXjWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777238310; c=relaxed/simple;
	bh=Q+gw/1KFdgX/E/Ofdk68AVFDrDMppizub1NBy5OtBDs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RL7t4rSQaaYumFLKfrcNs4gZ9RsFczvPSAsY2Ih5N0d42ZzSxiA+g6CBpEajs4FXEgcjGO8gY0i6jzIsWl60eGmwDyhaZjuzHmMr0dEhIUcIN8NePArQGl42qwZB8WmG5JoIZlEhS+MniAQyLGzaMv9IuloqYCjjEpU7zhMNteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7dbd60b7ecbso19512340a34.1
        for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2026 14:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777238308; x=1777843108;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=94k/1Ss9fpvg6ryXUn00EOh1/+r0EKV7MciQNFc6mRE=;
        b=szdzkHh27OO/iU3qm0hDsu/kDL0AJmRmCCZ1cgIMZeaXYam/AWKJbVkOldfNIsVVv0
         +SRMEyZfqLvSFnlfTrQiyaZ2/L2pdK0MRsmzmCaeISlZ+3r6AzvuXaQdMHwzlp214fvT
         9bzdLwNiWIrY3HK5BtMRnfXyakAWZ6+BEI+gjxw17QKep4rJzpQ8ov79eZ/6h8uKk2/z
         aBDi67I/wY7GetNH0y4X0ok5mLQpXYxoJluhX65DydZTzzKJRinUR1n4XLq1jSOYrV3v
         IdORRzMuvsL7lBYrDJS0y6N1KF3bYbAyA1pgyr11GZnpRmlDK/MHA5k1CDbjODUN70Lz
         YNvg==
X-Forwarded-Encrypted: i=1; AFNElJ/aQE+CCDk5/MEpmAhSiDk2wgrvi+gNBq9IcHCKBoJg/aINBDOj15mbJ8nAN6gg5/RM0L+q1lvz25DX@vger.kernel.org
X-Gm-Message-State: AOJu0YzXNhpmH4pD/aUobRqtZM+jbLZ/AFSFOedw6S9bw+QCAXJnNyKr
	jlf1i6g24RBOL4z59vQQdp6SaCxnU2Q0pTQ9eiVLCgcFMp+SqabLSCQUBtVagI8Ef+bORt0f2cC
	WZIHBrxg+lBhlQHgAlRjREMCHTyGlEZKm2o7CgH5e0NQCmqcKwoy1SvH4I8c=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c90:b0:688:6d55:195 with SMTP id
 006d021491bc7-69462f2f14fmr24547672eaf.57.1777238308293; Sun, 26 Apr 2026
 14:18:28 -0700 (PDT)
Date: Sun, 26 Apr 2026 14:18:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ee8124.170a0220.11de9.0012.GAE@google.com>
Subject: [syzbot] [ext4?] BUG: sleeping function called from invalid context
 in jbd2_journal_commit_transaction
From: syzbot <syzbot+06294fd562f060379c91@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120d3702580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=80b28e8d6ef9384a
dashboard link: https://syzkaller.appspot.com/bug?extid=06294fd562f060379c91
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5b2b3122db47/disk-6596a02b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ee12b37f6e5/vmlinux-6596a02b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aca25073993c/bzImage-6596a02b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+06294fd562f060379c91@syzkaller.appspotmail.com

BUG: sleeping function ca[   92.150581][ T5155] BUG: sleeping function called from invalid context at fs/jbd2/commit.c:1071
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5155, name: jbd2/sda1-8
preempt_count: 0, expected: 0
RCU nest depth: 2, expected: 1
3 locks held by jbd2/sda1-8/5155:
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: __rt_spin_lock kernel/locking/spinlock_rt.c:50 [inline]
 #0: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1e0/0x400 kernel/locking/spinlock_rt.c:57
 #1: ffff888036ea4920 (&journal->j_list_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #1: ffff888036ea4920 (&journal->j_list_lock){+.+.}-{3:3}, at: jbd2_journal_commit_transaction+0x3ad1/0x5b20 fs/jbd2/commit.c:993
 #2: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #2: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #2: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: __rt_spin_lock kernel/locking/spinlock_rt.c:50 [inline]
 #2: ffffffff8dfc80c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1e0/0x400 kernel/locking/spinlock_rt.c:57
CPU: 0 UID: 0 PID: 5155 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x329/0x480 kernel/sched/core.c:9162
 jbd2_journal_commit_transaction+0x3f59/0x5b20 fs/jbd2/commit.c:1071
 kjournald2+0x3e0/0x760 fs/jbd2/journal.c:201
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332, CPU#0: jbd2/sda1-8/5155
Modules linked in:
CPU: 0 UID: 0 PID: 5155 Comm: jbd2/sda1-8 Tainted: G        W           syzkaller #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:rcu_note_context_switch+0xcac/0xf40 kernel/rcu/tree_plugin.h:332
Code: 00 41 c6 45 00 00 48 8b 3d a1 20 e1 0d 48 81 c4 b8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 bb 5f ff ff 48 8d 3d a4 e2 e4 0d <67> 48 0f b9 3a e9 1b f4 ff ff 90 0f 0b 90 45 84 e4 0f 84 ea f3 ff
RSP: 0018:ffffc90010177930 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff888036ec5c40 RCX: 0000000080000002
RDX: 0000000000000000 RSI: ffffffff8ba74040 RDI: ffffffff8f8f3dd0
RBP: dffffc0000000000 R08: ffffffff8f8bcef7 R09: 1ffffffff1f179de
R10: dffffc0000000000 R11: fffffbfff1f179df R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880b883c800 R15: ffff888036ec6104
FS:  0000000000000000(0000) GS:ffff8881260fb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557df50340 CR3: 0000000011b24000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __schedule+0x291/0x54c0 kernel/sched/core.c:7043
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7282
 kjournald2+0x410/0x760 fs/jbd2/journal.c:230
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 41 c6             	add    %al,-0x3a(%rcx)
   3:	45 00 00             	add    %r8b,(%r8)
   6:	48 8b 3d a1 20 e1 0d 	mov    0xde120a1(%rip),%rdi        # 0xde120ae
   d:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  14:	5b                   	pop    %rbx
  15:	41 5c                	pop    %r12
  17:	41 5d                	pop    %r13
  19:	41 5e                	pop    %r14
  1b:	41 5f                	pop    %r15
  1d:	5d                   	pop    %rbp
  1e:	e9 bb 5f ff ff       	jmp    0xffff5fde
  23:	48 8d 3d a4 e2 e4 0d 	lea    0xde4e2a4(%rip),%rdi        # 0xde4e2ce
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 1b f4 ff ff       	jmp    0xfffff44f
  34:	90                   	nop
  35:	0f 0b                	ud2
  37:	90                   	nop
  38:	45 84 e4             	test   %r12b,%r12b
  3b:	0f                   	.byte 0xf
  3c:	84 ea                	test   %ch,%dl
  3e:	f3                   	repz
  3f:	ff                   	.byte 0xff


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
