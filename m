From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [BUG] [kernel-2.6.24.4] mm/slab.c:2948!
Date: Tue, 22 Apr 2008 22:30:15 +0300
Message-ID: <84144f020804221230y1067a876p9207db3c4357f64c@mail.gmail.com>
References: <45754D58.8040305@ccr.jussieu.fr> <48070AC5.2060302@ccr.jussieu.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
To: "Bernard Pidoux" <pidoux@ccr.jussieu.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:24555 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbYDVTaQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 15:30:16 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1345110wra.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 12:30:16 -0700 (PDT)
In-Reply-To: <48070AC5.2060302@ccr.jussieu.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Bernard,

On Thu, Apr 17, 2008 at 11:31 AM, Bernard Pidoux <pidoux@ccr.jussieu.fr> wrote:
> slab: Internal list corruption detected in cache 'buffer_head'(48), slabp
> dd546000(18). Hexdump:
>
>  000: 00 00 a9 e8 b8 c4 80 f7 e0 00 00 00 e0 60 54 dd
>  010: 12 00 00 00 1a 00 00 00 00 00 00 00 04 00 00 00
>  020: fd ff ff ff fd ff ff ff fd ff ff ff 0b 00 00 00
>  030: 19 00 00 00 05 00 00 00 20 00 00 00 26 00 00 00
>  040: fd ff ff ff 27 ff ff 0d 00 00 00 fd ff ff ff 1b 00 00 00
>  070: 28 00 00 00 fd ff ff ff 1e 00 00 00 fd ff ff ff
>  090: 2d 00 00 00 07 00 00 00 1d 00 00 00 fd ff 2c 00 00 00
>  0c0: fd ff ff ff fd ff ff ff fd ff ff ff
>  ------------[ cut here ]------------
>  kernel BUG at mm/slab.c:2948!
>  invalid opcode: 0000 [#1] SMP
>   snd_seq snd_pcm_oss ipv6 snd_mixer_oss binfmt_misc loop sata_via libata
> scsi_mod floppy cpufreq_              ondemand cpufreq_conservative snd
> 8139too ide_cd parport soundcore i2c_viapro mii via_agp agpgart
> thermal button processor
>  Stack: c03a5f0e 000000ff 00000030 dd546000 00000012 dd546000 f7827990
> 00000001
>
>  Call Trace:
>   [<c01053ba>] show_trace_log_lvl+0x1a/0x30
>   [<c010547b>] show_stack_log_lvl+0xab/0xd0
>   [<c010555d>] show_registers+0xbd/0x1c0
>   [<c010576f>] die+0x10f/0x230
>   [<c0105921>] do_trap+0x91/0xc0
>   [<f8a7f72d>] ext3_write_begin+0xbd/0x190 [ext3]
>   [<c01679a4>] generic_file_buffered_write+0xf4/0x5c0
>   [<c01680fe>] __generic_file_aio_write_nolock+0x28e/0x4e0
>   [<c01683b6>] generic_file_aio_write+0x66/0xe0
>   [<f8a7b54d>] ext3_file_write+0x2d/0xc0 [ext3]
>   [<c018a910>] do_sync_write+0xd0/0x110
>  1c 00 00 00 39 f0 76 0d 83 c3 01 f7 05 3e fa ff <0f> 0b eb fe 83 c4 18 5b
> Rebooting in 60 seconds              ..<3>BUG: sleeping function called from
> invalid context at kernel/rwsem.c:21
>  in_atomic():0, irqs_disabled():1
>  INFO: lockdep is turned off.
>  irq event stamp: 4614922
>  hardirqs last  enabled at (4614921): [<c018719b>]
> kmem_cache_alloc+0xcb/0x100
>  hardirqs last disabled at (4614922): [<c0187103>]
> kmem_cache_alloc+0x33/0x100
>  softirqs last  enabled at (4611908): [<c012dcc2>] __do_softirq+0x102/0x120
>  softirqs last disabled at (4611903): [<c012dd37>] do_softirq+0x57/0x60
>  Pid: 11844, comm: mozilla-firefox Tainted: G      D 2.6.24.4-1mnbcustom #1
>   [<c01053ba>] show_trace_log_lvl+0x1a/0x30
>   [<c0105df2>] show_trace+0x12/0x20
>   [<c01067ac>] dump_stack+0x6c/0x80
>   [<c0121a98>] __might_sleep+0xc8/0xf0
>   [<c03143a9>] down_read+0x19/0x80
>   [<c0218689>] pci_get_subsys+0x39/0x100
>   [<c021876b>] pci_get_device+0x1b/0x20
>   [<c011b190>] mach_reboot_fixups+0x40/0x60
>   [<c01155d3>] native_machine_emergency_restart+0x23/0x170
>   [<c01154b9>] machine_emergency_restart+0x9/0x10
>   [<c0137068>] emergency_restart+0x8/0x10
>   [<c01285ad>] panic+0xcd/0x110
>   [<c0105828>] die+0x1c8/0x230
>   [<c0105921>] do_trap+0x91/0xc0
>   [<c0105c38>] do_invalid_op+0x88/0xa0
>   [<c0315b8a>] error_code+0x72/0x78
>   [<c01867f2>] cache_alloc_refill+0xe2/0x720
>   [<c01871c4>] kmem_cache_alloc+0xf4/0x100
>   [<c01ac398>] alloc_buffer_head+0x28/0x60
>   [<c01ace1d>] alloc_page_buffers+0x7d/0xd0
>   [<c01ace84>] create_empty_buffers+0x14/0x90
>   [<c01ae2e2>] __block_prepare_write+0x322/0x3b0
>   [<c01ae3f9>] block_write_begin+0x49/0xe0
>   [<f8a7f72d>] ext3_write_begin+0xbd/0x190 [ext3]
>   [<c01679a4>] generic_file_buffered_write+0xf4/0x5c0
>   [<c01680fe>] __generic_file_aio_write_nolock+0x28e/0x4e0
>   [<c018a910>] do_sync_write+0xd0/0x110
>   [<c018b1ae>] vfs_write+0xae/0x130
>   [<c018b81d>] sys_write+0x3d/0x70
>   [<c010428e>] sysenter_past_esp+0x5f/0xa5
>   =======================

Can we get a full dmesg and your .config please? Can you reproduce
this with CONFIG_SLUB and CONFIG_SLUB_DEBUG_ON enabled as well?
Although this could be anything at this point, I've cc'd the ext3
developers just in case this looks familiar to them.

                Pekka
