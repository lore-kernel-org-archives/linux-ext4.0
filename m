Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80680C43218
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 22:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A17F2084F
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 22:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfDZWJL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 18:09:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54331 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfDZWJL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2019 18:09:11 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hK91o-0001bm-Km; Fri, 26 Apr 2019 22:09:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ext4: fix two cases where a u32 is being checked for a less than zero error return
Date:   Fri, 26 Apr 2019 23:09:08 +0100
Message-Id: <20190426220908.12790-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two cases where u32 variables n and err are being checked
for less than zero error values, the checks is always false because
the variables are not signed. Fix this by making the variables ints.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/block_validity.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 968f163b5feb..8d03550aaae3 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -142,7 +142,8 @@ static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
 	struct inode *inode;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_map_blocks map;
-	u32 i = 0, err = 0, num, n;
+	u32 i = 0, num;
+	int err = 0, n;
 
 	if ((ino < EXT4_ROOT_INO) ||
 	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
-- 
2.20.1

