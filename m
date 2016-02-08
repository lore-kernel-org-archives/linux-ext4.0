From: Mark Rutland <mark.rutland@arm.com>
Subject: Latent undefined behaviour in fs/ext4/mballoc.c (seen in v4.5-rc3)
Date: Mon, 8 Feb 2016 14:45:44 +0000
Message-ID: <20160208144543.GA12536@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org, aryabinin@virtuozzo.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

While trying UBSAN on arm64, I hit a couple of splats at boot in the
ext4 mballoc code [1] (duplicated below), on v4.5-rc3. In both cases a
dynamically-computed shift amount underflows before it is applied,
leading to a too-large shift in one case and a negative shift in the
other.

The code in question seems largely unchanged since 2008 judging by git
blame, and I didn't spot any relevant changes in linux-next today
(next-20160208), so I assume I'm the first to report this.

I've had a quick look at figuring out what's happening below, but I'm
not familiar with the code and I'm not sure what the intended results
are. Any help would be appreciated.

The first splat looks like:

[    3.804750] ================================================================================
[    3.813176] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:2612:15
[    3.819431] shift exponent 4294967295 is too large for 32-bit type 'int'
[    3.826121] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.5.0-rc2+ #48
[    3.832463] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS ROD0085E 11/23/2015
[    3.841060] Call trace:
[    3.843499] [<ffffffc00008d7b8>] dump_backtrace+0x0/0x298
[    3.848887] [<ffffffc00008da64>] show_stack+0x14/0x20
[    3.853929] [<ffffffc00056e0f0>] dump_stack+0xe0/0x178
[    3.859056] [<ffffffc0005b734c>] ubsan_epilogue+0x14/0x50
[    3.864444] [<ffffffc0005b7748>] __ubsan_handle_shift_out_of_bounds+0xe0/0x138
[    3.871655] [<ffffffc0003e1734>] ext4_mb_init+0x84c/0x920
[    3.877043] [<ffffffc0003ba294>] ext4_fill_super+0x2eac/0x4958
[    3.882866] [<ffffffc0002c1008>] mount_bdev+0x180/0x1e8
[    3.888079] [<ffffffc0003adf8c>] ext4_mount+0x14/0x20
[    3.893118] [<ffffffc0002c23f4>] mount_fs+0x44/0x1c8
[    3.898073] [<ffffffc0002ed9c0>] vfs_kern_mount+0x50/0x1a8
[    3.903547] [<ffffffc0002f3d90>] do_mount+0x240/0x1478
[    3.908673] [<ffffffc0002f54d0>] SyS_mount+0x90/0xf8
[    3.913627] [<ffffffc000eb2750>] mount_block_root+0x22c/0x3c4
[    3.919361] [<ffffffc000eb2a08>] mount_root+0x120/0x138
[    3.924574] [<ffffffc000eb2b5c>] prepare_namespace+0x13c/0x184
[    3.930396] [<ffffffc000eb21bc>] kernel_init_freeable+0x390/0x3b4
[    3.936479] [<ffffffc000bb4a78>] kernel_init+0x10/0xe0
[    3.941606] [<ffffffc000086cd0>] ret_from_fork+0x10/0x40
[    3.946905] ================================================================================

Which corresponds to the following loop:

2606         i = 1;
2607         offset = 0;
2608         max = sb->s_blocksize << 2;
2609         do {
2610                 sbi->s_mb_offsets[i] = offset;
2611                 sbi->s_mb_maxs[i] = max;
2612                 offset += 1 << (sb->s_blocksize_bits - i);
2613                 max = max >> 1;
2614                 i++;
2615         } while (i <= sb->s_blocksize_bits + 1);

The loop condition permits an iteration where i == sb->s_blocksize_bits + 1, as
sb->s_blocksize_bits is an unsigned char and i is an unsigned, the result is an
unsigned underflow value (4294967295). This leads us to try to left shift 1 by
an insanely large value.

The second splat looks like:

[    5.566166] ================================================================================
[    5.574596] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
[    5.580851] shift exponent -1 is negative
[    5.584851] CPU: 4 PID: 1028 Comm: mount Not tainted 4.5.0-rc2+ #48
[    5.591105] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS ROD0085E 11/23/2015
[    5.599702] Call trace:
[    5.602142] [<ffffffc00008d7b8>] dump_backtrace+0x0/0x298
[    5.607530] [<ffffffc00008da64>] show_stack+0x14/0x20
[    5.612572] [<ffffffc00056e0f0>] dump_stack+0xe0/0x178
[    5.617700] [<ffffffc0005b734c>] ubsan_epilogue+0x14/0x50
[    5.623088] [<ffffffc0005b7748>] __ubsan_handle_shift_out_of_bounds+0xe0/0x138
[    5.630300] [<ffffffc0003d2a04>] mb_find_order_for_block+0x154/0x1b0
[    5.636641] [<ffffffc0003d2b2c>] mb_find_extent+0xcc/0x548
[    5.642116] [<ffffffc0003de6a8>] ext4_mb_complex_scan_group+0xe8/0x4e8
[    5.648632] [<ffffffc0003ded7c>] ext4_mb_regular_allocator+0x2d4/0x648
[    5.655148] [<ffffffc0003e2b4c>] ext4_mb_new_blocks+0x344/0x7e0
[    5.661056] [<ffffffc0003cbf54>] ext4_ext_map_blocks+0x684/0xf68
[    5.667052] [<ffffffc000393664>] ext4_map_blocks+0x12c/0x500
[    5.672699] [<ffffffc000398df4>] ext4_writepages+0x47c/0xe38
[    5.678348] [<ffffffc00020da20>] do_writepages+0x48/0xc8
[    5.683649] [<ffffffc0001f9100>] __filemap_fdatawrite_range+0x70/0xe8
[    5.690078] [<ffffffc0001f91b0>] filemap_flush+0x18/0x20
[    5.695378] [<ffffffc000394b64>] ext4_alloc_da_blocks+0x3c/0x78
[    5.701285] [<ffffffc0003ac1c8>] ext4_rename+0x690/0xe38
[    5.706585] [<ffffffc0003ac98c>] ext4_rename2+0x1c/0x40
[    5.711800] [<ffffffc0002d0510>] vfs_rename+0x2c0/0xa90
[    5.717013] [<ffffffc0002d661c>] SyS_renameat2+0x464/0x5c0
[    5.722486] [<ffffffc0002d6788>] SyS_renameat+0x10/0x18
[    5.727700] [<ffffffc000086d30>] el0_svc_naked+0x24/0x28
[    5.732998] ================================================================================

Which corresponds to:

1259 static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
1260 {
1261         int order = 1;
1262         void *bb;
1263 
1264         BUG_ON(e4b->bd_bitmap == e4b->bd_buddy);
1265         BUG_ON(block >= (1 << (e4b->bd_blkbits + 3)));
1266 
1267         bb = e4b->bd_buddy;
1268         while (order <= e4b->bd_blkbits + 1) {
1269                 block = block >> 1;
1270                 if (!mb_test_bit(block, bb)) {
1271                         /* this block is part of buddy of order 'order' */
1272                         return order;
1273                 }
1274                 bb += 1 << (e4b->bd_blkbits - order);
1275                 order++;
1276         }
1277         return 0;
1278 }

We allow an iteration when order == e4b->bd_blkbits + 1 and so we calculate a
shift amount of -1.

Any idea of what should be done in these cases?

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/405825.html
