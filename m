From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] ext4: Kill ext4_mballoc_ready
Date: Mon, 22 Feb 2016 08:48:18 +0100
Message-ID: <1456127301-7702-9-git-send-email-jack@suse.cz>
References: <1456127301-7702-1-git-send-email-jack@suse.cz>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcBVHsI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 02:48:08 -0500
In-Reply-To: <1456127301-7702-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Gruenbacher <agruenba@redhat.com>

This variable, introduced in commit 9c191f70, is unnecessary: it is set
once the module has been initialized correctly, and ext4_fill_super
cannot run unless the module has been initialized correctly.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ecc37e103435..2f550519e0aa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -55,7 +55,6 @@
 
 static struct ext4_lazy_init *ext4_li_info;
 static struct mutex ext4_li_mtx;
-static int ext4_mballoc_ready;
 static struct ratelimit_state ext4_mount_msg_ratelimit;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -3795,12 +3794,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 
 no_journal:
-	if (ext4_mballoc_ready) {
-		sbi->s_mb_cache = ext4_xattr_create_cache();
-		if (!sbi->s_mb_cache) {
-			ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
-			goto failed_mount_wq;
-		}
+	sbi->s_mb_cache = ext4_xattr_create_cache();
+	if (!sbi->s_mb_cache) {
+		ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
+		goto failed_mount_wq;
 	}
 
 	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
@@ -5361,8 +5358,6 @@ static int __init ext4_init_fs(void)
 	err = ext4_init_mballoc();
 	if (err)
 		goto out2;
-	else
-		ext4_mballoc_ready = 1;
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -5378,7 +5373,6 @@ out:
 	unregister_as_ext3();
 	destroy_inodecache();
 out1:
-	ext4_mballoc_ready = 0;
 	ext4_exit_mballoc();
 out2:
 	ext4_exit_sysfs();
-- 
2.6.2

