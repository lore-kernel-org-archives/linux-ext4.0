From: Meelis Roos <mroos@linux.ee>
Subject: Re: 4.7-rc6, ext4, sparc64: Unable to handle kernel paging request
 at ...
Date: Sun, 31 Jul 2016 19:47:38 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1607311944440.26644@math.ut.ee>
References: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Just got this on bootup of my Sun T2000:

This time I got similar (but with slightly different virtual address) 
one on the same t2000 on 4.7.0-07753-gc9b95e5. Looks like pointer 
corruption?

[   70.888080] This architecture does not have kernel memory protection.
[   70.901299] random: fast init done
[   72.796476] Unable to handle kernel paging request at virtual address 000000000000e000
[   72.796717] tsk->{mm,active_mm}->context = 00000000000000b7
[   72.796904] tsk->{mm,active_mm}->pgd = ffff8003f354c000
[   72.797088]               \|/ ____ \|/
                             "@'/ .. \`@"
                             /_| \__/ |_\
                                \__U_/
[   72.797490] udevd(410): Oops [#1]
[   72.797669] CPU: 30 PID: 410 Comm: udevd Not tainted 4.7.0-07753-gc9b95e5 #115
[   72.797900] task: ffff8003fd72c440 task.stack: ffff8003f363c000
[   72.798090] TSTATE: 0000000011001601 TPC: 0000000000741b00 TNPC: 0000000000741b04 Y: 00000000    Not tainted
[   72.798396] TPC: <__radix_tree_lookup+0x60/0x1a0>
[   72.798521] g0: 0000000000bcec00 g1: 000000000000e6e1 g2: 0000000000000001 g3: 000000008064d76f
[   72.798752] g4: ffff8003fd72c440 g5: ffff8003fec68000 g6: ffff8003f363c000 g7: 0000000000000000
[   72.798980] o0: ffff8003fca8b6e0 o1: ffff8003f3502700 o2: 000000000000028d o3: 0000000000000010
[   72.799200] o4: 0000000000000000 o5: 0000000000000040 sp: ffff8003f363f111 ret_pc: ffff8003fcda2b40
[   72.799419] RPC: <0xffff8003fcda2b40>
[   72.799534] l0: 0000000000000292 l1: 0000000000000005 l2: 0000000000000329 l3: 0000000000000005
[   72.799757] l4: ffff8003fca8b6e8 l5: ffff8003f363fa70 l6: 00000000024213ca l7: 00000000024213ca
[   72.799979] i0: ffff8003fca8b6e8 i1: 0000000000000292 i2: 0000000000000000 i3: 0000000000000000
[   72.800196] i4: 000000000000e6e0 i5: 000000000000000a i6: ffff8003f363f1c1 i7: 0000000000541bac
[   72.800451] I7: <__do_page_cache_readahead+0x6c/0x260>
[   72.800631] Call Trace:
[   72.800751]  [0000000000541bac] __do_page_cache_readahead+0x6c/0x260
[   72.800941]  [00000000005351e0] filemap_fault+0x2a0/0x540
[   72.801127]  [00000000006355bc] ext4_filemap_fault+0x1c/0x40
[   72.801312]  [00000000005640c0] __do_fault+0x60/0x100
[   72.801493]  [0000000000569648] handle_mm_fault+0x968/0xdc0
[   72.801629]  [0000000000455aa4] do_sparc64_fault+0x264/0x780
[   72.801861]  [0000000000407c08] sparc64_realfault_common+0x10/0x20
[   72.801939] Disabling lock debugging due to kernel taint
[   72.802123] Caller[0000000000541bac]: __do_page_cache_readahead+0x6c/0x260
[   72.802363] Caller[00000000005351e0]: filemap_fault+0x2a0/0x540
[   72.802546] Caller[00000000006355bc]: ext4_filemap_fault+0x1c/0x40
[   72.802778] Caller[00000000005640c0]: __do_fault+0x60/0x100
[   72.802863] Caller[0000000000569648]: handle_mm_fault+0x968/0xdc0
[   72.803096] Caller[0000000000455aa4]: do_sparc64_fault+0x264/0x780
[   72.803182] Caller[0000000000407c08]: sparc64_realfault_common+0x10/0x20
[   72.803412] Caller[0000000070038494]: 0x70038494
[   72.803525] Instruction DUMP: 80a06001  0267ffec  b8087ffe <fa0f0000> 9e10001c  bb36501d  ba0f603f  83376000  82006004 

 
> [   72.333077] Unable to handle kernel paging request at virtual address 00000000fcdf6000
> [   72.333314] tsk->{mm,active_mm}->context = 00000000000000ba
> [   72.333517] tsk->{mm,active_mm}->pgd = ffff8003f3518000
> [   72.333730]               \|/ ____ \|/
>                              "@'/ .. \`@"
>                              /_| \__/ |_\
>                                 \__U_/
> [   72.334080] udevd(413): Oops [#1]
> [   72.334328] CPU: 12 PID: 413 Comm: udevd Not tainted 4.7.0-rc6 #113
> [   72.334427] task: ffff8003f34b91a0 ti: ffff8003f3540000 task.ti: ffff8003f3540000
> [   72.334558] TSTATE: 0000000811001604 TPC: 00000000007384e0 TNPC: 00000000007384e4 Y: 00000000    Not tainted
> [   72.334721] TPC: <__radix_tree_lookup+0x60/0x1a0>
> [   72.334797] g0: 0000600007e6a970 g1: 00000000fcdf6b81 g2: 0000000000000001 g3: 00000000a0063cd7
> [   72.334922] g4: ffff8003f34b91a0 g5: ffff8003fea3a000 g6: ffff8003f3540000 g7: 0000000000000000
> [   72.335048] o0: ffff8003fcad5518 o1: ffff8003fbf25700 o2: 00000000000002dc o3: 0000000000000010
> [   72.335174] o4: 0000000000000000 o5: 0000000000000040 sp: ffff8003f35430e1 ret_pc: ffff8003fcad84a0
> [   72.335300] RPC: <0xffff8003fcad84a0>
> [   72.335371] l0: 0000000000000329 l1: 000000000000000f l2: ffff8003fcad5520 l3: ffff8003f3543a40
> [   72.335496] l4: 0000000000001300 l5: 0000000003ffffff l6: 000000000000000f l7: 00000000000002eb
> [   72.335622] i0: ffff8003fcad5520 i1: 00000000000002eb i2: 0000000000000000 i3: 0000000000000000
> [   72.335749] i4: 00000000fcdf6b80 i5: 000000000000000b i6: ffff8003f3543191 i7: 000000000053ef40
> [   72.335882] I7: <__do_page_cache_readahead+0x60/0x260>
> [   72.335969] Call Trace:
> [   72.336043]  [000000000053ef40] __do_page_cache_readahead+0x60/0x260
> [   72.336148]  [0000000000532500] filemap_fault+0x2a0/0x540
> [   72.336241]  [0000000000629bbc] ext4_filemap_fault+0x1c/0x40
> [   72.336338]  [000000000055eb78] __do_fault+0x58/0x100
> [   72.336433]  [0000000000563bb0] handle_mm_fault+0xd50/0x1380
> [   72.336536]  [0000000000455aa8] do_sparc64_fault+0x268/0x780
> [   72.336630]  [0000000000407bf0] sparc64_realfault_common+0x10/0x20


-- 
Meelis Roos (mroos@linux.ee)
