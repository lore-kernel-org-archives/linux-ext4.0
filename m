From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] libext2fs : Fix memory leak in ext2fs_initialize().
Date: Sat, 23 Aug 2008 17:11:07 +0530
Message-ID: <ea11fea30808230441h680100d6k1e4524710e6d2d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:39406 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYHWLlJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 07:41:09 -0400
Received: by ti-out-0910.google.com with SMTP id b6so506253tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2008 04:41:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below patch ensures that cleanup is done properly in ext2fs_initialize
from all return paths in case of errors.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 lib/ext2fs/initialize.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 5ed4c06..aa4f424 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -254,8 +254,10 @@ retry:
 			super->s_frags_per_group = super->s_blocks_per_group *
 				frags_per_block;
 			goto retry;
-		} else
-			return EXT2_ET_TOO_MANY_INODES;
+		} else {
+			retval = EXT2_ET_TOO_MANY_INODES;
+			goto cleanup;
+		}
 	}

 	if (ipg > (unsigned) EXT2_MAX_INODES_PER_GROUP(super))
@@ -321,8 +323,10 @@ ipg_retry:
 			  fs->desc_blocks + super->s_reserved_gdt_blocks);

 	/* This can only happen if the user requested too many inodes */
-	if (overhead > super->s_blocks_per_group)
-		return EXT2_ET_TOO_MANY_INODES;
+	if (overhead > super->s_blocks_per_group) {
+		retval = EXT2_ET_TOO_MANY_INODES;
+		goto cleanup;
+	}

 	/*
 	 * See if the last group is big enough to support the
@@ -336,8 +340,10 @@ ipg_retry:
 		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
 	rem = ((super->s_blocks_count - super->s_first_data_block) %
 	       super->s_blocks_per_group);
-	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
-		return EXT2_ET_TOOSMALL;
+	if ((fs->group_desc_count == 1) && rem && (rem < overhead)) {
+		retval = EXT2_ET_TOOSMALL;
+		goto cleanup;
+	}
 	if (rem && (rem < overhead+50)) {
 		super->s_blocks_count -= rem;
 		goto retry;
-- 
1.5.4.3


Thanks -
Manish
