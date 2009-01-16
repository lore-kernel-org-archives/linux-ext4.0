From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/11] ocfs2: Fix possible deadlock in ocfs2_write_dquot()
Date: Fri, 16 Jan 2009 19:08:12 +0100
Message-ID: <1232129299-22018-5-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
 <1232129299-22018-4-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47978 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761813AbZAPSIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:22 -0500
In-Reply-To: <1232129299-22018-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It could happen that some limit has been set via quotactl() and in parallel
->mark_dirty() is called from another thread doing e.g. dquot_alloc_space(). In
such case ocfs2_write_dquot() must not try to sync the dquot because that needs
global quota lock but that ranks above transaction start.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/quota_global.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index f4efa89..1ed0f7c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -754,7 +754,9 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	if (dquot->dq_flags & mask)
 		sync = 1;
 	spin_unlock(&dq_data_lock);
-	if (!sync) {
+	/* This is a slight hack but we can't afford getting global quota
+	 * lock if we already have a transaction started. */
+	if (!sync || journal_current_handle()) {
 		status = ocfs2_write_dquot(dquot);
 		goto out;
 	}
-- 
1.6.0.2

