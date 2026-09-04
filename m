Received: from mail-oo2-f3.google.com (mail-oo2-f3.google.com [74.125.231.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDF33EDE7A
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523469; cv=none; b=uPuxRAHWfb6exyEnm9ePNHc4hfUOb0VAPgRmrl9LL0AwWxKB7lzUIgCUOlLnBfhiNQPW1qlsXaAy05uz5hCIzdtLMOxN+ambbR0ZDKJhu6we7j3jhRX3+68McSrwHXgEEufPNgGXJhWTcWwlqjnvn0AxUgeL3qSmOcw+FwsJ0+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523469; c=relaxed/simple;
	bh=fPbUSObR6eZ/+Io4h3mYEmMLDZes6MDRBPVGwOK1S/c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bvRIwqfBlox0OhC3Wzqm+uFHXt4Ev0wD/SxMq7B822q7SQI3C314XwNMRMdL27to6388vruRDyl49xAVySaIuq35Vkk/NYPsM3tHK0k6yKn9vWRQhx5g8coA9F6zpcVY64EZlrAxA4cvzHPl6P6IE3bdQAy2qBwFWLhru3Ho7L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f3.google.com with SMTP id 006d021491bc7-6b35c65f4cdso303256eaf.0
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2026 05:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788523467; x=1789128267;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SupJpdwSLj9zgEkdQSeNPXRZOkTr8HuxtyuLc8U7ACc=;
        b=CKj4PXpFrnYGRWnYBs5r/5TmMlH+wKOU3r1HaguUhHkkyzEX/JKbRA9lSVbqKxmjvV
         3k0RmokG9b+7ThqMzjf2fZvz3BCS/Yd/1BVYSK+V6gq50EPoHXmeVadz7flWio2Ibp+6
         qznu2ih2DIZhxLUgDR0lX0Jk1qD3DHusPVozx8LJJ4x5Jo6HlQHOzBjKO1EmwbzyLj4U
         Quc5qFQyLLW9Pf2QcHH61fAmSC/zw1GYEje7wYG+9/smtOlmywIhaRJ3MdHHUxFaDQKb
         szL054Lzlre1jZaYD9Na10UAFPQ3NaL8iCnzX0tRGYxeahurZQNLzbteCx81xen9WHm0
         Ui0g==
X-Forwarded-Encrypted: i=1; AKwUvByWSKs4rX4TuYsOgrOCM8UZN++siJsGxxwSFBf5CFy3G702POuXJCz10gYTgmlTA2N7qws0PN/C+X0T@vger.kernel.org
X-Gm-Message-State: AFuF++kMuMZajZo6HrFg6+N+yPn1BuMlmUajF6r5t1E50+j+Yx/g/xMH
	PRbEvXWUqn8kDxHSxn/G9oau3dKSMxHL5foIryKRrXcQt9klGssxmtZnp/q/R3o/D+IH5kdEjfk
	z884aNXx6tOcgWjav55T8SXvZ8lTd6uz/kX7dUKk5saw5myVFkEX8AcIFDN8=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c0d4:10b0:6b7:83d6:293f with SMTP id
 006d021491bc7-6b783d6301dmr1065951eaf.66.1788523467122; Fri, 04 Sep 2026
 05:04:27 -0700 (PDT)
Date: Fri, 04 Sep 2026 05:04:27 -0700
In-Reply-To: <6a964b83.99c12218.408a8.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9ab3cb.9266084e.bf0d7.0668.GAE@google.com>
Subject: Re: [syzbot] [ext4?] general protection fault in __bh_submit
From: syzbot <syzbot+41453ea05ab61c075f1f@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pavankumaryalagada@gmail.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9d80aa4617b3 Add linux-next specific files for 20260903
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15fa38f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb4a32c282cc2ec7
dashboard link: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c228f9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fa38f9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/417a63e8ac61/disk-9d80aa46.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a1d004c189c1/vmlinux-9d80aa46.xz
kernel image: https://storage.googleapis.com/syzbot-assets/97413e5bd243/bzImage-9d80aa46.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/21b9bcefd2ef/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=100508f9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+41453ea05ab61c075f1f@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 4945 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 f6 e7 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 d4 e7 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000753f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b9a9a9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff8880739467a0
RBP: 0000000000009801 R08: ffff8880739467ff R09: 1ffff1100e728cff
R10: dffffc0000000000 R11: ffffed100e728d00 R12: dffffc0000000000
R13: ffff888073946780 R14: ffff888076b240e0 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa1d208708 CR3: 000000000eb48000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 jbd2_journal_commit_transaction+0x2285/0x5c80 fs/jbd2/commit.c:751
 kjournald2+0x3bc/0x740 fs/jbd2/journal.c:200
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 f6 e7 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 d4 e7 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000753f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b9a9a9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff8880739467a0
RBP: 0000000000009801 R08: ffff8880739467ff R09: 1ffff1100e728cff
R10: dffffc0000000000 R11: ffffed100e728d00 R12: dffffc0000000000
R13: ffff888073946780 R14: ffff888076b240e0 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa1d208708 CR3: 000000007f076000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   8:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   d:	74 08                	je     0x17
   f:	48 89 df             	mov    %rbx,%rdi
  12:	e8 f6 e7 d7 ff       	call   0xffd7e80d
  17:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 d4 e7 d7 ff       	call   0xffd7e80d
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	4c 89 fe             	mov    %r15,%rsi
  3f:	48                   	rex.W


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
