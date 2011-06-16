From: Norbert Preining <preining@logic.at>
Subject: Re: another ext3 kernel BUG
Date: Thu, 16 Jun 2011 14:51:25 +0900
Message-ID: <20110616055125.GB23083@gamma.logic.tuwien.ac.at>
References: <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <20110614040313.GA6618@gamma.logic.tuwien.ac.at> <20110615012349.GA19098@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40866 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1FPFv2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2011 01:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20110615012349.GA19098@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mi, 15 Jun 2011, Norbert Preining wrote:
> CONFIG_LIST_DEBUG is compiled in.
> vbox modules are *not* loaded

new instance, this time again in fs/inode.c, but coming from fsnotify,
and one from ntfs3g.

When I go to 3.0-rc1 all is fine.

I will try to get a git bisect running, but that is a pain because
it is not easy to trigger.

Any suggestion what could be the culprit? 3cebde241 ?


Jun 16 14:30:21 mithrandir kernel: [19059.592663] ------------[ cut here ]------------
Jun 16 14:30:21 mithrandir kernel: [19059.592702] kernel BUG at fs/inode.c:1368!
Jun 16 14:30:21 mithrandir kernel: [19059.592732] invalid opcode: 0000 [#1] PREEMPT SMP 
Jun 16 14:30:21 mithrandir kernel: [19059.592771] CPU 1 
Jun 16 14:30:21 mithrandir kernel: [19059.592784] Modules linked in: usb_storage rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput hso arc4 snd_hda_codec_realtek btusb snd_hda_intel bluetooth snd_hda_codec iwlagn snd_hwdep snd_pcm_oss crc16 mac80211 snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi cfg80211 snd_seq_midi_event snd_seq snd_timer snd_seq_device snd firewire_ohci sony_laptop soundcore firewire_core snd_page_alloc crc_itu_t tpm_infineon joydev rfkill mxm_wmi
Jun 16 14:30:21 mithrandir kernel: [19059.593141] 
Jun 16 14:30:21 mithrandir kernel: [19059.593152] Pid: 544, comm: kswapd0 Not tainted 3.0.0-rc3+ #2 Sony Corporation VGN-Z11VN_B/VAIO
Jun 16 14:30:21 mithrandir kernel: [19059.593203] RIP: 0010:[<ffffffff810c43c5>]  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 16 14:30:21 mithrandir kernel: [19059.593248] RSP: 0018:ffff88013b025b40  EFLAGS: 00010202
Jun 16 14:30:21 mithrandir kernel: [19059.593277] RAX: ffff88012a7e3bc0 RBX: ffff880120f68430 RCX: 0000000000000017
Jun 16 14:30:21 mithrandir kernel: [19059.593314] RDX: 0000000000000000 RSI: ffff880100000050 RDI: ffff880120f68430
Jun 16 14:30:21 mithrandir kernel: [19059.593350] RBP: ffff88013b025b60 R08: 0000000000000000 R09: 0000000000000017
Jun 16 14:30:21 mithrandir kernel: [19059.593387] R10: ffff88012801a780 R11: 0000000000013858 R12: ffff8801275960c0
Jun 16 14:30:21 mithrandir kernel: [19059.593424] R13: ffff880120f68430 R14: ffff8800bb4940c0 R15: ffff8800bb4940b0
Jun 16 14:30:21 mithrandir kernel: [19059.593460] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 16 14:30:21 mithrandir kernel: [19059.593503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 16 14:30:21 mithrandir kernel: [19059.593533] CR2: 00000000023deb81 CR3: 0000000119cfb000 CR4: 00000000000006e0
Jun 16 14:30:21 mithrandir kernel: [19059.593570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 14:30:21 mithrandir kernel: [19059.593607] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 16 14:30:21 mithrandir kernel: [19059.593644] Process kswapd0 (pid: 544, threadinfo ffff88013b024000, task ffff88013f6386b0)
Jun 16 14:30:21 mithrandir kernel: [19059.593686] Stack:
Jun 16 14:30:21 mithrandir kernel: [19059.593699]  ffff88012a7e3bc0 ffff8800bb4940a0 ffff8801275960c0 ffff880120f68430
Jun 16 14:30:21 mithrandir kernel: [19059.593747]  ffff88013b025bb0 ffffffff810db540 ffff88013b025bc0 ffff880127596124
Jun 16 14:30:21 mithrandir kernel: [19059.593794]  ffff88013b025bb0 ffff8800bb4940a0 ffff88013b025b80 ffff88013b025bc0
Jun 16 14:30:21 mithrandir kernel: [19059.593841] Call Trace:
Jun 16 14:30:21 mithrandir kernel: [19059.593859]  [<ffffffff810db540>] fsnotify_destroy_mark+0x115/0x139
Jun 16 14:30:21 mithrandir kernel: [19059.593893]  [<ffffffff810daf23>] fsnotify_clear_marks_by_inode+0xa3/0xcf
Jun 16 14:30:21 mithrandir kernel: [19059.593928]  [<ffffffff810da0a1>] __fsnotify_inode_delete+0x9/0xb
Jun 16 14:30:21 mithrandir kernel: [19059.593961]  [<ffffffff810c4160>] __destroy_inode+0x1d/0x55
Jun 16 14:30:21 mithrandir kernel: [19059.593989]  [<ffffffff810c41b3>] destroy_inode+0x1b/0x4b
Jun 16 14:30:21 mithrandir kernel: [19059.594018]  [<ffffffff810c4365>] evict+0x110/0x119
Jun 16 14:30:21 mithrandir kernel: [19059.594044]  [<ffffffff810c4398>] dispose_list+0x2a/0x3b
Jun 16 14:30:21 mithrandir kernel: [19059.594072]  [<ffffffff810c47a0>] shrink_icache_memory+0x242/0x272
Jun 16 14:30:21 mithrandir kernel: [19059.594106]  [<ffffffff8108b8bb>] shrink_slab+0xed/0x15e
Jun 16 14:30:21 mithrandir kernel: [19059.594135]  [<ffffffff8108d3f0>] balance_pgdat+0x279/0x4ff
Jun 16 14:30:21 mithrandir kernel: [19059.594165]  [<ffffffff8108d874>] kswapd+0x1fe/0x217
Jun 16 14:30:21 mithrandir kernel: [19059.594194]  [<ffffffff81047faa>] ? remove_wait_queue+0x35/0x35
Jun 16 14:30:21 mithrandir kernel: [19059.594225]  [<ffffffff8108d676>] ? balance_pgdat+0x4ff/0x4ff
Jun 16 14:30:21 mithrandir kernel: [19059.594255]  [<ffffffff810479ce>] kthread+0x7f/0x87
Jun 16 14:30:21 mithrandir kernel: [19059.594283]  [<ffffffff8139c254>] kernel_thread_helper+0x4/0x10
Jun 16 14:30:21 mithrandir kernel: [19059.594314]  [<ffffffff8104794f>] ? kthread_worker_fn+0x143/0x143
Jun 16 14:30:21 mithrandir kernel: [19059.594346]  [<ffffffff8139c250>] ? gs_change+0xb/0xb
Jun 16 14:30:21 mithrandir kernel: [19059.594372] Code: 1c 24 4c 39 e3 75 dc 58 5b 41 5c 41 5d 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 50 0f 84 1d 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 3d eb 08 00 85 c0 0f 
Jun 16 14:30:21 mithrandir kernel: [19059.594621] RIP  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 16 14:30:21 mithrandir kernel: [19059.594652]  RSP <ffff88013b025b40>
Jun 16 14:30:21 mithrandir kernel: [19059.624619] ---[ end trace abed2640ce3aad65 ]---
Jun 16 14:30:24 mithrandir kernel: [19062.204833] ------------[ cut here ]------------
Jun 16 14:30:24 mithrandir kernel: [19062.206546] kernel BUG at fs/inode.c:1368!
Jun 16 14:30:24 mithrandir kernel: [19062.208004] invalid opcode: 0000 [#2] PREEMPT SMP 
Jun 16 14:30:24 mithrandir kernel: [19062.208004] CPU 1 
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Modules linked in: usb_storage rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput hso arc4 snd_hda_codec_realtek btusb snd_hda_intel bluetooth snd_hda_codec iwlagn snd_hwdep snd_pcm_oss crc16 mac80211 snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi cfg80211 snd_seq_midi_event snd_seq snd_timer snd_seq_device snd firewire_ohci sony_laptop soundcore firewire_core snd_page_alloc crc_itu_t tpm_infineon joydev rfkill mxm_wmi
Jun 16 14:30:24 mithrandir kernel: [19062.208004] 
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Pid: 1731, comm: mount.ntfs-3g Tainted: G      D     3.0.0-rc3+ #2 Sony Corporation VGN-Z11VN_B/VAIO
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RIP: 0010:[<ffffffff810c43c5>]  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RSP: 0018:ffff880128a87768  EFLAGS: 00010202
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RAX: ffff88012a7e3bc0 RBX: ffff880120f64d60 RCX: 00000000ffffffff
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RDX: ffff8801340dab00 RSI: ffff880100000050 RDI: ffff880120f64d60
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RBP: ffff880128a87788 R08: 0000000000000000 R09: 0000000000000016
Jun 16 14:30:24 mithrandir kernel: [19062.208004] R10: ffff88012801a780 R11: ffff880120f64d60 R12: ffff8801275960c0
Jun 16 14:30:24 mithrandir kernel: [19062.208004] R13: ffff880120f64d60 R14: ffff8800bb494f18 R15: ffff8800bb494f08
Jun 16 14:30:24 mithrandir kernel: [19062.208004] FS:  00007f11d3b69700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 16 14:30:24 mithrandir kernel: [19062.208004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 16 14:30:24 mithrandir kernel: [19062.208004] CR2: 00007f928f242000 CR3: 0000000128af1000 CR4: 00000000000006e0
Jun 16 14:30:24 mithrandir kernel: [19062.208004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 14:30:24 mithrandir kernel: [19062.208004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Process mount.ntfs-3g (pid: 1731, threadinfo ffff880128a86000, task ffff88012a953610)
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Stack:
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  ffff88012a7e3bc0 ffff8800bb494ef8 ffff8801275960c0 ffff880120f64d60
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  ffff880128a877d8 ffffffff810db540 ffff880128a877e8 ffff880127596124
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  ffff880128a877d8 ffff8800bb494ef8 ffff880128a877a8 ffff880128a877e8
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Call Trace:
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810db540>] fsnotify_destroy_mark+0x115/0x139
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810daf23>] fsnotify_clear_marks_by_inode+0xa3/0xcf
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810da0a1>] __fsnotify_inode_delete+0x9/0xb
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810c4160>] __destroy_inode+0x1d/0x55
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810c41b3>] destroy_inode+0x1b/0x4b
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810c4365>] evict+0x110/0x119
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810c4398>] dispose_list+0x2a/0x3b
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810c47a0>] shrink_icache_memory+0x242/0x272
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8108b8bb>] shrink_slab+0xed/0x15e
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8108d9e1>] do_try_to_free_pages+0x154/0x294
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8108dc3b>] try_to_free_pages+0x71/0x73
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff81087b22>] __alloc_pages_nodemask+0x449/0x64f
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810892aa>] __do_page_cache_readahead+0xd6/0x1d4
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff81020e80>] ? get_user_pages_fast+0xc0/0x15c
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810895de>] ra_submit+0x1c/0x20
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810897cb>] ondemand_readahead+0x1e9/0x1f8
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff81081aa1>] ? unlock_page+0x23/0x28
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8108984e>] page_cache_async_readahead+0x74/0x7d
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff81081969>] ? find_get_page+0x5e/0x6a
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8108307d>] generic_file_aio_read+0x2d5/0x640
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810b1298>] do_sync_read+0xba/0xfa
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810b102c>] ? fsnotify_access+0x5a/0x62
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810b18a4>] vfs_read+0xa4/0xeb
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810b286f>] ? fget_light+0x3b/0x9a
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff810b1a12>] sys_pread64+0x55/0x71
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  [<ffffffff8139b53b>] system_call_fastpath+0x16/0x1b
Jun 16 14:30:24 mithrandir kernel: [19062.208004] Code: 1c 24 4c 39 e3 75 dc 58 5b 41 5c 41 5d 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 50 0f 84 1d 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 3d eb 08 00 85 c0 0f 
Jun 16 14:30:24 mithrandir kernel: [19062.208004] RIP  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 16 14:30:24 mithrandir kernel: [19062.208004]  RSP <ffff880128a87768>
Jun 16 14:30:24 mithrandir kernel: [19062.299782] ---[ end trace abed2640ce3aad66 ]---


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HUMBY (n.)
An erection which won't go down when a gentleman has to go for a pee
in the middle of making love to someone.
			--- Douglas Adams, The Meaning of Liff
