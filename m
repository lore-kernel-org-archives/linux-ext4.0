Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367EC12D21B
	for <linux-ext4@vger.kernel.org>; Sat, 11 Jul 2026 01:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783733377; cv=none; b=UAsHWsOKhBqNlg5tagsXH9nB/vPkEWI7i61Ah9IaGa3r/HJnMCNWF12MQ5ssMJf5e+zaf14nHQOmRC1tilGquWLHF7yQPJ2jNA3WmPi3fvoDaAlXS2qvMzM/yaZ9cVyrELmZhASUwmT7pgtXZ12xYgY9Hk1o878Qd3fXF+FySFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783733377; c=relaxed/simple;
	bh=bZ8vSwKapDpmEcMHkBO+peiSiS2E/XgcrTa5VImBMGs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cnvbCszreuVnuIcpyNUCHs/4TfNfhAdMLkkVPemH/JgFQJUb2RPwQPe/B2KT4zFJNep9vzg961pvkCXaks26zSIdzXTF4lcsSaYsc4nxFBQYObGNzNOKUP6b+l/atIpJAo+vKRvo2Vj2w9nzipRhZ5miZd3ZGDFgV8Si/6xwwQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-451acf33124so764159fac.0
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 18:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783733375; x=1784338175;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/O3+zFLYKutGnfLXu3OIZFsMm9QJilupY1FpO0OjtrY=;
        b=k2ssx3yK/5xR+7seP3zS4tYUpgaxH+OWQjzzrLx1neYybT54ksXe5SXDWFVw9Rkcd+
         3oWzP2080Jzt0K79LkcOALCcjF23ffA32DqgOFVIMKe+siPwe20MpfjWF2KF+DNczCfX
         VYj9NCuTm6Q5pbe81liJnrFBsaLzzwYslvokel9f1KipEhWBIw9cteflwXny6+lmWiVH
         4/1CWGTyGvg4Sh6aqNvd2S3iY1CVWzhURgLfYw+sEcnY51K7GeTN74feS7niFeLrcQEm
         Qf/skr8m45mPahzpa6reGOSXj8DqcAV7zsXlm9ly/6F2dV2zBBe0NhDCkF2Bg1AqDLAz
         Ufxw==
X-Forwarded-Encrypted: i=1; AFNElJ/n9p9xPdABtQoQM1cuqRRF9IL8Y/Kojjf1IV+nLK4wHuBgo9OmUUsU2aRGgg4r5fCcQnHTDqK3J4L+@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ9p7fisivVIWpgWBLMXuxEmgwH/iUYFXXxhoGlgVzHBZLPb5X
	6RjstW+qGbY+Vr9aSysyQxh89NT8S1tSC0QjK93rLtqe0RXc/btIUPL+vlqEV5FtxNjga1TkT49
	ajva3GSVzn+Dn0SLb+0iCQ8e3YP8zj5wXQIhvQIBwZx4I7iV+IoXFSN/1BPo=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2387:b0:497:e7e2:756e with SMTP id
 5614622812f47-4a42aca9d0emr1052338b6e.13.1783733375235; Fri, 10 Jul 2026
 18:29:35 -0700 (PDT)
Date: Fri, 10 Jul 2026 18:29:35 -0700
In-Reply-To: <6a27cb2a.39669fcc.33b062.008b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a519c7f.278cdcd2.e885.000c.GAE@google.com>
Subject: Re: [syzbot] [ext4?] kernel BUG in ext4_write_inline_data (5)
From: syzbot <syzbot+53c8bd6136cfbe85197e@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    a635d6748234 Merge tag 'v7.2-rc2-smb3-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c8b0b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8578cb30af0c1c29
dashboard link: https://syzkaller.appspot.com/bug?extid=53c8bd6136cfbe85197e
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d41346580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5cfb3b35578d/disk-a635d674.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f49a13f1718/vmlinux-a635d674.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1c79dac0ba82/bzImage-a635d674.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e19a0b652c4c/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=125ac0b9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53c8bd6136cfbe85197e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ext4/inline.c:240!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 6277 Comm: syz.5.64 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:ext4_write_inline_data+0x40b/0x4f0 fs/ext4/inline.c:240
Code: fe e8 e9 e7 36 ff 42 8d 44 23 c4 bb 3c 00 00 00 89 44 24 08 44 29 e3 e9 aa fe ff ff e8 ce e7 36 ff 90 0f 0b e8 c6 e7 36 ff 90 <0f> 0b e8 be e7 36 ff 48 8d 3d f7 52 56 0e 48 c7 c2 e0 95 ed 8b 4c
RSP: 0018:ffffc90003d7f8e0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000078 RCX: ffffffff82d2c53b
RDX: ffff8880280cdd00 RSI: ffffffff82d2c75a RDI: ffff8880280cdd00
RBP: ffff88807127e000 R08: 0000000000000006 R09: 0000000000000080
R10: 000000000000003c R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000080 R14: ffffc90003d7f980 R15: ffff88807127e58a
FS:  00007f45fb4396c0(0000) GS:ffff888123eed000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff59e5b7000 CR3: 000000007855a000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ext4_write_inline_data_end+0x2a8/0xdb0 fs/ext4/inline.c:825
 ext4_da_write_end+0x51e/0xe70 fs/ext4/inode.c:3305
 generic_perform_write+0x513/0xa40 mm/filemap.c:4379
 ext4_buffered_write_iter+0xdc/0x3b0 fs/ext4/file.c:316
 ext4_file_write_iter+0xa2f/0x1cb0 fs/ext4/file.c:735
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6ac/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45fa59de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f45fb439028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f45fa825fa0 RCX: 00007f45fa59de59
RDX: 0000000000000078 RSI: 00002000000000c0 RDI: 0000000000000004
RBP: 00007f45fa633e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f45fa826038 R14: 00007f45fa825fa0 R15: 00007fff8e2c70e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ext4_write_inline_data+0x40b/0x4f0 fs/ext4/inline.c:240
Code: fe e8 e9 e7 36 ff 42 8d 44 23 c4 bb 3c 00 00 00 89 44 24 08 44 29 e3 e9 aa fe ff ff e8 ce e7 36 ff 90 0f 0b e8 c6 e7 36 ff 90 <0f> 0b e8 be e7 36 ff 48 8d 3d f7 52 56 0e 48 c7 c2 e0 95 ed 8b 4c
RSP: 0018:ffffc90003d7f8e0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000078 RCX: ffffffff82d2c53b
RDX: ffff8880280cdd00 RSI: ffffffff82d2c75a RDI: ffff8880280cdd00
RBP: ffff88807127e000 R08: 0000000000000006 R09: 0000000000000080
R10: 000000000000003c R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000080 R14: ffffc90003d7f980 R15: ffff88807127e58a
FS:  00007f45fb4396c0(0000) GS:ffff888123ded000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff59e5b6000 CR3: 000000007855a000 CR4: 0000000000350ef0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
