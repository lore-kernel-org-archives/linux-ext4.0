From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/9] quota: fix e2fsck so we update the quota file correctly
Date: Sun, 11 May 2014 00:32:46 -0400
Message-ID: <1399782773-20029-3-git-send-email-tytso@mit.edu>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60799 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbaEKEdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:09 -0400
In-Reply-To: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In scan_dquota_callback() we were copying dqb_off from the on-disk
dquot structure to the dqot structure that we have constructed in
memory.  This is a bad idea, because if we detect that the quota inode
is corrupted and needs to be replaced, when we later write out the
inode, the fact that we have a non-zero dqb_off value means that quota
routines will not bother updating the quota tree index, since
presumably the quota tree index already has an entry for this dqot.

The problem is that e2fsck, the only user of these functions, has
zapped the quota inode so it can be written from scratch.  So this
means the index for the quota records are not written out, so the
kernel can not find any of the records in the quota inodes.  Oops.

The fix is simple; there is no reason to copy the dqb_off field into
the quota_dict copy of struct dquot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: adityakali@google.com
---
 lib/quota/mkquota.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 3849ae1..f77e072 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -458,7 +458,6 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 
 	dq = get_dq(quota_dict, dquot->dq_id);
 	dq->dq_id = dquot->dq_id;
-	dq->dq_dqb.u.v2_mdqb.dqb_off = dquot->dq_dqb.u.v2_mdqb.dqb_off;
 
 	print_dquot("mem", dq);
 	print_dquot("dsk", dquot);
-- 
1.9.0

