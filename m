From: Mark Lord <kernel@teksavvy.com>
Subject: Re: 2.6.39.1: Intel I340-T4: irq/64-eth3-TxR: page allocation failure.
 order:1, mode:0x20
Date: Sat, 18 Jun 2011 12:21:19 -0400
Message-ID: <4DFCD07F.8050604@teksavvy.com>
References: <alpine.DEB.2.02.1106172106080.7672@p34.internal.lan> <4DFCD004.5090400@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
	e1000-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:40165 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120Ab1FRQVV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 12:21:21 -0400
In-Reply-To: <4DFCD004.5090400@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11-06-18 12:19 PM, Mark Lord wrote:
> On 11-06-17 09:16 PM, Justin Piszcz wrote:
>> > Hi,
>> >
>> > Kernel 2.6.39.1, x86_64.
>> > Has anyone seen a page allocation failure on a NIC before?
> ..
>> > [60295.925691] irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
>> > [60295.945328] Pid: 2299, comm: irq/64-eth3-TxR Not tainted 2.6.39.1 #1
>> > [60295.945329] Call Trace:
>> > [60295.945330]  <IRQ>  [<ffffffff810882f6>] ? __alloc_pages_nodemask+0x606/0x890
>> > [60295.945341]  [<ffffffff810b1435>] ? cache_alloc_refill+0x2c5/0x530
>> > [60295.945343]  [<ffffffff810b180b>] ? kmem_cache_alloc+0x7b/0xa0
>> > [60295.945347]  [<ffffffff815031ac>] ? sk_prot_alloc.clone.35+0x3c/0x120
>> > [60295.945349]  [<ffffffff81503320>] ? sk_clone+0x10/0x2b0
>> > [60295.945352]  [<ffffffff815580bb>] ? inet_csk_clone+0xb/0x90
>> > [60295.945355]  [<ffffffff8156fa31>] ? tcp_create_openreq_child+0x21/0x4e0
>> > [60295.945357]  [<ffffffff8156cbd3>] ? tcp_v4_syn_recv_sock+0x53/0x250
>> > [60295.945359]  [<ffffffff8156f790>] ? tcp_check_req+0x200/0x480
>> > [60295.945362]  [<ffffffff8156cab1>] ? tcp_v4_do_rcv+0x1c1/0x290
>> > [60295.945365]  [<ffffffff8154dd30>] ? ip_rcv_finish+0x340/0x340
>> > [60295.945367]  [<ffffffff8156f047>] ? tcp_v4_rcv+0x5f7/0x8b0
>> > [60295.945369]  [<ffffffff8154ddf4>] ? ip_local_deliver_finish+0xc4/0x200
>> > [60295.945373]  [<ffffffff8151158b>] ? __netif_receive_skb+0x4eb/0x610
>> > [60295.945375]  [<ffffffff81511898>] ? netif_receive_skb+0x78/0x80
>> > [60295.945377]  [<ffffffff81511f03>] ? napi_gro_receive+0xa3/0xc0
>> > [60295.945379]  [<ffffffff815119b8>] ? napi_skb_finish+0x38/0x50
>> > [60295.945383]  [<ffffffff813e6208>] ? igb_poll+0x8b8/0xd00
>> > [60295.945386]  [<ffffffff8102e5f1>] ? enqueue_task_rt+0x121/0x320
>> > [60295.945388]  [<ffffffff815120c9>] ? net_rx_action+0xf9/0x180
>> > [60295.945391]  [<ffffffff8103df38>] ? __do_softirq+0x98/0x120
>> > [60295.945395]  [<ffffffff81070010>] ? irq_thread_fn+0x40/0x40
>> > [60295.945397]  [<ffffffff81619a4c>] ? call_softirq+0x1c/0x30
>> > [60295.945398]  <EOI>  [<ffffffff81003d8d>] ? do_softirq+0x4d/0x80
>> > [60295.945402]  [<ffffffff8103de94>] ? local_bh_enable+0x94/0xa0
>> > [60295.945405]  [<ffffffff8106ff70>] ? irq_thread+0x150/0x1b0
>> > [60295.945407]  [<ffffffff8106fe20>] ? irq_finalize_oneshot+0x130/0x130
>> > [60295.945409]  [<ffffffff8106fe20>] ? irq_finalize_oneshot+0x130/0x130
>> > [60295.945412]  [<ffffffff81052746>] ? kthread+0x96/0xa0
>> > [60295.945414]  [<ffffffff81619954>] ? kernel_thread_helper+0x4/0x10
>> > [60295.945417]  [<ffffffff810526b0>] ? kthread_worker_fn+0x120/0x120
>> > [60295.945418]  [<ffffffff81619950>] ? gs_change+0xb/0xb
> ..
>
> Not on a NIC, but also with 2.6.39:
>
> [35850.612899] sd 4:0:0:0: [sdc] Attached SCSI disk
> [35943.085264] mount: page allocation failure. order:5, mode:0xc0d0
> [35943.085277] Pid: 14228, comm: mount Not tainted 2.6.39 #10
> [35943.085284] Call Trace:
> [35943.085306]  [<ffffffff8106fa96>] ? __alloc_pages_nodemask+0x710/0x74d
> [35943.085322]  [<ffffffff8106fb5b>] ? __get_free_pages+0x12/0x50
> [35943.085335]  [<ffffffff810f9120>] ? ext4_fill_super+0xe4f/0x20ff
> [35943.085347]  [<ffffffff810f82d1>] ? ext4_remount+0x40e/0x40e
> [35943.085359]  [<ffffffff81148ef0>] ? snprintf+0x36/0x3b
> [35943.085371]  [<ffffffff810f82d1>] ? ext4_remount+0x40e/0x40e
> [35943.085384]  [<ffffffff8109e05e>] ? mount_bdev+0x136/0x17d
> [35943.085397]  [<ffffffff8109537d>] ? __kmalloc_track_caller+0xa9/0x116
> [35943.085410]  [<ffffffff8109cfa6>] ? mount_fs+0xc/0xa6
> [35943.085423]  [<ffffffff810b225d>] ? vfs_kern_mount+0x61/0x97
> [35943.085434]  [<ffffffff810b22f2>] ? do_kern_mount+0x49/0xd6
> [35943.085445]  [<ffffffff810b2a70>] ? do_mount+0x6f1/0x758
> [35943.085457]  [<ffffffff81078f01>] ? memdup_user+0x3f/0x5b
> [35943.085468]  [<ffffffff810b2b5f>] ? sys_mount+0x88/0xcd
> [35943.085482]  [<ffffffff812cc47b>] ? system_call_fastpath+0x16/0x1b
> [35943.085490] Mem-Info:
> [35943.085496] DMA per-cpu:
> [35943.085503] CPU    0: hi:    0, btch:   1 usd:   0
> [35943.085511] CPU    1: hi:    0, btch:   1 usd:   0
> [35943.085517] DMA32 per-cpu:
> [35943.085524] CPU    0: hi:  186, btch:  31 usd:   0
> [35943.085532] CPU    1: hi:  186, btch:  31 usd: 114
> [35943.085549] active_anon:64179 inactive_anon:31764 isolated_anon:0
> [35943.085554]  active_file:90242 inactive_file:223697 isolated_file:0
> [35943.085558]  unevictable:2 dirty:24616 writeback:0 unstable:0
> [35943.085562]  free:19204 slab_reclaimable:64266 slab_unreclaimable:6283
> [35943.085566]  mapped:7463 shmem:31597 pagetables:5475 bounce:0
> [35943.085592] DMA free:8308kB min:340kB low:424kB high:508kB active_anon:0kB
> inactive_anon:1056kB active_file:1736kB inactive_file:4712kB unevictable:0kB
> isolated(anon):0kB isolated(file):0kB present:15688kB mlocked:0kB dirty:0kB
> writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:92kB slab_unreclaimable:8kB
> kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> [35943.085612] lowmem_reserve[]: 0 1993 1993 1993
> [35943.085643] DMA32 free:68508kB min:44712kB low:55888kB high:67068kB
> active_anon:256716kB inactive_anon:126000kB active_file:359232kB
> inactive_file:890076kB unevictable:8kB isolated(anon):0kB isolated(file):0kB
> present:2041776kB mlocked:0kB dirty:98464kB writeback:0kB mapped:29852kB
> shmem:126388kB slab_reclaimable:256972kB slab_unreclaimable:25124kB
> kernel_stack:2160kB pagetables:21900kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:115 all_unreclaimable? no
> [35943.085663] lowmem_reserve[]: 0 0 0 0
> [35943.085673] DMA: 3*4kB 3*8kB 3*16kB 15*32kB 17*64kB 6*128kB 3*256kB 4*512kB
> 1*1024kB 1*2048kB 0*4096kB = 8308kB
> [35943.085700] DMA32: 5597*4kB 2221*8kB 948*16kB 330*32kB 33*64kB 4*128kB
> 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 68508kB
> [35943.085727] 345589 total pagecache pages
> [35943.085733] 50 pages in swap cache
> [35943.085739] Swap cache stats: add 58, delete 8, find 0/0
> [35943.085744] Free swap  = 1975060kB
> [35943.085749] Total swap = 1975292kB
> [35943.113312] 521600 pages RAM
> [35943.113318] 9355 pages reserved
> [35943.113322] 290443 pages shared
> [35943.113326] 248448 pages non-shared
> [35943.181471] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts:
> (null)

Oh, and another one, not quite identical:

[297246.722573] mount: page allocation failure. order:5, mode:0xc0d0
[297246.722584] Pid: 25863, comm: mount Not tainted 2.6.39 #10
[297246.722590] Call Trace:
[297246.722610]  [<ffffffff8106fa96>] ? __alloc_pages_nodemask+0x710/0x74d
[297246.722622]  [<ffffffff810bbd2c>] ? unmap_underlying_metadata+0x4b/0x4b
[297246.722633]  [<ffffffff8106fb5b>] ? __get_free_pages+0x12/0x50
[297246.722643]  [<ffffffff810f9120>] ? ext4_fill_super+0xe4f/0x20ff
[297246.722652]  [<ffffffff810f82d1>] ? ext4_remount+0x40e/0x40e
[297246.722662]  [<ffffffff81148ef0>] ? snprintf+0x36/0x3b
[297246.722670]  [<ffffffff810f82d1>] ? ext4_remount+0x40e/0x40e
[297246.722680]  [<ffffffff8109e05e>] ? mount_bdev+0x136/0x17d
[297246.722690]  [<ffffffff8109537d>] ? __kmalloc_track_caller+0xa9/0x116
[297246.722700]  [<ffffffff8109cfa6>] ? mount_fs+0xc/0xa6
[297246.722710]  [<ffffffff810b225d>] ? vfs_kern_mount+0x61/0x97
[297246.722720]  [<ffffffff810b22f2>] ? do_kern_mount+0x49/0xd6
[297246.722729]  [<ffffffff810b2a70>] ? do_mount+0x6f1/0x758
[297246.722740]  [<ffffffff81078f01>] ? memdup_user+0x3f/0x5b
[297246.722749]  [<ffffffff810b2b5f>] ? sys_mount+0x88/0xcd
[297246.722761]  [<ffffffff812cc47b>] ? system_call_fastpath+0x16/0x1b
[297246.722767] Mem-Info:
[297246.722772] DMA per-cpu:
[297246.722778] CPU    0: hi:    0, btch:   1 usd:   0
[297246.722784] CPU    1: hi:    0, btch:   1 usd:   0
[297246.722788] DMA32 per-cpu:
[297246.722794] CPU    0: hi:  186, btch:  31 usd:  14
[297246.722800] CPU    1: hi:  186, btch:  31 usd:   0
[297246.722813] active_anon:73864 inactive_anon:32029 isolated_anon:0
[297246.722817]  active_file:76404 inactive_file:195583 isolated_file:0
[297246.722821]  unevictable:2 dirty:19997 writeback:0 unstable:0
[297246.722824]  free:20421 slab_reclaimable:96332 slab_unreclaimable:4325
[297246.722827]  mapped:7904 shmem:29851 pagetables:5963 bounce:0
[297246.722848] DMA free:8396kB min:340kB low:424kB high:508kB active_anon:0kB
inactive_anon:2048kB active_file:3476kB inactive_file:400kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15688kB mlocked:0kB dirty:0kB
writeback:0kB mapped:52kB shmem:0kB slab_reclaimable:1588kB
slab_unreclaimable:4kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[297246.722864] lowmem_reserve[]: 0 1993 1993 1993
[297246.722888] DMA32 free:73288kB min:44712kB low:55888kB high:67068kB
active_anon:295456kB inactive_anon:126068kB active_file:302140kB
inactive_file:781932kB unevictable:8kB isolated(anon):0kB isolated(file):0kB
present:2041776kB mlocked:0kB dirty:79988kB writeback:0kB mapped:31564kB
shmem:119404kB slab_reclaimable:383740kB slab_unreclaimable:17296kB
kernel_stack:2248kB pagetables:23852kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[297246.722904] lowmem_reserve[]: 0 0 0 0
[297246.722912] DMA: 57*4kB 29*8kB 10*16kB 1*32kB 3*64kB 3*128kB 4*256kB 2*512kB
3*1024kB 1*2048kB 0*4096kB = 8396kB
[297246.722936] DMA32: 3186*4kB 2220*8kB 936*16kB 455*32kB 191*64kB 8*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 73288kB
[297246.722962] 310158 total pagecache pages
[297246.722968] 8321 pages in swap cache
[297246.722974] Swap cache stats: add 33604, delete 25283, find 46658/48112
[297246.722980] Free swap  = 1899068kB
[297246.722984] Total swap = 1975292kB
[297246.747988] 521600 pages RAM
[297246.747995] 9355 pages reserved
[297246.748000] 258772 pages shared
[297246.748004] 291766 pages non-shared
[297246.815211] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts:
(null)
