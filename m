From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 06/10] libquota: add error checking to quota_remove_inode
Date: Tue,  7 Jan 2014 09:53:10 -0500
Message-ID: <1389106394-31898-6-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46603 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaAGOxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:21 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #709475

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/mkquota.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index b920f27..9883216 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -89,8 +89,13 @@ void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 {
 	ext2_ino_t qf_ino;
+	errcode_t	retval;
 
-	ext2fs_read_bitmaps(fs);
+	retval = ext2fs_read_bitmaps(fs);
+	if (retval) {
+		log_err("Couldn't read bitmaps: %s", error_message(retval));
+		return retval;
+	}
 	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
 		fs->super->s_grp_quota_inum;
 	quota_set_sb_inum(fs, 0, qtype);
@@ -100,7 +105,11 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 
 	ext2fs_mark_super_dirty(fs);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	ext2fs_write_bitmaps(fs);
+	retval = ext2fs_write_bitmaps(fs);
+	if (retval) {
+		log_err("Couldn't write bitmaps: %s", error_message(retval));
+		return retval;
+	}
 	return 0;
 }
 
-- 
1.8.5.rc3.362.gdf10213

