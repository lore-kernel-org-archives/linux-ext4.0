Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBFC2F12A1
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785207874; cv=none; b=YTYkN0q2OeyHP3sCC9uqiVngurT7sa0BQikwdgpFTi3xwtPK0nQXRzSWn11CrSehMnHQlsIKiujHQHSH9pYKCNDMmQCIpNgfdngI4cowBYDem+vqpJYDnlu8CAnUy6GWmMaEqWkJnG9Gnk6O0AuOqS/O+Z1BqzsbZ1R/cUwVRpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785207874; c=relaxed/simple;
	bh=qLr2Y/g4nipkauji2O4Id18ILEO/733VIthX8RgUaxE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aHD/mF121f1qPVkKWY3Eo0GiWe/EPtoUG/5uyKi9/9E/6BmRIlsP3rcchJu1hZaqUetNRIjv3kxKK700pMJDagxkLos0LolgcWYZ6F96gtJx/yVAhDZk/bAwyZA8Q9hw6QbISKEnEsDvu5Hc48WBVJTE2h/z8fWLUjBLUmA+3gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7e6b5976d74so4674539a34.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 20:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785207871; x=1785812671;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UDtlfXbxYb45YdZ78VZAhiv8+49xkuuaQ8XEJhBorzU=;
        b=H8kbev93ReW7ojJIg0vTAWNJM1tXpXIYQeroMIw/r3kKtAOuJKLcgX85b+O9WlcEYV
         IdlcoG+NoaOKQ1kNxKzNgLh2hWO5JodpMiJxG+wHJnba/fwpNbD0OoKr90hPBgJkJaJE
         WF7j4pItTKt9KohG6i4XJHSouJIZ15oTJQwlix7JVhL2j5AWwZEnNI3SXnRMFlA0arwE
         iQ5wwShRR+ZUuOhet2lggfgNpphha+8lgW67RdUHUk5usN5/9gCY8i39v8zrqQxxL5JG
         A+mR8oV4Mb8G4c97R+0zZAdcrnXQlrevJ+/SxW6iXDTtZxVDytkf+khIpWXuyVeHb64Z
         QcoQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Z15Hj61HFOZayKTWobLRynR8DuzGWYwnrewV8VJkgjS5Pyqmesd6xaXAMk2eBnbqOb0g5YLHv7m4@vger.kernel.org
X-Gm-Message-State: AOJu0YwAB/fxpihIVkYOXKERNzgd8gtCbIHqVP08g67kcs/hzj2Cpce2
	C+z4x35ChgGOmg62XGyK6aWmFO/mpRwtW+ML55TsLEoszHgpZ0jJ+Q9J0Rf+JHqBrTsItuOhhml
	3oI/cmJEFhimHWgIAOU2R1m6EOv8Lk6iVOASEFHkG858YN8ga2WZfG9Ix/tk=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b02:b0:6a1:50eb:2110 with SMTP id
 006d021491bc7-6ac96ce1d5fmr364109eaf.69.1785207871690; Mon, 27 Jul 2026
 20:04:31 -0700 (PDT)
Date: Mon, 27 Jul 2026 20:04:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a681c3f.70955b6c.323240.0050.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in __ext4_handle_dirty_metadata
From: syzbot <syzbot+3fee0864af947db7a9c4@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d326f83e819c Merge tag 'net-7.2-rc5' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c75232580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=3fee0864af947db7a9c4
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d326f83e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/754d3e5fbfc7/vmlinux-d326f83e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c70e5cfffd37/bzImage-d326f83e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3fee0864af947db7a9c4@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
------------[ cut here ]------------
!buffer_uptodate(bh)
WARNING: fs/buffer.c:1093 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:1093, CPU#0: syz.0.0/5329
Modules linked in:
CPU: 0 UID: 0 PID: 5329 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:mark_buffer_dirty+0x299/0x410 fs/buffer.c:1093
Code: 4c 89 f7 e8 19 0e d9 ff 49 8b 3e be 40 00 00 00 5b 41 5c 41 5e 41 5f 5d e9 d4 5e fb ff e8 7f e1 69 ff eb 8c e8 78 e1 69 ff 90 <0f> 0b 90 e9 a5 fd ff ff e8 6a e1 69 ff 90 0f 0b 90 e9 cf fd ff ff
RSP: 0018:ffffc9000fcd7420 EFLAGS: 00010287
RAX: ffffffff825ca058 RBX: ffff88801224ad20 RCX: 0000000000100000
RDX: ffffc9000f2a9000 RSI: 00000000000820c2 RDI: 00000000000820c3
RBP: 0000000000001601 R08: ffff88801224ad27 R09: 1ffff110024495a4
R10: dffffc0000000000 R11: ffffed10024495a5 R12: dffffc0000000000
R13: ffff88801224ad20 R14: 0000000000000000 R15: 1ffff110024495a4
FS:  00007f65e6f976c0(0000) GS:ffff88808c546000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000101000 CR3: 0000000012312000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __ext4_handle_dirty_metadata+0x2e3/0x800 fs/ext4/ext4_jbd2.c:396
 ext4_do_update_inode fs/ext4/inode.c:5751 [inline]
 ext4_mark_iloc_dirty+0x15b1/0x1cc0 fs/ext4/inode.c:6404
 __ext4_mark_inode_dirty+0x4a7/0x700 fs/ext4/inode.c:6610
 ext4_write_end+0x553/0x9e0 fs/ext4/inode.c:1481
 ext4_da_write_end+0x89/0xcc0 fs/ext4/inode.c:3297
 generic_perform_write+0x612/0x8f0 mm/filemap.c:4379
 ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
 ext4_file_write_iter+0x947/0x1c70 fs/ext4/file.c:-1
 aio_write+0x5cd/0x870 fs/aio.c:1687
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x798/0x13d0 fs/aio.c:2106
 __do_sys_io_submit fs/aio.c:2165 [inline]
 __se_sys_io_submit+0x195/0x340 fs/aio.c:2135
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65e619de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f65e6f96fe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007f65e6425fa0 RCX: 00007f65e619de99
RDX: 0000200000000540 RSI: 0000000000000008 RDI: 00007f65e6f76000
RBP: 00007f65e6233eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f65e6426038 R14: 00007f65e6425fa0 R15: 00007ffff6e87f78
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
