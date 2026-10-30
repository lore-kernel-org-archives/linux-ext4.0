Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377793;
	b=PP+6wXMQxKwKCCLQ+7fIgrYQaZ5N36Wp+aom1nSMf9BtuucGG6K7eNXrXxTBzSme3LpZ
	 j1Ww/2JuHO7L92ZZ070WhxaqBFxYTReo5puspmlp08YDtnzuRUif6xvR0rbCC5nqB3ubu
	 XgX0V9/uT9hmTPE2KAQMYWqahJgnhI1S/H6/Xc8KYIK5BX0E6gAxMsPBE2kcsG2YXAXTP
	 eFsgHUtiGiG7b64Qnud2W/FXnByN/EBYn04Y2iJ0OdYkh8jzweHPf3GmxiWCy2h9DVjmY
	 KlKk8ZN8Rwu/GohA5u7n9qbAoUSbHtk21MqoIOaRkyys+XrCz7rjvQQaXb8lndVtcVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377793;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=UbrJK1gmEBay7iBFJFQ+GOKQWV182S9OUrosyeEkatM=;
	b=hcjQc932N6uSe5EHp/YAv4jd9WM+Vhs9lmd0vwYSVs7YGOpug26u6+PYjTFgT0Afd2ot
	 pLC7gXbTZkpmtdY5HvtvUfmYeFUplsDg5pEyC8XPIJkVEFMh/PGo16u2RLisN7BGqhJ0Z
	 UTqXlsc7Qamsxy1XSE8eSSuyzzoEj5UdUE1h4DGTNQ5fV9tj4bCzBmGnfUTpYC1vRr6Vi
	 ePNJn9mWa5ECUC2bCbf32mH04qgv0zt+x6bLO5pirDx2AqMyC0mcEjvlfTXSIk1aEH4JM
	 RUwWDLEeb2Kj3UpOR8hrKRLgZ45AG6Nv6IjOpWvgronkFRi7JvfFvw77HHfWlccI2VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE1606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:29:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EBE1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4c55ba309c2so1223739b6e.1
        for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 09:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793377792; x=1793982592;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UbrJK1gmEBay7iBFJFQ+GOKQWV182S9OUrosyeEkatM=;
        b=M3Fq5tc1pgwaxJj2ASCgemyjT7aVMbuPcOumoaKhmFsEI9W0Vs7jTEz3i4xJ/ecfV8
         jvZg4U4wV2n4TZpANIacOmggK6wG5jRah0bFcxHJ05OD10ilyhSwHu+4zvEs4BA1bKcj
         vo1Sxw3yrXv9HadlGx7D6BXuXVWLZkCdiS7/QahBu4WDRXIlWHZ/KAGIi0h34O4N5O+0
         XtL3WwKCxp6WCHhAfbH5VF9cViKzjP+WoY7nH1hJ5QitjXjtyP2dnwZZp8u1nbnlAwn8
         IjBLy54HSDx/L+2lsFPrhnuvOHSlxkQwDNy0gVglAvwckkTG3qfzuQAI/r8S9QRPBUMO
         LYVw==
X-Forwarded-Encrypted: i=1; AKwUvByCfPOS9qVrcCaFNZqhXvLH1GvAWFv0dNt4vP1ndC3JORFP5iN/bK6YViFec1ypUMlM5GkH9qzfdVSh@vger.kernel.org
X-Gm-Message-State: AFq9FYKsUmErne2SqCuAhNl+DK+z5MhmNs+jA8p7DHgsyXl3mJpIWxsG
	UH2QBFDFLkNQm41NPSl6++7Qb3lFi4dxv3tO2Le7N9hq2zJnNAJvzeibppdPk6OHTYpT+kF7F4c
	gHN6c06i0wOv7miFBwrRDqS/tKquDtHEnuJes6vkTs+N4Z3ade0FT1AbnsMA=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6408:b0:4d6:9283:1df2 with SMTP id
 5614622812f47-5640de79c53mr1920184b6e.61.1793377792209; Fri, 30 Oct 2026
 09:29:52 -0700 (PDT)
Date: Fri, 30 Oct 2026 09:29:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae4c600.0c1d3ab6.e3d48.0072.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in ext4_do_writepages
From: syzbot <syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6b4b543fa187 Merge tag 'parisc-for-7.4-rc1' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17423721580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=34fc2a03f519bd67
dashboard link: https://syzkaller.appspot.com/bug?extid=97fbc97fdd4e4fa2ed3a
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12257b0d580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c23721580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4286db2c74d4/disk-6b4b543f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c7bad85f1b9a/vmlinux-6b4b543f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cb2301e1bf76/bzImage-6b4b543f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/60f2e9127825/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11a9250d580000)

AI-generated root cause summary:
In ext4 writeback (mpage_map_one_extent), a WARN_ON_ONCE(!err) is hit because
ext4_map_blocks() returns 0 (indicating a hole) for an extent that was queued
for writeback by mpage_add_bh_to_extent(). This occurs when a buffer head
remains marked mapped, dirty, and delayed/unwritten (for example, during file
truncation down via ftruncate/ext4_block_zero_eof or direct I/O fallback paths),
while the extent status tree or on-disk extent mapping for the logical block is
or becomes a hole. When ext4_map_blocks() is called with
EXT4_GET_BLOCKS_IO_SUBMIT, it avoids allocating blocks for holes and returns 0,
triggering the warning and returning -EINVAL. In production kernels, the warning
does not halt execution and error recovery safely invalidates the page without
causing memory corruption, information leaks, or denial of service.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=97fbc97fdd4e4fa2ed3a

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com

------------[ cut here ]------------
!err
WARNING: fs/ext4/inode.c:2512 at mpage_map_one_extent fs/ext4/inode.c:2512 [inline], CPU#1: kworker/u8:5/72
WARNING: fs/ext4/inode.c:2512 at mpage_map_and_submit_extent fs/ext4/inode.c:2601 [inline], CPU#1: kworker/u8:5/72
WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b6/0x44b0 fs/ext4/inode.c:3077, CPU#1: kworker/u8:5/72
Modules linked in:
CPU: 1 UID: 0 PID: 72 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
Workqueue: writeback wb_workfn (flush-7:0)
RIP: 0010:mpage_map_one_extent fs/ext4/inode.c:2512 [inline]
RIP: 0010:mpage_map_and_submit_extent fs/ext4/inode.c:2601 [inline]
RIP: 0010:ext4_do_writepages+0x33b6/0x44b0 fs/ext4/inode.c:3077
Code: 0f 0b 90 e9 b6 d9 ff ff e8 c7 d4 38 ff 90 0f 0b 90 e9 e6 dc ff ff e8 b9 d4 38 ff 90 0f 0b 90 e9 94 df ff ff e8 ab d4 38 ff 90 <0f> 0b 90 bb ea ff ff ff e9 ae f8 ff ff e8 98 d4 38 ff 48 8d 3d 11
RSP: 0018:ffffc9000158ec60 EFLAGS: 00010293
RAX: ffffffff828f01e5 RBX: 0000000000000000 RCX: ffff88801eb7ddc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000158f070 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10054fc8bc R12: ffffc9000158f120
R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff110054fc8d1
FS:  0000000000000000(0000) GS:ffff888124834000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c27e15b20 CR3: 0000000032ea4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ext4_writepages+0x1fe/0x4e0 fs/ext4/inode.c:3171
 do_writepages+0x338/0x560 mm/page-writeback.c:2560
 __writeback_single_inode+0x136/0x1230 fs/fs-writeback.c:1800
 writeback_sb_inodes+0x9db/0x1aa0 fs/fs-writeback.c:2111
 __writeback_inodes_wb+0x114/0x240 fs/fs-writeback.c:2187
 wb_writeback+0x42f/0xad0 fs/fs-writeback.c:2298
 wb_check_old_data_flush fs/fs-writeback.c:2402 [inline]
 wb_do_writeback fs/fs-writeback.c:2481 [inline]
 wb_workfn+0xc98/0x10f0 fs/fs-writeback.c:2509
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
