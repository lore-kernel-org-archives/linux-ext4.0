Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675AA36A01A
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2026 03:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779335673; cv=none; b=sK7gAeM1U8wNnZlwN3oogrguZW0XdsLrwoDI7L7MwZFMNLdrneNahT7510luxb+49Rh23lnfEKT4yBLBbW9mHaJfmplFMR2mGcgPZLI7jQynEUymwNCVnRO6X7WpecslxfdtlSk8+n7MHJ/Rm6pIKtt7UcOMmouiZfj2c2C1wro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779335673; c=relaxed/simple;
	bh=VHp1Lximo9KblQfwcOulwwoTEBMaFIBE0gphJZTM61g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XJHiktYaoKQQkEMGLXlcJ4h/ZvEi/zUsm4L+kqqLAWNWYNjiURZhU5dtwjOZqEj3k2O30MFSdGQx1OZ8Nz8kaGViC4HVZRlUYK/NdtarPAvpUY+hirQ3143HhuD7ZJ4bQ4v2uMxo7hZSsTMI7Y/oCBzM6dLWBWkQjHpDe4uikxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-679c5ed0942so10879730eaf.1
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 20:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779335670; x=1779940470;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LJzWxU5HwIwKulug+XUtwahdRBoxkSCgeN8FtBwRh9Q=;
        b=ZnVw5luOBUPswIR0mTKJZxLuvcvMZc4JlM/P4gYs7hzAc4d9q80n1rU/GR1SNDhuxd
         hjEvCV5/H1NRSrOx5/acZv1kcxomIHcvADjK5mweLa4KgALdT/MTVhk2O8PGZ0PeX7Xo
         xXHsPBQA3uth5x1NgDAsYaSs+T/pW6030t6MXWvW/opjspDKqpgWbNBY+DLc2JYIKp7w
         zBPID1LKnQ7z3193Nw1WE9cILEpGWQ5nNUs6eEIFNDhHU9L4PE6Y2dvsI0quRy30mCBA
         srRD782NVzMEPW3zth2/a8iazm1/gH/RWdq9Tpb4b1QH0dqT5vDqyYGY1dZQgeW2rhP0
         8dKg==
X-Forwarded-Encrypted: i=1; AFNElJ/mwWojl7LTHZo8WQvgXbawT0LFpSDIxH4j48Lt5JtDnvuBaQXFPNw4roFh/wdgUVTL6x+IVhINm+jB@vger.kernel.org
X-Gm-Message-State: AOJu0YxZefubNAFtbVtmYvxK1Cb87vxC5wBoM66mT8rYPo6Gyud0ZyCl
	Q/HT2TA+F3rV4OpFuTuQVJWIUEsPBkiDydvWLgt7AOGGkEnoDDguXm1eml3HMGr+cUbt75xPYdi
	qX3M2yYf3hSwl6f4G7l91bKRdRKPbg/5wltUgALUvkkg9LLt1ltf3HGu8lac=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:168f:b0:696:8cf4:a117 with SMTP id
 006d021491bc7-69d6ef07503mr467687eaf.51.1779335670388; Wed, 20 May 2026
 20:54:30 -0700 (PDT)
Date: Wed, 20 May 2026 20:54:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0e81f6.a70a0220.c4b15.010d.GAE@google.com>
Subject: [syzbot] [mm?] [ext4?] BUG: unable to handle kernel NULL pointer
 dereference in qlist_free_all (10)
From: syzbot <syzbot+741fee3eb7f4c4e6992a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    df685633c3db Merge tag 'rcu-fixes.v7.1-20260519a' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17beec2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0f0911eedbc130a
dashboard link: https://syzkaller.appspot.com/bug?extid=741fee3eb7f4c4e6992a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110e6b06580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146b4c2e580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/90074e46cb62/disk-df685633.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/691247547753/vmlinux-df685633.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e1c705a2acac/bzImage-df685633.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+741fee3eb7f4c4e6992a@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000008
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 800000007c8b6067 P4D 800000007c8b6067 PUD 0 
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 7032 Comm: syz.0.224 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:qlink_to_cache mm/kasan/quarantine.c:131 [inline]
RIP: 0010:qlist_free_all+0x8d/0xf0 mm/kasan/quarantine.c:176
Code: 48 89 c2 48 c1 e2 06 48 03 15 1f 8a a7 0b 48 8b 42 08 48 89 c1 83 e1 01 48 83 e9 01 48 09 c8 48 21 d0 80 78 33 f5 49 0f 45 c5 <48> 8b 68 08 eb 88 48 83 7d 40 00 75 9b 66 f7 45 08 04 02 75 93 8b
RSP: 0018:ffffc9000654f428 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff88802c2a8000 RCX: ffffffffffffffff
RDX: ffffea0000b0aa00 RSI: ffffffff8df1f2e9 RDI: ffff88802c2a8000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802c2a8000
R13: 0000000000000000 R14: ffffc9000654f458 R15: 0000000000000100
FS:  00007fa39d6a46c0(0000) GS:ffff888124374000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000000757fe000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 kmem_cache_alloc_noprof+0x241/0x6e0 mm/slub.c:4905
 vm_area_alloc+0x1f/0x160 mm/vma_init.c:32
 __mmap_new_vma mm/vma.c:2547 [inline]
 __mmap_region+0x104d/0x2da0 mm/vma.c:2771
 mmap_region+0x35d/0x620 mm/vma.c:2857
 do_mmap+0xc63/0x12f0 mm/mmap.c:560
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0xe4/0x610 mm/mmap.c:606
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa39c79ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa39d6a4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fa39ca15fa0 RCX: 00007fa39c79ce59
RDX: 00000000000000db RSI: 0000000004020009 RDI: 0000000000000000
RBP: 00007fa39c832d6f R08: 0000000000000401 R09: 0000000000008000
R10: 0000000000000eb1 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa39ca16038 R14: 00007fa39ca15fa0 R15: 00007fffb789fb58
 </TASK>
Modules linked in:
CR2: 0000000000000008
---[ end trace 0000000000000000 ]---
RIP: 0010:qlink_to_cache mm/kasan/quarantine.c:131 [inline]
RIP: 0010:qlist_free_all+0x8d/0xf0 mm/kasan/quarantine.c:176
Code: 48 89 c2 48 c1 e2 06 48 03 15 1f 8a a7 0b 48 8b 42 08 48 89 c1 83 e1 01 48 83 e9 01 48 09 c8 48 21 d0 80 78 33 f5 49 0f 45 c5 <48> 8b 68 08 eb 88 48 83 7d 40 00 75 9b 66 f7 45 08 04 02 75 93 8b
RSP: 0018:ffffc9000654f428 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff88802c2a8000 RCX: ffffffffffffffff
RDX: ffffea0000b0aa00 RSI: ffffffff8df1f2e9 RDI: ffff88802c2a8000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802c2a8000
R13: 0000000000000000 R14: ffffc9000654f458 R15: 0000000000000100
FS:  00007fa39d6a46c0(0000) GS:ffff888124374000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000000757fe000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	48 89 c2             	mov    %rax,%rdx
   3:	48 c1 e2 06          	shl    $0x6,%rdx
   7:	48 03 15 1f 8a a7 0b 	add    0xba78a1f(%rip),%rdx        # 0xba78a2d
   e:	48 8b 42 08          	mov    0x8(%rdx),%rax
  12:	48 89 c1             	mov    %rax,%rcx
  15:	83 e1 01             	and    $0x1,%ecx
  18:	48 83 e9 01          	sub    $0x1,%rcx
  1c:	48 09 c8             	or     %rcx,%rax
  1f:	48 21 d0             	and    %rdx,%rax
  22:	80 78 33 f5          	cmpb   $0xf5,0x33(%rax)
  26:	49 0f 45 c5          	cmovne %r13,%rax
* 2a:	48 8b 68 08          	mov    0x8(%rax),%rbp <-- trapping instruction
  2e:	eb 88                	jmp    0xffffffb8
  30:	48 83 7d 40 00       	cmpq   $0x0,0x40(%rbp)
  35:	75 9b                	jne    0xffffffd2
  37:	66 f7 45 08 04 02    	testw  $0x204,0x8(%rbp)
  3d:	75 93                	jne    0xffffffd2
  3f:	8b                   	.byte 0x8b


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
