Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D43D23A99F
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788705636; cv=none; b=GefWq6REIStlmTCzLe3cDietvjpwoz0xJ9hL5//g7bwAoPaLXdk/35VflsIC7++C0a1xZLYlEA+qzjvcLVxc4BIV6j26vFs7ECMqYQShN/lACS/sKo3KINbY8nTOYdenwjVtx5QPhxMUuz9XeS4CjZCVFCBzmqVicHLmx95Zqxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788705636; c=relaxed/simple;
	bh=s1q8WzzGuo8hVRRm/KWVtatN8Kh6Mlwms8kGOAbFfn8=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=YJsPvhqUmLUFWntBvAeTIGtMjizkqXQ6ArPa8NuslpSI0msi886txYmCWpTuUtI691FtBg3e1wSZ5QUrt6MEM4oyNC758jVAqIQOK9L55d4eDKByMy9A++Bvub3mvFv9pX61IzX/WsR7rm+gtxskFGOyuAKQu3OoDY2yaGTXokY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oD6ta1yM; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oD6ta1yM"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e58034d05so2113535a91.2
        for <linux-ext4@vger.kernel.org>; Sun, 06 Sep 2026 07:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788705633; x=1789310433; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9VYFtOUs9e8rShoNMIR91vWddUTxEe+7XBSxba8ZkAM=;
        b=oD6ta1yMpeH4kXGEm15K9LL8FhKwXKk3NtbwpofrYfyTSVLw2rIrCcOUFlY3vJQRGb
         JNZGtwGQXEQ6EqDPXxbN+KK8MtAYKlKXcZ9S+fnRmgpw0TWA6E6aPDmXjGe6m9MRmiQA
         rFIQz5/WLpzO5xFp5xfvTMpKBL15gcQm9IW5UTjvRmMLoCNj3cI+JKC6jlGVvhjbMBPi
         fbKyXu1Ktds+T5MyaDQjY3bPOc8UxQO613VvOD5PpFS5KOL5FRIuqbG3BsyzUbI7lgdG
         F4kx5DprDOTKClA/egozbL/NnrlQqusUTdZAmGqZD9zvPU2ayV3csxgOT9FurehALWSr
         qp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788705633; x=1789310433;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9VYFtOUs9e8rShoNMIR91vWddUTxEe+7XBSxba8ZkAM=;
        b=OCHg6AhB/9PzeO7+TvoJDk/DJBQVYq0V045+AF2Sie3ezXJRqS6vcoHrs69k6uOWod
         Cxvcx0IbqA8dAGF3iyisegLVgZDKa7zjV17PjGP92MHredk+gkZ9E73gnYMq43lhQlZF
         CPK5YgOuWUXUoR6fQGNcr24/CaYK7Vrbp3gZCWyWjonCdhnKnyY0lP4TjST7rJfkWhHL
         8s8KsXZooKnU/hElULVwLwbk0VbCP0tyomO+H2Y7lUpXrht7/bp6c656faNo/kIMxbC5
         5hzNoVIVeDpZjAkKAzFWI4PooOFQoM2Xe3wrcTAaa6HoHhn11Kk3y7e/IIHYBqPhH+xD
         sEWw==
X-Forwarded-Encrypted: i=1; AKwUvBwCvm7mT3Qd/f4vvcw6P3FeoNkWUOXKl39XQxuW1i1XGKbXhA97u0toEhien1CrlXuTmktEGKxGQM2W@vger.kernel.org
X-Gm-Message-State: AFuF++m+La1Aq3xi6KbyKpdYIANrzFvU/pmmX2Z3HpEWStYfcrftWFtT
	ymXOadzeV2UEgYJg8pHksBprRv9mSSRwf5hOUEMgRVV+BbjfS8DAf0Y/
X-Gm-Gg: AYBFou362M1mgYFBCTFNvmMDwQPb0wfoFZhFVSOev8mSDzm21TgGNO8SuIRj75gyjpY
	a4jXYiLsDoc9YU6NIXK/7dBsyI553LO6VvsJNaddD/8lNa0KDCwP6vHqwOm+FJtNuBzV5I8RzrG
	8LuJcrXc0UxbfO6kkKTVeW4+WiNoE45y6rwdoDGHSNgNWj+4qlNHMOnIjPWc4ERQiV+c9+fOw3P
	3ouT4iFM0b2maeBr45x3MaqMouLxXoL/8HAKAk6p6y4jOqgqpKEydLKzAhMWCLi3rV+RyGQDaZB
	zTHzKOC25cAAWstKEaq44JUGlGKS/xhghMd3a0pG69wlTFBH8ZF1xNhK+4P6JN334+caOJmORvd
	+aDFpUOrogVOHJpqVusauHzcI9UPWZIt1kwBVt0aWN8xgSlFmZn0/ioc3yLkpZxLe7ad8OXFnRK
	s/RNGW+y3Zf2tyPN98tNT30hRENHfLAEyNkcJ3B3+xsexeYZKAz6zQxPJfnIVMFa7KPKGokYjXk
	/JToWQXNJl2QMxOf9dnQzRKLZnkZOuxevoT8AQntTG1
X-Received: by 2002:a17:90b:57cb:b0:398:9be6:f998 with SMTP id 98e67ed59e1d1-39b262e2139mr28656965a91.23.1788705632700;
        Sun, 06 Sep 2026 07:40:32 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339ac24d7esm32567878eec.15.2026.09.06.07.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:40:31 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: syzbot <syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [syzbot] [ext4?] linux-next test error: general protection fault in __bh_submit
In-Reply-To: <6a9c44cc.0a3344eb.391530.000c.GAE@google.com>
Date: Sun, 06 Sep 2026 19:58:26 +0530
Message-ID: <mrtuxxmd.ritesh.list@gmail.com>
References: <6a9c44cc.0a3344eb.391530.000c.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

syzbot <syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    32b6ef9a5d0e Add linux-next specific files for G20260902
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14b44125580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=32ceed1c94c11059
> dashboard link: https://syzkaller.appspot.com/bug?extid=5a7a23af225c215902e7
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/9a1f38fb6f24/disk-32b6ef9a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f3152eed43a4/vmlinux-32b6ef9a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e7fbd36e1b12/bzImage-32b6ef9a.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5a7a23af225c215902e7@syzkaller.appspotmail.com
>
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 4945 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
> RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
> RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
> Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 26 f6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 04 f6 d7 ff 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc9001016f868 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b96ff9
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075a7a660
> RBP: 0000000000009801 R08: ffff888075a7a6bf R09: 1ffff1100eb4f4d7
> R10: dffffc0000000000 R11: ffffed100eb4f4d8 R12: dffffc0000000000
> R13: ffff888075a7a640 R14: ffff8880123a17e0 R15: 0000000000000008
> FS:  0000000000000000(0000) GS:ffff888124ccb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe1ee627da0 CR3: 0000000074fa8000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  jbd2_journal_commit_transaction+0x22a9/0x5cd0 fs/jbd2/commit.c:751
>  kjournald2+0x3bc/0x750 fs/jbd2/journal.c:200
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
> RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:600 [inline]
> RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1109
> Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 26 f6 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 04 f6 d7 ff 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc9001016f868 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b96ff9
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888075a7a660
> RBP: 0000000000009801 R08: ffff888075a7a6bf R09: 1ffff1100eb4f4d7
> R10: dffffc0000000000 R11: ffffed100eb4f4d8 R12: dffffc0000000000
> R13: ffff888075a7a640 R14: ffff8880123a17e0 R15: 0000000000000008
> FS:  0000000000000000(0000) GS:ffff888124dcb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f87c696cf80 CR3: 000000000eb48000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>    0:	c1 e8 03             	shr    $0x3,%eax
>    3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
>    8:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
>    d:	74 08                	je     0x17
>    f:	48 89 df             	mov    %rbx,%rdi
>   12:	e8 26 f6 d7 ff       	call   0xffd7f63d
>   17:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
>   1c:	48 8b 1b             	mov    (%rbx),%rbx
>   1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
>   23:	4c 89 f8             	mov    %r15,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
>   2f:	74 08                	je     0x39
>   31:	4c 89 ff             	mov    %r15,%rdi
>   34:	e8 04 f6 d7 ff       	call   0xffd7f63d
>   39:	4d 8b 3f             	mov    (%r15),%r15
>   3c:	4c 89 fe             	mov    %r15,%rsi
>   3f:	48                   	rex.W
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup


#syz test

diff --git a/fs/buffer.c b/fs/buffer.c
index 427d8a817cd5..f46fa6413032 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
-	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
+	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
+	    op_is_write(opf))
 		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))

