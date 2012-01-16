From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH RESEND] ext4: make sure O_(D)SYNC semantic in ext4_fallocate()
Date: Mon, 16 Jan 2012 16:47:43 +0800
Message-ID: <1326703663-4801-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2APIoF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 03:44:05 -0500
Received: by iagf6 with SMTP id f6so2240032iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 00:44:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 must make sure the transaction to be commited to the disk when user opens
a file with O_(D)SYNC flag and do a fallocate(2) call.

This problem had been reported by Christoph Hellwig in this thread:
http://www.spinics.net/lists/linux-btrfs/msg13621.html

CC: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..00e32d9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4356,6 +4356,8 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
+		if (file->f_flags & O_SYNC)
+			ext4_handle_sync(handle);
 		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
-- 
1.7.4.1

