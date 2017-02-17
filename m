From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ext4: fix spelling mistake: "alligned" -> "aligned"
Date: Fri, 17 Feb 2017 20:28:20 +0000
Message-ID: <20170217202820.21758-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50263 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934271AbdBQUtg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Feb 2017 15:49:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in debhg message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 578f8c3..ae4d1b6 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -511,7 +511,7 @@ mext_check_arguments(struct inode *orig_inode,
 	if ((orig_start & ~(PAGE_MASK >> orig_inode->i_blkbits)) !=
 	    (donor_start & ~(PAGE_MASK >> orig_inode->i_blkbits))) {
 		ext4_debug("ext4 move extent: orig and donor's start "
-			"offset are not alligned [ino:orig %lu, donor %lu]\n",
+			"offset are not aligned [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
-- 
2.10.2
