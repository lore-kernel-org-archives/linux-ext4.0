Return-Path: <SRS0=gIIK=3T=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F593C33C9E
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Jan 2020 11:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7BC206D5
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Jan 2020 11:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgA3LL4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 Jan 2020 06:11:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:53178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgA3LL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 30 Jan 2020 06:11:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DB0DB018;
        Thu, 30 Jan 2020 11:11:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AF11A1E0D4F; Thu, 30 Jan 2020 12:11:54 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Simplify checking quota limits in ext4_statfs()
Date:   Thu, 30 Jan 2020 12:11:48 +0100
Message-Id: <20200130111148.10766-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Coverity reports that conditions checking quota limits in ext4_statfs()
contain dead code. Indeed it is right and current conditions can be
simplified.

Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Note, currently this applies to 'dev' branch in ext4.git.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 88b213bd32bc..f23367a779e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5585,10 +5585,7 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	limit = dquot->dq_dqb.dqb_bsoftlimit;
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
@@ -5603,10 +5600,7 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_isoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_isoftlimit;
+	limit = dquot->dq_dqb.dqb_isoftlimit;
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
 		limit = dquot->dq_dqb.dqb_ihardlimit;
-- 
2.16.4

