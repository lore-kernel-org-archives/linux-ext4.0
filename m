Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6151C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 16:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A642082F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 16:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfC1QlX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 12:41:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:39350 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbfC1QlW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 12:41:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9475ACB8;
        Thu, 28 Mar 2019 16:41:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 49C581E08FF; Thu, 28 Mar 2019 17:41:21 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Make sanity check in mballoc more strict
Date:   Thu, 28 Mar 2019 17:41:17 +0100
Message-Id: <20190328164117.19148-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Sanity check in mb_find_extent() only checked that returned extent does
not extend past blocksize * 8, however it should not extend past
EXT4_CLUSTERS_PER_GROUP(sb). This can happen when clusters_per_group <
blocksize * 8 and the tail of the bitmap is not properly filled by 1s
which happened e.g. when ancient kernels have grown the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

As a background: We have a customer who has filesystems (created & apparently
resized by 3.0 or older kernels) and which make current kernels eventually barf
with errors but e2fsck says everything is fine.  This patch makes mballoc code
detect issues earlier. I'll send appropriate e2fsck patch shortly.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6fb76d408093..8ef5f12bbee2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1539,7 +1539,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int block,
 		ex->fe_len += 1 << order;
 	}
 
-	if (ex->fe_start + ex->fe_len > (1 << (e4b->bd_blkbits + 3))) {
+	if (ex->fe_start + ex->fe_len > EXT4_CLUSTERS_PER_GROUP(e4b->bd_sb)) {
 		/* Should never happen! (but apparently sometimes does?!?) */
 		WARN_ON(1);
 		ext4_error(e4b->bd_sb, "corruption or bug in mb_find_extent "
-- 
2.16.4

