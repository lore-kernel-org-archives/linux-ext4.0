Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794778403;
	b=K8lln5vu7oNl3SxUObk5AmBH6MD2zFsKIPZBNoScZ8egamLOXw6tCIMuzGGKx36Hx3l6
	 rI9n+7vn/m/iwbv/NlMRtxlzbrk3vZ05BFt01QkawWSJ7ucLzXueEGi/ElA0r31qS7jwZ
	 MIhGVsiPB3hmaGjiU5ASu/WDdwr67PAEcr/nmvGxlMpuHyqPq7rURBxcrkRtrFRBKOpby
	 PazPEYNzd9zLNLJYCBOxUBxHqr1QctB3yUh+b2YFLFv4+agjSLgW+s5cgzGbidUMQ6Pet
	 O1fDYt1bf9MUAEMsREWO8Kg6BckPU+/eDvGtFQojHCbuG0WqV58F5KyTx57J4RmgBfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794778403;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=wMHKKEbZ5qkIB3H9zWO4Epb/GYr+RAZqg3mXa7IL7nY=;
	b=43T3ccPtn6tScTaN6gU+BGFZA2kdmUhqcj4tul/07TgMlwigthTA1gNgR6DAxQECAxne
	 O8jx8udeyYUJ+EdTNFbT/U77wfRQGCOm9k8PmLFzWIwjFtLe/1d+8uIOP/pzyjZYKklzr
	 9LXp639S0NkkPGRePUfeZTfjensNAxKT0ge/v4M3cWwvoqpkKNWL7rA9x9VpiqUKQBdqD
	 DpCDXUF5+IdNqyFCdJoCIbucC8F/V5c5ngM+xPpQ5etU3JS70srV4i2+PA40tgPagZyGE
	 wyHPD+o8jpYbFGyUuEFYZA4fO45AM7sXC/JPmtU9OjwVQr5svl439V+GfuyyFn6RPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989C606A323
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 21:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E989C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-862adf80a1eso1270132a34.2
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 13:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794778402; x=1795383202;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wMHKKEbZ5qkIB3H9zWO4Epb/GYr+RAZqg3mXa7IL7nY=;
        b=034fkKqzB/7HUGuY44R3MTS1a/BVFRkdc+vYUhwTQIG0tEFGTorYBwPxyjulQ3Z992
         Enr1PZ0V3MDaRHE7cX6CZ4m+Uuwjzv7nCqx+CmkHOsbI31sMhvDRMKd+8zbtSKLt60ng
         MxnCO8xNACgz/x8JQ0xDnNnjP5cd3euTq/5v/skB54/CtAIhmaTvH09GFLjcSxIY5B5D
         +6EM5+SX4qpeY0nA1P6IevR8Tsia79+BsH8DY/a8uFFgSDXpgF2FPVIXwjVfXzo3ckIk
         FGRe2GoXShBHDHSLEtPXwjonEALCnmGh7DbI/Qyu9eGQP/4gQo8GQkpqQesupkgNc/5Y
         m4hg==
X-Forwarded-Encrypted: i=1; AL+hErFp8r32seykCCoQ4Tqehlt/G8FbI/g4WnrWgipvlQzhVCZl5WXlEpKctT2BhJWS7IxZ4wzAgwBBAW5N@vger.kernel.org
X-Gm-Message-State: APuU4Z8rYUmIIcWVa4NWLMfsAO0wCokYyLP3httQNW9F3seOWLDufJJq
	Qqqu8Efz72tqQUB5rE0lHqfqd3bCsuWgs017O1pyH3qv2h3EbgHKDExwc6tSDVopw0y12RBgb1h
	TJFBxgWxipdKk9EjETVOWEBNuUXU3vikv36nm7ENcAQqqi4KyG7vI0pWx1Qg=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1310:b0:4ab:230c:5faa with SMTP id
 5614622812f47-56e6389948bmr7585004b6e.18.1794778401926; Sun, 15 Nov 2026
 13:33:21 -0800 (PST)
Date: Sun, 15 Nov 2026 13:33:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afa2521.84fe3b82.798c4.0005.GAE@google.com>
Subject: [syzbot] [ext4?] BUG: unable to handle kernel paging request in jbd2_journal_file_inode
From: syzbot <syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com>
To: jack@suse.com, jack@suse.cz, kartikey406@gmail.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9d66f26fefac Merge tag 'vfs-7.4-rc3.fixes.2' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15ee2a3d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d16c0eae9c338e3c
dashboard link: https://syzkaller.appspot.com/bug?extid=9c29b92a3b6500bb347d
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1185c4c3580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1585c4c3580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/74b7d989ed20/disk-9d66f26f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/181fa79fbd3e/vmlinux-9d66f26f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/83339d886058/bzImage-9d66f26f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/8e682084d20b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1685c4c3580000)

The issue was bisected to:

commit ed9356a30e59c7cc3198e7fc46cfedf3767b9b17
Author: Deepanshu Kartikey <kartikey406@gmail.com>
Date:   Sat Feb 7 04:36:07 2026 +0000

    ext4: convert inline data to extents when truncate exceeds inline size

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d2f5a1580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15d2f5a1580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11d2f5a1580000

AI-generated root cause summary:
In ext4, path-based truncate(2) bypasses ext4_file_open(), leaving
EXT4_I(inode)->jinode as NULL if the file has not been opened for writing. When
truncating an inline-data file to a size larger than its inline capacity,
ext4_setattr() calls ext4_convert_inline_data() to convert the file to extent
storage without first attaching a jinode. During conversion,
ext4_convert_inline_data_nolock() allocates a block via ext4_map_blocks(), which
in data=ordered mode invokes ext4_jbd2_inode_add_write() with
EXT4_I(inode)->jinode (NULL), causing a NULL-pointer dereference when
jbd2_journal_file_inode() accesses jinode->i_flags.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=9c29b92a3b6500bb347d

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com
Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")

EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w with ordered data mode. Quota mode: journalled.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 UID: 0 PID: 5626 Comm: syz-executor342 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
RIP: 0010:jbd2_journal_file_inode+0x10e/0x5c0 fs/jbd2/transaction.c:2717
Code: 94 ff 49 8b 06 48 89 44 24 08 48 8d b8 e8 08 00 00 48 89 7c 24 30 e8 21 08 d1 08 48 8b 04 24 48 8d 78 28 48 89 f8 48 c1 e8 03 <80> 3c 28 00 74 05 e8 87 30 94 ff 48 8b 1c 24 4c 09 7b 28 4c 8d 7b
RSP: 0018:ffffc90004c17690 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000000 RCX: ffffffff9ada4a01
RDX: 000000009c34c801 RSI: ffffffff8bed2560 RDI: 0000000000000028
RBP: dffffc0000000000 R08: ffffffff8b781fe2 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff21ab398 R12: 1ffff110067de680
R13: 00000000000007ff R14: ffff888033ef3400 R15: 0000000000000006
FS:  000055556ada1400(0000) GS:ffff888124811000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd3ee05c74 CR3: 00000000426c8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ext4_jbd2_inode_add_write fs/ext4/ext4_jbd2.h:336 [inline]
 ext4_map_blocks+0x161e/0x1c60 fs/ext4/inode.c:967
 ext4_convert_inline_data_nolock+0x25d/0x980 fs/ext4/inline.c:1139
 ext4_convert_inline_data+0x484/0x5c0 fs/ext4/inline.c:2012
 ext4_setattr+0xef2/0x1560 fs/ext4/inode.c:7104
 notify_change+0xbb8/0xec0 fs/attr.c:556
 do_truncate+0x1c2/0x250 fs/open.c:68
 vfs_truncate+0x4ba/0x540 fs/open.c:118
 ksys_truncate+0xf3/0x1c0 fs/open.c:142
 __do_sys_truncate fs/open.c:154 [inline]
 __se_sys_truncate fs/open.c:152 [inline]
 __x64_sys_truncate+0x5b/0x70 fs/open.c:152
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f518900a909
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffefc2154d8 EFLAGS: 00000246 ORIG_RAX: 000000000000004c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f518900a909
RDX: 00007ffefc215360 RSI: 0000000002fffffd RDI: 00002000000033c0
RBP: 0000000000000001 R08: 0000000000000000 R09: 000055556ada2560
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffefc215500
R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007f518906a04b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:jbd2_journal_file_inode+0x10e/0x5c0 fs/jbd2/transaction.c:2717
Code: 94 ff 49 8b 06 48 89 44 24 08 48 8d b8 e8 08 00 00 48 89 7c 24 30 e8 21 08 d1 08 48 8b 04 24 48 8d 78 28 48 89 f8 48 c1 e8 03 <80> 3c 28 00 74 05 e8 87 30 94 ff 48 8b 1c 24 4c 09 7b 28 4c 8d 7b
RSP: 0018:ffffc90004c17690 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000000 RCX: ffffffff9ada4a01
RDX: 000000009c34c801 RSI: ffffffff8bed2560 RDI: 0000000000000028
RBP: dffffc0000000000 R08: ffffffff8b781fe2 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff21ab398 R12: 1ffff110067de680
R13: 00000000000007ff R14: ffff888033ef3400 R15: 0000000000000006
FS:  000055556ada1400(0000) GS:ffff888124811000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd3ee05c74 CR3: 00000000426c8000 CR4: 00000000003526f0
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	49 8b 06             	mov    (%r14),%rax
   3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   8:	48 8d b8 e8 08 00 00 	lea    0x8e8(%rax),%rdi
   f:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  14:	e8 21 08 d1 08       	call   0x8d1083a
  19:	48 8b 04 24          	mov    (%rsp),%rax
  1d:	48 8d 78 28          	lea    0x28(%rax),%rdi
  21:	48 89 f8             	mov    %rdi,%rax
  24:	48 c1 e8 03          	shr    $0x3,%rax
* 28:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2c:	74 05                	je     0x33
  2e:	e8 87 30 94 ff       	call   0xff9430ba
  33:	48 8b 1c 24          	mov    (%rsp),%rbx
  37:	4c 09 7b 28          	or     %r15,0x28(%rbx)
  3b:	4c                   	rex.WR
  3c:	8d                   	.byte 0x8d
  3d:	7b                   	.byte 0x7b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
