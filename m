From: Josh Triplett <josh@joshtriplett.org>
Subject: NULL pointer dereference in ext4_superblock_csum_set with mounted
 filesystem
Date: Wed, 13 Mar 2013 11:59:13 -0700
Message-ID: <20130313185911.GA1446@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I frequently test kernel changes by booting them with kvm's -kernel
option, with -hda pointing to my host system's root filesystem, and
-snapshot to prevent writing to (and likely corrupting) that root
filesystem.  I tried this with a kernel built from git commit
7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b, with a stock x86-64 "make
defconfig", and got a kernel panic:

[    0.908898] EXT4-fs (sda): couldn't mount as ext3 due to feature incompatibilities
[    0.911608] EXT4-fs (sda): couldn't mount as ext2 due to feature incompatibilities
[    0.917997] EXT4-fs (sda): INFO: recovery required on readonly filesystem
[    0.919575] EXT4-fs (sda): write access will be enabled during recovery
[    1.004234] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    1.005050] IP: [<ffffffff811ca54f>] ext4_superblock_csum_set+0x2f/0x70
[    1.005050] PGD 0 
[    1.005050] Oops: 0000 [#1] SMP 
[    1.005050] Modules linked in:
[    1.005050] CPU 0 
[    1.005050] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2+ #5 Bochs Bochs
[    1.005050] RIP: 0010:[<ffffffff811ca54f>]  [<ffffffff811ca54f>] ext4_superblock_csum_set+0x2f/0x70
[    1.005050] RSP: 0000:ffff88003e1f5578  EFLAGS: 00010202
[    1.005050] RAX: 0000000000000000 RBX: ffff880001da8400 RCX: 0000000000000001
[    1.005050] RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffff88003d93d400
[    1.005050] RBP: ffff88003e1f55a8 R08: ffffffff81cb4238 R09: 0000000000000040
[    1.005050] R10: 0000000001270030 R11: 0000000000000000 R12: ffff88003de0f1a0
[    1.005050] R13: ffff880001da8400 R14: 0000000000000000 R15: ffff88003d93d400
[    1.005050] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[    1.005050] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.005050] CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 00000000000006f0
[    1.005050] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.005050] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.005050] Process swapper/0 (pid: 1, threadinfo ffff88003e1f4000, task ffff88003e1f0000)
[    1.005050] Stack:
[    1.005050]  ffff88003e1f55a8 ffffffff812c8ffa ffffffff810fd729 0000000000000000
[    1.005050]  ffff88003de0f1a0 000000000105a4e8 ffff88003e1f55f8 ffffffff811cae3c
[    1.005050]  00000001000004d8 00000000307ea8c1 ffff88003e1f55f8 ffff88003d93d400
[    1.005050] Call Trace:
[    1.005050]  [<ffffffff812c8ffa>] ? __percpu_counter_sum+0x5a/0x80
[    1.005050]  [<ffffffff810fd729>] ? __inc_zone_state+0x59/0x60
[    1.005050]  [<ffffffff811cae3c>] ext4_commit_super+0x15c/0x240
[    1.005050]  [<ffffffff811cb0ae>] save_error_info+0x1e/0x30
[    1.005050]  [<ffffffff811cc12e>] ext4_error_inode+0x5e/0x120
[    1.005050]  [<ffffffff810e3fc0>] ? mempool_alloc_slab+0x10/0x20
[    1.005050]  [<ffffffff811a8208>] __check_block_validity.constprop.57+0x78/0x80
[    1.005050]  [<ffffffff811eb791>] ? ext4_es_lookup_extent+0x91/0x180
[    1.005050]  [<ffffffff811a9fe0>] ext4_map_blocks+0x250/0x3f0
[    1.005050]  [<ffffffff811ac062>] _ext4_get_block+0x82/0x190
[    1.005050]  [<ffffffff811ac1a1>] ext4_get_block+0x11/0x20
[    1.005050]  [<ffffffff8115d6ba>] generic_block_bmap+0x3a/0x40
[    1.005050]  [<ffffffff810e1d49>] ? find_get_page+0x19/0xa0
[    1.005050]  [<ffffffff8115e538>] ? __find_get_block_slow+0xb8/0x160
[    1.005050]  [<ffffffff810ea6ad>] ? mapping_tagged+0xd/0x10
[    1.005050]  [<ffffffff811a7f09>] ext4_bmap+0x89/0xf0
[    1.005050]  [<ffffffff811453d9>] bmap+0x19/0x20
[    1.005050]  [<ffffffff811fe25e>] jbd2_journal_bmap+0x2e/0xb0
[    1.005050]  [<ffffffff811f6d5b>] jread+0x3b/0x270
[    1.005050]  [<ffffffff8115ef28>] ? __getblk+0x28/0x2d0
[    1.005050]  [<ffffffff811f8aea>] ? find_revoke_record+0x5a/0xb0
[    1.005050]  [<ffffffff811f701e>] do_one_pass+0x8e/0xad0
[    1.005050]  [<ffffffff811f7b39>] jbd2_journal_recover+0xd9/0x110
[    1.005050]  [<ffffffff811fddc7>] jbd2_journal_load+0xd7/0x390
[    1.005050]  [<ffffffff811275a0>] ? kmem_cache_alloc_trace+0x30/0x110
[    1.005050]  [<ffffffff811cfbab>] ext4_fill_super+0x1e9b/0x2dc0
[    1.005050]  [<ffffffff81130cf1>] mount_bdev+0x1a1/0x1e0
[    1.005050]  [<ffffffff811cdd10>] ? ext4_calculate_overhead+0x3c0/0x3c0
[    1.005050]  [<ffffffff811bb1d0>] ext4_mount+0x10/0x20
[    1.005050]  [<ffffffff8113196e>] mount_fs+0x3e/0x1b0
[    1.005050]  [<ffffffff81100b7b>] ? __alloc_percpu+0xb/0x10
[    1.005050]  [<ffffffff8114a87f>] vfs_kern_mount+0x6f/0x110
[    1.005050]  [<ffffffff8114cac9>] do_mount+0x209/0xa10
[    1.005050]  [<ffffffff810fb343>] ? strndup_user+0x53/0x70
[    1.005050]  [<ffffffff8114d359>] sys_mount+0x89/0xd0
[    1.005050]  [<ffffffff81cd51e1>] mount_block_root+0xf6/0x221
[    1.005050]  [<ffffffff81cd5406>] mount_root+0xfa/0x105
[    1.005050]  [<ffffffff81cd554e>] prepare_namespace+0x13d/0x16a
[    1.005050]  [<ffffffff81cd4fa2>] kernel_init_freeable+0x1b4/0x1c4
[    1.005050]  [<ffffffff81cd481c>] ? do_early_param+0x8c/0x8c
[    1.005050]  [<ffffffff81784e20>] ? rest_init+0x70/0x70
[    1.005050]  [<ffffffff81784e29>] kernel_init+0x9/0xf0
[    1.005050]  [<ffffffff817a60ac>] ret_from_fork+0x7c/0xb0
[    1.005050]  [<ffffffff81784e20>] ? rest_init+0x70/0x70
[    1.005050] Code: 53 48 83 ec 28 48 8b 87 40 03 00 00 48 8b 58 68 f6 43 65 04 75 0e 48 83 c4 28 5b 5d c3 0f 1f 80 00 00 00 00 48 8b 80 b8 03 00 00 <83> 38 04 75 37 48 8d 7d d8 ba fc 03 00 00 48 89 de 48 89 45 d8 
[    1.005050] RIP  [<ffffffff811ca54f>] ext4_superblock_csum_set+0x2f/0x70
[    1.005050]  RSP <ffff88003e1f5578>
[    1.005050] CR2: 0000000000000000
[    1.066804] ---[ end trace cba8b53354947677 ]---
