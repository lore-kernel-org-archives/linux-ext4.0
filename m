From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/11] quota: Remove dquot_quotactl_ops
Date: Wed, 12 Apr 2017 09:26:11 +0200
Message-ID: <20170412072611.29017-12-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753272AbdDLH0Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Apr 2017 03:26:25 -0400
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nobody uses them anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 12 ------------
 include/linux/quotaops.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7e94cb0ecdde..ebf80c7739e1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2771,18 +2771,6 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
 }
 EXPORT_SYMBOL(dquot_set_dqinfo);
 
-const struct quotactl_ops dquot_quotactl_ops = {
-	.quota_on	= dquot_quota_on,
-	.quota_off	= dquot_quota_off,
-	.quota_sync	= dquot_quota_sync,
-	.get_state	= dquot_get_state,
-	.set_info	= dquot_set_dqinfo,
-	.get_dqblk	= dquot_get_dqblk,
-	.get_nextdqblk	= dquot_get_next_dqblk,
-	.set_dqblk	= dquot_set_dqblk
-};
-EXPORT_SYMBOL(dquot_quotactl_ops);
