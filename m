From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 2/2] ext3: Don't update ctime in ext3_splice_branch()
Date: Mon, 30 Jan 2012 17:41:33 +0900
Message-ID: <4F2657BD.8030208@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41002 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2A3IoU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 03:44:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

VFS handles updating ctime, so we don't need to update i_ctime
in ext3_splace_branch().

I backport the following patch for ext3:
http://marc.info/?l=linux-ext4&m=124505184027078&w=4

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext3/inode.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2d0afec..95cb0d1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -795,10 +795,6 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 	}
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
