Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53F73C07A
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 07:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532328; cv=none; b=YNEfmp8bhZwegHOK5elgNJAsU7pXna0yId7RZAAws7KA0pPS1fY9falVeQyyrIJOwB+zOwFH+9ZbWf8A3earQesXjRNBp8VDPMrbPBzHsDoTFTUauK84VVBO4fy3RwNKPkoENBSikOacoM3Se+WN2kT7p1zFI+GD/ZPcbHDXjKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532328; c=relaxed/simple;
	bh=KY0FFu5vOlbLH6ZZNLQ2IW9hmq8jtWlgBVrZrS07mCY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oDM7ekI9nKmqz9fng1v4Qi6EZjFCAm04npZ3/uCWHalVA9QdUAdoUmzHaLkYL8i2Wwm4cMVZvbDoqFljF9TskwdWyf5BS2oslIyZl2hbv5hBZwhSSENAKokdJ5r8cv9kUBgjceE9Bu2vcabGD87wPfPvGsMACk1RbhtfVQcegbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a43d32fa9fso11729158b6e.2
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 00:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784532325; x=1785137125;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xifO8HGQTu9S/8zGEtXXxsudku3lnEmH4DFbHAdHcbQ=;
        b=VWc+xbK3oVnpO6rQQXztnMZR5OjE3mwbkSslwVj/Hx8FicHXX74yxOSFXIxFklLH/z
         PClarqiTHMVYepk8Jhd3T/MNgY8YyZxd/7HKQGpKvtZzRSrza95QuVJiEBgzhS0H/8ZB
         10/q3d0DHQzdOqYgV/u69BONk/XHcp/5ny21TN/VSLbUDVzJX/Hxuq6uyXbjzT5u37AL
         1uzAKN4IPTUcGGM6wB4AdWYmf2p4fS4rLKAHSQTaWrqTMGT0Qc0hcroWZQR8ZjoA615+
         wN2RtVgMCjpV+JptPdnmgmGCyXYgEgmvyeMxWqq/zhN1rndfJPQB+BhmXHb+ycvI+6eo
         ezCQ==
X-Forwarded-Encrypted: i=1; AHgh+RoygoB4auEWZ8zKU9QNr/WJHLbs/FQXOfQNPwhNcBkSlo1rYnyYXvD565sFjn4GQQpU0xC4dJeGRxWa@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt999lJRCKO7y+DhkqTiJYAabqsjhkJkYgl1iqh2StggjYujZp
	b7bt7PkOU+mMwmb4DS1NiQsYiJI8PRYFvlYfDpaAKowfLkOFG4kXQn9V5fTpPia7OTgSt5T4sy1
	QFv1lg6+8Tod2XdNsg1Rc4igMgK3CfWlxdd/bk23/6PhkPBVjRHeh2coxc/k=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:30a9:b0:491:6271:b24e with SMTP id
 5614622812f47-4a4d03fd622mr8737906b6e.32.1784532325672; Mon, 20 Jul 2026
 00:25:25 -0700 (PDT)
Date: Mon, 20 Jul 2026 00:25:25 -0700
In-Reply-To: <20260720034441.3900050-1-rafad900@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5dcd65.5028b7d0.1f0bb.02e3.GAE@google.com>
Subject: [syzbot ci] Re: ext4: convert pa_count from atomic_t to refcount_t
From: syzbot ci <syzbot+ci021c8fe727674a70@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, rafad900@gmail.com, 
	tytso@mit.edu
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext4: convert pa_count from atomic_t to refcount_t
https://lore.kernel.org/all/20260720034441.3900050-1-rafad900@gmail.com
* [PATCH] ext4: convert pa_count from atomic_t to refcount_t

and found the following issue:
WARNING: refcount bug in ext4_mb_use_preallocated

Full report is available here:
https://ci.syzbot.org/series/34fda797-e979-409c-bc2d-7af3e163df14

***

WARNING: refcount bug in ext4_mb_use_preallocated

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/05fa6c1d-a594-4691-ace3-ded3fc2ca4dc/config

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110, CPU#0: kworker/u9:2/51
Modules linked in:
CPU: 0 UID: 0 PID: 51 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:refcount_warn_saturate+0x9f/0x110
Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 8b 73 0c fd 48 8d 3d 34 58 84 0b 67 48 0f b9 3a eb 4a e8 78 73 0c fd 48 8d 3d 31 58 84 0b <67> 48 0f b9 3a eb 37 e8 65 73 0c fd 48 8d 3d 2e 58 84 0b 67 48 0f
RSP: 0018:ffffc90000bb6590 EFLAGS: 00010293
RAX: ffffffff84b9ee08 RBX: 0000000000000002 RCX: ffff8881072a8000
RDX: 0000000000000000 RSI: ffffffff8f126800 RDI: ffffffff903e4640
RBP: ffff888112257dd0 R08: ffff8881072a8000 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888112257d98 R14: ffff888112257e10 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88818dc15000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc831b2c080 CR3: 0000000112724000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ext4_mb_use_preallocated+0xaa0/0x14e0
 ext4_mb_new_blocks+0x5a0/0x4560
 ext4_ext_map_blocks+0x1534/0x5850
 ext4_map_create_blocks+0x116/0x530
 ext4_map_blocks+0x7e4/0x1240
 ext4_do_writepages+0x23d3/0x47a0
 ext4_writepages+0x241/0x3b0
 do_writepages+0x338/0x560
 __writeback_single_inode+0x12e/0xf90
 writeback_sb_inodes+0x9de/0x1b00
 __writeback_inodes_wb+0x114/0x240
 wb_writeback+0x42f/0xad0
 wb_workfn+0x980/0x10f0
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0xa47/0xfb0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


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
