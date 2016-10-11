From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: correct endianness conversion in __xattr_check_inode()
Date: Tue, 11 Oct 2016 10:01:26 -0700
Message-ID: <1476205286-136713-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36169 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753376AbcJKRC1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2016 13:02:27 -0400
Received: by mail-pf0-f174.google.com with SMTP id e6so5034182pfk.3
        for <linux-ext4@vger.kernel.org>; Tue, 11 Oct 2016 10:02:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It should be cpu_to_le32(), not le32_to_cpu().  No change in behavior.

Found with sparse, and this was the only endianness warning in fs/ext4/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c15d633..e90c5cd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -241,7 +241,7 @@ __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
 	int error = -EFSCORRUPTED;
 
 	if (((void *) header >= end) ||
-	    (header->h_magic != le32_to_cpu(EXT4_XATTR_MAGIC)))
+	    (header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)))
 		goto errout;
 	error = ext4_xattr_check_names(entry, end, entry);
 errout:
-- 
2.8.0.rc3.226.g39d4020

