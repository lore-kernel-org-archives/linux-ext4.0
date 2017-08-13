From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libsupport: fix 32-bit quota test failures
Date: Sun, 13 Aug 2017 15:20:40 -0400
Message-ID: <20170813192040.25875-1-tytso@mit.edu>
References: <20170811212310.GA19995@localhost.localdomain>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38906 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdHMTUp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 13 Aug 2017 15:20:45 -0400
In-Reply-To: <20170811212310.GA19995@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit platform some of the util_dqblk structures have a type of
long long.  So we need to use %lld and casts to make sure the right
thing happens on both 32-bit and 64-bit platforms.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/support/mkquota.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 00f3a406e..931a839dd 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -50,11 +50,13 @@ static void print_dquot(const char *desc, struct dquot *dq)
 {
 	if (desc)
 		fprintf(stderr, "%s: ", desc);
-	fprintf(stderr, "%u %ld:%ld:%ld %ld:%ld:%ld\n",
-		dq->dq_id, dq->dq_dqb.dqb_curspace,
-		dq->dq_dqb.dqb_bsoftlimit, dq->dq_dqb.dqb_bhardlimit,
-		dq->dq_dqb.dqb_curinodes,
-		dq->dq_dqb.dqb_isoftlimit, dq->dq_dqb.dqb_ihardlimit);
+	fprintf(stderr, "%u %lld:%lld:%lld %lld:%lld:%lld\n",
+		dq->dq_id, (long long) dq->dq_dqb.dqb_curspace,
+		(long long) dq->dq_dqb.dqb_bsoftlimit,
+		(long long) dq->dq_dqb.dqb_bhardlimit,
+		(long long) dq->dq_dqb.dqb_curinodes,
+		(long long) dq->dq_dqb.dqb_isoftlimit,
+		(long long) dq->dq_dqb.dqb_ihardlimit);
 }
 #else
 static void print_dquot(const char *desc EXT2FS_ATTR((unused)),
@@ -524,11 +526,11 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
 		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %u:"
-			"actual (%ld, %ld) != expected (%ld, %ld)\n",
-			dq->dq_id, dq->dq_dqb.dqb_curspace,
-			dq->dq_dqb.dqb_curinodes,
-			dquot->dq_dqb.dqb_curspace,
-			dquot->dq_dqb.dqb_curinodes);
+			"actual (%lld, %lld) != expected (%lld, %lld)\n",
+			dq->dq_id, (long long) dq->dq_dqb.dqb_curspace,
+			(long long) dq->dq_dqb.dqb_curinodes,
+			(long long) dquot->dq_dqb.dqb_curspace,
+			(long long) dquot->dq_dqb.dqb_curinodes);
 	}
 
 	if (scan_data->update_limits) {
-- 
2.11.0.rc0.7.gbe5a750
