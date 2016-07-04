From: Meelis Roos <mroos@linux.ee>
Subject: Re: 4.7-rc6, ext4, sparc64: Unable to handle kernel paging request
 at ...
Date: Mon, 4 Jul 2016 20:04:02 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1607042002200.17692@math.ut.ee>
References: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee> <CADxRZqy42TR9Y1yKM=yCQnAwyCYoU-mR2SEMT3wcSLO-NHbiSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqy42TR9Y1yKM=yCQnAwyCYoU-mR2SEMT3wcSLO-NHbiSg@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > Just got this on bootup of my Sun T2000:
> >...
> > I have not seen it before, this includes 4.6.0 4.6.0-08907-g7639dad
> > 4.7.0-rc1-00094-g6b15d66 4.7.0-rc4-00014-g67016f6.
> >
> > It is not reproducible, did not appear on next reboot of the same
> > kernel.
> 
> mine T5120 boots ok 4.7.0-rc6, rootfs being on ext4 .

My T5120 and many other sparc64 machines also boot fine, most of them 
using ext4, others ext3 with ext4 driver.

However, I also got a very similar oops from T1000:

[   55.251101] Unable to handle kernel paging request at virtual address 00000000fe42a000
[   55.251348] tsk->{mm,active_mm}->context = 0000000000000083
[   55.251533] tsk->{mm,active_mm}->pgd = ffff8001f6224000
[   55.251719]               \|/ ____ \|/
                             "@'/ .. \`@"
                             /_| \__/ |_\
                                \__U_/
[   55.252038] systemd-udevd(268): Oops [#1]
[   55.252274] CPU: 9 PID: 268 Comm: systemd-udevd Not tainted 4.7.0-rc6 #26
[   55.252367] task: ffff8001f6064380 ti: ffff8001f620c000 task.ti: ffff8001f620c000
[   55.252497] TSTATE: 0000000811001604 TPC: 0000000000649380 TNPC: 0000000000649384 Y: 00000000    Not tainted
[   55.252651] TPC: <__radix_tree_lookup+0x60/0x1a0>
[   55.252783] g0: ffff8001fd6f7f00 g1: 00000000fe42b231 g2: 0000000000000001 g3: 00000000e0019bb0
[   55.252791] g4: ffff8001f6064380 g5: ffff8001fefe4000 g6: ffff8001f620c000 g7: 0000000000000000
[   55.252798] o0: ffff8001fe3f1940 o1: 0000000000000295 o2: 000000000000028d o3: 0000000000000010
[   55.252815] o4: 0000000000000000 o5: 0000000000000040 sp: ffff8001f620f0d1 ret_pc: ffff8001fe35d488
[   55.252822] RPC: <0xffff8001fe35d488>
[   55.252830] l0: 0000000000000329 l1: 0000000000000008 l2: ffff8001fe3f1948 l3: ffff8001f620fa40
[   55.252837] l4: 0000000000906b60 l5: 0000000000001300 l6: 0000000003ffffff l7: 0000000000000008
[   55.252844] i0: ffff8001fe3f1948 i1: 0000000000000295 i2: 0000000000000000 i3: 0000000000000000
[   55.252852] i4: 00000000fe42b230 i5: 000000000000000a i6: ffff8001f620f181 i7: 00000000004ecbcc
[   55.252871] I7: <__do_page_cache_readahead+0x6c/0x280>
[   55.252875] Call Trace:
[   55.252890]  [00000000004ecbcc] __do_page_cache_readahead+0x6c/0x280
[   55.252912]  [00000000004e0be0] filemap_fault+0x2a0/0x540
[   55.252925]  [00000000005bb95c] ext4_filemap_fault+0x1c/0x40
[   55.252937]  [00000000005057d8] __do_fault+0x58/0x100
[   55.252948]  [000000000050a638] handle_mm_fault+0xc58/0x1300
[   55.252969]  [000000000044d7d8] do_sparc64_fault+0x4d8/0x7c0
[   55.252982]  [0000000000407bf0] sparc64_realfault_common+0x10/0x20
[   55.252987] Disabling lock debugging due to kernel taint
[   55.253002] Caller[00000000004ecbcc]: __do_page_cache_readahead+0x6c/0x280
[   55.253018] Caller[00000000004e0be0]: filemap_fault+0x2a0/0x540
[   55.253029] Caller[00000000005bb95c]: ext4_filemap_fault+0x1c/0x40
[   55.253039] Caller[00000000005057d8]: __do_fault+0x58/0x100
[   55.253049] Caller[000000000050a638]: handle_mm_fault+0xc58/0x1300
[   55.253063] Caller[000000000044d7d8]: do_sparc64_fault+0x4d8/0x7c0
[   55.253073] Caller[0000000000407bf0]: sparc64_realfault_common+0x10/0x20
[   55.253089] Caller[0000000070038494]: 0x70038494
[   55.253117] Instruction DUMP: 80a06001  0267ffec  b8087ffe <fa0f0000> 9e10001c  bb36501d  ba0f603f  83376000  82006004

-- 
Meelis Roos (mroos@linux.ee)
