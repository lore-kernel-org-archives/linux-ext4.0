Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F4723B612
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774551488; cv=none; b=XBAPjnOztNcVwDf5SZXPKPmFVL/BHvLWF8dYlbJ34zVNoYomKZZ0IXpJFyndg43A5RgXDGSnmmcUc/yD0Y5Ne1Y6jIHtiyDJ+a97cnhPuABx/APRmfr481JHFOlHYDIpqjuLtvZBvGi4HjxJRsHSR9Np3KUGhLKynaaGVIdYAbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774551488; c=relaxed/simple;
	bh=Xuvy4e7oabiio6qkkAj6MwbdHHVVBuMdywAYB4O+Ctc=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=OhnwiSxmf84ZXpxMuZ0yVb5DgwXm6gmpDYcI3XCRSLLbYZi+VB00vVaIyoR+LRqfQyDz0PhVHj3XLTSgOx2Oeej9g73QQarZn4mBwtmDpDJvMHn3z7MICW1oJbqhPN2zP22NUlH9DZoEHWSBEsGlk8+49vLfBeZAjuqnw+N4sH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1PI9dvt; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1PI9dvt"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cfc795ca97so134173585a.0
        for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774551485; x=1775156285; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCTEYQhXAVMWtmCIBjjmro5U+/tZw81wQMaWcn1THjg=;
        b=T1PI9dvtXeJWzB3ZHmHlbTXjmij8S3ify1HC8z829yCLEF6st0ozbKxUfr04HTUAVh
         vb8c2eQrkBHTlD8lrGP0lFmSoxyLKcBokMabwQBczWMzwWNfsHQdMy1vkrPQR5tHv7J9
         740FtG8E8Qd9JoLa8b4LfNM4qS0r1g9KtVinIVmoacWxg8mCfh9XVD1rCN/7G7IVSEAo
         aD6n+4PEM3lUGZVvEqBneX1YyCe08QuwPCSwuTc+UVkAMFQRwb1GGBZVBXYLoWE113as
         WpJ/UNgDUd+h2v4Agxn9ygJv0Qy30Lh5uG/8J1hKKDmk+cMB76bSCpDMafAtl2QCXObP
         XYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774551485; x=1775156285;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VCTEYQhXAVMWtmCIBjjmro5U+/tZw81wQMaWcn1THjg=;
        b=G7r/MGCqvqs00PzudH/rihHwIlD1JuzJVH+abl1qKxvhI/Bibk6yZtEx53Z9qRekFr
         2PO2zEHmTB8dxjq/P7GimyQRgxETapS93N9HwXba7CILz7rC/YDmjBGNG7edRQ6b2SD4
         6EFtF1eeXooKoLKcDPmp+2hXXzie+yTzbelcAHEFdJ+Bhj3HRjAa/tXpeWnY+kz+YxlW
         lFnT7w422XysKxpAA3miB/gX4RZ6oBzKdpMfALJ+mRFCnmo/0I+3n4wND4wbM36zKl1e
         l7I/YhUNrf2V/onZ2Di0kmUBgjMecjtRK+8AOaFAN/yeRdjfH4K9fNUHm3TAxrvJtQPy
         68Vw==
X-Gm-Message-State: AOJu0YxkL9CGy8vWxYGq3sycvXNJgp0/flBSgXr7KV2ymCutDDAEbB3r
	RuId5kNATTZl4un/88LMSc6/q3ojWRb16wdjBY3vDYz2maOmOpSEd6nqak+4DEumoHI=
X-Gm-Gg: ATEYQzyvEBdHp02eZ3g39U1jVoNwdBiyk8W9vkYMwpg3E42lN4siwkD2G/4+MQ9Pp2b
	ObxAguteGgKh0rHwbGSLCPdVEjEGaRwCM90CbnLfyVgS4nMm364oftw6J/se4z/qUoakterPR/0
	hwKPtb7mgn9dLavOdYQlW5TNhJqOYnAp2kE0e5MTraUCkPynTVItFjUikqhHaj2dJpzdOR4zoeq
	TX2lxhxCcW2LE7g3tCalEadPMB/tHVCxtYX7CWwKhqaPb4WLLvlmEaAjkLOgGZrSBmhqPVhtYSv
	+O8n7DP3T3TO4ZNGklwjR1fwq9YSgf2osbxu6pgfLNouDWXkbJwEc5kPhlivc1Lc4T/s0eFKZ7p
	/WmRm1x7h9zoyJhiFOj4yJ7l5a6JzakI8LiPyFgud5OprbDZQ3n9K7bb4b0htgDhm1LrrSPXM4U
	1r0ObmyOUpYlkwhTEee6s1q8Lo18yL5BNjpJmt+b30GlUoHXYuCUL4Mz0iUg9u3/ab
X-Received: by 2002:a05:620a:390f:b0:8cf:d80c:5ac2 with SMTP id af79cd13be357-8d000f55f9emr1176782785a.28.1774551484221;
        Thu, 26 Mar 2026 11:58:04 -0700 (PDT)
Received: from smtpclient.apple ([104.39.146.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e4cf106sm318052185a.22.2026.03.26.11.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2026 11:58:03 -0700 (PDT)
From: Shuangpeng <shuangpeng.kernel@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: KASAN: slab-use-after-free Write in jbd2_journal_commit_transaction
Message-Id: <DEF763BA-150C-4512-997F-CF079BDA9259@gmail.com>
Date: Thu, 26 Mar 2026 14:57:53 -0400
Cc: jack@suse.com,
 tytso@mit.edu
To: linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3864.400.21)

Hi Kernel Maintainers,

I hit the following KASAN report while testing current upstream kernel:

KASAN: slab-use-after-free in jbd2_journal_commit_transaction

on commit: bbeb83d3182abe0d245318e274e8531e5dd7a948 (Mar 24 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/032c84edf2505f7f74fb5757e1e6cd1d

The same reproducer sometimes also triggers a KASAN slab-out-of-bounds=20=

report at the same site, which may indicate the same underlying bug.

I=E2=80=99m happy to test debug patches or provide additional =
information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   80.268862][ T8554] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   80.269678][ T8554] BUG: KASAN: slab-use-after-free in =
jbd2_journal_commit_transaction (./include/linux/instrumented.h:97 =
./include/asm-generic/bitops/instrumented-atomic.h:42 =
./include/linux/jbd2.h:320 fs/jbd2/commit.c:828)
[   80.270623][ T8554] Write of size 8 at addr ffff8881687ee5e8 by task =
jbd2/loop0-4107/8554
[   80.271460][ T8554]
[   80.271710][ T8554] CPU: 1 UID: 0 PID: 8554 Comm: jbd2/loop0-4107 Not =
tainted 7.0.0-rc5-00051-gbbeb83d3182a #35 PR
[   80.271719][ T8554] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
[   80.271726][ T8554] Call Trace:
[   80.271729][ T8554]  <TASK>
[   80.271732][ T8554]  dump_stack_lvl (lib/dump_stack.c:122)
[   80.271743][ T8554]  print_report (mm/kasan/report.c:379 =
mm/kasan/report.c:482)
[   80.271795][ T8554]  kasan_report (mm/kasan/report.c:597)
[   80.271813][ T8554]  kasan_check_range (mm/kasan/generic.c:? =
mm/kasan/generic.c:200)
[   80.271821][ T8554]  jbd2_journal_commit_transaction =
(./include/linux/instrumented.h:97 =
./include/asm-generic/bitops/instrumented-atomic.h:42 =
./include/linux/jbd2.h:320 fs/jbd2/commit.c:828)
[   80.271912][ T8554]  kjournald2 (fs/jbd2/journal.c:202)
[   80.271974][ T8554]  kthread (kernel/kthread.c:437)
[   80.271986][ T8554]  ret_from_fork (arch/x86/kernel/process.c:164)
[   80.272022][ T8554]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   80.272034][ T8554]  </TASK>
[   80.272036][ T8554]
[   80.292650][ T8554] Freed by task 8373 on cpu 1 at 42.645081s:
[   80.293268][ T8554]  kasan_save_track (mm/kasan/common.c:58 =
mm/kasan/common.c:78)
[   80.293766][ T8554]  kasan_save_free_info (mm/kasan/generic.c:587)
[   80.294292][ T8554]  __kasan_slab_free (mm/kasan/common.c:287)
[   80.294796][ T8554]  kfree (mm/slub.c:6165 mm/slub.c:6483)
[   80.295206][ T8554]  tomoyo_realpath_from_path =
(security/tomoyo/realpath.c:287)
[   80.295789][ T8554]  tomoyo_realpath_nofollow =
(security/tomoyo/realpath.c:304)
[   80.296344][ T8554]  tomoyo_find_next_domain =
(security/tomoyo/domain.c:731)
[   80.296910][ T8554]  tomoyo_bprm_check_security =
(security/tomoyo/tomoyo.c:102)
[   80.297486][ T8554]  security_bprm_check (security/security.c:795)
[   80.298020][ T8554]  bprm_execve (fs/exec.c:1655 fs/exec.c:1696 =
fs/exec.c:1748)
[   80.298486][ T8554]  do_execveat_common (fs/exec.c:1846)
[   80.299019][ T8554]  __x64_sys_execve (fs/exec.c:1930 fs/exec.c:1924 =
fs/exec.c:1924)
[   80.299510][ T8554]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   80.299984][ T8554]  entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:130)
[   80.300597][ T8554]
[   80.300847][ T8554] The buggy address belongs to the object at =
ffff8881687ee000
[   80.300847][ T8554]  which belongs to the cache kmalloc-4k of size =
4096
[   80.302261][ T8554] The buggy address is located 1512 bytes inside of
[   80.302261][ T8554]  freed 4096-byte region [ffff8881687ee000, =
ffff8881687ef000)
[   80.303678][ T8554]
[   80.303930][ T8554] The buggy address belongs to the physical page:
[   80.304590][ T8554] page: refcount:0 mapcount:0 =
mapping:0000000000000000 index:0x0 pfn:0x1687e8
[   80.305499][ T8554] head: order:3 mapcount:0 entire_mapcount:0 =
nr_pages_mapped:0 pincount:0
[   80.306363][ T8554] flags: =
0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
[   80.307153][ T8554] page_type: f5(slab)
[   80.307663][ T8554] raw: 017ff00000000040 ffff888100042140 =
dead000000000100 dead000000000122
[   80.308538][ T8554] raw: 0000000000000000 0000000800040004 =
00000000f5000000 0000000000000000
[   80.309414][ T8554] head: 017ff00000000040 ffff888100042140 =
dead000000000100 dead000000000122
[   80.310296][ T8554] head: 0000000000000000 0000000800040004 =
00000000f5000000 0000000000000000
[   80.311186][ T8554] head: 017ff00000000003 ffffea0005a1fa01 =
00000000ffffffff 00000000ffffffff
[   80.312076][ T8554] head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000008
[   80.312957][ T8554] page dumped because: kasan: bad access detected
[   80.313612][ T8554] page_owner tracks the page as allocated
[   80.314196][ T8554] page last allocated via order 3, migratetype =
Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN6
[   80.316275][ T8554]  post_alloc_hook (./include/linux/page_owner.h:? =
mm/page_alloc.c:1889)
[   80.316774][ T8554]  get_page_from_freelist (mm/page_alloc.c:? =
mm/page_alloc.c:3962)
[   80.317348][ T8554]  __alloc_frozen_pages_noprof =
(mm/page_alloc.c:5250)
[   80.317952][ T8554]  allocate_slab (mm/slub.c:3294 mm/slub.c:3481)
[   80.318430][ T8554]  refill_objects (mm/slub.c:7176)
[   80.318935][ T8554]  __pcs_replace_empty_main (mm/slub.c:? =
mm/slub.c:4615)
[   80.319510][ T8554]  __kmalloc_noprof (mm/slub.c:4718 mm/slub.c:4851 =
mm/slub.c:5259 mm/slub.c:5272)
[   80.320017][ T8554]  tomoyo_realpath_from_path =
(security/tomoyo/realpath.c:252)
[   80.320591][ T8554]  tomoyo_path_perm (security/tomoyo/file.c:151 =
security/tomoyo/file.c:827)
[   80.321100][ T8554]  security_inode_getattr =
(security/security.c:1870)
[   80.321648][ T8554]  __se_sys_newfstat (fs/stat.c:260 fs/stat.c:281 =
fs/stat.c:551 fs/stat.c:546)
[   80.322157][ T8554]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[   80.322632][ T8554]  entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:130)
[   80.323246][ T8554] page last free pid 1 tgid 1 stack trace:
[   80.323852][ T8554]  __free_frozen_pages =
(./include/linux/page_owner.h:? mm/page_alloc.c:1433 =
mm/page_alloc.c:2978)
[   80.324384][ T8554]  free_contig_range (mm/page_alloc.c:7373)
[   80.324886][ T8554]  destroy_args (mm/debug_vm_pgtable.c:995)
[   80.325363][ T8554]  debug_vm_pgtable (mm/debug_vm_pgtable.c:?)
[   80.325870][ T8554]  do_one_initcall (init/main.c:?)
[   80.326370][ T8554]  do_initcall_level (init/main.c:1443)
[   80.326890][ T8554]  do_initcalls (init/main.c:1457)
[   80.327346][ T8554]  kernel_init_freeable (init/main.c:1696)
[   80.327888][ T8554]  kernel_init (init/main.c:1584)
[   80.328342][ T8554]  ret_from_fork (arch/x86/kernel/process.c:164)
[   80.328827][ T8554]  ret_from_fork_asm =
(arch/x86/entry/entry_64.S:255)
[   80.329327][ T8554]
[   80.329577][ T8554] Memory state around the buggy address:
[   80.330154][ T8554]  ffff8881687ee480: fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb fb
[   80.330981][ T8554]  ffff8881687ee500: fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb fb
[   80.331803][ T8554] >ffff8881687ee580: fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb fb
[   80.332625][ T8554]                                                   =
        ^
[   80.333389][ T8554]  ffff8881687ee600: fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb fb
[   80.334209][ T8554]  ffff8881687ee680: fb fb fb fb fb fb fb fb fb fb =
fb fb fb fb fb fb
[   80.335033][ T8554] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Best,
Shuangpeng

