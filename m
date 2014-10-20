From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: fs: ext4: mballoc: negative shift exponent
Date: Mon, 20 Oct 2014 15:16:49 +0400
Message-ID: <5444EF21.8020501@samsung.com>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.cz>,
	Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-reply-to: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

I've got the following spew on mounting ext4 rootfs on kernel with UBSan:

================================================================================
UBSan: Undefined behaviour in ../fs/ext4/mballoc.c:2589:15
shift exponent -1 is negative
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc1+ #65
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000010 0000000000000000 0000000000000001 ffff88013ab0f998
 ffffffff82ade70a 0000000000000082 ffffffffffffffff ffff88013ab0f9a8
 ffffffff819a5339 ffff88013ab0fa58 ffffffff819a5825 ffff8800bb0c7840
Call Trace:
dump_stack (/home/andrew/linux/ubsan_x86//lib/dump_stackc:52)
ubsan_epilogue (/home/andrew/linux/ubsan_x86//lib/ubsanc:159)
__ubsan_handle_shift_out_of_bounds (/home/andrew/linux/ubsan_x86//lib/ubsanc:458)
? e1000_phy_get_info (/home/andrew/linux/ubsan_x86//drivers/net/ethernet/intel/e1000/e1000_hwc:3385 /home/andrew/linux/ubsan_x86//drivers/net/ethernet/intel/e1000/e1000_hwc:3455)
? put_online_cpus (/home/andrew/linux/ubsan_x86//kernel/cpuc:126)
? kmem_cache_create (/home/andrew/linux/ubsan_x86//mm/slab_commonc:431)
ext4_mb_init (/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:2589 (discriminator 1))
? ext4_setup_system_zone (/home/andrew/linux/ubsan_x86//fs/ext4/block_validityc:150)
ext4_fill_super (/home/andrew/linux/ubsan_x86//fs/ext4/superc:4101)
? register_shrinker (/home/andrew/linux/ubsan_x86//mm/vmscanc:207)
mount_bdev (/home/andrew/linux/ubsan_x86//fs/superc:1004)
? ext4_calculate_overhead (/home/andrew/linux/ubsan_x86//fs/ext4/superc:3374)
ext4_mount (/home/andrew/linux/ubsan_x86//fs/ext4/superc:5404)
mount_fs (/home/andrew/linux/ubsan_x86//fs/superc:1106)
vfs_kern_mount (/home/andrew/linux/ubsan_x86//fs/namespacec:908)
do_mount (/home/andrew/linux/ubsan_x86//fs/namespacec:2292 /home/andrew/linux/ubsan_x86//fs/namespacec:2607)
SyS_mount (/home/andrew/linux/ubsan_x86//fs/namespacec:2799 /home/andrew/linux/ubsan_x86//fs/namespacec:2774)
mount_block_root (/home/andrew/linux/ubsan_x86//init/do_mountsc:364 /home/andrew/linux/ubsan_x86//init/do_mountsc:393)
? done_path_create (/home/andrew/linux/ubsan_x86//fs/nameic:3366)
mount_root (/home/andrew/linux/ubsan_x86//init/do_mountsc:534)
prepare_namespace (/home/andrew/linux/ubsan_x86//init/do_mountsc:592)
kernel_init_freeable (/home/andrew/linux/ubsan_x86//init/mainc:903 /home/andrew/linux/ubsan_x86//init/mainc:1032)
? rest_init (/home/andrew/linux/ubsan_x86//init/mainc:931)
kernel_init (/home/andrew/linux/ubsan_x86//init/mainc:936)
ret_from_fork (/home/andrew/linux/ubsan_x86//arch/x86/kernel/entry_64S:348)
? rest_init (/home/andrew/linux/ubsan_x86//init/mainc:931)
================================================================================

And similar in another place:

================================================================================
UBSan: Undefined behaviour in ../fs/ext4/mballoc.c:1263:11
shift exponent -1 is negative
CPU: 2 PID: 1426 Comm: mktemp Not tainted 3.18.0-rc1+ #65
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000010 0000000000000000 0000000000000001 ffff8800babe7778
 ffffffff82ade70a 00000000000000bc ffffffffffffffff ffff8800babe7788
 ffffffff819a5339 ffff8800babe7838 ffffffff819a5825 ffff8800bb11ae68
Call Trace:
dump_stack (/home/andrew/linux/ubsan_x86//lib/dump_stackc:52)
ubsan_epilogue (/home/andrew/linux/ubsan_x86//lib/ubsanc:159)
__ubsan_handle_shift_out_of_bounds (/home/andrew/linux/ubsan_x86//lib/ubsanc:458)
? ext4_mb_init_cache (/home/andrew/linux/ubsan_x86//include/linux/buffer_headh:286 /home/andrew/linux/ubsan_x86//fs/ext4/mballocc:961)
mb_find_order_for_block (/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:1263 (discriminator 1))
mb_find_extent (/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:1512)
ext4_mb_complex_scan_group (/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:1947)
? pagecache_get_page (/home/andrew/linux/ubsan_x86//mm/filemapc:1102)
? ext4_mark_iloc_dirty (/home/andrew/linux/ubsan_x86//fs/ext4/inodec:4301 /home/andrew/linux/ubsan_x86//fs/ext4/inodec:4732)
ext4_mb_regular_allocator (/home/andrew/linux/ubsan_x86//fs/ext4/ext4h:1346 /home/andrew/linux/ubsan_x86//fs/ext4/ext4h:2516 /home/andrew/linux/ubsan_x86//fs/ext4/ext4h:2551
/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:2185)
? ext4_get_group_no_and_offset (/home/andrew/linux/ubsan_x86//fs/ext4/ballocc:61)
ext4_mb_new_blocks (/home/andrew/linux/ubsan_x86//fs/ext4/mballocc:4475)
? ext4_inode_to_goal_block (/home/andrew/linux/ubsan_x86//fs/ext4/ballocc:870)
ext4_ext_map_blocks (/home/andrew/linux/ubsan_x86//fs/ext4/extentsc:4455)
ext4_map_blocks (/home/andrew/linux/ubsan_x86//fs/ext4/inodec:611)
? __ext4_new_inode (/home/andrew/linux/ubsan_x86//fs/ext4/iallocc:1061)
ext4_getblk (/home/andrew/linux/ubsan_x86//fs/ext4/inodec:751)
ext4_bread (/home/andrew/linux/ubsan_x86//fs/ext4/inodec:805)
ext4_append (/home/andrew/linux/ubsan_x86//fs/ext4/nameic:66 (discriminator 3))
ext4_mkdir (/home/andrew/linux/ubsan_x86//fs/ext4/nameic:2404 /home/andrew/linux/ubsan_x86//fs/ext4/nameic:2452)
? security_inode_permission (/home/andrew/linux/ubsan_x86//security/securityc:573)
vfs_mkdir (/home/andrew/linux/ubsan_x86//fs/nameic:3494)
SyS_mkdir (/home/andrew/linux/ubsan_x86//fs/nameic:3517 /home/andrew/linux/ubsan_x86//fs/nameic:3500 /home/andrew/linux/ubsan_x86//fs/nameic:3527 /home/andrew/linux/ubsan_x86//fs/nameic:3525)
system_call_fastpath (/home/andrew/linux/ubsan_x86//arch/x86/kernel/entry_64S:423)
================================================================================


