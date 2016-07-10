From: Mikael Pettersson <mikpelinux@gmail.com>
Subject: Re: 4.7-rc6, ext4, sparc64: Unable to handle kernel paging request
 at ...
Date: Sun, 10 Jul 2016 11:40:14 +0200
Message-ID: <22402.6142.307987.804603@gargle.gargle.HOWL>
References: <alpine.LRH.2.20.1607041429380.6651@math.ut.ee>
	<CADxRZqy42TR9Y1yKM=yCQnAwyCYoU-mR2SEMT3wcSLO-NHbiSg@mail.gmail.com>
	<alpine.LRH.2.20.1607042002200.17692@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Anatoly Pugachev <matorola@gmail.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1607042002200.17692@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Meelis Roos writes:
 > > > Just got this on bootup of my Sun T2000:
 > > >...
 > > > I have not seen it before, this includes 4.6.0 4.6.0-08907-g7639dad
 > > > 4.7.0-rc1-00094-g6b15d66 4.7.0-rc4-00014-g67016f6.
 > > >
 > > > It is not reproducible, did not appear on next reboot of the same
 > > > kernel.
 > > 
 > > mine T5120 boots ok 4.7.0-rc6, rootfs being on ext4 .
 > 
 > My T5120 and many other sparc64 machines also boot fine, most of them 
 > using ext4, others ext3 with ext4 driver.
 > 
 > However, I also got a very similar oops from T1000:
 > 
 > [   55.251101] Unable to handle kernel paging request at virtual address 00000000fe42a000
 > [   55.251348] tsk->{mm,active_mm}->context = 0000000000000083
 > [   55.251533] tsk->{mm,active_mm}->pgd = ffff8001f6224000
 > [   55.251719]               \|/ ____ \|/
 >                              "@'/ .. \`@"
 >                              /_| \__/ |_\
 >                                 \__U_/
 > [   55.252038] systemd-udevd(268): Oops [#1]
 > [   55.252274] CPU: 9 PID: 268 Comm: systemd-udevd Not tainted 4.7.0-rc6 #26
 > [   55.252367] task: ffff8001f6064380 ti: ffff8001f620c000 task.ti: ffff8001f620c000
 > [   55.252497] TSTATE: 0000000811001604 TPC: 0000000000649380 TNPC: 0000000000649384 Y: 00000000    Not tainted
 > [   55.252651] TPC: <__radix_tree_lookup+0x60/0x1a0>
...

A few weeks ago I got a similar oops with 4.7.0-rc2 on a Sun Blade 2500 (dual USIIIi):

Jun 12 18:40:26 lauter kernel: Unable to handle kernel paging request at virtual address 000000000000a000
Jun 12 18:40:26 lauter kernel: tsk->{mm,active_mm}->context = 00000000000017e3
Jun 12 18:40:26 lauter kernel: tsk->{mm,active_mm}->pgd = fff000023edb8000
Jun 12 18:40:26 lauter kernel:               \|/ ____ \|/
Jun 12 18:40:26 lauter kernel:               "@'/ .. \`@"
Jun 12 18:40:26 lauter kernel:               /_| \__/ |_\
Jun 12 18:40:26 lauter kernel:                  \__U_/
Jun 12 18:40:26 lauter kernel: gnat1(19464): Oops [#1]
Jun 12 18:40:26 lauter kernel: CPU: 0 PID: 19464 Comm: gnat1 Not tainted 4.7.0-rc2 #1
Jun 12 18:40:26 lauter kernel: task: fff000023ebd1440 ti: fff000123c360000 task.ti: fff000123c360000
Jun 12 18:40:27 lauter kernel: TSTATE: 0000000011001604 TPC: 00000000005db288 TNPC: 00000000005db28c Y: 00000000    Not tainted
Jun 12 18:40:27 lauter kernel: TPC: <__radix_tree_lookup+0x44/0xd4>
Jun 12 18:40:27 lauter kernel: g0: 0000000000003000 g1: 000000000000a6d9 g2: 0000000000000001 g3: 0000000000000000
Jun 12 18:40:27 lauter kernel: g4: fff000023ebd1440 g5: fff000023ef7a000 g6: fff000123c360000 g7: 0000000000000000
Jun 12 18:40:27 lauter kernel: o0: 000000000000000c o1: fff000123c363980 o2: fff000123c363988 o3: fff000123c363968
Jun 12 18:40:27 lauter kernel: o4: 0000000000000020 o5: fff000023fffefc0 sp: fff000123c3630d1 ret_pc: fff0000232e42540
Jun 12 18:40:27 lauter kernel: RPC: <0xfff0000232e42540>
Jun 12 18:40:27 lauter kernel: l0: 00000000024213ca l1: 0000000000000000 l2: 0000000000000000 l3: 0000000000000000
Jun 12 18:40:27 lauter kernel: l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 0000000000000000
Jun 12 18:40:27 lauter kernel: i0: fff0001225e56900 i1: 0000000000000441 i2: 0000000000000000 i3: 0000000000000000
Jun 12 18:40:27 lauter kernel: i4: 000000000000a6d8 i5: fff0000232e42540 i6: fff000123c363191 i7: 00000000004bf680
Jun 12 18:40:27 lauter kernel: I7: <__do_page_cache_readahead+0x78/0x200>
Jun 12 18:40:27 lauter kernel: Call Trace:
Jun 12 18:40:27 lauter kernel:  [00000000004bf680] __do_page_cache_readahead+0x78/0x200
Jun 12 18:40:27 lauter kernel:  [00000000004b5990] filemap_fault+0x164/0x4c4
Jun 12 18:40:27 lauter kernel:  [0000000000562a84] ext4_filemap_fault+0x1c/0x38
Jun 12 18:40:27 lauter kernel:  [00000000004d2c38] __do_fault+0x58/0xdc
Jun 12 18:40:27 lauter kernel:  [00000000004d611c] handle_mm_fault+0x604/0xe5c
Jun 12 18:40:27 lauter kernel:  [0000000000448288] do_sparc64_fault+0x228/0x684
Jun 12 18:40:27 lauter kernel:  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
Jun 12 18:40:28 lauter kernel: Disabling lock debugging due to kernel taint
Jun 12 18:40:28 lauter kernel: Caller[00000000004bf680]: __do_page_cache_readahead+0x78/0x200
Jun 12 18:40:28 lauter kernel: Caller[00000000004b5990]: filemap_fault+0x164/0x4c4
Jun 12 18:40:28 lauter kernel: Caller[0000000000562a84]: ext4_filemap_fault+0x1c/0x38
Jun 12 18:40:28 lauter kernel: Caller[00000000004d2c38]: __do_fault+0x58/0xdc
Jun 12 18:40:28 lauter kernel: Caller[00000000004d611c]: handle_mm_fault+0x604/0xe5c
Jun 12 18:40:28 lauter kernel: Caller[0000000000448288]: do_sparc64_fault+0x228/0x684
Jun 12 18:40:28 lauter kernel: Caller[0000000000407bcc]: sparc64_realfault_common+0x10/0x20
Jun 12 18:40:28 lauter kernel: Caller[00000000006ee248]: ip_options_compile+0x288/0x60c
Jun 12 18:40:28 lauter kernel: Instruction DUMP: 80a06001  0267fff2  b8087ffe <c20f0000> 83365001  8208603f  84006004  83287003  8528b003

It's only happended that one time, so far.
