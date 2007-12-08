From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1: some issues on sparc64
Date: Sat, 8 Dec 2007 10:22:39 -0800
Message-ID: <20071208102239.2457eeaa.akpm@linux-foundation.org>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<200712081920.28748.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbXLHSWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2007 13:22:47 -0500
In-Reply-To: <200712081920.28748.m.kozlowski@tuxland.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 8 Dec 2007 19:20:28 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> 	The box is sun ultra 60 (dual sparc64). This was caught when
> system (gentoo) was emerging some package. 
> 
> [27006.402237] kernel BUG at fs/jbd/transaction.c:1894!

That's

        J_ASSERT_BH(bh, !buffer_jbddirty(bh));

at the end of journal_unmap_buffer().

I don't recall seeing that before and I can't think of anything we've
done recently which could cause it, sorry.

> [27006.402268]               \|/ ____ \|/
> [27006.402274]               "@'/ .. \`@"
> [27006.402279]               /_| \__/ |_\
> [27006.402285]                  \__U_/

x86 needs that.

> [27006.402298] rm(4713): Kernel bad sw trap 5 [#1]
> [27006.402538] TSTATE: 0000009911009605 TPC: 000000000053b1cc TNPC: 000000000053b1d0 Y: 00000000    Not tainted
> [27006.402579] TPC: <journal_invalidatepage+0x3d4/0x460>
> [27006.402593] g0: 0000000000000002 g1: 0000000000000000 g2: 0000000000000001 g3: fffff800a7d90000
> [27006.402610] g4: fffff800b54ea460 g5: fffff8007f832000 g6: fffff800a7d90000 g7: 000000000076d868
> [27006.402627] o0: 000000000072b660 o1: 0000000000000766 o2: 0000000000000002 o3: 0000000000000001
> [27006.402644] o4: 00000000008a2940 o5: 0000000000000000 sp: fffff800a7d92c91 ret_pc: 000000000053b1c4
> [27006.402665] RPC: <journal_invalidatepage+0x3cc/0x460>
> [27006.402679] l0: fffff800afbf4070 l1: 000000000069511c l2: 0000000000002000 l3: 0000000000000000
> [27006.402696] l4: 0000000000000001 l5: fffff800ba4cb730 l6: fffff800bf1cd338 l7: 0000000000000001
> [27006.402713] i0: fffff800bf1cd000 i1: 0000000201db2708 i2: 0000000000000000 i3: 0000000000727000
> [27006.402730] i4: 0000000000200000 i5: fffff800bf1cd028 i6: fffff800a7d92d51 i7: 0000000000529254
> [27006.402763] I7: <ext3_invalidatepage+0x3c/0x60>
> [27006.402776] Caller[0000000000529254]: ext3_invalidatepage+0x3c/0x60
> [27006.402800] Caller[00000000004b22fc]: do_invalidatepage+0x24/0x60
> [27006.402826] Caller[00000000004b29c4]: truncate_complete_page+0x6c/0x80
> [27006.402849] Caller[00000000004b2a6c]: truncate_inode_pages_range+0x94/0x440
> [27006.402872] Caller[00000000004b2e2c]: truncate_inode_pages+0x14/0x20
> [27006.402894] Caller[0000000000529888]: ext3_delete_inode+0x10/0x160
> [27006.402918] Caller[00000000004e7ca0]: generic_delete_inode+0x88/0x120
> [27006.402949] Caller[00000000004e7e60]: generic_drop_inode+0x128/0x1c0
> [27006.402971] Caller[00000000004e75d4]: iput+0x7c/0xa0
> [27006.402992] Caller[00000000004dd680]: do_unlinkat+0x108/0x1a0
> [27006.403024] Caller[00000000004dd884]: sys_unlinkat+0x2c/0x60
> [27006.403047] Caller[00000000004062d4]: linux_sparc_syscall32+0x3c/0x40
> [27006.403081] Caller[00000000f7e7d0ec]: 0xf7e7d0f4
> [27006.403102] Instruction DUMP: 92102766  7ffbbeaf  90122260 <91d02005> 92102780  7ffbbeab  90122260  91d02005  7ffbbea8
