From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] libext2fs: fix compile errors/warnings
Date: Thu, 29 Jun 2017 21:19:32 -0700
Message-ID: <20170630041932.5424-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
        Li Xi <lixi@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36508 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdF3ETp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jun 2017 00:19:45 -0400
Received: by mail-pg0-f48.google.com with SMTP id u62so57516553pgb.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 21:19:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Defining DEBUG_QUOTA reveals a few compile errors. Fix these.
Also fix format string type mismatches in a couple of log_debug()
calls.

Fixes: 2d2d799c7261 ("Clean up codes for adding new quota type")

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/support/mkquota.c | 4 ++--
 lib/support/quotaio.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 1bb43a71cfac..11a878e7f131 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -50,7 +50,7 @@ static void print_dquot(const char *desc, struct dquot *dq)
 {
 	if (desc)
 		fprintf(stderr, "%s: ", desc);
-	fprintf(stderr, "%u %lld:%lld:%lld %lld:%lld:%lld\n",
+	fprintf(stderr, "%u %ld:%ld:%ld %ld:%ld:%ld\n",
 		dq->dq_id, dq->dq_dqb.dqb_curspace,
 		dq->dq_dqb.dqb_bsoftlimit, dq->dq_dqb.dqb_bhardlimit,
 		dq->dq_dqb.dqb_curinodes,
@@ -523,7 +523,7 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
 		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %u:"
-			"actual (%lld, %lld) != expected (%lld, %lld)\n",
+			"actual (%ld, %ld) != expected (%ld, %ld)\n",
 			dq->dq_id, dq->dq_dqb.dqb_curspace,
 			dq->dq_dqb.dqb_curinodes,
 			dquot->dq_dqb.dqb_curspace,
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index befa832951a2..240eab3d63ea 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -230,9 +230,9 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 		return err;
 
 	if (qf_ino == 0)
-		qf_ino = *quota_sb_inump(fs->super, qtype)
+		qf_ino = *quota_sb_inump(fs->super, qtype);
 
-	log_debug("Opening quota ino=%lu, type=%d", qf_ino, qtype);
+	log_debug("Opening quota ino=%u, type=%d", qf_ino, qtype);
 	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
 	if (err) {
 		log_err("ext2fs_file_open failed: %s", error_message(err));
@@ -366,7 +366,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
 	h->e2fs_write = quota_write_nomount;
 	h->e2fs_read = quota_read_nomount;
 
-	log_debug("Creating quota ino=%lu, type=%d", qf_inum, type);
+	log_debug("Creating quota ino=%u, type=%d", qf_inum, qtype);
 	err = ext2fs_file_open(fs, qf_inum, h->qh_file_flags, &e2_file);
 	if (err) {
 		log_err("ext2fs_file_open failed: %ld", err);
-- 
2.13.2.725.g09c95d1e9-goog
