Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0090397AF2
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781078823; cv=none; b=YTB+NV9nwduwMCSuuZ22/MnUw+/gWiX9R7yzzEtS9uyM1AmxpT+cNQIrKQFv1//0O//aHDkZ9AyYOb0f1mAdetBj3tHzfv2BBbLmDoNxuafhMqDVdGlNcBw0vCiFVpUXxoLdNYlIZri2bGLv9rjkUzYOApHgb+O3Gh6Ry8l0CKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781078823; c=relaxed/simple;
	bh=GgzuIiBJVwDjUKxEOD0V6pexDkrGOU4Ft8K5cfbOPnk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZVnx5BL//etOHKsCXcuumefHJZdIZocVTwhzPD4ib+Lowho5JcZclwPNReNGxwHxgsEm24YNjpqTBZK52ohXXUGRGd18RA8wQ9OSpjmEPc4yHPFmFhV0U0thZMZMS+8uo19AWzjWwnwJoCGZVJwGcgElFqFBjvJ8dkXOxP01rJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-69e1eb09b3aso6471883eaf.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 01:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781078820; x=1781683620;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qjC+msim6OOYa5iJHDF+iSR9zraFZ9832S+rgK2FA4=;
        b=VXlz8vz/ayFYwZuRErEb9fMK4MgAH9V8Uji+iCW0/MEjEHvPd7946kuV2klbwWwtJ7
         xf/qdWH+248X0f8TqzAHiFmh6XAd4nm+eQcJ1emFGj+H3hqyb0JaIXpkZTh+zSSuw0AA
         y3DQ5Akrz8og8m35Ko7pBXxRMKBp++cS5r3Tyc141twizF5CYYSez7L0VFo4s/OHlJW0
         xjgyZqbFqRbJy6fntQKOQO9m+bMWaWKfrpaAwq3SEpfkwErlSh8l7QPBmjI9pHvkqk1o
         3QRsmUtukGn3sa+uIDcIpCxVPgj26BIlCxHZaR/d3nUfo2GCMgUtTyre0XhhiikDAQIk
         0Rxg==
X-Forwarded-Encrypted: i=1; AFNElJ+/rFe2sw7E6KXcGXmvsdcmoMYuwHC/4em/HTMOskA/DH6c2HAUs0vXJMGXbpMNr/uM4Bhv61YHetTE@vger.kernel.org
X-Gm-Message-State: AOJu0YykNkoIAY+6L7nOwUTiidJB91o7o7TzJx3jh0cC/m2rqI12GHIl
	l3StHKR9xu3jWSHFyAfH1p0I65iLRejRcyWNBw2AWKecwCPydDFU33dqZ0lRRpEqr/XGh8WFxcN
	+5+KXCG3K6f7uq9EIaphE1yD18n4neFEQ06kTIC7FUkc5X2p+S/PBkLLcOKA=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:413:b0:67e:251a:bd3e with SMTP id
 006d021491bc7-69e68b5f6f6mr11040870eaf.18.1781078819942; Wed, 10 Jun 2026
 01:06:59 -0700 (PDT)
Date: Wed, 10 Jun 2026 01:06:59 -0700
In-Reply-To: <20260609154505.2104659-1-yun.zhou@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a291b23.39669fcc.33b062.00b8.GAE@google.com>
Subject: [syzbot ci] Re: ext4: move inline data cleanup to ext4_writepages to
 fix deadlock
From: syzbot ci <syzbot+ci90e884a7832b9713@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, daeho.jeong@samsung.com, jack@suse.cz, 
	libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	tytso@mit.edu, yi.zhang@huawei.com, yun.zhou@windriver.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext4: move inline data cleanup to ext4_writepages to fix deadlock
https://lore.kernel.org/all/20260609154505.2104659-1-yun.zhou@windriver.com
* [PATCH] ext4: move inline data cleanup to ext4_writepages to fix deadlock

and found the following issue:
kernel BUG in ext4_writepages

Full report is available here:
https://ci.syzbot.org/series/1ede6029-df2a-4e08-bffc-05540c1f4934

***

kernel BUG in ext4_writepages

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2d3090a8aeb596a26935db0955d46c9a5db5c6ce
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63ee0324-2d17-4b32-aca2-c6230ff64be6/config
syz repro: https://ci.syzbot.org/findings/676a447c-ea73-43ea-9949-054dac1961e5/syz_repro

EXT4-fs warning (device loop2): ext4_expand_extra_isize_ea:2860: Unable to expand inode 15. Delete some EAs or run e2fsck.
------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:3047!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5875 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ext4_writepages+0x622/0x630 fs/ext4/inode.c:3046
Code: ff e9 61 fc ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c de fc ff ff 4c 89 f7 e8 f9 2f a8 ff e9 d1 fc ff ff e8 ef d7 3c ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900034df2e0 EFLAGS: 00010293
RAX: ffffffff8288dfb1 RBX: 1ffff9200069be60 RCX: ffff888110555940
RDX: 0000000000000000 RSI: 0000004000000000 RDI: 0000000000000000
RBP: ffffc900034df410 R08: ffff8881b48c2f0f R09: 1ffff110369185e1
R10: dffffc0000000000 R11: ffffed10369185e2 R12: dffffc0000000000
R13: 0000004000000000 R14: 0000004610000000 R15: 1ffff11020c6fcc5
FS:  00007f033e9346c0(0000) GS:ffff8882a92a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005556842f3058 CR3: 000000016d5c0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_writepages+0x32e/0x550 mm/page-writeback.c:2571
 __writeback_single_inode+0x133/0x10e0 fs/fs-writeback.c:1764
 writeback_single_inode+0x4ac/0xdc0 fs/fs-writeback.c:1883
 write_inode_now+0x1c2/0x290 fs/fs-writeback.c:2974
 iput_final fs/inode.c:1950 [inline]
 iput+0x8c1/0xe80 fs/inode.c:2009
 ext4_orphan_cleanup+0xc38/0x1470 fs/ext4/orphan.c:472
 __ext4_fill_super fs/ext4/super.c:5701 [inline]
 ext4_fill_super+0x5a19/0x6330 fs/ext4/super.c:5824
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3758 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3834
 do_mount fs/namespace.c:4167 [inline]
 __do_sys_mount fs/namespace.c:4383 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f033d99e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f033e933e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f033e933ee0 RCX: 00007f033d99e0ca
RDX: 0000200000000040 RSI: 00002000000016c0 RDI: 00007f033e933ea0
RBP: 0000200000000040 R08: 00007f033e933ee0 R09: 000000000000840e
R10: 000000000000840e R11: 0000000000000246 R12: 00002000000016c0
R13: 00007f033e933ea0 R14: 000000000000042f R15: 0000200000000080
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ext4_writepages+0x622/0x630 fs/ext4/inode.c:3046
Code: ff e9 61 fc ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c de fc ff ff 4c 89 f7 e8 f9 2f a8 ff e9 d1 fc ff ff e8 ef d7 3c ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900034df2e0 EFLAGS: 00010293
RAX: ffffffff8288dfb1 RBX: 1ffff9200069be60 RCX: ffff888110555940
RDX: 0000000000000000 RSI: 0000004000000000 RDI: 0000000000000000
RBP: ffffc900034df410 R08: ffff8881b48c2f0f R09: 1ffff110369185e1
R10: dffffc0000000000 R11: ffffed10369185e2 R12: dffffc0000000000
R13: 0000004000000000 R14: 0000004610000000 R15: 1ffff11020c6fcc5
FS:  00007f033e9346c0(0000) GS:ffff8882a92a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005556842f3058 CR3: 000000016d5c0000 CR4: 00000000000006f0


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
