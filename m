Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD3377AA5
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 05:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790226040; cv=none; b=esByr3Ep0tAgXROcOTjMb97gd3p7wVYpE70X0ow8GKGXszcVq5rpUvQtNN++Hf960/du7ZCPxwWGYjll4EPf0ZzAyvcesEsKG10Z9KBrenek3hOV2QPJMaugPFyJSNwLKgEnfGHjqNVUOcNb8lgr85IwHB0V8AyER5/CfIgqrZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790226040; c=relaxed/simple;
	bh=/n2EXLd79XKSegA1VHBulYcaGqxP4hAarrx93n3AKAI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qpXjCZW+Ht/p/K/FfOrRSXo9oNKAll8rP7I1n6Pr+fwfsKaeeerwuc1k4/W1ToF/PvJ1U6gGiSSATShq8PVmQMz9zMh/dvGHCYIA+EviaqfHayTDIuPQDBirkjoGRsmYnaC6d+MSCq9Aioi5Gu3FFNFclRIhpLPdw1KlVXaFRFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f9.google.com with SMTP id 46e09a7af769-7f4e9ec63a7so605992a34.1
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 22:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790226037; x=1790830837;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGp54yn9mQvzr/7sOgMFt0g4OtQDC+w1VQA3OF641dI=;
        b=Vsk+fuwpWl41ILfSe3EHEtRzpYCofEf88XqeUONhn++WImlYatPTUR/VKRIhZEayFi
         GqsEQUn433dSjUtOyAm3d8ASHsgqAUWCvKZgKMGqAWqOjdaB4VPz+bhGwiB3eGolGR7t
         CSVl6BbMHNREZ8FlG2klT4F7ckjcqmFZNLf8j4gnl4euETrg2wAoupQTKsFhfTZGB2+f
         AJDyz19TC527BrrBW0ky11TADWnTHb9VEMeYzu7F/cntRgSo0ru+V+dG9P9MRs2/1HYU
         w93ny4F27VFvQEB8Qbr5zZWKZIZ8C4e7qq8f1719nkHFxkMKrOmMawli78wwjeorgvxL
         sJLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwizxqhRdSSxzGl3uMCoImNBKGYAc9V4M9aNJILeAVRASY2KBnTbrTjCD0TU91By2DTw3eSDprVOghi@vger.kernel.org
X-Gm-Message-State: AFuF++lQK9FDxp3eKyTLN/0AwODvcGedm2PMEIxYk13SRRawHeH0hJBf
	hGWAoiLbHD/VxDrfyltcakw3a3dQZ1xupFCrURjdPyM1eVAYN6qPxaPH+TLe5gNtn/ued1RdpnE
	WdZvG97cGBoS50YQP9Fyy4vJYpqJbtGm5kv0UfbHZ2kJdk6P6tEnW5XNBbTU=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:19a7:b0:4c1:e0c3:9d17 with SMTP id
 5614622812f47-4d728717c0fmr1913863b6e.8.1790226037068; Wed, 23 Sep 2026
 22:00:37 -0700 (PDT)
Date: Wed, 23 Sep 2026 22:00:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
Subject: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
From: syzbot <syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c81cc2849c33/mount_3.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11cb4405580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: ./include/linux/pagemap.h:1130 at vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at vma_is_cow_mapping include/linux/mm.h:2329 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at linear_anon_page_index include/linux/pagemap.h:1130 [inline], CPU#1: syz.0.17/4884
WARNING: ./include/linux/pagemap.h:1130 at __folio_set_anon+0x240/0x298 mm/rmap.c:1491, CPU#1: syz.0.17/4884
Modules linked in:
CPU: 1 UID: 0 PID: 4884 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/14/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : linear_anon_page_index include/linux/mm.h:2315 [inline]
pc : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
lr : vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline]
lr : vma_is_cow_mapping include/linux/mm.h:2329 [inline]
lr : linear_anon_page_index include/linux/pagemap.h:1130 [inline]
lr : __folio_set_anon+0x240/0x298 mm/rmap.c:1491
sp : ffff800095456de0
x29: ffff800095456df0 x28: 0000000000020000 x27: 1fffe00019e1007c
x26: ffff0000cf0803e0 x25: 0000000000020000 x24: dfff800000000000
x23: 0000000020000000 x22: 0000000000000000 x21: 00000000200020d1
x20: ffff0000cf0803c0 x19: fffffdffc3c10000 x18: 00000000ffffffff
x17: 0000000000000003 x16: ffff800088b97000 x15: ffff80008a849000
x14: 000000000062064d x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 000000000000003d x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff800080c16020 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080ab2d0c
x2 : 0000000000000000 x1 : ffff0000d07a1d80 x0 : 0000000000000000
Call trace:
 vma_flags_is_cow_mapping include/linux/mm.h:2315 [inline] (P)
 vma_is_cow_mapping include/linux/mm.h:2329 [inline] (P)
 linear_anon_page_index include/linux/pagemap.h:1130 [inline] (P)
 __folio_set_anon+0x240/0x298 mm/rmap.c:1491 (P)
 folio_add_new_anon_rmap+0x1a8/0x10ac mm/rmap.c:1663
 map_anon_folio_pmd_nopf+0xfc/0x160 mm/huge_memory.c:1365
 collapse_huge_page mm/khugepaged.c:1438 [inline]
 mthp_collapse mm/khugepaged.c:1532 [inline]
 collapse_scan_pmd mm/khugepaged.c:1781 [inline]
 collapse_single_pmd+0x21e0/0x3748 mm/khugepaged.c:2797
 madvise_collapse+0x2a4/0x6f4 mm/khugepaged.c:3231
 madvise_vma_behavior+0x3e8/0x339c mm/madvise.c:1372
 madvise_walk_vmas+0x4c8/0x9bc mm/madvise.c:1721
 madvise_do_behavior+0x5f0/0x7c0 mm/madvise.c:1916
 do_madvise+0x28c/0x2f0 mm/madvise.c:2014
 __do_sys_madvise mm/madvise.c:2023 [inline]
 __se_sys_madvise mm/madvise.c:2021 [inline]
 __arm64_sys_madvise+0xac/0xc8 mm/madvise.c:2021
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
irq event stamp: 1412
hardirqs last  enabled at (1411): [<ffff8000869b7264>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
hardirqs last  enabled at (1411): [<ffff8000869b7264>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:221
hardirqs last disabled at (1412): [<ffff800086991a8c>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:445
softirqs last  enabled at (1120): [<ffff80008013c050>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (1120): [<ffff80008013c050>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
softirqs last  enabled at (1120): [<ffff80008013c050>] fpsimd_restore_current_state+0x39c/0x9c8 arch/arm64/kernel/fpsimd.c:1797
softirqs last disabled at (1118): [<ffff80008013bcf8>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (1118): [<ffff80008013bcf8>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
softirqs last disabled at (1118): [<ffff80008013bcf8>] fpsimd_restore_current_state+0x44/0x9c8 arch/arm64/kernel/fpsimd.c:1790
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
