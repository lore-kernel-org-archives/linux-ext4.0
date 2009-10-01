From: Andrew Lutomirski <andy@luto.us>
Subject: 2.6.32-rc1 oops in ext4
Date: Wed, 30 Sep 2009 22:54:26 -0400
Message-ID: <cb0375e10909301954y68e18290m97e9fecfbc5aa6e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57527 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZJACyX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 22:54:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All I did was boot Fedora 11 and open a Konsole.  I'm running
84d88d5d4efc37dfb8a93a4a58d8a227ee86ffa4.

root is ext4 mounted rw,acl, and it lives on LVM over dm-crypt.

[   95.519116] ------------[ cut here ]------------
[   95.519129] kernel BUG at fs/ext4/inode.c:1184!
[   95.519136] invalid opcode: 0000 [#1] SMP
[   95.519145] last sysfs file: /sys/devices/virtual/misc/fuse/dev
[   95.519151] CPU 0
[   95.519157] Modules linked in: fuse tp_smapi thinkpad_ec bridge stp
llc bnep sco l2cap bluetooth ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand dm_multipath uinput
arc4 thinkpad_acpi ecb hwmon snd_hda_codec_conexant snd_hda_intel
snd_hda_codec snd_hwdep iwlagn snd_pcm snd_timer iwlcore i2400m_usb
mac80211 iTCO_wdt snd i2c_i801 soundcore i2400m cfg80211
snd_page_alloc pcspkr iTCO_vendor_support xts gf128mul aes_x86_64
aes_generic dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core
video output [last unloaded: microcode]
[   95.519284] Pid: 131, comm: flush-253:2 Not tainted 2.6.32-rc2 #6
7465CTO
[   95.519291] RIP: 0010:[<ffffffff811b1820>]  [<ffffffff811b1820>]
ext4_num_dirty_pages+0x116/0x234
[   95.519311] RSP: 0018:ffff88013629ba00  EFLAGS: 00010246
[   95.519318] RAX: 000000000000000e RBX: 0000000000000000 RCX:
200000000002007d
[   95.519325] RDX: ffffea0003d11060 RSI: 0000000000000000 RDI:
ffffffff81643a3d
[   95.519332] RBP: ffff88013629bb10 R08: ffff8801183fa940 R09: 0000000000000000
[   95.519339] R10: ffff880135d66ca8 R11: ffff88013629bcd0 R12: 0000000000000000
[   95.519346] R13: ffff88013629ba50 R14: ffff8801183fcff8 R15: ffff88013629ba48
[   95.519354] FS:  0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[   95.519362] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   95.519368] CR2: 00000000061c4428 CR3: 0000000001001000 CR4: 00000000000006f0
[   95.519376] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   95.519383] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   95.519392] Process flush-253:2 (pid: 131, threadinfo
ffff88013629a000, task ffff880135cedcc0)
[   95.519399] Stack:
[   95.519404]  ffff88013629ba20 ffffffff8111c710 ffffea0003d11060
000000000000000e
[   95.519414] <0> 0000000000008000 ffff88013629ba60 ffff88013629ba60
0000000000000000
[   95.519426] <0> ffff880100000001 000000000000000e 000000000000000e
0000000000000000
[   95.519440] Call Trace:
[   95.519453]  [<ffffffff8111c710>] ? virt_to_head_page+0x21/0x56
[   95.519465]  [<ffffffff811b3403>] ext4_da_writepages+0x176/0x54c
[   95.519479]  [<ffffffff81044eec>] ? update_curr+0x149/0x16a
[   95.519491]  [<ffffffff810e847b>] do_writepages+0x32/0x4f
[   95.519503]  [<ffffffff8114b2f8>] writeback_single_inode+0xfe/0x30b
[   95.519514]  [<ffffffff8114bd95>] writeback_inodes_wb+0x475/0x57b
[   95.519525]  [<ffffffff8114bfd9>] wb_writeback+0x13e/0x1d3
[   95.519536]  [<ffffffff81068559>] ? del_timer_sync+0x28/0x4d
[   95.519547]  [<ffffffff8114c2b5>] wb_do_writeback+0x14b/0x175
[   95.519558]  [<ffffffff8114c32d>] bdi_writeback_task+0x4e/0xd5
[   95.519568]  [<ffffffff810faf28>] ? bdi_start_fn+0x0/0xf8
[   95.519577]  [<ffffffff810fafa8>] bdi_start_fn+0x80/0xf8
[   95.519587]  [<ffffffff81040329>] ? __spin_unlock_irq+0x23/0x3a
[   95.519596]  [<ffffffff810faf28>] ? bdi_start_fn+0x0/0xf8
[   95.519606]  [<ffffffff81076b89>] kthread+0x8e/0x96
[   95.519617]  [<ffffffff8100cfca>] child_rip+0xa/0x20
[   95.519626]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[   95.519636]  [<ffffffff81076afb>] ? kthread+0x0/0x96
[   95.519644]  [<ffffffff8100cfc0>] ? child_rip+0x0/0x20
[   95.519649] Code: 18 75 16 48 8b 0a f6 c1 10 74 0e f6 c5 20 75 09
48 8b 72 20 48 39 de 74 0d 48 89 d7 e8 81 e8 f2 ff 48 89 de eb 69 80
e5 08 75 04 <0f> 0b eb fe 48 8b 7a 10 48 89 f9 4c 8b 01 41 f7 c0 00 02
00 00
[   95.519746] RIP  [<ffffffff811b1820>] ext4_num_dirty_pages+0x116/0x234
[   95.519758]  RSP <ffff88013629ba00>
[   95.519766] ---[ end trace b0a7c79597727f0e ]---


--Andy
