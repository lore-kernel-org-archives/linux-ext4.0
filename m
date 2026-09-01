Received: from mail-oi2-f4.google.com (mail-oi2-f4.google.com [74.125.231.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42E742AFA9
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2026 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234630; cv=none; b=mRO0wHmoUPHptj9Tsp9etbDol4Mw4XtLRtx9wRh49A10MJua0CZWVK8ztLEhOdYVByn2WDx1iguhxQH3XU97/BXA5Y8343h0T9FP57zmCmkwic2HSIkS/NcnWEsBpu09K8DA37Kgew1c2ypgQH5/WxR8PIa7g55PyUJz808pFxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234630; c=relaxed/simple;
	bh=UhhBBmsYaCyIEIJzLDRWRyvemnCGZ0bEXPo8Dqo/4Yw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=quvEh/T/3g7K8b9snJ/xxjXCtD6v8mV1ChqUWzGF8dNHhgo8O340rzlOBX4MKfivm2zGGDoUFICZzFz7wJlZ1VFUOycKiYXhBVgz5lGEaX9MoTDlK0a0E2AB4KTOZonhtd534QVCP46+lxtp5Hn1XD8ni9vUg1+tH9iJsipKOPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f4.google.com with SMTP id 5614622812f47-4ab2d72ff13so99508b6e.0
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 20:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788234627; x=1788839427;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c8uO371wBdFvG6jzSTVZVnGOXKAom2HgHpJv36cFlMY=;
        b=m78wtSDI2b6UJG6wnYgiipFLnwT7ffh+nx9cAmDVVHhTVGkIghuJrqfyDZgLUP03TN
         ifeygvmadJ+PPrIN1DG8pVNECaH3aYTqQTrzW2lZx6IIMFr3jPVfb0sNf7DmqNcdTfAZ
         Z0Nnny483HqXE45bXAjfl5VHyURqVH8NHSz6zItLdIsR5Q+3yOLBhtLmxeW2GW4wNp4s
         gV6g0J5ndFvjCxBVP3F2CQGqZhZHJpzby4Imc/YqgkK9g9dusLIYqWsJTmkagrW+4MFc
         02o5U2cYnKhl1tNHUWIiL5ifHed+g+oahibLK2vesdT7NR5at6H1Qq/IMzySK8v7sj7s
         1Gng==
X-Forwarded-Encrypted: i=1; AHgh+RrfAPKWj/dE5aAEYEUV0vc2wfqXXWU9zDD/Nenjxi+Fg5PqElJJi6y4MXZnnI4y7VIyLGimrUwgRbHS@vger.kernel.org
X-Gm-Message-State: AFuF++n4otGKJW1W3LoAUk88zmQCZ9UvO0Hz5aJ80JgYLz0DHbhPhzZM
	M1hGhW4WG/35iI3OEeP+7GNG1BJ39xBY+q+4BSYJm+ame1npnttCvaelWn5OQPojMZgD37iJ22p
	yLZr0B7ThhvlV8FLlLGa3TVHBIwf3hFZvUOw4aZ4esjLjcF+FlJg2L9Wudto=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220b:b0:4b3:63a7:b955 with SMTP id
 5614622812f47-4b397fa2c8dmr37057114b6e.7.1788234627728; Mon, 31 Aug 2026
 20:50:27 -0700 (PDT)
Date: Mon, 31 Aug 2026 20:50:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a964b83.99c12218.408a8.0001.GAE@google.com>
Subject: [syzbot] [ext4?] general protection fault in __bh_submit
From: syzbot <syzbot+41453ea05ab61c075f1f@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    89c07d98716a Add linux-next specific files for 20260831
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1540fe25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=32e7f0dfdb3435a4
dashboard link: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c81b79580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/43759091bf91/disk-89c07d98.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c556aacad9a/vmlinux-89c07d98.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa1ff3f317d0/bzImage-89c07d98.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+41453ea05ab61c075f1f@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 4943 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 56 d6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 34 d6 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000e64f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b9a0d9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075d24660
RBP: 0000000000009801 R08: ffff888075d246bf R09: 1ffff1100eba48d7
R10: dffffc0000000000 R11: ffffed100eba48d8 R12: dffffc0000000000
R13: ffff888075d24640 R14: ffff88807045fc40 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124866000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f10e87e8008 CR3: 00000000603f2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 jbd2_journal_commit_transaction+0x22a9/0x5cd0 fs/jbd2/commit.c:751
 kjournald2+0x3bc/0x750 fs/jbd2/journal.c:200
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 56 d6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 34 d6 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000e64f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b9a0d9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075d24660
RBP: 0000000000009801 R08: ffff888075d246bf R09: 1ffff1100eba48d7
R10: dffffc0000000000 R11: ffffed100eba48d8 R12: dffffc0000000000
R13: ffff888075d24640 R14: ffff88807045fc40 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124866000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f10e952312d CR3: 000000007ff14000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   8:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   d:	74 08                	je     0x17
   f:	48 89 df             	mov    %rbx,%rdi
  12:	e8 56 d6 d7 ff       	call   0xffd7d66d
  17:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 34 d6 d7 ff       	call   0xffd7d66d
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	4c 89 fe             	mov    %r15,%rsi
  3f:	48                   	rex.W


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
