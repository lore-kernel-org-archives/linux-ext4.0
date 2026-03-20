Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0354259CB2
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 10:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774002446; cv=none; b=EYNM+xHtdcROWLLcS/rC9CIAYjzmy/jaFAWzhRYQMi7hPtepVmu28Tpm7IiIW8qQHm9Kv9KtlhysSLtz4dpmaTfhtReZXy/3GRlgEL/1lS+djFvVoVKlA6YIBol1azK9DEHiH5bHNqhlZy0S16MGp+JrqZMDQTL53vzYeqE9wFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774002446; c=relaxed/simple;
	bh=imOwnv2Cbz22Ws/05tLd2xt72S1UsRmM78MAIuAH+Vw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=jD87526EcUr2AuWexeamm+tgm4YVvqxmXA1k1IW7P3kx/LP99xTc4+3CN2uVKDXl9ZyOoB18SADVEtNiNPwEFnQpELYtfq0qoKe7zxGBu/+Tt6/HxoaXuayYGcab5DxbjQrbBJIxSUn5p7W3cZLKv8U96ttWig52WMNuYPqOPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679c5ed0942so20931147eaf.1
        for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 03:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774002444; x=1774607244;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2LdeuSx+OigkkOPyuviLWPLZ0CDnj0BK3QxBJMRGfU=;
        b=GzPIDoVfKoa7UZ4BEDxrjhy59TuSlAhLQ3ijK4S88p7AoLgDpMcrk+hB1l5XiKHcF1
         6Thj0Q4WfjbLsLkQJENxsUSQpzfw05oRu9AknIC0Op9YYrGwB3o1dL9GH1hAdlebmiAg
         aohJyGZW8hJPS881RVTvujfk07gdkJTGfW/pVkKZIF7kDtkhc/fzNgCDL18z13dJWhZF
         ocwxW0KN21gEkgERSmTaCGa1fAm8FtZlC66y0Bmo+x26mh3fZVTEDZ3P06edN5Xypi11
         6T6MWXpfhtGQ3WbKttM7QYtzYCeWYbhD1c05sgmwdatEQpWhTRQDHbkWSpGjTKvDXJdr
         CMaA==
X-Forwarded-Encrypted: i=1; AJvYcCX+LR5QFWed+9u8F1p12uM3siglO/6SBkNZKe/7McPjcW8HSzhoRJaKu4clDg2I33UCPVdbwy6hOv10@vger.kernel.org
X-Gm-Message-State: AOJu0YwY6tvYf5pKnZxwvMGBhLtBBisdEMMbDFogVBTfsAAzYnBx9abx
	JTPrlx3bmM71rO+7KrXvWZS6pfB3m+f6ukH+DKjXG1WUk17sNxp72t6i5esZvZb+bSg9rH5axai
	R1h+cTB9xl8LFta7AI1kUGDxsyOp/8EbyUXbT4+NXjxHaBsrtsnZvDP+6U08=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d4a:b0:67c:1d0b:d64f with SMTP id
 006d021491bc7-67c22f743d1mr1763235eaf.37.1774002443879; Fri, 20 Mar 2026
 03:27:23 -0700 (PDT)
Date: Fri, 20 Mar 2026 03:27:23 -0700
In-Reply-To: <20260319073651.79209-1-jiayuan.chen@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bd210b.050a0220.3bf4de.001a.GAE@google.com>
Subject: [syzbot ci] Re: ext4: fix use-after-free in update_super_work when
 racing with umount
From: syzbot ci <syzbot+cid9716702bbf43cf2@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, jiayuan.chen@linux.dev, 
	jiayuan.chen@shopee.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, riteshh@linux.ibm.com, tytso@mit.edu, 
	yebin10@huawei.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] ext4: fix use-after-free in update_super_work when racing with umount
https://lore.kernel.org/all/20260319073651.79209-1-jiayuan.chen@linux.dev
* [PATCH v2] ext4: fix use-after-free in update_super_work when racing with umount

and found the following issue:
WARNING in ext4_notify_error_sysfs

Full report is available here:
https://ci.syzbot.org/series/3b258c63-ea54-492a-ab47-c09e62612658

***

WARNING in ext4_notify_error_sysfs

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0e4f8f1a3d081e834be5fd0a62bdb2554fadd307
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8149e3c8-4cb9-4fa0-9bf5-3d6deda6899d/config
C repro:   https://ci.syzbot.org/findings/6f6eafc6-a231-4909-9025-539fa10ffcfd/c_repro
syz repro: https://ci.syzbot.org/findings/6f6eafc6-a231-4909-9025-539fa10ffcfd/syz_repro

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:593 at __mutex_lock_common kernel/locking/mutex.c:593 [inline], CPU#1: kworker/1:4/5883
WARNING: kernel/locking/mutex.c:593 at __mutex_lock+0x10a4/0x1300 kernel/locking/mutex.c:776, CPU#1: kworker/1:4/5883
Modules linked in:
CPU: 1 UID: 0 PID: 5883 Comm: kworker/1:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events update_super_work

RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:593 [inline]
RIP: 0010:__mutex_lock+0x10ab/0x1300 kernel/locking/mutex.c:776
Code: 11 90 48 c1 e8 03 42 0f b6 04 28 84 c0 0f 85 33 02 00 00 83 3d d9 e1 61 04 00 75 13 48 8d 3d 1c f7 64 04 48 c7 c6 c0 e0 cc 8b <67> 48 0f b9 3a 90 e9 ac f0 ff ff 90 0f 0b 90 e9 73 f4 ff ff 90 0f
RSP: 0018:ffffc90004dcf900 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff920009b9f38 RCX: ffff888172d3d7c0
RDX: 0000000000000000 RSI: ffffffff8bcce0c0 RDI: ffffffff9014ec10
RBP: ffffc90004dcfaa8 R08: ffffffff9011d6c3 R09: 1ffffffff2023ad8
R10: dffffc0000000000 R11: fffffbfff2023ad9 R12: ffff888172218368
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8882a945d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562af42c7d40 CR3: 0000000111346000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ext4_notify_error_sysfs+0x23/0xa0 fs/ext4/sysfs.c:600
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	11 90 48 c1 e8 03    	adc    %edx,0x3e8c148(%rax)
   6:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax
   b:	84 c0                	test   %al,%al
   d:	0f 85 33 02 00 00    	jne    0x246
  13:	83 3d d9 e1 61 04 00 	cmpl   $0x0,0x461e1d9(%rip)        # 0x461e1f3
  1a:	75 13                	jne    0x2f
  1c:	48 8d 3d 1c f7 64 04 	lea    0x464f71c(%rip),%rdi        # 0x464f73f
  23:	48 c7 c6 c0 e0 cc 8b 	mov    $0xffffffff8bcce0c0,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	e9 ac f0 ff ff       	jmp    0xfffff0e1
  35:	90                   	nop
  36:	0f 0b                	ud2
  38:	90                   	nop
  39:	e9 73 f4 ff ff       	jmp    0xfffff4b1
  3e:	90                   	nop
  3f:	0f                   	.byte 0xf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
