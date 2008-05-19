From: Solofo.Ramangalahy@bull.net
Subject: Re: Soft lockups in mballoc code
Date: Mon, 19 May 2008 16:47:56 +0200
Message-ID: <18481.37660.871969.813688@frecb006361.adech.frec.bull.fr>
References: <25037.1210612895@alphaville.zko.hp.com>
	<1210785517.3657.42.camel@localhost.localdomain>
	<27364.1210787137@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35040 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYESOrd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 10:47:33 -0400
In-Reply-To: <27364.1210787137@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos writes:
 > In the meantime, I wanted to let
 > you know that I tried the (stable) 2.6.25.3 kernel on x86-64 and encountered the
 > same problem, but I also tried it on an IA64 system (again with the
 > 2.6.25.3 kernel) and did *not* encounter the problem.

Also reproduced (or similar) on 2.6.25.4.
I will try to get a more focused test case...

-- 
solofo

BUG: soft lockup - CPU#0 stuck for 61s! [fsstress:16194]
CPU 0:
Modules linked in: ext4dev jbd2 crc16
Pid: 16194, comm: fsstress Not tainted 2.6.25.4 #1
RIP: 0010:[<ffffffff8802d5b7>]  [<ffffffff8802d5b7>] :ext4dev:ext4_mb_new_blocks+0x8e4/0x154d
RSP: 0018:ffff81011c1d97a8  EFLAGS: 00000202
RAX: 00000000ffffffff RBX: ffff810112de5c60 RCX: 0000000000000007
RDX: ffff81012d7789c0 RSI: 0000000000000008 RDI: ffffe200070fb180
RBP: ffff81011c1d9888 R08: 0000000000000003 R09: d37a6f4de9bd37a7
R10: 0000000000000173 R11: ffff810127fd8000 R12: ffff81012d7789c0
R13: ffff8100807c1000 R14: ffff81011c1d8000 R15: ffffffff808a6748
FS:  00007fcfcd3f46e0(0000) GS:ffffffff80782000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffd5409fa8 CR3: 00000001241db000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8802d571>] ? :ext4dev:ext4_mb_new_blocks+0x89e/0x154d
 [<ffffffff802821cd>] ? __kmalloc+0x12e/0x159
 [<ffffffff880267a1>] ? :ext4dev:ext4_ext_find_extent+0x71/0x255
 [<ffffffff88028c9c>] ? :ext4dev:ext4_ext_get_blocks+0x77a/0x962
 [<ffffffff8035a6bd>] ? __down_write_trylock+0x15/0x44
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff8801a703>] ? :ext4dev:ext4_get_blocks_wrap+0xed/0x135
 [<ffffffff8801a967>] ? :ext4dev:ext4_get_block+0xa3/0xe2
 [<ffffffff802ab900>] ? __blockdev_direct_IO+0x544/0xa0b
 [<ffffffff8801c450>] ? :ext4dev:ext4_direct_IO+0x11e/0x1b0
 [<ffffffff8801a8c4>] ? :ext4dev:ext4_get_block+0x0/0xe2
 [<ffffffff8025f516>] ? generic_file_direct_IO+0xcd/0x103
 [<ffffffff802a2157>] ? __mark_inode_dirty+0xe2/0x18b
 [<ffffffff8025f5ac>] ? generic_file_direct_write+0x60/0xfd
 [<ffffffff8025ff14>] ? __generic_file_aio_write_nolock+0x28f/0x37a
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff80260065>] ? generic_file_aio_write+0x66/0xc6
 [<ffffffff880178d8>] ? :ext4dev:ext4_file_write+0xa0/0x125
 [<ffffffff80286da0>] ? do_sync_write+0xd1/0x118
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff80240b96>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8057c4a1>] ? __mutex_unlock_slowpath+0xfe/0x109
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff802874f1>] ? vfs_write+0xad/0x136
 [<ffffffff80287a28>] ? sys_write+0x45/0x6e
 [<ffffffff8020af7b>] ? system_call_after_swapgs+0x7b/0x80

BUG: soft lockup - CPU#2 stuck for 61s! [fsstress:16438]
CPU 2:
Modules linked in: ext4dev jbd2 crc16
Pid: 16438, comm: fsstress Not tainted 2.6.25.4 #1
RIP: 0010:[<ffffffff8802d5b4>]  [<ffffffff8802d5b4>] :ext4dev:ext4_mb_new_blocks+0x8e1/0x154d
RSP: 0018:ffff8101211917a8  EFLAGS: 00000202
RAX: 00000000ffffffff RBX: ffff81010246d7c8 RCX: 0000000000000007
RDX: ffff81012d7789c0 RSI: 0000000000000008 RDI: ffffe200070fb180
RBP: ffff810121191888 R08: 0000000000000003 R09: d37a6f4de9bd37a7
R10: 0000000000000173 R11: ffff810127fd8000 R12: ffff81012d7789c0
R13: ffff810080893000 R14: ffff810121190000 R15: ffffffff808a6748
FS:  00007fcfcd3f46e0(0000) GS:ffff81012faeee40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffd5409fa8 CR3: 0000000121194000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8802d571>] ? :ext4dev:ext4_mb_new_blocks+0x89e/0x154d
 [<ffffffff88028c9c>] ? :ext4dev:ext4_ext_get_blocks+0x77a/0x962
 [<ffffffff8035a6bd>] ? __down_write_trylock+0x15/0x44
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff8801a703>] ? :ext4dev:ext4_get_blocks_wrap+0xed/0x135
 [<ffffffff8801a967>] ? :ext4dev:ext4_get_block+0xa3/0xe2
 [<ffffffff802ab900>] ? __blockdev_direct_IO+0x544/0xa0b
 [<ffffffff8801c450>] ? :ext4dev:ext4_direct_IO+0x11e/0x1b0
 [<ffffffff8801a8c4>] ? :ext4dev:ext4_get_block+0x0/0xe2
 [<ffffffff8025f516>] ? generic_file_direct_IO+0xcd/0x103
 [<ffffffff802a2157>] ? __mark_inode_dirty+0xe2/0x18b
 [<ffffffff8025f5ac>] ? generic_file_direct_write+0x60/0xfd
 [<ffffffff8025ff14>] ? __generic_file_aio_write_nolock+0x28f/0x37a
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff80260065>] ? generic_file_aio_write+0x66/0xc6
 [<ffffffff880178d8>] ? :ext4dev:ext4_file_write+0xa0/0x125
 [<ffffffff80286da0>] ? do_sync_write+0xd1/0x118
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff80240b96>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8057c4a1>] ? __mutex_unlock_slowpath+0xfe/0x109
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff802874f1>] ? vfs_write+0xad/0x136
 [<ffffffff80287a28>] ? sys_write+0x45/0x6e
 [<ffffffff8020af7b>] ? system_call_after_swapgs+0x7b/0x80

BUG: soft lockup - CPU#3 stuck for 61s! [fsstress:15776]
CPU 3:
Modules linked in: ext4dev jbd2 crc16
Pid: 15776, comm: fsstress Not tainted 2.6.25.4 #1
RIP: 0010:[<ffffffff8802d5b7>]  [<ffffffff8802d5b7>] :ext4dev:ext4_mb_new_blocks+0x8e4/0x154d
RSP: 0018:ffff8101240457a8  EFLAGS: 00000202
RAX: 00000000ffffffff RBX: ffff810112de5bb8 RCX: 0000000000000007
RDX: ffff81012d7789c0 RSI: 0000000000000008 RDI: ffffe200070fb180
RBP: ffff810124045888 R08: 0000000000000003 R09: d37a6f4de9bd37a7
R10: 0000000000000173 R11: ffff810127fd8000 R12: ffff81012d7789c0
R13: ffff8100808fc000 R14: ffff810124044000 R15: ffffffff808a6748
FS:  00007fcfcd3f46e0(0000) GS:ffff81012faee5c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fcfcd3f2000 CR3: 00000001164f5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8802d571>] ? :ext4dev:ext4_mb_new_blocks+0x89e/0x154d
 [<ffffffff880268b4>] ? :ext4dev:ext4_ext_find_extent+0x184/0x255
 [<ffffffff88028c9c>] ? :ext4dev:ext4_ext_get_blocks+0x77a/0x962
 [<ffffffff8035a6bd>] ? __down_write_trylock+0x15/0x44
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff8801a703>] ? :ext4dev:ext4_get_blocks_wrap+0xed/0x135
 [<ffffffff8801a967>] ? :ext4dev:ext4_get_block+0xa3/0xe2
 [<ffffffff802ab900>] ? __blockdev_direct_IO+0x544/0xa0b
 [<ffffffff8801c450>] ? :ext4dev:ext4_direct_IO+0x11e/0x1b0
 [<ffffffff8801a8c4>] ? :ext4dev:ext4_get_block+0x0/0xe2
 [<ffffffff8025f516>] ? generic_file_direct_IO+0xcd/0x103
 [<ffffffff802a2157>] ? __mark_inode_dirty+0xe2/0x18b
 [<ffffffff8025f5ac>] ? generic_file_direct_write+0x60/0xfd
 [<ffffffff8025ff14>] ? __generic_file_aio_write_nolock+0x28f/0x37a
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff8026a2f6>] ? zone_statistics+0x41/0x95
 [<ffffffff80260065>] ? generic_file_aio_write+0x66/0xc6
 [<ffffffff880178d8>] ? :ext4dev:ext4_file_write+0xa0/0x125
 [<ffffffff80286da0>] ? do_sync_write+0xd1/0x118
 [<ffffffff8026e5aa>] ? handle_mm_fault+0x2a9/0x6dc
 [<ffffffff80240b96>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8026e9c0>] ? handle_mm_fault+0x6bf/0x6dc
 [<ffffffff8035a6ff>] ? __up_read+0x13/0x8a
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff802874f1>] ? vfs_write+0xad/0x136
 [<ffffffff80287a28>] ? sys_write+0x45/0x6e
 [<ffffffff8020af7b>] ? system_call_after_swapgs+0x7b/0x80

BUG: soft lockup - CPU#1 stuck for 61s! [fsstress:15786]
CPU 1:
Modules linked in: ext4dev jbd2 crc16
Pid: 15786, comm: fsstress Not tainted 2.6.25.4 #1
RIP: 0010:[<ffffffff8802d5b7>]  [<ffffffff8802d5b7>] :ext4dev:ext4_mb_new_blocks+0x8e4/0x154d
RSP: 0018:ffff810122c0b6e8  EFLAGS: 00000202
RAX: 00000000ffffffff RBX: ffff810112de5d08 RCX: 0000000000000007
RDX: ffff81012d7789c0 RSI: 0000000000000008 RDI: ffffe200070fb180
RBP: ffff810122c0b7c8 R08: 0000000000000003 R09: d37a6f4de9bd37a7
R10: 0000000000000173 R11: ffff810127fd8000 R12: ffff81012d7789c0
R13: ffff81008082a000 R14: ffff810122c0a000 R15: ffffffff808a6748
FS:  00007fcfcd3f46e0(0000) GS:ffff81012fc08bc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffd5409c88 CR3: 000000010d41e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8802d571>] ? :ext4dev:ext4_mb_new_blocks+0x89e/0x154d
 [<ffffffff802821cd>] ? __kmalloc+0x12e/0x159
 [<ffffffff880267a1>] ? :ext4dev:ext4_ext_find_extent+0x71/0x255
 [<ffffffff88028c9c>] ? :ext4dev:ext4_ext_get_blocks+0x77a/0x962
 [<ffffffff8035a6bd>] ? __down_write_trylock+0x15/0x44
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff8801a703>] ? :ext4dev:ext4_get_blocks_wrap+0xed/0x135
 [<ffffffff8801a967>] ? :ext4dev:ext4_get_block+0xa3/0xe2
 [<ffffffff802a6a47>] ? __block_prepare_write+0x1bb/0x3ca
 [<ffffffff8801a8c4>] ? :ext4dev:ext4_get_block+0x0/0xe2
 [<ffffffff880041b3>] ? :jbd2:jbd2_journal_start+0xe5/0x108
 [<ffffffff802a6cf3>] ? block_write_begin+0x78/0xc9
 [<ffffffff8801bf04>] ? :ext4dev:ext4_write_begin+0xeb/0x1aa
 [<ffffffff8801a8c4>] ? :ext4dev:ext4_get_block+0x0/0xe2
 [<ffffffff8025f799>] ? generic_file_buffered_write+0x150/0x63c
 [<ffffffff88003612>] ? :jbd2:jbd2_journal_stop+0x28f/0x29f
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8025ffcb>] ? __generic_file_aio_write_nolock+0x346/0x37a
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff80260065>] ? generic_file_aio_write+0x66/0xc6
 [<ffffffff880178d8>] ? :ext4dev:ext4_file_write+0xa0/0x125
 [<ffffffff80286da0>] ? do_sync_write+0xd1/0x118
 [<ffffffff8024a891>] ? mark_held_locks+0x58/0x72
 [<ffffffff80240b96>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff80210ee3>] ? native_sched_clock+0x44/0x5d
 [<ffffffff8057c4a1>] ? __mutex_unlock_slowpath+0xfe/0x109
 [<ffffffff8024aa3c>] ? trace_hardirqs_on+0xfa/0x125
 [<ffffffff802874f1>] ? vfs_write+0xad/0x136
 [<ffffffff80287a28>] ? sys_write+0x45/0x6e
 [<ffffffff8020af7b>] ? system_call_after_swapgs+0x7b/0x80

