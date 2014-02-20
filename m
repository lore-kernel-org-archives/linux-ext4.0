From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: Set pointer to NULL after ext2fs_free
Date: Thu, 20 Feb 2014 14:14:39 +0100
Message-ID: <1392902079-23416-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbaBTNOq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 08:14:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_free() does not set the ext2_filsys pointer to null so the caller
is responsible to setting it himself if it is needed.

This patch fixes some places where caller did not set ext2_filsys
pointer to NULL after ext2fs_free() which might result in use after
free. Fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/openfs.c | 7 ++++---
 resize/resize2fs.c  | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index aba8a50..b4122de 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -476,10 +476,11 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 	return 0;
 cleanup:
-	if (flags & EXT2_FLAG_NOFREE_ON_ERROR)
-		*ret_fs = fs;
-	else
+	if (!(flags & EXT2_FLAG_NOFREE_ON_ERROR)) {
 		ext2fs_free(fs);
+		fs = NULL;
+	}
+	*ret_fs = fs;
 	return retval;
 }
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 498cf99..8353338 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -209,6 +209,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	rfs->flags = flags;
 
 	ext2fs_free(rfs->old_fs);
+	rfs->old_fs = NULL;
 	if (rfs->itable_buf)
 		ext2fs_free_mem(&rfs->itable_buf);
 	if (rfs->reserve_blocks)
@@ -220,8 +221,10 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	return 0;
 
 errout:
-	if (rfs->new_fs)
+	if (rfs->new_fs) {
 		ext2fs_free(rfs->new_fs);
+		rfs->new_fs = NULL;
+	}
 	if (rfs->itable_buf)
 		ext2fs_free_mem(&rfs->itable_buf);
 	ext2fs_free_mem(&rfs);
-- 
1.8.3.1

