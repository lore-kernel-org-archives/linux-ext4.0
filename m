Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182A53CB8EB
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 07:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669698; cv=none; b=Huv13ZeAH5Sq8t5kSZzUTVol586+TFjIzX1ley4tfcnKbMQV2i0ZV+Ft8euMUOo0ENYGDF06b2RzVMWvsQCP6WWDXxpU0dpf0qH9hq7ZOAEHrthJjO8eQAlN8AUmq4gj7vFTFTmoMUCbE0Sf6GyLIfQ8751EkacA8VfFcmrj/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669698; c=relaxed/simple;
	bh=h61h9WIIFeHMbJuEewtasNelafK1V+4qeyCgDSxP4hk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=eHgmZI9ygacGXRfX0IaMKVw9A862FyRoBFNCU63xZI3Hqao9h6fdFkAhBAm68js/mGEQrO6g5R+1imUvU//VHzTJaFvfVyyt/xlJW/KHhMaN9zzYPN/034icIrGZ0gdhGs0t9F2I+kcWODCR3LDGDRcpcrTMyM6FUyoRlf+CP/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49ab6a82cd5so687929b6e.2
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 00:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669696; x=1784274496;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=18vfEjJh39zqM38jFcXdkikUnYbrKM4RExAzoNks+6k=;
        b=qpQaKTBJ+PkvpXbqv2TnQH5AOL20vIKdMXsGSZu1eg7z9H0EECvL7TXdKLry5qdNzg
         ZdbZFJsmdK4uDkNSGAxWQX9IzTfHJBieWelvrSZf6tgpJ856YADg8G8bABUve1LOmLtd
         tdx/3hsI5++DGUrUx6KOlvvz8+99z5i/qtdkAh+yyQLLUyMUlraP6oZnWnbyJkOq0LgW
         yqEhY1IgkfgkH1UHjX3oLVbq0JL3uSANzsQtyQ1A3/lxU1wNA9TdpqM8HXVgCxA1zIWl
         bT7fNaMQ7HlYSB5WSK7WPJSULrutBxC/BBQ3wmLamcPff5WpQHhvJH+Fl6M5mR0aSu66
         O7CQ==
X-Forwarded-Encrypted: i=1; AFNElJ94jcguS8J0+aG7cRW+enBPlh5WZ+ao8tDn6pF7yQVTkjXdsMhPy4VeAjCNYX30vqf7j2HpIQ4ZcbKm@vger.kernel.org
X-Gm-Message-State: AOJu0Yww6Wb4uv/G06x8oMPoMzScoGtBL5OcyfFqxqPjjvMHz4OPl22m
	MQQD2UXxb6gbthEsQp/IqbNCLZQwNDnBpxKgBH9FZJEIwR7v8xRwo5/f070OlTMUS3gW+n5E11J
	C4DlyEmviNn1EBaWn7dPiMaLpWyUWHcAfU51OuSiD9OKeVICrGs8UXR2cBFA=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a10:b0:492:f15e:3626 with SMTP id
 5614622812f47-4a206affb0dmr7600731b6e.40.1783669696285; Fri, 10 Jul 2026
 00:48:16 -0700 (PDT)
Date: Fri, 10 Jul 2026 00:48:16 -0700
In-Reply-To: <20260709075613.854-1-coregee2000@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a50a3c0.c76b52dc.2a15e.000b.GAE@google.com>
Subject: [syzbot ci] Re: ext4: fix use-after-free in ext4 delayed I/O completion
From: syzbot ci <syzbot+ci87fd14106ebafa1b@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, akpm@linux-foundation.org, coregee2000@gmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext4: fix use-after-free in ext4 delayed I/O completion
https://lore.kernel.org/all/20260709075613.854-1-coregee2000@gmail.com
* [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion

and found the following issue:
inconsistent lock state in igrab

Full report is available here:
https://ci.syzbot.org/series/91c98fac-dc4f-4090-8c56-abbc36b7cd36

***

inconsistent lock state in igrab

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      86f436567f2516a0083b210bedc933544826a2c3
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/7d4608a1-deef-4f49-aff7-ee231c101f0a/config

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffff888112ebb350 (&sb->s_type->i_lock_key#23){+.?.}-{3:3}, at: igrab+0x2d/0x1e0
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x116/0x340
  _raw_spin_lock+0x2e/0x40
  iget_locked+0x397/0x6a0
  __ext4_iget+0x242/0x4290
  ext4_get_journal_inode+0x30/0x1c0
  ext4_load_and_init_journal+0x231/0x23f0
  ext4_fill_super+0x3a64/0x6560
  get_tree_bdev_flags+0x430/0x4f0
  vfs_get_tree+0x92/0x2a0
  do_new_mount+0x325/0xac0
  init_mount+0xc3/0x110
  do_mount_root+0xf4/0x260
  mount_root_generic+0x1a7/0x370
  prepare_namespace+0x71/0xa0
  kernel_init_freeable+0x36e/0x4b0
  kernel_init+0x1d/0x1d0
  ret_from_fork+0x5b0/0xb20
  ret_from_fork_asm+0x1a/0x30
irq event stamp: 682389
hardirqs last  enabled at (682388): [<ffffffff81862340>] handle_softirqs+0x1a0/0x850
hardirqs last disabled at (682389): [<ffffffff8b73ff0e>] _raw_spin_lock_irqsave+0x8e/0x100
softirqs last  enabled at (682374): [<ffffffff81862c35>] __irq_exit_rcu+0xd5/0x1f0
softirqs last disabled at (682387): [<ffffffff81862c35>] __irq_exit_rcu+0xd5/0x1f0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_lock_key#23);
  <Interrupt>
    lock(&sb->s_type->i_lock_key#23);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffff888112ebb880 (&ei->i_completed_io_lock){..-.}-{3:3}, at: ext4_put_io_end_defer+0x442/0x700

stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x1a9/0x280
 print_usage_bug+0x28b/0x2e0
 mark_lock_irq+0x410/0x420
 mark_lock+0x115/0x190
 __lock_acquire+0x65c/0x2cd0
 lock_acquire+0x116/0x340
 _raw_spin_lock+0x2e/0x40
 igrab+0x2d/0x1e0
 ext4_put_io_end_defer+0x4d0/0x700
 blk_update_request+0x57b/0xe30
 scsi_end_request+0x77/0x820
 scsi_io_completion+0x133/0x360
 blk_done_softirq+0x10a/0x160
 handle_softirqs+0x275/0x850
 __irq_exit_rcu+0xd5/0x1f0
 irq_exit_rcu+0x9/0x30
 common_interrupt+0xbb/0xe0
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40
RIP: 0010:pv_native_safe_halt+0xf/0x20
Code: 57 5e 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d d3 07 18 00 fb f4 <e9> cc f3 02 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8e007d80 EFLAGS: 00000286
RAX: ec158cdc8cc84600 RBX: ffffffff8198983a RCX: ec158cdc8cc84600
RDX: 0000000000000001 RSI: ffffffff8da4eee4 RDI: ffffffff8be557c0
RBP: ffffffff8e007eb0 R08: ffff8881210336db R09: 1ffff110242066db
R10: dffffc0000000000 R11: ffffed10242066dc R12: 1ffffffff1c12a78
R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffffffff1c00fbc
 default_idle+0x9/0x20
 default_idle_call+0x72/0xb0
 do_idle+0x1ea/0x4e0
 cpu_startup_entry+0x43/0x60
 rest_init+0x2de/0x300
 start_kernel+0x3a6/0x400
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x137/0x1b0
 common_startup_64+0x13e/0x147
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
