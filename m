Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7178737BE95
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878280; cv=pass; b=BsK+Aca2ALzpp1akPdU16H+vQSeGnRbWoNZkChIvXjsmCrqW1zXPpI2x+PYCPEZ97XuM3MNHFWsV1rAJ5FK0+2KUw1RH3+p4cstLQwEoyzpI1e3ZeVRMNAo9fNnAAVi4TjjVXNZYQVKBGpVfEGO8wPFA3w4XeWx0q5QcrmnGfmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878280; c=relaxed/simple;
	bh=lhZwGw0Zuo5vQLYFEoRsJPKl1WCQvsLn7v/qu3T79FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BksKB61pCrxWjs18bVjTWHBaq9nIH8xiyC828dZgkLRsiM8dtmwV7tnS5ZDe6tZ7QUUVycwrMMzMyR+P0vefRUNaedQoCblS8R9adEhpLUhU1dFBXAvsvw+UMdslROHx16LC9wrxjxwwqmsYpUjbPnghbarret0AGxRuJ2pu93U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVkIBdAC; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVkIBdAC"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7fd3801ca22so16881107b3.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 07:11:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781878270; cv=none;
        d=google.com; s=arc-20240605;
        b=HvwGIZF+hsUxAFUxCOliyQn7eLh6qEwCOWOJZrFTtMIXk6tq9sTylN2sNh3GeWKyrp
         gr0q0/ellIaxXwGg028+nQ+wU5/6Yhh19TG3Y1GqgyHyjKTevcioVFLWFTS8Z6fyPgaR
         b/8J6LwyDPRJstM712FbHyCVqF9E6RPcPzYuqfe9vAA2YpsnXuyGtL7xQW6dMt4Nf89C
         Zt3XB8NoutbnWzQFx/3Pgo9jswihIiC/4xXvTtzn5vPM3ttOUgsdqcULZYo8++8c1tW0
         mRTTN1X5lx4/H0hfAJSfX8gihaDH1VK1vpfIkKV3bK06CQLij3ZhmTqJFXjExqZZo7+L
         lMaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xsltvUv/GVJO6lJSnu2++yzIfHJ68rrkedbCW/ht3vg=;
        fh=LE3R8j/RCWTwmufjC99rtIr0xOUJJl7a8LDorDoQfsE=;
        b=eG0fZt2RoB0s9QBSLCRD7bH4toUso88dkLaf6cICaBgZHfB2OkfGiSRKZdwfzSavYO
         GcR/ZWvjVcaj9Wcgs9Eg739xkn0Go3vMlQnU/1+t0/fhLGYdGV+pRSBA4g8hSeYJT4jD
         FcFz7si+y7NMmJq4EhCuEPj8jFgaoitdu/KqWLOKotZ/2472LX7gcbiU/wATSKLmV305
         DbjuLULXkFoadh0FBMkLSX9Lal8U7030JGsD0t9IRiZ3LB8FgQ4jj9KZep35L6e++Xy9
         Lgk3lvVKYUb4KmXQLeWykqTL9JbFxJKgHGFwjff0+5y1sfEw+EmafrL1qKstuK/bWVtx
         PWkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781878270; x=1782483070; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xsltvUv/GVJO6lJSnu2++yzIfHJ68rrkedbCW/ht3vg=;
        b=PVkIBdACBKXD0iiQBWuxpKO3PTlxJA5bUfu2ZDrOEx+geOyylEb1nuX/2Jyjg4/efw
         GrrsruucvErcqWpD58NOuoyuevlFhuw2xprAXaWTSDMum72lG4uCw4FOeqStc/Ykhtoc
         5Nn2AWku4oEhku3e7lO0IZM9NyYvyL5HdtGzpYKxmhrYemR7stX8QkIoZvZ5WeUsUW3Q
         vrvHXkw3dxm5ESfXAzTRYBAL1io1CxbLd2MoOJcsOqKspLI2Toqxy6pdQb8Q2TBDK3El
         v8lpcVOeSmDyJGY3zmE/wEHMfAFsudrJNti+8Q16Ah2GRMOqmH5D+Z/NR0DpMatOE+d0
         Jxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781878270; x=1782483070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsltvUv/GVJO6lJSnu2++yzIfHJ68rrkedbCW/ht3vg=;
        b=A6j13XsVIsZKQU4VJ8MnQn3laN1WjUtbnUhqmMIUZdkU8zf4yCzD63xBsxGVYAISZS
         +Ay26khTtPaAQOENYbkmqGcvtXJIB3r7Vu1dsS7rMuawYrG+0vwyqspI/xopLyLPsdy9
         MWi9QQKOPPOS96UpGz/WaTKB/Yd/MUFdPw6ldUwmXU9lT2jggoTyKREr1z8gN/0AFqNF
         jK7gigasGcIBJbPfUsJteCGVYJ4J+3jFMYO5ZvYliNPKIPDLcVfGLk/XXIpnamYEz8Km
         3LpX3Yi+nahNwh9yMwXnTdCQsUTDWAcwgqzoQrDaze3Ne3IGPRbOnvQTxf2vMjem0PL5
         2bzQ==
X-Forwarded-Encrypted: i=1; AFNElJ88bO0V9el1iCmEQWHn5bf2OoNRv1J9AkYF3OR7RfmeW/0ImQi0nFhY6F6AAtdwVQju5wWO3N1JTxs6@vger.kernel.org
X-Gm-Message-State: AOJu0YxaE0i1XLfPO9U6hRN9nNN8pC7Spil7G/bGgXG+ZHFQ31JpYWwZ
	ULyhfg3MELSWy9GV8bfINLsh92Izu83ktiSEYTp1sakQsfsmGm4OFTeTWHaczQz8+Bj7PVq93Lh
	sXBoMjuo/5uP49c02grEnmfTsJXQX4NM=
X-Gm-Gg: AfdE7clMRQXYmpdyhIY3r7ZLXnIxt/z5ojXsXiAFAoj3c3lKvL7DfQwblwKKNy0FGKY
	uLU4oN0fd3xJtXf2kGmIQI8kebr5o11BpDkdBlw+GQzzoUW7+rPZ6vlwZcASpLY4lUDYWd4UFxX
	n16wRftRyKp/2nmEdIUBwtiYEUdqhlUjn+J8skmGIiJR3PHnXFiidGG3g+KCTkRN210EZR0dUoQ
	ulNuA40P1Qy6EvsqybHV3alCvElCkoPhkgrY6TTi7Vq5jReGlbHoEvNKvwU1pUpbT8QFHXXsET9
	IymcZvD8lxo3uGJbqzTv4T22YOTCxg==
X-Received: by 2002:a05:690c:698d:b0:7db:d730:4b8c with SMTP id
 00721157ae682-801361f85e9mr40148747b3.32.1781878270016; Fri, 19 Jun 2026
 07:11:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com> <6a2a8e0d.3b0a2d4e.8c8d1.000f.GAE@google.com>
In-Reply-To: <6a2a8e0d.3b0a2d4e.8c8d1.000f.GAE@google.com>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Fri, 19 Jun 2026 15:10:58 +0100
X-Gm-Features: AVVi8CeWQnPcpqIh52mHWPNdSqvhBjetpeMmO5JhP6nKh14nWmevCQfSmRw-Qzw
Message-ID: <CA+rD4x_2wXOP=4RwPY-A2vJjK4Vv9hGUSVFzprCe1H+8MTOKhA@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Data in direntry (dirdata) feature
To: adilger@dilger.ca, artem.blagodarenko@gmail.com, 
	linux-ext4@vger.kernel.org, pravin.shelar@sun.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="000000000000518ee606549bdd5d"

--000000000000518ee606549bdd5d
Content-Type: multipart/alternative; boundary="000000000000518ee506549bdd5b"

--000000000000518ee506549bdd5b
Content-Type: text/plain; charset="UTF-8"

Thanks for the report. The attached patch addresses the issues found in
the dirdata series review (dx_get_dx_info/get_dx_countlimit blocksize
fallback, dfid parameter shadowing in ext4_dirdata_get, and the unsafe
delete-before-add in EXT4_IOC_SET_LUFID).


#syz test

On Thu, Jun 11, 2026 11:29 AM, syzbot ci <
syzbot+cid7b922cb3d448114@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
>
> [v2] Data in direntry (dirdata) feature
>
> https://lore.kernel.org/all/20260610152417.13576-1-ablagodarenko@thelustrecollective.com
> * [PATCH v2 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
> * [PATCH v2 02/10] ext4: add ext4_dir_entry_is_tail()
> * [PATCH v2 03/10] ext4: refactor dx_root to support variable dirent sizes
> * [PATCH v2 04/10] ext4: add dirdata format definitions and access helpers
> * [PATCH v2 05/10] ext4: preserve dirdata bits in get_dtype()
> * [PATCH v2 06/10] ext4: add ext4_dir_entry_len() and harden dirdata
> parsing
> * [PATCH v2 07/10] ext4: rename ext4_dir_rec_len() and clarify dirdata
> usage
> * [PATCH v2 08/10] ext4: dirdata feature
> * [PATCH v2 09/10] ext4: add dirdata set/get helpers
> * [PATCH v2 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on
> directory entries
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
> * KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
> * KASAN: slab-use-after-free Read in __ext4_check_dir_entry
> * KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
> * KASAN: use-after-free Read in __ext4_check_dir_entry
>
> Full report is available here:
> https://ci.syzbot.org/series/5bf0e2fa-2e68-4532-8396-4568879b2788
>
> ***
>
> KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8
> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:
> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
> syz repro:
> https://ci.syzbot.org/findings/b0854918-13f9-49dd-ab30-12154f0debe2/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
> r/w without journal. Quota mode: none.
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len
> fs/ext4/ext4.h:4069 [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4096
> [inline]
> BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x65a/0xc40
> fs/ext4/dir.c:96
> Read of size 1 at addr ffff8881022db7f5 by task syz.0.23/5815
>
> CPU: 1 UID: 0 PID: 5815 Comm: syz.0.23 Not tainted syzkaller #0
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>  ext4_check_all_de+0x66/0x150 fs/ext4/dir.c:657
>  ext4_convert_inline_data_nolock+0x1b7/0x990 fs/ext4/inline.c:1121
>  ext4_try_add_inline_entry+0x604/0x8e0 fs/ext4/inline.c:1247
>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>  ext4_mkdir+0x5e5/0xce0 fs/ext4/namei.c:3175
>  vfs_mkdir+0x413/0x630 fs/namei.c:5271
>  filename_mkdirat+0x285/0x510 fs/namei.c:5304
>  __do_sys_mkdirat fs/namei.c:5325 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5322
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f669359bcc7
> Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff
> ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd42381d38 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007ffd42381dc0 RCX: 00007f669359bcc7
> RDX: 00000000000001ff RSI: 0000200000001200 RDI: 00000000ffffff9c
> RBP: 00002000000024c0 R08: 0000200000000240 R09: 0000000000000000
> R10: 00002000000024c0 R11: 0000000000000246 R12: 0000200000001200
> R13: 00007ffd42381d80 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
> Allocated by task 5066:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5420
>  kmalloc_noprof include/linux/slab.h:950 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  kernfs_get_open_node fs/kernfs/file.c:543 [inline]
>  kernfs_fop_open+0x862/0xda0 fs/kernfs/file.c:718
>  do_dentry_open+0x822/0x13a0 fs/open.c:947
>  vfs_open+0x3b/0x340 fs/open.c:1079
>  do_open fs/namei.c:4699 [inline]
>  path_openat+0x2e08/0x3860 fs/namei.c:4858
>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>  do_sys_open fs/open.c:1370 [inline]
>  __do_sys_openat fs/open.c:1386 [inline]
>  __se_sys_openat fs/open.c:1381 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  kvfree_call_rcu+0x100/0x430 mm/slab_common.c:1970
>  kernfs_unlink_open_file+0x3fe/0x4b0 fs/kernfs/file.c:604
>  kernfs_fop_release+0x2eb/0x440 fs/kernfs/file.c:783
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  fput_close_sync+0x11f/0x240 fs/file_table.c:615
>  __do_sys_close fs/open.c:1507 [inline]
>  __se_sys_close fs/open.c:1492 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1492
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881022db700
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 117 bytes to the right of
>  allocated 128-byte region [ffff8881022db700, ffff8881022db780)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1022db
> flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041a00 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask
> 0xd2000(__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 0,
> tgid 0 (swapper/0), ts 2408938923, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  __alloc_empty_sheaf mm/slub.c:2768 [inline]
>  alloc_empty_sheaf mm/slub.c:2783 [inline]
>  __pcs_replace_empty_main+0x2df/0x720 mm/slub.c:4647
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4906
>  dup_fd+0x55/0xb40 fs/file.c:390
>  copy_files+0xc8/0x120 kernel/fork.c:1639
>  copy_process+0x1d94/0x4440 kernel/fork.c:2252
>  kernel_clone+0x2d7/0x940 kernel/fork.c:2722
>  user_mode_thread+0x110/0x180 kernel/fork.c:2798
>  rest_init+0x23/0x300 init/main.c:727
>  start_kernel+0x38a/0x3e0 init/main.c:1220
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff8881022db680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8881022db700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff8881022db780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                              ^
>  ffff8881022db800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8881022db880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ***
>
> KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree
>
> tree:      torvalds
> URL:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8
> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:
> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
> syz repro:
> https://ci.syzbot.org/findings/2dff870b-f382-4c93-8d8d-b2291d921224/syz_repro
>
> loop1: lost filesystem error report for type 5 error -117
> EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000
> r/w without journal. Quota mode: none.
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4095
> [inline]
> BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xda5/0x10d0
> fs/ext4/inline.c:1335
> Read of size 2 at addr ffff888115a3183c by task syz.1.18/5839
>
> CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Not tainted syzkaller #0
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dir_entry_len fs/ext4/ext4.h:4095 [inline]
>  ext4_inlinedir_to_tree+0xda5/0x10d0 fs/ext4/inline.c:1335
>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3e02b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3e03ad5028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
> RAX: ffffffffffffffda RBX: 00007f3e02e15fa0 RCX: 00007f3e02b9ce59
> RDX: 0000000000001000 RSI: 0000200000000f80 RDI: 0000000000000004
> RBP: 00007f3e02c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3e02e16038 R14: 00007f3e02e15fa0 R15: 00007ffcaa902298
>  </TASK>
>
> Allocated by task 5839:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5296 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  ext4_inlinedir_to_tree+0x312/0x10d0 fs/ext4/inline.c:1292
>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents64 fs/readdir.c:399 [inline]
>  __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888115a31800
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes to the right of
>  allocated 60-byte region [ffff888115a31800, ffff888115a3183c)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115a31
> flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask
> 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
> pid 5051, tgid 5051 (acpid), ts 27203740677, free_ts 27201732767
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  tomoyo_get_name+0x20c/0x590 security/tomoyo/memory.c:173
>  tomoyo_parse_name_union+0xd9/0x130 security/tomoyo/util.c:260
>  tomoyo_update_path_acl security/tomoyo/file.c:399 [inline]
>  tomoyo_write_file+0x3a6/0xc50 security/tomoyo/file.c:1027
>  tomoyo_write_domain2 security/tomoyo/common.c:1160 [inline]
>  tomoyo_add_entry security/tomoyo/common.c:2177 [inline]
>  tomoyo_supervisor+0x1208/0x1570 security/tomoyo/common.c:2238
>  tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]
>  tomoyo_path_permission+0x25a/0x380 security/tomoyo/file.c:592
>  tomoyo_check_open_permission+0x2b2/0x470 security/tomoyo/file.c:782
>  security_file_open+0xa9/0x240 security/security.c:2739
>  do_dentry_open+0x4a8/0x13a0 fs/open.c:924
>  vfs_open+0x3b/0x340 fs/open.c:1079
> page last free pid 15 tgid 15 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888115a31700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff888115a31780: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> >ffff888115a31800: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc
>                                         ^
>  ffff888115a31880: 00 00 00 00 00 00 02 fc fc fc fc fc fc fc fc fc
>  ffff888115a31900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ***
>
> KASAN: slab-use-after-free Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8
> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:
> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
> syz repro:
> https://ci.syzbot.org/findings/f1d48ea1-6e87-4d64-9c13-8bf8aed109fc/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
> r/w without journal. Quota mode: none.
> ==================================================================
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len
> fs/ext4/ext4.h:4069 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
> [inline]
> BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x65a/0xc40
> fs/ext4/dir.c:96
> Read of size 1 at addr ffff888114d8c045 by task syz.0.20/5821
>
> CPU: 1 UID: 0 PID: 5821 Comm: syz.0.20 Not tainted syzkaller #0
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>  ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203
>  ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984
>  ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213
>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>  ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936
>  ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982
>  lookup_open fs/namei.c:4511 [inline]
>  open_last_lookups fs/namei.c:4611 [inline]
>  path_openat+0x1395/0x3860 fs/namei.c:4855
>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>  do_sys_open fs/open.c:1370 [inline]
>  __do_sys_openat fs/open.c:1386 [inline]
>  __se_sys_openat fs/open.c:1381 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f922219ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9223137028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f9222415fa0 RCX: 00007f922219ce59
> RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004
> RBP: 00007f9222232d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9222416038 R14: 00007f9222415fa0 R15: 00007ffd01a2d448
>  </TASK>
>
> Allocated by task 5484:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4570 [inline]
>  slab_alloc_node mm/slub.c:4899 [inline]
>  kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4951
>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>  alloc_skb include/linux/skbuff.h:1385 [inline]
>  nlmsg_new include/net/netlink.h:1055 [inline]
>  mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217
>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Freed by task 5484:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2689 [inline]
>  slab_free mm/slub.c:6251 [inline]
>  kfree+0x1c5/0x640 mm/slub.c:6566
>  skb_kfree_head net/core/skbuff.c:1075 [inline]
>  skb_free_head net/core/skbuff.c:1087 [inline]
>  skb_release_data+0x828/0xa60 net/core/skbuff.c:1114
>  skb_release_all net/core/skbuff.c:1189 [inline]
>  __kfree_skb+0x5d/0x210 net/core/skbuff.c:1203
>  netlink_broadcast_filtered+0xe18/0xf20 net/netlink/af_netlink.c:1540
>  nlmsg_multicast_filtered include/net/netlink.h:1165 [inline]
>  nlmsg_multicast include/net/netlink.h:1184 [inline]
>  nlmsg_notify+0xf0/0x1a0 net/netlink/af_netlink.c:2598
>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> The buggy address belongs to the object at ffff888114d8c000
>  which belongs to the cache skbuff_small_head of size 704
> The buggy address is located 69 bytes inside of
>  freed 704-byte region [ffff888114d8c000, ffff888114d8c2c0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x114d8c
> head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122
> head: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000
> head: 017ff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask
> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
> pid 5484, tgid 5484 (kworker/u8:2), ts 72573003529, free_ts 72546506446
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4951
>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>  alloc_skb include/linux/skbuff.h:1385 [inline]
>  nlmsg_new include/net/netlink.h:1055 [inline]
>  mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217
>  mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691
>  notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421
>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
> page last free pid 5484 tgid 5484 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>  stack_depot_save_flags+0x40e/0x810 lib/stackdepot.c:735
>  kasan_save_stack mm/kasan/common.c:58 [inline]
>  kasan_save_track+0x4f/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4570 [inline]
>  slab_alloc_node mm/slub.c:4899 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4906
>  kmem_alloc_batch lib/debugobjects.c:371 [inline]
>  fill_pool+0x156/0x580 lib/debugobjects.c:420
>  debug_objects_fill_pool lib/debugobjects.c:752 [inline]
>  debug_object_activate+0x4a3/0x580 lib/debugobjects.c:841
>  debug_rcu_head_queue kernel/rcu/rcu.h:236 [inline]
>  __call_rcu_common kernel/rcu/tree.c:3116 [inline]
>  call_rcu+0x43/0x890 kernel/rcu/tree.c:3251
>  kernfs_put+0x259/0x520 fs/kernfs/dir.c:618
>  kernfs_remove_by_name_ns+0xc8/0x140 fs/kernfs/dir.c:1799
>  device_remove_class_symlinks+0x178/0x190 drivers/base/core.c:3479
>  device_del+0x400/0x8f0 drivers/base/core.c:3881
>  unregister_netdevice_many_notify+0x1d5f/0x22c0 net/core/dev.c:12456
>  ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
>  ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248
>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>
> Memory state around the buggy address:
>  ffff888114d8bf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888114d8bf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff888114d8c000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff888114d8c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888114d8c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ***
>
> KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree
>
> tree:      torvalds
> URL:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8
> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:
> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
> syz repro:
> https://ci.syzbot.org/findings/f42da242-e16e-4f10-bf25-0bd7e192d989/syz_repro
>
> loop0: lost filesystem error report for type 5 error -117
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000
> r/w without journal. Quota mode: none.
> ==================================================================
> BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len
> fs/ext4/ext4.h:4069 [inline]
> BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
> [inline]
> BUG: KASAN: slab-use-after-free in ext4_inlinedir_to_tree+0x94c/0x10d0
> fs/ext4/inline.c:1335
> Read of size 1 at addr ffff88816fee8825 by task syz.0.20/5867
>
> CPU: 1 UID: 0 PID: 5867 Comm: syz.0.20 Not tainted syzkaller #0
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>  ext4_inlinedir_to_tree+0x94c/0x10d0 fs/ext4/inline.c:1335
>  ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182
>  ext4_dx_readdir fs/ext4/dir.c:600 [inline]
>  ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146
>  iterate_dir+0x399/0x570 fs/readdir.c:110
>  __do_sys_getdents fs/readdir.c:319 [inline]
>  __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f010ad9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f010bc0f028 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
> RAX: ffffffffffffffda RBX: 00007f010b015fa0 RCX: 00007f010ad9ce59
> RDX: 0000000000000054 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f010ae32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f010b016038 R14: 00007f010b015fa0 R15: 00007ffd93577348
>  </TASK>
>
> Allocated by task 5064:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5296 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
>  tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80
>  tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827
>  security_inode_getattr+0x12b/0x310 security/security.c:1895
>  vfs_getattr fs/stat.c:259 [inline]
>  vfs_fstat fs/stat.c:281 [inline]
>  vfs_fstatat+0xb4/0x170 fs/stat.c:371
>  __do_sys_newfstatat fs/stat.c:538 [inline]
>  __se_sys_newfstatat fs/stat.c:532 [inline]
>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5064:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2689 [inline]
>  slab_free mm/slub.c:6251 [inline]
>  kfree+0x1c5/0x640 mm/slub.c:6566
>  tomoyo_path_perm+0x403/0x560 security/tomoyo/file.c:847
>  security_inode_getattr+0x12b/0x310 security/security.c:1895
>  vfs_getattr fs/stat.c:259 [inline]
>  vfs_fstat fs/stat.c:281 [inline]
>  vfs_fstatat+0xb4/0x170 fs/stat.c:371
>  __do_sys_newfstatat fs/stat.c:538 [inline]
>  __se_sys_newfstatat fs/stat.c:532 [inline]
>  __x64_sys_newfstatat+0x151/0x200 fs/stat.c:532
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88816fee8800
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 37 bytes inside of
>  freed 64-byte region [ffff88816fee8800, ffff88816fee8840)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16fee8
> flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask
> 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
> pid 1, tgid 1 (swapper/0), ts 21294026082, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7272
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
>  alloc_from_pcs mm/slub.c:4750 [inline]
>  slab_alloc_node mm/slub.c:4884 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  handler_new_ref+0x261/0x9c0 drivers/media/v4l2-core/v4l2-ctrls-core.c:1882
>  v4l2_ctrl_add_handler+0x19f/0x290
> drivers/media/v4l2-core/v4l2-ctrls-core.c:2443
>  vivid_create_controls+0x332d/0x3bd0
> drivers/media/test-drivers/vivid/vivid-ctrls.c:2072
>  vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1933
> [inline]
>  vivid_probe+0x4261/0x72b0
> drivers/media/test-drivers/vivid/vivid-core.c:2095
>  platform_probe+0xf9/0x190 drivers/base/platform.c:1432
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x267/0xaf0 drivers/base/dd.c:709
>  __driver_probe_device+0x1ef/0x380 drivers/base/dd.c:871
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:901
>  __driver_attach+0x34c/0x640 drivers/base/dd.c:1295
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88816fee8700: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>  ffff88816fee8780: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >ffff88816fee8800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                                ^
>  ffff88816fee8880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88816fee8900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ***
>
> KASAN: use-after-free Read in __ext4_check_dir_entry
>
> tree:      torvalds
> URL:
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      9716c086c8e8b141d35aa61f2e96a2e83de212a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8
> (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:
> https://ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config
> syz repro:
> https://ci.syzbot.org/findings/57c0b75a-8922-4dc1-9a20-ca947564792b/syz_repro
>
> ==================================================================
> BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4069
> [inline]
> BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096
> [inline]
> BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x65a/0xc40
> fs/ext4/dir.c:96
> Read of size 1 at addr ffff88816be85045 by task syz.2.21/5880
>
> CPU: 1 UID: 0 PID: 5880 Comm: syz.2.21 Not tainted syzkaller #0
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]
>  ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]
>  __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96
>  ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203
>  ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984
>  ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213
>  __ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529
>  ext4_add_entry fs/ext4/namei.c:2613 [inline]
>  ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936
>  ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982
>  lookup_open fs/namei.c:4511 [inline]
>  open_last_lookups fs/namei.c:4611 [inline]
>  path_openat+0x1395/0x3860 fs/namei.c:4855
>  do_file_open+0x23e/0x4a0 fs/namei.c:4887
>  do_sys_openat2+0x113/0x200 fs/open.c:1364
>  do_sys_open fs/open.c:1370 [inline]
>  __do_sys_openat fs/open.c:1386 [inline]
>  __se_sys_openat fs/open.c:1381 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1381
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5713b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff672b25f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f5713e15fa0 RCX: 00007f5713b9ce59
> RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004
> RBP: 00007f5713c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5713e15fac R14: 00007f5713e15fa0 R15: 00007f5713e15fa0
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16be85
> flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
> page_type: f0(buddy)
> raw: 057ff00000000000 ffffea0005afa0c8 ffffea0005afa1c8 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000f0000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 0, migratetype Unmovable, gfp_mask
> 0xcc0(GFP_KERNEL), pid 5630, tgid 5630 (syz-executor), ts 67290853657,
> free_ts 69321168948
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
>  prep_new_page mm/page_alloc.c:1861 [inline]
>  get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
>  __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
>  alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
>  ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
>  __kasan_populate_vmalloc+0xc1/0x1d0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd47/0x1480 mm/vmalloc.c:2123
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3226
>  __vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:4024
>  vmalloc_user_noprof+0xad/0xe0 mm/vmalloc.c:4218
>  kcov_ioctl+0x55/0x620 kernel/kcov.c:726
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5693 tgid 5693 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
>  kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:484
>  apply_to_pte_range mm/memory.c:3338 [inline]
>  apply_to_pmd_range mm/memory.c:3382 [inline]
>  apply_to_pud_range mm/memory.c:3418 [inline]
>  apply_to_p4d_range mm/memory.c:3454 [inline]
>  __apply_to_page_range+0xbdc/0x1420 mm/memory.c:3490
>  __kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:602
>  kasan_release_vmalloc include/linux/kasan.h:593 [inline]
>  kasan_release_vmalloc_node mm/vmalloc.c:2284 [inline]
>  purge_vmap_node+0x220/0x960 mm/vmalloc.c:2306
>  __purge_vmap_area_lazy+0x779/0xb40 mm/vmalloc.c:2396
>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2430
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88816be84f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88816be84f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88816be85000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                            ^
>  ffff88816be85080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff88816be85100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
>

--000000000000518ee506549bdd5b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div dir=3D"auto">Thanks for the report. The attached=
 patch addresses the issues found in<br>the dirdata series review (dx_get_d=
x_info/get_dx_<span aria-invalid=3D"spelling" class=3D"LI ng" style=3D"bord=
er-style:none;background:none">countlimit</span> <span aria-invalid=3D"spel=
ling" class=3D"LI ng" style=3D"border-style:none;background:none">blocksize=
</span><br>fallback, dfid parameter shadowing in ext4_dirdata_get, and the =
unsafe<br>delete-before-add in EXT4_IOC_SET_LUFID).<br><br><br>#syz test</d=
iv></div></div><br><div class=3D"gmail_extra"><div>On Thu, Jun 11, 2026 11:=
29 AM, syzbot ci &lt;<a href=3D"mailto:syzbot%2Bcid7b922cb3d448114@syzkalle=
r.appspotmail.com" target=3D"_blank">syzbot+cid7b922cb3d448114@syzkaller.ap=
pspotmail.com</a>&gt; wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex">syzbot ci has tested the following series<br>
<br>
[v2] Data in direntry (dirdata) feature<br>
<a href=3D"https://lore.kernel.org/all/20260610152417.13576-1-ablagodarenko=
@thelustrecollective.com" rel=3D"noreferrer" target=3D"_blank">https://lore=
.kernel.org/all/20260610152417.13576-1-ablagodarenko@thelustrecollective.co=
m</a><br>
* [PATCH v2 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2<br>
* [PATCH v2 02/10] ext4: add ext4_dir_entry_is_tail()<br>
* [PATCH v2 03/10] ext4: refactor dx_root to support variable dirent sizes<=
br>
* [PATCH v2 04/10] ext4: add dirdata format definitions and access helpers<=
br>
* [PATCH v2 05/10] ext4: preserve dirdata bits in get_dtype()<br>
* [PATCH v2 06/10] ext4: add ext4_dir_entry_len() and harden dirdata parsin=
g<br>
* [PATCH v2 07/10] ext4: rename ext4_dir_rec_len() and clarify dirdata usag=
e<br>
* [PATCH v2 08/10] ext4: dirdata feature<br>
* [PATCH v2 09/10] ext4: add dirdata set/get helpers<br>
* [PATCH v2 10/10] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on =
directory entries<br>
<br>
and found the following issues:<br>
* KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry<br>
* KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree<br>
* KASAN: slab-use-after-free Read in __ext4_check_dir_entry<br>
* KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree<br>
* KASAN: use-after-free Read in __ext4_check_dir_entry<br>
<br>
Full report is available here:<br>
<a href=3D"https://ci.syzbot.org/series/5bf0e2fa-2e68-4532-8396-4568879b278=
8" rel=3D"noreferrer" target=3D"_blank">https://ci.syzbot.org/series/5bf0e2=
fa-2e68-4532-8396-4568879b2788</a><br>
<br>
***<br>
<br>
KASAN: slab-out-of-bounds Read in __ext4_check_dir_entry<br>
<br>
tree:=C2=A0 =C2=A0 =C2=A0 torvalds<br>
URL:=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://kernel.googlesource.com/p=
ub/scm/linux/kernel/git/torvalds/linux" rel=3D"noreferrer" target=3D"_blank=
">https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</=
a><br>
base:=C2=A0 =C2=A0 =C2=A0 9716c086c8e8b141d35aa61f2e96a2e83de212a7<br>
arch:=C2=A0 =C2=A0 =C2=A0 amd64<br>
compiler:=C2=A0 Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:=C2=A0 =C2=A0 <a href=3D"https://ci.syzbot.org/builds/ddf6ee7c-dfa8-=
4383-b004-10140edc081c/config" rel=3D"noreferrer" target=3D"_blank">https:/=
/ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config</a><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/b0854918-13f9-49dd-ab3=
0-12154f0debe2/syz_repro" rel=3D"noreferrer" target=3D"_blank">https://ci.s=
yzbot.org/findings/b0854918-13f9-49dd-ab30-12154f0debe2/syz_repro</a><br>
<br>
loop0: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-out-of-bounds in ext4_dirent_get_data_len fs/ext4/ext4.h:4=
069 [inline]<br>
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4096 [i=
nline]<br>
BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry+0x65a/0xc40 fs/ext=
4/dir.c:96<br>
Read of size 1 at addr ffff8881022db7f5 by task syz.0.23/5815<br>
<br>
CPU: 1 UID: 0 PID: 5815 Comm: syz.0.23 Not tainted syzkaller #0 PREEMPT(ful=
l) <br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
=C2=A0print_address_description+0x55/0x1e0 mm/kasan/report.c:378<br>
=C2=A0print_report+0x58/0x70 mm/kasan/report.c:482<br>
=C2=A0kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
=C2=A0ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]<br>
=C2=A0ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]<br>
=C2=A0__ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96<br>
=C2=A0ext4_check_all_de+0x66/0x150 fs/ext4/dir.c:657<br>
=C2=A0ext4_convert_inline_data_nolock+0x1b7/0x990 fs/ext4/inline.c:1121<br>
=C2=A0ext4_try_add_inline_entry+0x604/0x8e0 fs/ext4/inline.c:1247<br>
=C2=A0__ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529<br>
=C2=A0ext4_add_entry fs/ext4/namei.c:2613 [inline]<br>
=C2=A0ext4_mkdir+0x5e5/0xce0 fs/ext4/namei.c:3175<br>
=C2=A0vfs_mkdir+0x413/0x630 fs/namei.c:5271<br>
=C2=A0filename_mkdirat+0x285/0x510 fs/namei.c:5304<br>
=C2=A0__do_sys_mkdirat fs/namei.c:5325 [inline]<br>
=C2=A0__se_sys_mkdirat+0x35/0x150 fs/namei.c:5322<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f669359bcc7<br>
Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff =
ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007ffd42381d38 EFLAGS: 00000246 ORIG_RAX: 0000000000000102<br>
RAX: ffffffffffffffda RBX: 00007ffd42381dc0 RCX: 00007f669359bcc7<br>
RDX: 00000000000001ff RSI: 0000200000001200 RDI: 00000000ffffff9c<br>
RBP: 00002000000024c0 R08: 0000200000000240 R09: 0000000000000000<br>
R10: 00002000000024c0 R11: 0000000000000246 R12: 0000200000001200<br>
R13: 00007ffd42381d80 R14: 0000000000000000 R15: 0000000000000000<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
Allocated by task 5066:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
=C2=A0__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
=C2=A0kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
=C2=A0__kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5420<br>
=C2=A0kmalloc_noprof include/linux/slab.h:950 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
=C2=A0kernfs_get_open_node fs/kernfs/file.c:543 [inline]<br>
=C2=A0kernfs_fop_open+0x862/0xda0 fs/kernfs/file.c:718<br>
=C2=A0do_dentry_open+0x822/0x13a0 fs/open.c:947<br>
=C2=A0vfs_open+0x3b/0x340 fs/open.c:1079<br>
=C2=A0do_open fs/namei.c:4699 [inline]<br>
=C2=A0path_openat+0x2e08/0x3860 fs/namei.c:4858<br>
=C2=A0do_file_open+0x23e/0x4a0 fs/namei.c:4887<br>
=C2=A0do_sys_openat2+0x113/0x200 fs/open.c:1364<br>
=C2=A0do_sys_open fs/open.c:1370 [inline]<br>
=C2=A0__do_sys_openat fs/open.c:1386 [inline]<br>
=C2=A0__se_sys_openat fs/open.c:1381 [inline]<br>
=C2=A0__x64_sys_openat+0x138/0x170 fs/open.c:1381<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Last potentially related work creation:<br>
=C2=A0kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57<br>
=C2=A0kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556<br>
=C2=A0kvfree_call_rcu+0x100/0x430 mm/slab_common.c:1970<br>
=C2=A0kernfs_unlink_open_file+0x3fe/0x4b0 fs/kernfs/file.c:604<br>
=C2=A0kernfs_fop_release+0x2eb/0x440 fs/kernfs/file.c:783<br>
=C2=A0__fput+0x44f/0xa60 fs/file_table.c:510<br>
=C2=A0fput_close_sync+0x11f/0x240 fs/file_table.c:615<br>
=C2=A0__do_sys_close fs/open.c:1507 [inline]<br>
=C2=A0__se_sys_close fs/open.c:1492 [inline]<br>
=C2=A0__x64_sys_close+0x7e/0x110 fs/open.c:1492<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff8881022db700<br>
=C2=A0which belongs to the cache kmalloc-128 of size 128<br>
The buggy address is located 117 bytes to the right of<br>
=C2=A0allocated 128-byte region [ffff8881022db700, ffff8881022db780)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1022db=
<br>
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000000 ffff888100041a00 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2000(__=
GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 0, tgid 0 (swapp=
er/0), ts 2408938923, free_ts 0<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853<br>
=C2=A0prep_new_page mm/page_alloc.c:1861 [inline]<br>
=C2=A0get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941<br>
=C2=A0__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221<br>
=C2=A0alloc_slab_page mm/slub.c:3278 [inline]<br>
=C2=A0allocate_slab+0x77/0x660 mm/slub.c:3467<br>
=C2=A0new_slab mm/slub.c:3525 [inline]<br>
=C2=A0refill_objects+0x339/0x3d0 mm/slub.c:7272<br>
=C2=A0refill_sheaf mm/slub.c:2816 [inline]<br>
=C2=A0__pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652<br>
=C2=A0alloc_from_pcs mm/slub.c:4750 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4884 [inline]<br>
=C2=A0__do_kmalloc_node mm/slub.c:5295 [inline]<br>
=C2=A0__kmalloc_noprof+0x474/0x760 mm/slub.c:5308<br>
=C2=A0kmalloc_noprof include/linux/slab.h:954 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
=C2=A0__alloc_empty_sheaf mm/slub.c:2768 [inline]<br>
=C2=A0alloc_empty_sheaf mm/slub.c:2783 [inline]<br>
=C2=A0__pcs_replace_empty_main+0x2df/0x720 mm/slub.c:4647<br>
=C2=A0alloc_from_pcs mm/slub.c:4750 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4884 [inline]<br>
=C2=A0kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4906<br>
=C2=A0dup_fd+0x55/0xb40 fs/file.c:390<br>
=C2=A0copy_files+0xc8/0x120 kernel/fork.c:1639<br>
=C2=A0copy_process+0x1d94/0x4440 kernel/fork.c:2252<br>
=C2=A0kernel_clone+0x2d7/0x940 kernel/fork.c:2722<br>
=C2=A0user_mode_thread+0x110/0x180 kernel/fork.c:2798<br>
=C2=A0rest_init+0x23/0x300 init/main.c:727<br>
=C2=A0start_kernel+0x38a/0x3e0 init/main.c:1220<br>
page_owner free stack trace missing<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff8881022db680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
=C2=A0ffff8881022db700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
&gt;ffff8881022db780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^<br>
=C2=A0ffff8881022db800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
=C2=A0ffff8881022db880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-out-of-bounds Read in ext4_inlinedir_to_tree<br>
<br>
tree:=C2=A0 =C2=A0 =C2=A0 torvalds<br>
URL:=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://kernel.googlesource.com/p=
ub/scm/linux/kernel/git/torvalds/linux" rel=3D"noreferrer" target=3D"_blank=
">https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</=
a><br>
base:=C2=A0 =C2=A0 =C2=A0 9716c086c8e8b141d35aa61f2e96a2e83de212a7<br>
arch:=C2=A0 =C2=A0 =C2=A0 amd64<br>
compiler:=C2=A0 Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:=C2=A0 =C2=A0 <a href=3D"https://ci.syzbot.org/builds/ddf6ee7c-dfa8-=
4383-b004-10140edc081c/config" rel=3D"noreferrer" target=3D"_blank">https:/=
/ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config</a><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/2dff870b-f382-4c93-8d8=
d-b2291d921224/syz_repro" rel=3D"noreferrer" target=3D"_blank">https://ci.s=
yzbot.org/findings/2dff870b-f382-4c93-8d8d-b2291d921224/syz_repro</a><br>
<br>
loop1: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-out-of-bounds in ext4_dir_entry_len fs/ext4/ext4.h:4095 [i=
nline]<br>
BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xda5/0x10d0 fs/ex=
t4/inline.c:1335<br>
Read of size 2 at addr ffff888115a3183c by task syz.1.18/5839<br>
<br>
CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l) <br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
=C2=A0print_address_description+0x55/0x1e0 mm/kasan/report.c:378<br>
=C2=A0print_report+0x58/0x70 mm/kasan/report.c:482<br>
=C2=A0kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
=C2=A0ext4_dir_entry_len fs/ext4/ext4.h:4095 [inline]<br>
=C2=A0ext4_inlinedir_to_tree+0xda5/0x10d0 fs/ext4/inline.c:1335<br>
=C2=A0ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182<br>
=C2=A0ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
=C2=A0ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146<br>
=C2=A0iterate_dir+0x399/0x570 fs/readdir.c:110<br>
=C2=A0__do_sys_getdents64 fs/readdir.c:399 [inline]<br>
=C2=A0__se_sys_getdents64+0xf1/0x280 fs/readdir.c:384<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f3e02b9ce59<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007f3e03ad5028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9<br>
RAX: ffffffffffffffda RBX: 00007f3e02e15fa0 RCX: 00007f3e02b9ce59<br>
RDX: 0000000000001000 RSI: 0000200000000f80 RDI: 0000000000000004<br>
RBP: 00007f3e02c32d6f R08: 0000000000000000 R09: 0000000000000000<br>
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007f3e02e16038 R14: 00007f3e02e15fa0 R15: 00007ffcaa902298<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
Allocated by task 5839:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
=C2=A0__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
=C2=A0kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
=C2=A0__do_kmalloc_node mm/slub.c:5296 [inline]<br>
=C2=A0__kmalloc_noprof+0x35c/0x760 mm/slub.c:5308<br>
=C2=A0kmalloc_noprof include/linux/slab.h:954 [inline]<br>
=C2=A0ext4_inlinedir_to_tree+0x312/0x10d0 fs/ext4/inline.c:1292<br>
=C2=A0ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182<br>
=C2=A0ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
=C2=A0ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146<br>
=C2=A0iterate_dir+0x399/0x570 fs/readdir.c:110<br>
=C2=A0__do_sys_getdents64 fs/readdir.c:399 [inline]<br>
=C2=A0__se_sys_getdents64+0xf1/0x280 fs/readdir.c:384<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff888115a31800<br>
=C2=A0which belongs to the cache kmalloc-64 of size 64<br>
The buggy address is located 0 bytes to the right of<br>
=C2=A0allocated 60-byte region [ffff888115a31800, ffff888115a3183c)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115a31=
<br>
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GF=
P_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5051, t=
gid 5051 (acpid), ts 27203740677, free_ts 27201732767<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853<br>
=C2=A0prep_new_page mm/page_alloc.c:1861 [inline]<br>
=C2=A0get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941<br>
=C2=A0__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221<br>
=C2=A0alloc_slab_page mm/slub.c:3278 [inline]<br>
=C2=A0allocate_slab+0x77/0x660 mm/slub.c:3467<br>
=C2=A0new_slab mm/slub.c:3525 [inline]<br>
=C2=A0refill_objects+0x339/0x3d0 mm/slub.c:7272<br>
=C2=A0refill_sheaf mm/slub.c:2816 [inline]<br>
=C2=A0__pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652<br>
=C2=A0alloc_from_pcs mm/slub.c:4750 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4884 [inline]<br>
=C2=A0__do_kmalloc_node mm/slub.c:5295 [inline]<br>
=C2=A0__kmalloc_noprof+0x474/0x760 mm/slub.c:5308<br>
=C2=A0kmalloc_noprof include/linux/slab.h:954 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
=C2=A0tomoyo_get_name+0x20c/0x590 security/tomoyo/memory.c:173<br>
=C2=A0tomoyo_parse_name_union+0xd9/0x130 security/tomoyo/util.c:260<br>
=C2=A0tomoyo_update_path_acl security/tomoyo/file.c:399 [inline]<br>
=C2=A0tomoyo_write_file+0x3a6/0xc50 security/tomoyo/file.c:1027<br>
=C2=A0tomoyo_write_domain2 security/tomoyo/common.c:1160 [inline]<br>
=C2=A0tomoyo_add_entry security/tomoyo/common.c:2177 [inline]<br>
=C2=A0tomoyo_supervisor+0x1208/0x1570 security/tomoyo/common.c:2238<br>
=C2=A0tomoyo_audit_path_log security/tomoyo/file.c:169 [inline]<br>
=C2=A0tomoyo_path_permission+0x25a/0x380 security/tomoyo/file.c:592<br>
=C2=A0tomoyo_check_open_permission+0x2b2/0x470 security/tomoyo/file.c:782<b=
r>
=C2=A0security_file_open+0xa9/0x240 security/security.c:2739<br>
=C2=A0do_dentry_open+0x4a8/0x13a0 fs/open.c:924<br>
=C2=A0vfs_open+0x3b/0x340 fs/open.c:1079<br>
page last free pid 15 tgid 15 stack trace:<br>
=C2=A0reset_page_owner include/linux/page_owner.h:25 [inline]<br>
=C2=A0__free_pages_prepare mm/page_alloc.c:1397 [inline]<br>
=C2=A0__free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938<br>
=C2=A0__tlb_remove_table_free mm/mmu_gather.c:228 [inline]<br>
=C2=A0tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291<br>
=C2=A0rcu_do_batch kernel/rcu/tree.c:2617 [inline]<br>
=C2=A0rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869<br>
=C2=A0handle_softirqs+0x22a/0x840 kernel/softirq.c:622<br>
=C2=A0run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076<br>
=C2=A0smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160<br>
=C2=A0kthread+0x389/0x470 kernel/kthread.c:436<br>
=C2=A0ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff888115a31700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
=C2=A0ffff888115a31780: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc<br>
&gt;ffff888115a31800: 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0ffff888115a31880: 00 00 00 00 00 00 02 fc fc fc fc fc fc fc fc fc<br>
=C2=A0ffff888115a31900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-use-after-free Read in __ext4_check_dir_entry<br>
<br>
tree:=C2=A0 =C2=A0 =C2=A0 torvalds<br>
URL:=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://kernel.googlesource.com/p=
ub/scm/linux/kernel/git/torvalds/linux" rel=3D"noreferrer" target=3D"_blank=
">https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</=
a><br>
base:=C2=A0 =C2=A0 =C2=A0 9716c086c8e8b141d35aa61f2e96a2e83de212a7<br>
arch:=C2=A0 =C2=A0 =C2=A0 amd64<br>
compiler:=C2=A0 Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:=C2=A0 =C2=A0 <a href=3D"https://ci.syzbot.org/builds/ddf6ee7c-dfa8-=
4383-b004-10140edc081c/config" rel=3D"noreferrer" target=3D"_blank">https:/=
/ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config</a><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/f1d48ea1-6e87-4d64-9c1=
3-8bf8aed109fc/syz_repro" rel=3D"noreferrer" target=3D"_blank">https://ci.s=
yzbot.org/findings/f1d48ea1-6e87-4d64-9c13-8bf8aed109fc/syz_repro</a><br>
<br>
loop0: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4069 [inline]<br>
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096 [=
inline]<br>
BUG: KASAN: slab-use-after-free in __ext4_check_dir_entry+0x65a/0xc40 fs/ex=
t4/dir.c:96<br>
Read of size 1 at addr ffff888114d8c045 by task syz.0.20/5821<br>
<br>
CPU: 1 UID: 0 PID: 5821 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(ful=
l) <br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
=C2=A0print_address_description+0x55/0x1e0 mm/kasan/report.c:378<br>
=C2=A0print_report+0x58/0x70 mm/kasan/report.c:482<br>
=C2=A0kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
=C2=A0ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]<br>
=C2=A0ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]<br>
=C2=A0__ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96<br>
=C2=A0ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203<br>
=C2=A0ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984<br>
=C2=A0ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213<br>
=C2=A0__ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529<br>
=C2=A0ext4_add_entry fs/ext4/namei.c:2613 [inline]<br>
=C2=A0ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936<br>
=C2=A0ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982<br>
=C2=A0lookup_open fs/namei.c:4511 [inline]<br>
=C2=A0open_last_lookups fs/namei.c:4611 [inline]<br>
=C2=A0path_openat+0x1395/0x3860 fs/namei.c:4855<br>
=C2=A0do_file_open+0x23e/0x4a0 fs/namei.c:4887<br>
=C2=A0do_sys_openat2+0x113/0x200 fs/open.c:1364<br>
=C2=A0do_sys_open fs/open.c:1370 [inline]<br>
=C2=A0__do_sys_openat fs/open.c:1386 [inline]<br>
=C2=A0__se_sys_openat fs/open.c:1381 [inline]<br>
=C2=A0__x64_sys_openat+0x138/0x170 fs/open.c:1381<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f922219ce59<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007f9223137028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101<br>
RAX: ffffffffffffffda RBX: 00007f9222415fa0 RCX: 00007f922219ce59<br>
RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004<br>
RBP: 00007f9222232d6f R08: 0000000000000000 R09: 0000000000000000<br>
R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007f9222416038 R14: 00007f9222415fa0 R15: 00007ffd01a2d448<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
Allocated by task 5484:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0unpoison_slab_object mm/kasan/common.c:340 [inline]<br>
=C2=A0__kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366<br>
=C2=A0kasan_slab_alloc include/linux/kasan.h:253 [inline]<br>
=C2=A0slab_post_alloc_hook mm/slub.c:4570 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4899 [inline]<br>
=C2=A0kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4951<br>
=C2=A0kmalloc_reserve net/core/skbuff.c:613 [inline]<br>
=C2=A0__alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713<br>
=C2=A0alloc_skb include/linux/skbuff.h:1385 [inline]<br>
=C2=A0nlmsg_new include/net/netlink.h:1055 [inline]<br>
=C2=A0mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217<br>
=C2=A0mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691<br>
=C2=A0notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85<br>
=C2=A0call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]<br>
=C2=A0call_netdevice_notifiers net/core/dev.c:2301 [inline]<br>
=C2=A0unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421<b=
r>
=C2=A0ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]<br>
=C2=A0ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248<br>
=C2=A0cleanup_net+0x56b/0x800 net/core/net_namespace.c:702<br>
=C2=A0process_one_work kernel/workqueue.c:3314 [inline]<br>
=C2=A0process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397<br>
=C2=A0worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478<br>
=C2=A0kthread+0x389/0x470 kernel/kthread.c:436<br>
=C2=A0ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Freed by task 5484:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584<br>
=C2=A0poison_slab_object mm/kasan/common.c:253 [inline]<br>
=C2=A0__kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285<br>
=C2=A0kasan_slab_free include/linux/kasan.h:235 [inline]<br>
=C2=A0slab_free_hook mm/slub.c:2689 [inline]<br>
=C2=A0slab_free mm/slub.c:6251 [inline]<br>
=C2=A0kfree+0x1c5/0x640 mm/slub.c:6566<br>
=C2=A0skb_kfree_head net/core/skbuff.c:1075 [inline]<br>
=C2=A0skb_free_head net/core/skbuff.c:1087 [inline]<br>
=C2=A0skb_release_data+0x828/0xa60 net/core/skbuff.c:1114<br>
=C2=A0skb_release_all net/core/skbuff.c:1189 [inline]<br>
=C2=A0__kfree_skb+0x5d/0x210 net/core/skbuff.c:1203<br>
=C2=A0netlink_broadcast_filtered+0xe18/0xf20 net/netlink/af_netlink.c:1540<=
br>
=C2=A0nlmsg_multicast_filtered include/net/netlink.h:1165 [inline]<br>
=C2=A0nlmsg_multicast include/net/netlink.h:1184 [inline]<br>
=C2=A0nlmsg_notify+0xf0/0x1a0 net/netlink/af_netlink.c:2598<br>
=C2=A0mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691<br>
=C2=A0notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85<br>
=C2=A0call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]<br>
=C2=A0call_netdevice_notifiers net/core/dev.c:2301 [inline]<br>
=C2=A0unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421<b=
r>
=C2=A0ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]<br>
=C2=A0ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248<br>
=C2=A0cleanup_net+0x56b/0x800 net/core/net_namespace.c:702<br>
=C2=A0process_one_work kernel/workqueue.c:3314 [inline]<br>
=C2=A0process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397<br>
=C2=A0worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478<br>
=C2=A0kthread+0x389/0x470 kernel/kthread.c:436<br>
=C2=A0ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
The buggy address belongs to the object at ffff888114d8c000<br>
=C2=A0which belongs to the cache skbuff_small_head of size 704<br>
The buggy address is located 69 bytes inside of<br>
=C2=A0freed 704-byte region [ffff888114d8c000, ffff888114d8c2c0)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x114d8c=
<br>
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0<br>
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000<br=
>
head: 017ff00000000040 ffff888160416b40 dead000000000100 dead000000000122<b=
r>
head: 0000000000000000 0000000800120012 00000000f5000000 0000000000000000<b=
r>
head: 017ff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff<b=
r>
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004<b=
r>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5484, tgid 5484 (kworker/u8:2), ts 72573003529, free_ts 72546506446<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853<br>
=C2=A0prep_new_page mm/page_alloc.c:1861 [inline]<br>
=C2=A0get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941<br>
=C2=A0__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221<br>
=C2=A0alloc_slab_page mm/slub.c:3278 [inline]<br>
=C2=A0allocate_slab+0x77/0x660 mm/slub.c:3467<br>
=C2=A0new_slab mm/slub.c:3525 [inline]<br>
=C2=A0refill_objects+0x339/0x3d0 mm/slub.c:7272<br>
=C2=A0refill_sheaf mm/slub.c:2816 [inline]<br>
=C2=A0__pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652<br>
=C2=A0alloc_from_pcs mm/slub.c:4750 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4884 [inline]<br>
=C2=A0kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4951<br>
=C2=A0kmalloc_reserve net/core/skbuff.c:613 [inline]<br>
=C2=A0__alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713<br>
=C2=A0alloc_skb include/linux/skbuff.h:1385 [inline]<br>
=C2=A0nlmsg_new include/net/netlink.h:1055 [inline]<br>
=C2=A0mpls_netconf_notify_devconf+0x46/0x100 net/mpls/af_mpls.c:1217<br>
=C2=A0mpls_dev_notify+0xb2d/0xd10 net/mpls/af_mpls.c:1691<br>
=C2=A0notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85<br>
=C2=A0call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]<br>
=C2=A0call_netdevice_notifiers net/core/dev.c:2301 [inline]<br>
=C2=A0unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12421<b=
r>
=C2=A0ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]<br>
=C2=A0ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248<br>
=C2=A0cleanup_net+0x56b/0x800 net/core/net_namespace.c:702<br>
=C2=A0process_one_work kernel/workqueue.c:3314 [inline]<br>
=C2=A0process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397<br>
=C2=A0worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478<br>
page last free pid 5484 tgid 5484 stack trace:<br>
=C2=A0reset_page_owner include/linux/page_owner.h:25 [inline]<br>
=C2=A0__free_pages_prepare mm/page_alloc.c:1397 [inline]<br>
=C2=A0__free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938<br>
=C2=A0stack_depot_save_flags+0x40e/0x810 lib/stackdepot.c:735<br>
=C2=A0kasan_save_stack mm/kasan/common.c:58 [inline]<br>
=C2=A0kasan_save_track+0x4f/0x80 mm/kasan/common.c:78<br>
=C2=A0unpoison_slab_object mm/kasan/common.c:340 [inline]<br>
=C2=A0__kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366<br>
=C2=A0kasan_slab_alloc include/linux/kasan.h:253 [inline]<br>
=C2=A0slab_post_alloc_hook mm/slub.c:4570 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4899 [inline]<br>
=C2=A0kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4906<br>
=C2=A0kmem_alloc_batch lib/debugobjects.c:371 [inline]<br>
=C2=A0fill_pool+0x156/0x580 lib/debugobjects.c:420<br>
=C2=A0debug_objects_fill_pool lib/debugobjects.c:752 [inline]<br>
=C2=A0debug_object_activate+0x4a3/0x580 lib/debugobjects.c:841<br>
=C2=A0debug_rcu_head_queue kernel/rcu/rcu.h:236 [inline]<br>
=C2=A0__call_rcu_common kernel/rcu/tree.c:3116 [inline]<br>
=C2=A0call_rcu+0x43/0x890 kernel/rcu/tree.c:3251<br>
=C2=A0kernfs_put+0x259/0x520 fs/kernfs/dir.c:618<br>
=C2=A0kernfs_remove_by_name_ns+0xc8/0x140 fs/kernfs/dir.c:1799<br>
=C2=A0device_remove_class_symlinks+0x178/0x190 drivers/base/core.c:3479<br>
=C2=A0device_del+0x400/0x8f0 drivers/base/core.c:3881<br>
=C2=A0unregister_netdevice_many_notify+0x1d5f/0x22c0 net/core/dev.c:12456<b=
r>
=C2=A0ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]<br>
=C2=A0ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248<br>
=C2=A0cleanup_net+0x56b/0x800 net/core/net_namespace.c:702<br>
=C2=A0process_one_work kernel/workqueue.c:3314 [inline]<br>
=C2=A0process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff888114d8bf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
=C2=A0ffff888114d8bf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
&gt;ffff888114d8c000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0^<br>
=C2=A0ffff888114d8c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=C2=A0ffff888114d8c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: slab-use-after-free Read in ext4_inlinedir_to_tree<br>
<br>
tree:=C2=A0 =C2=A0 =C2=A0 torvalds<br>
URL:=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://kernel.googlesource.com/p=
ub/scm/linux/kernel/git/torvalds/linux" rel=3D"noreferrer" target=3D"_blank=
">https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</=
a><br>
base:=C2=A0 =C2=A0 =C2=A0 9716c086c8e8b141d35aa61f2e96a2e83de212a7<br>
arch:=C2=A0 =C2=A0 =C2=A0 amd64<br>
compiler:=C2=A0 Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:=C2=A0 =C2=A0 <a href=3D"https://ci.syzbot.org/builds/ddf6ee7c-dfa8-=
4383-b004-10140edc081c/config" rel=3D"noreferrer" target=3D"_blank">https:/=
/ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config</a><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/f42da242-e16e-4f10-bf2=
5-0bd7e192d989/syz_repro" rel=3D"noreferrer" target=3D"_blank">https://ci.s=
yzbot.org/findings/f42da242-e16e-4f10-bf25-0bd7e192d989/syz_repro</a><br>
<br>
loop0: lost filesystem error report for type 5 error -117<br>
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:=
4069 [inline]<br>
BUG: KASAN: slab-use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096 [=
inline]<br>
BUG: KASAN: slab-use-after-free in ext4_inlinedir_to_tree+0x94c/0x10d0 fs/e=
xt4/inline.c:1335<br>
Read of size 1 at addr ffff88816fee8825 by task syz.0.20/5867<br>
<br>
CPU: 1 UID: 0 PID: 5867 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(ful=
l) <br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
=C2=A0print_address_description+0x55/0x1e0 mm/kasan/report.c:378<br>
=C2=A0print_report+0x58/0x70 mm/kasan/report.c:482<br>
=C2=A0kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
=C2=A0ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]<br>
=C2=A0ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]<br>
=C2=A0ext4_inlinedir_to_tree+0x94c/0x10d0 fs/ext4/inline.c:1335<br>
=C2=A0ext4_htree_fill_tree+0x517/0x1230 fs/ext4/namei.c:1182<br>
=C2=A0ext4_dx_readdir fs/ext4/dir.c:600 [inline]<br>
=C2=A0ext4_readdir+0x2db4/0x3640 fs/ext4/dir.c:146<br>
=C2=A0iterate_dir+0x399/0x570 fs/readdir.c:110<br>
=C2=A0__do_sys_getdents fs/readdir.c:319 [inline]<br>
=C2=A0__se_sys_getdents+0xf1/0x270 fs/readdir.c:304<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f010ad9ce59<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007f010bc0f028 EFLAGS: 00000246 ORIG_RAX: 000000000000004e<br>
RAX: ffffffffffffffda RBX: 00007f010b015fa0 RCX: 00007f010ad9ce59<br>
RDX: 0000000000000054 RSI: 0000000000000000 RDI: 0000000000000004<br>
RBP: 00007f010ae32d6f R08: 0000000000000000 R09: 0000000000000000<br>
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007f010b016038 R14: 00007f010b015fa0 R15: 00007ffd93577348<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
Allocated by task 5064:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0poison_kmalloc_redzone mm/kasan/common.c:398 [inline]<br>
=C2=A0__kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415<br>
=C2=A0kasan_kmalloc include/linux/kasan.h:263 [inline]<br>
=C2=A0__do_kmalloc_node mm/slub.c:5296 [inline]<br>
=C2=A0__kmalloc_noprof+0x35c/0x760 mm/slub.c:5308<br>
=C2=A0kmalloc_noprof include/linux/slab.h:954 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
=C2=A0tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]<br>
=C2=A0tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80<br>
=C2=A0tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283<=
br>
=C2=A0tomoyo_get_realpath security/tomoyo/file.c:151 [inline]<br>
=C2=A0tomoyo_path_perm+0x283/0x560 security/tomoyo/file.c:827<br>
=C2=A0security_inode_getattr+0x12b/0x310 security/security.c:1895<br>
=C2=A0vfs_getattr fs/stat.c:259 [inline]<br>
=C2=A0vfs_fstat fs/stat.c:281 [inline]<br>
=C2=A0vfs_fstatat+0xb4/0x170 fs/stat.c:371<br>
=C2=A0__do_sys_newfstatat fs/stat.c:538 [inline]<br>
=C2=A0__se_sys_newfstatat fs/stat.c:532 [inline]<br>
=C2=A0__x64_sys_newfstatat+0x151/0x200 fs/stat.c:532<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
Freed by task 5064:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:57 [inline]<br>
=C2=A0kasan_save_track+0x3e/0x80 mm/kasan/common.c:78<br>
=C2=A0kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584<br>
=C2=A0poison_slab_object mm/kasan/common.c:253 [inline]<br>
=C2=A0__kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285<br>
=C2=A0kasan_slab_free include/linux/kasan.h:235 [inline]<br>
=C2=A0slab_free_hook mm/slub.c:2689 [inline]<br>
=C2=A0slab_free mm/slub.c:6251 [inline]<br>
=C2=A0kfree+0x1c5/0x640 mm/slub.c:6566<br>
=C2=A0tomoyo_path_perm+0x403/0x560 security/tomoyo/file.c:847<br>
=C2=A0security_inode_getattr+0x12b/0x310 security/security.c:1895<br>
=C2=A0vfs_getattr fs/stat.c:259 [inline]<br>
=C2=A0vfs_fstat fs/stat.c:281 [inline]<br>
=C2=A0vfs_fstatat+0xb4/0x170 fs/stat.c:371<br>
=C2=A0__do_sys_newfstatat fs/stat.c:538 [inline]<br>
=C2=A0__se_sys_newfstatat fs/stat.c:532 [inline]<br>
=C2=A0__x64_sys_newfstatat+0x151/0x200 fs/stat.c:532<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
<br>
The buggy address belongs to the object at ffff88816fee8800<br>
=C2=A0which belongs to the cache kmalloc-64 of size 64<br>
The buggy address is located 37 bytes inside of<br>
=C2=A0freed 64-byte region [ffff88816fee8800, ffff88816fee8840)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16fee8=
<br>
flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f5(slab)<br>
raw: 057ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122<br=
>
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tg=
id 1 (swapper/0), ts 21294026082, free_ts 0<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853<br>
=C2=A0prep_new_page mm/page_alloc.c:1861 [inline]<br>
=C2=A0get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941<br>
=C2=A0__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221<br>
=C2=A0alloc_slab_page mm/slub.c:3278 [inline]<br>
=C2=A0allocate_slab+0x77/0x660 mm/slub.c:3467<br>
=C2=A0new_slab mm/slub.c:3525 [inline]<br>
=C2=A0refill_objects+0x339/0x3d0 mm/slub.c:7272<br>
=C2=A0refill_sheaf mm/slub.c:2816 [inline]<br>
=C2=A0__pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652<br>
=C2=A0alloc_from_pcs mm/slub.c:4750 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4884 [inline]<br>
=C2=A0__do_kmalloc_node mm/slub.c:5295 [inline]<br>
=C2=A0__kmalloc_noprof+0x474/0x760 mm/slub.c:5308<br>
=C2=A0kmalloc_noprof include/linux/slab.h:954 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1188 [inline]<br>
=C2=A0handler_new_ref+0x261/0x9c0 drivers/media/v4l2-core/v4l2-ctrls-core.c=
:1882<br>
=C2=A0v4l2_ctrl_add_handler+0x19f/0x290 drivers/media/v4l2-core/v4l2-ctrls-=
core.c:2443<br>
=C2=A0vivid_create_controls+0x332d/0x3bd0 drivers/media/test-drivers/vivid/=
vivid-ctrls.c:2072<br>
=C2=A0vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:1=
933 [inline]<br>
=C2=A0vivid_probe+0x4261/0x72b0 drivers/media/test-drivers/vivid/vivid-core=
.c:2095<br>
=C2=A0platform_probe+0xf9/0x190 drivers/base/platform.c:1432<br>
=C2=A0call_driver_probe drivers/base/dd.c:-1 [inline]<br>
=C2=A0really_probe+0x267/0xaf0 drivers/base/dd.c:709<br>
=C2=A0__driver_probe_device+0x1ef/0x380 drivers/base/dd.c:871<br>
=C2=A0driver_probe_device+0x4f/0x240 drivers/base/dd.c:901<br>
=C2=A0__driver_attach+0x34c/0x640 drivers/base/dd.c:1295<br>
page_owner free stack trace missing<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff88816fee8700: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc<br>
=C2=A0ffff88816fee8780: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc<br>
&gt;ffff88816fee8800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^<br>
=C2=A0ffff88816fee8880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
=C2=A0ffff88816fee8900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
KASAN: use-after-free Read in __ext4_check_dir_entry<br>
<br>
tree:=C2=A0 =C2=A0 =C2=A0 torvalds<br>
URL:=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://kernel.googlesource.com/p=
ub/scm/linux/kernel/git/torvalds/linux" rel=3D"noreferrer" target=3D"_blank=
">https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux</=
a><br>
base:=C2=A0 =C2=A0 =C2=A0 9716c086c8e8b141d35aa61f2e96a2e83de212a7<br>
arch:=C2=A0 =C2=A0 =C2=A0 amd64<br>
compiler:=C2=A0 Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8<br>
config:=C2=A0 =C2=A0 <a href=3D"https://ci.syzbot.org/builds/ddf6ee7c-dfa8-=
4383-b004-10140edc081c/config" rel=3D"noreferrer" target=3D"_blank">https:/=
/ci.syzbot.org/builds/ddf6ee7c-dfa8-4383-b004-10140edc081c/config</a><br>
syz repro: <a href=3D"https://ci.syzbot.org/findings/57c0b75a-8922-4dc1-9a2=
0-ca947564792b/syz_repro" rel=3D"noreferrer" target=3D"_blank">https://ci.s=
yzbot.org/findings/57c0b75a-8922-4dc1-9a20-ca947564792b/syz_repro</a><br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: use-after-free in ext4_dirent_get_data_len fs/ext4/ext4.h:4069 =
[inline]<br>
BUG: KASAN: use-after-free in ext4_dir_entry_len fs/ext4/ext4.h:4096 [inlin=
e]<br>
BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x65a/0xc40 fs/ext4/di=
r.c:96<br>
Read of size 1 at addr ffff88816be85045 by task syz.2.21/5880<br>
<br>
CPU: 1 UID: 0 PID: 5880 Comm: syz.2.21 Not tainted syzkaller #0 PREEMPT(ful=
l) <br>
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120<br>
=C2=A0print_address_description+0x55/0x1e0 mm/kasan/report.c:378<br>
=C2=A0print_report+0x58/0x70 mm/kasan/report.c:482<br>
=C2=A0kasan_report+0x117/0x150 mm/kasan/report.c:595<br>
=C2=A0ext4_dirent_get_data_len fs/ext4/ext4.h:4069 [inline]<br>
=C2=A0ext4_dir_entry_len fs/ext4/ext4.h:4096 [inline]<br>
=C2=A0__ext4_check_dir_entry+0x65a/0xc40 fs/ext4/dir.c:96<br>
=C2=A0ext4_find_dest_de+0x136/0x770 fs/ext4/namei.c:2203<br>
=C2=A0ext4_add_dirent_to_inline+0xcf/0x430 fs/ext4/inline.c:984<br>
=C2=A0ext4_try_add_inline_entry+0x235/0x8e0 fs/ext4/inline.c:1213<br>
=C2=A0__ext4_add_entry+0x390/0x1f40 fs/ext4/namei.c:2529<br>
=C2=A0ext4_add_entry fs/ext4/namei.c:2613 [inline]<br>
=C2=A0ext4_add_nondir+0x111/0x310 fs/ext4/namei.c:2936<br>
=C2=A0ext4_create+0x2e9/0x470 fs/ext4/namei.c:2982<br>
=C2=A0lookup_open fs/namei.c:4511 [inline]<br>
=C2=A0open_last_lookups fs/namei.c:4611 [inline]<br>
=C2=A0path_openat+0x1395/0x3860 fs/namei.c:4855<br>
=C2=A0do_file_open+0x23e/0x4a0 fs/namei.c:4887<br>
=C2=A0do_sys_openat2+0x113/0x200 fs/open.c:1364<br>
=C2=A0do_sys_open fs/open.c:1370 [inline]<br>
=C2=A0__do_sys_openat fs/open.c:1386 [inline]<br>
=C2=A0__se_sys_openat fs/open.c:1381 [inline]<br>
=C2=A0__x64_sys_openat+0x138/0x170 fs/open.c:1381<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f5713b9ce59<br>
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007fff672b25f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101<br>
RAX: ffffffffffffffda RBX: 00007f5713e15fa0 RCX: 00007f5713b9ce59<br>
RDX: 0000000000042042 RSI: 0000200000000080 RDI: 0000000000000004<br>
RBP: 00007f5713c32d6f R08: 0000000000000000 R09: 0000000000000000<br>
R10: 000000000000014a R11: 0000000000000246 R12: 0000000000000000<br>
R13: 00007f5713e15fac R14: 00007f5713e15fa0 R15: 00007f5713e15fa0<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16be85=
<br>
flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)<br>
page_type: f0(buddy)<br>
raw: 057ff00000000000 ffffea0005afa0c8 ffffea0005afa1c8 0000000000000000<br=
>
raw: 0000000000000000 0000000000000000 00000000f0000000 0000000000000000<br=
>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as freed<br>
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_=
KERNEL), pid 5630, tgid 5630 (syz-executor), ts 67290853657, free_ts 693211=
68948<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853<br>
=C2=A0prep_new_page mm/page_alloc.c:1861 [inline]<br>
=C2=A0get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941<br>
=C2=A0__alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221<br>
=C2=A0__alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255<br>
=C2=A0alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175<br>
=C2=A0___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]<br>
=C2=A0__kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]<br>
=C2=A0__kasan_populate_vmalloc+0xc1/0x1d0 mm/kasan/shadow.c:424<br>
=C2=A0kasan_populate_vmalloc include/linux/kasan.h:580 [inline]<br>
=C2=A0alloc_vmap_area+0xd47/0x1480 mm/vmalloc.c:2123<br>
=C2=A0__get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3226<br>
=C2=A0__vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:4024<br>
=C2=A0vmalloc_user_noprof+0xad/0xe0 mm/vmalloc.c:4218<br>
=C2=A0kcov_ioctl+0x55/0x620 kernel/kcov.c:726<br>
=C2=A0vfs_ioctl fs/ioctl.c:51 [inline]<br>
=C2=A0__do_sys_ioctl fs/ioctl.c:597 [inline]<br>
=C2=A0__se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583<br>
=C2=A0do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]<br>
=C2=A0do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
page last free pid 5693 tgid 5693 stack trace:<br>
=C2=A0reset_page_owner include/linux/page_owner.h:25 [inline]<br>
=C2=A0__free_pages_prepare mm/page_alloc.c:1397 [inline]<br>
=C2=A0__free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938<br>
=C2=A0kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:484<br>
=C2=A0apply_to_pte_range mm/memory.c:3338 [inline]<br>
=C2=A0apply_to_pmd_range mm/memory.c:3382 [inline]<br>
=C2=A0apply_to_pud_range mm/memory.c:3418 [inline]<br>
=C2=A0apply_to_p4d_range mm/memory.c:3454 [inline]<br>
=C2=A0__apply_to_page_range+0xbdc/0x1420 mm/memory.c:3490<br>
=C2=A0__kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:602<br>
=C2=A0kasan_release_vmalloc include/linux/kasan.h:593 [inline]<br>
=C2=A0kasan_release_vmalloc_node mm/vmalloc.c:2284 [inline]<br>
=C2=A0purge_vmap_node+0x220/0x960 mm/vmalloc.c:2306<br>
=C2=A0__purge_vmap_area_lazy+0x779/0xb40 mm/vmalloc.c:2396<br>
=C2=A0drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2430<br>
=C2=A0process_one_work kernel/workqueue.c:3314 [inline]<br>
=C2=A0process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397<br>
=C2=A0worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478<br>
=C2=A0kthread+0x389/0x470 kernel/kthread.c:436<br>
=C2=A0ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff88816be84f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
=C2=A0ffff88816be84f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00<br>
&gt;ffff88816be85000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0^<br>
=C2=A0ffff88816be85080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
=C2=A0ffff88816be85100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
***<br>
<br>
If these findings have caused you to resend the series or submit a<br>
separate fix, please add the following tag to your commit message:<br>
=C2=A0 Tested-by: <a href=3D"mailto:syzbot@syzkaller.appspotmail.com" targe=
t=3D"_blank">syzbot@syzkaller.appspotmail.com</a><br>
<br>
---<br>
This report is generated by a bot. It may contain errors.<br>
syzbot ci engineers can be reached at <a href=3D"mailto:syzkaller@googlegro=
ups.com" target=3D"_blank">syzkaller@googlegroups.com</a>.<br>
<br>
To test a patch for this bug, please reply with `#syz test`<br>
(should be on a separate line).<br>
<br>
The patch should be attached to the email.<br>
Note: arguments like custom git repos and branches are not supported.<br>
<br>
</blockquote></div></div>

--000000000000518ee506549bdd5b--
--000000000000518ee606549bdd5d
Content-Type: application/octet-stream; name="dirdata-syzbot-fix.patch"
Content-Disposition: attachment; filename="dirdata-syzbot-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mql0ar3s0>
X-Attachment-Id: f_mql0ar3s0

RnJvbSBlM2Q1Yzc0ZjFlYzBmYmVmYjlhNGI5MTkzYTQ3NDYxNGI5OGQ2NDBhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcnRlbSBCbGFnb2RhcmVua28gPGFydGVtLmJsYWdvZGFyZW5r
b0BnbWFpbC5jb20+CkRhdGU6IEZyaSwgMTkgSnVuIDIwMjYgMDk6NDg6MTIgLTA0MDAKU3ViamVj
dDogW1BBVENIXSBleHQ0OiBmaXggaXNzdWVzIHJlcG9ydGVkIGJ5IHN5emJvdC9DSSBvbiB0aGUg
ZGlyZGF0YSBzZXJpZXMKCkFkZHJlc3MgdGhlIGZvbGxvd2luZyBpc3N1ZXMgZm91bmQgYnkgYXV0
b21hdGVkIHJldmlldyBvZiB0aGUgdjIKZGlyZGF0YSBwYXRjaCBzZXJpZXM6CgotIGR4X2dldF9k
eF9pbmZvKCkgY2FsbGVkIGV4dDRfZGlyX2VudHJ5X2xlbigpIHdpdGggZGlyIGhhcmRjb2RlZCB0
bwogIE5VTEwsIGZvcmNpbmcgaXRzIGJsb2Nrc2l6ZSBmYWxsYmFjayB0byA0MDk2IHJlZ2FyZGxl
c3Mgb2YgdGhlIHJlYWwKICBmaWxlc3lzdGVtIGJsb2Nrc2l6ZSwgYW5kIG5ldmVyIHZhbGlkYXRl
ZCB0aGF0IHRoZSBjb21wdXRlZCBvZmZzZXQKICBzdGF5ZWQgd2l0aGluIHRoZSBibG9jay4gVGhy
ZWFkIHRoZSByZWFsIGlub2RlIHRocm91Z2ggYW5kIHJlamVjdAogIG91dC1vZi1ib3VuZHMgcmVz
dWx0cy4KCi0gZ2V0X2R4X2NvdW50bGltaXQoKSBoYWQgdGhlIHNhbWUgTlVMTC1kaXIgYmxvY2tz
aXplLWZhbGxiYWNrIGJ1ZyBhdAogIGEgc2VwYXJhdGUgY2FsbCBzaXRlOyBwYXNzIHRoZSByZWFs
IGlub2RlIHRocm91Z2ggdGhlcmUgdG9vLgoKLSBleHQ0X2RpcmRhdGFfZ2V0KCkgZGVjbGFyZWQg
YSBsb2NhbCAiZGZpZCIgaW5zaWRlIHRoZQogIEVYVDRfRElSRU5UX0xVRklEIGJyYW5jaCB0aGF0
IHNoYWRvd2VkIHRoZSBmdW5jdGlvbidzIG93biAiZGZpZCIKICBvdXRwdXQgcGFyYW1ldGVyLCBz
byB0aGUgTFVGSUQgY29weSBuZXZlciByZWFjaGVkIHRoZSBjYWxsZXIncwogIGJ1ZmZlci4gUmVu
YW1lIHRoZSBsb2NhbCBhbmQgY29weSBpbnRvIHRoZSByZWFsIHBhcmFtZXRlci4gQWxzbywKICBi
b3RoIGV4dDRfZGlyZGF0YV9nZXQoKSBhbmQgZXh0NF9kaXJkYXRhX3NldCgpIGNvbXBhcmVkIG9m
ZnNldHMKICBhZ2FpbnN0IHRoZSByYXcgb24tZGlzayBkZS0+cmVjX2xlbiBpbnN0ZWFkIG9mIGRl
Y29kaW5nIGl0IHZpYQogIGV4dDRfcmVjX2xlbl9mcm9tX2Rpc2soKSwgd2hpY2ggaXMgd3Jvbmcg
b24gYmlnLWVuZGlhbiBob3N0cyBhbmQKICBtaXNoYW5kbGVzIHRoZSAiMC82NTUzNSBtZWFucyBm
dWxsIGJsb2NrIiBzZW50aW5lbC4KCi0gZXh0NF9kaXJkYXRhX3NldF9sdWZpZCgpIChFWFQ0X0lP
Q19TRVRfTFVGSUQpIGRlbGV0ZWQgdGhlIGV4aXN0aW5nCiAgZGlyZWN0b3J5IGVudHJ5IGFuZCB0
aGVuIHRyaWVkIHRvIHJlLWFkZCBpdCB3aXRoIHRoZSBuZXcgTFVGSUQKICBkYXRhOyBpZiBleHQ0
X2FkZF9lbnRyeSgpIGZhaWxlZCwgdGhlIGlub2RlIHdhcyBsZWZ0IHdpdGggbm8KICBkaXJlY3Rv
cnkgZW50cnkgcG9pbnRpbmcgYXQgaXQuIE9uIGZhaWx1cmUsIGF0dGVtcHQgdG8gcmVzdG9yZSB0
aGUKICBvcmlnaW5hbCBlbnRyeSwgYW5kIGxvdWRseSBmbGFnIGlub2RlIGNvcnJ1cHRpb24gaWYg
dGhhdCBhbHNvCiAgZmFpbHMuCgpTaWduZWQtb2ZmLWJ5OiBBcnRlbSBCbGFnb2RhcmVua28gPGFy
dGVtLmJsYWdvZGFyZW5rb0BnbWFpbC5jb20+Ci0tLQogZnMvZXh0NC9uYW1laS5jIHwgMTA1ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDc4IGluc2VydGlvbnMoKyksIDI3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L2V4dDQvbmFtZWkuYyBiL2ZzL2V4dDQvbmFtZWkuYwppbmRleCA2NWM1M2MwODIxM2EuLmU2ZjU0
ZGJhNzM1ZSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9uYW1laS5jCisrKyBiL2ZzL2V4dDQvbmFtZWku
YwpAQCAtNDEyLDcgKzQxMiw3IEBAIHN0YXRpYyBzdHJ1Y3QgZHhfY291bnRsaW1pdCAqZ2V0X2R4
X2NvdW50bGltaXQoc3RydWN0IGlub2RlICppbm9kZSwKIAkJaWYgKGxlMTZfdG9fY3B1KGRlLT5y
ZWNfbGVuKSAhPSAoYmxvY2tzaXplIC0gcmxlbikpCiAJCQlyZXR1cm4gTlVMTDsKIAkJLyogZGUt
PnJlY19sZW4gY292ZXJzIHdob2xlIGR4X3Jvb3QgYmxvY2ssIGNhbGN1bGF0ZSBhY3R1YWwgbGVu
Z3RoICovCi0JCWRvdGRvdF9yZWNfbGVuID0gZXh0NF9kaXJfZW50cnlfbGVuKGRlLCBOVUxMKTsK
KwkJZG90ZG90X3JlY19sZW4gPSBleHQ0X2Rpcl9lbnRyeV9sZW4oZGUsIGlub2RlKTsKIAkJcm9v
dCA9IChzdHJ1Y3QgZHhfcm9vdF9pbmZvICopKCgoY2hhciAqKWRlICsgZG90ZG90X3JlY19sZW4p
KTsKIAkJaWYgKHJvb3QtPnJlc2VydmVkX3plcm8gfHwKIAkJICAgIHJvb3QtPmluZm9fbGVuZ3Ro
ICE9IHNpemVvZihzdHJ1Y3QgZHhfcm9vdF9pbmZvKSkKQEAgLTUyMCwxMyArNTIwLDIwIEBAIGV4
dDRfbmV4dF9lbnRyeShzdHJ1Y3QgZXh0NF9kaXJfZW50cnlfMiAqcCwgdW5zaWduZWQgbG9uZyBi
bG9ja3NpemUpCiAgKiBGdXR1cmU6IHVzZSBoaWdoIGZvdXIgYml0cyBvZiBibG9jayBmb3IgY29h
bGVzY2Utb24tZGVsZXRlIGZsYWdzCiAgKiBNYXNrIHRoZW0gb2ZmIGZvciBub3cuCiAgKi8KLXN0
YXRpYyBzdHJ1Y3QgZHhfcm9vdF9pbmZvICpkeF9nZXRfZHhfaW5mbyh2b2lkICpkZV9idWYpCitz
dGF0aWMgc3RydWN0IGR4X3Jvb3RfaW5mbyAqZHhfZ2V0X2R4X2luZm8oc3RydWN0IGlub2RlICpk
aXIsIHZvaWQgKmRlX2J1ZikKIHsKKwl1bnNpZ25lZCBpbnQgYmxvY2tzaXplID0gZGlyLT5pX3Ni
LT5zX2Jsb2Nrc2l6ZTsKKwl2b2lkICpiYXNlID0gZGVfYnVmOworCiAJLyogZ2V0IGRvdGRvdCBm
aXJzdCAqLwotCWRlX2J1ZiArPSBleHQ0X2Rpcl9lbnRyeV9sZW4oZGVfYnVmLCBOVUxMKTsKKwlk
ZV9idWYgKz0gZXh0NF9kaXJfZW50cnlfbGVuKGRlX2J1ZiwgZGlyKTsKIAogCS8qIGR4IHJvb3Qg
aW5mbyBpcyBhZnRlciBkb3Rkb3QgZW50cnkgKi8KLQlkZV9idWYgKz0gZXh0NF9kaXJfZW50cnlf
bGVuKGRlX2J1ZiwgTlVMTCk7CisJZGVfYnVmICs9IGV4dDRfZGlyX2VudHJ5X2xlbihkZV9idWYs
IGRpcik7CisKKwlpZiAoZGVfYnVmIDwgYmFzZSB8fCAoY2hhciAqKWRlX2J1ZiAtIChjaGFyICop
YmFzZSArCisJCQkgICAgICBzaXplb2Yoc3RydWN0IGR4X3Jvb3RfaW5mbykgPiBibG9ja3NpemUp
CisJCXJldHVybiBFUlJfUFRSKC1FRlNDT1JSVVBURUQpOwogCiAJcmV0dXJuIChzdHJ1Y3QgZHhf
cm9vdF9pbmZvICopZGVfYnVmOwogfQpAQCAtNTc3LDcgKzU4NCw5IEBAIHN0YXRpYyBpbmxpbmUg
dW5zaWduZWQgZHhfcm9vdF9saW1pdChzdHJ1Y3QgaW5vZGUgKmRpciwKIAlzdHJ1Y3QgZHhfcm9v
dF9pbmZvICppbmZvOwogCXVuc2lnbmVkIGludCBlbnRyeV9zcGFjZTsKIAotCWluZm8gPSBkeF9n
ZXRfZHhfaW5mbyhkb3RfZGUpOworCWluZm8gPSBkeF9nZXRfZHhfaW5mbyhkaXIsIGRvdF9kZSk7
CisJaWYgKElTX0VSUihpbmZvKSkKKwkJcmV0dXJuIDA7CiAJZW50cnlfc3BhY2UgPSBkaXItPmlf
c2ItPnNfYmxvY2tzaXplIC0gKChjaGFyICopaW5mbyAtIChjaGFyICopZG90X2RlKSAtCiAJCWlu
Zm8tPmluZm9fbGVuZ3RoOwogCkBAIC03OTMsNyArODAyLDkgQEAgZHhfcHJvYmUoc3RydWN0IGV4
dDRfZmlsZW5hbWUgKmZuYW1lLCBzdHJ1Y3QgaW5vZGUgKmRpciwKIAlpZiAoSVNfRVJSKGZyYW1l
LT5iaCkpCiAJCXJldHVybiAoc3RydWN0IGR4X2ZyYW1lICopIGZyYW1lLT5iaDsKIAotCWluZm8g
PSBkeF9nZXRfZHhfaW5mbygoc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIgKilmcmFtZS0+YmgtPmJf
ZGF0YSk7CisJaW5mbyA9IGR4X2dldF9keF9pbmZvKGRpciwgKHN0cnVjdCBleHQ0X2Rpcl9lbnRy
eV8yICopZnJhbWUtPmJoLT5iX2RhdGEpOworCWlmIChJU19FUlIoaW5mbykpCisJCWdvdG8gZmFp
bDsKIAlpZiAoaW5mby0+aGFzaF92ZXJzaW9uICE9IERYX0hBU0hfVEVBICYmCiAJICAgIGluZm8t
Pmhhc2hfdmVyc2lvbiAhPSBEWF9IQVNIX0hBTEZfTUQ0ICYmCiAJICAgIGluZm8tPmhhc2hfdmVy
c2lvbiAhPSBEWF9IQVNIX0xFR0FDWSAmJgpAQCAtOTM4LDcgKzk0OSw3IEBAIGR4X3Byb2JlKHN0
cnVjdCBleHQ0X2ZpbGVuYW1lICpmbmFtZSwgc3RydWN0IGlub2RlICpkaXIsCiAJcmV0dXJuIHJl
dF9lcnI7CiB9CiAKLXN0YXRpYyB2b2lkIGR4X3JlbGVhc2Uoc3RydWN0IGR4X2ZyYW1lICpmcmFt
ZXMpCitzdGF0aWMgdm9pZCBkeF9yZWxlYXNlKHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgZHhf
ZnJhbWUgKmZyYW1lcykKIHsKIAlzdHJ1Y3QgZHhfcm9vdF9pbmZvICppbmZvOwogCWludCBpOwpA
QCAtOTQ3LDcgKzk1OCw5IEBAIHN0YXRpYyB2b2lkIGR4X3JlbGVhc2Uoc3RydWN0IGR4X2ZyYW1l
ICpmcmFtZXMpCiAJaWYgKGZyYW1lc1swXS5iaCA9PSBOVUxMKQogCQlyZXR1cm47CiAKLQlpbmZv
ID0gZHhfZ2V0X2R4X2luZm8oKHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICopZnJhbWVzWzBdLmJo
LT5iX2RhdGEpOworCWluZm8gPSBkeF9nZXRfZHhfaW5mbyhkaXIsIChzdHJ1Y3QgZXh0NF9kaXJf
ZW50cnlfMiAqKWZyYW1lc1swXS5iaC0+Yl9kYXRhKTsKKwlpZiAoSVNfRVJSKGluZm8pKQorCQly
ZXR1cm47CiAJLyogc2F2ZSBsb2NhbCBjb3B5LCAiaW5mbyIgbWF5IGJlIGZyZWVkIGFmdGVyIGJy
ZWxzZSgpICovCiAJaW5kaXJlY3RfbGV2ZWxzID0gaW5mby0+aW5kaXJlY3RfbGV2ZWxzOwogCWZv
ciAoaSA9IDA7IGkgPD0gaW5kaXJlY3RfbGV2ZWxzOyBpKyspIHsKQEAgLTEyNTMsMTIgKzEyNjYs
MTIgQEAgaW50IGV4dDRfaHRyZWVfZmlsbF90cmVlKHN0cnVjdCBmaWxlICpkaXJfZmlsZSwgX191
MzIgc3RhcnRfaGFzaCwKIAkJICAgIChjb3VudCAmJiAoKGhhc2h2YWwgJiAxKSA9PSAwKSkpCiAJ
CQlicmVhazsKIAl9Ci0JZHhfcmVsZWFzZShmcmFtZXMpOworCWR4X3JlbGVhc2UoZGlyLCBmcmFt
ZXMpOwogCWR4dHJhY2UocHJpbnRrKEtFUk5fREVCVUcgIkZpbGwgdHJlZTogcmV0dXJuZWQgJWQg
ZW50cmllcywgIgogCQkgICAgICAgIm5leHQgaGFzaDogJXhcbiIsIGNvdW50LCAqbmV4dF9oYXNo
KSk7CiAJcmV0dXJuIGNvdW50OwogZXJyb3V0OgotCWR4X3JlbGVhc2UoZnJhbWVzKTsKKwlkeF9y
ZWxlYXNlKGRpciwgZnJhbWVzKTsKIAlyZXR1cm4gKGVycik7CiB9CiAKQEAgLTEyOTYsOCArMTMw
OSwxMCBAQCB1bnNpZ25lZCBjaGFyIGV4dDRfZGlyZGF0YV9nZXQoc3RydWN0IGV4dDRfZGlyX2Vu
dHJ5XzIgKmRlLCBzdHJ1Y3QgaW5vZGUgKmRpciwKIHsKIAl1bnNpZ25lZCBjaGFyIHJldCA9IDA7
CiAJdW5zaWduZWQgaW50IGRhdGFfb2Zmc2V0ID0gZGUtPm5hbWVfbGVuICsgMTsKKwl1bnNpZ25l
ZCBpbnQgcmVjX2xlbiA9IGV4dDRfcmVjX2xlbl9mcm9tX2Rpc2soZGUtPnJlY19sZW4sCisJCQkJ
CQkgICAgICAgZGlyLT5pX3NiLT5zX2Jsb2Nrc2l6ZSk7CiAKLQlpZiAoZGF0YV9vZmZzZXQgPiBk
ZS0+cmVjX2xlbikKKwlpZiAoZGF0YV9vZmZzZXQgPiByZWNfbGVuKQogCQlyZXR1cm4gcmV0Owog
CiAJLyogY29tcGF0aWJpbGl0eTogaGFzaCBzdG9yZWQgaW5saW5lIGFmdGVyIGZpbGVuYW1lIChu
byBkaXJkYXRhKSAqLwpAQCAtMTMxMiwxOSArMTMyNywyMCBAQCB1bnNpZ25lZCBjaGFyIGV4dDRf
ZGlyZGF0YV9nZXQoc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIgKmRlLCBzdHJ1Y3QgaW5vZGUgKmRp
ciwKIAogCS8qICBFWFQ0X0RJUkVOVF8qIGFyZSBub3QgZXhwZWN0ZWQgd2l0aG91dCBmbGFnIGlu
IGlfc2IgKi8KIAlpZiAoZGUtPmZpbGVfdHlwZSAmIEVYVDRfRElSRU5UX0xVRklEKSB7Ci0JCXN0
cnVjdCBleHQ0X2RpcmVudF9maWQgKmRmaWQgPQorCQlzdHJ1Y3QgZXh0NF9kaXJlbnRfZmlkICpk
aXNrX2ZpZCA9CiAJCQkoc3RydWN0IGV4dDRfZGlyZW50X2ZpZCAqKShkZS0+bmFtZSArIGRhdGFf
b2Zmc2V0KTsKIAkJdW5zaWduZWQgaW50IGRsZW47CiAKLQkJaWYgKGRhdGFfb2Zmc2V0ICsgc2l6
ZW9mKGRmaWQtPmRmX2hlYWRlcikgPiBkZS0+cmVjX2xlbikKKwkJaWYgKGRhdGFfb2Zmc2V0ICsg
c2l6ZW9mKGRpc2tfZmlkLT5kZl9oZWFkZXIpID4gcmVjX2xlbikKIAkJCXJldHVybiByZXQ7CiAK
LQkJZGxlbiA9IGRmaWQtPmRmX2hlYWRlci5kZGhfbGVuZ3RoOwotCQlpZiAoZGxlbiA8IHNpemVv
ZigqZGZpZCkgfHwgZGF0YV9vZmZzZXQgKyBkbGVuID4gZGUtPnJlY19sZW4pCisJCWRsZW4gPSBk
aXNrX2ZpZC0+ZGZfaGVhZGVyLmRkaF9sZW5ndGg7CisJCWlmIChkbGVuIDwgc2l6ZW9mKCpkaXNr
X2ZpZCkgfHwgZGF0YV9vZmZzZXQgKyBkbGVuID4gcmVjX2xlbikKIAkJCXJldHVybiByZXQ7CiAK
IAkJaWYgKGRmaWQpIHsKLQkJCW1lbWNweShkZmlkLCBkZmlkLT5kZl9maWQsIGRmaWQtPmRmX2hl
YWRlci5kZGhfbGVuZ3RoKTsKKwkJCW1lbWNweShkZmlkLCBkaXNrX2ZpZC0+ZGZfZmlkLAorCQkJ
ICAgICAgIGRpc2tfZmlkLT5kZl9oZWFkZXIuZGRoX2xlbmd0aCk7CiAJCQlyZXQgfD0gRVhUNF9E
SVJFTlRfTFVGSUQ7CiAJCX0KIAkJZGF0YV9vZmZzZXQgKz0gZGxlbjsKQEAgLTEzMzYsMTEgKzEz
NTIsMTEgQEAgdW5zaWduZWQgY2hhciBleHQ0X2RpcmRhdGFfZ2V0KHN0cnVjdCBleHQ0X2Rpcl9l
bnRyeV8yICpkZSwgc3RydWN0IGlub2RlICpkaXIsCiAJCSAgICAgICAoc3RydWN0IGV4dDRfZGly
ZW50X2RhdGFfaGVhZGVyICopKGRlLT5uYW1lICsgZGF0YV9vZmZzZXQpOwogCQl1bnNpZ25lZCBp
bnQgZGxlbjsKIAotCQlpZiAoZGF0YV9vZmZzZXQgKyBzaXplb2YoKmRkaCkgPiBkZS0+cmVjX2xl
bikKKwkJaWYgKGRhdGFfb2Zmc2V0ICsgc2l6ZW9mKCpkZGgpID4gcmVjX2xlbikKIAkJCXJldHVy
biByZXQ7CiAKIAkJZGxlbiA9IGRkaC0+ZGRoX2xlbmd0aDsKLQkJaWYgKGRsZW4gPCBzaXplb2Yo
KmRkaCkgfHwgZGF0YV9vZmZzZXQgKyBkbGVuID4gZGUtPnJlY19sZW4pCisJCWlmIChkbGVuIDwg
c2l6ZW9mKCpkZGgpIHx8IGRhdGFfb2Zmc2V0ICsgZGxlbiA+IHJlY19sZW4pCiAJCQlyZXR1cm4g
cmV0OwogCiAJCWRhdGFfb2Zmc2V0ICs9IGRsZW47CkBAIC0xMzU1LDcgKzEzNzEsNyBAQCB1bnNp
Z25lZCBjaGFyIGV4dDRfZGlyZGF0YV9nZXQoc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIgKmRlLCBz
dHJ1Y3QgaW5vZGUgKmRpciwKIAkJdW5zaWduZWQgaW50IGRsZW47CiAKIAkJZGxlbiA9IGRoLT5k
aF9oZWFkZXIuZGRoX2xlbmd0aDsKLQkJaWYgKGRsZW4gPCBzaXplb2YoKmRoKSB8fCBkYXRhX29m
ZnNldCArIGRsZW4gPiBkZS0+cmVjX2xlbikKKwkJaWYgKGRsZW4gPCBzaXplb2YoKmRoKSB8fCBk
YXRhX29mZnNldCArIGRsZW4gPiByZWNfbGVuKQogCQkJcmV0dXJuIHJldDsKIAogCQloaW5mby0+
aGFzaCA9IGxlMzJfdG9fY3B1KGRoLT5kaF9oYXNoLmhhc2gpOwpAQCAtMTM4MywxMiArMTM5OSwx
NCBAQCBzdGF0aWMgdm9pZCBleHQ0X2RpcmRhdGFfc2V0KHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8y
ICpkZSwgc3RydWN0IGlub2RlICpkaXIsCiB7CiAJc3RydWN0IGR4X2hhc2hfaW5mbyAqaGluZm8g
PSAmZm5hbWUtPmhpbmZvOwogCXVuc2lnbmVkIGludCBkYXRhX29mZnNldCA9IGRlLT5uYW1lX2xl
biArIDE7CisJdW5zaWduZWQgaW50IHJlY19sZW4gPSBleHQ0X3JlY19sZW5fZnJvbV9kaXNrKGRl
LT5yZWNfbGVuLAorCQkJCQkJICAgICAgIGRpci0+aV9zYi0+c19ibG9ja3NpemUpOwogCiAKIAlp
ZiAoZGZpZCkgewogCQl1bnNpZ25lZCBpbnQgZGxlbiA9IGRmaWQtPmRmX2hlYWRlci5kZGhfbGVu
Z3RoOwogCi0JCWlmIChkYXRhX29mZnNldCArIGRsZW4gPiBkZS0+cmVjX2xlbikgeworCQlpZiAo
ZGF0YV9vZmZzZXQgKyBkbGVuID4gcmVjX2xlbikgewogCQkJRVhUNF9FUlJPUl9JTk9ERShkaXIs
ICJDYW4gbm90IGluc2VydCBGSUQiKTsKIAkJCXJldHVybjsKIAkJfQpAQCAtMTQwNiw3ICsxNDI0
LDcgQEAgc3RhdGljIHZvaWQgZXh0NF9kaXJkYXRhX3NldChzdHJ1Y3QgZXh0NF9kaXJfZW50cnlf
MiAqZGUsIHN0cnVjdCBpbm9kZSAqZGlyLAogCQkJc3RydWN0IGV4dDRfZGlyZW50X2hhc2ggKmRo
ID0KIAkJCSAgICAoc3RydWN0IGV4dDRfZGlyZW50X2hhc2ggKikoZGUtPm5hbWUgKyBkYXRhX29m
ZnNldCk7CiAKLQkJCWlmIChkYXRhX29mZnNldCArIHNpemVvZigqZGgpID4gZGUtPnJlY19sZW4p
IHsKKwkJCWlmIChkYXRhX29mZnNldCArIHNpemVvZigqZGgpID4gcmVjX2xlbikgewogCQkJCUVY
VDRfRVJST1JfSU5PREUoZGlyLCAiQ2FuIG5vdCBpbnNlcnQgZGhhc2ggZGlyZGF0YSIpOwogCQkJ
CXJldHVybjsKIAkJCX0KQEAgLTE0MTgsNyArMTQzNiw3IEBAIHN0YXRpYyB2b2lkIGV4dDRfZGly
ZGF0YV9zZXQoc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIgKmRlLCBzdHJ1Y3QgaW5vZGUgKmRpciwK
IAkJfSBlbHNlIHsKIAkJCS8qIENvbXBhdGliaWxpdHk6IHN0b3JlIGhhc2ggaW5saW5lIGFmdGVy
IGZpbGVuYW1lICovCiAJCQlpZiAoZGF0YV9vZmZzZXQgKyBzaXplb2Yoc3RydWN0IGV4dDRfZGly
X2VudHJ5X2hhc2gpID4KLQkJCQkJCQkJZGUtPiByZWNfbGVuKSB7CisJCQkJCQkJCXJlY19sZW4p
IHsKIAkJCQlFWFQ0X0VSUk9SX0lOT0RFKGRpciwgIkNhbiBub3QgaW5zZXJ0IGRoYXNoIik7CiAJ
CQkJcmV0dXJuOwogCQkJfQpAQCAtMTkwNiw3ICsxOTI0LDcgQEAgc3RhdGljIHN0cnVjdCBidWZm
ZXJfaGVhZCAqIGV4dDRfZHhfZmluZF9lbnRyeShzdHJ1Y3QgaW5vZGUgKmRpciwKIGVycm91dDoK
IAlkeHRyYWNlKHByaW50ayhLRVJOX0RFQlVHICIlcyBub3QgZm91bmRcbiIsIGZuYW1lLT51c3Jf
Zm5hbWUtPm5hbWUpKTsKIHN1Y2Nlc3M6Ci0JZHhfcmVsZWFzZShmcmFtZXMpOworCWR4X3JlbGVh
c2UoZGlyLCBmcmFtZXMpOwogCXJldHVybiBiaDsKIH0KIApAQCAtMjQyNSw3ICsyNDQzLDEyIEBA
IHN0YXRpYyBpbnQgbWFrZV9pbmRleGVkX2RpcihoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgZXh0
NF9maWxlbmFtZSAqZm5hbWUsCiAJCQkJICAgICBibG9ja3NpemUpOwogCiAJLyogaW5pdGlhbGl6
ZSBoYXNoaW5nIGluZm8gKi8KLQlkeF9pbmZvID0gZHhfZ2V0X2R4X2luZm8oZG90X2RlKTsKKwlk
eF9pbmZvID0gZHhfZ2V0X2R4X2luZm8oZGlyLCBkb3RfZGUpOworCWlmIChJU19FUlIoZHhfaW5m
bykpIHsKKwkJYnJlbHNlKGJoMik7CisJCWJyZWxzZShiaCk7CisJCXJldHVybiBQVFJfRVJSKGR4
X2luZm8pOworCX0KIAltZW1zZXQoZHhfaW5mbywgMCwgc2l6ZW9mKCpkeF9pbmZvKSk7CiAJZHhf
aW5mby0+aW5mb19sZW5ndGggPSBzaXplb2YoKmR4X2luZm8pOwogCWlmIChleHQ0X2hhc2hfaW5f
ZGlyZW50KGRpcikpCkBAIC0yNDgzLDcgKzI1MDYsNyBAQCBzdGF0aWMgaW50IG1ha2VfaW5kZXhl
ZF9kaXIoaGFuZGxlX3QgKmhhbmRsZSwgc3RydWN0IGV4dDRfZmlsZW5hbWUgKmZuYW1lLAogCSAq
LwogCWlmIChyZXR2YWwpCiAJCWV4dDRfbWFya19pbm9kZV9kaXJ0eShoYW5kbGUsIGRpcik7Ci0J
ZHhfcmVsZWFzZShmcmFtZXMpOworCWR4X3JlbGVhc2UoZGlyLCBmcmFtZXMpOwogCWJyZWxzZShi
aDIpOwogCXJldHVybiByZXR2YWw7CiB9CkBAIC0yNzU5LDggKzI3ODIsMTMgQEAgc3RhdGljIGlu
dCBleHQ0X2R4X2FkZF9lbnRyeShoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgZXh0NF9maWxlbmFt
ZSAqZm5hbWUsCiAJCQkvKiBTZXQgdXAgcm9vdCAqLwogCQkJZHhfc2V0X2NvdW50KGVudHJpZXMs
IDEpOwogCQkJZHhfc2V0X2Jsb2NrKGVudHJpZXMgKyAwLCBuZXdibG9jayk7Ci0JCQlpbmZvID0g
ZHhfZ2V0X2R4X2luZm8oKHN0cnVjdCBleHQ0X2Rpcl9lbnRyeV8yICopCisJCQlpbmZvID0gZHhf
Z2V0X2R4X2luZm8oZGlyLCAoc3RydWN0IGV4dDRfZGlyX2VudHJ5XzIgKikKIAkJCQkJICAgICAg
ZnJhbWVzWzBdLmJoLT5iX2RhdGEpOworCQkJaWYgKElTX0VSUihpbmZvKSkgeworCQkJCWVyciA9
IFBUUl9FUlIoaW5mbyk7CisJCQkJYnJlbHNlKGJoMik7CisJCQkJZ290byBqb3VybmFsX2Vycm9y
OworCQkJfQogCQkJaW5mby0+aW5kaXJlY3RfbGV2ZWxzICs9IDE7CiAJCQlkeHRyYWNlKHByaW50
ayhLRVJOX0RFQlVHCiAJCQkJICAgICAgICJDcmVhdGluZyAlZCBsZXZlbCBpbmRleC4uLlxuIiwK
QEAgLTI3ODgsNyArMjgxNiw3IEBAIHN0YXRpYyBpbnQgZXh0NF9keF9hZGRfZW50cnkoaGFuZGxl
X3QgKmhhbmRsZSwgc3RydWN0IGV4dDRfZmlsZW5hbWUgKmZuYW1lLAogCWV4dDRfc3RkX2Vycm9y
KGRpci0+aV9zYiwgZXJyKTsgLyogdGhpcyBpcyBhIG5vLW9wIGlmIGVyciA9PSAwICovCiBjbGVh
bnVwOgogCWJyZWxzZShiaCk7Ci0JZHhfcmVsZWFzZShmcmFtZXMpOworCWR4X3JlbGVhc2UoZGly
LCBmcmFtZXMpOwogCS8qIEByZXN0YXJ0IGlzIHRydWUgbWVhbnMgaHRyZWUtcGF0aCBoYXMgYmVl
biBjaGFuZ2VkLCB3ZSBuZWVkIHRvCiAJICogcmVwZWF0IGR4X3Byb2JlKCkgdG8gZmluZCBvdXQg
dmFsaWQgaHRyZWUtcGF0aAogCSAqLwpAQCAtNDQ2Myw2ICs0NDkxLDI5IEBAIGludCBleHQ0X2Rp
cmRhdGFfc2V0X2x1ZmlkKHN0cnVjdCBpbm9kZSAqZGlyLCBjb25zdCBjaGFyICpmaWxlbmFtZSwK
IAl9CiAJRVhUNF9JKGlub2RlKS0+aV9kaXJkYXRhID0gb2xkX2RpcmRhdGE7CiAKKwlpZiAoZXJy
KSB7CisJCS8qCisJCSAqIFRoZSBvcmlnaW5hbCBlbnRyeSB3YXMgYWxyZWFkeSByZW1vdmVkIGFi
b3ZlIGFuZCB0aGUKKwkJICogcmUtYWRkIHdpdGggdGhlIG5ldyBMVUZJRCBmYWlsZWQ7IHRyeSB0
byByZXN0b3JlIHRoZQorCQkgKiBvcmlnaW5hbCBlbnRyeSBzbyB0aGUgaW5vZGUgaXNuJ3QgbGVm
dCB3aXRob3V0IGFueQorCQkgKiBkaXJlY3RvcnkgZW50cnkgcG9pbnRpbmcgYXQgaXQuCisJCSAq
LworCQlzdHJ1Y3QgZGVudHJ5IHBhcmVudF9kZW50cnkgPSB7IC5kX2lub2RlID0gZGlyIH07CisJ
CXN0cnVjdCBkZW50cnkgb3JpZ19kZW50cnkgPSB7CisJCQkuZF9uYW1lID0gZF9uYW1lLAorCQkJ
LmRfcGFyZW50ID0gJnBhcmVudF9kZW50cnksCisJCQkuZF9pbm9kZSA9IGlub2RlLAorCQl9Owor
CQlpbnQgcm9sbGJhY2tfZXJyID0gZXh0NF9hZGRfZW50cnkoaGFuZGxlLCAmb3JpZ19kZW50cnks
IGlub2RlKTsKKworCQlpZiAocm9sbGJhY2tfZXJyKQorCQkJRVhUNF9FUlJPUl9JTk9ERShkaXIs
CisJCQkJIkZhaWxlZCB0byBzZXQgTFVGSUQgb24gJyUuKnMnIChlcnI9JWQpIGFuZCBmYWlsZWQg
dG8gcmVzdG9yZSB0aGUgb3JpZ2luYWwgZGlyZWN0b3J5IGVudHJ5IChlcnI9JWQpOyBpbm9kZSAl
bGx1IG1heSBiZSBvcnBoYW5lZCIsCisJCQkJbmFtZWxlbiwgZmlsZW5hbWUsIGVyciwgcm9sbGJh
Y2tfZXJyLAorCQkJCWlub2RlLT5pX2lubyk7CisJCWdvdG8gb3V0X3VubG9jazsKKwl9CisKIAkv
KiBVcGRhdGUgaW5vZGUgdGltZXMgKi8KIAlpbm9kZV9zZXRfY3RpbWVfY3VycmVudChkaXIpOwog
CWlub2RlX2luY19pdmVyc2lvbihkaXIpOwotLSAKMi40My43Cgo=
--000000000000518ee606549bdd5d--
