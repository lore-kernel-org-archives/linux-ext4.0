Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8192BEC55
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878309; cv=none; b=GwNEp+WSPFJeEbQJuRh4ynPIMNCHapwnL0nf9l0kfQ3OMplf5JBiUgD5Zvcn3Xaqo1NgpyT9kpv/zh9ATIEdupIvd5SW/nXlj+HXNDrwIpv/r3dYSQOTYn8v0rz+lNIU6TJUuI+lxYxCP4CK0fjxtVyaSd6aFiR2voGs7A43cI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878309; c=relaxed/simple;
	bh=lib8CuGzNChQt3AgE37Or8lZhZ+hpNDIjp8k30vh94A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nNfS0sVSErKddvqUll3S9vnJo/brxTi3OGWawlOpCT+qv7ToGmNU8OYrEr2uQAJhTplieWhwO0pCsrknZQR0q6lKN7BJk0ljYAWOdginyVLpuRhRZL6+/t62TIa1h6dGgjtdvK5wLgMs3QRG+T5N7+Mq1ci6TlHnU1VDrRIgmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e6b59d85dcso4569080a34.3
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 07:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781878305; x=1782483105;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tKRhglVLbWWUGp+O768AeaRD65GQ9ZRITkhbNwKpq0g=;
        b=oYaL/NTfshmueh+f+2f1HBnwMLU/ItQciqs6br0DJlrZIHbWa/vP8rf329rqJmru9W
         bC71lOmGVDjx3C34EU7Bse6vaPq3BXWcaVXMfOmB+7BovdKk58rhulWBbDRZKBkocczS
         OfhJt7WUP3buvFIhmYWPzJz9yaP76pCvqeo1gZMjHQBpzqyXKxsCQkwsGw4GZm5I1qc0
         FjTbvsCQeeQzt9ZQO9LlwacRGt4xL5OyUvurtq8yIv8/kKBAFtUYfMbT5eKoBKXBRk/P
         QMm8F4fYvh6F0G3Rj9wMpTANZANENUndZ0YBvjxxqQEZivbwTcDFDwcwl9E3pY1a/qrt
         ECqg==
X-Forwarded-Encrypted: i=1; AFNElJ/shbU7KQSCBiH1bVjblA2OPh7zVVyh21bYrkFI8aYNIQGvFKq4qtEEErzzOONw6BO0rr9Jisjm/Dnr@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Lz6zPuuUmAZMTlY7sdwWkigFl0/ACzEqt+uj/RmyUDlvqU1g
	bUO4Lwv9r4j0Q0cnPdjzzBDlJbUzFEt11q4TdkFygQ64Wsi5u0Uk6kjK7NYKuhAWZoVehL8hSGT
	hdLLCQqVgMzXmSGtwyHJqvbxWC8KDflz3agV5OSmn/+fP2177S4aKqWc1kAU=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b26:b0:486:4892:d553 with SMTP id
 5614622812f47-489ab58d99dmr1792478b6e.0.1781878304978; Fri, 19 Jun 2026
 07:11:44 -0700 (PDT)
Date: Fri, 19 Jun 2026 07:11:44 -0700
In-Reply-To: <CA+rD4x_2wXOP=4RwPY-A2vJjK4Vv9hGUSVFzprCe1H+8MTOKhA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a354e20.ff649fcc.e25e.0004.GAE@google.com>
Subject: Re: [syzbot ci] Re: Data in direntry (dirdata) feature
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: artem.blagodarenko@gmail.com
Cc: adilger@dilger.ca, artem.blagodarenko@gmail.com, 
	linux-ext4@vger.kernel.org, pravin.shelar@sun.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> Thanks for the report. The attached patch addresses the issues found in
> the dirdata series review (dx_get_dx_info/get_dx_countlimit blocksize
> fallback, dfid parameter shadowing in ext4_dirdata_get, and the unsafe
> delete-before-add in EXT4_IOC_SET_LUFID).
>
>
> #syz test

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

>
> On Thu, Jun 11, 2026 11:29 AM, syzbot ci <
> syzbot+cid7b922cb3d448114@syzkaller.appspotmail.com> wrote:
>
>> syzbot ci has tested the following series
>>
>> [v2] Data in direntry (dirdata) feature
>>
>> https://lore.kernel.org/all/20260610152417.13576-1-ablagodarenko@thelustrecollective.com
>> * [PATCH v2 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
>> * [PATCH v2 02/10] ext4: add ext4_dir_entry_is_tail()
>> * [PATCH v2 03/10] ext4: refactor dx_root to support variable dirent sizes
>> * [PATCH v2 04/10] ext4: add dirdata format definitions and access helpers
>> * [PATCH v2 05/10] ext4: preserve dirdata bits in get_dtype()
>> * [PATCH v2 06/10] ext4: add ext4_dir_entry_len() and harden dirdata
>> parsing
>> * [PATCH v2 07/10] ext4: rename ext4_dir_rec_len() and clarify dirdata
>> usage
>> * [PATCH v2 08/10] ext4: dirdata feature
>> * [PATCH v2 09/10] ext4: add dirdata set/get helpers
>> * [PATCH v2 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on
>> directory entries
>>
>> and found the following issues:
>> * KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
>> * KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
>> * KASAN: slab-use-after-free Read in __ext4_check_dir_entry
>> * KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
>> * KASAN: use-after-free Read in __ext4_check_dir_entry
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/5bf0e2fa-2e68-4532-8396-4568879b2788
>>
>> ***
>>
>> KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
>>
>> tree:      torvalds
>> URL:
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8
>> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> config:
>> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
>> syz repro:
>> https://ci.syzbot.org/findings/b0854918-13f9-49dd-ab30-12154f0debe2/syz_repro
>>
>> loop0: lost filesystem error report for type 5 error -117
>> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
>> r/w without journal. Quota mode: none.
>> ==================================================================
>> BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len
>> fs/ext4/ext4.h:4069 [inline]
>> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4096
>> [inline]
>> BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x65a/0xc40
>> fs/ext4/dir.c:96
>> Read of size 1 at addr ffff8881022db7f5 by task syz.0.23/5815
>>
>> CPU: 1 UID: 0 PID: 5815 Comm: syz.0.23 Not tainted syzkaller #0
>> PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.2-debian-1.16.2-1 04/01/2014
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>>  ext4_check_all_de+0x66/0x150 fs/ext4/dir.c:657
>>  ext4_convert_inline_data_nolock+0x1b7/0x990 fs/ext4/inline.c:1121
>>  ext4_try_add_inline_entry+0x604/0x8e0 fs/ext4/inline.c:1247
>>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>>  ext4_mkdir+0x5e5/0xce0 fs/ext4/namei.c:3175
>>  vfs_mkdir+0x413/0x630 fs/namei.c:5271
>>  filename_mkdirat+0x285/0x510 fs/namei.c:5304
>>  __do_sys_mkdirat fs/namei.c:5325 [inline]
>>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5322
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f669359bcc7
>> Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff
>> ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff
>> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffd42381d38 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
>> RAX: ffffffffffffffda RBX: 00007ffd42381dc0 RCX: 00007f669359bcc7
>> RDX: 00000000000001ff RSI: 0000200000001200 RDI: 00000000ffffff9c
>> RBP: 00002000000024c0 R08: 0000200000000240 R09: 0000000000000000
>> R10: 00002000000024c0 R11: 0000000000000246 R12: 0000200000001200
>> R13: 00007ffd42381d80 R14: 0000000000000000 R15: 0000000000000000
>>  </TASK>
>>
>> Allocated by task 5066:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5420
>>  kmalloc_noprof include/linux/slab.h:950 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  kernfs_get_open_node fs/kernfs/file.c:543 [inline]
>>  kernfs_fop_open+0x862/0xda0 fs/kernfs/file.c:718
>>  do_dentry_open+0x822/0x13a0 fs/open.c:947
>>  vfs_open+0x3b/0x340 fs/open.c:1079
>>  do_open fs/namei.c:4699 [inline]
>>  path_openat+0x2e08/0x3860 fs/namei.c:4858
>>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>>  do_sys_open fs/open.c:1370 [inline]
>>  __do_sys_openat fs/open.c:1386 [inline]
>>  __se_sys_openat fs/open.c:1381 [inline]
>>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> Last potentially related work creation:
>>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>>  kvfree_call_rcu+0x100/0x430 mm/slab_common.c:1970
>>  kernfs_unlink_open_file+0x3fe/0x4b0 fs/kernfs/file.c:604
>>  kernfs_fop_release+0x2eb/0x440 fs/kernfs/file.c:783
>>  __fput+0x44f/0xa60 fs/file_table.c:510
>>  fput_close_sync+0x11f/0x240 fs/file_table.c:615
>>  __do_sys_close fs/open.c:1507 [inline]
>>  __se_sys_close fs/open.c:1492 [inline]
>>  __x64_sys_close+0x7e/0x110 fs/open.c:1492
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> The buggy address belongs to the object at ffff8881022db700
>>  which belongs to the cache kmalloc-128 of size 128
>> The buggy address is located 117 bytes to the right of
>>  allocated 128-byte region [ffff8881022db700, ffff8881022db780)
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1022db
>> flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
>> page_type: f5(slab)
>> raw: 017ff00000000000 ffff888100041a00 dead000000000100 dead000000000122
>> raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask
>> 0xd2000(__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 0,
>> tgid 0 (swapper/0), ts 2408938923, free_ts 0
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>>  prep_new_page mm/page_alloc.c:1861 [inline]
>>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>>  alloc_slab_page mm/slub.c:3278 [inline]
>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>  new_slab mm/slub.c:3525 [inline]
>>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>>  refill_sheaf mm/slub.c:2816 [inline]
>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>>  alloc_from_pcs mm/slub.c:4750 [inline]
>>  slab_alloc_node mm/slub.c:4884 [inline]
>>  __do_kmalloc_node mm/slub.c:5295 [inline]
>>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  __alloc_empty_sheaf mm/slub.c:2768 [inline]
>>  alloc_empty_sheaf mm/slub.c:2783 [inline]
>>  __pcs_replace_empty_main+0x2df/0x720 mm/slub.c:4647
>>  alloc_from_pcs mm/slub.c:4750 [inline]
>>  slab_alloc_node mm/slub.c:4884 [inline]
>>  kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4906
>>  dup_fd+0x55/0xb40 fs/file.c:390
>>  copy_files+0xc8/0x120 kernel/fork.c:1639
>>  copy_process+0x1d94/0x4440 kernel/fork.c:2252
>>  kernel_clone+0x2d7/0x940 kernel/fork.c:2722
>>  user_mode_thread+0x110/0x180 kernel/fork.c:2798
>>  rest_init+0x23/0x300 init/main.c:727
>>  start_kernel+0x38a/0x3e0 init/main.c:1220
>> page_owner free stack trace missing
>>
>> Memory state around the buggy address:
>>  ffff8881022db680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff8881022db700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >ffff8881022db780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>                                                              ^
>>  ffff8881022db800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>  ffff8881022db880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ***
>>
>> KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
>>
>> tree:      torvalds
>> URL:
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8
>> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> config:
>> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
>> syz repro:
>> https://ci.syzbot.org/findings/2dff870b-f382-4c93-8d8d-b2291d921224/syz_repro
>>
>> loop1: lost filesystem error report for type 5 error -117
>> EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000
>> r/w without journal. Quota mode: none.
>> ==================================================================
>> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4095
>> [inline]
>> BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xda5/0x10d0
>> fs/ext4/inline.c:1335
>> Read of size 2 at addr ffff888115a3183c by task syz.1.18/5839
>>
>> CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Not tainted syzkaller #0
>> PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.2-debian-1.16.2-1 04/01/2014
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>  ext4_dir_entry_len fs/ext4/ext4.h:4095 [inline]
>>  ext4_inlinedir_to_tree+0xda5/0x10d0 fs/ext4/inline.c:1335
>>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>>  iterate_dir+0x399/0x570 fs/readdir.c:110
>>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f3e02b9ce59
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f3e03ad5028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
>> RAX: ffffffffffffffda RBX: 00007f3e02e15fa0 RCX: 00007f3e02b9ce59
>> RDX: 0000000000001000 RSI: 0000200000000f80 RDI: 0000000000000004
>> RBP: 00007f3e02c32d6f R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f3e02e16038 R14: 00007f3e02e15fa0 R15: 00007ffcaa902298
>>  </TASK>
>>
>> Allocated by task 5839:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>>  __do_kmalloc_node mm/slub.c:5296 [inline]
>>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  ext4_inlinedir_to_tree+0x312/0x10d0 fs/ext4/inline.c:1292
>>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>>  iterate_dir+0x399/0x570 fs/readdir.c:110
>>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> The buggy address belongs to the object at ffff888115a31800
>>  which belongs to the cache kmalloc-64 of size 64
>> The buggy address is located 0 bytes to the right of
>>  allocated 60-byte region [ffff888115a31800, ffff888115a3183c)
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115a31
>> flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
>> page_type: f5(slab)
>> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
>> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask
>> 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
>> pid 5051, tgid 5051 (acpid), ts 27203740677, free_ts 27201732767
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>>  prep_new_page mm/page_alloc.c:1861 [inline]
>>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>>  alloc_slab_page mm/slub.c:3278 [inline]
>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>  new_slab mm/slub.c:3525 [inline]
>>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>>  refill_sheaf mm/slub.c:2816 [inline]
>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>>  alloc_from_pcs mm/slub.c:4750 [inline]
>>  slab_alloc_node mm/slub.c:4884 [inline]
>>  __do_kmalloc_node mm/slub.c:5295 [inline]
>>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  tomoyo_get_name+0x20c/0x590 security/tomoyo/memory.c:173
>>  tomoyo_parse_name_union+0xd9/0x130 security/tomoyo/util.c:260
>>  tomoyo_update_path_acl security/tomoyo/file.c:399 [inline]
>>  tomoyo_write_file+0x3a6/0xc50 security/tomoyo/file.c:1027
>>  tomoyo_write_domain2 security/tomoyo/common.c:1160 [inline]
>>  tomoyo_add_entry security/tomoyo/common.c:2177 [inline]
>>  tomoyo_supervisor+0x1208/0x1570 security/tomoyo/common.c:2238
>>  tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]
>>  tomoyo_path_permission+0x25a/0x380 security/tomoyo/file.c:592
>>  tomoyo_check_open_permission+0x2b2/0x470 security/tomoyo/file.c:782
>>  security_file_open+0xa9/0x240 security/security.c:2739
>>  do_dentry_open+0x4a8/0x13a0 fs/open.c:924
>>  vfs_open+0x3b/0x340 fs/open.c:1079
>> page last free pid 15 tgid 15 stack trace:
>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>>  kthread+0x389/0x470 kernel/kthread.c:436
>>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>
>> Memory state around the buggy address:
>>  ffff888115a31700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>  ffff888115a31780: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>> >ffff888115a31800: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>>                                         ^
>>  ffff888115a31880: 00 00 00 00 00 00 02 fc fc fc fc fc fc fc fc fc
>>  ffff888115a31900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ***
>>
>> KASAN: slab-use-after-free Read in __ext4_check_dir_entry
>>
>> tree:      torvalds
>> URL:
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8
>> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> config:
>> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
>> syz repro:
>> https://ci.syzbot.org/findings/f1d48ea1-6e87-4d64-9c13-8bf8aed109fc/syz_repro
>>
>> loop0: lost filesystem error report for type 5 error -117
>> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
>> r/w without journal. Quota mode: none.
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len
>> fs/ext4/ext4.h:4069 [inline]
>> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
>> [inline]
>> BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x65a/0xc40
>> fs/ext4/dir.c:96
>> Read of size 1 at addr ffff888114d8c045 by task syz.0.20/5821
>>
>> CPU: 1 UID: 0 PID: 5821 Comm: syz.0.20 Not tainted syzkaller #0
>> PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.2-debian-1.16.2-1 04/01/2014
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>>  ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203
>>  ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984
>>  ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213
>>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>>  ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936
>>  ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982
>>  lookup_open fs/namei.c:4511 [inline]
>>  open_last_lookups fs/namei.c:4611 [inline]
>>  path_openat+0x1395/0x3860 fs/namei.c:4855
>>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>>  do_sys_open fs/open.c:1370 [inline]
>>  __do_sys_openat fs/open.c:1386 [inline]
>>  __se_sys_openat fs/open.c:1381 [inline]
>>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f922219ce59
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f9223137028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00007f9222415fa0 RCX: 00007f922219ce59
>> RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004
>> RBP: 00007f9222232d6f R08: 0000000000000000 R09: 0000000000000000
>> R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f9222416038 R14: 00007f9222415fa0 R15: 00007ffd01a2d448
>>  </TASK>
>>
>> Allocated by task 5484:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>  slab_post_alloc_hook mm/slub.c:4570 [inline]
>>  slab_alloc_node mm/slub.c:4899 [inline]
>>  kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4951
>>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>>  alloc_skb include/linux/skbuff.h:1385 [inline]
>>  nlmsg_new include/net/netlink.h:1055 [inline]
>>  mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217
>>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>>  process_one_work kernel/workqueue.c:3314 [inline]
>>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>>  kthread+0x389/0x470 kernel/kthread.c:436
>>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>
>> Freed by task 5484:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>>  poison_slab_object mm/kasan/common.c:253 [inline]
>>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>>  kasan_slab_free include/linux/kasan.h:235 [inline]
>>  slab_free_hook mm/slub.c:2689 [inline]
>>  slab_free mm/slub.c:6251 [inline]
>>  kfree+0x1c5/0x640 mm/slub.c:6566
>>  skb_kfree_head net/core/skbuff.c:1075 [inline]
>>  skb_free_head net/core/skbuff.c:1087 [inline]
>>  skb_release_data+0x828/0xa60 net/core/skbuff.c:1114
>>  skb_release_all net/core/skbuff.c:1189 [inline]
>>  __kfree_skb+0x5d/0x210 net/core/skbuff.c:1203
>>  netlink_broadcast_filtered+0xe18/0xf20 net/netlink/af_netlink.c:1540
>>  nlmsg_multicast_filtered include/net/netlink.h:1165 [inline]
>>  nlmsg_multicast include/net/netlink.h:1184 [inline]
>>  nlmsg_notify+0xf0/0x1a0 net/netlink/af_netlink.c:2598
>>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>>  process_one_work kernel/workqueue.c:3314 [inline]
>>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>>  kthread+0x389/0x470 kernel/kthread.c:436
>>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>
>> The buggy address belongs to the object at ffff888114d8c000
>>  which belongs to the cache skbuff_small_head of size 704
>> The buggy address is located 69 bytes inside of
>>  freed 704-byte region [ffff888114d8c000, ffff888114d8c2c0)
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x114d8c
>> head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>> flags: 0x17ff00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
>> page_type: f5(slab)
>> raw: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122
>> raw: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
>> head: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122
>> head: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
>> head: 017ff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
>> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 2, migratetype Unmovable, gfp_mask
>> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
>> pid 5484, tgid 5484 (kworker/u8:2), ts 72573003529, free_ts 72546506446
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>>  prep_new_page mm/page_alloc.c:1861 [inline]
>>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>>  alloc_slab_page mm/slub.c:3278 [inline]
>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>  new_slab mm/slub.c:3525 [inline]
>>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>>  refill_sheaf mm/slub.c:2816 [inline]
>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>>  alloc_from_pcs mm/slub.c:4750 [inline]
>>  slab_alloc_node mm/slub.c:4884 [inline]
>>  kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4951
>>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>>  alloc_skb include/linux/skbuff.h:1385 [inline]
>>  nlmsg_new include/net/netlink.h:1055 [inline]
>>  mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217
>>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>>  process_one_work kernel/workqueue.c:3314 [inline]
>>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>> page last free pid 5484 tgid 5484 stack trace:
>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>>  stack_depot_save_flags+0x40e/0x810 lib/stackdepot.c:735
>>  kasan_save_stack mm/kasan/common.c:58 [inline]
>>  kasan_save_track+0x4f/0x80 mm/kasan/common.c:78
>>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>  slab_post_alloc_hook mm/slub.c:4570 [inline]
>>  slab_alloc_node mm/slub.c:4899 [inline]
>>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4906
>>  kmem_alloc_batch lib/debugobjects.c:371 [inline]
>>  fill_pool+0x156/0x580 lib/debugobjects.c:420
>>  debug_objects_fill_pool lib/debugobjects.c:752 [inline]
>>  debug_object_activate+0x4a3/0x580 lib/debugobjects.c:841
>>  debug_rcu_head_queue kernel/rcu/rcu.h:236 [inline]
>>  __call_rcu_common kernel/rcu/tree.c:3116 [inline]
>>  call_rcu+0x43/0x890 kernel/rcu/tree.c:3251
>>  kernfs_put+0x259/0x520 fs/kernfs/dir.c:618
>>  kernfs_remove_by_name_ns+0xc8/0x140 fs/kernfs/dir.c:1799
>>  device_remove_class_symlinks+0x178/0x190 drivers/base/core.c:3479
>>  device_del+0x400/0x8f0 drivers/base/core.c:3881
>>  unregister_netdevice_many_notify+0x1d5f/0x22c0 net/core/dev.c:12456
>>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>>  process_one_work kernel/workqueue.c:3314 [inline]
>>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>>
>> Memory state around the buggy address:
>>  ffff888114d8bf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>  ffff888114d8bf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >ffff888114d8c000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                            ^
>>  ffff888114d8c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>  ffff888114d8c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ==================================================================
>>
>>
>> ***
>>
>> KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
>>
>> tree:      torvalds
>> URL:
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8
>> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> config:
>> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
>> syz repro:
>> https://ci.syzbot.org/findings/f42da242-e16e-4f10-bf25-0bd7e192d989/syz_repro
>>
>> loop0: lost filesystem error report for type 5 error -117
>> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
>> r/w without journal. Quota mode: none.
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len
>> fs/ext4/ext4.h:4069 [inline]
>> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
>> [inline]
>> BUG: KASAN: slab-use-after-free in ext4_inlinedir_to_tree+0x94c/0x10d0
>> fs/ext4/inline.c:1335
>> Read of size 1 at addr ffff88816fee8825 by task syz.0.20/5867
>>
>> CPU: 1 UID: 0 PID: 5867 Comm: syz.0.20 Not tainted syzkaller #0
>> PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.2-debian-1.16.2-1 04/01/2014
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>>  ext4_inlinedir_to_tree+0x94c/0x10d0 fs/ext4/inline.c:1335
>>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>>  iterate_dir+0x399/0x570 fs/readdir.c:110
>>  __do_sys_getdents fs/readdir.c:319 [inline]
>>  __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f010ad9ce59
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f010bc0f028 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
>> RAX: ffffffffffffffda RBX: 00007f010b015fa0 RCX: 00007f010ad9ce59
>> RDX: 0000000000000054 RSI: 0000000000000000 RDI: 0000000000000004
>> RBP: 00007f010ae32d6f R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f010b016038 R14: 00007f010b015fa0 R15: 00007ffd93577348
>>  </TASK>
>>
>> Allocated by task 5064:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>>  __do_kmalloc_node mm/slub.c:5296 [inline]
>>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
>>  tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80
>>  tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283
>>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>>  security_inode_getattr+0x12b/0x310 security/security.c:1895
>>  vfs_getattr fs/stat.c:259 [inline]
>>  vfs_fstat fs/stat.c:281 [inline]
>>  vfs_fstatat+0xb4/0x170 fs/stat.c:371
>>  __do_sys_newfstatat fs/stat.c:538 [inline]
>>  __se_sys_newfstatat fs/stat.c:532 [inline]
>>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> Freed by task 5064:
>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>>  poison_slab_object mm/kasan/common.c:253 [inline]
>>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>>  kasan_slab_free include/linux/kasan.h:235 [inline]
>>  slab_free_hook mm/slub.c:2689 [inline]
>>  slab_free mm/slub.c:6251 [inline]
>>  kfree+0x1c5/0x640 mm/slub.c:6566
>>  tomoyo_path_perm+0x403/0x560 security/tomoyo/file.c:847
>>  security_inode_getattr+0x12b/0x310 security/security.c:1895
>>  vfs_getattr fs/stat.c:259 [inline]
>>  vfs_fstat fs/stat.c:281 [inline]
>>  vfs_fstatat+0xb4/0x170 fs/stat.c:371
>>  __do_sys_newfstatat fs/stat.c:538 [inline]
>>  __se_sys_newfstatat fs/stat.c:532 [inline]
>>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> The buggy address belongs to the object at ffff88816fee8800
>>  which belongs to the cache kmalloc-64 of size 64
>> The buggy address is located 37 bytes inside of
>>  freed 64-byte region [ffff88816fee8800, ffff88816fee8840)
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16fee8
>> flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
>> page_type: f5(slab)
>> raw: 057ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
>> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask
>> 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
>> pid 1, tgid 1 (swapper/0), ts 21294026082, free_ts 0
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>>  prep_new_page mm/page_alloc.c:1861 [inline]
>>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>>  alloc_slab_page mm/slub.c:3278 [inline]
>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>  new_slab mm/slub.c:3525 [inline]
>>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>>  refill_sheaf mm/slub.c:2816 [inline]
>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>>  alloc_from_pcs mm/slub.c:4750 [inline]
>>  slab_alloc_node mm/slub.c:4884 [inline]
>>  __do_kmalloc_node mm/slub.c:5295 [inline]
>>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  handler_new_ref+0x261/0x9c0 drivers/media/v4l2-core/v4l2-ctrls-core.c:1882
>>  v4l2_ctrl_add_handler+0x19f/0x290
>> drivers/media/v4l2-core/v4l2-ctrls-core.c:2443
>>  vivid_create_controls+0x332d/0x3bd0
>> drivers/media/test-drivers/vivid/vivid-ctrls.c:2072
>>  vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1933
>> [inline]
>>  vivid_probe+0x4261/0x72b0
>> drivers/media/test-drivers/vivid/vivid-core.c:2095
>>  platform_probe+0xf9/0x190 drivers/base/platform.c:1432
>>  call_driver_probe drivers/base/dd.c:-1 [inline]
>>  really_probe+0x267/0xaf0 drivers/base/dd.c:709
>>  __driver_probe_device+0x1ef/0x380 drivers/base/dd.c:871
>>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:901
>>  __driver_attach+0x34c/0x640 drivers/base/dd.c:1295
>> page_owner free stack trace missing
>>
>> Memory state around the buggy address:
>>  ffff88816fee8700: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>>  ffff88816fee8780: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>> >ffff88816fee8800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>                                ^
>>  ffff88816fee8880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>  ffff88816fee8900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ***
>>
>> KASAN: use-after-free Read in __ext4_check_dir_entry
>>
>> tree:      torvalds
>> URL:
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8
>> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>> config:
>> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
>> syz repro:
>> https://ci.syzbot.org/findings/57c0b75a-8922-4dc1-9a20-ca947564792b/syz_repro
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4069
>> [inline]
>> BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
>> [inline]
>> BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x65a/0xc40
>> fs/ext4/dir.c:96
>> Read of size 1 at addr ffff88816be85045 by task syz.2.21/5880
>>
>> CPU: 1 UID: 0 PID: 5880 Comm: syz.2.21 Not tainted syzkaller #0
>> PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.16.2-debian-1.16.2-1 04/01/2014
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>>  ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203
>>  ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984
>>  ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213
>>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>>  ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936
>>  ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982
>>  lookup_open fs/namei.c:4511 [inline]
>>  open_last_lookups fs/namei.c:4611 [inline]
>>  path_openat+0x1395/0x3860 fs/namei.c:4855
>>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>>  do_sys_open fs/open.c:1370 [inline]
>>  __do_sys_openat fs/open.c:1386 [inline]
>>  __se_sys_openat fs/open.c:1381 [inline]
>>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f5713b9ce59
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fff672b25f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 00007f5713e15fa0 RCX: 00007f5713b9ce59
>> RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004
>> RBP: 00007f5713c32d6f R08: 0000000000000000 R09: 0000000000000000
>> R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f5713e15fac R14: 00007f5713e15fa0 R15: 00007f5713e15fa0
>>  </TASK>
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16be85
>> flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
>> page_type: f0(buddy)
>> raw: 057ff00000000000 ffffea0005afa0c8 ffffea0005afa1c8 0000000000000000
>> raw: 0000000000000000 0000000000000000 00000000f0000000 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as freed
>> page last allocated via order 0, migratetype Unmovable, gfp_mask
>> 0xcc0(GFP_KERNEL), pid 5630, tgid 5630 (syz-executor), ts 67290853657,
>> free_ts 69321168948
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>>  prep_new_page mm/page_alloc.c:1861 [inline]
>>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>>  __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
>>  alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
>>  ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
>>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
>>  __kasan_populate_vmalloc+0xc1/0x1d0 mm/kasan/shadow.c:424
>>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>>  alloc_vmap_area+0xd47/0x1480 mm/vmalloc.c:2123
>>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3226
>>  __vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:4024
>>  vmalloc_user_noprof+0xad/0xe0 mm/vmalloc.c:4218
>>  kcov_ioctl+0x55/0x620 kernel/kcov.c:726
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> page last free pid 5693 tgid 5693 stack trace:
>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>>  kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:484
>>  apply_to_pte_range mm/memory.c:3338 [inline]
>>  apply_to_pmd_range mm/memory.c:3382 [inline]
>>  apply_to_pud_range mm/memory.c:3418 [inline]
>>  apply_to_p4d_range mm/memory.c:3454 [inline]
>>  __apply_to_page_range+0xbdc/0x1420 mm/memory.c:3490
>>  __kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:602
>>  kasan_release_vmalloc include/linux/kasan.h:593 [inline]
>>  kasan_release_vmalloc_node mm/vmalloc.c:2284 [inline]
>>  purge_vmap_node+0x220/0x960 mm/vmalloc.c:2306
>>  __purge_vmap_area_lazy+0x779/0xb40 mm/vmalloc.c:2396
>>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2430
>>  process_one_work kernel/workqueue.c:3314 [inline]
>>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>>  kthread+0x389/0x470 kernel/kthread.c:436
>>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>
>> Memory state around the buggy address:
>>  ffff88816be84f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>  ffff88816be84f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> >ffff88816be85000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>                                            ^
>>  ffff88816be85080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  ffff88816be85100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ==================================================================
>>
>>
>> ***
>>
>> If these findings have caused you to resend the series or submit a
>> separate fix, please add the following tag to your commit message:
>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>
>> To test a patch for this bug, please reply with `#syz test`
>> (should be on a separate line).
>>
>> The patch should be attached to the email.
>> Note: arguments like custom git repos and branches are not supported.
>>
>>
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/CA%2BrD4x_2wXOP%3D4RwPY-A2vJjK4Vv9hGUSVFzprCe1H%2B8MTOKhA%40mail.gmail.com.
