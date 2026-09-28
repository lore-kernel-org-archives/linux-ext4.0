Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE04BD793
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632488; cv=none; b=Fo414dYJsBawOXdhT/wrU2uxh0e2cY06zoZTBzVvywk0A0OGE15cScDt//daNVjOBcUJIgzXAtBxRRFW113kGnD+zZk+j07HLP8ish+pH7eQbyi76I+mvr12BSkLSXn4ejauVOKqFMzGMgzgkrjtHZkGqUyYVbRcDUvjZzTUZjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632488; c=relaxed/simple;
	bh=hVuFlpIciviOdEKkyDoMYVy59c2xWi88gSzmUi3PDhA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f1yGNwfyfyTrpX8//5Sa4PaVsC64hi5RJ5dnkykqvCZrcKisu46CagwiseXDobTJU8L0QTjvSAD957Wyj2+iG2pi4DD1XmBqIxvAweudhrFs0MJghS7+wqSxuLKs+ONmhz3oiWatCRZ1NatVywNcgngVVAYS112geAx3YROKQYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b2f2b8d88fso5813740b6e.2
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 14:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790632486; x=1791237286;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lSk+cSsV2reaYHR/BJZXFfwVLCYIby+3JaSCkIJ4O0I=;
        b=jHbDZXnc9Chblt9YHHdWpfvOzV9UmGlcgEmjgWMpew6okS9sv2HSGVy/DN956qOZzh
         nNpm0Ndum1XeQCBEF+thPGk8VCddgil78rP5rvYdzj6TYL05bWVcDBbeUf2Ja81SJB8H
         z11KBDNMcG3BeOEbZxvDKhkmPk5EQtOc0aNO19fpLUYtYIvoD560cr1m5BNWGKQSE+W2
         pdLJwwMSDIpl6qujEGo7AW1sRCb62dHZa9OiRXILMCUO7SMTH8uhDkTFIxLRj7GgdJUC
         0FuH4bqvwvbHdJriard7OtCyLtUkXUbQoTAW4JTHIU6+4J5zv0H1+Ss5b2o9BdpPORtA
         fkmA==
X-Forwarded-Encrypted: i=1; AKwUvBwfteXn7iirPINpMjbBp2UfRWtfXx+tj/mEZDv81M6VDtq7SpSTDur6hDOK4+bTVCj8EK20YX9QV+Ae@vger.kernel.org
X-Gm-Message-State: AFuF++mLGkiE1JVNGl7cEchhQXh45xlkWHG1QoO/Epe918c1vrdQLGaF
	ueak4HcHg+k/L68G9tBusdBW0z7cev9LtVjhXqQNZZZRoBNjKG1NwxVGxhIVY5sfPMUiYLvfXt4
	aGm2T4L3zjU4JvI5v0hVMaXkveECSFPE9Xi+8jGdk5ohFEHO1iQzq2HoPLDo=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1811:b0:4cb:f21c:a799 with SMTP id
 5614622812f47-4d72ac45fd2mr19042124b6e.33.1790632486034; Mon, 28 Sep 2026
 14:54:46 -0700 (PDT)
Date: Mon, 28 Sep 2026 14:54:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abae226.69bd487b.a6f8c.000a.GAE@google.com>
Subject: [syzbot] [ext4?] KASAN: slab-use-after-free Write in do_split
From: syzbot <syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    72d3fcf802c4 Linux 7.3-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147f6325580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=718e346eb0b8f38
dashboard link: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12379605580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127f6325580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6e221bb16a33/disk-72d3fcf8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/705025f5cae2/vmlinux-72d3fcf8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5f22341c14fa/bzImage-72d3fcf8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5d87cd1c0001/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17e37605580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in dx_move_dirents fs/ext4/namei.c:1863 [inline]
BUG: KASAN: slab-use-after-free in do_split+0x1241/0x1e90 fs/ext4/namei.c:1993
Write of size 90458 at addr ffff88803b38ac6e by task syz.0.17/6003

CPU: 1 UID: 0 PID: 6003 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
 dx_move_dirents fs/ext4/namei.c:1863 [inline]
 do_split+0x1241/0x1e90 fs/ext4/namei.c:1993
 make_indexed_dir+0xdab/0x1360 fs/ext4/namei.c:2328
 __ext4_add_entry+0x1e77/0x1ff0 fs/ext4/namei.c:2432
 ext4_add_entry fs/ext4/namei.c:2469 [inline]
 ext4_rename fs/ext4/namei.c:3939 [inline]
 ext4_rename2+0x1f71/0x3270 fs/ext4/namei.c:4218
 vfs_rename+0xbd9/0xef0 fs/namei.c:6208
 filename_renameat2+0x533/0x9b0 fs/namei.c:6326
 __do_sys_rename fs/namei.c:6370 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6366
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7da7be159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7d9dfd028 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007fe7daa46090 RCX: 00007fe7da7be159
RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000200000000100
RBP: 00007fe7da85506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe7daa46128 R14: 00007fe7daa46090 R15: 00007fff45d807e8
 </TASK>

The buggy address belongs to the physical page:
page: refcount:2 mapcount:0 mapping:ffff888023717420 index:0x8 pfn:0x3b38a
memcg:ffff88801c2dc200
aops:def_blk_aops ino:700000 dentry name(?):""
flags: 0x8000000000493c(referenced|uptodate|dirty|lru|active|owner_2|private|node=0|zone=1)
raw: 008000000000493c ffffea0000efb748 ffffea0000d68388 ffff888023717420
raw: 0000000000000008 ffff8880235dbb40 00000002ffffffff ffff88801c2dc200
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x152c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_HARDWALL), pid 5836, tgid 5836 (udevd), ts 120465350871
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2591/0x2600 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x230/0x5c0 mm/page_alloc.c:5436
 alloc_pages_mpol+0xd4/0x280 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0xd2/0x2f0 mm/mempolicy.c:2577
 folio_alloc_noprof+0x22/0xc0 mm/mempolicy.c:2587
 filemap_alloc_folio_noprof+0x111/0x4c0 mm/filemap.c:1019
 ractl_alloc_folio mm/readahead.c:200 [inline]
 page_cache_ra_unbounded+0x2d6/0x8f0 mm/readahead.c:288
 do_page_cache_ra mm/readahead.c:348 [inline]
 force_page_cache_ra+0x26f/0x2e0 mm/readahead.c:378
 filemap_get_pages+0x493/0x1e80 mm/filemap.c:2714
 filemap_read+0x429/0x11e0 mm/filemap.c:2824
 blkdev_read_iter+0x2f8/0x430 block/fops.c:832
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x59e/0xa90 fs/read_write.c:574
 ksys_read+0x156/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 28 tgid 28 ts 120462276719 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xf8e/0x1070 mm/page_alloc.c:2962
 __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core kernel/rcu/tree.c:2919 [inline]
 rcu_cpu_kthread+0xb2c/0x1740 kernel/rcu/tree.c:3007
 smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88803b38af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88803b38af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88803b38b000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88803b38b080: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fa fb
 ffff88803b38b100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
