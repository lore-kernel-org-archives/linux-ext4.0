From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas
Date: Tue, 29 Mar 2016 18:11:44 +0200
Message-ID: <1459267904-10755-2-git-send-email-jack@suse.cz>
References: <1459267904-10755-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459267904-10755-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When Q_GETNEXTQUOTA was called for filesystem with quotas disabled
ocfs2_get_next_id() oopses. Fix the problem by checking early whether
the filesystem has quotas enabled.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 3892f3c079ca..ab6a6cdcf91c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -867,6 +867,10 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
+	if (!sb_has_quota_loaded(sb, type)) {
+		status = -ESRCH;
+		goto out;
+	}
 	status = ocfs2_lock_global_qf(info, 0);
 	if (status < 0)
 		goto out;
@@ -878,8 +882,11 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
 out_global:
 	ocfs2_unlock_global_qf(info, 0);
 out:
-	/* Avoid logging ENOENT since it just means there isn't next ID */
-	if (status && status != -ENOENT)
+	/*
+	 * Avoid logging ENOENT since it just means there isn't next ID and
+	 * ESRCH which means quota isn't enabled for the filesystem.
+	 */
+	if (status && status != -ENOENT && status != -ESRCH)
 		mlog_errno(status);
 	return status;
 }
-- 
2.6.2

