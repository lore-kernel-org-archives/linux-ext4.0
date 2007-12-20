From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: BUG: soft lockup - CPU#0 stuck for 11s! [fsstress:5534]
Date: Thu, 20 Dec 2007 20:02:42 +0530
Message-ID: <20071220143242.GB6953@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38121 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbXLTPCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Dec 2007 10:02:08 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBKEWR2L015797
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 01:32:27 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBKEaOdU231482
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 01:36:24 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBKEWltn008825
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 01:32:48 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am seeing this with the patch queue. I can reproduce this on x86 and
powerpc. I see the file system full when this happens. The same happens even
without delalloc enabled.


Any idea what i should try now. It is not spinning on the spin lock. I had the
spin lock debug enabled and added similar check for ext4_lock_group also.

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 7113a32..9833376 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -9,6 +9,7 @@
  */
 static inline void bit_spin_lock(int bitnum, unsigned long *addr)
 {
+       unsigned int stuck = 0xffffffff;
        /*
         * Assuming the lock is uncontended, this never enters
         * the body of the outer loop. If it is contended, then
@@ -21,6 +22,11 @@ static inline void bit_spin_lock(int bitnum, unsigned long *addr)
        while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
                while (test_bit(bitnum, addr)) {
                        preempt_enable();
+                       if (!--stuck) {
+                               printk("bit_spin_lock(%p) ", __builtin_return_address(0));
+                               dump_stack();
+                               stuck = 0xffffffff;
+                       }
                        cpu_relax();
                        preempt_disable();
                }
diff --git a/kernel/sched.c b/kernel/sched.c

The kernels are non preempt and I guess we are getting stuck in the kernel
trying to allocate new blocks.

-aneesh


BUG: soft lockup - CPU#0 stuck for 11s! [fsstress:5534]
NIP: c0000000001a98d8 LR: c0000000001a98fc CTR: c0000000001900ec
REGS: c0000000ed84ab30 TRAP: 0901   Not tainted  (2.6.24-rc5-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24008428  XER: 00000020
TASK = c0000000ed846000[5534] 'fsstress' THREAD: c0000000ed848000 CPU: 0
GPR00: 0000000000000002 c0000000ed84adb0 c000000000604760 c0000000e4105cc8 
GPR04: 000000000000002b c0000000ed84ae30 0000000000000015 c000000000733c98 
GPR08: 0000000000000000 c0000000fc9905a0 0000000000000000 0000000000000000 
GPR12: 0000000024002428 c000000000542980 
NIP [c0000000001a98d8] .ext4_mb_discard_preallocations+0x1e4/0x600
LR [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600
Call Trace:
[c0000000ed84adb0] [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600 (unreliable)
[c0000000ed84afa0] [c0000000001ab6d8] .ext4_mb_new_blocks+0x18a0/0x19a4
[c0000000ed84b220] [c0000000001a14d8] .ext4_ext_get_blocks+0x970/0xb5c
[c0000000ed84b3b0] [c00000000018ec5c] .ext4_get_block+0x138/0x1c0
[c0000000ed84b470] [c0000000001163a0] .__block_prepare_write+0x1f8/0x4c8
[c0000000ed84b580] [c0000000001168b8] .block_write_begin+0xc4/0x160
[c0000000ed84b650] [c00000000018c4e8] .ext4_write_begin+0x12c/0x24c
[c0000000ed84b750] [c0000000000aa9b0] .generic_file_buffered_write+0x174/0x760
[c0000000ed84b8a0] [c0000000000ab684] .__generic_file_aio_write_nolock+0x3ec/0x444
[c0000000ed84b9e0] [c0000000000ab75c] .generic_file_aio_write+0x80/0x114
[c0000000ed84baa0] [c000000000188634] .ext4_file_write+0xc8/0x190
[c0000000ed84bb50] [c0000000000e3484] .do_sync_write+0xd0/0x130
[c0000000ed84bcf0] [c0000000000e35ec] .vfs_write+0x108/0x1c8
[c0000000ed84bd90] [c0000000000e3784] .sys_write+0x4c/0x8c
[c0000000ed84be30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
794bffe3 41a2002c e8090000 780affe3 41820018 7c210b78 7c421378 e8090000 
780bffe3 4bffffec 38000002 4bffffc0 <e93d0020> 3b9d0020 3be9fff0 7fa9e000 
BUG: soft lockup - CPU#3 stuck for 11s! [fsstress:6291]
NIP: c0000000001a98c0 LR: c0000000001a98fc CTR: c0000000001900ec
REGS: c0000000ebecf0e0 TRAP: 0901   Not tainted  (2.6.24-rc5-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44008428  XER: 00000008
TASK = c0000000ebebc820[6291] 'fsstress' THREAD: c0000000ebecc000 CPU: 3
GPR00: 0000000000000002 c0000000ebecf360 c000000000604760 c0000000e4105cc8 
GPR04: 000000000000002b c0000000ebecf3e0 0000000000000015 c000000000748c98 
GPR08: 0000000000000000 c0000000fc9905a0 0000000000000001 0000000000000001 
GPR12: 0000000024002488 c000000000543100 
NIP [c0000000001a98c0] .ext4_mb_discard_preallocations+0x1cc/0x600
LR [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600
Call Trace:
[c0000000ebecf360] [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600 (unreliable)
[c0000000ebecf550] [c0000000001ab6d8] .ext4_mb_new_blocks+0x18a0/0x19a4
[c0000000ebecf7d0] [c0000000001a14d8] .ext4_ext_get_blocks+0x970/0xb5c
[c0000000ebecf960] [c00000000018fccc] .ext4_getblk+0xc4/0x2a4
[c0000000ebecfa80] [c00000000018fed0] .ext4_bread+0x24/0xec
[c0000000ebecfb20] [c0000000001941a4] .ext4_mkdir+0x1fc/0x490
[c0000000ebecfbf0] [c0000000000f181c] .vfs_mkdir+0x134/0x1d0
[c0000000ebecfc90] [c0000000000f1968] .sys_mkdirat+0xb0/0x10c
[c0000000ebecfdc0] [c00000000001721c] .compat_sys_mkdir+0x14/0x28
[c0000000ebecfe30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
7d29582a 7d4048a8 7d4b0378 7d6049ad 40a2fff4 4c00012c 794bffe3 41a2002c 
e8090000 780affe3 41820018 7c210b78 <7c421378> e8090000 780bffe3 4bffffec 
BUG: soft lockup - CPU#2 stuck for 11s! [fsstress:5738]
NIP: c0000000001a98c0 LR: c0000000001a98fc CTR: c0000000001900ec
REGS: c0000000e59eab30 TRAP: 0901   Not tainted  (2.6.24-rc5-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44008428  XER: 00000018
TASK = c0000000e59e6000[5738] 'fsstress' THREAD: c0000000e59e8000 CPU: 2
GPR00: 0000000000000002 c0000000e59eadb0 c000000000604760 c0000000e4105cc8 
GPR04: 000000000000002b c0000000e59eae30 0000000000000015 c000000000741c98 
GPR08: 0000000000000000 c0000000fc9905a0 0000000000000001 0000000000000001 
GPR12: 0000000024002428 c000000000542e80 
NIP [c0000000001a98c0] .ext4_mb_discard_preallocations+0x1cc/0x600
LR [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600
Call Trace:
[c0000000e59eadb0] [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600 (unreliable)
[c0000000e59eafa0] [c0000000001ab6d8] .ext4_mb_new_blocks+0x18a0/0x19a4
[c0000000e59eb220] [c0000000001a14d8] .ext4_ext_get_blocks+0x970/0xb5c
[c0000000e59eb3b0] [c00000000018ec5c] .ext4_get_block+0x138/0x1c0
[c0000000e59eb470] [c0000000001163a0] .__block_prepare_write+0x1f8/0x4c8
[c0000000e59eb580] [c0000000001168b8] .block_write_begin+0xc4/0x160
[c0000000e59eb650] [c00000000018c4e8] .ext4_write_begin+0x12c/0x24c
[c0000000e59eb750] [c0000000000aa9b0] .generic_file_buffered_write+0x174/0x760
[c0000000e59eb8a0] [c0000000000ab684] .__generic_file_aio_write_nolock+0x3ec/0x444
[c0000000e59eb9e0] [c0000000000ab75c] .generic_file_aio_write+0x80/0x114
[c0000000e59ebaa0] [c000000000188634] .ext4_file_write+0xc8/0x190
[c0000000e59ebb50] [c0000000000e3484] .do_sync_write+0xd0/0x130
[c0000000e59ebcf0] [c0000000000e35ec] .vfs_write+0x108/0x1c8
[c0000000e59ebd90] [c0000000000e3784] .sys_write+0x4c/0x8c
[c0000000e59ebe30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
7d29582a 7d4048a8 7d4b0378 7d6049ad 40a2fff4 4c00012c 794bffe3 41a2002c 
e8090000 780affe3 41820018 7c210b78 <7c421378> e8090000 780bffe3 4bffffec 
BUG: soft lockup - CPU#1 stuck for 11s! [fsstress:5942]
NIP: c0000000001a98a0 LR: c0000000001a98fc CTR: c00000000007f95c
REGS: c0000000ebc26b30 TRAP: 0901   Not tainted  (2.6.24-rc5-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24008428  XER: 00000010
TASK = c0000000ebc22000[5942] 'fsstress' THREAD: c0000000ebc24000 CPU: 1
GPR00: 0000000000000002 c0000000ebc26db0 c000000000604760 c0000000e4105cc8 
GPR04: 000000000000002b c0000000ebc26e30 0000000000000015 c00000000073ac98 
GPR08: 0000000000000000 c0000000fc9905a0 0000000000000002 0000000000000002 
GPR12: 0000000024002428 c000000000542c00 
NIP [c0000000001a98a0] .ext4_mb_discard_preallocations+0x1ac/0x600
LR [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600
Call Trace:
[c0000000ebc26db0] [c0000000001a98fc] .ext4_mb_discard_preallocations+0x208/0x600 (unreliable)
[c0000000ebc26fa0] [c0000000001ab6d8] .ext4_mb_new_blocks+0x18a0/0x19a4
[c0000000ebc27220] [c0000000001a14d8] .ext4_ext_get_blocks+0x970/0xb5c
[c0000000ebc273b0] [c00000000018ec5c] .ext4_get_block+0x138/0x1c0
[c0000000ebc27470] [c0000000001163a0] .__block_prepare_write+0x1f8/0x4c8
[c0000000ebc27580] [c0000000001168b8] .block_write_begin+0xc4/0x160
[c0000000ebc27650] [c00000000018c4e8] .ext4_write_begin+0x12c/0x24c
[c0000000ebc27750] [c0000000000aa9b0] .generic_file_buffered_write+0x174/0x760
[c0000000ebc278a0] [c0000000000ab610] .__generic_file_aio_write_nolock+0x378/0x444
[c0000000ebc279e0] [c0000000000ab75c] .generic_file_aio_write+0x80/0x114
[c0000000ebc27aa0] [c000000000188634] .ext4_file_write+0xc8/0x190
[c0000000ebc27b50] [c0000000000e3484] .do_sync_write+0xd0/0x130
[c0000000ebc27cf0] [c0000000000e35ec] .vfs_write+0x108/0x1c8
[c0000000ebc27d90] [c0000000000e3784] .sys_write+0x4c/0x8c
[c0000000ebc27e30] [c00000000000872c] syscall_exit+0x0/0x40
Instruction dump:
e92a0030 e94a4208 7f6b5c36 3929ffff 796b1f24 7f694838 7d6b502a 79291f24 
7d29582a 7d4048a8 7d4b0378 7d6049ad <40a2fff4> 4c00012c 794bffe3 41a2002c 
-- 0:conmux-control -- time-stamp -- Dec/20/07  2:53:52 --
-- 0:conmux-control -- time-stamp -- Dec/20/07  3:01:55 --
(bot:conmon-payload) disconnected



x86 gives me this stack.
-----------------------

BUG: soft lockup - CPU#6 stuck for 11s! [fsstress:14048]

Pid: 14048, comm: fsstress Not tainted (2.6.24-rc5-autokern1 #1)
EIP: 0060:[<c01d2f1c>] EFLAGS: 00000282 CPU: 6
EIP is at ext4_mb_discard_preallocations+0x13a/0x439
EAX: 00000002 EBX: dbd50180 ECX: 00000007 EDX: ffffffba
ESI: e44599c8 EDI: dbd50194 EBP: e44599b0 ESP: e419fb5c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 080eae1c CR3: 373cd000 CR4: 000006b0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c01be636>] ext4_mark_iloc_dirty+0x382/0x3dd
 [<c01be7df>] ext4_mark_inode_dirty+0x14e/0x15e
 [<c01cfe12>] ext4_mb_store_history+0x14b/0x153
 [<c01d51b9>] ext4_mb_new_blocks+0x17de/0x1891
 [<c01ce529>] __ext4_journal_dirty_metadata+0x15/0x3c
 [<c01be7df>] ext4_mark_inode_dirty+0x14e/0x15e
 [<c0170f1b>] __find_get_block+0x17b/0x185
 [<c01cbdc8>] ext4_ext_find_extent+0x5b/0x217
 [<c01cd44c>] ext4_ext_get_blocks+0x74d/0x924
 [<c01be636>] ext4_mark_iloc_dirty+0x382/0x3dd
 [<c01c086b>] ext4_get_blocks_wrap+0xc7/0x109
 [<c01c14e6>] ext4_getblk+0x4f/0x16f
 [<c01c161f>] ext4_bread+0x19/0x72
 [<c01c4f32>] ext4_mkdir+0x150/0x2d2
 [<c01d72d4>] ext4_permission+0x0/0xa
 [<c015cccd>] vfs_mkdir+0x8f/0xd3
 [<c015cd99>] sys_mkdirat+0x88/0xbf
 [<c0154f4b>] __fput+0x116/0x140
 [<c01655c1>] mntput_no_expire+0x11/0x63
 [<c0152cf4>] filp_close+0x4f/0x56
 [<c015cdef>] sys_mkdir+0x1f/0x23
 [<c01024ba>] sysenter_past_esp+0x5f/0x85
 =======================
BUG: soft lockup - CPU#7 stuck for 11s! [fsstress:14017]

Pid: 14017, comm: fsstress Not tainted (2.6.24-rc5-autokern1 #1)
EIP: 0060:[<c01d2f32>] EFLAGS: 00000246 CPU: 7
EIP is at ext4_mb_discard_preallocations+0x150/0x439
EAX: dbd50180 EBX: e44599b8 ECX: 00000007 EDX: ffffffff
ESI: e44599c8 EDI: dbd50194 EBP: e44599b0 ESP: f66737cc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7f02840 CR3: 36443000 CR4: 000006b0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c01be636>] ext4_mark_iloc_dirty+0x382/0x3dd
 [<c01be7df>] ext4_mark_inode_dirty+0x14e/0x15e
 [<c0170f1b>] __find_get_block+0x17b/0x185
 [<c01d000c>] ext4_mb_init+0x1f2/0x85a
 [<c01d51b9>] ext4_mb_new_blocks+0x17de/0x1891
 [<c01ce529>] __ext4_journal_dirty_metadata+0x15/0x3c
 [<c01be7df>] ext4_mark_inode_dirty+0x14e/0x15e
 [<c01cfe12>] ext4_mb_store_history+0x14b/0x153
 [<c01c63b1>] __ext4_journal_stop+0x19/0x34
 [<c0170f1b>] __find_get_block+0x17b/0x185
 [<c01cbed4>] ext4_ext_find_extent+0x167/0x217
 [<c01cd44c>] ext4_ext_get_blocks+0x74d/0x924
 [<c01c086b>] ext4_get_blocks_wrap+0xc7/0x109
 [<c01c1388>] ext4_da_get_block_write+0x6f/0x17e
 [<c01c1319>] ext4_da_get_block_write+0x0/0x17e
 [<c0174a9e>] mpage_da_map_blocks+0x6d/0x230
 [<c01cb78e>] __ext4_ext_check_header+0x77/0xfa
 [<c0170f1b>] __find_get_block+0x17b/0x185
 [<c01cb78e>] __ext4_ext_check_header+0x77/0xfa
 [<c0174cb5>] mpage_add_bh_to_extent+0x54/0x6b
 [<c017592b>] __mpage_da_writepage+0xb1/0xc6
 [<c0376e5c>] _read_unlock_irq+0x5/0x7
 [<c0136ce7>] find_get_pages_tag+0x76/0x80
 [<c013d10a>] write_cache_pages+0x169/0x280
 [<c017587a>] __mpage_da_writepage+0x0/0xc6
 [<c0175858>] mpage_da_writepages+0x5d/0x7f
 [<c01c0827>] ext4_get_blocks_wrap+0x83/0x109
 [<c01c12ce>] ext4_da_get_block_prep+0x4c/0x97
 [<c01c1319>] ext4_da_get_block_write+0x0/0x17e
 [<c01bd9db>] ext4_da_writepages+0x0/0xa
 [<c013d265>] do_writepages+0x20/0x33
 [<c0136ba6>] __filemap_fdatawrite_range+0x65/0x70
 [<c0137ae6>] filemap_fdatawrite+0x23/0x27
 [<c0137afb>] filemap_write_and_wait+0x11/0x29
 [<c01384a8>] generic_file_buffered_write+0x57a/0x5a0
 [<c011c05c>] current_fs_time+0x13/0x15
 [<c0139437>] __generic_file_aio_write_nolock+0x3c3/0x4b5
 [<c0139581>] generic_file_aio_write+0x58/0xb6
 [<c01bc5a4>] ext4_file_write+0xb4/0x124
 [<c0153eb8>] do_sync_write+0xc7/0x10a
 [<c0127898>] autoremove_wake_function+0x0/0x33
 [<c0156e44>] sys_fstat64+0x1e/0x23
 [<c0153df1>] do_sync_write+0x0/0x10a
 [<c0154495>] vfs_write+0x89/0x10b
 [<c0154b91>] sys_write+0x41/0x67
 [<c01024ba>] sysenter_past_esp+0x5f/0x85
 =======================
(bot:conmon-payload) disconnecte
