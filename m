Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B5E3BBFAA
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477461; cv=pass; b=ge84p+D8L5eW01HYoBeBq3LXmYa1WLxhFctbYwx907k1toknV3syo0cpX+1eljjqiEdjvCqdvMvQQM378yCatIwKwAIM0P2Dhbi4KdXlLKghVy/ouz0Tq7bfiYtjKiyaUmzcFVrXJ/3FP3670oWQFtAUG5Bv3+dACMhGG1BdjqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477461; c=relaxed/simple;
	bh=eAMi2z6sx1maFkhVJ1EPTUZWrkgTfjSgA/hD5tzvlgE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CMC7lr+b1R34MdKc3gT4avbVOYGfVc1mpMaY6fQT1ZKj2h2Ecxk0dZhzUpH4C1avMlRpfF08Mkd9EvryV+JBoDs7CeLjhffzLiqi6jaC1x2h8oxdq1WJmIlznZBxqk1QU0XRKhQMAEmI3W8IrwNDNb8/XwJNswHSdGQ2OI2NlSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fC85VwIK; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fC85VwIK"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ef15c1so52282766b.1
        for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 06:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789477457; cv=none;
        d=google.com; s=arc-20260327;
        b=rBt0Ey6vQ+IAfun38RgDxTCqWaR5OCDMrK5eEkmMMZvWtnT4scCeG4AOEh1wBsF1ii
         TiIOc51mFFVVBL8wWbzMJcL9HcklFgZWWJV5a97g8ihSCM9WR+je25UqCxm0IoUTwACH
         IMwKv6qWk1BDBfU/WOEliUtDafXbpDr4H75kNZZxYQ4F8r8c1JmnVM+j7k4YkNGmo3rr
         D+PQbLVuwaYAU+X8OEEf3m1E+t2lEev43vjkw6A0JnAkVIssdKQNtOrX8Eu8bj96P9oD
         hKW7jaxCZydRzd+dXSHTRo6EP6ELP68yDMcgqm1/EIfz2nE2yN+QJcReQi0nwkrYS/1F
         8qLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=HSn3OKtXUQxscb2DdZg7430ANRYq48oEhg3L+5EMQ1I=;
        fh=/ulgtALSf7GWjiJqq++0a+FMlDCcbSuPMXS1Gl8ZlAs=;
        b=LTXaZapLhHi3n4s2/BHofQQLquorRVicLRi+yomb+6j8NOjsH3MtFhf6Sw9/ygPeQy
         vNNvG74AkLu1O70RdZ4K1gb10tMgvuMiE+ZieWgLo9p0t5xh8RKRh58zBrQb2+TrqNcQ
         Swth4arXxNNfRzq4a1mkdymOKax0+CqF7Px6xeBoHnRiWwPetyhabNM8Gdq9dhyeL5ar
         tfl72SgHOZct0M9X4zdzdTSDRHeLQI12NoIaYvxBsWd8F+EW1w+YYfZQ3SiEPoToXCVY
         XqtjXJw8xMOSURtttE6KBx+bAO3i5qSbaFw2f9VQvm8qki3NWCRFwxHFpTOJMEHbALqm
         AfKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789477457; x=1790082257; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HSn3OKtXUQxscb2DdZg7430ANRYq48oEhg3L+5EMQ1I=;
        b=fC85VwIKqxprgsI/QKch6KhjXda3xWk5MMPOYDQR92vf3aKB1X3o45LTDVRzFaqDFu
         TX8rZJNVf1T/bJetp1mrpQUnvBz21jFZ+DORhql7X46XCW0jkqqtZNK4ZM6egZfxvk98
         elJDd3m16hpqJUVUy2t36KoimL1BP0rro+NMqCh2dIzgWEJvwTpPXj7SPmCyqaZNLrG+
         0T30qZeMU/adrLAOlPErhtUXm0sCv/u3V8yjMpw3allEQcE9IW5mfIohfQk9Gy2KooxR
         s6v+hhRVSR70HbDPSpJbvWSJJz3AIuvGI84hyvHQJduELqbJpl9mLet3/uFMLqF35G1f
         JFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789477457; x=1790082257;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HSn3OKtXUQxscb2DdZg7430ANRYq48oEhg3L+5EMQ1I=;
        b=mDaTLXozeZ0HJR0HHXuNM92oZszbwp/IJqd1tiT7tEkNERjKdqQYEEDs7xPnJMd0qF
         QDxdn17pKXrd6M/8WplYBn+vC4drWdhxNZm+Zatlrpo2Jeu3U2SgPZ4d85A3N7TMolQ3
         XoAB+aasavKY+uqeDbBysqn8pSL0USQapf8XBS+X0kQeUWkcebxuUv162301S7cm3N1r
         QqjUQ3wazGdsPGvHuD1RxBCjHZZ6Uk6FTaz+/DNmy2bV7+pvPnMIZBjqM6XF8czGS5ex
         +MyKowqLUfGXjppBgwuRVZGkLHm3rhpUOeo9CUTxjSdp1j6OZFsYVWT8F5ZupLOdHCuv
         N7PA==
X-Gm-Message-State: AFuF++n+lLgfu8TB9Gz3HKOjt+TAGCRqwGhO+psbE+MhYDCGVV+7rs38
	rmAgkm8BaxNyZuoNfTQ+YFr+w/Lmf0joI3T+rgtq87ykOGTZpXPRiXUOE76KWEah8KlgYGrwB5k
	TbT2snqkJhoSSU35651CThOdgcpaVHayEgTeljeI=
X-Gm-Gg: AYBFou228cT5/ZPcZNWUH32eXYNFSp2HqeLN0toY3JYSqwKqpfWzJkaCXKUoJA/nLO9
	2A1iurWblaQ08WK7JG3lqyO0KrdssZg0tbAh7ieyzlnnXJx+sn1UIWlg1q6jbTJvCbPZ6+7xekb
	BP2ULWpQ57cX5xN92qpFMGSdv75mDwLDbJp66LcJ06YxXc0gzsjcSoJwL2pey1fmFc61l1iY6ws
	euFZJYFNOjc0KjSDe1VIi1zldH4Nw+OEckLRrASfziLJhbTd2EnwKga3SNj2b1XJB9NKqO82Vzn
	KxRrnB3LDh2503IITtNhoinfHlq10TikPbH8aFLX5+aIPSTwta+uZfUP
X-Received: by 2002:a17:907:a088:b0:c29:65ef:b907 with SMTP id
 a640c23a62f3a-c29d78ffaffmr82104266b.26.1789477456611; Tue, 15 Sep 2026
 06:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Tue, 15 Sep 2026 21:03:28 +0800
X-Gm-Features: AcwNN1WU1wuip8FJuE-6xZ_-oZZzNEbREl-iOMxGR8aAMLmapFPzmp6o1d7iZ5M
Message-ID: <CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com>
Subject: [Linux Kernel Bug] KASAN: slab-out-of-bounds Write in ext4_xattr_set_entry
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, syzkaller@googlegroups.com, r772577952@gmail.com
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We are writing to report an issue discovered in the EXT4 subsystem.  The
issue is reproducible on the latest version of Linux (v7.3-rc3, commit
fd73f4a6659897191fa0d40695fe370925dd3780).  Below is the kernel report:

loop0: detected capacity change from 0 to 512
EXT4-fs (loop0): mounted filesystem
00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode:
writeback.
==================================================================
BUG: KASAN: slab-out-of-bounds in ext4_xattr_set_entry+0xdc5/0x1e80
fs/ext4/xattr.c:1812
Write of size 3803 at addr ffff8880476bc9ac by task syz-executor360/9770

CPU: 1 UID: 0 PID: 9770 Comm: syz-executor360 Not tainted 7.3.0-rc3
#49 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10e/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x153/0x7e0 mm/kasan/report.c:482
 kasan_report+0x147/0x180 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 ext4_xattr_set_entry+0xdc5/0x1e80 fs/ext4/xattr.c:1812
 ext4_xattr_ibody_set+0x254/0x6a0 fs/ext4/xattr.c:2277
 ext4_xattr_set_handle+0xcb7/0x1530 fs/ext4/xattr.c:2449
 ext4_xattr_set+0x244/0x330 fs/ext4/xattr.c:2563
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:223
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:257
 vfs_setxattr+0x162/0x360 fs/xattr.c:344
 do_setxattr fs/xattr.c:662 [inline]
 filename_setxattr+0x286/0x610 fs/xattr.c:690
 path_setxattrat+0x367/0x3b0 fs/xattr.c:734
 __do_sys_lsetxattr fs/xattr.c:775 [inline]
 __se_sys_lsetxattr fs/xattr.c:771 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:771
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7c0004703d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7bff803208 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f7c000f3ae8 RCX: 00007f7c0004703d
RDX: 0000200000000180 RSI: 0000200000000040 RDI: 0000200000000000
RBP: 00007f7c000f3ae0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000edb R11: 0000000000000246 R12: 00007f7c000bfec0
R13: 0000200000000c00 R14: 0031656c69662f2e R15: 0000200000000580
 </TASK>

Allocated by task 9469:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x2be/0x610 mm/slub.c:5010
 __kernfs_new_node+0xd9/0x980 fs/kernfs/dir.c:665
 kernfs_new_node+0xea/0x140 fs/kernfs/dir.c:751
 __kernfs_create_file+0x4b/0x2e0 fs/kernfs/file.c:1050
 sysfs_add_file_mode_ns+0x238/0x300 fs/sysfs/file.c:316
 create_files fs/sysfs/group.c:82 [inline]
 internal_create_group+0x66e/0x1170 fs/sysfs/group.c:189
 internal_create_groups fs/sysfs/group.c:229 [inline]
 sysfs_create_groups+0x59/0x120 fs/sysfs/group.c:255
 device_add_groups drivers/base/core.c:2911 [inline]
 device_add_attrs+0xde/0x600 drivers/base/core.c:2975
 device_add+0x496/0xb90 drivers/base/core.c:3715
 netdev_register_kobject+0x197/0x350 net/core/net-sysfs.c:2340
 register_netdevice+0x152e/0x1da0 net/core/dev.c:11503
 veth_newlink+0x639/0xd50 drivers/net/veth.c:1899
 rtnl_newlink_create+0x2f7/0x780 net/core/rtnetlink.c:3974
 __rtnl_newlink net/core/rtnetlink.c:4103 [inline]
 rtnl_newlink+0x1487/0x19f0 net/core/rtnetlink.c:4220
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:7137
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75e/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x3b4/0x520 net/socket.c:2281
 __do_sys_sendto net/socket.c:2288 [inline]
 __se_sys_sendto net/socket.c:2284 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2284
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x170/0x540 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880476bc960
 which belongs to the cache kernfs_node_cache of size 176
The buggy address is located 76 bytes inside of
 allocated 176-byte region [ffff8880476bc960, ffff8880476bca10)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x476bc
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801be9b000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000200110011 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask
0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 9469, tgid 9469 (syz-executor360), ts 217789819284
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x205/0x260 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x235b/0x23e0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x209/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x630 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x301/0x380 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2cb/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x3a0/0x610 mm/slub.c:5010
 __kernfs_new_node+0xd9/0x980 fs/kernfs/dir.c:665
 kernfs_new_node+0xea/0x140 fs/kernfs/dir.c:751
 __kernfs_create_file+0x4b/0x2e0 fs/kernfs/file.c:1050
 sysfs_add_file_mode_ns+0x238/0x300 fs/sysfs/file.c:316
 create_files fs/sysfs/group.c:82 [inline]
 internal_create_group+0x66e/0x1170 fs/sysfs/group.c:189
 internal_create_groups fs/sysfs/group.c:229 [inline]
 sysfs_create_groups+0x59/0x120 fs/sysfs/group.c:255
 device_add_groups drivers/base/core.c:2911 [inline]
 device_add_attrs+0xde/0x600 drivers/base/core.c:2975
 device_add+0x496/0xb90 drivers/base/core.c:3715
 netdev_register_kobject+0x197/0x350 net/core/net-sysfs.c:2340
page last free pid 9469 tgid 9469 ts 217788989395 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc71/0xd50 mm/page_alloc.c:2962
 __slab_free+0x282/0x2d0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __kmalloc_cache_noprof+0x2a4/0x620 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 netdev_name_node_alloc net/core/dev.c:276 [inline]
 netdev_name_node_head_alloc net/core/dev.c:290 [inline]
 register_netdevice+0x58d/0x1da0 net/core/dev.c:11416
 veth_newlink+0x639/0xd50 drivers/net/veth.c:1899
 rtnl_newlink_create+0x2f7/0x780 net/core/rtnetlink.c:3974
 __rtnl_newlink net/core/rtnetlink.c:4103 [inline]
 rtnl_newlink+0x1487/0x19f0 net/core/rtnetlink.c:4220
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:7137
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75e/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x3b4/0x520 net/socket.c:2281

Memory state around the buggy address:
 ffff8880476bc900: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
 ffff8880476bc980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880476bca00: 00 00 fc fc fc fc fc fc fc fc 00 00 00 00 00 00
                         ^
 ffff8880476bca80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880476bcb00: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
==================================================================

Following is the root cause analysis for this issue.  Note that the
analysis was performed with the assistance of an LLM, but we have tried
our best to ensure its accuracy.

The write happens while ext4_xattr_set_entry() adds an extended attribute
to the space inside the inode that follows the extra inode fields, whose
size is given by i_extra_isize.  To store a new value, the function walks
the entries to find the lowest value offset, min_offs, checks that the gap
between the end of the entry list and min_offs is large enough, and copies
the value to just below min_offs.  In this report min_offs is 0, so the
value is copied to memory in front of that space.

That offset of 0 comes from bytes that were never validated.  When ext4
loads an inode, ext4_iget_extra_inode() looks for the xattr magic right
after the extra inode fields.  Only if the magic is there does it validate
the entries and set EXT4_STATE_XATTR.  Otherwise it treats the space as
empty and checks nothing.  ext4_xattr_ibody_set() does not test that flag
before calling ext4_xattr_set_entry(), which walks whatever entries it
finds at the start of the space.

A crafted image can keep old attribute data in an inode and change
i_extra_isize so that the magic is no longer where ext4 looks for it.  The
old data after the new start of the space is then parsed as entries, and
one of them has a non-zero value size and a value offset of 0.  With
min_offs set to 0, the free space calculation underflows, because free is
a size_t:

size_t free;

free = min_offs - ((void *)last - s->base) - sizeof(__u32);
if (!s->not_found)
free += EXT4_XATTR_LEN(name_len) + old_size;

if (free < EXT4_XATTR_LEN(name_len) + new_size) {
ret = -ENOSPC;
goto out;
}

The subtraction wraps around to a huge value, so the check passes.  That
check is what normally keeps the copy inside the space: with a correct free
space value, it would have returned -ENOSPC.  The copy then goes to s->base
+ min_offs - new_size, which with min_offs being 0 is new_size bytes before
the start of the space.  It overwrites the memory in front of the inode.
Depending on where the write lands, the following issue was also triggered
during testing:

- KASAN: slab-use-after-free Write in ext4_xattr_set_entry

To fix this issue, ext4_xattr_ibody_set() should clear the attribute space
of an inode without EXT4_STATE_XATTR before adding an attribute to it, so
that leftover bytes can no longer be parsed as entries:

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c310747b965..2e5f39b710bd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2274,6 +2274,10 @@ int ext4_xattr_ibody_set(handle_t *handle,
struct inode *inode,
  if (IS_ERR(ea_inode))
  return PTR_ERR(ea_inode);
  }
+
+ if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
+ memset(s->first, 0, s->end - (void *)s->first);
+
  error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
      false /* is_block */);
  if (error) {

With the above patch applied, the reproducer no longer triggers the issue
on our machine.  If this solution is acceptable, we are happy to submit a
formal patch.

The kernel console output, kernel config, syzkaller reproducer, and C
reproducer are available on Google Drive:
https://drive.google.com/drive/folders/1o-aZtZqL93I06eP1GSC8g_0V0QMvbm7U?usp=sharing

Please let us know if any further information is required.

Best regards,
Jiaming Zhang
