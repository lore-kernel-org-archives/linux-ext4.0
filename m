From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] debugfs: fix debugfs/quota.c compile warnings
Date: Thu, 22 May 2014 00:38:07 -0600
Message-ID: <1400740687-25441-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:64546 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEVGiK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2014 02:38:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix type mismatch and unused variable warnings.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/quota.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/debugfs/quota.c b/debugfs/quota.c
index 95d064b..5589c1a 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -93,18 +93,19 @@ static int parse_quota_type(const char *cmdname, const char *str)
 static int list_quota_callback(struct dquot *dq, void *cb_data)
 {
 	printf("%8u   %8lld %8lld %8lld    %8lld %8lld %8lld\n",
-	       dq->dq_id, dq->dq_dqb.dqb_curspace,
-	       dq->dq_dqb.dqb_bsoftlimit, dq->dq_dqb.dqb_bhardlimit,
-	       dq->dq_dqb.dqb_curinodes,
-	       dq->dq_dqb.dqb_isoftlimit, dq->dq_dqb.dqb_ihardlimit);
+	       dq->dq_id, (long long)dq->dq_dqb.dqb_curspace,
+	       (long long)dq->dq_dqb.dqb_bsoftlimit,
+	       (long long)dq->dq_dqb.dqb_bhardlimit,
+	       (long long)dq->dq_dqb.dqb_curinodes,
+	       (long long)dq->dq_dqb.dqb_isoftlimit,
+	       (long long)dq->dq_dqb.dqb_ihardlimit);
 	return 0;
 }
 
 void do_list_quota(int argc, char *argv[])
 {
 	errcode_t	retval;
-	int		i, type;
-	int		flags = 0;
+	int		type;
 	struct quota_handle *qh;
 
 	if (load_quota_ctx(argv[0]))
@@ -132,9 +133,7 @@ void do_list_quota(int argc, char *argv[])
 
 void do_get_quota(int argc, char *argv[])
 {
-	errcode_t	retval;
-	int		i, err, type;
-	int		flags = 0;
+	int		err, type;
 	struct quota_handle *qh;
 	struct dquot	*dq;
 	qid_t		id;
@@ -165,7 +164,7 @@ void do_get_quota(int argc, char *argv[])
 	if (dq) {
 		list_quota_callback(dq, NULL);
 		ext2fs_free_mem(&dq);
-	} else
+	} else {
 		com_err(argv[0], 0, "couldn't read quota record");
