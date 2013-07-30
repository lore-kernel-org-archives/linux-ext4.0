From: Sage Weil <sage@inktank.com>
Subject: crash in __jbd2_journal_file_buffer
Date: Tue, 30 Jul 2013 15:41:40 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:40886 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3G3Wlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jul 2013 18:41:40 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 3D88C8044E
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jul 2013 15:41:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 1A92C8044E
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jul 2013 15:41:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

Hit this on 3.10.  Is this a known issue?

Thanks-
sage


Stack traceback for pid 23944
0xffff8802206edeb0    23944    23840  1    2   R  0xffff8802206ee338 
*ceph-osd
 ffff88020bf17b78 0000000000000018 ffffffff81267398 ffff8802256d40c0
 ffff88020b5a1230 ffff88020bf17bb8 ffffffff81325d9c ffff88020b5a1230
 ffff8802256d40c0 ffff88020b5a1230 00000000698a8d24 ffff88020bf17be8
Call Trace:
 [<ffffffff81267398>] ? __jbd2_journal_file_buffer+0x188/0x260
 [<ffffffff81325d9c>] ? do_raw_spin_lock+0x10c/0x150
 [<ffffffff81268118>] ? do_get_write_access+0x448/0x650
 [<ffffffff81213caf>] ? ext4_read_inode_bitmap+0x9f/0x5f0
 [<ffffffff81167849>] ? kmem_cache_alloc+0x39/0x160
 [<ffffffff81268490>] ? jbd2_journal_get_write_access+0x30/0x50
 [<ffffffff81244d43>] ? __ext4_journal_get_write_access+0x43/0x90
 [<ffffffff812143d7>] ? ext4_free_inode+0x1d7/0x5d0
 [<ffffffff8121e601>] ? ext4_evict_inode+0x341/0x4d0
 [<ffffffff8121b268>] ? ext4_mark_inode_dirty+0x88/0x230
 [<ffffffff8121e610>] ? ext4_evict_inode+0x350/0x4d0
 [<ffffffff8118a098>] ? evict+0xb8/0x1c0
 [<ffffffff8118a9d5>] ? iput+0x105/0x190
 [<ffffffff8117d341>] ? do_unlinkat+0x201/0x270
 [<ffffffff8131e9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81180356>] ? SyS_unlink+0x16/0x20

