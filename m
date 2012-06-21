From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/5] XFS: prjquota and grpqouta now may coexist
Date: Thu, 21 Jun 2012 13:08:53 +0400
Message-ID: <1340269733-25922-6-git-send-email-dmonakhov@openvz.org>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46938 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab2FUJJM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 05:09:12 -0400
In-Reply-To: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/xfs/xfs_super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..f408a27 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -538,14 +538,14 @@ xfs_showargs(
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
 		seq_puts(m, "," MNTOPT_UQUOTANOENF);
 
-	/* Either project or group quotas can be active, not both */
