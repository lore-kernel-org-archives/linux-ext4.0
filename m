Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81663BFE3E
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 10:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773915862; cv=none; b=RztMFjxc1SdNbwZQt67kaAnuCknIozzl58m6r2Nd/SgHnTiXIOYErpx7Y3+Ftd5mq01i3ZQvZ7WsiOzb4Os35hrgcHX0bxBDClT7v2BNbHUgEHNCr1x1HVmN7Z8GNx1pSXVY3hMPOTzuqPJSdt9F9PYHPcXZcl6Db/c1Htstp/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773915862; c=relaxed/simple;
	bh=9B2Hl+6I4ChgPovktLOAARvnz18ls8VEjRJ/1gr6EVI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ekSZvQLomy0caAyJ0hILzGYgtYbQuVnpRw37BlTOarz0onLgT6jlckWhDBNHscu/jkI/0edJ5umauHbXhx7KdqE0cBGgMhK0wFkHbFcretnZiOD35O2SGlTIXte7fQMHHoCUG0v+RR+yLcW/U81W1ZjgkC2vKrO+8fq7wIqvLmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-41702ea8343so6263993fac.0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 03:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773915860; x=1774520660;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57sCNPJzKfChPcSEGK1BN9+Ko/h/jrB7iWxDTKn4OFE=;
        b=k+GIdpAkosE1NxdFe77vkQVTO+u52kWWTY5Uctsz1DHG7gaWnnglt+c7XRe2in5C5q
         L4N67V39jh/geKPs1YnBy7osVdxldn6YkHgDGWtp4TPx48x+DjUIkDk7ktC5sp2MeyAY
         jWBsumNW7rbrSfJT4ClOrRYIHJ/Wq8hp2y/TmMurOiputTk+hGBGD8pAbVR9SPdGsa2G
         GKDxHjaa1jzYopKakTJ7N8XFVHVPbvIOZVb4QuSwr+shW4ldsa0fSSAWjSooJGNRc92w
         izPQsp1quJ4fsDp0oD5tKwIQ8uWB6WJkDg8U+TvxE7fSrCv0CqV7wHLf042iZhfzszBm
         frbg==
X-Forwarded-Encrypted: i=1; AJvYcCWQl1JLuq34RWJ3RI87TKOkg889zI14R4Wvqs1Y7AADpHDzwbiZoAB663v8uGvrzuKVIwodcjspAlTD@vger.kernel.org
X-Gm-Message-State: AOJu0YxmL4z4NXJ/ve5MBWCwWYkjJTDBBoG1Fh6TU5JcfWZRY8rD4yBn
	ViMT7Tn7WhFPUee/dSf4EUuguVDx82it41Cs96jvwI7NQGloDKpS6pX0dDZ61eTZzU3dS2EPxel
	lHNoIe+CvGb24boo9iy97/HV39+Q80Gq05xrhxzEDdbGG4jSAPjcwkAaGYBY=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1889:b0:67b:dd09:bc78 with SMTP id
 006d021491bc7-67c0daada7fmr4750194eaf.18.1773915859906; Thu, 19 Mar 2026
 03:24:19 -0700 (PDT)
Date: Thu, 19 Mar 2026 03:24:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bbced3.050a0220.1b2d94.000b.GAE@google.com>
Subject: [syzbot] [ext4?] general protection fault in ext4_split_extent_at
From: syzbot <syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1c9982b49613 Merge tag 'drm-fixes-2026-03-14' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e35d52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccef46afa67b2b19
dashboard link: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1c9982b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0ac9f4872167/vmlinux-1c9982b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bdee9f3a13ab/bzImage-1c9982b4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com

EXT4-fs (loop0): pa ffff88804798e658: logic 0, phys. 209, len 19
EXT4-fs error (device loop0): ext4_mb_release_inode_pa:5465: group 0, free 0, pa_free 8
EXT4-fs error (device loop0): ext4_ext_split:1151: inode #18: comm kworker/u4:8: eh_entries 0 != eh_max 84!
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 1060 Comm: kworker/u4:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
RIP: 0010:ext4_split_extent_at+0x486/0xa40 fs/ext4/extents.c:3266
Code: 02 00 00 e8 0c 90 42 ff 49 bf 00 00 00 00 00 fc ff df 4c 8b 6c 24 38 0f b7 9c 24 e4 00 00 00 49 83 c4 04 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 23 05 00 00 66 41 89 1c 24 4c 8b 74 24
RSP: 0018:ffffc90001567180 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000008004 RCX: ffff8880331d4980
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900015672c8 R08: ffff888047a501d7 R09: 1ffff11008f4a03a
R10: dffffc0000000000 R11: ffffed1008f4a03b R12: 0000000000000004
R13: 1ffff920002ace44 R14: ffff8880368d5500 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb2c215ff8 CR3: 00000000123cf000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ext4_split_extent fs/ext4/extents.c:3440 [inline]
 ext4_split_convert_extents+0x36d/0x1a00 fs/ext4/extents.c:3830
 ext4_convert_unwritten_extents_endio fs/ext4/extents.c:3906 [inline]
 ext4_ext_handle_unwritten_extents fs/ext4/extents.c:3990 [inline]
 ext4_ext_map_blocks+0xe70/0x58b0 fs/ext4/extents.c:4327
 ext4_map_create_blocks+0x11d/0x540 fs/ext4/inode.c:616
 ext4_map_blocks+0x7cd/0x11d0 fs/ext4/inode.c:809
 ext4_convert_unwritten_extents+0x2be/0x5f0 fs/ext4/extents.c:5029
 ext4_convert_unwritten_io_end_vec+0xff/0x170 fs/ext4/extents.c:5069
 ext4_end_io_end+0xc7/0x410 fs/ext4/page-io.c:200
 ext4_do_flush_completed_IO fs/ext4/page-io.c:291 [inline]
 ext4_end_io_rsv_work+0x26a/0x340 fs/ext4/page-io.c:306
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ext4_split_extent_at+0x486/0xa40 fs/ext4/extents.c:3266
Code: 02 00 00 e8 0c 90 42 ff 49 bf 00 00 00 00 00 fc ff df 4c 8b 6c 24 38 0f b7 9c 24 e4 00 00 00 49 83 c4 04 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 23 05 00 00 66 41 89 1c 24 4c 8b 74 24
RSP: 0018:ffffc90001567180 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000008004 RCX: ffff8880331d4980
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900015672c8 R08: ffff888047a501d7 R09: 1ffff11008f4a03a
R10: dffffc0000000000 R11: ffffed1008f4a03b R12: 0000000000000004
R13: 1ffff920002ace44 R14: ffff8880368d5500 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb2c215ff8 CR3: 00000000123cf000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	02 00                	add    (%rax),%al
   2:	00 e8                	add    %ch,%al
   4:	0c 90                	or     $0x90,%al
   6:	42 ff 49 bf          	rex.X decl -0x41(%rcx)
   a:	00 00                	add    %al,(%rax)
   c:	00 00                	add    %al,(%rax)
   e:	00 fc                	add    %bh,%ah
  10:	ff                   	lcall  (bad)
  11:	df 4c 8b 6c          	fisttps 0x6c(%rbx,%rcx,4)
  15:	24 38                	and    $0x38,%al
  17:	0f b7 9c 24 e4 00 00 	movzwl 0xe4(%rsp),%ebx
  1e:	00
  1f:	49 83 c4 04          	add    $0x4,%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 23 05 00 00    	jne    0x55a
  37:	66 41 89 1c 24       	mov    %bx,(%r12)
  3c:	4c                   	rex.WR
  3d:	8b                   	.byte 0x8b
  3e:	74 24                	je     0x64


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
