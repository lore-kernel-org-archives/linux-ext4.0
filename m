From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext2: trivial: fix a typo on comment in ext2/inode.c
Date: Thu,  9 Sep 2010 01:14:49 +0900
Message-ID: <1283962489-15842-1-git-send-email-namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36318 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0IHQO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 12:14:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'ext3_get_branch' should be 'ext2_get_branch'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 940c961..860d715 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -662,7 +662,7 @@ static int ext2_get_blocks(struct inode *inode,
 	mutex_lock(&ei->truncate_mutex);
 	/*
 	 * If the indirect block is missing while we are reading
-	 * the chain(ext3_get_branch() returns -EAGAIN err), or
+	 * the chain(ext2_get_branch() returns -EAGAIN err), or
 	 * if the chain has been changed after we grab the semaphore,
 	 * (either because another process truncated this branch, or
 	 * another get_block allocated this branch) re-grab the chain to see if
-- 
1.7.2.2

