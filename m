From: Joseph Fannin <jfannin@gmail.com>
Subject: JBD2/ext4 error
Date: Sun, 2 Nov 2008 19:48:27 -0500
Message-ID: <20081103004827.GA2766@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:64398 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYKCAsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 19:48:32 -0500
Received: by gxk5 with SMTP id 5so715090gxk.13
        for <linux-ext4@vger.kernel.org>; Sun, 02 Nov 2008 16:48:31 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm hitting what's probably a bug in ext4 on one of my boxes. It
always happens on the boot partition, which is extentless, since it
seems likely GRUB will choke on extents.

On with the backtrace, already:

[ 4586.330338] JBD: grub-probe wants too many credits (266 > 256)
[ 4586.330384] ext4_da_writepages: jbd2_start: 18691 pages, ino 39; err -28
[ 4586.330398] Pid: 7365, comm: grub-probe Not tainted 2.6.27.4-1jhf-686 #4
[ 4586.330456]  [<d806a2f4>] ext4_da_writepages+0x165/0x2c0 [ext4]
[ 4586.330562]  [<d80babf2>] scsi_pool_alloc_command+0x30/0x4a [scsi_mod]
[ 4586.330647]  [<c01dd1fd>] blk_rq_map_sg+0xf1/0x240
[ 4586.330671]  [<c01e4558>] kobject_get+0xf/0x13
[ 4586.330690]  [<d806a18f>] ext4_da_writepages+0x0/0x2c0 [ext4]
[ 4586.330726]  [<c015edf2>] do_writepages+0x20/0x30
[ 4586.330745]  [<c0193f24>] __writeback_single_inode+0x15e/0x314
[ 4586.330767]  [<c02c70b6>] _spin_unlock_irq+0x24/0x2e
[ 4586.330779]  [<c01606c0>] mark_page_accessed+0x37/0x53
[ 4586.330793]  [<c0159b43>] read_cache_page_async+0xf9/0x101
[ 4586.330802]  [<c019ca5c>] blkdev_readpage+0x0/0xc
[ 4586.330823]  [<c0194485>] generic_sync_sb_inodes+0x229/0x32d
[ 4586.330835]  [<c0194607>] sync_inodes_sb+0x7e/0x86
[ 4586.330845]  [<c017cefe>] __fsync_super+0xa/0x61
[ 4586.330861]  [<c017cf5d>] fsync_super+0x8/0x14
[ 4586.330869]  [<c0198903>] fsync_bdev+0x14/0x2b
[ 4586.330879]  [<c01dd507>] blkdev_ioctl+0xac/0x70d
[ 4586.330888]  [<c01e4558>] kobject_get+0xf/0x13
[ 4586.330897]  [<c01de7ed>] exact_lock+0x7/0xd
[ 4586.330907]  [<c0245352>] kobj_lookup+0x112/0x140
[ 4586.330927]  [<c01ddb68>] exact_match+0x0/0x7
[ 4586.330936]  [<c02c727d>] unlock_kernel+0x3b/0x45
[ 4586.330944]  [<c019c7e6>] do_open+0x20c/0x288
[ 4586.330956]  [<c019c862>] blkdev_open+0x0/0x4d
[ 4586.330966]  [<c019c887>] blkdev_open+0x25/0x4d
[ 4586.330975]  [<c017a159>] __dentry_open+0x15a/0x226
[ 4586.330985]  [<c017a2a2>] nameidata_to_filp+0x1c/0x2c
[ 4586.330994]  [<c0183997>] do_filp_open+0x327/0x64c
[ 4586.331006]  [<c019beb4>] block_ioctl+0x13/0x16
[ 4586.331016]  [<c019bea1>] block_ioctl+0x0/0x16
[ 4586.331024]  [<c01850b7>] vfs_ioctl+0x1c/0x5f
[ 4586.331035]  [<c01854c1>] do_vfs_ioctl+0x3c7/0x3f9
[ 4586.331044]  [<c02c6edb>] _spin_lock+0x10/0x12
[ 4586.331067]  [<c0175c32>] virt_to_head_page+0x1f/0x2a
[ 4586.331086]  [<c0179f98>] do_sys_open+0xaa/0xb2
[ 4586.331094]  [<c0185534>] sys_ioctl+0x41/0x58
[ 4586.331103]  [<c01039af>] sysenter_do_call+0x12/0x2f

This kernel is simply 2.6.27.4 with the 2.6.27-ext4-2 patch applied,
though I've seen it also in a kernel built from the Debian 2.6.26
sources with some ext4 patch applied too -- I'm not sure which, I
don't have the patch or the source around anymore.

The backtrace varies a bit, but ext4_da_writepages is always on top.
It's not always grub-probe that sets it off -- often it happens while
generating a new initrd.  The error message will continue to repeat
until the fs is unmounted.  It can then be mounted without a problem
with ext3, though the files that were being modified when ext4 started
complaining will be corrupted.  Ext3 works fine; fsck thinks the fs is
fine.

The filesystem is mounted in writeback mode, and the journal size is
4100k, according to dumpe2fs.  Another box here has a similar boot
partition with a 4114k journal, and I don't think it's ever done
this.

Actually, I have two other boxes with the same setup.  Their disks are
ide, though -- a sata disk in one, and ide driven via the pata
drivers in the other.  The one I'm seeing a problem with is SCSI-only,
using that aic7000-series driver.

I don't know what's causing this.  Is there something I can do to
track this down?

--
Joseph Fannin
jfannin@gmail.com

