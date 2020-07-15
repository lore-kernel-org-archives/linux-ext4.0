Return-Path: <SRS0=XcEL=A2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A310AC433EA
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFBB20658
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jul 2020 13:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgGONSa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:18:30 -0400
Received: from [195.135.220.15] ([195.135.220.15]:45950 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1731578AbgGONS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Jul 2020 09:18:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 64577B705;
        Wed, 15 Jul 2020 13:18:30 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E6F1F1E09FC; Wed, 15 Jul 2020 15:18:26 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Wolfgang Frisch <wolfgang.frisch@suse.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Handle error of ext4_setup_system_zone() on remount
Date:   Wed, 15 Jul 2020 15:18:09 +0200
Message-Id: <20200715131812.7243-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200715131812.7243-1-jack@suse.cz>
References: <20200715131812.7243-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

ext4_setup_system_zone() can fail. Handle the failure in ext4_remount().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 330957ed1f05..8e055ec57a2c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5653,7 +5653,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_register_li_request(sb, first_not_zeroed);
 	}
 
-	ext4_setup_system_zone(sb);
+	err = ext4_setup_system_zone(sb);
+	if (err)
+		goto restore_opts;
+
 	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
 		err = ext4_commit_super(sb, 1);
 		if (err)
-- 
2.16.4

