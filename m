From: Hugh Dickins <hughd@google.com>
Subject: next/mmotm: ext4 causes !rwsem_is_locked warnings
Date: Thu, 27 Sep 2012 14:05:00 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1209271334560.2226@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44723 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2I0VFs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 17:05:48 -0400
Received: by ieak13 with SMTP id k13so5676243iea.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2012 14:05:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

mmotm (or next) now gives me lots of WARNING at fs/fs-writeback.c:1312 from
writeback_inodes_sb_nr().  That's WARN_ON(!rwsem_is_locked(&sb->s_umount))
(some useful safety from hch) in writeback_inodes_sb_nr().

Your commit 40e684e5c597a98996cf4616e31fb2581ec82060
"ext4: fix potential deadlock in ext4_nonda_switch()" needs more change
to fs/fs-writeback.c.  I guess I'm the only one using a nearly full ext4.

I am, of course, applying the patch at the bottom to my tree for now;
but I think you'd do better not to eliminate that check.  Maybe add a
special wb_reason for your case, and skip rwsem check in that case.

Hugh

WARNING: at fs/fs-writeback.c:1312 writeback_inodes_sb_nr+0x6e/0xca()
Hardware name: GU658AA-ABU a6250.uk
ACPI: Invalid Power Resource to register!
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
Pid: 20839, comm: objcopy Not tainted 3.6.0-rc7-mm1 #1
Call Trace:
[<ffffffff8102f7b7>] warn_slowpath_common+0x80/0x98
[<ffffffff8102f7e4>] warn_slowpath_null+0x15/0x17
[<ffffffff810f55a8>] writeback_inodes_sb_nr+0x6e/0xca
[<ffffffff810f58a1>] writeback_inodes_sb+0x22/0x29
[<ffffffff81131b2a>] ext4_nonda_switch+0x8b/0x93
[<ffffffff81134cda>] ext4_da_write_begin+0x48/0x180
[<ffffffff8108718d>] generic_perform_write+0xc0/0x1e0
[<ffffffff81087300>] generic_file_buffered_write+0x53/0x7d
[<ffffffff81088c64>] __generic_file_aio_write+0x2a5/0x2d5
[<ffffffff81088d05>] generic_file_aio_write+0x71/0xda
[<ffffffff8112f203>] ext4_file_write+0xb0/0xb7
[<ffffffff810d6f0a>] do_sync_write+0x98/0xd5
[<ffffffff810d75d2>] vfs_write+0xb0/0x12c
[<ffffffff810d783f>] sys_write+0x4f/0x79
[<ffffffff813b6732>] system_call_fastpath+0x16/0x1b

---
 fs/fs-writeback.c |    1 -
 1 file changed, 1 deletion(-)

--- mmotm/fs/fs-writeback.c	2012-09-26 10:15:29.368071559 -0700
+++ linux/fs/fs-writeback.c	2012-09-26 22:38:25.648719969 -0700
@@ -1309,7 +1309,6 @@ void writeback_inodes_sb_nr(struct super
 
 	if (sb->s_bdi == &noop_backing_dev_info)
 		return;
-	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 }
