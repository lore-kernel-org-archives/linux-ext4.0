From: Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Don't call sync_fs() from vfs_quota_off() when there's no quota turn off
Date: Tue,  6 May 2008 12:03:48 +0200
Message-ID: <12100682282206-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37297 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246AbYEFKDt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2008 06:03:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sometimes, vfs_quota_off() is called on a partially set up super block (for example
when fill_super() fails for some reason). In such cases we cannot call ->sync_fs()
because it can Oops because of not properly filled in super block. So in case we
find there's not quota to turn off, we just skip everything and return which fixes
the above problem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index dfba162..bdcb15e 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1491,6 +1491,16 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 
 	/* We need to serialize quota_off() for device */
 	mutex_lock(&dqopt->dqonoff_mutex);
+
+	/*
+	 * Skip everything if there's nothing to do. We have to do this becase
+	 * sometimes we are called when fill_super() failed and calling
+	 * sync_fs() in such cases does no good.
+	 */
+	if (!sb_any_quota_enabled(sb) && !sb_any_quota_suspended(sb)) {
+		mutex_unlock(&dqopt->dqonoff_mutex);
+		return 0;
+	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
-- 
1.5.2.4

