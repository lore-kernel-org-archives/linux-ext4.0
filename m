From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] e2fsck,libquota: Update quota only if its inconsistent
Date: Fri, 13 Apr 2012 13:11:03 -0700
Message-ID: <1334347864-12662-2-git-send-email-adityakali@google.com>
References: <1334347864-12662-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, niu@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:39966 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2DMULj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 16:11:39 -0400
Received: by wgbdt11 with SMTP id dt11so173634wgb.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 13:11:37 -0700 (PDT)
In-Reply-To: <1334347864-12662-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently fsck recomputes quotas and overwrites quota files
whenever its run. This causes unnecessary modification of
filesystem even when quotas were never inconsistent. We also
lose the limits information because of this. With this patch,
e2fsck compares the computed quotas to the on-disk quotas
(while updating the in-memory limits) and writes out the
quota inode only if it is inconsistent.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/problem.c    |    5 +++
 e2fsck/problem.h    |    3 ++
 e2fsck/unix.c       |   15 ++++++++-
 lib/quota/mkquota.c |   83 ++++++++++++++++++++++++++++++++++++++++++--------
 lib/quota/mkquota.h |    2 +
 5 files changed, 92 insertions(+), 16 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 7293819..6710856 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1691,6 +1691,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Recreate @j"),
 	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
 
+	/* Update quota information if it is inconsistent */
+	{ PR_6_UPDATE_QUOTAS,
+	  N_("Updating quota info for quota type %N "),
+	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
+
 	{ 0 }
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 07df810..1b5815b 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1028,6 +1028,9 @@ struct problem_context {
 /* Recreate the journal if E2F_FLAG_JOURNAL_INODE flag is set */
 #define PR_6_RECREATE_JOURNAL		0x060001
 
+/* Update quota information if it is inconsistent */
+#define PR_6_UPDATE_QUOTAS		0x060002
+
 /*
  * Function declarations
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index fdefe7a..53fcd04 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1137,6 +1137,7 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
+	int qtype;  /* quota type */
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
@@ -1575,7 +1576,6 @@ print_unsupp_features:
 		journal_size = -1;
 
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
-		int qtype;
 		/* Quotas were enabled. Do quota accounting during fsck. */
 		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
 		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
@@ -1619,7 +1619,18 @@ print_unsupp_features:
 no_journal:
 
 	if (ctx->qctx) {
-		quota_write_inode(ctx->qctx, -1);
+		int i, needs_writeout;
+		for (i = 0; i < MAXQUOTAS; i++) {
+			if (qtype != -1 && qtype != i)
+				continue;
+			needs_writeout = 0;
+			pctx.num = i;
+			retval = quota_compare_and_update(ctx->qctx, i,
+							  &needs_writeout);
+			if ((retval || needs_writeout) &&
+			    fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
+				quota_write_inode(ctx->qctx, i);
+		}
 		quota_release_context(&ctx->qctx);
 	}
 
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index fbfde92..13994ad 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -412,29 +412,43 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 }
 
 struct scan_dquots_data {
-	quota_ctx_t         qctx;
-	int                 limit_only; /* read limit only */
+	dict_t		*quota_dict;
+	int             update_limits; /* update limits from disk */
+	int		update_usage;
+	int		usage_is_inconsistent;
 };
 
 static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 {
-	struct scan_dquots_data *scan_data =
-		(struct scan_dquots_data *)cb_data;
-	quota_ctx_t qctx = scan_data->qctx;
+	struct scan_dquots_data *scan_data = cb_data;
+	dict_t *quota_dict = scan_data->quota_dict;
 	struct dquot *dq;
 
-	dq = get_dq(qctx->quota_dict[dquot->dq_h->qh_type], dquot->dq_id);
-
+	dq = get_dq(quota_dict, dquot->dq_id);
 	dq->dq_id = dquot->dq_id;
-	if (scan_data->limit_only) {
-		dq->dq_dqb.u.v2_mdqb.dqb_off = dquot->dq_dqb.u.v2_mdqb.dqb_off;
+
+	/* Check if there is inconsistancy. */
+	if (dq->dq_dqb.dqb_curspace != dquot->dq_dqb.dqb_curspace ||
+	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
+		scan_data->usage_is_inconsistent = 1;
+		log_err("Usage inconsistent for ID %d: (%llu, %llu) != "
+			"(%llu,	%llu)", dq->dq_id, dq->dq_dqb.dqb_curspace,
+			dq->dq_dqb.dqb_curinodes, dquot->dq_dqb.dqb_curspace,
+			dquot->dq_dqb.dqb_curinodes);
+	}
+
+	if (scan_data->update_limits) {
 		dq->dq_dqb.dqb_ihardlimit = dquot->dq_dqb.dqb_ihardlimit;
 		dq->dq_dqb.dqb_isoftlimit = dquot->dq_dqb.dqb_isoftlimit;
 		dq->dq_dqb.dqb_bhardlimit = dquot->dq_dqb.dqb_bhardlimit;
 		dq->dq_dqb.dqb_bsoftlimit = dquot->dq_dqb.dqb_bsoftlimit;
-	} else {
-		dq->dq_dqb = dquot->dq_dqb;
 	}
+
+	if (scan_data->update_usage) {
+		dq->dq_dqb.dqb_curspace = dquot->dq_dqb.dqb_curspace;
+		dq->dq_dqb.dqb_curinodes = dquot->dq_dqb.dqb_curinodes;
+	}
+
 	return 0;
 }
 
@@ -442,12 +456,13 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
  * Read all dquots from quota file into memory
  */
 static errcode_t quota_read_all_dquots(struct quota_handle *qh,
-                                       quota_ctx_t qctx, int limit_only)
+                                       quota_ctx_t qctx, int update_limits)
 {
 	struct scan_dquots_data scan_data;
 
-	scan_data.qctx = qctx;
-	scan_data.limit_only = limit_only;
+	scan_data.quota_dict = qctx->quota_dict[qh->qh_type];
+	scan_data.update_limits = update_limits;
+	scan_data.update_usage = 0;
 
 	return qh->qh_ops->scan_dquots(qh, scan_dquots_callback, &scan_data);
 }
@@ -507,3 +522,43 @@ out:
 	ext2fs_free_mem(&qh);
 	return err;
 }
+
+/*
+ * Compares the measured quota in qctx->quota_dict with that in the quota inode
+ * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
+ * set to 1 if the supplied and on-disk quota usage values are not identical.
+ */
+errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+				   int *usage_inconsistent)
+{
+	ext2_filsys fs = qctx->fs;
+	struct quota_handle qh;
+	struct scan_dquots_data scan_data;
+	ext2_ino_t qf_ino;
+	errcode_t err = 0;
+
+	if (!qctx->quota_dict[qtype])
+		goto out;
+
+	qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
+				     fs->super->s_grp_quota_inum;
+	err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
+	if (err) {
+		log_err("Open quota file failed", "");
+		goto out;
+	}
+
+	scan_data.quota_dict = qctx->quota_dict[qtype];
+	scan_data.update_limits = 1;
+	scan_data.update_usage = 0;
+	scan_data.usage_is_inconsistent = 0;
+	err = qh.qh_ops->scan_dquots(&qh, scan_dquots_callback, &scan_data);
+	if (err) {
+		log_err("Error scanning dquots", "");
+		goto out;
+	}
+	*usage_inconsistent = scan_data.usage_is_inconsistent;
+
+out:
+	return err;
+}
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index a5fa74b..ed6fabd 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -59,5 +59,7 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
 int quota_is_on(ext2_filsys fs, int type);
 int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+				   int *usage_inconsistent);
 
 #endif  /* __QUOTA_QUOTAIO_H__ */
-- 
1.7.7.3

