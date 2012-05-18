From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext2: trivial fix to comment for ext2_free_blocks
Date: Fri, 18 May 2012 15:04:45 +0800
Message-ID: <4FB5F48D.1090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54756 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2ERHE7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2012 03:04:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function is ext2_free_blocks(), not ext2_free_blocks_sb().

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext2/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index a8cbe1b..1a6bf5e 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -479,7 +479,7 @@ void ext2_discard_reservation(struct inode *inode)
 }
 
 /**
- * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
+ * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
  * @inode:		inode
  * @block:		start physcial block to free
  * @count:		number of blocks to free
-- 
1.7.1

