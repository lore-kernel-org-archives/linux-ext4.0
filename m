From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: fix type mismatch bug in the largedir patch
Date: Fri, 14 Apr 2017 16:56:40 -0400
Message-ID: <20170414205640.31710-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38756 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbdDNU4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Apr 2017 16:56:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit ae9efd05a986: "e2fsck: 3 level hash tree directory
optimization" introduced a bug when checking for the largedir feature.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---

I should have noticed the build warning sooner, but then again, so the
patch author should have as well.  :-)

 e2fsck/pass2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index fc98e833..09b79c3b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -978,7 +978,7 @@ static int check_dir_block(ext2_filsys fs,
 	 * very large and then the files are deleted. For now, all that is
 	 * needed is to avoid e2fsck filling in these holes as part of
 	 * feature flag. */
-	if (db->blk == 0 && ext2fs_has_feature_largedir(fs))
+	if (db->blk == 0 && ext2fs_has_feature_largedir(fs->super))
 		return 0;
 
 	if (db->blk == 0 && !inline_data_size) {
-- 
2.11.0.rc0.7.gbe5a750
