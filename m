From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: fix type mismatches in quota warning message
Date: Fri, 31 Mar 2017 19:21:59 -0400
Message-ID: <20170331232159.GA12986@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33672 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbdCaXUv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Mar 2017 19:20:51 -0400
Received: by mail-qk0-f196.google.com with SMTP id p22so12346599qka.0
        for <linux-ext4@vger.kernel.org>; Fri, 31 Mar 2017 16:20:51 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The conversion operations in the format control strings found in the
fprintf call used to print the quota warning message do not match the
types of their corresponding arguments.  Although this probably hasn't
generally been a problem, it obfuscates a bigalloc quota accounting bug
where the reported actual quota goes negative.

Clean up the mismatches and some unnecessary casts.  While we're at it,
fix a spelling nit in a related comment.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 lib/support/mkquota.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 8629266..1bb43a7 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -518,16 +518,16 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	print_dquot("mem", dq);
 	print_dquot("dsk", dquot);
 
-	/* Check if there is inconsistancy. */
+	/* Check if there is inconsistency */
 	if (dq->dq_dqb.dqb_curspace != dquot->dq_dqb.dqb_curspace ||
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
-		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %d:"
-			"actual (%llu, %llu) != expected (%llu, %llu)\n",
-			dq->dq_id, (long long)dq->dq_dqb.dqb_curspace,
-			(long long)dq->dq_dqb.dqb_curinodes,
-			(long long)dquot->dq_dqb.dqb_curspace,
-			(long long)dquot->dq_dqb.dqb_curinodes);
+		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %u:"
+			"actual (%lld, %lld) != expected (%lld, %lld)\n",
+			dq->dq_id, dq->dq_dqb.dqb_curspace,
+			dq->dq_dqb.dqb_curinodes,
+			dquot->dq_dqb.dqb_curspace,
+			dquot->dq_dqb.dqb_curinodes);
 	}
 
 	if (scan_data->update_limits) {
-- 
2.1.4
