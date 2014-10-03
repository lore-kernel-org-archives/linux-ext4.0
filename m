From: Eric Whitney <enwlinux@gmail.com>
Subject: ext4 dev branch testing
Date: Fri, 3 Oct 2014 14:12:06 -0400
Message-ID: <20141003181205.GA2485@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45783 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJCSMK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2014 14:12:10 -0400
Received: by mail-qa0-f53.google.com with SMTP id v10so1179005qac.26
        for <linux-ext4@vger.kernel.org>; Fri, 03 Oct 2014 11:12:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've run regression tests on the ext4 kernel dev branch as found on 30
September on both an x86_64 VM and on ARM (Pandaboard ES).  I used
xfstest-bld's test infrastructure on my own VM in the x86_64 case, and on the
bare iron on ARM, running all the usual test scenarios and using the auto
group.  The same test environments had just been used for 3.17-rc7.

In this week's concall, Ted mentioned he had been seeing OOM kills during his
own testing of the dev branch.  I didn't in either of my runs.  My x86_64 VM
has 2 GB of memory, while the Pandaboard has 1 GB.

However, I am seeing apparent regressions affecting only the bigalloc and
bigalloc_1k test scenarios which bisect to:
713e8dde3e - ext4: fix ZERO_RANGE bug hidden by flag aliasing

This appears to result in multiple new test failures, including generic/269
(common to both architectures on bigalloc), and generic/127 (on bigalloc_1k).
There are also numerous new warnings in the kernel log for a range of tests
including these two.  These regressions are easily reproducable.

generic/269 fails its post-test fsck with bad i_blocks counts.  generic/127
does fail on 3.17-rc7, but on the dev branch now also fails its post-test
fsck with bad i_blocks counts.

Here's a typical warning as triggered by ext4/001 on bigalloc:

EXT4-fs warning (device vde): ext4_da_update_reserve_space:343: ext4_da_update_reserve_space: ino 12, used 1 with only 0 reserved data blocks
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1315 at fs/ext4/inode.c:344 ext4_da_update_reserve_space+0x180/0x190()
Modules linked in: quota_v2 quota_tree kvm_intel kvm microcode psmouse serio_raw virtio_balloon i2c_piix4
CPU: 1 PID: 1315 Comm: xfs_io Not tainted 3.17.0-rc2-ext4dev+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000009 ffff880025b27b58 ffffffff816ef0b3 0000000000000000
 ffff880025b27b90 ffffffff81056c1d ffff88006f8e6b60 0000000000000001
 0000000000000000 0000000000000002 ffff88002f4c4000 ffff880025b27ba0
Call Trace:
 [<ffffffff816ef0b3>] dump_stack+0x45/0x56
 [<ffffffff81056c1d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81056cfa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81259680>] ext4_da_update_reserve_space+0x180/0x190
 [<ffffffff81284ac6>] ext4_ext_map_blocks+0xcf6/0x1130
 [<ffffffff812597e1>] ext4_map_blocks+0x151/0x500
 [<ffffffff8125c847>] ? ext4_writepages+0x417/0xce0
 [<ffffffff8125ca86>] ext4_writepages+0x656/0xce0
 [<ffffffff811a7543>] ? kmem_cache_free+0x93/0x1c0
 [<ffffffff811615c1>] do_writepages+0x21/0x50
 [<ffffffff81156399>] __filemap_fdatawrite_range+0x59/0x60
 [<ffffffff811563ff>] filemap_write_and_wait+0x2f/0x60
 [<ffffffff811cc2ae>] do_vfs_ioctl+0x42e/0x520
 [<ffffffff811cc421>] SyS_ioctl+0x81/0xa0
 [<ffffffff816f8692>] system_call_fastpath+0x16/0x1b
---[ end trace 5d6b10aa9fac8fc0 ]---

The same warning is triggered by generic/269 on bigalloc and generic/127 on
bigalloc_1k.

I'm happy to supply more information if needed.

Thanks,
Eric
