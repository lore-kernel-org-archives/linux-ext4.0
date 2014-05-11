From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/9] quota: add debugging code to print the dquot structure
Date: Sun, 11 May 2014 00:32:45 -0400
Message-ID: <1399782773-20029-2-git-send-email-tytso@mit.edu>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60794 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbaEKEdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:09 -0400
In-Reply-To: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: adityakali@google.com
---
 lib/quota/common.h  |  1 +
 lib/quota/mkquota.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/quota/common.h b/lib/quota/common.h
index 7d324bf..f1ad79f 100644
--- a/lib/quota/common.h
+++ b/lib/quota/common.h
@@ -13,6 +13,7 @@
 #include <ext2fs/ext2_types.h>
 #endif /* EXT2_FLAT_INCLUDES */
 
+/* #define DEBUG_QUOTA 1 */
 
 #ifndef __attribute__
 # if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8) || __STRICT_ANSI__
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index ba8c2da..3849ae1 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -45,6 +45,21 @@ static void print_inode(struct ext2_inode *inode)
 
 	return;
 }
+
+static void print_dquot(const char *desc, struct dquot *dq)
+{
+	if (desc)
+		fprintf(stderr, "%s: ", desc);
+	fprintf(stderr, "%u %lld:%lld:%lld %lld:%lld:%lld\n",
+		dq->dq_id, dq->dq_dqb.dqb_curspace,
+		dq->dq_dqb.dqb_bsoftlimit, dq->dq_dqb.dqb_bhardlimit,
+		dq->dq_dqb.dqb_curinodes,
+		dq->dq_dqb.dqb_isoftlimit, dq->dq_dqb.dqb_ihardlimit);
+}
+#else
+static void print_dquot(const char *desc, struct dquot *dq)
+{
+}
 #endif
 
 /*
@@ -121,6 +136,7 @@ static void write_dquots(dict_t *dict, struct quota_handle *qh)
 	for (n = dict_first(dict); n; n = dict_next(dict, n)) {
 		dq = dnode_get(n);
 		if (dq) {
+			print_dquot("write", dq);
 			dq->dq_h = qh;
 			update_grace_times(dq);
 			qh->qh_ops->commit_dquot(dq);
@@ -444,6 +460,9 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	dq->dq_id = dquot->dq_id;
 	dq->dq_dqb.u.v2_mdqb.dqb_off = dquot->dq_dqb.u.v2_mdqb.dqb_off;
 
+	print_dquot("mem", dq);
+	print_dquot("dsk", dquot);
+
 	/* Check if there is inconsistancy. */
 	if (dq->dq_dqb.dqb_curspace != dquot->dq_dqb.dqb_curspace ||
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
-- 
1.9.0

