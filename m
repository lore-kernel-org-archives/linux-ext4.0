Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA83A1A23
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 23:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782343121; cv=none; b=qRpcuOjJATFKkx8nIHkPZi4yaEwM06rX9AsVvPB2rspFQr07CFDDf8CoozfldOdjPwW90VUOvgjLEfdWKsMb9bXlpxJkYv9ZmWaCEXc/v6ktj6uCPKpPjACIboEs+/ZVP4wyMKnfkIYoCpvk43ffMS+dgn8DHRV9MUV8zW60TF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782343121; c=relaxed/simple;
	bh=jOimYQQgTQKtJEGGJJtxmlMyYjtG1RgQczZ1VlkhC/8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=otUDdW2THV/sVlhAh8oOQX6mVGRBKPKQDK14syZpf2UMFd9HFMRm/dIVo7L7zGxOpPwiWJREldGKnvdpylfsmdGkdpsMhRxPzam1A+Rbh7+SJG0/iEGh2WxMqEyZfbiGgexOTKLDTOIlntlqFBIlQ33UG48TmjRToLludiYGU8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-487059fb570so2154821b6e.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 16:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782343118; x=1782947918;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=plsHfYcRVnvrH8Fuz1HjXcY4Xc51OvjKhFCNmmIJnrM=;
        b=sgObjLqazJX/zSO7hBbfRasyl3ODLMPAbkCqU2LlZXFgWRNACKq9Oi8+bgxVj7FdZ6
         pogzz1JnyOPn9sqHakG12jRy4UAVGZlPNu/kf7vi8F3wiVnT3yNXlY/2piYNjYsJx/U5
         SGD4yrg5D6mPMxgeYGWwFTBIrSipRJxAKbw9Q4MpgTCZ1Ewrrf2ziiA1lEXKwgyvx9Fq
         vnO4FoODL0PTLlX1StlO820EjfKZuLB2oFzjAXUEE29eJGpjbgPYsvLOQImxRYOTFI9j
         w0hCDYOYWD0qGjOTyJfn5qbxwt9qtWPghC7pOF5Fgmftkxt4ScOHuJfVwxErzosQjceo
         Lycw==
X-Forwarded-Encrypted: i=1; AFNElJ96N+O7uyu3Lql2Z/a+OwsnnqT6pShjLtiFCt74eETUW6jLZAu43LZAcoDG+N5PQtUcDG40XsJD1qdC@vger.kernel.org
X-Gm-Message-State: AOJu0YzwHgQQzP8AyVmw19Mmu2dihKu3oHBFl2LQaLySBYf/YgFpsb5b
	NwmUVmYtZk2lkoc3Zh+2ZMUuAyWk3bSJQlSR1H2N3hvxpba46ZumJDUVnVRs+2U0+bbFgQLsGPC
	TFHNZcgEPhcOa19VRd/X9YoVMY0j+57OTx+OfRS7Mu8RK0HydIaYkHGE7L88=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:320c:b0:489:6b1e:1b8e with SMTP id
 5614622812f47-49215249ee4mr230324b6e.8.1782343118266; Wed, 24 Jun 2026
 16:18:38 -0700 (PDT)
Date: Wed, 24 Jun 2026 16:18:38 -0700
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3c65ce.43b4ff68.30a095.0002.GAE@google.com>
Subject: [syzbot ci] Re: Data in direntry (dirdata) feature
From: syzbot ci <syzbot+ci09062967a4098270@syzkaller.appspotmail.com>
To: ablagodarenko@thelustrecollective.com, adilger.kernel@dilger.ca, 
	adilger@dilger.ca, adilger@diliger.ca, artem.blagodarenko@gmail.com, 
	linux-ext4@vger.kernel.org, pravin.shelar@sun.com, xiaowu.417@qq.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] Data in direntry (dirdata) feature
https://lore.kernel.org/all/20260624133642.18438-1-ablagodarenko@thelustrecollective.com
* [PATCH v4 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
* [PATCH v4 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
* [PATCH v4 03/11] ext4: add ext4_dir_entry_is_tail()
* [PATCH v4 04/11] ext4: refactor dx_root to support variable dirent sizes
* [PATCH v4 05/11] ext4: add dirdata format definitions and access helpers
* [PATCH v4 06/11] ext4: preserve dirdata bits in get_dtype()
* [PATCH v4 07/11] ext4: add ext4_dir_entry_len() and harden dirdata parsing
* [PATCH v4 08/11] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
* [PATCH v4 09/11] ext4: dirdata feature
* [PATCH v4 10/11] ext4: add dirdata set/get helpers
* [PATCH v4 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries

and found the following issues:
* KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
* KASAN: use-after-free Read in ext4_inlinedir_to_tree

Full report is available here:
https://ci.syzbot.org/series/7075f9f8-5dad-4e13-83ee-2f76e1e06dcf

***

KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      840ef6c78e6a2f694b578ecb9063241c992aaa9e
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/c9c607fc-012f-4e4c-88e7-89d5bade9f75/config
syz repro: https://ci.syzbot.org/findings/3badb95c-16ec-4f87-adf6-da2aca94c39c/syz_repro

EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
==================================================================
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4189 [inline]
BUG: KASAN: slab-use-after-free in ext4_inlinedir_to_tree+0x864/0x1030 fs/ext4/inline.c:1339
Read of size 1 at addr ffff888108ff7c19 by task syz.1.18/5891

CPU: 0 UID: 0 PID: 5891 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4189 [inline]
 ext4_inlinedir_to_tree+0x864/0x1030 fs/ext4/inline.c:1339
 ext4_htree_fill_tree+0x4b9/0x2140 fs/ext4/namei.c:1206
 ext4_dx_readdir fs/ext4/dir.c:600 [inline]
 ext4_readdir+0x2e2a/0x3720 fs/ext4/dir.c:146
 iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
 ovl_dir_read+0x141/0x4a0 fs/overlayfs/readdir.c:388
 ovl_check_d_type_supported+0xc5/0x150 fs/overlayfs/readdir.c:1167
 ovl_make_workdir fs/overlayfs/super.c:695 [inline]
 ovl_get_workdir fs/overlayfs/super.c:836 [inline]
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x3a43/0x5d40 fs/overlayfs/super.c:1560
 vfs_get_super fs/super.c:1267 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1286
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
RIP: 0033:0x7f09e159ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f09e24a9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f09e1815fa0 RCX: 00007f09e159ce59
RDX: 0000200000000000 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f09e1632e6f R08: 00002000000000c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f09e1816038 R14: 00007f09e1815fa0 R15: 00007fff17222ac8
 </TASK>

Allocated by task 5642:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5362 [inline]
 __kmalloc_node_track_caller_noprof+0x4c3/0x730 mm/slub.c:5497
 kmemdup_noprof+0x2b/0x70 mm/util.c:138
 kmemdup_noprof include/linux/fortify-string.h:715 [inline]
 xfrm6_net_sysctl_init net/ipv6/xfrm6_policy.c:206 [inline]
 xfrm6_net_init+0x86/0x180 net/ipv6/xfrm6_policy.c:261
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3267
 __do_sys_unshare kernel/fork.c:3341 [inline]
 __se_sys_unshare kernel/fork.c:3339 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 12:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2705 [inline]
 slab_free mm/slub.c:6405 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6720
 xfrm6_net_sysctl_exit net/ipv6/xfrm6_policy.c:238 [inline]
 xfrm6_net_exit+0x79/0xa0 net/ipv6/xfrm6_policy.c:270
 ops_exit_list net/core/net_namespace.c:199 [inline]
 ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:252
 cleanup_net+0x572/0x810 net/core/net_namespace.c:702
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888108ff7c00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 25 bytes inside of
 freed 64-byte region [ffff888108ff7c00, ffff888108ff7c40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x108ff7
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 14581267674, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3294 [inline]
 allocate_slab+0x79/0x5e0 mm/slub.c:3408
 new_slab mm/slub.c:3454 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7338
 refill_sheaf mm/slub.c:2832 [inline]
 __pcs_replace_empty_main+0x2bf/0x6b0 mm/slub.c:4703
 alloc_from_pcs mm/slub.c:4801 [inline]
 slab_alloc_node mm/slub.c:4933 [inline]
 __do_kmalloc_node mm/slub.c:5361 [inline]
 __kmalloc_noprof+0x485/0x720 mm/slub.c:5387
 _kmalloc_noprof include/linux/slab.h:973 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 kobject_get_path+0xc5/0x2f0 lib/kobject.c:161
 kobject_uevent_env+0x29e/0x9e0 lib/kobject_uevent.c:548
 device_add+0x544/0xb80 drivers/base/core.c:3738
 device_create_groups_vargs drivers/base/core.c:4454 [inline]
 device_create+0x269/0x300 drivers/base/core.c:4493
 mon_bin_add+0xb6/0x130 drivers/usb/mon/mon_bin.c:1371
 mon_bus_init+0x162/0x2a0 drivers/usb/mon/mon_main.c:291
 mon_bus_add drivers/usb/mon/mon_main.c:188 [inline]
 mon_notify+0x10c/0x3f0 drivers/usb/mon/mon_main.c:219
 notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888108ff7b00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
 ffff888108ff7b80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888108ff7c00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff888108ff7c80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
 ffff888108ff7d00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: use-after-free Read in ext4_inlinedir_to_tree

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      840ef6c78e6a2f694b578ecb9063241c992aaa9e
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/c9c607fc-012f-4e4c-88e7-89d5bade9f75/config
syz repro: https://ci.syzbot.org/findings/560b0247-7e29-4a4c-91b8-c73d275cb34f/syz_repro

loop0: lost filesystem error report for type 5 error -117
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
==================================================================
BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4189 [inline]
BUG: KASAN: use-after-free in ext4_inlinedir_to_tree+0x864/0x1030 fs/ext4/inline.c:1339
Read of size 1 at addr ffff888113752019 by task syz.0.17/5794

CPU: 0 UID: 0 PID: 5794 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_dirent_get_data_len fs/ext4/ext4.h:4156 [inline]
 ext4_dir_entry_len fs/ext4/ext4.h:4189 [inline]
 ext4_inlinedir_to_tree+0x864/0x1030 fs/ext4/inline.c:1339
 ext4_htree_fill_tree+0x4b9/0x2140 fs/ext4/namei.c:1206
 ext4_dx_readdir fs/ext4/dir.c:600 [inline]
 ext4_readdir+0x2e2a/0x3720 fs/ext4/dir.c:146
 iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
 ovl_dir_read+0x141/0x4a0 fs/overlayfs/readdir.c:388
 ovl_check_d_type_supported+0xc5/0x150 fs/overlayfs/readdir.c:1167
 ovl_make_workdir fs/overlayfs/super.c:695 [inline]
 ovl_get_workdir fs/overlayfs/super.c:836 [inline]
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x3a43/0x5d40 fs/overlayfs/super.c:1560
 vfs_get_super fs/super.c:1267 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1286
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
RIP: 0033:0x7f427399ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffce99c0f38 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f4273c15fa0 RCX: 00007f427399ce59
RDX: 0000200000000000 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f4273a32e6f R08: 00002000000000c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4273c15fac R14: 00007f4273c15fa0 R15: 00007f4273c15fa0
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888113752e00 pfn:0x113752
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000000000 ffffea0004296d08 ffffea0004501b08 0000000000000000
raw: ffff888113752e00 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5462, tgid 5462 (rm), ts 46014589837, free_ts 77936825094
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3294 [inline]
 allocate_slab+0x79/0x5e0 mm/slub.c:3408
 new_slab mm/slub.c:3454 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7338
 refill_sheaf mm/slub.c:2832 [inline]
 __prefill_sheaf_pfmemalloc mm/slub.c:5035 [inline]
 kmem_cache_prefill_sheaf+0x2fb/0x550 mm/slub.c:5123
 mt_get_sheaf lib/maple_tree.c:154 [inline]
 mas_alloc_nodes+0x1c2/0x350 lib/maple_tree.c:1119
 mas_preallocate+0x2cf/0x630 lib/maple_tree.c:4961
 vma_iter_prealloc mm/vma.h:577 [inline]
 __split_vma+0x318/0xa50 mm/vma.c:529
 vms_gather_munmap_vmas+0x322/0x1370 mm/vma.c:1427
 __mmap_setup mm/vma.c:2439 [inline]
 __mmap_region mm/vma.c:2756 [inline]
 mmap_region+0x8f9/0x2310 mm/vma.c:2860
 do_mmap+0xc3b/0x10c0 mm/mmap.c:560
 vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
 ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:606
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5736 tgid 5736 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xc1e/0xd10 mm/page_alloc.c:2950
 __slab_free+0x274/0x2c0 mm/slub.c:5767
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4612 [inline]
 slab_alloc_node mm/slub.c:4945 [inline]
 __kmalloc_cache_noprof+0x2ab/0x660 mm/slub.c:5511
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 ref_tracker_alloc+0x15b/0x4b0 lib/ref_tracker.c:270
 __netdev_tracker_alloc include/linux/netdevice.h:4489 [inline]
 netdev_hold include/linux/netdevice.h:4518 [inline]
 rx_queue_add_kobject net/core/net-sysfs.c:1236 [inline]
 net_rx_queue_update_kobjects+0x1c4/0x780 net/core/net-sysfs.c:1301
 register_queue_kobjects net/core/net-sysfs.c:2093 [inline]
 netdev_register_kobject+0x21f/0x310 net/core/net-sysfs.c:2341
 register_netdevice+0x1433/0x1eb0 net/core/dev.c:11439
 ipvlan_link_new+0x3e3/0xa90 drivers/net/ipvlan/ipvlan_main.c:593
 rtnl_newlink_create+0x310/0xb00 net/core/rtnetlink.c:3905
 __rtnl_newlink net/core/rtnetlink.c:4036 [inline]
 rtnl_newlink+0x167f/0x1bd0 net/core/rtnetlink.c:4151
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7068
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345

Memory state around the buggy address:
 ffff888113751f00: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
 ffff888113751f80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888113752000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                            ^
 ffff888113752080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888113752100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
