Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F15014B950
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779643178; cv=none; b=kxyryv/7CPYUoqxoDsocvDvHoGKFXRuBimHumyOM/3qiZ3DVGBPTazEchM7QbMc5Qg8ncSGHXqobNtRCtcYtasdDyleJXV1E3u4Sw3m9rqBekhMjvVSjRDCSll2EZm/SOzUS6fVqwfXT3oGsUGuhkRz+CPXpgiswnZv/gO1CbC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779643178; c=relaxed/simple;
	bh=r5RktkXBxaP/KhHQR/3SMBwRnnxO00Ic/tKwKjMdVf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6xj97spMAqWUcjwRV+evf+xUeM8Au3BmMKFhK9EPwBbjabk1mHI4r56ncLqeiixG/ubJIqNkIfkBCQSIWPQgmoUuHR/4UBP04F9st9D3nyW451zBqVDzOJOR0jAdSL2nf2AhVHNxwDPc97FsY2nvRv8jFGXdm3bpxoYk+GdxAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVPNrspu; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVPNrspu"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4462f8d2488so897104f8f.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 10:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779643175; x=1780247975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wKkf++9imcV1slzVc8aNP+SXe0jJIQFjQhnIPL65Rp8=;
        b=eVPNrspuckRQpKi19JbFKYnzuaUHfAPcw/yHnOeVbDgUBFPsaE2znhFvkWwoYZ/AYF
         w1PtdUxA3Gp3/SL9/PGPS0rf+Ta2FBkwOfLPAAjOic7qkTm7LIuKEu0WaETjKG4K9ylE
         gCv+KKh7BSY7lsaxjZg+Pj9ipVP0rgmlQhLAHQdklDYhWQ+ZBI2Sg78aE+lhvhgvQiFa
         Snyve1wuDweHq36oimdZDCG1GY7P/dR/yeHobLA+vD55XpYJ/++vLRqNtCDbWLKKNpFy
         1v4vmMFQg40zkqIcoIG9keO8sWSPbquUuso+/8SQmIrQFR/2L2dgocBgRrbZAfHml9Ic
         V6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779643175; x=1780247975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKkf++9imcV1slzVc8aNP+SXe0jJIQFjQhnIPL65Rp8=;
        b=ZtXzOj2T1U5hB+8H3Fw042smcLTc2aVUJp9sdLhveYHGcVfTH2zdRgKBvFU624AzOc
         I1vJnCFeorCBL2CQpisqeyZJ1uadYgJRv+UT+OH139eXt7SzkzsfC2QYfUyo1cSbPNNm
         Tfpo1k+EuhX9Z33eevFpzBf2T1zAl498oHZnjzYABJe3Qw55KyVUHwIoYZz4B4n7g1ym
         0pVQbax/xXlrQ84lsMXMtTzYS7J7z46mXmzfshfoKLYwqZtDpMCTXwZTYQw5UfsBQYwr
         ZZ8E/ijSRRUAU6ZjpgSEHMe3eLhsPHqDnOokRVsiQWVH0uhtdzB4KQ/LuTAe76aZzaLI
         IUpg==
X-Forwarded-Encrypted: i=1; AFNElJ/8sUgPidaWbN/TroEuhp3O2UhgaHJf+2fCdhsctlz67iNethkOE/mknbfk8zwi2Qam096xSnp+mRux@vger.kernel.org
X-Gm-Message-State: AOJu0YzXhMH++daWav/FQxnVt7bgtVfwUoYEXbH9BkC9H7ldPfEiCVrR
	kfz7fFyH4T9nJmQqaFEQfKQpFWVOd/xgTkcQhFyWN0PHDxx2h3QpPGDG
X-Gm-Gg: Acq92OHbBheGuDrtES1o5xP9N2NoECj2s7a7ONTqixwq6iSyLWnDzt2X48g3ru9jii3
	CXDhgEEQSKxWyP3RTXlCr94u+2Hd24OOrQQY6Cao2fpP0XVqs7sby6sSfOF6NCfPTRK+CcugjnI
	jpOxEN5f6OMPWdKzSdDbTWUk3DJtuTrKMrhLbRq/Hn4jtWHOoraVrRkFbqoJGZ5PcHpCA3o4ITC
	Q2EvpmZDfnwdxuhQQozTabjPyOS+Y2oGYpUJSBgJtld6t1d317q+AuwVQYrag014F1aJ2fWxar0
	Ynib9mXjRkZ1sq1T4YEPW2cpiHoxzaw5oAzuDhd21fUdSBUfM6A3t0bA85w6iUgF0U0AAKNBO8s
	IytZlM9hk8989i4vqSA5aCxpoAs2hmau5Q2tPRVlyGVGG6bUrbgGFNb9TRwWaxMO2ba2NssYmec
	u6kwbJYOt6V0U0iKCfrldsq017ytgevgNRu8pxnEVb5t3NdWwCay6n7ifKswJdMBuIgD1/8fIdZ
	mIugmI=
X-Received: by 2002:a05:6000:468c:b0:45e:ced1:19c1 with SMTP id ffacd0b85a97d-45eced11b20mr433909f8f.3.1779643175134;
        Sun, 24 May 2026 10:19:35 -0700 (PDT)
Received: from ast-epyc5.inf.ethz.ch (ast-epyc4.inf.ethz.ch. [129.132.161.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6cd151asm20090169f8f.13.2026.05.24.10.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 10:19:34 -0700 (PDT)
From: Zijing Yin <yzjaurora@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zijing Yin <yzjaurora@gmail.com>
Subject: [BUG] ext4: WARNING in dquot_reclaim_space_nodirty on bigalloc + PUNCH_HOLE
Date: Sun, 24 May 2026 10:19:10 -0700
Message-ID: <20260524171911.1891435-1-yzjaurora@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A standalone C reproducer (attached) reliably trips two related
quota-accounting WARNs on current linux-next when run against an
ext4 bigalloc filesystem mounted with quota.  The trigger workload
combines an O_DIRECT|RWF_DSYNC write at a sub-block-aligned offset,
a delayed-allocation single-byte write to a far-away logical
cluster, and a fallocate(FALLOC_FL_PUNCH_HOLE) that covers the
direct-I/O range but not the delayed cluster.

Reproduced on linux-next tag next-20260522.  The same bug also
reproduces on plain mainline (torvalds/linux.git at commit
4cbfe4502e3d, 2026-05-23) and on the ext4 maintainer tree
(tytso/ext4.git#dev at 981fcc5674e6, 2026-04-09).  The kernel was
built with x86_64 defconfig plus CONFIG_KASAN, CONFIG_LOCKDEP,
CONFIG_PROVE_LOCKING, CONFIG_QUOTA, CONFIG_QUOTA_DEBUG and
CONFIG_DEBUG_INFO (full .config attached).  The attached repro.c
is a standalone C program that fires both WARNs deterministically
about 38 seconds after the bigalloc image is mounted, back-to-back
from the same process.

I was not able to land a fix despite a couple of attempts, so I'd
rather get the bug in front of the right eyes than ship a
misleading symptom mask.

The traces below are the dmesg captured by running attached
repro.c directly inside a QEMU VM booted with the linux-next
kernel above, then symbolised with `scripts/decode_stacktrace.sh
./vmlinux <source-tree>` against the same build.

------------[ cut here ]------------
WARNING: fs/quota/dquot.c:1887 at dquot_reclaim_space_nodirty+0x77c/0x8c0, CPU#0: repro_test/312
Modules linked in:
CPU: 0 UID: 0 PID: 312 Comm: repro_test Not tainted 7.1.0-rc4-next-20260522 #1 PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:dquot_reclaim_space_nodirty (fs/quota/dquot.c:1887 (discriminator 1))
RSP: 0018:ff1100010ed67a10 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ff1100010c7dae00 RCX: ffffffff821076c7
RDX: ff1100010eaca280 RSI: ffffffff82107bfc RDI: 0000000000000006
RBP: ff1100010ed67a70 R08: 00000000000005c0 R09: 0000000000000006
R10: 0000000000010000 R11: 0000000000000000 R12: ff110001105b3f10
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000010000
FS:  00000000069c9380(0000) GS:0000000000000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000140 CR3: 000000010ece7005 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ext4_rereserve_cluster (./include/linux/quotaops.h:361 fs/ext4/extents.c:2467)
 ext4_ext_remove_space (fs/ext4/extents.c:3065)
 ? ext4_es_remove_extent (fs/ext4/extents_status.c:1669)
 ? __ext4_journal_start_sb (fs/ext4/ext4_jbd2.c:44 fs/ext4/ext4_jbd2.c:113)
 ? ext4_punch_hole (fs/ext4/ext4_jbd2.h:242 fs/ext4/inode.c:4486)
 ext4_punch_hole (fs/ext4/inode.c:4508)
 ext4_fallocate (fs/ext4/extents.c:4913)
 vfs_fallocate (fs/open.c:338)
 __x64_sys_fallocate (fs/open.c:362 fs/open.c:367 fs/open.c:365)
 x64_sys_call (./arch/x86/include/generated/asm/syscalls_64.h:286)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>
---[ end trace 0000000000000000 ]---

A second related WARN fires moments later, in the writeback path
off the test program's file close:

------------[ cut here ]------------
WARNING: fs/quota/dquot.c:1846 at dquot_claim_space_nodirty+0x77c/0x8c0, CPU#0: repro_test/312
Modules linked in:
CPU: 0 UID: 0 PID: 312 Comm: repro_test Tainted: G        W           7.1.0-rc4-next-20260522 #1 PREEMPT(lazy)
Tainted: [W]=WARN
RIP: 0010:dquot_claim_space_nodirty (fs/quota/dquot.c:1846 (discriminator 1))
RSP: 0018:ff1100010ed67250 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ff1100010c7dae00 RCX: ffffffff82107f97
RDX: ff1100010eaca280 RSI: ffffffff821084cc RDI: 0000000000000006
RBP: ff1100010ed672b0 R08: 00000000000005c0 R09: 0000000000000004
R10: 0000000000010000 R11: 0000000000000000 R12: ff110001105b3f10
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000010000
FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd79f6e86f8 CR3: 00000000098b6002 CR4: 0000000000771ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ext4_da_update_reserve_space (./include/linux/quotaops.h:355 fs/ext4/inode.c:373)
 ext4_es_insert_extent (fs/ext4/extents_status.c:1003)
 ? ext4_release_file (fs/ext4/file.c:169)
 ? ext4_map_blocks (fs/ext4/inode.c:823)
 ext4_map_create_blocks (fs/ext4/inode.c:671)
 ext4_map_blocks (fs/ext4/inode.c:824)
 ext4_do_writepages (fs/ext4/inode.c:2396 fs/ext4/inode.c:2490 fs/ext4/inode.c:2948)
 ext4_writepages (fs/ext4/inode.c:3042)
 do_writepages (mm/page-writeback.c:2571)
 filemap_writeback (mm/filemap.c:387)
 filemap_flush (mm/filemap.c:436 mm/filemap.c:451)
 ext4_alloc_da_blocks (fs/ext4/inode.c:3353)
 ext4_release_file (fs/ext4/file.c:169)
 __fput (fs/file_table.c:510)
 ____fput (fs/file_table.c:538)
 task_work_run (kernel/task_work.c:233)
 do_exit (./include/linux/task_work.h:40 kernel/exit.c:1004)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>
---[ end trace 0000000000000000 ]---

Happy to test instrumented kernels and candidate patches.

Attachments:
  repro.c     - standalone C reproducer, compiles with -static
  repro.prog  - syzkaller reproducer
  config      - kernel .config used for the build above
You can find them at: 
https://bugzilla.kernel.org/show_bug.cgi?id=221570

Thanks,
Zijing
