From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount
Date: Thu, 13 Mar 2008 14:06:15 +0100
Message-ID: <20080313130615.GJ12523@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Michael Tokarev <mjt@tls.msk.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35687 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754059AbYCMNGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 09:06:16 -0400
Content-Disposition: inline
In-Reply-To: <20080313125944.GF12523@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update reiserfs to handle quotaon on remount RW.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 super.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 3e1972d..f8f9a47 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -304,7 +304,7 @@ static int finish_unfinished(struct super_block *s)
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(s)->files[i])
-			vfs_quota_off(s, i);
+			vfs_quota_off(s, i, 0);
 	}
 	if (ms_active_set)
 		/* Restore the flag back */
@@ -634,7 +634,7 @@ static int reiserfs_acquire_dquot(struct dquot *);
 static int reiserfs_release_dquot(struct dquot *);
 static int reiserfs_mark_dquot_dirty(struct dquot *);
 static int reiserfs_write_info(struct super_block *, int);
-static int reiserfs_quota_on(struct super_block *, int, int, char *);
+static int reiserfs_quota_on(struct super_block *, int, int, char *, int);
 
 static struct dquot_operations reiserfs_quota_operations = {
 	.initialize = reiserfs_dquot_initialize,
@@ -2015,13 +2015,16 @@ static int reiserfs_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
-			     char *path)
+			     char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
+	/* No more checks needed? Path and format_id are bogus anyway... */
+	if (remount)
+		return vfs_quota_on(sb, type, format_id, path, 1);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -2041,7 +2044,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
 	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
 		path_put(&nd.path);
-		return vfs_quota_on(sb, type, format_id, path);
+		return vfs_quota_on(sb, type, format_id, path, 0);
 	}
 	/* Quotafile not of fs root? */
 	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
@@ -2049,7 +2052,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, 0);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
