From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: kernel BUG at fs/ext4/extents.c:2766!
Date: Wed, 7 Mar 2012 18:59:43 +0800
Message-ID: <CAGBYx2bc7mgYGm3gTbJt2Lhd7UbvW59fk7JPDs9dVqPJ-9OB3A@mail.gmail.com>
References: <20120307011430.GA613@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39025 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409Ab2CGK7o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 05:59:44 -0500
Received: by obbuo6 with SMTP id uo6so6755382obb.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Mar 2012 02:59:43 -0800 (PST)
In-Reply-To: <20120307011430.GA613@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 7, 2012 at 9:14 AM, J=F6rg Sommer <joerg@alea.gnuu.de> wrot=
e:
> Hi,
>
> I've got this Oops after I've created a file that filled up the
> filesystem.
>
> [ =A0852.407974] ------------[ cut here ]------------
> [ =A0852.412105] kernel BUG at /build/buildd-linux-2.6_3.2.9-1-powerp=
c-xXyGnW/linux-2.6-3.2.9/debian/build/source_powerpc_none/fs/ext4/exten=
ts.c:2766!
Hi,

Could this be reproduced?

Yongqiang.
> [ =A0852.433083] Oops: Exception in kernel mode, sig: 5 [#1]
> [ =A0852.436340] PowerMac
> [ =A0852.438523] Modules linked in: evdev ext4 crc16 jbd2 mbcache sr_=
mod cdrom virtio_net virtio_blk ata_generic pata_cmd64x virtio_pci virt=
io_ring virtio [last unloaded: scsi_wait_scan]
> [ =A0852.449271] NIP: c9297bbc LR: c9297f78 CTR: c011f92c
> [ =A0852.452964] REGS: c5ec5930 TRAP: 0700 =A0 Not tainted =A0(3.2.0-=
2-powerpc)
> [ =A0852.456848] MSR: 00029032 <EE,ME,CE,IR,DR> =A0CR: 24002042 =A0XE=
R: 00000000
> [ =A0852.477461] TASK =3D c1cea170[425] 'flush-254:0' THREAD: c5ec400=
0
> [ =A0852.479210] GPR00: 00000001 c5ec59e0 c1cea170 00000001 c759e0e0 =
c1fc54e0 00000000 00000003
> [ =A0852.484825] GPR08: 00000000 00000000 c31ff018 c5ec5a50 24002024 =
00000000 01000000 00000000
> [ =A0852.490069] GPR16: 000007b5 00000000 00071800 00005800 00000000 =
00000001 c1fc54e0 00000000
> [ =A0852.495771] GPR24: 00000000 c1fc5500 c31ff00c 00000003 c1fc54e0 =
00000001 00000000 c759e0e0
> [ =A0852.523827] NIP [c9297bbc] ext4_split_extent_at+0xb4/0x340 [ext4=
]
> [ =A0852.528397] LR [c9297f78] ext4_split_extent+0x130/0x144 [ext4]
> [ =A0852.532979] Call Trace:
> [ =A0852.536640] [c5ec5a50] [c9297f78] ext4_split_extent+0x130/0x144 =
[ext4]
> [ =A0852.541230] [c5ec5a80] [c92988a4] ext4_ext_handle_uninitialized_=
extents+0x918/0xabc [ext4]
> [ =A0852.563059] [c5ec5b20] [c9298f44] ext4_ext_map_blocks+0x41c/0x14=
2c [ext4]
> [ =A0852.569110] [c5ec5bf0] [c9271340] ext4_map_blocks+0x134/0x344 [e=
xt4]
> [ =A0852.574558] [c5ec5c70] [c9275750] mpage_da_map_and_submit+0xe0/0=
x4f8 [ext4]
> [ =A0852.579567] [c5ec5d00] [c92762b0] ext4_da_writepages+0x328/0x4f8=
 [ext4]
> [ =A0852.585242] [c5ec5db0] [c00c1534] do_writepages+0x30/0x58
> [ =A0852.590489] [c5ec5dc0] [c0116608] writeback_single_inode+0x128/0=
x2f8
> [ =A0852.613485] [c5ec5df0] [c0116acc] writeback_sb_inodes+0x144/0x1d=
0
> [ =A0852.619216] [c5ec5e60] [c0116bc0] __writeback_inodes_wb+0x68/0xa=
c
> [ =A0852.624050] [c5ec5e90] [c0116d4c] wb_writeback+0x148/0x250
> [ =A0852.628820] [c5ec5ef0] [c01174b4] wb_do_writeback+0x1e4/0x218
> [ =A0852.633826] [c5ec5f60] [c0117594] bdi_writeback_thread+0xac/0x24=
4
> [ =A0852.656169] [c5ec5fb0] [c005cc34] kthread+0x78/0x7c
> [ =A0852.662327] [c5ec5ff0] [c000f534] kernel_thread+0x4c/0x68
> [ =A0852.666968] Instruction dump:
> [ =A0852.670996] 5012421e 5012c00e a01a0006 5411c23e 5011442e 3800000=
1 5631043e 419c0014
> [ =A0852.676786] 7c18a214 7c00f010 38000000 7c000114 <0f000000> 80990=
018 7fa3eb78 4bffd80d
> [ =A0852.683259] ---[ end trace 7771de8b04a49e96 ]---
>
> [ =A0 =A00.000000] Linux version 3.2.0-2-powerpc (Debian 3.2.9-1) (de=
bian-kernel@lists.debian.org) (gcc version 4.6.2 (Debian 4.6.2-11) ) #1=
 Sun Mar 4 22:09:57 UTC 2012
>
> The system was a virtual machine running with kvm/qemu.
>
> Bye, J=F6rg.
> --
> Der Mensch hat die Atombombe erfunden.
> Keine Maus der Welt k=E4me auf die Idee, eine Mausefalle zu konstruie=
ren.



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
