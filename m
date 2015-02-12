From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [Xen-devel] 3.19 + xen-devel: kernel BUG at fs/ext4/page-io.c:85!
Date: Thu, 12 Feb 2015 12:28:35 +0100
Message-ID: <54DC8E63.6000500@citrix.com>
References: <1518867277.20150212095451@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
To: Sander Eikelenboom <linux@eikelenboom.it>,
	David Vrabel <david.vrabel@citrix.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518867277.20150212095451@eikelenboom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

El 12/02/15 a les 9.54, Sander Eikelenboom ha escrit:
> Hi,
> 
> With a 3.19 kernel + xen-devel tree pulled on top i run into this splat below.
> It's on a Xen PV-guest running a postgres database and doing a pg_dump at that
> moment in time, after running for a while (within 2 days or so).
> 
> --
> Sander
> 
> [139595.736073] ------------[ cut here ]------------
> [139595.736073] kernel BUG at fs/ext4/page-io.c:85!
> [139595.736073] invalid opcode: 0000 [#1] SMP
> [139595.736073] Modules linked in:
> [139595.736073] CPU: 0 PID: 25632 Comm: pg_dump Not tainted 3.19.0-20150209-doflr-xendevel-edid+ #1
> [139595.736073] task: ffff8800f8fd10c0 ti: ffff88006bc70000 task.ti: ffff88006bc70000
> [139595.736073] RIP: e030:[<ffffffff8126826f>]  [<ffffffff8126826f>] ext4_finish_bio+0x24f/0x260
> [139595.736073] RSP: e02b:ffff8800fac03bc8  EFLAGS: 00010046
> [139595.736073] RAX: 004000000002002c RBX: ffff880060fa6170 RCX: 0000000000000034
> [139595.736073] RDX: 0000000000000000 RSI: ffffea00014a77c0 RDI: ffff8800f9357300
> [139595.736073] RBP: ffff8800fac03c58 R08: 0000000000000009 R09: 0000000000016830
> [139595.736073] R10: ffff8800ff820680 R11: 0000000000000000 R12: 0000000000000000
> [139595.736073] R13: ffff88006bf111a0 R14: 0000000000000000 R15: ffffea0000cd1800
> [139595.736073] FS:  00007f623b3f7720(0000) GS:ffff8800fac00000(0000) knlGS:0000000000000000
> [139595.736073] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [139595.736073] CR2: ffffffffff600400 CR3: 0000000091907000 CR4: 0000000000000660
> [139595.736073] Stack:
> [139595.736073]  ffff8800fac03be8 ffffffff81bc11c2 ffffffff83140070 ffff8800fac03cc6
> [139595.736073]  ffff8800f9357300 00001000244d0001 004000000000002c 0000001700000000
> [139595.736073]  0000000000000000 0000000000000002 ffff8800fac03c98 ffffffff8110582d
> [139595.736073] Call Trace:
> [139595.736073]  <IRQ>
> [139595.736073]  [<ffffffff81bc11c2>] ? _raw_spin_unlock_irqrestore+0x52/0x90
> [139595.736073]  [<ffffffff8110582d>] ? lock_acquire+0xed/0x110
> [139595.736073]  [<ffffffff81268698>] ext4_end_bio+0x58/0x110
> [139595.736073]  [<ffffffff8144dea3>] bio_endio+0x53/0x90
> [139595.736073]  [<ffffffff81453850>] blk_update_request+0x80/0x300
> [139595.736073]  [<ffffffff81453af2>] blk_update_bidi_request+0x22/0x90
> [139595.736073]  [<ffffffff8145451b>] __blk_end_bidi_request+0x1b/0x40
> [139595.736073]  [<ffffffff8145455a>] __blk_end_request_all+0x1a/0x30
> [139595.736073]  [<ffffffff816e59d1>] blkif_interrupt+0x731/0x8c0

AFAICT the crash is due to the ext4 code not finding it's private data
embedded in the page. xen-blkfront doesn't use page->private at all, so
I'm not sure who is touching this. The only Xen specific code that
touches page->private is the p2m code. Was the domain
saved/restored/migrated?

Roger.
