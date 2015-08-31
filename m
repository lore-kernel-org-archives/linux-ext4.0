From: Andrey Konovalov <andreyknvl@google.com>
Subject: Fwd: Data race in __inode_add_bytes
Date: Mon, 31 Aug 2015 21:35:00 +0200
Message-ID: <CAAeHK+xOsU5xbtUBc2xqVuvyXB5+yM+TGc3FFffqvK-ja0jgrA@mail.gmail.com>
References: <CAAeHK+womwjgo4UgErWzDC9XD7BwUB1TkaFLo0eC7jF0ftV6gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Kostya Serebryany <kcc@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+womwjgo4UgErWzDC9XD7BwUB1TkaFLo0eC7jF0ftV6gg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

We are working on a dynamic data race detector for the Linux kernel,
KernelThreadSanitizer (ktsan):
https://github.com/google/ktsan/wiki

We got a report while running ktsan on 4.2:

==================================================================
ThreadSanitizer: data-race in __inode_add_bytes

Write of size 8 by thread T210 (K740):
 [<ffffffff81266435>] __inode_add_bytes+0x55/0xd0 fs/stat.c:451
 [<ffffffff812f90c0>] inode_claim_rsv_space+0x60/0xa0 fs/quota/dquot.c:1557
 [<ffffffff812f9f7b>] dquot_claim_space_nodirty+0x3b/0x280 fs/quota/dquot.c:1721
 [<     inlined    >] ext4_da_update_reserve_space+0x13b/0x2c0
dquot_claim_block include/linux/quotaops.h:345
 [<ffffffff81335dab>] ext4_da_update_reserve_space+0x13b/0x2c0
fs/ext4/inode.c:350
 [<ffffffff81384cf0>] ext4_ext_map_blocks+0x1570/0x1a30 fs/ext4/extents.c:4597
 [<ffffffff8133610a>] ext4_map_blocks+0x1da/0x7b0 fs/ext4/inode.c:592
 [<     inlined    >] ext4_writepages+0x976/0x1480
mpage_map_one_extent fs/ext4/inode.c:2109
 [<     inlined    >] ext4_writepages+0x976/0x1480
mpage_map_and_submit_extent fs/ext4/inode.c:2165
 [<ffffffff8133b7b6>] ext4_writepages+0x976/0x1480 fs/ext4/inode.c:2508
 [<ffffffff811dbd23>] do_writepages+0x53/0x80 mm/page-writeback.c:2332
 [<ffffffff812a76bf>] __writeback_single_inode+0x7f/0x530
fs/fs-writeback.c:1259 (discriminator 3)
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

Previous read of size 8 by thread T512 (K7200):
 [<     inlined    >] ext4_mark_iloc_dirty+0x454/0xe20
ext4_inode_blocks_set fs/ext4/inode.c:4272
 [<     inlined    >] ext4_mark_iloc_dirty+0x454/0xe20
ext4_do_update_inode fs/ext4/inode.c:4430
 [<ffffffff8133a014>] ext4_mark_iloc_dirty+0x454/0xe20 fs/ext4/inode.c:4937
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

The 'inode->i_blocks' field is updated in one thread, while being read
and used in another.

This can probably be fixed with a few READ_ONCE/WRITE_ONCE or by
taking inode->i_lock in ext4_inode_blocks_set.

Thanks.
