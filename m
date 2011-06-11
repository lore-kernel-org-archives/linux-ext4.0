From: Norbert Preining <preining@logic.at>
Subject: ext3 and btrfs various Oops and kernel BUGs
Date: Sat, 11 Jun 2011 11:17:32 +0900
Message-ID: <20110611021732.GA18768@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ext2-devel@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dear all,

(please Cc)

yesterday I had two bugs with btrfs and ext3 occurrences, always happening
when plugging in an external USB btrfs disk.

Today I had a BUG which is purely ext3 related.

The last bug was with yesterdays latest git checkout.

Here are the three bugs/oops:

that one was with 3.0.0-rc2 (exactely)

Jun 10 14:50:23 mithrandir kernel: [40871.704129] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
Jun 10 14:50:23 mithrandir kernel: [40871.704185] IP: [<ffffffffa0d7b6e5>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.704241] PGD 12d5e9067 PUD 12d5e8067 PMD 0 
Jun 10 14:50:23 mithrandir kernel: [40871.704277] Oops: 0000 [#1] PREEMPT SMP 
Jun 10 14:50:23 mithrandir kernel: [40871.704311] CPU 1 
Jun 10 14:50:23 mithrandir kernel: [40871.704324] Modules linked in: usb_storage rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat hso fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi iwlagn mac80211 snd_seq_midi_event cfg80211 snd_seq snd_timer snd_seq_device snd btusb bluetooth sony_laptop tpm_infineon soundcore mxm_wmi joydev firewire_ohci crc16 firewire_core snd_page_alloc rfkill crc_itu_t
Jun 10 14:50:23 mithrandir kernel: [40871.704733] 
Jun 10 14:50:23 mithrandir kernel: [40871.704745] Pid: 18862, comm: btrfs-transacti Tainted: P            3.0.0-rc2+ #33 Sony Corporation VGN-Z11VN_B/VAIO
Jun 10 14:50:23 mithrandir kernel: [40871.704812] RIP: 0010:[<ffffffffa0d7b6e5>]  [<ffffffffa0d7b6e5>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.704875] RSP: 0018:ffff880103eadb10  EFLAGS: 00010282
Jun 10 14:50:23 mithrandir kernel: [40871.704906] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: ffff88012431a828
Jun 10 14:50:23 mithrandir kernel: [40871.704945] RDX: 00000044824bb000 RSI: 0000000000000000 RDI: ffff88012bd11800
Jun 10 14:50:23 mithrandir kernel: [40871.704985] RBP: ffff880103eadb90 R08: 0000000000000001 R09: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.705024] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88012bd11800
Jun 10 14:50:23 mithrandir kernel: [40871.705063] R13: 0000004482495000 R14: 0000000000000007 R15: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.705103] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.705149] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 14:50:23 mithrandir kernel: [40871.705180] CR2: 0000000000000030 CR3: 00000001270df000 CR4: 00000000000006e0
Jun 10 14:50:23 mithrandir kernel: [40871.705220] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.705259] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 14:50:23 mithrandir kernel: [40871.705299] Process btrfs-transacti (pid: 18862, threadinfo ffff880103eac000, task ffff88013f5e7750)
Jun 10 14:50:23 mithrandir kernel: [40871.705350] Stack:
Jun 10 14:50:23 mithrandir kernel: [40871.705364]  ffff880103eadb20 0000004482495000 ffff880103eadb50 ffff88012bd11800
Jun 10 14:50:23 mithrandir kernel: [40871.705415]  ffffffff00008050 0000000000000206 ffff88013f7a64c0 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.705465]  a800000044824950 0000000000001000 ffff8800374bf140 ffff880102dcbd00
Jun 10 14:50:23 mithrandir kernel: [40871.705516] Call Trace:
Jun 10 14:50:23 mithrandir kernel: [40871.705539]  [<ffffffffa0d7584e>] __btrfs_free_extent+0x24b/0x54f [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705579]  [<ffffffff810781cc>] ? __delayacct_blkio_end+0x39/0x3b
Jun 10 14:50:23 mithrandir kernel: [40871.705616]  [<ffffffff81025a4e>] ? delayacct_blkio_end+0x1c/0x3c
Jun 10 14:50:23 mithrandir kernel: [40871.705652]  [<ffffffff810d2a0e>] ? wait_on_buffer+0x12/0x12
Jun 10 14:50:23 mithrandir kernel: [40871.705692]  [<ffffffffa0d77d22>] run_clustered_refs+0x616/0x660 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705733]  [<ffffffff81025042>] ? set_next_entity+0x3b/0x60
Jun 10 14:50:23 mithrandir kernel: [40871.705776]  [<ffffffffa0db768f>] ? btrfs_find_ref_cluster+0xf6/0x137 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705822]  [<ffffffffa0d77e38>] btrfs_run_delayed_refs+0xcc/0x17c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705871]  [<ffffffffa0d85775>] btrfs_commit_transaction+0x72/0x655 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705920]  [<ffffffffa0d84d89>] ? join_transaction.isra.23+0x203/0x20a [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.705964]  [<ffffffff810481d4>] ? add_wait_queue+0x44/0x44
Jun 10 14:50:23 mithrandir kernel: [40871.706006]  [<ffffffffa0d80180>] transaction_kthread+0x174/0x22b [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.706053]  [<ffffffffa0d8000c>] ? btrfs_congested_fn+0x8e/0x8e [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.706093]  [<ffffffff81047bb8>] kthread+0x7f/0x87
Jun 10 14:50:23 mithrandir kernel: [40871.706123]  [<ffffffff8139fd94>] kernel_thread_helper+0x4/0x10
Jun 10 14:50:23 mithrandir kernel: [40871.706157]  [<ffffffff81047b39>] ? kthread_worker_fn+0x141/0x141
Jun 10 14:50:23 mithrandir kernel: [40871.706192]  [<ffffffff8139fd90>] ? gs_change+0xb/0xb
Jun 10 14:50:23 mithrandir kernel: [40871.706220] Code: ff ff 48 8b 80 38 e0 ff ff a8 08 74 05 e8 ab 1c 62 e0 5d c3 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 89 f3 48 83 ec 58 
Jun 10 14:50:23 mithrandir kernel: [40871.706492] RIP  [<ffffffffa0d7b6e5>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.706543]  RSP <ffff880103eadb10>
Jun 10 14:50:23 mithrandir kernel: [40871.706564] CR2: 0000000000000030
Jun 10 14:50:23 mithrandir kernel: [40871.729568] ---[ end trace 7ff9da295f74d790 ]---
Jun 10 14:50:23 mithrandir kernel: [40871.729588] BUG: unable to handle kernel paging request at 00000000000015bd
Jun 10 14:50:23 mithrandir kernel: [40871.729632] IP: [<ffffffff8111a0c2>] journal_start+0x2f/0xc1
Jun 10 14:50:23 mithrandir kernel: [40871.729668] PGD 1391ca067 PUD 1391c9067 PMD 0 
Jun 10 14:50:23 mithrandir kernel: [40871.729701] Oops: 0000 [#2] PREEMPT SMP 
Jun 10 14:50:23 mithrandir kernel: [40871.731455] CPU 0 
Jun 10 14:50:23 mithrandir kernel: [40871.731467] Modules linked in: usb_storage rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat hso fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi iwlagn mac80211 snd_seq_midi_event cfg80211 snd_seq snd_timer snd_seq_device snd btusb bluetooth sony_laptop tpm_infineon soundcore mxm_wmi joydev firewire_ohci crc16 firewire_core snd_page_alloc rfkill crc_itu_t
Jun 10 14:50:23 mithrandir kernel: [40871.732005] 
Jun 10 14:50:23 mithrandir kernel: [40871.732005] Pid: 18862, comm: btrfs-transacti Tainted: P      D     3.0.0-rc2+ #33 Sony Corporation VGN-Z11VN_B/VAIO
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RIP: 0010:[<ffffffff8111a0c2>]  [<ffffffff8111a0c2>] journal_start+0x2f/0xc1
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RSP: 0018:ffff880103ead3e8  EFLAGS: 00010282
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RAX: 00000000000015bd RBX: ffff880124138780 RCX: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RDX: ffff88013b362800 RSI: 0000000000000002 RDI: ffff88013b362400
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RBP: ffff880103ead408 R08: 0000000000000040 R09: ffff880103ead778
Jun 10 14:50:23 mithrandir kernel: [40871.732005] R10: ffff880103eadfd8 R11: ffff880103ead6f8 R12: ffff88013f5e7750
Jun 10 14:50:23 mithrandir kernel: [40871.732005] R13: ffff88013b362400 R14: 0000000000000002 R15: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.732005] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.732005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 14:50:23 mithrandir kernel: [40871.732005] CR2: 00000000000015bd CR3: 0000000127204000 CR4: 00000000000006f0
Jun 10 14:50:23 mithrandir kernel: [40871.732005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 14:50:23 mithrandir kernel: [40871.732005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 14:50:23 mithrandir kernel: [40871.732005] Process btrfs-transacti (pid: 18862, threadinfo ffff880103eac000, task ffff88013f5e7750)
Jun 10 14:50:23 mithrandir kernel: [40871.732005] Stack:
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  ffffffffffffffe2 ffff88004cf7dd60 ffff880124138780 0000000000000001
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  ffff880103ead428 ffffffff8110adf1 ffff88004cf7dd60 ffff88004cf7dd60
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  ffff880103ead458 ffffffff81105e8d ffffffff81105e62 ffff88004cf7dd60
Jun 10 14:50:23 mithrandir kernel: [40871.732005] Call Trace:
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8110adf1>] ext3_journal_start_sb+0x45/0x50
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81105e8d>] ext3_dirty_inode+0x2b/0x7d
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81105e62>] ? ext3_evict_inode+0x119/0x119
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810cd805>] __mark_inode_dirty+0x2a/0x181
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810c4813>] file_update_time+0xfd/0x121
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810832a2>] __generic_file_aio_write+0x15b/0x270
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8139eb86>] ? retint_kernel+0x26/0x30
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81083413>] generic_file_aio_write+0x5c/0xb5
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810b1e2a>] do_sync_write+0xba/0xfa
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8103c2c6>] ? mod_timer+0x87/0x8f
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8104e7c7>] ? timekeeping_get_ns+0x12/0x31
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8104ec3b>] ? ktime_get_ts+0x80/0x89
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81063001>] do_acct_process+0x28c/0x2bf
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81063625>] acct_process+0x73/0x92
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81035007>] do_exit+0x244/0x6da
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810335c9>] ? kmsg_dump+0xcb/0xda
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8100492e>] oops_end+0x89/0x8e
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81396a4c>] no_context+0x1fe/0x20d
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d9397f>] ? lookup_extent_mapping+0xaf/0xc2 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81396be9>] __bad_area_nosemaphore+0x18e/0x1b1
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81396c1a>] bad_area_nosemaphore+0xe/0x10
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8101d95b>] do_page_fault+0x143/0x308
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0da20c7>] ? free_extent_buffer+0x12/0x29 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d6e660>] ? read_block_for_search.isra.35+0x356/0x36b [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d6b86d>] ? btrfs_header_nritems.isra.15+0x14/0x1b [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d6d7d9>] ? balance_level+0xd2/0x578 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8139e3e0>] ? _raw_spin_lock+0x18/0x1a
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8139ec8f>] page_fault+0x1f/0x30
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d7b6e5>] ? btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d7584e>] __btrfs_free_extent+0x24b/0x54f [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810781cc>] ? __delayacct_blkio_end+0x39/0x3b
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81025a4e>] ? delayacct_blkio_end+0x1c/0x3c
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810d2a0e>] ? wait_on_buffer+0x12/0x12
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d77d22>] run_clustered_refs+0x616/0x660 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81025042>] ? set_next_entity+0x3b/0x60
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0db768f>] ? btrfs_find_ref_cluster+0xf6/0x137 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d77e38>] btrfs_run_delayed_refs+0xcc/0x17c [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d85775>] btrfs_commit_transaction+0x72/0x655 [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d84d89>] ? join_transaction.isra.23+0x203/0x20a [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff810481d4>] ? add_wait_queue+0x44/0x44
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d80180>] transaction_kthread+0x174/0x22b [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffffa0d8000c>] ? btrfs_congested_fn+0x8e/0x8e [btrfs]
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81047bb8>] kthread+0x7f/0x87
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8139fd94>] kernel_thread_helper+0x4/0x10
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff81047b39>] ? kthread_worker_fn+0x141/0x141
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  [<ffffffff8139fd90>] ? gs_change+0xb/0xb
Jun 10 14:50:23 mithrandir kernel: [40871.732005] Code: 41 56 41 89 f6 41 55 49 89 fd 41 54 53 65 4c 8b 24 25 00 b6 00 00 48 85 ff 49 8b 9c 24 f8 04 00 00 74 7e 48 85 db 74 0f 48 8b 03 
Jun 10 14:50:23 mithrandir kernel: [40871.732005] RIP  [<ffffffff8111a0c2>] journal_start+0x2f/0xc1
Jun 10 14:50:23 mithrandir kernel: [40871.732005]  RSP <ffff880103ead3e8>
Jun 10 14:50:23 mithrandir kernel: [40871.732005] CR2: 00000000000015bd
Jun 10 14:50:23 mithrandir kernel: [40871.851016] ---[ end trace 7ff9da295f74d791 ]---
Jun 10 14:50:23 mithrandir kernel: [40871.851018] Fixing recursive fault but reboot is needed!
Jun 10 14:50:46 mithrandir console-kit-daemon[3064]: WARNING: The program /usr/lib/ConsoleKit/run-seat.d/udev-acl.ck didn't exit within 15 seconds; killing it
Jun 10 14:50:50 mithrandir kernel: [40898.096945] SysRq : Emergency Sync
Jun 10 14:50:50 mithrandir kernel: [40898.446155] SysRq : Emergency Sync
Jun 10 14:50:51 mithrandir kernel: [40899.399464] SysRq : Emergency Sync
Jun 10 14:50:51 mithrandir kernel: [40899.555006] SysRq : Emergency Sync
Jun 10 14:50:51 mithrandir kernel: [40900.037680] SysRq : Emergency Remount R/O



Reboot into git checkout last commit 7f45e5cd1718ed7692
(Thu Jun 9 16:33:01 2011 -0700)

--------- reboot and replug btrfs external HD

Jun 10 14:57:17 mithrandir kernel: [  266.180096] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
Jun 10 14:57:17 mithrandir kernel: [  266.180171] IP: [<ffffffffa02276f9>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.180245] PGD 102a92067 PUD 102ba6067 PMD 0 
Jun 10 14:57:17 mithrandir kernel: [  266.180292] Oops: 0000 [#1] PREEMPT SMP 
Jun 10 14:57:17 mithrandir kernel: [  266.180334] CPU 1 
Jun 10 14:57:17 mithrandir kernel: [  266.180352] Modules linked in: usb_storage rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mxm_wmi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq firewire_ohci firewire_core joydev crc_itu_t snd_timer snd_seq_device snd sony_laptop tpm_infineon iwlagn mac80211 cfg80211 rfkill soundcore snd_page_alloc
Jun 10 14:57:17 mithrandir kernel: [  266.180889] 
Jun 10 14:57:17 mithrandir kernel: [  266.180905] Pid: 4060, comm: sync Not tainted 3.0.0-rc2+ #34 Sony Corporation VGN-Z11VN_B/VAIO
Jun 10 14:57:17 mithrandir kernel: [  266.180980] RIP: 0010:[<ffffffffa02276f9>]  [<ffffffffa02276f9>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.181067] RSP: 0018:ffff88010e543b78  EFLAGS: 00010296
Jun 10 14:57:17 mithrandir kernel: [  266.181110] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: ffff880107c9fea8
Jun 10 14:57:17 mithrandir kernel: [  266.181165] RDX: 00000044823a9000 RSI: 0000000000000000 RDI: ffff88012de2d000
Jun 10 14:57:17 mithrandir kernel: [  266.181221] RBP: ffff88010e543bf8 R08: 0000000000000001 R09: 0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.181276] R10: 0000000000000000 R11: 0000004c42ba9000 R12: ffff88012de2d000
Jun 10 14:57:17 mithrandir kernel: [  266.181332] R13: 0000004482378000 R14: 0000000000000005 R15: 0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.181388] FS:  00007f2d337cd700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.181451] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 14:57:17 mithrandir kernel: [  266.181497] CR2: 0000000000000030 CR3: 000000010e7c2000 CR4: 00000000000006e0
Jun 10 14:57:17 mithrandir kernel: [  266.181553] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.181608] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 14:57:17 mithrandir kernel: [  266.181664] Process sync (pid: 4060, threadinfo ffff88010e542000, task ffff8800bb554da0)
Jun 10 14:57:17 mithrandir kernel: [  266.181727] Stack:
Jun 10 14:57:17 mithrandir kernel: [  266.181745]  ffff88010e543ba8 0000004482378000 ffff88012cf10800 ffff88012de2d000
Jun 10 14:57:17 mithrandir kernel: [  266.181814]  ffffffff00008050 0000000000000206 ffff88013b0fe2c0 0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.181883]  a800000044823780 0000000000001000 ffff8801161eb4c0 ffff8801062957f0
Jun 10 14:57:17 mithrandir kernel: [  266.181952] Call Trace:
Jun 10 14:57:17 mithrandir kernel: [  266.181986]  [<ffffffffa0221862>] __btrfs_free_extent+0x24b/0x54f [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182042]  [<ffffffff8139e63a>] ? _raw_spin_unlock+0x1e/0x29
Jun 10 14:57:17 mithrandir kernel: [  266.182105]  [<ffffffffa024ec12>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182174]  [<ffffffffa0223d36>] run_clustered_refs+0x616/0x660 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182228]  [<ffffffff8139e63a>] ? _raw_spin_unlock+0x1e/0x29
Jun 10 14:57:17 mithrandir kernel: [  266.182290]  [<ffffffffa02636a3>] ? btrfs_find_ref_cluster+0xf6/0x137 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182357]  [<ffffffffa0223e4c>] btrfs_run_delayed_refs+0xcc/0x17c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182427]  [<ffffffffa0231a2f>] btrfs_commit_transaction+0x318/0x655 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182487]  [<ffffffff810481cc>] ? add_wait_queue+0x44/0x44
Jun 10 14:57:17 mithrandir kernel: [  266.182534]  [<ffffffff810d13d6>] ? __sync_filesystem+0x72/0x72
Jun 10 14:57:17 mithrandir kernel: [  266.182589]  [<ffffffffa0216bd5>] btrfs_sync_fs+0x62/0x66 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.182639]  [<ffffffff810d13c2>] __sync_filesystem+0x5e/0x72
Jun 10 14:57:17 mithrandir kernel: [  266.182686]  [<ffffffff810d13e7>] sync_one_sb+0x11/0x13
Jun 10 14:57:17 mithrandir kernel: [  266.182730]  [<ffffffff810b49ec>] iterate_supers+0x6a/0xbf
Jun 10 14:57:17 mithrandir kernel: [  266.182775]  [<ffffffff810d146e>] sys_sync+0x3d/0x4f
Jun 10 14:57:17 mithrandir kernel: [  266.182816]  [<ffffffff8139f03b>] system_call_fastpath+0x16/0x1b
Jun 10 14:57:17 mithrandir kernel: [  266.182864] Code: ff ff 48 8b 80 38 e0 ff ff a8 08 74 05 e8 5f 5c 17 e1 5d c3 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 89 f3 48 83 ec 58 
Jun 10 14:57:17 mithrandir kernel: [  266.183224] RIP  [<ffffffffa02276f9>] btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.183293]  RSP <ffff88010e543b78>
Jun 10 14:57:17 mithrandir kernel: [  266.183321] CR2: 0000000000000030
Jun 10 14:57:17 mithrandir kernel: [  266.203699] ---[ end trace 757ecf6cb9e574c9 ]---
Jun 10 14:57:17 mithrandir kernel: [  266.203784] BUG: unable to handle kernel paging request at 00000000000015bd
Jun 10 14:57:17 mithrandir kernel: [  266.203788] IP: [<ffffffff8111a212>] journal_start+0x2f/0xc1
Jun 10 14:57:17 mithrandir kernel: [  266.203795] PGD 0 
Jun 10 14:57:17 mithrandir kernel: [  266.203797] Oops: 0000 [#2] PREEMPT SMP 
Jun 10 14:57:17 mithrandir kernel: [  266.203800] CPU 1 
Jun 10 14:57:17 mithrandir kernel: [  266.203801] Modules linked in: usb_storage rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mxm_wmi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq firewire_ohci firewire_core joydev crc_itu_t snd_timer snd_seq_device snd sony_laptop tpm_infineon iwlagn mac80211 cfg80211 rfkill soundcore snd_page_alloc
Jun 10 14:57:17 mithrandir kernel: [  266.203834] 
Jun 10 14:57:17 mithrandir kernel: [  266.203837] Pid: 4060, comm: sync Tainted: G      D     3.0.0-rc2+ #34 Sony Corporation VGN-Z11VN_B/VAIO
Jun 10 14:57:17 mithrandir kernel: [  266.203842] RIP: 0010:[<ffffffff8111a212>]  [<ffffffff8111a212>] journal_start+0x2f/0xc1
Jun 10 14:57:17 mithrandir kernel: [  266.203847] RSP: 0018:ffff88010e543398  EFLAGS: 00010282
Jun 10 14:57:17 mithrandir kernel: [  266.203849] RAX: 00000000000015bd RBX: ffff880101e5e540 RCX: 0000000000000003
Jun 10 14:57:17 mithrandir kernel: [  266.203852] RDX: 0000000000000002 RSI: 000000000000000e RDI: ffff88013a502800
Jun 10 14:57:17 mithrandir kernel: [  266.203855] RBP: ffff88010e5433b8 R08: ffffea0003df9de8 R09: 0000000000000037
Jun 10 14:57:17 mithrandir kernel: [  266.203858] R10: ffffffff814182f0 R11: 00000000ffffffff R12: ffff8800bb554da0
Jun 10 14:57:17 mithrandir kernel: [  266.203860] R13: ffff88013a502800 R14: 000000000000000e R15: 0000000000000040
Jun 10 14:57:17 mithrandir kernel: [  266.203864] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.203867] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 14:57:17 mithrandir kernel: [  266.203869] CR2: 00000000000015bd CR3: 0000000001617000 CR4: 00000000000006e0
Jun 10 14:57:17 mithrandir kernel: [  266.203872] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 14:57:17 mithrandir kernel: [  266.203875] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 14:57:17 mithrandir kernel: [  266.203878] Process sync (pid: 4060, threadinfo ffff88010e542000, task ffff8800bb554da0)
Jun 10 14:57:17 mithrandir kernel: [  266.203880] Stack:
Jun 10 14:57:17 mithrandir kernel: [  266.203882]  ffffffffffffffe2 ffffea0003df9de8 0000000000000000 0000000000000e40
Jun 10 14:57:17 mithrandir kernel: [  266.203886]  ffff88010e5433d8 ffffffff8110af41 ffff88012e44fa50 ffff88012e44fa50
Jun 10 14:57:17 mithrandir kernel: [  266.203890]  ffff88010e543468 ffffffff81105a08 0000001f1e3d4508 ffff88010e5434f8
Jun 10 14:57:17 mithrandir kernel: [  266.203894] Call Trace:
Jun 10 14:57:17 mithrandir kernel: [  266.203900]  [<ffffffff8110af41>] ext3_journal_start_sb+0x45/0x50
Jun 10 14:57:17 mithrandir kernel: [  266.203904]  [<ffffffff81105a08>] ext3_write_begin+0x93/0x1a1
Jun 10 14:57:17 mithrandir kernel: [  266.203909]  [<ffffffff810867db>] ? get_pageblock_flags_group+0x3c/0x76
Jun 10 14:57:17 mithrandir kernel: [  266.203913]  [<ffffffff81082739>] generic_file_buffered_write+0xf9/0x236
Jun 10 14:57:17 mithrandir kernel: [  266.203918]  [<ffffffff810362ba>] ? current_fs_time+0x32/0x39
Jun 10 14:57:17 mithrandir kernel: [  266.203923]  [<ffffffff810834f2>] __generic_file_aio_write+0x240/0x270
Jun 10 14:57:17 mithrandir kernel: [  266.203927]  [<ffffffff8108357e>] generic_file_aio_write+0x5c/0xb5
Jun 10 14:57:17 mithrandir kernel: [  266.203931]  [<ffffffff810b1f96>] do_sync_write+0xba/0xfa
Jun 10 14:57:17 mithrandir kernel: [  266.203937]  [<ffffffff810c82c5>] ? vfsmount_lock_local_unlock+0x33/0x3e
Jun 10 14:57:17 mithrandir kernel: [  266.203942]  [<ffffffff8109b68d>] ? remove_vma+0x57/0x5f
Jun 10 14:57:17 mithrandir kernel: [  266.203947]  [<ffffffff8104e7bf>] ? timekeeping_get_ns+0x12/0x31
Jun 10 14:57:17 mithrandir kernel: [  266.203951]  [<ffffffff8104ec33>] ? ktime_get_ts+0x80/0x89
Jun 10 14:57:17 mithrandir kernel: [  266.203957]  [<ffffffff81063049>] do_acct_process+0x28c/0x2bf
Jun 10 14:57:17 mithrandir kernel: [  266.203962]  [<ffffffff8106366d>] acct_process+0x73/0x92
Jun 10 14:57:17 mithrandir kernel: [  266.203965]  [<ffffffff81034ffb>] do_exit+0x244/0x6da
Jun 10 14:57:17 mithrandir kernel: [  266.203969]  [<ffffffff810335bd>] ? kmsg_dump+0xcb/0xda
Jun 10 14:57:17 mithrandir kernel: [  266.203974]  [<ffffffff81004912>] oops_end+0x89/0x8e
Jun 10 14:57:17 mithrandir kernel: [  266.203978]  [<ffffffff81396abd>] no_context+0x1fe/0x20d
Jun 10 14:57:17 mithrandir kernel: [  266.203982]  [<ffffffff81396c5a>] __bad_area_nosemaphore+0x18e/0x1b1
Jun 10 14:57:17 mithrandir kernel: [  266.203985]  [<ffffffff8139e63a>] ? _raw_spin_unlock+0x1e/0x29
Jun 10 14:57:17 mithrandir kernel: [  266.203989]  [<ffffffff81396ccf>] bad_area+0x42/0x49
Jun 10 14:57:17 mithrandir kernel: [  266.203994]  [<ffffffff8101d9a3>] do_page_fault+0x1ab/0x308
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa024e0db>] ? free_extent_buffer+0x12/0x29 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa021a674>] ? read_block_for_search.isra.35+0x356/0x36b [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa021792f>] ? unlock_up+0xa7/0xcb [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff8139ec4f>] page_fault+0x1f/0x30
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa02276f9>] ? btrfs_print_leaf+0x17/0x75c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa0221862>] __btrfs_free_extent+0x24b/0x54f [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff8139e63a>] ? _raw_spin_unlock+0x1e/0x29
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa024ec12>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa0223d36>] run_clustered_refs+0x616/0x660 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff8139e63a>] ? _raw_spin_unlock+0x1e/0x29
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa02636a3>] ? btrfs_find_ref_cluster+0xf6/0x137 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa0223e4c>] btrfs_run_delayed_refs+0xcc/0x17c [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa0231a2f>] btrfs_commit_transaction+0x318/0x655 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810481cc>] ? add_wait_queue+0x44/0x44
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810d13d6>] ? __sync_filesystem+0x72/0x72
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffffa0216bd5>] btrfs_sync_fs+0x62/0x66 [btrfs]
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810d13c2>] __sync_filesystem+0x5e/0x72
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810d13e7>] sync_one_sb+0x11/0x13
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810b49ec>] iterate_supers+0x6a/0xbf
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff810d146e>] sys_sync+0x3d/0x4f
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  [<ffffffff8139f03b>] system_call_fastpath+0x16/0x1b
Jun 10 14:57:17 mithrandir kernel: [  266.204006] Code: 41 56 41 89 f6 41 55 49 89 fd 41 54 53 65 4c 8b 24 25 00 b6 00 00 48 85 ff 49 8b 9c 24 f8 04 00 00 74 7e 48 85 db 74 0f 48 8b 03 
Jun 10 14:57:17 mithrandir kernel: [  266.204006] RIP  [<ffffffff8111a212>] journal_start+0x2f/0xc1
Jun 10 14:57:17 mithrandir kernel: [  266.204006]  RSP <ffff88010e543398>
Jun 10 14:57:17 mithrandir kernel: [  266.204006] CR2: 00000000000015bd
Jun 10 14:57:17 mithrandir kernel: [  266.204503] ---[ end trace 757ecf6cb9e574ca ]---
Jun 10 14:57:17 mithrandir kernel: [  266.204506] Fixing recursive fault but reboot is needed!
Jun 10 14:57:18 mithrandir kernel: [  266.354243] btrfs no csum found for inode 321772 start 0
Jun 10 14:57:18 mithrandir kernel: [  266.354268] btrfs no csum found for inode 321772 start 4096
Jun 10 14:57:18 mithrandir kernel: [  266.354288] btrfs no csum found for inode 321772 start 8192
Jun 10 14:57:18 mithrandir kernel: [  266.354308] btrfs no csum found for inode 321772 start 12288
Jun 10 14:57:18 mithrandir kernel: [  266.354342] btrfs no csum found for inode 321772 start 0
Jun 10 14:57:18 mithrandir kernel: [  266.354372] btrfs no csum found for inode 321772 start 4096
Jun 10 14:57:18 mithrandir kernel: [  266.354401] btrfs no csum found for inode 321772 start 8192
Jun 10 14:57:18 mithrandir kernel: [  266.354430] btrfs no csum found for inode 321772 start 12288
Jun 10 14:57:18 mithrandir kernel: [  266.354463] btrfs no csum found for inode 321772 start 0
Jun 10 14:57:18 mithrandir kernel: [  266.354492] btrfs no csum found for inode 321772 start 0
Jun 10 14:58:05 mithrandir kernel: [  313.354163] SysRq : Emergency Sync
Jun 10 14:58:05 mithrandir kernel: [  313.354621] Emergency Sync complete
Jun 10 14:58:05 mithrandir kernel: [  313.558844] SysRq : Emergency Sync
Jun 10 14:58:05 mithrandir kernel: [  313.559388] Emergency Sync complete
Jun 10 14:58:05 mithrandir kernel: [  313.724442] SysRq : Emergency Sync
Jun 10 14:58:05 mithrandir kernel: [  313.724719] Emergency Sync complete
Jun 10 14:58:05 mithrandir kernel: [  313.968301] SysRq : Emergency Sync
Jun 10 14:58:05 mithrandir kernel: [  313.968769] Emergency Sync complete
Jun 10 14:58:06 mithrandir kernel: [  314.262330] SysRq : Emergency Sync
Jun 10 14:58:06 mithrandir kernel: [  314.262873] Emergency Sync complete
Jun 10 14:58:06 mithrandir kernel: [  314.432943] SysRq : Emergency Sync
Jun 10 14:58:06 mithrandir kernel: [  314.433519] Emergency Sync complete
Jun 10 14:58:06 mithrandir kernel: [  314.601535] SysRq : Emergency Remount R/O



And that was with the same kernel, without anything btrfs related,
just normal aptitude update run and browsing the web and reading
email with ssh/mutt.


Jun 11 10:58:42 mithrandir kernel: [  564.924468] ------------[ cut here ]------------
Jun 11 10:58:42 mithrandir kernel: [  564.924504] kernel BUG at fs/inode.c:1368!
Jun 11 10:58:42 mithrandir kernel: [  564.924527] invalid opcode: 0000 [#1] PREEMPT SMP 
Jun 11 10:58:42 mithrandir kernel: [  564.924562] CPU 1 
Jun 11 10:58:42 mithrandir kernel: [  564.924576] Modules linked in: rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi mxm_wmi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device firewire_ohci joydev snd firewire_core crc_itu_t iwlagn mac80211 cfg80211 sony_laptop rfkill tpm_infineon soundcore snd_page_alloc
Jun 11 10:58:42 mithrandir kernel: [  564.924965] 
Jun 11 10:58:42 mithrandir kernel: [  564.924977] Pid: 7463, comm: rm Not tainted 3.0.0-rc2+ #34 Sony Corporation VGN-Z11VN_B/VAIO
Jun 11 10:58:42 mithrandir kernel: [  564.925030] RIP: 0010:[<ffffffff810c5354>]  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 11 10:58:42 mithrandir kernel: [  564.925074] RSP: 0018:ffff8800adfcde48  EFLAGS: 00010202
Jun 11 10:58:42 mithrandir kernel: [  564.925104] RAX: 0000000000000000 RBX: ffff88009f58fa50 RCX: ffff880000000050
Jun 11 10:58:42 mithrandir kernel: [  564.925139] RDX: 0000000100010200 RSI: ffffffff8110a184 RDI: ffff88009f58fa50
Jun 11 10:58:42 mithrandir kernel: [  564.925175] RBP: ffff8800adfcde68 R08: 0000000000000000 R09: 0000000000000000
Jun 11 10:58:42 mithrandir kernel: [  564.925210] R10: ffff88012e8c6cf8 R11: ffff88013a46b600 R12: ffff880139abb6c0
Jun 11 10:58:42 mithrandir kernel: [  564.925245] R13: ffff88009f58fa50 R14: 0000000000000001 R15: ffff8800bb5bfe10
Jun 11 10:58:42 mithrandir kernel: [  564.925281] FS:  00007f9e67d0b700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 11 10:58:42 mithrandir kernel: [  564.925321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 11 10:58:42 mithrandir kernel: [  564.925350] CR2: 00000000013e2018 CR3: 00000000a5edd000 CR4: 00000000000006e0
Jun 11 10:58:42 mithrandir kernel: [  564.925386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 11 10:58:42 mithrandir kernel: [  564.925421] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 11 10:58:42 mithrandir kernel: [  564.925457] Process rm (pid: 7463, threadinfo ffff8800adfcc000, task ffff88013f5f0b30)
Jun 11 10:58:42 mithrandir kernel: [  564.925497] Stack:
Jun 11 10:58:42 mithrandir kernel: [  564.925509]  ffffffff8110a184 ffff88009f8fb240 ffff880139abb6c0 ffff88009f58fa50
Jun 11 10:58:42 mithrandir kernel: [  564.925555]  ffff8800adfcde98 ffffffff810c26a7 ffff88009f8fb240 ffff88009f8fb29c
Jun 11 10:58:42 mithrandir kernel: [  564.925600]  ffff88009f58fa50 ffff88009f8fb240 ffff8800adfcdec8 ffffffff810c2bf5
Jun 11 10:58:42 mithrandir kernel: [  564.925646] Call Trace:
Jun 11 10:58:42 mithrandir kernel: [  564.925662]  [<ffffffff8110a184>] ? ext3_destroy_inode+0x8b/0x8b
Jun 11 10:58:42 mithrandir kernel: [  564.925695]  [<ffffffff810c26a7>] dentry_kill+0x122/0x144
Jun 11 10:58:42 mithrandir kernel: [  564.925723]  [<ffffffff810c2bf5>] dput+0xda/0xeb
Jun 11 10:58:42 mithrandir kernel: [  564.925749]  [<ffffffff810b3999>] fput+0x18d/0x1a5
Jun 11 10:58:42 mithrandir kernel: [  564.925775]  [<ffffffff810b0bfc>] filp_close+0x69/0x75
Jun 11 10:58:42 mithrandir kernel: [  564.925802]  [<ffffffff810b0cb0>] sys_close+0xa8/0xea
Jun 11 10:58:42 mithrandir kernel: [  564.925830]  [<ffffffff8139f03b>] system_call_fastpath+0x16/0x1b
Jun 11 10:58:42 mithrandir kernel: [  564.925861] Code: fe ff ff 48 8b 03 48 39 d8 75 da 58 5b 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 56 0f 84 2b 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 02 f6 08 00 85 c0 0f 
Jun 11 10:58:42 mithrandir kernel: [  564.926111] RIP  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 11 10:58:42 mithrandir kernel: [  564.926142]  RSP <ffff8800adfcde48>
Jun 11 10:58:42 mithrandir kernel: [  564.945053] ---[ end trace 4a6eb3e9afabf726 ]---
Jun 11 10:58:43 mithrandir kernel: [  565.068687] ------------[ cut here ]------------
Jun 11 10:58:43 mithrandir kernel: [  565.068719] kernel BUG at fs/inode.c:1368!
Jun 11 10:58:43 mithrandir kernel: [  565.070455] invalid opcode: 0000 [#2] PREEMPT SMP 
Jun 11 10:58:43 mithrandir kernel: [  565.072005] CPU 1 
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Modules linked in: rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi mxm_wmi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device firewire_ohci joydev snd firewire_core crc_itu_t iwlagn mac80211 cfg80211 sony_laptop rfkill tpm_infineon soundcore snd_page_alloc
Jun 11 10:58:43 mithrandir kernel: [  565.072005] 
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Pid: 7466, comm: rm Tainted: G      D     3.0.0-rc2+ #34 Sony Corporation VGN-Z11VN_B/VAIO
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RIP: 0010:[<ffffffff810c5354>]  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RSP: 0018:ffff8800a5cbfe48  EFLAGS: 00010202
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RAX: 0000000000000000 RBX: ffff88009d584a50 RCX: ffff880000000050
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RDX: 0000000100010200 RSI: ffffffff8110a184 RDI: ffff88009d584a50
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RBP: ffff8800a5cbfe68 R08: 0000000000000000 R09: 0000000000000000
Jun 11 10:58:43 mithrandir kernel: [  565.072005] R10: ffff88012e8c6cf8 R11: ffff88013a46b600 R12: ffff8800bb002440
Jun 11 10:58:43 mithrandir kernel: [  565.072005] R13: ffff88009d584a50 R14: 0000000000000001 R15: ffff8800bb519250
Jun 11 10:58:43 mithrandir kernel: [  565.072005] FS:  00007fa577401700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 11 10:58:43 mithrandir kernel: [  565.072005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 11 10:58:43 mithrandir kernel: [  565.072005] CR2: 00000000018dd078 CR3: 00000000bb71e000 CR4: 00000000000006e0
Jun 11 10:58:43 mithrandir kernel: [  565.072005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 11 10:58:43 mithrandir kernel: [  565.072005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Process rm (pid: 7466, threadinfo ffff8800a5cbe000, task ffff88013f49a040)
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Stack:
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  ffffffff8110a184 ffff88009d581ec0 ffff8800bb002440 ffff88009d584a50
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  ffff8800a5cbfe98 ffffffff810c26a7 ffff88009d581ec0 ffff88009d581f1c
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  ffff88009d584a50 ffff88009d581ec0 ffff8800a5cbfec8 ffffffff810c2bf5
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Call Trace:
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff8110a184>] ? ext3_destroy_inode+0x8b/0x8b
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff810c26a7>] dentry_kill+0x122/0x144
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff810c2bf5>] dput+0xda/0xeb
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff810b3999>] fput+0x18d/0x1a5
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff810b0bfc>] filp_close+0x69/0x75
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff810b0cb0>] sys_close+0xa8/0xea
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  [<ffffffff8139f03b>] system_call_fastpath+0x16/0x1b
Jun 11 10:58:43 mithrandir kernel: [  565.072005] Code: fe ff ff 48 8b 03 48 39 d8 75 da 58 5b 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 56 0f 84 2b 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 02 f6 08 00 85 c0 0f 
Jun 11 10:58:43 mithrandir kernel: [  565.072005] RIP  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 11 10:58:43 mithrandir kernel: [  565.072005]  RSP <ffff8800a5cbfe48>
Jun 11 10:58:43 mithrandir kernel: [  565.133844] ---[ end trace 4a6eb3e9afabf727 ]---
Jun 11 10:59:18 mithrandir dbus[2209]: [system] Failed to activate service 'org.freedesktop.Avahi': timed out
Jun 11 10:59:38 mithrandir kernel: [  620.107657] SysRq : Emergency Sync
Jun 11 10:59:38 mithrandir kernel: [  620.523102] SysRq : Emergency Sync
Jun 11 10:59:38 mithrandir kernel: [  620.646745] ------------[ cut here ]------------
Jun 11 10:59:38 mithrandir kernel: [  620.646753] WARNING: at fs/fs-writeback.c:356 writeback_single_inode+0x60/0x1c5()
Jun 11 10:59:38 mithrandir kernel: [  620.646755] Hardware name: VGN-Z11VN_B
Jun 11 10:59:38 mithrandir kernel: [  620.646756] Modules linked in: rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi mxm_wmi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device firewire_ohci joydev snd firewire_core crc_itu_t iwlagn mac80211 cfg80211 sony_laptop rfkill tpm_infineon soundcore snd_page_alloc
Jun 11 10:59:38 mithrandir kernel: [  620.646797] Pid: 2263, comm: flush-8:0 Tainted: G      D     3.0.0-rc2+ #34
Jun 11 10:59:38 mithrandir kernel: [  620.646799] Call Trace:
Jun 11 10:59:38 mithrandir kernel: [  620.646803]  [<ffffffff81032061>] warn_slowpath_common+0x7e/0x96
Jun 11 10:59:38 mithrandir kernel: [  620.646806]  [<ffffffff8103208e>] warn_slowpath_null+0x15/0x17
Jun 11 10:59:38 mithrandir kernel: [  620.646808]  [<ffffffff810cdd26>] writeback_single_inode+0x60/0x1c5
Jun 11 10:59:38 mithrandir kernel: [  620.646811]  [<ffffffff810cdfd8>] writeback_sb_inodes+0xc4/0x14c
Jun 11 10:59:38 mithrandir kernel: [  620.646814]  [<ffffffff810ce5a7>] wb_writeback+0x18b/0x253
Jun 11 10:59:38 mithrandir kernel: [  620.646818]  [<ffffffff81025b50>] ? finish_task_switch+0x7e/0xaa
Jun 11 10:59:38 mithrandir kernel: [  620.646820]  [<ffffffff810ce6bf>] wb_do_writeback+0x50/0x161
Jun 11 10:59:38 mithrandir kernel: [  620.646824]  [<ffffffff8139e665>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
Jun 11 10:59:38 mithrandir kernel: [  620.646827]  [<ffffffff8103c036>] ? del_timer+0x6b/0x79
Jun 11 10:59:38 mithrandir kernel: [  620.646830]  [<ffffffff810ce83d>] bdi_writeback_thread+0x6d/0x151
Jun 11 10:59:38 mithrandir kernel: [  620.646833]  [<ffffffff810ce7d0>] ? wb_do_writeback+0x161/0x161
Jun 11 10:59:38 mithrandir kernel: [  620.646836]  [<ffffffff81047bb0>] kthread+0x7f/0x87
Jun 11 10:59:38 mithrandir kernel: [  620.646839]  [<ffffffff8139fd54>] kernel_thread_helper+0x4/0x10
Jun 11 10:59:38 mithrandir kernel: [  620.646842]  [<ffffffff81047b31>] ? kthread_worker_fn+0x141/0x141
Jun 11 10:59:38 mithrandir kernel: [  620.646844]  [<ffffffff8139fd50>] ? gs_change+0xb/0xb
Jun 11 10:59:38 mithrandir kernel: [  620.646846] ---[ end trace 4a6eb3e9afabf728 ]---


Let me know if you need more information.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WILLIMANTIC (adj.)
Of a person whose hearth is in the wrong place (i.e. between their
legs).
			--- Douglas Adams, The Meaning of Liff
