From: Manish Katiyar <mkatiyar@gmail.com>
Subject: ext4 crashes in case of failed mounts
Date: Fri, 14 Jan 2011 19:34:56 -0800
Message-ID: <AANLkTik9FAqwXj2EOJfjR1bZ16-imT0rKS30zCrhDsZy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59524 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1AODfR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jan 2011 22:35:17 -0500
Received: by qyk12 with SMTP id 12so4048604qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 19:35:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was trying to simulate some failed mount cases so changed
ext4_mb_init() to return -ENOMEM. The next mount crashes with
following backtrace. Shouldn't it be handled gracefully ?

[  746.680089] EXT4-fs (loop0): failed to initialize mballoc (-12)
[  746.680127] EXT4-fs (loop0): mount failed
[  746.694981] BUG: unable to handle kernel NULL pointer dereference at 000001c4
[  746.694981] IP: [<e08bdf5c>] ext4_clear_inode+0x2c/0x50 [ext4]
[  746.694981] *pde = 00000000
[  746.694981] Oops: 0000 [#1] SMP
[  746.694981] last sysfs file: /sys/devices/virtual/block/loop0/range
[  746.694981] Modules linked in: ext4 jbd2 binfmt_misc bridge stp
bnep video output lp ppdev snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device psmouse snd serio_raw pcspkr soundcore i2c_piix4
snd_page_alloc parport_pc parport pcnet32 mii floppy
[  746.694981]
[  746.694981] Pid: 3395, comm: mount Tainted: G        W
2.6.36.2myversion #1 /VirtualBox
[  746.694981] EIP: 0060:[<e08bdf5c>] EFLAGS: 00010286 CPU: 0
[  746.694981] EIP is at ext4_clear_inode+0x2c/0x50 [ext4]
[  746.694981] EAX: 00000000 EBX: d82fd824 ECX: 00000000 EDX: d6685c00
[  746.694981] ESI: d6685c00 EDI: d82fd824 EBP: d871ddc4 ESP: d871ddc0
[  746.694981]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  746.694981] Process mount (pid: 3395, ti=d871c000 task=d9486220
task.ti=d871c000)
[  746.694981] Stack:
[  746.694981]  d82fd824 d871ddec e08afefe 00000246 00000246 c0217863
00000001 00000246
[  746.694981] <0> d82fd824 d6685c00 d82fd824 d871ddf8 c021703a
d82fd824 d871de08 c021786a
[  746.694981] <0> 00000000 d82f911c d871de40 c02155a2 d8726000
c058d728 00000020 d871de9c
[  746.694981] Call Trace:
[  746.694981]  [<e08afefe>] ? ext4_evict_inode+0x2e/0x330 [ext4]
[  746.694981]  [<c0217863>] ? iput+0x143/0x260
[  746.694981]  [<c021703a>] ? evict+0x1a/0xb0
[  746.694981]  [<c021786a>] ? iput+0x14a/0x260
[  746.694981]  [<c02155a2>] ? shrink_dcache_for_umount_subtree+0x192/0x220
[  746.694981]  [<c058d728>] ? mutex_unlock+0x8/0x10
[  746.694981]  [<c0205a49>] ? sget+0x1f9/0x410
[  746.694981]  [<c0215658>] ? shrink_dcache_for_umount+0x28/0x50
[  746.694981]  [<c0204c0b>] ? generic_shutdown_super+0x1b/0xd0
[  746.694981]  [<c0253dcf>] ? disk_name+0xaf/0xc0
[  746.694981]  [<c0204ce5>] ? kill_block_super+0x25/0x40
[  746.694981]  [<c020536d>] ? deactivate_locked_super+0x3d/0x60
[  746.694981]  [<c0205f0f>] ? get_sb_bdev+0x16f/0x180
[  746.694981]  [<e08bc9e1>] ? ext4_get_sb+0x21/0x30 [ext4]
[  746.694981]  [<e08c0b00>] ? ext4_fill_super+0x0/0x32d0 [ext4]
[  746.694981]  [<c020559a>] ? vfs_kern_mount+0x6a/0x1b0
[  746.694981]  [<c0219b2d>] ? get_fs_type+0x9d/0xc0
[  746.694981]  [<c0205739>] ? do_kern_mount+0x39/0xe0
[  746.694981]  [<c021c950>] ? do_mount+0x340/0x7b0
[  746.694981]  [<c01dba73>] ? memdup_user+0x33/0x70
[  746.694981]  [<c01dbaf9>] ? strndup_user+0x49/0x60
[  746.694981]  [<c021ce44>] ? sys_mount+0x84/0xb0
[  746.694981]  [<c058f9d5>] ? syscall_call+0x7/0xb
[  746.694981] Code: 89 e5 53 89 c3 e8 05 99 96 df 89 d8 e8 4e 90 95
df 89 d8 e8 a7 62 98 df 89 d8 e8 c0 5f 01 00 8b 83 0c 01 00 00 8b 80
60 02 00 00 <8b> 80 c4 01 00 00 85 c0 74 0b 8d 93 f4 01 00 00 e8 4f 71
f6 ff
[  746.694981] EIP: [<e08bdf5c>] ext4_clear_inode+0x2c/0x50 [ext4]
SS:ESP 0068:d871ddc0
[  746.694981] CR2: 00000000000001c4
[  746.699688] ---[ end trace 4eaa2a86a8e2da24 ]---
[ 1338.678856] kmemleak: 31 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)


=======================================================================

(gdb) l *(ext4_clear_inode+0x2c)
0x19f8c is in ext4_clear_inode (fs/ext4/super.c:878).
873	{
874		invalidate_inode_buffers(inode);
875		end_writeback(inode);
876		dquot_drop(inode);
877		ext4_discard_preallocations(inode);
878		if (EXT4_JOURNAL(inode))
879			jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
880					       &EXT4_I(inode)->jinode);
881	}


-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
