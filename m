Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794459452;
	b=mrfNKgol7mO7LlLxtnIm6JFqYVCpbu+zM2x3UG/gFTGVi5l1mB6Jx3xfQX9exE1dcetS
	 whXXhvQ52eS58jAl1LLzJ0+ubGF/ZIq8iCohFseLO5rkNRDrFo26RZpr0BBwNuPMzmwuB
	 bcCE33OlXCboKU2LAeOOWfGHbR9w5YHKcpdFEaNWN1q3BDkC8t8tu2xtz0535bYJKjBbH
	 pJqw/zCVIIZf5CkF8Xp8m1i2GL2oqcRZvtgKILtLSMcocs6KaOb8RIc9/SPYKFCFIxmsZ
	 SZFPgCKPVFkXinwslOzEUt6pYkUbecFMzgDCn+eUHTEzBvH42HD9dk3Dxh1YXiK/P3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794459452;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=fnLOXUSQFRSz6MuA8TQ8vh5DEGMpFeRQDhA/DrpotKc=;
	b=R6H5oGTcpQ5Ta1pAQB8EJcp64hJ2PMlF2bvhKeSjWzbrs6+vcj4Oeg6YmOSVmDsY6VGB
	 sSgeMOfeSCzmeruA8i2VFdKlqDnrDtL8rdG1vTFXZL8l2D2Rkx0HkscU/jELUzTIGSJiE
	 HkV47ecsPnED41/Rtvj+sgnLxih6Ah3fR3eJSqyRFqVLhOPIPo+bh99rRBBbtHetn2s8L
	 HoBtPsZnQpLx5G2dQkqlHlpMCDIV/ZIjSaxG32IA+gP5V5XKaRdelUVTkOP0rZxpyZenq
	 dyrTPSInQYQlMXtr0ssqNVcIQqOF6iKkDTGoCv2NIZ33UtVOlVKKm2ZB60BgUQ9Ky4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3153606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:57:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3153606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-5384e381fbbso3158947b6e.2
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 20:57:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794459451; x=1795064251;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnLOXUSQFRSz6MuA8TQ8vh5DEGMpFeRQDhA/DrpotKc=;
        b=jwZBjEbbLe41mC3xlQBlmZG4vXeOu8tua6yfbk6qCrjmc6aKF91/dnR4ZwvARyPpV/
         r5H1G4ifSa2xjqT3VMr2nOF7ycJwX0TWdggH5jM+XBcuIKAbvUcwd6AcQiubnrQePoFw
         EwOdE5grkdAHmluFT3FC3KbXPoJ9ziGnIAjYa1siVNFQ25ZBAVTulNVXOXNOQkpjPn/o
         A6osnIdIj5mMxng7kRf+82sgKNkGF3e8ZuZnI0nTuD1hNG7E4hufEZ40UcnldFwrT4bW
         /wA9z97i6kxxBHljKKZvvlEwWty12JIOtSzuhzVl9FSTbT4UmE9KdtSOSaf/Wyx750X5
         tlvw==
X-Forwarded-Encrypted: i=1; AL+hErGHLNdNq202lAs0c1HfQnMawXRWXuIdnwHoCyEAWZ2QrQYQ12uNHLtsXaChP25NJ42qiWAo5iaFL8aD@vger.kernel.org
X-Gm-Message-State: APuU4Z8zHtM/UGjlGBrZK6wqxEJ2rCYiAgNgoR9A99ficgRwgsZfcxTx
	Dsf0gA+KhO2LsqeQXCnGutoR0PkXgqa0P90AqJVmNBgW456qzFuT857/83ajHWvIi4wTH6H4YC4
	pB7ZHUt+R6GSgWNLQYuzM8ztJELHqM5T+o6A/6pSK8gEzfO9bWiQMIpg4mA0=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e82:b0:4fc:248a:de3b with SMTP id
 5614622812f47-56b96192df6mr3824923b6e.23.1794459450706; Wed, 11 Nov 2026
 20:57:30 -0800 (PST)
Date: Wed, 11 Nov 2026 20:57:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af5473a.7afbdece.117ea2.0025.GAE@google.com>
Subject: [syzbot] [ext4?] WARNING in ext4_journalled_invalidate_folio
From: syzbot <syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    58c1eb84e977 arm64: sdei: Preserve the interrupted context..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10ca51be580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a58b6b4d667e7a61
dashboard link: https://syzkaller.appspot.com/bug?extid=f111db4cb2acd44eb2f4
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b58811580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1277f5fd580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b1ec47537e12/disk-58c1eb84.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3bca0c2b1169/vmlinux-58c1eb84.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a7c49594d5a/Image-58c1eb84.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c1da89a2e5f9/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1280d5fd580000)

AI-generated root cause summary:
When a buffered write fails partially (e.g. short copy due to user page fault)
on an ext4 inode in data=journal mode with blocksize < PAGE_SIZE,
ext4_journalled_write_end() invokes ext4_truncate_failed_write() to discard
blocks allocated past inode->i_size. In data=journal mode, buffers attached to a
folio straddling inode->i_size that are undergoing transaction commit cannot be
invalidated immediately by jbd2_journal_invalidate_folio() and return -EBUSY.
While the normal truncate path (ext4_truncate_down()) calls
ext4_wait_for_tail_page_commit() to wait for the committing transaction before
truncating the page cache, ext4_truncate_failed_write() directly calls
truncate_inode_pages(), causing ext4_journalled_invalidate_folio() to encounter
-EBUSY and trigger a WARN_ON.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=f111db4cb2acd44eb2f4

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: fs/ext4/inode.c:3561 at ext4_journalled_invalidate_folio+0x64/0x6c fs/ext4/inode.c:3561, CPU#1: syz.3.128/5701
Modules linked in:
CPU: 1 UID: 0 PID: 5701 Comm: syz.3.128 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : ext4_journalled_invalidate_folio+0x64/0x6c fs/ext4/inode.c:3561
lr : ext4_journalled_invalidate_folio+0x64/0x6c fs/ext4/inode.c:3561
sp : ffff800099227130
x29: ffff800099227130 x28: 1fffffbff87922c3 x27: ffff800086b75f98
x26: fffffdffc3c91618 x25: 00000000000009c5 x24: 000000000000063b
x23: 0000000000001000 x22: fffffdffc3c91608 x21: fffffdffc3c91600
x20: 000000000000063b x19: 00000000fffffff0 x18: ffff80012364b000
x17: 0000000000000000 x16: 0000000000009800 x15: 0000000000000000
x14: 00000000006b0ec7 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: ffff800089889200 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff8000811b24f8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff8000810a36e4
x2 : 00000000fffffff0 x1 : ffff0000c4d31d80 x0 : 0000000000000000
Call trace:
 ext4_journalled_invalidate_folio+0x64/0x6c fs/ext4/inode.c:3561 (P)
 folio_invalidate mm/truncate.c:140 [inline]
 truncate_inode_partial_folio+0x574/0xb38 mm/truncate.c:261
 truncate_inode_pages_range+0x4e8/0xc9c mm/truncate.c:460
 truncate_inode_pages+0x2c/0x3c mm/truncate.c:526
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_journalled_write_end+0x698/0xa60 fs/ext4/inode.c:1726
 generic_perform_write+0x504/0x7a4 mm/filemap.c:4413
 ext4_buffered_write_iter+0xfc/0x438 fs/ext4/file.c:372
 ext4_file_write_iter+0x1f4/0x1478 fs/ext4/file.c:-1
 do_iter_readv_writev+0x48c/0x6f8 fs/read_write.c:-1
 vfs_writev+0x2a8/0x630 fs/read_write.c:1058
 do_pwritev+0x170/0x2a0 fs/read_write.c:1153
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2 fs/read_write.c:1203 [inline]
 __arm64_sys_pwritev2+0xe4/0x118 fs/read_write.c:1203
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
irq event stamp: 25834
hardirqs last  enabled at (25833): [<ffff800080bff1cc>] kasan_quarantine_put+0xb4/0x1c4 mm/kasan/quarantine.c:234
hardirqs last disabled at (25834): [<ffff800086953878>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:484
softirqs last  enabled at (25130): [<ffff8000800204f4>] __do_softirq+0x14/0x20 kernel/softirq.c:703
softirqs last disabled at (24937): [<ffff8000800204f4>] __do_softirq+0x14/0x20 kernel/softirq.c:703
---[ end trace 0000000000000000 ]---


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
