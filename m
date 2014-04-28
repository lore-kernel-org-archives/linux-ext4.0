From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] resize2fs: fix inode table move for the backwards move case
Date: Mon, 28 Apr 2014 10:09:39 -0400
Message-ID: <1398694179-18027-2-git-send-email-tytso@mit.edu>
References: <1398694179-18027-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37223 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392AbaD1OJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 10:09:45 -0400
In-Reply-To: <1398694179-18027-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the case where the new location of the inode table is before the
old inode table, the optimization which tries to optimize zero block
moves breaks.  Fix it.

This fixes a bug that was tickled by the reproduction described in the
previous commit.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0d968fa..c672cdb 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1869,6 +1869,8 @@ static errcode_t move_itables(ext2_resize_t rfs)
 
 		if (!diff)
 			continue;
+		if (diff < 0)
+			diff = 0;
 
 		retval = io_channel_read_blk64(fs->io, old_blk,
 					       fs->inode_blocks_per_group,
-- 
1.9.0

