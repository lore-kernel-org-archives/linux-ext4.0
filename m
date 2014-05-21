From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 15:20:20 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaEUOMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 10:12:10 -0400
In-Reply-To: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 May 2014, Arturo Borrero Gonzalez wrote:

> Date: Wed, 21 May 2014 12:29:04 +0200
> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: OOPs in ext4
> 
> Hi there!
> 
> I have an oops in a virtual machine using ext4 as fs.

Hi,

yes there is definitely a bug in the error handling code because we
really should not hit that BUG_ON() later.

However I am curious how we got this state in the first place. Can
you provide the logs before the first oops ? Are there any more
warnings ?

What is your storage setup ? Any particular workload you've been
running at the time ? Can you reproduce it ?

Thanks!
-Lukas

> 
> The kernel is 3.14
> 
> [153468.339345] EXT4-fs error (device vda1):
> ext4_mb_generate_buddy:756: group 50, 26334 clusters in bitmap, 26332
> in gd; block bitmap corrupt.
> [153468.340172] Aborting journal on device vda1-8.
> [153468.340983] EXT4-fs (vda1): Remounting filesystem read-only
> [153468.341304] ------------[ cut here ]------------
> [153468.341369] WARNING: CPU: 4 PID: 16902 at fs/ext4/ext4_jbd2.c:259
> __ext4_handle_dirty_metadata+0x5c/0x17f [ext4]()
> [153468.341372] Modules linked in: loop snd_pcm snd_timer snd
> parport_pc parport soundcore i2c_piix4 i2c_core psmouse pcspkr
> microcode serio_raw virtio_balloon evdev processor thermal_sys button
> ext4 crc16 jbd2 mbcache sg sr_mod cdrom ata_generic virtio_blk
> virtio_net floppy ata_piix libata uhci_hcd virtio_pci virtio_ring
> ehci_hcd virtio scsi_mod usbcore usb_common
> [153468.341412] CPU: 4 PID: 16902 Comm: collect2 Not tainted 3.14.0-rc8+ #61
> [153468.341414] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [153468.341417]  0000000000000000 0000000000000009 ffffffff813a5d47
> 0000000000000000
> [153468.341422]  ffffffff810396af ffff880022f49498 ffffffffa0133e65
> ffff880022cdde68
> [153468.341426]  ffff880022cdde68 00000000ffffffe2 ffff880022f49498
> 0000000000000000
> [153468.341430] Call Trace:
> [153468.341488]  [<ffffffff813a5d47>] ? dump_stack+0x41/0x51
> [153468.341523]  [<ffffffff810396af>] ? warn_slowpath_common+0x78/0x90
> [153468.341536]  [<ffffffffa0133e65>] ?
> __ext4_handle_dirty_metadata+0x5c/0x17f [ext4]
> [153468.341549]  [<ffffffffa0133e65>] ?
> __ext4_handle_dirty_metadata+0x5c/0x17f [ext4]
> [153468.341559]  [<ffffffffa0114f1a>] ? ext4_dirty_inode+0x21/0x52 [ext4]
> [153468.341569]  [<ffffffffa0114ef9>] ? ext4_evict_inode+0x2d8/0x2d8 [ext4]
> [153468.341585]  [<ffffffffa013a37b>] ? ext4_free_blocks+0x757/0x809 [ext4]
> [153468.341612]  [<ffffffff81132c66>] ? __find_get_block+0x154/0x162
> [153468.341625]  [<ffffffffa01317cb>] ? ext4_ext_remove_space+0x621/0xbbc [ext4]
> [153468.341639]  [<ffffffffa013fca2>] ? ext4_es_remove_extent+0x70/0x93 [ext4]
> [153468.341651]  [<ffffffffa0132df4>] ? ext4_ext_truncate+0x7a/0x9e [ext4]
> [153468.341661]  [<ffffffffa0112efb>] ? ext4_truncate+0x1b5/0x29f [ext4]
> [153468.341672]  [<ffffffffa0114de9>] ? ext4_evict_inode+0x1c8/0x2d8 [ext4]
> [153468.341678]  [<ffffffff811218e0>] ? evict+0xa3/0x153
> [153468.341689]  [<ffffffff81118d37>] ? do_unlinkat+0x120/0x1c2
> [153468.341696]  [<ffffffff810ec668>] ? vm_munmap+0x46/0x55
> [153468.341705]  [<ffffffff813af022>] ? system_call_fastpath+0x16/0x1b
> [153468.341708] ---[ end trace 7fd0a6c0fb901b79 ]---
> [153468.341742] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000028
> [153468.342173] IP: [<ffffffffa0127318>] __ext4_error_inode+0x25/0x13c [ext4]
> [153468.342547] PGD 37307067 PUD 36f57067 PMD 0
> [153468.342854] Oops: 0000 [#1] SMP
> [153468.343055] Modules linked in: loop snd_pcm snd_timer snd
> parport_pc parport soundcore i2c_piix4 i2c_core psmouse pcspkr
> microcode serio_raw virtio_balloon evdev processor thermal_sys button
> ext4 crc16 jbd2 mbcache sg sr_mod cdrom ata_generic virtio_blk
> virtio_net floppy ata_piix libata uhci_hcd virtio_pci virtio_ring
> ehci_hcd virtio scsi_mod usbcore usb_common
> [153468.344916] CPU: 4 PID: 16902 Comm: collect2 Tainted: G        W
>  3.14.0-rc8+ #61
> [153468.344916] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [153468.344916] task: ffff880036d74750 ti: ffff88003a9b0000 task.ti:
> ffff88003a9b0000
> [153468.344916] RIP: 0010:[<ffffffffa0127318>]  [<ffffffffa0127318>]
> __ext4_error_inode+0x25/0x13c [ext4]
> [153468.344916] RSP: 0018:ffff88003a9b1b18  EFLAGS: 00010296
> [153468.344916] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000180002
> [153468.344916] RDX: 00000000000012ea RSI: ffffffffa0151023 RDI:
> 0000000000000000
> [153468.344916] RBP: ffffffffa014d9d0 R08: ffffffffa015406a R09:
> 0000000000000005
> [153468.344916] R10: 0000000000000000 R11: ffffffff814e7700 R12:
> 00000000000012ea
> [153468.344916] R13: 0000000000180002 R14: ffffffffa014d9d0 R15:
> 00000000000012ea
> [153468.344916] FS:  00002b5afef92e40(0000) GS:ffff88003cf00000(0000)
> knlGS:0000000000000000
> [153468.344916] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [153468.344916] CR2: 0000000000000028 CR3: 0000000036bf4000 CR4:
> 00000000000006e0
> [153468.344916] Stack:
> [153468.344916]  00000000000012ea ffffffff813a3ceb 0000000000000009
> ffffffff00000010
> [153468.344916]  ffff88003a9b1b88 ffff88003a9b1b48 00000000000012ea
> 7fd0a6c0fb901b79
> [153468.344916]  0000000000000000 0000000000001173 0000000000000002
> ffffffffa0133b17
> [153468.344916] Call Trace:
> [153468.344916]  [<ffffffff813a3ceb>] ? printk+0x4f/0x54
> [153468.344916]  [<ffffffffa0133b17>] ?
> ext4_journal_abort_handle+0x2a/0x89 [ext4]
> [153468.344916]  [<ffffffffa0133f77>] ?
> __ext4_handle_dirty_metadata+0x16e/0x17f [ext4]
> [153468.344916]  [<ffffffffa013a37b>] ? ext4_free_blocks+0x757/0x809 [ext4]
> [153468.344916]  [<ffffffff81132c66>] ? __find_get_block+0x154/0x162
> [153468.344916]  [<ffffffffa01317cb>] ? ext4_ext_remove_space+0x621/0xbbc [ext4]
> [153468.344916]  [<ffffffffa013fca2>] ? ext4_es_remove_extent+0x70/0x93 [ext4]
> [153468.344916]  [<ffffffffa0132df4>] ? ext4_ext_truncate+0x7a/0x9e [ext4]
> [153468.344916]  [<ffffffffa0112efb>] ? ext4_truncate+0x1b5/0x29f [ext4]
> [153468.344916]  [<ffffffffa0114de9>] ? ext4_evict_inode+0x1c8/0x2d8 [ext4]
> [153468.344916]  [<ffffffff811218e0>] ? evict+0xa3/0x153
> [153468.344916]  [<ffffffff81118d37>] ? do_unlinkat+0x120/0x1c2
> [153468.344916]  [<ffffffff810ec668>] ? vm_munmap+0x46/0x55
> [153468.344916]  [<ffffffff813af022>] ? system_call_fastpath+0x16/0x1b
> [153468.344916] Code: 5d 41 5e 41 5f c3 41 55 49 89 cd 41 54 41 89 d4
> 55 48 89 f5 48 c7 c6 23 10 15 a0 53 48 89 fb 48 81 ec 88 00 00 00 4c
> 89 4c 24 78 <48> 8b 47 28 48 8b 57 40 48 8b 80 f8 02 00 00 48 8b 40 68
> 89 90
> [153468.344916] RIP  [<ffffffffa0127318>] __ext4_error_inode+0x25/0x13c [ext4]
> [153468.344916]  RSP <ffff88003a9b1b18>
> [153468.344916] CR2: 0000000000000028
> [153468.373561] ---[ end trace 7fd0a6c0fb901b7a ]---
> 
> Please, if you need additional info keep me in CC as i'm not
> subscribed to the list.
> 
> Regards.
> 
> 
