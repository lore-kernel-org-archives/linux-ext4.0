Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520FD3AA1A8
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 20:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532558; cv=none; b=QRFxJMyQz/t2hLGWXH5Bg9LXvt43zQ3uKWdfRx1mkrlEdc/ym7hnYALe71MHNKWPoeMxp8RNI1Axvt6rdZg9Gc7c64WF1F4BGscrvI4Yn5OcBQG08vHPutBmf8so6DhiPJnIucqC84XXgZTqtuz9tWkYZrp7b7x8oLVC4Au284M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532558; c=relaxed/simple;
	bh=SoPmw+VXUfhLjD5912x7QQY0x76p4tblSzGvtnUg72g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=typRXvjd7clRewkwmobauZV+oP2gNWbpSnuSrR7k6czW9DVuUwmQzbk3D50sze5OxefMiqSzv+W1e/GVpWProqmyhCu0/92nQ+hdvYkt2wXoCZYQKhtJhRNHbnJVIV7pJJ8urbIwxuzaqczg9gGyvN4xxMuSluhSLMoEeArygWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7de442b3402so9968786a34.3
        for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 13:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778532556; x=1779137356;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99nJ+y4hv8yCMmT45OGJ+EZML6MewLrbPCDP+fhWm10=;
        b=LwnMn1nUr6+rwduH7MLS/7oq7iZKAMH6Ql5WNda3Vja6Q75L9pYPN/xEEQ1NFTemWW
         Z4rHRbaEaH6M1mpCUUE0xgIaoBS2fUQYgCS+R+aaLHJYJOOwkZgKxcAO8IR8kO2tPZ7d
         EvxoQd5luMvkFCH77TE/rH058rXgfHQmkR/ui2EoLCC5NmW1JUijsC+KgWhf7FVFNITD
         Dc2WaZoQbgjS1vQCiAPZKSz7C31syhljkeq2XrAIcm1nfL7vpJWGxWm5+f3KkMKXFYDH
         myPdzLtC0KeegLBR8VCnqanRsbpXdRDOeyJZUPMxQR569Mjy55YznrDO0CdUn47WTHuU
         WPFw==
X-Forwarded-Encrypted: i=1; AFNElJ+fK69PgO1/K2wlapQPsFvnq6sG0qVWSIDg0dafu9UbbQ8fzZrzEbS4sK54vbP9wgWljtGGKBZiKIQV@vger.kernel.org
X-Gm-Message-State: AOJu0YwFt4dUHN1wWv4eB3bO1zMAtRKeGwt1O6we3HusR/jJbGty/jWp
	68Vq4Gpk8tsThMQ8dgED7ZLVTeaD5ueazFipfPWcg1OEotQDdWxyQ3QicVsMjMBCkbDy1qr11iQ
	IU3qji2Kz8w1fWqVqsR4NhGH9nYecotmHjpOWXluI044mij/7kArGkKXlbsA=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:208e:b0:695:818c:e56a with SMTP id
 006d021491bc7-69b69e5a828mr17611eaf.27.1778532556361; Mon, 11 May 2026
 13:49:16 -0700 (PDT)
Date: Mon, 11 May 2026 13:49:16 -0700
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0240cc.170a0220.7f9b3.0002.GAE@google.com>
Subject: [syzbot ci] Re: fs: Fix missed inode write during fsync
From: syzbot ci <syzbot+ci10e571aa5fa42db7@syzkaller.appspotmail.com>
To: aivazian.tigran@gmail.com, brauner@kernel.org, dsterba@suse.com, 
	hirofumi@mail.parknet.co.jp, jack@suse.cz, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, tytso@mit.edu
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: Fix missed inode write during fsync
https://lore.kernel.org/all/20260511115725.28441-1-jack@suse.cz
* [PATCH 1/9] affs: Drop support for metadata bh tracking
* [PATCH 2/9] ext4: Allocate mapping_metadata_bhs struct on demand
* [PATCH 3/9] fs: Writeout inode buffer from mmb_sync()
* [PATCH 4/9] ext2: Fix possibly missing inode write on fsync(2)
* [PATCH 5/9] udf: Fix possibly missing inode write on fsync(2)
* [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
* [PATCH 7/9] minix: Fix possibly missing inode write on fsync(2)
* [PATCH 8/9] bfs: Fix possibly missing inode write on fsync(2)
* [PATCH 9/9] ext4: Use mmb infrastructure for inode buffer writeout

and found the following issue:
KASAN: null-ptr-deref Write in write_dirty_buffer

Full report is available here:
https://ci.syzbot.org/series/d987d2d8-3775-4aa9-959f-8a045778888c

***

KASAN: null-ptr-deref Write in write_dirty_buffer

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      5d6919055dec134de3c40167a490f33c74c12581
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/567d596c-ca65-43c9-bd7d-1e60cfe9da2a/config
syz repro: https://ci.syzbot.org/findings/1bc13af8-2d91-4fbd-b43e-fbe72f29ca41/syz_repro

EXT4-fs (loop2): unmounting filesystem 00000000-0000-0000-0000-000000000000.
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
BUG: KASAN: null-ptr-deref in test_and_set_bit_lock include/asm-generic/bitops/instrumented-lock.h:57 [inline]
BUG: KASAN: null-ptr-deref in trylock_buffer include/linux/buffer_head.h:425 [inline]
BUG: KASAN: null-ptr-deref in lock_buffer include/linux/buffer_head.h:431 [inline]
BUG: KASAN: null-ptr-deref in write_dirty_buffer+0x37/0x190 fs/buffer.c:2760
Write of size 8 at addr 0000000000000000 by task syz-executor/5742

CPU: 1 UID: 0 PID: 5742 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
 test_and_set_bit_lock include/asm-generic/bitops/instrumented-lock.h:57 [inline]
 trylock_buffer include/linux/buffer_head.h:425 [inline]
 lock_buffer include/linux/buffer_head.h:431 [inline]
 write_dirty_buffer+0x37/0x190 fs/buffer.c:2760
 mmb_sync+0x74c/0xed0 fs/buffer.c:603
 ext4_evict_inode+0x2fa/0x1040 fs/ext4/inode.c:199
 evict+0x61e/0xb10 fs/inode.c:841
 ext4_quota_off+0x470/0x580 fs/ext4/super.c:7326
 ext4_quotas_off fs/ext4/super.c:1195 [inline]
 ext4_put_super+0xdf/0xd80 fs/ext4/super.c:1306
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:646
 kill_block_super+0x44/0x90 fs/super.c:1725
 ext4_kill_sb+0x68/0xb0 fs/ext4/super.c:7494
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd8d1b9e017
Code: a2 c7 05 dc 06 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffef04ebf88 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fd8d1c32120 RCX: 00007fd8d1b9e017
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffef04ec040
RBP: 00007ffef04ec040 R08: 00007ffef04ed040 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffef04ed0d0
R13: 00007fd8d1c32120 R14: 0000000000014595 R15: 00007ffef04ed110
 </TASK>
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
