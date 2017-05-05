From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Clear lockdep subtype for quota files on quota off
Date: Fri,  5 May 2017 10:53:27 +0200
Message-ID: <20170505085327.27103-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55467 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752769AbdEEIxe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 5 May 2017 04:53:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota files have special ranking of i_data_sem lock. We inform lockdep
about it when turning on quotas however when turning quotas off, we
don't clear the lockdep subclass from i_data_sem lock and thus when the
inode gets later reused for a normal file or directory, lockdep gets
confused and complains about possible deadlocks. Fix the problem by
resetting lockdep subclass of i_data_sem on quota off.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a9c72e39a4ee..77043dc7f704 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -846,14 +846,9 @@ static inline void ext4_quota_off_umount(struct super_block *sb)
 {
 	int type;
 
-	if (ext4_has_feature_quota(sb)) {
-		dquot_disable(sb, -1,
-			      DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
-	} else {
-		/* Use our quota_off function to clear inode flags etc. */
-		for (type = 0; type < EXT4_MAXQUOTAS; type++)
-			ext4_quota_off(sb, type);
-	}
+	/* Use our quota_off function to clear inode flags etc. */
+	for (type = 0; type < EXT4_MAXQUOTAS; type++)
+		ext4_quota_off(sb, type);
 }
 #else
 static inline void ext4_quota_off_umount(struct super_block *sb)
@@ -5476,7 +5471,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
 		goto out;
 
 	err = dquot_quota_off(sb, type);
-	if (err)
+	if (err || ext4_has_feature_quota(sb))
 		goto out_put;
 
 	inode_lock(inode);
@@ -5496,6 +5491,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
 out_unlock:
 	inode_unlock(inode);
 out_put:
+	lockdep_set_quota_inode(inode, I_DATA_SEM_NORMAL);
 	iput(inode);
 	return err;
 out:
-- 
2.12.0
