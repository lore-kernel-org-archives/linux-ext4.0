From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: kernel BUG at fs/ext4/extents.c:2738!
Date: Fri, 20 Feb 2009 20:40:42 +1300
Message-ID: <1235115642.22702.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:18976 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZBTHku (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2009 02:40:50 -0500
Received: by ti-out-0910.google.com with SMTP id d10so550000tib.23
        for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2009 23:40:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have no idea what information you guys will need. Let me know and I'll
to gather it.

Feb 20 19:26:11 storage kernel: ------------[ cut here ]------------
Feb 20 19:26:11 storage kernel: kernel BUG at fs/ext4/extents.c:2738!
Feb 20 19:26:11 storage kernel: invalid opcode: 0000 [#1] SMP 
Feb 20 19:26:11 storage kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0/block/sda/sda2/dev
Feb 20 19:26:11 storage kernel: Dumping ftrace buffer:
Feb 20 19:26:11 storage kernel:   (ftrace buffer empty)
Feb 20 19:26:11 storage kernel: CPU 0 
Feb 20 19:26:11 storage kernel: Modules linked in: vboxnetflt vboxdrv
ext2 ext4 jbd2 crc16 fuse ipt_MASQUERADE iptable_nat nf_nat bridge stp
nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc bonding ipv6 dm_multipath
raid456 async_xor async_memcpy async_tx xor kvm_amd kvm uinput usblp
snd_hda_intel snd_seq_dummy cfi_cmdset_0002 jedec_probe snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss forcedeth
snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep joydev sata_nv
usb_storage cfi_probe gen_probe cfi_util serio_raw nvidia(P) snd
firewire_ohci pcspkr k8temp hwmon ck804xrom soundcore firewire_core
crc_itu_t mtd chipreg map_funcs i2c_nforce2 i2c_core ata_generic
pata_acpi pata_amd [last unloaded: vboxdrv]
Feb 20 19:26:11 storage kernel: Pid: 24313, comm: mv Tainted: P        W
2.6.28.5.afb.fc10.3.x86_amd64 #1
Feb 20 19:26:11 storage kernel: RIP: 0010:[<ffffffffa0d41d30>]
[<ffffffffa0d41d30>] ext4_ext_get_blocks+0x185/0xe15 [ext4]
Feb 20 19:26:11 storage kernel: RSP: 0018:ffff880186f57818  EFLAGS:
00010202
Feb 20 19:26:11 storage kernel: RAX: 0000000000000060 RBX:
ffff88014d18c9c0 RCX: 0000000000000000
Feb 20 19:26:11 storage kernel: RDX: ffff880093880002 RSI:
0000000000000002 RDI: 000000000000000c
Feb 20 19:26:11 storage kernel: RBP: ffff880186f57958 R08:
ffffffffa0d52475 R09: 000000000000f30a
Feb 20 19:26:11 storage kernel: R10: ffff880093886000 R11:
0000000000000000 R12: ffff8801002151d0
Feb 20 19:26:11 storage kernel: R13: ffff880186f57b38 R14:
ffff880100215290 R15: 000000000000000c
Feb 20 19:26:11 storage kernel: FS:  00007f9ced51f780(0000)
GS:ffffffff8177b000(0000) knlGS:00000000ef88bb90
Feb 20 19:26:11 storage kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb 20 19:26:11 storage kernel: CR2: 00007f12856bb000 CR3:
000000016ec63000 CR4: 00000000000006e0
Feb 20 19:26:11 storage kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb 20 19:26:11 storage kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb 20 19:26:11 storage kernel: Process mv (pid: 24313, threadinfo
ffff880186f56000, task ffff880100474500)
Feb 20 19:26:11 storage kernel: Stack:
Feb 20 19:26:11 storage kernel: 0000000086f57838 ffff880186f57b38
000000000000000c 0001500c00000000
Feb 20 19:26:11 storage kernel: 0000000000000000 ffff88014d18c9c0
ffffffff81094763 00011280ffffffff
Feb 20 19:26:11 storage kernel: ffff8801002151d0 ffff88023ca5c6c0
0000000000001000 0000000000000000
Feb 20 19:26:11 storage kernel: Call Trace:
Feb 20 19:26:11 storage kernel: [<ffffffff81094763>] ?
mempool_alloc_slab+0x11/0x13
Feb 20 19:26:11 storage kernel: [<ffffffff81094763>] ?
mempool_alloc_slab+0x11/0x13
Feb 20 19:26:11 storage kernel: [<ffffffff81349d1a>] ? _spin_lock_irq
+0x21/0x26
Feb 20 19:26:11 storage kernel: [<ffffffff813497f8>] ? __down_read
+0x3d/0xbd
Feb 20 19:26:11 storage kernel: [<ffffffff81094877>] ? mempool_alloc
+0x5b/0x113
Feb 20 19:26:11 storage kernel: [<ffffffffa0d32a0b>]
ext4_get_blocks_wrap+0x6f/0x239 [ext4]
Feb 20 19:26:11 storage kernel: [<ffffffffa0d331b1>] ext4_get_block
+0xb4/0xf2 [ext4]
Feb 20 19:26:11 storage kernel: [<ffffffff810eadc7>] do_mpage_readpage
+0x1a8/0x4cb
Feb 20 19:26:11 storage kernel: [<ffffffff8117737a>] ? radix_tree_insert
+0x186/0x1ca
Feb 20 19:26:11 storage kernel: [<ffffffff8109fe45>] ?
__inc_zone_page_state+0x25/0x27
Feb 20 19:26:11 storage kernel: [<ffffffff8109b6f1>] ? __lru_cache_add
+0x34/0x7c
Feb 20 19:26:11 storage kernel: [<ffffffff810eb1ed>] mpage_readpages
+0xb1/0xf4
Feb 20 19:26:11 storage kernel: [<ffffffffa0d330fd>] ? ext4_get_block
+0x0/0xf2 [ext4]
Feb 20 19:26:11 storage kernel: [<ffffffff81098a19>] ?
__alloc_pages_internal+0xfe/0x45d
Feb 20 19:26:11 storage kernel: [<ffffffffa0d330fd>] ? ext4_get_block
+0x0/0xf2 [ext4]
Feb 20 19:26:11 storage kernel: [<ffffffff8111acb2>] ?
ext3_ordered_write_end+0x110/0x127
Feb 20 19:26:11 storage kernel: [<ffffffffa0d31216>] ext4_readpages
+0x1a/0x1c [ext4]
Feb 20 19:26:11 storage kernel: [<ffffffff8109a888>]
__do_page_cache_readahead+0xf0/0x163
Feb 20 19:26:11 storage kernel: [<ffffffff8109abf9>] ondemand_readahead
+0x178/0x18a
Feb 20 19:26:11 storage kernel: [<ffffffff8109ac80>]
page_cache_async_readahead+0x75/0x82
Feb 20 19:26:11 storage kernel: [<ffffffff81093fb6>]
generic_file_aio_read+0x27e/0x58f
Feb 20 19:26:11 storage kernel: [<ffffffff810c60dc>] do_sync_read
+0xe7/0x12d
Feb 20 19:26:11 storage kernel: [<ffffffff81058821>] ?
autoremove_wake_function+0x0/0x38
Feb 20 19:26:11 storage kernel: [<ffffffff81349a1a>] ? _spin_lock
+0x9/0xc
Feb 20 19:26:11 storage kernel: [<ffffffff81142d30>] ?
security_file_permission+0x11/0x13
Feb 20 19:26:11 storage kernel: [<ffffffff810c6a59>] vfs_read+0xa8/0x102
Feb 20 19:26:11 storage kernel: [<ffffffff810c6b77>] sys_read+0x47/0x6e
Feb 20 19:26:11 storage kernel: [<ffffffff8101104a>]
system_call_fastpath+0x16/0x1b
Feb 20 19:26:11 storage kernel: Code: 66 41 8b 96 46 ff ff ff 48 8b 9d
e8 fe ff ff 0f b7 f2 48 63 c6 48 6b c0 30 48 8b 4c 18 10 48 85 c9 75 0c
85 f6 0f 84 58 08 00 00 <0f> 0b eb fe 44 8b 41 04 8b 39 44 8b 51 08 66
44 8b 49 06 66 41 
Feb 20 19:26:11 storage kernel: RIP  [<ffffffffa0d41d30>]
ext4_ext_get_blocks+0x185/0xe15 [ext4]
Feb 20 19:26:11 storage kernel: RSP <ffff880186f57818>
Feb 20 19:26:11 storage kernel: ---[ end trace 455a038508c771a2 ]---


