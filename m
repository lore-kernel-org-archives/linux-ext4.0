Return-Path: <SRS0=cEPW=US=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEFAC31E49
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Jun 2019 09:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD4F520B1F
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Jun 2019 09:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbfFSJAL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 19 Jun 2019 05:00:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47495 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbfFSJAK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jun 2019 05:00:10 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hdWRr-0007xa-98; Wed, 19 Jun 2019 09:00:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: remove redundant assignment to node
Date:   Wed, 19 Jun 2019 10:00:06 +0100
Message-Id: <20190619090007.26962-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer 'node' is assigned a value that is never read, node is
later overwritten when it re-assigned a different value inside
the while-loop.  The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/extents_status.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 023a3eb3afa3..7521de2dcf3a 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1317,7 +1317,6 @@ static int es_do_reclaim_extents(struct ext4_inode_info *ei, ext4_lblk_t end,
 	es = __es_tree_search(&tree->root, ei->i_es_shrink_lblk);
 	if (!es)
 		goto out_wrap;
-	node = &es->rb_node;
 	while (*nr_to_scan > 0) {
 		if (es->es_lblk > end) {
 			ei->i_es_shrink_lblk = end + 1;
-- 
2.20.1

