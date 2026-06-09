Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4963E9F95
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 08:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992813; cv=none; b=b1UwtMNuc8AyfnXTTk5CvO1PDsh8Vac8rQIS3/5JatxPyb/xFDnz+sX/wz4fV3o8TiKi2y6DI2ucQeO/9VfkLsTrTLk1s41WXxtRUqTN9XnIZNlhCKcZZaQOwbXsJT2FX3Fwo49ZE8qJcA2OZpczPou4eqMmKyhFrG4/CkSTX3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992813; c=relaxed/simple;
	bh=n5hyP3LVHyRUQkbvS5A24VNqYIm2kjdagQ9KAMVnHCc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jO6glwZbGkuBARvbTbHkQvMDoZsm9Amu/wuwY7At0DSrT13r2gt3fJlQmoalut3MyMgPofrM0jEFvZp60VHFa7+xkycer6iLEDRvtCwO/xshWAInMSNOFAfAigEw0ZENPi60LexQ1oiqu1XgYzwPT5aBNPQZezqMBpXSrwJfci8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4865626337fso4826112b6e.2
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2026 01:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780992810; x=1781597610;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3eq3WMalkM9GMlydsQkwRqIOwz/Njz7Td6cqXUE8VZU=;
        b=KHfoMhOfXv+C17Kt28RKCrpL/2IgOPt0dWcVZsRsiI2/jLx60owQ1IbvifDKj4M0DU
         nEPWYg8fQZ8yJI2L/VhaTuFKknad1XBJTf5Ee8UYT7V0pG4FpABVFsfpp2GYwhdODapO
         CguuBFtpv7B/bn4IX+shN7IcPHSj5njoLAEoxnP0CHXGstRI/x9sXPJHHxMhqOjZPxjq
         NpwRdUncote9bK57NktDitch0TQ/tQ6Q/TGWtFFcecQ+Yay3rKpHMM1N9fg59ZPOob8E
         nRm2GX/bGJdFKW2dEHU8x+ONNWlKxKdmwWIe6bYLK18b1g6IyFlfIAC5VPjMJ5KqcEoK
         N1mg==
X-Forwarded-Encrypted: i=1; AFNElJ/pAuYsQnSBt9VnENuN47Ua0v4MdvBesF7DKKK8XGP4C1pGOSKXdV2q5jbyFkAhN65Uoytn+i9M87Wp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0dPOlgZbSTauNpJ38fa90pQ+Ai01gjqI8ZHamcE2NcSNCFsBG
	b0/DmP1T7AmPOjQ5UqycuRElK17dGMLpybwg0r5JqFbkFwJufy33GPZ70ECxQyQpPb7N417Jfpj
	neuo10bTSO11Gu/6g3fBa6MKVTyjO2H8idVCkkMsMN0eGK0bi8KFthx7xAmM=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8591:20b0:69e:41d8:f7e3 with SMTP id
 006d021491bc7-69e68c18c94mr7773663eaf.38.1780992810614; Tue, 09 Jun 2026
 01:13:30 -0700 (PDT)
Date: Tue, 09 Jun 2026 01:13:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a27cb2a.39669fcc.33b062.008b.GAE@google.com>
Subject: [syzbot] [ext4?] kernel BUG in ext4_write_inline_data (5)
From: syzbot <syzbot+53c8bd6136cfbe85197e@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9154c4af7829 Merge tag 'mmc-v7.1-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161d8f2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd38685893011045
dashboard link: https://syzkaller.appspot.com/bug?extid=53c8bd6136cfbe85197e
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d4d939a8f4d3/disk-9154c4af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6fd4009d5e57/vmlinux-9154c4af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d924d24cd0a4/bzImage-9154c4af.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53c8bd6136cfbe85197e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ext4/inline.c:240!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6427 Comm: syz.2.110 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:ext4_write_inline_data+0x43c/0x440 fs/ext4/inline.c:240
Code: c1 38 c1 0f 8c 19 ff ff ff 48 89 df 49 89 d7 e8 7a 1f b0 ff 4c 89 fa e9 06 ff ff ff e8 3d f2 48 ff 90 0f 0b e8 35 f2 48 ff 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f
RSP: 0000:ffffc9000d34f808 EFLAGS: 00010293
RAX: ffffffff827b79eb RBX: 0000000000002cf3 RCX: ffff88803ec71ec0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88804391b8fa R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100bc12881 R12: 000000000000003c
R13: ffffc9000d34f8e0 R14: 0000000000002cf2 R15: ffff88804391b1e8
FS:  00007f7639c7d6c0(0000) GS:ffff888126283000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000813 CR3: 000000003cc4a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ext4_write_inline_data_end+0x332/0xaf0 fs/ext4/inline.c:825
 generic_perform_write+0x5f7/0x8b0 mm/filemap.c:4346
 ext4_buffered_write_iter+0xd0/0x3a0 fs/ext4/file.c:316
 ext4_file_write_iter+0x299/0x1c10 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x629/0xba0 fs/read_write.c:688
 ksys_pwrite64 fs/read_write.c:795 [inline]
 __do_sys_pwrite64 fs/read_write.c:803 [inline]
 __se_sys_pwrite64 fs/read_write.c:800 [inline]
 __x64_sys_pwrite64+0x19c/0x230 fs/read_write.c:800
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f763ba4ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7639c7d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f763bcc6090 RCX: 00007f763ba4ce59
RDX: 0000000000000001 RSI: 0000200000000140 RDI: 0000000000000004
RBP: 00007f763bae2d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000002cf2 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f763bcc6128 R14: 00007f763bcc6090 R15: 00007ffe7dfe22b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ext4_write_inline_data+0x43c/0x440 fs/ext4/inline.c:240
Code: c1 38 c1 0f 8c 19 ff ff ff 48 89 df 49 89 d7 e8 7a 1f b0 ff 4c 89 fa e9 06 ff ff ff e8 3d f2 48 ff 90 0f 0b e8 35 f2 48 ff 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f
RSP: 0000:ffffc9000d34f808 EFLAGS: 00010293
RAX: ffffffff827b79eb RBX: 0000000000002cf3 RCX: ffff88803ec71ec0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88804391b8fa R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100bc12881 R12: 000000000000003c
R13: ffffc9000d34f8e0 R14: 0000000000002cf2 R15: ffff88804391b1e8
FS:  00007f7639c7d6c0(0000) GS:ffff888126283000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000813 CR3: 000000003cc4a000 CR4: 00000000003526f0


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
