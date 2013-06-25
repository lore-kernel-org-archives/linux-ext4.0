From: Nagachandra P <nagachandra@gmail.com>
Subject: (unknown)
Date: Tue, 25 Jun 2013 14:55:33 +0530
Message-ID: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Vikram MP <mp.vikram@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39054 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYJZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jun 2013 05:25:36 -0400
Received: by mail-lb0-f176.google.com with SMTP id z5so807422lbh.21
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jun 2013 02:25:33 -0700 (PDT)
Subject: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Here are some details on the platform

Linux kernel version - 3.4.5
Android - 4.2.2
ext4 mounted with *errors=panic* option.

We see memory allocation failures mostly caused by low memory kill the
ext4 process which is waiting for a allocation on slow path. (below is
one such instance)

select 26413 (AsyncTask #3), score_adj 647, adj 10,size 15287, to kill
send sigkill to 26413 (AsyncTask #3), score_adj 647,adj 10, size 15287
with ofree -450 10896, cfree 27845 984 msa 529 ma 8
AsyncTask #3: page allocation failure: order:0, mode:0x80050
[<c001595c>] (unwind_backtrace+0x0/0x11c) from [<c00dc064>]
(warn_alloc_failed+0xe8/0x110)
[<c00dc064>] (warn_alloc_failed+0xe8/0x110) from [<c00dee54>]
(__alloc_pages_nodemask+0x6d4/0x800)
[<c00dee54>] (__alloc_pages_nodemask+0x6d4/0x800) from [<c05fe250>]
(cache_alloc_refill+0x30c/0x6a4)
[<c05fe250>] (cache_alloc_refill+0x30c/0x6a4) from [<c0104eb4>]
(kmem_cache_alloc+0xa0/0x1b8)
[<c0104eb4>] (kmem_cache_alloc+0xa0/0x1b8) from [<c0192c34>]
(ext4_free_blocks+0x9c4/0xa08)
[<c0192c34>] (ext4_free_blocks+0x9c4/0xa08) from [<c01873bc>]
(ext4_ext_remove_space+0x690/0xd9c)
[<c01873bc>] (ext4_ext_remove_space+0x690/0xd9c) from [<c01897f8>]
(ext4_ext_truncate+0x100/0x1c8)
[<c01897f8>] (ext4_ext_truncate+0x100/0x1c8) from [<c016447c>]
(ext4_truncate+0xf4/0x194)
[<c016447c>] (ext4_truncate+0xf4/0x194) from [<c0166cc0>]
(ext4_setattr+0x36c/0x3f8)
[<c0166cc0>] (ext4_setattr+0x36c/0x3f8) from [<c011f540>]
(notify_change+0x1dc/0x2a8)
[<c011f540>] (notify_change+0x1dc/0x2a8) from [<c0107cc8>]
(do_truncate+0x74/0x90)
[<c0107cc8>] (do_truncate+0x74/0x90) from [<c0107e20>]
(do_sys_ftruncate+0x13c/0x144)
[<c0107e20>] (do_sys_ftruncate+0x13c/0x144) from [<c0108020>]
(sys_ftruncate+0x18/0x1c)
[<c0108020>] (sys_ftruncate+0x18/0x1c) from [<c000e140>]
(ret_fast_syscall+0x0/0x48)

followed by....

SLAB: Unable to allocate memory on node 0 (gfp=0x80050)
  cache: ext4_free_data, object size: 64, order: 0
  node 0: slabs: 0/0, objs: 0/0, free: 0
EXT4-fs error (device mmcblk0p26) in ext4_free_blocks:4700: Out of memory
Aborting journal on device mmcblk0p26-8.
EXT4-fs error (device mmcblk0p26): ext4_journal_start_sb:328: Detected
aborted journal
EXT4-fs (mmcblk0p26): Remounting filesystem read-only
Kernel panic - not syncing: EXT4-fs panic from previous error

[<c001595c>] (unwind_backtrace+0x0/0x11c) from [<c05fc5b4>] (panic+0x80/0x1cc)
[<c05fc5b4>] (panic+0x80/0x1cc) from [<c017ddec>] (__ext4_abort+0xc0/0xe0)
[<c017ddec>] (__ext4_abort+0xc0/0xe0) from [<c017dfa0>]
(ext4_journal_start_sb+0x194/0x1c4)
[<c017dfa0>] (ext4_journal_start_sb+0x194/0x1c4) from [<c0168c60>]
(ext4_dirty_inode+0x14/0x40)
[<c0168c60>] (ext4_dirty_inode+0x14/0x40) from [<c01293c0>]
(__mark_inode_dirty+0x2c/0x1b4)
[<c01293c0>] (__mark_inode_dirty+0x2c/0x1b4) from [<c011d6b8>]
(file_update_time+0xfc/0x11c)
[<c011d6b8>] (file_update_time+0xfc/0x11c) from [<c00d8f34>]
(__generic_file_aio_write+0x2d8/0x40c)
[<c00d8f34>] (__generic_file_aio_write+0x2d8/0x40c) from [<c00d90c8>]
(generic_file_aio_write+0x60/0xc8)
[<c00d90c8>] (generic_file_aio_write+0x60/0xc8) from [<c015f74c>]
(ext4_file_write+0x244/0x2b4)
[<c015f74c>] (ext4_file_write+0x244/0x2b4) from [<c0108a38>]
(do_sync_write+0x9c/0xd8)
[<c0108a38>] (do_sync_write+0x9c/0xd8) from [<c0109304>] (vfs_write+0xb0/0x128)
[<c0109304>] (vfs_write+0xb0/0x128) from [<c010953c>] (sys_write+0x38/0x64)
[<c010953c>] (sys_write+0x38/0x64) from [<c000e140>] (ret_fast_syscall+0x0/0x48)

Is there a way in which we could avoid ext4 panic caused by allocation
failure (a method other than setting errors=continue :-) )? (or is
memory allocation failure considered as fatal as any other IO error)

Thanks
Nagachandra
