From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: 3.19 + xen-devel: kernel BUG at fs/ext4/page-io.c:85!
Date: Thu, 12 Feb 2015 09:54:51 +0100
Message-ID: <1518867277.20150212095451@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "David Vrabel" <david.vrabel@citrix.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

With a 3.19 kernel + xen-devel tree pulled on top i run into this splat below.
It's on a Xen PV-guest running a postgres database and doing a pg_dump at that
moment in time, after running for a while (within 2 days or so).

--
Sander

[139595.736073] ------------[ cut here ]------------
[139595.736073] kernel BUG at fs/ext4/page-io.c:85!
[139595.736073] invalid opcode: 0000 [#1] SMP
[139595.736073] Modules linked in:
[139595.736073] CPU: 0 PID: 25632 Comm: pg_dump Not tainted 3.19.0-20150209-doflr-xendevel-edid+ #1
[139595.736073] task: ffff8800f8fd10c0 ti: ffff88006bc70000 task.ti: ffff88006bc70000
[139595.736073] RIP: e030:[<ffffffff8126826f>]  [<ffffffff8126826f>] ext4_finish_bio+0x24f/0x260
[139595.736073] RSP: e02b:ffff8800fac03bc8  EFLAGS: 00010046
[139595.736073] RAX: 004000000002002c RBX: ffff880060fa6170 RCX: 0000000000000034
[139595.736073] RDX: 0000000000000000 RSI: ffffea00014a77c0 RDI: ffff8800f9357300
[139595.736073] RBP: ffff8800fac03c58 R08: 0000000000000009 R09: 0000000000016830
[139595.736073] R10: ffff8800ff820680 R11: 0000000000000000 R12: 0000000000000000
[139595.736073] R13: ffff88006bf111a0 R14: 0000000000000000 R15: ffffea0000cd1800
[139595.736073] FS:  00007f623b3f7720(0000) GS:ffff8800fac00000(0000) knlGS:0000000000000000
[139595.736073] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[139595.736073] CR2: ffffffffff600400 CR3: 0000000091907000 CR4: 0000000000000660
[139595.736073] Stack:
[139595.736073]  ffff8800fac03be8 ffffffff81bc11c2 ffffffff83140070 ffff8800fac03cc6
[139595.736073]  ffff8800f9357300 00001000244d0001 004000000000002c 0000001700000000
[139595.736073]  0000000000000000 0000000000000002 ffff8800fac03c98 ffffffff8110582d
[139595.736073] Call Trace:
[139595.736073]  <IRQ>
[139595.736073]  [<ffffffff81bc11c2>] ? _raw_spin_unlock_irqrestore+0x52/0x90
[139595.736073]  [<ffffffff8110582d>] ? lock_acquire+0xed/0x110
[139595.736073]  [<ffffffff81268698>] ext4_end_bio+0x58/0x110
[139595.736073]  [<ffffffff8144dea3>] bio_endio+0x53/0x90
[139595.736073]  [<ffffffff81453850>] blk_update_request+0x80/0x300
[139595.736073]  [<ffffffff81453af2>] blk_update_bidi_request+0x22/0x90
[139595.736073]  [<ffffffff8145451b>] __blk_end_bidi_request+0x1b/0x40
[139595.736073]  [<ffffffff8145455a>] __blk_end_request_all+0x1a/0x30
[139595.736073]  [<ffffffff816e59d1>] blkif_interrupt+0x731/0x8c0
[139595.736073]  [<ffffffff8110f407>] handle_irq_event_percpu+0x47/0x150
[139595.736073]  [<ffffffff8110f553>] handle_irq_event+0x43/0x70
[139595.736073]  [<ffffffff811120b6>] handle_edge_irq+0x96/0x110
[139595.736073]  [<ffffffff8110ec5d>] generic_handle_irq+0x1d/0x40
[139595.736073]  [<ffffffff8152d22a>] evtchn_fifo_handle_events+0x16a/0x170
[139595.736073]  [<ffffffff8152a347>] __xen_evtchn_do_upcall+0x47/0x90
[139595.736073]  [<ffffffff8152bf4f>] xen_evtchn_do_upcall+0x2f/0x50
[139595.736073]  [<ffffffff81bc310e>] xen_do_hypervisor_callback+0x1e/0x30
[139595.736073]  <EOI>
[139595.736073] Code: 45 00 a8 10 75 f6 e9 82 fe ff ff 90 e8 5b 96 e9 ff 48 83 3d cb 78 fc 00 00 74 18 48 8b 7d a0 ff 14 25 28 fb 22 82 e9 1f ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00 00 00 55 48 89 e5
[139595.736073] RIP  [<ffffffff8126826f>] ext4_finish_bio+0x24f/0x260
[139595.736073]  RSP <ffff8800fac03bc8>
[139595.736073] ---[ end trace cb2ee1cb372ad9b2 ]---
[139595.736073] Kernel panic - not syncing: Fatal exception in interrupt
[139595.736073] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
