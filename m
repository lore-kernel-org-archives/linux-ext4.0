From: Markus Doits <doits@junetz.de>
Subject: frequent kernel bug with 2.6.26-gentoo-r1
Date: Sat, 16 Aug 2008 22:02:04 +0200
Message-ID: <48A7323C.4040002@junetz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rio-de-la-plata.junetz.de ([212.82.235.203]:50780 "EHLO
	donau.junetz.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755290AbYHPUpF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 16:45:05 -0400
Received: from e178146055.adsl.alicedsl.de ([85.178.146.55] helo=[192.168.178.20])
	by donau.junetz.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <doits@junetz.de>)
	id 1KURyN-0003YD-AZ
	for linux-ext4@vger.kernel.org; Sat, 16 Aug 2008 22:02:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi all,

i used ext4 some months ago but switched back to ext3 then.

today i wanted to try out ext4 again and did the following:

i'm using latest gentoo-kernel, which is based on 2.6.26.2 and some few
patches
(patchlist: http://dev.gentoo.org/~dsd/genpatches/patches-2.6.26-1.htm).

i patched the kernel with
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST-2.6.26/2.6.26-ext4-6.bz2
and compiled it successfully.

after a "ssv flags 4" and a "tune2fs -O extents" i could mount one of my
ext3 partitions as a ext4dev-drive. first, everything seemed to work,
but after some read/write to that drive i got the first kernel oops.

thought it might be because it was an old ext3-drive, so i formated the
drive with mkfs.ext4dev. but no change, still the same problems. now i'm
nearly always getting a kernel bug on umounting an ext4-drive (and then
the device is not accessible/mountable anymore). here's the recent one:

[  830.270166] ------------[ cut here ]------------
[  830.270166] kernel BUG at fs/ext4/inode.c:1561!
[  830.270166] invalid opcode: 0000 [1] PREEMPT SMP
[  830.270166] CPU 1
[  830.270166] Modules linked in: nls_iso8859_1 xt_tcpudp
nf_conntrack_ipv4 xt_state iptable_filter ip_tables x_tables snd_pcm_oss
snd_mixer_oss nls_cp437 nf_conntrack_ftp nf_conntrack vboxdrv tda1004x
budget_av saa7146_vv videobuf_dma_sg videobuf_core videodev nvidia(P)
v4l1_compat budget_core dvb_core snd_hda_intel saa7146 ttpci_eeprom
snd_pcm usblp snd_page_alloc joydev
[  830.270166] Pid: 6022, comm: umount Tainted: P
2.6.26-gentoo-r1 #1
[  830.270166] RIP: 0010:[<ffffffff8031a39a>]  [<ffffffff8031a39a>]
ext4_da_invalidatepage+0xda/0x140
[  830.270166] RSP: 0018:ffff81019b8dbbc8  EFLAGS: 00010202
[  830.270166] RAX: 0000000000000001 RBX: 0000000000000001 RCX:
0000000000000000
[  830.270166] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
00000000000003ff
[  830.270166] RBP: ffff81019b8dbc08 R08: 0000000000000400 R09:
000000000000000e
[  830.270166] R10: ffffffffffffffc0 R11: 0000000000000001 R12:
ffff81019fa986d0
[  830.270166] R13: 0000000000000000 R14: ffff8101bfd6a000 R15:
ffffe200059d4650
[  830.270166] FS:  00007f7f9b339740(0000) GS:ffff8101bfc06580(0000)
knlGS:0000000000000000
[  830.270166] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  830.270166] CR2: 00007fe1ea640000 CR3: 000000019b8bf000 CR4:
00000000000006e0
[  830.270166] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  830.270166] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  830.270166] Process umount (pid: 6022, threadinfo ffff81019b8da000,
task ffff8101ade0d680)
[  830.270166] Stack:  ffff81019b8dbbd8 0000000000000000
ffff81019fa98a2c ffffe200059d4650
[  830.270166]  0000000000000000 ffff81019b8dbc90 0000000000000001
ffff81019fa988a0
[  830.270166]  ffff81019b8dbc18 ffffffff80282b60 ffff81019b8dbc38
ffffffff8028316a
[  830.270166] Call Trace:
[  830.270166]  [<ffffffff80282b60>] do_invalidatepage+0x20/0x30
[  830.270166]  [<ffffffff8028316a>] truncate_complete_page+0x6a/0x70
[  830.270166]  [<ffffffff802832cf>] truncate_inode_pages_range+0x15f/0x430
[  830.270166]  [<ffffffff802835b0>] truncate_inode_pages+0x10/0x20
[  830.270166]  [<ffffffff802bd0f1>] dispose_list+0xf1/0x130
[  830.270166]  [<ffffffff802bd4cc>] invalidate_inodes+0xec/0x110
[  830.270166]  [<ffffffff802a812a>] generic_shutdown_super+0x3a/0x120
[  830.270166]  [<ffffffff802a8225>] kill_block_super+0x15/0x30
[  830.270166]  [<ffffffff802a8316>] deactivate_super+0x56/0x80
[  830.270166]  [<ffffffff802c0ab6>] mntput_no_expire+0xe6/0x150
[  830.270166]  [<ffffffff802c0e89>] sys_umount+0x69/0x3e0
[  830.270166]  [<ffffffff802a9877>] ? sys_newstat+0x27/0x50
[  830.270166]  [<ffffffff8020c50b>] system_call_after_swapgs+0x7b/0x80
[  830.270166]
[  830.270166]
[  830.270166] Code: 89 45 d0 e8 99 7b 2b 00 49 8b b4 24 40 03 00 00 48
89 df 44 29 ee e8 d6 fe ff ff 49 8b 94 24 48 03 00 00 48 63 d8 48 39 d3
76 04 <0f> 0b eb fe 89 d6 49 8d be b8 00 00 00 29 c6 ba 20 00 00 00 44
[  830.270166] RIP  [<ffffffff8031a39a>] ext4_da_invalidatepage+0xda/0x140
[  830.270166]  RSP <ffff81019b8dbbc8>
[  830.270166] ---[ end trace 4538c50fe9c49e26 ]---
[  830.270166] ------------[ cut here ]------------
[  830.270166] WARNING: at kernel/exit.c:965 do_exit+0x37a/0x7c0()
[  830.270166] Modules linked in: nls_iso8859_1 xt_tcpudp
nf_conntrack_ipv4 xt_state iptable_filter ip_tables x_tables snd_pcm_oss
snd_mixer_oss nls_cp437 nf_conntrack_ftp nf_conntrack vboxdrv tda1004x
budget_av saa7146_vv videobuf_dma_sg videobuf_core videodev nvidia(P)
v4l1_compat budget_core dvb_core snd_hda_intel saa7146 ttpci_eeprom
snd_pcm usblp snd_page_alloc joydev
[  830.270166] Pid: 6022, comm: umount Tainted: P      D
2.6.26-gentoo-r1 #1
[  830.270166]
[  830.270166] Call Trace:
[  830.270166]  [<ffffffff8023e61f>] warn_on_slowpath+0x5f/0xa0
[  830.270166]  [<ffffffff8023268e>] ? __resched_task+0x4e/0x80
[  830.270166]  [<ffffffff805cf4bf>] ? printk+0x67/0x70
[  830.270166]  [<ffffffff80242c1a>] do_exit+0x37a/0x7c0
[  830.270166]  [<ffffffff80231f0e>] ? __wake_up+0x4e/0x70
[  830.270166]  [<ffffffff8020da98>] oops_end+0x88/0x90
[  830.270166]  [<ffffffff8020e93e>] die+0x5e/0x90
[  830.270166]  [<ffffffff8020ee16>] do_trap+0x146/0x170
[  830.270166]  [<ffffffff8025ab51>] ? atomic_notifier_call_chain+0x11/0x20
[  830.270166]  [<ffffffff8020f322>] do_invalid_op+0x92/0xb0
[  830.270166]  [<ffffffff8031a39a>] ? ext4_da_invalidatepage+0xda/0x140
[  830.270166]  [<ffffffff805d2480>] ? _spin_unlock+0x10/0x40
[  830.270166]  [<ffffffff8027e878>] ? free_hot_cold_page+0x178/0x250
[  830.270166]  [<ffffffff805d2859>] error_exit+0x0/0x51
[  830.270166]  [<ffffffff8031a39a>] ? ext4_da_invalidatepage+0xda/0x140
[  830.270166]  [<ffffffff8031a38a>] ? ext4_da_invalidatepage+0xca/0x140
[  830.270166]  [<ffffffff80282b60>] ? do_invalidatepage+0x20/0x30
[  830.270166]  [<ffffffff8028316a>] ? truncate_complete_page+0x6a/0x70
[  830.270166]  [<ffffffff802832cf>] ?
truncate_inode_pages_range+0x15f/0x430
[  830.270190]  [<ffffffff802835b0>] ? truncate_inode_pages+0x10/0x20
[  830.270193]  [<ffffffff802bd0f1>] ? dispose_list+0xf1/0x130
[  830.270197]  [<ffffffff802bd4cc>] ? invalidate_inodes+0xec/0x110
[  830.270201]  [<ffffffff802a812a>] ? generic_shutdown_super+0x3a/0x120
[  830.270205]  [<ffffffff802a8225>] ? kill_block_super+0x15/0x30
[  830.270208]  [<ffffffff802a8316>] ? deactivate_super+0x56/0x80
[  830.270212]  [<ffffffff802c0ab6>] ? mntput_no_expire+0xe6/0x150
[  830.270215]  [<ffffffff802c0e89>] ? sys_umount+0x69/0x3e0
[  830.270220]  [<ffffffff802a9877>] ? sys_newstat+0x27/0x50
[  830.270224]  [<ffffffff8020c50b>] ? system_call_after_swapgs+0x7b/0x80
[  830.270228]
[  830.270231] ---[ end trace 4538c50fe9c49e26 ]---
[  830.270235] note: umount[6022] exited with preempt_count 1

is this a known problem?

regards

