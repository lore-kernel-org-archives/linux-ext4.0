Return-Path: <SRS0=+SyN=6R=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1313AC28CBC
	for <linux-ext4@archiver.kernel.org>; Sun,  3 May 2020 20:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1E220643
	for <linux-ext4@archiver.kernel.org>; Sun,  3 May 2020 20:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgECUGw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 May 2020 16:06:52 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:30894 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729005AbgECUGw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 May 2020 16:06:52 -0400
Received: from localhost.localdomain ([93.22.151.175])
        by mwinf5d76 with ME
        id aL6q220023nJVaM03L6qva; Sun, 03 May 2020 22:06:51 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 03 May 2020 22:06:51 +0200
X-ME-IP: 93.22.151.175
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ext4: Fix a typo in a comment
Date:   Sun,  3 May 2020 22:06:47 +0200
Message-Id: <20200503200647.154701-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

s/extnets/extents/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2b577b315a0..779a0687858a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4490,7 +4490,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	inode_lock(inode);
 
 	/*
-	 * Indirect files do not support unwritten extnets
+	 * Indirect files do not support unwritten extents
 	 */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 		ret = -EOPNOTSUPP;
-- 
2.25.1

