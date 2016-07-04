From: Meelis Roos <mroos@linux.ee>
Subject: 4.7-rc6, ext4, sparc64: Unable to handle kernel paging request at
 ...
Date: Mon, 4 Jul 2016 14:36:39 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just got this on bootup of my Sun T2000:

[   72.333077] Unable to handle kernel paging request at virtual address 00000000fcdf6000
[   72.333314] tsk->{mm,active_mm}->context = 00000000000000ba
[   72.333517] tsk->{mm,active_mm}->pgd = ffff8003f3518000
[   72.333730]               \|/ ____ \|/
                             "@'/ .. \`@"
                             /_| \__/ |_\
                                \__U_/
[   72.334080] udevd(413): Oops [#1]
[   72.334328] CPU: 12 PID: 413 Comm: udevd Not tainted 4.7.0-rc6 #113
[   72.334427] task: ffff8003f34b91a0 ti: ffff8003f3540000 task.ti: ffff8003f3540000
[   72.334558] TSTATE: 0000000811001604 TPC: 00000000007384e0 TNPC: 00000000007384e4 Y: 00000000    Not tainted
[   72.334721] TPC: <__radix_tree_lookup+0x60/0x1a0>
[   72.334797] g0: 0000600007e6a970 g1: 00000000fcdf6b81 g2: 0000000000000001 g3: 00000000a0063cd7
[   72.334922] g4: ffff8003f34b91a0 g5: ffff8003fea3a000 g6: ffff8003f3540000 g7: 0000000000000000
[   72.335048] o0: ffff8003fcad5518 o1: ffff8003fbf25700 o2: 00000000000002dc o3: 0000000000000010
[   72.335174] o4: 0000000000000000 o5: 0000000000000040 sp: ffff8003f35430e1 ret_pc: ffff8003fcad84a0
[   72.335300] RPC: <0xffff8003fcad84a0>
[   72.335371] l0: 0000000000000329 l1: 000000000000000f l2: ffff8003fcad5520 l3: ffff8003f3543a40
[   72.335496] l4: 0000000000001300 l5: 0000000003ffffff l6: 000000000000000f l7: 00000000000002eb
[   72.335622] i0: ffff8003fcad5520 i1: 00000000000002eb i2: 0000000000000000 i3: 0000000000000000
[   72.335749] i4: 00000000fcdf6b80 i5: 000000000000000b i6: ffff8003f3543191 i7: 000000000053ef40
[   72.335882] I7: <__do_page_cache_readahead+0x60/0x260>
[   72.335969] Call Trace:
[   72.336043]  [000000000053ef40] __do_page_cache_readahead+0x60/0x260
[   72.336148]  [0000000000532500] filemap_fault+0x2a0/0x540
[   72.336241]  [0000000000629bbc] ext4_filemap_fault+0x1c/0x40
[   72.336338]  [000000000055eb78] __do_fault+0x58/0x100
[   72.336433]  [0000000000563bb0] handle_mm_fault+0xd50/0x1380
[   72.336536]  [0000000000455aa8] do_sparc64_fault+0x268/0x780
[   72.336630]  [0000000000407bf0] sparc64_realfault_common+0x10/0x20
[   72.336720] Disabling lock debugging due to kernel taint
[   72.336812] Caller[000000000053ef40]: __do_page_cache_readahead+0x60/0x260
[   72.336911] Caller[0000000000532500]: filemap_fault+0x2a0/0x540
[   72.337006] Caller[0000000000629bbc]: ext4_filemap_fault+0x1c/0x40
[   72.337101] Caller[000000000055eb78]: __do_fault+0x58/0x100
[   72.337195] Caller[0000000000563bb0]: handle_mm_fault+0xd50/0x1380
[   72.337292] Caller[0000000000455aa8]: do_sparc64_fault+0x268/0x780
[   72.337387] Caller[0000000000407bf0]: sparc64_realfault_common+0x10/0x20
[   72.337479] Caller[00000000f7d7da08]: 0xf7d7da08
[   72.337543] Instruction DUMP: 80a06001  0267ffec  b8087ffe <fa0f0000> 9e10001c  bb36501d  ba0f603f  83376000  82006004 

I have not seen it before, this includes 4.6.0 4.6.0-08907-g7639dad 
4.7.0-rc1-00094-g6b15d66 4.7.0-rc4-00014-g67016f6.

It is not reproducible, did not appear on next reboot of the same 
kernel.

-- 
Meelis Roos (mroos@linux.ee)
