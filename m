From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/11] xfs: Remove useless test
Date: Tue, 11 Nov 2014 22:04:15 +0100
Message-ID: <1415739865-2438-2-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaKKVEp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2014 16:04:45 -0500
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index b238027df987..9ad73240ed54 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -77,7 +77,7 @@ xfs_fs_set_xstate(
 
 	if (sb->s_flags & MS_RDONLY)
 		return -EROFS;
-	if (op != Q_XQUOTARM && !XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
 
 	if (uflags & FS_QUOTA_UDQ_ACCT)
-- 
1.8.1.4

