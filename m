Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811442F39CE
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220400; cv=none; b=n5Ar1g/up9ztLeWPnNd0gxwbMggXheoX6FIwIHD5kVpwb1qp4ihkhQ6IdRnulAewUQuzH21XId1+12Qhq9TKR6rUI23EXHgo3FEzgae1Stf0VPC49kcjyYINjRZdtSk0k7bcBqCVzRBtQgNb5cf6uGei1fUSyZX2jHp2V7ugzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220400; c=relaxed/simple;
	bh=kA+UIsNS62YX12orZbM8JTTK7tZpQBCweb+L8j6v3Ro=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ESgIWkvJY7fgQ6hYlhVYp+DYXdGRbfNNXhMM4Dy1N8Lch/rOM4zvP0NiUQOom1xWZ2UDtAzBRQb7HLH5Dcmx1FG8VkfVKmi+ABh3z4J5dYCPYudq9eKfJKUOJG3vnJuFoYON70Qvr7hxdECBeiVSFK26FJsuLhue9C2hdS24bzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e7624e584dso10494134a34.2
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 06:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220398; x=1782825198;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFXXWE9fBxsiphisMz3jKhcIk0QDsz2y2XoZ0YQGi0I=;
        b=YhyRKpo0f/iUUIGVUnJO5yFISGb7516t8YsHIt6CYkE3vQ0wOfK/GqYPcEMgtMdjlZ
         P2quSSvqfkHLEfj60vsY2Z/ltAetXElMYVp1KbUZ4kgbJg0ws5hsGIveJh7k9Sz7i6iO
         FD9Bn8BjLUr35X85l40HDd1yH8uWKs9X/EXEN7Wr1d22ayPtc9AhRO+TFotwLJ9/Pr0i
         yQgXUmBCJBdOMt7ypsNa3YBTMshnAyp/kpBLUoQuxicj5akIUf4kXJ9AQOE9DZbdRQjP
         yQkF/V5tqX0cjJaGCz2YyZBFH9Khl1WeoLxJnDmZgNt1Xbo3IPGZCbrHk0GC5TLVjTf7
         lOfg==
X-Forwarded-Encrypted: i=1; AFNElJ8yzx9tGmHJXszgf5AUV1U1POYYH7MbztQWk2W6m9JXv0apLnK5is86tTmvs7kSR+u3ODZ1Uhp9/tAi@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl1Fhu+mviUg+B8Nn5x6UIFcPbo5ab6H+cHMmlIYy4uxpwNqAT
	7fWgR+49QE4y8YmLe+gl59l50vR9iwXu4e5z/MKt0Ky1gazUGWyi8olsfg46eyNK3EmQ8E0Z7Tq
	9znyQYffo6wIO9js3i5MGJ3muuBjTlCu5SHnQWGS0kvzFJyHCNtBGyJSJ6mg=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1f7:b0:489:443d:a8ed with SMTP id
 5614622812f47-4896ac4a91amr16299113b6e.32.1782220398523; Tue, 23 Jun 2026
 06:13:18 -0700 (PDT)
Date: Tue, 23 Jun 2026 06:13:18 -0700
In-Reply-To: <20260623083540.2744885-1-yun.zhou@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3a866e.c358b6d0.89040.0003.GAE@google.com>
Subject: [syzbot ci] Re: ext4: deferred iput framework for EA inodes
From: syzbot ci <syzbot+ci7b0958cccc507600@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, tytso@mit.edu, 
	yi.zhang@huawei.com, yun.zhou@windriver.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v9] ext4: deferred iput framework for EA inodes
https://lore.kernel.org/all/20260623083540.2744885-1-yun.zhou@windriver.com
* [PATCH v9 1/4] fs: add iput_if_not_last() helper
* [PATCH v9 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
* [PATCH v9 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
* [PATCH v9 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

and found the following issue:
WARNING: ODEBUG bug in flush_delayed_work

Full report is available here:
https://ci.syzbot.org/series/acc1a7bd-816f-451e-86ee-a62f88ad8fcc

***

WARNING: ODEBUG bug in flush_delayed_work

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      502d801f0ab03e4f32f9a33d203154ce84887921
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/79d2cdf0-fde6-4e70-a88c-04d44c9d3e44/config
syz repro: https://ci.syzbot.org/findings/9b2e3f5d-279a-469f-9f2a-05f96ea11587/syz_repro

EXT4-fs warning (device loop2): ext4_multi_mount_protect:287: Invalid MMP block in superblock
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object: ffff8881bf08c9e0 object type: timer_list hint: 0x0
WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230 lib/debugobjects.c:629, CPU#1: syz.2.19/5833
Modules linked in:
CPU: 1 UID: 0 PID: 5833 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:debug_print_object+0x18a/0x230 lib/debugobjects.c:629
Code: f8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ff e8 5d 04 71 fd 4d 8b 0f 4c 89 ef 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f0 ff 34 24 <67> 48 0f b9 3a 48 83 c4 08 ff 05 a3 23 70 0b 48 83 c4 10 5b 41 5c
RSP: 0018:ffffc9000179f848 EFLAGS: 00010046

RAX: 1ffffffff179eacc RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffffffff8c2a9980 RSI: ffffffff8c2a93e0 RDI: ffffffff903ddbf0
RBP: ffffffff8c2a9980 R08: ffff8881bf08c9e0 R09: ffffffff8bcf69c0
R10: dffffc0000000000 R11: ffffffff81b25990 R12: 0000000000000000
R13: ffffffff903ddbf0 R14: ffff8881bf08c9e0 R15: ffffffff8bcf5660
FS:  00007fd11e12e6c0(0000) GS:ffff8882a922d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe46d80f88 CR3: 00000001bf40e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 debug_object_assert_init+0x237/0x370 lib/debugobjects.c:1075
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __try_to_del_timer_sync kernel/time/timer.c:1457 [inline]
 __timer_delete_sync+0x181/0x520 kernel/time/timer.c:1621
 flush_delayed_work+0x48/0x100 kernel/workqueue.c:4414
 ext4_drain_ea_inode_work fs/ext4/xattr.h:196 [inline]
 __ext4_fill_super fs/ext4/super.c:5795 [inline]
 ext4_fill_super+0x54c7/0x66d0 fs/ext4/super.c:5844
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd11d19e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd11e12de58 EFLAGS: 00000246
 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fd11e12dee0 RCX: 00007fd11d19e0ca
RDX: 0000200000000400 RSI: 0000200000000340 RDI: 00007fd11e12dea0
RBP: 0000200000000400 R08: 00007fd11e12dee0 R09: 000000000021c91c
R10: 000000000021c91c R11: 0000000000000246 R12: 0000200000000340
R13: 00007fd11e12dea0 R14: 000000000000051a R15: 0000200000000240
 </TASK>
----------------
Code disassembly (best guess):
   0:	f8                   	clc
   1:	48 c1 e8 03          	shr    $0x3,%rax
   5:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   9:	74 08                	je     0x13
   b:	4c 89 ff             	mov    %r15,%rdi
   e:	e8 5d 04 71 fd       	call   0xfd710470
  13:	4d 8b 0f             	mov    (%r15),%r9
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  1e:	48 89 ea             	mov    %rbp,%rdx
  21:	44 89 e1             	mov    %r12d,%ecx
  24:	4d 89 f0             	mov    %r14,%r8
  27:	ff 34 24             	push   (%rsp)
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 83 c4 08          	add    $0x8,%rsp
  33:	ff 05 a3 23 70 0b    	incl   0xb7023a3(%rip)        # 0xb7023dc
  39:	48 83 c4 10          	add    $0x10,%rsp
  3d:	5b                   	pop    %rbx
  3e:	41 5c                	pop    %r12


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
