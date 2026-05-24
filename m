Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37B7397E8A
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779642700; cv=none; b=ZMNV76IHNu42d/Y++QRUabXVvqjaF+eApZFp4VEh4PT8QvLewu7t+EpPFoAywo35IuhfbnCg0N9OUjK47pNXdKl6tYsa+Dr3tbGUpszSVFl9QAU0USd1RPvEDKfgEBrjMSxNL1QvziF+Z6o9T9JRhDSzTUOjaXEMHVfAw99WQko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779642700; c=relaxed/simple;
	bh=ACe+fFGYWjYoVg+NCOtR9OSNXzNDdcY+5Yj14gN7OCo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u4OgabdsEy7KUnqu3xdJ1+REU+gQLBNEUA0TTR++QvO459PFeVmyvx48GMlpgUDgXflHPVnIixJTwLbJcowNSe7ij20MzJCgt7TEBISXKkgr5a0Ve4uaekrk/dTrJBeVsBOR8UAZ+8VgPPlOsctIQQ8ZtdMy7eZLWz+cUdtZxVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhaHgTy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhaHgTy3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F73AC2BCC7
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779642700;
	bh=ACe+fFGYWjYoVg+NCOtR9OSNXzNDdcY+5Yj14gN7OCo=;
	h=From:To:Subject:Date:From;
	b=rhaHgTy3YzA7JKTq6IYs/mtgh7mEwiAx7XlM7Px1sLe0YKcZQ7ieaXh8X+XF5DKo7
	 0TAS/NI5OobVEoF6O8Zgvhs5EtcFJ7dGe9pIftpq4rezAXAC9z7YFRwCAdY+kdz9yN
	 AQyoeYpOuaMBraRvpFHSuHDV0MS9Hnqe2/aeLGKWTGFbGN/227rilu70t88ZIGmN/U
	 1URF9Pay0OiJQJKKECSETN8mHGLgcpc4YZlL94zuZixWUdKhy2hTuxWlNk1dVH0B5r
	 ZGD6tEKdldOB1jtZlAZuUohMfVAuB89aJ1lCOPqZzZJ2PkUlqKncXwpW9vpkyjJ/WL
	 o9M2VOO9EHfxA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4AD6AC41612; Sun, 24 May 2026 17:11:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 221570] New: [BUG] ext4: WARNING in dquot_reclaim_space_nodirty
 on bigalloc + PUNCH_HOLE
Date: Sun, 24 May 2026 17:11:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yzjaurora@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-221570-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D221570

            Bug ID: 221570
           Summary: [BUG] ext4: WARNING in dquot_reclaim_space_nodirty on
                    bigalloc + PUNCH_HOLE
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: yzjaurora@gmail.com
        Regression: No

Created attachment 310188
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310188&action=3Dedit
Syzkaller reproducer

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
WARNING: fs/quota/dquot.c:1887 at dquot_reclaim_space_nodirty+0x77c/0x8c0,
CPU#0: repro_test/312
Modules linked in:
CPU: 0 UID: 0 PID: 312 Comm: repro_test Not tainted 7.1.0-rc4-next-20260522=
 #1
PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:dquot_reclaim_space_nodirty (fs/quota/dquot.c:1887 (discriminator=
 1))
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
 ext4_rereserve_cluster (./include/linux/quotaops.h:361 fs/ext4/extents.c:2=
467)
 ext4_ext_remove_space (fs/ext4/extents.c:3065)
 ? ext4_es_remove_extent (fs/ext4/extents_status.c:1669)
 ? __ext4_journal_start_sb (fs/ext4/ext4_jbd2.c:44 fs/ext4/ext4_jbd2.c:113)
 ? ext4_punch_hole (fs/ext4/ext4_jbd2.h:242 fs/ext4/inode.c:4486)
 ext4_punch_hole (fs/ext4/inode.c:4508)
 ext4_fallocate (fs/ext4/extents.c:4913)
 vfs_fallocate (fs/open.c:338)
 __x64_sys_fallocate (fs/open.c:362 fs/open.c:367 fs/open.c:365)
 x64_sys_call (./arch/x86/include/generated/asm/syscalls_64.h:286)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:=
94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>
---[ end trace 0000000000000000 ]---

A second related WARN fires moments later, in the writeback path
off the test program's file close:

------------[ cut here ]------------
WARNING: fs/quota/dquot.c:1846 at dquot_claim_space_nodirty+0x77c/0x8c0, CP=
U#0:
repro_test/312
Modules linked in:
CPU: 0 UID: 0 PID: 312 Comm: repro_test Tainted: G        W=20=20=20=20=20=
=20=20=20=20=20
7.1.0-rc4-next-20260522 #1 PREEMPT(lazy)
Tainted: [W]=3DWARN
RIP: 0010:dquot_claim_space_nodirty (fs/quota/dquot.c:1846 (discriminator 1=
))
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
 ext4_da_update_reserve_space (./include/linux/quotaops.h:355
fs/ext4/inode.c:373)
 ext4_es_insert_extent (fs/ext4/extents_status.c:1003)
 ? ext4_release_file (fs/ext4/file.c:169)
 ? ext4_map_blocks (fs/ext4/inode.c:823)
 ext4_map_create_blocks (fs/ext4/inode.c:671)
 ext4_map_blocks (fs/ext4/inode.c:824)
 ext4_do_writepages (fs/ext4/inode.c:2396 fs/ext4/inode.c:2490
fs/ext4/inode.c:2948)
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

Reported-by: Zijing Yin <yzjaurora@gmail.com>

Thanks,
Zijing

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
