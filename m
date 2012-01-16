From: Jan Kara <jack@suse.cz>
Subject: Re: Fwd: [BUG] NULL deref in  jbd2_journal_grab_journal_head
Date: Mon, 16 Jan 2012 23:02:34 +0100
Message-ID: <20120116220234.GA25424@quack.suse.cz>
References: <4F10140F.1030905@cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F10140F.1030905@cwi.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Fri 13-01-12 11:22:55, Wouter M. Koolen wrote:
> Dear jbd2 maintainers,
> 
> I observed the below BUG a couple of seconds after resuming from ram. I
> include all the fallout, in hope that it may be helpful.
> 
> I am using kernel 3.2.1.
> 
> Please let me know what other details I could provide.
> 
> With kind regards,
> 
> Wouter Koolen
> 
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffffa0069cb4>] jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> PGD 5df46067 PUD 5df45067 PMD 0
> Oops: 0002 [#1] SMP
> CPU 0
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> 
> Pid: 24, comm: kswapd0 Not tainted 3.2.1.git #1 Apple Inc.
> MacBook4,1/Mac-F22788A9
> RIP: 0010:[<ffffffffa0069cb4>]  [<ffffffffa0069cb4>]
> jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> RSP: 0018:ffff8800789d59b0  EFLAGS: 00010202
> RAX: ffff8800789d5fd8 RBX: ffff880077706f20 RCX: 4000000000000009
> RDX: ffff8800789d5fd8 RSI: ffffea0000afa6b0 RDI: 0000000000000000
> RBP: ffff8800789d59b0 R08: ffff880008c77c80 R09: dead000000100100
> R10: dead000000200200 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8800789d5fd8 R15: ffff8800789d5fd8
> FS:  0000000000000000(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000060733000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Thanks for report! Apparently jbd2_journal_grab_journal_head() was called
with bh == NULL and we crashed when accessing bh->b_state. Since we checked
page_has_buffers() just shortly before in ext4_releasepage() this looks
either as a bitflip in page flags, or some race in page handling tearing
buffers from locked page, or corruption leading to NULL page->private but
PagePrivate bit set. Frankly, I'd consider the bitflip most likely (also
given the suspend to ram)... But I already saw a few reports like this over
past years so maybe there's a bug somewhere after all.

									Honza

> Process kswapd0 (pid: 24, threadinfo ffff8800789d4000, task
> ffff8800789d2140)
> Stack:
> ffff8800789d5a20 ffffffffa0060088 ffff880008c77cb0 ffffffff810e9285
> ffff8800789d5fd8 ffff8800789d5fd8 ffffea0000afa6b0 ffff88000008fdb0
> 0000000000000000 ffffea0000afa6b0 ffff880077706f20 ffffea0000afa6d0
> Call Trace:
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffff810e9285>] ? __remove_mapping+0xb5/0x150
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb33c>] ? shrink_inactive_list+0x19c/0x490
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff810ec1f5>] kswapd+0x655/0xa80
> [<ffffffff8106db90>] ? __init_waitqueue_head+0x60/0x60
> [<ffffffff810ebba0>] ? shrink_zone+0x570/0x570
> [<ffffffff8106d282>] kthread+0xa2/0xb0
> [<ffffffff81417fd4>] kernel_thread_helper+0x4/0x10
> [<ffffffff8106d1e0>] ? __init_kthread_worker+0x70/0x70
> [<ffffffff81417fd0>] ? gs_change+0xb/0xb
> Code: 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 48 89 df e8 52 eb 0e e1 eb
> bb 55 65 48 8b 04 25 48 b6 00 00 83 80 44 e0 ff ff 01 48 89 e5<f0>  0f
> ba 2f 15 19 d2 85 d2 75 34 48 8b 17 31 c0 80 e6 40 74 08
> RIP  [<ffffffffa0069cb4>] jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> RSP<ffff8800789d59b0>
> CR2: 0000000000000000
> ---[ end trace 17338e42d6591a02 ]---
> note: kswapd0[24] exited with preempt_count 1
> BUG: sleeping function called from invalid context at kernel/rwsem.c:48
> in_atomic(): 1, irqs_disabled(): 0, pid: 24, name: kswapd0
> INFO: lockdep is turned off.
> Pid: 24, comm: kswapd0 Tainted: G      D      3.2.1.git #1
> Call Trace:
> [<ffffffff810335aa>] __might_sleep+0xda/0x100
> [<ffffffff8140f16f>] down_write+0x1f/0x70
> [<ffffffff811a47f8>] exit_shm+0x48/0x90
> [<ffffffff8104cd0d>] do_exit+0x13d/0x810
> [<ffffffff8104aa74>] ? kmsg_dump+0xf4/0x140
> [<ffffffff8141159d>] oops_end+0x9d/0xe0
> [<ffffffff81407ac3>] no_context+0x1a2/0x1b1
> [<ffffffff81407c90>] __bad_area_nosemaphore+0x1be/0x1dd
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff81407cbd>] bad_area_nosemaphore+0xe/0x10
> [<ffffffff81413fd7>] do_page_fault+0x3d7/0x4f0
> [<ffffffff81124e6e>] ? __delete_object+0x7e/0xc0
> [<ffffffff81119afe>] ? poison_obj+0x2e/0x40
> [<ffffffff8111aaeb>] ? cache_free_debugcheck+0x13b/0x280
> [<ffffffff81410c3f>] page_fault+0x1f/0x30
> [<ffffffffa0069cb4>] ? jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffff810e9285>] ? __remove_mapping+0xb5/0x150
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb33c>] ? shrink_inactive_list+0x19c/0x490
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff810ec1f5>] kswapd+0x655/0xa80
> [<ffffffff8106db90>] ? __init_waitqueue_head+0x60/0x60
> [<ffffffff810ebba0>] ? shrink_zone+0x570/0x570
> [<ffffffff8106d282>] kthread+0xa2/0xb0
> [<ffffffff81417fd4>] kernel_thread_helper+0x4/0x10
> [<ffffffff8106d1e0>] ? __init_kthread_worker+0x70/0x70
> [<ffffffff81417fd0>] ? gs_change+0xb/0xb
> BUG: scheduling while atomic: kswapd0/24/0x10000002
> INFO: lockdep is turned off.
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> Pid: 24, comm: kswapd0 Tainted: G      D      3.2.1.git #1
> Call Trace:
> [<ffffffff81407fe4>] __schedule_bug+0x60/0x65
> [<ffffffff8140d1c1>] __schedule+0x911/0x950
> [<ffffffff810059a7>] ? show_trace_log_lvl+0x57/0x70
> [<ffffffff810059d0>] ? show_trace+0x10/0x20
> [<ffffffff81040175>] __cond_resched+0x25/0x40
> [<ffffffff8140d27d>] _cond_resched+0x2d/0x40
> [<ffffffff8140f174>] down_write+0x24/0x70
> [<ffffffff811a47f8>] exit_shm+0x48/0x90
> [<ffffffff8104cd0d>] do_exit+0x13d/0x810
> [<ffffffff8104aa74>] ? kmsg_dump+0xf4/0x140
> [<ffffffff8141159d>] oops_end+0x9d/0xe0
> [<ffffffff81407ac3>] no_context+0x1a2/0x1b1
> [<ffffffff81407c90>] __bad_area_nosemaphore+0x1be/0x1dd
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff81407cbd>] bad_area_nosemaphore+0xe/0x10
> [<ffffffff81413fd7>] do_page_fault+0x3d7/0x4f0
> [<ffffffff81124e6e>] ? __delete_object+0x7e/0xc0
> [<ffffffff81119afe>] ? poison_obj+0x2e/0x40
> [<ffffffff8111aaeb>] ? cache_free_debugcheck+0x13b/0x280
> [<ffffffff81410c3f>] page_fault+0x1f/0x30
> [<ffffffffa0069cb4>] ? jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffff810e9285>] ? __remove_mapping+0xb5/0x150
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb33c>] ? shrink_inactive_list+0x19c/0x490
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff810ec1f5>] kswapd+0x655/0xa80
> [<ffffffff8106db90>] ? __init_waitqueue_head+0x60/0x60
> [<ffffffff810ebba0>] ? shrink_zone+0x570/0x570
> [<ffffffff8106d282>] kthread+0xa2/0xb0
> [<ffffffff81417fd4>] kernel_thread_helper+0x4/0x10
> [<ffffffff8106d1e0>] ? __init_kthread_worker+0x70/0x70
> [<ffffffff81417fd0>] ? gs_change+0xb/0xb
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffffa0069cb4>] jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> PGD 0
> Oops: 0002 [#2] SMP
> CPU 1
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> 
> Pid: 1203, comm: Xorg Tainted: G      D      3.2.1.git #1 Apple Inc.
> MacBook4,1/Mac-F22788A9
> RIP: 0010:[<ffffffffa0069cb4>]  [<ffffffffa0069cb4>]
> jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> RSP: 0018:ffff880073b25338  EFLAGS: 00010202
> RAX: ffff880073b25fd8 RBX: ffff880077706f20 RCX: 4000000000000009
> RDX: ffff880073b25fd8 RSI: ffffea00017e83a8 RDI: 0000000000000000
> RBP: ffff880073b25338 R08: ffff880008c77c80 R09: dead000000100100
> R10: dead000000200200 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff880073b25fd8 R15: ffff880073b25fd8
> FS:  00007f864a09a880(0000) GS:ffff88007db00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000073b76000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process Xorg (pid: 1203, threadinfo ffff880073b24000, task ffff8800739c80c0)
> Stack:
> ffff880073b253a8 ffffffffa0060088 0000000000000000 0000000000000046
> ffff880073b25fd8 ffff880073b25fd8 ffffea00017e83a8 ffff88000008f2b0
> 0000000000000000 ffffea00017e83a8 ffff880077706f20 ffffea00017e83c8
> Call Trace:
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810e45e7>] ? pagevec_lru_move_fn+0x77/0xe0
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff81036cc1>] ? cpuacct_charge+0x21/0xd0
> [<ffffffff810779c8>] ? ktime_get_ts+0xa8/0xe0
> [<ffffffff810ec9ae>] do_try_to_free_pages+0x38e/0x4c0
> [<ffffffff810f3924>] ? __mod_zone_page_state+0x44/0x50
> [<ffffffff810ecc46>] try_to_free_pages+0xa6/0x1b0
> [<ffffffff810e07bc>] __alloc_pages_nodemask+0x54c/0x860
> [<ffffffff810d86b0>] ? add_to_page_cache_lru+0x50/0x50
> [<ffffffff811005b3>] ? __vm_enough_memory+0x33/0x190
> [<ffffffff810ef0f3>] shmem_getpage_gfp+0x283/0x5a0
> [<ffffffff810ef43f>] shmem_read_mapping_page_gfp+0x2f/0x60
> [<ffffffff812b546d>] i915_gem_object_bind_to_gtt+0x1dd/0x650
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812b913f>] i915_gem_object_pin+0x16f/0x1c0
> [<ffffffff812b9210>] i915_gem_object_pin_to_display_plane+0x80/0x1e0
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812c9208>] intel_pin_and_fence_fb_obj+0x68/0x120
> [<ffffffff812c99c7>] intel_pipe_set_base+0xb7/0x2f0
> [<ffffffff811e4804>] ? snprintf+0x34/0x40
> [<ffffffff81288443>] ? drm_crtc_helper_set_config+0x143/0xae0
> [<ffffffff81288a60>] drm_crtc_helper_set_config+0x760/0xae0
> [<ffffffff81299cb1>] ? drm_mode_object_find+0x31/0x80
> [<ffffffff8129c0d4>] drm_mode_setcrtc+0x124/0x490
> [<ffffffff8140ee59>] ? mutex_unlock+0x9/0x10
> [<ffffffff8128d614>] drm_ioctl+0x454/0x530
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8129bfb0>] ? drm_mode_getencoder+0xb0/0xb0
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8113a5f7>] do_vfs_ioctl+0x97/0x600
> [<ffffffff811284f0>] ? vfs_write+0x120/0x160
> [<ffffffff8113abaa>] sys_ioctl+0x4a/0x80
> [<ffffffff81416ebb>] system_call_fastpath+0x16/0x1b
> Code: 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 48 89 df e8 52 eb 0e e1 eb
> bb 55 65 48 8b 04 25 48 b6 00 00 83 80 44 e0 ff ff 01 48 89 e5<f0>  0f
> ba 2f 15 19 d2 85 d2 75 34 48 8b 17 31 c0 80 e6 40 74 08
> RIP  [<ffffffffa0069cb4>] jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> RSP<ffff880073b25338>
> CR2: 0000000000000000
> ---[ end trace 17338e42d6591a03 ]---
> note: Xorg[1203] exited with preempt_count 1
> BUG: scheduling while atomic: Xorg/1203/0x10000002
> INFO: lockdep is turned off.
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> Pid: 1203, comm: Xorg Tainted: G      D      3.2.1.git #1
> Call Trace:
> [<ffffffff81407fe4>] __schedule_bug+0x60/0x65
> [<ffffffff8140d1c1>] __schedule+0x911/0x950
> [<ffffffff810718ab>] ? lock_hrtimer_base.isra.21+0x2b/0x60
> [<ffffffff81040175>] __cond_resched+0x25/0x40
> [<ffffffff8140d27d>] _cond_resched+0x2d/0x40
> [<ffffffff81087d98>] exit_robust_list+0x68/0x1c0
> [<ffffffff8140ffcf>] ? _raw_spin_lock_irqsave+0x4f/0x60
> [<ffffffff810718ab>] ? lock_hrtimer_base.isra.21+0x2b/0x60
> [<ffffffff810462ff>] mm_release+0x11f/0x130
> [<ffffffff8104b131>] exit_mm+0x21/0x130
> [<ffffffff8104ccf8>] do_exit+0x128/0x810
> [<ffffffff8104aa74>] ? kmsg_dump+0xf4/0x140
> [<ffffffff8141159d>] oops_end+0x9d/0xe0
> [<ffffffff81407ac3>] no_context+0x1a2/0x1b1
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81407c90>] __bad_area_nosemaphore+0x1be/0x1dd
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff81407cbd>] bad_area_nosemaphore+0xe/0x10
> [<ffffffff81413fd7>] do_page_fault+0x3d7/0x4f0
> [<ffffffff811ee0bf>] ? debug_check_no_obj_freed+0x17f/0x230
> [<ffffffff81104fee>] ? __page_check_address+0xde/0x170
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81410c3f>] page_fault+0x1f/0x30
> [<ffffffffa0069cb4>] ? jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810e45e7>] ? pagevec_lru_move_fn+0x77/0xe0
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff81036cc1>] ? cpuacct_charge+0x21/0xd0
> [<ffffffff810779c8>] ? ktime_get_ts+0xa8/0xe0
> [<ffffffff810ec9ae>] do_try_to_free_pages+0x38e/0x4c0
> [<ffffffff810f3924>] ? __mod_zone_page_state+0x44/0x50
> [<ffffffff810ecc46>] try_to_free_pages+0xa6/0x1b0
> [<ffffffff810e07bc>] __alloc_pages_nodemask+0x54c/0x860
> [<ffffffff810d86b0>] ? add_to_page_cache_lru+0x50/0x50
> [<ffffffff811005b3>] ? __vm_enough_memory+0x33/0x190
> [<ffffffff810ef0f3>] shmem_getpage_gfp+0x283/0x5a0
> [<ffffffff810ef43f>] shmem_read_mapping_page_gfp+0x2f/0x60
> [<ffffffff812b546d>] i915_gem_object_bind_to_gtt+0x1dd/0x650
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812b913f>] i915_gem_object_pin+0x16f/0x1c0
> [<ffffffff812b9210>] i915_gem_object_pin_to_display_plane+0x80/0x1e0
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812c9208>] intel_pin_and_fence_fb_obj+0x68/0x120
> [<ffffffff812c99c7>] intel_pipe_set_base+0xb7/0x2f0
> [<ffffffff811e4804>] ? snprintf+0x34/0x40
> [<ffffffff81288443>] ? drm_crtc_helper_set_config+0x143/0xae0
> [<ffffffff81288a60>] drm_crtc_helper_set_config+0x760/0xae0
> [<ffffffff81299cb1>] ? drm_mode_object_find+0x31/0x80
> [<ffffffff8129c0d4>] drm_mode_setcrtc+0x124/0x490
> [<ffffffff8140ee59>] ? mutex_unlock+0x9/0x10
> [<ffffffff8128d614>] drm_ioctl+0x454/0x530
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8129bfb0>] ? drm_mode_getencoder+0xb0/0xb0
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8113a5f7>] do_vfs_ioctl+0x97/0x600
> [<ffffffff811284f0>] ? vfs_write+0x120/0x160
> [<ffffffff8113abaa>] sys_ioctl+0x4a/0x80
> [<ffffffff81416ebb>] system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: Xorg/1203/0x10000002
> INFO: lockdep is turned off.
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> Pid: 1203, comm: Xorg Tainted: G      D      3.2.1.git #1
> Call Trace:
> [<ffffffff81407fe4>] __schedule_bug+0x60/0x65
> [<ffffffff8140d1c1>] __schedule+0x911/0x950
> [<ffffffff81040175>] __cond_resched+0x25/0x40
> [<ffffffff8140d27d>] _cond_resched+0x2d/0x40
> [<ffffffff810fafca>] unmap_vmas+0x4fa/0x7d0
> [<ffffffff81102b09>] exit_mmap+0xb9/0x130
> [<ffffffff810460b4>] mmput+0x74/0x150
> [<ffffffff8104b219>] exit_mm+0x109/0x130
> [<ffffffff8104ccf8>] do_exit+0x128/0x810
> [<ffffffff8104aa74>] ? kmsg_dump+0xf4/0x140
> [<ffffffff8141159d>] oops_end+0x9d/0xe0
> [<ffffffff81407ac3>] no_context+0x1a2/0x1b1
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81407c90>] __bad_area_nosemaphore+0x1be/0x1dd
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff81407cbd>] bad_area_nosemaphore+0xe/0x10
> [<ffffffff81413fd7>] do_page_fault+0x3d7/0x4f0
> [<ffffffff811ee0bf>] ? debug_check_no_obj_freed+0x17f/0x230
> [<ffffffff81104fee>] ? __page_check_address+0xde/0x170
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81410c3f>] page_fault+0x1f/0x30
> [<ffffffffa0069cb4>] ? jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810e45e7>] ? pagevec_lru_move_fn+0x77/0xe0
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff81036cc1>] ? cpuacct_charge+0x21/0xd0
> [<ffffffff810779c8>] ? ktime_get_ts+0xa8/0xe0
> [<ffffffff810ec9ae>] do_try_to_free_pages+0x38e/0x4c0
> [<ffffffff810f3924>] ? __mod_zone_page_state+0x44/0x50
> [<ffffffff810ecc46>] try_to_free_pages+0xa6/0x1b0
> [<ffffffff810e07bc>] __alloc_pages_nodemask+0x54c/0x860
> [<ffffffff810d86b0>] ? add_to_page_cache_lru+0x50/0x50
> [<ffffffff811005b3>] ? __vm_enough_memory+0x33/0x190
> [<ffffffff810ef0f3>] shmem_getpage_gfp+0x283/0x5a0
> [<ffffffff810ef43f>] shmem_read_mapping_page_gfp+0x2f/0x60
> [<ffffffff812b546d>] i915_gem_object_bind_to_gtt+0x1dd/0x650
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812b913f>] i915_gem_object_pin+0x16f/0x1c0
> [<ffffffff812b9210>] i915_gem_object_pin_to_display_plane+0x80/0x1e0
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812c9208>] intel_pin_and_fence_fb_obj+0x68/0x120
> [<ffffffff812c99c7>] intel_pipe_set_base+0xb7/0x2f0
> [<ffffffff811e4804>] ? snprintf+0x34/0x40
> [<ffffffff81288443>] ? drm_crtc_helper_set_config+0x143/0xae0
> [<ffffffff81288a60>] drm_crtc_helper_set_config+0x760/0xae0
> [<ffffffff81299cb1>] ? drm_mode_object_find+0x31/0x80
> [<ffffffff8129c0d4>] drm_mode_setcrtc+0x124/0x490
> [<ffffffff8140ee59>] ? mutex_unlock+0x9/0x10
> [<ffffffff8128d614>] drm_ioctl+0x454/0x530
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8129bfb0>] ? drm_mode_getencoder+0xb0/0xb0
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8113a5f7>] do_vfs_ioctl+0x97/0x600
> [<ffffffff811284f0>] ? vfs_write+0x120/0x160
> [<ffffffff8113abaa>] sys_ioctl+0x4a/0x80
> [<ffffffff81416ebb>] system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: Xorg/1203/0x00000002
> INFO: lockdep is turned off.
> Modules linked in: aes_x86_64 aes_generic hidp acpi_cpufreq mperf
> cpufreq_stats cpufreq_powersave rfcomm bnep binfmt_misc microcode uinput
> fuse sbs sbshc coretemp i2c_dev loop firewire_sbp2 btusb bluetooth
> snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep b43
> mac80211 cfg80211 hid_apple snd_pcm_oss snd_mixer_oss uvcvideo usbhid
> snd_pcm rfkill videodev rng_core hid appletouch v4l2_compat_ioctl32
> snd_seq snd_timer snd_seq_device firewire_ohci firewire_core ssb snd
> soundcore applesmc sr_mod cdrom uhci_hcd ehci_hcd mmc_core usbcore sky2
> pcspkr crc_itu_t input_polldev usb_common i2c_i801 snd_page_alloc
> battery processor ac evdev apple_bl power_supply ext4 mbcache jbd2 crc16
> sd_mod crc_t10dif ata_piix libata scsi_mod
> Pid: 1203, comm: Xorg Tainted: G      D      3.2.1.git #1
> Call Trace:
> [<ffffffff81407fe4>] __schedule_bug+0x60/0x65
> [<ffffffff8140d1c1>] __schedule+0x911/0x950
> [<ffffffff8128eec1>] ? drm_gem_vm_close+0x31/0x70
> [<ffffffff8140d4fa>] schedule+0x3a/0x50
> [<ffffffff8140e173>] mutex_lock_nested+0x163/0x310
> [<ffffffff8128eec1>] ? drm_gem_vm_close+0x31/0x70
> [<ffffffff8128eec1>] drm_gem_vm_close+0x31/0x70
> [<ffffffff811001a0>] remove_vma+0x40/0x80
> [<ffffffff81102b58>] exit_mmap+0x108/0x130
> [<ffffffff810460b4>] mmput+0x74/0x150
> [<ffffffff8104b219>] exit_mm+0x109/0x130
> [<ffffffff8104ccf8>] do_exit+0x128/0x810
> [<ffffffff8104aa74>] ? kmsg_dump+0xf4/0x140
> [<ffffffff8141159d>] oops_end+0x9d/0xe0
> [<ffffffff81407ac3>] no_context+0x1a2/0x1b1
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81407c90>] __bad_area_nosemaphore+0x1be/0x1dd
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff811edfc8>] ? debug_check_no_obj_freed+0x88/0x230
> [<ffffffff81407cbd>] bad_area_nosemaphore+0xe/0x10
> [<ffffffff81413fd7>] do_page_fault+0x3d7/0x4f0
> [<ffffffff811ee0bf>] ? debug_check_no_obj_freed+0x17f/0x230
> [<ffffffff81104fee>] ? __page_check_address+0xde/0x170
> [<ffffffff8108254c>] ? __lock_acquire.isra.26+0x3ec/0xaf0
> [<ffffffff81410c3f>] page_fault+0x1f/0x30
> [<ffffffffa0069cb4>] ? jbd2_journal_grab_journal_head+0x14/0x90 [jbd2]
> [<ffffffffa0060088>] jbd2_journal_try_to_free_buffers+0x68/0x1b0 [jbd2]
> [<ffffffffa00c8fbd>] ext4_releasepage+0x6d/0x110 [ext4]
> [<ffffffff810e45e7>] ? pagevec_lru_move_fn+0x77/0xe0
> [<ffffffff810d8170>] try_to_release_page+0x30/0x50
> [<ffffffff810eacc2>] shrink_page_list+0x7c2/0xa00
> [<ffffffff810eb355>] shrink_inactive_list+0x1b5/0x490
> [<ffffffff810eb746>] ? shrink_zone+0x116/0x570
> [<ffffffff810ebaa1>] shrink_zone+0x471/0x570
> [<ffffffff81036cc1>] ? cpuacct_charge+0x21/0xd0
> [<ffffffff810779c8>] ? ktime_get_ts+0xa8/0xe0
> [<ffffffff810ec9ae>] do_try_to_free_pages+0x38e/0x4c0
> [<ffffffff810f3924>] ? __mod_zone_page_state+0x44/0x50
> [<ffffffff810ecc46>] try_to_free_pages+0xa6/0x1b0
> [<ffffffff810e07bc>] __alloc_pages_nodemask+0x54c/0x860
> [<ffffffff810d86b0>] ? add_to_page_cache_lru+0x50/0x50
> [<ffffffff811005b3>] ? __vm_enough_memory+0x33/0x190
> [<ffffffff810ef0f3>] shmem_getpage_gfp+0x283/0x5a0
> [<ffffffff810ef43f>] shmem_read_mapping_page_gfp+0x2f/0x60
> [<ffffffff812b546d>] i915_gem_object_bind_to_gtt+0x1dd/0x650
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812b913f>] i915_gem_object_pin+0x16f/0x1c0
> [<ffffffff812b9210>] i915_gem_object_pin_to_display_plane+0x80/0x1e0
> [<ffffffff812c99b5>] ? intel_pipe_set_base+0xa5/0x2f0
> [<ffffffff812c9208>] intel_pin_and_fence_fb_obj+0x68/0x120
> [<ffffffff812c99c7>] intel_pipe_set_base+0xb7/0x2f0
> [<ffffffff811e4804>] ? snprintf+0x34/0x40
> [<ffffffff81288443>] ? drm_crtc_helper_set_config+0x143/0xae0
> [<ffffffff81288a60>] drm_crtc_helper_set_config+0x760/0xae0
> [<ffffffff81299cb1>] ? drm_mode_object_find+0x31/0x80
> [<ffffffff8129c0d4>] drm_mode_setcrtc+0x124/0x490
> [<ffffffff8140ee59>] ? mutex_unlock+0x9/0x10
> [<ffffffff8128d614>] drm_ioctl+0x454/0x530
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8129bfb0>] ? drm_mode_getencoder+0xb0/0xb0
> [<ffffffff81166372>] ? fsnotify+0x82/0x2e0
> [<ffffffff8113a5f7>] do_vfs_ioctl+0x97/0x600
> [<ffffffff811284f0>] ? vfs_write+0x120/0x160
> [<ffffffff8113abaa>] sys_ioctl+0x4a/0x80
> [<ffffffff81416ebb>] system_call_fastpath+0x16/0x1b
> 
> 
> 

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.2.1.git Kernel Configuration
> #
> CONFIG_64BIT=y
> # CONFIG_X86_32 is not set
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> # CONFIG_KTIME_SCALAR is not set
> CONFIG_ARCH_CPU_PROBE_RELEASE=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_HAVE_IRQ_WORK=y
> CONFIG_IRQ_WORK=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_FHANDLE=y
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> # CONFIG_TASK_XACCT is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_HAVE_SPARSE_IRQ=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=64
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_RCU_FAST_NO_HZ=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> CONFIG_CGROUP_CPUACCT=y
> # CONFIG_RESOURCE_COUNTERS is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=m
> # CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_JUMP_LABEL=y
> CONFIG_OPTPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_KRETPROBES=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PREEMPT_NOTIFIERS=y
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_SPIN_UNLOCK is not set
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_PARAVIRT_GUEST is not set
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_MATOM is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_CMPXCHG=y
> CONFIG_CMPXCHG_LOCAL=y
> CONFIG_CMPXCHG_DOUBLE=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_P6_NOP=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> # CONFIG_CPU_SUP_AMD is not set
> # CONFIG_CPU_SUP_CENTAUR is not set
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=2
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> # CONFIG_I8K is not set
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_PROC_KCORE_TEXT=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> # CONFIG_HWPOISON_INJECT is not set
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_ARCH_RANDOM is not set
> CONFIG_EFI=y
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> # CONFIG_KEXEC_JUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> CONFIG_PM_ADVANCED_DEBUG=y
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_CAN_PM_TRACE=y
> # CONFIG_PM_TRACE_RTC is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=m
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=m
> # CONFIG_ACPI_IPMI is not set
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_DEBUG=y
> # CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
> CONFIG_ACPI_PCI_SLOT=m
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=m
> CONFIG_ACPI_SBS=m
> CONFIG_ACPI_HED=m
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> # CONFIG_CPU_FREQ_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_PCC_CPUFREQ is not set
> CONFIG_X86_ACPI_CPUFREQ=m
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
> 
> #
> # shared options
> #
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Memory power savings
> #
> # CONFIG_I7300_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> # CONFIG_PCIEAER_INJECT is not set
> CONFIG_PCIEASPM=y
> CONFIG_PCIEASPM_DEBUG=y
> CONFIG_PCIE_PME=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> CONFIG_PCCARD=m
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> # CONFIG_PD6729 is not set
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=m
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> CONFIG_COMPAT_NETLINK_MESSAGES=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=m
> CONFIG_NET_KEY=m
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_IP_FIB_TRIE_STATS=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_IP_ROUTE_CLASSID=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_LRO=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> # CONFIG_TCP_CONG_HSTCP is not set
> # CONFIG_TCP_CONG_HYBLA is not set
> # CONFIG_TCP_CONG_VEGAS is not set
> # CONFIG_TCP_CONG_SCALABLE is not set
> # CONFIG_TCP_CONG_LP is not set
> # CONFIG_TCP_CONG_VENO is not set
> # CONFIG_TCP_CONG_YEAH is not set
> # CONFIG_TCP_CONG_ILLINOIS is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> # CONFIG_IPV6_ROUTE_INFO is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> # CONFIG_IPV6_MIP6 is not set
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> CONFIG_IPV6_SIT=m
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> CONFIG_ATALK=m
> CONFIG_DEV_APPLETALK=m
> CONFIG_IPDDP=m
> CONFIG_IPDDP_ENCAP=y
> CONFIG_IPDDP_DECAP=y
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_MULTIQ=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFB=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_DRR=m
> CONFIG_NET_SCH_MQPRIO=m
> CONFIG_NET_SCH_CHOKE=m
> CONFIG_NET_SCH_QFQ=m
> CONFIG_NET_SCH_INGRESS=m
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> CONFIG_NET_CLS_FLOW=m
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_NAT=m
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> CONFIG_NET_ACT_SKBEDIT=m
> CONFIG_NET_ACT_CSUM=m
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=m
> # CONFIG_BATMAN_ADV_DEBUG is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_HAVE_BPF_JIT=y
> CONFIG_BPF_JIT=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_TCPPROBE is not set
> # CONFIG_NET_DROP_MONITOR is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=m
> CONFIG_BT_L2CAP=y
> CONFIG_BT_SCO=y
> CONFIG_BT_RFCOMM=m
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=m
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_HIDP=m
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=m
> # CONFIG_BT_HCIBTSDIO is not set
> # CONFIG_BT_HCIUART is not set
> # CONFIG_BT_HCIBCM203X is not set
> # CONFIG_BT_HCIBPA10X is not set
> # CONFIG_BT_HCIBFUSB is not set
> # CONFIG_BT_HCIDTL1 is not set
> # CONFIG_BT_HCIBT3C is not set
> # CONFIG_BT_HCIBLUECARD is not set
> # CONFIG_BT_HCIBTUART is not set
> # CONFIG_BT_HCIVHCI is not set
> # CONFIG_BT_MRVL is not set
> # CONFIG_BT_ATH3K is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_CFG80211=m
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_WEXT=y
> # CONFIG_WIRELESS_EXT_SYSFS is not set
> # CONFIG_LIB80211 is not set
> CONFIG_MAC80211=m
> CONFIG_MAC80211_HAS_RC=y
> # CONFIG_MAC80211_RC_PID is not set
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_OSD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> # CONFIG_BLK_DEV_RAM is not set
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_SENSORS_BH1780 is not set
> # CONFIG_SENSORS_BH1770 is not set
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> # CONFIG_VMWARE_BALLOON is not set
> # CONFIG_BMP085 is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=m
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_CB710_CORE is not set
> # CONFIG_IWMC3200TOP is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=m
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=m
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> # CONFIG_SCSI_DH is not set
> CONFIG_SCSI_OSD_INITIATOR=m
> CONFIG_SCSI_OSD_ULD=m
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=m
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_PCMCIA is not set
> # CONFIG_PATA_PLATFORM is not set
> # CONFIG_PATA_RZ1000 is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> # CONFIG_BLK_DEV_DM is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_OHCI_DEBUG=y
> CONFIG_FIREWIRE_SBP2=m
> CONFIG_FIREWIRE_NET=m
> CONFIG_FIREWIRE_NOSY=m
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> CONFIG_BONDING=m
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> # CONFIG_MII is not set
> CONFIG_IFB=m
> # CONFIG_MACVLAN is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> CONFIG_TUN=m
> CONFIG_VETH=m
> # CONFIG_ARCNET is not set
> 
> #
> # CAIF transport drivers
> #
> CONFIG_ETHERNET=y
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> # CONFIG_NET_VENDOR_AMD is not set
> # CONFIG_NET_VENDOR_ATHEROS is not set
> # CONFIG_NET_VENDOR_BROADCOM is not set
> # CONFIG_NET_VENDOR_BROCADE is not set
> # CONFIG_NET_VENDOR_CHELSIO is not set
> # CONFIG_NET_VENDOR_CISCO is not set
> # CONFIG_DNET is not set
> # CONFIG_NET_VENDOR_DEC is not set
> # CONFIG_NET_VENDOR_DLINK is not set
> # CONFIG_NET_VENDOR_EMULEX is not set
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_FUJITSU is not set
> # CONFIG_NET_VENDOR_HP is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_SKGE is not set
> CONFIG_SKY2=m
> # CONFIG_SKY2_DEBUG is not set
> # CONFIG_NET_VENDOR_MELLANOX is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> # CONFIG_NET_VENDOR_MYRI is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> # CONFIG_NET_VENDOR_OKI is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> # CONFIG_NET_VENDOR_QLOGIC is not set
> # CONFIG_NET_VENDOR_REALTEK is not set
> # CONFIG_NET_VENDOR_RDC is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SILAN is not set
> # CONFIG_NET_VENDOR_SIS is not set
> # CONFIG_SFC is not set
> # CONFIG_NET_VENDOR_SMSC is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_XIRCOM is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=m
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> CONFIG_BROADCOM_PHY=m
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_PPP=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_FILTER=y
> # CONFIG_PPP_MPPE is not set
> # CONFIG_PPP_MULTILINK is not set
> # CONFIG_PPPOE is not set
> # CONFIG_PPTP is not set
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=m
> # CONFIG_TR is not set
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_HSO is not set
> # CONFIG_USB_IPHETH is not set
> CONFIG_WLAN=y
> # CONFIG_PCMCIA_RAYCS is not set
> # CONFIG_LIBERTAS_THINFIRM is not set
> # CONFIG_AIRO is not set
> # CONFIG_ATMEL is not set
> # CONFIG_AT76C50X_USB is not set
> # CONFIG_AIRO_CS is not set
> # CONFIG_PCMCIA_WL3501 is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_MWL8K is not set
> # CONFIG_ATH_COMMON is not set
> CONFIG_B43=m
> CONFIG_B43_SSB=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> # CONFIG_B43_PCMCIA is not set
> CONFIG_B43_SDIO=y
> CONFIG_B43_PIO=y
> CONFIG_B43_PHY_N=y
> CONFIG_B43_PHY_LP=y
> CONFIG_B43_PHY_HT=y
> CONFIG_B43_LEDS=y
> CONFIG_B43_HWRNG=y
> # CONFIG_B43_DEBUG is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_BRCMSMAC is not set
> # CONFIG_BRCMFMAC is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> # CONFIG_IWLWIFI is not set
> # CONFIG_IWL4965 is not set
> # CONFIG_IWL3945 is not set
> # CONFIG_IWM is not set
> # CONFIG_LIBERTAS is not set
> # CONFIG_HERMES is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_RT2X00 is not set
> # CONFIG_RTL8192CE is not set
> # CONFIG_RTL8192SE is not set
> # CONFIG_RTL8192DE is not set
> # CONFIG_RTL8192CU is not set
> # CONFIG_WL1251 is not set
> # CONFIG_WL12XX_MENU is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_MWIFIEX is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
> CONFIG_INPUT_SPARSEKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=m
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> # CONFIG_INPUT_KEYBOARD is not set
> CONFIG_INPUT_MOUSE=y
> # CONFIG_MOUSE_PS2 is not set
> # CONFIG_MOUSE_SERIAL is not set
> CONFIG_MOUSE_APPLETOUCH=m
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_UINPUT=m
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=m
> # CONFIG_SERIO_I8042 is not set
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> # CONFIG_SERIO_LIBPS2 is not set
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=m
> CONFIG_CYCLADES=m
> # CONFIG_CYZ_INTR is not set
> CONFIG_MOXA_INTELLIO=m
> CONFIG_MOXA_SMARTIO=m
> CONFIG_SYNCLINK=m
> CONFIG_SYNCLINKMP=m
> CONFIG_SYNCLINK_GT=m
> # CONFIG_NOZOMI is not set
> # CONFIG_ISI is not set
> CONFIG_N_HDLC=m
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> # CONFIG_STALDRV is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MFD_HSU=m
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=m
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=m
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=m
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_NVRAM=m
> CONFIG_R3964=m
> CONFIG_APPLICOM=m
> 
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> # CONFIG_IPWIRELESS is not set
> # CONFIG_MWAVE is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=m
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=m
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_INTEL_MID=m
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> # CONFIG_I2C_EG20T is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> 
> #
> # Enable Device Drivers -> PPS to see the PTP clock options.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=m
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_BQ20Z75 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> CONFIG_SENSORS_ADT7475=m
> CONFIG_SENSORS_ASC7621=m
> # CONFIG_SENSORS_K8TEMP is not set
> CONFIG_SENSORS_K10TEMP=m
> CONFIG_SENSORS_FAM15H_POWER=m
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=m
> CONFIG_SENSORS_DS1621=m
> # CONFIG_SENSORS_I5K_AMB is not set
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_FSCHMD=m
> CONFIG_SENSORS_G760A=m
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_IBMAEM=m
> CONFIG_SENSORS_IBMPEX=m
> CONFIG_SENSORS_IT87=m
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LTC4151=m
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> CONFIG_SENSORS_LM95241=m
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_PCF8591=m
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SIS5595=m
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=m
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_EMC6W201=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> # CONFIG_SENSORS_SMSC47B397 is not set
> CONFIG_SENSORS_SCH56XX_COMMON=m
> CONFIG_SENSORS_SCH5627=m
> # CONFIG_SENSORS_SCH5636 is not set
> CONFIG_SENSORS_ADS1015=m
> CONFIG_SENSORS_ADS7828=m
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_THMC50=m
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> CONFIG_SENSORS_VIA_CPUTEMP=m
> CONFIG_SENSORS_VIA686A=m
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> CONFIG_SENSORS_W83792D=m
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> CONFIG_SENSORS_APPLESMC=m
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=m
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_BLOCKIO=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> # CONFIG_SSB_PCMCIAHOST is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_SILENT is not set
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=m
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_CS5535 is not set
> CONFIG_LPC_SCH=m
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_REGULATOR is not set
> CONFIG_MEDIA_SUPPORT=m
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CONTROLLER is not set
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L2_COMMON=m
> # CONFIG_DVB_CORE is not set
> CONFIG_VIDEO_MEDIA=m
> 
> #
> # Multimedia drivers
> #
> # CONFIG_RC_CORE is not set
> CONFIG_MEDIA_ATTACH=y
> CONFIG_MEDIA_TUNER=m
> # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MC44S803=m
> CONFIG_VIDEO_V4L2=m
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
> 
> #
> # Audio decoders, processors and mixers
> #
> 
> #
> # RDS decoders
> #
> 
> #
> # Video decoders
> #
> 
> #
> # Video and audio decoders
> #
> 
> #
> # MPEG video encoders
> #
> 
> #
> # Video encoders
> #
> 
> #
> # Camera sensor devices
> #
> 
> #
> # Flash devices
> #
> 
> #
> # Video improvement chips
> #
> 
> #
> # Miscelaneous helper chips
> #
> # CONFIG_VIDEO_VIVI is not set
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_VIDEO_ZORAN is not set
> # CONFIG_VIDEO_SAA7134 is not set
> # CONFIG_VIDEO_MXB is not set
> # CONFIG_VIDEO_HEXIUM_ORION is not set
> # CONFIG_VIDEO_HEXIUM_GEMINI is not set
> # CONFIG_VIDEO_CAFE_CCIC is not set
> # CONFIG_SOC_CAMERA is not set
> CONFIG_V4L_USB_DRIVERS=y
> CONFIG_USB_VIDEO_CLASS=m
> CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> CONFIG_USB_GSPCA=m
> CONFIG_USB_M5602=m
> CONFIG_USB_STV06XX=m
> CONFIG_USB_GL860=m
> # CONFIG_USB_GSPCA_BENQ is not set
> # CONFIG_USB_GSPCA_CONEX is not set
> # CONFIG_USB_GSPCA_CPIA1 is not set
> # CONFIG_USB_GSPCA_ETOMS is not set
> # CONFIG_USB_GSPCA_FINEPIX is not set
> # CONFIG_USB_GSPCA_JEILINJ is not set
> # CONFIG_USB_GSPCA_KINECT is not set
> # CONFIG_USB_GSPCA_KONICA is not set
> # CONFIG_USB_GSPCA_MARS is not set
> # CONFIG_USB_GSPCA_MR97310A is not set
> # CONFIG_USB_GSPCA_NW80X is not set
> # CONFIG_USB_GSPCA_OV519 is not set
> # CONFIG_USB_GSPCA_OV534 is not set
> # CONFIG_USB_GSPCA_OV534_9 is not set
> # CONFIG_USB_GSPCA_PAC207 is not set
> # CONFIG_USB_GSPCA_PAC7302 is not set
> # CONFIG_USB_GSPCA_PAC7311 is not set
> # CONFIG_USB_GSPCA_SE401 is not set
> # CONFIG_USB_GSPCA_SN9C2028 is not set
> # CONFIG_USB_GSPCA_SN9C20X is not set
> # CONFIG_USB_GSPCA_SONIXB is not set
> CONFIG_USB_GSPCA_SONIXJ=m
> # CONFIG_USB_GSPCA_SPCA500 is not set
> # CONFIG_USB_GSPCA_SPCA501 is not set
> # CONFIG_USB_GSPCA_SPCA505 is not set
> # CONFIG_USB_GSPCA_SPCA506 is not set
> # CONFIG_USB_GSPCA_SPCA508 is not set
> # CONFIG_USB_GSPCA_SPCA561 is not set
> # CONFIG_USB_GSPCA_SPCA1528 is not set
> # CONFIG_USB_GSPCA_SQ905 is not set
> # CONFIG_USB_GSPCA_SQ905C is not set
> # CONFIG_USB_GSPCA_SQ930X is not set
> # CONFIG_USB_GSPCA_STK014 is not set
> # CONFIG_USB_GSPCA_STV0680 is not set
> # CONFIG_USB_GSPCA_SUNPLUS is not set
> # CONFIG_USB_GSPCA_T613 is not set
> # CONFIG_USB_GSPCA_TOPRO is not set
> # CONFIG_USB_GSPCA_TV8532 is not set
> # CONFIG_USB_GSPCA_VC032X is not set
> # CONFIG_USB_GSPCA_VICAM is not set
> # CONFIG_USB_GSPCA_XIRLINK_CIT is not set
> # CONFIG_USB_GSPCA_ZC3XX is not set
> # CONFIG_VIDEO_PVRUSB2 is not set
> # CONFIG_VIDEO_HDPVR is not set
> # CONFIG_VIDEO_EM28XX is not set
> # CONFIG_VIDEO_USBVISION is not set
> # CONFIG_USB_ET61X251 is not set
> # CONFIG_USB_SN9C102 is not set
> # CONFIG_USB_PWC is not set
> # CONFIG_USB_ZR364XX is not set
> # CONFIG_USB_STKWEBCAM is not set
> # CONFIG_USB_S2255 is not set
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> # CONFIG_RADIO_ADAPTERS is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_VIA is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_STUB_POULSBO is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_WMT_GE_ROPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> # CONFIG_FB_MODE_HELPERS is not set
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_EFI is not set
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_PROGEAR is not set
> CONFIG_BACKLIGHT_APPLE=m
> # CONFIG_BACKLIGHT_SAHARA is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> 
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=m
> 
> #
> # Display hardware drivers
> #
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=m
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> # CONFIG_SND_SEQUENCER_OSS is not set
> CONFIG_SND_HRTIMER=m
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> # CONFIG_SND_SUPPORT_OLD_API is not set
> # CONFIG_SND_VERBOSE_PROCFS is not set
> # CONFIG_SND_VERBOSE_PRINTK is not set
> CONFIG_SND_DEBUG=y
> # CONFIG_SND_DEBUG_VERBOSE is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_DRIVERS=y
> # CONFIG_SND_PCSP is not set
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_ALOOP is not set
> # CONFIG_SND_VIRMIDI is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> CONFIG_SND_HDA_PREALLOC_SIZE=2048
> CONFIG_SND_HDA_HWDEP=y
> # CONFIG_SND_HDA_RECONFIG is not set
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
> CONFIG_SND_HDA_INPUT_JACK=y
> # CONFIG_SND_HDA_PATCH_LOADER is not set
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
> # CONFIG_SND_HDA_CODEC_ANALOG is not set
> # CONFIG_SND_HDA_CODEC_SIGMATEL is not set
> # CONFIG_SND_HDA_CODEC_VIA is not set
> # CONFIG_SND_HDA_CODEC_HDMI is not set
> # CONFIG_SND_HDA_CODEC_CIRRUS is not set
> # CONFIG_SND_HDA_CODEC_CONEXANT is not set
> # CONFIG_SND_HDA_CODEC_CA0110 is not set
> # CONFIG_SND_HDA_CODEC_CA0132 is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> # CONFIG_SND_HDA_CODEC_SI3054 is not set
> CONFIG_SND_HDA_GENERIC=y
> CONFIG_SND_HDA_POWER_SAVE=y
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_USB is not set
> CONFIG_SND_FIREWIRE=y
> CONFIG_SND_FIREWIRE_LIB=m
> # CONFIG_SND_FIREWIRE_SPEAKERS is not set
> CONFIG_SND_ISIGHT=m
> # CONFIG_SND_PCMCIA is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=m
> CONFIG_HIDRAW=y
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # USB HID Boot Protocol drivers
> #
> # CONFIG_USB_KBD is not set
> # CONFIG_USB_MOUSE is not set
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=m
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> # CONFIG_HID_CHICONY is not set
> # CONFIG_HID_PRODIKEYS is not set
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LOGITECH is not set
> CONFIG_HID_MAGICMOUSE=m
> CONFIG_HID_MICROSOFT=m
> # CONFIG_HID_MONTEREY is not set
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_QUANTA is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=m
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB=m
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> # CONFIG_USB_DWC3 is not set
> # CONFIG_USB_MON is not set
> # CONFIG_USB_WUSB is not set
> CONFIG_USB_WUSB_CBAF=m
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_XHCI_HCD is not set
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_U132_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> CONFIG_USB_WDM=m
> CONFIG_USB_TMC=m
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_REALTEK=m
> CONFIG_REALTEK_AUTOPM=y
> CONFIG_USB_STORAGE_DATAFAB=m
> CONFIG_USB_STORAGE_FREECOM=m
> CONFIG_USB_STORAGE_ISD200=m
> CONFIG_USB_STORAGE_USBAT=m
> CONFIG_USB_STORAGE_SDDR09=m
> CONFIG_USB_STORAGE_SDDR55=m
> CONFIG_USB_STORAGE_JUMPSHOT=m
> CONFIG_USB_STORAGE_ALAUDA=m
> CONFIG_USB_STORAGE_ONETOUCH=m
> CONFIG_USB_STORAGE_KARMA=m
> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
> CONFIG_USB_STORAGE_ENE_UB6250=m
> CONFIG_USB_UAS=m
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=m
> CONFIG_USB_MICROTEK=m
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=m
> CONFIG_USB_EMI26=m
> CONFIG_USB_ADUTUX=m
> CONFIG_USB_SEVSEG=m
> CONFIG_USB_RIO500=m
> CONFIG_USB_LEGOTOWER=m
> CONFIG_USB_LCD=m
> CONFIG_USB_LED=m
> CONFIG_USB_CYPRESS_CY7C63=m
> CONFIG_USB_CYTHERM=m
> # CONFIG_USB_IDMOUSE is not set
> CONFIG_USB_FTDI_ELAN=m
> CONFIG_USB_APPLEDISPLAY=m
> CONFIG_USB_SISUSBVGA=m
> CONFIG_USB_SISUSBVGA_CON=y
> CONFIG_USB_LD=m
> CONFIG_USB_TRANCEVIBRATOR=m
> CONFIG_USB_IOWARRIOR=m
> # CONFIG_USB_TEST is not set
> CONFIG_USB_ISIGHTFW=m
> CONFIG_USB_YUREX=m
> # CONFIG_USB_GADGET is not set
> 
> #
> # OTG and related infrastructure
> #
> CONFIG_USB_OTG_UTILS=y
> CONFIG_NOP_USB_XCEIV=m
> # CONFIG_UWB is not set
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> # CONFIG_MMC_UNSAFE_RESUME is not set
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_SDIO_UART=m
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_SDHCI_PCI=m
> CONFIG_MMC_RICOH_MMC=y
> CONFIG_MMC_SDHCI_PLTFM=m
> CONFIG_MMC_WBSD=m
> # CONFIG_MMC_TIFM_SD is not set
> # CONFIG_MMC_SDRICOH_CS is not set
> # CONFIG_MMC_CB710 is not set
> CONFIG_MMC_VIA_SDMMC=m
> CONFIG_MMC_VUB300=m
> CONFIG_MMC_USHC=m
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_LP3944 is not set
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_TRIGGERS=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> 
> #
> # Reporting subsystems
> #
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=m
> CONFIG_EDAC_E752X=m
> CONFIG_EDAC_I82975X=m
> CONFIG_EDAC_I3000=m
> CONFIG_EDAC_I3200=m
> CONFIG_EDAC_X38=m
> CONFIG_EDAC_I5400=m
> CONFIG_EDAC_I7CORE=m
> CONFIG_EDAC_I5000=m
> CONFIG_EDAC_I5100=m
> CONFIG_EDAC_I7300=m
> # CONFIG_EDAC_SBRIDGE is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> CONFIG_RTC_DEBUG=y
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> # CONFIG_VIRTIO_MMIO is not set
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_IOMMU_SUPPORT is not set
> # CONFIG_VIRT_DRIVERS is not set
> # CONFIG_HYPERV is not set
> # CONFIG_PM_DEVFREQ is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_EFI_VARS=m
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_SIGMA is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=m
> CONFIG_EXT4_FS_XATTR=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=m
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=m
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> CONFIG_REISERFS_FS=m
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=m
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=m
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> CONFIG_CUSE=m
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=m
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> CONFIG_HFSPLUS_FS=m
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_SQUASHFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_PSTORE=y
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> # CONFIG_EXOFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> # CONFIG_NFS_V4_1 is not set
> CONFIG_NFS_FSCACHE=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> # CONFIG_NFSD is not set
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_RPCSEC_GSS_KRB5=m
> # CONFIG_CEPH_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> # CONFIG_PRINTK_TIME is not set
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=2000
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_REDUCED is not set
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_TEST_LIST_SORT is not set
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_DEBUG_PER_CPU_MAPS=y
> # CONFIG_LKDTM is not set
> # CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> # CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_KPROBE_EVENT is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_STACKOVERFLOW=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DEBUG_SET_MODULE_RONX=y
> # CONFIG_DEBUG_NX_TEST is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> # CONFIG_X86_DECODER_SELFTEST is not set
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=m
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_NULL=m
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_AUTHENC=m
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_CTR=m
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=m
> # CONFIG_CRYPTO_LRW is not set
> CONFIG_CRYPTO_PCBC=m
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=m
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_GHASH=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA1_SSSE3=m
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_WP512=m
> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_X86_64=m
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_BLOWFISH_COMMON=m
> CONFIG_CRYPTO_BLOWFISH_X86_64=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> # CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=m
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_USER_API=m
> CONFIG_CRYPTO_USER_API_HASH=m
> CONFIG_CRYPTO_USER_API_SKCIPHER=m
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=m
> CONFIG_KVM_INTEL=m
> # CONFIG_KVM_AMD is not set
> # CONFIG_KVM_MMU_AUDIT is not set
> # CONFIG_VHOST_NET is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=m
> CONFIG_CRC_T10DIF=m
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> CONFIG_CRC7=m
> # CONFIG_LIBCRC32C is not set
> # CONFIG_CRC8 is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> # CONFIG_CPUMASK_OFFSTACK is not set
> CONFIG_CPU_RMAP=y
> CONFIG_NLATTR=y
> CONFIG_AVERAGE=y
> # CONFIG_CORDIC is not set
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
