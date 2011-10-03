From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Oops in block/ext4 layer on USB3 hard drive connect
Date: Mon, 3 Oct 2011 11:52:35 -0700
Message-ID: <20111003185235.GA12865@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Cc: linux-ext4@vger.kernel.org,
	USB Storage List <usb-storage@lists.one-eyed-alien.net>
To: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1JCSwh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 14:52:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jens, Ted, and Andreas,

A co-worker of mine found a 100% reproducible oops that happens when a
IOMEGA USB 3.0 hard drive is plugged into a particular machine.  It
looks like an oops in the block or EXT4 layer, and it doesn't seem to be
in the xHCI (USB 3.0 host controller) driver.  (Although looking at the
log again, it seems show a cut-off oops at the beginning of the log...)

This appears on the 3.0.4 stable kernel.  dmesg is attached.  Let me
know if you need any other info to help solve this issue.

Sarah Sharp

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3881540.txt"

8.185704]  [<c040969f>] sysenter_do_call+0x12/0x28
[   38.191738] BUG: unable to handle kernel paging request at 01012e00
[   38.195613] IP: [<c05d10e5>] cfq_exit_single_io_context+0x1a/0x4d
[   38.195621] *pdpt = 0000000000000000 *pde = f000f84d9c4002a0
[   38.195626] Oops: 0000 [#2] SMP
[   38.195628] last sysfs file: /sys/devices/pci0000:00/0000:00:14.0/usb3/3-8/serial
[   38.195631] Modules linked in: usb_storage uas fuse sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_realtek ppdev snd_hda_intel microcode snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm parport_pc snd_timer parport snd xhci_hcd e1000e soundcore snd_page_alloc ipv6 firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[   38.195658]
[   38.195662] Pid: 1598, comm: cdrom_id Tainted: G      D W   2.6.38.6-26.rc1.fc15.i686.PAE #1 Intel Corporation 2012 Client Platform/LosLunas EV
[   38.195669] EIP: 0060:[<c05d10e5>] EFLAGS: 00010206 CPU: 1
[   38.195672] EIP is at cfq_exit_single_io_context+0x1a/0x4d
[   38.195675] EAX: ed9c7780 EBX: eda41c68 ECX: efcf14c4 EDX: eda41c40
[   38.195678] ESI: 01012e00 EDI: c05d10cb EBP: ec85391c ESP: ec85390c
[   38.195681]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   38.195685] Process cdrom_id (pid: 1598, ti=ec852000 task=f0367110 task.ti=ec852000)
[   38.195699] Stack:
[   38.195699]  ed9c7780 eda41c68 ed9c7780 c05d10cb ec853930 c05cde09 ed9c7780 f0367110
[   38.195704]  00000000 ec853938 c05cde38 ec853948 c05c523f f0367110 00000012 ec85399c
[   38.195708]  c0445466 c0469b90 00000096 00000096 ec853964 00000090 ec853994 f0367324
[   38.195713] Call Trace:
[   38.195716]  [<c05d10cb>] ? cfq_exit_single_io_context+0x0/0x4d
[   38.195720]  [<c05cde09>] __call_for_each_cic+0x23/0x2c
[   38.195723]  [<c05cde38>] cfq_exit_io_context+0x12/0x14
[   38.195726]  [<c05c523f>] exit_io_context+0x44/0x4f
[   38.195730]  [<c0445466>] do_exit+0x600/0x61c
[   38.195734]  [<c0469b90>] ? arch_local_irq_save+0x12/0x17
[   38.195738]  [<c07ea4b3>] oops_end+0xa2/0xa8
[   38.195741]  [<c040c2db>] die+0x56/0x5f
[   38.195744]  [<c07e9d40>] do_trap+0x8e/0xa7
[   38.195747]  [<c040a11c>] ? do_invalid_op+0x0/0x96
[   38.195750]  [<c040a1a8>] do_invalid_op+0x8c/0x96
[   38.195752]  [<c05ce90e>] ? cfq_cic_lookup+0x77/0xf0
[   38.195756]  [<c040c25b>] ? show_trace+0x1f/0x24
[   38.195759]  [<c07e15f2>] ? printk+0x2d/0x2f
[   38.195761]  [<c0441fdf>] ? print_oops_end_marker+0x2f/0x31
[   38.195764]  [<c07e9ae7>] error_code+0x67/0x6c
[   38.195767]  [<c05ce90e>] ? cfq_cic_lookup+0x77/0xf0
[   38.195769]  [<c05ceae1>] cfq_may_queue+0x24/0x96
[   38.195772]  [<c05be04b>] elv_may_queue+0x1d/0x20
[   38.195774]  [<c05c23c6>] get_request+0x27/0x21c
[   38.195777]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.195780]  [<c0696459>] ? scsi_request_fn+0x312/0x3b0
[   38.195783]  [<c05c2df5>] get_request_wait+0x2b/0x132
[   38.195786]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.195789]  [<c05c2f36>] blk_get_request+0x3a/0x63
[   38.195791]  [<c0695328>] scsi_execute+0x26/0x110
[   38.195794]  [<c06a2718>] ? sr_do_ioctl+0x40/0x206
[   38.195796]  [<c06a27a2>] sr_do_ioctl+0xca/0x206
[   38.195799]  [<c06a292e>] ? sr_read_tochdr+0x50/0xd9
[   38.195802]  [<c06a2985>] sr_read_tochdr+0xa7/0xd9
[   38.195805]  [<c06a2d5a>] sr_disk_status+0x20/0x8f
[   38.195808]  [<c06a36bf>] sr_cd_check+0x357/0x3b8
[   38.195811]  [<c06a1ac4>] sr_block_revalidate_disk+0x4b/0x1bb
[   38.195814]  [<c05104ed>] ? __invalidate_device+0x3e/0x46
[   38.195816]  [<c0510561>] ? flush_disk+0x21/0x91
[   38.195819]  [<c07e8fe6>] ? _raw_spin_lock_irq+0x19/0x1b
[   38.195822]  [<c05c9399>] ? disk_clear_events+0xd4/0xe3
[   38.195824]  [<c0510613>] check_disk_change+0x42/0x49
[   38.195828]  [<c06c3913>] cdrom_open+0x392/0x441
[   38.195831]  [<c059cded>] ? inode_has_perm+0x6e/0x87
[   38.195834]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.195836]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.195839]  [<c05d41d8>] ? kobject_get+0x12/0x17
[   38.195842]  [<c05c8041>] ? get_disk+0x5b/0x6f
[   38.195844]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.195847]  [<c05d41d8>] ? kobject_get+0x12/0x17
[   38.195849]  [<c067f50e>] ? get_device+0x16/0x1d
[   38.195852]  [<c06a1ddf>] sr_block_open+0x76/0x95
[   38.195855]  [<c05113ec>] __blkdev_get+0xa4/0x2ca
[   38.195858]  [<c0511792>] blkdev_get+0x180/0x23c
[   38.195860]  [<c05102ff>] ? bdev_set+0x0/0x11
[   38.195863]  [<c05118b2>] blkdev_open+0x64/0x68
[   38.195866]  [<c04ec3f8>] __dentry_open+0x139/0x21b
[   38.195869]  [<c04ed2a7>] nameidata_to_filp+0x52/0x5e
[   38.195871]  [<c051184e>] ? blkdev_open+0x0/0x68
[   38.195875]  [<c04f7899>] finish_open+0x7f/0x13c
[   38.195878]  [<c04f6c1e>] ? do_path_lookup+0xb1/0xd3
[   38.195881]  [<c04f7d2d>] do_filp_open+0x173/0x4cb
[   38.195884]  [<c042e1d3>] ? kmap_atomic_prot+0x108/0x131
[   38.195887]  [<c07e7d71>] ? _cond_resched+0xd/0x21
[   38.195890]  [<c04ed309>] do_sys_open+0x56/0xdc
[   38.195893]  [<c04f538e>] ? path_put+0x1a/0x1d
[   38.195896]  [<c04ed3b5>] sys_open+0x26/0x2c
[   38.195899]  [<c040969f>] sysenter_do_call+0x12/0x28
[   38.195900] Code: 2b ff ff ff c7 43 08 00 00 00 00 5f 5b 5e 5f 5d c3 55 89 e5 57 56 53 56 3e 8d 74 26 00 8b 32 f7 c6 01 00 00 00 75 31 85 f6 74 2d <8b> 1e 8b 83 08 02 00 00 89 55 f0 e8 b1 7e 21 00 8b 55 f0 89 c7
[   38.195920] EIP: [<c05d10e5>] cfq_exit_single_io_context+0x1a/0x4d SS:ESP 0068:ec85390c
[   38.195924] CR2: 0000000001012e00
[   38.195937] ---[ end trace 90cee66b031dfa4b ]---
[   38.195940] Fixing recursive fault but reboot is needed!
[   38.689887] xhci_hcd 0000:00:14.0: WARN: babble error on endpoint
[   38.689902] xhci_hcd 0000:00:14.0: WARN Set TR Deq Ptr cmd invalid because of stream ID configuration
[   38.689976] sd 6:0:0:0: [sdb] Sector size 0 reported, assuming 512.
[   38.689980] sd 6:0:0:0: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[   38.689982] sd 6:0:0:0: [sdb] 0-byte physical blocks
[   38.790089] BUG: unable to handle kernel paging request at 03000000
[   38.797066] IP: [<c04e180d>] __kmalloc+0xa5/0xed
[   38.802200] *pdpt = 0000000030322001 *pde = 0000000000000000
[   38.808467] Oops: 0000 [#3] SMP
[   38.812232] last sysfs file: /sys/devices/pci0000:00/0000:00:14.0/usb3/3-8/3-8:1.0/host6/target6:0:0/6:0:0:1/evt_media_change
[   38.824003] Modules linked in: usb_storage uas fuse sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_realtek ppdev snd_hda_intel microcode snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm parport_pc snd_timer parport snd xhci_hcd e1000e soundcore snd_page_alloc ipv6 firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[   38.869156]
[   38.871146] Pid: 1493, comm: abrt-applet Tainted: G      D W   2.6.38.6-26.rc1.fc15.i686.PAE #1 Intel Corporation 2012 Client Platform/LosLunas EV
[   38.884883] EIP: 0060:[<c04e180d>] EFLAGS: 00010006 CPU: 0
[   38.890866] EIP is at __kmalloc+0xa5/0xed
[   38.895468] EAX: f3807994 EBX: f1802380 ECX: 00000000 EDX: 00000000
[   38.902374] ESI: 03000000 EDI: 00000246 EBP: edb3de30 ESP: edb3de10
[   38.909145]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   38.915046] Process abrt-applet (pid: 1493, ti=edb3c000 task=f6cc1920 task.ti=edb3c000)
[   38.923551] Stack:
[   38.926081]  73656168 6f727365 c054b519 00000029 000080d0 ee296338 ad19519e 641ff634
[   38.934531]  edb3de4c c054b519 efc792e0 49c83f8c ee296338 edcba4a0 f6b58e70 edb3de84
[   38.942992]  c05560e4 ee296338 ee296338 f6b58e70 00000338 ee296ff8 00000000 edbb49c0
[   38.951449] Call Trace:
[   38.954442]  [<c054b519>] ? ext4_htree_store_dirent+0x2c/0xdf
[   38.960721]  [<c054b519>] ext4_htree_store_dirent+0x2c/0xdf
[   38.966818]  [<c05560e4>] htree_dirblock_to_tree+0xe5/0x11f
[   38.972912]  [<c0557e5a>] ext4_htree_fill_tree+0x6a/0x1a5
[   38.978838]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   38.984239]  [<c054afaa>] ? ext4_readdir+0x99/0x5aa
[   38.989634]  [<c054afaa>] ? ext4_readdir+0x99/0x5aa
[   38.995031]  [<c054b09e>] ext4_readdir+0x18d/0x5aa
[   39.000503]  [<c07e8fa4>] ? _raw_spin_lock+0xd/0xf
[   39.005825]  [<c04fc952>] ? dput+0x3a/0xc1
[   39.010444]  [<c0515099>] ? __fsnotify_parent+0xa8/0xb3
[   39.016184]  [<c04f9f38>] ? filldir64+0x0/0xcc
[   39.021144]  [<c042f603>] ? should_resched+0xd/0x27
[   39.026544]  [<c04fa20f>] vfs_readdir+0x6a/0x8f
[   39.031600]  [<c04f9f38>] ? filldir64+0x0/0xcc
[   39.036572]  [<c04fa398>] sys_getdents64+0x66/0xa6
[   39.041888]  [<c040969f>] sysenter_do_call+0x12/0x28
[   39.047371] Code: e8 8b d7 ff ff 8b 03 64 03 05 bc 0c b0 c0 8b 30 85 f6 75 14 8b 4d e8 8b 55 f0 89 04 24 89 d8 e8 40 24 30 00 89 c6 eb 08 8b 53 10 <8b> 14 16 89 10 89 f8 e8 4e d7 ff ff 85 f6 74 12 f7 45 f0 00 80
[   39.068957] EIP: [<c04e180d>] __kmalloc+0xa5/0xed SS:ESP 0068:edb3de10
[   39.076081] CR2: 0000000003000000
[   39.079962] ---[ end trace 90cee66b031dfa4c ]---
[   40.710008] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1087
[   40.718262] in_atomic(): 0, irqs_disabled(): 1, pid: 735, name: abrtd
[   40.724692] Pid: 735, comm: abrtd Tainted: G      D W   2.6.38.6-26.rc1.fc15.i686.PAE #1
[   40.732765] Call Trace:
[   40.735218]  [<c07e15f2>] ? printk+0x2d/0x2f
[   40.739492]  [<c0435b8a>] __might_sleep+0xdd/0xe4
[   40.744193]  [<c07ebeda>] do_page_fault+0x179/0x30c
[   40.749064]  [<c059babe>] ? avc_has_perm_noaudit+0x8e/0x346
[   40.754629]  [<c05a53ab>] ? hashtab_search+0x4e/0x56
[   40.759588]  [<c05add5c>] ? mls_level_isvalid+0x4f/0x90
[   40.764805]  [<c05a5623>] ? context_cmp+0x83/0x92
[   40.769507]  [<c07ebd61>] ? do_page_fault+0x0/0x30c
[   40.774379]  [<c07e9ae7>] error_code+0x67/0x6c
[   40.778821]  [<c04e180d>] ? __kmalloc+0xa5/0xed
[   40.783344]  [<c05aa1d5>] ? context_struct_to_string+0xc3/0x18b
[   40.789256]  [<c05aa1d5>] context_struct_to_string+0xc3/0x18b
[   40.794995]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   40.799868]  [<c059eccd>] ? selinux_inode_init_security+0xf9/0x153
[   40.806039]  [<c05aabef>] security_sid_to_context_core+0xeb/0xfe
[   40.812037]  [<c05ab7c5>] security_sid_to_context_force+0x17/0x19
[   40.818120]  [<c059ecfa>] selinux_inode_init_security+0x126/0x153
[   40.824205]  [<c05998a7>] security_inode_init_security+0x34/0x39
[   40.830204]  [<c0577b5f>] ext4_init_security+0x2b/0x84
[   40.835337]  [<c057790b>] ? ext4_init_acl+0x104/0x111
[   40.840381]  [<c04ff205>] ? insert_inode_locked+0xb1/0xbb
[   40.845773]  [<c054d37e>] ext4_new_inode+0x9e7/0xb36
[   40.850734]  [<c057d923>] ? jbd2__journal_start+0x7c/0xb5
[   40.856128]  [<c05578b4>] ext4_symlink+0xee/0x1cf
[   40.860827]  [<c04f6da9>] vfs_symlink+0x49/0x60
[   40.865350]  [<c04f842d>] sys_symlinkat+0x71/0xb1
[   40.870050]  [<c04f137b>] ? sys_stat64+0x25/0x27
[   40.874665]  [<c04f8492>] sys_symlink+0x25/0x27
[   40.879193]  [<c040969f>] sysenter_do_call+0x12/0x28
[   40.884156] BUG: unable to handle kernel paging request at 03000000
[   40.891060] IP: [<c04e180d>] __kmalloc+0xa5/0xed
[   40.896293] *pdpt = 000000002fd7a001 *pde = 0000000000000000
[   40.902674] Oops: 0000 [#4] SMP
[   40.906545] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[   40.914957] Modules linked in: usb_storage uas fuse sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_realtek ppdev snd_hda_intel microcode snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm parport_pc snd_timer parport snd xhci_hcd e1000e soundcore snd_page_alloc ipv6 firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[   40.960573]
[   40.962696] Pid: 735, comm: abrtd Tainted: G      D W   2.6.38.6-26.rc1.fc15.i686.PAE #1 Intel Corporation 2012 Client Platform/LosLunas EV
[   40.975942] EIP: 0060:[<c04e180d>] EFLAGS: 00010006 CPU: 0
[   40.982071] EIP is at __kmalloc+0xa5/0xed
[   40.986725] EAX: f3807994 EBX: f1802380 ECX: 00000004 EDX: 00000000
[   40.993635] ESI: 03000000 EDI: 00000246 EBP: f03f1d6c ESP: f03f1d4c
[   41.000543]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   41.006586] Process abrtd (pid: 735, ti=f03f0000 task=f0f39920 task.ti=f03f0000)
[   41.014621] Stack:
[   41.017278]  efcc2418 fffffffe c05aa1d5 00000026 00000020 efcc2404 f03f1dfc f03f1e00
[   41.025839]  f03f1da0 c05aa1d5 c0435ad6 00000000 00000000 00000000 c059eccd 00000023
[   41.034404]  f6def238 00000246 000000cd f03f1e00 f03f1dfc f03f1dc8 c05aabef 00000008
[   41.042950] Call Trace:
[   41.046014]  [<c05aa1d5>] ? context_struct_to_string+0xc3/0x18b
[   41.052541]  [<c05aa1d5>] context_struct_to_string+0xc3/0x18b
[   41.058888]  [<c0435ad6>] ? __might_sleep+0x29/0xe4
[   41.064373]  [<c059eccd>] ? selinux_inode_init_security+0xf9/0x153
[   41.071146]  [<c05aabef>] security_sid_to_context_core+0xeb/0xfe
[   41.077745]  [<c05ab7c5>] security_sid_to_context_force+0x17/0x19
[   41.084424]  [<c059ecfa>] selinux_inode_init_security+0x126/0x153
[   41.091095]  [<c05998a7>] security_inode_init_security+0x34/0x39
[   41.097682]  [<c0577b5f>] ext4_init_security+0x2b/0x84
[   41.103391]  [<c057790b>] ? ext4_init_acl+0x104/0x111
[   41.109000]  [<c04ff205>] ? insert_inode_locked+0xb1/0xbb
[   41.114957]  [<c054d37e>] ext4_new_inode+0x9e7/0xb36
[   41.120487]  [<c057d923>] ? jbd2__journal_start+0x7c/0xb5
[   41.126445]  [<c05578b4>] ext4_symlink+0xee/0x1cf
[   41.131706]  [<c04f6da9>] vfs_symlink+0x49/0x60
[   41.136787]  [<c04f842d>] sys_symlinkat+0x71/0xb1
[   41.142036]  [<c04f137b>] ? sys_stat64+0x25/0x27
[   41.147192]  [<c04f8492>] sys_symlink+0x25/0x27
[   41.152263]  [<c040969f>] sysenter_do_call+0x12/0x28
[   41.157763] Code: e8 8b d7 ff ff 8b 03 64 03 05 bc 0c b0 c0 8b 30 85 f6 75 14 8b 4d e8 8b 55 f0 89 04 24 89 d8 e8 40 24 30 00 89 c6 eb 08 8b 53 10 <8b> 14 16 89 10 89 f8 e8 4e d7 ff ff 85 f6 74 12 f7 45 f0 00 80
[   41.179371] EIP: [<c04e180d>] __kmalloc+0xa5/0xed SS:ESP 0068:f03f1d4c
[   41.186508] CR2: 0000000003000000
[   41.190397] ---[ end trace 90cee66b031dfa4d ]---
[   41.216937] BUG: unable to handle kernel paging request at 03000000
[   41.223859] IP: [<c04e2348>] __kmalloc_track_caller+0xa2/0xea
[   41.230253] *pdpt = 0000000000000000 *pde = f000eef3f000eef3
[   41.236656] Oops: 0000 [#5] SMP
[   41.240547] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[   41.248993] Modules linked in: usb_storage uas fuse sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_realtek ppdev snd_hda_intel microcode snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm parport_pc snd_timer parport snd xhci_hcd e1000e soundcore snd_page_alloc ipv6 firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[   41.294715]
[   41.297178] Pid: 11, comm: kworker/0:1 Tainted: G      D W   2.6.38.6-26.rc1.fc15.i686.PAE #1 Intel Corporation 2012 Client Platform/LosLunas EV
[   41.310896] EIP: 0060:[<c04e2348>] EFLAGS: 00010006 CPU: 0
[   41.317049] EIP is at __kmalloc_track_caller+0xa2/0xea
[   41.322859] EAX: f3807994 EBX: f1802380 ECX: 00000000 EDX: 00000000
[   41.329788] ESI: 03000000 EDI: 00000246 EBP: f1a03f14 ESP: f1a03ef4
[   41.336704]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   41.342746] Process kworker/0:1 (pid: 11, ti=f1a02000 task=f1a08000 task.ti=f1a02000)
[   41.351203] Stack:
[   41.353861]  c0476a3c f1802680 c0476a7c 00000023 000000d0 00000023 f01b0110 ee42c000
[   41.362425]  f1a03f2c c04c43ae 000000d0 f6dbbdb0 00000000 ee42c000 f1a03f5c c0476a7c
[   41.370977]  987ac31a 00000009 00000000 00000009 f1a08000 026995a7 00000000 c0a32874
[   41.379534] Call Trace:
[   41.382609]  [<c0476a3c>] ? cgroup_release_agent+0x50/0x142
[   41.388810]  [<c0476a7c>] ? cgroup_release_agent+0x90/0x142
[   41.394999]  [<c04c43ae>] kstrdup+0x2e/0x3e
[   41.399989]  [<c0476a7c>] cgroup_release_agent+0x90/0x142
[   41.405992]  [<c0455790>] process_one_work+0x13d/0x22b
[   41.411732]  [<c04769ec>] ? cgroup_release_agent+0x0/0x142
[   41.417819]  [<c0455a95>] worker_thread+0xb9/0x133
[   41.423195]  [<c04559dc>] ? worker_thread+0x0/0x133
[   41.428652]  [<c0458b1c>] kthread+0x67/0x6c
[   41.433409]  [<c0458ab5>] ? kthread+0x0/0x6c
[   41.438257]  [<c0409c3e>] kernel_thread_helper+0x6/0x10
[   41.444049] Code: e8 50 cc ff ff 8b 03 64 03 05 bc 0c b0 c0 8b 30 85 f6 75 14 8b 4d e8 8b 55 f0 89 04 24 89 d8 e8 05 19 30 00 89 c6 eb 08 8b 53 10 <8b> 14 16 89 10 89 f8 e8 13 cc ff ff 85 f6 74 12 f7 45 f0 00 80
[   41.465720] EIP: [<c04e2348>] __kmalloc_track_caller+0xa2/0xea SS:ESP 0068:f1a03ef4
[   41.474024] CR2: 0000000003000000
[   41.477944] ---[ end trace 90cee66b031dfa4e ]---

--OgqxwSJOaUobr8KG--
