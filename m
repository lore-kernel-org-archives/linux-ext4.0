From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] quota: Handle Q_GETNEXTQUOTA when quota is disabled
Date: Tue, 29 Mar 2016 18:11:43 +0200
Message-ID: <1459267904-10755-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we oopsed when Q_GETNEXTQUOTA got called when quota was
disabled. Properly check whether quota is enabled for the filesystem
before calling into quota format handler.

Reported-by: Ted Tso <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

I have queue this fix for the bug Ted reported and will push it to Linus soon.

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index ba827daea5a0..ff21980d0119 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2047,11 +2047,20 @@ int dquot_get_next_id(struct super_block *sb, struct kqid *qid)
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int err;
 
-	if (!dqopt->ops[qid->type]->get_next_id)
-		return -ENOSYS;
+	mutex_lock(&dqopt->dqonoff_mutex);
+	if (!sb_has_quota_active(sb, qid->type)) {
+		err = -ESRCH;
+		goto out;
+	}
+	if (!dqopt->ops[qid->type]->get_next_id) {
+		err = -ENOSYS;
+		goto out;
+	}
 	mutex_lock(&dqopt->dqio_mutex);
 	err = dqopt->ops[qid->type]->get_next_id(sb, qid);
 	mutex_unlock(&dqopt->dqio_mutex);
+out:
+	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	return err;
 }
-- 
2.6.2

