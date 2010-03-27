From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] quota: optimize mark_dirty logic
Date: Sat, 27 Mar 2010 15:15:38 +0300
Message-ID: <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61402 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab0C0MPz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 08:15:55 -0400
In-Reply-To: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- Skipp locking if quota is dirty already.
- Return old quota state to help fs-specciffic implementation to optimize
  case where quota was dirty already.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index e0b870f..88a8ef2 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -319,14 +319,23 @@ static inline int mark_dquot_dirty(struct dquot *dquot)
 	return dquot->dq_sb->dq_op->mark_dirty(dquot);
 }
 
+/* Mark dquot dirty in atomic meaner, and return it's old dirty flag state */
 int dquot_mark_dquot_dirty(struct dquot *dquot)
 {
+	int ret = 1;
+
+	/* If quota is dirtly already we don't have to acquire dq_list_lock */
+	if (test_bit(DQ_MOD_B, &dquot->dq_flags))
+		return 1;
+
 	spin_lock(&dq_list_lock);
-	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags))
+	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags)) {
 		list_add(&dquot->dq_dirty, &sb_dqopt(dquot->dq_sb)->
 				info[dquot->dq_type].dqi_dirty_list);
+		ret = 0;
+	}
 	spin_unlock(&dq_list_lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
-- 
1.6.6.1

