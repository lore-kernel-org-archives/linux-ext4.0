From: Graham Murray <graham@gmurray.org.uk>
Subject: Block allocation failed
Date: Wed, 19 Aug 2009 06:27:46 +0100
Message-ID: <87iqgk8jal.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newton.gmurray.org.uk ([81.2.114.237]:43962 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZHSFtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 01:49:04 -0400
Received: from newton.gmurray.org.uk (localhost [127.0.0.1])
	by newton.gmurray.org.uk (8.14.3/8.14.3) with ESMTP id n7J5Rl8t008879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 06:27:47 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Shortly after rebooting following an untidy shutdown due to an unrelated
(to ext4 or the filesystem) Oops. Unmounting the partition and running
e2fsck (version 1.41.8) just replayed the journal and stated the
filesystem was clean but I did not believe it so ran 'e2fsck -f
/dev/sdb3' and that showed several errors which I allowed it to correct.

Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 35: 3499 blocks in bitmap, 3243 in gd
Aug 18 23:50:07 newton Aborting journal on device sdb3:8.
Aug 18 23:50:07 newton EXT4-fs (sdb3): Remounting filesystem read-only
Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 36: 2941 blocks in bitmap, 2429 in gd
Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 37: 6806 blocks in bitmap, 5782 in gd
Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 49: 5616 blocks in bitmap, 5730 in gd
Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 65: 12586 blocks in bitmap, 12524 in gd
Aug 18 23:50:07 newton mpage_da_map_blocks block allocation failed for inode 275405 at logical offset 0 with max blocks 1 with error -30
Aug 18 23:50:07 newton This should not happen.!! Data will be lost
Aug 18 23:50:07 newton ext4_da_writepages: jbd2_start: 1023 pages, ino 275405; err -30
Aug 18 23:50:07 newton Pid: 344, comm: pdflush Not tainted 2.6.31-rc6-00043-g894ef82 #2
Aug 18 23:50:07 newton Call Trace:
Aug 18 23:50:07 newton [<c05d512b>] ? printk+0x23/0x36
Aug 18 23:50:07 newton [<c0258533>] ext4_da_writepages+0x463/0x4a0
Aug 18 23:50:07 newton [<c01bb54e>] do_writepages+0x2e/0x60
Aug 18 23:50:07 newton [<c0207bbb>] writeback_single_inode+0x16b/0x3c0
Aug 18 23:50:07 newton [<c013109a>] ? set_next_entity+0x15a/0x190
Aug 18 23:50:07 newton [<c02080d5>] generic_sync_sb_inodes+0x165/0x4d0
Aug 18 23:50:07 newton [<c020854e>] writeback_inodes+0x6e/0x110
Aug 18 23:50:07 newton [<c01ba222>] wb_kupdate+0xa2/0x120
Aug 18 23:50:07 newton [<c01bbc40>] ? pdflush+0x0/0x1f0
Aug 18 23:50:07 newton [<c01bbd26>] pdflush+0xe6/0x1f0
Aug 18 23:50:07 newton [<c01ba180>] ? wb_kupdate+0x0/0x120
Aug 18 23:50:07 newton [<c0160304>] kthread+0x84/0x90
Aug 18 23:50:07 newton [<c0160280>] ? kthread+0x0/0x90
Aug 18 23:50:07 newton [<c0103e3f>] kernel_thread_helper+0x7/0x18
Aug 18 23:56:29 newton EXT4-fs: mballoc: 0 blocks 1 reqs (0 success)
Aug 18 23:56:29 newton EXT4-fs: mballoc: 1 extents scanned, 0 goal hits, 1 2^N hits, 0 breaks, 0 lost
Aug 18 23:56:29 newton EXT4-fs: mballoc: 67 generated and it took 5291480
Aug 18 23:56:29 newton EXT4-fs: mballoc: 512 preallocated, 0 discarded
Aug 18 23:56:29 newton EXT4-fs error (device sdb3): ext4_put_super: Couldn't clean up the journal
