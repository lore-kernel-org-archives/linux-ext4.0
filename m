From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: ext4: add meta_bg and bit64 support to online resizing
Date: Fri, 23 Mar 2012 20:02:00 +0200
Message-ID: <4F6CBA98.2020204@iki.fi>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060804000404020807040607"
Cc: linux-ext4@vger.kernel.org, adilger@gmail.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw-out2.cc.tut.fi ([130.230.160.33]:45781 "EHLO
	mail-gw-out2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2CWSRF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Mar 2012 14:17:05 -0400
In-Reply-To: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060804000404020807040607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

29.01.2012 18:01, Yongqiang Yang kirjoitti:
> Hi List,

Hi!

I wonder how I missed this, as this is a feature I've been waiting for
for some time...

>    This patch series adds meta_bg and bit64 support to online resizing,
> the patches were tested with meta_bg, bit64 feature is not tested.
> 
>    Could anyone can test the patch with device whose size beyonds 16TB?

You could test this with e.g. a sparse lvm lv, i.e. --virtualsize option
of lvcreate, no?

After running the attached quickly hacked up test script on a patched
3.3, I get the below kernel issue (captured via netconsole). Is the
patchset simply incompatible with 3.3 or is this an actual bug?

> [  392.296318] general protection fault: 0000 [#1] SMP 
> [  392.296338] CPU 2 
> [  392.296341] Modules linked in: nouveau ttm drm_kms_helper drm video netconsole binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sg parport_pc ppdev parport ppp_async ppp_generic slhc crc_ccitt ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables x_tables capi kernelcapi dm_snapshot dm_zero tda18271c2dd af_packet snd_hda_codec_hdmi joydev coretemp cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr nvram ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder serio_raw ir_sony_decoder configfs ir_jvc_decoder rc_imon_pad ir_rc6_decoder ir_rc5_decoder ir_nec_decoder imon i2c_i801 rc_core iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_realtek drxk e1000
 e ddbridge dvb_core cxd2099(C) i2c_core i7core_edac edac_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer asus_atk0110 snd soundcore snd_page_alloc evdev xhci_hcd processor cn ip
 v6 autofs
4 ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usb_storage sd_mod usbhid hid uas crc_t10dif sr_mod mpt2sas raid_class mptsas mptscsih mptbase scsi_transport_sas mxm_wmi ahci libahci firewire_ohci libata ehci_hcd firewire_core uhci_hcd crc_itu_t usbcore scsi_mod usb_common wmi button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: netconsole]
> [  392.296761] 
> [  392.296771] Pid: 7022, comm: flush-252:6 Tainted: G         C   3.3.0-server-1anssi2 #1 System manufacturer System Product Name/P6X58-E-WS
> [  392.296813] RIP: 0010:[<ffffffff8115035a>]  [<ffffffff8115035a>] kmem_cache_alloc+0x4a/0x120
> [  392.296840] RSP: 0018:ffff880382b21420  EFLAGS: 00010202
> [  392.296857] RAX: 0000000000000000 RBX: ffff880409fd7840 RCX: 000000000000252f
> [  392.296877] RDX: 000000000000252e RSI: 0000000000011200 RDI: 0000000000016610
> [  392.296898] RBP: ffff880382b21470 R08: ffff88043fc56610 R09: ffffffff81108155
> [  392.296916] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88042f007200
> [  392.296935] R13: 0001880360cbe840 R14: ffff880382b214c0 R15: ffff8804107fad80
> [  392.296958] FS:  0000000000000000(0000) GS:ffff88043fc40000(0000) knlGS:0000000000000000
> [  392.296979] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  392.296997] CR2: 00007f1dac6ff000 CR3: 0000000001a05000 CR4: 00000000000006e0
> [  392.297016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  392.297036] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  392.297057] Process flush-252:6 (pid: 7022, threadinfo ffff880382b20000, task ffff8804107fad80)
> [  392.297082] Stack:
> [  392.297093]  ffff880427139700 ffff8803ecd8cd80 ffff8803ecd8cd80 0001120000000000
> [  392.297129]  ffff88042762a4e0 ffff880409fd7840 0000000000011210 ffff880409fd7870
> [  392.297164]  ffff880382b214c0 ffff8804107fad80 ffff880382b21480 ffffffff81108155
> [  392.297199] Call Trace:
> [  392.297208]  [<ffffffff81108155>] mempool_alloc_slab+0x15/0x20
> [  392.297223]  [<ffffffff81108488>] mempool_alloc+0x58/0x150
> [  392.297238]  [<ffffffff81108488>] ? mempool_alloc+0x58/0x150
> [  392.297256]  [<ffffffffa000144c>] alloc_tio.isra.14+0x2c/0x50 [dm_mod]
> [  392.297271]  [<ffffffffa0001e67>] __split_and_process_bio+0x4d7/0x5f0 [dm_mod]
> [  392.297290]  [<ffffffffa0002075>] dm_request+0xf5/0x1a0 [dm_mod]
> [  392.297303]  [<ffffffff8121a647>] generic_make_request+0xc7/0x100
> [  392.297316]  [<ffffffff8121a707>] submit_bio+0x87/0x110
> [  392.297332]  [<ffffffff811983c1>] ? __bio_add_page.part.14+0x101/0x240
> [  392.297350]  [<ffffffff8110f083>] ? account_page_writeback+0x13/0x20
> [  392.297372]  [<ffffffffa0310d19>] ext4_io_submit+0x29/0x60 [ext4]
> [  392.297387]  [<ffffffffa0310f15>] ext4_bio_write_page+0x1c5/0x4d0 [ext4]
> [  392.297401]  [<ffffffffa030cb51>] mpage_da_submit_io+0x511/0x590 [ext4]
> [  392.297420]  [<ffffffffa030edfe>] mpage_da_map_and_submit+0x19e/0x440 [ext4]
> [  392.297436]  [<ffffffffa030f100>] mpage_add_bh_to_extent+0x60/0xe0 [ext4]
> [  392.298587]  [<ffffffffa030f488>] write_cache_pages_da+0x308/0x450 [ext4]
> [  392.299917]  [<ffffffffa030f8f7>] ext4_da_writepages+0x327/0x610 [ext4]
> [  392.301183]  [<ffffffff8134b66b>] ? plugger_unplug+0x3b/0x50
> [  392.302485]  [<ffffffff811113c1>] do_writepages+0x21/0x40
> [  392.303908]  [<ffffffff8118c559>] writeback_single_inode+0x159/0x410
> [  392.305262]  [<ffffffff8118cbe0>] writeback_sb_inodes+0x1a0/0x240
> [  392.306523]  [<ffffffff8118cd1e>] __writeback_inodes_wb+0x9e/0xd0
> [  392.309885]  [<ffffffff8118cfbb>] wb_writeback+0x26b/0x320
> [  392.311173]  [<ffffffff8118e0b0>] wb_do_writeback+0x190/0x1d0
> [  392.312337]  [<ffffffff8118e17b>] bdi_writeback_thread+0x8b/0x290
> [  392.313484]  [<ffffffff8118e0f0>] ? wb_do_writeback+0x1d0/0x1d0
> [  392.314829]  [<ffffffff810701a3>] kthread+0x93/0xa0
> [  392.316081]  [<ffffffff814607a4>] kernel_thread_helper+0x4/0x10
> [  392.317346]  [<ffffffff81070110>] ? kthread_freezable_should_stop+0x70/0x70
> [  392.318568]  [<ffffffff814607a0>] ? gs_change+0x13/0x13
> [  392.319961] Code: cc 4d 8b 04 24 65 4c 03 04 25 00 dc 00 00 49 8b 50 08 4d 8b 28 4d 85 ed 0f 84 c4 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2 4d 
> [  392.321564] RIP  [<ffffffff8115035a>] kmem_cache_alloc+0x4a/0x120
> [  392.323009]  RSP <ffff880382b21420>
> [  392.326808] ---[ end trace 566c867baea1e58d ]---
> [  392.327843] ------------[ cut here ]------------
> [  392.329315] WARNING: at kernel/exit.c:897 do_exit+0x55/0x8a0()
> [  392.330810] Hardware name: System Product Name
> [  392.332280] Modules linked in: nouveau ttm drm_kms_helper drm video netconsole binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sg parport_pc ppdev parport ppp_async ppp_generic slhc crc_ccitt ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables x_tables capi kernelcapi dm_snapshot dm_zero tda18271c2dd af_packet snd_hda_codec_hdmi joydev coretemp cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr nvram ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder serio_raw ir_sony_decoder configfs ir_jvc_decoder rc_imon_pad ir_rc6_decoder ir_rc5_decoder ir_nec_decoder imon i2c_i801 rc_core iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_realtek drxk e1000
 e ddbridge dvb_core cxd2099(C) i2c_core i7core_edac edac_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer asus_atk0110 snd soundcore snd_page_alloc evdev xhci_hcd processor cn ip
 v6 autofs
4 ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usb_storage sd_mod usbhid hid uas crc_t10dif sr_mod mpt2sas raid_class mptsas mptscsih mptbase scsi_transport_sas mxm_wmi ahci libahci firewire_ohci libata ehci_hcd firewire_core uhci_hcd crc_itu_t usbcore scsi_mod usb_common wmi button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: netconsole]
> [  392.341944] Pid: 7022, comm: flush-252:6 Tainted: G      D  C   3.3.0-server-1anssi2 #1
> [  392.345445] Call Trace:
> [  392.346862]  [<ffffffff8104de6f>] warn_slowpath_common+0x7f/0xc0
> [  392.348316]  [<ffffffff8104deca>] warn_slowpath_null+0x1a/0x20
> [  392.349784]  [<ffffffff81051c15>] do_exit+0x55/0x8a0
> [  392.351124]  [<ffffffff8104fb2c>] ? kmsg_dump+0x5c/0xf0
> [  392.352499]  [<ffffffff814585bb>] oops_end+0xab/0xf0
> [  392.353942]  [<ffffffff810177c8>] die+0x58/0x90
> [  392.355228]  [<ffffffff814580f2>] do_general_protection+0x162/0x170
> [  392.356545]  [<ffffffff81457a05>] general_protection+0x25/0x30
> [  392.357794]  [<ffffffff81108155>] ? mempool_alloc_slab+0x15/0x20
> [  392.359044]  [<ffffffff8115035a>] ? kmem_cache_alloc+0x4a/0x120
> [  392.362356]  [<ffffffff81108155>] mempool_alloc_slab+0x15/0x20
> [  392.363713]  [<ffffffff81108488>] mempool_alloc+0x58/0x150
> [  392.364958]  [<ffffffff81108488>] ? mempool_alloc+0x58/0x150
> [  392.366231]  [<ffffffffa000144c>] alloc_tio.isra.14+0x2c/0x50 [dm_mod]
> [  392.367513]  [<ffffffffa0001e67>] __split_and_process_bio+0x4d7/0x5f0 [dm_mod]
> [  392.368822]  [<ffffffffa0002075>] dm_request+0xf5/0x1a0 [dm_mod]
> [  392.370150]  [<ffffffff8121a647>] generic_make_request+0xc7/0x100
> [  392.371474]  [<ffffffff8121a707>] submit_bio+0x87/0x110
> [  392.372715]  [<ffffffff811983c1>] ? __bio_add_page.part.14+0x101/0x240
> [  392.373954]  [<ffffffff8110f083>] ? account_page_writeback+0x13/0x20
> [  392.375239]  [<ffffffffa0310d19>] ext4_io_submit+0x29/0x60 [ext4]
> [  392.376547]  [<ffffffffa0310f15>] ext4_bio_write_page+0x1c5/0x4d0 [ext4]
> [  392.379691]  [<ffffffffa030cb51>] mpage_da_submit_io+0x511/0x590 [ext4]
> [  392.380932]  [<ffffffffa030edfe>] mpage_da_map_and_submit+0x19e/0x440 [ext4]
> [  392.382040]  [<ffffffffa030f100>] mpage_add_bh_to_extent+0x60/0xe0 [ext4]
> [  392.383254]  [<ffffffffa030f488>] write_cache_pages_da+0x308/0x450 [ext4]
> [  392.384548]  [<ffffffffa030f8f7>] ext4_da_writepages+0x327/0x610 [ext4]
> [  392.385832]  [<ffffffff8134b66b>] ? plugger_unplug+0x3b/0x50
> [  392.387035]  [<ffffffff811113c1>] do_writepages+0x21/0x40
> [  392.388257]  [<ffffffff8118c559>] writeback_single_inode+0x159/0x410
> [  392.389497]  [<ffffffff8118cbe0>] writeback_sb_inodes+0x1a0/0x240
> [  392.390655]  [<ffffffff8118cd1e>] __writeback_inodes_wb+0x9e/0xd0
> [  392.391822]  [<ffffffff8118cfbb>] wb_writeback+0x26b/0x320
> [  392.393034]  [<ffffffff8118e0b0>] wb_do_writeback+0x190/0x1d0
> [  392.394229]  [<ffffffff8118e17b>] bdi_writeback_thread+0x8b/0x290
> [  392.397465]  [<ffffffff8118e0f0>] ? wb_do_writeback+0x1d0/0x1d0
> [  392.398576]  [<ffffffff810701a3>] kthread+0x93/0xa0
> [  392.399791]  [<ffffffff814607a4>] kernel_thread_helper+0x4/0x10
> [  392.401056]  [<ffffffff81070110>] ? kthread_freezable_should_stop+0x70/0x70
> [  392.402320]  [<ffffffff814607a0>] ? gs_change+0x13/0x13
> [  392.403593] ---[ end trace 566c867baea1e58e ]---
> [  392.484824] general protection fault: 0000 [#2] SMP 
> [  392.485708] CPU 2 
> [  392.485715] Modules linked in: nouveau ttm drm_kms_helper drm video netconsole binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sg parport_pc ppdev parport ppp_async ppp_generic slhc crc_ccitt ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables x_tables capi kernelcapi dm_snapshot dm_zero tda18271c2dd af_packet snd_hda_codec_hdmi joydev coretemp cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr nvram ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder serio_raw ir_sony_decoder configfs ir_jvc_decoder rc_imon_pad ir_rc6_decoder ir_rc5_decoder ir_nec_decoder imon i2c_i801 rc_core iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_realtek drxk e1000
 e ddbridge dvb_core cxd2099(C) i2c_core i7core_edac edac_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer asus_atk0110 snd soundcore snd_page_alloc evdev xhci_hcd processor cn ip
 v6 autofs
4 ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usb_storage sd_mod usbhid hid uas crc_t10dif sr_mod mpt2sas raid_class mptsas mptscsih mptbase scsi_transport_sas mxm_wmi ahci libahci firewire_ohci libata ehci_hcd firewire_core uhci_hcd crc_itu_t usbcore scsi_mod usb_common wmi button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: netconsole]
> [  392.496398] 
> [  392.497957] Pid: 6484, comm: rtorrent Tainted: G      D WC   3.3.0-server-1anssi2 #1 System manufacturer System Product Name/P6X58-E-WS
> [  392.499585] RIP: 0010:[<ffffffff8115035a>]  [<ffffffff8115035a>] kmem_cache_alloc+0x4a/0x120
> [  392.503058] RSP: 0018:ffff8803fa24b2e8  EFLAGS: 00010202
> [  392.504567] RAX: 0000000000000000 RBX: ffff8804256be0c0 RCX: 000000000000252f
> [  392.506151] RDX: 000000000000252e RSI: 0000000000011200 RDI: 0000000000016610
> [  392.507691] RBP: ffff8803fa24b338 R08: ffff88043fc56610 R09: ffffffff81108155
> [  392.509229] R10: 0000000000000001 R11: 0000000000000002 R12: ffff88042f007200
> [  392.510851] R13: 0001880360cbe840 R14: ffff8803fa24b388 R15: ffff8804107f8000
> [  392.512442] FS:  00007f1db731d740(0000) GS:ffff88043fc40000(0000) knlGS:0000000000000000
> [  392.513967] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  392.515296] CR2: 00007f1dad125000 CR3: 00000003f7e89000 CR4: 00000000000006e0
> [  392.516757] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  392.520092] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  392.521376] Process someapp (pid: 6484, threadinfo ffff8803fa24a000, task ffff8804107f8000)
> [  392.522636] Stack:
> [  392.523771]  ffff880300000000 ffff880427738000 ffff880300044402 0001120000000020
> [  392.525002]  00000020fa24b388 ffff8804256be0c0 0000000000011210 ffff8804256be0f0
> [  392.526247]  ffff8803fa24b388 ffff8804107f8000 ffff8803fa24b348 ffffffff81108155
> [  392.527496] Call Trace:
> [  392.528849]  [<ffffffff81108155>] mempool_alloc_slab+0x15/0x20
> [  392.530117]  [<ffffffff81108488>] mempool_alloc+0x58/0x150
> [  392.531301]  [<ffffffff81108488>] ? mempool_alloc+0x58/0x150
> [  392.532608]  [<ffffffffa000144c>] alloc_tio.isra.14+0x2c/0x50 [dm_mod]
> [  392.533897]  [<ffffffffa0001e67>] __split_and_process_bio+0x4d7/0x5f0 [dm_mod]
> [  392.537329]  [<ffffffffa0002075>] dm_request+0xf5/0x1a0 [dm_mod]
> [  392.538407]  [<ffffffff8121a647>] generic_make_request+0xc7/0x100
> [  392.539735]  [<ffffffff8121a707>] submit_bio+0x87/0x110
> [  392.541076]  [<ffffffff81105e5d>] ? add_to_page_cache_locked+0xcd/0x130
> [  392.542249]  [<ffffffff8119f1c8>] mpage_readpages+0x118/0x130
> [  392.543529]  [<ffffffffa030d010>] ? noalloc_get_block_write+0x30/0x30 [ext4]
> [  392.544821]  [<ffffffff81108155>] ? mempool_alloc_slab+0x15/0x20
> [  392.546138]  [<ffffffffa030d010>] ? noalloc_get_block_write+0x30/0x30 [ext4]
> [  392.547475]  [<ffffffffa030940d>] ext4_readpages+0x1d/0x20 [ext4]
> [  392.548815]  [<ffffffff8111176f>] __do_page_cache_readahead+0x1af/0x250
> [  392.550188]  [<ffffffff81111b71>] ra_submit+0x21/0x30
> [  392.551465]  [<ffffffff81111c95>] ondemand_readahead+0x115/0x230
> [  392.554814]  [<ffffffff81111e38>] page_cache_async_readahead+0x88/0xb0
> [  392.555890]  [<ffffffff81107dd1>] filemap_fault+0x341/0x470
> [  392.557236]  [<ffffffff8112842f>] __do_fault+0x6f/0x500
> [  392.558505]  [<ffffffffa048546a>] ? e1000_xmit_frame+0xa1a/0xe70 [e1000e]
> [  392.559853]  [<ffffffff812567a0>] ? map_single+0x60/0x60
> [  392.561242]  [<ffffffff8112b1c7>] handle_pte_fault+0xf7/0xab0
> [  392.562619]  [<ffffffff81123859>] ? zone_statistics+0x99/0xc0
> [  392.563945]  [<ffffffff8112bf38>] handle_mm_fault+0x1f8/0x350
> [  392.565170]  [<ffffffff8145adcd>] do_page_fault+0x14d/0x520
> [  392.566518]  [<ffffffff813c82b0>] ? ip_fragment+0x810/0x810
> [  392.567680]  [<ffffffff8110e839>] ? __alloc_pages_nodemask+0x109/0x860
> [  392.569043]  [<ffffffff81152e08>] ? __kmalloc_node_track_caller+0x38/0x1b0
> [  392.572391]  [<ffffffff81457a35>] page_fault+0x25/0x30
> [  392.573521]  [<ffffffff81246636>] ? __copy_user_nocache+0x36/0xc0
> [  392.574748]  [<ffffffff813d1dc6>] ? tcp_sendmsg+0x746/0xda0
> [  392.576102]  [<ffffffff813f7844>] inet_sendmsg+0x64/0xb0
> [  392.577467]  [<ffffffff8120922e>] ? tomoyo_socket_sendmsg+0xe/0x10
> [  392.578859]  [<ffffffff813771e7>] sock_sendmsg+0x117/0x130
> [  392.580162]  [<ffffffff81243174>] ? timerqueue_del+0x34/0x90
> [  392.581478]  [<ffffffff81074400>] ? __remove_hrtimer+0x60/0xc0
> [  392.582824]  [<ffffffff81074830>] ? hrtimer_try_to_cancel+0x50/0xc0
> [  392.584059]  [<ffffffff8137630a>] ? sock_poll+0x1a/0x20
> [  392.585221]  [<ffffffff811a6545>] ? ep_send_events_proc+0x65/0x110
> [  392.586586]  [<ffffffff8137a43d>] sys_sendto+0x13d/0x190
> [  392.589916]  [<ffffffff8107ee40>] ? try_to_wake_up+0x2a0/0x2a0
> [  392.590862]  [<ffffffff8145f3f9>] system_call_fastpath+0x16/0x1b
> [  392.591915] Code: cc 4d 8b 04 24 65 4c 03 04 25 00 dc 00 00 49 8b 50 08 4d 8b 28 4d 85 ed 0f 84 c4 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2 4d 
> [  392.593381] RIP  [<ffffffff8115035a>] kmem_cache_alloc+0x4a/0x120
> [  392.594570]  RSP <ffff8803fa24b2e8>
> [  392.595681] divide error: 0000 [#3] SMP 
> [  392.596073] ---[ end trace 566c867baea1e58f ]---
> [  392.597940] CPU 1 
> [  392.597947] Modules linked in: nouveau ttm drm_kms_helper drm video netconsole binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sg parport_pc ppdev parport ppp_async ppp_generic slhc crc_ccitt ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables x_tables capi kernelcapi dm_snapshot dm_zero tda18271c2dd af_packet snd_hda_codec_hdmi joydev coretemp cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr nvram ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder serio_raw ir_sony_decoder configfs ir_jvc_decoder rc_imon_pad ir_rc6_decoder ir_rc5_decoder ir_nec_decoder imon i2c_i801 rc_core iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_realtek drxk e1000
 e ddbridge dvb_core cxd2099(C) i2c_core i7core_edac edac_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer asus_atk0110 snd soundcore snd_page_alloc evdev xhci_hcd processor cn ip
 v6 autofs
4 ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usb_storage sd_mod usbhid hid uas crc_t10dif sr_mod mpt2sas raid_class mptsas mptscsih mptbase scsi_transport_sas mxm_wmi ahci libahci firewire_ohci libata ehci_hcd firewire_core uhci_hcd crc_itu_t usbcore scsi_mod usb_common wmi button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: netconsole]
> [  392.612423] 
> [  392.613653] Pid: 7235, comm: resize2fs Tainted: G      D WC   3.3.0-server-1anssi2 #1 System manufacturer System Product Name/P6X58-E-WS
> [  392.615057] RIP: 0010:[<ffffffffa032feae>]  [<ffffffffa032feae>] ext4_flex_group_add+0x10de/0x1720 [ext4]
> [  392.616362] RSP: 0018:ffff8803666cbbf8  EFLAGS: 00010206
> [  392.617717] RAX: 000000043ffb1fec RBX: ffff8803e9e80000 RCX: ffff8803559b9400
> [  392.619126] RDX: 0000000000000000 RSI: 0000000100080000 RDI: 0000000000000000
> [  392.620577] RBP: ffff8803666cbd08 R08: 0000000000000200 R09: 0000000100001e21
> [  392.621901] R10: 00000000ffffffff R11: 00000000000761df R12: 000000000007dfde
> [  392.625135] R13: 0000000000080000 R14: ffff8803e9ecfc00 R15: 28f5c28f5c28f5c3
> [  392.626413] FS:  00007f14103c2720(0000) GS:ffff88043fc20000(0000) knlGS:0000000000000000
> [  392.627813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  392.629238] CR2: 00007f0ccbdd65f0 CR3: 000000041140d000 CR4: 00000000000006e0
> [  392.630548] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  392.631968] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  392.633353] Process resize2fs (pid: 7235, threadinfo ffff8803666ca000, task ffff88041050c440)
> [  392.634773] Stack:
> [  392.636137]  0000000000000449 000000000000e6a9 ffff8803666cbc38 ffff88036631e0d0
> [  392.637562]  ffff8803e9e80000 ffff88036636a888 ffff88041a899168 0000000000000000
> [  392.638934]  ffff8803e9e84c00 0000000000000000 ffff8803559b9400 0000000000000000
> [  392.642513] Call Trace:
> [  392.643690]  [<ffffffffa0331462>] ext4_resize_fs+0x692/0x9c0 [ext4]
> [  392.645124]  [<ffffffff8116f522>] ? path_put+0x22/0x30
> [  392.646623]  [<ffffffffa0311acf>] ext4_ioctl+0x8af/0xc20 [ext4]
> [  392.647980]  [<ffffffff8117678f>] do_vfs_ioctl+0x8f/0x4f0
> [  392.649474]  [<ffffffff8115045f>] ? kmem_cache_free+0x2f/0x110
> [  392.650908]  [<ffffffff81176c81>] sys_ioctl+0x91/0xa0
> [  392.652386]  [<ffffffff8145f3f9>] system_call_fastpath+0x16/0x1b
> [  392.653828] Code: 28 8b b1 50 01 00 00 48 c1 e0 20 48 09 d0 8b 51 04 48 c1 e6 20 48 8d 04 80 48 8d 04 80 48 09 d6 31 d2 89 f7 48 c1 e0 02 4c 01 ee <48> f7 f7 89 71 04 48 c1 ee 20 89 b1 50 01 00 00 48 8b 75 88 49 
> [  392.655542] RIP  [<ffffffffa032feae>] ext4_flex_group_add+0x10de/0x1720 [ext4]
> [  392.657113]  RSP <ffff8803666cbbf8>
> [  392.660622] general protection fault: 0000 [#4] SMP 
> [  392.660891] ---[ end trace 566c867baea1e590 ]---
> [  392.663690] CPU 0 
> [  392.663697] Modules linked in: nouveau ttm drm_kms_helper drm video netconsole binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sg parport_pc ppdev parport ppp_async ppp_generic slhc crc_ccitt ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables x_tables capi kernelcapi dm_snapshot dm_zero tda18271c2dd af_packet snd_hda_codec_hdmi joydev coretemp cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table mperf pcspkr nvram ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder serio_raw ir_sony_decoder configfs ir_jvc_decoder rc_imon_pad ir_rc6_decoder ir_rc5_decoder ir_nec_decoder imon i2c_i801 rc_core iTCO_wdt iTCO_vendor_support kvm_intel kvm snd_hda_codec_realtek drxk e1000
 e ddbridge dvb_core cxd2099(C) i2c_core i7core_edac edac_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer asus_atk0110 snd soundcore snd_page_alloc evdev xhci_hcd processor cn ip
 v6 autofs
4 ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usb_storage sd_mod usbhid hid uas crc_t10dif sr_mod mpt2sas raid_class mptsas mptscsih mptbase scsi_transport_sas mxm_wmi ahci libahci firewire_ohci libata ehci_hcd firewire_core uhci_hcd crc_itu_t usbcore scsi_mod usb_common wmi button dm_mirror dm_region_hash dm_log dm_mod [last unloaded: netconsole]
> [  392.678312] 
> [  392.680123] Pid: 3251, comm: kworker/0:6 Tainted: G      D WC   3.3.0-server-1anssi2 #1 System manufacturer System Product Name/P6X58-E-WS
> [  392.682065] RIP: 0010:[<ffffffffa0000d84>]  [<ffffffffa0000d84>] clone_endio+0x34/0xe0 [dm_mod]
> [  392.684081] RSP: 0018:ffff880427223c40  EFLAGS: 00010246
> [  392.686073] RAX: ffffffffa0000d50 RBX: 0000000000000000 RCX: 0000000000000000
> [  392.688134] RDX: ffffffff00000001 RSI: 0000000000000000 RDI: 0001c9001a842040
> [  392.690129] RBP: ffff880427223c70 R08: 0000000000000000 R09: 0000000180270026
> [  392.692126] R10: 0000000000000001 R11: 00ffffffffffffff R12: ffff88035c3423c0
> [  392.696047] R13: ffff880360cb9e10 R14: ffff88035c3423c0 R15: 000767e182a7ff78
> [  392.698077] FS:  0000000000000000(0000) GS:ffff88043fc00000(0000) knlGS:0000000000000000
> [  392.700012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  392.702037] CR2: 0000000002f23220 CR3: 0000000001a05000 CR4: 00000000000006f0
> [  392.703970] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  392.706020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  392.708007] Process kworker/0:6 (pid: 3251, threadinfo ffff880427222000, task ffff880429115b00)
> [  392.709930] Stack:
> [  392.713855]  ffff880427223c80 0000000000000000 ffff8803883f2a00 0000000000000000
> [  392.715845]  ffff88035c3423c0 0000000000000000 ffff880427223c80 ffffffff811976cd
> [  392.717795]  ffff880427223cd0 ffffffffa0621f9f 0000000000049ca0 ffff880417198ea0
> [  392.719764] Call Trace:
> [  392.721687]  [<ffffffff811976cd>] bio_endio+0x1d/0x40
> [  392.723675]  [<ffffffffa0621f9f>] pending_complete+0x1af/0x2d0 [dm_snapshot]
> [  392.725624]  [<ffffffffa062211e>] commit_callback+0xe/0x10 [dm_snapshot]
> [  392.727501]  [<ffffffffa06238a8>] persistent_commit_exception+0xb8/0x160 [dm_snapshot]
> [  392.731315]  [<ffffffffa06220c0>] ? pending_complete+0x2d0/0x2d0 [dm_snapshot]
> [  392.733098]  [<ffffffffa06220f3>] copy_callback+0x33/0x50 [dm_snapshot]
> [  392.734818]  [<ffffffffa000ab34>] run_complete_job+0x74/0xd0 [dm_mod]
> [  392.736578]  [<ffffffffa000a7c5>] process_jobs+0x75/0x110 [dm_mod]
> [  392.738292]  [<ffffffffa000aac0>] ? dispatch_job+0x80/0x80 [dm_mod]
> [  392.739979]  [<ffffffffa000a860>] ? process_jobs+0x110/0x110 [dm_mod]
> [  392.741630]  [<ffffffffa000a893>] do_work+0x33/0x70 [dm_mod]
> [  392.743127]  [<ffffffff8106abf3>] process_one_work+0x113/0x470
> [  392.744738]  [<ffffffff8106b975>] worker_thread+0x165/0x360
> [  392.748204]  [<ffffffff8106b810>] ? manage_workers.isra.28+0x230/0x230
> [  392.749750]  [<ffffffff810701a3>] kthread+0x93/0xa0
> [  392.751205]  [<ffffffff814607a4>] kernel_thread_helper+0x4/0x10
> [  392.752724]  [<ffffffff81070110>] ? kthread_freezable_should_stop+0x70/0x70
> [  392.754200]  [<ffffffff814607a0>] ? gs_change+0x13/0x13
> [  392.755724] Code: 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 4c 8b 6f 58 49 89 fc 85 f6 89 f3 49 8b 7d 08 4d 8b 7d 00 <48> 8b 47 08 4d 8b 37 48 8b 40 48 75 0e 41 f6 44 24 18 01 ba fb 
> [  392.757546] RIP  [<ffffffffa0000d84>] clone_endio+0x34/0xe0 [dm_mod]
> [  392.759184]  RSP <ffff880427223c40>
> [  392.761393] ---[ end trace 566c867baea1e591 ]---

-- 
Anssi Hannula

--------------060804000404020807040607
Content-Type: text/plain;
 name="ext4resizetest"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ext4resizetest"

#!/bin/bash -ex

VG=delta
LV=ext4test
LVSIZE=40T
MOUNTPOINT="/mnt/iso"
RESIZE2FS=/home/anssi/src/git/e2fsprogs/resize/resize2fs

INITIAL_BLOCKS=4294967295
NEW_BLOCKS=$((INITIAL_BLOCKS * 2))

lvcreate -l 100%FREE -V "$LVSIZE" -n "$LV" "$VG"
mkfs.ext4 -O meta_bg,64bit,^resize_inode "/dev/$VG/$LV" "$INITIAL_BLOCKS"

mount "/dev/$VG/$LV" "$MOUNTPOINT"

mkdir "$MOUNTPOINT/test"
for file in 1 2; do
	dd if=/dev/urandom bs=1M count=50 of="$MOUNTPOINT/test/$file"
done
md5sum $MOUNTPOINT/test/* > $MOUNTPOINT/MD5SUM

for N in $NEW_BLOCKS $((NEW_BLOCKS + 50)); do
	$RESIZE2FS "/dev/$VG/$LV" "$N"

	umount "$MOUNTPOINT"
	fsck.ext4 -ncf "/dev/$VG/$LV"
	mount "/dev/$VG/$LV" "$MOUNTPOINT"
	md5sum -c "$MOUNTPOINT/MD5SUM"
done


--------------060804000404020807040607--
