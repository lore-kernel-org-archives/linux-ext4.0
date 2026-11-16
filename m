Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794816771;
	b=ItjAXg06PZSZwYeFeWfAEGvYe7kaqYje/KNeAKVM5JcJBeFETVTJuNF3fPCpanNiDfZM
	 OY/teEQ6oCEgAFPgxUBf/aMFwY3zKT//WPh4WdjrUCscMxHq+Y/EJjrYdNPEE9Xh4bbiM
	 4WNKc1U8UU0DWGt71vvUr7WPxVZc2L7H9FixVKthmU9wJ69Eh4LRpvTMvQSE/XkUQK4WV
	 OtOt+en68+hco18MlmYV70moEZI1d/aBFwnEkkaixIdPA0wLokQLlLncXDQIFd23p0RNK
	 uuqxqNawwZogK9nh1I0GD2MNVVPCkymE3jUldtAJFm+xEhN5WqEZQjPliBlMSxO+rmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794816771;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=tKJr2taXAbMNdxS2ld12zcXQJ7D7w6pOLh3/XuIBMz8=;
	b=mAaD3ptEZthdmn0Anu72+58DOx18yK4DEOZnKk/s8RDqEb8mEErv2t18eytDoRVYVrQA
	 nfOrGHZEhzoGbm++ymUWPfT+C/uuEsWwH7RTffporGvWNnmmu3/U0ni7fFqAzI8XkK2SH
	 1BXED8BI7eE9VlCaE8HkKNs1O6m+M/tvckVPT6m8biCFjcgl2o+Tyer5krNOLMRJxVz2/
	 0X2+TdcTNyv8VTAD2+z8qeSm6vGrf5Wgv0utFki1p9dIQfG9U2GkxA/I49xvRNy5Bksq0
	 m3cp2/yKL9Wb/6ogspuBjAWNfptpDlE+rvK6UlJnTZLZCxLgc2OnmrMx/B3NoSeukVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E79606A332
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 08:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39E79606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c467e19391so4988697b6e.3
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 00:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816770; x=1795421570;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tKJr2taXAbMNdxS2ld12zcXQJ7D7w6pOLh3/XuIBMz8=;
        b=M0If2wtIMms3BxIBWMAbdQs9/72xf98fWthv7sU4/1N08Uz2qiV4LRdHC9JGcnqJEh
         dK79IV/NRxbnaymiRfgyAPGJcIxLI/3vf7j0tTS20nZdy0lxD21ESYlWafClFD8PiTil
         TTWBZMhgoYiukE4Hh+mTnPExxns82jvK1GcuZA6gM6hXA+eWJU6dI2GjIA4eAx4LeU7w
         JPu7arYW27y4TUta2TAapL9HMnfUr7XWO3c3nmnScgCHIsEG8AY/B1653ThDtu9W6Wqz
         FTkY/JJb/BXtcn5B2ydv82MTGD797Vl5Oy8G78Dcyd9Ifb7OtW/y4L7bITOYN0vqU1I7
         g5IQ==
X-Forwarded-Encrypted: i=1; AL+hErEHbm3Lxc4UySWMqBnukRfSceV0bu2Mq+nTRWPlgWM27F2jjtDQneL7/eApXUZVlloxed9bojEIY4ZW@vger.kernel.org
X-Gm-Message-State: APuU4Z93jw3/FoPmcuLHZo46Ps0HBtJuPbMQLh7ebzixuQ832SkO4wgl
	MVpG877rUIU+Eu2b31jfViS6uUDSLvsNfFa/CAwiwdM0j0jzPKTCvz033V1T4l8xJaAAZnELvq7
	nfFeYhRDOcupSLObIMgINlYTtfEW+NraAOMoIRFepWZF2NyufNQ2lrhZUcEU=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:148a:b0:4b9:e6ab:d07b with SMTP id
 5614622812f47-56e634827b9mr7862955b6e.27.1794816770222; Mon, 16 Nov 2026
 00:12:50 -0800 (PST)
Date: Mon, 16 Nov 2026 00:12:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afabb02.3f8ef711.2cc87e.0003.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in jbd2_journal_dirty_metadata (4)
From: syzbot <syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com>
To: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fa2933aac170 Merge tag 'x86-urgent-2026-11-15' of git://gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=144bd5a1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d16c0eae9c338e3c
dashboard link: https://syzkaller.appspot.com/bug?extid=e8180f5590685cbc9037
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154c444d580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113d0411580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40cdc2f6bae1/disk-fa2933aa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3aa3c064246/vmlinux-fa2933aa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bae87f0bfa48/bzImage-fa2933aa.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6a29776e177b/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=164c444d580000)

AI-generated root cause summary:
In ext4 inline data writes, ext4_generic_write_inline_data() starts a
transaction handle requesting only 1 credit for dirtying the inode buffer. When
inline data is created or expanded, ext4_prepare_inline_data() consumes that
sole credit by marking the inode table block (iloc.bh) dirty. If the subsequent
userspace copy fails or is truncated (e.g. copying from a NULL/unmapped
address), ext4_write_inline_data_end() invokes ext4_orphan_add(handle, inode),
which attempts to dirty an orphan file or superblock block using the exhausted
handle. jbd2_journal_dirty_metadata() encounters
jbd2_handle_buffer_credits(handle) <= 0, warns, and returns -ENOSPC, causing
__ext4_handle_dirty_metadata() to abort the journal handle and trigger ext4
filesystem error handling.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=e8180f5590685cbc9037

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com

EXT4-fs (loop0): mounted filesystem 104feaea-39f8-49fa-9fe9-3052f307e139 r/w with ordered data mode. Quota mode: journalled.
------------[ cut here ]------------
jbd2_handle_buffer_credits(handle) <= 0
WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata+0xb84/0xef0 fs/jbd2/transaction.c:1598, CPU#0: syz-executor284/5618
Modules linked in:
CPU: 0 UID: 0 PID: 5618 Comm: syz-executor284 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
RIP: 0010:jbd2_journal_dirty_metadata+0xb84/0xef0 fs/jbd2/transaction.c:1598
Code: 39 03 00 00 45 8b 06 48 c7 c7 a0 bf a7 8b 89 ee 89 da 4c 89 f9 e8 bc 6f 80 fe b8 ea ff ff ff e9 40 fd ff ff e8 dd f5 20 ff 90 <0f> 0b 90 b8 e4 ff ff ff e9 2d fd ff ff 44 89 e1 80 e1 07 38 c1 0f
RSP: 0018:ffffc90004a5f0f8 EFLAGS: 00010293
RAX: ffffffff82a6f833 RBX: 1ffff11008908f20 RCX: ffff88804117be80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff21ab638 R12: dffffc0000000000
R13: ffff888044847908 R14: ffff888044853900 R15: 0000000000000008
FS:  000055558b2f3400(0000) GS:ffff888124709000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000046af40 CR3: 000000002ae66000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __ext4_handle_dirty_metadata+0x198/0x9f0 fs/ext4/ext4_jbd2.c:392
 ext4_quota_write+0x3ca/0x580 fs/ext4/super.c:7503
 qtree_write_dquot+0x244/0x5e0 fs/quota/quota_tree.c:462
 v2_write_dquot+0x183/0x260 fs/quota/quota_v2.c:372
 dquot_commit+0x36e/0x440 fs/quota/dquot.c:540
 ext4_write_dquot+0x20a/0x380 fs/ext4/super.c:7096
 mark_dquot_dirty fs/quota/dquot.c:398 [inline]
 mark_all_dquot_dirty+0x1fe/0x460 fs/quota/dquot.c:438
 __dquot_free_space+0x817/0xc00 fs/quota/dquot.c:1901
 dquot_free_space_nodirty include/linux/quotaops.h:372 [inline]
 dquot_free_space+0x1b/0x30 include/linux/quotaops.h:377
 swap_inode_boot_loader+0xbe6/0x1070 fs/ext4/ioctl.c:503
 __ext4_ioctl fs/ext4/ioctl.c:1731 [inline]
 ext4_ioctl+0x2379/0x4b70 fs/ext4/ioctl.c:1932
 vfs_ioctl fs/ioctl.c:52 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f163c16d949
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5b174698 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f163c16d949
RDX: 0000000000000000 RSI: 0000000000006611 RDI: 0000000000000004
RBP: 0000000000000001 R08: 000055558b2f4560 R09: 000055558b2f4560
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe5b1746c0
R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007f163c1cd04b
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
