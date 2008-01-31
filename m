From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: BUG_ON at mballoc.c:3752
Date: Thu, 31 Jan 2008 15:01:37 +0100
Message-ID: <20080131140137.GA20780@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932653AbYAaOBk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 09:01:40 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

while running a modified version of fsfuzzer i triggered the BUG() in
ext4_mb_release_inode_pa(). Sadly I am not able to reproduce this using
the generated image, but running the fuzzer will usually trigger this in
less than 40 attempts. Increasing the JBD2 Debug level didnt give more
information. The kernel is current git with
ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch
applied. 

Greetings, Eric

[ 1570.971980] EXT4-fs error (device loop0) in ext4_reserve_inode_write: Journal has aborted
[ 1570.972077] pa c6512330: logic 16, phys. 2337, len 16
[ 1570.972103] free 2, pa_free 1
[ 1570.972191] ------------[ cut here ]------------
[ 1570.972217] kernel BUG at fs/ext4/mballoc.c:3752!
[ 1570.972241] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[ 1570.972386] Modules linked in:
[ 1570.972425] 
[ 1570.972509] Pid: 6629, comm: fstest Not tainted (2.6.24-05749-g8af03e7-dirty #19)
[ 1570.972534] EIP: 0060:[<c02266b9>] EFLAGS: 00010202 CPU: 0
[ 1570.972570] EIP is at ext4_mb_release_inode_pa+0x169/0x1a0
[ 1570.972595] EAX: 00000001 EBX: 00000930 ECX: 00000001 EDX: 00000001
[ 1570.972678] ESI: 00000930 EDI: c6512330 EBP: cb638b28 ESP: cb638a84
[ 1570.972703]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1570.972728] Process fstest (pid: 6629, ti=cb638000 task=cb698000 task.ti=cb638000)
[ 1570.972751] Stack: c07c21bb 00000002 00000001 00000921 00000010 cbff34e0 cb638b54 00000002 
[ 1570.972899]        cb5fa430 c64824a0 cb5fb920 00000022 cbff34e0 cb638ad4 00000246 00000400 
[ 1570.972899]        cbfa2000 cb5fb920 cbff34e0 00000000 0000092e 00000000 00000002 cbfa2000 
[ 1570.972899] Call Trace:
[ 1570.972899]  [<c020e3a4>] ? read_block_bitmap+0x54/0x120
[ 1570.972899]  [<c022bd24>] ? ext4_mb_discard_inode_preallocations+0x124/0x300
[ 1570.972899]  [<c022bda5>] ? ext4_mb_discard_inode_preallocations+0x1a5/0x300
[ 1570.972899]  [<c0223577>] ? ext4_ext_get_blocks+0x3a7/0x4b0
[ 1570.972899]  [<c0213928>] ? ext4_get_blocks_wrap+0xe8/0x130
[ 1570.972899]  [<c0213bce>] ? ext4_get_block+0x7e/0xf0
[ 1570.972899]  [<c019d7ba>] ? __block_prepare_write+0x17a/0x3a0
[ 1570.972899]  [<c019da68>] ? block_write_begin+0x48/0xe0
[ 1570.972899]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.972899]  [<c0215127>] ? ext4_write_begin+0xb7/0x190
[ 1570.972899]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.972899]  [<c01557e9>] ? generic_perform_write+0xa9/0x190
[ 1570.972899]  [<c01575bd>] ? generic_file_buffered_write+0x6d/0x130
[ 1570.972899]  [<c01578c1>] ? __generic_file_aio_write_nolock+0x241/0x550
[ 1570.972899]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.972899]  [<c0157c2c>] ? generic_file_aio_write+0x5c/0xd0
[ 1570.972899]  [<c015ab0d>] ? free_one_page+0x1ed/0x220
[ 1570.972899]  [<c0210410>] ? ext4_file_write+0x50/0x160
[ 1570.972899]  [<c017b11d>] ? do_sync_write+0xcd/0x110
[ 1570.972899]  [<c01096f9>] ? native_sched_clock+0x69/0xc0
[ 1570.972899]  [<c01373c0>] ? autoremove_wake_function+0x0/0x50
[ 1570.972899]  [<c01070e5>] ? do_softirq+0x55/0xd0
[ 1570.972899]  [<c01050d3>] ? restore_nocheck+0x12/0x15
[ 1570.972899]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.972899]  [<c017b959>] ? vfs_write+0x99/0x130
[ 1570.972899]  [<c017b050>] ? do_sync_write+0x0/0x110
[ 1570.972899]  [<c017c048>] ? sys_pwrite64+0x68/0x70
[ 1570.972899]  [<c0104fea>] ? sysenter_past_esp+0x5f/0xa5
[ 1570.972899]  =======================
[ 1570.972899] Code: ff 0f b7 47 4e 89 44 24 08 8b 85 78 ff ff ff c7 04 24 bb 21 7c c0 89 44 24 04 e8 c3 e0 ef ff 0f b7 47 4e 39 85 78 ff ff ff 74 07 <0f> 0b eb fe 8d 76 00 8b 85 78 ff ff ff 8b 95 7c ff ff ff 01 82 
[ 1570.972899] EIP: [<c02266b9>] ext4_mb_release_inode_pa+0x169/0x1a0 SS:ESP 0068:cb638a84
[ 1570.972942] ---[ end trace 51819e80cd9431da ]---
[ 1570.972969] note: fstest[6629] exited with preempt_count 1
[ 1570.973013] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[ 1570.973039] in_atomic():1, irqs_disabled():0
[ 1570.973077] INFO: lockdep is turned off.
[ 1570.973104] Pid: 6629, comm: fstest Tainted: G      D 2.6.24-05749-g8af03e7-dirty #19
[ 1570.973159]  [<c011e1a6>] __might_sleep+0xc6/0xf0
[ 1570.973224]  [<c06b2c99>] down_read+0x19/0x80
[ 1570.973295]  [<c013a7fd>] ? hrtimer_try_to_cancel+0x3d/0x80
[ 1570.973396]  [<c0125a27>] exit_mm+0x27/0xd0
[ 1570.973467]  [<c01272f3>] do_exit+0x133/0x2e0
[ 1570.973529]  [<c010611c>] die+0x13c/0x140
[ 1570.973590]  [<c0135197>] ? search_exception_tables+0x27/0x30
[ 1570.973993]  [<c01061b1>] do_trap+0x91/0xc0
[ 1570.974054]  [<c0106440>] ? do_invalid_op+0x0/0xa0
[ 1570.974133]  [<c01064c9>] do_invalid_op+0x89/0xa0
[ 1570.974195]  [<c02266b9>] ? ext4_mb_release_inode_pa+0x169/0x1a0
[ 1570.974290]  [<c012007b>] ? account_system_time+0x9b/0xd0
[ 1570.974370]  [<c01245de>] ? vprintk+0x1ce/0x360
[ 1570.974465]  [<c06b4492>] error_code+0x6a/0x70
[ 1570.974531]  [<c012007b>] ? account_system_time+0x9b/0xd0
[ 1570.974626]  [<c02266b9>] ? ext4_mb_release_inode_pa+0x169/0x1a0
[ 1570.974707]  [<c020e3a4>] ? read_block_bitmap+0x54/0x120
[ 1570.974803]  [<c022bd24>] ? ext4_mb_discard_inode_preallocations+0x124/0x300
[ 1570.975151]  [<c022bda5>] ext4_mb_discard_inode_preallocations+0x1a5/0x300
[ 1570.975221]  [<c0223577>] ext4_ext_get_blocks+0x3a7/0x4b0
[ 1570.975289]  [<c0213928>] ext4_get_blocks_wrap+0xe8/0x130
[ 1570.975352]  [<c0213bce>] ext4_get_block+0x7e/0xf0
[ 1570.975413]  [<c019d7ba>] __block_prepare_write+0x17a/0x3a0
[ 1570.975479]  [<c019da68>] block_write_begin+0x48/0xe0
[ 1570.975541]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.975635]  [<c0215127>] ext4_write_begin+0xb7/0x190
[ 1570.975697]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.975776]  [<c01557e9>] generic_perform_write+0xa9/0x190
[ 1570.975838]  [<c01575bd>] generic_file_buffered_write+0x6d/0x130
[ 1570.975944]  [<c01578c1>] __generic_file_aio_write_nolock+0x241/0x550
[ 1570.976007]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.976105]  [<c0157c2c>] generic_file_aio_write+0x5c/0xd0
[ 1570.976166]  [<c015ab0d>] ? free_one_page+0x1ed/0x220
[ 1570.976247]  [<c0210410>] ext4_file_write+0x50/0x160
[ 1570.976308]  [<c017b11d>] do_sync_write+0xcd/0x110
[ 1570.976372]  [<c01096f9>] ? native_sched_clock+0x69/0xc0
[ 1570.976470]  [<c01373c0>] ? autoremove_wake_function+0x0/0x50
[ 1570.976567]  [<c01070e5>] ? do_softirq+0x55/0xd0
[ 1570.976662]  [<c01050d3>] ? restore_nocheck+0x12/0x15
[ 1570.976741]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.976837]  [<c017b959>] vfs_write+0x99/0x130
[ 1570.976933]  [<c017b050>] ? do_sync_write+0x0/0x110
[ 1570.977014]  [<c017c048>] sys_pwrite64+0x68/0x70
[ 1570.977075]  [<c0104fea>] sysenter_past_esp+0x5f/0xa5
[ 1570.977137]  =======================
[ 1570.977400] BUG: scheduling while atomic: fstest/6629/0x00000002
[ 1570.977426] INFO: lockdep is turned off.
[ 1570.977468] Pid: 6629, comm: fstest Tainted: G      D 2.6.24-05749-g8af03e7-dirty #19
[ 1570.977494]  [<c0120125>] __schedule_bug+0x75/0x80
[ 1570.977557]  [<c06b1db5>] schedule+0x2d5/0x3a0
[ 1570.977621]  [<c06b3325>] rwsem_down_failed_common+0x75/0x170
[ 1570.977684]  [<c0142fde>] ? __lock_contended+0xbe/0x110
[ 1570.977780]  [<c06b343d>] rwsem_down_write_failed+0x1d/0x30
[ 1570.977842]  [<c06b34ca>] call_rwsem_down_write_failed+0x6/0x8
[ 1570.977933]  [<c06b2d81>] ? down_write+0x81/0x90
[ 1570.978013]  [<c021058c>] ? ext4_release_file+0x6c/0x80
[ 1570.978108]  [<c021058c>] ext4_release_file+0x6c/0x80
[ 1570.978168]  [<c017c484>] __fput+0xb4/0x1b0
[ 1570.978231]  [<c017c788>] fput+0x18/0x20
[ 1570.978291]  [<c0179827>] filp_close+0x47/0x70
[ 1570.978352]  [<c0125dd0>] close_files+0x70/0x80
[ 1570.978415]  [<c0125e0a>] put_files_struct+0x2a/0x60
[ 1570.978477]  [<c0125e80>] __exit_files+0x40/0x50
[ 1570.978538]  [<c0127301>] do_exit+0x141/0x2e0
[ 1570.978600]  [<c010611c>] die+0x13c/0x140
[ 1570.978661]  [<c0135197>] ? search_exception_tables+0x27/0x30
[ 1570.978741]  [<c01061b1>] do_trap+0x91/0xc0
[ 1570.978803]  [<c0106440>] ? do_invalid_op+0x0/0xa0
[ 1570.979039]  [<c01064c9>] do_invalid_op+0x89/0xa0
[ 1570.979104]  [<c02266b9>] ? ext4_mb_release_inode_pa+0x169/0x1a0
[ 1570.979185]  [<c012007b>] ? account_system_time+0x9b/0xd0
[ 1570.979280]  [<c01245de>] ? vprintk+0x1ce/0x360
[ 1570.979360]  [<c06b4492>] error_code+0x6a/0x70
[ 1570.979423]  [<c012007b>] ? account_system_time+0x9b/0xd0
[ 1570.979519]  [<c02266b9>] ? ext4_mb_release_inode_pa+0x169/0x1a0
[ 1570.979600]  [<c020e3a4>] ? read_block_bitmap+0x54/0x120
[ 1570.979700]  [<c022bd24>] ? ext4_mb_discard_inode_preallocations+0x124/0x300
[ 1570.979797]  [<c022bda5>] ext4_mb_discard_inode_preallocations+0x1a5/0x300
[ 1570.979861]  [<c0223577>] ext4_ext_get_blocks+0x3a7/0x4b0
[ 1570.979964]  [<c0213928>] ext4_get_blocks_wrap+0xe8/0x130
[ 1570.980026]  [<c0213bce>] ext4_get_block+0x7e/0xf0
[ 1570.980087]  [<c019d7ba>] __block_prepare_write+0x17a/0x3a0
[ 1570.980153]  [<c019da68>] block_write_begin+0x48/0xe0
[ 1570.980215]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.980309]  [<c0215127>] ext4_write_begin+0xb7/0x190
[ 1570.980371]  [<c0213b50>] ? ext4_get_block+0x0/0xf0
[ 1570.980450]  [<c01557e9>] generic_perform_write+0xa9/0x190
[ 1570.980513]  [<c01575bd>] generic_file_buffered_write+0x6d/0x130
[ 1570.980576]  [<c01578c1>] __generic_file_aio_write_nolock+0x241/0x550
[ 1570.980639]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.980735]  [<c0157c2c>] generic_file_aio_write+0x5c/0xd0
[ 1570.980796]  [<c015ab0d>] ? free_one_page+0x1ed/0x220
[ 1570.980932]  [<c0210410>] ext4_file_write+0x50/0x160
[ 1570.980995]  [<c017b11d>] do_sync_write+0xcd/0x110
[ 1570.981058]  [<c01096f9>] ? native_sched_clock+0x69/0xc0
[ 1570.981142]  [<c01373c0>] ? autoremove_wake_function+0x0/0x50
[ 1570.981238]  [<c01070e5>] ? do_softirq+0x55/0xd0
[ 1570.981317]  [<c01050d3>] ? restore_nocheck+0x12/0x15
[ 1570.981410]  [<c0144b44>] ? trace_hardirqs_on+0xc4/0x150
[ 1570.981491]  [<c017b959>] vfs_write+0x99/0x130
[ 1570.981552]  [<c017b050>] ? do_sync_write+0x0/0x110
[ 1570.981646]  [<c017c048>] sys_pwrite64+0x68/0x70
[ 1570.981708]  [<c0104fea>] sysenter_past_esp+0x5f/0xa5
[ 1570.981769]  =======================
