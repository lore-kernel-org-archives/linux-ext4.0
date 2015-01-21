From: Matt Mullins <mmullins@twopensource.com>
Subject: Occasional BUG_ON when mapping pages into KVM guests
Date: Tue, 20 Jan 2015 16:19:12 -0800
Message-ID: <20150121001912.GA31683@whiteoak.sf.office.twttr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [8.25.196.27] ([8.25.196.27]:45308 "EHLO ham-cannon.twitter.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751665AbbAUAYd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2015 19:24:33 -0500
Received: from whiteoak.sf.office.twttr.net (unknown [172.25.20.100])
	by 490043954.twitter.com (Postfix) with ESMTPS id 777D15CE86DD
	for <linux-ext4@vger.kernel.org>; Wed, 21 Jan 2015 00:19:14 +0000 (UTC)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was doing some experimentation to mmap files into a KVM guest, and
occasionally (sometimes early during the guest's lifetime, sometimes
after it's been running a while, and sometimes never at all), I end up
hitting the BUG_ON below on the stock Fedora build of 3.17.7.  All I/O
stops after hitting this.

This appears to be the BUG_ON(!PagePrivate(page)); in page_buffers()
called from mpage_prepare_extent_to_map.

Let me know if there's something I can do to help track it down.

[90583.106816] ------------[ cut here ]------------
[90583.111442] kernel BUG at fs/ext4/inode.c:2267!
[90583.115971] invalid opcode: 0000 [#1] SMP 
[90583.120106] Modules linked in: tun ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth cfg80211 rfkill squashfs loop nvidia(POE) xfs libcrc32c dm_raid raid456 raid1 raid10 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq snd_hda_codec_analog snd_hda_codec_generic coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device lpc_ich snd_pcm serio_raw i7core_edac microcode mfd_core i2c_i801 drm snd_timer snd ioatdma edac_core soundcore dca shpchp tpm_tis acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd sunrpc firewire_ohci tg3 uas firewire_core mvsas ptp usb_storage mxm_wmi crc_itu_t libsas pps_core scsi_transp
 ort_sas wmi ecryptfs encrypted_keys trusted tpm
[90583.197045] CPU: 3 PID: 25178 Comm: kworker/u34:0 Tainted: P           OE  3.17.7-200.fc20.x86_64 #1
[90583.206176] Hardware name:
[90583.213141] Workqueue: writeback bdi_writeback_workfn (flush-253:13)
[90583.219525] task: ffff88060c711d70 ti: ffff8806064bc000 task.ti: ffff8806064bc000
[90583.227002] RIP: 0010:[<ffffffff81288283>]  [<ffffffff81288283>] mpage_prepare_extent_to_map+0x2d3/0x2e0
[90583.236501] RSP: 0018:ffff8806064bf9a8  EFLAGS: 00010246
[90583.241808] RAX: 00c019480000007d RBX: ffff8806064bf9e8 RCX: 0000000000000001
[90583.248939] RDX: ffff8806064bf9e8 RSI: 0000000000000000 RDI: 0000000000040000
[90583.256067] RBP: ffff8806064bfa80 R08: 0000000000000000 R09: 0000000000000000
[90583.263197] R10: 0000000000000100 R11: 0000000000000220 R12: 0000000000003800
[90583.270326] R13: ffffffffffffffff R14: ffffea0010db0b40 R15: ffff8806064bfb20
[90583.277458] FS:  0000000000000000(0000) GS:ffff88061fc40000(0000) knlGS:0000000000000000
[90583.285542] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[90583.291283] CR2: 00007f62d4662108 CR3: 0000000001c14000 CR4: 00000000000027e0
[90583.298413] Stack:
[90583.300425]  ffff8806064bf9e8 0000000000000000 ffff8801dd95d8b0 ffff8806064bfa00
[90583.307884]  0000000000000005 0000000000000004 0000000000000000 ffffea0010db0b40
[90583.315342]  ffffea000e51afc0 ffffea0013d12880 ffffea0016728940 ffffffff812d1d53
[90583.322804] Call Trace:
[90583.325256]  [<ffffffff812d1d53>] ? jbd2__journal_start+0xf3/0x1e0
[90583.331437]  [<ffffffff8128c19a>] ? ext4_writepages+0x42a/0xcd0
[90583.337360]  [<ffffffff812b8809>] ? __ext4_journal_start_sb+0x69/0xe0
[90583.343805]  [<ffffffff8128c1cd>] ext4_writepages+0x45d/0xcd0
[90583.349557]  [<ffffffff81340a53>] ? __blk_run_queue+0x33/0x40
[90583.355311]  [<ffffffff8119493b>] ? generic_writepages+0x5b/0x80
[90583.361325]  [<ffffffff8119626e>] do_writepages+0x1e/0x40
[90583.366721]  [<ffffffff812286e0>] __writeback_single_inode+0x40/0x210
[90583.373163]  [<ffffffff8122908e>] writeback_sb_inodes+0x1be/0x400
[90583.379254]  [<ffffffff8122936f>] __writeback_inodes_wb+0x9f/0xd0
[90583.385343]  [<ffffffff81229bd3>] wb_writeback+0x263/0x2f0
[90583.390824]  [<ffffffff81219bbc>] ? get_nr_inodes+0x4c/0x70
[90583.396392]  [<ffffffff8122c22b>] bdi_writeback_workfn+0x2cb/0x460
[90583.402572]  [<ffffffff810aadc9>] process_one_work+0x149/0x3d0
[90583.408406]  [<ffffffff810ab44b>] worker_thread+0x11b/0x490
[90583.413973]  [<ffffffff810ab330>] ? rescuer_thread+0x2e0/0x2e0
[90583.419805]  [<ffffffff810b04a8>] kthread+0xd8/0xf0
[90583.424686]  [<ffffffff810b03d0>] ? kthread_create_on_node+0x190/0x190
[90583.431212]  [<ffffffff8172ebbc>] ret_from_fork+0x7c/0xb0
[90583.436614]  [<ffffffff810b03d0>] ? kthread_create_on_node+0x190/0x190
[90583.443144] Code: 48 8d bd 50 ff ff ff 89 85 40 ff ff ff e8 36 09 f1 ff 8b 85 40 ff ff ff eb c2 48 8d bd 50 ff ff ff e8 22 09 f1 ff e9 75 ff ff ff <0f> 0b 0f 0b e8 d4 a9 e0 ff 0f 1f 40 00 66 66 66 66 90 55 48 89 
[90583.463110] RIP  [<ffffffff81288283>] mpage_prepare_extent_to_map+0x2d3/0x2e0
[90583.470257]  RSP <ffff8806064bf9a8>
[90583.473777] ---[ end trace 61401eed54aace7e ]---

This was followed immediately by:

[90583.478601] BUG: unable to handle kernel paging request at ffffffffffffffd8
[90583.485591] IP: [<ffffffff810b0ac0>] kthread_data+0x10/0x20
[90583.491186] PGD 1c17067 PUD 1c19067 PMD 0 
[90583.495333] Oops: 0000 [#2] SMP 
[90583.498593] Modules linked in: tun ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth cfg80211 rfkill squashfs loop nv
idia(POE) xfs libcrc32c dm_raid raid456 raid1 raid10 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq snd_hda_
codec_analog snd_hda_codec_generic coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_code
c_hdmi iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device lpc_ich snd_pcm s
erio_raw i7core_edac microcode mfd_core i2c_i801 drm snd_timer snd ioatdma edac_core soundcore dca shpchp tpm_tis acpi_cpufreq nfsd a
uth_rpcgss nfs_acl lockd sunrpc firewire_ohci tg3 uas firewire_core mvsas ptp usb_storage mxm_wmi crc_itu_t libsas pps_core scsi_tran
sport_sas wmi ecryptfs encrypted_keys trusted tpm
[90583.575757] CPU: 3 PID: 25178 Comm: kworker/u34:0 Tainted: P      D    OE  3.17.7-200.fc20.x86_64 #1
[90583.584881] Hardware name:
[90583.591845] task: ffff88060c711d70 ti: ffff8806064bc000 task.ti: ffff8806064bc000
[90583.599374] RIP: 0010:[<ffffffff810b0ac0>]  [<ffffffff810b0ac0>] kthread_data+0x10/0x20
[90583.607520] RSP: 0018:ffff8806064bf648  EFLAGS: 00010002
[90583.612826] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 000000000000000f
[90583.619958] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff88060c711d70
[90583.627095] RBP: ffff8806064bf648 R08: ffff88060c711e00 R09: ffff88060c711d70
[90583.634226] R10: 000000000000002f R11: ffff88030b90002f R12: ffff88061fc53840
[90583.641355] R13: 0000000000000003 R14: 0000000000000000 R15: ffff88060c711d70
[90583.648485] FS:  0000000000000000(0000) GS:ffff88061fc40000(0000) knlGS:0000000000000000
[90583.656569] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[90583.662310] CR2: 0000000000000028 CR3: 0000000001c14000 CR4: 00000000000027e0
[90583.669440] Stack:
[90583.671453]  ffff8806064bf660 ffffffff810ab841 ffff88060c711d70 ffff8806064bf6c8
[90583.678912]  ffffffff8172a6a9 ffff88060c711d70 0000000000013840 ffff8806064bffd8
[90583.686553]  0000000000013840 ffff8806064bf6c0 ffff88060c711d70 ffff88060c712460
[90583.694013] Call Trace:
[90583.696461]  [<ffffffff810ab841>] wq_worker_sleeping+0x11/0xa0
[90583.702294]  [<ffffffff8172a6a9>] __schedule+0x509/0x7d0
[90583.707606]  [<ffffffff8172a999>] schedule+0x29/0x70
[90583.712569]  [<ffffffff81095827>] do_exit+0x6d7/0xa50
[90583.717629]  [<ffffffff8101770c>] oops_end+0x9c/0xe0
[90583.722595]  [<ffffffff81017bbb>] die+0x4b/0x70
[90583.727122]  [<ffffffff81013fb0>] do_trap+0xb0/0x150
[90583.732085]  [<ffffffff81014416>] do_error_trap+0xa6/0x180
[90583.737576]  [<ffffffff81288283>] ? mpage_prepare_extent_to_map+0x2d3/0x2e0
[90583.744544]  [<ffffffffa009fc11>] ? mvs_queue_command+0x311/0x320 [mvsas]
[90583.751333]  [<ffffffff811e2b62>] ? kmem_cache_alloc+0x1c2/0x1f0
[90583.757342]  [<ffffffff81014d30>] do_invalid_op+0x20/0x30
[90583.762736]  [<ffffffff817305be>] invalid_op+0x1e/0x30
[90583.767872]  [<ffffffff81288283>] ? mpage_prepare_extent_to_map+0x2d3/0x2e0
[90583.774836]  [<ffffffff8128814a>] ? mpage_prepare_extent_to_map+0x19a/0x2e0
[90583.781793]  [<ffffffff812d1d53>] ? jbd2__journal_start+0xf3/0x1e0
[90583.787969]  [<ffffffff8128c19a>] ? ext4_writepages+0x42a/0xcd0
[90583.793886]  [<ffffffff812b8809>] ? __ext4_journal_start_sb+0x69/0xe0
[90583.800328]  [<ffffffff8128c1cd>] ext4_writepages+0x45d/0xcd0
[90583.806071]  [<ffffffff81340a53>] ? __blk_run_queue+0x33/0x40
[90583.811814]  [<ffffffff8119493b>] ? generic_writepages+0x5b/0x80
[90583.817825]  [<ffffffff8119626e>] do_writepages+0x1e/0x40
[90583.823230]  [<ffffffff812286e0>] __writeback_single_inode+0x40/0x210
[90583.829671]  [<ffffffff8122908e>] writeback_sb_inodes+0x1be/0x400
[90583.835761]  [<ffffffff8122936f>] __writeback_inodes_wb+0x9f/0xd0
[90583.841854]  [<ffffffff81229bd3>] wb_writeback+0x263/0x2f0
[90583.847344]  [<ffffffff81219bbc>] ? get_nr_inodes+0x4c/0x70
[90583.852924]  [<ffffffff8122c22b>] bdi_writeback_workfn+0x2cb/0x460
[90583.859108]  [<ffffffff810aadc9>] process_one_work+0x149/0x3d0
[90583.864945]  [<ffffffff810ab44b>] worker_thread+0x11b/0x490
[90583.870642]  [<ffffffff810ab330>] ? rescuer_thread+0x2e0/0x2e0
[90583.876545]  [<ffffffff810b04a8>] kthread+0xd8/0xf0
[90583.881435]  [<ffffffff810b03d0>] ? kthread_create_on_node+0x190/0x190
[90583.887968]  [<ffffffff8172ebbc>] ret_from_fork+0x7c/0xb0
[90583.893385]  [<ffffffff810b03d0>] ? kthread_create_on_node+0x190/0x190
[90583.899932] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 68 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[90583.899942] RIP  [<ffffffff810b0ac0>] kthread_data+0x10/0x20
[90583.899943]  RSP <ffff8806064bf648>
[90583.899948] CR2: ffffffffffffffd8
[90583.899951] ---[ end trace 61401eed54aace7f ]---
