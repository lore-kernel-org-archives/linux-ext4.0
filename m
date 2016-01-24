From: Dmitry Vyukov <dvyukov@google.com>
Subject: ext4: BUG: scheduling while atomic in ext4_commit_super
Date: Sun, 24 Jan 2016 17:48:00 +0100
Message-ID: <CACT4Y+Y5MveKSQ0Yywdcfa8M+cVPAEXRTiaFGM-ajo_x_pTWHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I've hit the following BUG while running syzkaller fuzzer:

JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 1). There's
a risk of filesystem corruption in case of system crash.
EXT4-fs error (device sda): ext4_init_block_bitmap:194: comm
kworker/u10:2: Checksum bad for group 3
BUG: sleeping function called from invalid context at
include/linux/buffer_head.h:354
in_atomic(): 1, irqs_disabled(): 0, pid: 20922, name: kworker/u10:2
INFO: lockdep is turned off.
CPU: 3 PID: 20922 Comm: kworker/u10:2 Tainted: G        W       4.4.0+ #276
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
 00000000ffffffff ffff8800608ded00 ffffffff82999e2d ffff880067570000
 00000000000051ba 0000000000000000 ffff8800608ded28 ffffffff813cc25b
 ffff880067570000 ffffffff864a4ba0 0000000000000162 ffff8800608ded68
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff82999e2d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
 [<ffffffff813cc25b>] ___might_sleep+0x27b/0x3a0 kernel/sched/core.c:7703
 [<ffffffff813cc410>] __might_sleep+0x90/0x1a0 kernel/sched/core.c:7665
 [<     inline     >] lock_buffer include/linux/buffer_head.h:354
 [<ffffffff8186b353>] __sync_dirty_buffer+0x63/0x270 fs/buffer.c:3129
 [<ffffffff81acb8b3>] ext4_commit_super+0x713/0xa80 fs/ext4/super.c:4333
 [<     inline     >] save_error_info fs/ext4/super.c:316
 [<ffffffff81acc547>] __ext4_error+0xe7/0x1d0 fs/ext4/super.c:419
 [<     inline     >] ext4_init_block_bitmap fs/ext4/balloc.c:194
 [<ffffffff81a31749>] ext4_read_block_bitmap_nowait+0x1159/0x1850
fs/ext4/balloc.c:446
 [<ffffffff81a31e5f>] ext4_read_block_bitmap+0x1f/0x60 fs/ext4/balloc.c:513
 [<ffffffff81b28da7>] ext4_mb_mark_diskspace_used+0x177/0x13f0
fs/ext4/mballoc.c:2899
 [<ffffffff81b2e5ea>] ext4_mb_new_blocks+0xd2a/0x25e0 fs/ext4/mballoc.c:4504
 [<ffffffff81b04a1f>] ext4_ext_map_blocks+0x1f0f/0x3030 fs/ext4/extents.c:4466
 [<ffffffff81a4fb63>] ext4_map_blocks+0x3c3/0xef0 fs/ext4/inode.c:593
 [<     inline     >] mpage_map_one_extent fs/ext4/inode.c:2153
 [<     inline     >] mpage_map_and_submit_extent fs/ext4/inode.c:2209
 [<ffffffff81a5cad0>] ext4_writepages+0x1110/0x2bc0 fs/ext4/inode.c:2552
 [<ffffffff816805c7>] do_writepages+0x97/0x100 mm/page-writeback.c:2354
 [<ffffffff8184820e>] __writeback_single_inode+0xee/0xd20 fs/fs-writeback.c:1231
 [<ffffffff8184a22d>] writeback_sb_inodes+0x44d/0x10e0 fs/fs-writeback.c:1492
 [<ffffffff8184afc4>] __writeback_inodes_wb+0x104/0x1e0 fs/fs-writeback.c:1553
 [<ffffffff8184b920>] wb_writeback+0x720/0x9e0 fs/fs-writeback.c:1662
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1797
 [<ffffffff8184ce13>] wb_workfn+0x2f3/0xd60 fs/fs-writeback.c:1837
 [<ffffffff813a0836>] process_one_work+0x796/0x1440 kernel/workqueue.c:2037
 [<ffffffff813a15bb>] worker_thread+0xdb/0xfc0 kernel/workqueue.c:2171
 [<ffffffff813b4d4f>] kthread+0x23f/0x2d0 drivers/block/aoe/aoecmd.c:1303
 [<ffffffff86336fef>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:468
BUG: scheduling while atomic: kworker/u10:2/20922/0x00000002
INFO: lockdep is turned off.
Modules linked in:
CPU: 3 PID: 20922 Comm: kworker/u10:2 Tainted: G        W       4.4.0+ #276
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
 00000000ffffffff ffff8800608de570 ffffffff82999e2d ffff880067570000
 0000000000000002 0000000000020140 ffff8800608de590 ffffffff813cb589
 ffff88006d720140 ffff8800608d8000 ffff8800608de618 ffffffff8632755d
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff82999e2d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
 [<ffffffff813cb589>] __schedule_bug+0xb9/0xe0 kernel/sched/core.c:3101
 [<     inline     >] schedule_debug kernel/sched/core.c:3115
 [<ffffffff8632755d>] __schedule+0x118d/0x1c50 kernel/sched/core.c:3225
 [<ffffffff863280b7>] schedule+0x97/0x1c0 kernel/sched/core.c:3311
 [<ffffffff8633436d>] schedule_timeout+0x55d/0x920 kernel/time/timer.c:1508
 [<ffffffff863261fe>] io_schedule_timeout+0x1be/0x390 kernel/sched/core.c:4888
 [<     inline     >] io_schedule include/linux/sched.h:437
 [<ffffffff82940a62>] bt_get+0x2d2/0x700 block/blk-mq-tag.c:301
 [<     inline     >] __blk_mq_get_tag block/blk-mq-tag.c:325
 [<ffffffff8294177b>] blk_mq_get_tag+0x11b/0x360 block/blk-mq-tag.c:354
 [<ffffffff829308f4>] __blk_mq_alloc_request+0x24/0xa20 block/blk-mq.c:215
 [<ffffffff829383cb>] blk_mq_map_request+0x79b/0xac0 block/blk-mq.c:1186
 [<ffffffff8293bf5f>] blk_sq_make_request+0x36f/0xc20 block/blk-mq.c:1358
 [<ffffffff8290ec60>] generic_make_request+0x310/0x800 block/blk-core.c:2066
 [<ffffffff8290f2ae>] submit_bio+0x15e/0x4c0 block/blk-core.c:2129
 [<ffffffff81866600>] submit_bh_wbc+0x400/0x560 fs/buffer.c:3036
 [<     inline     >] submit_bh fs/buffer.c:3048
 [<ffffffff8186b3f6>] __sync_dirty_buffer+0x106/0x270 fs/buffer.c:3133
 [<ffffffff81acb8b3>] ext4_commit_super+0x713/0xa80 fs/ext4/super.c:4333
 [<     inline     >] save_error_info fs/ext4/super.c:316
 [<ffffffff81acc547>] __ext4_error+0xe7/0x1d0 fs/ext4/super.c:419
 [<     inline     >] ext4_init_block_bitmap fs/ext4/balloc.c:194
 [<ffffffff81a31749>] ext4_read_block_bitmap_nowait+0x1159/0x1850
fs/ext4/balloc.c:446
 [<ffffffff81a31e5f>] ext4_read_block_bitmap+0x1f/0x60 fs/ext4/balloc.c:513
 [<ffffffff81b28da7>] ext4_mb_mark_diskspace_used+0x177/0x13f0
fs/ext4/mballoc.c:2899
 [<ffffffff81b2e5ea>] ext4_mb_new_blocks+0xd2a/0x25e0 fs/ext4/mballoc.c:4504
 [<ffffffff81b04a1f>] ext4_ext_map_blocks+0x1f0f/0x3030 fs/ext4/extents.c:4466
 [<ffffffff81a4fb63>] ext4_map_blocks+0x3c3/0xef0 fs/ext4/inode.c:593
 [<     inline     >] mpage_map_one_extent fs/ext4/inode.c:2153
 [<     inline     >] mpage_map_and_submit_extent fs/ext4/inode.c:2209
 [<ffffffff81a5cad0>] ext4_writepages+0x1110/0x2bc0 fs/ext4/inode.c:2552
 [<ffffffff816805c7>] do_writepages+0x97/0x100 mm/page-writeback.c:2354
 [<ffffffff8184820e>] __writeback_single_inode+0xee/0xd20 fs/fs-writeback.c:1231
 [<ffffffff8184a22d>] writeback_sb_inodes+0x44d/0x10e0 fs/fs-writeback.c:1492
 [<ffffffff8184afc4>] __writeback_inodes_wb+0x104/0x1e0 fs/fs-writeback.c:1553
 [<ffffffff8184b920>] wb_writeback+0x720/0x9e0 fs/fs-writeback.c:1662
 [<     inline     >] wb_do_writeback fs/fs-writeback.c:1797
 [<ffffffff8184ce13>] wb_workfn+0x2f3/0xd60 fs/fs-writeback.c:1837
 [<ffffffff813a0836>] process_one_work+0x796/0x1440 kernel/workqueue.c:2037
 [<ffffffff813a15bb>] worker_thread+0xdb/0xfc0 kernel/workqueue.c:2171
 [<ffffffff813b4d4f>] kthread+0x23f/0x2d0 drivers/block/aoe/aoecmd.c:1303
 [<ffffffff86336fef>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:468

The fuzzer especially corrupted /dev/hda, but this call path of
ext4_error seems to be expected in real life as well:

static int ext4_init_block_bitmap(struct super_block *sb,
...
        /* If checksum is bad mark all blocks used to prevent allocation
         * essentially implementing a per-group read-only flag. */
        if (!ext4_group_desc_csum_verify(sb, block_group, gdp)) {
                ext4_error(sb, "Checksum bad for group %u", block_group);

On commit 30f05309bde49295e02e45c7e615f73aa4e0ccc2.
