Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECA5C636D3
	for <linux-ext4@archiver.kernel.org>; Tue,  7 Feb 2023 03:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjBGDEI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Feb 2023 22:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBGDDq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Feb 2023 22:03:46 -0500
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4BA2D58;
        Mon,  6 Feb 2023 19:03:25 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 1235E1A00A1C;
        Tue,  7 Feb 2023 11:03:54 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZXB-Qq9GzveJ; Tue,  7 Feb 2023 11:03:53 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 3B6951A0087E;
        Tue,  7 Feb 2023 11:03:53 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] ext4: extents: Modify the return value variable type and initialize the assignment
Date:   Thu,  9 Feb 2023 03:34:43 +0800
Message-Id: <20230208193443.3055-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Modify the return value variable to be consistent with the return value
type of the function, and modify the initialization assignment. Under
certain circumstances, the constant return value is not required.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 fs/ext4/extents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9de1c9d1a13d..debeb2e7a162 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4676,7 +4676,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct inode *inode = file_inode(file);
 	loff_t new_size = 0;
 	unsigned int max_blocks;
-	int ret = 0;
+	long ret = -EOPNOTSUPP;
 	int flags;
 	ext4_lblk_t lblk;
 	unsigned int blkbits = inode->i_blkbits;
@@ -4689,13 +4689,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 */
 	if (IS_ENCRYPTED(inode) &&
 	    (mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
-		return -EOPNOTSUPP;
+		return ret;
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
 		     FALLOC_FL_INSERT_RANGE))
-		return -EOPNOTSUPP;
+		return ret;
 
 	inode_lock(inode);
 	ret = ext4_convert_inline_data(inode);
-- 
2.18.2

