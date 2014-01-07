From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/10] libquota: add error checking to quota_write_inode()
Date: Tue,  7 Jan 2014 09:53:09 -0500
Message-ID: <1389106394-31898-5-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46599 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaAGOxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:21 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #709476

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/mkquota.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 3aa8100..b920f27 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -133,11 +133,16 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 	fs = qctx->fs;
 	retval = ext2fs_get_mem(sizeof(struct quota_handle), &h);
 	if (retval) {
-		log_err("Unable to allocate quota handle");
+		log_err("Unable to allocate quota handle: %s",
+			error_message(retval));
 		goto out;
 	}
 
-	ext2fs_read_bitmaps(fs);
+	retval = ext2fs_read_bitmaps(fs);
+	if (retval) {
+		log_err("Couldn't read bitmaps: %s", error_message(retval));
+		goto out;
+	}
 
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if ((qtype != -1) && (i != qtype))
@@ -171,7 +176,11 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	}
 
-	ext2fs_write_bitmaps(fs);
+	retval = ext2fs_write_bitmaps(fs);
+	if (retval) {
+		log_err("Couldn't write bitmaps: %s", error_message(retval));
+		goto out;
+	}
 out:
 	if (h)
 		ext2fs_free_mem(&h);
-- 
1.8.5.rc3.362.gdf10213

