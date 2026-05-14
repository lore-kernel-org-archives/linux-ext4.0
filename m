Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA593655D2
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2026 03:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778729257; cv=none; b=X+a3zxJ0NPCocL5bCKoCO9OxYnSAzgHorkG9BtyyH1SIdDZF7y2n6aVTCt2+d7nIoxriDxD002ZQ4iw9JBId8wTp+TTyIYFFnrw6kgEyqrl7C5tvTjrNych9fNO09cxeSg/6611IOmUxR830fYr97UvnW0khNGKqhYDxslIaps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778729257; c=relaxed/simple;
	bh=Q2BLEVAwWwvI7PKfd9z8YohFBpkOnRtTMrpJyqdzFc8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=glJ1OwLgOHF+sB0VWfYfmKIMzm4X+HAsblb6m5+XngHthdG37I1Ftg9XWPMihrMmJcwwDh20UJW8y9SycVJhjEo0BqgVBCNMdo60RsNM1PDpUTMb1bFP/ZQGlNdehiE95BM4h5i7/5JRcYN8QLBjM/sdM/hfk2QY30MN3MMwXUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-6966f1f4490so17029150eaf.1
        for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 20:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778729254; x=1779334054;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZRKMTH/KHD+rN/uhANp7BHRw5GIC3a2QWqwTKhX7er0=;
        b=W0inHWiRrE4IKYlaY8Om3EGIQbMMS0lUhuMsQOY05jY2pq9Eh8YPqWGWkuYNnTsNnq
         0kK/LZI63jmjQsUZK4CaMihlg3+5AFsjfRU+0XaGAMx14qdIPi+twghlixER+OWOcHrm
         zeHOgNcOOWo8IDls3SBP50+80gmbxuM1Kny7866H6AfyN0ipQReO3Zs2zYFR2MuT4oqW
         u6shD4pKBPEbGKSNVj6953KaXU2dVTx3UxUIXIKbfOEOWWJm8FGFHmTa7O+bV+LFyNji
         StiMax4hgbuIZzKPwncBbUnEOdM2des4/uo519TRNrz8NTAGa86CGsm4QplgUN7HG0ey
         UnUw==
X-Forwarded-Encrypted: i=1; AFNElJ/jMvqk/E44HAfNO+fAp3ATzXiVsWJpfhoJRGvzu1vV0rIDG9ai/OvWGhSHkxXEOtvXmE4fvxfMX3BE@vger.kernel.org
X-Gm-Message-State: AOJu0YxYeKIex3Cy5vfFPO6qLYJ0czn/sw5FPZ8hJJeRoy5NpXS0fwmI
	yC2WDmy7/ABunAUpH62/1w43I60WbCHOYO/P7T+1fUs9XaQLkzygPNLbhHc2p2GNpOy/00NHgO0
	N63a1F/dksF92TsxhmFKH1AyN/p3t6OXayKYRS77fLxHsJls7UDXs+1gHrjI=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:d10e:0:b0:67e:e9c:63f0 with SMTP id
 006d021491bc7-69b8829ab9dmr884756eaf.25.1778729254355; Wed, 13 May 2026
 20:27:34 -0700 (PDT)
Date: Wed, 13 May 2026 20:27:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a054126.170a0220.9c1d9.0786.GAE@google.com>
Subject: [syzbot] [ext4?] BUG: sleeping function called from invalid context
 in mempool_alloc_noprof
From: syzbot <syzbot+9fc0caf33cb36845f9b9@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    25bd55f46032 usb: udc: pxa: remove unused platform_data
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=16e2ead2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afc495310dffaa7c
dashboard link: https://syzkaller.appspot.com/bug?extid=9fc0caf33cb36845f9b9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/df4cd244b684/disk-25bd55f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bccb34371b4c/vmlinux-25bd55f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d86b0bd5ea58/bzImage-25bd55f4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9fc0caf33cb36845f9b9@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 50, name: kworker/u8:4
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
4 locks held by kworker/u8:4/50:
 #0: ffff888100e9d140 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x12d6/0x1980 kernel/workqueue.c:3277
 #1: ffffc90000537d18 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x973/0x1980 kernel/workqueue.c:3278
 #2: ffff8881012bc0d8 (&type->s_umount_key#33){.+.+}-{4:4}, at: super_trylock_shared+0x1e/0xf0 fs/super.c:565
 #3: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #3: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #3: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: unlocked_inode_to_wb_begin include/linux/backing-dev.h:290 [inline]
 #3: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: folio_clear_dirty_for_io+0x1eb/0x7f0 mm/page-writeback.c:2919
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 might_alloc include/linux/sched/mm.h:323 [inline]
 might_alloc include/linux/sched/mm.h:315 [inline]
 mempool_alloc_noprof+0x220/0x310 mm/mempool.c:558
 bio_alloc_bioset+0x8d5/0x1050 block/bio.c:594
 bio_alloc include/linux/bio.h:367 [inline]
 submit_bh_wbc+0x250/0x710 fs/buffer.c:2716
 __block_write_full_folio+0x77f/0xee0 fs/buffer.c:1830
 block_write_full_folio+0x3b5/0x4e0 fs/buffer.c:2650
 blkdev_writepages+0xc7/0x150 block/fops.c:486
 do_writepages+0x278/0x600 mm/page-writeback.c:2575
 __writeback_single_inode+0x164/0x1350 fs/fs-writeback.c:1764
 writeback_sb_inodes+0x766/0x1c60 fs/fs-writeback.c:2056
 __writeback_inodes_wb+0xf8/0x2d0 fs/fs-writeback.c:2132
 wb_writeback+0x720/0xb90 fs/fs-writeback.c:2243
 wb_check_old_data_flush fs/fs-writeback.c:2347 [inline]
 wb_do_writeback fs/fs-writeback.c:2400 [inline]
 wb_workfn+0x8dd/0xc00 fs/fs-writeback.c:2428
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: workqueue leaked atomic, lock or RCU: kworker/u8:4[50]
     preempt=0x00000000 lock=0->1 RCU=0->1 workfn=wb_workfn
1 lock held by kworker/u8:4/50:
 #0: 
ffffffff896de8e0
 (
rcu_read_lock
){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
){....}-{1:3}, at: unlocked_inode_to_wb_begin include/linux/backing-dev.h:290 [inline]
){....}-{1:3}, at: folio_clear_dirty_for_io+0x1eb/0x7f0 mm/page-writeback.c:2919
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 process_one_work.cold+0x127/0x306 kernel/workqueue.c:3323
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W          
-----------------------------
kworker/u8:4/50 is trying to lock:
ffff88811bb071d0 (&ei->i_data_sem){++++}-{4:4}, at: ext4_map_blocks+0x45a/0xd30 fs/ext4/inode.c:823
other info that might help us debug this:
context-{5:5}
4 locks held by kworker/u8:4/50:
 #0: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: unlocked_inode_to_wb_begin include/linux/backing-dev.h:290 [inline]
 #0: ffffffff896de8e0 (rcu_read_lock){....}-{1:3}, at: folio_clear_dirty_for_io+0x1eb/0x7f0 mm/page-writeback.c:2919
 #1: ffff888113550940 ((wq_completion)ext4-rsv-conversion){+.+.}-{0:0}, at: process_one_work+0x12d6/0x1980 kernel/workqueue.c:3277
 #2: ffffc90000537d18 ((work_completion)(&ei->i_rsv_conversion_work)){+.+.}-{0:0}, at: process_one_work+0x973/0x1980 kernel/workqueue.c:3278
 #3: ffff888116262938 (jbd2_handle){.+.+}-{0:0}, at: start_this_handle+0xfaa/0x13a0 fs/jbd2/transaction.c:444
stack backtrace:
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4830 [inline]
 check_wait_context kernel/locking/lockdep.c:4902 [inline]
 __lock_acquire+0xfa4/0x2630 kernel/locking/lockdep.c:5187
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1625
 ext4_map_blocks+0x45a/0xd30 fs/ext4/inode.c:823
 ext4_convert_unwritten_extents+0x2a6/0x4d0 fs/ext4/extents.c:5067
 ext4_convert_unwritten_io_end_vec+0x121/0x280 fs/ext4/extents.c:5107
 ext4_end_io_end+0xd3/0x4b0 fs/ext4/page-io.c:199
 ext4_do_flush_completed_IO fs/ext4/page-io.c:290 [inline]
 ext4_end_io_rsv_work+0x205/0x380 fs/ext4/page-io.c:305
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 50, name: kworker/u8:4
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4520 [inline]
 slab_alloc_node mm/slub.c:4875 [inline]
 __do_kmalloc_node mm/slub.c:5294 [inline]
 __kmalloc_noprof+0x55e/0x810 mm/slub.c:5307
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 ext4_find_extent+0x21b/0xa30 fs/ext4/extents.c:918
 ext4_ext_map_blocks+0x20a/0x5930 fs/ext4/extents.c:4286
 ext4_map_create_blocks+0xec/0x5e0 fs/ext4/inode.c:631
 ext4_map_blocks+0x46b/0xd30 fs/ext4/inode.c:824
 ext4_convert_unwritten_extents+0x2a6/0x4d0 fs/ext4/extents.c:5067
 ext4_convert_unwritten_io_end_vec+0x121/0x280 fs/ext4/extents.c:5107
 ext4_end_io_end+0xd3/0x4b0 fs/ext4/page-io.c:199
 ext4_do_flush_completed_IO fs/ext4/page-io.c:290 [inline]
 ext4_end_io_rsv_work+0x205/0x380 fs/ext4/page-io.c:305
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: workqueue leaked atomic, lock or RCU: kworker/u8:4[50]
     preempt=0x00000000 lock=1->0 RCU=1->1 workfn=ext4_end_io_rsv_work
INFO: lockdep is turned off.
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 process_one_work.cold+0x127/0x306 kernel/workqueue.c:3323
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332, CPU#0: kworker/u8:4/50
Modules linked in:
CPU: 0 UID: 0 PID: 50 Comm: kworker/u8:4 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue:  0x0 (ext4-rsv-conversion)
RIP: 0010:rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332
Code: c1 ea 03 80 3c 02 00 0f 85 9b 0b 00 00 48 8b 53 28 b9 01 00 00 00 4c 89 ef e8 a3 cf fe ff e9 1d f9 ff ff 48 8d 3d 27 29 59 09 <67> 48 0f b9 3a e9 99 f8 ff ff 48 b8 00 00 00 00 00 fc ff df 48 8d
RSP: 0018:ffffc90000537c10 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ffff8881f563a540 RCX: ffffffff81987a21
RDX: 0000000000000000 RSI: ffffffff87b08ce0 RDI: ffffffff8af21770
RBP: ffff888103eb8000 R08: 0000000000000000 R09: fffffbfff15e10da
R10: ffffffff8af086d7 R11: 0000000000000001 R12: 0000000000000000
R13: ffff888103eb847c R14: ffffffff8cf91680 R15: ffffffff8af09664
FS:  0000000000000000(0000) GS:ffff8882686a8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d53982e008 CR3: 0000000117564000 CR4: 00000000003506f0
Call Trace:
 <TASK>
 __schedule+0x25e/0x4840 kernel/sched/core.c:7043
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7282
 worker_thread+0x53b/0xe50 kernel/workqueue.c:3481
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 9b 0b 00 00    	jne    0xba8
   d:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  11:	b9 01 00 00 00       	mov    $0x1,%ecx
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	e8 a3 cf fe ff       	call   0xfffecfc1
  1e:	e9 1d f9 ff ff       	jmp    0xfffff940
  23:	48 8d 3d 27 29 59 09 	lea    0x9592927(%rip),%rdi        # 0x9592951
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 99 f8 ff ff       	jmp    0xfffff8cd
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	48                   	rex.W
  3f:	8d                   	.byte 0x8d


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
