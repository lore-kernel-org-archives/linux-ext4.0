From: Nikolay Borisov <kernel@kyup.com>
Subject: Hard lockup in ext4_finish_bio
Date: Thu, 8 Oct 2015 14:46:12 +0300
Message-ID: <56165784.60206@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
	Jan Kara <jack@suse.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, 

I've hit a rather strange hard lock up on one of my servers from the 
page writeback path, the actual backtrace is: 

[427149.717151] ------------[ cut here ]------------
[427149.717553] WARNING: CPU: 23 PID: 4611 at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()
[427149.718216] Watchdog detected hard LOCKUP on cpu 23
[427149.718292] Modules linked in:
[427149.718723]  tcp_diag inet_diag netconsole act_police cls_basic sch_ingress xt_pkttype xt_state veth openvswitch gre 
vxlan ip_tunnel xt_owner xt_conntrack iptable_mangle xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_n
at xt_CT nf_conntrack iptable_raw ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa ext2 
dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio dm_mirror dm_region_hash dm_log i2c_i801 lpc_ich mfd_core shpchp i
oapic ioatdma igb i2c_algo_bit ses enclosure ipmi_devintf ipmi_si ipmi_msghandler ib_qib dca ib_mad ib_core
[427149.725321] CPU: 23 PID: 4611 Comm: kworker/u98:7 Not tainted 3.12.47-clouder1 #1
[427149.725690] Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
[427149.726062] Workqueue: writeback bdi_writeback_workfn (flush-252:148)
[427149.726564]  00000000000000f5 ffff883fff366b58 ffffffff81651631 00000000000000f5
[427149.727212]  ffff883fff366ba8 ffff883fff366b98 ffffffff81089a6c 0000000000000000
[427149.727860]  ffff883fd2f08000 0000000000000000 ffff883fff366ce8 0000000000000000
[427149.728490] Call Trace:
[427149.728845]  <NMI>  [<ffffffff81651631>] dump_stack+0x58/0x7f
[427149.729350]  [<ffffffff81089a6c>] warn_slowpath_common+0x8c/0xc0
[427149.729712]  [<ffffffff81089b56>] warn_slowpath_fmt+0x46/0x50
[427149.730076]  [<ffffffff811015f8>] watchdog_overflow_callback+0x98/0xc0
[427149.730443]  [<ffffffff81132d0c>] __perf_event_overflow+0x9c/0x250
[427149.730810]  [<ffffffff81133664>] perf_event_overflow+0x14/0x20
[427149.731175]  [<ffffffff81061796>] intel_pmu_handle_irq+0x1d6/0x3e0
[427149.739656]  [<ffffffff8105b4c4>] perf_event_nmi_handler+0x34/0x60
[427149.740027]  [<ffffffff8104c152>] nmi_handle+0xa2/0x1a0
[427149.740389]  [<ffffffff8104c3b4>] do_nmi+0x164/0x430
[427149.740754]  [<ffffffff81656e2e>] end_repeat_nmi+0x1a/0x1e
[427149.741122]  [<ffffffff8113bfd7>] ? mempool_free_slab+0x17/0x20
[427149.741492]  [<ffffffff8125be15>] ? ext4_finish_bio+0x275/0x2a0
[427149.741854]  [<ffffffff8125be15>] ? ext4_finish_bio+0x275/0x2a0
[427149.742216]  [<ffffffff8125be15>] ? ext4_finish_bio+0x275/0x2a0
[427149.742579]  <<EOE>>  <IRQ>  [<ffffffff8125c2c8>] ext4_end_bio+0xc8/0x120
[427149.743150]  [<ffffffff811dbf1d>] bio_endio+0x1d/0x40
[427149.743516]  [<ffffffff81546781>] dec_pending+0x1c1/0x360
[427149.743878]  [<ffffffff81546996>] clone_endio+0x76/0xa0
[427149.744239]  [<ffffffff811dbf1d>] bio_endio+0x1d/0x40
[427149.744599]  [<ffffffff81546781>] dec_pending+0x1c1/0x360
[427149.744964]  [<ffffffff81546996>] clone_endio+0x76/0xa0
[427149.745326]  [<ffffffff811dbf1d>] bio_endio+0x1d/0x40
[427149.745686]  [<ffffffff81546781>] dec_pending+0x1c1/0x360
[427149.746048]  [<ffffffff81546996>] clone_endio+0x76/0xa0
[427149.746407]  [<ffffffff811dbf1d>] bio_endio+0x1d/0x40
[427149.746773]  [<ffffffff812fad2b>] blk_update_request+0x21b/0x450
[427149.747138]  [<ffffffff812faf87>] blk_update_bidi_request+0x27/0xb0
[427149.747513]  [<ffffffff812fcc7f>] blk_end_bidi_request+0x2f/0x80
[427149.748101]  [<ffffffff812fcd20>] blk_end_request+0x10/0x20
[427149.748705]  [<ffffffff813fdc1c>] scsi_io_completion+0xbc/0x620
[427149.749297]  [<ffffffff813f57f9>] scsi_finish_command+0xc9/0x130
[427149.749891]  [<ffffffff813fe2e7>] scsi_softirq_done+0x147/0x170
[427149.750491]  [<ffffffff813035ad>] blk_done_softirq+0x7d/0x90
[427149.751089]  [<ffffffff8108ed87>] __do_softirq+0x137/0x2e0
[427149.751694]  [<ffffffff81658a0c>] call_softirq+0x1c/0x30
[427149.752284]  [<ffffffff8104a35d>] do_softirq+0x8d/0xc0
[427149.752892]  [<ffffffff8108e925>] irq_exit+0x95/0xa0
[427149.753526]  [<ffffffff8106f755>] smp_call_function_single_interrupt+0x35/0x40
[427149.754149]  [<ffffffff8165826f>] call_function_single_interrupt+0x6f/0x80
[427149.754750]  <EOI>  [<ffffffff813276e6>] ? memcpy+0x6/0x110
[427149.755572]  [<ffffffff811dc6d6>] ? __bio_clone+0x26/0x70
[427149.756179]  [<ffffffff81546db9>] __clone_and_map_data_bio+0x139/0x160
[427149.756814]  [<ffffffff815471cd>] __split_and_process_bio+0x3ed/0x490
[427149.757444]  [<ffffffff815473a6>] dm_request+0x136/0x1e0
[427149.758041]  [<ffffffff812fbe0a>] generic_make_request+0xca/0x100
[427149.758641]  [<ffffffff812fbeb9>] submit_bio+0x79/0x160
[427149.759035]  [<ffffffff81144c3d>] ? account_page_writeback+0x2d/0x40
[427149.759406]  [<ffffffff81144dbd>] ? __test_set_page_writeback+0x16d/0x1f0
[427149.759781]  [<ffffffff8125b7a9>] ext4_io_submit+0x29/0x50
[427149.760151]  [<ffffffff8125b8fb>] ext4_bio_write_page+0x12b/0x2f0
[427149.760519]  [<ffffffff81252fe8>] mpage_submit_page+0x68/0x90
[427149.760887]  [<ffffffff81253100>] mpage_process_page_bufs+0xf0/0x110
[427149.761257]  [<ffffffff81254a80>] mpage_prepare_extent_to_map+0x210/0x310
[427149.761624]  [<ffffffff8125a911>] ? ext4_writepages+0x361/0xc60
[427149.761998]  [<ffffffff81283c09>] ? __ext4_journal_start_sb+0x79/0x110
[427149.762362]  [<ffffffff8125a948>] ext4_writepages+0x398/0xc60
[427149.762726]  [<ffffffff812fd358>] ? blk_finish_plug+0x18/0x50
[427149.763089]  [<ffffffff81146b40>] do_writepages+0x20/0x40
[427149.763454]  [<ffffffff811cec79>] __writeback_single_inode+0x49/0x2b0
[427149.763819]  [<ffffffff810aeeef>] ? wake_up_bit+0x2f/0x40
[427149.764182]  [<ffffffff811cfdee>] writeback_sb_inodes+0x2de/0x540
[427149.764544]  [<ffffffff811a6e65>] ? put_super+0x25/0x50
[427149.764903]  [<ffffffff811d00ee>] __writeback_inodes_wb+0x9e/0xd0
[427149.765265]  [<ffffffff811d035b>] wb_writeback+0x23b/0x340
[427149.765628]  [<ffffffff811d04f9>] wb_do_writeback+0x99/0x230
[427149.765996]  [<ffffffff810a40f1>] ? set_worker_desc+0x81/0x90
[427149.766364]  [<ffffffff810c7a6a>] ? dequeue_task_fair+0x36a/0x4c0
[427149.766734]  [<ffffffff811d0bf8>] bdi_writeback_workfn+0x88/0x260
[427149.767101]  [<ffffffff810bbb3e>] ? finish_task_switch+0x4e/0xe0
[427149.767473]  [<ffffffff81653dac>] ? __schedule+0x2dc/0x760
[427149.767845]  [<ffffffff810a61e5>] process_one_work+0x195/0x550
[427149.768212]  [<ffffffff810a848a>] worker_thread+0x13a/0x430
[427149.768575]  [<ffffffff810a8350>] ? manage_workers+0x2c0/0x2c0
[427149.768940]  [<ffffffff810ae48e>] kthread+0xce/0xe0
[427149.769303]  [<ffffffff810ae3c0>] ? kthread_freezable_should_stop+0x80/0x80
[427149.769668]  [<ffffffff816571c8>] ret_from_fork+0x58/0x90
[427149.770030]  [<ffffffff810ae3c0>] ? kthread_freezable_should_stop+0x80/0x80
[427149.770394] ---[ end trace 76566eb23cf1b028 ]---


What's not evident here is that in ext4_end_bio, the CPU has actually 
been executing ext4_finish_bio as seen from the following 
NMI backtrace: 

[427160.405277] NMI backtrace for cpu 23
[427160.405279] CPU: 23 PID: 4611 Comm: kworker/u98:7 Tainted: G        W    3.12.47-clouder1 #1
[427160.405281] Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
[427160.405285] Workqueue: writeback bdi_writeback_workfn (flush-252:148)
[427160.405286] task: ffff8825aa819830 ti: ffff882b19180000 task.ti: ffff882b19180000
[427160.405290] RIP: 0010:[<ffffffff8125be13>]  [<ffffffff8125be13>] ext4_finish_bio+0x273/0x2a0 <-- Important bit
[427160.405291] RSP: 0000:ffff883fff3639b0  EFLAGS: 00000002
[427160.405292] RAX: ffff882b19180000 RBX: ffff883f67480a80 RCX: 0000000000000110
[427160.405292] RDX: ffff882b19180000 RSI: 0000000000000000 RDI: ffff883f67480a80
[427160.405293] RBP: ffff883fff363a70 R08: 0000000000014b80 R09: ffff881fff454f00
[427160.405294] R10: ffffea00473214c0 R11: ffffffff8113bfd7 R12: ffff880826272138
[427160.405295] R13: 0000000000000000 R14: 0000000000000000 R15: ffffea00aeaea400
[427160.405296] FS:  0000000000000000(0000) GS:ffff883fff360000(0000) knlGS:0000000000000000
[427160.405296] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[427160.405297] CR2: 0000003c5b009c24 CR3: 0000000001c0b000 CR4: 00000000001407e0
[427160.405297] Stack:
[427160.405305]  0000000000000000 ffffffff8203f230 ffff883fff363a00 ffff882b19180000
[427160.405312]  ffff882b19180000 ffff882b19180000 00000400018e0af8 ffff882b19180000
[427160.405319]  ffff883f67480a80 0000000000000000 0000000000000202 00000000d219e720
[427160.405320] Call Trace:
[427160.405324]  <IRQ> 
	//SAME AS THE FIRST STACKTRACE
[427160.405436]  <EOI> 
	//SAME AS THE FIRST STACKTRACE
[427160.405540] Code: e8 a3 38 ec ff ff 75 90 9d e9 2a ff ff ff 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 48 8b 85 60 ff ff ff 48 8b 95 58 ff ff ff ff 48 1c <f3> 90 49 8b 0c 24 80 e1 10 75 f5 ff 42 1c f0 41 0f ba 2c 24 04 

After sampling from several different NMI prints it turns out the CPU 
has looped on the following bit lock acquire: 

local_irq_save(flags);
bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
do {
     if (bh_offset(bh) < bio_start ||
         bh_offset(bh) + bh->b_size > bio_end) {
         	if (buffer_async_write(bh))
                	under_io++;
                continue;
     }
     clear_buffer_async_write(bh);
     if (error)
     	buffer_io_error(bh);
} while ((bh = bh->b_this_page) != head);
bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
local_irq_restore(flags);

So far everything seems to check out - the code is spinning on 
acquiring the BH_Uptodate_Lock with interrupts disabled and 
this causes the deadlock. Now, the pertinent question is 
why can't it acquire the spinlock. Grepping for the users of
BH_Uptodate_Lock it is revealed that the only other places where 
they are used are in end_buffer_async_read and 
end_buffer_async_write. Looking at the NMI backtraces for the 
rest of the CPUs on the system I didn't find it in any 
execution path. Most of the cores were in acpi_idle_enter and 
one was in mem cgroup reclaim path. However I think those are 
unrelated. 

Ignoring the NMI call stack, this is by far the deepest callchain
I've ever seen, I wonder whether some sort of memory corruption has 
happened which confuses the code into thinking the lock is 
held. Here is the struct buffer_head:

crash> struct buffer_head ffff880826272138 -x

struct buffer_head {
  b_state = 0x131,  
  b_this_page = 0xffff8808262728f0, 
  b_page = 0xffffea00aeaea400, 
  b_blocknr = 0x36bea69, 
  b_size = 0x400, 
  b_data = 0xffff882baba90000 struct: page excluded: kernel virtual address: ffff882baba90000  type: "gdb_readmem_callback"
struct: page excluded: kernel virtual address: ffff882baba90000  type: "gdb_readmem_callback"
<Address 0xffff882baba90000 out of bounds>, 
  b_bdev = 0xffff883fcfb6db00, 
  b_end_io = 0x0, 
  b_private = 0x0, 
  b_assoc_buffers = {
    next = 0xffff880826272180, 
    prev = 0xffff880826272180
  }, 
  b_assoc_map = 0x0, 
  b_count = {
    counter = 0x0
  }
}

b_state = 0x131 = (0001 0011 0001) = BH_Uptodate, BG_Uptodate_Lock, 
BH_Mapped and BH_Async_Write, which implies that 
end_buffer_async_write should have been executing somewhere but 
I do not see this.  And in any case it hasn't completed in reasonable time
since we've hit the deadlock. At this point I'm inclined to believe 
that some sort of hardware issue might have reared its head?

What do you guys think? 

Regards, 
Nikolay
