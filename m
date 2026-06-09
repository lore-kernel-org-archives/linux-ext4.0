Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C3740D57F
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 21:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781039014; cv=none; b=U1IMV9Bdf+/Sl8wEnYcwKEBl6QnwjG+h2rsXBbLHzuJ/T5Z9O7T9O57bt9MspD8x3cnGZRMhdZsEXCgZaVzq/MPN1X7PNZW15kWZ5pV3PrcHIgC/oiyCGOovr53yxNvSB+YBr0cFqEHNQQpXZCmcUJr75vdR9ASndX/FxjOvonA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781039014; c=relaxed/simple;
	bh=3koKuE6bjkgQS2xbKYsD2J+TUFefwYHJ5laVbJJAO0M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=V+/CRktbqJ5zjnX20lQdpUr6FsEgEhoHpcthT7OeEMSZaOQnrAz0xjipQg5npu+4jNhyWKQhP5DshP6gN4G3dG+o7mJ/CeNOeMc1MW2bfQg9JuSvW+Vdi+QAhC/FFuxZLhuNSlAtEx9GHFw4Q5lODxORz+ubLcYJtrWsqzJrLno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-69e37cab8e0so8144277eaf.3
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2026 14:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781039012; x=1781643812;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3dlFvrYrzKbDhSWnrDZGhiWty0ba+90oypUY6AJkEeg=;
        b=TBJSPtEUjJ1tFKQntRQtxlL2ngnux2d705NRujWG0CqpZt0AwbRYKC5dR5ymESxbm7
         +4WzwxhQoXOr7XIZP2oC04CgpWMVucGcpfxW8SnUgzY05+i3hVQSkdSoMctYbRBMk19f
         QcAjyhCH6zlkbcy5396wsENb/NLolSSce7z9+Z/zdLB4RyGl1xl8oP1095yVrwqYa3aj
         lqH3cLWNqnLXUwnQsb+J3Twrc9RrNz8Ir8+smiEIePBwlMtpmPnYAQNuah17xo/y/Da4
         feOFqPvjA3Zzf/TgsnGwO6iDxSPa8iuvShp5sJKJMxXx/N6qGuxbun5Fvdg/IBVi/3Ka
         9qNQ==
X-Forwarded-Encrypted: i=1; AFNElJ8de0pvRIKUMZyIvx0gCGdvotIH132Qcr8dZT4eeaznkt8YC9TcZFLASv3Acab87a/h+W1fkXWHBobZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2yOhyw/IE8Foa1W1qBWjK2P1E8Jcnz3kvqzeIk5qg9wRDDPoW
	fYK9z3F1hLQek3bGOuA69OhZXxmUhokD0QKRvTYUEcYjUabV4vqVNt219wo6dfAh+qR3gkeuvZ9
	w+DqRcgfc8QuK8is5wZJlTXX15lAi8shpm/dNJeLgmxbgVyeEZHk97k1qDY0=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0f:0:b0:69e:90d8:d0b1 with SMTP id
 006d021491bc7-69eac6bddbfmr2960868eaf.0.1781039012500; Tue, 09 Jun 2026
 14:03:32 -0700 (PDT)
Date: Tue, 09 Jun 2026 14:03:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a287fa4.39669fcc.33b062.00a4.GAE@google.com>
Subject: [syzbot] [ext4?] KASAN: use-after-free Read in ext4_xattr_list_entries
 (2)
From: syzbot <syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8e65320d91cd Merge tag 'drm-fixes-2026-06-06' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106aabec580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=3fbf2337de43f5581aec
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8e65320d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0bee42e3c28b/vmlinux-8e65320d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/57e4c1a3c321/bzImage-8e65320d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 2048
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
cdc_ether 5-1:1.0: probe with driver cdc_ether failed with error -22
loop0: detected capacity change from 2048 to 64
EXT4-fs error (device loop0): xattr_find_entry:337: inode #15: comm syz.0.0: corrupted xattr entries
==================================================================
BUG: KASAN: use-after-free in ext4_xattr_list_entries+0x302/0x3d0 fs/ext4/xattr.c:724
Read of size 4 at addr ffff8880568de014 by task syz.0.0/5342

CPU: 0 UID: 0 PID: 5342 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_xattr_list_entries+0x302/0x3d0 fs/ext4/xattr.c:724
 ext4_xattr_ibody_list fs/ext4/xattr.c:793 [inline]
 ext4_listxattr+0x221/0x670 fs/ext4/xattr.c:818
 vfs_listxattr fs/xattr.c:511 [inline]
 listxattr+0x112/0x2a0 fs/xattr.c:933
 filename_listxattr fs/xattr.c:966 [inline]
 path_listxattrat+0x1a3/0x3f0 fs/xattr.c:993
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9709f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f970af29fe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000c3
RAX: ffffffffffffffda RBX: 00007f970a215fa0 RCX: 00007f9709f9ce59
RDX: 000000000000002d RSI: 0000200000000100 RDI: 0000200000000140
RBP: 00007f970a032d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f970a216038 R14: 00007f970a215fa0 R15: 00007fff4c5d5648
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x568de
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 ffffea00015a37c8 ffffea000141f208 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffff8880568ddf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880568ddf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880568de000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                         ^
 ffff8880568de080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880568de100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
