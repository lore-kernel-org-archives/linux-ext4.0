From: Norbert Preining <preining@logic.at>
Subject: Re: another ext3 kernel BUG
Date: Wed, 15 Jun 2011 10:23:49 +0900
Message-ID: <20110615012349.GA19098@gamma.logic.tuwien.ac.at>
References: <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <20110614040313.GA6618@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47137 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1FOBXw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 21:23:52 -0400
Content-Disposition: inline
In-Reply-To: <20110614040313.GA6618@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

here we go again.

On Di, 14 Jun 2011, Norbert Preining wrote:
> > we've been getting a lot of bug reports in Fedora that have the vbo=
x module
> > loaded that manifest in various ways that look like it's corrupting=
 kernel data
> > structures. (Usually it scribbles over some linked list, and the CO=
NFIG_LIST_DEBUG
> > stuff catches it).
>=20
> Ahh, ok. I thought that if the modules are loaded but NOT in use,
> in the sense no vbox is running, then they cannot do much harm.
> At the end it was always on heavy IO load without any vbox interactio=
n.
>=20
> But I will recompile with CONFIG_LIST_DEBUG and see what comes out.

CONFIG_LIST_DEBUG is compiled in.
vbox modules are *not* loaded
again BUG (there is a funny last line ...)
this is with rc3

Jun 15 10:12:16 mithrandir kernel: [24645.387482] ------------[ cut her=
e ]------------
Jun 15 10:12:16 mithrandir kernel: [24645.387516] kernel BUG at fs/inod=
e.c:1368!
Jun 15 10:12:16 mithrandir kernel: [24645.387539] invalid opcode: 0000 =
[#1] PREEMPT SMP=20
Jun 15 10:12:16 mithrandir kernel: [24645.387572] CPU 0=20
Jun 15 10:12:16 mithrandir kernel: [24645.387584] Modules linked in: rf=
comm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_defl=
ate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek sn=
d_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss hso arc4 snd_mixer_oss =
snd_pcm snd_seq_dummy snd_seq_oss iwlagn btusb snd_seq_midi bluetooth s=
nd_rawmidi mac80211 crc16 snd_seq_midi_event snd_seq snd_timer snd_seq_=
device snd cfg80211 soundcore firewire_ohci firewire_core snd_page_allo=
c sony_laptop tpm_infineon rfkill crc_itu_t joydev mxm_wmi
Jun 15 10:12:16 mithrandir kernel: [24645.387925]=20
Jun 15 10:12:16 mithrandir kernel: [24645.387936] Pid: 15175, comm: rm =
Not tainted 3.0.0-rc3+ #2 Sony Corporation VGN-Z11VN_B/VAIO
Jun 15 10:12:16 mithrandir kernel: [24645.387986] RIP: 0010:[<ffffffff8=
10c43c5>]  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 15 10:12:16 mithrandir kernel: [24645.388029] RSP: 0018:ffff88013a5=
abe48  EFLAGS: 00010202
Jun 15 10:12:16 mithrandir kernel: [24645.388057] RAX: 0000000000000000=
 RBX: ffff88010946ca50 RCX: 0000000000000036
Jun 15 10:12:16 mithrandir kernel: [24645.388093] RDX: 00000001005cde00=
 RSI: ffffffff81108be8 RDI: ffff88010946ca50
Jun 15 10:12:16 mithrandir kernel: [24645.388129] RBP: ffff88013a5abe68=
 R08: 0000000000000000 R09: ffff88012b8bca20
Jun 15 10:12:16 mithrandir kernel: [24645.388169] R10: ffff88012b8bca20=
 R11: ffff88013a4d9600 R12: ffff8800969349c0
Jun 15 10:12:16 mithrandir kernel: [24645.388203] R13: ffff88010946ca50=
 R14: ffff88011787c5f0 R15: ffff88009f122c10
Jun 15 10:12:16 mithrandir kernel: [24645.388237] FS:  00007f5fc4b74700=
(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 15 10:12:16 mithrandir kernel: [24645.388276] CS:  0010 DS: 0000 ES=
: 0000 CR0: 0000000080050033
Jun 15 10:12:16 mithrandir kernel: [24645.388304] CR2: 000000000065b018=
 CR3: 0000000101e6d000 CR4: 00000000000006f0
Jun 15 10:12:16 mithrandir kernel: [24645.388338] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Jun 15 10:12:16 mithrandir kernel: [24645.388373] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 15 10:12:16 mithrandir kernel: [24645.388407] Process rm (pid: 1517=
5, threadinfo ffff88013a5aa000, task ffff880130d550e0)
Jun 15 10:12:16 mithrandir kernel: [24645.388444] Stack:
Jun 15 10:12:16 mithrandir kernel: [24645.388456]  0000000000000000 fff=
f88011787c540 ffff8800969349c0 ffff88010946ca50
Jun 15 10:12:16 mithrandir kernel: [24645.388501]  ffff88013a5abe98 fff=
fffff810c17cc ffff88011787c540 ffff88011787c59c
Jun 15 10:12:16 mithrandir kernel: [24645.388545]  ffff88010946ca50 fff=
f88011787c540 ffff88013a5abec8 ffffffff810c1ce1
Jun 15 10:12:16 mithrandir kernel: [24645.388589] Call Trace:
Jun 15 10:12:16 mithrandir kernel: [24645.388605]  [<ffffffff810c17cc>]=
 dentry_kill+0x115/0x137
Jun 15 10:12:16 mithrandir kernel: [24645.388632]  [<ffffffff810c1ce1>]=
 dput+0xbf/0xd0
Jun 15 10:12:16 mithrandir kernel: [24645.388658]  [<ffffffff810b2b99>]=
 fput+0x18d/0x1a5
Jun 15 10:12:16 mithrandir kernel: [24645.388683]  [<ffffffff810afe04>]=
 filp_close+0x69/0x75
Jun 15 10:12:16 mithrandir kernel: [24645.388710]  [<ffffffff810afeb8>]=
 sys_close+0xa8/0xea
Jun 15 10:12:16 mithrandir kernel: [24645.388737]  [<ffffffff8139b53b>]=
 system_call_fastpath+0x16/0x1b
Jun 15 10:12:16 mithrandir kernel: [24645.388767] Code: 1c 24 4c 39 e3 =
75 dc 58 5b 41 5c 41 5d 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89=
 fb 50 0f 84 1d 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf=
 b0 00 00 00 e8 3d eb 08 00 85 c0 0f=20
Jun 15 10:12:16 mithrandir kernel: [24645.389011] RIP  [<ffffffff810c43=
c5>] iput+0x1c/0x13b
Jun 15 10:12:16 mithrandir kernel: [24645.389040]  RSP <ffff88013a5abe4=
8>
Jun 15 10:12:16 mithrandir kernel: [24645.410091] ---[ end trace 9353fc=
80151a84f4 ]---
Jun 15 10:12:16 mithrandir kernel: [24645.537171] ------------[ cut her=
e ]------------
Jun 15 10:12:16 mithrandir kernel: [24645.537204] kernel BUG at fs/inod=
e.c:1368!
Jun 15 10:12:16 mithrandir kernel: [24645.537227] invalid opcode: 0000 =
[#2] PREEMPT SMP=20
Jun 15 10:12:16 mithrandir kernel: [24645.538996] CPU 1=20
Jun 15 10:12:16 mithrandir kernel: [24645.539008] Modules linked in: rf=
comm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_defl=
ate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek sn=
d_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss hso arc4 snd_mixer_oss =
snd_pcm snd_seq_dummy snd_seq_oss iwlagn btusb snd_seq_midi bluetooth s=
nd_rawmidi mac80211 crc16 snd_seq_midi_event snd_seq snd_timer snd_seq_=
device snd cfg80211 soundcore firewire_ohci firewire_core snd_page_allo=
c sony_laptop tpm_infineon rfkill crc_itu_t joydev mxm_wmi
Jun 15 10:12:16 mithrandir kernel: [24645.540007]=20
Jun 15 10:12:16 mithrandir kernel: [24645.546893] Pid: 15178, comm: rm =
Tainted: G      D     3.0.0-rc3+ #2 Sony Corporation VGN-Z11VN_B/VAIO
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RIP: 0010:[<ffffffff8=
10c43c5>]  [<ffffffff810c43c5>] iput+0x1c/0x13b
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RSP: 0018:ffff880130d=
7de48  EFLAGS: 00010202
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RAX: 0000000000000000=
 RBX: ffff880094c12430 RCX: 0000000000000034
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RDX: 00000001005cde00=
 RSI: ffffffff81108be8 RDI: ffff880094c12430
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RBP: ffff880130d7de68=
 R08: 0000000000000000 R09: ffff88012b8bca20
Jun 15 10:12:16 mithrandir kernel: [24645.546893] R10: ffff88012b8bca20=
 R11: ffff88013a4d9600 R12: ffff88012b901480
Jun 15 10:12:16 mithrandir kernel: [24645.546893] R13: ffff880094c12430=
 R14: ffff88012cf62470 R15: ffff880130029550
Jun 15 10:12:16 mithrandir kernel: [24645.546893] FS:  00007f26d09bb700=
(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
Jun 15 10:12:16 mithrandir kernel: [24645.546893] CS:  0010 DS: 0000 ES=
: 0000 CR0: 0000000080050033
Jun 15 10:12:16 mithrandir kernel: [24645.546893] CR2: 0000000002112078=
 CR3: 000000009f3d6000 CR4: 00000000000006e0
Jun 15 10:12:16 mithrandir kernel: [24645.546893] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Jun 15 10:12:16 mithrandir kernel: [24645.546893] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 15 10:12:16 mithrandir kernel: [24645.546893] Process rm (pid: 1517=
8, threadinfo ffff880130d7c000, task ffff88009f24a140)
Jun 15 10:12:16 mithrandir kernel: [24645.546893] Stack:
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  0000000000000000 fff=
f88012cf623c0 ffff88012b901480 ffff880094c12430
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  ffff880130d7de98 fff=
fffff810c17cc ffff88012cf623c0 ffff88012cf6241c
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  ffff880094c12430 fff=
f88012cf623c0 ffff880130d7dec8 ffffffff810c1ce1
Jun 15 10:12:16 mithrandir kernel: [24645.546893] Call Trace:
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff810c17cc>]=
 dentry_kill+0x115/0x137
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff810c1ce1>]=
 dput+0xbf/0xd0
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff810b2b99>]=
 fput+0x18d/0x1a5
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff810afe04>]=
 filp_close+0x69/0x75
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff810afeb8>]=
 sys_close+0xa8/0xea
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  [<ffffffff8139b53b>]=
 system_call_fastpath+0x16/0x1b
Jun 15 10:12:16 mithrandir kernel: [24645.546893] Code: 1c 24 4c 39 e3 =
75 dc 58 5b 41 5c 41 5d 5d c3 55 48 85 ff 48 89 e5 41 55 41 54 53 48 89=
 fb 50 0f 84 1d 01 00 00 f6 47 28 40 74 02 <0f> 0b 48 8d 77 20 48 8d bf=
 b0 00 00 00 e8 3d eb 08 00 85 c0 0f=20
Jun 15 10:12:16 mithrandir kernel: [24645.546893] RIP  [<ffffffff810c43=
c5>] iput+0x1c/0x13b
Jun 15 10:12:16 mithrandir kernel: [24645.546893]  RSP <ffff880130d7de4=
8>
Jun 15 10:12:16 mithrandir kernel: [24645.600558] ---[ end trace 9353fc=
80151a84f5 ]---
Jun 15 10:12:41 mithrandir kernel: /0x2a

Best wishes

Norbert
-----------------------------------------------------------------------=
-
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org=
}
JAIST, Japan                                 TeX Live & Debian Develope=
r
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B09=
4
-----------------------------------------------------------------------=
