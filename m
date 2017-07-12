From: Emoly Liu <emoly.liu@intel.com>
Subject: [PATCH] ext4: error should be cleared if ea_inode isn't added to the cache
Date: Wed, 12 Jul 2017 03:56:53 +0000
Message-ID: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
Cc: linux-ext4@vger.kernel.org, Emoly Liu <emoly.liu@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [207.108.8.150] ([207.108.8.150]:57826 "HELO
        mail-1.trevis.hpdd.intel.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with SMTP id S1750729AbdGLEF0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Jul 2017 00:05:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For Lustre, if ea_inode fails in hash validation but passes parent
inode and generation checks, it won't be added to the cache as well
as the error "-EFSCORRUPTED" should be cleared, otherwise it will
cause "Structure needs cleaning" when running getfattr command.

Signed-off-by: Emoly Liu <emoly.liu@intel.com>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9723
---
 fs/ext4/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cff4f41..de217a0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -451,6 +451,7 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 		}
 		/* Do not add ea_inode to the cache. */
 		ea_inode_cache = NULL;
+		err = 0;
 	} else if (err)
 		goto out;
 
-- 
1.8.3.1
