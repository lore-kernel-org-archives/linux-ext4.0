From: Norbert Preining <preining@logic.at>
Subject: another ext3 kernel BUG
Date: Tue, 14 Jun 2011 10:19:04 +0900
Message-ID: <20110614011904.GA32521@gamma.logic.tuwien.ac.at>
References: <20110611021732.GA18768@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110611021732.GA18768@gamma.logic.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(please cc)

As already reported 2 times, here another BUG that occurs agian and
again when doing heavy IO stuff (aptitude update plus kernel compile eg).

Jun 14 09:52:59 mithrandir kernel: [14128.489923] ------------[ cut here ]------------
Jun 14 09:52:59 mithrandir kernel: [14128.489957] kernel BUG at fs/inode.c:1368!
Jun 14 09:52:59 mithrandir kernel: [14128.489980] invalid opcode: 0000 [#1] PREEMPT SMP 
Jun 14 09:52:59 mithrandir kernel: [14128.490012] CPU 0 
Jun 14 09:52:59 mithrandir kernel: [14128.490025] Modules linked in: rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek arc4 snd_hda_intel iwlagn snd_hda_codec mac80211 snd_hwdep cfg80211 snd_pcm_oss snd_mixer_oss snd_pcm hso snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sony_laptop snd btusb bluetooth crc16 rfkill soundcore snd_page_alloc joydev firewire_ohci firewire_core mxm_wmi crc_itu_t tpm_infineon
Jun 14 09:52:59 mithrandir kernel: [14128.490389] 
Jun 14 09:52:59 mithrandir kernel: [14128.490401] Pid: 10687, comm: rm Not tainted 3.0.0-rc2+ #35 Sony Corporation VGN-Z11VN_B/VAIO
Jun 14 09:52:59 mithrandir kernel: [14128.490449] RIP: 0010:[<ffffffff810c5354>]  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 14 09:52:59 mithrandir kernel: [14128.490493] RSP: 0018:ffff8801324cbe48  EFLAGS: 00010202
Jun 14 09:52:59 mithrandir kernel: [14128.490521] RAX: 0000000000000000 RBX: ffff88005f6eda50 RCX: ffff880100000050
Jun 14 09:52:59 mithrandir kernel: [14128.490556] RDX: 000000010034c000 RSI: ffffffff8110a184 RDI: ffff88005f6eda50
Jun 14 09:52:59 mithrandir kernel: [14128.490592] RBP: ffff8801324cbe68 R08: 000000000000000b R09: 0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.490627] R10: ffff88010e9e4818 R11: ffff88013a4ffc00 R12: ffff88004fb03380
Jun 14 09:52:59 mithrandir kernel: [14128.490662] R13: ffff88005f6eda50 R14: 0000000000000001 R15: ffff88003d4e4510
Jun 14 09:52:59 mithrandir kernel: [14128.490698] FS:  00007fd842776700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.490740] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 14 09:52:59 mithrandir kernel: [14128.490769] CR2: 0000000000408080 CR3: 0000000132951000 CR4: 00000000000006f0
Jun 14 09:52:59 mithrandir kernel: [14128.490805] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.490840] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 14 09:52:59 mithrandir kernel: [14128.490876] Process rm (pid: 10687, threadinfo ffff8801324ca000, task ffff8800229b89b0)
Jun 14 09:52:59 mithrandir kernel: [14128.490915] Stack:
Jun 14 09:52:59 mithrandir kernel: [14128.490927]  ffffffff8110a184 ffff880101d9bcc0 ffff88004fb03380 ffff88005f6eda50
Jun 14 09:52:59 mithrandir kernel: [14128.490973]  ffff8801324cbe98 ffffffff810c26a7 ffff880101d9bcc0 ffff880101d9bd1c
Jun 14 09:52:59 mithrandir kernel: [14128.491019]  ffff88005f6eda50 ffff880101d9bcc0 ffff8801324cbec8 ffffffff810c2bf5
Jun 14 09:52:59 mithrandir kernel: [14128.491064] Call Trace:
Jun 14 09:52:59 mithrandir kernel: [14128.491080]  [<ffffffff8110a184>] ? ext3_destroy_inode+0x8b/0x8b
Jun 14 09:52:59 mithrandir kernel: [14128.491114]  [<ffffffff810c26a7>] dentry_kill+0x122/0x144
Jun 14 09:52:59 mithrandir kernel: [14128.491143]  [<ffffffff810c2bf5>] dput+0xda/0xeb
Jun 14 09:52:59 mithrandir kernel: [14128.491169]  [<ffffffff810b3999>] fput+0x18d/0x1a5
Jun 14 09:52:59 mithrandir kernel: [14128.491195]  [<ffffffff810b0bfc>] filp_close+0x69/0x75
Jun 14 09:52:59 mithrandir kernel: [14128.491223]  [<ffffffff810b0cb0>] sys_close+0xa8/0xea
Jun 14 09:52:59 mithrandir kernel: [14128.491251]  [<ffffffff8139f07b>] system_call_fastpath+0x16/0x1b
Jun 14 09:52:59 mithrandir kernel: [14128.491282] Code: fe ff ff 48 8b 03 48 39 d8 75 da 58 5b 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 56 0f 84 2b 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 02 f6 08 00 85 c0 0f 
Jun 14 09:52:59 mithrandir kernel: [14128.491533] RIP  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 14 09:52:59 mithrandir kernel: [14128.491563]  RSP <ffff8801324cbe48>
Jun 14 09:52:59 mithrandir kernel: [14128.513847] ---[ end trace ebb3cd31d1ade445 ]---
Jun 14 09:52:59 mithrandir kernel: [14128.696044] ------------[ cut here ]------------
Jun 14 09:52:59 mithrandir kernel: [14128.697889] kernel BUG at fs/inode.c:1368!
Jun 14 09:52:59 mithrandir kernel: [14128.699685] invalid opcode: 0000 [#2] PREEMPT SMP 
Jun 14 09:52:59 mithrandir kernel: [14128.700009] CPU 0 
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Modules linked in: rfcomm bnep snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek arc4 snd_hda_intel iwlagn snd_hda_codec mac80211 snd_hwdep cfg80211 snd_pcm_oss snd_mixer_oss snd_pcm hso snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sony_laptop snd btusb bluetooth crc16 rfkill soundcore snd_page_alloc joydev firewire_ohci firewire_core mxm_wmi crc_itu_t tpm_infineon
Jun 14 09:52:59 mithrandir kernel: [14128.700009] 
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Pid: 10704, comm: rm Tainted: G      D     3.0.0-rc2+ #35 Sony Corporation VGN-Z11VN_B/VAIO
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RIP: 0010:[<ffffffff810c5354>]  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RSP: 0000:ffff88011454fe48  EFLAGS: 00010202
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RAX: 0000000000000000 RBX: ffff8800ab6e7740 RCX: ffff880100000050
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RDX: 000000010034c000 RSI: ffffffff8110a184 RDI: ffff8800ab6e7740
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RBP: ffff88011454fe68 R08: 0000000000000000 R09: 0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.700009] R10: ffff88010e9e4818 R11: ffff88013a4ffc00 R12: ffff8800938e1200
Jun 14 09:52:59 mithrandir kernel: [14128.700009] R13: ffff8800ab6e7740 R14: 0000000000000001 R15: ffff880025fbf5d0
Jun 14 09:52:59 mithrandir kernel: [14128.700009] FS:  00007f16ab273700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.700009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 14 09:52:59 mithrandir kernel: [14128.700009] CR2: 00002adf57a41000 CR3: 00000001328dc000 CR4: 00000000000006f0
Jun 14 09:52:59 mithrandir kernel: [14128.700009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 14 09:52:59 mithrandir kernel: [14128.700009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Process rm (pid: 10704, threadinfo ffff88011454e000, task ffff88000f4be970)
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Stack:
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  ffffffff8110a184 ffff88004fb03140 ffff8800938e1200 ffff8800ab6e7740
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  ffff88011454fe98 ffffffff810c26a7 ffff88004fb03140 ffff88004fb0319c
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  ffff8800ab6e7740 ffff88004fb03140 ffff88011454fec8 ffffffff810c2bf5
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Call Trace:
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff8110a184>] ? ext3_destroy_inode+0x8b/0x8b
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff810c26a7>] dentry_kill+0x122/0x144
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff810c2bf5>] dput+0xda/0xeb
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff810b3999>] fput+0x18d/0x1a5
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff810b0bfc>] filp_close+0x69/0x75
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff810b0cb0>] sys_close+0xa8/0xea
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  [<ffffffff8139f07b>] system_call_fastpath+0x16/0x1b
Jun 14 09:52:59 mithrandir kernel: [14128.700009] Code: fe ff ff 48 8b 03 48 39 d8 75 da 58 5b 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89 fb 56 0f 84 2b 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf b0 00 00 00 e8 02 f6 08 00 85 c0 0f 
Jun 14 09:52:59 mithrandir kernel: [14128.700009] RIP  [<ffffffff810c5354>] iput+0x1c/0x149
Jun 14 09:52:59 mithrandir kernel: [14128.700009]  RSP <ffff88011454fe48>
Jun 14 09:52:59 mithrandir kernel: [14128.768256] ---[ end trace ebb3cd31d1ade446 ]---


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
FOVANT (n.)
A taxi driver's gesture, a raised hand pointed out of the window which
purports to mean 'thank you' and actually means 'fuck off out of the
way'.
			--- Douglas Adams, The Meaning of Liff
