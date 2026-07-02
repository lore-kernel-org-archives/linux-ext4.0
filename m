Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923C34389D
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 06:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782972394; cv=none; b=eUSZoL1hmU3hq0lR+CaemmnLc9/gdPuODYT0aFOY7241Jo7BLj6gs8P+P2nInMguBrC2AwF93sIBEUWSaV5b6Q6/D/vCD+G1uEnb4tq8X7/RYNZhP6IWmTRnBB6MRt854B9wyF40gx/Oc3IxE9do6qjiRzyom+UWbH9S4L8jOpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782972394; c=relaxed/simple;
	bh=UOj+uJDMveZemDciFQzAaYWcN1Kwyf2tBlVhhLtYSGg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qBk7KDRP453vGKBVOIrfHumrqHpcqb/JL5hATMZd0bd/ZfX2oCgrymxd7N681rDProhip9N/MZSIP6aL2sYSJciJnclIGcA+KHn5SIJ8WgkeZbTC040YWVNznzmLiHh7RysdHElgxgKhn8CbRcuhRLR574wX+Rhlj0i7DmShNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e9e54e9cf5so2317774a34.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 23:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782972390; x=1783577190;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zZRX3RhowiF6tkrFkNIA+KXP9dWPF7cJriwRu4Fe7eY=;
        b=W50WbOxIzL4TSdazH/B/kUAr8kj4N9XPZEyT5dYQXfr8xUbg/9afqy3wlHxTdDMf7K
         e4SQTyl9J9X+6W+lscRO5OXsp4Y/ciZk/LXz4/zJWmKbuQ/8WI6B4Gjs3glHFRxkcYww
         xJH9At7nHqezzpPk2NbuEN+kjakXh57fdAO+r3M1WjZ8YOlkvoUUlUTJeK7tFq3Qv+4D
         heIO4+qymfVgy7wR1h7xIkZoQQ1H5TgmX0g1bZPo9yEQWE+3u2LJuvV8LSqwj8FmeeJQ
         EGEbRMwYGtcVvMwV4/+HpRdgY/ywZ19VtdFY/fgtUc/iVww4DshBHunwIYhHp+hWqBpZ
         I9yA==
X-Forwarded-Encrypted: i=1; AFNElJ9dNshYgdIipTFDF9xb/OxkrlHLPRLSxc4Ghq6cN5Pb85YObpccW/kbfY0ttaJ5zQ0MMtos7/vGnm/X@vger.kernel.org
X-Gm-Message-State: AOJu0YwT5BlRWQoYYOFfztHIQZRt3htZISWJu8KAT5xIKFJZ5GF+v0Yo
	Aoko18QOfp43J45laOkVwqTOf9sPnUAsa4ctRXzBDgoaqBnHHPn9/OrpPAfVKYpjr8AIk/wkuKR
	Cvy/ROKbdbG9+COPGDoTqYy7o52t2D7vivfoWMOOy9w+Y5wNWkNN0P81GBTI=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:623:b0:6a1:7baa:31e3 with SMTP id
 006d021491bc7-6a309a897femr2912843eaf.47.1782972390607; Wed, 01 Jul 2026
 23:06:30 -0700 (PDT)
Date: Wed, 01 Jul 2026 23:06:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a45ffe6.34acba0d.1e07b.0002.GAE@google.com>
Subject: [syzbot] [ext4?] INFO: task hung in ext4_write_end
From: syzbot <syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller-bugs@googlegroups.com, 
	tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    665159e24674 Merge tag 'probes-fixes-v7.2-rc1' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a54ae0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86ba763b42fa66a
dashboard link: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11804946580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a05a33a56982/disk-665159e2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/155ad8e180de/vmlinux-665159e2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/40c3a5216293/bzImage-665159e2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/62f6b0a820df/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=126fce51580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com

INFO: task syz.0.297:7222 blocked in I/O wait for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.297       state:D stack:24616 pid:7222  tgid:7218  ppid:5781   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 io_schedule+0x7f/0xd0 kernel/sched/core.c:8154
 folio_wait_bit_common+0x836/0xbc0 mm/filemap.c:1323
 folio_lock include/linux/pagemap.h:1157 [inline]
 truncate_inode_pages_range+0xa41/0xd80 mm/truncate.c:458
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_write_end+0x734/0x9e0 fs/ext4/inode.c:1495
 generic_perform_write+0x612/0x8f0 mm/filemap.c:4379
 ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
 ext4_file_write_iter+0x947/0x1c70 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f395cf9de59
RSP: 002b:00007f395dde8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f395d225fa0 RCX: 00007f395cf9de59
RDX: 000000000000fea7 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007f395d033e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f395d226038 R14: 00007f395d225fa0 R15: 00007ffff725c4c8
 </TASK>
INFO: task syz.0.297:7244 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.297       state:D stack:23760 pid:7244  tgid:7218  ppid:5781   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x6ba/0x920 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
 page_cache_sync_readahead include/linux/pagemap.h:1395 [inline]
 collapse_file mm/khugepaged.c:2335 [inline]
 collapse_scan_file+0x1ab9/0x5210 mm/khugepaged.c:2773
 collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2808
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3234
 madvise_vma_behavior+0x11ac/0x42e0 mm/madvise.c:1364
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1713
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1908
 do_madvise+0x327/0x3a0 mm/madvise.c:2006
 __do_sys_madvise mm/madvise.c:2015 [inline]
 __se_sys_madvise mm/madvise.c:2013 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2013
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f395cf9de59
RSP: 002b:00007f395ddc7028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f395d226090 RCX: 00007f395cf9de59
RDX: 0000000000000019 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007f395d033e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f395d226128 R14: 00007f395d226090 R15: 00007ffff725c4c8
 </TASK>
INFO: task syz.4.326:7346 blocked in I/O wait for more than 146 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.326       state:D stack:24616 pid:7346  tgid:7345  ppid:5806   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 io_schedule+0x7f/0xd0 kernel/sched/core.c:8154
 folio_wait_bit_common+0x836/0xbc0 mm/filemap.c:1323
 folio_lock include/linux/pagemap.h:1157 [inline]
 truncate_inode_pages_range+0xa41/0xd80 mm/truncate.c:458
 ext4_truncate_failed_write fs/ext4/truncate.h:21 [inline]
 ext4_write_end+0x734/0x9e0 fs/ext4/inode.c:1495
 generic_perform_write+0x612/0x8f0 mm/filemap.c:4379
 ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
 ext4_file_write_iter+0x947/0x1c70 fs/ext4/file.c:-1
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe9399de59
RSP: 002b:00007efe94897028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007efe93c25fa0 RCX: 00007efe9399de59
RDX: 000000000000fea7 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007efe93a33e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efe93c26038 R14: 00007efe93c25fa0 R15: 00007fff4570fa28
 </TASK>
INFO: task syz.4.326:7360 blocked for more than 147 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.326       state:D stack:23696 pid:7360  tgid:7345  ppid:5806   task_flags:0x440040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 rwsem_down_read_slowpath+0x6ba/0x920 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x9c/0x330 kernel/locking/rwsem.c:1576
 filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
 page_cache_sync_readahead include/linux/pagemap.h:1395 [inline]
 collapse_file mm/khugepaged.c:2335 [inline]
 collapse_scan_file+0x1ab9/0x5210 mm/khugepaged.c:2773
 collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2808
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3234
 madvise_vma_behavior+0x11ac/0x42e0 mm/madvise.c:1364
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1713
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1908
 do_madvise+0x327/0x3a0 mm/madvise.c:2006
 __do_sys_madvise mm/madvise.c:2015 [inline]
 __se_sys_madvise mm/madvise.c:2013 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2013
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe9399de59
RSP: 002b:00007efe94876028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007efe93c26090 RCX: 00007efe9399de59
RDX: 0000000000000019 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007efe93a33e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efe93c26128 R14: 00007efe93c26090 R15: 00007fff4570fa28
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/32:
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
3 locks held by kworker/u8:2/37:
4 locks held by kworker/u8:8/1341:
 #0: ffff88801ae8c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801ae8c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc90006187c40 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc90006187c40 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8fdecec0 (
rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:313
 #3: ffffffff8e95ff28 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
 #3: ffffffff8e95ff28 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2d0/0x770 kernel/rcu/tree_exp.h:961
1 lock held by udevd/4987:
2 locks held by getty/5372:
 #0: ffff888035a570a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
1 lock held by udevd/5670:
4 locks held by syz.0.297/7222:
 #0: ffff88807063f430 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888020ecc450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888020ecc450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88806e84d7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88806e84d7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff88806e84d978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff88806e84d978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff88806e84d978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.0.297/7244:
 #0: ffff88806e84d978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff88806e84d978 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.4.326/7346:
 #0: ffff888021b287f0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888020782450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888020782450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88806ea39640 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88806ea39640 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff88806ea397d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff88806ea397d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff88806ea397d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.4.326/7360:
 #0: ffff88806ea397d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff88806ea397d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.7.867/9690:
 #0: ffff88807e5e97b0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888058692450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888058692450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88805586e140 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88805586e140 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff88805586e2d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff88805586e2d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff88805586e2d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.7.867/9704:
 #0: ffff88805586e2d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff88805586e2d8 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.3.1163/10927:
 #0: ffff88807ec65270 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888059256450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888059256450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff888055a1c520 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff888055a1c520 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff888055a1c6b8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff888055a1c6b8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff888055a1c6b8 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.3.1163/10946:
 #0: ffff888055a1c6b8 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff888055a1c6b8 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.5.1177/10998:
 #0: ffff88807748fcf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888056ee6450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888056ee6450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff888076ccd7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff888076ccd7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff888076ccd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff888076ccd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff888076ccd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.5.1177/11014:
 #0: ffff888076ccd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff888076ccd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.8.1536/12449:
 #0: ffff8880339f1cf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff88807b69a450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff88807b69a450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff888076c8ce80 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff888076c8ce80 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff888076c8d018 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff888076c8d018 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff888076c8d018 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.8.1536/12465:
 #0: ffff888076c8d018 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff888076c8d018 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
4 locks held by syz.6.1557/12517:
 #0: ffff88807b6eeb70 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888057e82450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2728 [inline]
 #1: ffff888057e82450 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88806eabd7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff88806eabd7e0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at: ext4_buffered_write_iter+0x9c/0x370 fs/ext4/file.c:311
 #3: ffff88806eabd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock include/linux/fs.h:1079 [inline]
 #3: ffff88806eabd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_truncate_failed_write fs/ext4/truncate.h:20 [inline]
 #3: ffff88806eabd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: ext4_write_end+0x713/0x9e0 fs/ext4/inode.c:1495
1 lock held by syz.6.1557/12533:
 #0: ffff88806eabd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #0: ffff88806eabd978 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0x3eb/0xee0 mm/readahead.c:517
1 lock held by syz-executor/13000:
 #0: ffffffff8fdecec0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8fdecec0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #0: ffffffff8fdecec0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8a3/0x1bd0 net/core/rtnetlink.c:4158
2 locks held by syz-executor/13036:
 #0: ffffffff8fdde328 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8fdecec0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock_killable include/linux/rtnetlink.h:145 [inline]
 #1: ffffffff8fdecec0 (rtnl_mutex){+.+.}-{4:4}, at: register_netdev+0x18/0x60 net/core/dev.c:11553
2 locks held by dhcpcd/13097:
 #0: ffff888058895880 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #0: ffff888058895880 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release net/socket.c:709 [inline]
 #0: ffff888058895880 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: sock_close+0x82/0x220 net/socket.c:1501
 #1: ffffffff8e95ff28 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #1: ffffffff8e95ff28 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x38d/0x770 kernel/rcu/tree_exp.h:961
1 lock held by dhcpcd/13113:
 #0: ffff888070c80260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
 #0: ffff888070c80260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x33/0xe90 net/packet/af_packet.c:3204
1 lock held by dhcpcd/13127:
 #0: ffff888079e76260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
 #0: ffff888079e76260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x33/0xe90 net/packet/af_packet.c:3204
3 locks held by syz.0.1755/13140:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 32 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 11424 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:401
Code: e8 de 15 7a fc 44 89 f9 d3 e3 49 83 c6 40 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 4f 9a e7 fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f e9 f5 f4 c3 fb cc 44 89 f9 80 e1 07
RSP: 0018:ffffc9000396f5a8 EFLAGS: 00000002
RAX: 1ffffffff3501500 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000020
RBP: dffffc0000000000 R08: ffff8880264f0237 R09: 1ffff11004c9e046
R10: dffffc0000000000 R11: ffffffff854c4b90 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff9a80ae80 R15: 0000000000000000
FS:  000055558b7f8500(0000) GS:ffff888125320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000010000 CR3: 000000002cc76000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:128 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:150 [inline]
 wait_for_lsr+0x184/0x2f0 drivers/tty/serial/8250/8250_port.c:1982
 serial8250_fifo_wait_for_lsr_thre drivers/tty/serial/8250/8250_port.c:3229 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3294 [inline]
 serial8250_console_write+0x12ef/0x1ba0 drivers/tty/serial/8250/8250_port.c:3379
 console_emit_next_record kernel/printk/printk.c:3183 [inline]
 console_flush_one_record kernel/printk/printk.c:3269 [inline]
 console_flush_all+0x6ea/0xaf0 kernel/printk/printk.c:3343
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
 vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __ext4_msg+0x2b9/0x2d0 fs/ext4/super.c:1001
 ext4_put_super+0xb6/0xd80 fs/ext4/super.c:1302
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:647
 kill_block_super+0x44/0x90 fs/super.c:1665
 ext4_kill_sb+0x68/0xb0 fs/ext4/super.c:7499
 deactivate_locked_super+0xbc/0x130 fs/super.c:477
 cleanup_mnt+0x3d3/0x460 fs/namespace.c:1317
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1fa/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8ab759f097
Code: a2 c7 05 5c 26 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fffcf334e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f8ab76332ca RCX: 00007f8ab759f097
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fffcf334f20
RBP: 00007fffcf334f20 R08: 00007fffcf335f20 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffcf335fb0
R13: 00007f8ab76332ca R14: 000000000005b196 R15: 00007fffcf335ff0
 </TASK>


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
