From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: Out of memory: ext3 with data=journal and non-standard journal
 size (2.6.27-rc6)
Date: Wed, 08 Oct 2008 11:42:44 +0900
Message-ID: <48EC1E24.9000100@jp.fujitsu.com>
References: <a700c9740810071743k496ea343m703d703b65153758@mail.gmail.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
To: Alexey Kopytko <alexey@kopytko.ru>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYJHCmw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 22:42:52 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id m982gnFl022980
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 8 Oct 2008 11:42:49 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 7E0CB53C0AD
	for <linux-ext4@vger.kernel.org>; Wed,  8 Oct 2008 11:42:49 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 5590524005B
	for <linux-ext4@vger.kernel.org>; Wed,  8 Oct 2008 11:42:49 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 252301DB8045
	for <linux-ext4@vger.kernel.org>; Wed,  8 Oct 2008 11:42:49 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id B966A1DB8043
	for <linux-ext4@vger.kernel.org>; Wed,  8 Oct 2008 11:42:48 +0900 (JST)
In-Reply-To: <a700c9740810071743k496ea343m703d703b65153758@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I have experienced similar problem recently.
I am examining the solution method of the problem.

# I think that a large amount of journal heads which cannot be released remain in your system.
# So, buffer heads to which journal heads are corresponding also remain.
# As a result, nothing can be returned for memory request.

Regards,
Toshiyuki Okajima

Alexey Kopytko wrote:
 > When writing to ext3 with extra sized journal, out of memory errors may occur.
 >
 > Is that OK?
 >
 > Steps to reproduce:
 >
 > LSmini ~ # uname -a
 > Linux LSmini 2.6.27-rc6lsmini-00036-g5d58b60 #79 PREEMPT Tue Oct 7
 > 22:31:16 JST 2008 armv5tel Feroceon rev 0 (v5l) Buffalo Linkstation
 > Mini GNU/Linux
 >
 > We are on arm9-based NAS board with not much memory, but you can
 > repeat that on x86:
 >
 >  # grep MemTotal /proc/meminfo
 > MemTotal:       126968 kB
 >
 > # mkfs.ext3 -T largefile -J size=512 /dev/md4
 > # tune2fs -o journal_data /dev/md4
 >
 > Confirm journal size: it must be larger than all available memory.
 >
 > # debugfs /dev/md4 -R "stat <8>" | grep -i user
 > debugfs 1.41.1 (01-Sep-2008)
 > User:     0   Group:     0   Size: 536870912
 >
 > # mkdir /raid/
 > # mount /dev/md4  /raid/
 >
 > # grep md4 /proc/mounts
 > /dev/md4 /raid ext3 rw,errors=continue,data=journal 0 0
 >
 > Now write something larger than all your memory:
 >
 > # dd if=/dev/zero of=/raid/testfile bs=1M count=150;
 >
 > And watch you system being out of memory:
 >
 > <6>kjournald starting.  Commit interval 5 seconds
 > <6>EXT3 FS on md4, internal journal
 > <6>EXT3-fs: mounted filesystem with journal data mode.
 > <4>sshd: page allocation failure. order:2, mode:0x20
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c00680d0>]
 > (__alloc_pages_internal+0x3e8/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c0084e60>]
 > (cache_alloc_refill+0x300/0x5e4)
 > <4>[<c0084b60>] (cache_alloc_refill+0x0/0x5e4) from [<c00851d8>]
 > (__kmalloc+0x94/0xd0)
 > <4>[<c0085144>] (__kmalloc+0x0/0xd0) from [<c01cdf54>] (__alloc_skb+0x50/0xf4)
 > <4> r7:c7807d40 r6:00002380 r5:00000020 r4:c7834780
 > <4>[<c01cdf04>] (__alloc_skb+0x0/0xf4) from [<c01ce2c0>]
 > (dev_alloc_skb+0x20/0x44)
 > <4> r8:c78c6450 r7:c78c604c r6:c78c6450 r5:c11645c0 r4:20000013
 > <4>[<c01ce2a0>] (dev_alloc_skb+0x0/0x44) from [<c0166b54>]
 > (rxq_refill+0x70/0x198)
 > <4>[<c0166ae4>] (rxq_refill+0x0/0x198) from [<c01681c0>]
 > (mv643xx_eth_poll+0x364/0x45c)
 > <4>[<c0167e5c>] (mv643xx_eth_poll+0x0/0x45c) from [<c01d5870>]
 > (net_rx_action+0x64/0x1b8)
 > <4>[<c01d580c>] (net_rx_action+0x0/0x1b8) from [<c003a584>]
 > (__do_softirq+0x68/0xd0)
 > <4>[<c003a51c>] (__do_softirq+0x0/0xd0) from [<c003a638>] (do_softirq+0x4c/0x58)
 > <4>[<c003a5ec>] (do_softirq+0x0/0x58) from [<c003ad9c>]
 > (local_bh_enable+0x8c/0xc0)
 > <4> r4:c11a88e0
 > <4>[<c003ad10>] (local_bh_enable+0x0/0xc0) from [<c01d7034>]
 > (dev_queue_xmit+0x484/0x4d0)
 > <4> r4:c11a88e0
 > <4>[<c01d6bb0>] (dev_queue_xmit+0x0/0x4d0) from [<c01f17dc>]
 > (ip_finish_output+0x24c/0x2a0)
 > <4> r7:00000000 r6:0000000e r5:c603c3e0 r4:c7869f08
 > <4>[<c01f1590>] (ip_finish_output+0x0/0x2a0) from [<c01f1b8c>]
 > (ip_output+0x80/0x88)
 > <4>[<c01f1b0c>] (ip_output+0x0/0x88) from [<c01efec8>] (ip_local_out+0x30/0x34)
 > <4> r5:000222d8 r4:c7869f08
 > <4>[<c01efe98>] (ip_local_out+0x0/0x34) from [<c01f2024>]
 > (ip_queue_xmit+0x2cc/0x340)
 > <4> r4:c6b68c6c
 > <4>[<c01f1d58>] (ip_queue_xmit+0x0/0x340) from [<c0203240>]
 > (tcp_transmit_skb+0x68c/0x6e0)
 > <4>[<c0202bb4>] (tcp_transmit_skb+0x0/0x6e0) from [<c0204cd0>]
 > (__tcp_push_pending_frames+0x6fc/0x7b8)
 > <4>[<c02045d4>] (__tcp_push_pending_frames+0x0/0x7b8) from
 > [<c01f9718>] (tcp_sendmsg+0x9ec/0xb50)
 > <4>[<c01f8d2c>] (tcp_sendmsg+0x0/0xb50) from [<c01c6690>]
 > (sock_aio_write+0xdc/0xe4)
 > <4>[<c01c65b4>] (sock_aio_write+0x0/0xe4) from [<c0087f7c>]
 > (do_sync_write+0xb8/0x10c)
 > <4> r8:c7197f70 r7:c11c3240 r6:c784d940 r5:00000000 r4:00000000
 > <4>[<c0087ec4>] (do_sync_write+0x0/0x10c) from [<c0088884>]
 > (vfs_write+0xd0/0x148)
 > <4>[<c00887b4>] (vfs_write+0x0/0x148) from [<c0088df4>] (sys_write+0x44/0x70)
 > <4> r7:00000080 r6:c11c3240 r5:00000000 r4:00000000
 > <4>[<c0088db0>] (sys_write+0x0/0x70) from [<c0025c80>]
 > (ret_fast_syscall+0x0/0x2c)
 > <4> r8:c0025e04 r7:00000004 r6:0005802c r5:00000080 r4:00000003
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  31
 > <4>Active:1073 inactive:26121 dirty:12701 writeback:3684 unstable:0
 > <4> free:800 slab:3375 mapped:325 pagetables:49 bounce:0
 > <4>DMA free:3200kB min:1440kB low:1800kB high:2160kB active:4292kB
 > inactive:104484kB present:130048kB pages_scanned:0 all_unreco
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 626*4kB 71*8kB 2*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 3200kB
 > <4>26811 total pagecache pages
 > <4>172 pages in swap cache
 > <4>Swap cache stats: add 10545, delete 10373, find 4757/5468
 > <4>Free swap  = 247176kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>914 free pages
 > <4>1109 reserved pages
 > <4>3375 slab pages
 > <4>26799 pages shared
 > <4>172 pages swap cached
 > <4>top invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c006a624>]
 > (__do_page_cache_readahead+0x118/0x254)
 > <4>[<c006a50c>] (__do_page_cache_readahead+0x0/0x254) from
 > [<c006abdc>] (do_page_cache_readahead+0x6c/0x74)
 > <4>[<c006ab70>] (do_page_cache_readahead+0x0/0x74) from [<c00646cc>]
 > (filemap_fault+0x1dc/0x450)
 > <4> r7:c117e8c0 r6:c7192000 r5:00000000 r4:00000000
 > <4>[<c00644f0>] (filemap_fault+0x0/0x450) from [<c0070cf4>]
 > (__do_fault+0x58/0x410)
 > <4>[<c0070c9c>] (__do_fault+0x0/0x410) from [<c0071e7c>]
 > (handle_mm_fault+0x32c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c002b608>]
 > (do_translation_fault+0x1c/0x88)
 > <4>[<c002b5ec>] (do_translation_fault+0x0/0x88) from [<c00251e8>]
 > (do_PrefetchAbort+0x18/0x1c)
 > <4> r4:ffffffff
 > <4>[<c00251d0>] (do_PrefetchAbort+0x0/0x1c) from [<c0025c00>]
 > (ret_from_exception+0x0/0x10)
 > <4>Exception stack(0xc7193fb0 to 0xc7193ff8)
 > <4>3fa0:                                     00000000 be82a55c
 > 00000001 00000001
 > <4>3fc0: 00000000 be82a55c 00000001 0001e848 0001d160 be82a408
 > be82a55c 00020638
 > <4>3fe0: 0001d070 be829c80 0000dc28 401557c0 60000010 ffffffff
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  39
 > <4>Active:13785 inactive:13645 dirty:0 writeback:0 unstable:0
 > <4> free:367 slab:3510 mapped:0 pagetables:53 bounce:0
 > <4>DMA free:1468kB min:1440kB low:1800kB high:2160kB active:55140kB
 > inactive:54580kB present:130048kB pages_scanned:113442 all_o
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 231*4kB 48*8kB 4*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1468kB
 > <4>22576 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12048, delete 12048, find 5471/6308
 > <4>Free swap  = 245844kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>493 free pages
 > <4>1109 reserved pages
 > <4>3510 slab pages
 > <4>22576 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 979 (rpc.statd) score 392 or a child
 > <3>Killed process 979 (rpc.statd)
 > <4>top invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c006a624>]
 > (__do_page_cache_readahead+0x118/0x254)
 > <4>[<c006a50c>] (__do_page_cache_readahead+0x0/0x254) from
 > [<c006abdc>] (do_page_cache_readahead+0x6c/0x74)
 > <4>[<c006ab70>] (do_page_cache_readahead+0x0/0x74) from [<c00646cc>]
 > (filemap_fault+0x1dc/0x450)
 > <4> r7:c117e8c0 r6:c7192000 r5:00000000 r4:00000000
 > <4>[<c00644f0>] (filemap_fault+0x0/0x450) from [<c0070cf4>]
 > (__do_fault+0x58/0x410)
 > <4>[<c0070c9c>] (__do_fault+0x0/0x410) from [<c0071e7c>]
 > (handle_mm_fault+0x32c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c002b608>]
 > (do_translation_fault+0x1c/0x88)
 > <4>[<c002b5ec>] (do_translation_fault+0x0/0x88) from [<c00251e8>]
 > (do_PrefetchAbort+0x18/0x1c)
 > <4> r4:ffffffff
 > <4>[<c00251d0>] (do_PrefetchAbort+0x0/0x1c) from [<c0025c00>]
 > (ret_from_exception+0x0/0x10)
 > <4>Exception stack(0xc7193fb0 to 0xc7193ff8)
 > <4>3fa0:                                     00000000 be82a55c
 > 00000001 00000001
 > <4>3fc0: 00000000 be82a55c 00000001 0001e848 0001d160 be82a408
 > be82a55c 00020638
 > <4>3fe0: 0001d070 be829c80 0000dc28 401557c0 60000010 ffffffff
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  37
 > <4>Active:13160 inactive:14270 dirty:0 writeback:0 unstable:0
 > <4> free:357 slab:3510 mapped:0 pagetables:50 bounce:0
 > <4>DMA free:1428kB min:1440kB low:1800kB high:2160kB active:52640kB
 > inactive:57080kB present:130048kB pages_scanned:219443 all_s
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 215*4kB 49*8kB 5*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1428kB
 > <4>22576 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12053, delete 12053, find 5471/6309
 > <4>Free swap  = 245924kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>478 free pages
 > <4>1109 reserved pages
 > <4>3510 slab pages
 > <4>22576 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 964 (portmap) score 369 or a child
 > <3>Killed process 964 (portmap)
 > <4>dd invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c007c5b8>]
 > (read_swap_cache_async+0x4c/0x100)
 > <4>[<c007c56c>] (read_swap_cache_async+0x0/0x100) from [<c007c6a8>]
 > (swapin_readahead+0x3c/0x94)
 > <4>[<c007c66c>] (swapin_readahead+0x0/0x94) from [<c0071ebc>]
 > (handle_mm_fault+0x36c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c0025228>]
 > (do_DataAbort+0x3c/0xa0)
 > <4>[<c00251ec>] (do_DataAbort+0x0/0xa0) from [<c002582c>] (__dabt_svc+0x4c/0x60)
 > <4>Exception stack(0xc785dc90 to 0xc785dcd8)
 > <4>dc80:                                     00001000 00000000
 > 4022e000 00000000
 > <4>dca0: 00001000 c785c000 057b1000 00000000 00000000 c785dd40
 > 00001000 c785dcec
 > <4>dcc0: 000b1000 c785dcd8 c006292c c0060e88 20000013 ffffffff
 > <4> r8:00000000 r7:00000000 r6:057b1000 r5:c785dcc4 r4:ffffffff
 > <4>[<c0060e48>] (iov_iter_fault_in_readable+0x0/0x98) from
 > [<c006292c>] (generic_file_buffered_write+0xe0/0x698)
 > <4>[<c006284c>] (generic_file_buffered_write+0x0/0x698) from
 > [<c0063634>] (__generic_file_aio_write_nolock+0x49c/0x4ec)
 > <4>[<c0063198>] (__generic_file_aio_write_nolock+0x0/0x4ec) from
 > [<c00636f8>] (generic_file_aio_write+0x74/0xe8)
 > <4>[<c0063684>] (generic_file_aio_write+0x0/0xe8) from [<c00cff1c>]
 > (ext3_file_write+0x28/0xa8)
 > <4>[<c00cfef4>] (ext3_file_write+0x0/0xa8) from [<c0087f7c>]
 > (do_sync_write+0xb8/0x10c)
 > <4> r7:c09eb1e0 r6:c78976a0 r5:00000000 r4:05700000
 > <4>[<c0087ec4>] (do_sync_write+0x0/0x10c) from [<c008886c>]
 > (vfs_write+0xb8/0x148)
 > <4>[<c00887b4>] (vfs_write+0x0/0x148) from [<c0088df4>] (sys_write+0x44/0x70)
 > <4> r7:00100000 r6:c09eb1e0 r5:00000000 r4:05700000
 > <4>[<c0088db0>] (sys_write+0x0/0x70) from [<c0025c80>]
 > (ret_fast_syscall+0x0/0x2c)
 > <4> r8:c0025e04 r7:00000004 r6:4017d000 r5:00100000 r4:00000000
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  31
 > <4>Active:13770 inactive:13693 dirty:0 writeback:0 unstable:0
 > <4> free:354 slab:3510 mapped:1 pagetables:47 bounce:0
 > <4>DMA free:1416kB min:1440kB low:1800kB high:2160kB active:55080kB
 > inactive:54772kB present:130048kB pages_scanned:14174 all_uo
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 208*4kB 49*8kB 6*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1416kB
 > <4>22609 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12061, delete 12061, find 5471/6311
 > <4>Free swap  = 246004kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>466 free pages
 > <4>1109 reserved pages
 > <4>3510 slab pages
 > <4>22578 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 1057 (sshd) score 183 or a child
 > <3>Killed process 1075 (sshd)
 > <4>sshd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c006a624>]
 > (__do_page_cache_readahead+0x118/0x254)
 > <4>[<c006a50c>] (__do_page_cache_readahead+0x0/0x254) from
 > [<c006abdc>] (do_page_cache_readahead+0x6c/0x74)
 > <4>[<c006ab70>] (do_page_cache_readahead+0x0/0x74) from [<c00646cc>]
 > (filemap_fault+0x1dc/0x450)
 > <4> r7:c113bd60 r6:c7196000 r5:00000000 r4:00000000
 > <4>[<c00644f0>] (filemap_fault+0x0/0x450) from [<c0070cf4>]
 > (__do_fault+0x58/0x410)
 > <4>[<c0070c9c>] (__do_fault+0x0/0x410) from [<c0071e7c>]
 > (handle_mm_fault+0x32c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c002b608>]
 > (do_translation_fault+0x1c/0x88)
 > <4>[<c002b5ec>] (do_translation_fault+0x0/0x88) from [<c00251e8>]
 > (do_PrefetchAbort+0x18/0x1c)
 > <4> r4:ffffffff
 > <4>[<c00251d0>] (do_PrefetchAbort+0x0/0x1c) from [<c0025c00>]
 > (ret_from_exception+0x0/0x10)
 > <4>Exception stack(0xc7197fb0 to 0xc7197ff8)
 > <4>7fa0:                                     be92f35c 00000011
 > ffffffff be92f3dc
 > <4>7fc0: be92f35c 00000000 0005802c 00056abc be92f474 be92f47c
 > be92f478 be92f470
 > <4>7fe0: 0005626c be92f358 00014ed8 402846ac 80000010 ffffffff
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  35
 > <4>Active:13806 inactive:13657 dirty:0 writeback:0 unstable:0
 > <4> free:358 slab:3512 mapped:1 pagetables:42 bounce:0
 > <4>DMA free:1432kB min:1440kB low:1800kB high:2160kB active:55224kB
 > inactive:54628kB present:130048kB pages_scanned:348 all_unro
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 208*4kB 49*8kB 7*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1432kB
 > <4>22609 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12061, delete 12061, find 5471/6313
 > <4>Free swap  = 246484kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>471 free pages
 > <4>1109 reserved pages
 > <4>3512 slab pages
 > <4>22578 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 1155 (sshd) score 139 or a child
 > <3>Killed process 1159 (bash)
 > <4>cat invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c006a624>]
 > (__do_page_cache_readahead+0x118/0x254)
 > <4>[<c006a50c>] (__do_page_cache_readahead+0x0/0x254) from
 > [<c006abdc>] (do_page_cache_readahead+0x6c/0x74)
 > <4>[<c006ab70>] (do_page_cache_readahead+0x0/0x74) from [<c00646cc>]
 > (filemap_fault+0x1dc/0x450)
 > <4> r7:c09ebc60 r6:c7ada000 r5:00000000 r4:00000000
 > <4>[<c00644f0>] (filemap_fault+0x0/0x450) from [<c0070cf4>]
 > (__do_fault+0x58/0x410)
 > <4>[<c0070c9c>] (__do_fault+0x0/0x410) from [<c0071e7c>]
 > (handle_mm_fault+0x32c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c002b608>]
 > (do_translation_fault+0x1c/0x88)
 > <4>[<c002b5ec>] (do_translation_fault+0x0/0x88) from [<c00251e8>]
 > (do_PrefetchAbort+0x18/0x1c)
 > <4> r4:ffffffff
 > <4>[<c00251d0>] (do_PrefetchAbort+0x0/0x1c) from [<c0025c00>]
 > (ret_from_exception+0x0/0x10)
 > <4>Exception stack(0xc7adbfb0 to 0xc7adbff8)
 > <4>bfa0:                                     0000096f 00016000
 > 00001000 00016000
 > <4>bfc0: 00001000 00016000 00016000 00000003 7fffe000 00000000
 > 40023fa4 00001000
 > <4>bfe0: 00000003 bedc24b8 0000aad8 400d37dc 60000010 ffffffff
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  36
 > <4>Active:13864 inactive:13567 dirty:0 writeback:0 unstable:0
 > <4> free:418 slab:3512 mapped:0 pagetables:39 bounce:0
 > <4>DMA free:1672kB min:1440kB low:1800kB high:2160kB active:55456kB
 > inactive:54268kB present:130048kB pages_scanned:219271 all_s
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 258*4kB 48*8kB 10*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1672kB
 > <4>22577 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12066, delete 12066, find 5471/6314
 > <4>Free swap  = 246816kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>529 free pages
 > <4>1109 reserved pages
 > <4>3512 slab pages
 > <4>22577 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 1057 (sshd) score 124 or a child
 > <3>Killed process 1155 (sshd)
 > <4>top invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
 > <4>[<c0029994>] (dump_stack+0x0/0x14) from [<c006526c>]
 > (oom_kill_process+0x58/0x1cc)
 > <4>[<c0065214>] (oom_kill_process+0x0/0x1cc) from [<c00657c8>]
 > (out_of_memory+0x1cc/0x238)
 > <4>[<c00655fc>] (out_of_memory+0x0/0x238) from [<c006802c>]
 > (__alloc_pages_internal+0x344/0x400)
 > <4>[<c0067ce8>] (__alloc_pages_internal+0x0/0x400) from [<c006a624>]
 > (__do_page_cache_readahead+0x118/0x254)
 > <4>[<c006a50c>] (__do_page_cache_readahead+0x0/0x254) from
 > [<c006abdc>] (do_page_cache_readahead+0x6c/0x74)
 > <4>[<c006ab70>] (do_page_cache_readahead+0x0/0x74) from [<c00646cc>]
 > (filemap_fault+0x1dc/0x450)
 > <4> r7:c117e8c0 r6:c7192000 r5:00000000 r4:00000000
 > <4>[<c00644f0>] (filemap_fault+0x0/0x450) from [<c0070cf4>]
 > (__do_fault+0x58/0x410)
 > <4>[<c0070c9c>] (__do_fault+0x0/0x410) from [<c0071e7c>]
 > (handle_mm_fault+0x32c/0x734)
 > <4>[<c0071b50>] (handle_mm_fault+0x0/0x734) from [<c002b420>]
 > (do_page_fault+0xf4/0x23c)
 > <4>[<c002b32c>] (do_page_fault+0x0/0x23c) from [<c002b608>]
 > (do_translation_fault+0x1c/0x88)
 > <4>[<c002b5ec>] (do_translation_fault+0x0/0x88) from [<c00251e8>]
 > (do_PrefetchAbort+0x18/0x1c)
 > <4> r4:ffffffff
 > <4>[<c00251d0>] (do_PrefetchAbort+0x0/0x1c) from [<c0025c00>]
 > (ret_from_exception+0x0/0x10)
 > <4>Exception stack(0xc7193fb0 to 0xc7193ff8)
 > <4>3fa0:                                     be829965 0001e25c
 > 00000000 00000003
 > <4>3fc0: 00008a3b 00000000 00000000 00005404 0001d160 be82a408
 > be82a55c 00020638
 > <4>3fe0: 00000010 be829950 00000016 4015bf8c 40000010 ffffffff
 > <4>Mem-info:
 > <4>DMA per-cpu:
 > <4>CPU    0: hi:   42, btch:   7 usd:  38
 > <4>Active:13638 inactive:13735 dirty:0 writeback:0 unstable:0
 > <4> free:416 slab:3514 mapped:0 pagetables:34 bounce:0
 > <4>DMA free:1664kB min:1440kB low:1800kB high:2160kB active:54552kB
 > inactive:54940kB present:130048kB pages_scanned:221054 all_s
 > <4>lowmem_reserve[]: 0 0 0
 > <4>DMA: 230*4kB 55*8kB 13*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
 > 0*1024kB 0*2048kB 0*4096kB = 1664kB
 > <4>22583 total pagecache pages
 > <4>0 pages in swap cache
 > <4>Swap cache stats: add 12217, delete 12217, find 5488/6358
 > <4>Free swap  = 247296kB
 > <4>Total swap = 250580kB
 > <4>32768 pages of RAM
 > <4>523 free pages
 > <4>1109 reserved pages
 > <4>3514 slab pages
 > <4>22647 pages shared
 > <4>0 pages swap cached
 > <3>Out of memory: kill process 1074 (login) score 69 or a child
 > <3>Killed process 1110 (bash)
 >
 > And so on until kernel panic and reboot.
 >
 > This bug won't occur with default journal size, even if it is larger
 > than all available memory.
 >
 > Regards,
 > Alexey
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html

