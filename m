Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D112E8472
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 00:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555648; cv=none; b=VZ3ujQUabyPM02VkHch023y2xgeXqJVPJEaA13cv4Pi9aHeneVuc5cUuep4Q25Itd1rOobpWjJaV0cdRXPGr4hPPHAXGt2KpoeUPM9+5Fk414MjSdF51kXI1VTfQMkDJPCdQil9FoDuwn8ffbB7NcG4p2OxnpvsA8xuDqFe8VXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555648; c=relaxed/simple;
	bh=G26upqMPQ8wCLsQGyEc/DIBHSMGL4tSOOyVHGvaz9W0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NyQs/+3+OOC/t1WcAEnCsetj9lB6s+PwE7v68TCvRwmsdo2syU+/fwVBeTli6f8KqE05XcpEQ1NRJq7FYGlKpyXm5KfS/mlZ0/GhNRSp6VTNTefYH9NS0otBYVDNP1LtrFUvZ9mjNWSbzkNH/ECwEA8NJyBlKoFVOATYpJego/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6a193269cfdso403003eaf.1
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 17:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555646; x=1784160446;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4tDgcBSVeZFyvqNSj3NPT1ZaqMIC8R3a3L88HwnQO0Y=;
        b=OC3ghEl4FmLDK1/HQYetCmNEyC72FqYXfJ/k6AsTExw3vpKEeDqNjB0JzPXv9Zdjxr
         vJzwZ+aL736yf8vSN/vC9INggv8nMMYpDtKrfQ1o2eZ6CJ+Oi1g8n/yYLbw/WrxsEoHM
         kNfojBvnAqJ0yo8aFJyXky8CV4t7c2HDnUGdH38ANE84Asfv32XfrAYIwLhFYR91LuTy
         xX5oB2EbO+49yvCzxRVoiH0/7qikmnUWQAlqoeg4+YpJe/GAtVS5XESiTaAeBHeJEpJ4
         PMGR8/waOZQb1lsoCJM6RSRRAz1DALXVk37En0wgLsLpkOdvZOkdOJxcuqgx1ePmmlhJ
         7IxQ==
X-Forwarded-Encrypted: i=1; AFNElJ94E4wBNL+fDusHpw9stjeYEcRvF+loSZ5tkuLXh/1sBqP/JOjyl7p1Pd1Ex/11bHWJDocoaoErUna1@vger.kernel.org
X-Gm-Message-State: AOJu0YwPt7y6CGz+fIeNvTdY0Zgfcizwp62NjZlB+ofEBGum3+CTCsrT
	ziwqclh+X2LPKlDfmfjgBq5ROpD2XxR9LuzV8zteIpMT7L29mLJgBLo+216gLoTih+mZ1LP1OQ4
	L3YAbnG2zLS4HOSjy1greAEkNJsW7XbFnYj5Gx/dMYbmcXNtW8J2GaBJxcDw=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a0e:b0:6a1:4507:3535 with SMTP id
 006d021491bc7-6a37da3e071mr391672eaf.38.1783555645780; Wed, 08 Jul 2026
 17:07:25 -0700 (PDT)
Date: Wed, 08 Jul 2026 17:07:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4ee63d.c76b52dc.34afef.0024.GAE@google.com>
Subject: [syzbot] [ext4?] KASAN: use-after-free Read in ext4_search_dir (3)
From: syzbot <syzbot+4eb78541a595c5ad659f@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d2c9a99135da Merge tag 'device-id-rework' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138fec6e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb78541a595c5ad659f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d2c9a991.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c8723eec7ee9/vmlinux-d2c9a991.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f5a482d9ade0/bzImage-d2c9a991.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4eb78541a595c5ad659f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ext4_search_dir+0x180/0x250 fs/ext4/namei.c:1469
Read of size 1 at addr ffff88801323b3aa by task syz.0.0/5323

CPU: 0 UID: 0 PID: 5323 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ext4_search_dir+0x180/0x250 fs/ext4/namei.c:1469
 ext4_find_inline_entry+0x502/0x650 fs/ext4/inline.c:1639
 __ext4_find_entry+0x315/0x1cd0 fs/ext4/namei.c:1542
 ext4_lookup_entry fs/ext4/namei.c:1703 [inline]
 ext4_lookup+0x17b/0x710 fs/ext4/namei.c:1769
 lookup_open fs/namei.c:4481 [inline]
 open_last_lookups fs/namei.c:4608 [inline]
 path_openat+0x111f/0x3830 fs/namei.c:4856
 do_file_open+0x23e/0x4a0 fs/namei.c:4888
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_open fs/open.c:1382 [inline]
 __se_sys_open fs/open.c:1378 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1378
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdc5619de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdc56fc5fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fdc56426090 RCX: 00007fdc5619de59
RDX: 0000000000000000 RSI: 0000000000064842 RDI: 00002000000005c0
RBP: 00007fdc56233e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdc56426128 R14: 00007fdc56426090 R15: 00007ffea8722208
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xa96 pfn:0x1323b
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000a96 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 5322, tgid 5321 (syz.0.0), ts 105785277419, free_ts 105927156983
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
 alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x39/0x160 mm/mempolicy.c:2509
 shmem_alloc_folio mm/shmem.c:1907 [inline]
 shmem_alloc_and_add_folio+0x43e/0xf60 mm/shmem.c:1949
 shmem_get_folio_gfp+0x5da/0x16d0 mm/shmem.c:2502
 shmem_get_folio mm/shmem.c:2608 [inline]
 shmem_write_begin+0x16c/0x330 mm/shmem.c:3239
 generic_perform_write+0x2d5/0x8f0 mm/filemap.c:4358
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3414
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 69 tgid 69 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 free_unref_folios+0xd84/0x14a0 mm/page_alloc.c:3011
 shrink_folio_list+0x2b7d/0x5330 mm/vmscan.c:1513
 evict_folios+0x3821/0x4b40 mm/vmscan.c:4835
 try_to_shrink_lruvec+0xb4f/0xed0 mm/vmscan.c:4983
 shrink_one+0x233/0x730 mm/vmscan.c:5024
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x3303/0x3b60 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x17b6/0x31c0 mm/vmscan.c:7462
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88801323b280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88801323b300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88801323b380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                  ^
 ffff88801323b400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88801323b480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
