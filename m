Return-Path: <SRS0=KV+B=X4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BC4C10F14
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Oct 2019 22:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6305220867
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Oct 2019 22:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388143AbfJCWGG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Oct 2019 18:06:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:49694 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbfJCWFz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Oct 2019 18:05:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57B8DB126;
        Thu,  3 Oct 2019 22:05:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1A06C1E4818; Fri,  4 Oct 2019 00:06:14 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 06/22] ext4: Use ext4_journal_extend() instead of jbd2_journal_extend()
Date:   Fri,  4 Oct 2019 00:05:52 +0200
Message-Id: <20191003220613.10791-6-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Use ext4 helper ext4_journal_extend() instead of opencoding it in
ext4_try_to_expand_extra_isize().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e6b631d50c26..042d23a81f44 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5970,8 +5970,7 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	 * If this is felt to be critical, then e2fsck should be run to
 	 * force a large enough s_min_extra_isize.
 	 */
-	if (ext4_handle_valid(handle) &&
-	    jbd2_journal_extend(handle,
+	if (ext4_journal_extend(handle,
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) != 0)
 		return -ENOSPC;
 
-- 
2.16.4

