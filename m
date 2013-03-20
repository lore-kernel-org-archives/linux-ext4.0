From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: grab write access inside ext4_file_dio_write
Date: Wed, 20 Mar 2013 16:48:17 +0400
Message-ID: <1363783698-28092-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:39059 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916Ab3CTMtR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 08:49:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are responsible hold write count before any fs-speciffic modifications
This patch should fix following warning:

WARNING: at fs/ext4/ext4_jbd2.c:50 __ext4_journal_start_sb+0x132/0x240()
Call Trace:
[<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
[<ffffffff81344f97>] ? ext4_da_write_begin+0x277/0x4f0
[<ffffffff8106fb6a>] warn_slowpath_null+0x1a/0x20
[<ffffffff8138a122>] __ext4_journal_start_sb+0x132/0x240
[<ffffffff81344f97>] ext4_da_write_begin+0x277/0x4f0
[<ffffffff811a0668>] generic_perform_write+0x148/0x3c0
[<ffffffff811a0944>] generic_file_buffered_write+0x64/0xd0
[<ffffffff811a5c90>] __generic_file_aio_write+0x4d0/0x750
[<ffffffff81335da3>] ext4_file_dio_write+0x253/0x4e0
[<ffffffff81336101>] ext4_file_write+0xd1/0x190
[<ffffffff81243072>] do_sync_write+0xb2/0x120
[<ffffffff8124332c>] ? rw_verify_area+0x12c/0x270
[<ffffffff812435f2>] vfs_write+0x182/0x1f0
[<ffffffff818ff605>] ? sysret_check+0x22/0x5d
[<ffffffff812445f4>] sys_write+0x94/0xd0
[<ffffffff818ff5d9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7e85a10..99918e4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -106,6 +106,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	    !is_sync_kiocb(iocb))
 		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
 
+	sb_start_write(inode->i_sb);
 	/* Unaligned direct AIO must be serialized; see comment above */
 	if (unaligned_aio) {
 		mutex_lock(ext4_aio_mutex(inode));
@@ -160,6 +161,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (unaligned_aio)
 		mutex_unlock(ext4_aio_mutex(inode));
 
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 
-- 
1.7.1

