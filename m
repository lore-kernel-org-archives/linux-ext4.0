From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: checking for NULL instead of IS_ERR
Date: Wed, 6 Jan 2016 13:04:25 +0300
Message-ID: <20160106100425.GG23185@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbcAFKEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2016 05:04:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The dqget() function returns error pointers on error, it doesn't return
NULL.

Fixes: 76481d7a60a4 ('ext4: add project quota support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 50b2207..103a7a3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4844,8 +4844,8 @@ static int ext4_statfs_project(struct super_block *sb,
 
 	qid = make_kqid_projid(projid);
 	dquot = dqget(sb, qid);
-	if (!dquot)
-		return -ESRCH;
+	if (IS_ERR(dquot))
+		return PTR_ERR(dquot);
 	spin_lock(&dq_data_lock);
 
 	limit = (dquot->dq_dqb.dqb_bsoftlimit ?
