From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 00/15] ext4: add new online resize
Date: Wed, 28 Dec 2011 23:07:38 -0500
Message-ID: <20111229040738.GK12370@thunk.org>
References: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44154 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab1L2EHn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 23:07:43 -0500
Content-Disposition: inline
In-Reply-To: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

FYI, I just updated the online resizes in the unstable portion of the
ext4 series to the V5 version.  Unfortunately, I was able to trigger a
BUG_ON at line 497 of resize.c trying to resize a simple ext3 file
system.  (See below)

I'd suggest that you use a regression test suite that tries a various
different mke2fs commands with -t ext3, -t ext4, as well as different
file system options (i.e., -t ext3 -O extents, -t ext4 -O bigalloc,
etc.)  Also make sure you try different sizes so that you we check
extending a flex_bg, growing a new flex_bg, etc.

In this particular case, the problem is that the resize code appears
to assume the uninit_bg file system feature aka
EXT4_FEATURE_RO_COMPAT_GDT_CSUM is always going to be set.

				   	  - Ted

# grep vdc /proc/partitions 
 254       32    5242880 vdc
# mke2fs -t ext3 /dev/vdc 512M
# mount /dev/vdc
# resize2fs /dev/vdc
resize2fs 1.42-WIP (16-Oct-2011)
Filesystem at /dev/vdc is mounted on /vdc; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
[  187.749591] ------------[ cut here ]------------
[  187.751725] kernel BUG at /usr/projects/linux/ext4/fs/ext4/resize.c:497!
[  187.752756] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  187.752756] Modules linked in:
[  187.752756] 
[  187.752756] Pid: 2204, comm: resize2fs Not tainted 3.2.0-rc6-00030-g82a1181 #46 Bochs Bochs
[  187.752756] EIP: 0060:[<c035281a>] EFLAGS: 00010202 CPU: 0
[  187.752756] EIP is at setup_new_flex_group_blocks+0x33f/0x6d2
[  187.752756] EAX: 00000001 EBX: f6297000 ECX: 00570a4a EDX: 00000000
[  187.752756] ESI: 00000000 EDI: 00000001 EBP: f62f3d8c ESP: f62f3d0c
[  187.752756]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  187.752756] Process resize2fs (pid: 2204, ti=f62f2000 task=f5eca940 task.ti=f62f2000)
[  187.752756] Stack:
[  187.752756]  c01ce2dc f6824ee0 00000020 0000001f 00000000 00000004 f6a2d778 f6297000
[  187.752756]  00020001 00000000 00000000 00000000 f6297c00 f62f3d6c f37877c0 00000004
[  187.752756]  f6ab9c30 f37877c0 00000000 f6824f2c 00020001 00000000 f6415168 c020b5a0
[  187.752756] Call Trace:
[  187.752756]  [<c01ce2dc>] ? trace_hardirqs_on_caller+0x10f/0x140
[  187.752756]  [<c020b5a0>] ? __delayacct_blkio_end+0x55/0x5b
[  187.752756]  [<c03534d4>] ext4_flex_group_add+0xc2/0x10c6
[  187.752756]  [<c0a33706>] ? __wait_on_bit+0x6e/0x77
[  187.752756]  [<c02bfcf5>] ? unmap_underlying_metadata+0x5d/0x5d
[  187.752756]  [<c02bfcf5>] ? unmap_underlying_metadata+0x5d/0x5d
[  187.752756]  [<c02847ec>] ? trace_kmalloc+0x2f/0x95
[  187.752756]  [<c035489d>] ? ext4_resize_fs+0x3c5/0xb56
[  187.752756]  [<c0284ca5>] ? __kmalloc+0x20d/0x219
[  187.752756]  [<c035489d>] ? ext4_resize_fs+0x3c5/0xb56
[  187.752756]  [<c0354d33>] ext4_resize_fs+0x85b/0xb56
[  187.752756]  [<c01cf1df>] ? lock_release_non_nested+0xb5/0x1e8
[  187.752756]  [<c03343a7>] ext4_ioctl+0xbcf/0xda4
[  187.752756]  [<c01bc804>] ? sched_clock_cpu+0x22e/0x23e
[  187.752756]  [<c01cba23>] ? trace_hardirqs_off+0xb/0xd
[  187.752756]  [<c0282f25>] ? slab_free_hook+0x5e/0x6b
[  187.752756]  [<c029d5e6>] vfs_ioctl+0x4a/0x78
[  187.752756]  [<c029ddf5>] do_vfs_ioctl+0x66d/0x67f
[  187.752756]  [<c0284725>] ? kmem_cache_free+0xe8/0x144
[  187.752756]  [<c02988b5>] ? putname+0x62/0x66
[  187.752756]  [<c02988b5>] ? putname+0x62/0x66
[  187.752756]  [<c028727e>] ? do_sys_open+0x12c/0x136
[  187.752756]  [<c029de7b>] sys_ioctl+0x74/0xaa
[  187.752756]  [<c0a3600d>] syscall_call+0x7/0xb
[  187.752756] Code: 83 e0 05 48 0f 95 c0 31 c9 0f b6 f8 b8 64 11 04 c1 89 fa e8 14 05 ed ff 8b 04 bd c8 6e 12 c1 40 85 ff 89 04 bd c8 6e 12 c1 74 04 <0f> 0b eb fe 8b 55 98 8b 7d c8 0f b7 04 7a d1 e8 83 e0 01 8b 14 
[  187.752756] EIP: [<c035281a>] setup_new_flex_group_blocks+0x33f/0x6d2 SS:ESP 0068:f62f3d0c
[  187.822687] ---[ end trace aa45447d850e7921 ]---
Segmentation fault

						- Ted


On Fri, Dec 23, 2011 at 04:14:50PM +0800, Yongqiang Yang wrote:
> Hi all,
> 
> This is the 5th version of patch series adding new online resize to ext4.
> 
> -- What's new resize implementation?
>    It is a new online resize interface for ext4.  It can be used via
>    ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating size
>    of the resized fs in block.
> 
> -- Difference between current resize and new resize.
>    New resize lets kernel do all work, like allocating bitmaps and
>    inode tables and can support flex_bg and BLOCK_UNINIT features.
>    Besides these, new resize is much faster than current resize.
> 
>    Below are benchmarks I made on my personal computer, fses with
>    flex_bg size = 16 were resized to 230GB evry time. The first
>    row shows the size of a fs from which the fs was resized to 230GB.
>    The datas were collected by 'time resize2fs'.
> 
>                       new resize
>                 20GB          50GB      100GB
>       real    0m3.558s     0m2.891s    0m0.394s
>       user    0m0.004s     0m0.000s    0m0.394s
>       sys     0m0.048s     0m0.048s    0m0.028s
> 
>                       current resize
>                 20GB          50GB      100GB
>       real    5m2.770s     4m43.757s  3m14.840s
>       user    0m0.040s     0m0.032s   0m0.024s
>       sys     0m0.464s     0m0.432s   0m0.324s
> 
>    According to data above, new resize is faster than current resize in both
>    user and sys time.  New resize performs well in sys time, because it
>    supports BLOCK_UNINIT and adds multi-groups each time.
> 
> -- About supporting new features.
>    YES! New resize can support new feature like bigalloc and exclude bitmap
>    easily.  Because it lets kernel do all work.
> 
>  V4->V5:
>    release resizing lock in error case of IOC_RESIZEFS
>    Thanks Djalal <tixxdz@opendz.org> for pointing it out and his patch for
>    IOC_GROUP_EXTEND and IOC_GROUP_ADD.
> 
>  V3->V4:
>    rename __ext4_group_extend to ext4_group_extend_no_check.
> 
>  V2->V3:
>    initialize block bitmap of last group.
>    remove code initalizing inode bitmap and inode tables.
> 
> Yongqiang.
> 
