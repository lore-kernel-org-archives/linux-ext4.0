Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D679C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 22:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6796220818
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 22:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tn4WP5CC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfB0WCl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 17:02:41 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37105 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfB0WCk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2019 17:02:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id a48so21215062qtb.4
        for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2019 14:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iOjb6bVbAO9dxNoEMJ70Ddn6Eba9sKOZb5rrW3uqQBE=;
        b=tn4WP5CC5ReMtZh69apIJipuH1Elx+6v9a2HN7IZzk0C2QAQLYxQvaJC0DZ5NuruGJ
         rfQx4Dx6vij56d0daQxrvAk2xj74z6ggG158FI3nKAmbKeJtSOZZjuK+42zodHatJNb7
         Zew8EG/+Z5BuooZo6noZzIhnG+YbqyV9MOAUpbTj+EKmtS4cQMnkpzRTVMyBAjyknI9t
         D3GKVrQBcVfsisDGosxW4D/SHqIthJjDUhjD6/6u9XRU3NgfVuMQaoFtU6VazGsF8Avw
         n3VbttIZlHYoHovOXzLVdOyatyPxekVLgmzuRUlNifDFl/6YPT8UEkznept5a0aU0hC2
         cGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iOjb6bVbAO9dxNoEMJ70Ddn6Eba9sKOZb5rrW3uqQBE=;
        b=q5PCHdbqnhbQEHvadT71QaDuoLiak9nREBG2RVYukWAwYSaKNicTRu9wLH6hr3e+BR
         PVE6hcvdFqrEQnpIeY0OtH4rlZDzv7eGrRVoFRSbo1h7YaHOqMJSBB2BFM5JvFtq+EMy
         3aja2Sh3dHqaAYK6Qatx+qYaoOH9yFevDzwhaMnuw3XwsUGXuGnSvjZGhn7SDySP79zw
         aQ8RtaaF5wvc8EEv7tsx44Z7nBJJZ0C97J4HcPK4TQuwvNwI+1axZVyMMpgddBopJTLf
         1BZglFaQMYx5A3LPT+MffykjrvNDnBbqoM5EFjm680KxmLd5neY0iimG6Bk0FuKr9i6d
         voPg==
X-Gm-Message-State: AHQUAubQYjDumOM8LupyN0u32a4VKTWCTALeT5GgGXSX72zW/hFYQ3rF
        Uja3BlGJ9dTNePSyyRqhBw0DzKH2
X-Google-Smtp-Source: APXvYqw2jT2Qk/NyfuqmeT0Au8PXuqyNeP+5eGC0PCoPB/1Kl9gLVriKnB2EOVqie0I3LGW9DICUuA==
X-Received: by 2002:ac8:96c:: with SMTP id z41mr3557517qth.305.1551304959570;
        Wed, 27 Feb 2019 14:02:39 -0800 (PST)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id j11sm12066923qtk.26.2019.02.27.14.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 14:02:39 -0800 (PST)
From:   Eric Whitney <enwlinux@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix bigalloc cluster freeing when hole punching under load
Date:   Wed, 27 Feb 2019 17:02:04 -0500
Message-Id: <20190227220204.31804-1-enwlinux@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

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
2.11.0

