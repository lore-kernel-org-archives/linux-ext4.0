From: Matteo Croce <matteo@openwrt.org>
Subject: EXT4-fs error in ext4_reserve_inode_write: Journal has aborted
Date: Thu, 21 May 2009 01:35:24 +0200
Message-ID: <40101cc30905201635t6af2586bne1acbc77216628ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:25207 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZETXfn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 19:35:43 -0400
Received: by ey-out-2122.google.com with SMTP id 9so236857eyd.37
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 16:35:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When launching a web browser in normal desktop usage, I get this and
the disk mounted read only:

[ 1101.535101] EXT4-fs error (device sda1) in
ext4_reserve_inode_write: Journal has aborted
[ 1101.535114] Remounting filesystem read-only
[ 1101.535622] EXT4-fs error (device sda1) in
ext4_reserve_inode_write: Journal has aborted
[ 1101.535637] EXT4-fs error (device sda1) in ext4_dirty_inode:
Journal has aborted
[ 1101.535669] mpage_da_map_blocks block allocation failed for inode
1867 at logical offset 0 with max blocks 1 with error -30
[ 1101.535681] This should not happen.!! Data will be lost
[ 1101.535703] ext4_da_writepages: jbd2_start: 1024 pages, ino 1867; err -30
[ 1101.535716] Pid: 26, comm: pdflush Not tainted 2.6.29.1 #12
[ 1101.535724] Call Trace:
[ 1101.535744]  [<c038602c>] ? printk+0x18/0x1c
[ 1101.535862]  [<c01e5999>] ext4_da_writepages+0x409/0x430
[ 1101.535879]  [<c01e7670>] ? ext4_da_get_block_write+0x0/0x210
[ 1101.535893]  [<c01e5590>] ? ext4_da_writepages+0x0/0x430
[ 1101.535907]  [<c0174f6e>] do_writepages+0x2e/0x50
[ 1101.535921]  [<c01b4748>] __writeback_single_inode+0x88/0x500
[ 1101.535936]  [<c0122957>] ? set_next_entity+0x97/0x180
[ 1101.535950]  [<c01b4f73>] generic_sync_sb_inodes+0x283/0x410
[ 1101.535963]  [<c01b52b7>] writeback_inodes+0x47/0xd0
[ 1101.535975]  [<c01750e2>] wb_kupdate+0xb2/0x120
[ 1101.535988]  [<c01761d2>] pdflush+0x112/0x1d0
[ 1101.536000]  [<c0175030>] ? wb_kupdate+0x0/0x120
[ 1101.536160]  [<c01760c0>] ? pdflush+0x0/0x1d0
[ 1101.536173]  [<c0144e6c>] kthread+0x3c/0x70
[ 1101.536184]  [<c0144e30>] ? kthread+0x0/0x70
[ 1101.536198]  [<c0103cdb>] kernel_thread_helper+0x7/0x1c
[ 1101.536417] journal commit I/O error
