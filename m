From: Nikolay Borisov <kernel@kyup.com>
Subject: Yet another ext4/jbd2 lockup
Date: Wed, 29 Jul 2015 16:33:18 +0300
Message-ID: <55B8D61E.7090609@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Marian Marinov <mm@1h.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34661 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbG2NdY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2015 09:33:24 -0400
Received: by wibud3 with SMTP id ud3so220991713wib.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2015 06:33:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, 

Again, I have come up against a rather annoying ext4/jbd2 
lock and I'm not sure it's the same issue as the last one 
I posted (http://marc.info/?l=linux-ext4&m=143522748527527&w=2). 
Again, all of this is happening on an 3.12.28 kernel. I did grep for
the ext4 commits that have come afterwards but none of them allude to
fixing something similar. This time the blocked process is an rsync 
which has been running OUTSIDE of a container e.g. in the / cgroup 
but it was copying stuff from a dm-thin volume acting as the root 
device for a cgroup: 

rsync           D ffffffff81622100     0 33158      1 0x00000004
 ffff882ad6257b18 0000000000000086 ffff883cfb3e5280 0000000000011640
 ffff882ad6257fd8 ffff882ad6256010 0000000000011640 0000000000011640
 ffff882ad6257fd8 0000000000011640 ffff881fd3213180 ffff883cfb3e5280
Call Trace:
 [<ffffffff81573f24>] schedule+0x24/0x70
 [<ffffffff8122f64c>] wait_transaction_locked+0x7c/0xb0
 [<ffffffff81097a70>] ? wake_up_bit+0x40/0x40
 [<ffffffff8122faf2>] start_this_handle+0x2c2/0x660
 [<ffffffff8116a8fd>] ? d_rehash+0x1d/0x30
 [<ffffffff8113b7f5>] ? kmem_cache_alloc+0xb5/0x150
 [<ffffffff81230229>] jbd2__journal_start+0x109/0x1b0
 [<ffffffff8120fe31>] __ext4_journal_start_sb+0x61/0xb0
 [<ffffffff811ebbe7>] __ext4_new_inode+0x5b7/0x1330
 [<ffffffff8115db8e>] ? __lookup_hash+0x1e/0x40
 [<ffffffff811fb7ec>] ext4_mkdir+0x18c/0x400
 [<ffffffff8115de05>] ? generic_permission+0xc5/0x230
 [<ffffffff8115f018>] vfs_mkdir+0xb8/0x100
 [<ffffffff811614e2>] SyS_mkdirat+0xb2/0x100
 [<ffffffff8115dc44>] SyS_mkdir+0x14/0x20
 [<ffffffff815763a2>] system_call_fastpath+0x16/0x1b

Sampling echo "w" > /proc/sysrq-trigger I found some other 
blocked process which might be related to the issue. In particular: 

jbd2/dm-24-8    D 0000000000000000     0 31263      2 0x00000000
 ffff882af46df9f8 0000000000000046 ffff882643db0000 0000000000011640
 ffff882af46dffd8 ffff882af46de010 0000000000011640 0000000000011640
 ffff882af46dffd8 0000000000011640 ffff8827c519ca40 ffff882643db0000
Call Trace:
 [<ffffffff810f4fc0>] ? __lock_page+0x70/0x70
 [<ffffffff81573f24>] schedule+0x24/0x70
 [<ffffffff81573ff7>] io_schedule+0x87/0xd0
 [<ffffffff810f4fc9>] sleep_on_page+0x9/0x10
 [<ffffffff81571a45>] __wait_on_bit_lock+0x55/0xb0
 [<ffffffff810f4b0a>] ? find_get_pages_tag+0xca/0x170
 [<ffffffff810f4fb2>] __lock_page+0x62/0x70
 [<ffffffff81097af0>] ? wake_atomic_t_function+0x40/0x40
 [<ffffffff81101c30>] ? pagevec_lookup_tag+0x20/0x30
 [<ffffffff810fffe1>] write_cache_pages+0x391/0x470
 [<ffffffff810fec20>] ? set_page_dirty+0x60/0x60
 [<ffffffff8110010c>] generic_writepages+0x4c/0x70
 [<ffffffff81231b0b>] jbd2_journal_commit_transaction+0x41b/0x1790
 [<ffffffff81083be7>] ? lock_timer_base+0x37/0x70
 [<ffffffff81235d12>] kjournald2+0xc2/0x250
 [<ffffffff81097a70>] ? wake_up_bit+0x40/0x40
 [<ffffffff81235c50>] ? commit_timeout+0x10/0x10
 [<ffffffff81097456>] kthread+0xc6/0xd0
 [<ffffffff81097390>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff815762fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81097390>] ? kthread_freezable_should_stop+0x60/0x60

kworker/u81:90  D 0000000000000000     0 36695      2 0x00000000
Workqueue: writeback bdi_writeback_workfn (flush-253:24)
 ffff880155ee7888 0000000000000046 ffff881ea1a71080 0000000000011640
 ffff880155ee7fd8 ffff880155ee6010 0000000000011640 0000000000011640
 ffff880155ee7fd8 0000000000011640 ffff882119215ac0 ffff881ea1a71080
Call Trace:
 [<ffffffff81573f24>] schedule+0x24/0x70
 [<ffffffff81235bc5>] jbd2_log_wait_commit+0xb5/0x130
 [<ffffffff81097a70>] ? wake_up_bit+0x40/0x40
 [<ffffffff810a04ce>] ? __wake_up+0x4e/0x70
 [<ffffffff8122f43b>] jbd2_journal_stop+0x1bb/0x2c0
 [<ffffffff8120fda8>] __ext4_journal_stop+0x78/0xa0
 [<ffffffff811f366f>] ext4_writepages+0x45f/0xa50
 [<ffffffff8110014b>] do_writepages+0x1b/0x30
 [<ffffffff811794cd>] __writeback_single_inode+0x3d/0x130
 [<ffffffff8117a637>] writeback_sb_inodes+0x207/0x3f0
 [<ffffffff8117a8b6>] __writeback_inodes_wb+0x96/0xc0
 [<ffffffff8117aabb>] wb_writeback+0x1db/0x1f0
 [<ffffffff8117ac61>] wb_do_writeback+0x191/0x1a0
 [<ffffffff8117ace8>] bdi_writeback_workfn+0x78/0x1b0
 [<ffffffff810a4312>] ? wake_up_process+0x22/0x40
 [<ffffffff8109078b>] process_one_work+0x13b/0x460
 [<ffffffff81091a09>] worker_thread+0x119/0x3f0
 [<ffffffff810918f0>] ? manage_workers+0x2c0/0x2c0
 [<ffffffff81097456>] kthread+0xc6/0xd0
 [<ffffffff81097390>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff815762fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81097390>] ? kthread_freezable_should_stop+0x60/0x60

Basically dm-24 is the device this rsync was syncing from  and the 
kworker is running as part of writeback for the same device 
(253:24 is the major:minor for this particular device). 
Furthermore, I see there have been a number of "sync" executed and 
their stack traces look like the following: 

sync            D ffffffff81622100     0 17596  17532 0x00000000
 ffff8827cf1fdd78 0000000000000086 ffff88348291b9c0 0000000000011640
 ffff8827cf1fdfd8 ffff8827cf1fc010 0000000000011640 0000000000011640
 ffff8827cf1fdfd8 0000000000011640 ffff881fd32118c0 ffff88348291b9c0
Call Trace:
 [<ffffffff81573f24>] schedule+0x24/0x70
 [<ffffffff81571955>] schedule_timeout+0x185/0x1c0
 [<ffffffff810904c2>] ? __queue_delayed_work+0x82/0x150
 [<ffffffff81574984>] wait_for_completion+0x94/0x100
 [<ffffffff810a42d0>] ? try_to_wake_up+0x2b0/0x2b0
 [<ffffffff81179a28>] ? bdi_queue_work+0x48/0xb0
 [<ffffffff8117e830>] ? fdatawrite_one_bdev+0x20/0x20
 [<ffffffff81179c56>] sync_inodes_sb+0xa6/0x1c0
 [<ffffffff8117e830>] ? fdatawrite_one_bdev+0x20/0x20
 [<ffffffff8117e845>] sync_inodes_one_sb+0x15/0x20
 [<ffffffff81157b29>] iterate_supers+0xa9/0xe0
 [<ffffffff8117e880>] sys_sync+0x30/0x90
 [<ffffffff815763a2>] system_call_fastpath+0x16/0x1b

I believe it is this sync which has triggered the bdi_writeback_workfn 
for the particular dm device. Essentially what I gather is that the 
rsync is locked since it wants to do some filesystem activity, hence 
it wants to start a transaction but it's blocked due to an unfinished 
transaction - presumably the one from the writeback path. However, 
the writeback is blocked in jbd2_log_wait_commit, waiting for its 
own transaction to complete and it is not progressing due to some 
reason. There hasn't been any OOM messages for the container in 
question and the global OOM killer hasn't triggered. The memory 
state of the machine when this was observed. There still some 
memory: 

SysRq : Show Memory
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
CPU    8: hi:    0, btch:   1 usd:   0
CPU    9: hi:    0, btch:   1 usd:   0
CPU   10: hi:    0, btch:   1 usd:   0
CPU   11: hi:    0, btch:   1 usd:   0
CPU   12: hi:    0, btch:   1 usd:   0
CPU   13: hi:    0, btch:   1 usd:   0
CPU   14: hi:    0, btch:   1 usd:   0
CPU   15: hi:    0, btch:   1 usd:   0
CPU   16: hi:    0, btch:   1 usd:   0
CPU   17: hi:    0, btch:   1 usd:   0
CPU   18: hi:    0, btch:   1 usd:   0
CPU   19: hi:    0, btch:   1 usd:   0
CPU   20: hi:    0, btch:   1 usd:   0
CPU   21: hi:    0, btch:   1 usd:   0
CPU   22: hi:    0, btch:   1 usd:   0
CPU   23: hi:    0, btch:   1 usd:   0
CPU   24: hi:    0, btch:   1 usd:   0
CPU   25: hi:    0, btch:   1 usd:   0
CPU   26: hi:    0, btch:   1 usd:   0
CPU   27: hi:    0, btch:   1 usd:   0
CPU   28: hi:    0, btch:   1 usd:   0
CPU   29: hi:    0, btch:   1 usd:   0
CPU   30: hi:    0, btch:   1 usd:   0
CPU   31: hi:    0, btch:   1 usd:   0
CPU   32: hi:    0, btch:   1 usd:   0
CPU   33: hi:    0, btch:   1 usd:   0
CPU   34: hi:    0, btch:   1 usd:   0
CPU   35: hi:    0, btch:   1 usd:   0
CPU   36: hi:    0, btch:   1 usd:   0
CPU   37: hi:    0, btch:   1 usd:   0
CPU   38: hi:    0, btch:   1 usd:   0
CPU   39: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 177
CPU    1: hi:  186, btch:  31 usd: 129
CPU    2: hi:  186, btch:  31 usd: 145
CPU    3: hi:  186, btch:  31 usd:  60
CPU    4: hi:  186, btch:  31 usd: 105
CPU    5: hi:  186, btch:  31 usd:  96
CPU    6: hi:  186, btch:  31 usd:  71
CPU    7: hi:  186, btch:  31 usd:  53
CPU    8: hi:  186, btch:  31 usd: 121
CPU    9: hi:  186, btch:  31 usd: 171
CPU   10: hi:  186, btch:  31 usd:  77
CPU   11: hi:  186, btch:  31 usd:   0
CPU   12: hi:  186, btch:  31 usd:   0
CPU   13: hi:  186, btch:  31 usd:   0
CPU   14: hi:  186, btch:  31 usd:  29
CPU   15: hi:  186, btch:  31 usd:  36
CPU   16: hi:  186, btch:  31 usd:   0
CPU   17: hi:  186, btch:  31 usd:   0
CPU   18: hi:  186, btch:  31 usd:   0
CPU   19: hi:  186, btch:  31 usd:  22
CPU   20: hi:  186, btch:  31 usd:  76
CPU   21: hi:  186, btch:  31 usd: 161
CPU   22: hi:  186, btch:  31 usd:  73
CPU   23: hi:  186, btch:  31 usd:  78
CPU   24: hi:  186, btch:  31 usd: 125
CPU   25: hi:  186, btch:  31 usd:  73
CPU   26: hi:  186, btch:  31 usd:  72
CPU   27: hi:  186, btch:  31 usd:  38
CPU   28: hi:  186, btch:  31 usd: 118
CPU   29: hi:  186, btch:  31 usd:  63
CPU   30: hi:  186, btch:  31 usd:   0
CPU   31: hi:  186, btch:  31 usd:   0
CPU   32: hi:  186, btch:  31 usd:   0
CPU   33: hi:  186, btch:  31 usd:   0
CPU   34: hi:  186, btch:  31 usd:   0
CPU   35: hi:  186, btch:  31 usd:   0
CPU   36: hi:  186, btch:  31 usd:   0
CPU   37: hi:  186, btch:  31 usd:   0
CPU   38: hi:  186, btch:  31 usd:   0
CPU   39: hi:  186, btch:  31 usd:   0
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 188
CPU    1: hi:  186, btch:  31 usd: 174
CPU    2: hi:  186, btch:  31 usd: 116
CPU    3: hi:  186, btch:  31 usd:  96
CPU    4: hi:  186, btch:  31 usd: 169
CPU    5: hi:  186, btch:  31 usd: 137
CPU    6: hi:  186, btch:  31 usd: 102
CPU    7: hi:  186, btch:  31 usd:  96
CPU    8: hi:  186, btch:  31 usd: 149
CPU    9: hi:  186, btch:  31 usd: 203
CPU   10: hi:  186, btch:  31 usd: 179
CPU   11: hi:  186, btch:  31 usd: 181
CPU   12: hi:  186, btch:  31 usd: 159
CPU   13: hi:  186, btch:  31 usd: 160
CPU   14: hi:  186, btch:  31 usd: 179
CPU   15: hi:  186, btch:  31 usd: 158
CPU   16: hi:  186, btch:  31 usd: 180
CPU   17: hi:  186, btch:  31 usd: 155
CPU   18: hi:  186, btch:  31 usd: 156
CPU   19: hi:  186, btch:  31 usd: 173
CPU   20: hi:  186, btch:  31 usd: 161
CPU   21: hi:  186, btch:  31 usd: 163
CPU   22: hi:  186, btch:  31 usd: 123
CPU   23: hi:  186, btch:  31 usd: 157
CPU   24: hi:  186, btch:  31 usd:  19
CPU   25: hi:  186, btch:  31 usd: 159
CPU   26: hi:  186, btch:  31 usd: 176
CPU   27: hi:  186, btch:  31 usd: 140
CPU   28: hi:  186, btch:  31 usd: 180
CPU   29: hi:  186, btch:  31 usd: 169
CPU   30: hi:  186, btch:  31 usd: 158
CPU   31: hi:  186, btch:  31 usd: 181
CPU   32: hi:  186, btch:  31 usd: 181
CPU   33: hi:  186, btch:  31 usd: 159
CPU   34: hi:  186, btch:  31 usd: 168
CPU   35: hi:  186, btch:  31 usd: 173
CPU   36: hi:  186, btch:  31 usd: 161
CPU   37: hi:  186, btch:  31 usd: 179
CPU   38: hi:  186, btch:  31 usd: 184
CPU   39: hi:  186, btch:  31 usd: 182
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 164
CPU    1: hi:  186, btch:  31 usd: 167
CPU    2: hi:  186, btch:  31 usd: 160
CPU    3: hi:  186, btch:  31 usd: 171
CPU    4: hi:  186, btch:  31 usd: 175
CPU    5: hi:  186, btch:  31 usd: 184
CPU    6: hi:  186, btch:  31 usd: 169
CPU    7: hi:  186, btch:  31 usd: 159
CPU    8: hi:  186, btch:  31 usd: 171
CPU    9: hi:  186, btch:  31 usd: 185
CPU   10: hi:  186, btch:  31 usd:  86
CPU   11: hi:  186, btch:  31 usd:  73
CPU   12: hi:  186, btch:  31 usd:  29
CPU   13: hi:  186, btch:  31 usd:  62
CPU   14: hi:  186, btch:  31 usd:  91
CPU   15: hi:  186, btch:  31 usd: 114
CPU   16: hi:  186, btch:  31 usd:  69
CPU   17: hi:  186, btch:  31 usd: 117
CPU   18: hi:  186, btch:  31 usd:  17
CPU   19: hi:  186, btch:  31 usd:  20
CPU   20: hi:  186, btch:  31 usd: 163
CPU   21: hi:  186, btch:  31 usd: 161
CPU   22: hi:  186, btch:  31 usd: 175
CPU   23: hi:  186, btch:  31 usd: 172
CPU   24: hi:  186, btch:  31 usd: 177
CPU   25: hi:  186, btch:  31 usd: 171
CPU   26: hi:  186, btch:  31 usd: 157
CPU   27: hi:  186, btch:  31 usd: 171
CPU   28: hi:  186, btch:  31 usd: 182
CPU   29: hi:  186, btch:  31 usd: 183
CPU   30: hi:  186, btch:  31 usd:  40
CPU   31: hi:  186, btch:  31 usd: 157
CPU   32: hi:  186, btch:  31 usd:  76
CPU   33: hi:  186, btch:  31 usd: 157
CPU   34: hi:  186, btch:  31 usd:  63
CPU   35: hi:  186, btch:  31 usd:  62
CPU   36: hi:  186, btch:  31 usd:  58
CPU   37: hi:  186, btch:  31 usd:  36
CPU   38: hi:  186, btch:  31 usd:  19
CPU   39: hi:  186, btch:  31 usd:  47
active_anon:6762239 inactive_anon:12245334 isolated_anon:0
 active_file:10705451 inactive_file:11321321 isolated_file:0
 unevictable:5516901 dirty:457441 writeback:0 unstable:0
 free:1028680 slab_reclaimable:3791349 slab_unreclaimable:13461537
 mapped:1567688 shmem:904717 pagetables:362061 bounce:0
 free_cma:0
Node 0 DMA free:15532kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 1668 128642 128642
Node 0 DMA32 free:509204kB min:1164kB low:1452kB high:1744kB active_anon:6016kB inactive_anon:13164kB active_file:2584kB inactive_file:5756kB unevictable:1112kB isolated(anon):0kB isolated(file):0kB present:2045980kB managed:1708904kB mlocked:1224kB dirty:20kB writeback:0kB mapped:4164kB shmem:3900kB slab_reclaimable:463020kB slab_unreclaimable:671072kB kernel_stack:1224kB pagetables:4268kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 126973 126973
Node 0 Normal free:189488kB min:88804kB low:111004kB high:133204kB active_anon:16411204kB inactive_anon:24056744kB active_file:19949588kB inactive_file:22435040kB unevictable:8645768kB isolated(anon):0kB isolated(file):0kB present:132120576kB managed:130020968kB mlocked:8657300kB dirty:1773000kB writeback:0kB mapped:2878728kB shmem:1624252kB slab_reclaimable:6834156kB slab_unreclaimable:29014116kB kernel_stack:65736kB pagetables:711944kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 Normal free:3393536kB min:90240kB low:112800kB high:135360kB active_anon:10638288kB inactive_anon:24911428kB active_file:22869632kB inactive_file:22844488kB unevictable:13420724kB isolated(anon):0kB isolated(file):0kB present:134217728kB managed:132117884kB mlocked:13427472kB dirty:56744kB writeback:0kB mapped:3387860kB shmem:1990716kB slab_reclaimable:7868220kB slab_unreclaimable:24160960kB kernel_stack:90600kB pagetables:731280kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB (U) 1*8kB (U) 0*16kB 1*32kB (U) 0*64kB 1*128kB (U) 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (U) 3*4096kB (MR) = 15532kB
Node 0 DMA32: 612*4kB (UEM) 1081*8kB (UEM) 295*16kB (UEM) 412*32kB (UEM) 288*64kB (UEM) 118*128kB (UEM) 63*256kB (UEM) 49*512kB (UEM) 30*1024kB (UEM) 29*2048kB (UEM) 77*4096kB (UMR) = 509256kB
Node 0 Normal: 44891*4kB (UE) 0*8kB 0*16kB 5*32kB (R) 4*64kB (R) 2*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 1*4096kB (R) = 186124kB
Node 1 Normal: 467218*4kB (UEM) 145540*8kB (UEM) 18995*16kB (UEM) 1482*32kB (UMR) 5*64kB (R) 1*128kB (R) 2*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 1*4096kB (R) = 3391128kB
23967743 total pagecache pages
1034858 pages in swap cache
Swap cache stats: add 154167590, delete 153132732, find 2698616740/2708213552
Free swap  = 16464476kB
Total swap = 41943036kB
67100065 pages RAM
0 pages HighMem/MovableOnly
524961 pages reserved
