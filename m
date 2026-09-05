Received: from mail-oa2-f9.google.com (mail-oa2-f9.google.com [74.125.231.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AAD446073
	for <linux-ext4@vger.kernel.org>; Sat,  5 Sep 2026 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788626130; cv=none; b=ofa6GfcVh3kA/uwM0QR0sG0EJI4KpURDLQOdTygPSxllbxPiCsnNgxZ8E8i8dQqUPS1DY3p06NfKTbiw57TJfEq7rZFwnQBS1YMwMFoGSFcYjd9T1QMof8HN9qgDbhPgkmcOxDjsgJcx/tlnB68hj/ExQyq48POFyuMj/SYLf44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788626130; c=relaxed/simple;
	bh=7ldFdUpdXshti50OTKWR6g3cXzXRtTzv126MEz8f9VU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LljalfHfd7O63Iu6JOwe1C5VxRxhAESVZzwLr2KvuIJTzNOzdHNWh0gs/3Ycd4wYGu4r7YouwhAG9q4Ig2lvMxLpbPyfccJ1qW0k0HtaAAkrypg9oWkI+/u8rNOz2p+o92lG0+iRLaxL0TEraC7h6psl/wUc17909rUN11th2CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f9.google.com with SMTP id 586e51a60fabf-4667f43a4ccso926154fac.0
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2026 09:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788626124; x=1789230924;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUIY8LF1P32AExNv+e/dvPQWZ9n0Hc0mLlb7GId3vG4=;
        b=hDwpwOIZ9GrOuXUGG98jncnFM7CK3C9WEqX2lzQA2Gl5CVm/laoL1SnrRwNJY+0NtO
         DVEx5/JSTiArX9WoILY0o7LM/Mliq7v7iQN4DGXSf8ickJ/6DW8PFzWZdb1Lau7gvuRk
         1XEuV33t1dmkieXVCfwxQcLLqwHTB+954zBu7tOdcp6jOzQ3s9SByvW/pavdf0/H8M4z
         +cT2rkGbtthhS+gfXimprbeQjjrIj2wRexdX0/dqHiAAb/LYgIwSAi4c0hI1NI8hPgrT
         jMEj3tQpfBF4cXrmnLTFReI2YpZKP81dRfnf1Cr3iJ9aEId7px+E52yCXyMiOcAOPNeM
         qd8w==
X-Forwarded-Encrypted: i=1; AKwUvBxOOqtD2az2swEX7n5xpkPYaxmtgwIPqWpdM0F3cdrQm1dYBc9JcwSO9urLiZdtNnUnH9vLuVAZaY9z@vger.kernel.org
X-Gm-Message-State: AFuF++m9BNhE6XF+d+6QQpTzBVWOzS+M5LuognPRxdFuGJtblMOWbEK4
	L7Pby8GbRvi5SaTBOR8BJKCol/mjOnTSBgc8kO72t8wL5QipX+8f8UfjKDnT1C0Q/SSXg0VCBo9
	jiUpPOFOnTDTaOTBFPbGYEM60RaP2GU0XowyBUs5SV5aQ96XZwemllEDZEkE=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d04:b0:6a0:f44b:1265 with SMTP id
 006d021491bc7-6b6fa8e0837mr8742483eaf.4.1788626124360; Sat, 05 Sep 2026
 09:35:24 -0700 (PDT)
Date: Sat, 05 Sep 2026 09:35:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9c44cc.0a3344eb.391530.000c.GAE@google.com>
Subject: [syzbot] [ext4?] linux-next test error: general protection fault in __bh_submit
From: syzbot <syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-next@vger.kernel.org, sfr@canb.auug.org.au, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    32b6ef9a5d0e Add linux-next specific files for 20260902
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14b44125580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=32ceed1c94c11059
dashboard link: https://syzkaller.appspot.com/bug?extid=5a7a23af225c215902e7
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9a1f38fb6f24/disk-32b6ef9a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3152eed43a4/vmlinux-32b6ef9a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e7fbd36e1b12/bzImage-32b6ef9a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 4945 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 26 f6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 04 f6 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9001016f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b96ff9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075a7a660
RBP: 0000000000009801 R08: ffff888075a7a6bf R09: 1ffff1100eb4f4d7
R10: dffffc0000000000 R11: ffffed100eb4f4d8 R12: dffffc0000000000
R13: ffff888075a7a640 R14: ffff8880123a17e0 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124ccb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe1ee627da0 CR3: 0000000074fa8000 CR4: 00000000003526f0
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
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 26 f6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 04 f6 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9001016f868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b96ff9
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075a7a660
RBP: 0000000000009801 R08: ffff888075a7a6bf R09: 1ffff1100eb4f4d7
R10: dffffc0000000000 R11: ffffed100eb4f4d8 R12: dffffc0000000000
R13: ffff888075a7a640 R14: ffff8880123a17e0 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff888124dcb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f87c696cf80 CR3: 000000000eb48000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   8:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   d:	74 08                	je     0x17
   f:	48 89 df             	mov    %rbx,%rdi
  12:	e8 26 f6 d7 ff       	call   0xffd7f63d
  17:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 04 f6 d7 ff       	call   0xffd7f63d
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
