Received: from smtp2.ptsecurity.com (smtp2.ptsecurity.com [155.212.253.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE7E285CAE;
	Thu, 28 May 2026 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.212.253.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980642; cv=none; b=P9L9cdrYWbWYKzOTujG38nR12WlJFxqP05hXutWKG9QhH5kKI47Vp4kw/s/8jkBF2vLF4IBX5uuD6dqoqv8KwGRUNNhbmghDGXJ6/ffCUtSCV0hyvgKix/wjxKVZZFFnbpJSm2GuKME51PF6JDuZShl9UHwqpbLPIhwWQmEPjkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980642; c=relaxed/simple;
	bh=V9sRZAjKTto8aOMnXVkXO/SVeBDF0iHqsktGMk7wgNs=;
	h=Date:From:To:Message-ID:MIME-Version:Content-Type; b=gjP3aAOtcWlw+LsMqNSVPjCeeUTgaKgb1LD7lsmAE0WDn871moZoBkDu2hkYJvC+LcslNMcorS95X3+CwS2T1nkkTlE+6HManNfK3MHYD0T5rv6nJbahlbR76GGLkVkfiEJUCTtPsA/UiRXQV5oaSkB/HNLBinNfePfpxmPZ4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ptsecurity.com; spf=pass smtp.mailfrom=ptsecurity.com; dkim=pass (2048-bit key) header.d=ptsecurity.com header.i=@ptsecurity.com header.b=HvMz+QoZ; arc=none smtp.client-ip=155.212.253.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ptsecurity.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ptsecurity.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ptsecurity.com header.i=@ptsecurity.com header.b="HvMz+QoZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ptsecurity.com;
	s=202601; t=1779980207;
	bh=V9sRZAjKTto8aOMnXVkXO/SVeBDF0iHqsktGMk7wgNs=;
	h=Date:From:To:From;
	b=HvMz+QoZeWwxajlTkdLNAmBj5rStRcJP20BD7MXVc/Ek0P2+40Rqr2IC4imTuPnui
	 P7u1xHcIQurGEZX0agDVy+XzJ3CVNKAnwPF055oD7shuyaVBXXbCvyW7vFYCZEcuxo
	 8ZXckLz53JHs1WLuULvkLu+6BGaKfXSrqlf+6RTNJDMYrrxHcVLn6fvzj39EZF675t
	 0mBwATtP4CVcKwkEDLWaosAUZ1q2j5VTZEcKPSsXHVUT9M6EmI8V0T42+8sbQs9lQr
	 TeeMwE53KMUyup2DHmOZY+KDnWL4I52MrVrcZALMKzTPp3+bwCo5BzsCiKSpSkYIuq
	 m5EXKoes6uwhA==
Date: Thu, 28 May 2026 14:56:46 +0000
From: Syzkaller syz-bot-8448545c66-w8mzv <fuzzing.farm@ptsecurity.com>
To: <eburkov@ptsecurity.com>, <jack@suse.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tytso@mit.edu>
Message-ID: <20260528145646.1Czp0%fuzzing.farm@ptsecurity.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Content-Type: multipart/mixed; boundary="===============0636582995431990448=="
MIME-Version: 1.0
To: eburkov@ptsecurity.com, jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
From: "syzbot" <fuzzing.farm+b4c70f9f7908435cb4f7@ptsecurity.com>
Reply-To: 
Subject: [syzbot] INFO: task hung in do_get_write_access

--===============0636582995431990448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hello,

syzbot found the following issue on:

HEAD commit:    100000000000 6.9.6
git tree:       https://github.com/torvalds/linux.git 6.9.6
console output: https://None.appspot.com/x/log.txt?x=16a08000000000
kernel config:  https://None.appspot.com/x/.config?x=31f7bb9bd056e52b
dashboard link: https://None.appspot.com/bug?extid=b4c70f9f7908435cb4f7
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: fuzzing.farm+b4c70f9f7908435cb4f7@ptsecurity.com

forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
INFO: task kworker/u8:2:32 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:2    state:D stack:24272 pid:32    tgid:32    ppid:2      flags:0x00004000
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 bit_wait_io+0x1b/0xf0 kernel/sched/wait_bit.c:209
 __wait_on_bit+0x63/0x170 kernel/sched/wait_bit.c:49
 out_of_line_wait_on_bit+0xe1/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 do_get_write_access+0x91c/0x1270 fs/jbd2/transaction.c:1111
 jbd2_journal_get_write_access+0x20a/0x2a0 fs/jbd2/transaction.c:1260
 __ext4_journal_get_write_access+0x6e/0x3e0 fs/ext4/ext4_jbd2.c:239
 ext4_mb_mark_context+0x1f3/0xe50 fs/ext4/mballoc.c:4005
 ext4_mb_mark_diskspace_used+0x461/0x990 fs/ext4/mballoc.c:4122
 ext4_mb_new_blocks+0x7fc/0x4cc0 fs/ext4/mballoc.c:6224
 ext4_ext_map_blocks+0x1ced/0x6180 fs/ext4/extents.c:4317
 ext4_map_blocks+0x654/0x1a20 fs/ext4/inode.c:623
 mpage_map_one_extent fs/ext4/inode.c:2163 [inline]
 mpage_map_and_submit_extent fs/ext4/inode.c:2216 [inline]
 ext4_do_writepages+0x1a62/0x35e0 fs/ext4/inode.c:2679
 ext4_writepages+0x34e/0x7a0 fs/ext4/inode.c:2768
 do_writepages+0x1ca/0x890 mm/page-writeback.c:2612
 __writeback_single_inode+0x157/0xee0 fs/fs-writeback.c:1650
 writeback_sb_inodes+0x5fb/0x1170 fs/fs-writeback.c:1941
 __writeback_inodes_wb+0x10d/0x300 fs/fs-writeback.c:2012
 wb_writeback+0x7b3/0xae0 fs/fs-writeback.c:2119
 wb_check_background_flush fs/fs-writeback.c:2189 [inline]
 wb_do_writeback fs/fs-writeback.c:2277 [inline]
 wb_workfn+0x8a1/0xf60 fs/fs-writeback.c:2304
 process_one_work+0x93e/0x1ab0 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3348 [inline]
 worker_thread+0x6b9/0xf60 kernel/workqueue.c:3429
 kthread+0x2cc/0x3c0 kernel/kthread.c:388
 ret_from_fork+0x56/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task kworker/u8:3:41 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:3    state:D stack:24280 pid:41    tgid:41    ppid:2      flags:0x00004000
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 blk_mq_get_tag+0x5ec/0xb90 block/blk-mq-tag.c:187
 __blk_mq_alloc_requests+0x7eb/0x1e40 block/blk-mq.c:499
 blk_mq_get_new_requests block/blk-mq.c:2890 [inline]
 blk_mq_submit_bio+0x12b1/0x1f90 block/blk-mq.c:2988
 __submit_bio+0x89/0x250 block/blk-core.c:621
 __submit_bio_noacct_mq block/blk-core.c:700 [inline]
 submit_bio_noacct_nocheck+0x92f/0xcd0 block/blk-core.c:729
 submit_bio_noacct+0x278/0xff0 block/blk-core.c:839
 submit_bio+0xd5/0x480 block/blk-core.c:881
 ext4_io_submit+0xac/0x150 fs/ext4/page-io.c:378
 ext4_do_writepages+0xc8b/0x35e0 fs/ext4/inode.c:2636
 ext4_writepages+0x34e/0x7a0 fs/ext4/inode.c:2768
 do_writepages+0x1ca/0x890 mm/page-writeback.c:2612
 __writeback_single_inode+0x157/0xee0 fs/fs-writeback.c:1650
 writeback_sb_inodes+0x5fb/0x1170 fs/fs-writeback.c:1941
 __writeback_inodes_wb+0x10d/0x300 fs/fs-writeback.c:2012
 wb_writeback+0x7b3/0xae0 fs/fs-writeback.c:2119
 wb_check_background_flush fs/fs-writeback.c:2189 [inline]
 wb_do_writeback fs/fs-writeback.c:2277 [inline]
 wb_workfn+0x8a1/0xf60 fs/fs-writeback.c:2304
 process_one_work+0x93e/0x1ab0 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3348 [inline]
 worker_thread+0x6b9/0xf60 kernel/workqueue.c:3429
 kthread+0x2cc/0x3c0 kernel/kthread.c:388
 ret_from_fork+0x56/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task jbd2/sda-8:58 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:jbd2/sda-8      state:D stack:26824 pid:58    tgid:58    ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 blk_mq_get_tag+0x5ec/0xb90 block/blk-mq-tag.c:187
 __blk_mq_alloc_requests+0x7eb/0x1e40 block/blk-mq.c:499
 blk_mq_get_new_requests block/blk-mq.c:2890 [inline]
 blk_mq_submit_bio+0x12b1/0x1f90 block/blk-mq.c:2988
 __submit_bio+0x89/0x250 block/blk-core.c:621
 __submit_bio_noacct_mq block/blk-core.c:700 [inline]
 submit_bio_noacct_nocheck+0x92f/0xcd0 block/blk-core.c:729
 submit_bio_noacct+0x278/0xff0 block/blk-core.c:839
 submit_bio+0xd5/0x480 block/blk-core.c:881
 submit_bh_wbc+0x579/0x740 fs/buffer.c:2804
 submit_bh+0x24/0x30 fs/buffer.c:2809
 jbd2_journal_commit_transaction+0x2cd8/0x6640 fs/jbd2/commit.c:731
 kjournald2+0x218/0x970 fs/jbd2/journal.c:201
 kthread+0x2cc/0x3c0 kernel/kthread.c:388
 ret_from_fork+0x56/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task systemd-journal:85 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:systemd-journal state:D stack:25008 pid:85    tgid:85    ppid:1      flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 bit_wait_io+0x1b/0xf0 kernel/sched/wait_bit.c:209
 __wait_on_bit+0x63/0x170 kernel/sched/wait_bit.c:49
 out_of_line_wait_on_bit+0xe1/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 do_get_write_access+0x91c/0x1270 fs/jbd2/transaction.c:1111
 jbd2_journal_get_write_access+0x20a/0x2a0 fs/jbd2/transaction.c:1260
 __ext4_journal_get_write_access+0x6e/0x3e0 fs/ext4/ext4_jbd2.c:239
 ext4_reserve_inode_write+0x144/0x280 fs/ext4/inode.c:5728
 __ext4_mark_inode_dirty+0x1b1/0x8b0 fs/ext4/inode.c:5902
 ext4_dirty_inode+0xe6/0x140 fs/ext4/inode.c:5939
 __mark_inode_dirty+0x1d5/0xda0 fs/fs-writeback.c:2477
 generic_update_time+0xd4/0x100 fs/inode.c:1907
 inode_update_time fs/inode.c:1920 [inline]
 __file_update_time fs/inode.c:2109 [inline]
 file_update_time+0x143/0x170 fs/inode.c:2139
 ext4_page_mkwrite+0x38c/0x17d0 fs/ext4/inode.c:6057
 do_page_mkwrite+0x195/0x3b0 mm/memory.c:3091
 wp_page_shared mm/memory.c:3478 [inline]
 do_wp_page+0x543/0x2a60 mm/memory.c:3628
 handle_pte_fault mm/memory.c:5316 [inline]
 __handle_mm_fault+0xcc8/0x26e0 mm/memory.c:5441
 handle_mm_fault+0x455/0xad0 mm/memory.c:5606
 do_user_addr_fault+0x504/0x1130 arch/x86/mm/fault.c:1331
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x5e/0xe0 arch/x86/mm/fault.c:1532
 _ZN2PT3LLD9Shellcode14HyperTransportL21splice_exc_page_faultEPNS2_7pt_regsEm+0x43/0x50 root/lld/kernel/linux/shellcode/driver/communication/page_fault_hook.cpp:28 [ptsb]
 asm_exc_page_fault+0x27/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f3b9ba7e419
RSP: 002b:00007fffe6506800 EFLAGS: 00010246
RAX: 00007f3b997e7308 RBX: 000055d8e08bfb00 RCX: 00007f3b9baeb7e0
RDX: 00007f3b9baeb200 RSI: 00007fffe65067a8 RDI: 000055d8e08c6e40
RBP: 000055d8e08c6790 R08: 0000000000600ea8 R09: 000000000012c308
R10: 0000000000000002 R11: 0000000000223fe6 R12: 0000000000000024
R13: 00000000000324d0 R14: 0000000000000000 R15: 00007fffe6506820
 </TASK>
INFO: task rs:main Q:Reg:141 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:rs:main Q:Reg   state:D stack:26808 pid:141   tgid:136   ppid:1      flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 bit_wait_io+0x1b/0xf0 kernel/sched/wait_bit.c:209
 __wait_on_bit+0x63/0x170 kernel/sched/wait_bit.c:49
 out_of_line_wait_on_bit+0xe1/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 do_get_write_access+0x91c/0x1270 fs/jbd2/transaction.c:1111
 jbd2_journal_get_write_access+0x20a/0x2a0 fs/jbd2/transaction.c:1260
 __ext4_journal_get_write_access+0x6e/0x3e0 fs/ext4/ext4_jbd2.c:239
 ext4_reserve_inode_write+0x144/0x280 fs/ext4/inode.c:5728
 __ext4_mark_inode_dirty+0x1b1/0x8b0 fs/ext4/inode.c:5902
 ext4_dirty_inode+0xe6/0x140 fs/ext4/inode.c:5939
 __mark_inode_dirty+0x1d5/0xda0 fs/fs-writeback.c:2477
 generic_update_time+0xd4/0x100 fs/inode.c:1907
 inode_update_time fs/inode.c:1920 [inline]
 __file_update_time fs/inode.c:2109 [inline]
 file_modified_flags fs/inode.c:2180 [inline]
 file_modified+0x1b7/0x1f0 fs/inode.c:2196
 ext4_write_checks fs/ext4/file.c:279 [inline]
 ext4_buffered_write_iter+0x107/0x3f0 fs/ext4/file.c:295
 ext4_file_write_iter+0x390/0x1900 fs/ext4/file.c:698
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x786/0x1350 fs/read_write.c:590
 _ZN2PT3LLD9ShellcodeL16splice_vfs_writeEP4filePKcmPx+0x57/0x200 root/lld/kernel/linux/shellcode/driver/plugins/filetracer.cpp:363 [ptsb]
 ksys_write+0x155/0x290 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x77/0xb0 fs/read_write.c:652
 _ZN2PT3LLD9ShellcodeL16SysSpliceGenericEPK7pt_regsPFlS4_ERKNS1_11syscall_dscE root/lld/kernel/linux/shellcode/driver/plugins/syscalls.cpp:395 [inline] [ptsb]
 _ZN2PT3LLD9ShellcodeL24splice_syscall_x64_writeEPK7pt_regs+0x51/0x60 root/lld/kernel/linux/shellcode/driver/plugins/syscalls.cpp:587 [ptsb]
 x64_sys_call+0x1e65/0x1f10 arch/x86/include/generated/asm/syscalls_64.h:2
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xbf/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd394ee9fef
RSP: 002b:00007fd38fffe830 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000088 RCX: 00007fd394ee9fef
RDX: 0000000000001000 RSI: 00007fd384024260 RDI: 0000000000000009
RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fd384024260
R13: 0000000000000000 R14: 0000000000000088 R15: 00007fd384023fa0
 </TASK>
INFO: task syz-executor:209 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:26264 pid:209   tgid:209   ppid:203    flags:0x00000002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 bit_wait_io+0x1b/0xf0 kernel/sched/wait_bit.c:209
 __wait_on_bit+0x63/0x170 kernel/sched/wait_bit.c:49
 out_of_line_wait_on_bit+0xe1/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 do_get_write_access+0x91c/0x1270 fs/jbd2/transaction.c:1111
 jbd2_journal_get_write_access+0x20a/0x2a0 fs/jbd2/transaction.c:1260
 __ext4_journal_get_write_access+0x6e/0x3e0 fs/ext4/ext4_jbd2.c:239
 ext4_reserve_inode_write+0x144/0x280 fs/ext4/inode.c:5728
 __ext4_mark_inode_dirty+0x1b1/0x8b0 fs/ext4/inode.c:5902
 ext4_dirty_inode+0xe6/0x140 fs/ext4/inode.c:5939
 __mark_inode_dirty+0x1d5/0xda0 fs/fs-writeback.c:2477
 generic_update_time+0xd4/0x100 fs/inode.c:1907
 inode_update_time fs/inode.c:1920 [inline]
 __file_update_time fs/inode.c:2109 [inline]
 file_update_time+0x143/0x170 fs/inode.c:2139
 ext4_page_mkwrite+0x38c/0x17d0 fs/ext4/inode.c:6057
 do_page_mkwrite+0x195/0x3b0 mm/memory.c:3091
 do_shared_fault mm/memory.c:4966 [inline]
 do_fault mm/memory.c:5028 [inline]
 do_pte_missing mm/memory.c:3880 [inline]
 handle_pte_fault mm/memory.c:5300 [inline]
 __handle_mm_fault+0x12ef/0x26e0 mm/memory.c:5441
 handle_mm_fault+0x455/0xad0 mm/memory.c:5606
 do_user_addr_fault+0x396/0x1130 arch/x86/mm/fault.c:1382
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x5e/0xe0 arch/x86/mm/fault.c:1532
 _ZN2PT3LLD9Shellcode14HyperTransportL21splice_exc_page_faultEPNS2_7pt_regsEm+0x43/0x50 root/lld/kernel/linux/shellcode/driver/communication/page_fault_hook.cpp:28 [ptsb]
 asm_exc_page_fault+0x27/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f34896debad
RSP: 002b:00007ffe4422bb08 EFLAGS: 00010287
RAX: 00007f3484d93000 RBX: 0000555559d98d00 RCX: 000000000000003f
RDX: 000000000000005d RSI: 0000555559d9af30 RDI: 00007f3484d93000
RBP: 0000555559d97dc0 R08: 0000000000000007 R09: 0000555559d97f10
R10: 311dc10bb6075acf R11: 0000000000000202 R12: 0000000000000001
R13: 0000000000000000 R14: 00007ffe4422bb20 R15: 0000000000000000
 </TASK>
INFO: task syz-executor:218 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:24672 pid:218   tgid:218   ppid:214    flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 bit_wait_io+0x1b/0xf0 kernel/sched/wait_bit.c:209
 __wait_on_bit+0x63/0x170 kernel/sched/wait_bit.c:49
 out_of_line_wait_on_bit+0xe1/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 do_get_write_access+0x91c/0x1270 fs/jbd2/transaction.c:1111
 jbd2_journal_get_write_access+0x20a/0x2a0 fs/jbd2/transaction.c:1260
 __ext4_journal_get_write_access+0x6e/0x3e0 fs/ext4/ext4_jbd2.c:239
 __ext4_new_inode+0x1057/0x56f0 fs/ext4/ialloc.c:1088
 ext4_mkdir+0x2ab/0xbf0 fs/ext4/namei.c:3013
 vfs_mkdir+0x585/0x830 fs/namei.c:4123
 do_mkdirat+0x327/0x3d0 fs/namei.c:4146
 __do_sys_mkdirat fs/namei.c:4161 [inline]
 __se_sys_mkdirat fs/namei.c:4159 [inline]
 __x64_sys_mkdirat+0x11c/0x180 fs/namei.c:4159
 _ZN2PT3LLD9ShellcodeL16SysSpliceGenericEPK7pt_regsPFlS4_ERKNS1_11syscall_dscE root/lld/kernel/linux/shellcode/driver/plugins/syscalls.cpp:395 [inline] [ptsb]
 _ZN2PT3LLD9ShellcodeL26splice_syscall_x64_mkdiratEPK7pt_regs+0x51/0x60 root/lld/kernel/linux/shellcode/driver/plugins/syscalls.cpp:1679 [ptsb]
 x64_sys_call+0x1dff/0x1f10 arch/x86/include/generated/asm/syscalls_64.h:259
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xbf/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ee7aab997
RSP: 002b:00007ffcd45a4bd8 EFLAGS: 00000206 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f1ee7b1fc1b RCX: 00007f1ee7aab997
RDX: 00000000000001ff RSI: 00007f1ee7b1fc1b RDI: 00000000ffffff9c
RBP: 00007f1ee7c65a38 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000000000000c
R13: 0000000000000003 R14: 0000000000000009 R15: 0000000000000000
 </TASK>
INFO: task kworker/u8:4:232 blocked for more than 143 seconds.
      Tainted: G           O       6.9.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:4    state:D stack:25208 pid:232   tgid:232   ppid:2      flags:0x00004000
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0xb9b/0x2d20 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0xea/0x380 kernel/sched/core.c:6838
 io_schedule+0xca/0x150 kernel/sched/core.c:9044
 blk_mq_get_tag+0x5ec/0xb90 block/blk-mq-tag.c:187
 __blk_mq_alloc_requests+0x7eb/0x1e40 block/blk-mq.c:499
 blk_mq_get_new_requests block/blk-mq.c:2890 [inline]
 blk_mq_submit_bio+0x12b1/0x1f90 block/blk-mq.c:2988
 __submit_bio+0x89/0x250 block/blk-core.c:621
 __submit_bio_noacct_mq block/blk-core.c:700 [inline]
 submit_bio_noacct_nocheck+0x92f/0xcd0 block/blk-core.c:729
 submit_bio_noacct+0x278/0xff0 block/blk-core.c:839
 submit_bio+0xd5/0x480 block/blk-core.c:881
 ext4_io_submit fs/ext4/page-io.c:378 [inline]
 io_submit_add_bh fs/ext4/page-io.c:419 [inline]
 ext4_bio_write_folio+0x86c/0x13b0 fs/ext4/page-io.c:563
 mpage_submit_folio+0x1a8/0x290 fs/ext4/inode.c:1869
 mpage_process_page_bufs+0x3dc/0x8c0 fs/ext4/inode.c:1982
 mpage_prepare_extent_to_map+0xd74/0x1420 fs/ext4/inode.c:2490
 ext4_do_writepages+0xc72/0x35e0 fs/ext4/inode.c:2632
 ext4_writepages+0x34e/0x7a0 fs/ext4/inode.c:2768
 do_writepages+0x1ca/0x890 mm/page-writeback.c:2612
 __writeback_single_inode+0x157/0xee0 fs/fs-writeback.c:1650
 writeback_sb_inodes+0x5fb/0x1170 fs/fs-writeback.c:1941
 __writeback_inodes_wb+0x10d/0x300 fs/fs-writeback.c:2012
 wb_writeback+0x7b3/0xae0 fs/fs-writeback.c:2119
 wb_check_old_data_flush fs/fs-writeback.c:2223 [inline]
 wb_do_writeback fs/fs-writeback.c:2276 [inline]
 wb_workfn+0xa46/0xf60 fs/fs-writeback.c:2304
 process_one_work+0x93e/0x1ab0 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3348 [inline]
 worker_thread+0x6b9/0xf60 kernel/workqueue.c:3429
 kthread+0x2cc/0x3c0 kernel/kthread.c:388
 ret_from_fork+0x56/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: lockdep is turned off.
forming flush request for buffer 0xffffc900006d4000, size: 288776
forming flush request for buffer 0xffffc900006d4000, size: 1680
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672
forming flush request for buffer 0xffffc900006d4000, size: 1672


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
--===============0636582995431990448==--
