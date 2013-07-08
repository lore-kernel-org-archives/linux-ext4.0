From: Jan Kara <jack@suse.cz>
Subject: Re: kernel BUG at fs/buffer.c:1234!
Date: Mon, 8 Jul 2013 16:12:01 +0200
Message-ID: <20130708141201.GG5988@quack.suse.cz>
References: <51C1DF40.7030708@null-ptr.net>
 <20130619185537.GB24587@thunk.org>
 <51C32BB1.5070902@null-ptr.net>
 <20130620163406.GB4982@thunk.org>
 <51D5DBA2.4050705@null-ptr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dustin Lundquist <dustin@null-ptr.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab3GHOMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jul 2013 10:12:05 -0400
Content-Disposition: inline
In-Reply-To: <51D5DBA2.4050705@null-ptr.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-07-13 13:31:30, Dustin Lundquist wrote:
> I've narrowed this down a bit more: this seems to only occur when a
> program attempts to core dump when run within ecryptfs mount. I've
> been able to reliably reproduce it with: int main() { assert(0); };
> 
> Additionally my earlier report that I'm not able to access any local
> files was incorrect: it seems to be limited to the directory which
> the program attempted to core dump in.
> 
> I've update my kernel with WARN_ON(irqs_disabled()); in
> ext4_lookup(), ext4_find_entry() and ecryptfs_lookup() and then only
> received the following:
  Hum, so it's interesting that ecryptfs_lookup() WARN_ON() didn't trigger
but ext4 one did. Strangely enough I don't see a place in the call chain
where irqs could get disabled. Can you maybe trace using irq tracing at
which point exactly do we disable interrupts?

								Honza

> 
> >[   71.368060] ------------[ cut here ]------------
> >[   71.368107] WARNING: at fs/ext4/namei.c:1420 ext4_lookup+0x2a/0x126 [ext4]()
> >[   71.368110] Modules linked in: hidp hid fuse ecb ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc parport_pc ppdev lp parport cpufreq_conservative cpufreq_powersave cpufreq_stats cpufreq_userspace rfcomm bnep binfmt_misc uinput loop ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek joydev coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support arc4 iwldvm snd_hda_intel snd_hda_codec mac80211 snd_hwdep thinkpad_acp
 i snd_pcm pcspkr snd_page_alloc nvram snd_seq snd_timer snd_seq_device iwlwifi microcode i915 ehci_pci psmouse snd serio_raw evdev i2c_i801 drm_kms_helper ehci_hcd cfg80211 lpc_ich mfd_core s
> oundcore drm rfkill battery i2c_algo_bit ac i2c_core wmi video
> acpi_cpufreq mperf processor button ext4 crc16 jbd2 mbcache dm_mod
> sg sd_mod crc_t10dif sdhci_pci ahci sdhci libahci mmc_core libata
> e1000e ptp pps_core scsi_mod xhci_hcd usbcore usb_common thermal
> thermal_sys
> >[   71.368216] CPU: 3 PID: 4560 Comm: test_assert Not tainted 3.10.0 #3
> >[   71.368219] Hardware name: LENOVO 2306CTO/2306CTO, BIOS G2ET94WW (2.54 ) 04/30/2013
> >[   71.368222]  ffffffff8136cf25 0000000000000000 ffffffff8102fbad 0000000000000000
> >[   71.368228]  0000000000000000 ffff8803d4cbf988 ffff8803f48fbc70 ffff8803d9903900
> >[   71.368232]  ffff8803d4decac0 ffff8803f30468c0 ffffffffa01575ee ffff8803f30468c0
> >[   71.368237] Call Trace:
> >[   71.368247]  [<ffffffff8136cf25>] ? dump_stack+0xd/0x17
> >[   71.368255]  [<ffffffff8102fbad>] ? warn_slowpath_common+0x5f/0x77
> >[   71.368271]  [<ffffffffa01575ee>] ? ext4_lookup+0x2a/0x126 [ext4]
> >[   71.368277]  [<ffffffff8110f59f>] ? spin_unlock+0x5/0x6
> >[   71.368282]  [<ffffffff8111141e>] ? d_alloc+0x61/0x69
> >[   71.368288]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.368293]  [<ffffffff811083a4>] ? __lookup_hash+0x2a/0x31
> >[   71.368298]  [<ffffffff8110bffe>] ? lookup_one_len+0xd3/0xe5
> >[   71.368306]  [<ffffffffa05c81f9>] ? ecryptfs_lookup+0x117/0x2eb [ecryptfs]
> >[   71.368311]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.368316]  [<ffffffff8110b6e9>] ? do_last+0x509/0xa16
> >[   71.368321]  [<ffffffff81109492>] ? __inode_permission+0x2f/0x95
> >[   71.368327]  [<ffffffff8110bcba>] ? path_openat+0xc4/0x335
> >[   71.368333]  [<ffffffff810cb77c>] ? __inc_zone_state+0x3f/0x47
> >[   71.368338]  [<ffffffff8110c1d6>] ? do_filp_open+0x2a/0x6e
> >[   71.368345]  [<ffffffff81141c6e>] ? cn_printf+0xda/0xea
> >[   71.368350]  [<ffffffff810ffc2b>] ? file_open_name+0x27/0x2d
> >[   71.368354]  [<ffffffff810ffc53>] ? filp_open+0x22/0x27
> >[   71.368359]  [<ffffffff811424dc>] ? do_coredump+0x85e/0xbe6
> >[   71.368366]  [<ffffffff810b61cc>] ? find_get_page+0x3e/0x5f
> >[   71.368373]  [<ffffffff8136f4c9>] ? _cond_resched+0x6/0x1a
> >[   71.368380]  [<ffffffff8103f892>] ? get_signal_to_deliver+0x46a/0x4a5
> >[   71.368385]  [<ffffffff8103db63>] ? signal_wake_up_state+0x1e/0x31
> >[   71.368390]  [<ffffffff8100214a>] ? do_signal+0x3c/0x504
> >[   71.368395]  [<ffffffff81002637>] ? do_notify_resume+0x25/0x68
> >[   71.368400]  [<ffffffff81370ca2>] ? int_signal+0x12/0x17
> >[   71.368403] ---[ end trace c3af132f2e9b580b ]---
> >[   71.368405] ------------[ cut here ]------------
> >[   71.368417] WARNING: at fs/ext4/namei.c:1235 ext4_find_entry+0x3d/0x3e3 [ext4]()
> >[   71.368419] Modules linked in: hidp hid fuse ecb ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc parport_pc ppdev lp parport cpufreq_conservative cpufreq_powersave cpufreq_stats cpufreq_userspace rfcomm bnep binfmt_misc uinput loop ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek joydev coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support arc4 iwldvm snd_hda_intel snd_hda_codec mac80211 snd_hwdep thinkpad_acp
 i snd_pcm pcspkr snd_page_alloc nvram snd_seq snd_timer snd_seq_device iwlwifi microcode i915 ehci_pci psmouse snd serio_raw evdev i2c_i801 drm_kms_helper ehci_hcd cfg80211 lpc_ich mfd_core s
> oundcore drm rfkill battery i2c_algo_bit ac i2c_core wmi video
> acpi_cpufreq mperf processor button ext4 crc16 jbd2 mbcache dm_mod
> sg sd_mod crc_t10dif sdhci_pci ahci sdhci libahci mmc_core libata
> e1000e ptp pps_core scsi_mod xhci_hcd usbcore usb_common thermal
> thermal_sys
> >[   71.368517] CPU: 3 PID: 4560 Comm: test_assert Tainted: G        W    3.10.0 #3
> >[   71.368519] Hardware name: LENOVO 2306CTO/2306CTO, BIOS G2ET94WW (2.54 ) 04/30/2013
> >[   71.368521]  ffffffff8136cf25 0000000000000000 ffffffff8102fbad ffffffff818b8682
> >[   71.368526]  0000000000000000 00000000d4cbf828 ffff8803f48fbc70 ffff8803d4decb40
> >[   71.368530]  ffff8803d4decac0 0000000000000000 ffffffffa015721e ffff8803d4cbf8f0
> >[   71.368535] Call Trace:
> >[   71.368539]  [<ffffffff8136cf25>] ? dump_stack+0xd/0x17
> >[   71.368544]  [<ffffffff8102fbad>] ? warn_slowpath_common+0x5f/0x77
> >[   71.368560]  [<ffffffffa015721e>] ? ext4_find_entry+0x3d/0x3e3 [ext4]
> >[   71.368577]  [<ffffffffa01575ee>] ? ext4_lookup+0x2a/0x126 [ext4]
> >[   71.368592]  [<ffffffffa01575ee>] ? ext4_lookup+0x2a/0x126 [ext4]
> >[   71.368597]  [<ffffffff8102fbb2>] ? warn_slowpath_common+0x64/0x77
> >[   71.368612]  [<ffffffffa0157615>] ? ext4_lookup+0x51/0x126 [ext4]
> >[   71.368616]  [<ffffffff8110f59f>] ? spin_unlock+0x5/0x6
> >[   71.368620]  [<ffffffff8111141e>] ? d_alloc+0x61/0x69
> >[   71.368625]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.368629]  [<ffffffff811083a4>] ? __lookup_hash+0x2a/0x31
> >[   71.368635]  [<ffffffff8110bffe>] ? lookup_one_len+0xd3/0xe5
> >[   71.368642]  [<ffffffffa05c81f9>] ? ecryptfs_lookup+0x117/0x2eb [ecryptfs]
> >[   71.368647]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.368652]  [<ffffffff8110b6e9>] ? do_last+0x509/0xa16
> >[   71.368657]  [<ffffffff81109492>] ? __inode_permission+0x2f/0x95
> >[   71.368662]  [<ffffffff8110bcba>] ? path_openat+0xc4/0x335
> >[   71.368667]  [<ffffffff810cb77c>] ? __inc_zone_state+0x3f/0x47
> >[   71.368672]  [<ffffffff8110c1d6>] ? do_filp_open+0x2a/0x6e
> >[   71.368678]  [<ffffffff81141c6e>] ? cn_printf+0xda/0xea
> >[   71.368682]  [<ffffffff810ffc2b>] ? file_open_name+0x27/0x2d
> >[   71.368686]  [<ffffffff810ffc53>] ? filp_open+0x22/0x27
> >[   71.368691]  [<ffffffff811424dc>] ? do_coredump+0x85e/0xbe6
> >[   71.368696]  [<ffffffff810b61cc>] ? find_get_page+0x3e/0x5f
> >[   71.368701]  [<ffffffff8136f4c9>] ? _cond_resched+0x6/0x1a
> >[   71.368707]  [<ffffffff8103f892>] ? get_signal_to_deliver+0x46a/0x4a5
> >[   71.368711]  [<ffffffff8103db63>] ? signal_wake_up_state+0x1e/0x31
> >[   71.368716]  [<ffffffff8100214a>] ? do_signal+0x3c/0x504
> >[   71.368721]  [<ffffffff81002637>] ? do_notify_resume+0x25/0x68
> >[   71.368724]  [<ffffffff81370ca2>] ? int_signal+0x12/0x17
> >[   71.368727] ---[ end trace c3af132f2e9b580c ]---
> >[   71.368741] ------------[ cut here ]------------
> >[   71.368806] kernel BUG at fs/buffer.c:1234!
> >[   71.368859] invalid opcode: 0000 [#1] SMP
> >[   71.368916] Modules linked in: hidp hid fuse ecb ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc parport_pc ppdev lp parport cpufreq_conservative cpufreq_powersave cpufreq_stats cpufreq_userspace rfcomm bnep binfmt_misc uinput loop ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek joydev coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support arc4 iwldvm snd_hda_intel snd_hda_codec mac80211 snd_hwdep thinkpad_acp
 i snd_pcm pcspkr snd_page_alloc nvram snd_seq snd_timer snd_seq_device iwlwifi microcode i915 ehci_pci psmouse snd serio_raw evdev i2c_i801 drm_kms_helper ehci_hcd cfg80211 lpc_ich mfd_core s
> oundcore drm rfkill battery i2c_algo_bit ac i2c_core wmi video
> acpi_cpufreq mperf processor button ext4 crc16 jbd2 mbcache dm_mod
> sg sd_mod crc_t10dif sdhci_pci ahci sdhci libahci mmc_core libata
> e1000e ptp pps_core scsi_mod xhci_hcd usbcore usb_common thermal
> thermal_sys
> >[   71.370597] CPU: 3 PID: 4560 Comm: test_assert Tainted: G        W    3.10.0 #3
> >[   71.370685] Hardware name: LENOVO 2306CTO/2306CTO, BIOS G2ET94WW (2.54 ) 04/30/2013
> >[   71.370777] task: ffff8804097055e0 ti: ffff8803d4cbe000 task.ti: ffff8803d4cbe000
> >[   71.370868] RIP: 0010:[<ffffffff81123bfa>]  [<ffffffff81123bfa>] check_irqs_on+0x7/0xa
> >[   71.370971] RSP: 0018:ffff8803d4cbf540  EFLAGS: 00010046
> >[   71.371037] RAX: 0000000000000096 RBX: 0000000000001000 RCX: 0000000000000000
> >[   71.371122] RDX: 0000000000001000 RSI: 0000000000a8207b RDI: ffff88041d7c7740
> >[   71.371208] RBP: ffff88041d7c7740 R08: 0000000001400000 R09: 0000000000000000
> >[   71.371294] R10: 0000000000000000 R11: ffffffff814dae00 R12: 0000000000a8207b
> >[   71.371380] R13: 0000000000000001 R14: 0000000000a8207b R15: 0000000000000000
> >[   71.371467] FS:  00007f3a5c944700(0000) GS:ffff88041e2c0000(0000) knlGS:0000000000000000
> >[   71.371565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[   71.371634] CR2: 00007f3a5c425070 CR3: 00000003f346f000 CR4: 00000000001407e0
> >[   71.371720] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >[   71.371806] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >[   71.371891] Stack:
> >[   71.371917]  ffffffff81123e41 0000000000000001 ffff8803f3fe8358 ffff8803d4cbf5b0
> >[   71.372017]  ffffffffa014e10d ffff8803d4cbf6b4 ffff8803d4cbf630 ffff8803d4cbf630
> >[   71.372117]  ffff8803f48fbc70 0000000000000000 ffff8803d4cbf6b4 0000000000001000
> >[   71.372217] Call Trace:
> >[   71.372253]  [<ffffffff81123e41>] ? __find_get_block+0x17/0x162
> >[   71.372341]  [<ffffffffa014e10d>] ? __check_block_validity.constprop.53+0x27/0x65 [ext4]
> >[   71.372441]  [<ffffffff81124b7d>] ? __getblk+0x1b/0x275
> >[   71.372519]  [<ffffffffa014fc55>] ? ext4_getblk+0x9b/0x15d [ext4]
> >[   71.372596]  [<ffffffff8136ff4d>] ? _raw_spin_trylock+0x5/0x13
> >[   71.372681]  [<ffffffffa014fd24>] ? ext4_bread+0xd/0x61 [ext4]
> >[   71.372755]  [<ffffffff81031549>] ? console_unlock+0x2c6/0x303
> >[   71.372839]  [<ffffffffa0155f2f>] ? __ext4_read_dirblock+0x35/0x251 [ext4]
> >[   71.372935]  [<ffffffffa015636c>] ? dx_probe+0x38/0x308 [ext4]
> >[   71.373008]  [<ffffffff81005039>] ? show_trace_log_lvl+0x2c/0x56
> >[   71.373094]  [<ffffffffa01570cc>] ? ext4_dx_find_entry+0x3d/0x152 [ext4]
> >[   71.373179]  [<ffffffff8136a902>] ? printk+0x4f/0x54
> >[   71.373252]  [<ffffffffa015721e>] ? ext4_find_entry+0x3d/0x3e3 [ext4]
> >[   71.373333]  [<ffffffff8102fbb2>] ? warn_slowpath_common+0x64/0x77
> >[   71.373421]  [<ffffffffa0157313>] ? ext4_find_entry+0x132/0x3e3 [ext4]
> >[   71.373515]  [<ffffffffa01575ee>] ? ext4_lookup+0x2a/0x126 [ext4]
> >[   71.373601]  [<ffffffffa01575ee>] ? ext4_lookup+0x2a/0x126 [ext4]
> >[   71.376994]  [<ffffffff8102fbb2>] ? warn_slowpath_common+0x64/0x77
> >[   71.380410]  [<ffffffffa0157615>] ? ext4_lookup+0x51/0x126 [ext4]
> >[   71.383809]  [<ffffffff8110f59f>] ? spin_unlock+0x5/0x6
> >[   71.387089]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.390236]  [<ffffffff811083a4>] ? __lookup_hash+0x2a/0x31
> >[   71.393253]  [<ffffffff8110bffe>] ? lookup_one_len+0xd3/0xe5
> >[   71.396152]  [<ffffffffa05c81f9>] ? ecryptfs_lookup+0x117/0x2eb [ecryptfs]
> >[   71.398948]  [<ffffffff81107f5d>] ? lookup_real+0x24/0x3f
> >[   71.401614]  [<ffffffff8110b6e9>] ? do_last+0x509/0xa16
> >[   71.404152]  [<ffffffff81109492>] ? __inode_permission+0x2f/0x95
> >[   71.406579]  [<ffffffff8110bcba>] ? path_openat+0xc4/0x335
> >[   71.408960]  [<ffffffff810cb77c>] ? __inc_zone_state+0x3f/0x47
> >[   71.411307]  [<ffffffff8110c1d6>] ? do_filp_open+0x2a/0x6e
> >[   71.413623]  [<ffffffff81141c6e>] ? cn_printf+0xda/0xea
> >[   71.415889]  [<ffffffff810ffc2b>] ? file_open_name+0x27/0x2d
> >[   71.418123]  [<ffffffff810ffc53>] ? filp_open+0x22/0x27
> >[   71.420317]  [<ffffffff811424dc>] ? do_coredump+0x85e/0xbe6
> >[   71.422516]  [<ffffffff810b61cc>] ? find_get_page+0x3e/0x5f
> >[   71.424701]  [<ffffffff8136f4c9>] ? _cond_resched+0x6/0x1a
> >[   71.426876]  [<ffffffff8103f892>] ? get_signal_to_deliver+0x46a/0x4a5
> >[   71.429073]  [<ffffffff8103db63>] ? signal_wake_up_state+0x1e/0x31
> >[   71.431238]  [<ffffffff8100214a>] ? do_signal+0x3c/0x504
> >[   71.433364]  [<ffffffff81002637>] ? do_notify_resume+0x25/0x68
> >[   71.435483]  [<ffffffff81370ca2>] ? int_signal+0x12/0x17
> >[   71.437588] Code: db b6 6d 48 c1 fe 03 48 0f af f0 48 b8 00 00 00 00 00 88 ff ff 48 c1 e6 0c 48 01 c6 48 01 f2 48 89 57 28 c3 9c 58 f6 c4 02 75 02 <0f> 0b c3 55 48 c7 c5 60 f3 00 00 83 c8 ff 53 31 db 41 52 65 c7
> >[   71.442432] RIP  [<ffffffff81123bfa>] check_irqs_on+0x7/0xa
> >[   71.444766]  RSP <ffff8803d4cbf540>
> >[   71.463545] ---[ end trace c3af132f2e9b580d ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
