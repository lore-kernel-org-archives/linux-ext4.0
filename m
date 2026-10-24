Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792862320;
	b=rRtKFqlOa10K54xc7A64dPCqccH9TGY81RSYWlZwqPWNxT5oI5KUfBwl1VP26w0g+MMC
	 1pbj6oBLGUaBhZwO4qbzbM/S4ZLpKdT3jftK+ID0nV+31awzkTTXUPO4slqtefdu5preg
	 noqg5Zx0TMdIk8rSZWmfZat8ANOMVvhdF779UHXMke0RlCD1JFdAyQeWY9eHadFwcaXM3
	 b3O0gUVMdU7ayY54QNAzYHATCWACAQZTjIwB8PC4k4ZOgf3XJBXJJrHHZ0xrFpC442xM6
	 n6NKZFxEq05uXx86UAm5GkweoXuKEWvotkHyxBTLAWYTlCpGER/UrQVxcQbFUdDsnvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792862320;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=zuxq5Su5TICEeSRZuF0VlE3n9gPb1lgwgkmS/yFiNu8=;
	b=jOk7y1DoZYlh4UtvMsU9xiOU737dt+vT6QjunsshbHFF0X/uusnyPh/1YxbaL3yzJTWo
	 KriB6hWuf2paMuYGYV66C2zsIqx59WEK1VOdYmXzrOg/CMvr1AWFUlYRc4kdN5kNBwUEC
	 HpMxMmdk0SCRzz33c/IGEjECbGg3PcNjTRf0a27+dXVZeLZ8QtNlJ6VRk2n+RWRxE9U4X
	 D+itxY9vORfJML2cmzFcaQvUBDRzYV9FWcKR+aKqQge4W70m7JZVPK9/bgColqwCa8OWr
	 H1so3nGk26+pWvEobtXBY3eYS13ClXoe17bNY9JPZ09LXN1zTowK4barGli9kC8M7qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5A606A322
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 17:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42A5A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b597558c4cso2889763b6e.1
        for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 10:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792862319; x=1793467119;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zuxq5Su5TICEeSRZuF0VlE3n9gPb1lgwgkmS/yFiNu8=;
        b=cSkz+5vP78tcoQ4KN6lpMpCXEmHUj9ULjZmIhyPJEddGpbLit1ekPsaJ3wpsuQ7Tpr
         zc+xkAqaXwPR3MM+DjBIes1ho/hWT69LOaoNcgdsimUdVWTTHjB7svA4P0zGgGhc3rGt
         7KRYCu1AJ0Kjrxq23DTUKSxYKVGGKB7uGVBObIxU98i/23DvcTFwJmVi2oej4LOx/VBT
         aJ9gEnHtutgJ3s/5nBJ7FFiTWe5aGDpDNika1M0ru8ZBRJ/jIsWs1hsXAJfQaZsLdxWD
         XtLv323zbcbDHJNu7Zq33pr3OunvCF1d3y/CqrnpRAFcS+tF1TFe/U9ExchhUqyBlILn
         0kQg==
X-Forwarded-Encrypted: i=1; AKwUvBz/7/UepSbmMWw7Q6MZpzwYuOLKDodSQyFSIwhLHYYSp4LWLuyFO3xEu952xFvD2f0c3WcFMdyPeAh8@vger.kernel.org
X-Gm-Message-State: AFq9FYJTW+L8IFAwo/inP/Usc/Ju8JO6ii7C7UzIQjnYfOVPLQrKcC03
	mt2mGuk5wFXFfSj5j5chmCxGpAeNFMl5gq4GwcjEtAOWRGFR+jLylaZHJhnk7IuIjOYSLQX8PiC
	xmV9wS4g/to1VKr4TrI9B7VFFs/f878Ct00LRcnjYo1T0rhA5HvUoyF2oQsQ=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3eb:b0:4f4:3790:6615 with SMTP id
 5614622812f47-55c0020f526mr1617575b6e.11.1792862319250; Sat, 24 Oct 2026
 10:18:39 -0700 (PDT)
Date: Sat, 24 Oct 2026 10:18:39 -0700
In-Reply-To: <20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adce86f.998fdb85.f0000.0012.GAE@google.com>
Subject: [syzbot ci] Re: ext2: Make sbi an proper alias for EXT2_SB(sb) in ext2_fill_super()
From: syzbot ci <syzbot+cie4faa945f36997d4@syzkaller.appspotmail.com>
To: elver@google.com, jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, nathan@kernel.org, 
	timday@thelustrecollective.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext2: Make sbi an proper alias for EXT2_SB(sb) in ext2_fill_super()
https://lore.kernel.org/all/20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org
* [PATCH] ext2: Make sbi an proper alias for EXT2_SB(sb) in ext2_fill_super()

and found the following issues:
* KASAN: slab-out-of-bounds Write in ext2_fill_super
* KASAN: slab-use-after-free Write in ext2_fill_super
* KASAN: use-after-free Write in ext2_fill_super
* KFENCE: out-of-bounds write in ext2_fill_super

Full report is available here:
https://ci.syzbot.org/series/66ff7f30-f0bf-494b-9f1e-c6ecfc95d077

***

KASAN: slab-out-of-bounds Write in ext2_fill_super

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      782654a3e9c4065dea2e9f10539899d348b7a1fc
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9d5126b8-7fff-4896-9bfe-27b0f12ca6a3/config
syz repro: https://ci.syzbot.org/findings/7aae8de4-5380-4855-9b7b-d7ca38f5ffd9/syz_repro

EXT2-fs (loop1): (no)user_xattr options not supported
EXT2-fs (loop1): nobh option not supported
==================================================================
BUG: KASAN: slab-out-of-bounds in ext2_fill_super+0x18f/0x2c00 fs/ext2/super.c:898
Write of size 8 at addr ffff888165f11ee8 by task syz.1.18/5846

CPU: 1 UID: 0 PID: 5846 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext2_fill_super+0x18f/0x2c00 fs/ext2/super.c:898
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1872
 vfs_get_tree+0x92/0x2a0 fs/super.c:1932
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f74269a07ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7427787e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f7427787ee0 RCX: 00007f74269a07ca
RDX: 0000200000000180 RSI: 00002000000001c0 RDI: 00007f7427787ea0
RBP: 0000200000000180 R08: 00007f7427787ee0 R09: 0000000003000002
R10: 0000000003000002 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007f7427787ea0 R14: 0000000000000462 R15: 0000200000000200
 </TASK>

Allocated by task 5731:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5414 [inline]
 __kmalloc_node_noprof+0x4b9/0x720 mm/slub.c:5426
 _kmalloc_node_noprof include/linux/slab.h:1200 [inline]
 __vmalloc_area_node mm/vmalloc.c:3893 [inline]
 __vmalloc_node_range_noprof+0x5b4/0x1540 mm/vmalloc.c:4104
 __vmalloc_node_noprof mm/vmalloc.c:4165 [inline]
 vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4243
 __do_replace+0xb2/0x9a0 net/ipv6/netfilter/ip6_tables.c:1066
 do_replace net/ipv6/netfilter/ip6_tables.c:1161 [inline]
 do_ip6t_set_ctl+0xb45/0xe30 net/ipv6/netfilter/ip6_tables.c:1648
 nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2397
 __sys_setsockopt net/socket.c:2422 [inline]
 __do_sys_setsockopt net/socket.c:2428 [inline]
 __se_sys_setsockopt net/socket.c:2425 [inline]
 __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2425
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5731:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6801
 vfree+0x42b/0x490 mm/vmalloc.c:3511
 __do_replace+0x855/0x9a0 net/ipv6/netfilter/ip6_tables.c:1110
 do_replace net/ipv6/netfilter/ip6_tables.c:1161 [inline]
 do_ip6t_set_ctl+0xb45/0xe30 net/ipv6/netfilter/ip6_tables.c:1648
 nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2397
 __sys_setsockopt net/socket.c:2422 [inline]
 __do_sys_setsockopt net/socket.c:2428 [inline]
 __se_sys_setsockopt net/socket.c:2425 [inline]
 __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2425
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888165f11ee0
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of
 allocated 8-byte region [ffff888165f11ee0, ffff888165f11ee8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888165f11f00 pfn:0x165f11
flags: 0x57ff00000000200(workingset|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000200 ffff888100041500 ffff888160400348 ffffea000596de10
raw: ffff888165f11f00 000000000080006b 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 2865123928
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 acpi_ns_internalize_name+0x2da/0x3f0 drivers/acpi/acpica/nsutils.c:331
 acpi_ns_get_node_unlocked+0x186/0x480 drivers/acpi/acpica/nsutils.c:666
 acpi_ns_get_node+0x76/0xc0 drivers/acpi/acpica/nsutils.c:726
 acpi_ns_evaluate+0x28c/0x1320 drivers/acpi/acpica/nseval.c:62
 acpi_ut_evaluate_object+0xe1/0x560 drivers/acpi/acpica/uteval.c:60
 acpi_ut_execute_power_methods+0xdf/0x3d0 drivers/acpi/acpica/uteval.c:288
 acpi_get_object_info+0x539/0xd60 drivers/acpi/acpica/nsxfname.c:366
 acpi_set_pnp_ids drivers/acpi/scan.c:1405 [inline]
 acpi_init_device_object+0xc6a/0x2b50 drivers/acpi/scan.c:1824
 acpi_add_single_object+0x107/0x1b60 drivers/acpi/scan.c:1874
page last free pid 1 tgid 1 ts 2802656815 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_remove_cache+0x1cc/0x380 mm/kasan/quarantine.c:369
 kmem_cache_shrink+0xd/0x20 mm/slab_common.c:611
 acpi_os_purge_cache+0x15/0x20 drivers/acpi/osl.c:1622
 acpi_purge_cached_objects+0xac/0x100 drivers/acpi/acpica/utxface.c:239
 acpi_initialize_objects+0x2e/0xb0 drivers/acpi/acpica/utxfinit.c:250
 acpi_bus_init+0xa8/0x360 drivers/acpi/bus.c:1397
 acpi_init+0xa1/0x1f0 drivers/acpi/bus.c:1486
 do_one_initcall+0x250/0x870 init/main.c:1362
 do_initcall_level+0x10a/0x1a0 init/main.c:1424
 do_initcalls+0x59/0xa0 init/main.c:1440
 kernel_init_freeable+0x29d/0x3e0 init/main.c:1675
 kernel_init+0x22/0x1d0 init/main.c:1565
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158

Memory state around the buggy address:
 ffff888165f11d80: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff888165f11e00: fa fc fc fc fa fc fc fc fa fc fc fc 00 fc fc fc
>ffff888165f11e80: 01 fc fc fc fa fc fc fc 05 fc fc fc fa fc fc fc
                                                          ^
 ffff888165f11f00: fa fc fc fc 00 fc fc fc fa fc fc fc fa fc fc fc
 ffff888165f11f80: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
==================================================================


***

KASAN: slab-use-after-free Write in ext2_fill_super

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      782654a3e9c4065dea2e9f10539899d348b7a1fc
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9d5126b8-7fff-4896-9bfe-27b0f12ca6a3/config
syz repro: https://ci.syzbot.org/findings/ff1ed4a7-36ee-413a-a9a1-e3fcbae980a9/syz_repro

EXT2-fs (loop0): (no)user_xattr options not supported
EXT2-fs (loop0): nobh option not supported
==================================================================
BUG: KASAN: slab-use-after-free in ext2_fill_super+0x160/0x2c00 fs/ext2/super.c:891
Write of size 8 at addr ffff88810d7a71a8 by task syz.0.17/5841

CPU: 0 UID: 0 PID: 5841 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext2_fill_super+0x160/0x2c00 fs/ext2/super.c:891
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1872
 vfs_get_tree+0x92/0x2a0 fs/super.c:1932
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b14fa07ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc911dfee8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc911dff70 RCX: 00007f0b14fa07ca
RDX: 0000200000000180 RSI: 00002000000001c0 RDI: 00007ffc911dff30
RBP: 0000200000000180 R08: 00007ffc911dff70 R09: 0000000003000002
R10: 0000000003000002 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007ffc911dff30 R14: 0000000000000462 R15: 0000200000000200
 </TASK>

Allocated by task 5693:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cgroup_file_open+0x8d/0x3a0 kernel/cgroup/cgroup.c:4357
 kernfs_fop_open+0xa1e/0xce0 fs/kernfs/file.c:717
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x1443/0x1d60 fs/namei.c:5000
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 do_sys_openat2+0x115/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5693:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6801
 cgroup_file_release+0xd6/0x100 kernel/cgroup/cgroup.c:4384
 kernfs_release_file fs/kernfs/file.c:757 [inline]
 kernfs_fop_release+0x21c/0x440 fs/kernfs/file.c:772
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __do_sys_close fs/open.c:1560 [inline]
 __se_sys_close fs/open.c:1545 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1545
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810d7a7100
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 168 bytes inside of
 freed 192-byte region [ffff88810d7a7100, ffff88810d7a71c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10d7a7
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000413c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c00(GFP_NOIO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 7774384016
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 usb_alloc_urb+0x46/0x150 drivers/usb/core/urb.c:75
 usb_internal_control_msg drivers/usb/core/message.c:110 [inline]
 usb_control_msg+0x118/0x3e0 drivers/usb/core/message.c:167
 usb_get_string+0xa2/0x3e0 drivers/usb/core/message.c:902
 usb_string_sub+0x76/0x420 drivers/usb/core/message.c:941
 usb_get_langid drivers/usb/core/message.c:978 [inline]
 usb_string+0x1a7/0x790 drivers/usb/core/message.c:1042
 usb_cache_string+0x7d/0xf0 drivers/usb/core/message.c:1090
 usb_enumerate_device drivers/usb/core/hub.c:2547 [inline]
 usb_new_device+0x28a/0x1690 drivers/usb/core/hub.c:2678
 register_root_hub+0x250/0x5c0 drivers/usb/core/hcd.c:990
 usb_add_hcd+0xac7/0xf80 drivers/usb/core/hcd.c:2987
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88810d7a7080: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff88810d7a7100: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88810d7a7180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                  ^
 ffff88810d7a7200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88810d7a7280: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: use-after-free Write in ext2_fill_super

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      782654a3e9c4065dea2e9f10539899d348b7a1fc
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9d5126b8-7fff-4896-9bfe-27b0f12ca6a3/config

==================================================================
BUG: KASAN: use-after-free in ext2_fill_super+0x160/0x2c00
Write of size 8 at addr ffff8881752f1108 by task syz.0.171/6249

CPU: 1 UID: 0 PID: 6249 Comm: syz.0.171 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_address_description+0x55/0x1e0
 print_report+0x58/0x70
 kasan_report+0x117/0x150
 ext2_fill_super+0x160/0x2c00
 get_tree_bdev_flags+0x430/0x4f0
 vfs_get_tree+0x92/0x2a0
 do_new_mount+0x319/0xdc0
 __se_sys_mount+0x31d/0x420
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4018fa07ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f40171f5e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f40171f5ee0 RCX: 00007f4018fa07ca
RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007f40171f5ea0
RBP: 00002000000000c0 R08: 00007f40171f5ee0 R09: 000000000080c080
R10: 000000000080c080 R11: 0000000000000246 R12: 0000200000000080
R13: 00007f40171f5ea0 R14: 000000000000052e R15: 0000200000000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881752f1b40 pfn:0x1752f1
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 ffffea0005d4bc88 ffffea0005d4bd08 0000000000000000
raw: ffff8881752f1b40 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5590, tgid 5590 (syz-executor), ts 50946740251
 post_alloc_hook+0x1f9/0x250
 get_page_from_freelist+0x2209/0x2280
 __alloc_frozen_pages_noprof+0x217/0x5a0
 allocate_slab+0x7d/0x620
 refill_objects+0x2d5/0x350
 __pcs_replace_empty_main+0x2c8/0x6c0
 kmem_cache_alloc_noprof+0x399/0x600
 __kernfs_new_node+0xe6/0x980
 kernfs_new_node+0xea/0x140
 __kernfs_create_file+0x4b/0x2e0
 sysfs_add_file_mode_ns+0x237/0x300
 internal_create_group+0x679/0x1180
 sysfs_create_groups+0x59/0x120
 device_add_attrs+0xde/0x600
 device_add+0x488/0xb80
 netdev_register_kobject+0x197/0x350
page last free pid 5041 tgid 5041 ts 65207060004 stack trace:
 __free_frozen_pages+0xc93/0xd90
 __slab_free+0x274/0x2c0
 qlist_free_all+0x99/0x100
 kasan_quarantine_reduce+0x148/0x160
 __kasan_slab_alloc+0x22/0x80
 __kmalloc_noprof+0x307/0x720
 tomoyo_realpath_from_path+0xef/0x640
 tomoyo_path_perm+0x283/0x560
 security_inode_getattr+0x12b/0x310
 vfs_fstatat+0xb4/0x170
 __x64_sys_newfstatat+0x151/0x200
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8881752f1000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881752f1080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8881752f1100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff8881752f1180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881752f1200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


***

KFENCE: out-of-bounds write in ext2_fill_super

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      782654a3e9c4065dea2e9f10539899d348b7a1fc
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9d5126b8-7fff-4896-9bfe-27b0f12ca6a3/config

==================================================================
BUG: KFENCE: out-of-bounds write in ext2_fill_super+0x160/0x2c00

Out-of-bounds write at 0xffff88823c45b200 (520B right of kfence-#44):
 ext2_fill_super+0x160/0x2c00
 get_tree_bdev_flags+0x430/0x4f0
 vfs_get_tree+0x92/0x2a0
 do_new_mount+0x319/0xdc0
 __se_sys_mount+0x31d/0x420
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

kfence-#44: 0xffff88823c45aff8-0xffff88823c45aff8, size=1, cache=kmalloc-8

allocated by task 7813 on cpu 1 at 135.547792s (0.000274s ago):
 ext2_fill_super+0xca/0x2c00
 get_tree_bdev_flags+0x430/0x4f0
 vfs_get_tree+0x92/0x2a0
 do_new_mount+0x319/0xdc0
 __se_sys_mount+0x31d/0x420
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 7813 Comm: syz.5.708 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ext2_fill_super+0x160/0x2c00
Code: 84 ff 48 89 c3 4d 8d ae 08 02 00 00 4c 89 e8 48 c1 e8 03 48 89 84 24 b0 00 00 00 42 80 3c 20 00 74 08 4c 89 ef e8 e0 04 90 ff <49> 89 5d 00 48 85 db 0f 84 d1 00 00 00 4c 89 ac 24 a8 00 00 00 49
RSP: 0018:ffffc90006a8fac0 EFLAGS: 00010246
RAX: 1ffff1104788b640 RBX: ffff8881a9c4b000 RCX: 2fbd52647b28b300
RDX: 0000000000000001 RSI: ffffffff8e46ce43 RDI: 00000000ffffffff
RBP: ffff88816fe8da98 R08: ffffffff917ac27f R09: 1ffffffff22f584f
R10: dffffc0000000000 R11: fffffbfff22f5850 R12: dffffc0000000000
R13: ffff88823c45b200 R14: ffff88823c45aff8 R15: 1ffff1102dfd1b53
FS:  00007f0b1f26a6c0(0000) GS:ffff8882a7cb2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823c45b200 CR3: 0000000118ad8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 get_tree_bdev_flags+0x430/0x4f0
 vfs_get_tree+0x92/0x2a0
 do_new_mount+0x319/0xdc0
 __se_sys_mount+0x31d/0x420
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b1e3a07ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0b1f269e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f0b1f269ee0 RCX: 00007f0b1e3a07ca
RDX: 0000200000000000 RSI: 0000200000000040 RDI: 00007f0b1f269ea0
RBP: 0000200000000000 R08: 00007f0b1f269ee0 R09: 0000000000010001
R10: 0000000000010001 R11: 0000000000000246 R12: 0000200000000040
R13: 00007f0b1f269ea0 R14: 0000000000000582 R15: 0000200000000080
 </TASK>
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
