From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] e2fsprogs : Add stricter checks for blocksize in ext2fs_open
Date: Fri, 11 Jul 2008 14:19:06 +0530
Message-ID: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:31865 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGKItI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 04:49:08 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1713809tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jul 2008 01:49:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below patch adds stricter checks in ext2fs_open() so that we catch bad
block sizes earlier than later.

============================================================================

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 lib/ext2fs/openfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index fc54afe..670cc7c 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -233,7 +233,9 @@ errcode_t ext2fs_open2(const char *name, const
char *io_options,
 	}
 	
 	fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
-	if (fs->blocksize == 0) {
+	if ((fs->blocksize < EXT2_MIN_BLOCK_SIZE) ||
+	    (fs->blocksize > EXT2_MAX_BLOCK_SIZE) ||
+	    (fs->blocksize % EXT2_MIN_BLOCK_SIZE != 0)) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-- 
1.5.4.3


============================================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
