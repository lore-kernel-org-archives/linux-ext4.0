Return-Path: <SRS0=j5GV=7C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3330FC433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 20 May 2020 13:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B72720748
	for <linux-ext4@archiver.kernel.org>; Wed, 20 May 2020 13:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgETNbX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 May 2020 09:31:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:42310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETNbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 May 2020 09:31:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E87CAD5E;
        Wed, 20 May 2020 13:31:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 309931E126B; Wed, 20 May 2020 15:31:22 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Drop ext4_journal_free_reserved()
Date:   Wed, 20 May 2020 15:31:18 +0200
Message-Id: <20200520133119.1383-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200520133119.1383-1-jack@suse.cz>
References: <20200520133119.1383-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove ext4_journal_free_reserved() function. It is never used.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 4b9002f0e84c..1c926f31d43e 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -335,12 +335,6 @@ static inline handle_t *__ext4_journal_start(struct inode *inode,
 handle_t *__ext4_journal_start_reserved(handle_t *handle, unsigned int line,
 					int type);
 
-static inline void ext4_journal_free_reserved(handle_t *handle)
-{
-	if (ext4_handle_valid(handle))
-		jbd2_journal_free_reserved(handle);
-}
-
 static inline handle_t *ext4_journal_current_handle(void)
 {
 	return journal_current_handle();
-- 
2.16.4

