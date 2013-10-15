From: jon ernst <jonernst07@gmail.com>
Subject: Re: new kernel warning when running xfstest ext4/271 on 3.12
Date: Mon, 14 Oct 2013 23:51:46 -0400
Message-ID: <CAGW2f1F3jM2H-MRpGDH7aJy5LRZ3o98bOh8UguRZ7QDOwD16Ug@mail.gmail.com>
References: <20131014021606.GA31336@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:51518 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3JODvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Oct 2013 23:51:47 -0400
Received: by mail-oa0-f54.google.com with SMTP id n5so5406776oag.27
        for <linux-ext4@vger.kernel.org>; Mon, 14 Oct 2013 20:51:46 -0700 (PDT)
In-Reply-To: <20131014021606.GA31336@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 13, 2013 at 10:16 PM, Eric Whitney <enwlinux@gmail.com> wrote:
>
> Since 3.12-rc1, I've noticed a new warning message in my kernel logs when
> running ext4 regression tests with xfstests on both my x86-64 (KVM guest) and
> ARM (Pandaboard ES) SUTs.  (I'm using xfstests-bld to run xfstests.)  It
> remains visible in 3.12-rc4.
>
> The warning appears when running ext4/271 after mounting the test file system
> with the dioread_nolock option.
>
> After running ext4/271, the kernel log contains the following trace repeated
> 21 times, apparently once for each write performed by dd in the test:
>
> EXT4-fs (vdc): mounted filesystem without journal. Opts: dioread_nolock,noload
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1366 at fs/ext4/page-io.c:205 ext4_put_io_end_defer+0xf5/0x100()
> Modules linked in: snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer psmouse serio_raw snd soundcore virtio_balloon snd_page_alloc i2c_piix4 mac_hid lp parport floppy
> CPU: 1 PID: 1366 Comm: dd Not tainted 3.12.0-rc4-ext4testing+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>  0000000000000009 ffff88003fd03d10 ffffffff816e3b66 0000000000000000
>  ffff88003fd03d48 ffffffff8104eb4c ffff88003d1a1168 ffff88003d209c10
>  0000000000000000 0000000000001000 ffff88003bb57490 ffff88003fd03d58
> Call Trace:
>  <IRQ>  [<ffffffff816e3b66>] dump_stack+0x45/0x56
>  [<ffffffff8104eb4c>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff8104eb9a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff81245df5>] ext4_put_io_end_defer+0xf5/0x100
>  [<ffffffff81245ec6>] ext4_end_bio+0xc6/0xe0
>  [<ffffffff811d206d>] bio_endio+0x1d/0x30
>  [<ffffffff8133313a>] blk_update_request+0xba/0x450
>  [<ffffffff813333e0>] ? blk_update_request+0x360/0x450
>  [<ffffffff813334f7>] blk_update_bidi_request+0x27/0xa0
>  [<ffffffff81336720>] __blk_end_bidi_request+0x20/0x50
>  [<ffffffff8133676f>] __blk_end_request_all+0x1f/0x30
>  [<ffffffff81480a20>] virtblk_done+0x100/0x260
>  [<ffffffff81412b11>] vring_interrupt+0x31/0x50
>  [<ffffffff810a6394>] handle_irq_event_percpu+0x54/0x1f0
>  [<ffffffff810a6578>] handle_irq_event+0x48/0x70
>  [<ffffffff810a8de7>] handle_edge_irq+0x77/0x110
>  [<ffffffff810044de>] handle_irq+0x1e/0x30
>  [<ffffffff816f70ba>] do_IRQ+0x5a/0xe0
>  [<ffffffff816ecdaf>] common_interrupt+0x6f/0x6f
>  <EOI>  [<ffffffff810be18e>] ? lock_acquire+0x9e/0x100
>  [<ffffffff811a76ad>] ? path_init+0x26d/0x4c0
>  [<ffffffff8107ca94>] lg_local_lock+0x34/0x70
>  [<ffffffff811a76ad>] ? path_init+0x26d/0x4c0
>  [<ffffffff811a76ad>] path_init+0x26d/0x4c0
>  [<ffffffff81370898>] ? __raw_spin_lock_init+0x38/0x70
>  [<ffffffff811abbb1>] path_openat+0x81/0x660
>  [<ffffffff81165031>] ? handle_mm_fault+0x2d1/0xaf0
>  [<ffffffff816f0638>] ? __do_page_fault+0x148/0x570
>  [<ffffffff811ac4b3>] do_filp_open+0x43/0xa0
>  [<ffffffff816ec897>] ? _raw_spin_unlock+0x27/0x30
>  [<ffffffff811b9876>] ? __alloc_fd+0xd6/0x130
>  [<ffffffff8119a62c>] do_sys_open+0x13c/0x230
>  [<ffffffff8119a742>] SyS_open+0x22/0x30
>  [<ffffffff816f5192>] system_call_fastpath+0x16/0x1b
> ---[ end trace bd3f4c22c85fc732 ]---
>
> The test itself concludes successfully as written, though it's worth noting
> the test does not check the integrity of the data written.
>
> The same warning can be triggered by the following simple sequence of
> commands, extracted from ext4/271:
>
> mkfs.ext4 /dev/vdc
> mount -o dioread_nolock,noload /dev/vdc /vdc
> touch /vdc/file
> chattr +S /vdc/file
> dd if=/dev/zero of=/vdc/file bs=4k count=1
>
> (FWIW, if you omit the touch and chattr commands, the warning won't be
> triggered unless a second instance of the dd command is issued.)
>
> The warning bisects cleanly to this patch:
> 7b7a8665ed direct-io: Implement generic deferred AIO completions
>
> Apparently, !io_end->handle is unexpectedly true in this test case.  A
> WARN_ON for that condition was newly added in the patch.
>
> It's not yet clear to me how serious this warning is, but the new message is
> at least a minor regression.
>
> Thanks,
> Eric
>

I have tested it too. Got same result as yours. I also put some
printks to see runtime values.
It turned out io_end->handle is always 0 when I ran your test case.
And, flag is EXT4_IO_END_UNWRITTEN just before WARNNING been triggered.
and io_end->size is always 4096 on my machine.

Below is my dump. Hope it provides a little bit more information.

[  313.464892] ext4 io_end->handle is 0,
[  313.464900] is EXT4_IO_END_UNWRITTEN
[  313.464901] io_end->size = 4096.
[  313.464902] ------------[ cut here ]------------
[  313.464907] WARNING: CPU: 0 PID: 0 at fs/ext4/page-io.c:205
ext4_put_io_end_defer+0xef/0x110()
[  313.464908] Modules linked in: kvm_intel kvm bnep rfcomm bluetooth
parport_pc ppdev binfmt_misc snd_hda_codec_hdmi snd_hda_codec_conexant
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi i915
snd_rawmidi snd_seq_midi_event joydev snd_seq drm_kms_helper drm
snd_timer snd_seq_device psmouse snd soundcore serio_raw lpc_ich
dcdbas snd_page_alloc i2c_algo_bit video mac_hid coretemp lp parport
hid_generic usbhid r8169 hid mii
[  313.464941] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc4+ #3
[  313.464942] Hardware name: ***       , BIOS A04 11/21/2011
[  313.464943]  00000000000000cd ffff8801bfa03c10 ffffffff816903c7
0000000000000e4b
[  313.464945]  0000000000000000 ffff8801bfa03c50 ffffffff8104e34c
ffff8801bfa03c70
[  313.464947]  ffff8800302a31f8 ffff8801ada1cc20 0000000000000000
ffff88008da85180
[  313.464949] Call Trace:
[  313.464950]  <IRQ>  [<ffffffff816903c7>] dump_stack+0x46/0x58
[  313.464957]  [<ffffffff8104e34c>] warn_slowpath_common+0x8c/0xc0
[  313.464959]  [<ffffffff8104e39a>] warn_slowpath_null+0x1a/0x20
[  313.464961]  [<ffffffff8122a2ef>] ext4_put_io_end_defer+0xef/0x110
[  313.464963]  [<ffffffff81494bc9>] ? ata_scsi_qc_complete+0x69/0x460
[  313.464965]  [<ffffffff8122a402>] ext4_end_bio+0xf2/0x100
[  313.464967]  [<ffffffff811baebd>] bio_endio+0x1d/0x40
[  313.464970]  [<ffffffff81307c98>] blk_update_request+0xb8/0x3f0
[  313.464973]  [<ffffffff8148e05d>] ? ata_qc_complete+0x9d/0x230
[  313.464975]  [<ffffffff81308001>] blk_update_bidi_request+0x31/0x90
[  313.464977]  [<ffffffff8130870c>] blk_end_bidi_request+0x2c/0x80
[  313.464979]  [<ffffffff813087a0>] blk_end_request+0x10/0x20
[  313.464982]  [<ffffffff81465f5f>] scsi_io_completion+0xaf/0x710
[  313.464984]  [<ffffffff814a0a50>] ? ata_sff_softreset+0x190/0x190
[  313.464987]  [<ffffffff8145c7e1>] scsi_finish_command+0xc1/0x120
[  313.464988]  [<ffffffff81465dbe>] scsi_softirq_done+0x13e/0x150
[  313.464990]  [<ffffffff8130f0a3>] blk_done_softirq+0x73/0x90
[  313.464993]  [<ffffffff81052f90>] __do_softirq+0xd0/0x270
[  313.464996]  [<ffffffff816a0a5c>] call_softirq+0x1c/0x30
[  313.464998]  [<ffffffff810045a5>] do_softirq+0x55/0x90
[  313.465000]  [<ffffffff81053276>] irq_exit+0x86/0xb0
[  313.465002]  [<ffffffff816a10e3>] do_IRQ+0x63/0xe0
[  313.465004]  [<ffffffff8169736a>] common_interrupt+0x6a/0x6a
[  313.465005]  <EOI>  [<ffffffff8107480f>] ?
__hrtimer_start_range_ns+0x18f/0x490
[  313.465011]  [<ffffffff8155313b>] ? cpuidle_enter_state+0x5b/0xe0
[  313.465012]  [<ffffffff81553137>] ? cpuidle_enter_state+0x57/0xe0
[  313.465014]  [<ffffffff81553280>] cpuidle_idle_call+0xc0/0x220
[  313.465017]  [<ffffffff8100b7fe>] arch_cpu_idle+0xe/0x30
[  313.465019]  [<ffffffff810a0ace>] cpu_startup_entry+0xce/0x290
[  313.465022]  [<ffffffff81681f07>] rest_init+0x77/0x80
[  313.465025]  [<ffffffff81d04e64>] start_kernel+0x3d3/0x3e0
[  313.465027]  [<ffffffff81d04891>] ? repair_env_string+0x5a/0x5a
[  313.465029]  [<ffffffff81d045a8>] x86_64_start_reservations+0x2a/0x2c
[  313.465030]  [<ffffffff81d04696>] x86_64_start_kernel+0xec/0xf3
[  313.465031] ---[ end trace da7f582e4c5a7b8c ]--

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
