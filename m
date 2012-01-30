From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 1/2] ext3: Don't call dquot_free_block() if we don't update
 anything
Date: Mon, 30 Jan 2012 17:41:25 +0900
Message-ID: <4F2657B5.9050100@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43602 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2A3IoV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 03:44:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dquot_free_block() is called in the end of ext3_new_blocks() and updates
information of the inode structure. However, this update is not necessary
if the number of blocks we requested is equal to the number of
allocated blocks.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext3/balloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a203892..954a7d3 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1743,8 +1743,11 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	dquot_free_block(inode, *count-num);
-	*count = num;
+
+	if (num < *count) {
+		dquot_free_block(inode, *count-num);
+		*count = num;
+	}
 
 	trace_ext3_allocate_blocks(inode, goal, num,
 				   (unsigned long long)ret_block);
