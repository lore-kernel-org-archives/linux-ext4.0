From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 10/30] ext4: snapshot file - read through to block device
Date: Mon,  9 May 2011 19:41:28 +0300
Message-ID: <1304959308-11122-11-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1EIQnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:41 -0400
Received: by wwa36 with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:39 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On active snapshot page read, the function ext4_snapshot_get_block()
is called to map the page to a disk block.  If the page is not mapped
in the snapshot file a direct mapping to the block device is returned.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4ec5f02..3acdbe5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4181,8 +4181,7 @@ static int ext4_no_writepage(struct page *page,
  * the snapshot COW bitmaps and a few initial blocks copied on snapshot_take().
  */
 static const struct address_space_operations ext4_snapfile_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
+	.readpage		= ext4_snapshot_readpage,
 	.writepage		= ext4_no_writepage,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
-- 
1.7.0.4

