From: Dave Jones <davej@redhat.com>
Subject: ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1
 with only 0 reserved data  blocks
Date: Tue, 16 Jul 2013 16:25:33 -0400
Message-ID: <20130716202533.GA16061@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've seen this happen a few times this week..

EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs warning (device sdb1): ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1 with only 0 reserved data  blocks
------------[ cut here ]------------
WARNING: CPU: 3 PID: 798 at fs/ext4/inode.c:1334 ext4_da_invalidatepage+0x39e/0x3c0()
Modules linked in: btrfs snd_hda_codec_realtek xor snd_hda_intel snd_hda_codec snd_pcm raid6_pq libcrc32c zlib_deflate snd_pag e_alloc snd_timer edac_core snd pcspkr serio_raw soundcore r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
CPU: 3 PID: 798 Comm: fsx Not tainted 3.11.0-rc1+ #12
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
 ffffffff81a1bec7 ffff880126c81c18 ffffffff816b8a79 0000000000000000
 ffff880126c81c50 ffffffff81043efc ffff88010b753020 0000000000000002
 ffff88011bc237b0 ffff88011bc237b0 ffffea00045fbe00 ffff880126c81c60
Call Trace:
 [<ffffffff816b8a79>] dump_stack+0x4e/0x82
 [<ffffffff81043efc>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81043fea>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8124f1ae>] ext4_da_invalidatepage+0x39e/0x3c0
 [<ffffffff81152b6e>] truncate_inode_page+0x8e/0x90
 [<ffffffff81152f0a>] truncate_inode_pages_range+0x35a/0x650
 [<ffffffff81153272>] truncate_pagecache+0x52/0x80
 [<ffffffff81255f1d>] ext4_setattr+0x33d/0x840
 [<ffffffff811d90a8>] notify_change+0x1d8/0x350
 [<ffffffff811b91e9>] do_truncate+0x69/0x90
 [<ffffffff811b953e>] do_sys_ftruncate.constprop.17+0x10e/0x160
 [<ffffffff811b95ce>] SyS_ftruncate+0xe/0x10
 [<ffffffff816ca8d4>] tracesys+0xdd/0xe2
---[ end trace 267735bac62efc6a ]---
EXT4-fs warning (device sdb1): ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1 with only 0 reserved data blocks
