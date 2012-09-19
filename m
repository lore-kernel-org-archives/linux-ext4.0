From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: possible bug ?
Date: Wed, 19 Sep 2012 10:13:46 -0500
Message-ID: <5059E12A.9000306@redhat.com>
References: <CAEG-z2-5=hYOZ+ZwUAE5ULQPJ2kjZ5WMv9EoTpx=c+Mik6_9ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab2ISPNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 11:13:49 -0400
In-Reply-To: <CAEG-z2-5=hYOZ+ZwUAE5ULQPJ2kjZ5WMv9EoTpx=c+Mik6_9ug@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/19/12 9:44 AM, Adrian Sandu wrote:
> Hi people,
> 
> While trying to delete a couple of files today, I got into this lil'
> thingy. It first happened in mc, then at a reboot.

Did you cut off a few lines before this?  Like one that said NULL pointer
dereference, or BUG() at .... or something similar?

I think we have a few reports of this in the fedora bugzilla, I don't
think we've gotten to the bottom of it yet.

-Eric

> [   48.770178] IP: [<ffffffff811d6424>] ext4_ext_remove_space+0x9f4/0xe00
> [   48.770178] PGD 11d365067 PUD 11d1e8067 PMD 0
> [   48.770178] Oops: 0000 [#1] SMP
> [   48.770178] CPU 3
> [   48.770178] Modules linked in: ir_lirc_codec lirc_dev
> ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder nvidia(PO)
> ir_jvc_decoder ir_rc6_decoder rt2800usb rt2800lib crc_ccitt rt2x00usb
> rt2x00lib ir_rc5_decoder snd_usb_audio ir_nec_decoder option
> rc_rc6_mce nuvoton_cir rc_core snd_hwdep snd_usbmidi_lib snd_rawmidi
> usb_wwan r8712u(C) usbserial
> [   48.770178]
> [   48.770178] Pid: 1465, comm: mount Tainted: P         C O
> 3.4.9-gentoo #1 To Be Filled By O.E.M. To Be Filled By O.E.M./ION3D-HT
> [   48.922060] RIP: 0010:[<ffffffff811d6424>]  [<ffffffff811d6424>]
> ext4_ext_remove_space+0x9f4/0xe00
> [   48.922060] RSP: 0018:ffff88011a5b19d8  EFLAGS: 00010246
> [   48.922060] RAX: 0000000000000000 RBX: ffff88011d9c01b0 RCX: 0000000000000002
> [   48.922060] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 000000000e590f51
> [   48.922060] RBP: ffff88011a5b1ae8 R08: 000000001d1bf000 R09: ffff88011d9c0180
> [   48.922060] R10: ffffffff811d5ddc R11: 0000000000000001 R12: 0000000000000000
> [   48.922060] R13: ffff88011bab9550 R14: 0000000000000000 R15: 0000000000000001
> [   48.922060] FS:  00007f0a3714d740(0000) GS:ffff880123d80000(0000)
> knlGS:0000000000000000
> [   48.922060] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   48.922060] CR2: 0000000000000028 CR3: 000000011b704000 CR4: 00000000000007e0
> [   48.922060] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   48.922060] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   48.922060] Process mount (pid: 1465, threadinfo ffff88011a5b0000,
> task ffff88011b417000)
> [   48.922060] Stack:
> [   48.922060]  0000000000001111 ffff88011bab9550 ffff88011bab94a0
> ffff88011a5b1a98
> [   48.922060]  ffff88011ae16e00 ffff880116f37a28 ffffffff1a5b1a68
> ffff88011a4b8000
> [   48.922060]  000000011ec37000 0000000000000000 ffff88011bab94a0
> ffff88011daf3c00
> [   48.922060] Call Trace:
> [   48.922060]  [<ffffffff811d8953>] ext4_ext_truncate+0x1b3/0x1f0
> [   48.922060]  [<ffffffff811cb1ec>] ? ext4_journal_start_sb+0x7c/0x1b0
> [   48.922060]  [<ffffffff811ac878>] ext4_truncate+0xb8/0xf0
> [   48.922060]  [<ffffffff811b13f0>] ext4_evict_inode+0x3a0/0x4a0
> [   48.922060]  [<ffffffff8112f3d7>] evict+0xa7/0x1b0
> [   48.922060]  [<ffffffff8112f5eb>] iput+0x10b/0x210
> [   48.922060]  [<ffffffff811cf367>] ext4_fill_super+0x28f7/0x2a40
> [   48.922060]  [<ffffffff810dcabe>] ? register_shrinker+0x4e/0x60
> [   48.922060]  [<ffffffff811192f2>] mount_bdev+0x1a2/0x1e0
> [   48.922060]  [<ffffffff811cca70>] ? ext4_calculate_overhead+0x3c0/0x3c0
> [   48.922060]  [<ffffffff81112424>] ? __kmalloc_track_caller+0x54/0x160
> [   48.922060]  [<ffffffff811c3cd0>] ext4_mount+0x10/0x20
> [   48.922060]  [<ffffffff8111a073>] mount_fs+0x43/0x1c0
> [   48.922060]  [<ffffffff810ebe2b>] ? __alloc_percpu+0xb/0x10
> [   48.922060]  [<ffffffff81132baa>] vfs_kern_mount+0x6a/0x100
> [   48.922060]  [<ffffffff81133400>] do_kern_mount+0x50/0x100
> [   48.922060]  [<ffffffff81135020>] do_mount+0x520/0x7f0
> [   48.922060]  [<ffffffff810e6e77>] ? memdup_user+0x47/0x90
> [   48.922060]  [<ffffffff810e6f13>] ? strndup_user+0x53/0x70
> [   48.922060]  [<ffffffff81135420>] sys_mount+0x90/0xe0
> [   48.922060]  [<ffffffff815e43a2>] system_call_fastpath+0x16/0x1b
> [   48.922060] Code: 8d 04 40 48 8d 04 81 48 89 43 18 0f b7 49 02 48
> 83 c1 01 48 85 c0 48 89 0b 0f 85 c8 f8 ff ff 0f 0b 66 0f 1f 44 00 00
> 48 8b 43 28 <48> 8b 40 28 48 89 43 20 e9 91 f8 ff ff 0f 1f 80 00 00 00
> 00 44
> [   48.922060] RIP  [<ffffffff811d6424>] ext4_ext_remove_space+0x9f4/0xe00
> [   48.922060]  RSP <ffff88011a5b19d8>
> [   48.922060] CR2: 0000000000000028
> [   48.922862] ---[ end trace d17fa9fb727ed36f ]---
> 
> Any ideas ? I'm updating to 3.5.4 ( latest in gentoo's ~amd64  )
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

