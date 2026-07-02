Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4936A342
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 06:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782972393; cv=none; b=VIv/Cyo+P50RiLs78nNXcxwVASPU61kIdOZDpiP4xI754MiNGp2g6lzf6W9sYBhJmTLHvBVfwqSw4jk7wKI1xccc7YOiRH0eI01rpn0dGM8fdoP6wQxSqg8glgKD0ykIklqZnzQqPOiL7U4LapAhcmkPs9AbFYwkliyTQGh3Sbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782972393; c=relaxed/simple;
	bh=iCqOFTz5ZCAjq/lGo14xcKhmtm3K/D35x1y2b0W3HvY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aWX3kvW7npf5sEiLMrbB57emlhakV2uuKeag2nVEAPj2GsvbRnyrfXzCztuOgf+Wt+bDjQoV4K0T8eyZ45gXtY7ndPLJLe3xwWwMkuo3OaU+C6g0tclPMqlKL164zz2AkPhIsSZRKDyKUSmFTFey6JI76TCguAGe2XO5iuusrRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-48576b535b6so864113b6e.2
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 23:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782972390; x=1783577190;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DVu5Ga6Kdd2HO30hYGlYDBQDjTohNHgiIRhYVsUG/uI=;
        b=NbBc7AgQ2m7RifGPg0pau5UTYPqh8U8+A+7OWSDhZWOBNCq+L4mgw9XufqLPqYl2Ft
         xvrr30gu5tYJs6m/ajY3ShvCfb39UOCtIYcP/ntmwlEPtAex9eMFYZ+JNJRufDDpFpbF
         M2Kb0QMioaFG24GcM2N1KUd6lESSbQmnNt/+UV+p8QsD71LkxTuzS3sYaNgDlUWSieQo
         FHAdPGINctfTn5ikexmnjmty3Ot9RdbsIjSJQxaBkbxuYWAVUuSAgeMJCz3Nv1+nqxzt
         GudikOS4eLKqSiI8f15OzRQgsWlfWnFRiWON4sjTDUeYa+ReN9t5wMFQn4kcDiA1dyYT
         oqNA==
X-Forwarded-Encrypted: i=1; AFNElJ/rGS9tdhMCdn1b5WKUq6A/cIjPyO4oW4ZjYNFtJC7AlY6g5pFPw0iRqOMFbNNhf1i/RqIbifmo5cxM@vger.kernel.org
X-Gm-Message-State: AOJu0YxmRXUfhJUSnq+TkSmGQla2Ua1WH+qZy6qxYTVEyr1pZH6aIfK1
	DYFqRxJ0rELG5AxZnlj/zM+49BpzXCKem2Jbi6UzZnsCG4kOJvCdTHtjzDiDkVndxqIXNOjtcfy
	NsB1BQ9coDzEa3R5kU/502rSKGtMQOuClJBkFMom60gZA0/7l8D/uD6hdn4k=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e8c4:10b0:496:14ff:78b9 with SMTP id
 5614622812f47-49614ff81d5mr1815512b6e.10.1782972390328; Wed, 01 Jul 2026
 23:06:30 -0700 (PDT)
Date: Wed, 01 Jul 2026 23:06:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a45ffe6.34acba0d.1e07b.0001.GAE@google.com>
Subject: [syzbot] [ext4?] INFO: task hung in ext4_load_tail_bh
From: syzbot <syzbot+479d1ce6391270ec5dc6@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ff4c5a0de1f2 arm64/mm: Optimize TLB flush in unmap_hotplug..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=148c611e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ecdef466b08b9772
dashboard link: https://syzkaller.appspot.com/bug?extid=479d1ce6391270ec5dc6
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12eb1e89580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12adbe89580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ea05371791a/disk-ff4c5a0d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/968513dc8b51/vmlinux-ff4c5a0d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a1a240044ae4/Image-ff4c5a0d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7d8146d523b0/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13bac289580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+479d1ce6391270ec5dc6@syzkaller.appspotmail.com

INFO: task syz.5.7528:29358 blocked in I/O wait for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.5.7528      state:D stack:0     pid:29358 tgid:29355 ppid:27464  task_flags:0x400140 flags:0x00000011
Call trace:
 __switch_to+0x2b0/0x6e0 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7326
 io_schedule+0x1c/0xe0 kernel/sched/core.c:8154
 folio_wait_bit_common+0x6b8/0xa30 mm/filemap.c:1323
 __folio_lock mm/filemap.c:1704 [inline]
 folio_lock include/linux/pagemap.h:1157 [inline]
 __filemap_get_folio_mpol+0x1f4/0x1054 mm/filemap.c:1960
 __filemap_get_folio include/linux/pagemap.h:761 [inline]
 ext4_load_tail_bh+0x94/0x704 fs/ext4/inode.c:4040
 ext4_block_do_zero_range fs/ext4/inode.c:4111 [inline]
 ext4_block_zero_range+0xd8/0x7b0 fs/ext4/inode.c:4199
 ext4_block_zero_eof+0x22c/0x4b8 fs/ext4/inode.c:4229
 ext4_truncate+0x500/0x10d4 fs/ext4/inode.c:4632
 ext4_truncate_failed_write fs/ext4/truncate.h:22 [inline]
 ext4_write_end+0x598/0x9e0 fs/ext4/inode.c:1495
 generic_perform_write+0x504/0x7a4 mm/filemap.c:4379
 ext4_buffered_write_iter+0xd0/0x2ec fs/ext4/file.c:316
 ext4_file_write_iter+0x1dc/0x134c fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
INFO: task syz.5.7528:29366 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.5.7528      state:D stack:0     pid:29366 tgid:29355 ppid:27464  task_flags:0x440040 flags:0x00000011
Call trace:
 __switch_to+0x2b0/0x6e0 arch/arm64/kernel/process.c:775 (T)
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x1370/0x2d80 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x13c/0x20c kernel/sched/core.c:7326
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x530/0x7b0 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0xa0/0x2bc kernel/locking/rwsem.c:1576
 filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 page_cache_ra_order+0x334/0xe20 mm/readahead.c:517
 page_cache_sync_ra+0x66c/0xaf0 mm/readahead.c:649
 page_cache_sync_readahead include/linux/pagemap.h:1395 [inline]
 collapse_file mm/khugepaged.c:2335 [inline]
 collapse_scan_file+0x16fc/0x4834 mm/khugepaged.c:2773
 collapse_single_pmd+0x3c0/0x3b78 mm/khugepaged.c:2808
 madvise_collapse+0x2a4/0x728 mm/khugepaged.c:3234
 madvise_vma_behavior+0x408/0x3390 mm/madvise.c:1364
 madvise_walk_vmas+0x4c8/0x9bc mm/madvise.c:1713
 madvise_do_behavior+0x5f0/0x7c0 mm/madvise.c:1908
 do_madvise+0x28c/0x2f0 mm/madvise.c:2006
 __do_sys_madvise mm/madvise.c:2015 [inline]
 __se_sys_madvise mm/madvise.c:2013 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:2013
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

Showing all locks held in the system:
2 locks held by kworker/u8:0/12:
1 lock held by khungtaskd/31:
 #0: ffff800088cb6f20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffff800088cb6f20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffff800088cb6f20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x4c/0x188 kernel/locking/lockdep.c:6775
1 lock held by pr/ttyAMA-1/41:
2 locks held by getty/4492:
 #0: ffff0000d159a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009248b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x348/0xf78 drivers/tty/n_tty.c:2211
3 locks held by udevd/4753:
2 locks held by kworker/0:4/4834:
3 locks held by udevd/5195:
1 lock held by udevd/5459:
2 locks held by udevd/25825:
4 locks held by syz.5.7528/29358:
 #0: ffff0000cd7f3b30 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x100/0x144 fs/file.c:1259
 #1: ffff0000d54a2450 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff0000d54a2450 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:683
 #2: ffff0000dfbf9fa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff0000dfbf9fa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: ext4_buffered_write_iter+0xa0/0x2ec fs/ext4/file.c:311
 #3: ffff0000dfbfa138 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff0000dfbfa138 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff0000dfbfa138 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x574/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.5.7528/29366:
 #0: ffff0000dfbfa138 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff0000dfbfa138 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x334/0xe20 mm/readahead.c:517
4 locks held by syz.3.8462/32291:
 #0: ffff0000d18440f0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x100/0x144 fs/file.c:1259
 #1: ffff0000ed44a450 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff0000ed44a450 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:683
 #2: ffff0000efc86aa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff0000efc86aa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: ext4_buffered_write_iter+0xa0/0x2ec fs/ext4/file.c:311
 #3: ffff0000efc86c38 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff0000efc86c38 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff0000efc86c38 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x574/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.3.8462/32302:
 #0: ffff0000efc86c38 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff0000efc86c38 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x334/0xe20 mm/readahead.c:517
4 locks held by syz.7.12097/10967:
 #0: ffff0000c98c2630 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x100/0x144 fs/file.c:1259
 #1: ffff0000d4d4c450 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff0000d4d4c450 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x248/0xa0c fs/read_write.c:683
 #2: ffff0000dfba1fa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff0000dfba1fa0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: ext4_buffered_write_iter+0xa0/0x2ec fs/ext4/file.c:311
 #3: ffff0000dfba2138 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff0000dfba2138 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff0000dfba2138 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x574/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.7.12097/10978:
 #0: ffff0000dfba2138 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff0000dfba2138 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x334/0xe20 mm/readahead.c:517
1 lock held by syz-executor/12531:
1 lock held by syz.2.13521/15260:
1 lock held by syz.1.13518/15265:

=============================================



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
