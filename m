From: Dmitry Vyukov <dvyukov@google.com>
Subject: Potential use-after-free in ext4_mb_new_blocks
Date: Mon, 16 Sep 2013 21:54:02 -0700
Message-ID: <CACT4Y+Zw_E36m9Hun=Vjwm_bACczrkQrjUWtGT0PhsxcSZKNKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Nauman Rafique <nauman@google.com>,
	Michael Siegenthaler <msiegen@google.com>,
	Paul Turner <pjt@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Kostya Serebryany <kcc@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47899 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3IQEyX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Sep 2013 00:54:23 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so4920004lbi.15
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2013 21:54:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am working on AddressSanitizer -- a tool that detects use-after-free
and out-of-bounds bugs
(https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).

Here is one of the use-after-free reports:

[ 3548.503571]  EXT4-fs error (device sda3):
ext4_mb_mark_diskspace_used:2872: comm Logger: Allocating blocks
46719-46720 which overlap fs metadata
[ 3548.563517] EXT4-fs error (device sda3):
ext4_mb_mark_diskspace_used:2872: comm Logger: Allocating blocks
37605-37606 which overlap fs metadata
[ 3548.615284] =========================================================================
[ 3548.616798] ERROR: AddressSanitizer: heap-use-after-free on address
ffff880064d11924
[ 3548.618354] ffff880064d11924 is located 84 bytes inside of 104-byte
region [ffff880064d118d0, ffff880064d11938)
[ 3548.620425] Accessed by thread T3916:
[ 3548.621267]   #0      inlined     describe_heap_address
./arch/x86/mm/asan/report.c:164
[ 3548.621267]   #0 ffffffff810dd277 (asan_report_error+0x2f7/0x400)
./arch/x86/mm/asan/report.c:278
[ 3548.622580]   #1 ffffffff810dc6a0 (asan_check_region+0x30/0x40)
./arch/x86/mm/asan/asan.c:37
[ 3548.623929]   #2 ffffffff810dd3e3 (__tsan_read2+0x13/0x20) ??:0
[ 3548.625158]   #3 ffffffff813fbb30
(ext4_mb_release_context+0x70/0xa40) ./fs/ext4/mballoc.c:4269
[ 3548.626516]   #4 ffffffff81401888 (ext4_mb_new_blocks+0x888/0x9b0)
./fs/ext4/mballoc.c:4432
[ 3548.627826]   #5 ffffffff813f2594
(ext4_ext_map_blocks+0x1404/0x1ba0) ./fs/ext4/extents.c:4213
[ 3548.629232]   #6 ffffffff813a9b15 (ext4_map_blocks+0x485/0x800)
./fs/ext4/inode.c:628
[ 3548.630450]   #7      inlined     mpage_map_one_extent ./fs/ext4/inode.c:2110
[ 3548.630450]   #7      inlined     mpage_map_and_submit_extent
./fs/ext4/inode.c:2161
[ 3548.630450]   #7 ffffffff813aeeb3 (ext4_writepages+0x8f3/0x13d0)
./fs/ext4/inode.c:2494
[ 3548.631745]   #8 ffffffff81226b14 (do_writepages+0x54/0xa0)
./mm/page-writeback.c:1928
[ 3548.633060]   #9 ffffffff812174f8
(__filemap_fdatawrite_range+0xd8/0xf0) ./mm/filemap.c:231
[ 3548.634506]   #10 ffffffff8121b7a3 (SyS_fadvise64_64+0x2f3/0x300) ??:0
[ 3548.635903]   #11 ffffffff810de3d0 (sys32_fadvise64+0x40/0x60) ??:0
[ 3548.637135]   #12 ffffffff81929bf5 (sysenter_dispatch+0x7/0x1a)
./arch/x86/ia32/ia32entry.S:164
[ 3548.638455]
[ 3548.638812] Freed by thread T14794:
[ 3548.639617]   #0 ffffffff810dc839 (asan_slab_free+0x69/0xb0)
./arch/x86/mm/asan/asan.c:130
[ 3548.640963]   #1      inlined     __cache_free ./mm/slab.c:3591
[ 3548.640963]   #1 ffffffff81280b95 (kmem_cache_free+0x55/0x2e0)
./mm/slab.c:3800
[ 3548.642275]   #2 ffffffff813f7832 (ext4_mb_pa_callback+0x32/0x40)
./fs/ext4/mballoc.c:3428
[ 3548.643533]   #3      inlined     rcu_do_batch ./kernel/rcutree.c:1991
[ 3548.643533]   #3      inlined     invoke_rcu_callbacks
./kernel/rcutree.c:2229
[ 3548.643533]   #3      inlined     __rcu_process_callbacks
./kernel/rcutree.c:2199
[ 3548.643533]   #3 ffffffff811bce22
(rcu_process_callbacks+0x292/0x880) ./kernel/rcutree.c:2213
[ 3548.645067]   #4      inlined     trace_softirq_exit ./kernel/softirq.c:251
[ 3548.645067]   #4 ffffffff810eec62 (__do_softirq+0x182/0x3a0)
./kernel/softirq.c:252
[ 3548.646326]   #5      inlined     invoke_softirq ./kernel/softirq.c:332
[ 3548.646326]   #5 ffffffff810ef0e5 (irq_exit+0x115/0x120)
./kernel/softirq.c:365
[ 3548.647477]   #6 ffffffff8192a2da
(smp_apic_timer_interrupt+0x6a/0x80)
././arch/x86/include/asm/irq_regs.h:26
[ 3548.648874]   #7 ffffffff8192908a (apic_timer_interrupt+0x6a/0x70)
./arch/x86/kernel/entry_64.S:1181
[ 3548.650101]   #8 ffffffff810dccdd (asan_region_is_poisoned+0x6d/0x1a0) ??:0
[ 3548.651438]   #9 ffffffff810dc689 (asan_check_region+0x19/0x40)
./arch/x86/mm/asan/asan.c:33
[ 3548.652630]   #10 ffffffff810dd423 (__tsan_read8+0x13/0x20) ??:0
[ 3548.653722]   #11 ffffffff81214861 (iov_iter_advance+0x31/0x210)
./mm/filemap.c:2023
[ 3548.654898]   #12      inlined     generic_perform_write ./mm/filemap.c:2304
[ 3548.654898]   #12 ffffffff81215918
(generic_file_buffered_write+0xa8/0x420) ./mm/filemap.c:2402
[ 3548.656250]   #13 ffffffff812186c7
(__generic_file_aio_write+0x2f7/0x550) ./mm/filemap.c:2520
[ 3548.657682]   #14 ffffffff812189b7
(generic_file_aio_write+0x97/0x100) ./mm/filemap.c:2551
[ 3548.658947]   #15 ffffffff813a0ad1 (ext4_file_write+0x121/0x5e0) file.c:0
[ 3548.660102]
[ 3548.660421] Allocated by thread T1087:
[ 3548.661218]   #0 ffffffff810dc768 (asan_slab_alloc+0x48/0xb0)
./arch/x86/mm/asan/asan.c:91
[ 3548.662385]   #1      inlined     slab_alloc ./mm/slab.c:3475
[ 3548.662385]   #1 ffffffff81282e0a (kmem_cache_alloc+0x9a/0x4c0)
./mm/slab.c:3630
[ 3548.663576]   #2 ffffffff8190e928 (ext4_mb_new_inode_pa+0xd8/0x752)
./fs/ext4/mballoc.c:3506
[ 3548.664826]   #3 ffffffff8140190b (ext4_mb_new_blocks+0x90b/0x9b0)
./fs/ext4/mballoc.c:4417
[ 3548.666087]   #4 ffffffff813f2594
(ext4_ext_map_blocks+0x1404/0x1ba0) ./fs/ext4/extents.c:4213
[ 3548.667377]   #5 ffffffff813a9b15 (ext4_map_blocks+0x485/0x800)
./fs/ext4/inode.c:628
[ 3548.668589]   #6      inlined     mpage_map_one_extent ./fs/ext4/inode.c:2110
[ 3548.668589]   #6      inlined     mpage_map_and_submit_extent
./fs/ext4/inode.c:2161
[ 3548.668589]   #6 ffffffff813aeeb3 (ext4_writepages+0x8f3/0x13d0)
./fs/ext4/inode.c:2494
[ 3548.669831]   #7 ffffffff81226b14 (do_writepages+0x54/0xa0)
./mm/page-writeback.c:1928
[ 3548.671056]   #8 ffffffff812da583
(__writeback_single_inode+0x73/0x390) ./fs/fs-writeback.c:451
[ 3548.672382]   #9 ffffffff812dbd94 (writeback_sb_inodes+0x2a4/0x700)
./fs/fs-writeback.c:668
[ 3548.673655]   #10 ffffffff812dc2bf
(__writeback_inodes_wb+0xcf/0x130) ./fs/fs-writeback.c:712
[ 3548.674654]   #11 ffffffff812dc74b (wb_writeback+0x42b/0x450)
./fs/fs-writeback.c:842
[ 3548.675990]   #12      inlined     wb_check_old_data_flush
./fs/fs-writeback.c:957
[ 3548.675990]   #12      inlined     wb_do_writeback ./fs/fs-writeback.c:992
[ 3548.675990]   #12 ffffffff812df829
(bdi_writeback_workfn+0x4e9/0x620) ./fs/fs-writeback.c:1022
[ 3548.677403]   #13      inlined     trace_workqueue_execute_end
./kernel/workqueue.c:2186
[ 3548.677403]   #13 ffffffff81111640 (process_one_work+0x2d0/0x750)
./kernel/workqueue.c:2191
[ 3548.678744]   #14 ffffffff81111d23 (worker_thread+0x263/0x640)
./include/linux/list.h:188
[ 3548.680034]   #15 ffffffff8111c092 (kthread+0x132/0x140) kthread.c:0
[ 3548.681249]
[ 3548.681572] Shadow bytes around the buggy address:
[ 3548.682647]   ffff880064d11680: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.684246]   ffff880064d11700: fa fa fa fa fa fa fa fd fd fd fd fd
fd fd fd fd
[ 3548.685576]   ffff880064d11780: fd fd fd fd fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.686591]   ffff880064d11800: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.687586]   ffff880064d11880: fa fa fa fa fa fa fa fa fa fa fd fd
fd fd fd fd
[ 3548.688576] =>ffff880064d11900: fd fd fd fd[fd]fd fd fa fa fa fa fa
fa fa fa fa
[ 3548.689563]   ffff880064d11980: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.690546]   ffff880064d11a00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fd fd fd
[ 3548.691534]   ffff880064d11a80: fd fd fd fd fd fd fd fd fd fd fa fa
fa fa fa fa
[ 3548.692517]   ffff880064d11b00: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.693577]   ffff880064d11b80: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[ 3548.694519] Shadow byte legend (one shadow byte represents 8
application bytes):
[ 3548.695555]   Addressable:           00
[ 3548.696071]   Partially addressable: 01 02 03 04 05 06 07
[ 3548.696827]   Heap redzone:          fa
[ 3548.697336]   Heap kmalloc redzone:  fb
[ 3548.697830]   Freed heap region:     fd
[ 3548.698336]   Shadow gap:            fe
[ 3548.698881] =========================================================================
[ 3548.710135] EXT4-fs error (device sda3):
ext4_mb_mark_diskspace_used:2872: comm Logger: Allocating blocks
37446-37447 which overlap fs metadata
// SAME USE-AFTER-FREE REPORT GOES HERE
[ 3548.845162] EXT4-fs error (device sda3):
ext4_mb_mark_diskspace_used:2872: comm Logger: Allocating blocks
37447-37448 which overlap fs metadata
// SAME USE-AFTER-FREE REPORT GOES HERE
[ 3548.967232] EXT4-fs error (device sda3):
ext4_mb_mark_diskspace_used:2872: comm Logger: Allocating blocks
33592-33593 which overlap fs metadata
// SAME USE-AFTER-FREE REPORT GOES HERE
// AND SO ON, 99 REPORTS IN TOTAL


The problem seems to be that ext4_mb_release_context() frees
ac->ac_pa, but does not reset it to NULL. Then ext4_mb_new_blocks()
makes another repeat loop, gets EAGAIN from
ext4_mb_mark_diskspace_used(), and frees ac->ac_pa once again, and
again, and again.

The report is obtained on revision 6a7492a4b2e05051a44458d7187023e22d580666.

Please help to confirm/triage the report.
