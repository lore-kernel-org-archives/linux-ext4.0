From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 10/12] fuse2fs: refuse to mount fs with ea_inode feature
Date: Mon, 26 Jun 2017 06:43:46 -0700
Message-ID: <20170626134348.1240-10-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:32850 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdFZNoV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:21 -0400
Received: by mail-pg0-f49.google.com with SMTP id f127so741649pgc.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:15 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_xattr_set() currently does not support creating xattr inodes,
so allowing fuse2fs to mount a filesystem with ea_inode feature could
lead to corruption. Refuse to mount if the ea_inode feature is set.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 misc/fuse2fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index b5897685c466..956348f8f876 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3786,6 +3786,12 @@ int main(int argc, char *argv[])
 	global_fs->priv_data = &fctx;
 
 	ret = 3;
+	if (ext2fs_has_feature_ea_inode(global_fs->super)) {
+		printf(_("%s: fuse2fs does not support ea_inode feature.\n"),
+		       fctx.device);
+		goto out;
+	}
+
 	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
 		if (!fctx.ro) {
 			printf(_("%s: recovering journal\n"), fctx.device);
-- 
2.13.1.611.g7e3b11ae1-goog
