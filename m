Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FC0C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 811742075C
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714990;
	bh=hVPfTA1SzKeA4IWVriWiwUs1b+vTqgjQ0p9tgEmDNKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pVoaX0cJ9gVAhM1TYHVrFWfnzuAnlbX9679AfFlOrl+sS+nZdzqvFiuD4JljaT1y8
	 ELeSji/5YLHs/jHjTIZygSZsGWOQIJwnzcwcJ5Rqlvn6Tkl2obS5ye23uM44ZM8V2e
	 BEkJ7P91WCUtF+/kwZxPTmaMpNeE+7fAFJ03G/pw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbfC0SDl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732685AbfC0SDk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1630B217F5;
        Wed, 27 Mar 2019 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709819;
        bh=hVPfTA1SzKeA4IWVriWiwUs1b+vTqgjQ0p9tgEmDNKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5PdoVnMAnr2WSmrzu9m73zScjw17+N9mV5DxM18POobAPAa88K6+5lqLU7W1mNlT
         WPHA+l4Jp0XCmSyc/dTElpKNiS/l8wjbOYhZqJF9X93ZjXtkgRZr7iCv4FV7g5Jalw
         G2YB672aZfAH5RYO1pQ6c112/orODmlIpyR3oWhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Whitney <enwlinux@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 058/262] ext4: fix bigalloc cluster freeing when hole punching under load
Date:   Wed, 27 Mar 2019 13:58:33 -0400
Message-Id: <20190327180158.10245-58-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

[ Upstream commit 7bd75230b43727b258a4f7a59d62114cffe1b6c8 ]

Ext4 may not free clusters correctly when punching holes in bigalloc
file systems under high load conditions.  If it's not possible to
extend and restart the journal in ext4_ext_rm_leaf() when preparing to
remove blocks from a punched region, a retry of the entire punch
operation is triggered in ext4_ext_remove_space().  This causes a
partial cluster to be set to the first cluster in the extent found to
the right of the punched region.  However, if the punch operation
prior to the retry had made enough progress to delete one or more
extents and a partial cluster candidate for freeing had already been
recorded, the retry would overwrite the partial cluster.  The loss of
this information makes it impossible to correctly free the original
partial cluster in all cases.

This bug can cause generic/476 to fail when run as part of
xfstests-bld's bigalloc and bigalloc_1k test cases.  The failure is
reported when e2fsck detects bad iblocks counts greater than expected
in units of whole clusters and also detects a number of negative block
bitmap differences equal to the iblocks discrepancy in cluster units.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 240b6dea5441..252bbbb5a2f4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2956,14 +2956,17 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			if (err < 0)
 				goto out;
 
-		} else if (sbi->s_cluster_ratio > 1 && end >= ex_end) {
+		} else if (sbi->s_cluster_ratio > 1 && end >= ex_end &&
+			   partial.state == initial) {
 			/*
-			 * If there's an extent to the right its first cluster
-			 * contains the immediate right boundary of the
-			 * truncated/punched region.  Set partial_cluster to
-			 * its negative value so it won't be freed if shared
-			 * with the current extent.  The end < ee_block case
-			 * is handled in ext4_ext_rm_leaf().
+			 * If we're punching, there's an extent to the right.
+			 * If the partial cluster hasn't been set, set it to
+			 * that extent's first cluster and its state to nofree
+			 * so it won't be freed should it contain blocks to be
+			 * removed. If it's already set (tofree/nofree), we're
+			 * retrying and keep the original partial cluster info
+			 * so a cluster marked tofree as a result of earlier
+			 * extent removal is not lost.
 			 */
 			lblk = ex_end + 1;
 			err = ext4_ext_search_right(inode, path, &lblk, &pblk,
-- 
2.19.1

