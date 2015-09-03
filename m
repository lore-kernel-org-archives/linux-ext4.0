From: Andrey Konovalov <andreyknvl@google.com>
Subject: Data race in ext4_writepages
Date: Thu, 3 Sep 2015 17:51:53 +0200
Message-ID: <CAAeHK+yHaX-5Dr8Rr1CmQ_ZM003CwWT4xLdtmfeiyvhCFf+AUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Kostya Serebryany <kcc@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

We are working on a dynamic data race detector for the Linux kernel,
KernelThreadSanitizer (ktsan):
https://github.com/google/ktsan/wiki

We got a report while running ktsan on 4.2:

==================================================================
ThreadSanitizer: data-race in ext4_writepages

Write of size 8 by thread T210 (K741):
 [<     inlined    >] ext4_writepages+0x10a6/0x1480
mpage_map_and_submit_extent fs/ext4/inode.c:2223
 [<ffffffff8133bee6>] ext4_writepages+0x10a6/0x1480 fs/ext4/inode.c:2508
 [<ffffffff811dbd23>] do_writepages+0x53/0x80 mm/page-writeback.c:2332
 [<ffffffff812a76bf>] __writeback_single_inode+0x7f/0x530 fs/fs-writeback.c:1259
 [<ffffffff812a7fd4>] writeback_sb_inodes+0x464/0x690 fs/fs-writeback.c:1516
 [<ffffffff812a82c1>] __writeback_inodes_wb+0xc1/0x100 fs/fs-writeback.c:1562
 [<ffffffff812a86ae>] wb_writeback+0x3ae/0x450 fs/fs-writeback.c:1666
 [<     inlined    >] wb_workfn+0x203/0x780 wb_do_writeback
fs/fs-writeback.c:1801
 [<ffffffff812a91c3>] wb_workfn+0x203/0x780 fs/fs-writeback.c:1852
 [<ffffffff810b06ce>] process_one_work+0x28e/0x710 kernel/workqueue.c:2036
 [<ffffffff810b1299>] worker_thread+0xb9/0x750 kernel/workqueue.c:2170
 [<ffffffff810b9c61>] kthread+0x161/0x180 kernel/kthread.c:209
 [<ffffffff81eb0a1f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:526

Previous read of size 8 by thread T480 (K7162):
 [<     inlined    >] ext4_mark_iloc_dirty+0x5ec/0xe20
ext4_do_update_inode fs/ext4/inode.c:4441
 [<ffffffff8133a1ac>] ext4_mark_iloc_dirty+0x5ec/0xe20 fs/ext4/inode.c:4937
 [<ffffffff8133ab8b>] ext4_mark_inode_dirty+0xdb/0x390 fs/ext4/inode.c:5053
 [<ffffffff8133f929>] ext4_dirty_inode+0x59/0x80 fs/ext4/inode.c:5085
 [<ffffffff812a7319>] __mark_inode_dirty+0x2c9/0x5f0 fs/fs-writeback.c:2015
 [<ffffffff8128a58e>] generic_update_time+0xbe/0x150 fs/inode.c:1566
 [<     inlined    >] file_update_time+0x112/0x1b0 update_time fs/inode.c:1582
 [<ffffffff812890f2>] file_update_time+0x112/0x1b0 fs/inode.c:1785
 [<ffffffff811cb175>] __generic_file_write_iter+0x105/0x2e0 mm/filemap.c:2570
 [<ffffffff8132c3a4>] ext4_file_write_iter+0x254/0x740 fs/ext4/file.c:170
 [<     inlined    >] __vfs_write+0x19c/0x1e0 new_sync_write fs/read_write.c:478
 [<ffffffff8125d48c>] __vfs_write+0x19c/0x1e0 fs/read_write.c:491
 [<ffffffff8125dde6>] vfs_write+0xf6/0x2a0 fs/read_write.c:538
 [<     inlined    >] SyS_write+0x6b/0xd0 SYSC_write fs/read_write.c:585
 [<ffffffff8125f37b>] SyS_write+0x6b/0xd0 fs/read_write.c:577
 [<ffffffff81eb062e>] entry_SYSCALL_64_fastpath+0x12/0x71
arch/x86/entry/entry_64.S:186
==================================================================

One thread reads 'ei->i_disksize' multiple times while it's being
updated by another.
ei->i_disksize is 64 bits long so reads and writes are not atomic.

Thanks!
