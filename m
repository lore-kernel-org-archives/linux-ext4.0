From: Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
Date: Tue, 26 Jan 2016 11:59:19 +0000
Message-ID: <20160126115919.GA5126@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, aryabinin@virtuozzo.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mounting ext4 fs on 4.5.0-rc1

[ 1176.592557] ================================================================================
[ 1176.592565] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
[ 1176.592567] shift exponent -1 is negative
[ 1176.592571] CPU: 3 PID: 4976 Comm: QThread Not tainted 4.5.0-rc1 #252
[ 1176.592573] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B0A.1509130955 09/13/2015
[ 1176.592575]  0000000000000000 0000000000000000 ffffffff8379dede ffff88021f4bf8b8
[ 1176.592578]  ffffffff81b2e7d9 0000000000000007 ffff88021f4bf8e8 ffff88021f4bf8d0
[ 1176.592581]  ffffffff81bcb87d ffffffffffffffff ffff88021f4bf968 ffffffff81bcc1c1
[ 1176.592583] Call Trace:
[ 1176.592590]  [<ffffffff81b2e7d9>] dump_stack+0x45/0x6c
[ 1176.592595]  [<ffffffff81bcb87d>] ubsan_epilogue+0xd/0x40
[ 1176.592597]  [<ffffffff81bcc1c1>] __ubsan_handle_shift_out_of_bounds+0xf1/0x140
[ 1176.592601]  [<ffffffff8163a847>] ? ext4_mb_init_cache+0x677/0x1570
[ 1176.592604]  [<ffffffff81398ae9>] ? lru_cache_add+0x9/0x10
[ 1176.592607]  [<ffffffff81633c02>] mb_find_order_for_block+0x132/0x1e0
[ 1176.592609]  [<ffffffff81633e9e>] mb_find_extent+0xde/0x6d0
[ 1176.592611]  [<ffffffff81646bfb>] ext4_mb_complex_scan_group+0x14b/0x8a0
[ 1176.592614]  [<ffffffff816476f7>] ext4_mb_regular_allocator+0x3a7/0xcc0
[ 1176.592616]  [<ffffffff8164da45>] ext4_mb_new_blocks+0x4c5/0x1270
[ 1176.592620]  [<ffffffff8161b526>] ? ext4_ext_put_gap_in_cache+0x116/0x230
[ 1176.592622]  [<ffffffff816275fc>] ext4_ext_map_blocks+0x81c/0x2280
[ 1176.592626]  [<ffffffff8159e5f6>] ext4_map_blocks+0x1b6/0xe00
[ 1176.592628]  [<ffffffff815a0579>] ext4_getblk+0x49/0x290
[ 1176.592630]  [<ffffffff815a07ce>] ext4_bread+0xe/0xb0
[ 1176.592633]  [<ffffffff815b932d>] ext4_append+0xad/0x340
[ 1176.592635]  [<ffffffff815c6d84>] ext4_mkdir+0x344/0x970
[ 1176.592639]  [<ffffffff8147f5c3>] vfs_mkdir+0x103/0x310
[ 1176.592642]  [<ffffffff81487483>] SyS_mkdir+0x93/0x130
[ 1176.592645]  [<ffffffff82b40a57>] entry_SYSCALL_64_fastpath+0x12/0x6a
[ 1176.592647] ================================================================================
