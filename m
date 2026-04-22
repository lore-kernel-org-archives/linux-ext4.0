Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0693364046
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 22:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776897869; cv=none; b=b5Zpa8eBaKHK9O7yd9aXdcOEvx/QBgh0sX2itqTnQre1QbI5LF4glFVFBBuyo0bzbI1q+nSEiShKtbnuDrkHo12DIqEfEaG45QVjrMXFV8O4il8qMLdivrxviX99zMWkSX+HO+6f5JlCuYRnDRthQ0pftLNjzV6fgzZOHBY8Mg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776897869; c=relaxed/simple;
	bh=2CLnSP3NEMUlwcB4vc88Rr16RkTxa5B+HpTpVLYlJQs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bLEUBI1oHNpIKcRaISZGJt/dRO/sykF26YjwsiOaTX+Fb2obJ84dLx2qV3bqSrS14cp3XNAn1ZyX0H3spyA9iA3Vu3ZkdL8gFxBI9jJTHPNDm8uWD8c0sJHu1+XVW7vLjyVcvzwoBDp+Ym9EAVpAZnXbEl+yi+7NKqHw7etEBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d4be1dee67so14784721a34.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 15:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776897866; x=1777502666;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gGT97ChjdsRCHqxVlRQ2FN7oqi7qOicH+gwshBV/cyM=;
        b=A7BESsCPP81HGqiMUE9nGLK+toyuM8VpczrLxh6intrgzTnbAYLgCurMNPUiDjrvdB
         OaDXNBJne7X6sDtj0aK1yt552zSIWMwAkM4UC3iKieKiGKwmzlnoWZxBHHa/il/QtiLL
         wRRA5levP0d4WVB27K1zhAxouxI0AvOENix8Fj/+ZfvK9XErYyXtHiMgzfUO5dOiEBni
         6Ar5DOWOuOFQMRfqfj1GZSX/2REDvWqS4S53luSnN22TFAOy1AOwR+HBlVV9r6NU+BNW
         RKOgtS3/cwmXFJVjNoDLnyZpJxjf+eKwHlEG05wMWYvVcslYUEcg+EO3M3nOi88D1G+j
         yU4g==
X-Forwarded-Encrypted: i=1; AFNElJ8Y2H3Ni8o/AHLBZGeGyYuPo5aetphzJaaywURiE0fP/Ui/JmdQBFSs3dNv/8S3ID29nUHlOLeV9nZQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2osKiDNSFD8NnvDBy1hxVKeoQkHGqOyaSXid652Y0SDbUmZq6
	NTbxIRthLbjM05kLXHbZTvvJXhRMmhlyQu55kftmwKulbVq8o52T0YGaV0znL/u5NeSWlvSM9XF
	HzWFBInf/Bz5mPdJFc0m8NNOTiSpsyFW8dmjUi/3zyr1Kgj02aaEnPqeFwD8=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d06:b0:683:63f2:a42a with SMTP id
 006d021491bc7-69462ed3552mr14869674eaf.33.1776897866693; Wed, 22 Apr 2026
 15:44:26 -0700 (PDT)
Date: Wed, 22 Apr 2026 15:44:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e94f4a.a00a0220.9259.0022.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in jbd2_journal_dirty_metadata (3)
From: syzbot <syzbot+a5f824f1c49dd97fcff0@syzkaller.appspotmail.com>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eb5249b12507 Merge tag 'parisc-for-7.1-rc1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ed0836580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d120b114be21f79
dashboard link: https://syzkaller.appspot.com/bug?extid=a5f824f1c49dd97fcff0
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-eb5249b1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cb4e868ca1f9/vmlinux-eb5249b1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb064cd651ff/bzImage-eb5249b1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a5f824f1c49dd97fcff0@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
jbd2_handle_buffer_credits(handle) <= 0
WARNING: fs/jbd2/transaction.c:1593 at jbd2_journal_dirty_metadata+0x9c8/0xd30 fs/jbd2/transaction.c:1593, CPU#0: syz.0.0/5322
Modules linked in:
CPU: 0 UID: 0 PID: 5322 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:jbd2_journal_dirty_metadata+0x9c8/0xd30 fs/jbd2/transaction.c:1593
Code: 26 03 00 00 45 8b 06 48 c7 c7 40 07 e6 8b 89 de 89 ea 4c 89 f9 e8 18 25 8a fe b8 ea ff ff ff e9 11 fa ff ff e8 f9 42 28 ff 90 <0f> 0b 90 b8 e4 ff ff ff e9 fe f9 ff ff e8 e6 42 28 ff 90 0f 0b 90
RSP: 0018:ffffc9000f85e640 EFLAGS: 00010287
RAX: ffffffff829d9bb7 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc9000ef42000 RSI: 000000000009fb83 RDI: 000000000009fb84
RBP: 1ffff1100ac32d99 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52001f0bcb8 R12: ffff8880483456f8
R13: ffff888048345690 R14: 1ffff11009068adc R15: 0000000000000000
FS:  00007f04675f56c0(0000) GS:ffff88808c81a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a18f887168 CR3: 000000001f4fd000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
 ocfs2_alloc_dinode_update_counts+0x16e/0x2d0 fs/ocfs2/suballoc.c:1746
 ocfs2_search_chain+0xe39/0x1e10 fs/ocfs2/suballoc.c:2002
 ocfs2_claim_suballoc_bits+0x901/0x1f40 fs/ocfs2/suballoc.c:2113
 __ocfs2_claim_clusters+0x31d/0x970 fs/ocfs2/suballoc.c:2540
 ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3243 [inline]
 ocfs2_replace_cow+0x984/0x1c90 fs/ocfs2/refcounttree.c:3346
 ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3424 [inline]
 ocfs2_refcount_cow+0x790/0xd40 fs/ocfs2/refcounttree.c:3467
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2347 [inline]
 ocfs2_file_write_iter+0xee2/0x1e70 fs/ocfs2/file.c:2458
 iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 do_sendfile+0x535/0x7d0 fs/read_write.c:1372
 __do_sys_sendfile64 fs/read_write.c:1433 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f046b19c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f04675f4fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f046b415fa0 RCX: 00007f046b19c819
RDX: 0000000000000000 RSI: 000000000000000b RDI: 000000000000000a
RBP: 00007f046b232c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020fffe82 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f046b416038 R14: 00007f046b415fa0 R15: 00007ffd208882e8
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
